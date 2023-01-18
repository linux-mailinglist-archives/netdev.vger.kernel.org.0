Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9F6B671997
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 11:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbjARKtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 05:49:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbjARKsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 05:48:30 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 22D622ED63;
        Wed, 18 Jan 2023 01:54:29 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 1/1] netfilter: conntrack: handle tcp challenge acks during connection reuse
Date:   Wed, 18 Jan 2023 10:54:24 +0100
Message-Id: <20230118095424.885014-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230118095424.885014-1-pablo@netfilter.org>
References: <20230118095424.885014-1-pablo@netfilter.org>
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

When a connection is re-used, following can happen:
[ connection starts to close, fin sent in either direction ]
 > syn   # initator quickly reuses connection
 < ack   # peer sends a challenge ack
 > rst   # rst, sequence number == ack_seq of previous challenge ack
 > syn   # this syn is expected to pass

Problem is that the rst will fail window validation, so it gets
tagged as invalid.

If ruleset drops such packets, we get repeated syn-retransmits until
initator gives up or peer starts responding with syn/ack.

Before the commit indicated in the "Fixes" tag below this used to work:

The challenge-ack made conntrack re-init state based on the challenge
ack itself, so the following rst would pass window validation.

Add challenge-ack support: If we get ack for syn, record the ack_seq,
and then check if the rst sequence number matches the last ack number
seen in reverse direction.

Fixes: c7aab4f17021 ("netfilter: nf_conntrack_tcp: re-init for syn packets only")
Reported-by: Michal Tesar <mtesar@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 656631083177..3ac1af6f59fc 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1068,6 +1068,13 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 				ct->proto.tcp.last_flags |=
 					IP_CT_EXP_CHALLENGE_ACK;
 		}
+
+		/* possible challenge ack reply to syn */
+		if (old_state == TCP_CONNTRACK_SYN_SENT &&
+		    index == TCP_ACK_SET &&
+		    dir == IP_CT_DIR_REPLY)
+			ct->proto.tcp.last_ack = ntohl(th->ack_seq);
+
 		spin_unlock_bh(&ct->lock);
 		nf_ct_l4proto_log_invalid(skb, ct, state,
 					  "packet (index %d) in dir %d ignored, state %s",
@@ -1193,6 +1200,14 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 			 * segments we ignored. */
 			goto in_window;
 		}
+
+		/* Reset in response to a challenge-ack we let through earlier */
+		if (old_state == TCP_CONNTRACK_SYN_SENT &&
+		    ct->proto.tcp.last_index == TCP_ACK_SET &&
+		    ct->proto.tcp.last_dir == IP_CT_DIR_REPLY &&
+		    ntohl(th->seq) == ct->proto.tcp.last_ack)
+			goto in_window;
+
 		break;
 	default:
 		/* Keep compilers happy. */
-- 
2.30.2

