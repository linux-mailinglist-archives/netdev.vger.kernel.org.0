Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAEBA1DF552
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 08:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387737AbgEWGtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 02:49:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:52994 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387710AbgEWGtN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 May 2020 02:49:13 -0400
IronPort-SDR: uogyiUsynPkk++/0Jfha9D7qS4mROmN2gRZVglBzGqOmZvwDTOsJzS/SUPnEmHRHw7cNZYp4k5
 sdYfn7MlnhJA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 23:48:51 -0700
IronPort-SDR: iXEiIy0VTmEsAdLppOT5seunr0ynJ1gWTM80o6EVyq7SrppVSLywyRADXAkKJKwphe21nOVA+Z
 zsuNP6r8BO+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,424,1583222400"; 
   d="scan'208";a="374966917"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga001.fm.intel.com with ESMTP; 22 May 2020 23:48:51 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 15/16] ice: fix usage of incorrect variable
Date:   Fri, 22 May 2020 23:48:46 -0700
Message-Id: <20200523064847.3972158-16-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523064847.3972158-1-jeffrey.t.kirsher@intel.com>
References: <20200523064847.3972158-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

The driver was using rq_last_status where it should have been
using sq_last_status. Fix the string to be using the correct
error reporting variable.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 2 +-
 drivers/net/ethernet/intel/ice/ice_main.c    | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 477ad33e0403..f39d4eb7fd8b 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3251,7 +3251,7 @@ static int ice_vsi_set_dflt_rss_lut(struct ice_vsi *vsi, int req_rss_size)
 	if (status) {
 		dev_err(dev, "Cannot set RSS lut, err %s aq_err %s\n",
 			ice_stat_str(status),
-			ice_aq_str(hw->adminq.rq_last_status));
+			ice_aq_str(hw->adminq.sq_last_status));
 		err = -EIO;
 	}
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 5adf6c92872d..6e6df4d690cc 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5232,7 +5232,7 @@ int ice_set_rss(struct ice_vsi *vsi, u8 *seed, u8 *lut, u16 lut_size)
 		if (status) {
 			dev_err(dev, "Cannot set RSS key, err %s aq_err %s\n",
 				ice_stat_str(status),
-				ice_aq_str(hw->adminq.rq_last_status));
+				ice_aq_str(hw->adminq.sq_last_status));
 			return -EIO;
 		}
 	}
@@ -5243,7 +5243,7 @@ int ice_set_rss(struct ice_vsi *vsi, u8 *seed, u8 *lut, u16 lut_size)
 		if (status) {
 			dev_err(dev, "Cannot set RSS lut, err %s aq_err %s\n",
 				ice_stat_str(status),
-				ice_aq_str(hw->adminq.rq_last_status));
+				ice_aq_str(hw->adminq.sq_last_status));
 			return -EIO;
 		}
 	}
@@ -5276,7 +5276,7 @@ int ice_get_rss(struct ice_vsi *vsi, u8 *seed, u8 *lut, u16 lut_size)
 		if (status) {
 			dev_err(dev, "Cannot get RSS key, err %s aq_err %s\n",
 				ice_stat_str(status),
-				ice_aq_str(hw->adminq.rq_last_status));
+				ice_aq_str(hw->adminq.sq_last_status));
 			return -EIO;
 		}
 	}
@@ -5287,7 +5287,7 @@ int ice_get_rss(struct ice_vsi *vsi, u8 *seed, u8 *lut, u16 lut_size)
 		if (status) {
 			dev_err(dev, "Cannot get RSS lut, err %s aq_err %s\n",
 				ice_stat_str(status),
-				ice_aq_str(hw->adminq.rq_last_status));
+				ice_aq_str(hw->adminq.sq_last_status));
 			return -EIO;
 		}
 	}
-- 
2.26.2

