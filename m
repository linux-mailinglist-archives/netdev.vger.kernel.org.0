Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07C13194971
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 21:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgCZUrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 16:47:05 -0400
Received: from mga05.intel.com ([192.55.52.43]:47904 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727774AbgCZUrE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 16:47:04 -0400
IronPort-SDR: HH1LFsjjEPqc3xYnRTwkInbvBeAs5Q5JnFvDkUkaYeXixhQZbY5tXQMOA1BN8cSSbfz8wtKGTl
 8LtK4lR8mqlw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 13:47:03 -0700
IronPort-SDR: RVRBiawIB2WmYSodsQMKW0Fl6xAodhynQqov0OrvG5z2fy8qnYUfuXBbBCvXuOxnUefivKMV+p
 s0+E0oTG+66A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,309,1580803200"; 
   d="scan'208";a="238911696"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.252.133.119])
  by fmsmga007.fm.intel.com with ESMTP; 26 Mar 2020 13:47:03 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Davide Caratti <dcaratti@redhat.com>, eric.dumazet@gmail.com,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next v2 13/17] mptcp: allow dumping subflow context to userspace
Date:   Thu, 26 Mar 2020 13:46:36 -0700
Message-Id: <20200326204640.67336-14-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200326204640.67336-1-mathew.j.martineau@linux.intel.com>
References: <20200326204640.67336-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

add ulp-specific diagnostic functions, so that subflow information can be
dumped to userspace programs like 'ss'.

Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 MAINTAINERS                    |   1 +
 include/uapi/linux/inet_diag.h |   1 +
 include/uapi/linux/mptcp.h     |  34 +++++++++++
 net/mptcp/Makefile             |   2 +-
 net/mptcp/diag.c               | 104 +++++++++++++++++++++++++++++++++
 net/mptcp/protocol.h           |   2 +
 net/mptcp/subflow.c            |   2 +
 7 files changed, 145 insertions(+), 1 deletion(-)
 create mode 100644 include/uapi/linux/mptcp.h
 create mode 100644 net/mptcp/diag.c

diff --git a/MAINTAINERS b/MAINTAINERS
index feccc0aa2720..248926155660 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11719,6 +11719,7 @@ W:	https://github.com/multipath-tcp/mptcp_net-next/wiki
 B:	https://github.com/multipath-tcp/mptcp_net-next/issues
 S:	Maintained
 F:	include/net/mptcp.h
+F:	include/uapi/linux/mptcp.h
 F:	net/mptcp/
 F:	tools/testing/selftests/net/mptcp/
 
diff --git a/include/uapi/linux/inet_diag.h b/include/uapi/linux/inet_diag.h
index 75dffd78363a..57cc429a9177 100644
--- a/include/uapi/linux/inet_diag.h
+++ b/include/uapi/linux/inet_diag.h
@@ -166,6 +166,7 @@ enum {
 	INET_ULP_INFO_UNSPEC,
 	INET_ULP_INFO_NAME,
 	INET_ULP_INFO_TLS,
+	INET_ULP_INFO_MPTCP,
 	__INET_ULP_INFO_MAX,
 };
 #define INET_ULP_INFO_MAX (__INET_ULP_INFO_MAX - 1)
diff --git a/include/uapi/linux/mptcp.h b/include/uapi/linux/mptcp.h
new file mode 100644
index 000000000000..c564140d20f0
--- /dev/null
+++ b/include/uapi/linux/mptcp.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+#ifndef _UAPI_MPTCP_H
+#define _UAPI_MPTCP_H
+
+#include <linux/types.h>
+
+#define MPTCP_SUBFLOW_FLAG_MCAP_REM		BIT(0)
+#define MPTCP_SUBFLOW_FLAG_MCAP_LOC		BIT(1)
+#define MPTCP_SUBFLOW_FLAG_JOIN_REM		BIT(2)
+#define MPTCP_SUBFLOW_FLAG_JOIN_LOC		BIT(3)
+#define MPTCP_SUBFLOW_FLAG_BKUP_REM		BIT(4)
+#define MPTCP_SUBFLOW_FLAG_BKUP_LOC		BIT(5)
+#define MPTCP_SUBFLOW_FLAG_FULLY_ESTABLISHED	BIT(6)
+#define MPTCP_SUBFLOW_FLAG_CONNECTED		BIT(7)
+#define MPTCP_SUBFLOW_FLAG_MAPVALID		BIT(8)
+
+enum {
+	MPTCP_SUBFLOW_ATTR_UNSPEC,
+	MPTCP_SUBFLOW_ATTR_TOKEN_REM,
+	MPTCP_SUBFLOW_ATTR_TOKEN_LOC,
+	MPTCP_SUBFLOW_ATTR_RELWRITE_SEQ,
+	MPTCP_SUBFLOW_ATTR_MAP_SEQ,
+	MPTCP_SUBFLOW_ATTR_MAP_SFSEQ,
+	MPTCP_SUBFLOW_ATTR_SSN_OFFSET,
+	MPTCP_SUBFLOW_ATTR_MAP_DATALEN,
+	MPTCP_SUBFLOW_ATTR_FLAGS,
+	MPTCP_SUBFLOW_ATTR_ID_REM,
+	MPTCP_SUBFLOW_ATTR_ID_LOC,
+	MPTCP_SUBFLOW_ATTR_PAD,
+	__MPTCP_SUBFLOW_ATTR_MAX
+};
+
+#define MPTCP_SUBFLOW_ATTR_MAX (__MPTCP_SUBFLOW_ATTR_MAX - 1)
+#endif /* _UAPI_MPTCP_H */
diff --git a/net/mptcp/Makefile b/net/mptcp/Makefile
index 2848d723c252..54494cf5bec0 100644
--- a/net/mptcp/Makefile
+++ b/net/mptcp/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_MPTCP) += mptcp.o
 
-mptcp-y := protocol.o subflow.o options.o token.o crypto.o ctrl.o pm.o
+mptcp-y := protocol.o subflow.o options.o token.o crypto.o ctrl.o pm.o diag.o
diff --git a/net/mptcp/diag.c b/net/mptcp/diag.c
new file mode 100644
index 000000000000..a536586742f2
--- /dev/null
+++ b/net/mptcp/diag.c
@@ -0,0 +1,104 @@
+// SPDX-License-Identifier: GPL-2.0
+/* MPTCP socket monitoring support
+ *
+ * Copyright (c) 2019 Red Hat
+ *
+ * Author: Davide Caratti <dcaratti@redhat.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/net.h>
+#include <linux/inet_diag.h>
+#include <net/netlink.h>
+#include <uapi/linux/mptcp.h>
+#include "protocol.h"
+
+static int subflow_get_info(const struct sock *sk, struct sk_buff *skb)
+{
+	struct mptcp_subflow_context *sf;
+	struct nlattr *start;
+	u32 flags = 0;
+	int err;
+
+	start = nla_nest_start_noflag(skb, INET_ULP_INFO_MPTCP);
+	if (!start)
+		return -EMSGSIZE;
+
+	rcu_read_lock();
+	sf = rcu_dereference(inet_csk(sk)->icsk_ulp_data);
+	if (!sf) {
+		err = 0;
+		goto nla_failure;
+	}
+
+	if (sf->mp_capable)
+		flags |= MPTCP_SUBFLOW_FLAG_MCAP_REM;
+	if (sf->request_mptcp)
+		flags |= MPTCP_SUBFLOW_FLAG_MCAP_LOC;
+	if (sf->mp_join)
+		flags |= MPTCP_SUBFLOW_FLAG_JOIN_REM;
+	if (sf->request_join)
+		flags |= MPTCP_SUBFLOW_FLAG_JOIN_LOC;
+	if (sf->backup)
+		flags |= MPTCP_SUBFLOW_FLAG_BKUP_REM;
+	if (sf->request_bkup)
+		flags |= MPTCP_SUBFLOW_FLAG_BKUP_LOC;
+	if (sf->fully_established)
+		flags |= MPTCP_SUBFLOW_FLAG_FULLY_ESTABLISHED;
+	if (sf->conn_finished)
+		flags |= MPTCP_SUBFLOW_FLAG_CONNECTED;
+	if (sf->map_valid)
+		flags |= MPTCP_SUBFLOW_FLAG_MAPVALID;
+
+	if (nla_put_u32(skb, MPTCP_SUBFLOW_ATTR_TOKEN_REM, sf->remote_token) ||
+	    nla_put_u32(skb, MPTCP_SUBFLOW_ATTR_TOKEN_LOC, sf->token) ||
+	    nla_put_u32(skb, MPTCP_SUBFLOW_ATTR_RELWRITE_SEQ,
+			sf->rel_write_seq) ||
+	    nla_put_u64_64bit(skb, MPTCP_SUBFLOW_ATTR_MAP_SEQ, sf->map_seq,
+			      MPTCP_SUBFLOW_ATTR_PAD) ||
+	    nla_put_u32(skb, MPTCP_SUBFLOW_ATTR_MAP_SFSEQ,
+			sf->map_subflow_seq) ||
+	    nla_put_u32(skb, MPTCP_SUBFLOW_ATTR_SSN_OFFSET, sf->ssn_offset) ||
+	    nla_put_u16(skb, MPTCP_SUBFLOW_ATTR_MAP_DATALEN,
+			sf->map_data_len) ||
+	    nla_put_u32(skb, MPTCP_SUBFLOW_ATTR_FLAGS, flags) ||
+	    nla_put_u8(skb, MPTCP_SUBFLOW_ATTR_ID_REM, sf->remote_id) ||
+	    nla_put_u8(skb, MPTCP_SUBFLOW_ATTR_ID_LOC, sf->local_id)) {
+		err = -EMSGSIZE;
+		goto nla_failure;
+	}
+
+	rcu_read_unlock();
+	nla_nest_end(skb, start);
+	return 0;
+
+nla_failure:
+	rcu_read_unlock();
+	nla_nest_cancel(skb, start);
+	return err;
+}
+
+static size_t subflow_get_info_size(const struct sock *sk)
+{
+	size_t size = 0;
+
+	size += nla_total_size(0) +	/* INET_ULP_INFO_MPTCP */
+		nla_total_size(4) +	/* MPTCP_SUBFLOW_ATTR_TOKEN_REM */
+		nla_total_size(4) +	/* MPTCP_SUBFLOW_ATTR_TOKEN_LOC */
+		nla_total_size(4) +	/* MPTCP_SUBFLOW_ATTR_RELWRITE_SEQ */
+		nla_total_size_64bit(8) +	/* MPTCP_SUBFLOW_ATTR_MAP_SEQ */
+		nla_total_size(4) +	/* MPTCP_SUBFLOW_ATTR_MAP_SFSEQ */
+		nla_total_size(2) +	/* MPTCP_SUBFLOW_ATTR_SSN_OFFSET */
+		nla_total_size(2) +	/* MPTCP_SUBFLOW_ATTR_MAP_DATALEN */
+		nla_total_size(4) +	/* MPTCP_SUBFLOW_ATTR_FLAGS */
+		nla_total_size(1) +	/* MPTCP_SUBFLOW_ATTR_ID_REM */
+		nla_total_size(1) +	/* MPTCP_SUBFLOW_ATTR_ID_LOC */
+		0;
+	return size;
+}
+
+void mptcp_diag_subflow_init(struct tcp_ulp_ops *ops)
+{
+	ops->get_info = subflow_get_info;
+	ops->get_info_size = subflow_get_info_size;
+}
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index e9d4a852c7f1..0999f74df027 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -408,4 +408,6 @@ static inline bool before64(__u64 seq1, __u64 seq2)
 
 #define after64(seq2, seq1)	before64(seq1, seq2)
 
+void mptcp_diag_subflow_init(struct tcp_ulp_ops *ops);
+
 #endif /* __MPTCP_PROTOCOL_H */
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index ba636cd84a3c..c051db074708 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1148,6 +1148,8 @@ void mptcp_subflow_init(void)
 	subflow_v6m_specific.net_frag_header_len = 0;
 #endif
 
+	mptcp_diag_subflow_init(&subflow_ulp_ops);
+
 	if (tcp_register_ulp(&subflow_ulp_ops) != 0)
 		panic("MPTCP: failed to register subflows to ULP\n");
 }
-- 
2.26.0

