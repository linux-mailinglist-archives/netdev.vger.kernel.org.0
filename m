Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA8C180976
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 21:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbgCJUpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 16:45:46 -0400
Received: from mga12.intel.com ([192.55.52.136]:27474 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727504AbgCJUpl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 16:45:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Mar 2020 13:45:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,538,1574150400"; 
   d="scan'208";a="441431018"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga005.fm.intel.com with ESMTP; 10 Mar 2020 13:45:38 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 13/15] ice: Use EOPNOTSUPP instead of ENOTSUPP
Date:   Tue, 10 Mar 2020 13:45:32 -0700
Message-Id: <20200310204534.2071912-14-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200310204534.2071912-1-jeffrey.t.kirsher@intel.com>
References: <20200310204534.2071912-1-jeffrey.t.kirsher@intel.com>
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

