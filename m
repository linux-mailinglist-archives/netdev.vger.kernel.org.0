Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 953815F21F9
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 10:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiJBIRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 04:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiJBIRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 04:17:31 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC6D3F1E7
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 01:17:28 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 3B12120549;
        Sun,  2 Oct 2022 10:17:26 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id iA4jPkxqsSu0; Sun,  2 Oct 2022 10:17:25 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id ADA9720569;
        Sun,  2 Oct 2022 10:17:23 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 9ECFE80004A;
        Sun,  2 Oct 2022 10:17:23 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 2 Oct 2022 10:17:23 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sun, 2 Oct
 2022 10:17:23 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 060D83182A17; Sun,  2 Oct 2022 10:17:22 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 07/24] xfrm: add extack support to verify_newpolicy_info
Date:   Sun, 2 Oct 2022 10:16:55 +0200
Message-ID: <20221002081712.757515-8-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221002081712.757515-1-steffen.klassert@secunet.com>
References: <20221002081712.757515-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_user.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index cfa35d76fb7e..fa6024b2c88b 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1512,7 +1512,8 @@ static int verify_policy_type(u8 type)
 	return 0;
 }
 
-static int verify_newpolicy_info(struct xfrm_userpolicy_info *p)
+static int verify_newpolicy_info(struct xfrm_userpolicy_info *p,
+				 struct netlink_ext_ack *extack)
 {
 	int ret;
 
@@ -1524,6 +1525,7 @@ static int verify_newpolicy_info(struct xfrm_userpolicy_info *p)
 		break;
 
 	default:
+		NL_SET_ERR_MSG(extack, "Invalid policy share");
 		return -EINVAL;
 	}
 
@@ -1533,35 +1535,44 @@ static int verify_newpolicy_info(struct xfrm_userpolicy_info *p)
 		break;
 
 	default:
+		NL_SET_ERR_MSG(extack, "Invalid policy action");
 		return -EINVAL;
 	}
 
 	switch (p->sel.family) {
 	case AF_INET:
-		if (p->sel.prefixlen_d > 32 || p->sel.prefixlen_s > 32)
+		if (p->sel.prefixlen_d > 32 || p->sel.prefixlen_s > 32) {
+			NL_SET_ERR_MSG(extack, "Invalid prefix length in selector (must be <= 32 for IPv4)");
 			return -EINVAL;
+		}
 
 		break;
 
 	case AF_INET6:
 #if IS_ENABLED(CONFIG_IPV6)
-		if (p->sel.prefixlen_d > 128 || p->sel.prefixlen_s > 128)
+		if (p->sel.prefixlen_d > 128 || p->sel.prefixlen_s > 128) {
+			NL_SET_ERR_MSG(extack, "Invalid prefix length in selector (must be <= 128 for IPv6)");
 			return -EINVAL;
+		}
 
 		break;
 #else
+		NL_SET_ERR_MSG(extack, "IPv6 support disabled");
 		return  -EAFNOSUPPORT;
 #endif
 
 	default:
+		NL_SET_ERR_MSG(extack, "Invalid selector family");
 		return -EINVAL;
 	}
 
 	ret = verify_policy_dir(p->dir);
 	if (ret)
 		return ret;
-	if (p->index && (xfrm_policy_id2dir(p->index) != p->dir))
+	if (p->index && (xfrm_policy_id2dir(p->index) != p->dir)) {
+		NL_SET_ERR_MSG(extack, "Policy index doesn't match direction");
 		return -EINVAL;
+	}
 
 	return 0;
 }
@@ -1768,7 +1779,7 @@ static int xfrm_add_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 	int err;
 	int excl;
 
-	err = verify_newpolicy_info(p);
+	err = verify_newpolicy_info(p, extack);
 	if (err)
 		return err;
 	err = verify_sec_ctx_len(attrs);
@@ -2501,7 +2512,7 @@ static int xfrm_add_acquire(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	xfrm_mark_get(attrs, &mark);
 
-	err = verify_newpolicy_info(&ua->policy);
+	err = verify_newpolicy_info(&ua->policy, extack);
 	if (err)
 		goto free_state;
 	err = verify_sec_ctx_len(attrs);
@@ -3284,7 +3295,7 @@ static struct xfrm_policy *xfrm_compile_policy(struct sock *sk, int opt,
 	*dir = -EINVAL;
 
 	if (len < sizeof(*p) ||
-	    verify_newpolicy_info(p))
+	    verify_newpolicy_info(p, NULL))
 		return NULL;
 
 	nr = ((len - sizeof(*p)) / sizeof(*ut));
-- 
2.25.1

