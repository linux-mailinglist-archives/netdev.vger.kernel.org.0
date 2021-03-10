Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AAC9333C23
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 13:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbhCJMEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 07:04:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231691AbhCJMEp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 07:04:45 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94716C061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:04:45 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id w9so27617402edc.11
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:04:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rYYV0DV/HZe1x6KQOm6y5XhVWh1furGAHhlPiSskupM=;
        b=RsbLgvoMtw6kJA/ChEvHucRK770EJIVxjLgWLIoPjwd4JTFPU0uaopyARGvx/MRswC
         nUv+oNn6rwD+sanEsmgjHbf1kJadCRDjDZz3yA2A6Ar5NSSrfmRUsuTa8fVo+mtthB/3
         c47OgLyo5edk0/suSm4ubTtLVSsCT3Rj+349GitclmlVw3NfVu46sY6wU5CSdr0m0zOc
         fqf0NqWENMnEwksUr26exNcEwECL1Bv3UVpRgUzsPmnVBluU8FA1ercL5l597VPt/Y+l
         WwbQEBkfU+7MGTdfPe7rm22iH5La0NmLGgI7eL6CWmnDajEmksup/1O4WPsa+ZRKGPL6
         F0tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rYYV0DV/HZe1x6KQOm6y5XhVWh1furGAHhlPiSskupM=;
        b=oMcUMyTFsI4k8TtwxhQ5sDW0b7jA2T5fiW5IeRzzU7Jp4wEGXUdhiNg8B2nh+xDVFQ
         IEOy8qq7WotiVNqtGSaElP5P6t4/WR10ctG2ypv4+jsAHPAgpV25PlNsUlc/4aygXeB7
         RnM6Tf8sX5nUhmX5aCropgxTRl+AbmcB3jv8jxRsVQ5w0ozAhngpehEoiFcXulgkjH18
         FvLbTq703qYUQfe8xfJPNz76uLOtUdJc9yRufDvpbvw3GwpG1y5MGapIZagxm7fr/m2+
         lB6r+YS/WJSZqPNRG4UrW8gaTREBo7aXNNuS7+CqSwF+cuHbUdEJcLh8UqiJfKW11CYP
         J1HA==
X-Gm-Message-State: AOAM532s/T/t+5qEd8BAG8TYbvnhcSuLajnzDWl+f9GM+the6pQECHUY
        pWp00sO/z4wKdL+4CK1h/oc=
X-Google-Smtp-Source: ABdhPJzwrXdg3iMi5wUTrqdxgUkB66pwzmvNHD9cO13CVSLNoWm/aI10SN87CHE3is9TQ55U1LWKCg==
X-Received: by 2002:a05:6402:b41:: with SMTP id bx1mr2895460edb.69.1615377884292;
        Wed, 10 Mar 2021 04:04:44 -0800 (PST)
Received: from localhost.localdomain ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id q20sm9913239ejs.41.2021.03.10.04.04.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 04:04:44 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
X-Google-Original-From: Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH net-next 03/12] net: enetc: squash enetc_alloc_cbdr and enetc_setup_cbdr
Date:   Wed, 10 Mar 2021 14:03:42 +0200
Message-Id: <20210310120351.542292-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210310120351.542292-1-vladimir.oltean@nxp.com>
References: <20210310120351.542292-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

enetc_alloc_cbdr and enetc_setup_cbdr are always called one after
another, so we can simplify the callers and make enetc_setup_cbdr do
everything that's needed.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c  |  4 +--
 drivers/net/ethernet/freescale/enetc/enetc.h  |  4 +--
 .../net/ethernet/freescale/enetc/enetc_cbdr.c | 30 +++++++++----------
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  4 +--
 4 files changed, 18 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index ceecee42f0f1..57073c3c679e 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1064,12 +1064,10 @@ int enetc_alloc_si_resources(struct enetc_ndev_priv *priv)
 	struct enetc_si *si = priv->si;
 	int err;
 
-	err = enetc_alloc_cbdr(priv->dev, &si->cbd_ring);
+	err = enetc_setup_cbdr(priv->dev, &si->hw, &si->cbd_ring);
 	if (err)
 		return err;
 
-	enetc_setup_cbdr(&si->hw, &si->cbd_ring);
-
 	priv->cls_rules = kcalloc(si->num_fs_entries, sizeof(*priv->cls_rules),
 				  GFP_KERNEL);
 	if (!priv->cls_rules) {
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index b343d1002bb7..1f2e9bec1b30 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -311,9 +311,9 @@ int enetc_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 void enetc_set_ethtool_ops(struct net_device *ndev);
 
 /* control buffer descriptor ring (CBDR) */
-int enetc_alloc_cbdr(struct device *dev, struct enetc_cbdr *cbdr);
+int enetc_setup_cbdr(struct device *dev, struct enetc_hw *hw,
+		     struct enetc_cbdr *cbdr);
 void enetc_free_cbdr(struct enetc_cbdr *cbdr);
-void enetc_setup_cbdr(struct enetc_hw *hw, struct enetc_cbdr *cbdr);
 void enetc_clear_cbdr(struct enetc_hw *hw);
 int enetc_set_mac_flt_entry(struct enetc_si *si, int index,
 			    char *mac_addr, int si_map);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c b/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c
index 7e84eb665ecd..4de31b283319 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c
@@ -3,7 +3,8 @@
 
 #include "enetc.h"
 
-int enetc_alloc_cbdr(struct device *dev, struct enetc_cbdr *cbdr)
+int enetc_setup_cbdr(struct device *dev, struct enetc_hw *hw,
+		     struct enetc_cbdr *cbdr)
 {
 	int size = cbdr->bd_count * sizeof(struct enetc_cbd);
 
@@ -23,21 +24,6 @@ int enetc_alloc_cbdr(struct device *dev, struct enetc_cbdr *cbdr)
 	cbdr->next_to_use = 0;
 	cbdr->dma_dev = dev;
 
-	return 0;
-}
-
-void enetc_free_cbdr(struct enetc_cbdr *cbdr)
-{
-	int size = cbdr->bd_count * sizeof(struct enetc_cbd);
-
-	dma_free_coherent(cbdr->dma_dev, size, cbdr->bd_base,
-			  cbdr->bd_dma_base);
-	cbdr->bd_base = NULL;
-	cbdr->dma_dev = NULL;
-}
-
-void enetc_setup_cbdr(struct enetc_hw *hw, struct enetc_cbdr *cbdr)
-{
 	/* set CBDR cache attributes */
 	enetc_wr(hw, ENETC_SICAR2,
 		 ENETC_SICAR_RD_COHERENT | ENETC_SICAR_WR_COHERENT);
@@ -54,6 +40,18 @@ void enetc_setup_cbdr(struct enetc_hw *hw, struct enetc_cbdr *cbdr)
 
 	cbdr->pir = hw->reg + ENETC_SICBDRPIR;
 	cbdr->cir = hw->reg + ENETC_SICBDRCIR;
+
+	return 0;
+}
+
+void enetc_free_cbdr(struct enetc_cbdr *cbdr)
+{
+	int size = cbdr->bd_count * sizeof(struct enetc_cbd);
+
+	dma_free_coherent(cbdr->dma_dev, size, cbdr->bd_base,
+			  cbdr->bd_dma_base);
+	cbdr->bd_base = NULL;
+	cbdr->dma_dev = NULL;
 }
 
 void enetc_clear_cbdr(struct enetc_hw *hw)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index a7195ec736f3..31d229e0912a 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -1088,12 +1088,10 @@ static void enetc_init_unused_port(struct enetc_si *si)
 	int err;
 
 	si->cbd_ring.bd_count = ENETC_CBDR_DEFAULT_SIZE;
-	err = enetc_alloc_cbdr(dev, &si->cbd_ring);
+	err = enetc_setup_cbdr(dev, hw, &si->cbd_ring);
 	if (err)
 		return;
 
-	enetc_setup_cbdr(hw, &si->cbd_ring);
-
 	enetc_init_port_rfs_memory(si);
 	enetc_init_port_rss_memory(si);
 
-- 
2.25.1

