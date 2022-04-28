Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBF025136BA
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 16:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346751AbiD1OY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 10:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbiD1OY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 10:24:28 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EDB95AFB22;
        Thu, 28 Apr 2022 07:21:13 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 1/3] netfilter: nf_conntrack_tcp: re-init for syn packets only
Date:   Thu, 28 Apr 2022 16:21:07 +0200
Message-Id: <20220428142109.38726-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220428142109.38726-1-pablo@netfilter.org>
References: <20220428142109.38726-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Jaco Kroon reported tcp problems that Eric Dumazet and Neal Cardwell
pinpointed to nf_conntrack tcp_in_window() bug.

tcp trace shows following sequence:

I > R Flags [S], seq 3451342529, win 62580, options [.. tfo [|tcp]>
R > I Flags [S.], seq 2699962254, ack 3451342530, win 65535, options [..]
R > I Flags [P.], seq 1:89, ack 1, [..]

Note 3rd ACK is from responder to initiator so following branch is taken:
    } else if (((state->state == TCP_CONNTRACK_SYN_SENT
               && dir == IP_CT_DIR_ORIGINAL)
               || (state->state == TCP_CONNTRACK_SYN_RECV
               && dir == IP_CT_DIR_REPLY))
               && after(end, sender->td_end)) {

... because state == TCP_CONNTRACK_SYN_RECV and dir is REPLY.
This causes the scaling factor to be reset to 0: window scale option
is only present in syn(ack) packets.  This in turn makes nf_conntrack
mark valid packets as out-of-window.

This was always broken, it exists even in original commit where
window tracking was added to ip_conntrack (nf_conntrack predecessor)
in 2.6.9-rc1 kernel.

Restrict to 'tcph->syn', just like the 3rd condtional added in
commit 82b72cb94666 ("netfilter: conntrack: re-init state for retransmitted syn-ack").

Upon closer look, those conditionals/branches can be merged:

Because earlier checks prevent syn-ack from showing up in
original direction, the 'dir' checks in the conditional quoted above are
redundant, remove them. Return early for pure syn retransmitted in reply
direction (simultaneous open).

Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
Reported-by: Jaco Kroon <jaco@uls.co.za>
Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 8ec55cd72572..204a5cdff5b1 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -556,24 +556,14 @@ static bool tcp_in_window(struct nf_conn *ct,
 			}
 
 		}
-	} else if (((state->state == TCP_CONNTRACK_SYN_SENT
-		     && dir == IP_CT_DIR_ORIGINAL)
-		   || (state->state == TCP_CONNTRACK_SYN_RECV
-		     && dir == IP_CT_DIR_REPLY))
-		   && after(end, sender->td_end)) {
+	} else if (tcph->syn &&
+		   after(end, sender->td_end) &&
+		   (state->state == TCP_CONNTRACK_SYN_SENT ||
+		    state->state == TCP_CONNTRACK_SYN_RECV)) {
 		/*
 		 * RFC 793: "if a TCP is reinitialized ... then it need
 		 * not wait at all; it must only be sure to use sequence
 		 * numbers larger than those recently used."
-		 */
-		sender->td_end =
-		sender->td_maxend = end;
-		sender->td_maxwin = (win == 0 ? 1 : win);
-
-		tcp_options(skb, dataoff, tcph, sender);
-	} else if (tcph->syn && dir == IP_CT_DIR_REPLY &&
-		   state->state == TCP_CONNTRACK_SYN_SENT) {
-		/* Retransmitted syn-ack, or syn (simultaneous open).
 		 *
 		 * Re-init state for this direction, just like for the first
 		 * syn(-ack) reply, it might differ in seq, ack or tcp options.
@@ -581,7 +571,8 @@ static bool tcp_in_window(struct nf_conn *ct,
 		tcp_init_sender(sender, receiver,
 				skb, dataoff, tcph,
 				end, win);
-		if (!tcph->ack)
+
+		if (dir == IP_CT_DIR_REPLY && !tcph->ack)
 			return true;
 	}
 
-- 
2.30.2

