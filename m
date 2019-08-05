Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 592368251D
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 20:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730395AbfHESzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 14:55:15 -0400
Received: from mga06.intel.com ([134.134.136.31]:43661 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730195AbfHESzC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 14:55:02 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Aug 2019 11:55:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,350,1559545200"; 
   d="scan'208";a="373801231"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga006.fm.intel.com with ESMTP; 05 Aug 2019 11:55:01 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 3/8] i40e: don't report link up for a VF who hasn't enabled queues
Date:   Mon,  5 Aug 2019 11:54:54 -0700
Message-Id: <20190805185459.12846-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190805185459.12846-1-jeffrey.t.kirsher@intel.com>
References: <20190805185459.12846-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Commit d3d657a90850 ("i40e: update VFs of link state after
GET_VF_RESOURCES") modified the PF driver to notify a VF of
its link status immediately after it requests resources.

This was intended to fix reporting on VF drivers, so that they would
properly report link status.

However, some older VF drivers do not respond well to receiving a link
up notification before queues are enabled. This can cause their state
machine to think that it is safe to send traffic. This results in a Tx
hang on the VF.

More recent versions of the old i40evf and all versions of iavf are
resilient to these early link status messages. However, if a VM happens
to run an older version of the VF driver, this can be problematic.

Record whether the PF has actually enabled queues for the VF. When
reporting link status, always report link down if the queues aren't
enabled. In this way, the VF driver will never receive a link up
notification until after its queues are enabled.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 13 ++++++++++++-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h |  1 +
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 02b09a8ad54c..12f04f36e357 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -55,7 +55,12 @@ static void i40e_vc_notify_vf_link_state(struct i40e_vf *vf)
 
 	pfe.event = VIRTCHNL_EVENT_LINK_CHANGE;
 	pfe.severity = PF_EVENT_SEVERITY_INFO;
-	if (vf->link_forced) {
+
+	/* Always report link is down if the VF queues aren't enabled */
+	if (!vf->queues_enabled) {
+		pfe.event_data.link_event.link_status = false;
+		pfe.event_data.link_event.link_speed = 0;
+	} else if (vf->link_forced) {
 		pfe.event_data.link_event.link_status = vf->link_up;
 		pfe.event_data.link_event.link_speed =
 			(vf->link_up ? VIRTCHNL_LINK_SPEED_40GB : 0);
@@ -65,6 +70,7 @@ static void i40e_vc_notify_vf_link_state(struct i40e_vf *vf)
 		pfe.event_data.link_event.link_speed =
 			i40e_virtchnl_link_speed(ls->link_speed);
 	}
+
 	i40e_aq_send_msg_to_vf(hw, abs_vf_id, VIRTCHNL_OP_EVENT,
 			       0, (u8 *)&pfe, sizeof(pfe), NULL);
 }
@@ -2364,6 +2370,8 @@ static int i40e_vc_enable_queues_msg(struct i40e_vf *vf, u8 *msg)
 		}
 	}
 
+	vf->queues_enabled = true;
+
 error_param:
 	/* send the response to the VF */
 	return i40e_vc_send_resp_to_vf(vf, VIRTCHNL_OP_ENABLE_QUEUES,
@@ -2385,6 +2393,9 @@ static int i40e_vc_disable_queues_msg(struct i40e_vf *vf, u8 *msg)
 	struct i40e_pf *pf = vf->pf;
 	i40e_status aq_ret = 0;
 
+	/* Immediately mark queues as disabled */
+	vf->queues_enabled = false;
+
 	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto error_param;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
index f65cc0c16550..7164b9bb294f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
@@ -99,6 +99,7 @@ struct i40e_vf {
 	unsigned int tx_rate;	/* Tx bandwidth limit in Mbps */
 	bool link_forced;
 	bool link_up;		/* only valid if VF link is forced */
+	bool queues_enabled;	/* true if the VF queues are enabled */
 	bool spoofchk;
 	u16 num_mac;
 	u16 num_vlan;
-- 
2.21.0

