Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA0F468AF
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 22:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbfFNUQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 16:16:00 -0400
Received: from mga06.intel.com ([134.134.136.31]:59942 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726177AbfFNUPz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 16:15:55 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jun 2019 13:15:55 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga004.fm.intel.com with ESMTP; 14 Jun 2019 13:15:54 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Piotr Kwapulinski <piotr.kwapulinski@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 05/12] i40e: Add bounds check for ch[] array
Date:   Fri, 14 Jun 2019 13:16:03 -0700
Message-Id: <20190614201610.13566-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190614201610.13566-1-jeffrey.t.kirsher@intel.com>
References: <20190614201610.13566-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Piotr Kwapulinski <piotr.kwapulinski@intel.com>

Add bounds check for ch[] array.
Use ARRAY_SIZE() to ensure that idx is within the range.

Signed-off-by: Piotr Kwapulinski <piotr.kwapulinski@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 2390bfff7581..c4c71cf7c4d7 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2135,8 +2135,13 @@ static int i40e_vc_config_queues_msg(struct i40e_vf *vf, u8 *msg)
 			}
 		}
 
-		if (vf->adq_enabled)
+		if (vf->adq_enabled) {
+			if (idx >= ARRAY_SIZE(vf->ch)) {
+				aq_ret = I40E_ERR_NO_AVAILABLE_VSI;
+				goto error_param;
+			}
 			vsi_id = vf->ch[idx].vsi_id;
+		}
 
 		if (i40e_config_vsi_rx_queue(vf, vsi_id, vsi_queue_id,
 					     &qpi->rxq) ||
@@ -2152,6 +2157,10 @@ static int i40e_vc_config_queues_msg(struct i40e_vf *vf, u8 *msg)
 		 * to its appropriate VSIs based on TC mapping
 		 **/
 		if (vf->adq_enabled) {
+			if (idx >= ARRAY_SIZE(vf->ch)) {
+				aq_ret = I40E_ERR_NO_AVAILABLE_VSI;
+				goto error_param;
+			}
 			if (j == (vf->ch[idx].num_qps - 1)) {
 				idx++;
 				j = 0; /* resetting the queue count */
-- 
2.21.0

