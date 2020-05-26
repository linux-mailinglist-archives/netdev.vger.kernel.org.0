Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA641E1ED7
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 11:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388713AbgEZJjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 05:39:14 -0400
Received: from mail-db8eur05on2125.outbound.protection.outlook.com ([40.107.20.125]:25953
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388460AbgEZJjN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 05:39:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hoVsOhef5LeZYpGtnPLYNYdqef8HzBGc7xWoe2vAHKA3TApdZC181qL9Y2Nw7ls4Jcxcvc0cEVB0csNUt1sSVzPz1YYPqszqnAGukdt4aKxEloEDrjECpH5WuGEKJhJnoialw73PL3fuzwW1PxEedddCerJkXp3+482F84CqOWlP0yRRHnI6V+xPA7LFgIdPVVbIsaEzbdu3/uF77v93P8NNE6aS/Crz8v5JGh45z9BlcPN/xiVzvVv7vo4yfVjB5k9slGqNB2oAUCxYqE0C2fMZRrA4ge3VwFVhwojCbZ+BynkxbaCQcWogvFqxiHeM378euT4WH+nu8ZqFa3Jw2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YZgnXiJWAJQ1BJ20fpHt90xan4ymmSixFTEukR17O+Q=;
 b=dLnQ1V7tEjlYsntNxSDMV8NBQhpbR+oXtni2Ue+BEcetf1o18cJdsQQZVAcFVa4NTosummzGbpLfM7Uwzy3NTFFJrX0/O3tGaHD81EZHiPEJPfvbNaCr5x+qsDxs53QftiIYWnQ13ur1/mhGMGxqhQPsGiDAud1yTniN3Z3UuQRSDPqqNlLXLXTKP2SQKqpeu14xHvnu2rylcl+zK2jV847ZClhknNtEI3SQBadoyDe4Im+Tq3FwxXHbFAJg94fhW9pNWKUFhPgZKkpPd7LqZ6PqIRzy1rS+n2dqbw27zZjA3MUfgzOUCtcHp0igu+Xq+tPEQVvdI9KYD+wvOOHvEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YZgnXiJWAJQ1BJ20fpHt90xan4ymmSixFTEukR17O+Q=;
 b=wAJImoTQ9JsS5rVcaRH0IuhwriZOIHdWM5PM+74B94uGJV86wy+rj8bObPAdjR7QxRRFkhEQl5IA5RqAV+WZagdgwm3ED7h50Nm2RjCKB5r+OIovVpU/Gpwlpwgd4YSGG+XXk7kISo17fGZstHU4S4XQfyWdox5jWXm+bMNBY4Y=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=dektech.com.au;
Received: from AM6PR0502MB3925.eurprd05.prod.outlook.com (2603:10a6:209:5::28)
 by AM6PR0502MB3718.eurprd05.prod.outlook.com (2603:10a6:209:11::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Tue, 26 May
 2020 09:38:57 +0000
Received: from AM6PR0502MB3925.eurprd05.prod.outlook.com
 ([fe80::4d5f:2ab:5a66:deaf]) by AM6PR0502MB3925.eurprd05.prod.outlook.com
 ([fe80::4d5f:2ab:5a66:deaf%7]) with mapi id 15.20.3021.029; Tue, 26 May 2020
 09:38:57 +0000
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jmaloy@redhat.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [net-next 4/5] tipc: add support for broadcast rcv stats dumping
Date:   Tue, 26 May 2020 16:38:37 +0700
Message-Id: <20200526093838.17421-5-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20200526093838.17421-1-tuong.t.lien@dektech.com.au>
References: <20200526093838.17421-1-tuong.t.lien@dektech.com.au>
Content-Type: text/plain
X-ClientProxiedBy: HK2PR03CA0060.apcprd03.prod.outlook.com
 (2603:1096:202:17::30) To AM6PR0502MB3925.eurprd05.prod.outlook.com
 (2603:10a6:209:5::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (14.161.14.188) by HK2PR03CA0060.apcprd03.prod.outlook.com (2603:1096:202:17::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3045.8 via Frontend Transport; Tue, 26 May 2020 09:38:54 +0000
X-Mailer: git-send-email 2.13.7
X-Originating-IP: [14.161.14.188]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28b76398-0668-4a54-44ad-08d801589c8c
X-MS-TrafficTypeDiagnostic: AM6PR0502MB3718:
X-Microsoft-Antispam-PRVS: <AM6PR0502MB3718A6086E0271941159820DE2B00@AM6PR0502MB3718.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:67;
X-Forefront-PRVS: 041517DFAB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gjJOFor/6FZXTAdYiDsnaPJs5/Nn9x3iL1SoHyqMx38P/ZkdTNZx1QCEdoxtZgImBpQfmQcvWmGJlwrBRVCNTWWV4AJuOfcrfN3mWO/R7F4D26O3QOMaTccu9C7Uiauh8RyCa/OI97QEZx3QO5tbnQOSBsYtb5S79NNbHAWWDJkiJ78why5OfWf73dJvNAIxYUv3CJAw2usyvxng9o90zSXOPennrEY2N2WF9WxnimIWteWTHqKiwZU5J+gn49Jkl60Pb9OHQR8+p636r1pEuRAqG4f64jugVtKqi3NcmwX4KfucS0uoQAmuohFtFNQ+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0502MB3925.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(346002)(366004)(376002)(136003)(39850400004)(8676002)(16526019)(956004)(2616005)(103116003)(55016002)(186003)(6666004)(4326008)(66476007)(66556008)(2906002)(86362001)(36756003)(316002)(5660300002)(30864003)(26005)(66946007)(8936002)(52116002)(1076003)(478600001)(7696005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: zZBcYfl14zRFfgGrkfIUoCFsW52tqWsX/RrHUsjUYtjqUvXep5nCeWrbZwIXbxnYZUkRAtQJsLY19R0n/EZ9h0TJpjlZTbdsQgtqrlVJoFYxZKV8SawEyeIQ/Si/ahNpWTJNJonCGbQ5vQCfg7KrgOqJujKqqpYYJE43nXml+0w2PTHCF30HQEpIVCzenc5dI/zEdyqdIjkZCCpqr+TTfvobLWzKz9EaTZx1gWc9z+wfSAQmUc4d+/h7UVBYGtnhw503v7/rs1sorCTOju910Udw6vwO1qxYUoH3mTP15JvWHs9znrtbnsNzENbGmKrW0LwYTmfe18HgbL2WbN6e1+XKXPDQ2OCPniL7IiJGGWLDSilNKChTlrmzSV3b24yx0+DAmvnmhf4b3oe+8qaNwXXYaghvdubxENVzTTz47fZX2L06tL8C24qiG3FAW1T8X4YepMNzzrTNS3AYHCDo3Uje3AkjlzYzqcXgflKhMS4=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: 28b76398-0668-4a54-44ad-08d801589c8c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2020 09:38:57.1911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JXyZH3hESR4YntxqOuxSItEWPVhGYcnpd4YmwAKNzzrZ08iTevnvWOkaTYihuHiScis6J7Cgbm2pXt3+Y00DtmrRaIelBm0YbltszP7UM2M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0502MB3718
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit enables dumping the statistics of a broadcast-receiver link
like the traditional 'broadcast-link' one (which is for broadcast-
sender). The link dumping can be triggered via netlink (e.g. the
iproute2/tipc tool) by the link flag - 'TIPC_NLA_LINK_BROADCAST' as the
indicator.

The name of a broadcast-receiver link of a specific peer will be in the
format: 'broadcast-link:<peer-id>'.

For example:

Link <broadcast-link:1001002>
  Window:50 packets
  RX packets:7841 fragments:2408/440 bundles:0/0
  TX packets:0 fragments:0/0 bundles:0/0
  RX naks:0 defs:124 dups:0
  TX naks:21 acks:0 retrans:0
  Congestion link:0  Send queue max:0 avg:0

In addition, the broadcast-receiver link statistics can be reset in the
usual way via netlink by specifying that link name in command.

Note: the 'tipc_link_name_ext()' is removed because the link name can
now be retrieved simply via the 'l->name'.

Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
---
 net/tipc/bcast.c   |  6 ++---
 net/tipc/bcast.h   |  5 +++--
 net/tipc/link.c    | 65 +++++++++++++++++++++++++++---------------------------
 net/tipc/link.h    |  3 +--
 net/tipc/msg.c     |  9 ++++----
 net/tipc/msg.h     |  2 +-
 net/tipc/netlink.c |  2 +-
 net/tipc/node.c    | 61 +++++++++++++++++++++++++++++++++++++++++++-------
 net/tipc/trace.h   |  4 ++--
 9 files changed, 101 insertions(+), 56 deletions(-)

diff --git a/net/tipc/bcast.c b/net/tipc/bcast.c
index 50a16f8bebd9..383f87bc1061 100644
--- a/net/tipc/bcast.c
+++ b/net/tipc/bcast.c
@@ -563,10 +563,8 @@ void tipc_bcast_remove_peer(struct net *net, struct tipc_link *rcv_l)
 		tipc_sk_rcv(net, inputq);
 }
 
-int tipc_bclink_reset_stats(struct net *net)
+int tipc_bclink_reset_stats(struct net *net, struct tipc_link *l)
 {
-	struct tipc_link *l = tipc_bc_sndlink(net);
-
 	if (!l)
 		return -ENOPROTOOPT;
 
@@ -694,7 +692,7 @@ int tipc_bcast_init(struct net *net)
 	tn->bcbase = bb;
 	spin_lock_init(&tipc_net(net)->bclock);
 
-	if (!tipc_link_bc_create(net, 0, 0,
+	if (!tipc_link_bc_create(net, 0, 0, NULL,
 				 FB_MTU,
 				 BCLINK_WIN_DEFAULT,
 				 BCLINK_WIN_DEFAULT,
diff --git a/net/tipc/bcast.h b/net/tipc/bcast.h
index 97d3cf9d3e4d..4240c95188b1 100644
--- a/net/tipc/bcast.h
+++ b/net/tipc/bcast.h
@@ -96,9 +96,10 @@ void tipc_bcast_ack_rcv(struct net *net, struct tipc_link *l,
 int tipc_bcast_sync_rcv(struct net *net, struct tipc_link *l,
 			struct tipc_msg *hdr,
 			struct sk_buff_head *retrq);
-int tipc_nl_add_bc_link(struct net *net, struct tipc_nl_msg *msg);
+int tipc_nl_add_bc_link(struct net *net, struct tipc_nl_msg *msg,
+			struct tipc_link *bcl);
 int tipc_nl_bc_link_set(struct net *net, struct nlattr *attrs[]);
-int tipc_bclink_reset_stats(struct net *net);
+int tipc_bclink_reset_stats(struct net *net, struct tipc_link *l);
 
 u32 tipc_bcast_get_broadcast_mode(struct net *net);
 u32 tipc_bcast_get_broadcast_ratio(struct net *net);
diff --git a/net/tipc/link.c b/net/tipc/link.c
index af352391e2ab..ee3b8d0576b8 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -539,7 +539,7 @@ bool tipc_link_create(struct net *net, char *if_name, int bearer_id,
  *
  * Returns true if link was created, otherwise false
  */
-bool tipc_link_bc_create(struct net *net, u32 ownnode, u32 peer,
+bool tipc_link_bc_create(struct net *net, u32 ownnode, u32 peer, u8 *peer_id,
 			 int mtu, u32 min_win, u32 max_win, u16 peer_caps,
 			 struct sk_buff_head *inputq,
 			 struct sk_buff_head *namedq,
@@ -554,7 +554,18 @@ bool tipc_link_bc_create(struct net *net, u32 ownnode, u32 peer,
 		return false;
 
 	l = *link;
-	strcpy(l->name, tipc_bclink_name);
+	if (peer_id) {
+		char peer_str[NODE_ID_STR_LEN] = {0,};
+
+		tipc_nodeid2string(peer_str, peer_id);
+		if (strlen(peer_str) > 16)
+			sprintf(peer_str, "%x", peer);
+		/* Broadcast receiver link name: "broadcast-link:<peer>" */
+		snprintf(l->name, sizeof(l->name), "%s:%s", tipc_bclink_name,
+			 peer_str);
+	} else {
+		strcpy(l->name, tipc_bclink_name);
+	}
 	trace_tipc_link_reset(l, TIPC_DUMP_ALL, "bclink created!");
 	tipc_link_reset(l);
 	l->state = LINK_RESET;
@@ -1412,11 +1423,8 @@ static u8 __tipc_build_gap_ack_blks(struct tipc_gap_ack_blks *ga,
 			gacks[n].ack = htons(expect - 1);
 			gacks[n].gap = htons(seqno - expect);
 			if (++n >= MAX_GAP_ACK_BLKS / 2) {
-				char buf[TIPC_MAX_LINK_NAME];
-
 				pr_info_ratelimited("Gacks on %s: %d, ql: %d!\n",
-						    tipc_link_name_ext(l, buf),
-						    n,
+						    l->name, n,
 						    skb_queue_len(&l->deferdq));
 				return n;
 			}
@@ -1587,6 +1595,8 @@ static int tipc_link_advance_transmq(struct tipc_link *l, struct tipc_link *r,
 			_skb->priority = TC_PRIO_CONTROL;
 			__skb_queue_tail(xmitq, _skb);
 			l->stats.retransmitted++;
+			if (!is_uc)
+				r->stats.retransmitted++;
 			*retransmitted = true;
 			/* Increase actual retrans counter & mark first time */
 			if (!TIPC_SKB_CB(skb)->retr_cnt++)
@@ -1753,7 +1763,8 @@ int tipc_link_rcv(struct tipc_link *l, struct sk_buff *skb,
 
 		/* Defer delivery if sequence gap */
 		if (unlikely(seqno != rcv_nxt)) {
-			__tipc_skb_queue_sorted(defq, seqno, skb);
+			if (!__tipc_skb_queue_sorted(defq, seqno, skb))
+				l->stats.duplicates++;
 			rc |= tipc_link_build_nack_msg(l, xmitq);
 			break;
 		}
@@ -1787,15 +1798,15 @@ static void tipc_link_build_proto_msg(struct tipc_link *l, int mtyp, bool probe,
 				      int tolerance, int priority,
 				      struct sk_buff_head *xmitq)
 {
+	struct tipc_mon_state *mstate = &l->mon_state;
+	struct sk_buff_head *dfq = &l->deferdq;
 	struct tipc_link *bcl = l->bc_rcvlink;
-	struct sk_buff *skb;
 	struct tipc_msg *hdr;
-	struct sk_buff_head *dfq = &l->deferdq;
+	struct sk_buff *skb;
 	bool node_up = link_is_up(bcl);
-	struct tipc_mon_state *mstate = &l->mon_state;
+	u16 glen = 0, bc_rcvgap = 0;
 	int dlen = 0;
 	void *data;
-	u16 glen = 0;
 
 	/* Don't send protocol message during reset or link failover */
 	if (tipc_link_is_blocked(l))
@@ -1833,7 +1844,8 @@ static void tipc_link_build_proto_msg(struct tipc_link *l, int mtyp, bool probe,
 		if (l->peer_caps & TIPC_LINK_PROTO_SEQNO)
 			msg_set_seqno(hdr, l->snd_nxt_state++);
 		msg_set_seq_gap(hdr, rcvgap);
-		msg_set_bc_gap(hdr, link_bc_rcv_gap(bcl));
+		bc_rcvgap = link_bc_rcv_gap(bcl);
+		msg_set_bc_gap(hdr, bc_rcvgap);
 		msg_set_probe(hdr, probe);
 		msg_set_is_keepalive(hdr, probe || probe_reply);
 		if (l->peer_caps & TIPC_GAP_ACK_BLOCK)
@@ -1858,6 +1870,8 @@ static void tipc_link_build_proto_msg(struct tipc_link *l, int mtyp, bool probe,
 		l->stats.sent_probes++;
 	if (rcvgap)
 		l->stats.sent_nacks++;
+	if (bc_rcvgap)
+		bcl->stats.sent_nacks++;
 	skb->priority = TC_PRIO_CONTROL;
 	__skb_queue_tail(xmitq, skb);
 	trace_tipc_proto_build(skb, false, l->name);
@@ -2358,8 +2372,6 @@ int tipc_link_bc_sync_rcv(struct tipc_link *l, struct tipc_msg *hdr,
 	if (!l->bc_peer_is_up)
 		return rc;
 
-	l->stats.recv_nacks++;
-
 	/* Ignore if peers_snd_nxt goes beyond receive window */
 	if (more(peers_snd_nxt, l->rcv_nxt + l->window))
 		return rc;
@@ -2410,6 +2422,11 @@ int tipc_link_bc_ack_rcv(struct tipc_link *r, u16 acked, u16 gap,
 	if (!link_is_up(r) || !r->bc_peer_is_up)
 		return 0;
 
+	if (gap) {
+		l->stats.recv_nacks++;
+		r->stats.recv_nacks++;
+	}
+
 	if (less(acked, r->acked) || (acked == r->acked && !gap && !ga))
 		return 0;
 
@@ -2721,16 +2738,15 @@ static int __tipc_nl_add_bc_link_stat(struct sk_buff *skb,
 	return -EMSGSIZE;
 }
 
-int tipc_nl_add_bc_link(struct net *net, struct tipc_nl_msg *msg)
+int tipc_nl_add_bc_link(struct net *net, struct tipc_nl_msg *msg,
+			struct tipc_link *bcl)
 {
 	int err;
 	void *hdr;
 	struct nlattr *attrs;
 	struct nlattr *prop;
-	struct tipc_net *tn = net_generic(net, tipc_net_id);
 	u32 bc_mode = tipc_bcast_get_broadcast_mode(net);
 	u32 bc_ratio = tipc_bcast_get_broadcast_ratio(net);
-	struct tipc_link *bcl = tn->bcl;
 
 	if (!bcl)
 		return 0;
@@ -2817,21 +2833,6 @@ void tipc_link_set_abort_limit(struct tipc_link *l, u32 limit)
 	l->abort_limit = limit;
 }
 
-char *tipc_link_name_ext(struct tipc_link *l, char *buf)
-{
-	if (!l)
-		scnprintf(buf, TIPC_MAX_LINK_NAME, "null");
-	else if (link_is_bc_sndlink(l))
-		scnprintf(buf, TIPC_MAX_LINK_NAME, "broadcast-sender");
-	else if (link_is_bc_rcvlink(l))
-		scnprintf(buf, TIPC_MAX_LINK_NAME,
-			  "broadcast-receiver, peer %x", l->addr);
-	else
-		memcpy(buf, l->name, TIPC_MAX_LINK_NAME);
-
-	return buf;
-}
-
 /**
  * tipc_link_dump - dump TIPC link data
  * @l: tipc link to be dumped
diff --git a/net/tipc/link.h b/net/tipc/link.h
index 4d0768cf91d5..fc07232c9a12 100644
--- a/net/tipc/link.h
+++ b/net/tipc/link.h
@@ -80,7 +80,7 @@ bool tipc_link_create(struct net *net, char *if_name, int bearer_id,
 		      struct sk_buff_head *inputq,
 		      struct sk_buff_head *namedq,
 		      struct tipc_link **link);
-bool tipc_link_bc_create(struct net *net, u32 ownnode, u32 peer,
+bool tipc_link_bc_create(struct net *net, u32 ownnode, u32 peer, u8 *peer_id,
 			 int mtu, u32 min_win, u32 max_win, u16 peer_caps,
 			 struct sk_buff_head *inputq,
 			 struct sk_buff_head *namedq,
@@ -111,7 +111,6 @@ u16 tipc_link_rcv_nxt(struct tipc_link *l);
 u16 tipc_link_acked(struct tipc_link *l);
 u32 tipc_link_id(struct tipc_link *l);
 char *tipc_link_name(struct tipc_link *l);
-char *tipc_link_name_ext(struct tipc_link *l, char *buf);
 u32 tipc_link_state(struct tipc_link *l);
 char tipc_link_plane(struct tipc_link *l);
 int tipc_link_prio(struct tipc_link *l);
diff --git a/net/tipc/msg.c b/net/tipc/msg.c
index 4d0e0bdd997b..c69fb99163fc 100644
--- a/net/tipc/msg.c
+++ b/net/tipc/msg.c
@@ -825,19 +825,19 @@ bool tipc_msg_pskb_copy(u32 dst, struct sk_buff_head *msg,
  * @seqno: sequence number of buffer to add
  * @skb: buffer to add
  */
-void __tipc_skb_queue_sorted(struct sk_buff_head *list, u16 seqno,
+bool __tipc_skb_queue_sorted(struct sk_buff_head *list, u16 seqno,
 			     struct sk_buff *skb)
 {
 	struct sk_buff *_skb, *tmp;
 
 	if (skb_queue_empty(list) || less(seqno, buf_seqno(skb_peek(list)))) {
 		__skb_queue_head(list, skb);
-		return;
+		return true;
 	}
 
 	if (more(seqno, buf_seqno(skb_peek_tail(list)))) {
 		__skb_queue_tail(list, skb);
-		return;
+		return true;
 	}
 
 	skb_queue_walk_safe(list, _skb, tmp) {
@@ -846,9 +846,10 @@ void __tipc_skb_queue_sorted(struct sk_buff_head *list, u16 seqno,
 		if (seqno == buf_seqno(_skb))
 			break;
 		__skb_queue_before(list, _skb, skb);
-		return;
+		return true;
 	}
 	kfree_skb(skb);
+	return false;
 }
 
 void tipc_skb_reject(struct net *net, int err, struct sk_buff *skb,
diff --git a/net/tipc/msg.h b/net/tipc/msg.h
index ca5f8689a33b..cd4281779468 100644
--- a/net/tipc/msg.h
+++ b/net/tipc/msg.h
@@ -1145,7 +1145,7 @@ bool tipc_msg_assemble(struct sk_buff_head *list);
 bool tipc_msg_reassemble(struct sk_buff_head *list, struct sk_buff_head *rcvq);
 bool tipc_msg_pskb_copy(u32 dst, struct sk_buff_head *msg,
 			struct sk_buff_head *cpy);
-void __tipc_skb_queue_sorted(struct sk_buff_head *list, u16 seqno,
+bool __tipc_skb_queue_sorted(struct sk_buff_head *list, u16 seqno,
 			     struct sk_buff *skb);
 bool tipc_msg_skb_clone(struct sk_buff_head *msg, struct sk_buff_head *cpy);
 
diff --git a/net/tipc/netlink.c b/net/tipc/netlink.c
index bb9862410e68..c4aee6247d55 100644
--- a/net/tipc/netlink.c
+++ b/net/tipc/netlink.c
@@ -188,7 +188,7 @@ static const struct genl_ops tipc_genl_v2_ops[] = {
 	},
 	{
 		.cmd	= TIPC_NL_LINK_GET,
-		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.validate = GENL_DONT_VALIDATE_STRICT,
 		.doit   = tipc_nl_node_get_link,
 		.dumpit	= tipc_nl_node_dump_link,
 	},
diff --git a/net/tipc/node.c b/net/tipc/node.c
index 548207fdec15..0312fb181d94 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -1138,7 +1138,7 @@ void tipc_node_check_dest(struct net *net, u32 addr,
 	if (unlikely(!n->bc_entry.link)) {
 		snd_l = tipc_bc_sndlink(net);
 		if (!tipc_link_bc_create(net, tipc_own_addr(net),
-					 addr, U16_MAX,
+					 addr, peer_id, U16_MAX,
 					 tipc_link_min_win(snd_l),
 					 tipc_link_max_win(snd_l),
 					 n->capabilities,
@@ -2435,7 +2435,7 @@ int tipc_nl_node_get_link(struct sk_buff *skb, struct genl_info *info)
 		return -ENOMEM;
 
 	if (strcmp(name, tipc_bclink_name) == 0) {
-		err = tipc_nl_add_bc_link(net, &msg);
+		err = tipc_nl_add_bc_link(net, &msg, tipc_net(net)->bcl);
 		if (err)
 			goto err_free;
 	} else {
@@ -2479,6 +2479,7 @@ int tipc_nl_node_reset_link_stats(struct sk_buff *skb, struct genl_info *info)
 	struct tipc_node *node;
 	struct nlattr *attrs[TIPC_NLA_LINK_MAX + 1];
 	struct net *net = sock_net(skb->sk);
+	struct tipc_net *tn = tipc_net(net);
 	struct tipc_link_entry *le;
 
 	if (!info->attrs[TIPC_NLA_LINK])
@@ -2495,11 +2496,26 @@ int tipc_nl_node_reset_link_stats(struct sk_buff *skb, struct genl_info *info)
 
 	link_name = nla_data(attrs[TIPC_NLA_LINK_NAME]);
 
-	if (strcmp(link_name, tipc_bclink_name) == 0) {
-		err = tipc_bclink_reset_stats(net);
+	err = -EINVAL;
+	if (!strcmp(link_name, tipc_bclink_name)) {
+		err = tipc_bclink_reset_stats(net, tipc_bc_sndlink(net));
 		if (err)
 			return err;
 		return 0;
+	} else if (strstr(link_name, tipc_bclink_name)) {
+		rcu_read_lock();
+		list_for_each_entry_rcu(node, &tn->node_list, list) {
+			tipc_node_read_lock(node);
+			link = node->bc_entry.link;
+			if (link && !strcmp(link_name, tipc_link_name(link))) {
+				err = tipc_bclink_reset_stats(net, link);
+				tipc_node_read_unlock(node);
+				break;
+			}
+			tipc_node_read_unlock(node);
+		}
+		rcu_read_unlock();
+		return err;
 	}
 
 	node = tipc_node_find_by_name(net, link_name, &bearer_id);
@@ -2523,7 +2539,8 @@ int tipc_nl_node_reset_link_stats(struct sk_buff *skb, struct genl_info *info)
 
 /* Caller should hold node lock  */
 static int __tipc_nl_add_node_links(struct net *net, struct tipc_nl_msg *msg,
-				    struct tipc_node *node, u32 *prev_link)
+				    struct tipc_node *node, u32 *prev_link,
+				    bool bc_link)
 {
 	u32 i;
 	int err;
@@ -2539,6 +2556,14 @@ static int __tipc_nl_add_node_links(struct net *net, struct tipc_nl_msg *msg,
 		if (err)
 			return err;
 	}
+
+	if (bc_link) {
+		*prev_link = i;
+		err = tipc_nl_add_bc_link(net, msg, node->bc_entry.link);
+		if (err)
+			return err;
+	}
+
 	*prev_link = 0;
 
 	return 0;
@@ -2547,17 +2572,36 @@ static int __tipc_nl_add_node_links(struct net *net, struct tipc_nl_msg *msg,
 int tipc_nl_node_dump_link(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct net *net = sock_net(skb->sk);
+	struct nlattr **attrs = genl_dumpit_info(cb)->attrs;
+	struct nlattr *link[TIPC_NLA_LINK_MAX + 1];
 	struct tipc_net *tn = net_generic(net, tipc_net_id);
 	struct tipc_node *node;
 	struct tipc_nl_msg msg;
 	u32 prev_node = cb->args[0];
 	u32 prev_link = cb->args[1];
 	int done = cb->args[2];
+	bool bc_link = cb->args[3];
 	int err;
 
 	if (done)
 		return 0;
 
+	if (!prev_node) {
+		/* Check if broadcast-receiver links dumping is needed */
+		if (attrs && attrs[TIPC_NLA_LINK]) {
+			err = nla_parse_nested_deprecated(link,
+							  TIPC_NLA_LINK_MAX,
+							  attrs[TIPC_NLA_LINK],
+							  tipc_nl_link_policy,
+							  NULL);
+			if (unlikely(err))
+				return err;
+			if (unlikely(!link[TIPC_NLA_LINK_BROADCAST]))
+				return -EINVAL;
+			bc_link = true;
+		}
+	}
+
 	msg.skb = skb;
 	msg.portid = NETLINK_CB(cb->skb).portid;
 	msg.seq = cb->nlh->nlmsg_seq;
@@ -2581,7 +2625,7 @@ int tipc_nl_node_dump_link(struct sk_buff *skb, struct netlink_callback *cb)
 						 list) {
 			tipc_node_read_lock(node);
 			err = __tipc_nl_add_node_links(net, &msg, node,
-						       &prev_link);
+						       &prev_link, bc_link);
 			tipc_node_read_unlock(node);
 			if (err)
 				goto out;
@@ -2589,14 +2633,14 @@ int tipc_nl_node_dump_link(struct sk_buff *skb, struct netlink_callback *cb)
 			prev_node = node->addr;
 		}
 	} else {
-		err = tipc_nl_add_bc_link(net, &msg);
+		err = tipc_nl_add_bc_link(net, &msg, tn->bcl);
 		if (err)
 			goto out;
 
 		list_for_each_entry_rcu(node, &tn->node_list, list) {
 			tipc_node_read_lock(node);
 			err = __tipc_nl_add_node_links(net, &msg, node,
-						       &prev_link);
+						       &prev_link, bc_link);
 			tipc_node_read_unlock(node);
 			if (err)
 				goto out;
@@ -2611,6 +2655,7 @@ int tipc_nl_node_dump_link(struct sk_buff *skb, struct netlink_callback *cb)
 	cb->args[0] = prev_node;
 	cb->args[1] = prev_link;
 	cb->args[2] = done;
+	cb->args[3] = bc_link;
 
 	return skb->len;
 }
diff --git a/net/tipc/trace.h b/net/tipc/trace.h
index e7535ab75255..04af83f0500c 100644
--- a/net/tipc/trace.h
+++ b/net/tipc/trace.h
@@ -255,7 +255,7 @@ DECLARE_EVENT_CLASS(tipc_link_class,
 
 	TP_fast_assign(
 		__assign_str(header, header);
-		tipc_link_name_ext(l, __entry->name);
+		memcpy(__entry->name, tipc_link_name(l), TIPC_MAX_LINK_NAME);
 		tipc_link_dump(l, dqueues, __get_str(buf));
 	),
 
@@ -295,7 +295,7 @@ DECLARE_EVENT_CLASS(tipc_link_transmq_class,
 	),
 
 	TP_fast_assign(
-		tipc_link_name_ext(r, __entry->name);
+		memcpy(__entry->name, tipc_link_name(r), TIPC_MAX_LINK_NAME);
 		__entry->from = f;
 		__entry->to = t;
 		__entry->len = skb_queue_len(tq);
-- 
2.13.7

