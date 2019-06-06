Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4D1F37DE6
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 22:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbfFFUOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 16:14:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51836 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727082AbfFFUOR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 16:14:17 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 70066307D840;
        Thu,  6 Jun 2019 20:14:12 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 342D627C57;
        Thu,  6 Jun 2019 20:14:09 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        David Ahern <dsahern@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Subject: [PATCH net 2/2] ip6_fib: Don't discard nodes with valid routing information in fib6_locate_1()
Date:   Thu,  6 Jun 2019 22:13:42 +0200
Message-Id: <e87dd6e8229ea2ec9918b9ac7ad86f222a881208.1559851514.git.sbrivio@redhat.com>
In-Reply-To: <cover.1559851514.git.sbrivio@redhat.com>
References: <cover.1559851514.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 06 Jun 2019 20:14:17 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we perform an inexact match on FIB nodes via fib6_locate_1(), longer
prefixes will be preferred to shorter ones. However, it might happen that
a node, with higher fn_bit value than some other, has no valid routing
information.

In this case, we'll pick that node, but it will be discarded by the check
on RTN_RTINFO in fib6_locate(), and we might miss nodes with valid routing
information but with lower fn_bit value.

This is apparent when a routing exception is created for a default route:
 # ip -6 route list
 fc00:1::/64 dev veth_A-R1 proto kernel metric 256 pref medium
 fc00:2::/64 dev veth_A-R2 proto kernel metric 256 pref medium
 fc00:4::1 via fc00:2::2 dev veth_A-R2 metric 1024 pref medium
 fe80::/64 dev veth_A-R1 proto kernel metric 256 pref medium
 fe80::/64 dev veth_A-R2 proto kernel metric 256 pref medium
 default via fc00:1::2 dev veth_A-R1 metric 1024 pref medium
 # ip -6 route list cache
 fc00:4::1 via fc00:2::2 dev veth_A-R2 metric 1024 expires 593sec mtu 1500 pref medium
 fc00:3::1 via fc00:1::2 dev veth_A-R1 metric 1024 expires 593sec mtu 1500 pref medium
 # ip -6 route flush cache    # node for default route is discarded
 Failed to send flush request: No such process
 # ip -6 route list cache
 fc00:3::1 via fc00:1::2 dev veth_A-R1 metric 1024 expires 586sec mtu 1500 pref medium

Check right away if the node has a RTN_RTINFO flag, before replacing the
'prev' pointer, that indicates the longest matching prefix found so far.

Fixes: 38fbeeeeccdb ("ipv6: prepare fib6_locate() for exception table")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 net/ipv6/ip6_fib.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 5be133565819..d8b9f4d801e3 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1537,7 +1537,8 @@ static struct fib6_node *fib6_locate_1(struct fib6_node *root,
 		if (plen == fn->fn_bit)
 			return fn;
 
-		prev = fn;
+		if (fn->fn_flags & RTN_RTINFO)
+			prev = fn;
 
 next:
 		/*
-- 
2.20.1

