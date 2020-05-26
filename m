Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 117871E1ED2
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 11:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388700AbgEZJjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 05:39:05 -0400
Received: from mail-db8eur05on2125.outbound.protection.outlook.com ([40.107.20.125]:25953
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388468AbgEZJjE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 05:39:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WDNAwgAw+4F+/RSe4USxs8DVcM3wWCq+blr5CNPMvZaw4tYT4iRQmCQ75N/O2I8YfiQSuR5kF3NQeZ6jKbmQTGTQCJxTVn/5Ykha/NYbHITTkBuCEdrm2M2Dpzt+9v1C+9kAWh7WL0zmmMu23V1pK5XiPo/7Nc0gZ2/B05c3nbk3lwDvEYz/aLMYdU9Y7eGqqbNOon8unmQ+L2rqGYFnAy01b1s2j1QndaG8JPINLTlzJCVO4M84qHEQ08dQ/+6s9aL6jtM/OwWVdZUgfinE942PJPhmqfk/S/3Ef/4i0yi63eKLfxiuWs/zpe6/okY/6hznphrpp/k1XxLdiSSijQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6wSZzMZAYu9j9QwTrBCBj1bXGkzk5N12x7xEeJewurs=;
 b=M9g0yWi34z7UTu3zROli4D5iQO97oP2VYYPVWKJox+s4T4l7cYRh9oIwahI4MNJgjT1YB977kpPpzwVlpSYDgpbovuhDqa8w2pP8e0Ds1+R1OoQPNL7EPYxBMeKTI4RzpfMqZRr505gu9VeZoDxFNX1G/cR5Xw4sL6RnRcaw0bCwwXYm6L84j5IIWqHxuPx2uTqPZ80eCEZRFzokBdrpQb/iDStA4o8YNvXp2L3LRS94irDgIJuaxVe4D4GVxZDLZ/VGBQLUWvWs/ELUDG+zgi5lDfzoEWXcBNuv/ngfunMLS/WivPMST9P39C0w4yysL/iqcOHdmyK2FFmrFB2knQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6wSZzMZAYu9j9QwTrBCBj1bXGkzk5N12x7xEeJewurs=;
 b=wRv5PTgBkH+KpCOyCfAf616dSnR3RNnSmZJVD3B/EpGUp1AZjlWflhwsQXlAKtDlh/cbTp1B20r1kevINxzqaazwd/7UfmZfY6O9BNCqrIatftXqlY2EOCx9Q6aB3ChhFjzrPtyVH5p3G4UbDy608xCpsi8IZYGr3RxKtlqLCVs=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=dektech.com.au;
Received: from AM6PR0502MB3925.eurprd05.prod.outlook.com (2603:10a6:209:5::28)
 by AM6PR0502MB3718.eurprd05.prod.outlook.com (2603:10a6:209:11::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Tue, 26 May
 2020 09:38:54 +0000
Received: from AM6PR0502MB3925.eurprd05.prod.outlook.com
 ([fe80::4d5f:2ab:5a66:deaf]) by AM6PR0502MB3925.eurprd05.prod.outlook.com
 ([fe80::4d5f:2ab:5a66:deaf%7]) with mapi id 15.20.3021.029; Tue, 26 May 2020
 09:38:54 +0000
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jmaloy@redhat.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [net-next 3/5] tipc: enable broadcast retrans via unicast
Date:   Tue, 26 May 2020 16:38:36 +0700
Message-Id: <20200526093838.17421-4-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20200526093838.17421-1-tuong.t.lien@dektech.com.au>
References: <20200526093838.17421-1-tuong.t.lien@dektech.com.au>
Content-Type: text/plain
X-ClientProxiedBy: HK2PR03CA0060.apcprd03.prod.outlook.com
 (2603:1096:202:17::30) To AM6PR0502MB3925.eurprd05.prod.outlook.com
 (2603:10a6:209:5::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (14.161.14.188) by HK2PR03CA0060.apcprd03.prod.outlook.com (2603:1096:202:17::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3045.8 via Frontend Transport; Tue, 26 May 2020 09:38:52 +0000
X-Mailer: git-send-email 2.13.7
X-Originating-IP: [14.161.14.188]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 105ebfd9-5aeb-42d4-a5a6-08d801589b0d
X-MS-TrafficTypeDiagnostic: AM6PR0502MB3718:
X-Microsoft-Antispam-PRVS: <AM6PR0502MB3718EBE4FE7C7FF59793D49AE2B00@AM6PR0502MB3718.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:632;
X-Forefront-PRVS: 041517DFAB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1fnByXkAWdoLN1WE1PX6TBWl8HVhfOzyBu+v4yvvP6GSBNX06/QEfFgZm81FJrfMwe75aepph0RrF1vegFDZ1vQJUq1jTBIOEs/wIo+lTu3beRKRlrulMMUiSwFxJDBQvpEBFDoirwloFn9jXpR3wI8dBKHNqA7eu3v51jog6jP1gZ9RrFapFeTcVWFPilKisEJcm0yuk+iRPuYC7ZcT8+i+LKzPZzub598OJZ7Kohh3+kgtPiDH+Jggr0qePRDh0hNJamcyvOG3vnX6OeW17xmq6Fos45xCKwHnt9bMfX4aabRFTWvpUUK/YcDVX5LqK+9roPVccbst1TflOX5u7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0502MB3925.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(346002)(366004)(376002)(136003)(39850400004)(8676002)(16526019)(956004)(2616005)(103116003)(55016002)(186003)(6666004)(4326008)(66476007)(66556008)(2906002)(86362001)(36756003)(316002)(5660300002)(26005)(66946007)(8936002)(52116002)(1076003)(478600001)(7696005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: xAHDMeH2woY2x/jRdnwWCvXdfWrwVf1JuMsZ0YidUlurMK72Nnc0C9WYugmU8KnKq67MJMyW8ZHBkQLjaqQnfd/FVUrcEd+D3v5aFN3PiKgA6sTb2fzRZ6iLHccYzBLOxBv4JL5cSrl1fgN3tGx5TqhVPHUYpw5TJ1ZAUC7ILW5onmHj08SKDnd913P41xyMulTIv+DHHMVPfUGrW4vGgKC0rW2KfwwfnGquj2ER4ArIuYqwHUjEuz8f8/WJHb6nfLz7LXdA03twjhySjz4g1RO+NEg1+UgTxseRRHQQIXQe7LiiTwJJyQSyoqMb8UgiGG3LvUTgXet3RrYGiGjIRyk9f6zzYZHY4VwJbypOsbUsOxkZ4bCjQ+L16BYJpV2ie3+Sp0DBaCSeyyR//fritKp2sdk3ktVkzuRuTnJLxjMG4XD08MPj6x08YCBoJLrpSUCbC3mpMX7B8EGXB4SNa6M2K6WlP75X96r6aEf03HA=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: 105ebfd9-5aeb-42d4-a5a6-08d801589b0d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2020 09:38:54.6505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2AXLvE/b4RYgC0qtX5JKm548LBuYug2skZksALhFQcLVTD5wWGqnXTlU05BELFwMShpnQSgBX7S1nbNgt/D7cI7y6ff3okERB4ia3uf4uKM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0502MB3718
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some environment, broadcast traffic is suppressed at high rate (i.e.
a kind of bandwidth limit setting). When it is applied, TIPC broadcast
can still run successfully. However, when it comes to a high load, some
packets will be dropped first and TIPC tries to retransmit them but the
packet retransmission is intentionally broadcast too, so making things
worse and not helpful at all.

This commit enables the broadcast retransmission via unicast which only
retransmits packets to the specific peer that has really reported a gap
i.e. not broadcasting to all nodes in the cluster, so will prevent from
being suppressed, and also reduce some overheads on the other peers due
to duplicates, finally improve the overall TIPC broadcast performance.

Note: the functionality can be turned on/off via the sysctl file:

echo 1 > /proc/sys/net/tipc/bc_retruni
echo 0 > /proc/sys/net/tipc/bc_retruni

Default is '0', i.e. the broadcast retransmission still works as usual.

Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
---
 net/tipc/bcast.c  | 11 ++++++++---
 net/tipc/bcast.h  |  4 +++-
 net/tipc/link.c   | 10 ++++++----
 net/tipc/link.h   |  3 ++-
 net/tipc/node.c   |  2 +-
 net/tipc/sysctl.c |  9 ++++++++-
 6 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/net/tipc/bcast.c b/net/tipc/bcast.c
index 3ce690a96ee9..50a16f8bebd9 100644
--- a/net/tipc/bcast.c
+++ b/net/tipc/bcast.c
@@ -46,6 +46,7 @@
 #define BCLINK_WIN_MIN      32	/* bcast minimum link window size */
 
 const char tipc_bclink_name[] = "broadcast-link";
+unsigned long sysctl_tipc_bc_retruni __read_mostly;
 
 /**
  * struct tipc_bc_base - base structure for keeping broadcast send state
@@ -474,7 +475,7 @@ void tipc_bcast_ack_rcv(struct net *net, struct tipc_link *l,
 	__skb_queue_head_init(&xmitq);
 
 	tipc_bcast_lock(net);
-	tipc_link_bc_ack_rcv(l, acked, 0, NULL, &xmitq);
+	tipc_link_bc_ack_rcv(l, acked, 0, NULL, &xmitq, NULL);
 	tipc_bcast_unlock(net);
 
 	tipc_bcbase_xmit(net, &xmitq);
@@ -489,7 +490,8 @@ void tipc_bcast_ack_rcv(struct net *net, struct tipc_link *l,
  * RCU is locked, no other locks set
  */
 int tipc_bcast_sync_rcv(struct net *net, struct tipc_link *l,
-			struct tipc_msg *hdr)
+			struct tipc_msg *hdr,
+			struct sk_buff_head *retrq)
 {
 	struct sk_buff_head *inputq = &tipc_bc_base(net)->inputq;
 	struct tipc_gap_ack_blks *ga;
@@ -503,8 +505,11 @@ int tipc_bcast_sync_rcv(struct net *net, struct tipc_link *l,
 		tipc_link_bc_init_rcv(l, hdr);
 	} else if (!msg_bc_ack_invalid(hdr)) {
 		tipc_get_gap_ack_blks(&ga, l, hdr, false);
+		if (!sysctl_tipc_bc_retruni)
+			retrq = &xmitq;
 		rc = tipc_link_bc_ack_rcv(l, msg_bcast_ack(hdr),
-					  msg_bc_gap(hdr), ga, &xmitq);
+					  msg_bc_gap(hdr), ga, &xmitq,
+					  retrq);
 		rc |= tipc_link_bc_sync_rcv(l, hdr, &xmitq);
 	}
 	tipc_bcast_unlock(net);
diff --git a/net/tipc/bcast.h b/net/tipc/bcast.h
index 9e847d9617d3..97d3cf9d3e4d 100644
--- a/net/tipc/bcast.h
+++ b/net/tipc/bcast.h
@@ -45,6 +45,7 @@ struct tipc_nl_msg;
 struct tipc_nlist;
 struct tipc_nitem;
 extern const char tipc_bclink_name[];
+extern unsigned long sysctl_tipc_bc_retruni;
 
 #define TIPC_METHOD_EXPIRE msecs_to_jiffies(5000)
 
@@ -93,7 +94,8 @@ int tipc_bcast_rcv(struct net *net, struct tipc_link *l, struct sk_buff *skb);
 void tipc_bcast_ack_rcv(struct net *net, struct tipc_link *l,
 			struct tipc_msg *hdr);
 int tipc_bcast_sync_rcv(struct net *net, struct tipc_link *l,
-			struct tipc_msg *hdr);
+			struct tipc_msg *hdr,
+			struct sk_buff_head *retrq);
 int tipc_nl_add_bc_link(struct net *net, struct tipc_nl_msg *msg);
 int tipc_nl_bc_link_set(struct net *net, struct nlattr *attrs[]);
 int tipc_bclink_reset_stats(struct net *net);
diff --git a/net/tipc/link.c b/net/tipc/link.c
index 288c5670cfa5..af352391e2ab 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -375,7 +375,7 @@ void tipc_link_remove_bc_peer(struct tipc_link *snd_l,
 	snd_l->ackers--;
 	rcv_l->bc_peer_is_up = true;
 	rcv_l->state = LINK_ESTABLISHED;
-	tipc_link_bc_ack_rcv(rcv_l, ack, 0, NULL, xmitq);
+	tipc_link_bc_ack_rcv(rcv_l, ack, 0, NULL, xmitq, NULL);
 	trace_tipc_link_reset(rcv_l, TIPC_DUMP_ALL, "bclink removed!");
 	tipc_link_reset(rcv_l);
 	rcv_l->state = LINK_RESET;
@@ -2400,7 +2400,8 @@ int tipc_link_bc_sync_rcv(struct tipc_link *l, struct tipc_msg *hdr,
 
 int tipc_link_bc_ack_rcv(struct tipc_link *r, u16 acked, u16 gap,
 			 struct tipc_gap_ack_blks *ga,
-			 struct sk_buff_head *xmitq)
+			 struct sk_buff_head *xmitq,
+			 struct sk_buff_head *retrq)
 {
 	struct tipc_link *l = r->bc_sndlink;
 	bool unused = false;
@@ -2413,7 +2414,7 @@ int tipc_link_bc_ack_rcv(struct tipc_link *r, u16 acked, u16 gap,
 		return 0;
 
 	trace_tipc_link_bc_ack(r, acked, gap, &l->transmq);
-	tipc_link_advance_transmq(l, r, acked, gap, ga, xmitq, &unused, &rc);
+	tipc_link_advance_transmq(l, r, acked, gap, ga, retrq, &unused, &rc);
 
 	tipc_link_advance_backlog(l, xmitq);
 	if (unlikely(!skb_queue_empty(&l->wakeupq)))
@@ -2447,7 +2448,8 @@ int tipc_link_bc_nack_rcv(struct tipc_link *l, struct sk_buff *skb,
 		return 0;
 
 	if (dnode == tipc_own_addr(l->net)) {
-		rc = tipc_link_bc_ack_rcv(l, acked, to - acked, NULL, xmitq);
+		rc = tipc_link_bc_ack_rcv(l, acked, to - acked, NULL, xmitq,
+					  xmitq);
 		l->stats.recv_nacks++;
 		return rc;
 	}
diff --git a/net/tipc/link.h b/net/tipc/link.h
index 0a0fa7350722..4d0768cf91d5 100644
--- a/net/tipc/link.h
+++ b/net/tipc/link.h
@@ -147,7 +147,8 @@ u16 tipc_get_gap_ack_blks(struct tipc_gap_ack_blks **ga, struct tipc_link *l,
 			  struct tipc_msg *hdr, bool uc);
 int tipc_link_bc_ack_rcv(struct tipc_link *l, u16 acked, u16 gap,
 			 struct tipc_gap_ack_blks *ga,
-			 struct sk_buff_head *xmitq);
+			 struct sk_buff_head *xmitq,
+			 struct sk_buff_head *retrq);
 void tipc_link_build_bc_sync_msg(struct tipc_link *l,
 				 struct sk_buff_head *xmitq);
 void tipc_link_bc_init_rcv(struct tipc_link *l, struct tipc_msg *hdr);
diff --git a/net/tipc/node.c b/net/tipc/node.c
index 6a49b3eeaae9..548207fdec15 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -1772,7 +1772,7 @@ static void tipc_node_bc_sync_rcv(struct tipc_node *n, struct tipc_msg *hdr,
 	struct tipc_link *ucl;
 	int rc;
 
-	rc = tipc_bcast_sync_rcv(n->net, n->bc_entry.link, hdr);
+	rc = tipc_bcast_sync_rcv(n->net, n->bc_entry.link, hdr, xmitq);
 
 	if (rc & TIPC_LINK_DOWN_EVT) {
 		tipc_node_reset_links(n);
diff --git a/net/tipc/sysctl.c b/net/tipc/sysctl.c
index 58ab3d6dcdce..97a6264a2993 100644
--- a/net/tipc/sysctl.c
+++ b/net/tipc/sysctl.c
@@ -36,7 +36,7 @@
 #include "core.h"
 #include "trace.h"
 #include "crypto.h"
-
+#include "bcast.h"
 #include <linux/sysctl.h>
 
 static struct ctl_table_header *tipc_ctl_hdr;
@@ -75,6 +75,13 @@ static struct ctl_table tipc_table[] = {
 		.extra1         = SYSCTL_ONE,
 	},
 #endif
+	{
+		.procname	= "bc_retruni",
+		.data		= &sysctl_tipc_bc_retruni,
+		.maxlen		= sizeof(sysctl_tipc_bc_retruni),
+		.mode		= 0644,
+		.proc_handler	= proc_doulongvec_minmax,
+	},
 	{}
 };
 
-- 
2.13.7

