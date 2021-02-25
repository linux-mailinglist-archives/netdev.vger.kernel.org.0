Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83B07324FCE
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 13:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbhBYMTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 07:19:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbhBYMTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 07:19:38 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A6CC061756
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 04:18:57 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id lr13so8499739ejb.8
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 04:18:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4IB483OU7lPn3et2xrh4PpCHRm/DZxM85vDyWmdxYkw=;
        b=KUdNfwPffyKr7XR8/uTLbB+LrRIMF9wva615eIRytipSV3JCYFfqOZpTbpCoElWrfv
         SRDj2qV96xjz4OFnniXn0GcoqvwyaqmIAEgjUYwyoMbBTd2VQwVMQtzzTyM6WBPsQXnI
         sYzbpmefZoVJ0zgAQi0qBWEcjD0gO55XlvRWOvnamR92fAzpsGlF3N5/jQssbr6OYl6l
         m3LzbzfO3yEkpkicLy6g9j6w7iEEg98J/nM92MBa23jUK0siFDWDNdjsPdr4E4fPDLLv
         gZe5Gq7seuq9Rk5odRUDItamFKOEWPPfO8LIKHUdrblNH9wvuLEira6WI+wLx8BYz5Z3
         KJhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4IB483OU7lPn3et2xrh4PpCHRm/DZxM85vDyWmdxYkw=;
        b=UYyI15Aijz8Kxpold6uah+icHhWiDgHc0hLPGCAXOFFsZBGwxlgTvFyuaN1wepxR+t
         DXPSv4n/5wVEwvaX9SPCQ3kBVp1orIHYdGzeLFMX/m1NaApav3bwwPJc6k2lKAzUCELt
         //Q+o8i4rZf0yGfOGggGVEBNVtSD0wkARQ+7TcXZloeo0U4Iy5C3mm9SFUmXjLqLbVke
         DXRfxhEwj+dD5xE9OPTNOOR1k9SE18bcJl9ug8E6+OSfqARnfwN0sMGpRbP056XLS25K
         Z6vyn0QMU10OyXx04qvhGU4MJXt7X5hnB+ZCGkwUda3ljGgs6mX7FZMfNXqn3nxmmmDB
         wjMw==
X-Gm-Message-State: AOAM5321e6rhTHyDlfcGRE6oq4MggQlrNnD3xNbjIetvtLNwGm5xQRX1
        7d+O/IRVp1Nbu3JulbNhVbrJJ0X04c0=
X-Google-Smtp-Source: ABdhPJxss3dRBCNnN9U/tG4w9Q0PWV3HvCu9M0K9zoYmAHEsIZthW1VT5qvApuUM+MPHNcnLiU0vjA==
X-Received: by 2002:a17:906:46d9:: with SMTP id k25mr2399106ejs.387.1614255536666;
        Thu, 25 Feb 2021 04:18:56 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id x25sm3420925edv.65.2021.02.25.04.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 04:18:56 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH v2 net 2/6] net: enetc: initialize RFS/RSS memories for unused ports too
Date:   Thu, 25 Feb 2021 14:18:31 +0200
Message-Id: <20210225121835.3864036-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210225121835.3864036-1-olteanv@gmail.com>
References: <20210225121835.3864036-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Michael reports that since linux-next-20210211, the AER messages for ECC
errors have started reappearing, and this time they can be reliably
reproduced with the first ping on one of his LS1028A boards.

$ ping 1[   33.258069] pcieport 0000:00:1f.0: AER: Multiple Corrected error received: 0000:00:00.0
72.16.0.1
PING [   33.267050] pcieport 0000:00:1f.0: AER: can't find device of ID0000
172.16.0.1 (172.16.0.1): 56 data bytes
64 bytes from 172.16.0.1: seq=0 ttl=64 time=17.124 ms
64 bytes from 172.16.0.1: seq=1 ttl=64 time=0.273 ms

$ devmem 0x1f8010e10 32
0xC0000006

It isn't clear why this is necessary, but it seems that for the errors
to go away, we must clear the entire RFS and RSS memory, not just for
the ports in use.

Sadly the code is structured in such a way that we can't have unified
logic for the used and unused ports. For the minimal initialization of
an unused port, we need just to enable and ioremap the PF memory space,
and a control buffer descriptor ring. Unused ports must then free the
CBDR because the driver will exit, but used ports can not pick up from
where that code path left, since the CBDR API does not reinitialize a
ring when setting it up, so its producer and consumer indices are out of
sync between the software and hardware state. So a separate
enetc_init_unused_port function was created, and it gets called right
after the PF memory space is enabled.

Note that we need access from enetc_pf.c to the CBDR creation and
deletion methods, which were for some reason put in enetc.c. While
changing their definitions to be non-static, also move them to
enetc_cbdr.c which seems like a better place to hold these.

Fixes: 07bf34a50e32 ("net: enetc: initialize the RFS and RSS memories")
Reported-by: Michael Walle <michael@walle.cc>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

 drivers/net/ethernet/freescale/enetc/enetc.c  | 54 -------------------
 drivers/net/ethernet/freescale/enetc/enetc.h  |  4 ++
 .../net/ethernet/freescale/enetc/enetc_cbdr.c | 54 +++++++++++++++++++
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 33 ++++++++++--
 4 files changed, 86 insertions(+), 59 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index fdb6b9e8da78..43f0fae30080 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -984,60 +984,6 @@ static void enetc_free_rxtx_rings(struct enetc_ndev_priv *priv)
 		enetc_free_tx_ring(priv->tx_ring[i]);
 }
 
-static int enetc_alloc_cbdr(struct device *dev, struct enetc_cbdr *cbdr)
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
-static void enetc_free_cbdr(struct device *dev, struct enetc_cbdr *cbdr)
-{
-	int size = cbdr->bd_count * sizeof(struct enetc_cbd);
-
-	dma_free_coherent(dev, size, cbdr->bd_base, cbdr->bd_dma_base);
-	cbdr->bd_base = NULL;
-}
-
-static void enetc_setup_cbdr(struct enetc_hw *hw, struct enetc_cbdr *cbdr)
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
-static void enetc_clear_cbdr(struct enetc_hw *hw)
-{
-	enetc_wr(hw, ENETC_SICBDRMR, 0);
-}
-
 static int enetc_setup_default_rss_table(struct enetc_si *si, int num_groups)
 {
 	int *rss_table;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index f8275cef3b5c..8b380fc13314 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -310,6 +310,10 @@ int enetc_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 void enetc_set_ethtool_ops(struct net_device *ndev);
 
 /* control buffer descriptor ring (CBDR) */
+int enetc_alloc_cbdr(struct device *dev, struct enetc_cbdr *cbdr);
+void enetc_free_cbdr(struct device *dev, struct enetc_cbdr *cbdr);
+void enetc_setup_cbdr(struct enetc_hw *hw, struct enetc_cbdr *cbdr);
+void enetc_clear_cbdr(struct enetc_hw *hw);
 int enetc_set_mac_flt_entry(struct enetc_si *si, int index,
 			    char *mac_addr, int si_map);
 int enetc_clear_mac_flt_entry(struct enetc_si *si, int index);
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
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index d02ecb2e46ae..62ba4bf56f0d 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -1041,6 +1041,26 @@ static int enetc_init_port_rss_memory(struct enetc_si *si)
 	return err;
 }
 
+static void enetc_init_unused_port(struct enetc_si *si)
+{
+	struct device *dev = &si->pdev->dev;
+	struct enetc_hw *hw = &si->hw;
+	int err;
+
+	si->cbd_ring.bd_count = ENETC_CBDR_DEFAULT_SIZE;
+	err = enetc_alloc_cbdr(dev, &si->cbd_ring);
+	if (err)
+		return;
+
+	enetc_setup_cbdr(hw, &si->cbd_ring);
+
+	enetc_init_port_rfs_memory(si);
+	enetc_init_port_rss_memory(si);
+
+	enetc_clear_cbdr(hw);
+	enetc_free_cbdr(dev, &si->cbd_ring);
+}
+
 static int enetc_pf_probe(struct pci_dev *pdev,
 			  const struct pci_device_id *ent)
 {
@@ -1051,11 +1071,6 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 	struct enetc_pf *pf;
 	int err;
 
-	if (node && !of_device_is_available(node)) {
-		dev_info(&pdev->dev, "device is disabled, skipping\n");
-		return -ENODEV;
-	}
-
 	err = enetc_pci_probe(pdev, KBUILD_MODNAME, sizeof(*pf));
 	if (err) {
 		dev_err(&pdev->dev, "PCI probing failed\n");
@@ -1069,6 +1084,13 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 		goto err_map_pf_space;
 	}
 
+	if (node && !of_device_is_available(node)) {
+		enetc_init_unused_port(si);
+		dev_info(&pdev->dev, "device is disabled, skipping\n");
+		err = -ENODEV;
+		goto err_device_disabled;
+	}
+
 	pf = enetc_si_priv(si);
 	pf->si = si;
 	pf->total_vfs = pci_sriov_get_totalvfs(pdev);
@@ -1151,6 +1173,7 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 	si->ndev = NULL;
 	free_netdev(ndev);
 err_alloc_netdev:
+err_device_disabled:
 err_map_pf_space:
 	enetc_pci_remove(pdev);
 
-- 
2.25.1

