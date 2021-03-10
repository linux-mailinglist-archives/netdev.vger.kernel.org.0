Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB14D333C20
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 13:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbhCJMEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 07:04:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232929AbhCJMEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 07:04:44 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B3BBC061761
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:04:44 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id c10so38117501ejx.9
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:04:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OJnVq8r2fzUNQAWLMQfE4OMc3vq4nuKCHOZGEnNktZ4=;
        b=CZeIHB+3kLnaiIA7T8Nb4iAWICAL1HEogtz7STJBIv2nIyNLkRQCATDXLyKlb0c6N2
         mi5xlsIQ6X6zDb8BAME7zneL7Sgc1+YrNHssP8MJ/4/GzscfbRom7LI9UVxr9m3zuSrl
         9kO12xXGJRlmyLkoFW46YwAyz4wHyZ02IuE9C2S3FvpG1gx0Ss1dgW8u7IbeiWUHQMoF
         BDOjn7XWdnaxYEjUnV37X30gR4Mf4gwGDWPUbq7rus9odIS+CKN/iPEVCSCfW41M1ag4
         KzeIN/L09Y0SambdEC9qXvQT3Y5VBnAwxnDMwDhO/8zvlgNiEHP+5yhtA3uP5NGzLCe9
         SOhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OJnVq8r2fzUNQAWLMQfE4OMc3vq4nuKCHOZGEnNktZ4=;
        b=Neoy8RzS2sLa3FjWr4/G2Y7Uk3lFNgntbBnEJmYi5lASiVBMWWOVPrlIzDy/z5Tmkn
         oDLe8FXvSXOHYtTgD2fZIz41RRzdz4tsSFlgNAM4/+krOCYchgmRYAPSC1EEi/NVvXoD
         xHRIAhYWYJU3OFr5W9AUY7x49+3OuTS8Wwx3aJgrjJw7jsHGIim+6/63MXCX3d+N3m9m
         HKQLoijExRw4/zOL9KtjqytfrKkW81QrwkPOf8UunqmPUpyUImffucuD+zz+s/NBAt8j
         QcEySlDFlG3YzYV/wQFO6ITbBcA3m2Sm27sSKdsUs6Do4g2qGqsdfxGSdkN9Y2EMx765
         YApw==
X-Gm-Message-State: AOAM530iW8CU5zsCLyYOtytnzFClOowsPfocKnCy4Nar870NvgszR2m2
        NwMf8eBBT9c8OrTSxJB9w4I=
X-Google-Smtp-Source: ABdhPJysXzemETsEpZxT3u/D0SiEr0FkTXiYsQwE+x/p82t0xqs6z8bBfSiFX7f1MbwfOh8bT1G4Ag==
X-Received: by 2002:a17:906:688:: with SMTP id u8mr3221619ejb.38.1615377882675;
        Wed, 10 Mar 2021 04:04:42 -0800 (PST)
Received: from localhost.localdomain ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id q20sm9913239ejs.41.2021.03.10.04.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 04:04:42 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
X-Google-Original-From: Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH net-next 01/12] net: enetc: move the CBDR API to enetc_cbdr.c
Date:   Wed, 10 Mar 2021 14:03:40 +0200
Message-Id: <20210310120351.542292-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210310120351.542292-1-vladimir.oltean@nxp.com>
References: <20210310120351.542292-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since there is a dedicated file in this driver for interacting with
control BD rings, it makes sense to move these functions there.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c  | 54 -------------------
 .../net/ethernet/freescale/enetc/enetc_cbdr.c | 54 +++++++++++++++++++
 2 files changed, 54 insertions(+), 54 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 09471329f3a3..a6ae4ebaee7d 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -995,60 +995,6 @@ static void enetc_free_rxtx_rings(struct enetc_ndev_priv *priv)
 		enetc_free_tx_ring(priv->tx_ring[i]);
 }
 
-int enetc_alloc_cbdr(struct device *dev, struct enetc_cbdr *cbdr)
-{
-	int size = cbdr->bd_count * sizeof(struct enetc_cbd);
-
-	cbdr->bd_base = dma_alloc_coherent(dev, size, &cbdr->bd_dma_base,
-					   GFP_KERNEL);
-	if (!cbdr->bd_base)
-		return -ENOMEM;
-
-	/* h/w requires 128B alignment */
-	if (!IS_ALIGNED(cbdr->bd_dma_base, 128)) {
-		dma_free_coherent(dev, size, cbdr->bd_base, cbdr->bd_dma_base);
-		return -EINVAL;
-	}
-
-	cbdr->next_to_clean = 0;
-	cbdr->next_to_use = 0;
-
-	return 0;
-}
-
-void enetc_free_cbdr(struct device *dev, struct enetc_cbdr *cbdr)
-{
-	int size = cbdr->bd_count * sizeof(struct enetc_cbd);
-
-	dma_free_coherent(dev, size, cbdr->bd_base, cbdr->bd_dma_base);
-	cbdr->bd_base = NULL;
-}
-
-void enetc_setup_cbdr(struct enetc_hw *hw, struct enetc_cbdr *cbdr)
-{
-	/* set CBDR cache attributes */
-	enetc_wr(hw, ENETC_SICAR2,
-		 ENETC_SICAR_RD_COHERENT | ENETC_SICAR_WR_COHERENT);
-
-	enetc_wr(hw, ENETC_SICBDRBAR0, lower_32_bits(cbdr->bd_dma_base));
-	enetc_wr(hw, ENETC_SICBDRBAR1, upper_32_bits(cbdr->bd_dma_base));
-	enetc_wr(hw, ENETC_SICBDRLENR, ENETC_RTBLENR_LEN(cbdr->bd_count));
-
-	enetc_wr(hw, ENETC_SICBDRPIR, 0);
-	enetc_wr(hw, ENETC_SICBDRCIR, 0);
-
-	/* enable ring */
-	enetc_wr(hw, ENETC_SICBDRMR, BIT(31));
-
-	cbdr->pir = hw->reg + ENETC_SICBDRPIR;
-	cbdr->cir = hw->reg + ENETC_SICBDRCIR;
-}
-
-void enetc_clear_cbdr(struct enetc_hw *hw)
-{
-	enetc_wr(hw, ENETC_SICBDRMR, 0);
-}
-
 static int enetc_setup_default_rss_table(struct enetc_si *si, int num_groups)
 {
 	int *rss_table;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c b/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c
index 201cbc362e33..ad6aecda6b47 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c
@@ -3,6 +3,60 @@
 
 #include "enetc.h"
 
+int enetc_alloc_cbdr(struct device *dev, struct enetc_cbdr *cbdr)
+{
+	int size = cbdr->bd_count * sizeof(struct enetc_cbd);
+
+	cbdr->bd_base = dma_alloc_coherent(dev, size, &cbdr->bd_dma_base,
+					   GFP_KERNEL);
+	if (!cbdr->bd_base)
+		return -ENOMEM;
+
+	/* h/w requires 128B alignment */
+	if (!IS_ALIGNED(cbdr->bd_dma_base, 128)) {
+		dma_free_coherent(dev, size, cbdr->bd_base, cbdr->bd_dma_base);
+		return -EINVAL;
+	}
+
+	cbdr->next_to_clean = 0;
+	cbdr->next_to_use = 0;
+
+	return 0;
+}
+
+void enetc_free_cbdr(struct device *dev, struct enetc_cbdr *cbdr)
+{
+	int size = cbdr->bd_count * sizeof(struct enetc_cbd);
+
+	dma_free_coherent(dev, size, cbdr->bd_base, cbdr->bd_dma_base);
+	cbdr->bd_base = NULL;
+}
+
+void enetc_setup_cbdr(struct enetc_hw *hw, struct enetc_cbdr *cbdr)
+{
+	/* set CBDR cache attributes */
+	enetc_wr(hw, ENETC_SICAR2,
+		 ENETC_SICAR_RD_COHERENT | ENETC_SICAR_WR_COHERENT);
+
+	enetc_wr(hw, ENETC_SICBDRBAR0, lower_32_bits(cbdr->bd_dma_base));
+	enetc_wr(hw, ENETC_SICBDRBAR1, upper_32_bits(cbdr->bd_dma_base));
+	enetc_wr(hw, ENETC_SICBDRLENR, ENETC_RTBLENR_LEN(cbdr->bd_count));
+
+	enetc_wr(hw, ENETC_SICBDRPIR, 0);
+	enetc_wr(hw, ENETC_SICBDRCIR, 0);
+
+	/* enable ring */
+	enetc_wr(hw, ENETC_SICBDRMR, BIT(31));
+
+	cbdr->pir = hw->reg + ENETC_SICBDRPIR;
+	cbdr->cir = hw->reg + ENETC_SICBDRCIR;
+}
+
+void enetc_clear_cbdr(struct enetc_hw *hw)
+{
+	enetc_wr(hw, ENETC_SICBDRMR, 0);
+}
+
 static void enetc_clean_cbdr(struct enetc_si *si)
 {
 	struct enetc_cbdr *ring = &si->cbd_ring;
-- 
2.25.1

