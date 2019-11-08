Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BEA1F45EB
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 12:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732671AbfKHLia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 06:38:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:51360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732632AbfKHLi3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:38:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E44B620869;
        Fri,  8 Nov 2019 11:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213107;
        bh=qJjbPrjFRY495K0HIO7+KLACd1NUusqk87DGaGw81ZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Depl4+wi6fiqSr5Serr2qoCYWgotSwzIJ/M0EV/3tMQ1Aobr+2hgOu7e5dVvbBgG5
         c3cEmLm60QrOJy95OG320oRfNYzXm9/beBEQrkxa4EbsxPm4YFU1wvR2NjzX1vaC/H
         f/p0VwNHyBuN8SFtH17taIAiqPKqJET65WVScEgw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Nowlin <dan.nowlin@intel.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 030/205] ice: Update request resource command to latest specification
Date:   Fri,  8 Nov 2019 06:34:57 -0500
Message-Id: <20191108113752.12502-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Nowlin <dan.nowlin@intel.com>

[ Upstream commit ff2b13213a6a0baca105bc3bc724225f0adde1f8 ]

Align Request Resource Ownership AQ command (0x0008) to the latest
specification. This includes:

- Correcting the resource IDs for the Global Cfg and Change locks.
- new enum ICE_CHANGE_LOCK_RES_ID
- new enum ICE_GLOBAL_CFG_LOCK_RES_ID
- Altering the flow for Global Config Lock to allow only the first PF to
  download the package.

Signed-off-by: Dan Nowlin <dan.nowlin@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 75 ++++++++++++++++-----
 drivers/net/ethernet/intel/ice/ice_common.h |  2 +-
 drivers/net/ethernet/intel/ice/ice_nvm.c    |  2 +-
 drivers/net/ethernet/intel/ice/ice_type.h   |  9 ++-
 4 files changed, 67 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 661beea6af795..f8d00263d9019 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -904,7 +904,22 @@ enum ice_status ice_aq_q_shutdown(struct ice_hw *hw, bool unloading)
  * @timeout: the maximum time in ms that the driver may hold the resource
  * @cd: pointer to command details structure or NULL
  *
- * requests common resource using the admin queue commands (0x0008)
+ * Requests common resource using the admin queue commands (0x0008).
+ * When attempting to acquire the Global Config Lock, the driver can
+ * learn of three states:
+ *  1) ICE_SUCCESS -        acquired lock, and can perform download package
+ *  2) ICE_ERR_AQ_ERROR -   did not get lock, driver should fail to load
+ *  3) ICE_ERR_AQ_NO_WORK - did not get lock, but another driver has
+ *                          successfully downloaded the package; the driver does
+ *                          not have to download the package and can continue
+ *                          loading
+ *
+ * Note that if the caller is in an acquire lock, perform action, release lock
+ * phase of operation, it is possible that the FW may detect a timeout and issue
+ * a CORER. In this case, the driver will receive a CORER interrupt and will
+ * have to determine its cause. The calling thread that is handling this flow
+ * will likely get an error propagated back to it indicating the Download
+ * Package, Update Package or the Release Resource AQ commands timed out.
  */
 static enum ice_status
 ice_aq_req_res(struct ice_hw *hw, enum ice_aq_res_ids res,
@@ -922,13 +937,43 @@ ice_aq_req_res(struct ice_hw *hw, enum ice_aq_res_ids res,
 	cmd_resp->res_id = cpu_to_le16(res);
 	cmd_resp->access_type = cpu_to_le16(access);
 	cmd_resp->res_number = cpu_to_le32(sdp_number);
+	cmd_resp->timeout = cpu_to_le32(*timeout);
+	*timeout = 0;
 
 	status = ice_aq_send_cmd(hw, &desc, NULL, 0, cd);
+
 	/* The completion specifies the maximum time in ms that the driver
 	 * may hold the resource in the Timeout field.
-	 * If the resource is held by someone else, the command completes with
-	 * busy return value and the timeout field indicates the maximum time
-	 * the current owner of the resource has to free it.
+	 */
+
+	/* Global config lock response utilizes an additional status field.
+	 *
+	 * If the Global config lock resource is held by some other driver, the
+	 * command completes with ICE_AQ_RES_GLBL_IN_PROG in the status field
+	 * and the timeout field indicates the maximum time the current owner
+	 * of the resource has to free it.
+	 */
+	if (res == ICE_GLOBAL_CFG_LOCK_RES_ID) {
+		if (le16_to_cpu(cmd_resp->status) == ICE_AQ_RES_GLBL_SUCCESS) {
+			*timeout = le32_to_cpu(cmd_resp->timeout);
+			return 0;
+		} else if (le16_to_cpu(cmd_resp->status) ==
+			   ICE_AQ_RES_GLBL_IN_PROG) {
+			*timeout = le32_to_cpu(cmd_resp->timeout);
+			return ICE_ERR_AQ_ERROR;
+		} else if (le16_to_cpu(cmd_resp->status) ==
+			   ICE_AQ_RES_GLBL_DONE) {
+			return ICE_ERR_AQ_NO_WORK;
+		}
+
+		/* invalid FW response, force a timeout immediately */
+		*timeout = 0;
+		return ICE_ERR_AQ_ERROR;
+	}
+
+	/* If the resource is held by some other driver, the command completes
+	 * with a busy return value and the timeout field indicates the maximum
+	 * time the current owner of the resource has to free it.
 	 */
 	if (!status || hw->adminq.sq_last_status == ICE_AQ_RC_EBUSY)
 		*timeout = le32_to_cpu(cmd_resp->timeout);
@@ -967,30 +1012,28 @@ ice_aq_release_res(struct ice_hw *hw, enum ice_aq_res_ids res, u8 sdp_number,
  * @hw: pointer to the HW structure
  * @res: resource id
  * @access: access type (read or write)
+ * @timeout: timeout in milliseconds
  *
  * This function will attempt to acquire the ownership of a resource.
  */
 enum ice_status
 ice_acquire_res(struct ice_hw *hw, enum ice_aq_res_ids res,
-		enum ice_aq_res_access_type access)
+		enum ice_aq_res_access_type access, u32 timeout)
 {
 #define ICE_RES_POLLING_DELAY_MS	10
 	u32 delay = ICE_RES_POLLING_DELAY_MS;
+	u32 time_left = timeout;
 	enum ice_status status;
-	u32 time_left = 0;
-	u32 timeout;
 
 	status = ice_aq_req_res(hw, res, access, 0, &time_left, NULL);
 
-	/* An admin queue return code of ICE_AQ_RC_EEXIST means that another
-	 * driver has previously acquired the resource and performed any
-	 * necessary updates; in this case the caller does not obtain the
-	 * resource and has no further work to do.
+	/* A return code of ICE_ERR_AQ_NO_WORK means that another driver has
+	 * previously acquired the resource and performed any necessary updates;
+	 * in this case the caller does not obtain the resource and has no
+	 * further work to do.
 	 */
-	if (hw->adminq.sq_last_status == ICE_AQ_RC_EEXIST) {
-		status = ICE_ERR_AQ_NO_WORK;
+	if (status == ICE_ERR_AQ_NO_WORK)
 		goto ice_acquire_res_exit;
-	}
 
 	if (status)
 		ice_debug(hw, ICE_DBG_RES,
@@ -1003,11 +1046,9 @@ ice_acquire_res(struct ice_hw *hw, enum ice_aq_res_ids res,
 		timeout = (timeout > delay) ? timeout - delay : 0;
 		status = ice_aq_req_res(hw, res, access, 0, &time_left, NULL);
 
-		if (hw->adminq.sq_last_status == ICE_AQ_RC_EEXIST) {
+		if (status == ICE_ERR_AQ_NO_WORK)
 			/* lock free, but no work to do */
-			status = ICE_ERR_AQ_NO_WORK;
 			break;
-		}
 
 		if (!status)
 			/* lock acquired */
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index 9a5519130af13..6455b6952ec8e 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -23,7 +23,7 @@ enum ice_status
 ice_get_link_status(struct ice_port_info *pi, bool *link_up);
 enum ice_status
 ice_acquire_res(struct ice_hw *hw, enum ice_aq_res_ids res,
-		enum ice_aq_res_access_type access);
+		enum ice_aq_res_access_type access, u32 timeout);
 void ice_release_res(struct ice_hw *hw, enum ice_aq_res_ids res);
 enum ice_status ice_init_nvm(struct ice_hw *hw);
 enum ice_status
diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index 295a8cd87fc16..3274c543283c6 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.c
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
@@ -137,7 +137,7 @@ ice_acquire_nvm(struct ice_hw *hw, enum ice_aq_res_access_type access)
 	if (hw->nvm.blank_nvm_mode)
 		return 0;
 
-	return ice_acquire_res(hw, ICE_NVM_RES_ID, access);
+	return ice_acquire_res(hw, ICE_NVM_RES_ID, access, ICE_NVM_TIMEOUT);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index ba11b58988331..a509fe5f1e543 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -34,10 +34,15 @@ static inline bool ice_is_tc_ena(u8 bitmap, u8 tc)
 enum ice_aq_res_ids {
 	ICE_NVM_RES_ID = 1,
 	ICE_SPD_RES_ID,
-	ICE_GLOBAL_CFG_LOCK_RES_ID,
-	ICE_CHANGE_LOCK_RES_ID
+	ICE_CHANGE_LOCK_RES_ID,
+	ICE_GLOBAL_CFG_LOCK_RES_ID
 };
 
+/* FW update timeout definitions are in milliseconds */
+#define ICE_NVM_TIMEOUT			180000
+#define ICE_CHANGE_LOCK_TIMEOUT		1000
+#define ICE_GLOBAL_CFG_LOCK_TIMEOUT	3000
+
 enum ice_aq_res_access_type {
 	ICE_RES_READ = 1,
 	ICE_RES_WRITE
-- 
2.20.1

