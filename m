Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 008B83FA0BA
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 22:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231745AbhH0UlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 16:41:25 -0400
Received: from mga12.intel.com ([192.55.52.136]:60752 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231589AbhH0UlP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 16:41:15 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10089"; a="197589405"
X-IronPort-AV: E=Sophos;i="5.84,357,1620716400"; 
   d="scan'208";a="197589405"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2021 13:40:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,357,1620716400"; 
   d="scan'208";a="685587311"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 27 Aug 2021 13:40:20 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        maciej.machnikowski@intel.com,
        Sunitha D Mekala <sunithax.d.mekala@intel.com>
Subject: [PATCH net 4/5] ice: restart periodic outputs around time changes
Date:   Fri, 27 Aug 2021 13:43:57 -0700
Message-Id: <20210827204358.792803-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210827204358.792803-1-anthony.l.nguyen@intel.com>
References: <20210827204358.792803-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

When we enabled auxiliary input/output support for the E810 device, we
forgot to add logic to restart the output when we change time. This is
important as the periodic output will be incorrect after a time change
otherwise.

This unfortunately includes the adjust time function, even though it
uses an atomic hardware interface. The atomic adjustment can still cause
the pin output to stall permanently, so we need to stop and restart it.

Introduce wrapper functions to temporarily disable and then re-enable
the clock outputs.

Fixes: 172db5f91d5f ("ice: add support for auxiliary input/output pins")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Sunitha D Mekala <sunithax.d.mekala@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 49 ++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index ae0980f14c80..05cc5870e4ef 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -688,6 +688,41 @@ static int ice_ptp_cfg_clkout(struct ice_pf *pf, unsigned int chan,
 	return -EFAULT;
 }
 
+/**
+ * ice_ptp_disable_all_clkout - Disable all currently configured outputs
+ * @pf: pointer to the PF structure
+ *
+ * Disable all currently configured clock outputs. This is necessary before
+ * certain changes to the PTP hardware clock. Use ice_ptp_enable_all_clkout to
+ * re-enable the clocks again.
+ */
+static void ice_ptp_disable_all_clkout(struct ice_pf *pf)
+{
+	uint i;
+
+	for (i = 0; i < pf->ptp.info.n_per_out; i++)
+		if (pf->ptp.perout_channels[i].ena)
+			ice_ptp_cfg_clkout(pf, i, NULL, false);
+}
+
+/**
+ * ice_ptp_enable_all_clkout - Enable all configured periodic clock outputs
+ * @pf: pointer to the PF structure
+ *
+ * Enable all currently configured clock outputs. Use this after
+ * ice_ptp_disable_all_clkout to reconfigure the output signals according to
+ * their configuration.
+ */
+static void ice_ptp_enable_all_clkout(struct ice_pf *pf)
+{
+	uint i;
+
+	for (i = 0; i < pf->ptp.info.n_per_out; i++)
+		if (pf->ptp.perout_channels[i].ena)
+			ice_ptp_cfg_clkout(pf, i, &pf->ptp.perout_channels[i],
+					   false);
+}
+
 /**
  * ice_ptp_gpio_enable_e810 - Enable/disable ancillary features of PHC
  * @info: the driver's PTP info structure
@@ -783,12 +818,17 @@ ice_ptp_settime64(struct ptp_clock_info *info, const struct timespec64 *ts)
 		goto exit;
 	}
 
+	/* Disable periodic outputs */
+	ice_ptp_disable_all_clkout(pf);
+
 	err = ice_ptp_write_init(pf, &ts64);
 	ice_ptp_unlock(hw);
 
 	if (!err)
 		ice_ptp_update_cached_phctime(pf);
 
+	/* Reenable periodic outputs */
+	ice_ptp_enable_all_clkout(pf);
 exit:
 	if (err) {
 		dev_err(ice_pf_to_dev(pf), "PTP failed to set time %d\n", err);
@@ -842,8 +882,14 @@ static int ice_ptp_adjtime(struct ptp_clock_info *info, s64 delta)
 		return -EBUSY;
 	}
 
+	/* Disable periodic outputs */
+	ice_ptp_disable_all_clkout(pf);
+
 	err = ice_ptp_write_adj(pf, delta);
 
+	/* Reenable periodic outputs */
+	ice_ptp_enable_all_clkout(pf);
+
 	ice_ptp_unlock(hw);
 
 	if (err) {
@@ -1543,6 +1589,9 @@ void ice_ptp_release(struct ice_pf *pf)
 	if (!pf->ptp.clock)
 		return;
 
+	/* Disable periodic outputs */
+	ice_ptp_disable_all_clkout(pf);
+
 	ice_clear_ptp_clock_index(pf);
 	ptp_clock_unregister(pf->ptp.clock);
 	pf->ptp.clock = NULL;
-- 
2.26.2

