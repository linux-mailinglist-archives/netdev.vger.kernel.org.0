Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5070564DF4E
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 18:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbiLORGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 12:06:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbiLORGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 12:06:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BEE94A582;
        Thu, 15 Dec 2022 09:04:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28C1661AE9;
        Thu, 15 Dec 2022 17:03:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43445C433EF;
        Thu, 15 Dec 2022 17:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671123811;
        bh=u0KSgYTkV2U77f0/Zntx9WBbO1DjEIog/utLYU5Ak/4=;
        h=From:To:Cc:Subject:Date:From;
        b=uPCpdBejXEKb1/niS//KWNiuPjmrUe1FJe5QumUGvx4HgWxbjb7Zsn6cxqre9O5BD
         6QqoBj/k4yW83WGU7u6CZ5BxEq0VXuoyIWs/8+IMwGL5KVl+XMf8eMOnHfm5SiUz+j
         84XwJuSlhvWlk48/K+mPBp9onxWU7Wc2IZOZ5iuRjpW3m8RZgcb1/N3y0P+9Z8por8
         htWMh4HOZKV9fKrnOGuPJ2jsWvOuZNnnYngISc0ia1gb6RMgR0OeFqyh5MZ2nM8t98
         CTh+f1yJN20qOIsUdbOMb5HpWhpquzbbYvbE3tlJ8jBSgu0wpoGvGqhttGSlv7g+vU
         66ovFs7tXj6xg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jiri Wiesner <jwiesner@suse.de>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ipvs: use div_s64 for signed division
Date:   Thu, 15 Dec 2022 18:03:15 +0100
Message-Id: <20221215170324.2579685-1-arnd@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

do_div() is only well-behaved for positive numbers, and now warns
when the first argument is a an s64:

net/netfilter/ipvs/ip_vs_est.c: In function 'ip_vs_est_calc_limits':
include/asm-generic/div64.h:222:35: error: comparison of distinct pointer types lacks a cast [-Werror]
  222 |         (void)(((typeof((n)) *)0) == ((uint64_t *)0));  \
      |                                   ^~
net/netfilter/ipvs/ip_vs_est.c:694:17: note: in expansion of macro 'do_div'
  694 |                 do_div(val, loops);

Convert to using the more appropriate div_s64(), which also
simplifies the code a bit.

Fixes: 705dd3444081 ("ipvs: use kthreads for stats estimation")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/netfilter/ipvs/ip_vs_est.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_est.c b/net/netfilter/ipvs/ip_vs_est.c
index ce2a1549b304..dbc32f8cf1f9 100644
--- a/net/netfilter/ipvs/ip_vs_est.c
+++ b/net/netfilter/ipvs/ip_vs_est.c
@@ -691,15 +691,13 @@ static int ip_vs_est_calc_limits(struct netns_ipvs *ipvs, int *chain_max)
 		}
 		if (diff >= NSEC_PER_SEC)
 			continue;
-		val = diff;
-		do_div(val, loops);
+		val = div_s64(diff, loops);
 		if (!min_est || val < min_est) {
 			min_est = val;
 			/* goal: 95usec per chain */
 			val = 95 * NSEC_PER_USEC;
 			if (val >= min_est) {
-				do_div(val, min_est);
-				max = (int)val;
+				max = div_s64(val, min_est);
 			} else {
 				max = 1;
 			}
-- 
2.35.1

