Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B917E4EC7A
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 17:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbfFUPrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 11:47:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58604 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726469AbfFUPrJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jun 2019 11:47:09 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EB5CD30C1AE7;
        Fri, 21 Jun 2019 15:47:08 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8FD2B19C4F;
        Fri, 21 Jun 2019 15:47:05 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>, David Ahern <dsahern@gmail.com>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
Subject: [PATCH net-next v7 06/11] ipv6/route: Don't match on fc_nh_id if not set in ip6_route_del()
Date:   Fri, 21 Jun 2019 17:45:25 +0200
Message-Id: <3450805b83561af0a7de249da6bf860aee4d2524.1561131177.git.sbrivio@redhat.com>
In-Reply-To: <cover.1561131177.git.sbrivio@redhat.com>
References: <cover.1561131177.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Fri, 21 Jun 2019 15:47:09 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If fc_nh_id isn't set, we shouldn't try to match against it. This
actually matters just for the RTF_CACHE below (where this case is
already handled): if iproute2 gets a route exception and tries to
delete it, it won't reference it by fc_nh_id, even if a nexthop
object might be associated to the originating route.

Fixes: 5b98324ebe29 ("ipv6: Allow routes to use nexthop objects")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
---
v7: No changes

v6: New patch

 net/ipv6/route.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index c4d285fe0adc..86859023cd01 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3827,7 +3827,8 @@ static int ip6_route_del(struct fib6_config *cfg,
 		for_each_fib6_node_rt_rcu(fn) {
 			struct fib6_nh *nh;
 
-			if (rt->nh && rt->nh->id != cfg->fc_nh_id)
+			if (rt->nh && cfg->fc_nh_id &&
+			    rt->nh->id != cfg->fc_nh_id)
 				continue;
 
 			if (cfg->fc_flags & RTF_CACHE) {
-- 
2.20.1

