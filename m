Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8715ACC4
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 19:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbfF2R4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 13:56:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44382 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726864AbfF2R4T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Jun 2019 13:56:19 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1430CC057EC6;
        Sat, 29 Jun 2019 17:56:19 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D719319C69;
        Sat, 29 Jun 2019 17:56:17 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH] ipv4: Fix off-by-one in route dump counter without netlink strict checking
Date:   Sat, 29 Jun 2019 19:55:08 +0200
Message-Id: <74faa085e6af026f8b9f0d3cce8a94147781f257.1561830851.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Sat, 29 Jun 2019 17:56:19 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit ee28906fd7a1 ("ipv4: Dump route exceptions if requested") I
added a counter of per-node dumped routes (including actual routes and
exceptions), analogous to the existing counter for dumped nodes. Dumping
exceptions means we need to also keep track of how many routes are dumped
for each node: this would be just one route per node, without exceptions.

When netlink strict checking is not enabled, we dump both routes and
exceptions at the same time: the RTM_F_CLONED flag is not used as a
filter. In this case, the per-node counter 'i_fa' is incremented by one
to track the single dumped route, then also incremented by one for each
exception dumped, and then stored as netlink callback argument as skip
counter, 's_fa', to be used when a partial dump operation restarts.

The per-node counter needs to be increased by one also when we skip a
route (exception) due to a previous non-zero skip counter, because it
needs to match the existing skip counter, if we are dumping both routes
and exceptions. I missed this, and only incremented the counter, for
regular routes, if the previous skip counter was zero. This means that,
in case of a mixed dump, partial dump operations after the first one
will start with a mismatching skip counter value, one less than expected.

This means in turn that the first exception for a given node is skipped
every time a partial dump operation restarts, if netlink strict checking
is not enabled (iproute < 5.0).

It turns out I didn't repeat the test in its final version, commit
de755a85130e ("selftests: pmtu: Introduce list_flush_ipv4_exception test
case"), which also counts the number of route exceptions returned, with
iproute2 versions < 5.0 -- I was instead using the equivalent of the IPv6
test as it was before commit b964641e9925 ("selftests: pmtu: Make
list_flush_ipv6_exception test more demanding").

Always increment the per-node counter by one if we previously dumped
a regular route, so that it matches the current skip counter.

Fixes: ee28906fd7a1 ("ipv4: Dump route exceptions if requested")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 net/ipv4/fib_trie.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 4400f5051977..2b2b3d291ab0 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -2126,14 +2126,20 @@ static int fn_trie_dump_leaf(struct key_vector *l, struct fib_table *tb,
 				goto next;
 		}
 
-		if (filter->dump_routes && !s_fa) {
-			err = fib_dump_info(skb, NETLINK_CB(cb->skb).portid,
-					    cb->nlh->nlmsg_seq, RTM_NEWROUTE,
-					    tb->tb_id, fa->fa_type,
-					    xkey, KEYLENGTH - fa->fa_slen,
-					    fa->fa_tos, fi, flags);
-			if (err < 0)
-				goto stop;
+		if (filter->dump_routes) {
+			if (!s_fa) {
+				err = fib_dump_info(skb,
+						    NETLINK_CB(cb->skb).portid,
+						    cb->nlh->nlmsg_seq,
+						    RTM_NEWROUTE,
+						    tb->tb_id, fa->fa_type,
+						    xkey,
+						    KEYLENGTH - fa->fa_slen,
+						    fa->fa_tos, fi, flags);
+				if (err < 0)
+					goto stop;
+			}
+
 			i_fa++;
 		}
 
-- 
2.20.1

