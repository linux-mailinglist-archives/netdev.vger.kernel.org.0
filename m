Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2CC55F2212
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 10:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiJBIeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 04:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbiJBIeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 04:34:02 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5F14C636
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 01:34:00 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 2E4CD20519;
        Sun,  2 Oct 2022 10:33:59 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id uBq14YP_ad2D; Sun,  2 Oct 2022 10:33:58 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 8F40420539;
        Sun,  2 Oct 2022 10:33:58 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 7EABE80004A;
        Sun,  2 Oct 2022 10:33:58 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 2 Oct 2022 10:33:58 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sun, 2 Oct
 2022 10:33:57 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 2B2A73182A2D; Sun,  2 Oct 2022 10:17:22 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 15/24] xfrm: add extack support to xfrm_dev_state_add
Date:   Sun, 2 Oct 2022 10:17:03 +0200
Message-ID: <20221002081712.757515-16-steffen.klassert@secunet.com>
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
 include/net/xfrm.h     |  5 +++--
 net/xfrm/xfrm_device.c | 20 +++++++++++++++-----
 net/xfrm/xfrm_user.c   |  8 +++++---
 3 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 28b988577ed2..9c1cccf85f12 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1886,7 +1886,8 @@ void xfrm_dev_resume(struct sk_buff *skb);
 void xfrm_dev_backlog(struct softnet_data *sd);
 struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t features, bool *again);
 int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
-		       struct xfrm_user_offload *xuo);
+		       struct xfrm_user_offload *xuo,
+		       struct netlink_ext_ack *extack);
 bool xfrm_dev_offload_ok(struct sk_buff *skb, struct xfrm_state *x);
 
 static inline void xfrm_dev_state_advance_esn(struct xfrm_state *x)
@@ -1949,7 +1950,7 @@ static inline struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_fea
 	return skb;
 }
 
-static inline int xfrm_dev_state_add(struct net *net, struct xfrm_state *x, struct xfrm_user_offload *xuo)
+static inline int xfrm_dev_state_add(struct net *net, struct xfrm_state *x, struct xfrm_user_offload *xuo, struct netlink_ext_ack *extack)
 {
 	return 0;
 }
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 637ca8838436..5f5aafd418af 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -207,7 +207,8 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 EXPORT_SYMBOL_GPL(validate_xmit_xfrm);
 
 int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
-		       struct xfrm_user_offload *xuo)
+		       struct xfrm_user_offload *xuo,
+		       struct netlink_ext_ack *extack)
 {
 	int err;
 	struct dst_entry *dst;
@@ -216,15 +217,21 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 	xfrm_address_t *saddr;
 	xfrm_address_t *daddr;
 
-	if (!x->type_offload)
+	if (!x->type_offload) {
+		NL_SET_ERR_MSG(extack, "Type doesn't support offload");
 		return -EINVAL;
+	}
 
 	/* We don't yet support UDP encapsulation and TFC padding. */
-	if (x->encap || x->tfcpad)
+	if (x->encap || x->tfcpad) {
+		NL_SET_ERR_MSG(extack, "Encapsulation and TFC padding can't be offloaded");
 		return -EINVAL;
+	}
 
-	if (xuo->flags & ~(XFRM_OFFLOAD_IPV6 | XFRM_OFFLOAD_INBOUND))
+	if (xuo->flags & ~(XFRM_OFFLOAD_IPV6 | XFRM_OFFLOAD_INBOUND)) {
+		NL_SET_ERR_MSG(extack, "Unrecognized flags in offload request");
 		return -EINVAL;
+	}
 
 	dev = dev_get_by_index(net, xuo->ifindex);
 	if (!dev) {
@@ -256,6 +263,7 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 
 	if (x->props.flags & XFRM_STATE_ESN &&
 	    !dev->xfrmdev_ops->xdo_dev_state_advance_esn) {
+		NL_SET_ERR_MSG(extack, "Device doesn't support offload with ESN");
 		xso->dev = NULL;
 		dev_put(dev);
 		return -EINVAL;
@@ -277,8 +285,10 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 		xso->real_dev = NULL;
 		netdev_put(dev, &xso->dev_tracker);
 
-		if (err != -EOPNOTSUPP)
+		if (err != -EOPNOTSUPP) {
+			NL_SET_ERR_MSG(extack, "Device failed to offload this state");
 			return err;
+		}
 	}
 
 	return 0;
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 3c150e1f8a2a..c56b9442dffe 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -652,7 +652,8 @@ static void xfrm_smark_init(struct nlattr **attrs, struct xfrm_mark *m)
 static struct xfrm_state *xfrm_state_construct(struct net *net,
 					       struct xfrm_usersa_info *p,
 					       struct nlattr **attrs,
-					       int *errp)
+					       int *errp,
+					       struct netlink_ext_ack *extack)
 {
 	struct xfrm_state *x = xfrm_state_alloc(net);
 	int err = -ENOMEM;
@@ -735,7 +736,8 @@ static struct xfrm_state *xfrm_state_construct(struct net *net,
 	/* configure the hardware if offload is requested */
 	if (attrs[XFRMA_OFFLOAD_DEV]) {
 		err = xfrm_dev_state_add(net, x,
-					 nla_data(attrs[XFRMA_OFFLOAD_DEV]));
+					 nla_data(attrs[XFRMA_OFFLOAD_DEV]),
+					 extack);
 		if (err)
 			goto error;
 	}
@@ -763,7 +765,7 @@ static int xfrm_add_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err)
 		return err;
 
-	x = xfrm_state_construct(net, p, attrs, &err);
+	x = xfrm_state_construct(net, p, attrs, &err, extack);
 	if (!x)
 		return err;
 
-- 
2.25.1

