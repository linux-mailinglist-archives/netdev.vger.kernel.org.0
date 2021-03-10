Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE73333C22
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 13:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232900AbhCJMEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 07:04:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232930AbhCJMEp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 07:04:45 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A2EC061762
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:04:44 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id x9so27607560edd.0
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:04:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FT1x6x9ugdWaFZzEHSyMIq0oqTnCwmalm2czRraEjvg=;
        b=j5wi7JXT9jCdrYhhyMIQ0a7h5rhV2PV2w++mtOECUS2jc8Nscx1XOf0yaw3F1V4APn
         6/LFc2rEVRDV7PMhblCoh7iic/DEY68HEU1xK2cxFbIpS7Bf9BDJ/+ZNHBPye2UAuH3Z
         TYHtGW9gAvvZ6buJ+2NjqXMpWE5PBCkUdwKlUK5Z7pR2VX69c8MYMGFzrn+5kvUutjCa
         K5DzJ1+Cj7qTD6zVLUiynpLFtYr9K9IE8oFGw7qN2aB2mzqGoSxL5gNtz2uo4MJF4tCb
         1/7aRzPStnHe0E0dbmv5vfvPBY8OrksD0QERnrovfXA+f8XToOmp7JnKiRqtGARMD2HQ
         Kl3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FT1x6x9ugdWaFZzEHSyMIq0oqTnCwmalm2czRraEjvg=;
        b=f/rN9EbEYiAzVxqyquQPpt84tjCQwSCpPDnidd2ov7/qh2wMQ7v5pqqW5SdF8aoZs5
         eFNjr04jovuax3QhlvpDJcBKUtob73kErZSRRwHp0z7Suy0eoFq/dWyDlaKKLvxhxhyS
         rjbwxzUnWlGznhpZB8qccWhBTU+cw81v4LebVfUEyDtL157bAqvmzhoFYepZI0PrfGba
         l8HUeGqi0snWM8gO+ddM62mjIVnvPGN3h5iDdT07TRgrLF8kE2rAYx2UB0lY4V234p5O
         9r3Wu3UpEbHd8Sfd8cUv4zHfXIrS7fJf99kS5e2ayq9oTQ88RnHEoBVxm56udFykOB/N
         wLrQ==
X-Gm-Message-State: AOAM5304x5eACQA2FuOTG6SItxOcj2K+FbNoeLKULWPuJJhV8K26PZuU
        ZKy9bIGMo2X9jaGo+Lda2ns=
X-Google-Smtp-Source: ABdhPJy2dIUjTwde4JTPmpPpjFUKzg5l3YA1rBaHE3gAKYWy7l7kWcVSstBpO+IUOpqW1sGEFC44Bg==
X-Received: by 2002:aa7:c386:: with SMTP id k6mr2782634edq.224.1615377883462;
        Wed, 10 Mar 2021 04:04:43 -0800 (PST)
Received: from localhost.localdomain ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id q20sm9913239ejs.41.2021.03.10.04.04.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 04:04:43 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
X-Google-Original-From: Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH net-next 02/12] net: enetc: save the DMA device for enetc_free_cbdr
Date:   Wed, 10 Mar 2021 14:03:41 +0200
Message-Id: <20210310120351.542292-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210310120351.542292-1-vladimir.oltean@nxp.com>
References: <20210310120351.542292-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We shouldn't need to pass the struct device *dev to enetc CBDR APIs over
and over again, so save this inside struct enetc_cbdr::dma_dev and avoid
calling it from the enetc_free_cbdr functions.

This breaks the dependency of the cbdr API from struct enetc_si (the
station interface).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c  |  4 +-
 drivers/net/ethernet/freescale/enetc/enetc.h  |  3 +-
 .../net/ethernet/freescale/enetc/enetc_cbdr.c | 37 +++++++++++--------
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  2 +-
 4 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index a6ae4ebaee7d..ceecee42f0f1 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1081,7 +1081,7 @@ int enetc_alloc_si_resources(struct enetc_ndev_priv *priv)
 
 err_alloc_cls:
 	enetc_clear_cbdr(&si->hw);
-	enetc_free_cbdr(priv->dev, &si->cbd_ring);
+	enetc_free_cbdr(&si->cbd_ring);
 
 	return err;
 }
@@ -1091,7 +1091,7 @@ void enetc_free_si_resources(struct enetc_ndev_priv *priv)
 	struct enetc_si *si = priv->si;
 
 	enetc_clear_cbdr(&si->hw);
-	enetc_free_cbdr(priv->dev, &si->cbd_ring);
+	enetc_free_cbdr(&si->cbd_ring);
 
 	kfree(priv->cls_rules);
 }
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 8b380fc13314..b343d1002bb7 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -104,6 +104,7 @@ struct enetc_cbdr {
 	int next_to_clean;
 
 	dma_addr_t bd_dma_base;
+	struct device *dma_dev;
 };
 
 #define ENETC_TXBD(BDR, i) (&(((union enetc_tx_bd *)((BDR).bd_base))[i]))
@@ -311,7 +312,7 @@ void enetc_set_ethtool_ops(struct net_device *ndev);
 
 /* control buffer descriptor ring (CBDR) */
 int enetc_alloc_cbdr(struct device *dev, struct enetc_cbdr *cbdr);
-void enetc_free_cbdr(struct device *dev, struct enetc_cbdr *cbdr);
+void enetc_free_cbdr(struct enetc_cbdr *cbdr);
 void enetc_setup_cbdr(struct enetc_hw *hw, struct enetc_cbdr *cbdr);
 void enetc_clear_cbdr(struct enetc_hw *hw);
 int enetc_set_mac_flt_entry(struct enetc_si *si, int index,
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c b/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c
index ad6aecda6b47..7e84eb665ecd 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c
@@ -14,22 +14,26 @@ int enetc_alloc_cbdr(struct device *dev, struct enetc_cbdr *cbdr)
 
 	/* h/w requires 128B alignment */
 	if (!IS_ALIGNED(cbdr->bd_dma_base, 128)) {
-		dma_free_coherent(dev, size, cbdr->bd_base, cbdr->bd_dma_base);
+		dma_free_coherent(dev, size, cbdr->bd_base,
+				  cbdr->bd_dma_base);
 		return -EINVAL;
 	}
 
 	cbdr->next_to_clean = 0;
 	cbdr->next_to_use = 0;
+	cbdr->dma_dev = dev;
 
 	return 0;
 }
 
-void enetc_free_cbdr(struct device *dev, struct enetc_cbdr *cbdr)
+void enetc_free_cbdr(struct enetc_cbdr *cbdr)
 {
 	int size = cbdr->bd_count * sizeof(struct enetc_cbd);
 
-	dma_free_coherent(dev, size, cbdr->bd_base, cbdr->bd_dma_base);
+	dma_free_coherent(cbdr->dma_dev, size, cbdr->bd_base,
+			  cbdr->bd_dma_base);
 	cbdr->bd_base = NULL;
+	cbdr->dma_dev = NULL;
 }
 
 void enetc_setup_cbdr(struct enetc_hw *hw, struct enetc_cbdr *cbdr)
@@ -57,9 +61,8 @@ void enetc_clear_cbdr(struct enetc_hw *hw)
 	enetc_wr(hw, ENETC_SICBDRMR, 0);
 }
 
-static void enetc_clean_cbdr(struct enetc_si *si)
+static void enetc_clean_cbdr(struct enetc_cbdr *ring)
 {
-	struct enetc_cbdr *ring = &si->cbd_ring;
 	struct enetc_cbd *dest_cbd;
 	int i, status;
 
@@ -69,7 +72,7 @@ static void enetc_clean_cbdr(struct enetc_si *si)
 		dest_cbd = ENETC_CBD(*ring, i);
 		status = dest_cbd->status_flags & ENETC_CBD_STATUS_MASK;
 		if (status)
-			dev_warn(&si->pdev->dev, "CMD err %04x for cmd %04x\n",
+			dev_warn(ring->dma_dev, "CMD err %04x for cmd %04x\n",
 				 status, dest_cbd->cmd);
 
 		memset(dest_cbd, 0, sizeof(*dest_cbd));
@@ -97,7 +100,7 @@ int enetc_send_cmd(struct enetc_si *si, struct enetc_cbd *cbd)
 		return -EIO;
 
 	if (unlikely(!enetc_cbd_unused(ring)))
-		enetc_clean_cbdr(si);
+		enetc_clean_cbdr(ring);
 
 	i = ring->next_to_use;
 	dest_cbd = ENETC_CBD(*ring, i);
@@ -123,7 +126,7 @@ int enetc_send_cmd(struct enetc_si *si, struct enetc_cbd *cbd)
 	/* CBD may writeback data, feedback up level */
 	*cbd = *dest_cbd;
 
-	enetc_clean_cbdr(si);
+	enetc_clean_cbdr(ring);
 
 	return 0;
 }
@@ -171,6 +174,7 @@ int enetc_set_mac_flt_entry(struct enetc_si *si, int index,
 int enetc_set_fs_entry(struct enetc_si *si, struct enetc_cmd_rfse *rfse,
 		       int index)
 {
+	struct enetc_cbdr *ring = &si->cbd_ring;
 	struct enetc_cbd cbd = {.cmd = 0};
 	dma_addr_t dma, dma_align;
 	void *tmp, *tmp_align;
@@ -183,10 +187,10 @@ int enetc_set_fs_entry(struct enetc_si *si, struct enetc_cmd_rfse *rfse,
 	cbd.length = cpu_to_le16(sizeof(*rfse));
 	cbd.opt[3] = cpu_to_le32(0); /* SI */
 
-	tmp = dma_alloc_coherent(&si->pdev->dev, sizeof(*rfse) + RFSE_ALIGN,
+	tmp = dma_alloc_coherent(ring->dma_dev, sizeof(*rfse) + RFSE_ALIGN,
 				 &dma, GFP_KERNEL);
 	if (!tmp) {
-		dev_err(&si->pdev->dev, "DMA mapping of RFS entry failed!\n");
+		dev_err(ring->dma_dev, "DMA mapping of RFS entry failed!\n");
 		return -ENOMEM;
 	}
 
@@ -199,9 +203,9 @@ int enetc_set_fs_entry(struct enetc_si *si, struct enetc_cmd_rfse *rfse,
 
 	err = enetc_send_cmd(si, &cbd);
 	if (err)
-		dev_err(&si->pdev->dev, "FS entry add failed (%d)!", err);
+		dev_err(ring->dma_dev, "FS entry add failed (%d)!", err);
 
-	dma_free_coherent(&si->pdev->dev, sizeof(*rfse) + RFSE_ALIGN,
+	dma_free_coherent(ring->dma_dev, sizeof(*rfse) + RFSE_ALIGN,
 			  tmp, dma);
 
 	return err;
@@ -211,6 +215,7 @@ int enetc_set_fs_entry(struct enetc_si *si, struct enetc_cmd_rfse *rfse,
 static int enetc_cmd_rss_table(struct enetc_si *si, u32 *table, int count,
 			       bool read)
 {
+	struct enetc_cbdr *ring = &si->cbd_ring;
 	struct enetc_cbd cbd = {.cmd = 0};
 	dma_addr_t dma, dma_align;
 	u8 *tmp, *tmp_align;
@@ -220,10 +225,10 @@ static int enetc_cmd_rss_table(struct enetc_si *si, u32 *table, int count,
 		/* HW only takes in a full 64 entry table */
 		return -EINVAL;
 
-	tmp = dma_alloc_coherent(&si->pdev->dev, count + RSSE_ALIGN,
+	tmp = dma_alloc_coherent(ring->dma_dev, count + RSSE_ALIGN,
 				 &dma, GFP_KERNEL);
 	if (!tmp) {
-		dev_err(&si->pdev->dev, "DMA mapping of RSS table failed!\n");
+		dev_err(ring->dma_dev, "DMA mapping of RSS table failed!\n");
 		return -ENOMEM;
 	}
 	dma_align = ALIGN(dma, RSSE_ALIGN);
@@ -243,13 +248,13 @@ static int enetc_cmd_rss_table(struct enetc_si *si, u32 *table, int count,
 
 	err = enetc_send_cmd(si, &cbd);
 	if (err)
-		dev_err(&si->pdev->dev, "RSS cmd failed (%d)!", err);
+		dev_err(ring->dma_dev, "RSS cmd failed (%d)!", err);
 
 	if (read)
 		for (i = 0; i < count; i++)
 			table[i] = tmp_align[i];
 
-	dma_free_coherent(&si->pdev->dev, count + RSSE_ALIGN, tmp, dma);
+	dma_free_coherent(ring->dma_dev, count + RSSE_ALIGN, tmp, dma);
 
 	return err;
 }
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 224fc37a6757..a7195ec736f3 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -1098,7 +1098,7 @@ static void enetc_init_unused_port(struct enetc_si *si)
 	enetc_init_port_rss_memory(si);
 
 	enetc_clear_cbdr(hw);
-	enetc_free_cbdr(dev, &si->cbd_ring);
+	enetc_free_cbdr(&si->cbd_ring);
 }
 
 static int enetc_pf_probe(struct pci_dev *pdev,
-- 
2.25.1

