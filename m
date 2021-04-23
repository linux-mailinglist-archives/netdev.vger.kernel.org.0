Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17175368C8F
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 07:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240451AbhDWFWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 01:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240661AbhDWFWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 01:22:08 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F8DC06138B;
        Thu, 22 Apr 2021 22:21:31 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id m12so13715098pgr.9;
        Thu, 22 Apr 2021 22:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+QE5ZWLQU/5/upbp8ywwYoobLbbRgh+EOZbhqiCaUrA=;
        b=emZgKFW/wnnHGbcgxGHvjMJSTTp41HMSrSfSNbAOHa0WoVcXkjQXL7pjJjWrjoGDTJ
         hId9J9+qWMR8KPl15pQDK/gvU0Kk0GRq39cfQ780+gtChTF0nt7G/WBxnSZ2EF+32EFZ
         lbnn4hpUJJaKZtnm+sx36zRpSyirj1HaDiVhjZb1tMkHCDajmwnCtEk+I6wjDWhUvh0g
         +MWMV/Nn7cGVcKJsMHN7SaYhbVswFRxbe5VOHn05kL7Iq83nG+zccmAfw6T9arFS5p+3
         Vk+AJ7V0fr+Vieurmck8FixnwUU58va+9/nQZA+blGbLKb3/2cZ7Np7Qp74HwqyCk2A3
         F09A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+QE5ZWLQU/5/upbp8ywwYoobLbbRgh+EOZbhqiCaUrA=;
        b=bltZ2R6C78wiWM4OTNw+8Nb1EfezfQNPRCynQLhqqeIoeUmrrMeJL179JlDT35MUtf
         nTaKpdYOM/6M1lfa4upgzZEnQrUCallE0RtFheaR/tzkdDy/wz84hRmbm1++zJHaSbt2
         9+890+lMwwNF8Rrya9pJ/ur5O1zLGCEsnvp/a24DlFreuy7vkvHJGPH/oYI+rwYDhuiK
         /VRQmNBVDW7ywPxmc/YAS8kMGOoPTo6Tx0aTBVI7WlNK8b56QgZsxMfPvTYa/YrLGe2w
         FG/zlIuZUZS/kKe0OlM6WBGMo8CDLRHmDTIzsLuHhK/uJKMW0YLZ/bVryFGbP9GbdS67
         sjgQ==
X-Gm-Message-State: AOAM530BzA7aEpXB3e7D4HzFm6t7qeLHs3ZIwarE7EtaCaPjx2RGs+E3
        oCJ+tC9aYjptxenWk9zYMSzKOOyJu2WvyA9x
X-Google-Smtp-Source: ABdhPJynB6x3ngxSvlU0/QX4s3M24EdwHpWscDh8pUHB5agFFtw8uqjvYdoITIV4mCYf52er8fSdQg==
X-Received: by 2002:a63:d755:: with SMTP id w21mr2221158pgi.400.1619155291309;
        Thu, 22 Apr 2021 22:21:31 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id y24sm6238825pjp.26.2021.04.22.22.21.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 22:21:30 -0700 (PDT)
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 15/15] net: ethernet: mtk_eth_soc: use iopoll.h macro for DMA init
Date:   Thu, 22 Apr 2021 22:21:08 -0700
Message-Id: <20210423052108.423853-16-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210423052108.423853-1-ilya.lipnitskiy@gmail.com>
References: <20210423052108.423853-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace a tight busy-wait loop without a pause with a standard
readx_poll_timeout_atomic routine with a 5 us poll period.

Tested by booting a MT7621 device to ensure the driver initializes
properly.

Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 29 +++++++++------------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  2 +-
 2 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 37e50a2e7d0e..ed4eacef17ce 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2033,25 +2033,22 @@ static int mtk_set_features(struct net_device *dev, netdev_features_t features)
 /* wait for DMA to finish whatever it is doing before we start using it again */
 static int mtk_dma_busy_wait(struct mtk_eth *eth)
 {
-	unsigned long t_start = jiffies;
+	unsigned int reg;
+	int ret;
+	u32 val;
 
-	while (1) {
-		if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA)) {
-			if (!(mtk_r32(eth, MTK_QDMA_GLO_CFG) &
-			      (MTK_RX_DMA_BUSY | MTK_TX_DMA_BUSY)))
-				return 0;
-		} else {
-			if (!(mtk_r32(eth, MTK_PDMA_GLO_CFG) &
-			      (MTK_RX_DMA_BUSY | MTK_TX_DMA_BUSY)))
-				return 0;
-		}
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA))
+		reg = MTK_QDMA_GLO_CFG;
+	else
+		reg = MTK_PDMA_GLO_CFG;
 
-		if (time_after(jiffies, t_start + MTK_DMA_BUSY_TIMEOUT))
-			break;
-	}
+	ret = readx_poll_timeout_atomic(__raw_readl, eth->base + reg, val,
+					!(val & (MTK_RX_DMA_BUSY | MTK_TX_DMA_BUSY)),
+					5, MTK_DMA_BUSY_TIMEOUT_US);
+	if (ret)
+		dev_err(eth->dev, "DMA init timeout\n");
 
-	dev_err(eth->dev, "DMA init timeout\n");
-	return -1;
+	return ret;
 }
 
 static int mtk_dma_init(struct mtk_eth *eth)
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 6b92dd6c2cda..11331b44ba07 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -214,7 +214,7 @@
 #define MTK_TX_DMA_BUSY		BIT(1)
 #define MTK_RX_DMA_EN		BIT(2)
 #define MTK_TX_DMA_EN		BIT(0)
-#define MTK_DMA_BUSY_TIMEOUT	HZ
+#define MTK_DMA_BUSY_TIMEOUT_US	1000000
 
 /* QDMA Reset Index Register */
 #define MTK_QDMA_RST_IDX	0x1A08
-- 
2.31.1

