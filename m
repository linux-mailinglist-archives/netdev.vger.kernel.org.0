Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06591DF54E
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 08:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387717AbgEWGtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 02:49:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:52994 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387694AbgEWGtD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 May 2020 02:49:03 -0400
IronPort-SDR: q4AbU8noO0sah9bNEnrpudydtdG4Tfru8LM24qB+IWoDuTMGMeiA7QbsolV+h0WKq4iEO3Hg8W
 eOahRUZuD+GA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 23:48:50 -0700
IronPort-SDR: ZQVPv7urnDGN2KMueteOWLKJ70bJZc6toJ6kgG1W0x7e5ASuSbf7tlx5qx4ktODfPrnqvbGomr
 kcLjUrFiR8HA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,424,1583222400"; 
   d="scan'208";a="374966902"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga001.fm.intel.com with ESMTP; 22 May 2020 23:48:50 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Paul Greenwalt <paul.greenwalt@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 10/16] ice: print Rx MDD auto reset message before VF reset
Date:   Fri, 22 May 2020 23:48:41 -0700
Message-Id: <20200523064847.3972158-11-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523064847.3972158-1-jeffrey.t.kirsher@intel.com>
References: <20200523064847.3972158-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Greenwalt <paul.greenwalt@intel.com>

Rx MDD auto reset message was not being logged because logging occurred
after the VF reset and the VF MDD data was reinitialized.

Log the Rx MDD auto reset message before triggering the VF reset.

Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c     |  7 +++++-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 25 ++++++++++++++-----
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |  2 ++
 3 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 220f1bfc6376..bac5a0857c8c 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1322,8 +1322,13 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 			 * PF can be configured to reset the VF through ethtool
 			 * private flag mdd-auto-reset-vf.
 			 */
-			if (test_bit(ICE_FLAG_MDD_AUTO_RESET_VF, pf->flags))
+			if (test_bit(ICE_FLAG_MDD_AUTO_RESET_VF, pf->flags)) {
+				/* VF MDD event counters will be cleared by
+				 * reset, so print the event prior to reset.
+				 */
+				ice_print_vf_rx_mdd_event(vf);
 				ice_reset_vf(&pf->vf[i], false);
+			}
 		}
 	}
 
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 62c100d47592..e9c14d460731 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -3756,6 +3756,24 @@ int ice_get_vf_stats(struct net_device *netdev, int vf_id,
 	return 0;
 }
 
+/**
+ * ice_print_vf_rx_mdd_event - print VF Rx malicious driver detect event
+ * @vf: pointer to the VF structure
+ */
+void ice_print_vf_rx_mdd_event(struct ice_vf *vf)
+{
+	struct ice_pf *pf = vf->pf;
+	struct device *dev;
+
+	dev = ice_pf_to_dev(pf);
+
+	dev_info(dev, "%d Rx Malicious Driver Detection events detected on PF %d VF %d MAC %pM. mdd-auto-reset-vfs=%s\n",
+		 vf->mdd_rx_events.count, pf->hw.pf_id, vf->vf_id,
+		 vf->dflt_lan_addr.addr,
+		 test_bit(ICE_FLAG_MDD_AUTO_RESET_VF, pf->flags)
+			  ? "on" : "off");
+}
+
 /**
  * ice_print_vfs_mdd_event - print VFs malicious driver detect event
  * @pf: pointer to the PF structure
@@ -3785,12 +3803,7 @@ void ice_print_vfs_mdd_events(struct ice_pf *pf)
 		if (vf->mdd_rx_events.count != vf->mdd_rx_events.last_printed) {
 			vf->mdd_rx_events.last_printed =
 							vf->mdd_rx_events.count;
-
-			dev_info(dev, "%d Rx Malicious Driver Detection events detected on PF %d VF %d MAC %pM. mdd-auto-reset-vfs=%s\n",
-				 vf->mdd_rx_events.count, hw->pf_id, i,
-				 vf->dflt_lan_addr.addr,
-				 test_bit(ICE_FLAG_MDD_AUTO_RESET_VF, pf->flags)
-					  ? "on" : "off");
+			ice_print_vf_rx_mdd_event(vf);
 		}
 
 		/* only print Tx MDD event message if there are new events */
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index 474293ff4fe5..0adff89a6749 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -132,6 +132,7 @@ bool ice_is_any_vf_in_promisc(struct ice_pf *pf);
 void
 ice_vf_lan_overflow_event(struct ice_pf *pf, struct ice_rq_event_info *event);
 void ice_print_vfs_mdd_events(struct ice_pf *pf);
+void ice_print_vf_rx_mdd_event(struct ice_vf *vf);
 #else /* CONFIG_PCI_IOV */
 #define ice_process_vflr_event(pf) do {} while (0)
 #define ice_free_vfs(pf) do {} while (0)
@@ -141,6 +142,7 @@ void ice_print_vfs_mdd_events(struct ice_pf *pf);
 #define ice_set_vf_state_qs_dis(vf) do {} while (0)
 #define ice_vf_lan_overflow_event(pf, event) do {} while (0)
 #define ice_print_vfs_mdd_events(pf) do {} while (0)
+#define ice_print_vf_rx_mdd_event(vf) do {} while (0)
 
 static inline bool
 ice_reset_all_vfs(struct ice_pf __always_unused *pf,
-- 
2.26.2

