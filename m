Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2143F9F05A
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 18:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730326AbfH0Qih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 12:38:37 -0400
Received: from mga17.intel.com ([192.55.52.151]:7294 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730258AbfH0Qif (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 12:38:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 09:38:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,437,1559545200"; 
   d="scan'208";a="331876333"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 27 Aug 2019 09:38:33 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 03/15] ice: Sanitize ice_ena_vsi and ice_dis_vsi
Date:   Tue, 27 Aug 2019 09:38:20 -0700
Message-Id: <20190827163832.8362-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190827163832.8362-1-jeffrey.t.kirsher@intel.com>
References: <20190827163832.8362-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

1. ndo_open and ndo_stop are implemented by ice_open and ice_stop
   respectively. When enabling/disabling VSIs, just call
   ice_open/ice_stop instead of ndo_open/ndo_stop.

2. Rework logic around rtnl_lock/rtnl_unlock

3. In ice_ena_vsi, remove an unnecessary stack variable and return
   0 instead of err when __ICE_NEEDS_RESTART is not set.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 24 +++++++++++------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 76a647cc2dbd..2f6125bfd991 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -436,13 +436,13 @@ static void ice_dis_vsi(struct ice_vsi *vsi, bool locked)
 
 	if (vsi->type == ICE_VSI_PF && vsi->netdev) {
 		if (netif_running(vsi->netdev)) {
-			if (!locked) {
+			if (!locked)
 				rtnl_lock();
-				vsi->netdev->netdev_ops->ndo_stop(vsi->netdev);
+
+			ice_stop(vsi->netdev);
+
+			if (!locked)
 				rtnl_unlock();
-			} else {
-				vsi->netdev->netdev_ops->ndo_stop(vsi->netdev);
-			}
 		} else {
 			ice_vsi_close(vsi);
 		}
@@ -3654,21 +3654,19 @@ static int ice_ena_vsi(struct ice_vsi *vsi, bool locked)
 	int err = 0;
 
 	if (!test_bit(__ICE_NEEDS_RESTART, vsi->state))
-		return err;
+		return 0;
 
 	clear_bit(__ICE_NEEDS_RESTART, vsi->state);
 
 	if (vsi->netdev && vsi->type == ICE_VSI_PF) {
-		struct net_device *netd = vsi->netdev;
-
 		if (netif_running(vsi->netdev)) {
-			if (locked) {
-				err = netd->netdev_ops->ndo_open(netd);
-			} else {
+			if (!locked)
 				rtnl_lock();
-				err = netd->netdev_ops->ndo_open(netd);
+
+			err = ice_open(vsi->netdev);
+
+			if (!locked)
 				rtnl_unlock();
-			}
 		}
 	}
 
-- 
2.21.0

