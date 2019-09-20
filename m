Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75654B961C
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 19:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391621AbfITRAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 13:00:43 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41302 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391506AbfITRAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 13:00:42 -0400
Received: by mail-wr1-f68.google.com with SMTP id h7so7452142wrw.8;
        Fri, 20 Sep 2019 10:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PYRjHANJ0MWxLPIUwtgxGbxSiQPDnOdCGXrlF6OG6sU=;
        b=LyQN9rMXftusXw4XU5bgx8xZjtrXZGdGwiriDtRRBb+NbwDw9oJwjFS4a+jBI8foWq
         /5BjZL/eLtkw+IOSCHwk0r/VXxw8F/6gf1+ddTo/DhTkgjymFigCh4iLrWNVrbGIRmjm
         NHOTSqDo8ihWDyHP53CrTAVevpjP35Hr1Hr6dfR87xAUdZ17X6pljXdnevo7zUXo5J1d
         vKZcA1jbS/ZS1Q4SDX/HVpjuhTJPDq1tzXEqIb7oJ3pMdDoFVuNictfO4DxJLQpKmjYX
         sJwG70oE6qhEX5ggTvi9/OQ7PHscODPrRgHGatCnhlv7/uzbZ05pVomGVGXwxJdQgyPg
         mngA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PYRjHANJ0MWxLPIUwtgxGbxSiQPDnOdCGXrlF6OG6sU=;
        b=Qzdgkh0XyypTLDG51uJwSjAdrfFhm/89lImMENCq4rxEGowtNefMXhMYoq0/vbTaA3
         aurLSPq2FmMfkvFL+1dwd0Kd0ooKIRVfPh3gUI+pfuqRzRxDe8/WJj1t6W3Fvhdjx19M
         n1iX8tSDnK7uefQiqruAioRKbg2VtaXd1xhpJZEv8ESSqoCdYouoD6yHo3PVsaqUXt5l
         nQbxzcbgVqMhKauEvl8gsOsrTSKtQcri4h8bffKlbFlFq3OuGlS/BuCH0odtaahkbUIL
         xh38raj8XC/jr+Hf+bjezNwM3epYWQMVtzWKzdf7Ug8WHz5fk+lQAqmnmPJEgVT4XT8b
         Sdkg==
X-Gm-Message-State: APjAAAVnnrOvzNjLY01qdI80kT/CZI58gsOgBbXrZmk8gGe77tNSOZ/0
        U7AykmQQTnbwA8EgJis+Cww=
X-Google-Smtp-Source: APXvYqwG+IDZfUBwpXjVeS1KW3NuGTdzjIGF/+u7zxEYpfiREVdBPQ/7EEdx3/94+Hk5Gey3cXBvaQ==
X-Received: by 2002:a5d:62c8:: with SMTP id o8mr12317178wrv.350.1568998840543;
        Fri, 20 Sep 2019 10:00:40 -0700 (PDT)
Received: from localhost (p2E5BE2CE.dip0.t-ipconnect.de. [46.91.226.206])
        by smtp.gmail.com with ESMTPSA id y13sm3513601wrg.8.2019.09.20.10.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 10:00:39 -0700 (PDT)
From:   Thierry Reding <thierry.reding@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Bitan Biswas <bbiswas@nvidia.com>, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH v3 1/2] net: stmmac: Only enable enhanced addressing mode when needed
Date:   Fri, 20 Sep 2019 19:00:35 +0200
Message-Id: <20190920170036.22610-2-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190920170036.22610-1-thierry.reding@gmail.com>
References: <20190920170036.22610-1-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Enhanced addressing mode is only required when more than 32 bits need to
be addressed. Add a DMA configuration parameter to enable this mode only
when needed.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c | 5 ++++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 6 ++++++
 include/linux/stmmac.h                             | 1 +
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
index 64956465c030..3e00fd8befcf 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -27,7 +27,10 @@ static void dwxgmac2_dma_init(void __iomem *ioaddr,
 	if (dma_cfg->aal)
 		value |= XGMAC_AAL;
 
-	writel(value | XGMAC_EAME, ioaddr + XGMAC_DMA_SYSBUS_MODE);
+	if (dma_cfg->eame)
+		value |= XGMAC_EAME;
+
+	writel(value, ioaddr + XGMAC_DMA_SYSBUS_MODE);
 }
 
 static void dwxgmac2_dma_init_chan(void __iomem *ioaddr,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 06ccd216ae90..ecd461207dbc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4497,6 +4497,12 @@ int stmmac_dvr_probe(struct device *device,
 		if (!ret) {
 			dev_info(priv->device, "Using %d bits DMA width\n",
 				 priv->dma_cap.addr64);
+
+			/*
+			 * If more than 32 bits can be addressed, make sure to
+			 * enable enhanced addressing mode.
+			 */
+			priv->plat->dma_cfg->eame = true;
 		} else {
 			ret = dma_set_mask_and_coherent(device, DMA_BIT_MASK(32));
 			if (ret) {
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index 7ad7ae35cf88..d300ac907c76 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -92,6 +92,7 @@ struct stmmac_dma_cfg {
 	int fixed_burst;
 	int mixed_burst;
 	bool aal;
+	bool eame;
 };
 
 #define AXI_BLEN	7
-- 
2.23.0

