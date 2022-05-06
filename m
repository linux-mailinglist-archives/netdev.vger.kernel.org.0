Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFC151D8BF
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 15:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392344AbiEFNWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 09:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239008AbiEFNWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 09:22:30 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0254644C4
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 06:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NAWdIn+X5oLyjGQEEAkwc5Hf+xIBmIi3Mu0+INqAleM=; b=K+38SS5d3sJI1CUpBJLWEN8sYD
        8h9z2JNnGb2s1F0xWJYe/FdaacQ1w2G8xptcOvsjsuHC2IBSWyZLWBMayu8i76/aehSwY1pzPRWLl
        kEaqhiBBgQQ2LvGC5SlPAoyK9UNur7mitzuwtVPwqQ155B47OL1vFzz6XAlCZw+1RdWo=;
Received: from p200300daa70ef2004175abbac4c8f9c2.dip0.t-ipconnect.de ([2003:da:a70e:f200:4175:abba:c4c8:f9c2] helo=Maecks.lan)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1nmxr3-0005Kx-AU; Fri, 06 May 2022 15:18:45 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org
Cc:     pablo@netfilter.org
Subject: [PATCH 3/4] net: fix dev_fill_forward_path with pppoe + bridge
Date:   Fri,  6 May 2022 15:18:40 +0200
Message-Id: <20220506131841.3177-3-nbd@nbd.name>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220506131841.3177-1-nbd@nbd.name>
References: <20220506131841.3177-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When calling dev_fill_forward_path on a pppoe device, the provided destination
address is invalid. In order for the bridge fdb lookup to succeed, the pppoe
code needs to update ctx->daddr to the correct value.
Fix this by storing the address inside struct net_device_path_ctx

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c | 2 +-
 drivers/net/ppp/pppoe.c                         | 1 +
 include/linux/netdevice.h                       | 2 +-
 net/core/dev.c                                  | 2 +-
 4 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index 1fe31058b0f2..d4a0126082f2 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -90,7 +90,6 @@ mtk_flow_get_wdma_info(struct net_device *dev, const u8 *addr, struct mtk_wdma_i
 {
 	struct net_device_path_ctx ctx = {
 		.dev = dev,
-		.daddr = addr,
 	};
 	struct net_device_path path = {};
 
@@ -100,6 +99,7 @@ mtk_flow_get_wdma_info(struct net_device *dev, const u8 *addr, struct mtk_wdma_i
 	if (!dev->netdev_ops->ndo_fill_forward_path)
 		return -1;
 
+	memcpy(ctx.daddr, addr, sizeof(ctx.daddr));
 	if (dev->netdev_ops->ndo_fill_forward_path(&ctx, &path))
 		return -1;
 
diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index 1b41cd9732d7..ce2cbb5903d7 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -988,6 +988,7 @@ static int pppoe_fill_forward_path(struct net_device_path_ctx *ctx,
 	path->encap.proto = htons(ETH_P_PPP_SES);
 	path->encap.id = be16_to_cpu(po->num);
 	memcpy(path->encap.h_dest, po->pppoe_pa.remote, ETH_ALEN);
+	memcpy(ctx->daddr, po->pppoe_pa.remote, ETH_ALEN);
 	path->dev = ctx->dev;
 	ctx->dev = dev;
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index eaf66e57d891..a87dbbd22cbb 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -909,7 +909,7 @@ struct net_device_path_stack {
 
 struct net_device_path_ctx {
 	const struct net_device *dev;
-	const u8		*daddr;
+	u8			daddr[ETH_ALEN];
 
 	int			num_vlans;
 	struct {
diff --git a/net/core/dev.c b/net/core/dev.c
index c2d73595a7c3..0c5c020304a0 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -682,11 +682,11 @@ int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
 	const struct net_device *last_dev;
 	struct net_device_path_ctx ctx = {
 		.dev	= dev,
-		.daddr	= daddr,
 	};
 	struct net_device_path *path;
 	int ret = 0;
 
+	memcpy(ctx.daddr, daddr, sizeof(ctx.daddr));
 	stack->num_paths = 0;
 	while (ctx.dev && ctx.dev->netdev_ops->ndo_fill_forward_path) {
 		last_dev = ctx.dev;
-- 
2.35.1

