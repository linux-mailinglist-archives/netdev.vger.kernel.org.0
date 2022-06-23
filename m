Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A09D5579F9
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 14:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231714AbiFWMF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 08:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiFWMF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 08:05:58 -0400
X-Greylist: delayed 314 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 23 Jun 2022 05:05:58 PDT
Received: from smtpservice.6wind.com (unknown [185.13.181.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 247674B43C
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 05:05:58 -0700 (PDT)
Received: from bretzel (bretzel.dev.6wind.com [10.17.1.57])
        by smtpservice.6wind.com (Postfix) with ESMTPS id 3411A60011;
        Thu, 23 Jun 2022 14:00:17 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1o4LVR-0008Uk-2n; Thu, 23 Jun 2022 14:00:17 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Steffen Klassert <klassert@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>, stable@kernel.org,
        David Forster <dforster@brocade.com>,
        Siwar Zitouni <siwar.zitouni@6wind.com>
Subject: [PATCH net] ipv6: take care of disable_policy when restoring routes
Date:   Thu, 23 Jun 2022 14:00:15 +0200
Message-Id: <20220623120015.32640-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When routes corresponding to addresses are restored by
fixup_permanent_addr(), the dst_nopolicy parameter was not set.
The typical use case is a user that configures an address on a down
interface and then put this interface up.

Let's take care of this flag in addrconf_f6i_alloc(), so that every callers
benefit ont it.

CC: stable@kernel.org
CC: David Forster <dforster@brocade.com>
Fixes: df789fe75206 ("ipv6: Provide ipv6 version of "disable_policy" sysctl")
Reported-by: Siwar Zitouni <siwar.zitouni@6wind.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---

I choose to be conservative in my patch, thus I filter anycast addresses. But
I don't see why this flag is not set on anycast routes. Any thoughts
about this?

 net/ipv6/addrconf.c | 4 ----
 net/ipv6/route.c    | 9 ++++++++-
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 1b1932502e9e..5864cbc30db6 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1109,10 +1109,6 @@ ipv6_add_addr(struct inet6_dev *idev, struct ifa6_config *cfg,
 		goto out;
 	}
 
-	if (net->ipv6.devconf_all->disable_policy ||
-	    idev->cnf.disable_policy)
-		f6i->dst_nopolicy = true;
-
 	neigh_parms_data_state_setall(idev->nd_parms);
 
 	ifa->addr = *cfg->pfx;
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index d25dc83bac62..828355710c57 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4569,8 +4569,15 @@ struct fib6_info *addrconf_f6i_alloc(struct net *net,
 	}
 
 	f6i = ip6_route_info_create(&cfg, gfp_flags, NULL);
-	if (!IS_ERR(f6i))
+	if (!IS_ERR(f6i)) {
 		f6i->dst_nocount = true;
+
+		if (!anycast &&
+		    (net->ipv6.devconf_all->disable_policy ||
+		     idev->cnf.disable_policy))
+			f6i->dst_nopolicy = true;
+	}
+
 	return f6i;
 }
 
-- 
2.33.0

