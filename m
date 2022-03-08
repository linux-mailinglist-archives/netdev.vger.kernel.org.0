Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB1244D1F33
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 18:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344672AbiCHRiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 12:38:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345761AbiCHRiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 12:38:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D301655743
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 09:37:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6034C61309
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 17:37:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D656C340EB;
        Tue,  8 Mar 2022 17:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646761023;
        bh=fy7ad6pd0VTjILc4G79+WQ2C6j7izuJMJojWG7NkW0U=;
        h=From:To:Cc:Subject:Date:From;
        b=Xs1NysVzfnVEcMSp6ku8Pv6IHd5920uhudiCT+rK79jB2YmCd1XFdGmMsSRn/LyXD
         2UQmf0ywmkKemN+CQ4Z4Ev1bf16iSwGaBnCqq9cb0qouzPPlYrupPP3J7OUn6EBKi5
         JmaKqUyCUf7EP6PkZxhW8nUBAO8Dcm4Do+jJJir7dv+c/y8odCKJOatkzbxw9jsyHO
         QUgQxdSarEz8UkBi9bYYFKnhJtzdTrnXMSrYZn69Wo4zfrR/QSHaClVRRCOAUDwZQV
         C/hxO8jVxiQ7QsOmHb54mzoO5prfAW7JAr3GlvReA6xSTtHJ4QMHQFYIlnPrkt51fY
         qpbelYa9VdoBw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] bnxt: revert hastily merged uAPI aberrations
Date:   Tue,  8 Mar 2022 09:36:59 -0800
Message-Id: <20220308173659.304915-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts:
 commit 02acd399533e ("bnxt_en: parse result field when NVRAM package install fails")
 commit 22f5dba5065d ("bnxt_en: add an nvm test for hw diagnose")
 commit bafed3f231f7 ("bnxt_en: implement hw health reporter")

These patches are still under discussion / I don't think they
are right, and since the authors don't reply promptly let me
lessen my load of "things I need to resolve before next release"
and revert them.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  19 ---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  45 ------
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c | 153 ------------------
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.h |   1 -
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  66 ++------
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.h |   7 -
 6 files changed, 14 insertions(+), 277 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 63b8fc4f9d42..2de02950086f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2061,22 +2061,6 @@ static void bnxt_event_error_report(struct bnxt *bp, u32 data1, u32 data2)
 	case ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_EVENT_DATA1_ERROR_TYPE_DOORBELL_DROP_THRESHOLD:
 		netdev_warn(bp->dev, "One or more MMIO doorbells dropped by the device!\n");
 		break;
-	case ASYNC_EVENT_CMPL_ERROR_REPORT_BASE_EVENT_DATA1_ERROR_TYPE_NVM: {
-		struct bnxt_hw_health *hw_health = &bp->hw_health;
-
-		hw_health->nvm_err_address = EVENT_DATA2_NVM_ERR_ADDR(data2);
-		if (EVENT_DATA1_NVM_ERR_TYPE_WRITE(data1)) {
-			hw_health->synd = BNXT_HW_STATUS_NVM_WRITE_ERR;
-			hw_health->nvm_write_errors++;
-		} else if (EVENT_DATA1_NVM_ERR_TYPE_ERASE(data1)) {
-			hw_health->synd = BNXT_HW_STATUS_NVM_ERASE_ERR;
-			hw_health->nvm_erase_errors++;
-		} else {
-			hw_health->synd = BNXT_HW_STATUS_NVM_UNKNOWN_ERR;
-		}
-		set_bit(BNXT_FW_NVM_ERR_SP_EVENT, &bp->sp_event);
-		break;
-	}
 	default:
 		netdev_err(bp->dev, "FW reported unknown error type %u\n",
 			   err_type);
@@ -11903,9 +11887,6 @@ static void bnxt_sp_task(struct work_struct *work)
 	if (test_and_clear_bit(BNXT_FW_ECHO_REQUEST_SP_EVENT, &bp->sp_event))
 		bnxt_fw_echo_reply(bp);
 
-	if (test_and_clear_bit(BNXT_FW_NVM_ERR_SP_EVENT, &bp->sp_event))
-		bnxt_devlink_health_hw_report(bp);
-
 	/* These functions below will clear BNXT_STATE_IN_SP_TASK.  They
 	 * must be the last functions to be called before exiting.
 	 */
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 9dd878def3c2..447a9406b8a2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -516,21 +516,6 @@ struct rx_tpa_end_cmp_ext {
 	  ASYNC_EVENT_CMPL_ERROR_REPORT_INVALID_SIGNAL_EVENT_DATA2_PIN_ID_MASK) >>\
 	 ASYNC_EVENT_CMPL_ERROR_REPORT_INVALID_SIGNAL_EVENT_DATA2_PIN_ID_SFT)
 
-#define EVENT_DATA2_NVM_ERR_ADDR(data2)					\
-	(((data2) &							\
-	  ASYNC_EVENT_CMPL_ERROR_REPORT_NVM_EVENT_DATA2_ERR_ADDR_MASK) >>\
-	 ASYNC_EVENT_CMPL_ERROR_REPORT_NVM_EVENT_DATA2_ERR_ADDR_SFT)
-
-#define EVENT_DATA1_NVM_ERR_TYPE_WRITE(data1)				\
-	(((data1) &							\
-	  ASYNC_EVENT_CMPL_ERROR_REPORT_NVM_EVENT_DATA1_NVM_ERR_TYPE_MASK) ==\
-	 ASYNC_EVENT_CMPL_ERROR_REPORT_NVM_EVENT_DATA1_NVM_ERR_TYPE_WRITE)
-
-#define EVENT_DATA1_NVM_ERR_TYPE_ERASE(data1)				\
-	(((data1) &							\
-	  ASYNC_EVENT_CMPL_ERROR_REPORT_NVM_EVENT_DATA1_NVM_ERR_TYPE_MASK) ==\
-	 ASYNC_EVENT_CMPL_ERROR_REPORT_NVM_EVENT_DATA1_NVM_ERR_TYPE_ERASE)
-
 struct nqe_cn {
 	__le16	type;
 	#define NQ_CN_TYPE_MASK           0x3fUL
@@ -1543,33 +1528,6 @@ struct bnxt_ctx_mem_info {
 	struct bnxt_mem_init	mem_init[BNXT_CTX_MEM_INIT_MAX];
 };
 
-enum bnxt_hw_err {
-	BNXT_HW_STATUS_HEALTHY			= 0x0,
-	BNXT_HW_STATUS_NVM_WRITE_ERR		= 0x1,
-	BNXT_HW_STATUS_NVM_ERASE_ERR		= 0x2,
-	BNXT_HW_STATUS_NVM_UNKNOWN_ERR		= 0x3,
-	BNXT_HW_STATUS_NVM_TEST_VPD_ENT_ERR	= 0x4,
-	BNXT_HW_STATUS_NVM_TEST_VPD_READ_ERR	= 0x5,
-	BNXT_HW_STATUS_NVM_TEST_VPD_WRITE_ERR	= 0x6,
-	BNXT_HW_STATUS_NVM_TEST_INCMPL_ERR	= 0x7,
-};
-
-struct bnxt_hw_health {
-	u32 nvm_err_address;
-	u32 nvm_write_errors;
-	u32 nvm_erase_errors;
-	u32 nvm_test_vpd_ent_errors;
-	u32 nvm_test_vpd_read_errors;
-	u32 nvm_test_vpd_write_errors;
-	u32 nvm_test_incmpl_errors;
-	u8 synd;
-	/* max a test in a day if previous test was successful */
-#define HW_RETEST_MIN_TIME	(1000 * 3600 * 24)
-	u8 nvm_test_result;
-	unsigned long nvm_test_timestamp;
-	struct devlink_health_reporter *hw_reporter;
-};
-
 enum bnxt_health_severity {
 	SEVERITY_NORMAL = 0,
 	SEVERITY_WARNING,
@@ -2087,7 +2045,6 @@ struct bnxt {
 #define BNXT_FW_EXCEPTION_SP_EVENT	19
 #define BNXT_LINK_CFG_CHANGE_SP_EVENT	21
 #define BNXT_FW_ECHO_REQUEST_SP_EVENT	23
-#define BNXT_FW_NVM_ERR_SP_EVENT	25
 
 	struct delayed_work	fw_reset_task;
 	int			fw_reset_state;
@@ -2188,8 +2145,6 @@ struct bnxt {
 	struct dentry		*debugfs_pdev;
 	struct device		*hwmon_dev;
 	enum board_idx		board_idx;
-
-	struct bnxt_hw_health	hw_health;
 };
 
 #define BNXT_NUM_RX_RING_STATS			8
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 77e55105d645..0c17f90d44a2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -20,7 +20,6 @@
 #include "bnxt_ulp.h"
 #include "bnxt_ptp.h"
 #include "bnxt_coredump.h"
-#include "bnxt_nvm_defs.h"	/* NVRAM content constant and structure defs */
 
 static void __bnxt_fw_recover(struct bnxt *bp)
 {
@@ -242,148 +241,6 @@ static const struct devlink_health_reporter_ops bnxt_dl_fw_reporter_ops = {
 	.recover = bnxt_fw_recover,
 };
 
-static int bnxt_hw_recover(struct devlink_health_reporter *reporter,
-			   void *priv_ctx,
-			   struct netlink_ext_ack *extack)
-{
-	struct bnxt *bp = devlink_health_reporter_priv(reporter);
-	struct bnxt_hw_health *hw_health = &bp->hw_health;
-
-	hw_health->synd = BNXT_HW_STATUS_HEALTHY;
-	return 0;
-}
-
-static const char *hw_err_str(u8 synd)
-{
-	switch (synd) {
-	case BNXT_HW_STATUS_HEALTHY:
-		return "healthy";
-	case BNXT_HW_STATUS_NVM_WRITE_ERR:
-		return "nvm write error";
-	case BNXT_HW_STATUS_NVM_ERASE_ERR:
-		return "nvm erase error";
-	case BNXT_HW_STATUS_NVM_UNKNOWN_ERR:
-		return "unrecognized nvm error";
-	case BNXT_HW_STATUS_NVM_TEST_VPD_ENT_ERR:
-		return "nvm test vpd entry error";
-	case BNXT_HW_STATUS_NVM_TEST_VPD_READ_ERR:
-		return "nvm test vpd read error";
-	case BNXT_HW_STATUS_NVM_TEST_VPD_WRITE_ERR:
-		return "nvm test vpd write error";
-	case BNXT_HW_STATUS_NVM_TEST_INCMPL_ERR:
-		return "nvm test incomplete error";
-	default:
-		return "unknown hw error";
-	}
-}
-
-static void bnxt_nvm_test(struct bnxt *bp)
-{
-	struct bnxt_hw_health *h = &bp->hw_health;
-	u32 datalen;
-	u16 index;
-	u8 *buf;
-
-	if (!h->nvm_test_result) {
-		if (!h->nvm_test_timestamp ||
-		    time_after(jiffies, h->nvm_test_timestamp +
-					msecs_to_jiffies(HW_RETEST_MIN_TIME)))
-			h->nvm_test_timestamp = jiffies;
-		else
-			return;
-	}
-
-	if (bnxt_find_nvram_item(bp->dev, BNX_DIR_TYPE_VPD,
-				 BNX_DIR_ORDINAL_FIRST, BNX_DIR_EXT_NONE,
-				 &index, NULL, &datalen) || !datalen) {
-		h->nvm_test_result = BNXT_HW_STATUS_NVM_TEST_VPD_ENT_ERR;
-		h->nvm_test_vpd_ent_errors++;
-		return;
-	}
-
-	buf = kzalloc(datalen, GFP_KERNEL);
-	if (!buf) {
-		h->nvm_test_result = BNXT_HW_STATUS_NVM_TEST_INCMPL_ERR;
-		h->nvm_test_incmpl_errors++;
-		return;
-	}
-
-	if (bnxt_get_nvram_item(bp->dev, index, 0, datalen, buf)) {
-		h->nvm_test_result = BNXT_HW_STATUS_NVM_TEST_VPD_READ_ERR;
-		h->nvm_test_vpd_read_errors++;
-		goto err;
-	}
-
-	if (bnxt_flash_nvram(bp->dev, BNX_DIR_TYPE_VPD, BNX_DIR_ORDINAL_FIRST,
-			     BNX_DIR_EXT_NONE, 0, 0, buf, datalen)) {
-		h->nvm_test_result = BNXT_HW_STATUS_NVM_TEST_VPD_WRITE_ERR;
-		h->nvm_test_vpd_write_errors++;
-	}
-
-err:
-	kfree(buf);
-}
-
-static int bnxt_hw_diagnose(struct devlink_health_reporter *reporter,
-			    struct devlink_fmsg *fmsg,
-			    struct netlink_ext_ack *extack)
-{
-	struct bnxt *bp = devlink_health_reporter_priv(reporter);
-	struct bnxt_hw_health *h = &bp->hw_health;
-	u8 synd = h->synd;
-	int rc;
-
-	bnxt_nvm_test(bp);
-	if (h->nvm_test_result) {
-		synd = h->nvm_test_result;
-		devlink_health_report(h->hw_reporter, hw_err_str(synd), NULL);
-	}
-
-	rc = devlink_fmsg_string_pair_put(fmsg, "Status", hw_err_str(synd));
-	if (rc)
-		return rc;
-	rc = devlink_fmsg_u32_pair_put(fmsg, "nvm_write_errors", h->nvm_write_errors);
-	if (rc)
-		return rc;
-	rc = devlink_fmsg_u32_pair_put(fmsg, "nvm_erase_errors", h->nvm_erase_errors);
-	if (rc)
-		return rc;
-	rc = devlink_fmsg_u32_pair_put(fmsg, "nvm_test_vpd_ent_errors",
-				       h->nvm_test_vpd_ent_errors);
-	if (rc)
-		return rc;
-	rc = devlink_fmsg_u32_pair_put(fmsg, "nvm_test_vpd_read_errors",
-				       h->nvm_test_vpd_read_errors);
-	if (rc)
-		return rc;
-	rc = devlink_fmsg_u32_pair_put(fmsg, "nvm_test_vpd_write_errors",
-				       h->nvm_test_vpd_write_errors);
-	if (rc)
-		return rc;
-	rc = devlink_fmsg_u32_pair_put(fmsg, "nvm_test_incomplete_errors",
-				       h->nvm_test_incmpl_errors);
-	if (rc)
-		return rc;
-
-	return 0;
-}
-
-void bnxt_devlink_health_hw_report(struct bnxt *bp)
-{
-	struct bnxt_hw_health *hw_health = &bp->hw_health;
-
-	netdev_warn(bp->dev, "%s reported at address 0x%x\n", hw_err_str(hw_health->synd),
-		    hw_health->nvm_err_address);
-
-	devlink_health_report(hw_health->hw_reporter, hw_err_str(hw_health->synd), NULL);
-}
-
-static const struct devlink_health_reporter_ops bnxt_dl_hw_reporter_ops = {
-	.name = "hw",
-	.diagnose = bnxt_hw_diagnose,
-	.recover = bnxt_hw_recover,
-};
-
 static struct devlink_health_reporter *
 __bnxt_dl_reporter_create(struct bnxt *bp,
 			  const struct devlink_health_reporter_ops *ops)
@@ -403,10 +260,6 @@ __bnxt_dl_reporter_create(struct bnxt *bp,
 void bnxt_dl_fw_reporters_create(struct bnxt *bp)
 {
 	struct bnxt_fw_health *fw_health = bp->fw_health;
-	struct bnxt_hw_health *hw_health = &bp->hw_health;
-
-	if (!hw_health->hw_reporter)
-		hw_health->hw_reporter = __bnxt_dl_reporter_create(bp, &bnxt_dl_hw_reporter_ops);
 
 	if (fw_health && !fw_health->fw_reporter)
 		fw_health->fw_reporter = __bnxt_dl_reporter_create(bp, &bnxt_dl_fw_reporter_ops);
@@ -415,12 +268,6 @@ void bnxt_dl_fw_reporters_create(struct bnxt *bp)
 void bnxt_dl_fw_reporters_destroy(struct bnxt *bp)
 {
 	struct bnxt_fw_health *fw_health = bp->fw_health;
-	struct bnxt_hw_health *hw_health = &bp->hw_health;
-
-	if (hw_health->hw_reporter) {
-		devlink_health_reporter_destroy(hw_health->hw_reporter);
-		hw_health->hw_reporter = NULL;
-	}
 
 	if (fw_health && fw_health->fw_reporter) {
 		devlink_health_reporter_destroy(fw_health->fw_reporter);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
index 056962e4b177..b8105065367b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
@@ -74,7 +74,6 @@ enum bnxt_dl_version_type {
 void bnxt_devlink_health_fw_report(struct bnxt *bp);
 void bnxt_dl_health_fw_status_update(struct bnxt *bp, bool healthy);
 void bnxt_dl_health_fw_recovery_done(struct bnxt *bp);
-void bnxt_devlink_health_hw_report(struct bnxt *bp);
 void bnxt_dl_fw_reporters_create(struct bnxt *bp);
 void bnxt_dl_fw_reporters_destroy(struct bnxt *bp);
 int bnxt_dl_register(struct bnxt *bp);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 178074795b27..22e965e18fbc 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2168,10 +2168,14 @@ static void bnxt_print_admin_err(struct bnxt *bp)
 	netdev_info(bp->dev, "PF does not have admin privileges to flash or reset the device\n");
 }
 
-int bnxt_flash_nvram(struct net_device *dev, u16 dir_type,
-		     u16 dir_ordinal, u16 dir_ext, u16 dir_attr,
-		     u32 dir_item_len, const u8 *data,
-		     size_t data_len)
+static int bnxt_find_nvram_item(struct net_device *dev, u16 type, u16 ordinal,
+				u16 ext, u16 *index, u32 *item_length,
+				u32 *data_length);
+
+static int bnxt_flash_nvram(struct net_device *dev, u16 dir_type,
+			    u16 dir_ordinal, u16 dir_ext, u16 dir_attr,
+			    u32 dir_item_len, const u8 *data,
+			    size_t data_len)
 {
 	struct bnxt *bp = netdev_priv(dev);
 	struct hwrm_nvm_write_input *req;
@@ -2495,48 +2499,6 @@ static int bnxt_flash_firmware_from_file(struct net_device *dev,
 	return rc;
 }
 
-static int nvm_update_err_to_stderr(struct net_device *dev, u8 result)
-{
-	switch (result) {
-	case NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_TYPE_PARAMETER:
-	case NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_INDEX_PARAMETER:
-	case NVM_INSTALL_UPDATE_RESP_RESULT_INSTALL_DATA_ERROR:
-	case NVM_INSTALL_UPDATE_RESP_RESULT_INSTALL_CHECKSUM_ERROR:
-	case NVM_INSTALL_UPDATE_RESP_RESULT_ITEM_NOT_FOUND:
-	case NVM_INSTALL_UPDATE_RESP_RESULT_ITEM_LOCKED:
-		netdev_err(dev, "PKG install error : Data integrity on NVM\n");
-		return -EINVAL;
-	case NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_PREREQUISITE:
-	case NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_FILE_HEADER:
-	case NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_SIGNATURE:
-	case NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_PROP_STREAM:
-	case NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_PROP_LENGTH:
-	case NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_MANIFEST:
-	case NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_TRAILER:
-	case NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_CHECKSUM:
-	case NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_ITEM_CHECKSUM:
-	case NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_DATA_LENGTH:
-	case NVM_INSTALL_UPDATE_RESP_RESULT_INVALID_DIRECTIVE:
-	case NVM_INSTALL_UPDATE_RESP_RESULT_DUPLICATE_ITEM:
-	case NVM_INSTALL_UPDATE_RESP_RESULT_ZERO_LENGTH_ITEM:
-		netdev_err(dev, "PKG install error : Invalid package\n");
-		return -ENOPKG;
-	case NVM_INSTALL_UPDATE_RESP_RESULT_INSTALL_AUTHENTICATION_ERROR:
-		netdev_err(dev, "PKG install error : Authentication error\n");
-		return -EPERM;
-	case NVM_INSTALL_UPDATE_RESP_RESULT_UNSUPPORTED_CHIP_REV:
-	case NVM_INSTALL_UPDATE_RESP_RESULT_UNSUPPORTED_DEVICE_ID:
-	case NVM_INSTALL_UPDATE_RESP_RESULT_UNSUPPORTED_SUBSYS_VENDOR:
-	case NVM_INSTALL_UPDATE_RESP_RESULT_UNSUPPORTED_SUBSYS_ID:
-	case NVM_INSTALL_UPDATE_RESP_RESULT_UNSUPPORTED_PLATFORM:
-		netdev_err(dev, "PKG install error : Invalid device\n");
-		return -EOPNOTSUPP;
-	default:
-		netdev_err(dev, "PKG install error : Internal error\n");
-		return -EIO;
-	}
-}
-
 #define BNXT_PKG_DMA_SIZE	0x40000
 #define BNXT_NVM_MORE_FLAG	(cpu_to_le16(NVM_MODIFY_REQ_FLAGS_BATCH_MODE))
 #define BNXT_NVM_LAST_FLAG	(cpu_to_le16(NVM_MODIFY_REQ_FLAGS_BATCH_LAST))
@@ -2691,7 +2653,7 @@ int bnxt_flash_package_from_fw_obj(struct net_device *dev, const struct firmware
 	if (resp->result) {
 		netdev_err(dev, "PKG install error = %d, problem_item = %d\n",
 			   (s8)resp->result, (int)resp->problem_item);
-		rc = nvm_update_err_to_stderr(dev, resp->result);
+		rc = -ENOPKG;
 	}
 	if (rc == -EACCES)
 		bnxt_print_admin_err(bp);
@@ -2815,8 +2777,8 @@ static int bnxt_get_nvram_directory(struct net_device *dev, u32 len, u8 *data)
 	return rc;
 }
 
-int bnxt_get_nvram_item(struct net_device *dev, u32 index, u32 offset,
-			u32 length, u8 *data)
+static int bnxt_get_nvram_item(struct net_device *dev, u32 index, u32 offset,
+			       u32 length, u8 *data)
 {
 	struct bnxt *bp = netdev_priv(dev);
 	int rc;
@@ -2850,9 +2812,9 @@ int bnxt_get_nvram_item(struct net_device *dev, u32 index, u32 offset,
 	return rc;
 }
 
-int bnxt_find_nvram_item(struct net_device *dev, u16 type, u16 ordinal,
-			 u16 ext, u16 *index, u32 *item_length,
-			 u32 *data_length)
+static int bnxt_find_nvram_item(struct net_device *dev, u16 type, u16 ordinal,
+				u16 ext, u16 *index, u32 *item_length,
+				u32 *data_length)
 {
 	struct hwrm_nvm_find_dir_entry_output *output;
 	struct hwrm_nvm_find_dir_entry_input *req;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
index 2593e0049582..6aa44840f13a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
@@ -56,13 +56,6 @@ int bnxt_hwrm_firmware_reset(struct net_device *dev, u8 proc_type,
 int bnxt_flash_package_from_fw_obj(struct net_device *dev, const struct firmware *fw,
 				   u32 install_type);
 int bnxt_get_pkginfo(struct net_device *dev, char *ver, int size);
-int bnxt_find_nvram_item(struct net_device *dev, u16 type, u16 ordinal, u16 ext,
-			 u16 *index, u32 *item_length, u32 *data_length);
-int bnxt_get_nvram_item(struct net_device *dev, u32 index, u32 offset,
-			u32 length, u8 *data);
-int bnxt_flash_nvram(struct net_device *dev, u16 dir_type, u16 dir_ordinal,
-		     u16 dir_ext, u16 dir_attr, u32 dir_item_len,
-		     const u8 *data, size_t data_len);
 void bnxt_ethtool_init(struct bnxt *bp);
 void bnxt_ethtool_free(struct bnxt *bp);
 
-- 
2.34.1

