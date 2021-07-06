Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 328783BC85B
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 11:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbhGFJQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 05:16:21 -0400
Received: from host.78.145.23.62.rev.coltfrance.com ([62.23.145.78]:50338 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230295AbhGFJQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 05:16:20 -0400
Received: from bretzel (unknown [10.16.0.57])
        by proxy.6wind.com (Postfix) with ESMTPS id 5EB31A670CA;
        Tue,  6 Jul 2021 11:13:41 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1m0h9B-00087q-B2; Tue, 06 Jul 2021 11:13:41 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     steffen.klassert@secunet.com, netdev@vger.kernel.org,
        dforster@brocade.com, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net] ipv6: fix 'disable_policy' for fwd packets
Date:   Tue,  6 Jul 2021 11:13:35 +0200
Message-Id: <20210706091335.30103-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The goal of commit df789fe75206 ("ipv6: Provide ipv6 version of
"disable_policy" sysctl") was to have the disable_policy from ipv4
available on ipv6.
However, it's not exactly the same mechanism. On IPv4, all packets coming
from an interface, which has disable_policy set, bypass the policy check.
For ipv6, this is done only for local packets, ie for packets destinated to
an address configured on the incoming interface.

Let's align ipv6 with ipv4 so that the 'disable_policy' sysctl has the same
effect for both protocols.

My first approach was to create a new kind of route cache entries, to be
able to set DST_NOPOLICY without modifying routes. This would have added a
lot of code. Because the local delivery path is already handled, I choose
to focus on the forwarding path to minimize code churn.

Fixes: df789fe75206 ("ipv6: Provide ipv6 version of "disable_policy" sysctl")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 net/ipv6/ip6_output.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 984050f35c61..d4ee2169afd8 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -479,7 +479,9 @@ int ip6_forward(struct sk_buff *skb)
 	if (skb_warn_if_lro(skb))
 		goto drop;
 
-	if (!xfrm6_policy_check(NULL, XFRM_POLICY_FWD, skb)) {
+	if (!net->ipv6.devconf_all->disable_policy &&
+	    !idev->cnf.disable_policy &&
+	    !xfrm6_policy_check(NULL, XFRM_POLICY_FWD, skb)) {
 		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INDISCARDS);
 		goto drop;
 	}
-- 
2.30.0

