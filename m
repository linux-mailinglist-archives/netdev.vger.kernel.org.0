Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A47E0451BCE
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 01:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348461AbhKPAHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 19:07:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:18638 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351029AbhKPAF2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 19:05:28 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10169"; a="220768895"
X-IronPort-AV: E=Sophos;i="5.87,237,1631602800"; 
   d="scan'208";a="220768895"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 16:01:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,237,1631602800"; 
   d="scan'208";a="506163110"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 15 Nov 2021 16:00:57 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Nicholas Nunley <nicholas.d.nunley@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com, Tony Brelinski <tony.brelinski@intel.com>
Subject: [PATCH net 02/10] iavf: check for null in iavf_fix_features
Date:   Mon, 15 Nov 2021 15:59:26 -0800
Message-Id: <20211115235934.880882-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211115235934.880882-1-anthony.l.nguyen@intel.com>
References: <20211115235934.880882-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicholas Nunley <nicholas.d.nunley@intel.com>

If the driver has lost contact with the PF then it enters a disabled state
and frees adapter->vf_res. However, ndo_fix_features can still be called on
the interface, so we need to check for this condition first. Since we have
no information on the features at this time simply leave them unmodified
and return.

Fixes: c4445aedfe09 ("i40evf: Fix VLAN features")
Signed-off-by: Nicholas Nunley <nicholas.d.nunley@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 847d67e32a54..561171507cda 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3503,7 +3503,8 @@ static netdev_features_t iavf_fix_features(struct net_device *netdev,
 {
 	struct iavf_adapter *adapter = netdev_priv(netdev);
 
-	if (!(adapter->vf_res->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_VLAN))
+	if (adapter->vf_res &&
+	    !(adapter->vf_res->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_VLAN))
 		features &= ~(NETIF_F_HW_VLAN_CTAG_TX |
 			      NETIF_F_HW_VLAN_CTAG_RX |
 			      NETIF_F_HW_VLAN_CTAG_FILTER);
-- 
2.31.1

