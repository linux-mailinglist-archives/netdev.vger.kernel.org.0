Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEC15424CE9
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 07:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240162AbhJGF5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 01:57:25 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:37648 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhJGF5W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 01:57:22 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id E34E0200BB;
        Thu,  7 Oct 2021 07:55:27 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id qw2OTN2laKwD; Thu,  7 Oct 2021 07:55:27 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 6850120460;
        Thu,  7 Oct 2021 07:55:27 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id 603D880004A;
        Thu,  7 Oct 2021 07:55:27 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 7 Oct 2021 07:55:27 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14; Thu, 7 Oct
 2021 07:55:26 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id AE0BB3183BF5; Thu,  7 Oct 2021 07:55:26 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 4/5] xfrm: notify default policy on update
Date:   Thu, 7 Oct 2021 07:55:23 +0200
Message-ID: <20211007055524.319785-5-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211007055524.319785-1-steffen.klassert@secunet.com>
References: <20211007055524.319785-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

This configuration knob is very sensible, it should be notified when
changing.

Fixes: 2d151d39073a ("xfrm: Add possibility to set the default to block if we have no policy")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
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
2.25.1

