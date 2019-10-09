Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCBED1C73
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 01:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732480AbfJIXIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 19:08:53 -0400
Received: from mga06.intel.com ([134.134.136.31]:40462 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732388AbfJIXIn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 19:08:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Oct 2019 16:08:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,277,1566889200"; 
   d="scan'208";a="205902518"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.254.70.56])
  by orsmga002.jf.intel.com with ESMTP; 09 Oct 2019 16:08:41 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        cpaasch@apple.com, fw@strlen.de, pabeni@redhat.com,
        peter.krystad@linux.intel.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH v3 06/10] mptcp: Add MPTCP to skb extensions
Date:   Wed,  9 Oct 2019 16:08:05 -0700
Message-Id: <20191009230809.27387-7-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191009230809.27387-1-mathew.j.martineau@linux.intel.com>
References: <20191009230809.27387-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add enum value for MPTCP and update config dependencies

Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 include/linux/skbuff.h |  3 +++
 include/net/mptcp.h    | 27 +++++++++++++++++++++++++++
 net/core/skbuff.c      |  7 +++++++
 3 files changed, 37 insertions(+)
 create mode 100644 include/net/mptcp.h

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 0a58402a166e..618ee4b3ab7f 100644
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
new file mode 100644
index 000000000000..f9f668ac4339
--- /dev/null
+++ b/include/net/mptcp.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Multipath TCP
+ *
+ * Copyright (c) 2017 - 2019, Intel Corporation.
+ */
+
+#ifndef __NET_MPTCP_H
+#define __NET_MPTCP_H
+
+#include <linux/types.h>
+
+/* MPTCP sk_buff extension data */
+struct mptcp_ext {
+	u64		data_ack;
+	u64		data_seq;
+	u32		subflow_seq;
+	u16		data_len;
+	u8		use_map:1,
+			dsn64:1,
+			data_fin:1,
+			use_ack:1,
+			ack64:1,
+			__unused:2;
+};
+
+#endif /* __NET_MPTCP_H */
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 529133611ea2..b2dc326f748b 100644
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
-- 
2.23.0

