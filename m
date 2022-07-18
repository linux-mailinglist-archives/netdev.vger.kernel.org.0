Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A79925789A0
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 20:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234862AbiGRSgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 14:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbiGRSgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 14:36:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B6E25E9D
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 11:36:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D1A7B816E9
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 18:36:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FAD7C341C0;
        Mon, 18 Jul 2022 18:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658169407;
        bh=pbLxD1a6FhlDvxC0DWqCHHgNPbqWwkoxz5mjbtCWIro=;
        h=From:To:Cc:Subject:Date:From;
        b=sgwGW9zaXFlOIYPF/qTzr9cVcUTrxt6wk2jdzahKvyqkEMHKfyop0RuKrqTyWJJy7
         dfEkH9ZF3FNRqzd8AH6wOLyNXs2RtjCTiYi+eicaoaUJ/vWbquvAx2JylKeUxo2FbS
         1Jf1bIOyKWJ4VZmJ0SXs5IlupPzvcSZ/6jBdO9XpQtNrfUu+5updHHTVw4y9nDUjmC
         5lsC9g7/MmrNIPjYZr4LC75Zs4VSxVkgUcUuMfFyLKXaObCphI8TC3fB0vvkIUOAcQ
         6U3dyDUELbzrNbS87sl/nWwa0xueHrAubMgKUgx2NMhpPrjEzZl8O7QiAajIkDnXhl
         qcwlib9CU9PSQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, pablo@netfilter.org,
        matthias.bgg@gmail.com, linux-mediatek@lists.infradead.org,
        lorenzo.bianconi@redhat.com, Ryder.Lee@mediatek.com,
        Evelyn.Tsai@mediatek.com
Subject: [PATCH net-next] net: ethernet: mtk-ppe: fix traffic offload with bridged wlan
Date:   Mon, 18 Jul 2022 20:36:39 +0200
Message-Id: <7fa3ce7e77fb579515e0a7c5a7dee60fc5999e2b.1658168627.git.lorenzo@kernel.org>
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

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../net/ethernet/mediatek/mtk_ppe_offload.c   | 29 +++++++++----------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index 90e7dfd011c9..25dc3c3aa31d 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -88,29 +88,28 @@ mtk_flow_offload_mangle_eth(const struct flow_action_entry *act, void *eth)
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
 
-	memcpy(ctx.daddr, addr, sizeof(ctx.daddr));
+	if (!dev)
+		return -ENODEV;
 
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

