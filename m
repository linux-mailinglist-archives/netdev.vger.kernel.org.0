Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88EA29F068
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 18:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730493AbfH0QjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 12:39:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:10368 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730185AbfH0Qie (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 12:38:34 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 09:38:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,437,1559545200"; 
   d="scan'208";a="331876342"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 27 Aug 2019 09:38:33 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Akeem G Abodunrin <akeem.g.abodunrin@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 06/15] ice: Don't clog kernel debug log with VF MDD events errors
Date:   Tue, 27 Aug 2019 09:38:23 -0700
Message-Id: <20190827163832.8362-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190827163832.8362-1-jeffrey.t.kirsher@intel.com>
References: <20190827163832.8362-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>

In case of MDD events on VF, don't clog kernel log with unlimited VF MDD
events message "VF 0 has had 1018 MDD events since last boot" - limit
events log message to 30, based on the observation in some experimentation
with sending malicious packet once, and number of events reported before
device stopped observing MDD events.

Also removed defunct macro "ICE_DFLT_NUM_MDD_EVENTS_ALLOWED" for tracking
number of MDD events allowed before disabling the interface...

Signed-off-by: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c        | 6 ++++--
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h | 2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 2c6b2bc4e30e..67cbebe1ff3f 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1315,8 +1315,10 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 
 		if (vf_mdd_detected) {
 			vf->num_mdd_events++;
-			if (vf->num_mdd_events > 1)
-				dev_info(&pf->pdev->dev, "VF %d has had %llu MDD events since last boot\n",
+			if (vf->num_mdd_events &&
+			    vf->num_mdd_events <= ICE_MDD_EVENTS_THRESHOLD)
+				dev_info(&pf->pdev->dev,
+					 "VF %d has had %llu MDD events since last boot, Admin might need to reload AVF driver with this number of events\n",
 					 i, vf->num_mdd_events);
 		}
 	}
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index 4d94853f119a..13f45f37d75e 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -15,8 +15,8 @@
 #define ICE_MAX_MACADDR_PER_VF		12
 
 /* Malicious Driver Detection */
-#define ICE_DFLT_NUM_MDD_EVENTS_ALLOWED		3
 #define ICE_DFLT_NUM_INVAL_MSGS_ALLOWED		10
+#define ICE_MDD_EVENTS_THRESHOLD		30
 
 /* Static VF transaction/status register def */
 #define VF_DEVICE_STATUS		0xAA
-- 
2.21.0

