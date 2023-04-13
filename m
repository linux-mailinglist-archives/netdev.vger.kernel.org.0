Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE2D6E0B5B
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 12:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbjDMKYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 06:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbjDMKYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 06:24:47 -0400
Received: from hust.edu.cn (mail.hust.edu.cn [202.114.0.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE6D1FF3;
        Thu, 13 Apr 2023 03:24:45 -0700 (PDT)
Received: from fb20229aa3ce.us-central1-c.c.codatalab-user-runtimes.internal (254.140.184.35.bc.googleusercontent.com [35.184.140.254])
        (user=iccccc@hust.edu.cn mech=LOGIN bits=0)
        by mx1.hust.edu.cn  with ESMTP id 33DAAt5J005165-33DAAt5K005165
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Thu, 13 Apr 2023 18:11:11 +0800
From:   Haoyi Liu <iccccc@hust.edu.cn>
To:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     hust-os-kernel-patches@googlegroups.com, yalongz@hust.edu.cn,
        error27@gmail.com, Haoyi Liu <iccccc@hust.edu.cn>,
        Dongliang Mu <dzm91@hust.edu.cn>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2] net/ipv6: silence 'passing zero to ERR_PTR()' warning
Date:   Thu, 13 Apr 2023 10:10:05 +0000
Message-Id: <20230413101005.7504-1-iccccc@hust.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-FEAS-AUTH-USER: iccccc@hust.edu.cn
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Smatch complains that if xfrm_lookup() returns NULL then this does a
weird thing with "err":

    net/ ipv6/ icmp.c:411 icmpv6_route_lookup()
    warn: passing zero to ERR_PTR()

Merge conditional paths and remove unnecessary 'else'. No functional
change.

Signed-off-by: Haoyi Liu <iccccc@hust.edu.cn>
Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
---
v1->v2: Remove unnecessary 'else'.
The issue is found by static analysis, and the patch is remains untested.
---
 net/ipv6/icmp.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index 1f53f2a74480..a12eef11c7ee 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -393,17 +393,12 @@ static struct dst_entry *icmpv6_route_lookup(struct net *net,
 		goto relookup_failed;
 
 	dst2 = xfrm_lookup(net, dst2, flowi6_to_flowi(&fl2), sk, XFRM_LOOKUP_ICMP);
-	if (!IS_ERR(dst2)) {
-		dst_release(dst);
-		dst = dst2;
-	} else {
-		err = PTR_ERR(dst2);
-		if (err == -EPERM) {
-			dst_release(dst);
-			return dst2;
-		} else
-			goto relookup_failed;
-	}
+	err = PTR_ERR_OR_ZERO(dst2);
+	if (err && err != -EPERM)
+		goto relookup_failed;
+
+	dst_release(dst);
+	return dst2;	/* returns success or ERR_PTR(-EPERM) */
 
 relookup_failed:
 	if (dst)
-- 
2.40.0

