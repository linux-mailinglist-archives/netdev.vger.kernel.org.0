Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77259179C47
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 00:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388604AbgCDXVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 18:21:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:48334 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388577AbgCDXVm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 18:21:42 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2020 15:21:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,515,1574150400"; 
   d="scan'208";a="244094651"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga006.jf.intel.com with ESMTP; 04 Mar 2020 15:21:38 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 14/16] ice: Use EOPNOTSUPP instead of ENOTSUPP
Date:   Wed,  4 Mar 2020 15:21:34 -0800
Message-Id: <20200304232136.4172118-15-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200304232136.4172118-1-jeffrey.t.kirsher@intel.com>
References: <20200304232136.4172118-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

Using ENOTSUPP almost always results in some bizarre error message to
be printed in userspace. This is likely because ENOTSUPP was defined for
the NFS protocol (as per a comment in include/linux/errno.h). Use
EOPNOTSUPP instead.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.h         | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 6ee7f8c9449a..15191a325918 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -1429,7 +1429,7 @@ static int ice_pci_sriov_ena(struct ice_pf *pf, int num_vfs)
 	if (num_vfs > pf->num_vfs_supported) {
 		dev_err(dev, "Can't enable %d VFs, max VFs supported is %d\n",
 			num_vfs, pf->num_vfs_supported);
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 	}
 
 	dev_info(dev, "Allocating %d VFs\n", num_vfs);
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.h b/drivers/net/ethernet/intel/ice/ice_xsk.h
index 3479e1de98fe..8a4ba7c6d549 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.h
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.h
@@ -24,7 +24,7 @@ ice_xsk_umem_setup(struct ice_vsi __always_unused *vsi,
 		   struct xdp_umem __always_unused *umem,
 		   u16 __always_unused qid)
 {
-	return -ENOTSUPP;
+	return -EOPNOTSUPP;
 }
 
 static inline void
@@ -63,7 +63,7 @@ static inline int
 ice_xsk_wakeup(struct net_device __always_unused *netdev,
 	       u32 __always_unused queue_id, u32 __always_unused flags)
 {
-	return -ENOTSUPP;
+	return -EOPNOTSUPP;
 }
 
 #define ice_xsk_clean_rx_ring(rx_ring) do {} while (0)
-- 
2.24.1

