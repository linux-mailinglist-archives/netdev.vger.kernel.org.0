Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2F5B424CEC
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 07:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240202AbhJGF5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 01:57:35 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:37670 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231661AbhJGF5W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 01:57:22 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 7CCAC20581;
        Thu,  7 Oct 2021 07:55:28 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 9dnO-vWeiONN; Thu,  7 Oct 2021 07:55:27 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id B6D4620573;
        Thu,  7 Oct 2021 07:55:27 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id A844480004A;
        Thu,  7 Oct 2021 07:55:27 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 7 Oct 2021 07:55:27 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14; Thu, 7 Oct
 2021 07:55:27 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id A9DCD3183BF4; Thu,  7 Oct 2021 07:55:26 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 3/5] xfrm: make user policy API complete
Date:   Thu, 7 Oct 2021 07:55:22 +0200
Message-ID: <20211007055524.319785-4-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211007055524.319785-1-steffen.klassert@secunet.com>
References: <20211007055524.319785-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

>From a userland POV, this API was based on some magic values:
 - dirmask and action were bitfields but meaning of bits
   (XFRM_POL_DEFAULT_*) are not exported;
 - action is confusing, if a bit is set, does it mean drop or accept?

Let's try to simplify this uapi by using explicit field and macros.

Fixes: 2d151d39073a ("xfrm: Add possibility to set the default to block if we have no policy")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/uapi/linux/xfrm.h |  9 ++++++---
 net/xfrm/xfrm_user.c      | 36 +++++++++++++++++++-----------------
 2 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/include/uapi/linux/xfrm.h b/include/uapi/linux/xfrm.h
index 26f456b1f33e..eda0426ec4c2 100644
--- a/include/uapi/linux/xfrm.h
+++ b/include/uapi/linux/xfrm.h
@@ -514,9 +514,12 @@ struct xfrm_user_offload {
 #define XFRM_OFFLOAD_INBOUND	2
 
 struct xfrm_userpolicy_default {
-#define XFRM_USERPOLICY_DIRMASK_MAX	(sizeof(__u8) * 8)
-	__u8				dirmask;
-	__u8				action;
+#define XFRM_USERPOLICY_UNSPEC	0
+#define XFRM_USERPOLICY_BLOCK	1
+#define XFRM_USERPOLICY_ACCEPT	2
+	__u8				in;
+	__u8				fwd;
+	__u8				out;
 };
 
 #ifndef __KERNEL__
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 4719a6d54aa6..90c88390f1fe 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1966,16 +1966,21 @@ static int xfrm_set_default(struct sk_buff *skb, struct nlmsghdr *nlh,
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_userpolicy_default *up = nlmsg_data(nlh);
-	u8 dirmask;
-	u8 old_default = net->xfrm.policy_default;
 
-	if (up->dirmask >= XFRM_USERPOLICY_DIRMASK_MAX)
-		return -EINVAL;
+	if (up->in == XFRM_USERPOLICY_BLOCK)
+		net->xfrm.policy_default |= XFRM_POL_DEFAULT_IN;
+	else if (up->in == XFRM_USERPOLICY_ACCEPT)
+		net->xfrm.policy_default &= ~XFRM_POL_DEFAULT_IN;
 
-	dirmask = (1 << up->dirmask) & XFRM_POL_DEFAULT_MASK;
+	if (up->fwd == XFRM_USERPOLICY_BLOCK)
+		net->xfrm.policy_default |= XFRM_POL_DEFAULT_FWD;
+	else if (up->fwd == XFRM_USERPOLICY_ACCEPT)
+		net->xfrm.policy_default &= ~XFRM_POL_DEFAULT_FWD;
 
-	net->xfrm.policy_default = (old_default & (0xff ^ dirmask))
-				    | (up->action << up->dirmask);
+	if (up->out == XFRM_USERPOLICY_BLOCK)
+		net->xfrm.policy_default |= XFRM_POL_DEFAULT_OUT;
+	else if (up->out == XFRM_USERPOLICY_ACCEPT)
+		net->xfrm.policy_default &= ~XFRM_POL_DEFAULT_OUT;
 
 	rt_genid_bump_all(net);
 
@@ -1988,13 +1993,11 @@ static int xfrm_get_default(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct sk_buff *r_skb;
 	struct nlmsghdr *r_nlh;
 	struct net *net = sock_net(skb->sk);
-	struct xfrm_userpolicy_default *r_up, *up;
+	struct xfrm_userpolicy_default *r_up;
 	int len = NLMSG_ALIGN(sizeof(struct xfrm_userpolicy_default));
 	u32 portid = NETLINK_CB(skb).portid;
 	u32 seq = nlh->nlmsg_seq;
 
-	up = nlmsg_data(nlh);
-
 	r_skb = nlmsg_new(len, GFP_ATOMIC);
 	if (!r_skb)
 		return -ENOMEM;
@@ -2005,15 +2008,14 @@ static int xfrm_get_default(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return -EMSGSIZE;
 	}
 
-	if (up->dirmask >= XFRM_USERPOLICY_DIRMASK_MAX) {
-		kfree_skb(r_skb);
-		return -EINVAL;
-	}
-
 	r_up = nlmsg_data(r_nlh);
 
-	r_up->action = ((net->xfrm.policy_default & (1 << up->dirmask)) >> up->dirmask);
-	r_up->dirmask = up->dirmask;
+	r_up->in = net->xfrm.policy_default & XFRM_POL_DEFAULT_IN ?
+			XFRM_USERPOLICY_BLOCK : XFRM_USERPOLICY_ACCEPT;
+	r_up->fwd = net->xfrm.policy_default & XFRM_POL_DEFAULT_FWD ?
+			XFRM_USERPOLICY_BLOCK : XFRM_USERPOLICY_ACCEPT;
+	r_up->out = net->xfrm.policy_default & XFRM_POL_DEFAULT_OUT ?
+			XFRM_USERPOLICY_BLOCK : XFRM_USERPOLICY_ACCEPT;
 	nlmsg_end(r_skb, r_nlh);
 
 	return nlmsg_unicast(net->xfrm.nlsk, r_skb, portid);
-- 
2.25.1

