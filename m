Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCCD15A470F
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 12:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbiH2KX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 06:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiH2KXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 06:23:25 -0400
X-Greylist: delayed 598 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 29 Aug 2022 03:23:23 PDT
Received: from smtpservice.6wind.com (unknown [185.13.181.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9A036564EF;
        Mon, 29 Aug 2022 03:23:23 -0700 (PDT)
Received: from bretzel (bretzel.dev.6wind.com [10.17.1.57])
        by smtpservice.6wind.com (Postfix) with ESMTPS id 8DFD5600C2;
        Mon, 29 Aug 2022 12:03:27 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1oSbc7-00013K-Fq; Mon, 29 Aug 2022 12:03:27 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, Heng Qi <hengqi@linux.alibaba.com>,
        Edwin Brossette <edwin.brossette@6wind.com>,
        kernel test robot <lkp@intel.com>, lkp@lists.01.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        stable@vger.kernel.org, kernel test robot <yujie.liu@intel.com>
Subject: [PATCH net] ip: fix triggering of 'icmp redirect'
Date:   Mon, 29 Aug 2022 12:01:21 +0200
Message-Id: <20220829100121.3821-1-nicolas.dichtel@6wind.com>
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

__mkroute_input() uses fib_validate_source() to trigger an icmp redirect.
My understanding is that fib_validate_source() is used to know if the src
address and the gateway address are on the same link. For that,
fib_validate_source() returns 1 (same link) or 0 (not the same network).
__mkroute_input() is the only user of these positive values, all other
callers only look if the returned value is negative.

Since the below patch, fib_validate_source() didn't return anymore 1 when
both addresses are on the same network, because the route lookup returns
RT_SCOPE_LINK instead of RT_SCOPE_HOST. But this is, in fact, right.
Let's adapat the test to return 1 again when both addresses are on the same
link.

CC: stable@vger.kernel.org
Fixes: 747c14307214 ("ip: fix dflt addr selection for connected nexthop")
Reported-by: kernel test robot <yujie.liu@intel.com>
Reported-by: Heng Qi <hengqi@linux.alibaba.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---

This code exists since more than two decades:
https://git.kernel.org/pub/scm/linux/kernel/git/davem/netdev-vger-cvs.git/commit/?id=0c2c94df8133f

Please, feel free to comment if my analysis seems wrong.

Regards,
Nicolas

 net/ipv4/fib_frontend.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index f361d3d56be2..943edf4ad4db 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -389,7 +389,7 @@ static int __fib_validate_source(struct sk_buff *skb, __be32 src, __be32 dst,
 	dev_match = dev_match || (res.type == RTN_LOCAL &&
 				  dev == net->loopback_dev);
 	if (dev_match) {
-		ret = FIB_RES_NHC(res)->nhc_scope >= RT_SCOPE_HOST;
+		ret = FIB_RES_NHC(res)->nhc_scope >= RT_SCOPE_LINK;
 		return ret;
 	}
 	if (no_addr)
@@ -401,7 +401,7 @@ static int __fib_validate_source(struct sk_buff *skb, __be32 src, __be32 dst,
 	ret = 0;
 	if (fib_lookup(net, &fl4, &res, FIB_LOOKUP_IGNORE_LINKSTATE) == 0) {
 		if (res.type == RTN_UNICAST)
-			ret = FIB_RES_NHC(res)->nhc_scope >= RT_SCOPE_HOST;
+			ret = FIB_RES_NHC(res)->nhc_scope >= RT_SCOPE_LINK;
 	}
 	return ret;
 
-- 
2.33.0

