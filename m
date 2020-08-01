Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10A9E235341
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 18:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgHAQSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 12:18:22 -0400
Received: from mga05.intel.com ([192.55.52.43]:19610 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727059AbgHAQSL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Aug 2020 12:18:11 -0400
IronPort-SDR: bpht56BP0qfzZHvIYsOKOS6VIQHz9hmpTOlPI1aiW6pdtSGcFkkZVcZIk6PInwBQFkQyedCkCX
 bPoW5V6/4rLw==
X-IronPort-AV: E=McAfee;i="6000,8403,9699"; a="236810861"
X-IronPort-AV: E=Sophos;i="5.75,422,1589266800"; 
   d="scan'208";a="236810861"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2020 09:18:08 -0700
IronPort-SDR: 9vR1slKLWqcdueYexhsxNBGhJFoV8Vy7RhW6tQEyiWkOLG1VbiK1zvHSIibRqj1p1muS6lZHI0
 rvABz7andR7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,422,1589266800"; 
   d="scan'208";a="331457712"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga007.jf.intel.com with ESMTP; 01 Aug 2020 09:18:07 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 08/14] ice: Allow 2 queue pairs per VF on SR-IOV initialization
Date:   Sat,  1 Aug 2020 09:17:56 -0700
Message-Id: <20200801161802.867645-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200801161802.867645-1-anthony.l.nguyen@intel.com>
References: <20200801161802.867645-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently VFs are only allowed to get 16, 4, and 1 queue pair by
default, which require 17, 5, and 2 MSI-X vectors respectively. This
is because each VF needs a MSI-X per data queue and a MSI-X for its
other interrupt. The calculation is based on the number of VFs created,
MSI-X available, and queue pairs available at the time of VF creation.

Unfortunately the values above exclude 2 queue pairs when only 3 MSI-X
are available to each VF based on resource constraints. The current
calculation would default to 2 MSI-X and 1 queue pair. This is a waste
of resources, so fix this by allowing 2 queue pairs per VF when there
are between 2 and 5 MSI-X available per VF.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 2 ++
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 7061730f0f37..cfdd820e9a2a 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -932,6 +932,8 @@ static int ice_set_per_vf_res(struct ice_pf *pf)
 		num_msix_per_vf = ICE_NUM_VF_MSIX_MED;
 	} else if (msix_avail_per_vf >= ICE_NUM_VF_MSIX_SMALL) {
 		num_msix_per_vf = ICE_NUM_VF_MSIX_SMALL;
+	} else if (msix_avail_per_vf >= ICE_NUM_VF_MSIX_MULTIQ_MIN) {
+		num_msix_per_vf = ICE_NUM_VF_MSIX_MULTIQ_MIN;
 	} else if (msix_avail_per_vf >= ICE_MIN_INTR_PER_VF) {
 		num_msix_per_vf = ICE_MIN_INTR_PER_VF;
 	} else {
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index 049e0b583383..0f519fba3770 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -32,6 +32,7 @@
 #define ICE_MAX_RSS_QS_PER_VF		16
 #define ICE_NUM_VF_MSIX_MED		17
 #define ICE_NUM_VF_MSIX_SMALL		5
+#define ICE_NUM_VF_MSIX_MULTIQ_MIN	3
 #define ICE_MIN_INTR_PER_VF		(ICE_MIN_QS_PER_VF + 1)
 #define ICE_MAX_VF_RESET_TRIES		40
 #define ICE_MAX_VF_RESET_SLEEP_MS	20
-- 
2.26.2

