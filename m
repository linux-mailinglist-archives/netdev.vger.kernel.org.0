Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEEE62EDB7
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 07:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241130AbiKRGgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 01:36:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241122AbiKRGgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 01:36:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 030A872120
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 22:36:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC4A7B8229E
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 06:36:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2100C433C1;
        Fri, 18 Nov 2022 06:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668753360;
        bh=MqlBXv0vD45Z1GaGMXMWr+UYrWtOGgxfz/wBPNEWZzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eynK4lVLthUqIB5dlQsVFsG262CIfyda1/ZYvv+O52uTzYdDzlIi/jj7mD3/b8A/y
         9ErjugmexwyHB4skxbvSfx+2ZGO8ViKKcM3fdjGgqY9Cpmfmm8nOskD6bBbQWvX67+
         m13dfmowLYpnOtWSaWyNMEkjoLLzoIxPJh/p0/Bn983m5kDbuVKjFF3FTlqtaH7Y1E
         lhqdkFfXmi3hXNXHCSPbSPRxhmkJVv8o4/cZgvqRF74sGgATi6va+V/1qOMIfD6Gsv
         LrmyhodBKxtKO6nvJYjVU/v0S7/ZBJDoUYY3dkKNrHdIAwqL/mvxtUkfCK2/1Gbf4i
         GejcA61fO2eJA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: [PATCH xfrm-next v8 7/8] xfrm: add support to HW update soft and hard limits
Date:   Fri, 18 Nov 2022 08:35:27 +0200
Message-Id: <683fc0b79cfe8e49c3914e48707a8ac5bde5a70c.1668753030.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1668753030.git.leonro@nvidia.com>
References: <cover.1668753030.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Both in RX and TX, the traffic that performs IPsec packet offload
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
 net/xfrm/xfrm_state.c     |  4 ++++
 3 files changed, 22 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 40dff55fad25..f5bba23f2aae 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1040,6 +1040,7 @@ struct xfrmdev_ops {
 	bool	(*xdo_dev_offload_ok) (struct sk_buff *skb,
 				       struct xfrm_state *x);
 	void	(*xdo_dev_state_advance_esn) (struct xfrm_state *x);
+	void	(*xdo_dev_state_update_curlft) (struct xfrm_state *x);
 	int	(*xdo_dev_policy_add) (struct xfrm_policy *x);
 	void	(*xdo_dev_policy_delete) (struct xfrm_policy *x);
 	void	(*xdo_dev_policy_free) (struct xfrm_policy *x);
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 00ce7a68bf3c..3982c43117d0 100644
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
+	if (x->xso.type != XFRM_DEV_OFFLOAD_PACKET)
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
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index cfc8c72b173d..5076f9d7a752 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -570,6 +570,8 @@ static enum hrtimer_restart xfrm_timer_handler(struct hrtimer *me)
 	int err = 0;
 
 	spin_lock(&x->lock);
+	xfrm_dev_state_update_curlft(x);
+
 	if (x->km.state == XFRM_STATE_DEAD)
 		goto out;
 	if (x->km.state == XFRM_STATE_EXPIRED)
@@ -1821,6 +1823,8 @@ EXPORT_SYMBOL(xfrm_state_update);
 
 int xfrm_state_check_expire(struct xfrm_state *x)
 {
+	xfrm_dev_state_update_curlft(x);
+
 	if (!x->curlft.use_time)
 		x->curlft.use_time = ktime_get_real_seconds();
 
-- 
2.38.1

