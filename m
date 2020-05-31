Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23D4C1E979F
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 14:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgEaMgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 08:36:40 -0400
Received: from mga12.intel.com ([192.55.52.136]:12463 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728120AbgEaMgZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 May 2020 08:36:25 -0400
IronPort-SDR: cUlpPPSIJ0UaRMLRTjwIQkHDKKtfxU/FPdl7BZEj4JZEeRA75e7FkgfKZ7SXDQZcPhk88hvRXj
 c0CkD+Yaf2qw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2020 05:36:23 -0700
IronPort-SDR: C0c/eq5PBAGfuJLDeXwlfSbcp63hFOb6cucVj7sPJNmr+3M/qRHjgLXk2BNJkAErIPyWigf6In
 FLpz4wdfWwmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,456,1583222400"; 
   d="scan'208";a="303345438"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 31 May 2020 05:36:23 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 08/14] ice: Fix inability to set channels when down
Date:   Sun, 31 May 2020 05:36:13 -0700
Message-Id: <20200531123619.2887469-9-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200531123619.2887469-1-jeffrey.t.kirsher@intel.com>
References: <20200531123619.2887469-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

Currently the driver prevents a user from doing
modprobe ice
ethtool -L eth0 combined 5
ip link set eth0 up

The ethtool command fails, because the driver is checking to see if the
interface is down before allowing the get_channels to proceed (even for
a set_channels).

Remove this check and allow the user to configure the interface
before bringing it up, which is a much better usability case.

Fixes: 87324e747fde ("ice: Implement ethtool ops for channels")
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index fd1849155d85..68c38004a088 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3189,10 +3189,6 @@ ice_get_channels(struct net_device *dev, struct ethtool_channels *ch)
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
 
-	/* check to see if VSI is active */
-	if (test_bit(__ICE_DOWN, vsi->state))
-		return;
-
 	/* report maximum channels */
 	ch->max_rx = ice_get_max_rxq(pf);
 	ch->max_tx = ice_get_max_txq(pf);
-- 
2.26.2

