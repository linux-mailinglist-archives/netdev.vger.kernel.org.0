Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 641DC78954
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 12:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbfG2KLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 06:11:32 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34068 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728239AbfG2KL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 06:11:27 -0400
Received: by mail-pf1-f196.google.com with SMTP id b13so27780210pfo.1
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 03:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JZUDFKBZk1ElIRUARbRJmGdg5KE4BPrFvpxixPa+YT4=;
        b=chLoSPhFGMC9AwFNwqqJUOaVj+4tcbo4rM9ycEXLzvGIl2dojjR+rZTdb52t10v3F1
         aNzBrS0E+fKOOYVOTUmvHd73ci7j+dq5BW/j7MuCgbs0LIwbGgTpRdN5lwILBp/N+Zgx
         1hgegT5Nn6Ydnv5wpnOGF+GL9vXMVONUAbbyI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JZUDFKBZk1ElIRUARbRJmGdg5KE4BPrFvpxixPa+YT4=;
        b=SFEQ6Il6EQIGjg25J0fUG6mbNvPS91DaEL+w3UlQp7laY/142Ac6OEhLAe7Dj4wpAs
         TiodUc/VYbG2zNd8hkJe8O3w37JHl9kpqfek3P7r23CEhDP6HR/z1S8dgj/rBVlcVTFG
         9hq9UvltBqvBMZ2HEbscvDkSDQbYP/FWAJEsfSmyHdIbuYE6m6wcSxmUFl3HeJYD8Sqs
         9PUsi6n/Dwr7Az4QNliW1Y4dVruW4OXKqE4N+b+lUyy+Xhw643Kovie2xNAiWyrdWFAj
         nPp3YfJ7lyBGgj5VryrP4wIlXTprLjbM9yl5lm/LC4NFHjErMA/ek3RR/zEWbFlJyXfF
         BlRw==
X-Gm-Message-State: APjAAAVbqQu+rpeX7mri+u5bPBJoXmKMpQjiBGu+bq07EIOGISr4hUH0
        j16rCx5nBc60h5LKX9PFyhaq0A==
X-Google-Smtp-Source: APXvYqzNDbTuYp9IdwinVDlegn8EC/D47VA7xrAtUKTJrslc5naGaRpJdug3ROHEm4H1z3dBN2uKPA==
X-Received: by 2002:a63:f13:: with SMTP id e19mr103210114pgl.132.1564395086427;
        Mon, 29 Jul 2019 03:11:26 -0700 (PDT)
Received: from localhost.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e124sm99045812pfh.181.2019.07.29.03.11.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 03:11:25 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 14/16] bnxt_en: Refactor bnxt_init_one() and turn on TPA support on 57500 chips.
Date:   Mon, 29 Jul 2019 06:10:31 -0400
Message-Id: <1564395033-19511-15-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564395033-19511-1-git-send-email-michael.chan@broadcom.com>
References: <1564395033-19511-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the new TPA feature in the 57500 chips, we need to discover the
feature first before setting up the netdev features.  Refactor the
the firmware probe and init logic more cleanly into 2 functions and
and make these calls before setting up the netdev features.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 116 +++++++++++++++++-------------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |   4 +-
 2 files changed, 67 insertions(+), 53 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 38ac007..9fe81fa 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9896,6 +9896,68 @@ static void bnxt_init_dflt_coal(struct bnxt *bp)
 	bp->stats_coal_ticks = BNXT_DEF_STATS_COAL_TICKS;
 }
 
+static int bnxt_fw_init_one_p1(struct bnxt *bp)
+{
+	int rc;
+
+	bp->fw_cap = 0;
+	rc = bnxt_hwrm_ver_get(bp);
+	if (rc)
+		return rc;
+
+	if (bp->fw_cap & BNXT_FW_CAP_KONG_MB_CHNL) {
+		rc = bnxt_alloc_kong_hwrm_resources(bp);
+		if (rc)
+			bp->fw_cap &= ~BNXT_FW_CAP_KONG_MB_CHNL;
+	}
+
+	if ((bp->fw_cap & BNXT_FW_CAP_SHORT_CMD) ||
+	    bp->hwrm_max_ext_req_len > BNXT_HWRM_MAX_REQ_LEN) {
+		rc = bnxt_alloc_hwrm_short_cmd_req(bp);
+		if (rc)
+			return rc;
+	}
+	rc = bnxt_hwrm_func_reset(bp);
+	if (rc)
+		return -ENODEV;
+
+	bnxt_hwrm_fw_set_time(bp);
+	return 0;
+}
+
+static int bnxt_fw_init_one_p2(struct bnxt *bp)
+{
+	int rc;
+
+	/* Get the MAX capabilities for this function */
+	rc = bnxt_hwrm_func_qcaps(bp);
+	if (rc) {
+		netdev_err(bp->dev, "hwrm query capability failure rc: %x\n",
+			   rc);
+		return -ENODEV;
+	}
+
+	rc = bnxt_hwrm_cfa_adv_flow_mgnt_qcaps(bp);
+	if (rc)
+		netdev_warn(bp->dev, "hwrm query adv flow mgnt failure rc: %d\n",
+			    rc);
+
+	rc = bnxt_hwrm_func_drv_rgtr(bp);
+	if (rc)
+		return -ENODEV;
+
+	rc = bnxt_hwrm_func_rgtr_async_events(bp, NULL, 0);
+	if (rc)
+		return -ENODEV;
+
+	bnxt_hwrm_func_qcfg(bp);
+	bnxt_hwrm_vnic_qcaps(bp);
+	bnxt_hwrm_port_led_qcaps(bp);
+	bnxt_ethtool_init(bp);
+	bnxt_dcb_init(bp);
+	return 0;
+}
+
 static int bnxt_init_board(struct pci_dev *pdev, struct net_device *dev)
 {
 	int rc;
@@ -10851,32 +10913,18 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto init_err_pci_clean;
 
 	mutex_init(&bp->hwrm_cmd_lock);
-	rc = bnxt_hwrm_ver_get(bp);
+
+	rc = bnxt_fw_init_one_p1(bp);
 	if (rc)
 		goto init_err_pci_clean;
 
-	if (bp->fw_cap & BNXT_FW_CAP_KONG_MB_CHNL) {
-		rc = bnxt_alloc_kong_hwrm_resources(bp);
-		if (rc)
-			bp->fw_cap &= ~BNXT_FW_CAP_KONG_MB_CHNL;
-	}
-
-	if ((bp->fw_cap & BNXT_FW_CAP_SHORT_CMD) ||
-	    bp->hwrm_max_ext_req_len > BNXT_HWRM_MAX_REQ_LEN) {
-		rc = bnxt_alloc_hwrm_short_cmd_req(bp);
-		if (rc)
-			goto init_err_pci_clean;
-	}
-
 	if (BNXT_CHIP_P5(bp))
 		bp->flags |= BNXT_FLAG_CHIP_P5;
 
-	rc = bnxt_hwrm_func_reset(bp);
+	rc = bnxt_fw_init_one_p2(bp);
 	if (rc)
 		goto init_err_pci_clean;
 
-	bnxt_hwrm_fw_set_time(bp);
-
 	dev->hw_features = NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | NETIF_F_SG |
 			   NETIF_F_TSO | NETIF_F_TSO6 |
 			   NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_GRE |
@@ -10920,37 +10968,8 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!BNXT_CHIP_P4_PLUS(bp))
 		bp->flags |= BNXT_FLAG_DOUBLE_DB;
 
-	rc = bnxt_hwrm_func_drv_rgtr(bp);
-	if (rc)
-		goto init_err_pci_clean;
-
-	rc = bnxt_hwrm_func_rgtr_async_events(bp, NULL, 0);
-	if (rc)
-		goto init_err_pci_clean;
-
 	bp->ulp_probe = bnxt_ulp_probe;
 
-	rc = bnxt_hwrm_queue_qportcfg(bp);
-	if (rc) {
-		netdev_err(bp->dev, "hwrm query qportcfg failure rc: %x\n",
-			   rc);
-		rc = -1;
-		goto init_err_pci_clean;
-	}
-	/* Get the MAX capabilities for this function */
-	rc = bnxt_hwrm_func_qcaps(bp);
-	if (rc) {
-		netdev_err(bp->dev, "hwrm query capability failure rc: %x\n",
-			   rc);
-		rc = -1;
-		goto init_err_pci_clean;
-	}
-
-	rc = bnxt_hwrm_cfa_adv_flow_mgnt_qcaps(bp);
-	if (rc)
-		netdev_warn(bp->dev, "hwrm query adv flow mgnt failure rc: %d\n",
-			    rc);
-
 	rc = bnxt_init_mac_addr(bp);
 	if (rc) {
 		dev_err(&pdev->dev, "Unable to initialize mac address.\n");
@@ -10964,11 +10983,6 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		if (rc)
 			goto init_err_pci_clean;
 	}
-	bnxt_hwrm_func_qcfg(bp);
-	bnxt_hwrm_vnic_qcaps(bp);
-	bnxt_hwrm_port_led_qcaps(bp);
-	bnxt_ethtool_init(bp);
-	bnxt_dcb_init(bp);
 
 	/* MTU range: 60 - FW defined max */
 	dev->min_mtu = ETH_ZLEN;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 6c710d7..c61af57 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1459,8 +1459,8 @@ struct bnxt {
 #define BNXT_CHIP_TYPE_NITRO_A0(bp) ((bp)->flags & BNXT_FLAG_CHIP_NITRO_A0)
 #define BNXT_RX_PAGE_MODE(bp)	((bp)->flags & BNXT_FLAG_RX_PAGE_MODE)
 #define BNXT_SUPPORTS_TPA(bp)	(!BNXT_CHIP_TYPE_NITRO_A0(bp) &&	\
-				 !(bp->flags & BNXT_FLAG_CHIP_P5) &&	\
-				 !is_kdump_kernel())
+				 (!((bp)->flags & BNXT_FLAG_CHIP_P5) ||	\
+				  (bp)->max_tpa_v2) && !is_kdump_kernel())
 
 /* Chip class phase 5 */
 #define BNXT_CHIP_P5(bp)			\
-- 
2.5.1

