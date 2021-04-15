Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA13336166C
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 01:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237862AbhDOXpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 19:45:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:63174 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236589AbhDOXpc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 19:45:32 -0400
IronPort-SDR: /ejY7diZWuUbNwhF7D0TIKk8c2mOUr0ogfxDHSxHRigt5eYYmwhCebJ3JgVPZ98Ez2nblEOucd
 lMZJ+BgaX7Fw==
X-IronPort-AV: E=McAfee;i="6200,9189,9955"; a="215480154"
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="215480154"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2021 16:45:07 -0700
IronPort-SDR: 3KrRNt/vTrvfCpRS+Io6onEaz7KRh420SMTCFqcb/Bj+svsIuzGSXJuoSagsuoI5eGFOnwJVsk
 Gn7l3WghuCvA==
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="461793356"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.243.150])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2021 16:45:07 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 03/13] mptcp: only admit explicitly supported sockopt
Date:   Thu, 15 Apr 2021 16:44:52 -0700
Message-Id: <20210415234502.224225-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415234502.224225-1-mathew.j.martineau@linux.intel.com>
References: <20210415234502.224225-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Unrolling mcast state at msk dismantel time is bug prone, as
syzkaller reported:

======================================================
WARNING: possible circular locking dependency detected
5.11.0-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor905/8822 is trying to acquire lock:
ffffffff8d678fe8 (rtnl_mutex){+.+.}-{3:3}, at: ipv6_sock_mc_close+0xd7/0x110 net/ipv6/mcast.c:323

but task is already holding lock:
ffff888024390120 (sk_lock-AF_INET6){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1600 [inline]
ffff888024390120 (sk_lock-AF_INET6){+.+.}-{0:0}, at: mptcp6_release+0x57/0x130 net/mptcp/protocol.c:3507

which lock already depends on the new lock.

Instead we can simply forbid any mcast-related setsockopt.
Let's do the same with all other non supported sockopts.

Fixes: 717e79c867ca5 ("mptcp: Add setsockopt()/getsockopt() socket operations")
Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/sockopt.c | 216 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 216 insertions(+)

diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index 479f75653969..fb98fab252df 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -82,6 +82,219 @@ static int mptcp_setsockopt_v6(struct mptcp_sock *msk, int optname,
 	return ret;
 }
 
+static bool mptcp_supported_sockopt(int level, int optname)
+{
+	if (level == SOL_SOCKET) {
+		switch (optname) {
+		case SO_DEBUG:
+		case SO_REUSEPORT:
+		case SO_REUSEADDR:
+
+		/* the following ones need a better implementation,
+		 * but are quite common we want to preserve them
+		 */
+		case SO_BINDTODEVICE:
+		case SO_SNDBUF:
+		case SO_SNDBUFFORCE:
+		case SO_RCVBUF:
+		case SO_RCVBUFFORCE:
+		case SO_KEEPALIVE:
+		case SO_PRIORITY:
+		case SO_LINGER:
+		case SO_TIMESTAMP_OLD:
+		case SO_TIMESTAMP_NEW:
+		case SO_TIMESTAMPNS_OLD:
+		case SO_TIMESTAMPNS_NEW:
+		case SO_TIMESTAMPING_OLD:
+		case SO_TIMESTAMPING_NEW:
+		case SO_RCVLOWAT:
+		case SO_RCVTIMEO_OLD:
+		case SO_RCVTIMEO_NEW:
+		case SO_SNDTIMEO_OLD:
+		case SO_SNDTIMEO_NEW:
+		case SO_MARK:
+		case SO_INCOMING_CPU:
+		case SO_BINDTOIFINDEX:
+		case SO_BUSY_POLL:
+		case SO_PREFER_BUSY_POLL:
+		case SO_BUSY_POLL_BUDGET:
+
+		/* next ones are no-op for plain TCP */
+		case SO_NO_CHECK:
+		case SO_DONTROUTE:
+		case SO_BROADCAST:
+		case SO_BSDCOMPAT:
+		case SO_PASSCRED:
+		case SO_PASSSEC:
+		case SO_RXQ_OVFL:
+		case SO_WIFI_STATUS:
+		case SO_NOFCS:
+		case SO_SELECT_ERR_QUEUE:
+			return true;
+		}
+
+		/* SO_OOBINLINE is not supported, let's avoid the related mess */
+		/* SO_ATTACH_FILTER, SO_ATTACH_BPF, SO_ATTACH_REUSEPORT_CBPF,
+		 * SO_DETACH_REUSEPORT_BPF, SO_DETACH_FILTER, SO_LOCK_FILTER,
+		 * we must be careful with subflows
+		 */
+		/* SO_ATTACH_REUSEPORT_EBPF is not supported, at it checks
+		 * explicitly the sk_protocol field
+		 */
+		/* SO_PEEK_OFF is unsupported, as it is for plain TCP */
+		/* SO_MAX_PACING_RATE is unsupported, we must be careful with subflows */
+		/* SO_CNX_ADVICE is currently unsupported, could possibly be relevant,
+		 * but likely needs careful design
+		 */
+		/* SO_ZEROCOPY is currently unsupported, TODO in sndmsg */
+		/* SO_TXTIME is currently unsupported */
+		return false;
+	}
+	if (level == SOL_IP) {
+		switch (optname) {
+		/* should work fine */
+		case IP_FREEBIND:
+		case IP_TRANSPARENT:
+
+		/* the following are control cmsg related */
+		case IP_PKTINFO:
+		case IP_RECVTTL:
+		case IP_RECVTOS:
+		case IP_RECVOPTS:
+		case IP_RETOPTS:
+		case IP_PASSSEC:
+		case IP_RECVORIGDSTADDR:
+		case IP_CHECKSUM:
+		case IP_RECVFRAGSIZE:
+
+		/* common stuff that need some love */
+		case IP_TOS:
+		case IP_TTL:
+		case IP_BIND_ADDRESS_NO_PORT:
+		case IP_MTU_DISCOVER:
+		case IP_RECVERR:
+
+		/* possibly less common may deserve some love */
+		case IP_MINTTL:
+
+		/* the following is apparently a no-op for plain TCP */
+		case IP_RECVERR_RFC4884:
+			return true;
+		}
+
+		/* IP_OPTIONS is not supported, needs subflow care */
+		/* IP_HDRINCL, IP_NODEFRAG are not supported, RAW specific */
+		/* IP_MULTICAST_TTL, IP_MULTICAST_LOOP, IP_UNICAST_IF,
+		 * IP_ADD_MEMBERSHIP, IP_ADD_SOURCE_MEMBERSHIP, IP_DROP_MEMBERSHIP,
+		 * IP_DROP_SOURCE_MEMBERSHIP, IP_BLOCK_SOURCE, IP_UNBLOCK_SOURCE,
+		 * MCAST_JOIN_GROUP, MCAST_LEAVE_GROUP MCAST_JOIN_SOURCE_GROUP,
+		 * MCAST_LEAVE_SOURCE_GROUP, MCAST_BLOCK_SOURCE, MCAST_UNBLOCK_SOURCE,
+		 * MCAST_MSFILTER, IP_MULTICAST_ALL are not supported, better not deal
+		 * with mcast stuff
+		 */
+		/* IP_IPSEC_POLICY, IP_XFRM_POLICY are nut supported, unrelated here */
+		return false;
+	}
+	if (level == SOL_IPV6) {
+		switch (optname) {
+		case IPV6_V6ONLY:
+
+		/* the following are control cmsg related */
+		case IPV6_RECVPKTINFO:
+		case IPV6_2292PKTINFO:
+		case IPV6_RECVHOPLIMIT:
+		case IPV6_2292HOPLIMIT:
+		case IPV6_RECVRTHDR:
+		case IPV6_2292RTHDR:
+		case IPV6_RECVHOPOPTS:
+		case IPV6_2292HOPOPTS:
+		case IPV6_RECVDSTOPTS:
+		case IPV6_2292DSTOPTS:
+		case IPV6_RECVTCLASS:
+		case IPV6_FLOWINFO:
+		case IPV6_RECVPATHMTU:
+		case IPV6_RECVORIGDSTADDR:
+		case IPV6_RECVFRAGSIZE:
+
+		/* the following ones need some love but are quite common */
+		case IPV6_TCLASS:
+		case IPV6_TRANSPARENT:
+		case IPV6_FREEBIND:
+		case IPV6_PKTINFO:
+		case IPV6_2292PKTOPTIONS:
+		case IPV6_UNICAST_HOPS:
+		case IPV6_MTU_DISCOVER:
+		case IPV6_MTU:
+		case IPV6_RECVERR:
+		case IPV6_FLOWINFO_SEND:
+		case IPV6_FLOWLABEL_MGR:
+		case IPV6_MINHOPCOUNT:
+		case IPV6_DONTFRAG:
+		case IPV6_AUTOFLOWLABEL:
+
+		/* the following one is a no-op for plain TCP */
+		case IPV6_RECVERR_RFC4884:
+			return true;
+		}
+
+		/* IPV6_HOPOPTS, IPV6_RTHDRDSTOPTS, IPV6_RTHDR, IPV6_DSTOPTS are
+		 * not supported
+		 */
+		/* IPV6_MULTICAST_HOPS, IPV6_MULTICAST_LOOP, IPV6_UNICAST_IF,
+		 * IPV6_MULTICAST_IF, IPV6_ADDRFORM,
+		 * IPV6_ADD_MEMBERSHIP, IPV6_DROP_MEMBERSHIP, IPV6_JOIN_ANYCAST,
+		 * IPV6_LEAVE_ANYCAST, IPV6_MULTICAST_ALL, MCAST_JOIN_GROUP, MCAST_LEAVE_GROUP,
+		 * MCAST_JOIN_SOURCE_GROUP, MCAST_LEAVE_SOURCE_GROUP,
+		 * MCAST_BLOCK_SOURCE, MCAST_UNBLOCK_SOURCE, MCAST_MSFILTER
+		 * are not supported better not deal with mcast
+		 */
+		/* IPV6_ROUTER_ALERT, IPV6_ROUTER_ALERT_ISOLATE are not supported, since are evil */
+
+		/* IPV6_IPSEC_POLICY, IPV6_XFRM_POLICY are not supported */
+		/* IPV6_ADDR_PREFERENCES is not supported, we must be careful with subflows */
+		return false;
+	}
+	if (level == SOL_TCP) {
+		switch (optname) {
+		/* the following are no-op or should work just fine */
+		case TCP_THIN_DUPACK:
+		case TCP_DEFER_ACCEPT:
+
+		/* the following need some love */
+		case TCP_MAXSEG:
+		case TCP_NODELAY:
+		case TCP_THIN_LINEAR_TIMEOUTS:
+		case TCP_CONGESTION:
+		case TCP_ULP:
+		case TCP_CORK:
+		case TCP_KEEPIDLE:
+		case TCP_KEEPINTVL:
+		case TCP_KEEPCNT:
+		case TCP_SYNCNT:
+		case TCP_SAVE_SYN:
+		case TCP_LINGER2:
+		case TCP_WINDOW_CLAMP:
+		case TCP_QUICKACK:
+		case TCP_USER_TIMEOUT:
+		case TCP_TIMESTAMP:
+		case TCP_NOTSENT_LOWAT:
+		case TCP_TX_DELAY:
+			return true;
+		}
+
+		/* TCP_MD5SIG, TCP_MD5SIG_EXT are not supported, MD5 is not compatible with MPTCP */
+
+		/* TCP_REPAIR, TCP_REPAIR_QUEUE, TCP_QUEUE_SEQ, TCP_REPAIR_OPTIONS,
+		 * TCP_REPAIR_WINDOW are not supported, better avoid this mess
+		 */
+		/* TCP_FASTOPEN_KEY, TCP_FASTOPEN TCP_FASTOPEN_CONNECT, TCP_FASTOPEN_NO_COOKIE,
+		 * are not supported fastopen is currently unsupported
+		 */
+		/* TCP_INQ is currently unsupported, needs some recvmsg work */
+	}
+	return false;
+}
+
 int mptcp_setsockopt(struct sock *sk, int level, int optname,
 		     sockptr_t optval, unsigned int optlen)
 {
@@ -90,6 +303,9 @@ int mptcp_setsockopt(struct sock *sk, int level, int optname,
 
 	pr_debug("msk=%p", msk);
 
+	if (!mptcp_supported_sockopt(level, optname))
+		return -ENOPROTOOPT;
+
 	if (level == SOL_SOCKET)
 		return mptcp_setsockopt_sol_socket(msk, optname, optval, optlen);
 
-- 
2.31.1

