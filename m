Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4421E7122
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 02:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438039AbgE2AJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 20:09:15 -0400
Received: from mga03.intel.com ([134.134.136.65]:2081 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437671AbgE2AIf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 20:08:35 -0400
IronPort-SDR: pHfdKFCj/XInMHRMiDIUkIcB1RJo2oo5pLP5EEq9icIPzczVa0zke//mt/hGXy5JQHTJB9OU33
 c1dz93wrJl3w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 17:08:33 -0700
IronPort-SDR: YES2E/DV2yL3cDkkbtCPSE7fTiYNniyozwQNOZmL3KbjTySNCVAz+LmTO5k1cWDMBGSPK1S0KM
 t6yn4hv3p2jg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,446,1583222400"; 
   d="scan'208";a="302651624"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 28 May 2020 17:08:33 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 04/15] ice: fix kernel BUG if register_netdev fails
Date:   Thu, 28 May 2020 17:08:20 -0700
Message-Id: <20200529000831.2803870-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529000831.2803870-1-jeffrey.t.kirsher@intel.com>
References: <20200529000831.2803870-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

If register_netdev() fails, the driver will attempt to cleanup the
q_vectors and inadvertently trigger a kernel BUG due to a NULL pointer
dereference.

This occurs because cleaning up q_vectors attempts to call
netif_napi_del on napi_structs which were never initialized.

Resolve this by releasing the netdev in ice_cfg_netdev and setting
vsi->netdev to NULL. This ensures that after ice_cfg_netdev fails the
state is rewound to match as if ice_cfg_netdev was never called.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 5cffaf360cb0..69854b8644a6 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2428,7 +2428,7 @@ static int ice_cfg_netdev(struct ice_vsi *vsi)
 
 	err = register_netdev(vsi->netdev);
 	if (err)
-		goto err_destroy_devlink_port;
+		goto err_free_netdev;
 
 	devlink_port_type_eth_set(&pf->devlink_port, vsi->netdev);
 
@@ -2439,9 +2439,11 @@ static int ice_cfg_netdev(struct ice_vsi *vsi)
 
 	return 0;
 
+err_free_netdev:
+	free_netdev(vsi->netdev);
+	vsi->netdev = NULL;
 err_destroy_devlink_port:
 	ice_devlink_destroy_port(pf);
-
 	return err;
 }
 
-- 
2.26.2

