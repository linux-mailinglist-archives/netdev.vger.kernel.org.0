Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68E614D713E
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 23:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbiCLWEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 17:04:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232367AbiCLWEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 17:04:30 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6B173D0050;
        Sat, 12 Mar 2022 14:03:23 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 84DA162FF3;
        Sat, 12 Mar 2022 23:01:13 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 1/3] Revert "netfilter: nat: force port remap to prevent shadowing well-known ports"
Date:   Sat, 12 Mar 2022 23:03:13 +0100
Message-Id: <20220312220315.64531-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220312220315.64531-1-pablo@netfilter.org>
References: <20220312220315.64531-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This reverts commit 878aed8db324bec64f3c3f956e64d5ae7375a5de.

This change breaks existing setups where conntrack is used with
asymmetric paths.

In these cases, the NAT transformation occurs on the syn-ack instead of
the syn:

1. SYN    x:12345 -> y -> 443 // sent by initiator, receiverd by responder
2. SYNACK y:443 -> x:12345 // First packet seen by conntrack, as sent by responder
3. tuple_force_port_remap() gets called, sees:
  'tcp from 443 to port 12345 NAT' -> pick a new source port, inititor receives
4. SYNACK y:$RANDOM -> x:12345   // connection is never established

While its possible to avoid the breakage with NOTRACK rules, a kernel
update should not break working setups.

An alternative to the revert is to augment conntrack to tag
mid-stream connections plus more code in the nat core to skip NAT
for such connections, however, this leads to more interaction/integration
between conntrack and NAT.

Therefore, revert, users will need to add explicit nat rules to avoid
port shadowing.

Link: https://lore.kernel.org/netfilter-devel/20220302105908.GA5852@breakpoint.cc/#R
Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=2051413
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_nat_core.c                  | 43 ++------------------
 tools/testing/selftests/netfilter/nft_nat.sh |  5 +--
 2 files changed, 5 insertions(+), 43 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 2d06a66899b2..ffcf6529afc3 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -494,38 +494,6 @@ static void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
 	goto another_round;
 }
 
-static bool tuple_force_port_remap(const struct nf_conntrack_tuple *tuple)
-{
-	u16 sp, dp;
-
-	switch (tuple->dst.protonum) {
-	case IPPROTO_TCP:
-		sp = ntohs(tuple->src.u.tcp.port);
-		dp = ntohs(tuple->dst.u.tcp.port);
-		break;
-	case IPPROTO_UDP:
-	case IPPROTO_UDPLITE:
-		sp = ntohs(tuple->src.u.udp.port);
-		dp = ntohs(tuple->dst.u.udp.port);
-		break;
-	default:
-		return false;
-	}
-
-	/* IANA: System port range: 1-1023,
-	 *         user port range: 1024-49151,
-	 *      private port range: 49152-65535.
-	 *
-	 * Linux default ephemeral port range is 32768-60999.
-	 *
-	 * Enforce port remapping if sport is significantly lower
-	 * than dport to prevent NAT port shadowing, i.e.
-	 * accidental match of 'new' inbound connection vs.
-	 * existing outbound one.
-	 */
-	return sp < 16384 && dp >= 32768;
-}
-
 /* Manipulate the tuple into the range given. For NF_INET_POST_ROUTING,
  * we change the source to map into the range. For NF_INET_PRE_ROUTING
  * and NF_INET_LOCAL_OUT, we change the destination to map into the
@@ -539,17 +507,11 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
 		 struct nf_conn *ct,
 		 enum nf_nat_manip_type maniptype)
 {
-	bool random_port = range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL;
 	const struct nf_conntrack_zone *zone;
 	struct net *net = nf_ct_net(ct);
 
 	zone = nf_ct_zone(ct);
 
-	if (maniptype == NF_NAT_MANIP_SRC &&
-	    !random_port &&
-	    !ct->local_origin)
-		random_port = tuple_force_port_remap(orig_tuple);
-
 	/* 1) If this srcip/proto/src-proto-part is currently mapped,
 	 * and that same mapping gives a unique tuple within the given
 	 * range, use that.
@@ -558,7 +520,8 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
 	 * So far, we don't do local source mappings, so multiple
 	 * manips not an issue.
 	 */
-	if (maniptype == NF_NAT_MANIP_SRC && !random_port) {
+	if (maniptype == NF_NAT_MANIP_SRC &&
+	    !(range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL)) {
 		/* try the original tuple first */
 		if (in_range(orig_tuple, range)) {
 			if (!nf_nat_used_tuple(orig_tuple, ct)) {
@@ -582,7 +545,7 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
 	 */
 
 	/* Only bother mapping if it's not already in range and unique */
-	if (!random_port) {
+	if (!(range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL)) {
 		if (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
 			if (!(range->flags & NF_NAT_RANGE_PROTO_OFFSET) &&
 			    l4proto_in_range(tuple, maniptype,
diff --git a/tools/testing/selftests/netfilter/nft_nat.sh b/tools/testing/selftests/netfilter/nft_nat.sh
index 79fe627b9e81..eb8543b9a5c4 100755
--- a/tools/testing/selftests/netfilter/nft_nat.sh
+++ b/tools/testing/selftests/netfilter/nft_nat.sh
@@ -880,9 +880,8 @@ EOF
 		return $ksft_skip
 	fi
 
-	# test default behaviour. Packet from ns1 to ns0 is not redirected
-	# due to automatic port translation.
-	test_port_shadow "default" "ROUTER"
+	# test default behaviour. Packet from ns1 to ns0 is redirected to ns2.
+	test_port_shadow "default" "CLIENT"
 
 	# test packet filter based mitigation: prevent forwarding of
 	# packets claiming to come from the service port.
-- 
2.30.2

