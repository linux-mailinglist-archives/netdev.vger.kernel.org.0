Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 422F64A9037
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 22:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355280AbiBCVvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 16:51:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:63985 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354869AbiBCVvw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 16:51:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643925112; x=1675461112;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QEm+d8KdN1L8pHMOKq1C2YqyXVjghJIR+Ai6VaYSKFI=;
  b=aITlgDtiQ/9GmBp5pwR3pIFFhHPi3Q/rL4NoKYS8/RBVoMudGM/aI1P9
   /0pLZiBGyF3915kYPNjNZvCG4QNqtsL09RFHIWlhMakEWB0mfle8nW4Py
   Ryui56WXRzlmUNlC6vXRxvIRQG8o4nnJZnCuipAvBUvM0GhVdItRjRijI
   r7/P+3zazGOGds6CvIEqzrPQlofyBWgQ5VlyEigWhBu4cVUIbZTMI4lb1
   WP1EQliBfUvSRzzmKcrlt4dv4U5YMNZmlQ26C78D0fYjf+RFvcs6avhRG
   IZf7O0aAxgNTswFlkL/hu6IcMSdecIXk3mVtOMeEeqaaxMtgJgivVSHmS
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10247"; a="272760129"
X-IronPort-AV: E=Sophos;i="5.88,340,1635231600"; 
   d="scan'208";a="272760129"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2022 13:51:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,340,1635231600"; 
   d="scan'208";a="498295189"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 03 Feb 2022 13:51:51 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Mateusz Palczewski <mateusz.palczewski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        Norbert Zulinski <norbertx.zulinski@intel.com>,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        Dave Switzer <david.switzer@intel.com>
Subject: [PATCH net-next 1/7] i40e: Disable hw-tc-offload feature on driver load
Date:   Thu,  3 Feb 2022 13:51:34 -0800
Message-Id: <20220203215140.969227-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220203215140.969227-1-anthony.l.nguyen@intel.com>
References: <20220203215140.969227-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

After loading driver hw-tc-offload is enabled by default.
Change the behaviour of driver to disable hw-tc-offload by default as
this is the expected state. Additionally since this impacts ntuple
feature state change the way of checking NETIF_F_HW_TC flag.

Signed-off-by: Norbert Zulinski <norbertx.zulinski@intel.com>
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index c8834765c864..748806cfc441 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -12707,7 +12707,8 @@ static int i40e_set_features(struct net_device *netdev,
 	else
 		i40e_vlan_stripping_disable(vsi);
 
-	if (!(features & NETIF_F_HW_TC) && pf->num_cloud_filters) {
+	if (!(features & NETIF_F_HW_TC) &&
+	    (netdev->features & NETIF_F_HW_TC) && pf->num_cloud_filters) {
 		dev_err(&pf->pdev->dev,
 			"Offloaded tc filters active, can't turn hw_tc_offload off");
 		return -EINVAL;
@@ -13459,6 +13460,8 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 	netdev->features |= hw_features | NETIF_F_HW_VLAN_CTAG_FILTER;
 	netdev->hw_enc_features |= NETIF_F_TSO_MANGLEID;
 
+	netdev->features &= ~NETIF_F_HW_TC;
+
 	if (vsi->type == I40E_VSI_MAIN) {
 		SET_NETDEV_DEV(netdev, &pf->pdev->dev);
 		ether_addr_copy(mac_addr, hw->mac.perm_addr);
-- 
2.31.1

