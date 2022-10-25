Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC38360C9F3
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 12:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232377AbiJYKZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 06:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbiJYKYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 06:24:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0FB2181C90
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 03:22:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B6E1B81CE3
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 10:22:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F5EC433C1;
        Tue, 25 Oct 2022 10:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666693352;
        bh=Mg2Xg5FcnvLV8Y/vsEOnvuiojnt/2RVVEVstU+c6WbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EPhXgVBW56axMzYhtMuJk25vfEYbwdAHqf9W+BY6fN0aX9qlcUe5EgnrbXRBdrV9o
         POm4ju/BOZ3dA6sWdVQBVjS5UNU9IS24/FSKb813ZpWTPs7Q3JIPwcOS/LfP3HwJDV
         dH2/0/Pp/qMuYY7d0CApKm8stRT/DZeIecym79cLCE+xX7rIkG1rYQjrXmgO6p1OqD
         NqxUyDes6l64c1fD1pi+7AvhMB7UtKKpro/16KBxWQcGC/mJ5emlh+90yOfiHIp1EC
         hRE61dgZ/ojojaNPo+3JfUP0hHQTQB2czAK5EJWK5fxdgsrHA5EsoMsWSylLFuuVbn
         JdfakX3JQ3vYQ==
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
Subject: [PATCH xfrm-next v6 7/8] xfrm: add support to HW update soft and hard limits
Date:   Tue, 25 Oct 2022 13:22:03 +0300
Message-Id: <42757f834a96be1976b6fc1841592dee06a605de.1666692948.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1666692948.git.leonro@nvidia.com>
References: <cover.1666692948.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
index e3d979a9b69c..8f87fce07525 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1033,6 +1033,7 @@ struct xfrmdev_ops {
 	bool	(*xdo_dev_offload_ok) (struct sk_buff *skb,
 				       struct xfrm_state *x);
 	void	(*xdo_dev_state_advance_esn) (struct xfrm_state *x);
+	void	(*xdo_dev_state_update_curlft) (struct xfrm_state *x);
 	int	(*xdo_dev_policy_add) (struct xfrm_policy *x);
 	void	(*xdo_dev_policy_delete) (struct xfrm_policy *x);
 	void	(*xdo_dev_policy_free) (struct xfrm_policy *x);
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 976361976ed5..41f8aaafe755 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1571,6 +1571,23 @@ struct xfrm_state *xfrm_stateonly_find(struct net *net, u32 mark, u32 if_id,
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
index 3d2fe7712ac5..b2c83c0f27f2 100644
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
2.37.3

