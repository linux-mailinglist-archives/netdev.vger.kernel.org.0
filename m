Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 513B043DB02
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 08:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbhJ1GVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 02:21:14 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:42808 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbhJ1GVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 02:21:13 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 626772028B; Thu, 28 Oct 2021 14:18:45 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Andrew Jeffery <andrew@aj.id.au>
Subject: [PATCH net-next 2/3] mctp: Add flow extension to skb
Date:   Thu, 28 Oct 2021 14:18:32 +0800
Message-Id: <20211028061833.2390354-2-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211028061833.2390354-1-jk@codeconstruct.com.au>
References: <20211028061833.2390354-1-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds a new skb extension for MCTP, to represent a
request/response flow.

The intention is to use this in a later change to allow i2c controllers
to correctly configure a multiplexer over a flow.

Since we have a cleanup function in the core path (if an extension is
present), we'll need to make CONFIG_MCTP a bool, rather than a tristate.

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 include/linux/skbuff.h |  3 +++
 include/net/mctp.h     |  7 +++++++
 net/core/skbuff.c      | 19 +++++++++++++++++++
 net/mctp/Kconfig       |  6 +++++-
 4 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index cb96f1e6460c..0bd6520329f6 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4243,6 +4243,9 @@ enum skb_ext_id {
 #endif
 #if IS_ENABLED(CONFIG_MPTCP)
 	SKB_EXT_MPTCP,
+#endif
+#if IS_ENABLED(CONFIG_MCTP_FLOWS)
+	SKB_EXT_MCTP,
 #endif
 	SKB_EXT_NUM, /* must be last */
 };
diff --git a/include/net/mctp.h b/include/net/mctp.h
index 23bec708f4c7..7a5ba801703c 100644
--- a/include/net/mctp.h
+++ b/include/net/mctp.h
@@ -189,6 +189,13 @@ static inline struct mctp_skb_cb *mctp_cb(struct sk_buff *skb)
 	return (void *)(skb->cb);
 }
 
+/* If CONFIG_MCTP_FLOWS, we may add one of these as a SKB extension,
+ * indicating the flow to the device driver.
+ */
+struct mctp_flow {
+	struct mctp_sk_key *key;
+};
+
 /* Route definition.
  *
  * These are held in the pernet->mctp.routes list, with RCU protection for
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 74601bbc56ac..2505e1845f57 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -70,6 +70,7 @@
 #include <net/xfrm.h>
 #include <net/mpls.h>
 #include <net/mptcp.h>
+#include <net/mctp.h>
 #include <net/page_pool.h>
 
 #include <linux/uaccess.h>
@@ -4430,6 +4431,9 @@ static const u8 skb_ext_type_len[] = {
 #if IS_ENABLED(CONFIG_MPTCP)
 	[SKB_EXT_MPTCP] = SKB_EXT_CHUNKSIZEOF(struct mptcp_ext),
 #endif
+#if IS_ENABLED(CONFIG_MCTP)
+	[SKB_EXT_MCTP] = SKB_EXT_CHUNKSIZEOF(struct mctp_flow),
+#endif
 };
 
 static __always_inline unsigned int skb_ext_total_length(void)
@@ -4446,6 +4450,9 @@ static __always_inline unsigned int skb_ext_total_length(void)
 #endif
 #if IS_ENABLED(CONFIG_MPTCP)
 		skb_ext_type_len[SKB_EXT_MPTCP] +
+#endif
+#if IS_ENABLED(CONFIG_MCTP)
+		skb_ext_type_len[SKB_EXT_MCTP] +
 #endif
 		0;
 }
@@ -6519,6 +6526,14 @@ static void skb_ext_put_sp(struct sec_path *sp)
 }
 #endif
 
+#ifdef CONFIG_MCTP_FLOWS
+static void skb_ext_put_mctp(struct mctp_flow *flow)
+{
+	if (flow->key)
+		mctp_key_unref(flow->key);
+}
+#endif
+
 void __skb_ext_del(struct sk_buff *skb, enum skb_ext_id id)
 {
 	struct skb_ext *ext = skb->extensions;
@@ -6554,6 +6569,10 @@ void __skb_ext_put(struct skb_ext *ext)
 	if (__skb_ext_exist(ext, SKB_EXT_SEC_PATH))
 		skb_ext_put_sp(skb_ext_get_ptr(ext, SKB_EXT_SEC_PATH));
 #endif
+#if CONFIG_MCTP_FLOWS
+	if (__skb_ext_exist(ext, SKB_EXT_MCTP))
+		skb_ext_put_mctp(skb_ext_get_ptr(ext, SKB_EXT_MCTP));
+#endif
 
 	kmem_cache_free(skbuff_ext_cache, ext);
 }
diff --git a/net/mctp/Kconfig b/net/mctp/Kconfig
index 868c92272cbd..de739f49c40c 100644
--- a/net/mctp/Kconfig
+++ b/net/mctp/Kconfig
@@ -1,7 +1,7 @@
 
 menuconfig MCTP
 	depends on NET
-	tristate "MCTP core protocol support"
+	bool "MCTP core protocol support"
 	help
 	  Management Component Transport Protocol (MCTP) is an in-system
 	  protocol for communicating between management controllers and
@@ -16,3 +16,7 @@ config MCTP_TEST
         bool "MCTP core tests" if !KUNIT_ALL_TESTS
         depends on MCTP=y && KUNIT=y
         default KUNIT_ALL_TESTS
+
+config MCTP_FLOWS
+	bool
+	select SKB_EXTENSIONS
-- 
2.30.2

