Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 078ED232298
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 18:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgG2QYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 12:24:24 -0400
Received: from mga06.intel.com ([134.134.136.31]:42166 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726869AbgG2QYS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 12:24:18 -0400
IronPort-SDR: STZJQku+EIwhiQ+DymLvTIeI/behx0LY3MDLW6knctM+PR/oGbh78+fyEOEaxCCRq8bvdWTbAh
 m+l62PouHi5Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9697"; a="212982344"
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="212982344"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2020 09:24:16 -0700
IronPort-SDR: voBbqUDqlzTsqZInDyIy318No/wpJ4qN/PcMV7AHgSjLqQeJ+2p9jBF+kYL2lCiwPgH1+bXUAD
 Dg8Gm4jBF+hg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="313087600"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 29 Jul 2020 09:24:15 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Marcin Szycik <marcin.szycik@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 12/15] ice: cleanup VSI on probe fail
Date:   Wed, 29 Jul 2020 09:24:02 -0700
Message-Id: <20200729162405.1596435-13-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200729162405.1596435-1-anthony.l.nguyen@intel.com>
References: <20200729162405.1596435-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcin Szycik <marcin.szycik@intel.com>

As part of ice_setup_pf_sw() a PF VSI is setup; release the VSI in case of
failure.

Signed-off-by: Marcin Szycik <marcin.szycik@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index a68371fc0a75..c0bde24ab344 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4134,7 +4134,7 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	if (err) {
 		dev_err(dev, "probe failed sending driver version %s. error: %d\n",
 			UTS_RELEASE, err);
-		goto err_alloc_sw_unroll;
+		goto err_send_version_unroll;
 	}
 
 	/* since everything is good, start the service timer */
@@ -4143,19 +4143,19 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	err = ice_init_link_events(pf->hw.port_info);
 	if (err) {
 		dev_err(dev, "ice_init_link_events failed: %d\n", err);
-		goto err_alloc_sw_unroll;
+		goto err_send_version_unroll;
 	}
 
 	err = ice_init_nvm_phy_type(pf->hw.port_info);
 	if (err) {
 		dev_err(dev, "ice_init_nvm_phy_type failed: %d\n", err);
-		goto err_alloc_sw_unroll;
+		goto err_send_version_unroll;
 	}
 
 	err = ice_update_link_info(pf->hw.port_info);
 	if (err) {
 		dev_err(dev, "ice_update_link_info failed: %d\n", err);
-		goto err_alloc_sw_unroll;
+		goto err_send_version_unroll;
 	}
 
 	ice_init_link_dflt_override(pf->hw.port_info);
@@ -4166,7 +4166,7 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 		err = ice_init_phy_user_cfg(pf->hw.port_info);
 		if (err) {
 			dev_err(dev, "ice_init_phy_user_cfg failed: %d\n", err);
-			goto err_alloc_sw_unroll;
+			goto err_send_version_unroll;
 		}
 
 		if (!test_bit(ICE_FLAG_LINK_DOWN_ON_CLOSE_ENA, pf->flags)) {
@@ -4220,6 +4220,8 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	clear_bit(__ICE_DOWN, pf->state);
 	return 0;
 
+err_send_version_unroll:
+	ice_vsi_release_all(pf);
 err_alloc_sw_unroll:
 	ice_devlink_destroy_port(pf);
 	set_bit(__ICE_SERVICE_DIS, pf->state);
-- 
2.26.2

