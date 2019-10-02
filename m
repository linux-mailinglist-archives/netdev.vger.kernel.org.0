Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59DD2C94F5
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729071AbfJBXhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:37:36 -0400
Received: from mga04.intel.com ([192.55.52.120]:16453 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728981AbfJBXhW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 19:37:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:37:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200"; 
   d="scan'208";a="366862605"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.30.230])
  by orsmga005.jf.intel.com with ESMTP; 02 Oct 2019 16:37:21 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        cpaasch@apple.com, fw@strlen.de, pabeni@redhat.com,
        peter.krystad@linux.intel.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH v2 17/45] mptcp: Add MPTCP to skb extensions
Date:   Wed,  2 Oct 2019 16:36:27 -0700
Message-Id: <20191002233655.24323-18-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
References: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
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
index e7a7abd62026..5a9b26ff44e9 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4068,6 +4068,9 @@ enum skb_ext_id {
 #endif
 #if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
 	TC_SKB_EXT,
+#endif
+#if IS_ENABLED(CONFIG_MPTCP)
+	SKB_EXT_MPTCP,
 #endif
 	SKB_EXT_NUM, /* must be last */
 };
diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index 1a3ed7734bb4..6921b7fb6f0d 100644
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
 struct mptcp_out_options {
 #if IS_ENABLED(CONFIG_MPTCP)
 	u16 suboptions;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 01d65206f4fb..20094629e103 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -68,6 +68,7 @@
 #include <net/ip6_checksum.h>
 #include <net/xfrm.h>
 #include <net/mpls.h>
+#include <net/mptcp.h>
 
 #include <linux/uaccess.h>
 #include <trace/events/skb.h>
@@ -4109,6 +4110,9 @@ static const u8 skb_ext_type_len[] = {
 #if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
 	[TC_SKB_EXT] = SKB_EXT_CHUNKSIZEOF(struct tc_skb_ext),
 #endif
+#if IS_ENABLED(CONFIG_MPTCP)
+	[SKB_EXT_MPTCP] = SKB_EXT_CHUNKSIZEOF(struct mptcp_ext),
+#endif
 };
 
 static __always_inline unsigned int skb_ext_total_length(void)
@@ -4122,6 +4126,9 @@ static __always_inline unsigned int skb_ext_total_length(void)
 #endif
 #if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
 		skb_ext_type_len[TC_SKB_EXT] +
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
2.23.0

