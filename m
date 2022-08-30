Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 806755A6632
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 16:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbiH3OXq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 30 Aug 2022 10:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiH3OXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 10:23:42 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 898C4B9FBD
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 07:23:41 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-50-gjwfiqMvP5OK_QwdGqrO7w-1; Tue, 30 Aug 2022 10:23:37 -0400
X-MC-Unique: gjwfiqMvP5OK_QwdGqrO7w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 65838101E989;
        Tue, 30 Aug 2022 14:23:36 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.195.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 95D0A40C141D;
        Tue, 30 Aug 2022 14:23:35 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 2/6] xfrm: add extack support to verify_newpolicy_info
Date:   Tue, 30 Aug 2022 16:23:08 +0200
Message-Id: <a0c1662bdc1502012dced1fc81f2deba55c5a38c.1661162395.git.sd@queasysnail.net>
In-Reply-To: <cover.1661162395.git.sd@queasysnail.net>
References: <cover.1661162395.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252; x-default=true
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
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
2.37.2

