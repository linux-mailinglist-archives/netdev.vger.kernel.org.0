Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF922F3B27
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 23:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727626AbfKGWOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 17:14:48 -0500
Received: from mga07.intel.com ([134.134.136.100]:16692 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727560AbfKGWOr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 17:14:47 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Nov 2019 14:14:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,279,1569308400"; 
   d="scan'208";a="233420941"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga002.fm.intel.com with ESMTP; 07 Nov 2019 14:14:45 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 15/15] ice: print opcode when printing controlq errors
Date:   Thu,  7 Nov 2019 14:14:38 -0800
Message-Id: <20191107221438.17994-16-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191107221438.17994-1-jeffrey.t.kirsher@intel.com>
References: <20191107221438.17994-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

To help aid in debugging, display the command opcode in debug messages
that print an error code. This makes it easier to see what command
failed if only ICE_DBG_AQ_MSG is enabled.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_controlq.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_controlq.c b/drivers/net/ethernet/intel/ice/ice_controlq.c
index 947728aada46..dd946866d7b8 100644
--- a/drivers/net/ethernet/intel/ice/ice_controlq.c
+++ b/drivers/net/ethernet/intel/ice/ice_controlq.c
@@ -1017,7 +1017,8 @@ ice_sq_send_cmd(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 		retval = le16_to_cpu(desc->retval);
 		if (retval) {
 			ice_debug(hw, ICE_DBG_AQ_MSG,
-				  "Control Send Queue command completed with error 0x%x\n",
+				  "Control Send Queue command 0x%04X completed with error 0x%X\n",
+				  le16_to_cpu(desc->opcode),
 				  retval);
 
 			/* strip off FW internal code */
@@ -1121,7 +1122,8 @@ ice_clean_rq_elem(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 	if (flags & ICE_AQ_FLAG_ERR) {
 		ret_code = ICE_ERR_AQ_ERROR;
 		ice_debug(hw, ICE_DBG_AQ_MSG,
-			  "Control Receive Queue Event received with error 0x%x\n",
+			  "Control Receive Queue Event 0x%04X received with error 0x%X\n",
+			  le16_to_cpu(desc->opcode),
 			  cq->rq_last_status);
 	}
 	memcpy(&e->desc, desc, sizeof(e->desc));
-- 
2.21.0

