Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B9039AE97
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 01:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbhFCX0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 19:26:31 -0400
Received: from mga05.intel.com ([192.55.52.43]:8110 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229812AbhFCX02 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 19:26:28 -0400
IronPort-SDR: VHswNSPqKg2ihOuI9h01O8cZmKJUJX/9RnTE+Ri38Fu0pGOSd8NQvNI+kO4w17Qyq1QswRW3cf
 KT5SHr2hPRDQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10004"; a="289807791"
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="289807791"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 16:24:42 -0700
IronPort-SDR: K1alDfWUdVULLAu1VndtEapa0rXQDUc0LV8AwiQckmYarbP2OfjD/QcE0akumXj1YVGLtlqSOy
 gtjzXu2kUY7g==
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="483669042"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.3.143])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 16:24:42 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 3/7] mptcp: sockopt: propagate timestamp request to subflows
Date:   Thu,  3 Jun 2021 16:24:29 -0700
Message-Id: <20210603232433.260703-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603232433.260703-1-mathew.j.martineau@linux.intel.com>
References: <20210603232433.260703-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This adds support for TIMESTAMP(NS) setsockopt.

This doesn't make things work yet, because the mptcp receive path
doesn't convert the skb timestamps to cmsgs for userspace consumption.

receive path cmsg support is added ina followup patch.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/sockopt.c | 50 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index a79798189599..3168ad4a9298 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -140,6 +140,43 @@ static void mptcp_so_incoming_cpu(struct mptcp_sock *msk, int val)
 	mptcp_sol_socket_sync_intval(msk, SO_INCOMING_CPU, val);
 }
 
+static int mptcp_setsockopt_sol_socket_tstamp(struct mptcp_sock *msk, int optname, int val)
+{
+	sockptr_t optval = KERNEL_SOCKPTR(&val);
+	struct mptcp_subflow_context *subflow;
+	struct sock *sk = (struct sock *)msk;
+	int ret;
+
+	ret = sock_setsockopt(sk->sk_socket, SOL_SOCKET, optname,
+			      optval, sizeof(val));
+	if (ret)
+		return ret;
+
+	lock_sock(sk);
+	mptcp_for_each_subflow(msk, subflow) {
+		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+		bool slow = lock_sock_fast(ssk);
+
+		switch (optname) {
+		case SO_TIMESTAMP_OLD:
+		case SO_TIMESTAMP_NEW:
+		case SO_TIMESTAMPNS_OLD:
+		case SO_TIMESTAMPNS_NEW:
+			sock_set_timestamp(sk, optname, !!val);
+			break;
+		case SO_TIMESTAMPING_NEW:
+		case SO_TIMESTAMPING_OLD:
+			sock_set_timestamping(sk, optname, val);
+			break;
+		}
+
+		unlock_sock_fast(ssk, slow);
+	}
+
+	release_sock(sk);
+	return 0;
+}
+
 static int mptcp_setsockopt_sol_socket_int(struct mptcp_sock *msk, int optname,
 					   sockptr_t optval, unsigned int optlen)
 {
@@ -164,6 +201,13 @@ static int mptcp_setsockopt_sol_socket_int(struct mptcp_sock *msk, int optname,
 	case SO_INCOMING_CPU:
 		mptcp_so_incoming_cpu(msk, val);
 		return 0;
+	case SO_TIMESTAMP_OLD:
+	case SO_TIMESTAMP_NEW:
+	case SO_TIMESTAMPNS_OLD:
+	case SO_TIMESTAMPNS_NEW:
+	case SO_TIMESTAMPING_OLD:
+	case SO_TIMESTAMPING_NEW:
+		return mptcp_setsockopt_sol_socket_tstamp(msk, optname, val);
 	}
 
 	return -ENOPROTOOPT;
@@ -251,6 +295,12 @@ static int mptcp_setsockopt_sol_socket(struct mptcp_sock *msk, int optname,
 	case SO_MARK:
 	case SO_INCOMING_CPU:
 	case SO_DEBUG:
+	case SO_TIMESTAMP_OLD:
+	case SO_TIMESTAMP_NEW:
+	case SO_TIMESTAMPNS_OLD:
+	case SO_TIMESTAMPNS_NEW:
+	case SO_TIMESTAMPING_OLD:
+	case SO_TIMESTAMPING_NEW:
 		return mptcp_setsockopt_sol_socket_int(msk, optname, optval, optlen);
 	case SO_LINGER:
 		return mptcp_setsockopt_sol_socket_linger(msk, optval, optlen);
-- 
2.31.1

