Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C24E23B4064
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 11:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbhFYJ1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 05:27:10 -0400
Received: from inva020.nxp.com ([92.121.34.13]:33084 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231455AbhFYJ1D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 05:27:03 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id EAE181A21AA;
        Fri, 25 Jun 2021 11:24:41 +0200 (CEST)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 8451B1A045A;
        Fri, 25 Jun 2021 11:24:41 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id 2A827183AC8A;
        Fri, 25 Jun 2021 17:24:39 +0800 (+08)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, mptcp@lists.linux.dev,
        Richard Cochran <richardcochran@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Shuah Khan <shuah@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Rui Sousa <rui.sousa@nxp.com>,
        Sebastien Laveze <sebastien.laveze@nxp.com>
Subject: [net-next, v4, 07/11] mptcp: setsockopt: convert to mptcp_setsockopt_sol_socket_timestamping()
Date:   Fri, 25 Jun 2021 17:35:09 +0800
Message-Id: <20210625093513.38524-8-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210625093513.38524-1-yangbo.lu@nxp.com>
References: <20210625093513.38524-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split timestamping handling into a new function
mptcp_setsockopt_sol_socket_timestamping().
This is preparation for extending SO_TIMESTAMPING
for PHC binding, since optval will no longer be
integer.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
Changes for v4:
	- Added this patch.
---
 net/mptcp/sockopt.c | 57 +++++++++++++++++++++++++++++++--------------
 1 file changed, 40 insertions(+), 17 deletions(-)

diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index 092d1f635d27..ea38cbcd2ad4 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -157,19 +157,7 @@ static int mptcp_setsockopt_sol_socket_tstamp(struct mptcp_sock *msk, int optnam
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 		bool slow = lock_sock_fast(ssk);
 
-		switch (optname) {
-		case SO_TIMESTAMP_OLD:
-		case SO_TIMESTAMP_NEW:
-		case SO_TIMESTAMPNS_OLD:
-		case SO_TIMESTAMPNS_NEW:
-			sock_set_timestamp(sk, optname, !!val);
-			break;
-		case SO_TIMESTAMPING_NEW:
-		case SO_TIMESTAMPING_OLD:
-			sock_set_timestamping(sk, optname, val);
-			break;
-		}
-
+		sock_set_timestamp(sk, optname, !!val);
 		unlock_sock_fast(ssk, slow);
 	}
 
@@ -178,7 +166,8 @@ static int mptcp_setsockopt_sol_socket_tstamp(struct mptcp_sock *msk, int optnam
 }
 
 static int mptcp_setsockopt_sol_socket_int(struct mptcp_sock *msk, int optname,
-					   sockptr_t optval, unsigned int optlen)
+					   sockptr_t optval,
+					   unsigned int optlen)
 {
 	int val, ret;
 
@@ -205,14 +194,45 @@ static int mptcp_setsockopt_sol_socket_int(struct mptcp_sock *msk, int optname,
 	case SO_TIMESTAMP_NEW:
 	case SO_TIMESTAMPNS_OLD:
 	case SO_TIMESTAMPNS_NEW:
-	case SO_TIMESTAMPING_OLD:
-	case SO_TIMESTAMPING_NEW:
 		return mptcp_setsockopt_sol_socket_tstamp(msk, optname, val);
 	}
 
 	return -ENOPROTOOPT;
 }
 
+static int mptcp_setsockopt_sol_socket_timestamping(struct mptcp_sock *msk,
+						    int optname,
+						    sockptr_t optval,
+						    unsigned int optlen)
+{
+	struct mptcp_subflow_context *subflow;
+	struct sock *sk = (struct sock *)msk;
+	int val, ret;
+
+	ret = mptcp_get_int_option(msk, optval, optlen, &val);
+	if (ret)
+		return ret;
+
+	ret = sock_setsockopt(sk->sk_socket, SOL_SOCKET, optname,
+			      KERNEL_SOCKPTR(&val), sizeof(val));
+	if (ret)
+		return ret;
+
+	lock_sock(sk);
+
+	mptcp_for_each_subflow(msk, subflow) {
+		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+		bool slow = lock_sock_fast(ssk);
+
+		sock_set_timestamping(sk, optname, val);
+		unlock_sock_fast(ssk, slow);
+	}
+
+	release_sock(sk);
+
+	return 0;
+}
+
 static int mptcp_setsockopt_sol_socket_linger(struct mptcp_sock *msk, sockptr_t optval,
 					      unsigned int optlen)
 {
@@ -299,9 +319,12 @@ static int mptcp_setsockopt_sol_socket(struct mptcp_sock *msk, int optname,
 	case SO_TIMESTAMP_NEW:
 	case SO_TIMESTAMPNS_OLD:
 	case SO_TIMESTAMPNS_NEW:
+		return mptcp_setsockopt_sol_socket_int(msk, optname, optval,
+						       optlen);
 	case SO_TIMESTAMPING_OLD:
 	case SO_TIMESTAMPING_NEW:
-		return mptcp_setsockopt_sol_socket_int(msk, optname, optval, optlen);
+		return mptcp_setsockopt_sol_socket_timestamping(msk, optname,
+								optval, optlen);
 	case SO_LINGER:
 		return mptcp_setsockopt_sol_socket_linger(msk, optval, optlen);
 	case SO_RCVLOWAT:
-- 
2.25.1

