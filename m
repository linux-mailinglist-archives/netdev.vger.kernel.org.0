Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9D44658C1
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 23:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353268AbhLAWFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 17:05:10 -0500
Received: from mga02.intel.com ([134.134.136.20]:6240 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343505AbhLAWEN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Dec 2021 17:04:13 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10185"; a="223795735"
X-IronPort-AV: E=Sophos;i="5.87,280,1631602800"; 
   d="scan'208";a="223795735"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2021 14:00:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,280,1631602800"; 
   d="scan'208";a="540980332"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 01 Dec 2021 14:00:24 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Norbert Zulinski <norbertx.zulinski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 5/6] i40e: Fix VF failed to init adminq: -53
Date:   Wed,  1 Dec 2021 13:59:13 -0800
Message-Id: <20211201215914.1200153-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211201215914.1200153-1-anthony.l.nguyen@intel.com>
References: <20211201215914.1200153-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Norbert Zulinski <norbertx.zulinski@intel.com>

Fix the problem with init adminq in VF reset handler.
When the PF finished reinitialize VF resource set VFR_VFACTIVE bit
in VF Reset Status register. It is sign for VF driver among others
to shut down and reinitialize the admin queue. VF handle reset procedure
is sampling this register to check every 10ms. PF driver give up to 20ms
to VF reset procedure. For a single VF reset it is enough time to do it
but in case request VF reset twice, the first VF reset can be not
completely finished when PF requests it one more time.
Fixed by adding additional time for VF to finish reset procedure
before sending next VF reset request by PF.

Fixes: 5c3c48ac6bf5 ("i40e: implement virtual device interface")
Signed-off-by: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
Signed-off-by: Norbert Zulinski <norbertx.zulinski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 4 ++++
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 2ea4deb8fc44..8e224b9c1cf3 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -172,6 +172,9 @@ void i40e_vc_notify_vf_reset(struct i40e_vf *vf)
 	    !test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states))
 		return;
 
+	if (ktime_get_ns() - vf->reset_timestamp < I40E_VF_RESET_TIME_MIN)
+		usleep_range(30000, 60000);
+
 	abs_vf_id = vf->vf_id + (int)vf->pf->hw.func_caps.vf_base_id;
 
 	pfe.event = VIRTCHNL_EVENT_RESET_IMPENDING;
@@ -1536,6 +1539,7 @@ bool i40e_reset_vf(struct i40e_vf *vf, bool flr)
 	i40e_cleanup_reset_vf(vf);
 
 	i40e_flush(hw);
+	vf->reset_timestamp = ktime_get_ns();
 	clear_bit(__I40E_VF_DISABLE, pf->state);
 
 	return true;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
index 49575a640a84..6aa35c8c9091 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
@@ -19,6 +19,7 @@
 #define I40E_MAX_VF_PROMISC_FLAGS	3
 
 #define I40E_VF_STATE_WAIT_COUNT	20
+#define I40E_VF_RESET_TIME_MIN		30000000	/* time in nsec */
 
 /* Various queue ctrls */
 enum i40e_queue_ctrl {
@@ -80,6 +81,7 @@ struct i40e_vf {
 	u16 port_vlan_id;
 	bool pf_set_mac;	/* The VMM admin set the VF MAC address */
 	bool trusted;
+	u64 reset_timestamp;
 
 	/* VSI indices - actual VSI pointers are maintained in the PF structure
 	 * When assigned, these will be non-zero, because VSI 0 is always
-- 
2.31.1

