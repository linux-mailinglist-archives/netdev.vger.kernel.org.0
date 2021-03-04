Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4253632C46A
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354927AbhCDANo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:13:44 -0500
Received: from orthanc.universe-factory.net ([104.238.176.138]:34778 "EHLO
        orthanc.universe-factory.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1452520AbhCCPvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 10:51:53 -0500
Received: from avalon.. (unknown [IPv6:2001:19f0:6c01:100::2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by orthanc.universe-factory.net (Postfix) with ESMTPSA id BB0AF1F5DB;
        Wed,  3 Mar 2021 16:51:05 +0100 (CET)
From:   Matthias Schiffer <mschiffer@universe-factory.net>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tom Parkin <tparkin@katalix.com>, linux-kernel@vger.kernel.org,
        Matthias Schiffer <mschiffer@universe-factory.net>
Subject: [PATCH net v2] net: l2tp: reduce log level of messages in receive path, add counter instead
Date:   Wed,  3 Mar 2021 16:50:49 +0100
Message-Id: <bd6f117b433969634b613153ec86ccd9d5fa3fb9.1614707999.git.mschiffer@universe-factory.net>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 5ee759cda51b ("l2tp: use standard API for warning log messages")
changed a number of warnings about invalid packets in the receive path
so that they are always shown, instead of only when a special L2TP debug
flag is set. Even with rate limiting these warnings can easily cause
significant log spam - potentially triggered by a malicious party
sending invalid packets on purpose.

In addition these warnings were noticed by projects like Tunneldigger [1],
which uses L2TP for its data path, but implements its own control
protocol (which is sufficiently different from L2TP data packets that it
would always be passed up to userspace even with future extensions of
L2TP).

Some of the warnings were already redundant, as l2tp_stats has a counter
for these packets. This commit adds one additional counter for invalid
packets that are passed up to userspace. Packets with unknown session are
not counted as invalid, as there is nothing wrong with the format of
these packets.

With the additional counter, all of these messages are either redundant
or benign, so we reduce them to pr_debug_ratelimited().

[1] https://github.com/wlanslovenija/tunneldigger/issues/160

Fixes: 5ee759cda51b ("l2tp: use standard API for warning log messages")
Signed-off-by: Matthias Schiffer <mschiffer@universe-factory.net>
---

v2:
- Add counter for invalid packets
- Reduce loglevel of more messages that can be abused for log spam

 include/uapi/linux/l2tp.h |  1 +
 net/l2tp/l2tp_core.c      | 41 +++++++++++++++++++++------------------
 net/l2tp/l2tp_core.h      |  1 +
 net/l2tp/l2tp_netlink.c   |  6 ++++++
 4 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/include/uapi/linux/l2tp.h b/include/uapi/linux/l2tp.h
index 30c80d5ba4bf..bab8c9708611 100644
--- a/include/uapi/linux/l2tp.h
+++ b/include/uapi/linux/l2tp.h
@@ -145,6 +145,7 @@ enum {
 	L2TP_ATTR_RX_ERRORS,		/* u64 */
 	L2TP_ATTR_STATS_PAD,
 	L2TP_ATTR_RX_COOKIE_DISCARDS,	/* u64 */
+	L2TP_ATTR_RX_INVALID,		/* u64 */
 	__L2TP_ATTR_STATS_MAX,
 };
 
diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 7be5103ff2a8..8ed889f44d23 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -649,9 +649,9 @@ void l2tp_recv_common(struct l2tp_session *session, struct sk_buff *skb,
 	/* Parse and check optional cookie */
 	if (session->peer_cookie_len > 0) {
 		if (memcmp(ptr, &session->peer_cookie[0], session->peer_cookie_len)) {
-			pr_warn_ratelimited("%s: cookie mismatch (%u/%u). Discarding.\n",
-					    tunnel->name, tunnel->tunnel_id,
-					    session->session_id);
+			pr_debug_ratelimited("%s: cookie mismatch (%u/%u). Discarding.\n",
+					     tunnel->name, tunnel->tunnel_id,
+					     session->session_id);
 			atomic_long_inc(&session->stats.rx_cookie_discards);
 			goto discard;
 		}
@@ -702,8 +702,8 @@ void l2tp_recv_common(struct l2tp_session *session, struct sk_buff *skb,
 		 * If user has configured mandatory sequence numbers, discard.
 		 */
 		if (session->recv_seq) {
-			pr_warn_ratelimited("%s: recv data has no seq numbers when required. Discarding.\n",
-					    session->name);
+			pr_debug_ratelimited("%s: recv data has no seq numbers when required. Discarding.\n",
+					     session->name);
 			atomic_long_inc(&session->stats.rx_seq_discards);
 			goto discard;
 		}
@@ -718,8 +718,8 @@ void l2tp_recv_common(struct l2tp_session *session, struct sk_buff *skb,
 			session->send_seq = 0;
 			l2tp_session_set_header_len(session, tunnel->version);
 		} else if (session->send_seq) {
-			pr_warn_ratelimited("%s: recv data has no seq numbers when required. Discarding.\n",
-					    session->name);
+			pr_debug_ratelimited("%s: recv data has no seq numbers when required. Discarding.\n",
+					     session->name);
 			atomic_long_inc(&session->stats.rx_seq_discards);
 			goto discard;
 		}
@@ -809,9 +809,9 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel *tunnel, struct sk_buff *skb)
 
 	/* Short packet? */
 	if (!pskb_may_pull(skb, L2TP_HDR_SIZE_MAX)) {
-		pr_warn_ratelimited("%s: recv short packet (len=%d)\n",
-				    tunnel->name, skb->len);
-		goto error;
+		pr_debug_ratelimited("%s: recv short packet (len=%d)\n",
+				     tunnel->name, skb->len);
+		goto invalid;
 	}
 
 	/* Point to L2TP header */
@@ -824,9 +824,9 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel *tunnel, struct sk_buff *skb)
 	/* Check protocol version */
 	version = hdrflags & L2TP_HDR_VER_MASK;
 	if (version != tunnel->version) {
-		pr_warn_ratelimited("%s: recv protocol version mismatch: got %d expected %d\n",
-				    tunnel->name, version, tunnel->version);
-		goto error;
+		pr_debug_ratelimited("%s: recv protocol version mismatch: got %d expected %d\n",
+				     tunnel->name, version, tunnel->version);
+		goto invalid;
 	}
 
 	/* Get length of L2TP packet */
@@ -834,7 +834,7 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel *tunnel, struct sk_buff *skb)
 
 	/* If type is control packet, it is handled by userspace. */
 	if (hdrflags & L2TP_HDRFLAG_T)
-		goto error;
+		goto pass;
 
 	/* Skip flags */
 	ptr += 2;
@@ -863,21 +863,24 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel *tunnel, struct sk_buff *skb)
 			l2tp_session_dec_refcount(session);
 
 		/* Not found? Pass to userspace to deal with */
-		pr_warn_ratelimited("%s: no session found (%u/%u). Passing up.\n",
-				    tunnel->name, tunnel_id, session_id);
-		goto error;
+		pr_debug_ratelimited("%s: no session found (%u/%u). Passing up.\n",
+				     tunnel->name, tunnel_id, session_id);
+		goto pass;
 	}
 
 	if (tunnel->version == L2TP_HDR_VER_3 &&
 	    l2tp_v3_ensure_opt_in_linear(session, skb, &ptr, &optr))
-		goto error;
+		goto invalid;
 
 	l2tp_recv_common(session, skb, ptr, optr, hdrflags, length);
 	l2tp_session_dec_refcount(session);
 
 	return 0;
 
-error:
+invalid:
+	atomic_long_inc(&tunnel->stats.rx_invalid);
+
+pass:
 	/* Put UDP header back */
 	__skb_push(skb, sizeof(struct udphdr));
 
diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index cb21d906343e..98ea98eb9567 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -39,6 +39,7 @@ struct l2tp_stats {
 	atomic_long_t		rx_oos_packets;
 	atomic_long_t		rx_errors;
 	atomic_long_t		rx_cookie_discards;
+	atomic_long_t		rx_invalid;
 };
 
 struct l2tp_tunnel;
diff --git a/net/l2tp/l2tp_netlink.c b/net/l2tp/l2tp_netlink.c
index 83956c9ee1fc..96eb91be9238 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -428,6 +428,9 @@ static int l2tp_nl_tunnel_send(struct sk_buff *skb, u32 portid, u32 seq, int fla
 			      L2TP_ATTR_STATS_PAD) ||
 	    nla_put_u64_64bit(skb, L2TP_ATTR_RX_ERRORS,
 			      atomic_long_read(&tunnel->stats.rx_errors),
+			      L2TP_ATTR_STATS_PAD) ||
+	    nla_put_u64_64bit(skb, L2TP_ATTR_RX_INVALID,
+			      atomic_long_read(&tunnel->stats.rx_invalid),
 			      L2TP_ATTR_STATS_PAD))
 		goto nla_put_failure;
 	nla_nest_end(skb, nest);
@@ -771,6 +774,9 @@ static int l2tp_nl_session_send(struct sk_buff *skb, u32 portid, u32 seq, int fl
 			      L2TP_ATTR_STATS_PAD) ||
 	    nla_put_u64_64bit(skb, L2TP_ATTR_RX_ERRORS,
 			      atomic_long_read(&session->stats.rx_errors),
+			      L2TP_ATTR_STATS_PAD) ||
+	    nla_put_u64_64bit(skb, L2TP_ATTR_RX_INVALID,
+			      atomic_long_read(&session->stats.rx_invalid),
 			      L2TP_ATTR_STATS_PAD))
 		goto nla_put_failure;
 	nla_nest_end(skb, nest);
-- 
2.30.1

