Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 773EA169512
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 03:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728944AbgBWCfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 21:35:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:51136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728047AbgBWCWO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Feb 2020 21:22:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19DDF2071E;
        Sun, 23 Feb 2020 02:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582424532;
        bh=QBtKWAnTBZqguhrWhK/yf4l1xcXIcT6NK+JocHdAZQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1SL1p4KSaGUOVWlrGL5pA0u1X+xM/6DomuIRRcFUEs8lxQb+H9+qtyJiVlcPrBzLv
         KcPMLl71O7eBHZHOP/rnzBCysBfG/nPpVYj2c5j85nuRLvck3c/2lnmKLFni6bG8Lu
         oHBQJ+UdmqMlfNIBcXe0xMZxKnkPLH/onMLaV7+o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bruce Allan <bruce.w.allan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 44/58] ice: fix and consolidate logging of NVM/firmware version information
Date:   Sat, 22 Feb 2020 21:21:05 -0500
Message-Id: <20200223022119.707-44-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200223022119.707-1-sashal@kernel.org>
References: <20200223022119.707-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

[ Upstream commit fbf1e1f6988e70287b1bfcad4f655ca96b681929 ]

Logging the firmware/NVM information during driver load is redundant since
that information is also available via ethtool.  Move the functionality
found in ice_nvm_version_str() directly into ice_get_drvinfo() and remove
calling the former and logging that info during driver probe.  This also
gets rid of a bug in ice_nvm_version_str() where it returns a pointer to
a buffer which is free'ed when that function exits.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 15 +++++++++++++--
 drivers/net/ethernet/intel/ice/ice_lib.c     | 19 -------------------
 drivers/net/ethernet/intel/ice/ice_lib.h     |  2 --
 drivers/net/ethernet/intel/ice/ice_main.c    |  5 -----
 4 files changed, 13 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 9ebd93e79aeb6..f956f7bb4ef2d 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -165,13 +165,24 @@ static void
 ice_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
+	u8 oem_ver, oem_patch, nvm_ver_hi, nvm_ver_lo;
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
+	struct ice_hw *hw = &pf->hw;
+	u16 oem_build;
 
 	strlcpy(drvinfo->driver, KBUILD_MODNAME, sizeof(drvinfo->driver));
 	strlcpy(drvinfo->version, ice_drv_ver, sizeof(drvinfo->version));
-	strlcpy(drvinfo->fw_version, ice_nvm_version_str(&pf->hw),
-		sizeof(drvinfo->fw_version));
+
+	/* Display NVM version (from which the firmware version can be
+	 * determined) which contains more pertinent information.
+	 */
+	ice_get_nvm_version(hw, &oem_ver, &oem_build, &oem_patch,
+			    &nvm_ver_hi, &nvm_ver_lo);
+	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
+		 "%x.%02x 0x%x %d.%d.%d", nvm_ver_hi, nvm_ver_lo,
+		 hw->nvm.eetrack, oem_ver, oem_build, oem_patch);
+
 	strlcpy(drvinfo->bus_info, pci_name(pf->pdev),
 		sizeof(drvinfo->bus_info));
 	drvinfo->n_priv_flags = ICE_PRIV_FLAG_ARRAY_SIZE;
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index e7449248fab4c..e0e3c6400e4b9 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2647,25 +2647,6 @@ int ice_vsi_cfg_tc(struct ice_vsi *vsi, u8 ena_tc)
 }
 #endif /* CONFIG_DCB */
 
-/**
- * ice_nvm_version_str - format the NVM version strings
- * @hw: ptr to the hardware info
- */
-char *ice_nvm_version_str(struct ice_hw *hw)
-{
-	u8 oem_ver, oem_patch, ver_hi, ver_lo;
-	static char buf[ICE_NVM_VER_LEN];
-	u16 oem_build;
-
-	ice_get_nvm_version(hw, &oem_ver, &oem_build, &oem_patch, &ver_hi,
-			    &ver_lo);
-
-	snprintf(buf, sizeof(buf), "%x.%02x 0x%x %d.%d.%d", ver_hi, ver_lo,
-		 hw->nvm.eetrack, oem_ver, oem_build, oem_patch);
-
-	return buf;
-}
-
 /**
  * ice_update_ring_stats - Update ring statistics
  * @ring: ring to update
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 6e31e30aba394..0d2b1119c0e38 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -97,8 +97,6 @@ void ice_vsi_cfg_frame_size(struct ice_vsi *vsi);
 
 u32 ice_intrl_usec_to_reg(u8 intrl, u8 gran);
 
-char *ice_nvm_version_str(struct ice_hw *hw);
-
 enum ice_status
 ice_vsi_cfg_mac_fltr(struct ice_vsi *vsi, const u8 *macaddr, bool set);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 69bff085acf75..b4cbeb4f3177f 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3241,11 +3241,6 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 		goto err_exit_unroll;
 	}
 
-	dev_info(dev, "firmware %d.%d.%d api %d.%d.%d nvm %s build 0x%08x\n",
-		 hw->fw_maj_ver, hw->fw_min_ver, hw->fw_patch,
-		 hw->api_maj_ver, hw->api_min_ver, hw->api_patch,
-		 ice_nvm_version_str(hw), hw->fw_build);
-
 	ice_request_fw(pf);
 
 	/* if ice_request_fw fails, ICE_FLAG_ADV_FEATURES bit won't be
-- 
2.20.1

