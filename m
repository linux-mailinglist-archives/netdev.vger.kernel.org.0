Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16B5A402F14
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 21:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245599AbhIGTng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 15:43:36 -0400
Received: from host.78.145.23.62.rev.coltfrance.com ([62.23.145.78]:47051 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232112AbhIGTnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 15:43:31 -0400
Received: from bretzel (unknown [10.16.0.57])
        by proxy.6wind.com (Postfix) with ESMTPS id 55DC5B29AA0;
        Tue,  7 Sep 2021 21:35:21 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1mNgsL-0004IG-9r; Tue, 07 Sep 2021 21:35:21 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     steffen.klassert@secunet.com, davem@davemloft.net, kuba@kernel.org,
        antony.antony@secunet.com
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH ipsec 2/2] xfrm: notify default policy on update
Date:   Tue,  7 Sep 2021 21:35:09 +0200
Message-Id: <20210907193510.16487-3-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210907193510.16487-1-nicolas.dichtel@6wind.com>
References: <9b0ddb88-c7d3-9bb6-48f2-1967425b3fc7@6wind.com>
 <20210907193510.16487-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This configuration knob is very sensible, it should be notified when
changing.

Fixes: 2d151d39073a ("xfrm: Add possibility to set the default to block if we have no policy")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 net/xfrm/xfrm_user.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 4e1c4dd53fe2..af9803f18ff7 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1961,6 +1961,36 @@ static struct sk_buff *xfrm_policy_netlink(struct sk_buff *in_skb,
 	return skb;
 }
 
+static int xfrm_notify_userpolicy(const struct net *net)
+{
+	struct xfrm_userpolicy_default *up;
+	int len = NLMSG_ALIGN(sizeof(*up));
+	struct nlmsghdr *nlh;
+	struct sk_buff *skb;
+
+	skb = nlmsg_new(len, GFP_ATOMIC);
+	if (skb == NULL)
+		return -ENOMEM;
+
+	nlh = nlmsg_put(skb, 0, 0, XFRM_MSG_GETDEFAULT, sizeof(*up), 0);
+	if (nlh == NULL) {
+		kfree_skb(skb);
+		return -EMSGSIZE;
+	}
+
+	up = nlmsg_data(nlh);
+	up->in = net->xfrm.policy_default & XFRM_POL_DEFAULT_IN ?
+			XFRM_USERPOLICY_BLOCK : XFRM_USERPOLICY_ACCEPT;
+	up->fwd = net->xfrm.policy_default & XFRM_POL_DEFAULT_FWD ?
+			XFRM_USERPOLICY_BLOCK : XFRM_USERPOLICY_ACCEPT;
+	up->out = net->xfrm.policy_default & XFRM_POL_DEFAULT_OUT ?
+			XFRM_USERPOLICY_BLOCK : XFRM_USERPOLICY_ACCEPT;
+
+	nlmsg_end(skb, nlh);
+
+	return xfrm_nlmsg_multicast(net, skb, 0, XFRMNLGRP_POLICY);
+}
+
 static int xfrm_set_default(struct sk_buff *skb, struct nlmsghdr *nlh,
 			    struct nlattr **attrs)
 {
@@ -1984,6 +2014,7 @@ static int xfrm_set_default(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	rt_genid_bump_all(net);
 
+	xfrm_notify_userpolicy(net);
 	return 0;
 }
 
-- 
2.33.0

