Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9628A2DAC
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 05:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbfH3Dzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 23:55:44 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40875 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727920AbfH3Dzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 23:55:39 -0400
Received: by mail-pf1-f195.google.com with SMTP id w16so3667102pfn.7
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 20:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=q8jNXXWIIiNEO7A1yZ4bQeV6pZiBT6BckUrndYvFQgc=;
        b=QLu42c+ya9qiqZD194u3OKCmMEbRMkBPbdoucMpX2yB/qRTgj3iqbkKsjKqxQU0gt9
         sBMkI5UuRgyK+gkCkzk+HUu2aZPVE1r/pomvcNubejMFxkny3hehTmz01PvoqsrviABF
         ZbKTpQJTH79XtzDxhMpwHRh2ibD/0onw1fEtc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=q8jNXXWIIiNEO7A1yZ4bQeV6pZiBT6BckUrndYvFQgc=;
        b=I6EEouxeTAy5hthRzsjlHc+2w/hMuEEf9N0iPkn14zEkEOVnKApGGREb7Ju2tvAIY9
         PIqdwt+op5mGZYTKhFsQZx7rgy0IyEHJHbktvzFoPdC++He5S6QhgmOy6WP1fsxVCrZy
         UM2jJcCg4IPu2iLhmXL0bvJY+muOICmunl133Etl8nTu73ljyjVWVUp3EVK/kuKrkDZw
         bk1mKFGI05gySeKV/dlxk+ahwpbw43ASdFlyb1RHnYHZMSWdbgE6LyfisPW8sdl7J7P5
         q0zf/zRS2hYt5wjtqPhXW9OVJ6Dn0nuR79hxcgpVkLUzcancAL1tmy5TrEfr3uq7zOKk
         TeKg==
X-Gm-Message-State: APjAAAWihAJa+OgIYKjAK5Gd476136Ib9QEH0bBOBZsErI/Ficd3Ysh8
        FUzVLTPS4Dj9kylsrtqJlLI5Cg==
X-Google-Smtp-Source: APXvYqwQNp+BKuUcw8ZSydBtAVznNSCYooduE59SFun4QTNnIpRuuyC7QHzneOQqSNmRIDsXCEE4AQ==
X-Received: by 2002:a62:80cb:: with SMTP id j194mr16150255pfd.183.1567137338093;
        Thu, 29 Aug 2019 20:55:38 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l3sm3658877pjq.24.2019.08.29.20.55.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 20:55:37 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        ray.jui@broadcom.com
Subject: [PATCH net-next v2 06/22] bnxt_en: Prepare bnxt_init_one() to be called multiple times.
Date:   Thu, 29 Aug 2019 23:54:49 -0400
Message-Id: <1567137305-5853-7-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
References: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for the new firmware reset feature, some of the logic
in bnxt_init_one() and related functions will be called again after
firmware has reset.  Reset some of the flags and capabilities so that
everything that can change can be re-initialized.  Refactor some
functions to probe firmware versions and capabilities.  Check some
buffers before allocating as they may have been allocated previously.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 126 +++++++++++++++-------
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c     |   2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |   5 +-
 3 files changed, 93 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 3e48bcb..696a548 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3555,6 +3555,9 @@ static int bnxt_alloc_kong_hwrm_resources(struct bnxt *bp)
 {
 	struct pci_dev *pdev = bp->pdev;
 
+	if (bp->hwrm_cmd_kong_resp_addr)
+		return 0;
+
 	bp->hwrm_cmd_kong_resp_addr =
 		dma_alloc_coherent(&pdev->dev, PAGE_SIZE,
 				   &bp->hwrm_cmd_kong_resp_dma_addr,
@@ -3594,6 +3597,9 @@ static int bnxt_alloc_hwrm_short_cmd_req(struct bnxt *bp)
 {
 	struct pci_dev *pdev = bp->pdev;
 
+	if (bp->hwrm_short_cmd_req_addr)
+		return 0;
+
 	bp->hwrm_short_cmd_req_addr =
 		dma_alloc_coherent(&pdev->dev, bp->hwrm_max_ext_req_len,
 				   &bp->hwrm_short_cmd_req_dma_addr,
@@ -5017,6 +5023,7 @@ static int bnxt_hwrm_vnic_qcaps(struct bnxt *bp)
 	int rc;
 
 	bp->hw_ring_stats_size = sizeof(struct ctx_hw_stats);
+	bp->flags &= ~(BNXT_FLAG_NEW_RSS_CAP | BNXT_FLAG_ROCE_MIRROR_CAP);
 	if (bp->hwrm_spec_code < 0x10600)
 		return 0;
 
@@ -6871,6 +6878,7 @@ static int __bnxt_hwrm_func_qcaps(struct bnxt *bp)
 		pf->max_tx_wm_flows = le32_to_cpu(resp->max_tx_wm_flows);
 		pf->max_rx_em_flows = le32_to_cpu(resp->max_rx_em_flows);
 		pf->max_rx_wm_flows = le32_to_cpu(resp->max_rx_wm_flows);
+		bp->flags &= ~BNXT_FLAG_WOL_CAP;
 		if (flags & FUNC_QCAPS_RESP_FLAGS_WOL_MAGICPKT_SUPPORTED)
 			bp->flags |= BNXT_FLAG_WOL_CAP;
 	} else {
@@ -6999,20 +7007,30 @@ static int bnxt_hwrm_queue_qportcfg(struct bnxt *bp)
 	return rc;
 }
 
-static int bnxt_hwrm_ver_get(struct bnxt *bp)
+static int __bnxt_hwrm_ver_get(struct bnxt *bp, bool silent)
 {
-	int rc;
 	struct hwrm_ver_get_input req = {0};
-	struct hwrm_ver_get_output *resp = bp->hwrm_cmd_resp_addr;
-	u32 dev_caps_cfg;
+	int rc;
 
-	bp->hwrm_max_req_len = HWRM_MAX_REQ_LEN;
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_VER_GET, -1, -1);
 	req.hwrm_intf_maj = HWRM_VERSION_MAJOR;
 	req.hwrm_intf_min = HWRM_VERSION_MINOR;
 	req.hwrm_intf_upd = HWRM_VERSION_UPDATE;
+
+	rc = bnxt_hwrm_do_send_msg(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT,
+				   silent);
+	return rc;
+}
+
+static int bnxt_hwrm_ver_get(struct bnxt *bp)
+{
+	struct hwrm_ver_get_output *resp = bp->hwrm_cmd_resp_addr;
+	u32 dev_caps_cfg;
+	int rc;
+
+	bp->hwrm_max_req_len = HWRM_MAX_REQ_LEN;
 	mutex_lock(&bp->hwrm_cmd_lock);
-	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	rc = __bnxt_hwrm_ver_get(bp, false);
 	if (rc)
 		goto hwrm_ver_get_exit;
 
@@ -8181,6 +8199,9 @@ static int bnxt_hwrm_phy_qcaps(struct bnxt *bp)
 	struct hwrm_port_phy_qcaps_output *resp = bp->hwrm_cmd_resp_addr;
 	struct bnxt_link_info *link_info = &bp->link_info;
 
+	bp->flags &= ~BNXT_FLAG_EEE_CAP;
+	if (bp->test_info)
+		bp->test_info->flags &= ~BNXT_TEST_FL_EXT_LPBK;
 	if (bp->hwrm_spec_code < 0x10201)
 		return 0;
 
@@ -8546,6 +8567,7 @@ static int bnxt_hwrm_port_led_qcaps(struct bnxt *bp)
 	struct bnxt_pf_info *pf = &bp->pf;
 	int rc;
 
+	bp->num_leds = 0;
 	if (BNXT_VF(bp) || bp->hwrm_spec_code < 0x10601)
 		return 0;
 
@@ -8640,6 +8662,7 @@ static void bnxt_get_wol_settings(struct bnxt *bp)
 {
 	u16 handle = 0;
 
+	bp->wol = 0;
 	if (!BNXT_PF(bp) || !(bp->flags & BNXT_FLAG_WOL_CAP))
 		return;
 
@@ -8686,6 +8709,9 @@ static void bnxt_hwmon_open(struct bnxt *bp)
 {
 	struct pci_dev *pdev = bp->pdev;
 
+	if (bp->hwmon_dev)
+		return;
+
 	bp->hwmon_dev = hwmon_device_register_with_groups(&pdev->dev,
 							  DRV_MODULE_NAME, bp,
 							  bnxt_groups);
@@ -10002,6 +10028,53 @@ static int bnxt_fw_init_one_p2(struct bnxt *bp)
 	return 0;
 }
 
+static void bnxt_set_dflt_rss_hash_type(struct bnxt *bp)
+{
+	bp->flags &= ~BNXT_FLAG_UDP_RSS_CAP;
+	bp->rss_hash_cfg = VNIC_RSS_CFG_REQ_HASH_TYPE_IPV4 |
+			   VNIC_RSS_CFG_REQ_HASH_TYPE_TCP_IPV4 |
+			   VNIC_RSS_CFG_REQ_HASH_TYPE_IPV6 |
+			   VNIC_RSS_CFG_REQ_HASH_TYPE_TCP_IPV6;
+	if (BNXT_CHIP_P4(bp) && bp->hwrm_spec_code >= 0x10501) {
+		bp->flags |= BNXT_FLAG_UDP_RSS_CAP;
+		bp->rss_hash_cfg |= VNIC_RSS_CFG_REQ_HASH_TYPE_UDP_IPV4 |
+				    VNIC_RSS_CFG_REQ_HASH_TYPE_UDP_IPV6;
+	}
+}
+
+static void bnxt_set_dflt_rfs(struct bnxt *bp)
+{
+	struct net_device *dev = bp->dev;
+
+	dev->hw_features &= ~NETIF_F_NTUPLE;
+	dev->features &= ~NETIF_F_NTUPLE;
+	bp->flags &= ~BNXT_FLAG_RFS;
+	if (bnxt_rfs_supported(bp)) {
+		dev->hw_features |= NETIF_F_NTUPLE;
+		if (bnxt_rfs_capable(bp)) {
+			bp->flags |= BNXT_FLAG_RFS;
+			dev->features |= NETIF_F_NTUPLE;
+		}
+	}
+}
+
+static void bnxt_fw_init_one_p3(struct bnxt *bp)
+{
+	struct pci_dev *pdev = bp->pdev;
+
+	bnxt_set_dflt_rss_hash_type(bp);
+	bnxt_set_dflt_rfs(bp);
+
+	bnxt_get_wol_settings(bp);
+	if (bp->flags & BNXT_FLAG_WOL_CAP)
+		device_set_wakeup_enable(&pdev->dev, bp->wol);
+	else
+		device_set_wakeup_capable(&pdev->dev, false);
+
+	bnxt_hwrm_set_cache_line_size(bp, cache_line_size());
+	bnxt_hwrm_coal_params_qcaps(bp);
+}
+
 static int bnxt_init_board(struct pci_dev *pdev, struct net_device *dev)
 {
 	int rc;
@@ -10607,7 +10680,7 @@ static void bnxt_remove_one(struct pci_dev *pdev)
 	free_netdev(dev);
 }
 
-static int bnxt_probe_phy(struct bnxt *bp)
+static int bnxt_probe_phy(struct bnxt *bp, bool fw_dflt)
 {
 	int rc = 0;
 	struct bnxt_link_info *link_info = &bp->link_info;
@@ -10618,8 +10691,6 @@ static int bnxt_probe_phy(struct bnxt *bp)
 			   rc);
 		return rc;
 	}
-	mutex_init(&bp->link_lock);
-
 	rc = bnxt_update_link(bp, false);
 	if (rc) {
 		netdev_err(bp->dev, "Probe phy can't update link (rc: %x)\n",
@@ -10633,6 +10704,9 @@ static int bnxt_probe_phy(struct bnxt *bp)
 	if (link_info->auto_link_speeds && !link_info->support_auto_speeds)
 		link_info->support_auto_speeds = link_info->support_speeds;
 
+	if (!fw_dflt)
+		return 0;
+
 	/*initialize the ethool setting copy with NVM settings */
 	if (BNXT_AUTO_MODE(link_info->auto_mode)) {
 		link_info->autoneg = BNXT_AUTONEG_SPEED;
@@ -10653,7 +10727,7 @@ static int bnxt_probe_phy(struct bnxt *bp)
 			link_info->auto_pause_setting & BNXT_LINK_PAUSE_BOTH;
 	else
 		link_info->req_flow_ctrl = link_info->force_pause_setting;
-	return rc;
+	return 0;
 }
 
 static int bnxt_get_max_irq(struct pci_dev *pdev)
@@ -10957,6 +11031,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto init_err_pci_clean;
 
 	mutex_init(&bp->hwrm_cmd_lock);
+	mutex_init(&bp->link_lock);
 
 	rc = bnxt_fw_init_one_p1(bp);
 	if (rc)
@@ -11032,7 +11107,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->min_mtu = ETH_ZLEN;
 	dev->max_mtu = bp->max_mtu;
 
-	rc = bnxt_probe_phy(bp);
+	rc = bnxt_probe_phy(bp, true);
 	if (rc)
 		goto init_err_pci_clean;
 
@@ -11046,24 +11121,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto init_err_pci_clean;
 	}
 
-	/* Default RSS hash cfg. */
-	bp->rss_hash_cfg = VNIC_RSS_CFG_REQ_HASH_TYPE_IPV4 |
-			   VNIC_RSS_CFG_REQ_HASH_TYPE_TCP_IPV4 |
-			   VNIC_RSS_CFG_REQ_HASH_TYPE_IPV6 |
-			   VNIC_RSS_CFG_REQ_HASH_TYPE_TCP_IPV6;
-	if (BNXT_CHIP_P4(bp) && bp->hwrm_spec_code >= 0x10501) {
-		bp->flags |= BNXT_FLAG_UDP_RSS_CAP;
-		bp->rss_hash_cfg |= VNIC_RSS_CFG_REQ_HASH_TYPE_UDP_IPV4 |
-				    VNIC_RSS_CFG_REQ_HASH_TYPE_UDP_IPV6;
-	}
-
-	if (bnxt_rfs_supported(bp)) {
-		dev->hw_features |= NETIF_F_NTUPLE;
-		if (bnxt_rfs_capable(bp)) {
-			bp->flags |= BNXT_FLAG_RFS;
-			dev->features |= NETIF_F_NTUPLE;
-		}
-	}
+	bnxt_fw_init_one_p3(bp);
 
 	if (dev->hw_features & NETIF_F_HW_VLAN_CTAG_RX)
 		bp->flags |= BNXT_FLAG_STRIP_VLAN;
@@ -11077,16 +11135,6 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 */
 	bp->tx_nr_rings_per_tc = bp->tx_nr_rings;
 
-	bnxt_get_wol_settings(bp);
-	if (bp->flags & BNXT_FLAG_WOL_CAP)
-		device_set_wakeup_enable(&pdev->dev, bp->wol);
-	else
-		device_set_wakeup_capable(&pdev->dev, false);
-
-	bnxt_hwrm_set_cache_line_size(bp, cache_line_size());
-
-	bnxt_hwrm_coal_params_qcaps(bp);
-
 	if (BNXT_PF(bp)) {
 		if (!bnxt_pf_wq) {
 			bnxt_pf_wq =
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
index a2ffc3e..fb6f30d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
@@ -389,6 +389,7 @@ static int bnxt_hwrm_queue_dscp_qcaps(struct bnxt *bp)
 	struct hwrm_queue_dscp_qcaps_input req = {0};
 	int rc;
 
+	bp->max_dscp_value = 0;
 	if (bp->hwrm_spec_code < 0x10800 || BNXT_VF(bp))
 		return 0;
 
@@ -718,6 +719,7 @@ static const struct dcbnl_rtnl_ops dcbnl_ops = {
 
 void bnxt_dcb_init(struct bnxt *bp)
 {
+	bp->dcbx_cap = 0;
 	if (bp->hwrm_spec_code < 0x10501)
 		return;
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index a3a8722..235265e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -3350,6 +3350,7 @@ void bnxt_ethtool_init(struct bnxt *bp)
 	if (!(bp->fw_cap & BNXT_FW_CAP_PKG_VER))
 		bnxt_get_pkgver(dev);
 
+	bp->num_tests = 0;
 	if (bp->hwrm_spec_code < 0x10704 || !BNXT_SINGLE_PF(bp))
 		return;
 
@@ -3359,7 +3360,9 @@ void bnxt_ethtool_init(struct bnxt *bp)
 	if (rc)
 		goto ethtool_init_exit;
 
-	test_info = kzalloc(sizeof(*bp->test_info), GFP_KERNEL);
+	test_info = bp->test_info;
+	if (!test_info)
+		test_info = kzalloc(sizeof(*bp->test_info), GFP_KERNEL);
 	if (!test_info)
 		goto ethtool_init_exit;
 
-- 
2.5.1

