Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 103A24EE661
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 05:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244318AbiDADDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 23:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244310AbiDADDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 23:03:54 -0400
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384AC25719A
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 20:02:05 -0700 (PDT)
Received: by codeconstruct.com.au (Postfix, from userid 10001)
        id 213D3213EB; Fri,  1 Apr 2022 11:02:01 +0800 (AWST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=codeconstruct.com.au; s=2022a; t=1648782121;
        bh=oKP1sd5SSLgBKEUChVFe/9PqdFvNZQIYqA6yRuAl9bY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=dO1MNu6eQfmxYzI2CCT0awh2LoaheEVzMk4FumWj4W+JkGjwKCpnCGEUTj3LwHjnW
         C4XaokE4DbpejyZThoXDfl7uNToVr3bA7ysOqlmlfOhN9ZXc6ARUco6H3CK5zQdD6+
         ocNq2Pghsl5BSZvk0AN6i3d9l96ub1ioxwOI1TEa7EB7HwFeGjWWx/yhGFmCxkj6FQ
         sDNcRCJAbMqxHBwhyMUmvpFyF7ywijH2QNDRRSwokr3jgH9mycY6uYRMzTPi1JXHGx
         PGVviv2PGA9YER+M9r2ioBz090hDThB9UXhftg5WgyN2OPsRqXKmEXEYWrktsrGtx5
         MkzODf5oEprtg==
From:   Matt Johnston <matt@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     mjrinal@g.clemson.edu, jk@codeconstruct.com.au,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net 1/3] mctp: Fix check for dev_hard_header() result
Date:   Fri,  1 Apr 2022 10:48:42 +0800
Message-Id: <20220401024844.1578937-2-matt@codeconstruct.com.au>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220401024844.1578937-1-matt@codeconstruct.com.au>
References: <20220401024844.1578937-1-matt@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dev_hard_header() returns the length of the header, so
we need to test for negative errors rather than non-zero.

Fixes: 889b7da23abf ("mctp: Add initial routing framework")
Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
---
 net/mctp/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mctp/route.c b/net/mctp/route.c
index d5e7db83fe9d..ee548c46c78f 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -512,7 +512,7 @@ static int mctp_route_output(struct mctp_route *route, struct sk_buff *skb)
 
 	rc = dev_hard_header(skb, skb->dev, ntohs(skb->protocol),
 			     daddr, skb->dev->dev_addr, skb->len);
-	if (rc) {
+	if (rc < 0) {
 		kfree_skb(skb);
 		return -EHOSTUNREACH;
 	}
-- 
2.32.0

