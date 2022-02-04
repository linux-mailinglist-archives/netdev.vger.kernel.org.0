Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52BD54A9BD2
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 16:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359631AbiBDPTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 10:19:21 -0500
Received: from mail.netfilter.org ([217.70.188.207]:50388 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359624AbiBDPTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 10:19:17 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 7AD0E6019D;
        Fri,  4 Feb 2022 16:19:10 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 4/6] netfilter: conntrack: re-init state for retransmitted syn-ack
Date:   Fri,  4 Feb 2022 16:19:01 +0100
Message-Id: <20220204151903.320786-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220204151903.320786-1-pablo@netfilter.org>
References: <20220204151903.320786-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

TCP conntrack assumes that a syn-ack retransmit is identical to the
previous syn-ack.  This isn't correct and causes stuck 3whs in some more
esoteric scenarios.  tcpdump to illustrate the problem:

 client > server: Flags [S] seq 1365731894, win 29200, [mss 1460,sackOK,TS val 2083035583 ecr 0,wscale 7]
 server > client: Flags [S.] seq 145824453, ack 643160523, win 65535, [mss 8952,wscale 5,TS val 3215367629 ecr 2082921663]

Note the invalid/outdated synack ack number.
Conntrack marks this syn-ack as out-of-window/invalid, but it did
initialize the reply direction parameters based on this packets content.

 client > server: Flags [S] seq 1365731894, win 29200, [mss 1460,sackOK,TS val 2083036623 ecr 0,wscale 7]

... retransmit...

 server > client: Flags [S.], seq 145824453, ack 643160523, win 65535, [mss 8952,wscale 5,TS val 3215368644 ecr 2082921663]

and another bogus synack. This repeats, then client re-uses for a new
attempt:

client > server: Flags [S], seq 2375731741, win 29200, [mss 1460,sackOK,TS val 2083100223 ecr 0,wscale 7]
server > client: Flags [S.], seq 145824453, ack 643160523, win 65535, [mss 8952,wscale 5,TS val 3215430754 ecr 2082921663]

... but still gets a invalid syn-ack.

This repeats until:

 server > client: Flags [S.], seq 145824453, ack 643160523, win 65535, [mss 8952,wscale 5,TS val 3215437785 ecr 2082921663]
 server > client: Flags [R.], seq 145824454, ack 643160523, win 65535, [mss 8952,wscale 5,TS val 3215443451 ecr 2082921663]
 client > server: Flags [S], seq 2375731741, win 29200, [mss 1460,sackOK,TS val 2083115583 ecr 0,wscale 7]
 server > client: Flags [S.], seq 162602410, ack 2375731742, win 65535, [mss 8952,wscale 5,TS val 3215445754 ecr 2083115583]

This syn-ack has the correct ack number, but conntrack flags it as
invalid: The internal state was created from the first syn-ack seen
so the sequence number of the syn-ack is treated as being outside of
the announced window.

Don't assume that retransmitted syn-ack is identical to previous one.
Treat it like the first syn-ack and reinit state.

Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 88c89e97d8a2..d1582b888c0d 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -571,6 +571,18 @@ static bool tcp_in_window(struct nf_conn *ct,
 		sender->td_maxwin = (win == 0 ? 1 : win);
 
 		tcp_options(skb, dataoff, tcph, sender);
+	} else if (tcph->syn && dir == IP_CT_DIR_REPLY &&
+		   state->state == TCP_CONNTRACK_SYN_SENT) {
+		/* Retransmitted syn-ack, or syn (simultaneous open).
+		 *
+		 * Re-init state for this direction, just like for the first
+		 * syn(-ack) reply, it might differ in seq, ack or tcp options.
+		 */
+		tcp_init_sender(sender, receiver,
+				skb, dataoff, tcph,
+				end, win);
+		if (!tcph->ack)
+			return true;
 	}
 
 	if (!(tcph->ack)) {
-- 
2.30.2

