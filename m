Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1E74577F09
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 11:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234034AbiGRJwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 05:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232195AbiGRJwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 05:52:32 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F334217E1C
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 02:52:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0725CCE12B0
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 09:52:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918C2C341C0;
        Mon, 18 Jul 2022 09:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658137948;
        bh=FvJ30zIBe6teYhvvRTO4Y1PlGza4yd1K3IFdjppMF/g=;
        h=From:To:Cc:Subject:Date:From;
        b=JElPX3qUMrDlcb6A9YI1RPl+F9iekDAlhF0N45C7pFYxei/D/jQWUbYOHUgnCGHYP
         9MJI8Ec9PVbzCFg2YYGLGp0cl8NeY5GFVBVwe0foaY2kpGeR5PxKjoV9WyVxAaW1Ce
         CxbBVVi1Y4rND+0Vu8ToulFB67N9nyn4w+BPgRh3HooP1O+exY4pnTEmgpg4KqXxmO
         2JToIG912eVl0z3vXDxJydwUVA842soi0bkvqJ3cVGvnMjzZdIe7SPxuwxxwUTSrTE
         dnYyx8He6jQm10rRjcsKhXeJljk43ZMu/Ki5lfvdGEYddmLWV8bct1eBjz2Uv5xco7
         7Hgy5f9j7LspA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com
Subject: [PATCH net] net: ethernet: mtk_ppe: fix possible NULL pointer dereference in mtk_flow_get_wdma_info
Date:   Mon, 18 Jul 2022 11:51:53 +0200
Message-Id: <4e1685bc4976e21e364055f6bee86261f8f9ee93.1658137753.git.lorenzo@kernel.org>
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

odev pointer can be NULL in mtk_flow_offload_replace routine according
to the flower action rules. Fix possible NULL pointer dereference in
mtk_flow_get_wdma_info.

Fixes: a333215e10cb5 ("net: ethernet: mtk_eth_soc: implement flow offloading to WED devices")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index 90e7dfd011c9..5d457bc9acc1 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -93,6 +93,9 @@ mtk_flow_get_wdma_info(struct net_device *dev, const u8 *addr, struct mtk_wdma_i
 	};
 	struct net_device_path path = {};
 
+	if (!ctx.dev)
+		return -ENODEV;
+
 	memcpy(ctx.daddr, addr, sizeof(ctx.daddr));
 
 	if (!IS_ENABLED(CONFIG_NET_MEDIATEK_SOC_WED))
-- 
2.36.1

