Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCD96DA81C
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 05:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbjDGDyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 23:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbjDGDyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 23:54:47 -0400
Received: from hust.edu.cn (mail.hust.edu.cn [202.114.0.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0255B4C2F;
        Thu,  6 Apr 2023 20:54:45 -0700 (PDT)
Received: from 544c38f4e6dd.us-east4-c.c.codatalab-user-runtimes.internal (152.111.245.35.bc.googleusercontent.com [35.245.111.152])
        (user=iccccc@hust.edu.cn mech=LOGIN bits=0)
        by mx1.hust.edu.cn  with ESMTP id 3373r0ch004804-3373r0ci004804
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Fri, 7 Apr 2023 11:53:08 +0800
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
Subject: [PATCH net-next] net/ipv6: silence 'passing zero to ERR_PTR()' warning
Date:   Fri,  7 Apr 2023 03:50:58 +0000
Message-Id: <20230407035058.8373-1-iccccc@hust.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-FEAS-AUTH-USER: iccccc@hust.edu.cn
X-Spam-Status: No, score=1.0 required=5.0 tests=HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no
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

Just return "dst2" directly instead of assigning it to"dst" and then
looking up the value of "err".  No functional change.

Signed-off-by: Haoyi Liu <iccccc@hust.edu.cn>
Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
---
The issue is found by static analysis, and the patch is remains untested.
---
 net/ipv6/icmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index 1f53f2a74480..a5e77acead89 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -395,7 +395,7 @@ static struct dst_entry *icmpv6_route_lookup(struct net *net,
 	dst2 = xfrm_lookup(net, dst2, flowi6_to_flowi(&fl2), sk, XFRM_LOOKUP_ICMP);
 	if (!IS_ERR(dst2)) {
 		dst_release(dst);
-		dst = dst2;
+		return dst2;
 	} else {
 		err = PTR_ERR(dst2);
 		if (err == -EPERM) {
-- 
2.25.1

