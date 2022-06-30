Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22025561B63
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 15:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235309AbiF3Nba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 09:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235315AbiF3Nb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 09:31:27 -0400
Received: from eidolon.nox.tf (eidolon.nox.tf [IPv6:2a07:2ec0:2185::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B813335C
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 06:31:26 -0700 (PDT)
Received: from [2a02:169:59c5:1:c73e:2f64:7ea2:a8b1] (helo=areia)
        by eidolon.nox.tf with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <equinox@diac24.net>)
        id 1o6uGT-008EI5-5e; Thu, 30 Jun 2022 15:31:25 +0200
Received: from equinox by areia with local (Exim 4.96)
        (envelope-from <equinox@diac24.net>)
        id 1o6uG6-000Aqi-2x;
        Thu, 30 Jun 2022 15:31:02 +0200
From:   David Lamparter <equinox@diac24.net>
To:     netdev@vger.kernel.org
Cc:     David Lamparter <equinox@diac24.net>
Subject: [PATCH 1/2] ipv6: make rtm_ipv6_policy available
Date:   Thu, 30 Jun 2022 15:30:50 +0200
Message-Id: <20220630133051.41685-2-equinox@diac24.net>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220630133051.41685-1-equinox@diac24.net>
References: <20220630133051.41685-1-equinox@diac24.net>
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

... so ip6mr.c can use it too (as it is in IPv4.)

Signed-off-by: David Lamparter <equinox@diac24.net>
---

1:1 analog to IPv4, where rtm_ipv4_policy is exposed for pretty exactly
the same thing.  IPv6 just got away with not using this across file
boundaries so far.

---
 include/net/ip6_fib.h | 1 +
 net/ipv6/route.c      | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 6268963d9599..a12fedea97de 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -483,6 +483,7 @@ void rt6_get_prefsrc(const struct rt6_info *rt, struct in6_addr *addr)
 	rcu_read_unlock();
 }
 
+extern const struct nla_policy rtm_ipv6_policy[];
 int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
 		 struct fib6_config *cfg, gfp_t gfp_flags,
 		 struct netlink_ext_ack *extack);
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 1d6f75eef4bd..26c7b31abe96 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4964,7 +4964,7 @@ void rt6_mtu_change(struct net_device *dev, unsigned int mtu)
 	fib6_clean_all(dev_net(dev), rt6_mtu_change_route, &arg);
 }
 
-static const struct nla_policy rtm_ipv6_policy[RTA_MAX+1] = {
+const struct nla_policy rtm_ipv6_policy[RTA_MAX+1] = {
 	[RTA_UNSPEC]		= { .strict_start_type = RTA_DPORT + 1 },
 	[RTA_GATEWAY]           = { .len = sizeof(struct in6_addr) },
 	[RTA_PREFSRC]		= { .len = sizeof(struct in6_addr) },
-- 
2.36.1

