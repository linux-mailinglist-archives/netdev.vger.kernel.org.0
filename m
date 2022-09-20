Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B27415BEECB
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 22:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbiITUxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 16:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbiITUxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 16:53:54 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC9E76950
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 13:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663707233; x=1695243233;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=j5TyEptKZLCMciL+lInL5eZU0tOPPqTUnk3IiIGxnEE=;
  b=WTQJ1w/Cvf2TSkfK5y5SWyQQku7q7EsKYu6U5K0hKoqibczy3eV2kLwO
   vcRXEKLdRO1Z2KeXvzPHiPfLbzF9zpmufDHP7nqXYhfwx38N7wmC4zpzZ
   qmQiFC5GHiwz0uza7D8ZdpqqUYDlxs7XqgyJj9RzQLqzM8QVMmhPiG0AR
   fYGGj4c69lsBGsGLl46YOGVu9q3gtjq/mn3rIJ8hgh4ZbdDR7Ljx0rwSo
   eCYCOV57YrH+AIaujmGrcrTNZPq5rRlXVWQh2jvf3+p/mIRgEInuaN/NI
   sqpxDBS6sdzZg5eSiLBC34jbqcXpoyzZKlJMqkoyvJMOa4SWpfbLFk24s
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10476"; a="386103560"
X-IronPort-AV: E=Sophos;i="5.93,331,1654585200"; 
   d="scan'208";a="386103560"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2022 13:53:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,331,1654585200"; 
   d="scan'208";a="722904472"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 20 Sep 2022 13:53:52 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Mateusz Palczewski <mateusz.palczewski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Petr Oros <poros@redhat.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net 2/2] ice: Fix interface being down after reset with link-down-on-close flag on
Date:   Tue, 20 Sep 2022 13:53:44 -0700
Message-Id: <20220920205344.1860934-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220920205344.1860934-1-anthony.l.nguyen@intel.com>
References: <20220920205344.1860934-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

When performing a reset on ice driver with link-down-on-close flag on
interface would always stay down. Fix this by moving a check of this
flag to ice_stop() that is called only when user wants to bring
interface down.

Fixes: ab4ab73fc1ec ("ice: Add ethtool private flag to make forcing link down optional")
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Petr Oros <poros@redhat.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 3042a76b848d..e109cb93886b 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -6649,7 +6649,7 @@ static void ice_napi_disable_all(struct ice_vsi *vsi)
  */
 int ice_down(struct ice_vsi *vsi)
 {
-	int i, tx_err, rx_err, link_err = 0, vlan_err = 0;
+	int i, tx_err, rx_err, vlan_err = 0;
 
 	WARN_ON(!test_bit(ICE_VSI_DOWN, vsi->state));
 
@@ -6683,20 +6683,13 @@ int ice_down(struct ice_vsi *vsi)
 
 	ice_napi_disable_all(vsi);
 
-	if (test_bit(ICE_FLAG_LINK_DOWN_ON_CLOSE_ENA, vsi->back->flags)) {
-		link_err = ice_force_phys_link_state(vsi, false);
-		if (link_err)
-			netdev_err(vsi->netdev, "Failed to set physical link down, VSI %d error %d\n",
-				   vsi->vsi_num, link_err);
-	}
-
 	ice_for_each_txq(vsi, i)
 		ice_clean_tx_ring(vsi->tx_rings[i]);
 
 	ice_for_each_rxq(vsi, i)
 		ice_clean_rx_ring(vsi->rx_rings[i]);
 
-	if (tx_err || rx_err || link_err || vlan_err) {
+	if (tx_err || rx_err || vlan_err) {
 		netdev_err(vsi->netdev, "Failed to close VSI 0x%04X on switch 0x%04X\n",
 			   vsi->vsi_num, vsi->vsw->sw_id);
 		return -EIO;
@@ -8892,6 +8885,16 @@ int ice_stop(struct net_device *netdev)
 		return -EBUSY;
 	}
 
+	if (test_bit(ICE_FLAG_LINK_DOWN_ON_CLOSE_ENA, vsi->back->flags)) {
+		int link_err = ice_force_phys_link_state(vsi, false);
+
+		if (link_err) {
+			netdev_err(vsi->netdev, "Failed to set physical link down, VSI %d error %d\n",
+				   vsi->vsi_num, link_err);
+			return -EIO;
+		}
+	}
+
 	ice_vsi_close(vsi);
 
 	return 0;
-- 
2.35.1

