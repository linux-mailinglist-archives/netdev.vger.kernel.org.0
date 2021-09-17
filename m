Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61CCF4101C6
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 01:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241360AbhIQXe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 19:34:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:37385 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236729AbhIQXex (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 19:34:53 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10110"; a="210130346"
X-IronPort-AV: E=Sophos;i="5.85,302,1624345200"; 
   d="scan'208";a="210130346"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2021 16:33:30 -0700
X-IronPort-AV: E=Sophos;i="5.85,302,1624345200"; 
   d="scan'208";a="483228557"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.205.24])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2021 16:33:29 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 2/5] mptcp: add MPTCP_INFO getsockopt
Date:   Fri, 17 Sep 2021 16:33:19 -0700
Message-Id: <20210917233322.271789-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210917233322.271789-1-mathew.j.martineau@linux.intel.com>
References: <20210917233322.271789-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Its not compatible with multipath-tcp.org kernel one.

1. The out-of-tree implementation defines a different 'struct mptcp_info',
   with embedded __user addresses for additional data such as
   endpoint addresses.

2. Mat Martineau points out that embedded __user addresses doesn't work
with BPF_CGROUP_RUN_PROG_GETSOCKOPT() which assumes that copying in
optsize bytes from optval provides all data that got copied to userspace.

This provides mptcp_info data for the given mptcp socket.

Userspace sets optlen to the size of the structure it expects.
The kernel updates it to contain the number of bytes that it copied.

This allows to append more information to the structure later.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/linux/socket.h     |  1 +
 include/uapi/linux/mptcp.h |  3 +++
 net/mptcp/sockopt.c        | 40 +++++++++++++++++++++++++++++++++++++-
 3 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 041d6032a348..7612d760b6a9 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -364,6 +364,7 @@ struct ucred {
 #define SOL_KCM		281
 #define SOL_TLS		282
 #define SOL_XDP		283
+#define SOL_MPTCP	284
 
 /* IPX options */
 #define IPX_TYPE	1
diff --git a/include/uapi/linux/mptcp.h b/include/uapi/linux/mptcp.h
index f66038b9551f..3e9caeddda7e 100644
--- a/include/uapi/linux/mptcp.h
+++ b/include/uapi/linux/mptcp.h
@@ -193,4 +193,7 @@ enum mptcp_event_attr {
 #define MPTCP_RST_EBADPERF	5
 #define MPTCP_RST_EMIDDLEBOX	6
 
+/* MPTCP socket options */
+#define MPTCP_INFO 1
+
 #endif /* _UAPI_MPTCP_H */
diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index 54f0d521a399..f7683c22911f 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -673,10 +673,14 @@ static int mptcp_getsockopt_first_sf_only(struct mptcp_sock *msk, int level, int
 void mptcp_diag_fill_info(struct mptcp_sock *msk, struct mptcp_info *info)
 {
 	struct sock *sk = &msk->sk.icsk_inet.sk;
-	bool slow = lock_sock_fast(sk);
 	u32 flags = 0;
+	bool slow;
 	u8 val;
 
+	memset(info, 0, sizeof(*info));
+
+	slow = lock_sock_fast(sk);
+
 	info->mptcpi_subflows = READ_ONCE(msk->pm.subflows);
 	info->mptcpi_add_addr_signal = READ_ONCE(msk->pm.add_addr_signaled);
 	info->mptcpi_add_addr_accepted = READ_ONCE(msk->pm.add_addr_accepted);
@@ -702,6 +706,27 @@ void mptcp_diag_fill_info(struct mptcp_sock *msk, struct mptcp_info *info)
 }
 EXPORT_SYMBOL_GPL(mptcp_diag_fill_info);
 
+static int mptcp_getsockopt_info(struct mptcp_sock *msk, char __user *optval, int __user *optlen)
+{
+	struct mptcp_info m_info;
+	int len;
+
+	if (get_user(len, optlen))
+		return -EFAULT;
+
+	len = min_t(unsigned int, len, sizeof(struct mptcp_info));
+
+	mptcp_diag_fill_info(msk, &m_info);
+
+	if (put_user(len, optlen))
+		return -EFAULT;
+
+	if (copy_to_user(optval, &m_info, len))
+		return -EFAULT;
+
+	return 0;
+}
+
 static int mptcp_getsockopt_sol_tcp(struct mptcp_sock *msk, int optname,
 				    char __user *optval, int __user *optlen)
 {
@@ -716,6 +741,17 @@ static int mptcp_getsockopt_sol_tcp(struct mptcp_sock *msk, int optname,
 	return -EOPNOTSUPP;
 }
 
+static int mptcp_getsockopt_sol_mptcp(struct mptcp_sock *msk, int optname,
+				      char __user *optval, int __user *optlen)
+{
+	switch (optname) {
+	case MPTCP_INFO:
+		return mptcp_getsockopt_info(msk, optval, optlen);
+	}
+
+	return -EOPNOTSUPP;
+}
+
 int mptcp_getsockopt(struct sock *sk, int level, int optname,
 		     char __user *optval, int __user *option)
 {
@@ -738,6 +774,8 @@ int mptcp_getsockopt(struct sock *sk, int level, int optname,
 
 	if (level == SOL_TCP)
 		return mptcp_getsockopt_sol_tcp(msk, optname, optval, option);
+	if (level == SOL_MPTCP)
+		return mptcp_getsockopt_sol_mptcp(msk, optname, optval, option);
 	return -EOPNOTSUPP;
 }
 
-- 
2.33.0

