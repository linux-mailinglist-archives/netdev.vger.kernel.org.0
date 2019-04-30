Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65E11EFF1
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 07:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbfD3Fau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 01:30:50 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:46806 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbfD3Fat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 01:30:49 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id E8A9720277;
        Tue, 30 Apr 2019 07:30:47 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id c-6288dLJ_5Z; Tue, 30 Apr 2019 07:30:47 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 63A27201E3;
        Tue, 30 Apr 2019 07:30:47 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 30 Apr 2019
 07:30:47 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id ECEAD31805D7;
 Tue, 30 Apr 2019 07:30:46 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 03/12] net: xfrm: Add '_rcu' tag for rcu protected pointer in netns_xfrm
Date:   Tue, 30 Apr 2019 07:30:21 +0200
Message-ID: <20190430053030.27009-4-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190430053030.27009-1-steffen.klassert@secunet.com>
References: <20190430053030.27009-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-G-Data-MailSecurity-for-Exchange-State: 0
X-G-Data-MailSecurity-for-Exchange-Error: 0
X-G-Data-MailSecurity-for-Exchange-Sender: 23
X-G-Data-MailSecurity-for-Exchange-Server: d65e63f7-5c15-413f-8f63-c0d707471c93
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-G-Data-MailSecurity-for-Exchange-Guid: 6BDC8B32-D366-4218-AFA4-D3DA592A2B9E
X-G-Data-MailSecurity-for-Exchange-ProcessedOnRouted: True
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Su Yanjun <suyj.fnst@cn.fujitsu.com>

For rcu protected pointers, we'd better add '__rcu' for them.

Once added '__rcu' tag for rcu protected pointer, the sparse tool reports
warnings.

net/xfrm/xfrm_user.c:1198:39: sparse:    expected struct sock *sk
net/xfrm/xfrm_user.c:1198:39: sparse:    got struct sock [noderef] <asn:4> *nlsk
[...]

So introduce a new wrapper function of nlmsg_unicast  to handle type
conversions.

This patch also fixes a direct access of a rcu protected socket.

Fixes: be33690d8fcf("[XFRM]: Fix aevent related crash")
Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/netns/xfrm.h |  2 +-
 net/xfrm/xfrm_user.c     | 30 +++++++++++++++++++++++-------
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/include/net/netns/xfrm.h b/include/net/netns/xfrm.h
index 59f45b1e9dac..d2a36fb9f92a 100644
--- a/include/net/netns/xfrm.h
+++ b/include/net/netns/xfrm.h
@@ -57,7 +57,7 @@ struct netns_xfrm {
 	struct list_head	inexact_bins;
 
 
-	struct sock		*nlsk;
+	struct sock		__rcu *nlsk;
 	struct sock		*nlsk_stash;
 
 	u32			sysctl_aevent_etime;
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 8d4d52fd457b..944589832343 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1071,6 +1071,22 @@ static inline int xfrm_nlmsg_multicast(struct net *net, struct sk_buff *skb,
 	return nlmsg_multicast(nlsk, skb, pid, group, GFP_ATOMIC);
 }
 
+/* A similar wrapper like xfrm_nlmsg_multicast checking that nlsk is still
+ * available.
+ */
+static inline int xfrm_nlmsg_unicast(struct net *net, struct sk_buff *skb,
+				     u32 pid)
+{
+	struct sock *nlsk = rcu_dereference(net->xfrm.nlsk);
+
+	if (!nlsk) {
+		kfree_skb(skb);
+		return -EPIPE;
+	}
+
+	return nlmsg_unicast(nlsk, skb, pid);
+}
+
 static inline unsigned int xfrm_spdinfo_msgsize(void)
 {
 	return NLMSG_ALIGN(4)
@@ -1195,7 +1211,7 @@ static int xfrm_get_spdinfo(struct sk_buff *skb, struct nlmsghdr *nlh,
 	err = build_spdinfo(r_skb, net, sportid, seq, *flags);
 	BUG_ON(err < 0);
 
-	return nlmsg_unicast(net->xfrm.nlsk, r_skb, sportid);
+	return xfrm_nlmsg_unicast(net, r_skb, sportid);
 }
 
 static inline unsigned int xfrm_sadinfo_msgsize(void)
@@ -1254,7 +1270,7 @@ static int xfrm_get_sadinfo(struct sk_buff *skb, struct nlmsghdr *nlh,
 	err = build_sadinfo(r_skb, net, sportid, seq, *flags);
 	BUG_ON(err < 0);
 
-	return nlmsg_unicast(net->xfrm.nlsk, r_skb, sportid);
+	return xfrm_nlmsg_unicast(net, r_skb, sportid);
 }
 
 static int xfrm_get_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
@@ -1274,7 +1290,7 @@ static int xfrm_get_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (IS_ERR(resp_skb)) {
 		err = PTR_ERR(resp_skb);
 	} else {
-		err = nlmsg_unicast(net->xfrm.nlsk, resp_skb, NETLINK_CB(skb).portid);
+		err = xfrm_nlmsg_unicast(net, resp_skb, NETLINK_CB(skb).portid);
 	}
 	xfrm_state_put(x);
 out_noput:
@@ -1337,7 +1353,7 @@ static int xfrm_alloc_userspi(struct sk_buff *skb, struct nlmsghdr *nlh,
 		goto out;
 	}
 
-	err = nlmsg_unicast(net->xfrm.nlsk, resp_skb, NETLINK_CB(skb).portid);
+	err = xfrm_nlmsg_unicast(net, resp_skb, NETLINK_CB(skb).portid);
 
 out:
 	xfrm_state_put(x);
@@ -1903,8 +1919,8 @@ static int xfrm_get_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 		if (IS_ERR(resp_skb)) {
 			err = PTR_ERR(resp_skb);
 		} else {
-			err = nlmsg_unicast(net->xfrm.nlsk, resp_skb,
-					    NETLINK_CB(skb).portid);
+			err = xfrm_nlmsg_unicast(net, resp_skb,
+						 NETLINK_CB(skb).portid);
 		}
 	} else {
 		xfrm_audit_policy_delete(xp, err ? 0 : 1, true);
@@ -2062,7 +2078,7 @@ static int xfrm_get_ae(struct sk_buff *skb, struct nlmsghdr *nlh,
 	err = build_aevent(r_skb, x, &c);
 	BUG_ON(err < 0);
 
-	err = nlmsg_unicast(net->xfrm.nlsk, r_skb, NETLINK_CB(skb).portid);
+	err = xfrm_nlmsg_unicast(net, r_skb, NETLINK_CB(skb).portid);
 	spin_unlock_bh(&x->lock);
 	xfrm_state_put(x);
 	return err;
-- 
2.17.1

