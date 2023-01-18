Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF945671D20
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 14:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbjARNJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 08:09:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbjARNI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 08:08:58 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486855998F;
        Wed, 18 Jan 2023 04:32:40 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pI7cE-000742-9i; Wed, 18 Jan 2023 13:32:30 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 1/9] netfilter: conntrack: sctp: use nf log infrastructure for invalid packets
Date:   Wed, 18 Jan 2023 13:32:00 +0100
Message-Id: <20230118123208.17167-2-fw@strlen.de>
X-Mailer: git-send-email 2.38.2
In-Reply-To: <20230118123208.17167-1-fw@strlen.de>
References: <20230118123208.17167-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The conntrack logging facilities include useful info such as in/out
interface names and packet headers.

Use those in more places instead of pr_debug calls.
Furthermore, several pr_debug calls can be removed, they are useless
on production machines due to the sheer volume of log messages.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_proto_sctp.c | 46 ++++++++-----------------
 1 file changed, 15 insertions(+), 31 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index d88b92a8ffca..dbdfcc6cd2aa 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -168,7 +168,8 @@ for ((offset) = (dataoff) + sizeof(struct sctphdr), (count) = 0;	\
 static int do_basic_checks(struct nf_conn *ct,
 			   const struct sk_buff *skb,
 			   unsigned int dataoff,
-			   unsigned long *map)
+			   unsigned long *map,
+			   const struct nf_hook_state *state)
 {
 	u_int32_t offset, count;
 	struct sctp_chunkhdr _sch, *sch;
@@ -177,8 +178,6 @@ static int do_basic_checks(struct nf_conn *ct,
 	flag = 0;
 
 	for_each_sctp_chunk (skb, sch, _sch, offset, dataoff, count) {
-		pr_debug("Chunk Num: %d  Type: %d\n", count, sch->type);
-
 		if (sch->type == SCTP_CID_INIT ||
 		    sch->type == SCTP_CID_INIT_ACK ||
 		    sch->type == SCTP_CID_SHUTDOWN_COMPLETE)
@@ -193,7 +192,9 @@ static int do_basic_checks(struct nf_conn *ct,
 		      sch->type == SCTP_CID_COOKIE_ECHO ||
 		      flag) &&
 		     count != 0) || !sch->length) {
-			pr_debug("Basic checks failed\n");
+			nf_ct_l4proto_log_invalid(skb, ct, state,
+						  "%s failed. chunk num %d, type %d, len %d flag %d\n",
+						  __func__, count, sch->type, sch->length, flag);
 			return 1;
 		}
 
@@ -201,7 +202,6 @@ static int do_basic_checks(struct nf_conn *ct,
 			set_bit(sch->type, map);
 	}
 
-	pr_debug("Basic checks passed\n");
 	return count == 0;
 }
 
@@ -211,69 +211,51 @@ static int sctp_new_state(enum ip_conntrack_dir dir,
 {
 	int i;
 
-	pr_debug("Chunk type: %d\n", chunk_type);
-
 	switch (chunk_type) {
 	case SCTP_CID_INIT:
-		pr_debug("SCTP_CID_INIT\n");
 		i = 0;
 		break;
 	case SCTP_CID_INIT_ACK:
-		pr_debug("SCTP_CID_INIT_ACK\n");
 		i = 1;
 		break;
 	case SCTP_CID_ABORT:
-		pr_debug("SCTP_CID_ABORT\n");
 		i = 2;
 		break;
 	case SCTP_CID_SHUTDOWN:
-		pr_debug("SCTP_CID_SHUTDOWN\n");
 		i = 3;
 		break;
 	case SCTP_CID_SHUTDOWN_ACK:
-		pr_debug("SCTP_CID_SHUTDOWN_ACK\n");
 		i = 4;
 		break;
 	case SCTP_CID_ERROR:
-		pr_debug("SCTP_CID_ERROR\n");
 		i = 5;
 		break;
 	case SCTP_CID_COOKIE_ECHO:
-		pr_debug("SCTP_CID_COOKIE_ECHO\n");
 		i = 6;
 		break;
 	case SCTP_CID_COOKIE_ACK:
-		pr_debug("SCTP_CID_COOKIE_ACK\n");
 		i = 7;
 		break;
 	case SCTP_CID_SHUTDOWN_COMPLETE:
-		pr_debug("SCTP_CID_SHUTDOWN_COMPLETE\n");
 		i = 8;
 		break;
 	case SCTP_CID_HEARTBEAT:
-		pr_debug("SCTP_CID_HEARTBEAT");
 		i = 9;
 		break;
 	case SCTP_CID_HEARTBEAT_ACK:
-		pr_debug("SCTP_CID_HEARTBEAT_ACK");
 		i = 10;
 		break;
 	case SCTP_CID_DATA:
 	case SCTP_CID_SACK:
-		pr_debug("SCTP_CID_DATA/SACK");
 		i = 11;
 		break;
 	default:
 		/* Other chunks like DATA or SACK do not change the state */
-		pr_debug("Unknown chunk type, Will stay in %s\n",
-			 sctp_conntrack_names[cur_state]);
+		pr_debug("Unknown chunk type %d, Will stay in %s\n",
+			 chunk_type, sctp_conntrack_names[cur_state]);
 		return cur_state;
 	}
 
-	pr_debug("dir: %d   cur_state: %s  chunk_type: %d  new_state: %s\n",
-		 dir, sctp_conntrack_names[cur_state], chunk_type,
-		 sctp_conntrack_names[sctp_conntracks[dir][i][cur_state]]);
-
 	return sctp_conntracks[dir][i][cur_state];
 }
 
@@ -392,7 +374,7 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
 	if (sh == NULL)
 		goto out;
 
-	if (do_basic_checks(ct, skb, dataoff, map) != 0)
+	if (do_basic_checks(ct, skb, dataoff, map, state) != 0)
 		goto out;
 
 	if (!nf_ct_is_confirmed(ct)) {
@@ -414,7 +396,9 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
 		    !test_bit(SCTP_CID_HEARTBEAT, map) &&
 		    !test_bit(SCTP_CID_HEARTBEAT_ACK, map) &&
 		    sh->vtag != ct->proto.sctp.vtag[dir]) {
-			pr_debug("Verification tag check failed\n");
+			nf_ct_l4proto_log_invalid(skb, ct, state,
+						  "verification tag check failed %x vs %x for dir %d",
+						  sh->vtag, ct->proto.sctp.vtag[dir], dir);
 			goto out;
 		}
 	}
@@ -488,9 +472,10 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
 
 		/* Invalid */
 		if (new_state == SCTP_CONNTRACK_MAX) {
-			pr_debug("nf_conntrack_sctp: Invalid dir=%i ctype=%u "
-				 "conntrack=%u\n",
-				 dir, sch->type, old_state);
+			nf_ct_l4proto_log_invalid(skb, ct, state,
+						  "Invalid, old_state %d, dir %d, type %d",
+						  old_state, dir, sch->type);
+
 			goto out_unlock;
 		}
 
@@ -536,7 +521,6 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
 	if (old_state == SCTP_CONNTRACK_COOKIE_ECHOED &&
 	    dir == IP_CT_DIR_REPLY &&
 	    new_state == SCTP_CONNTRACK_ESTABLISHED) {
-		pr_debug("Setting assured bit\n");
 		set_bit(IPS_ASSURED_BIT, &ct->status);
 		nf_conntrack_event_cache(IPCT_ASSURED, ct);
 	}
-- 
2.38.2

