Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA382327CFA
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 12:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbhCALSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 06:18:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232045AbhCALSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 06:18:52 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 982D1C061793
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 03:18:36 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id f6so4380523edd.12
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 03:18:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PNpEc5UnQICrqSCHItm3V5PWvmtOlQcEydqMRVoKzEI=;
        b=uTmZq7DVx3QsURIF1zwTJ7lR+pOLuRYOKGM3nehO9xSt+asD3tbNZIodZ8GdVohv38
         Cl99Fe1ndffgM6GUO6a+JVNUD+hlYciDsalneaG3g8XuTcxJi30k5mqd28sdoRjHVmCH
         IX67uC89fELmGPr9zzHwsfiK33d3GdRYap044Kj102vkEctNdZviFeU/RZYFwMsCWlCy
         I/ySuwF8JEH4gfKW5iBU68w2DdxXnTdEptNAzVmFPqXvaMH846v+s0sJBDgjlYSdjM+o
         Ps5lZqu+lRkhwfSH3ZEmQH2RbEV9WLozHpSIdquk40+JJjXtVNSKxnMN2ii1pJWLTqO+
         o17g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PNpEc5UnQICrqSCHItm3V5PWvmtOlQcEydqMRVoKzEI=;
        b=p2yTATEe/Q2V1C3lFlX7092YRIns6cHM/9RvrLbglbimmmd9uH7vs3yPr2Lpqp5/sc
         NMVi7YiimIRZkRACW9KdOVPXO7aXiJi4TsTm/12Dp3UI74fj6I+6ieY3KCrGbGfpcDvs
         YoV7sKnvkKvGLAd5RKRtD2/HwPxR1ne3t5iF0hUR0dlElEMVmlylbkG9lwOMkR5HqLgC
         huXRq5tSyyOYSzes7KjNJ/W7FjNMS62yhRHLrfbR+j/g/09LbcfxVg7tfC2u00ZWGe/Q
         /ki95UK4ZiL8p8gQj8aLItRyjAyAzVA1eMiogj0PJdvucTCEdtdnyO7xRQgP+CJB1sf4
         dYxw==
X-Gm-Message-State: AOAM531/NmIZM1sZbaxC9t4GlZO+gWgz4G8wblzR5OmJpClq7uWP8eJY
        Q6ugSJIPKM1z1fBvk9bS740=
X-Google-Smtp-Source: ABdhPJxbkFTua5ZRkUTQWMViFVcJbWF2UBE+Mi/gQWmf0eBKkplrifzWKltUwgyhDlqtBM1AjThLaA==
X-Received: by 2002:a05:6402:1455:: with SMTP id d21mr15467465edx.192.1614597515262;
        Mon, 01 Mar 2021 03:18:35 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id i13sm13586491ejj.2.2021.03.01.03.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 03:18:34 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH v3 net 1/8] net: enetc: don't overwrite the RSS indirection table when initializing
Date:   Mon,  1 Mar 2021 13:18:11 +0200
Message-Id: <20210301111818.2081582-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210301111818.2081582-1-olteanv@gmail.com>
References: <20210301111818.2081582-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

After the blamed patch, all RX traffic gets hashed to CPU 0 because the
hashing indirection table set up in:

enetc_pf_probe
-> enetc_alloc_si_resources
   -> enetc_configure_si
      -> enetc_setup_default_rss_table

is overwritten later in:

enetc_pf_probe
-> enetc_init_port_rss_memory

which zero-initializes the entire port RSS table in order to avoid ECC errors.

The trouble really is that enetc_init_port_rss_memory really neads
enetc_alloc_si_resources to be called, because it depends upon
enetc_alloc_cbdr and enetc_setup_cbdr. But that whole enetc_configure_si
thing could have been better thought out, it has nothing to do in a
function called "alloc_si_resources", especially since its counterpart,
"free_si_resources", does nothing to unwind the configuration of the SI.

The point is, we need to pull out enetc_configure_si out of
enetc_alloc_resources, and move it after enetc_init_port_rss_memory.
This allows us to set up the default RSS indirection table after
initializing the memory.

Fixes: 07bf34a50e32 ("net: enetc: initialize the RFS and RSS memories")
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
None.

Changes in v2:
None.

 drivers/net/ethernet/freescale/enetc/enetc.c    | 11 +++--------
 drivers/net/ethernet/freescale/enetc/enetc.h    |  1 +
 drivers/net/ethernet/freescale/enetc/enetc_pf.c |  7 +++++++
 drivers/net/ethernet/freescale/enetc/enetc_vf.c |  7 +++++++
 4 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index c78d12229730..fdb6b9e8da78 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1058,13 +1058,12 @@ static int enetc_setup_default_rss_table(struct enetc_si *si, int num_groups)
 	return 0;
 }
 
-static int enetc_configure_si(struct enetc_ndev_priv *priv)
+int enetc_configure_si(struct enetc_ndev_priv *priv)
 {
 	struct enetc_si *si = priv->si;
 	struct enetc_hw *hw = &si->hw;
 	int err;
 
-	enetc_setup_cbdr(hw, &si->cbd_ring);
 	/* set SI cache attributes */
 	enetc_wr(hw, ENETC_SICAR0,
 		 ENETC_SICAR_RD_COHERENT | ENETC_SICAR_WR_COHERENT);
@@ -1112,6 +1111,8 @@ int enetc_alloc_si_resources(struct enetc_ndev_priv *priv)
 	if (err)
 		return err;
 
+	enetc_setup_cbdr(&si->hw, &si->cbd_ring);
+
 	priv->cls_rules = kcalloc(si->num_fs_entries, sizeof(*priv->cls_rules),
 				  GFP_KERNEL);
 	if (!priv->cls_rules) {
@@ -1119,14 +1120,8 @@ int enetc_alloc_si_resources(struct enetc_ndev_priv *priv)
 		goto err_alloc_cls;
 	}
 
-	err = enetc_configure_si(priv);
-	if (err)
-		goto err_config_si;
-
 	return 0;
 
-err_config_si:
-	kfree(priv->cls_rules);
 err_alloc_cls:
 	enetc_clear_cbdr(&si->hw);
 	enetc_free_cbdr(priv->dev, &si->cbd_ring);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 8532d23b54f5..f8275cef3b5c 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -292,6 +292,7 @@ void enetc_get_si_caps(struct enetc_si *si);
 void enetc_init_si_rings_params(struct enetc_ndev_priv *priv);
 int enetc_alloc_si_resources(struct enetc_ndev_priv *priv);
 void enetc_free_si_resources(struct enetc_ndev_priv *priv);
+int enetc_configure_si(struct enetc_ndev_priv *priv);
 
 int enetc_open(struct net_device *ndev);
 int enetc_close(struct net_device *ndev);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 515c5b29d7aa..d02ecb2e46ae 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -1108,6 +1108,12 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 		goto err_init_port_rss;
 	}
 
+	err = enetc_configure_si(priv);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to configure SI\n");
+		goto err_config_si;
+	}
+
 	err = enetc_alloc_msix(priv);
 	if (err) {
 		dev_err(&pdev->dev, "MSIX alloc failed\n");
@@ -1136,6 +1142,7 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 	enetc_mdiobus_destroy(pf);
 err_mdiobus_create:
 	enetc_free_msix(priv);
+err_config_si:
 err_init_port_rss:
 err_init_port_rfs:
 err_alloc_msix:
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_vf.c b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
index 39c1a09e69a9..9b755a84c2d6 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_vf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
@@ -171,6 +171,12 @@ static int enetc_vf_probe(struct pci_dev *pdev,
 		goto err_alloc_si_res;
 	}
 
+	err = enetc_configure_si(priv);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to configure SI\n");
+		goto err_config_si;
+	}
+
 	err = enetc_alloc_msix(priv);
 	if (err) {
 		dev_err(&pdev->dev, "MSIX alloc failed\n");
@@ -187,6 +193,7 @@ static int enetc_vf_probe(struct pci_dev *pdev,
 
 err_reg_netdev:
 	enetc_free_msix(priv);
+err_config_si:
 err_alloc_msix:
 	enetc_free_si_resources(priv);
 err_alloc_si_res:
-- 
2.25.1

