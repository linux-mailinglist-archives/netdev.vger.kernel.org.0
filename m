Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31F16622648
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 10:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbiKIJIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 04:08:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbiKIJIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 04:08:22 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93BF2251F;
        Wed,  9 Nov 2022 01:07:52 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id y203so16131383pfb.4;
        Wed, 09 Nov 2022 01:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ATZUQ+Nx2kluoQOYVdU2Cj3EMJ55/EmnBRWtaD0eIds=;
        b=oEA1fT3iQwLXmfxIEDBSRKwG9XhxYfarc819wSUKkHKySyY3x5pnOnWZV7QAQIp93q
         nd5KE/pUjsfz8Gm8XvgMVVeQgqrKdreF8QfYJ8ebsGgYKr/byczX4OwPGVlOnFThCfd8
         z3TeXpeqh2oc1XbSYcbd3nDBlGzeCc16uxOJ97iYQ2ft4HJiTa4J5+NxfjtUVfJKQUCj
         RSCqtiFxFpuJ4DdPM0KKtqPx8vJc03zqWHMdUUoSeWF8WtS0wi+r93CTfqS58Iw2r2ee
         yS+MOxgcuSJ5eS6mnr/iKbFw/Mo+h/IXo6OFMVJuobdp30m72opzIvI1YVT2gfo9FY2c
         z8+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ATZUQ+Nx2kluoQOYVdU2Cj3EMJ55/EmnBRWtaD0eIds=;
        b=4K+TvIYjk1fVL/9kiQfDO1xZ2I1UPy7FP6nxXf7vblWXiJdzJbNs+dI6LxZsvXo1UT
         3tIeI5Lhf3A5j8pXu3qDprO1t5fbTlxOoBsr4ujKeTatKQEIH+uQAfWS+GsYhnqR73O6
         FCot7uSGXwP9SRn3DQCxzq65pyzb/l6SdK+zWwQHT8C1+M9ck8VZ+JLFaLXMfirOhP4u
         CNWvzQV8BIpwPUb/FP2+j5g3aZ2Cwz2q48Akfe2sUpGUOPolAam1ogFhoGCR58u3MQgH
         x840XqU18bgGunThft4TVZvqHw17mnmnyAdy6/esnSkyqLZNzkHHrZcnUjWWPP9IiYXV
         CC1w==
X-Gm-Message-State: ACrzQf1bAylXs6zJWOgnwPDO7Cg+sTrTNX8h4vO+w3Gz4LXEDOzTUcK9
        zQB6PX4uV5T2pS6mQLqQx3w=
X-Google-Smtp-Source: AMsMyM7X3Eq72gWqFhqbSs6hrweLvv4GZjnrrJGm1fJ3b2ymPnhRUhn8GvDURG6wI04/Uxem2ywRpg==
X-Received: by 2002:a63:8a42:0:b0:46f:5804:8d9e with SMTP id y63-20020a638a42000000b0046f58048d9emr51838333pgd.214.1667984872117;
        Wed, 09 Nov 2022 01:07:52 -0800 (PST)
Received: from localhost.localdomain ([47.242.114.172])
        by smtp.gmail.com with ESMTPSA id i9-20020a17090332c900b0017a09ebd1e2sm8578304plr.237.2022.11.09.01.07.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 01:07:51 -0800 (PST)
From:   Chuang Wang <nashuiliang@gmail.com>
Cc:     Chuang Wang <nashuiliang@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Gao Feng <fgao@ikuai8.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: macvlan: fix memory leaks of macvlan_common_newlink
Date:   Wed,  9 Nov 2022 17:07:34 +0800
Message-Id: <20221109090735.690500-1-nashuiliang@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kmemleak reports memory leaks in macvlan_common_newlink, as follows:

 ip link add link eth0 name .. type macvlan mode source macaddr add
 <MAC-ADDR>

kmemleak reports:

unreferenced object 0xffff8880109bb140 (size 64):
  comm "ip", pid 284, jiffies 4294986150 (age 430.108s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 b8 aa 5a 12 80 88 ff ff  ..........Z.....
    80 1b fa 0d 80 88 ff ff 1e ff ac af c7 c1 6b 6b  ..............kk
  backtrace:
    [<ffffffff813e06a7>] kmem_cache_alloc_trace+0x1c7/0x300
    [<ffffffff81b66025>] macvlan_hash_add_source+0x45/0xc0
    [<ffffffff81b66a67>] macvlan_changelink_sources+0xd7/0x170
    [<ffffffff81b6775c>] macvlan_common_newlink+0x38c/0x5a0
    [<ffffffff81b6797e>] macvlan_newlink+0xe/0x20
    [<ffffffff81d97f8f>] __rtnl_newlink+0x7af/0xa50
    [<ffffffff81d98278>] rtnl_newlink+0x48/0x70
    ...

In the scenario where the macvlan mode is configured as 'source',
macvlan_changelink_sources() will be execured to reconfigure list of
remote source mac addresses, at the same time, if register_netdevice()
return an error, the resource generated by macvlan_changelink_sources()
is not cleaned up.

Using this patch, in the case of an error, it will execute
macvlan_flush_sources() to ensure that the resource is cleaned up.

Fixes: aa5fd0fb7748 ("driver: macvlan: Destroy new macvlan port if macvlan_common_newlink failed.")
Signed-off-by: Chuang Wang <nashuiliang@gmail.com>
---
 drivers/net/macvlan.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index c58fea63be7d..28f9f917ff54 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1533,8 +1533,10 @@ int macvlan_common_newlink(struct net *src_net, struct net_device *dev,
 	/* the macvlan port may be freed by macvlan_uninit when fail to register.
 	 * so we destroy the macvlan port only when it's valid.
 	 */
-	if (create && macvlan_port_get_rtnl(lowerdev))
+	if (create && macvlan_port_get_rtnl(lowerdev)) {
+		macvlan_flush_sources(port, vlan);
 		macvlan_port_destroy(port->dev);
+	}
 	return err;
 }
 EXPORT_SYMBOL_GPL(macvlan_common_newlink);
-- 
2.37.2

