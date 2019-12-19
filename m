Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 765C612705B
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 23:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbfLSWGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 17:06:40 -0500
Received: from mga18.intel.com ([134.134.136.126]:44253 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727210AbfLSWGb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 17:06:31 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Dec 2019 14:06:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,333,1571727600"; 
   d="scan'208";a="298841749"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.1.107])
  by orsmga001.jf.intel.com with ESMTP; 19 Dec 2019 14:06:30 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, mptcp@lists.01.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH net-next v4 06/11] mptcp: Add MPTCP to skb extensions
Date:   Thu, 19 Dec 2019 14:05:52 -0800
Message-Id: <20191219220557.17823-7-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219220557.17823-1-mathew.j.martineau@linux.intel.com>
References: <20191219220557.17823-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add enum value for MPTCP and update config dependencies

Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 MAINTAINERS            | 10 ++++++++++
 include/linux/skbuff.h |  3 +++
 include/net/mptcp.h    | 27 +++++++++++++++++++++++++++
 net/core/skbuff.c      |  7 +++++++
 4 files changed, 47 insertions(+)
 create mode 100644 include/net/mptcp.h

diff --git a/MAINTAINERS b/MAINTAINERS
index a28c77ee6b0d..132eb3f9fbb7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11568,6 +11568,16 @@ F:	net/ipv6/calipso.c
 F:	net/netfilter/xt_CONNSECMARK.c
 F:	net/netfilter/xt_SECMARK.c
 
+NETWORKING [MPTCP]
+M:	Mat Martineau <mathew.j.martineau@linux.intel.com>
+M:	Matthieu Baerts <matthieu.baerts@tessares.net>
+L:	netdev@vger.kernel.org
+L:	mptcp@lists.01.org
+W:	https://github.com/multipath-tcp/mptcp_net-next/wiki
+B:	https://github.com/multipath-tcp/mptcp_net-next/issues
+S:	Maintained
+F:	include/net/mptcp.h
+
 NETWORKING [TCP]
 M:	Eric Dumazet <edumazet@google.com>
 L:	netdev@vger.kernel.org
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index e9133bcf0544..1a261c3ee074 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4091,6 +4091,9 @@ enum skb_ext_id {
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
index 973a71f4bc89..fa67036dd928 100644
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
2.24.1

