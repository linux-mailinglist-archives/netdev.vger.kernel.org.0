Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1501DE05D
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 08:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728545AbgEVG4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 02:56:39 -0400
Received: from mga14.intel.com ([192.55.52.115]:18662 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728394AbgEVG4T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 02:56:19 -0400
IronPort-SDR: s0kVXxLW/Xeq/QEPCxPg72a2oWLDvBSCjHEEpdDURaclIMQ8m/XXRGj1NbjFsJnyClHrl9ooqd
 brjKpDx+3dRQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 23:56:11 -0700
IronPort-SDR: ojfxElqCXeAjGEgp6r4h0hfWu6R7NxK1ADWtN99Z0nX49fI7x/o8C01797yOojahTAGLITs9BZ
 8MowRt3NuV+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,420,1583222400"; 
   d="scan'208";a="290017773"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 21 May 2020 23:56:11 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Lihong Yang <lihong.yang@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 13/17] ice: Fix check for removing/adding mac filters
Date:   Thu, 21 May 2020 23:56:03 -0700
Message-Id: <20200522065607.1680050-14-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522065607.1680050-1-jeffrey.t.kirsher@intel.com>
References: <20200522065607.1680050-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lihong Yang <lihong.yang@intel.com>

In function ice_set_mac_address, we will remove old dev_addr before
adding the new MAC. In the removing and adding process of the MAC,
there is no need to return error if the check finds the to-be-removed
dev_addr does not exist in the MAC filter list or the to-be-added mac
already exists, keep going or return success accordingly.

Signed-off-by: Lihong Yang <lihong.yang@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 7fee3e4b39eb..6ac3e5540119 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3707,19 +3707,24 @@ static int ice_set_mac_address(struct net_device *netdev, void *pi)
 		return -EBUSY;
 	}
 
-	/* Clean up old MAC filter before changing the MAC address */
+	/* Clean up old MAC filter. Not an error if old filter doesn't exist */
 	status = ice_fltr_remove_mac(vsi, netdev->dev_addr, ICE_FWD_TO_VSI);
-	if (status) {
+	if (status && status != ICE_ERR_DOES_NOT_EXIST) {
 		err = -EADDRNOTAVAIL;
 		goto err_update_filters;
 	}
 
+	/* Add filter for new MAC. If filter exists, just return success */
 	status = ice_fltr_add_mac(vsi, mac, ICE_FWD_TO_VSI);
-	if (status) {
-		err = -EADDRNOTAVAIL;
-		goto err_update_filters;
+	if (status == ICE_ERR_ALREADY_EXISTS) {
+		netdev_dbg(netdev, "filter for MAC %pM already exists\n", mac);
+		return 0;
 	}
 
+	/* error if the new filter addition failed */
+	if (status)
+		err = -EADDRNOTAVAIL;
+
 err_update_filters:
 	if (err) {
 		netdev_err(netdev, "can't set MAC %pM. filter update failed\n",
-- 
2.26.2

