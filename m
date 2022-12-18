Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3D4065016E
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 17:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232176AbiLRQaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 11:30:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232146AbiLRQ3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 11:29:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C158B287;
        Sun, 18 Dec 2022 08:10:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B71DB80BA4;
        Sun, 18 Dec 2022 16:10:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A1CC433D2;
        Sun, 18 Dec 2022 16:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379833;
        bh=q7lfFyFR6E+o1kguI+ZUe/xB/1GBz8RnOY6mSvtFvtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IMDyY/wT2Z66DWs97d8esUtFQWwT77tXYbjWgPq9ocAGHyHyZwOQ0Xc22midM7ZFX
         jqX8/d9LyCAlZ8DF1Cwb3Hog82mknkbV8t4D4gZ6hyRh+NEP4fIXdSMi3wnJgV+osy
         HtMaRf7Eg1IXF5hl4LsWq9YdXo2T3C/iJcWJyYLgeMQYOQxBe8NYD3dKtQBzOrBYHo
         kDjApLu+I1IAvCt7GdxNRBB80UcHYPDSPJd1tguFqvYlp0mg9zpYUN9BOcpstQ+SrI
         KvZ9ESmvRu9RXmZXBdZ59iT6WkWabO71vC9YC9TK1yEFc1IEaCGIynkskiIIM3uHlE
         JxLgFDp6v8qQA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.0 45/73] net: ethernet: mtk_eth_soc: drop packets to WDMA if the ring is full
Date:   Sun, 18 Dec 2022 11:07:13 -0500
Message-Id: <20221218160741.927862-45-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160741.927862-1-sashal@kernel.org>
References: <20221218160741.927862-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit f4b2fa2c25e1ade78f766aa82e733a0b5198d484 ]

Improves handling of DMA ring overflow.
Clarify other WDMA drop related comment.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20221116080734.44013-3-nbd@nbd.name
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 5 ++++-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 5380caf0acc2..27e178599ffd 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3311,9 +3311,12 @@ static int mtk_hw_init(struct mtk_eth *eth)
 	mtk_w32(eth, 0x21021000, MTK_FE_INT_GRP);
 
 	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
-		/* PSE should not drop port8 and port9 packets */
+		/* PSE should not drop port8 and port9 packets from WDMA Tx */
 		mtk_w32(eth, 0x00000300, PSE_DROP_CFG);
 
+		/* PSE should drop packets to port 8/9 on WDMA Rx ring full */
+		mtk_w32(eth, 0x00000300, PSE_PPE0_DROP);
+
 		/* PSE Free Queue Flow Control  */
 		mtk_w32(eth, 0x01fa01f4, PSE_FQFC_CFG2);
 
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 0f9668a4079d..1c2a5fece126 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -121,6 +121,7 @@
 #define PSE_FQFC_CFG1		0x100
 #define PSE_FQFC_CFG2		0x104
 #define PSE_DROP_CFG		0x108
+#define PSE_PPE0_DROP		0x110
 
 /* PSE Input Queue Reservation Register*/
 #define PSE_IQ_REV(x)		(0x140 + (((x) - 1) << 2))
-- 
2.35.1

