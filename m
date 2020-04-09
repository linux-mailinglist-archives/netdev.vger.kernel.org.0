Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FAF71A3564
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 16:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbgDIOIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 10:08:50 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34896 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726552AbgDIOIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 10:08:50 -0400
Received: by mail-pf1-f194.google.com with SMTP id a13so4174143pfa.2
        for <netdev@vger.kernel.org>; Thu, 09 Apr 2020 07:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=yqVrqlh6zqx7i2FTwwlbxuYwYGAOZHaZv+4AEelWcW4=;
        b=LwSHgC7SidlcoL1QbG4f9ed6mxY8rvYzPlwXMJgG1Jw2pcFn0i0XkCrVtpOouiBZnc
         bEQvJReR2YFQFWm+hq3HDXIcoSUz+3nBFtVB3KYBWLi2DjrlwZXIxQBQpOjOz9Z+9/jc
         IbkCtpbnSNVVbAur4NpeUEOou1TvtwkfgAMqfgcMkNfCxLukY/XMvXueGoMDEKmKxj8h
         QUOsN9Qb8C/2Rtm9j04lG8bYm9qn95tRabINF5YpLFcK3/+0ju5cpR7vcxbC7Tyvx9H1
         7DmfojvNazK9ExZfrFG4dtyVWJqtlC2FvhKQfr8BwzQLPfRrxU0qqV7MzbHVCP3/hfCb
         reEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yqVrqlh6zqx7i2FTwwlbxuYwYGAOZHaZv+4AEelWcW4=;
        b=VewsEZ3rDhcT+mGmSOD4f1rw2j1NRsDyMm47VEMcU1rz52Jo3U2HWI0ki7AXoMu6WT
         PELMwzXRphfyQIzW2Ir4XqnbK+gYGu7ym2NVzpaJ8ePQeZa2PM9c3FDPztMq5wp5mEUa
         ummeHN/PbpmSGMsxsjafcD4fxIsaHe0jq7tTR27qfqdwoTJ3O/WMO/vUeLyTKyPOs+Xn
         iALHLuKx69Qjg2YoheJ+zwCtNCjmfB90LvW4cTU92u1Nn9gDn74Jfly40m/7nbCqpnr5
         AF1rhMNcep9nF8dVq5powRSEAPmKngOB+nsnvciuQUO1hEMcwJeBniQWRNZJX/Vtqxh8
         uAxA==
X-Gm-Message-State: AGi0PuZ7X1Gk3wVwPMTGPYFq+rI+NIcbVXglkxGZw+DZZGPCFhk0AEff
        uFW90XoDr6h/u1d9eEiort5EZTkmVmI=
X-Google-Smtp-Source: APiQypJx5PMlF4+5hudU3pGSdGl7q8rY2pPhxr+f2zP93VVqsk5P0AGpfmN8aRT42kpKV3q98l9TBQ==
X-Received: by 2002:a65:49c7:: with SMTP id t7mr3834878pgs.286.1586441328837;
        Thu, 09 Apr 2020 07:08:48 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id d21sm19390338pfo.49.2020.04.09.07.08.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 07:08:47 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, antoine.tenart@bootlin.com
Subject: [PATCH net] net: macsec: fix using wrong structure in macsec_changelink()
Date:   Thu,  9 Apr 2020 14:08:08 +0000
Message-Id: <20200409140808.29172-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the macsec_changelink(), "struct macsec_tx_sa tx_sc" is used to
store "macsec_secy.tx_sc".
But, the struct type of tx_sc is macsec_tx_sc, not macsec_tx_sa.
So, the macsec_tx_sc should be used instead.

Test commands:
    ip link add dummy0 type dummy
    ip link add macsec0 link dummy0 type macsec
    ip link set macsec0 type macsec encrypt off

Splat looks like:
[61119.963483][ T9335] ==================================================================
[61119.964709][ T9335] BUG: KASAN: slab-out-of-bounds in macsec_changelink.part.34+0xb6/0x200 [macsec]
[61119.965787][ T9335] Read of size 160 at addr ffff888020d69c68 by task ip/9335
[61119.966699][ T9335]
[61119.966979][ T9335] CPU: 0 PID: 9335 Comm: ip Not tainted 5.6.0+ #503
[61119.967791][ T9335] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[61119.968914][ T9335] Call Trace:
[61119.969324][ T9335]  dump_stack+0x96/0xdb
[61119.969809][ T9335]  ? macsec_changelink.part.34+0xb6/0x200 [macsec]
[61119.970554][ T9335]  print_address_description.constprop.5+0x1be/0x360
[61119.971294][ T9335]  ? macsec_changelink.part.34+0xb6/0x200 [macsec]
[61119.971973][ T9335]  ? macsec_changelink.part.34+0xb6/0x200 [macsec]
[61119.972703][ T9335]  __kasan_report+0x12a/0x170
[61119.973323][ T9335]  ? macsec_changelink.part.34+0xb6/0x200 [macsec]
[61119.973942][ T9335]  kasan_report+0xe/0x20
[61119.974397][ T9335]  check_memory_region+0x149/0x1a0
[61119.974866][ T9335]  memcpy+0x1f/0x50
[61119.975209][ T9335]  macsec_changelink.part.34+0xb6/0x200 [macsec]
[61119.975825][ T9335]  ? macsec_get_stats64+0x3e0/0x3e0 [macsec]
[61119.976451][ T9335]  ? kernel_text_address+0x111/0x120
[61119.976990][ T9335]  ? pskb_expand_head+0x25f/0xe10
[61119.977503][ T9335]  ? stack_trace_save+0x82/0xb0
[61119.977986][ T9335]  ? memset+0x1f/0x40
[61119.978397][ T9335]  ? __nla_validate_parse+0x98/0x1ab0
[61119.978936][ T9335]  ? macsec_alloc_tfm+0x90/0x90 [macsec]
[61119.979511][ T9335]  ? __kasan_slab_free+0x111/0x150
[61119.980021][ T9335]  ? kfree+0xce/0x2f0
[61119.980700][ T9335]  ? netlink_trim+0x196/0x1f0
[61119.981420][ T9335]  ? nla_memcpy+0x90/0x90
[61119.982036][ T9335]  ? register_lock_class+0x19e0/0x19e0
[61119.982776][ T9335]  ? memcpy+0x34/0x50
[61119.983327][ T9335]  __rtnl_newlink+0x922/0x1270
[ ... ]

Fixes: 3cf3227a21d1 ("net: macsec: hardware offloading infrastructure")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/macsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 0d580d81d910..a183250ff66a 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3809,7 +3809,7 @@ static int macsec_changelink(struct net_device *dev, struct nlattr *tb[],
 			     struct netlink_ext_ack *extack)
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
-	struct macsec_tx_sa tx_sc;
+	struct macsec_tx_sc tx_sc;
 	struct macsec_secy secy;
 	int ret;
 
-- 
2.17.1

