Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D17C6327CFE
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 12:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbhCALTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 06:19:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232124AbhCALTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 06:19:17 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C09CC061756
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 03:18:37 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id h10so20095079edl.6
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 03:18:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n/3TB3LAlq1rQiWc+V07/zAlcw6bhT/udy9/FkJs4Vc=;
        b=SxzwiOqJaw6PNXUcSXlCvW2HiHkHpkVaBla4SmmPTIjjH305AWFHpV4udG86ezea00
         nZVwR+DUBN8H6huQQ7o9MOAqE4t6k0qriqtXpHENJvLRteEZ4yQJP9sLnsufJ/DIOsMR
         4nGVBfPl/KNewa/InIt6bBZgVmyGMZ5WK46HKLZAlIPmOS+Nmlu7dr2CEeUC3oUt1gZ1
         +RKn9Wz//ZQBRow905OhBTI2RqHtUhfUAym6b9K2n5RtVARHgU5YCJXK6FOwzyCtHnMD
         5SeDJn/E4eVyeIOXar32NH9ZMhK9E1G+VETj89V40Ool0Hwm3azbrDRKQrMnmSoo0ErF
         NlyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n/3TB3LAlq1rQiWc+V07/zAlcw6bhT/udy9/FkJs4Vc=;
        b=IS7SIm9L7BF5U2EMd81fwgBGkTvSAzps33VozByDfGODGWjKljRVtjIlBtqxa81ZdF
         NAo8AGPMtllzREe7Et9PDVhrQc68ajLN+1SKQYgDDjwMFMqRRGIrBN2DIDbC1j+GQtvx
         foIGAbemKZc4JIQonT184F7h1oKWcptJVrbhIEZVKSgGffS4NvXhSbYLGzBZQW8ibyQ8
         AAbSHP7FUDfogG3KjIEoB4/+lcYejWyQXi4qy6P3Z99Xb8wiL5pLY/x3qeXtPYO22SDv
         6izD5uqIPxHZOjh0ldAE92jxCBc0f11p2JtQYnQ7pj0GpJxv7VuXEeMw0HUGKSFofRZh
         P4JA==
X-Gm-Message-State: AOAM532Yu//oVAEpiTY/rs40aQp2W6HILcY4jx4jYp6ZJ5rrzCBQGHuy
        7JSOCO5YzXHSvalpC4ZBrt8qZ0uwkak=
X-Google-Smtp-Source: ABdhPJwFYVPJJSb0qB+N1NcKJWTtRsBW7AD9O5wRUCU5u13vs58wIUynSe8MdhiKfwgNEmBerbBSGQ==
X-Received: by 2002:aa7:cb8e:: with SMTP id r14mr15911396edt.331.1614597516284;
        Mon, 01 Mar 2021 03:18:36 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id i13sm13586491ejj.2.2021.03.01.03.18.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 03:18:35 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH v3 net 2/8] net: enetc: initialize RFS/RSS memories for unused ports too
Date:   Mon,  1 Mar 2021 13:18:12 +0200
Message-Id: <20210301111818.2081582-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210301111818.2081582-1-olteanv@gmail.com>
References: <20210301111818.2081582-1-olteanv@gmail.com>
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

Fixes: 07bf34a50e32 ("net: enetc: initialize the RFS and RSS memories")
Reported-by: Michael Walle <michael@walle.cc>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Michael Walle <michael@walle.cc>
---
Changes in v3:
Leave the moving around of cbdr functions to a later refactoring patch,
and keep the bug fix minimal.

Changes in v2:
None.

 drivers/net/ethernet/freescale/enetc/enetc.c  |  8 ++---
 drivers/net/ethernet/freescale/enetc/enetc.h  |  4 +++
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 33 ++++++++++++++++---
 3 files changed, 36 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index fdb6b9e8da78..eb45830a1667 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -984,7 +984,7 @@ static void enetc_free_rxtx_rings(struct enetc_ndev_priv *priv)
 		enetc_free_tx_ring(priv->tx_ring[i]);
 }
 
-static int enetc_alloc_cbdr(struct device *dev, struct enetc_cbdr *cbdr)
+int enetc_alloc_cbdr(struct device *dev, struct enetc_cbdr *cbdr)
 {
 	int size = cbdr->bd_count * sizeof(struct enetc_cbd);
 
@@ -1005,7 +1005,7 @@ static int enetc_alloc_cbdr(struct device *dev, struct enetc_cbdr *cbdr)
 	return 0;
 }
 
-static void enetc_free_cbdr(struct device *dev, struct enetc_cbdr *cbdr)
+void enetc_free_cbdr(struct device *dev, struct enetc_cbdr *cbdr)
 {
 	int size = cbdr->bd_count * sizeof(struct enetc_cbd);
 
@@ -1013,7 +1013,7 @@ static void enetc_free_cbdr(struct device *dev, struct enetc_cbdr *cbdr)
 	cbdr->bd_base = NULL;
 }
 
-static void enetc_setup_cbdr(struct enetc_hw *hw, struct enetc_cbdr *cbdr)
+void enetc_setup_cbdr(struct enetc_hw *hw, struct enetc_cbdr *cbdr)
 {
 	/* set CBDR cache attributes */
 	enetc_wr(hw, ENETC_SICAR2,
@@ -1033,7 +1033,7 @@ static void enetc_setup_cbdr(struct enetc_hw *hw, struct enetc_cbdr *cbdr)
 	cbdr->cir = hw->reg + ENETC_SICBDRCIR;
 }
 
-static void enetc_clear_cbdr(struct enetc_hw *hw)
+void enetc_clear_cbdr(struct enetc_hw *hw)
 {
 	enetc_wr(hw, ENETC_SICBDRMR, 0);
 }
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

