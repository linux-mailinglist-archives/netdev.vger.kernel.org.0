Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F95C52E1F5
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 03:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344290AbiETB0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 21:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344527AbiETB0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 21:26:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F109E039
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 18:26:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B80A61B0A
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 01:26:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25621C385AA;
        Fri, 20 May 2022 01:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653009961;
        bh=hx1D3YfIK90WpbX638ldtTkbgiWjZuenn0ZiJH1/ISI=;
        h=From:To:Cc:Subject:Date:From;
        b=a1zGhC+0JlxKmERUc5zvqPHn+FwrUMTKy+65hZNv4/fPqFNwaRNriBShFQtAAcAyK
         1x069sHVB10p7bBrGCqaQ8tjpM+vciNncNNv2iMsQfWCi9NVwz173A29EkuKLXrNZZ
         r56lOQOu+E54kdwaVVqY6QzSpuQJOLYQoUuTfax3LLa9QodQtjSu0HKijaRJ2i74im
         84c5rYiejUOSlHyDo5gwe3ulKfAPgovHFihREY6DvTbwjIa1uQstQv4fpk4x4IiLCn
         WuZBckee58S8lbV7M1/zvDZem1ZAS5LK0Glw0/wglmHssl37CuTHHwQCXXE4iDd+Q7
         Iz+Acmj3F0vbw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, nbd@nbd.name,
        john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        matthias.bgg@gmail.com
Subject: [PATCH net-next] eth: mtk_ppe: fix up after merge
Date:   Thu, 19 May 2022 18:25:55 -0700
Message-Id: <20220520012555.2262461-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I missed this in the barrage of GCC 12 warnings. Commit cf2df74e202d
("net: fix dev_fill_forward_path with pppoe + bridge") changed
the pointer into an array.

Fixes: d7e6f5836038 ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: nbd@nbd.name
CC: john@phrozen.org
CC: sean.wang@mediatek.com
CC: Mark-MC.Lee@mediatek.com
CC: matthias.bgg@gmail.com
---
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index 1fe31058b0f2..c9353071f96a 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -90,10 +90,11 @@ mtk_flow_get_wdma_info(struct net_device *dev, const u8 *addr, struct mtk_wdma_i
 {
 	struct net_device_path_ctx ctx = {
 		.dev = dev,
-		.daddr = addr,
 	};
 	struct net_device_path path = {};
 
+	memcpy(ctx.daddr, addr, sizeof(ctx.daddr));
+
 	if (!IS_ENABLED(CONFIG_NET_MEDIATEK_SOC_WED))
 		return -1;
 
-- 
2.34.3

