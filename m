Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99548605BE0
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 12:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbiJTKKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 06:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbiJTKKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 06:10:12 -0400
Received: from smtpservice.6wind.com (unknown [185.13.181.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 199EB45F68
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 03:09:58 -0700 (PDT)
Received: from bretzel (bretzel.dev.6wind.com [10.17.1.57])
        by smtpservice.6wind.com (Postfix) with ESMTPS id 6F444601E2;
        Thu, 20 Oct 2022 12:09:57 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1olSUv-0003b9-Bq; Thu, 20 Oct 2022 12:09:57 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Julian Anastasov <ja@ssi.bg>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net 2/3] Revert "ip: fix dflt addr selection for connected nexthop"
Date:   Thu, 20 Oct 2022 12:09:51 +0200
Message-Id: <20221020100952.8748-3-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221020100952.8748-1-nicolas.dichtel@6wind.com>
References: <20221020100952.8748-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 747c14307214b55dbd8250e1ab44cad8305756f1.

As explained by Julian, nhc_scope is related to nhc_gw, not to the route.
Revert the original patch. The initial problem is fixed differently in the
next commit.

Link: https://lore.kernel.org/netdev/6c8a44ba-c2d5-cdf-c5c7-5baf97cba38@ssi.bg/
CC: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 net/ipv4/fib_semantics.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index e9a7f70a54df..f721c308248b 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1231,7 +1231,7 @@ static int fib_check_nh_nongw(struct net *net, struct fib_nh *nh,
 
 	nh->fib_nh_dev = in_dev->dev;
 	netdev_hold(nh->fib_nh_dev, &nh->fib_nh_dev_tracker, GFP_ATOMIC);
-	nh->fib_nh_scope = RT_SCOPE_LINK;
+	nh->fib_nh_scope = RT_SCOPE_HOST;
 	if (!netif_carrier_ok(nh->fib_nh_dev))
 		nh->fib_nh_flags |= RTNH_F_LINKDOWN;
 	err = 0;
-- 
2.37.3

