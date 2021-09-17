Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3CBB4101C8
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 01:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343717AbhIQXfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 19:35:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:37389 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235653AbhIQXey (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 19:34:54 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10110"; a="210130350"
X-IronPort-AV: E=Sophos;i="5.85,302,1624345200"; 
   d="scan'208";a="210130350"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2021 16:33:30 -0700
X-IronPort-AV: E=Sophos;i="5.85,302,1624345200"; 
   d="scan'208";a="483228560"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.205.24])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2021 16:33:30 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 4/5] mptcp: add MPTCP_SUBFLOW_ADDRS getsockopt support
Date:   Fri, 17 Sep 2021 16:33:21 -0700
Message-Id: <20210917233322.271789-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210917233322.271789-1-mathew.j.martineau@linux.intel.com>
References: <20210917233322.271789-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This retrieves the address pairs of all subflows currently
active for a given mptcp connection.

It re-uses the same meta-header as for MPTCP_TCPINFO.

A new structure is provided to hold the subflow
address data:

struct mptcp_subflow_addrs {
	union {
		__kernel_sa_family_t sa_family;
		struct sockaddr sa_local;
		struct sockaddr_in sin_local;
		struct sockaddr_in6 sin6_local;
		struct sockaddr_storage ss_local;
	};
	union {
		struct sockaddr sa_remote;
		struct sockaddr_in sin_remote;
		struct sockaddr_in6 sin6_remote;
		struct sockaddr_storage ss_remote;
	};
};

Usage of the new getsockopt is very similar to
MPTCP_TCPINFO one.

Userspace allocates a
'struct mptcp_subflow_data', followed by one or
more 'struct mptcp_subflow_addrs', then inits the
mptcp_subflow_data structure as follows:

struct mptcp_subflow_addrs *sf_addr;
struct mptcp_subflow_data *addr;
socklen_t olen = sizeof(*addr) + (8 * sizeof(*sf_addr));

addr = malloc(olen);
addr->size_subflow_data = sizeof(*addr);
addr->num_subflows = 0;
addr->size_kernel = 0;
addr->size_user = sizeof(struct mptcp_subflow_addrs);

sf_addr = (struct mptcp_subflow_addrs *)(addr + 1);

and then retrieves the endpoint addresses via:
ret = getsockopt(fd, SOL_MPTCP, MPTCP_SUBFLOW_ADDRS,
		 addr, &olen);

If the call succeeds, kernel will have added up to 8
endpoint addresses after the 'mptcp_subflow_data' header.

Userspace needs to re-check 'olen' value to detect how
many bytes have been filled in by the kernel.

Userspace can check addr->num_subflows to discover when
there were more subflows that available data space.

Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/uapi/linux/mptcp.h | 24 ++++++++++
 net/mptcp/sockopt.c        | 91 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 115 insertions(+)

diff --git a/include/uapi/linux/mptcp.h b/include/uapi/linux/mptcp.h
index 3f013a513770..c8cc46f80a16 100644
--- a/include/uapi/linux/mptcp.h
+++ b/include/uapi/linux/mptcp.h
@@ -4,6 +4,13 @@
 
 #include <linux/const.h>
 #include <linux/types.h>
+#include <linux/in.h>		/* for sockaddr_in			*/
+#include <linux/in6.h>		/* for sockaddr_in6			*/
+#include <linux/socket.h>	/* for sockaddr_storage and sa_family	*/
+
+#ifndef __KERNEL__
+#include <sys/socket.h>		/* for struct sockaddr			*/
+#endif
 
 #define MPTCP_SUBFLOW_FLAG_MCAP_REM		_BITUL(0)
 #define MPTCP_SUBFLOW_FLAG_MCAP_LOC		_BITUL(1)
@@ -200,8 +207,25 @@ struct mptcp_subflow_data {
 	__u32		size_user;			/* size of one element in data[] */
 } __attribute__((aligned(8)));
 
+struct mptcp_subflow_addrs {
+	union {
+		__kernel_sa_family_t sa_family;
+		struct sockaddr sa_local;
+		struct sockaddr_in sin_local;
+		struct sockaddr_in6 sin6_local;
+		struct __kernel_sockaddr_storage ss_local;
+	};
+	union {
+		struct sockaddr sa_remote;
+		struct sockaddr_in sin_remote;
+		struct sockaddr_in6 sin6_remote;
+		struct __kernel_sockaddr_storage ss_remote;
+	};
+};
+
 /* MPTCP socket options */
 #define MPTCP_INFO		1
 #define MPTCP_TCPINFO		2
+#define MPTCP_SUBFLOW_ADDRS	3
 
 #endif /* _UAPI_MPTCP_H */
diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index eb2905bfa089..8137cc3a4296 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -840,6 +840,95 @@ static int mptcp_getsockopt_tcpinfo(struct mptcp_sock *msk, char __user *optval,
 	return 0;
 }
 
+static void mptcp_get_sub_addrs(const struct sock *sk, struct mptcp_subflow_addrs *a)
+{
+	struct inet_sock *inet = inet_sk(sk);
+
+	memset(a, 0, sizeof(*a));
+
+	if (sk->sk_family == AF_INET) {
+		a->sin_local.sin_family = AF_INET;
+		a->sin_local.sin_port = inet->inet_sport;
+		a->sin_local.sin_addr.s_addr = inet->inet_rcv_saddr;
+
+		if (!a->sin_local.sin_addr.s_addr)
+			a->sin_local.sin_addr.s_addr = inet->inet_saddr;
+
+		a->sin_remote.sin_family = AF_INET;
+		a->sin_remote.sin_port = inet->inet_dport;
+		a->sin_remote.sin_addr.s_addr = inet->inet_daddr;
+#if IS_ENABLED(CONFIG_IPV6)
+	} else if (sk->sk_family == AF_INET6) {
+		const struct ipv6_pinfo *np = inet6_sk(sk);
+
+		a->sin6_local.sin6_family = AF_INET6;
+		a->sin6_local.sin6_port = inet->inet_sport;
+
+		if (ipv6_addr_any(&sk->sk_v6_rcv_saddr))
+			a->sin6_local.sin6_addr = np->saddr;
+		else
+			a->sin6_local.sin6_addr = sk->sk_v6_rcv_saddr;
+
+		a->sin6_remote.sin6_family = AF_INET6;
+		a->sin6_remote.sin6_port = inet->inet_dport;
+		a->sin6_remote.sin6_addr = sk->sk_v6_daddr;
+#endif
+	}
+}
+
+static int mptcp_getsockopt_subflow_addrs(struct mptcp_sock *msk, char __user *optval,
+					  int __user *optlen)
+{
+	struct sock *sk = &msk->sk.icsk_inet.sk;
+	struct mptcp_subflow_context *subflow;
+	unsigned int sfcount = 0, copied = 0;
+	struct mptcp_subflow_data sfd;
+	char __user *addrptr;
+	int len;
+
+	len = mptcp_get_subflow_data(&sfd, optval, optlen);
+	if (len < 0)
+		return len;
+
+	sfd.size_kernel = sizeof(struct mptcp_subflow_addrs);
+	sfd.size_user = min_t(unsigned int, sfd.size_user,
+			      sizeof(struct mptcp_subflow_addrs));
+
+	addrptr = optval + sfd.size_subflow_data;
+
+	lock_sock(sk);
+
+	mptcp_for_each_subflow(msk, subflow) {
+		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+
+		++sfcount;
+
+		if (len && len >= sfd.size_user) {
+			struct mptcp_subflow_addrs a;
+
+			mptcp_get_sub_addrs(ssk, &a);
+
+			if (copy_to_user(addrptr, &a, sfd.size_user)) {
+				release_sock(sk);
+				return -EFAULT;
+			}
+
+			addrptr += sfd.size_user;
+			copied += sfd.size_user;
+			len -= sfd.size_user;
+		}
+	}
+
+	release_sock(sk);
+
+	sfd.num_subflows = sfcount;
+
+	if (mptcp_put_subflow_data(&sfd, optval, copied, optlen))
+		return -EFAULT;
+
+	return 0;
+}
+
 static int mptcp_getsockopt_sol_tcp(struct mptcp_sock *msk, int optname,
 				    char __user *optval, int __user *optlen)
 {
@@ -862,6 +951,8 @@ static int mptcp_getsockopt_sol_mptcp(struct mptcp_sock *msk, int optname,
 		return mptcp_getsockopt_info(msk, optval, optlen);
 	case MPTCP_TCPINFO:
 		return mptcp_getsockopt_tcpinfo(msk, optval, optlen);
+	case MPTCP_SUBFLOW_ADDRS:
+		return mptcp_getsockopt_subflow_addrs(msk, optval, optlen);
 	}
 
 	return -EOPNOTSUPP;
-- 
2.33.0

