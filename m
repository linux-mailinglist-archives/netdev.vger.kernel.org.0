Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF2F64554FE
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 07:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243502AbhKRHAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 02:00:38 -0500
Received: from pi.codeconstruct.com.au ([203.29.241.158]:52416 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242647AbhKRHAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 02:00:35 -0500
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 3F5302022C; Thu, 18 Nov 2021 14:57:34 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] mctp/test: Update refcount checking in route fragment tests
Date:   Thu, 18 Nov 2021 14:57:23 +0800
Message-Id: <20211118065723.2808020-1-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In 99ce45d5e, we moved a route refcount decrement from
mctp_do_fragment_route into the caller. This invalidates the assumption
that the route test makes about refcount behaviour, so the route tests
fail.

This change fixes the test case to suit the new refcount behaviour.

Fixes: 99ce45d5e7db ("mctp: Implement extended addressing")
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 net/mctp/test/route-test.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/mctp/test/route-test.c b/net/mctp/test/route-test.c
index 36fac3daf86a..86ad15abf897 100644
--- a/net/mctp/test/route-test.c
+++ b/net/mctp/test/route-test.c
@@ -150,11 +150,6 @@ static void mctp_test_fragment(struct kunit *test)
 	rt = mctp_test_create_route(&init_net, NULL, 10, mtu);
 	KUNIT_ASSERT_TRUE(test, rt);
 
-	/* The refcount would usually be incremented as part of a route lookup,
-	 * but we're setting the route directly here.
-	 */
-	refcount_inc(&rt->rt.refs);
-
 	rc = mctp_do_fragment_route(&rt->rt, skb, mtu, MCTP_TAG_OWNER);
 	KUNIT_EXPECT_FALSE(test, rc);
 
-- 
2.30.2

