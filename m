Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A30C289079
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 20:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390357AbgJISCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 14:02:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390311AbgJISCu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 14:02:50 -0400
Received: from Davids-MacBook-Pro.local.net (unknown [72.164.175.30])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3B002158C;
        Fri,  9 Oct 2020 18:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602266570;
        bh=xmcaceTugzVMaxTHV0RO1DC2hmeiZ3xKDCkkJInmxgM=;
        h=From:To:Cc:Subject:Date:From;
        b=NAajQLT+QAG30/i7iGRyUY1SqTZOQftA9zZBfv1zakLbzQbobDzHEHIADNA/VN4pK
         xANDd9cujhwKk8b6t1Aoc2Ed7ga/lV8YWkA77cXBPiaiXD7Ijvf3KALTaTOGTgJT76
         mS0lroLNoXf/Vlqs2nlvQhwfwajCInEXxijzM6t4=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        David Ahern <dsahern@kernel.org>,
        Tobias Brunner <tobias@strongswan.org>
Subject: [PATCH net] ipv4: Restore flowi4_oif update before call to xfrm_lookup_route
Date:   Fri,  9 Oct 2020 11:01:01 -0700
Message-Id: <20201009180101.5092-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tobias reported regressions in IPsec tests following the patch
referenced by the Fixes tag below. The root cause is dropping the
reset of the flowi4_oif after the fib_lookup. Apparently it is
needed for xfrm cases, so restore the oif update to ip_route_output_flow
right before the call to xfrm_lookup_route.

Fixes: 2fbc6e89b2f1 ("ipv4: Update exception handling for multipath routes via same device")
Reported-by: Tobias Brunner <tobias@strongswan.org>
Signed-off-by: David Ahern <dsahern@kernel.org>
---
 net/ipv4/route.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 58642b29a499..9bd30fd4de4b 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2769,10 +2769,12 @@ struct rtable *ip_route_output_flow(struct net *net, struct flowi4 *flp4,
 	if (IS_ERR(rt))
 		return rt;
 
-	if (flp4->flowi4_proto)
+	if (flp4->flowi4_proto) {
+		flp4->flowi4_oif = rt->dst.dev->ifindex;
 		rt = (struct rtable *)xfrm_lookup_route(net, &rt->dst,
 							flowi4_to_flowi(flp4),
 							sk, 0);
+	}
 
 	return rt;
 }
-- 
2.24.3 (Apple Git-128)

