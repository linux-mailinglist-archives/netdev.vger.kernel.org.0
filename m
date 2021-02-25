Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5DE324FCD
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 13:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbhBYMTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 07:19:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231974AbhBYMTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 07:19:37 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10FD0C06174A
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 04:18:57 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id w21so6562009edc.7
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 04:18:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W+hPE7Ylm3KoIWW0DVLEyykDeccmiqTm6edZALsG95k=;
        b=Mbg1JMA4tbmeKfK+8lER1XN72UQIi70PzPBLo3dGD2CIZs65w45uOu1Nr8SyEF6Aie
         Le2uSFGchgYJSMSDnHTVwVsgMnaWWU3KkudMCTu8sWCQDZm7sn+gRkvKP+gkxlOPMdUr
         mHAFPgkz48hGH5zxA7SQD6VX3ZQhzPC8C/aWb0+ZlBVH74WMC/postsC8lQl1tsvEhpP
         4OBKUZnfR6FAPDboWHPmCHvot7fINgPWFcMpIOfzQDyzecLsWN8L2pVzX5WMF3GAlQmR
         2kk1Wc3+NuhJQTYsLyCz7o7agmqmBmzD3kD8PdRh4ThXKZyYJ4YNclN9z+VPXuP249q8
         4lyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W+hPE7Ylm3KoIWW0DVLEyykDeccmiqTm6edZALsG95k=;
        b=rAuSwd++zF0r4GU+7QetUEZM/paJlVq5N7FY51+GSptouAxwYUGGpjGvIqf+Sg371I
         pUPhsDx3I9GtTH2LgxH1ADTIhnTB7tLzjEWgjEOcFhi7rS9OSVKsEmsN5l9gOMdgZnl7
         T5e8Nt+ZRMDdorzPscahDnjf3RL1LGMKe6Q0D/g8zpyNjH1SHLT25oHDCGikxOwQaIp+
         6ToXJhpNITsjuDFi86HUWBpeQWQ74skof99IufRaaAlYbDHgHVST/zK1NJ70/rtW1Ts+
         OyFTFMffFrLw53b5/QWBa/vbI3FpYvbeOGxFiYW8jg09dHu7zrM5jai5irJ8N/h3X5A6
         1pvg==
X-Gm-Message-State: AOAM531DpSO0NPXhA9H9GXyexd1nfEi8O4YcFd0PQYjOTMHP2472MAjN
        L20KIAC/jGc6kToNvQX6yrg=
X-Google-Smtp-Source: ABdhPJxmYoTawrxgCrNCHs7q29gvFW0VrBsr/nK83KY+cV88yZoVGpDopMlfodxGf76SzQBh4P2O1Q==
X-Received: by 2002:a05:6402:31b9:: with SMTP id dj25mr2553931edb.349.1614255535741;
        Thu, 25 Feb 2021 04:18:55 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id x25sm3420925edv.65.2021.02.25.04.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 04:18:55 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH v2 net 1/6] net: enetc: don't overwrite the RSS indirection table when initializing
Date:   Thu, 25 Feb 2021 14:18:30 +0200
Message-Id: <20210225121835.3864036-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210225121835.3864036-1-olteanv@gmail.com>
References: <20210225121835.3864036-1-olteanv@gmail.com>
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

