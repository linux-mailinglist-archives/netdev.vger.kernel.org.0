Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE85D5B08CB
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 17:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiIGPlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 11:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiIGPll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 11:41:41 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C759E0FF;
        Wed,  7 Sep 2022 08:41:40 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oVxBI-00066j-4a; Wed, 07 Sep 2022 17:41:36 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 4/8] netfilter: conntrack: reduce timeout when receiving out-of-window fin or rst
Date:   Wed,  7 Sep 2022 17:41:06 +0200
Message-Id: <20220907154110.8898-5-fw@strlen.de>
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

In case the endpoints and conntrack go out-of-sync, i.e. there is
disagreement wrt. validy of sequence/ack numbers between conntracks
internal state and those of the endpoints, connections can hang for a
long time (until ESTABLISHED timeout).

This adds a check to detect a fin/fin exchange even if those are
invalid.  The timeout is then lowered to UNACKED (default 300s).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 58 ++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 0574290326d1..656631083177 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -717,6 +717,63 @@ tcp_in_window(struct nf_conn *ct, enum ip_conntrack_dir dir,
 	return NFCT_TCP_ACCEPT;
 }
 
+static void __cold nf_tcp_handle_invalid(struct nf_conn *ct,
+					 enum ip_conntrack_dir dir,
+					 int index,
+					 const struct sk_buff *skb,
+					 const struct nf_hook_state *hook_state)
+{
+	const unsigned int *timeouts;
+	const struct nf_tcp_net *tn;
+	unsigned int timeout;
+	u32 expires;
+
+	if (!test_bit(IPS_ASSURED_BIT, &ct->status) ||
+	    test_bit(IPS_FIXED_TIMEOUT_BIT, &ct->status))
+		return;
+
+	/* We don't want to have connections hanging around in ESTABLISHED
+	 * state for long time 'just because' conntrack deemed a FIN/RST
+	 * out-of-window.
+	 *
+	 * Shrink the timeout just like when there is unacked data.
+	 * This speeds up eviction of 'dead' connections where the
+	 * connection and conntracks internal state are out of sync.
+	 */
+	switch (index) {
+	case TCP_RST_SET:
+	case TCP_FIN_SET:
+		break;
+	default:
+		return;
+	}
+
+	if (ct->proto.tcp.last_dir != dir &&
+	    (ct->proto.tcp.last_index == TCP_FIN_SET ||
+	     ct->proto.tcp.last_index == TCP_RST_SET)) {
+		expires = nf_ct_expires(ct);
+		if (expires < 120 * HZ)
+			return;
+
+		tn = nf_tcp_pernet(nf_ct_net(ct));
+		timeouts = nf_ct_timeout_lookup(ct);
+		if (!timeouts)
+			timeouts = tn->timeouts;
+
+		timeout = READ_ONCE(timeouts[TCP_CONNTRACK_UNACK]);
+		if (expires > timeout) {
+			nf_ct_l4proto_log_invalid(skb, ct, hook_state,
+					  "packet (index %d, dir %d) response for index %d lower timeout to %u",
+					  index, dir, ct->proto.tcp.last_index, timeout);
+
+			WRITE_ONCE(ct->timeout, timeout + nfct_time_stamp);
+		}
+	} else {
+		ct->proto.tcp.last_index = index;
+		ct->proto.tcp.last_dir = dir;
+	}
+}
+
 /* table of valid flag combinations - PUSH, ECE and CWR are always valid */
 static const u8 tcp_valid_flags[(TCPHDR_FIN|TCPHDR_SYN|TCPHDR_RST|TCPHDR_ACK|
 				 TCPHDR_URG) + 1] =
@@ -1149,6 +1206,7 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 		spin_unlock_bh(&ct->lock);
 		return NF_ACCEPT;
 	case NFCT_TCP_INVALID:
+		nf_tcp_handle_invalid(ct, dir, index, skb, state);
 		spin_unlock_bh(&ct->lock);
 		return -NF_ACCEPT;
 	case NFCT_TCP_ACCEPT:
-- 
2.35.1

