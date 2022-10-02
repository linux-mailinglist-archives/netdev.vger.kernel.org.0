Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB1E5F21FB
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 10:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiJBIRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 04:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbiJBIRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 04:17:31 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB8E3F1EF
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 01:17:28 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 8132520569;
        Sun,  2 Oct 2022 10:17:26 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id R4JudzfDvpDM; Sun,  2 Oct 2022 10:17:25 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id D11092053D;
        Sun,  2 Oct 2022 10:17:23 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id C0F8380004A;
        Sun,  2 Oct 2022 10:17:23 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 2 Oct 2022 10:17:23 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sun, 2 Oct
 2022 10:17:22 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 018CE3182A11; Sun,  2 Oct 2022 10:17:21 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 06/24] xfrm: propagate extack to all netlink doit handlers
Date:   Sun, 2 Oct 2022 10:16:54 +0200
Message-ID: <20221002081712.757515-7-steffen.klassert@secunet.com>
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

xfrm_user_rcv_msg() already handles extack, we just need to pass it down.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_user.c | 56 +++++++++++++++++++++++++++-----------------
 1 file changed, 34 insertions(+), 22 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 2ff017117730..cfa35d76fb7e 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -678,7 +678,7 @@ static struct xfrm_state *xfrm_state_construct(struct net *net,
 }
 
 static int xfrm_add_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+		       struct nlattr **attrs, struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_usersa_info *p = nlmsg_data(nlh);
@@ -757,7 +757,7 @@ static struct xfrm_state *xfrm_user_state_lookup(struct net *net,
 }
 
 static int xfrm_del_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+		       struct nlattr **attrs, struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_state *x;
@@ -1254,7 +1254,8 @@ static int build_spdinfo(struct sk_buff *skb, struct net *net,
 }
 
 static int xfrm_set_spdinfo(struct sk_buff *skb, struct nlmsghdr *nlh,
-			    struct nlattr **attrs)
+			    struct nlattr **attrs,
+			    struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrmu_spdhthresh *thresh4 = NULL;
@@ -1299,7 +1300,8 @@ static int xfrm_set_spdinfo(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_get_spdinfo(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+			    struct nlattr **attrs,
+			    struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct sk_buff *r_skb;
@@ -1358,7 +1360,8 @@ static int build_sadinfo(struct sk_buff *skb, struct net *net,
 }
 
 static int xfrm_get_sadinfo(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+			    struct nlattr **attrs,
+			    struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct sk_buff *r_skb;
@@ -1378,7 +1381,7 @@ static int xfrm_get_sadinfo(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_get_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+		       struct nlattr **attrs, struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_usersa_id *p = nlmsg_data(nlh);
@@ -1402,7 +1405,8 @@ static int xfrm_get_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_alloc_userspi(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+			      struct nlattr **attrs,
+			      struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_state *x;
@@ -1754,7 +1758,8 @@ static struct xfrm_policy *xfrm_policy_construct(struct net *net, struct xfrm_us
 }
 
 static int xfrm_add_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+			   struct nlattr **attrs,
+			   struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_userpolicy_info *p = nlmsg_data(nlh);
@@ -2015,7 +2020,7 @@ static bool xfrm_userpolicy_is_valid(__u8 policy)
 }
 
 static int xfrm_set_default(struct sk_buff *skb, struct nlmsghdr *nlh,
-			    struct nlattr **attrs)
+			    struct nlattr **attrs, struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_userpolicy_default *up = nlmsg_data(nlh);
@@ -2036,7 +2041,7 @@ static int xfrm_set_default(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_get_default(struct sk_buff *skb, struct nlmsghdr *nlh,
-			    struct nlattr **attrs)
+			    struct nlattr **attrs, struct netlink_ext_ack *extack)
 {
 	struct sk_buff *r_skb;
 	struct nlmsghdr *r_nlh;
@@ -2066,7 +2071,8 @@ static int xfrm_get_default(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_get_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+			   struct nlattr **attrs,
+			   struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_policy *xp;
@@ -2149,7 +2155,8 @@ static int xfrm_get_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_flush_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+			 struct nlattr **attrs,
+			 struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct km_event c;
@@ -2249,7 +2256,7 @@ static int build_aevent(struct sk_buff *skb, struct xfrm_state *x, const struct
 }
 
 static int xfrm_get_ae(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+		       struct nlattr **attrs, struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_state *x;
@@ -2293,7 +2300,7 @@ static int xfrm_get_ae(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_new_ae(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+		       struct nlattr **attrs, struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_state *x;
@@ -2344,7 +2351,8 @@ static int xfrm_new_ae(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_flush_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+			     struct nlattr **attrs,
+			     struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct km_event c;
@@ -2372,7 +2380,8 @@ static int xfrm_flush_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_add_pol_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+			       struct nlattr **attrs,
+			       struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_policy *xp;
@@ -2438,7 +2447,8 @@ static int xfrm_add_pol_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_add_sa_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+			      struct nlattr **attrs,
+			      struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_state *x;
@@ -2472,7 +2482,8 @@ static int xfrm_add_sa_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_add_acquire(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+			    struct nlattr **attrs,
+			    struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_policy *xp;
@@ -2577,7 +2588,7 @@ static int copy_from_user_migrate(struct xfrm_migrate *ma,
 }
 
 static int xfrm_do_migrate(struct sk_buff *skb, struct nlmsghdr *nlh,
-			   struct nlattr **attrs)
+			   struct nlattr **attrs, struct netlink_ext_ack *extack)
 {
 	struct xfrm_userpolicy_id *pi = nlmsg_data(nlh);
 	struct xfrm_migrate m[XFRM_MAX_DEPTH];
@@ -2623,7 +2634,7 @@ static int xfrm_do_migrate(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 #else
 static int xfrm_do_migrate(struct sk_buff *skb, struct nlmsghdr *nlh,
-			   struct nlattr **attrs)
+			   struct nlattr **attrs, struct netlink_ext_ack *extack)
 {
 	return -ENOPROTOOPT;
 }
@@ -2819,7 +2830,8 @@ static const struct nla_policy xfrma_spd_policy[XFRMA_SPD_MAX+1] = {
 };
 
 static const struct xfrm_link {
-	int (*doit)(struct sk_buff *, struct nlmsghdr *, struct nlattr **);
+	int (*doit)(struct sk_buff *, struct nlmsghdr *, struct nlattr **,
+		    struct netlink_ext_ack *);
 	int (*start)(struct netlink_callback *);
 	int (*dump)(struct sk_buff *, struct netlink_callback *);
 	int (*done)(struct netlink_callback *);
@@ -2921,7 +2933,7 @@ static int xfrm_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 		goto err;
 	}
 
-	err = link->doit(skb, nlh, attrs);
+	err = link->doit(skb, nlh, attrs, extack);
 
 	/* We need to free skb allocated in xfrm_alloc_compat() before
 	 * returning from this function, because consume_skb() won't take
-- 
2.25.1

