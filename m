Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7099F52DFBB
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 00:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235617AbiESWCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 18:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235334AbiESWCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 18:02:16 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 16D2CF68AE;
        Thu, 19 May 2022 15:02:16 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Subject: [PATCH net-next 03/11] netfilter: conntrack: remove pr_debug callsites from tcp tracker
Date:   Fri, 20 May 2022 00:01:58 +0200
Message-Id: <20220519220206.722153-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220519220206.722153-1-pablo@netfilter.org>
References: <20220519220206.722153-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

They are either obsolete or useless.

Those in the normal processing path cannot be enabled on a production
system; they generate too much noise.

One pr_debug call resides in an error path and does provide useful info,
merge it with the existing nf_log_invalid().

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 52 ++------------------------
 1 file changed, 4 insertions(+), 48 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 204a5cdff5b1..a63b51dceaf2 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -485,7 +485,6 @@ static bool tcp_in_window(struct nf_conn *ct,
 	struct nf_tcp_net *tn = nf_tcp_pernet(net);
 	struct ip_ct_tcp_state *sender = &state->seen[dir];
 	struct ip_ct_tcp_state *receiver = &state->seen[!dir];
-	const struct nf_conntrack_tuple *tuple = &ct->tuplehash[dir].tuple;
 	__u32 seq, ack, sack, end, win, swin;
 	u16 win_raw;
 	s32 receiver_offset;
@@ -508,18 +507,6 @@ static bool tcp_in_window(struct nf_conn *ct,
 	ack -= receiver_offset;
 	sack -= receiver_offset;
 
-	pr_debug("tcp_in_window: START\n");
-	pr_debug("tcp_in_window: ");
-	nf_ct_dump_tuple(tuple);
-	pr_debug("seq=%u ack=%u+(%d) sack=%u+(%d) win=%u end=%u\n",
-		 seq, ack, receiver_offset, sack, receiver_offset, win, end);
-	pr_debug("tcp_in_window: sender end=%u maxend=%u maxwin=%u scale=%i "
-		 "receiver end=%u maxend=%u maxwin=%u scale=%i\n",
-		 sender->td_end, sender->td_maxend, sender->td_maxwin,
-		 sender->td_scale,
-		 receiver->td_end, receiver->td_maxend, receiver->td_maxwin,
-		 receiver->td_scale);
-
 	if (sender->td_maxwin == 0) {
 		/*
 		 * Initialize sender data.
@@ -597,27 +584,10 @@ static bool tcp_in_window(struct nf_conn *ct,
 		 */
 		seq = end = sender->td_end;
 
-	pr_debug("tcp_in_window: ");
-	nf_ct_dump_tuple(tuple);
-	pr_debug("seq=%u ack=%u+(%d) sack=%u+(%d) win=%u end=%u\n",
-		 seq, ack, receiver_offset, sack, receiver_offset, win, end);
-	pr_debug("tcp_in_window: sender end=%u maxend=%u maxwin=%u scale=%i "
-		 "receiver end=%u maxend=%u maxwin=%u scale=%i\n",
-		 sender->td_end, sender->td_maxend, sender->td_maxwin,
-		 sender->td_scale,
-		 receiver->td_end, receiver->td_maxend, receiver->td_maxwin,
-		 receiver->td_scale);
-
 	/* Is the ending sequence in the receive window (if available)? */
 	in_recv_win = !receiver->td_maxwin ||
 		      after(end, sender->td_end - receiver->td_maxwin - 1);
 
-	pr_debug("tcp_in_window: I=%i II=%i III=%i IV=%i\n",
-		 before(seq, sender->td_maxend + 1),
-		 (in_recv_win ? 1 : 0),
-		 before(sack, receiver->td_end + 1),
-		 after(sack, receiver->td_end - MAXACKWINDOW(sender) - 1));
-
 	if (before(seq, sender->td_maxend + 1) &&
 	    in_recv_win &&
 	    before(sack, receiver->td_end + 1) &&
@@ -698,11 +668,6 @@ static bool tcp_in_window(struct nf_conn *ct,
 		}
 	}
 
-	pr_debug("tcp_in_window: res=%u sender end=%u maxend=%u maxwin=%u "
-		 "receiver end=%u maxend=%u maxwin=%u\n",
-		 res, sender->td_end, sender->td_maxend, sender->td_maxwin,
-		 receiver->td_end, receiver->td_maxend, receiver->td_maxwin);
-
 	return res;
 }
 
@@ -772,8 +737,6 @@ static noinline bool tcp_new(struct nf_conn *ct, const struct sk_buff *skb,
 	enum tcp_conntrack new_state;
 	struct net *net = nf_ct_net(ct);
 	const struct nf_tcp_net *tn = nf_tcp_pernet(net);
-	const struct ip_ct_tcp_state *sender = &ct->proto.tcp.seen[0];
-	const struct ip_ct_tcp_state *receiver = &ct->proto.tcp.seen[1];
 
 	/* Don't need lock here: this conntrack not in circulation yet */
 	new_state = tcp_conntracks[0][get_conntrack_index(th)][TCP_CONNTRACK_NONE];
@@ -826,14 +789,6 @@ static noinline bool tcp_new(struct nf_conn *ct, const struct sk_buff *skb,
 
 	/* tcp_packet will set them */
 	ct->proto.tcp.last_index = TCP_NONE_SET;
-
-	pr_debug("%s: sender end=%u maxend=%u maxwin=%u scale=%i "
-		 "receiver end=%u maxend=%u maxwin=%u scale=%i\n",
-		 __func__,
-		 sender->td_end, sender->td_maxend, sender->td_maxwin,
-		 sender->td_scale,
-		 receiver->td_end, receiver->td_maxend, receiver->td_maxwin,
-		 receiver->td_scale);
 	return true;
 }
 
@@ -1032,10 +987,11 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 		}
 
 		/* Invalid packet */
-		pr_debug("nf_ct_tcp: Invalid dir=%i index=%u ostate=%u\n",
-			 dir, get_conntrack_index(th), old_state);
 		spin_unlock_bh(&ct->lock);
-		nf_ct_l4proto_log_invalid(skb, ct, state, "invalid state");
+		nf_ct_l4proto_log_invalid(skb, ct, state,
+					  "packet (index %d) in dir %d invalid, state %s",
+					  index, dir,
+					  tcp_conntrack_names[old_state]);
 		return -NF_ACCEPT;
 	case TCP_CONNTRACK_TIME_WAIT:
 		/* RFC5961 compliance cause stack to send "challenge-ACK"
-- 
2.30.2

