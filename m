Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2100511605
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 11:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbfEBJG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 05:06:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:47594 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726001AbfEBJGX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 05:06:23 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 May 2019 02:06:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,421,1549958400"; 
   d="scan'208";a="147615334"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 02 May 2019 02:06:22 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Akeem G Abodunrin <akeem.g.abodunrin@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 02/15] ice: Return configuration error without queue to disable
Date:   Thu,  2 May 2019 02:06:07 -0700
Message-Id: <20190502090620.21281-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190502090620.21281-1-jeffrey.t.kirsher@intel.com>
References: <20190502090620.21281-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>

If there is no queue to disable, return appropriate configuration error
earlier without acquiring the lock.

Signed-off-by: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index dce07882f7e1..1d25a4230308 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -2932,14 +2932,17 @@ ice_dis_vsi_txq(struct ice_port_info *pi, u16 vsi_handle, u8 tc, u8 num_queues,
 	if (!pi || pi->port_state != ICE_SCHED_PORT_STATE_READY)
 		return ICE_ERR_CFG;
 
-	/* if queue is disabled already yet the disable queue command has to be
-	 * sent to complete the VF reset, then call ice_aq_dis_lan_txq without
-	 * any queue information
-	 */
 
-	if (!num_queues && rst_src)
-		return ice_aq_dis_lan_txq(pi->hw, 0, NULL, 0, rst_src, vmvf_num,
-					  NULL);
+	if (!num_queues) {
+		/* if queue is disabled already yet the disable queue command
+		 * has to be sent to complete the VF reset, then call
+		 * ice_aq_dis_lan_txq without any queue information
+		 */
+		if (rst_src)
+			return ice_aq_dis_lan_txq(pi->hw, 0, NULL, 0, rst_src,
+						  vmvf_num, NULL);
+		return ICE_ERR_CFG;
+	}
 
 	mutex_lock(&pi->sched_lock);
 
-- 
2.20.1

