Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 788B83C69CD
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 07:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbhGMFnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 01:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbhGMFnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 01:43:24 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22D8C0613DD;
        Mon, 12 Jul 2021 22:40:34 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id h4so20626699pgp.5;
        Mon, 12 Jul 2021 22:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nCoykUfAeCmm7EweIlj2EVckVQsnC0tULaDKLSufM14=;
        b=IQcarGJNgxbM+9PEbA2hjgnAzguOJ6Fl8BtlwbD+QiGIWR2QMTzdNYqfV8/O5RePMu
         jc+dxLQtSRSvJd5BvPgOvvLJ5OeW0woWRuZQVOXF5jGWBxWJsiXTQcKd+XRV+mHg8sqx
         +w4nFQh3mtoYFNWwMqwL8aDxwxO4NBFoHE6iVr0d9Lwm7Ec2Q2hRYnlojrMdxLu9ICzW
         s8ZMU++QeEBFGBOF2ZFYYlhO8fjIHEh3A8gHxCjvIPXDq2/yN6wwBKOfr/SJGk4gR6Uy
         p38QX2Gm7WcgYXi5HiI76B0oFzTiPA+hGlMBBmhSccKY5AEKuaI5ZTtidS9bx/RVvo9U
         BW/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nCoykUfAeCmm7EweIlj2EVckVQsnC0tULaDKLSufM14=;
        b=Cw03a2WLrpqM6m+bEDPC1IFezzTr1a7sc4RthRIIqxB1G2RRmhuSBjKTKtdrRXIoza
         zxQCuED1luUn4oeEGHAbGEc62/ZjkbL8VQ1SykEfpdn3NmL1BAx0/IJtfaFKLZ85QPBQ
         ULwDO6lCgK7FFY0mlURc+mO7i7ywSC5XWd7/RzC44DWTUM8JQN8JTKRWBDcMrLe/1lp3
         DTRII50GK6x2lbHDAOPk6j07CViCIMnfEtst5c2q4SFnJtCt1wHKkPL6sAf/lhVJpQTN
         FpIFBpXIVbhAfDH9Mc9U3oPXKmbc2ivZ8g2g9z1xqBysY12ealUlA3neDqAqP3Ie04k/
         6GeA==
X-Gm-Message-State: AOAM530cjOuxCeajUDdNiehurLAum6K2PoOALOlBCelU2p4gcHZ0y3Xb
        XMJ2cQw8KRYh49qs9dsZkS4=
X-Google-Smtp-Source: ABdhPJwavFVmwmu61Q4RhV1CUjL6kBCllpAgmQF59n/2dp1wTEUND5wCoYi7BpbOIEhOSkWuQCDw9w==
X-Received: by 2002:a62:cd47:0:b029:329:714e:cce2 with SMTP id o68-20020a62cd470000b0290329714ecce2mr2925551pfg.22.1626154834013;
        Mon, 12 Jul 2021 22:40:34 -0700 (PDT)
Received: from localhost.localdomain ([154.16.166.164])
        by smtp.gmail.com with ESMTPSA id q14sm9232593pff.209.2021.07.12.22.40.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 22:40:33 -0700 (PDT)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        Alexander Aring <aring@mojatatu.com>,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ieee802154: hwsim: fix memory leak in __pskb_copy_fclone
Date:   Tue, 13 Jul 2021 13:40:18 +0800
Message-Id: <20210713054019.409273-1-mudongliangabcd@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hwsim_hw_xmit fails to deallocate the newskb copied by pskb_copy. Fix
this by adding kfree_skb after ieee802154_rx_irqsafe.

  [<ffffffff836433fb>] __alloc_skb+0x22b/0x250 net/core/skbuff.c:414
  [<ffffffff8364ad95>] __pskb_copy_fclone+0x75/0x360 net/core/skbuff.c:1609
  [<ffffffff82ae65e3>] __pskb_copy include/linux/skbuff.h:1176 [inline]
  [<ffffffff82ae65e3>] pskb_copy include/linux/skbuff.h:3207 [inline]
  [<ffffffff82ae65e3>] hwsim_hw_xmit+0xd3/0x140 drivers/net/ieee802154/mac802154_hwsim.c:132
  [<ffffffff83ff8f47>] drv_xmit_async net/mac802154/driver-ops.h:16 [inline]
  [<ffffffff83ff8f47>] ieee802154_tx+0xc7/0x190 net/mac802154/tx.c:83
  [<ffffffff83ff9138>] ieee802154_subif_start_xmit+0x58/0x70 net/mac802154/tx.c:132
  [<ffffffff83670b82>] __netdev_start_xmit include/linux/netdevice.h:4944 [inline]
  [<ffffffff83670b82>] netdev_start_xmit include/linux/netdevice.h:4958 [inline]
  [<ffffffff83670b82>] xmit_one net/core/dev.c:3658 [inline]
  [<ffffffff83670b82>] dev_hard_start_xmit+0xe2/0x330 net/core/dev.c:3674
  [<ffffffff83718028>] sch_direct_xmit+0xf8/0x520 net/sched/sch_generic.c:342
  [<ffffffff8367193b>] __dev_xmit_skb net/core/dev.c:3874 [inline]
  [<ffffffff8367193b>] __dev_queue_xmit+0xa3b/0x1360 net/core/dev.c:4241
  [<ffffffff83ff5437>] dgram_sendmsg+0x437/0x570 net/ieee802154/socket.c:682
  [<ffffffff836345b6>] sock_sendmsg_nosec net/socket.c:702 [inline]
  [<ffffffff836345b6>] sock_sendmsg+0x56/0x80 net/socket.c:722

Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
 drivers/net/ieee802154/mac802154_hwsim.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index ebc976b7fcc2..d97ed033ac77 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -132,9 +132,11 @@ static int hwsim_hw_xmit(struct ieee802154_hw *hw, struct sk_buff *skb)
 			struct sk_buff *newskb = pskb_copy(skb, GFP_ATOMIC);
 
 			einfo = rcu_dereference(e->info);
-			if (newskb)
+			if (newskb) {
 				ieee802154_rx_irqsafe(e->endpoint->hw, newskb,
 						      einfo->lqi);
+				kfree_skb(newskb);
+			}
 		}
 	}
 	rcu_read_unlock();
-- 
2.25.1

