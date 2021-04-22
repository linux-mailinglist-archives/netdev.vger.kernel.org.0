Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E76C36784D
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 06:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234804AbhDVEKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 00:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231442AbhDVEKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 00:10:17 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8728DC06138E;
        Wed, 21 Apr 2021 21:09:43 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id u14-20020a17090a1f0eb029014e38011b09so240630pja.5;
        Wed, 21 Apr 2021 21:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XaeFpP4NyPNpT7feooMHSBOAhXY5/vqZy8Ostkjc59Q=;
        b=hfi2TcPIsk6W4BIHeinsfsPsQP897tqjtp+z6BngIvDmr5Mr1Iz70jkxspEeoXNQKC
         kgOh8ndlSIRk4O9LWEBeyMysynYTqy9EzGYsvI49aRynODdJ/GILzsgReEDmWfWUnfP7
         mf69N56PkshimlU0N4S97VOauuR1V4HXmKY1Vtncmw7tyEDCVOrXLU0uulLdC341Hr/z
         6NdyCozWKQijnbBFXU74ubUr0p1NxwSB8DpE3QrMx4NlYpN9XO4YZKqCvpK5QbrDEfcU
         OO3fbWobjgX6ZlY9NWBU0r6npAfp9Yha9qcakETlybuYTWaL4VHOYcOXH6XF0G9LpldN
         /A2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XaeFpP4NyPNpT7feooMHSBOAhXY5/vqZy8Ostkjc59Q=;
        b=f8fJ4QBeV7wtlrbUqYbAWuaRgyWP7JRgPhJcpn3sx5S3YrfGGdUPSrWOTL/47kuouf
         t+5xG6nDC54IHcEZapFF3nA/uYTaYUrOAiU6oZtY07N9lf8jPffQ4qWOM1Ln5726LEFT
         8sSDZR9Wo6HpWr6XF+FtG5AYtWLl2KNlB880VHDoxtiAU4ogm64c00i/KUwaZCsWC20J
         lfR10cV9ZiJgKPAaZGx3jq7YcRned3DK4Vs5wL/6h89L2D6DMqHmOxwGjj1V2tzkaIcH
         I4dt24tvSj+r8fhPggWPSysINylzMulT6VpVjKlECpSAGfOcnesAxSuseoqmocU/U7FR
         gdcA==
X-Gm-Message-State: AOAM5334ELD/kbTiFTXG2ON6RjoiLuqCtiI6nQIE+OF6Z4VtUK3Jrt/T
        vBoWaIm/Dxbjg8SlA3chr54=
X-Google-Smtp-Source: ABdhPJwQQeHlhMyirN59DawShgsPiF1tWB8tRGdQUATxeztZ1cCHj1TO/tCxi6vHsEAz2NwgKMU0iQ==
X-Received: by 2002:a17:903:4106:b029:e9:244f:9aca with SMTP id r6-20020a1709034106b02900e9244f9acamr1644202pld.58.1619064583049;
        Wed, 21 Apr 2021 21:09:43 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id i17sm635354pfd.84.2021.04.21.21.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 21:09:42 -0700 (PDT)
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
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Subject: [PATCH net-next 07/14] net: ethernet: mtk_eth_soc: use larger burst size for QDMA TX
Date:   Wed, 21 Apr 2021 21:09:07 -0700
Message-Id: <20210422040914.47788-8-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210422040914.47788-1-ilya.lipnitskiy@gmail.com>
References: <20210422040914.47788-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

Improves tx performance

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 223131645a37..5a67bbe9bd90 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2191,7 +2191,7 @@ static int mtk_start_dma(struct mtk_eth *eth)
 	if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA)) {
 		mtk_w32(eth,
 			MTK_TX_WB_DDONE | MTK_TX_DMA_EN |
-			MTK_DMA_SIZE_16DWORDS | MTK_NDP_CO_PRO |
+			MTK_TX_BT_32DWORDS | MTK_NDP_CO_PRO |
 			MTK_RX_DMA_EN | MTK_RX_2B_OFFSET |
 			MTK_RX_BT_32DWORDS,
 			MTK_QDMA_GLO_CFG);
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 989342a7ae4a..039c39d750e0 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -203,7 +203,7 @@
 #define MTK_RX_BT_32DWORDS	(3 << 11)
 #define MTK_NDP_CO_PRO		BIT(10)
 #define MTK_TX_WB_DDONE		BIT(6)
-#define MTK_DMA_SIZE_16DWORDS	(2 << 4)
+#define MTK_TX_BT_32DWORDS	(3 << 4)
 #define MTK_RX_DMA_BUSY		BIT(3)
 #define MTK_TX_DMA_BUSY		BIT(1)
 #define MTK_RX_DMA_EN		BIT(2)
-- 
2.31.1

