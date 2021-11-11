Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2BC44D64A
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 13:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233189AbhKKMGP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 11 Nov 2021 07:06:15 -0500
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:44518 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233143AbhKKMGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 07:06:13 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-lps5UfOvMXSiVX-stJ2xWw-1; Thu, 11 Nov 2021 07:03:04 -0500
X-MC-Unique: lps5UfOvMXSiVX-stJ2xWw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 12510804141;
        Thu, 11 Nov 2021 12:03:03 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.192.210])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 18DEB1017CE3;
        Thu, 11 Nov 2021 12:03:01 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, Sabrina Dubroca <sd@queasysnail.net>
Subject: [RFC PATCH ipsec-next 1/6] xfrm: propagate extack to all netlink doit handlers
Date:   Thu, 11 Nov 2021 13:02:42 +0100
Message-Id: <450482993e7930dbae1ab06a93ec6115224ab8d9.1636450303.git.sd@queasysnail.net>
In-Reply-To: <cover.1636450303.git.sd@queasysnail.net>
References: <cover.1636450303.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sd@queasysnail.net
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xfrm_user_rcv_msg() already handles extack, we just need to pass it down.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/xfrm/xfrm_user.c | 56 +++++++++++++++++++++++++++-----------------
 1 file changed, 34 insertions(+), 22 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 03b66d154b2b..7af2104281e3 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -669,7 +669,7 @@ static struct xfrm_state *xfrm_state_construct(struct net *net,
 }
 
 static int xfrm_add_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+		       struct nlattr **attrs, struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_usersa_info *p = nlmsg_data(nlh);
@@ -748,7 +748,7 @@ static struct xfrm_state *xfrm_user_state_lookup(struct net *net,
 }
 
 static int xfrm_del_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+		       struct nlattr **attrs, struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_state *x;
@@ -1239,7 +1239,8 @@ static int build_spdinfo(struct sk_buff *skb, struct net *net,
 }
 
 static int xfrm_set_spdinfo(struct sk_buff *skb, struct nlmsghdr *nlh,
-			    struct nlattr **attrs)
+			    struct nlattr **attrs,
+			    struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrmu_spdhthresh *thresh4 = NULL;
@@ -1284,7 +1285,8 @@ static int xfrm_set_spdinfo(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_get_spdinfo(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+			    struct nlattr **attrs,
+			    struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct sk_buff *r_skb;
@@ -1343,7 +1345,8 @@ static int build_sadinfo(struct sk_buff *skb, struct net *net,
 }
 
 static int xfrm_get_sadinfo(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+			    struct nlattr **attrs,
+			    struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct sk_buff *r_skb;
@@ -1363,7 +1366,7 @@ static int xfrm_get_sadinfo(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_get_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+		       struct nlattr **attrs, struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_usersa_id *p = nlmsg_data(nlh);
@@ -1387,7 +1390,8 @@ static int xfrm_get_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_alloc_userspi(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+			      struct nlattr **attrs,
+			      struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_state *x;
@@ -1739,7 +1743,8 @@ static struct xfrm_policy *xfrm_policy_construct(struct net *net, struct xfrm_us
 }
 
 static int xfrm_add_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+			   struct nlattr **attrs,
+			   struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_userpolicy_info *p = nlmsg_data(nlh);
@@ -1962,7 +1967,7 @@ static struct sk_buff *xfrm_policy_netlink(struct sk_buff *in_skb,
 }
 
 static int xfrm_set_default(struct sk_buff *skb, struct nlmsghdr *nlh,
-			    struct nlattr **attrs)
+			    struct nlattr **attrs, struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_userpolicy_default *up = nlmsg_data(nlh);
@@ -1983,7 +1988,7 @@ static int xfrm_set_default(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_get_default(struct sk_buff *skb, struct nlmsghdr *nlh,
-			    struct nlattr **attrs)
+			    struct nlattr **attrs, struct netlink_ext_ack *extack)
 {
 	struct sk_buff *r_skb;
 	struct nlmsghdr *r_nlh;
@@ -2015,7 +2020,8 @@ static int xfrm_get_default(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_get_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+			   struct nlattr **attrs,
+			   struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_policy *xp;
@@ -2098,7 +2104,8 @@ static int xfrm_get_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_flush_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+			 struct nlattr **attrs,
+			 struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct km_event c;
@@ -2198,7 +2205,7 @@ static int build_aevent(struct sk_buff *skb, struct xfrm_state *x, const struct
 }
 
 static int xfrm_get_ae(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+		       struct nlattr **attrs, struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_state *x;
@@ -2242,7 +2249,7 @@ static int xfrm_get_ae(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_new_ae(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+		       struct nlattr **attrs, struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_state *x;
@@ -2293,7 +2300,8 @@ static int xfrm_new_ae(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_flush_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+			     struct nlattr **attrs,
+			     struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct km_event c;
@@ -2321,7 +2329,8 @@ static int xfrm_flush_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_add_pol_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+			       struct nlattr **attrs,
+			       struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_policy *xp;
@@ -2387,7 +2396,8 @@ static int xfrm_add_pol_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_add_sa_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+			      struct nlattr **attrs,
+			      struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_state *x;
@@ -2421,7 +2431,8 @@ static int xfrm_add_sa_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int xfrm_add_acquire(struct sk_buff *skb, struct nlmsghdr *nlh,
-		struct nlattr **attrs)
+			    struct nlattr **attrs,
+			    struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_policy *xp;
@@ -2526,7 +2537,7 @@ static int copy_from_user_migrate(struct xfrm_migrate *ma,
 }
 
 static int xfrm_do_migrate(struct sk_buff *skb, struct nlmsghdr *nlh,
-			   struct nlattr **attrs)
+			   struct nlattr **attrs, struct netlink_ext_ack *extack)
 {
 	struct xfrm_userpolicy_id *pi = nlmsg_data(nlh);
 	struct xfrm_migrate m[XFRM_MAX_DEPTH];
@@ -2568,7 +2579,7 @@ static int xfrm_do_migrate(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 #else
 static int xfrm_do_migrate(struct sk_buff *skb, struct nlmsghdr *nlh,
-			   struct nlattr **attrs)
+			   struct nlattr **attrs, struct netlink_ext_ack *extack)
 {
 	return -ENOPROTOOPT;
 }
@@ -2764,7 +2775,8 @@ static const struct nla_policy xfrma_spd_policy[XFRMA_SPD_MAX+1] = {
 };
 
 static const struct xfrm_link {
-	int (*doit)(struct sk_buff *, struct nlmsghdr *, struct nlattr **);
+	int (*doit)(struct sk_buff *, struct nlmsghdr *, struct nlattr **,
+		    struct netlink_ext_ack *);
 	int (*start)(struct netlink_callback *);
 	int (*dump)(struct sk_buff *, struct netlink_callback *);
 	int (*done)(struct netlink_callback *);
@@ -2866,7 +2878,7 @@ static int xfrm_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 		goto err;
 	}
 
-	err = link->doit(skb, nlh, attrs);
+	err = link->doit(skb, nlh, attrs, extack);
 
 	/* We need to free skb allocated in xfrm_alloc_compat() before
 	 * returning from this function, because consume_skb() won't take
-- 
2.33.1

