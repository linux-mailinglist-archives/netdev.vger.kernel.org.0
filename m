Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E213157DA9C
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 09:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233417AbiGVHGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 03:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiGVHG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 03:06:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159CD8E6F5
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 00:06:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2FD762088
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 07:06:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81462C341C7;
        Fri, 22 Jul 2022 07:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658473587;
        bh=XLTTjhAlQU069Q80S9sF/4wyl2wZ60rupcBZIJL+82o=;
        h=From:To:Cc:Subject:Date:From;
        b=eU/3tN8N4knUKcEZutX4jeq20xwrzGo+R5X3//rKt5rou4QiMrn2fOC65HjimauHh
         cBve2PEIxTEcZYMDkUza2bSHfkidsGVJmqs0cKXoWnykhTFeZj+IzSsdqCS8JY3JH7
         zyMFGVPL/5BeVb9qb56IDMwH2sviq/1Gz+kVKd8vt3sqROWHauwpMX5vpedhDs7PvW
         IBMcQoPnU6MKF2Fios4i2ZK1atWIjKLGylkzPoBeuMj2dtySP1Wmp/a/6QFvlnQlPj
         xfoT0iHhQ5NKeQJlrGWYxI1nACN+aaeMdDrTGPUziK6ep1749DqjU3z+Ku6djy4lVc
         wd0L2uLVNFy0g==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, pablo@netfilter.org,
        matthias.bgg@gmail.com, linux-mediatek@lists.infradead.org,
        lorenzo.bianconi@redhat.com, Ryder.Lee@mediatek.com,
        Evelyn.Tsai@mediatek.com, pvalerio@redhat.com
Subject: [PATCH v2 net-next] net: ethernet: mtk-ppe: fix traffic offload with bridged wlan
Date:   Fri, 22 Jul 2022 09:06:19 +0200
Message-Id: <c79ed39af42540a6ce2cd145c4ddbcb98491630b.1658473427.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A typical flow offload scenario for OpenWrt users is routed traffic
received by the wan interface that is redirected to a wlan device
belonging to the lan bridge. Current implementation fails to
fill wdma offload info in mtk_flow_get_wdma_info() since odev device is
the local bridge. Fix the issue running dev_fill_forward_path routine in
mtk_flow_get_wdma_info in order to identify the wlan device.

Tested-by: Paolo Valerio <pvalerio@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
Changes since v1:
- rebase on top of net-next master
---
 .../net/ethernet/mediatek/mtk_ppe_offload.c   | 30 ++++++++-----------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index 5d457bc9acc1..25dc3c3aa31d 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -88,32 +88,28 @@ mtk_flow_offload_mangle_eth(const struct flow_action_entry *act, void *eth)
 static int
 mtk_flow_get_wdma_info(struct net_device *dev, const u8 *addr, struct mtk_wdma_info *info)
 {
-	struct net_device_path_ctx ctx = {
-		.dev = dev,
-	};
-	struct net_device_path path = {};
+	struct net_device_path_stack stack;
+	struct net_device_path *path;
+	int err;
 
-	if (!ctx.dev)
+	if (!dev)
 		return -ENODEV;
 
-	memcpy(ctx.daddr, addr, sizeof(ctx.daddr));
-
 	if (!IS_ENABLED(CONFIG_NET_MEDIATEK_SOC_WED))
 		return -1;
 
-	if (!dev->netdev_ops->ndo_fill_forward_path)
-		return -1;
-
-	if (dev->netdev_ops->ndo_fill_forward_path(&ctx, &path))
-		return -1;
+	err = dev_fill_forward_path(dev, addr, &stack);
+	if (err)
+		return err;
 
-	if (path.type != DEV_PATH_MTK_WDMA)
+	path = &stack.path[stack.num_paths - 1];
+	if (path->type != DEV_PATH_MTK_WDMA)
 		return -1;
 
-	info->wdma_idx = path.mtk_wdma.wdma_idx;
-	info->queue = path.mtk_wdma.queue;
-	info->bss = path.mtk_wdma.bss;
-	info->wcid = path.mtk_wdma.wcid;
+	info->wdma_idx = path->mtk_wdma.wdma_idx;
+	info->queue = path->mtk_wdma.queue;
+	info->bss = path->mtk_wdma.bss;
+	info->wcid = path->mtk_wdma.wcid;
 
 	return 0;
 }
-- 
2.36.1

