Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FED12E4B4
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 20:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfE2Srr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 14:47:47 -0400
Received: from mga03.intel.com ([134.134.136.65]:45223 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726131AbfE2Srp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 14:47:45 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 May 2019 11:47:44 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 29 May 2019 11:47:43 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 03/15] ice: Implement toggling ethtool rx-vlan-filter
Date:   Wed, 29 May 2019 11:47:42 -0700
Message-Id: <20190529184754.12693-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190529184754.12693-1-jeffrey.t.kirsher@intel.com>
References: <20190529184754.12693-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>

Implement the toggling of rx-vlan-filter; enable|disable VLAN
pruning based on on|off, respectively.

Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 0a4abc21890c..eaa1b25dd1b0 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2876,6 +2876,13 @@ ice_set_features(struct net_device *netdev, netdev_features_t features)
 		 (netdev->features & NETIF_F_HW_VLAN_CTAG_TX))
 		ret = ice_vsi_manage_vlan_insertion(vsi);
 
+	if ((features & NETIF_F_HW_VLAN_CTAG_FILTER) &&
+	    !(netdev->features & NETIF_F_HW_VLAN_CTAG_FILTER))
+		ret = ice_cfg_vlan_pruning(vsi, true, false);
+	else if (!(features & NETIF_F_HW_VLAN_CTAG_FILTER) &&
+		 (netdev->features & NETIF_F_HW_VLAN_CTAG_FILTER))
+		ret = ice_cfg_vlan_pruning(vsi, false, false);
+
 	return ret;
 }
 
-- 
2.21.0

