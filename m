Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E77E403544
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 09:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348192AbhIHHZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 03:25:16 -0400
Received: from host.78.145.23.62.rev.coltfrance.com ([62.23.145.78]:47791 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1349789AbhIHHZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 03:25:11 -0400
Received: from bretzel (unknown [10.16.0.57])
        by proxy.6wind.com (Postfix) with ESMTPS id 745E6B2B5B5;
        Wed,  8 Sep 2021 09:24:00 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1mNrw8-0001TQ-E6; Wed, 08 Sep 2021 09:24:00 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     steffen.klassert@secunet.com, davem@davemloft.net, kuba@kernel.org,
        antony.antony@secunet.com
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH ipsec v2 2/2] xfrm: notify default policy on update
Date:   Wed,  8 Sep 2021 09:23:40 +0200
Message-Id: <20210908072341.5647-3-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210908072341.5647-1-nicolas.dichtel@6wind.com>
References: <202109080912.cNYfj6Ho-lkp@intel.com>
 <20210908072341.5647-1-nicolas.dichtel@6wind.com>
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
index 90c88390f1fe..0eba0c27c665 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1961,6 +1961,36 @@ static struct sk_buff *xfrm_policy_netlink(struct sk_buff *in_skb,
 	return skb;
 }
 
+static int xfrm_notify_userpolicy(struct net *net)
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

