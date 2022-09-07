Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 297F65B08C9
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 17:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiIGPlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 11:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiIGPlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 11:41:37 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9393CA74F9;
        Wed,  7 Sep 2022 08:41:36 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oVxBC-00065t-Fq; Wed, 07 Sep 2022 17:41:30 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 2/8] netfilter: conntrack: ignore overly delayed tcp packets
Date:   Wed,  7 Sep 2022 17:41:04 +0200
Message-Id: <20220907154110.8898-3-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220907154110.8898-1-fw@strlen.de>
References: <20220907154110.8898-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If 'nf_conntrack_tcp_loose' is off (the default), tcp packets that are
outside of the current window are marked as INVALID.

nf/iptables rulesets often drop such packets via 'ct state invalid' or
similar checks.

For overly delayed acks, this can be a nuisance if such 'invalid' packets
are also logged.

Since they are not invalid in a strict sense, just ignore them, i.e.
conntrack won't extend timeout or change state so that they do not match
invalid state rules anymore.

This also avoids unwantend connection stalls in case conntrack considers
retransmission (of data that did not reach the peer) as too old.

The else branch of the conditional becomes obsolete.
Next patch will reformant the now always-true if condition.

The existing workaround for data that exceeds the calculated receive
window is adjusted to use the 'ignore' state so that these packets do
not refresh the timeout or change state other than updating ->td_end.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 49 +++++++++++---------------
 1 file changed, 21 insertions(+), 28 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 1731b82dcc97..2d6925ef269f 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -48,6 +48,7 @@ static const char *const tcp_conntrack_names[] = {
 };
 
 enum nf_ct_tcp_action {
+	NFCT_TCP_IGNORE,
 	NFCT_TCP_INVALID,
 	NFCT_TCP_ACCEPT,
 };
@@ -510,8 +511,6 @@ tcp_in_window(struct nf_conn *ct, enum ip_conntrack_dir dir,
 	      const struct nf_hook_state *hook_state)
 {
 	struct ip_ct_tcp *state = &ct->proto.tcp;
-	struct net *net = nf_ct_net(ct);
-	struct nf_tcp_net *tn = nf_tcp_pernet(net);
 	struct ip_ct_tcp_state *sender = &state->seen[dir];
 	struct ip_ct_tcp_state *receiver = &state->seen[!dir];
 	__u32 seq, ack, sack, end, win, swin;
@@ -639,9 +638,8 @@ tcp_in_window(struct nf_conn *ct, enum ip_conntrack_dir dir,
 			sender->td_end = end;
 			sender->flags |= IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED;
 
-			nf_ct_l4proto_log_invalid(skb, ct, hook_state,
+			return nf_tcp_log_invalid(skb, ct, hook_state, sender, NFCT_TCP_IGNORE,
 						  "%u bytes more than expected", overshot);
-			return NFCT_TCP_ACCEPT;
 		}
 
 		return nf_tcp_log_invalid(skb, ct, hook_state, sender, NFCT_TCP_INVALID,
@@ -657,9 +655,15 @@ tcp_in_window(struct nf_conn *ct, enum ip_conntrack_dir dir,
 	/* Is the ending sequence in the receive window (if available)? */
 	in_recv_win = !receiver->td_maxwin ||
 		      after(end, sender->td_end - receiver->td_maxwin - 1);
-
-	if (in_recv_win &&
-	    after(sack, receiver->td_end - MAXACKWINDOW(sender) - 1)) {
+	if (!in_recv_win)
+		return nf_tcp_log_invalid(skb, ct, hook_state, sender, NFCT_TCP_IGNORE,
+					  "SEQ is under lower bound %u (already ACKed data retransmitted)",
+					  sender->td_end - receiver->td_maxwin - 1);
+	if (!after(sack, receiver->td_end - MAXACKWINDOW(sender) - 1))
+		return nf_tcp_log_invalid(skb, ct, hook_state, sender, NFCT_TCP_IGNORE,
+					  "ignored ACK under lower bound %u (possible overly delayed)",
+					  receiver->td_end - MAXACKWINDOW(sender) - 1);
+	if (1) {
 		/*
 		 * Take into account window scaling (RFC 1323).
 		 */
@@ -716,25 +720,6 @@ tcp_in_window(struct nf_conn *ct, enum ip_conntrack_dir dir,
 				state->retrans = 0;
 			}
 		}
-	} else {
-		if (sender->flags & IP_CT_TCP_FLAG_BE_LIBERAL ||
-		    tn->tcp_be_liberal)
-			return NFCT_TCP_ACCEPT;
-
-		{
-			nf_ct_l4proto_log_invalid(skb, ct, hook_state,
-			"%s",
-			before(seq, sender->td_maxend + 1) ?
-			in_recv_win ?
-			before(sack, receiver->td_end + 1) ?
-			after(sack, receiver->td_end - MAXACKWINDOW(sender) - 1) ? "BUG"
-			: "ACK is under the lower bound (possible overly delayed ACK)"
-			: "ACK is over the upper bound (ACKed data not seen yet)"
-			: "SEQ is under the lower bound (already ACKed data retransmitted)"
-			: "SEQ is over the upper bound (over the window of the receiver)");
-		}
-
-		return NFCT_TCP_INVALID;
 	}
 
 	return NFCT_TCP_ACCEPT;
@@ -899,6 +884,7 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 	struct nf_conntrack_tuple *tuple;
 	enum tcp_conntrack new_state, old_state;
 	unsigned int index, *timeouts;
+	enum nf_ct_tcp_action res;
 	enum ip_conntrack_dir dir;
 	const struct tcphdr *th;
 	struct tcphdr _tcph;
@@ -1164,10 +1150,17 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 		break;
 	}
 
-	if (!tcp_in_window(ct, dir, index,
-			   skb, dataoff, th, state)) {
+	res = tcp_in_window(ct, dir, index,
+			    skb, dataoff, th, state);
+	switch (res) {
+	case NFCT_TCP_IGNORE:
+		spin_unlock_bh(&ct->lock);
+		return NF_ACCEPT;
+	case NFCT_TCP_INVALID:
 		spin_unlock_bh(&ct->lock);
 		return -NF_ACCEPT;
+	case NFCT_TCP_ACCEPT:
+		break;
 	}
      in_window:
 	/* From now on we have got in-window packets */
-- 
2.35.1

