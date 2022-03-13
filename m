Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 626334D7436
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 11:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbiCMKYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 06:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiCMKYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 06:24:19 -0400
X-Greylist: delayed 347 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 13 Mar 2022 03:23:10 PDT
Received: from eidolon.nox.tf (eidolon.nox.tf [IPv6:2a07:2ec0:2185::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938FD17A91
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 03:23:10 -0700 (PDT)
Received: from [178.197.200.96] (helo=areia)
        by eidolon.nox.tf with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <equinox@diac24.net>)
        id 1nTLHq-003JVp-Nj; Sun, 13 Mar 2022 11:17:19 +0100
Received: from equinox by areia with local (Exim 4.95)
        (envelope-from <equinox@diac24.net>)
        id 1nTL1o-001aBK-K1;
        Sun, 13 Mar 2022 11:00:44 +0100
From:   David Lamparter <equinox@diac24.net>
To:     netdev@vger.kernel.org
Cc:     David Lamparter <equinox@diac24.net>
Subject: [PATCH net-next 1/2] net: add synchronize_net_expedited()
Date:   Sun, 13 Mar 2022 11:00:32 +0100
Message-Id: <20220313100033.343442-2-equinox@diac24.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220313100033.343442-1-equinox@diac24.net>
References: <20220313100033.343442-1-equinox@diac24.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The AF_PACKET code has a bunch of calls to synchronize_net() while in a
syscall from userland.  These become very visible in some applications
(e.g. just plain starting wireshark when the system has a lot of
interfaces.)

Add a "synchronize_net_expedited()" for cases like these.

Signed-off-by: David Lamparter <equinox@diac24.net>
---
 include/linux/netdevice.h |  2 ++
 net/core/dev.c            | 13 +++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 0d994710b335..fcc8cfe5e4d8 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -74,6 +74,8 @@ struct bpf_prog;
 struct xdp_buff;
 
 void synchronize_net(void);
+void synchronize_net_expedited(void);
+
 void netdev_set_default_ethtool_ops(struct net_device *dev,
 				    const struct ethtool_ops *ops);
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 8d25ec5b3af7..d53c171040c6 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10633,6 +10633,19 @@ void synchronize_net(void)
 }
 EXPORT_SYMBOL(synchronize_net);
 
+/**
+ *	synchronize_net_expedited - synchronize_net, but always expedited
+ *
+ *	Some callers may have reasons other than "RTNL held" to want expedited
+ *	RCU sync.  A prominent example is if the RCU delay is user visible.
+ */
+void synchronize_net_expedited(void)
+{
+	might_sleep();
+	synchronize_rcu_expedited();
+}
+EXPORT_SYMBOL(synchronize_net_expedited);
+
 /**
  *	unregister_netdevice_queue - remove device from the kernel
  *	@dev: device
-- 
2.35.1

