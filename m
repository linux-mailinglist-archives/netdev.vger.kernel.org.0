Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE213080A4
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 22:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbhA1Vjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 16:39:39 -0500
Received: from mga12.intel.com ([192.55.52.136]:19348 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231531AbhA1Vj1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 16:39:27 -0500
IronPort-SDR: 3w4A+YIVuC9mG/QbvQLm/zQqSTarY74WQwxiHiTqmsDqQoleU0ljGXhTMifylMk7kJh6hP43KX
 NScgGVJ0bvJA==
X-IronPort-AV: E=McAfee;i="6000,8403,9878"; a="159491179"
X-IronPort-AV: E=Sophos;i="5.79,383,1602572400"; 
   d="scan'208";a="159491179"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 13:38:21 -0800
IronPort-SDR: SJr3AYAEnVqd4j/suAaS+uOv7LH9bj/EQTqugE4ni/IFyyyWkJh53gdfDbUpbgcFA72TTxMIp8
 rIaICtuUGRlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,383,1602572400"; 
   d="scan'208";a="474241016"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 28 Jan 2021 13:38:20 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 4/4] i40e: Revert "i40e: don't report link up for a VF who hasn't enabled queues"
Date:   Thu, 28 Jan 2021 13:38:51 -0800
Message-Id: <20210128213851.2499012-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210128213851.2499012-1-anthony.l.nguyen@intel.com>
References: <20210128213851.2499012-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

This reverts commit 2ad1274fa35ace5c6360762ba48d33b63da2396c

VF queues were not brought up when PF was brought up after being
downed if the VF driver disabled VFs queues during PF down.
This could happen in some older or external VF driver implementations.
The problem was that PF driver used vf->queues_enabled as a condition
to decide what link-state it would send out which caused the issue.

Remove the check for vf->queues_enabled in the VF link notify.
Now VF will always be notified of the current link status.
Also remove the queues_enabled member from i40e_vf structure as it is
not used anymore. Otherwise VNF implementation was broken and caused
a link flap.

Fixes: 2ad1274fa35a ("i40e: don't report link up for a VF who hasn't enabled")
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 13 +------------
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h |  1 -
 2 files changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 7efc61aacb0a..1b6ec9be155a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -55,12 +55,7 @@ static void i40e_vc_notify_vf_link_state(struct i40e_vf *vf)
 
 	pfe.event = VIRTCHNL_EVENT_LINK_CHANGE;
 	pfe.severity = PF_EVENT_SEVERITY_INFO;
-
-	/* Always report link is down if the VF queues aren't enabled */
-	if (!vf->queues_enabled) {
-		pfe.event_data.link_event.link_status = false;
-		pfe.event_data.link_event.link_speed = 0;
-	} else if (vf->link_forced) {
+	if (vf->link_forced) {
 		pfe.event_data.link_event.link_status = vf->link_up;
 		pfe.event_data.link_event.link_speed =
 			(vf->link_up ? i40e_virtchnl_link_speed(ls->link_speed) : 0);
@@ -70,7 +65,6 @@ static void i40e_vc_notify_vf_link_state(struct i40e_vf *vf)
 		pfe.event_data.link_event.link_speed =
 			i40e_virtchnl_link_speed(ls->link_speed);
 	}
-
 	i40e_aq_send_msg_to_vf(hw, abs_vf_id, VIRTCHNL_OP_EVENT,
 			       0, (u8 *)&pfe, sizeof(pfe), NULL);
 }
@@ -2443,8 +2437,6 @@ static int i40e_vc_enable_queues_msg(struct i40e_vf *vf, u8 *msg)
 		}
 	}
 
-	vf->queues_enabled = true;
-
 error_param:
 	/* send the response to the VF */
 	return i40e_vc_send_resp_to_vf(vf, VIRTCHNL_OP_ENABLE_QUEUES,
@@ -2466,9 +2458,6 @@ static int i40e_vc_disable_queues_msg(struct i40e_vf *vf, u8 *msg)
 	struct i40e_pf *pf = vf->pf;
 	i40e_status aq_ret = 0;
 
-	/* Immediately mark queues as disabled */
-	vf->queues_enabled = false;
-
 	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto error_param;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
index 5491215d81de..091e32c1bb46 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
@@ -98,7 +98,6 @@ struct i40e_vf {
 	unsigned int tx_rate;	/* Tx bandwidth limit in Mbps */
 	bool link_forced;
 	bool link_up;		/* only valid if VF link is forced */
-	bool queues_enabled;	/* true if the VF queues are enabled */
 	bool spoofchk;
 	u16 num_vlan;
 
-- 
2.26.2

