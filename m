Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1B6B5AC46D
	for <lists+netdev@lfdr.de>; Sun,  4 Sep 2022 15:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbiIDNQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Sep 2022 09:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233492AbiIDNQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 09:16:26 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B308D31EC7
        for <netdev@vger.kernel.org>; Sun,  4 Sep 2022 06:16:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 08803CE0E9D
        for <netdev@vger.kernel.org>; Sun,  4 Sep 2022 13:16:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0162C433D6;
        Sun,  4 Sep 2022 13:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662297380;
        bh=2M9HDGMw17Puz6EZpCKukP0BNeS/7ycgvJgf16l6UbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H9V3PkXWDvE4VYIGUkukcmtIHuZ6MSS0PB+KPiTfZBBMh4NkzSCnomCFSlmwMqUT7
         o7AHPqXU8JaaOBmpFTBtl2ArAhTGFcxjRGxmokWg06+cIdU6yQ6LJlj4o0MKTMYvBO
         pb4TRHwgoJH6+HFtPB/5K8BWWFjuwZqhJvG4n1MSsjvgORD7ehzLndX4rxwklZjsdB
         mtA9FrNzHDMPXkAAnvsEyodJW5nulwX7oxix4aitdlhHJPj2Bnf14PQ7sFpsqXECBr
         HFP7g10qJKp0UVHdBldYG8AXTRBKHwEJOXBsF6F0nwGbT+IfQMotu+01ZC/WCJwnoD
         Cm4KmTzgoPRYw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: [PATCH RFC xfrm-next v3 7/8] xfrm: add support to HW update soft and hard limits
Date:   Sun,  4 Sep 2022 16:15:41 +0300
Message-Id: <4d8f2155e79af5a12f6358337bdc0f035f687769.1662295929.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1662295929.git.leonro@nvidia.com>
References: <cover.1662295929.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Both in RX and TX, the traffic that performs IPsec full offload
transformation is accounted by HW. It is needed to properly handle
hard limits that require to drop the packet.

It means that XFRM core needs to update internal counters with the one
that accounted by the HW, so new callbacks are introduced in this patch.

In case of soft or hard limit is occurred, the driver should call to
xfrm_state_check_expire() that will perform key rekeying exactly as
done by XFRM core.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/netdevice.h |  1 +
 include/net/xfrm.h        | 17 +++++++++++++++++
 net/xfrm/xfrm_output.c    |  1 -
 net/xfrm/xfrm_state.c     |  4 ++++
 4 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index c1db9eaa3dca..e38154d7b4cd 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1026,6 +1026,7 @@ struct xfrmdev_ops {
 	bool	(*xdo_dev_offload_ok) (struct sk_buff *skb,
 				       struct xfrm_state *x);
 	void	(*xdo_dev_state_advance_esn) (struct xfrm_state *x);
+	void	(*xdo_dev_state_update_curlft) (struct xfrm_state *x);
 	int	(*xdo_dev_policy_add) (struct xfrm_policy *x);
 	void	(*xdo_dev_policy_delete) (struct xfrm_policy *x);
 	void	(*xdo_dev_policy_free) (struct xfrm_policy *x);
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 38fff78a1421..100ca45d8172 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1563,6 +1563,23 @@ struct xfrm_state *xfrm_stateonly_find(struct net *net, u32 mark, u32 if_id,
 struct xfrm_state *xfrm_state_lookup_byspi(struct net *net, __be32 spi,
 					      unsigned short family);
 int xfrm_state_check_expire(struct xfrm_state *x);
+#ifdef CONFIG_XFRM_OFFLOAD
+static inline void xfrm_dev_state_update_curlft(struct xfrm_state *x)
+{
+	struct xfrm_dev_offload *xdo = &x->xso;
+	struct net_device *dev = xdo->dev;
+
+	if (x->xso.type != XFRM_DEV_OFFLOAD_FULL)
+		return;
+
+	if (dev && dev->xfrmdev_ops &&
+	    dev->xfrmdev_ops->xdo_dev_state_update_curlft)
+		dev->xfrmdev_ops->xdo_dev_state_update_curlft(x);
+
+}
+#else
+static inline void xfrm_dev_state_update_curlft(struct xfrm_state *x) {}
+#endif
 void xfrm_state_insert(struct xfrm_state *x);
 int xfrm_state_add(struct xfrm_state *x);
 int xfrm_state_update(struct xfrm_state *x);
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index dde009be8463..a22033350ddc 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -560,7 +560,6 @@ static int xfrm_output_one(struct sk_buff *skb, int err)
 			XFRM_INC_STATS(net, LINUX_MIB_XFRMOUTSTATEPROTOERROR);
 			goto error_nolock;
 		}
-
 		dst = skb_dst_pop(skb);
 		if (!dst) {
 			XFRM_INC_STATS(net, LINUX_MIB_XFRMOUTERROR);
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 91c32a3b6924..83d307cb526f 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -549,6 +549,8 @@ static enum hrtimer_restart xfrm_timer_handler(struct hrtimer *me)
 	int err = 0;
 
 	spin_lock(&x->lock);
+	xfrm_dev_state_update_curlft(x);
+
 	if (x->km.state == XFRM_STATE_DEAD)
 		goto out;
 	if (x->km.state == XFRM_STATE_EXPIRED)
@@ -1786,6 +1788,8 @@ EXPORT_SYMBOL(xfrm_state_update);
 
 int xfrm_state_check_expire(struct xfrm_state *x)
 {
+	xfrm_dev_state_update_curlft(x);
+
 	if (!x->curlft.use_time)
 		x->curlft.use_time = ktime_get_real_seconds();
 
-- 
2.37.2

