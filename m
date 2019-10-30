Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FADBE9547
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 04:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbfJ3D3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 23:29:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:43132 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727034AbfJ3D3O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 23:29:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Oct 2019 20:29:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,245,1569308400"; 
   d="scan'208";a="205673662"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Oct 2019 20:29:13 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 9/9] ice: allow 3k MTU for XDP
Date:   Tue, 29 Oct 2019 20:29:10 -0700
Message-Id: <20191030032910.24261-10-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191030032910.24261-1-jeffrey.t.kirsher@intel.com>
References: <20191030032910.24261-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

At this point ice driver is able to work on order 1 pages that are split
onto two 3k buffers. Let's reflect that when user is setting new MTU
size and XDP is present on interface.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 98022ed9aaf4..3da674b07339 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4648,6 +4648,18 @@ static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
 	dev_err(dev, "Rebuild failed, unload and reload driver\n");
 }
 
+/**
+ * ice_max_xdp_frame_size - returns the maximum allowed frame size for XDP
+ * @vsi: Pointer to VSI structure
+ */
+static int ice_max_xdp_frame_size(struct ice_vsi *vsi)
+{
+	if (PAGE_SIZE >= 8192 || test_bit(ICE_FLAG_LEGACY_RX, vsi->back->flags))
+		return ICE_RXBUF_2048 - XDP_PACKET_HEADROOM;
+	else
+		return ICE_RXBUF_3072;
+}
+
 /**
  * ice_change_mtu - NDO callback to change the MTU
  * @netdev: network interface device structure
@@ -4668,11 +4680,11 @@ static int ice_change_mtu(struct net_device *netdev, int new_mtu)
 	}
 
 	if (ice_is_xdp_ena_vsi(vsi)) {
-		int frame_size = ICE_RXBUF_2048 - XDP_PACKET_HEADROOM;
+		int frame_size = ice_max_xdp_frame_size(vsi);
 
 		if (new_mtu + ICE_ETH_PKT_HDR_PAD > frame_size) {
 			netdev_err(netdev, "max MTU for XDP usage is %d\n",
-				   frame_size);
+				   frame_size - ICE_ETH_PKT_HDR_PAD);
 			return -EINVAL;
 		}
 	}
-- 
2.21.0

