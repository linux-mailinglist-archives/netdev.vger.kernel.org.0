Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D68B4959B
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728981AbfFQW7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:59:36 -0400
Received: from mga18.intel.com ([134.134.136.126]:10998 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728455AbfFQW6w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 18:58:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 15:58:50 -0700
X-ExtLoop1: 1
Received: from mjmartin-nuc01.amr.corp.intel.com (HELO mjmartin-nuc01.sea.intel.com) ([10.241.98.42])
  by orsmga002.jf.intel.com with ESMTP; 17 Jun 2019 15:58:50 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     edumazet@google.com, netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        cpaasch@apple.com, fw@strlen.de, pabeni@redhat.com,
        peter.krystad@linux.intel.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH net-next 15/33] mptcp: Add MPTCP to skb extensions
Date:   Mon, 17 Jun 2019 15:57:50 -0700
Message-Id: <20190617225808.665-16-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617225808.665-1-mathew.j.martineau@linux.intel.com>
References: <20190617225808.665-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add enum value for MPTCP and update config dependencies

Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/linux/skbuff.h |  3 +++
 include/net/mptcp.h    | 16 ++++++++++++++++
 net/core/skbuff.c      |  7 +++++++
 net/mptcp/Kconfig      |  1 +
 4 files changed, 27 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 37387ab9f336..5de91656f8ea 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3993,6 +3993,9 @@ enum skb_ext_id {
 #endif
 #ifdef CONFIG_XFRM
 	SKB_EXT_SEC_PATH,
+#endif
+#if IS_ENABLED(CONFIG_MPTCP)
+	SKB_EXT_MPTCP,
 #endif
 	SKB_EXT_NUM, /* must be last */
 };
diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index e7cae0f4404a..805206359135 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -8,6 +8,22 @@
 #ifndef __NET_MPTCP_H
 #define __NET_MPTCP_H
 
+/* MPTCP sk_buff extension data */
+struct mptcp_ext {
+	u64		data_ack;
+	u64		data_seq;
+	u32		subflow_seq;
+	u16		data_len;
+	__sum16		checksum;
+	u8		use_map:1,
+			dsn64:1,
+			use_checksum:1,
+			data_fin:1,
+			use_ack:1,
+			ack64:1,
+			__unused:2;
+};
+
 /* MPTCP option subtypes */
 #define OPTION_MPTCP_MPC_SYN	BIT(0)
 #define OPTION_MPTCP_MPC_SYNACK	BIT(1)
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index bab9484f1631..826d81ef32f5 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -66,6 +66,7 @@
 #include <net/checksum.h>
 #include <net/ip6_checksum.h>
 #include <net/xfrm.h>
+#include <net/mptcp.h>
 
 #include <linux/uaccess.h>
 #include <trace/events/skb.h>
@@ -3979,6 +3980,9 @@ static const u8 skb_ext_type_len[] = {
 #ifdef CONFIG_XFRM
 	[SKB_EXT_SEC_PATH] = SKB_EXT_CHUNKSIZEOF(struct sec_path),
 #endif
+#if IS_ENABLED(CONFIG_MPTCP)
+	[SKB_EXT_MPTCP] = SKB_EXT_CHUNKSIZEOF(struct mptcp_ext),
+#endif
 };
 
 static __always_inline unsigned int skb_ext_total_length(void)
@@ -3989,6 +3993,9 @@ static __always_inline unsigned int skb_ext_total_length(void)
 #endif
 #ifdef CONFIG_XFRM
 		skb_ext_type_len[SKB_EXT_SEC_PATH] +
+#endif
+#if IS_ENABLED(CONFIG_MPTCP)
+		skb_ext_type_len[SKB_EXT_MPTCP] +
 #endif
 		0;
 }
diff --git a/net/mptcp/Kconfig b/net/mptcp/Kconfig
index d87dfdc210cc..f21190a4f7e9 100644
--- a/net/mptcp/Kconfig
+++ b/net/mptcp/Kconfig
@@ -2,6 +2,7 @@
 config MPTCP
 	bool "Multipath TCP"
 	depends on INET
+	select SKB_EXTENSIONS
 	help
 	  Multipath TCP (MPTCP) connections send and receive data over multiple
 	  subflows in order to utilize multiple network paths. Each subflow
-- 
2.22.0

