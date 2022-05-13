Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEDA5265B2
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 17:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234502AbiEMPMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 11:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234500AbiEMPMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 11:12:31 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D4453711
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 08:12:29 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id EC7F52068A;
        Fri, 13 May 2022 17:12:27 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id BnvtQV5jMdBE; Fri, 13 May 2022 17:12:27 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id F313E2068E;
        Fri, 13 May 2022 17:12:26 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id EE05780004A;
        Fri, 13 May 2022 17:12:26 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 13 May 2022 17:12:26 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 13 May
 2022 17:12:26 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 452973182D49; Fri, 13 May 2022 17:12:26 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 4/8] xfrm: store and rely on direction to construct offload flags
Date:   Fri, 13 May 2022 17:12:14 +0200
Message-ID: <20220513151218.4010119-5-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220513151218.4010119-1-steffen.klassert@secunet.com>
References: <20220513151218.4010119-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

XFRM state doesn't need anything from flags except to understand
direction, so store it separately. For future patches, such change
will allow us to reuse xfrm_dev_offload for policy offload too, which
has three possible directions instead of two.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h     | 6 ++++++
 net/xfrm/xfrm_device.c | 8 +++++++-
 net/xfrm/xfrm_user.c   | 3 ++-
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index bb20278d689c..45422f7be0c5 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -126,12 +126,18 @@ struct xfrm_state_walk {
 	struct xfrm_address_filter *filter;
 };
 
+enum {
+	XFRM_DEV_OFFLOAD_IN = 1,
+	XFRM_DEV_OFFLOAD_OUT,
+};
+
 struct xfrm_dev_offload {
 	struct net_device	*dev;
 	netdevice_tracker	dev_tracker;
 	struct net_device	*real_dev;
 	unsigned long		offload_handle;
 	u8			flags;
+	u8			dir : 2;
 };
 
 struct xfrm_mode {
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 6e4d3cb2e24d..c818afca9137 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -117,7 +117,7 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 
 	sp = skb_sec_path(skb);
 	x = sp->xvec[sp->len - 1];
-	if (xo->flags & XFRM_GRO || x->xso.flags & XFRM_OFFLOAD_INBOUND)
+	if (xo->flags & XFRM_GRO || x->xso.dir == XFRM_DEV_OFFLOAD_IN)
 		return skb;
 
 	/* This skb was already validated on the upper/virtual dev */
@@ -267,10 +267,16 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 	/* Don't forward bit that is not implemented */
 	xso->flags = xuo->flags & ~XFRM_OFFLOAD_IPV6;
 
+	if (xuo->flags & XFRM_OFFLOAD_INBOUND)
+		xso->dir = XFRM_DEV_OFFLOAD_IN;
+	else
+		xso->dir = XFRM_DEV_OFFLOAD_OUT;
+
 	err = dev->xfrmdev_ops->xdo_dev_state_add(x);
 	if (err) {
 		xso->flags = 0;
 		xso->dev = NULL;
+		xso->dir = 0;
 		xso->real_dev = NULL;
 		dev_put_track(dev, &xso->dev_tracker);
 
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 7217c57a76e9..6a58fec6a1fb 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -852,7 +852,8 @@ static int copy_user_offload(struct xfrm_dev_offload *xso, struct sk_buff *skb)
 	xuo = nla_data(attr);
 	memset(xuo, 0, sizeof(*xuo));
 	xuo->ifindex = xso->dev->ifindex;
-	xuo->flags = xso->flags;
+	if (xso->dir == XFRM_DEV_OFFLOAD_IN)
+		xuo->flags = XFRM_OFFLOAD_INBOUND;
 
 	return 0;
 }
-- 
2.25.1

