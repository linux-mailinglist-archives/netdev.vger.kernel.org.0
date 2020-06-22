Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4989220436B
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 00:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731007AbgFVWSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 18:18:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:17254 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731044AbgFVWS0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 18:18:26 -0400
IronPort-SDR: salFy4N2jGP7qv/7KLI3C0Ijz6gsUjEAs9rBXI3rKurxmCtZbYXNBCVrkwJa+OPSoKcpdeOGaH
 RHhGhJk37jdg==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="142151167"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="142151167"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 15:18:24 -0700
IronPort-SDR: ik3OOXX7UrwW5HZ24zzebKpDSi7Q43Me6y0Tk95mYqyxO2aKsB/o2gP/MDfMmxS+vYW8ckgiZT
 6Ay8FPI6nFxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="311075840"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 22 Jun 2020 15:18:21 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Qian Cai <cai@lca.pw>, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 9/9] i40e: silence an UBSAN false positive
Date:   Mon, 22 Jun 2020 15:18:17 -0700
Message-Id: <20200622221817.2287549-10-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200622221817.2287549-1-jeffrey.t.kirsher@intel.com>
References: <20200622221817.2287549-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qian Cai <cai@lca.pw>

virtchnl_rss_lut.lut is used for the RSS lookup table, but in
i40e_vc_config_rss_lut(), it is indexed by subscript results in a false
positive.

 UBSAN: array-index-out-of-bounds in drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:2983:15
 index 1 is out of range for type 'u8 [1]'
 CPU: 34 PID: 871 Comm: kworker/34:2 Not tainted 5.7.0-next-20200605+ #5
 Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 03/09/2018
 Workqueue: i40e i40e_service_task [i40e]
 Call Trace:
  dump_stack+0xa7/0xea
  ubsan_epilogue+0x9/0x45
  __ubsan_handle_out_of_bounds+0x6f/0x80
  i40e_vc_process_vf_msg+0x457c/0x4660 [i40e]
  i40e_service_task+0x96c/0x1ab0 [i40e]
  process_one_work+0x57d/0xbd0
  worker_thread+0x63/0x5b0
  kthread+0x20c/0x230
  ret_from_fork+0x22/0x30

Fixes: d510497b8397 ("i40e: add input validation for virtchnl handlers")
Signed-off-by: Qian Cai <cai@lca.pw>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 62132df0527e..5070b3a4b026 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -3018,6 +3018,7 @@ static int i40e_vc_config_rss_lut(struct i40e_vf *vf, u8 *msg)
 	struct i40e_vsi *vsi = NULL;
 	i40e_status aq_ret = 0;
 	u16 i;
+	u8 *lut = vrl->lut;
 
 	if (!test_bit(I40E_VF_STATE_ACTIVE, &vf->vf_states) ||
 	    !i40e_vc_isvalid_vsi_id(vf, vrl->vsi_id) ||
@@ -3027,13 +3028,13 @@ static int i40e_vc_config_rss_lut(struct i40e_vf *vf, u8 *msg)
 	}
 
 	for (i = 0; i < vrl->lut_entries; i++)
-		if (vrl->lut[i] >= vf->num_queue_pairs) {
+		if (lut[i] >= vf->num_queue_pairs) {
 			aq_ret = I40E_ERR_PARAM;
 			goto err;
 		}
 
 	vsi = pf->vsi[vf->lan_vsi_idx];
-	aq_ret = i40e_config_rss(vsi, NULL, vrl->lut, I40E_VF_HLUT_ARRAY_SIZE);
+	aq_ret = i40e_config_rss(vsi, NULL, lut, I40E_VF_HLUT_ARRAY_SIZE);
 	/* send the response to the VF */
 err:
 	return i40e_vc_send_resp_to_vf(vf, VIRTCHNL_OP_CONFIG_RSS_LUT,
-- 
2.26.2

