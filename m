Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F8039AE99
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 01:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbhFCX0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 19:26:33 -0400
Received: from mga05.intel.com ([192.55.52.43]:8110 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229880AbhFCX02 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 19:26:28 -0400
IronPort-SDR: +okJxZe/3Tn3j5YghsKSrupupXGNoIHUteejsmsgGCtIFj6ByAEGXdzc+E4knjUFUNY78tsDWF
 +lOMTUbIBimA==
X-IronPort-AV: E=McAfee;i="6200,9189,10004"; a="289807796"
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="289807796"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 16:24:43 -0700
IronPort-SDR: 8zkenE7fqbqhKo5vrBpwZ5Tnobh1A/uMyhXqcWt2zegRicwZQxD59FNOuZ8hTTkZE4w8kNFjrU
 AM+OIURKgYGA==
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="483669043"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.3.143])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 16:24:42 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 4/7] mptcp: setsockopt: handle SOL_SOCKET in one place only
Date:   Thu,  3 Jun 2021 16:24:30 -0700
Message-Id: <20210603232433.260703-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603232433.260703-1-mathew.j.martineau@linux.intel.com>
References: <20210603232433.260703-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Move the pre-check to the function that handles all SOL_SOCKET values.

At this point there is complete coverage for all values that were
accepted by the pre-check.

BUSYPOLL functions are accepted but will not have any functionality
yet until its clear how the expected mptcp behaviour should look like.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/sockopt.c | 99 +++++++++++++--------------------------------
 1 file changed, 29 insertions(+), 70 deletions(-)

diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index 3168ad4a9298..092d1f635d27 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -304,6 +304,14 @@ static int mptcp_setsockopt_sol_socket(struct mptcp_sock *msk, int optname,
 		return mptcp_setsockopt_sol_socket_int(msk, optname, optval, optlen);
 	case SO_LINGER:
 		return mptcp_setsockopt_sol_socket_linger(msk, optval, optlen);
+	case SO_RCVLOWAT:
+	case SO_RCVTIMEO_OLD:
+	case SO_RCVTIMEO_NEW:
+	case SO_BUSY_POLL:
+	case SO_PREFER_BUSY_POLL:
+	case SO_BUSY_POLL_BUDGET:
+		/* No need to copy: only relevant for msk */
+		return sock_setsockopt(sk->sk_socket, SOL_SOCKET, optname, optval, optlen);
 	case SO_NO_CHECK:
 	case SO_DONTROUTE:
 	case SO_BROADCAST:
@@ -317,7 +325,24 @@ static int mptcp_setsockopt_sol_socket(struct mptcp_sock *msk, int optname,
 		return 0;
 	}
 
-	return sock_setsockopt(sk->sk_socket, SOL_SOCKET, optname, optval, optlen);
+	/* SO_OOBINLINE is not supported, let's avoid the related mess
+	 * SO_ATTACH_FILTER, SO_ATTACH_BPF, SO_ATTACH_REUSEPORT_CBPF,
+	 * SO_DETACH_REUSEPORT_BPF, SO_DETACH_FILTER, SO_LOCK_FILTER,
+	 * we must be careful with subflows
+	 *
+	 * SO_ATTACH_REUSEPORT_EBPF is not supported, at it checks
+	 * explicitly the sk_protocol field
+	 *
+	 * SO_PEEK_OFF is unsupported, as it is for plain TCP
+	 * SO_MAX_PACING_RATE is unsupported, we must be careful with subflows
+	 * SO_CNX_ADVICE is currently unsupported, could possibly be relevant,
+	 * but likely needs careful design
+	 *
+	 * SO_ZEROCOPY is currently unsupported, TODO in sndmsg
+	 * SO_TXTIME is currently unsupported
+	 */
+
+	return -EOPNOTSUPP;
 }
 
 static int mptcp_setsockopt_v6(struct mptcp_sock *msk, int optname,
@@ -349,72 +374,6 @@ static int mptcp_setsockopt_v6(struct mptcp_sock *msk, int optname,
 
 static bool mptcp_supported_sockopt(int level, int optname)
 {
-	if (level == SOL_SOCKET) {
-		switch (optname) {
-		case SO_DEBUG:
-		case SO_REUSEPORT:
-		case SO_REUSEADDR:
-
-		/* the following ones need a better implementation,
-		 * but are quite common we want to preserve them
-		 */
-		case SO_BINDTODEVICE:
-		case SO_SNDBUF:
-		case SO_SNDBUFFORCE:
-		case SO_RCVBUF:
-		case SO_RCVBUFFORCE:
-		case SO_KEEPALIVE:
-		case SO_PRIORITY:
-		case SO_LINGER:
-		case SO_TIMESTAMP_OLD:
-		case SO_TIMESTAMP_NEW:
-		case SO_TIMESTAMPNS_OLD:
-		case SO_TIMESTAMPNS_NEW:
-		case SO_TIMESTAMPING_OLD:
-		case SO_TIMESTAMPING_NEW:
-		case SO_RCVLOWAT:
-		case SO_RCVTIMEO_OLD:
-		case SO_RCVTIMEO_NEW:
-		case SO_SNDTIMEO_OLD:
-		case SO_SNDTIMEO_NEW:
-		case SO_MARK:
-		case SO_INCOMING_CPU:
-		case SO_BINDTOIFINDEX:
-		case SO_BUSY_POLL:
-		case SO_PREFER_BUSY_POLL:
-		case SO_BUSY_POLL_BUDGET:
-
-		/* next ones are no-op for plain TCP */
-		case SO_NO_CHECK:
-		case SO_DONTROUTE:
-		case SO_BROADCAST:
-		case SO_BSDCOMPAT:
-		case SO_PASSCRED:
-		case SO_PASSSEC:
-		case SO_RXQ_OVFL:
-		case SO_WIFI_STATUS:
-		case SO_NOFCS:
-		case SO_SELECT_ERR_QUEUE:
-			return true;
-		}
-
-		/* SO_OOBINLINE is not supported, let's avoid the related mess */
-		/* SO_ATTACH_FILTER, SO_ATTACH_BPF, SO_ATTACH_REUSEPORT_CBPF,
-		 * SO_DETACH_REUSEPORT_BPF, SO_DETACH_FILTER, SO_LOCK_FILTER,
-		 * we must be careful with subflows
-		 */
-		/* SO_ATTACH_REUSEPORT_EBPF is not supported, at it checks
-		 * explicitly the sk_protocol field
-		 */
-		/* SO_PEEK_OFF is unsupported, as it is for plain TCP */
-		/* SO_MAX_PACING_RATE is unsupported, we must be careful with subflows */
-		/* SO_CNX_ADVICE is currently unsupported, could possibly be relevant,
-		 * but likely needs careful design
-		 */
-		/* SO_ZEROCOPY is currently unsupported, TODO in sndmsg */
-		/* SO_TXTIME is currently unsupported */
-		return false;
-	}
 	if (level == SOL_IP) {
 		switch (optname) {
 		/* should work fine */
@@ -624,12 +583,12 @@ int mptcp_setsockopt(struct sock *sk, int level, int optname,
 
 	pr_debug("msk=%p", msk);
 
-	if (!mptcp_supported_sockopt(level, optname))
-		return -ENOPROTOOPT;
-
 	if (level == SOL_SOCKET)
 		return mptcp_setsockopt_sol_socket(msk, optname, optval, optlen);
 
+	if (!mptcp_supported_sockopt(level, optname))
+		return -ENOPROTOOPT;
+
 	/* @@ the meaning of setsockopt() when the socket is connected and
 	 * there are multiple subflows is not yet defined. It is up to the
 	 * MPTCP-level socket to configure the subflows until the subflow
-- 
2.31.1

