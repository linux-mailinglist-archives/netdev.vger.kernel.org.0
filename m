Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 525E0605BDF
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 12:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbiJTKKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 06:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiJTKKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 06:10:12 -0400
Received: from smtpservice.6wind.com (unknown [185.13.181.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 198B745F44
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 03:09:58 -0700 (PDT)
Received: from bretzel (bretzel.dev.6wind.com [10.17.1.57])
        by smtpservice.6wind.com (Postfix) with ESMTPS id 6CE69600F7;
        Thu, 20 Oct 2022 12:09:57 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1olSUv-0003b6-BN; Thu, 20 Oct 2022 12:09:57 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Julian Anastasov <ja@ssi.bg>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net 1/3] Revert "ip: fix triggering of 'icmp redirect'"
Date:   Thu, 20 Oct 2022 12:09:50 +0200
Message-Id: <20221020100952.8748-2-nicolas.dichtel@6wind.com>
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

This reverts commit eb55dc09b5dd040232d5de32812cc83001a23da6.

The patch that introduces this bug is reverted right after this one.

CC: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 net/ipv4/fib_frontend.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 943edf4ad4db..f361d3d56be2 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -389,7 +389,7 @@ static int __fib_validate_source(struct sk_buff *skb, __be32 src, __be32 dst,
 	dev_match = dev_match || (res.type == RTN_LOCAL &&
 				  dev == net->loopback_dev);
 	if (dev_match) {
-		ret = FIB_RES_NHC(res)->nhc_scope >= RT_SCOPE_LINK;
+		ret = FIB_RES_NHC(res)->nhc_scope >= RT_SCOPE_HOST;
 		return ret;
 	}
 	if (no_addr)
@@ -401,7 +401,7 @@ static int __fib_validate_source(struct sk_buff *skb, __be32 src, __be32 dst,
 	ret = 0;
 	if (fib_lookup(net, &fl4, &res, FIB_LOOKUP_IGNORE_LINKSTATE) == 0) {
 		if (res.type == RTN_UNICAST)
-			ret = FIB_RES_NHC(res)->nhc_scope >= RT_SCOPE_LINK;
+			ret = FIB_RES_NHC(res)->nhc_scope >= RT_SCOPE_HOST;
 	}
 	return ret;
 
-- 
2.37.3

