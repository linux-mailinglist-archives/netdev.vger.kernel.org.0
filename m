Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8A38403545
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 09:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349738AbhIHHZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 03:25:17 -0400
Received: from host.78.145.23.62.rev.coltfrance.com ([62.23.145.78]:47788 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1349763AbhIHHZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 03:25:11 -0400
Received: from bretzel (unknown [10.16.0.57])
        by proxy.6wind.com (Postfix) with ESMTPS id 7197EB2B5B4;
        Wed,  8 Sep 2021 09:24:00 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1mNrw8-0001TN-Dg; Wed, 08 Sep 2021 09:24:00 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     steffen.klassert@secunet.com, davem@davemloft.net, kuba@kernel.org,
        antony.antony@secunet.com
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH ipsec v2 1/2] xfrm: make user policy API complete
Date:   Wed,  8 Sep 2021 09:23:39 +0200
Message-Id: <20210908072341.5647-2-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210908072341.5647-1-nicolas.dichtel@6wind.com>
References: <202109080912.cNYfj6Ho-lkp@intel.com>
 <20210908072341.5647-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From a userland POV, this API was based on some magic values:
 - dirmask and action were bitfields but meaning of bits
   (XFRM_POL_DEFAULT_*) are not exported;
 - action is confusing, if a bit is set, does it mean drop or accept?

Let's try to simplify this uapi by using explicit field and macros.

Fixes: 2d151d39073a ("xfrm: Add possibility to set the default to block if we have no policy")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 include/uapi/linux/xfrm.h |  9 ++++++---
 net/xfrm/xfrm_user.c      | 31 +++++++++++++++++++------------
 2 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/include/uapi/linux/xfrm.h b/include/uapi/linux/xfrm.h
index b96c1ea7166d..3e605b09eb6f 100644
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
index 03b66d154b2b..90c88390f1fe 100644
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
@@ -2007,8 +2010,12 @@ static int xfrm_get_default(struct sk_buff *skb, struct nlmsghdr *nlh,
 
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
2.33.0

