Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC9A2A2DA8
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 05:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbfH3Dzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 23:55:36 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33518 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727775AbfH3Dzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 23:55:35 -0400
Received: by mail-pg1-f193.google.com with SMTP id n190so2816056pgn.0
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 20:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=crs02X/t/0z48ho3d4VorRWpt8Ocv5AmEnXmRg61Kzk=;
        b=e2bDBI1NrQWGdMulilMFBhkrd8GuRWNxJ4IEcsEe7VPHUy1Hh0Z49CYDikpqj2rDuv
         iV6LnkJJMX3DeWRSyD9f54sPcBVhDE7Ck+cNRsuU9VhqfnN7TYKxZu1C3JB1PPebA5P0
         AQZkTXm1sYGQVoHsCWxwOACeN1w86VG12d1yU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=crs02X/t/0z48ho3d4VorRWpt8Ocv5AmEnXmRg61Kzk=;
        b=smm0ImoCtld2xv4nsUMr6PKa1GMnGHUFg5S20uD4Uk4PTYnexVWFSv/s5z7AbNhefK
         p819GadBCyLXlciRGQ5fpAKMstZi9f13P7TTHV2pzw6HRH2gaQZrlWXiBzSLrDant9uR
         aHG1jM2l1qZkG4TbVua6A1cMde7xNw6tPyvAwqYy+EF6gqg3/IUZC43KKxKVFd2wMjdt
         H5yp0MvQ11UI8HmJX/cnCI6XjDKTiYfBawwAXkScdMobWnzZTLHXPKFkiHQu213fRCjv
         Xkwa6QaqV+INWlAiz6xw58xcIIeoy8KwdAcvCu/Cu3pjbiz85H8e1UdnW73cMcpUX3d8
         EwoQ==
X-Gm-Message-State: APjAAAUrb9pZG+vM0vezhu33dDra4Xzcffk1ykYgxClcgJKiIycmFx8n
        X+Q3d/WEzvfBg7G2sY9yfWpq0w==
X-Google-Smtp-Source: APXvYqxUF9gTTzlb5aqL43YEXblqdG0A8IOi/i/jq7UTTKDSc0568N4RGCnWzRh6OKwXRGqMrhe0bQ==
X-Received: by 2002:a65:690b:: with SMTP id s11mr9344289pgq.10.1567137334267;
        Thu, 29 Aug 2019 20:55:34 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l3sm3658877pjq.24.2019.08.29.20.55.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 20:55:33 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        ray.jui@broadcom.com
Subject: [PATCH net-next v2 03/22] bnxt_en: Convert error code in firmware message response to standard code.
Date:   Thu, 29 Aug 2019 23:54:46 -0400
Message-Id: <1567137305-5853-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
References: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The main firmware messaging function returns the firmware defined error
code and many callers have to convert to standard error code for proper
propagation to userspace.  Convert bnxt_hwrm_do_send_msg() to return
standard error code so we can do away with all the special error code
handling by the many callers.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 60 ++++++++++++++---------
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c     |  4 --
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c |  8 +--
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 20 ++------
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c   | 12 ++---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c      | 17 -------
 6 files changed, 44 insertions(+), 77 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index c8550ca..b9eb24e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4048,6 +4048,32 @@ void bnxt_hwrm_cmd_hdr_init(struct bnxt *bp, void *request, u16 req_type,
 		req->resp_addr = cpu_to_le64(bp->hwrm_cmd_resp_dma_addr);
 }
 
+static int bnxt_hwrm_to_stderr(u32 hwrm_err)
+{
+	switch (hwrm_err) {
+	case HWRM_ERR_CODE_SUCCESS:
+		return 0;
+	case HWRM_ERR_CODE_RESOURCE_ACCESS_DENIED:
+		return -EACCES;
+	case HWRM_ERR_CODE_RESOURCE_ALLOC_ERROR:
+		return -ENOSPC;
+	case HWRM_ERR_CODE_INVALID_PARAMS:
+	case HWRM_ERR_CODE_INVALID_FLAGS:
+	case HWRM_ERR_CODE_INVALID_ENABLES:
+	case HWRM_ERR_CODE_UNSUPPORTED_TLV:
+	case HWRM_ERR_CODE_UNSUPPORTED_OPTION_ERR:
+		return -EINVAL;
+	case HWRM_ERR_CODE_NO_BUFFER:
+		return -ENOMEM;
+	case HWRM_ERR_CODE_HOT_RESET_PROGRESS:
+		return -EAGAIN;
+	case HWRM_ERR_CODE_CMD_NOT_SUPPORTED:
+		return -EOPNOTSUPP;
+	default:
+		return -EIO;
+	}
+}
+
 static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
 				 int timeout, bool silent)
 {
@@ -4222,7 +4248,7 @@ static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
 		netdev_err(bp->dev, "hwrm req_type 0x%x seq id 0x%x error 0x%x\n",
 			   le16_to_cpu(resp->req_type),
 			   le16_to_cpu(resp->seq_id), rc);
-	return rc;
+	return bnxt_hwrm_to_stderr(rc);
 }
 
 int _hwrm_send_message(struct bnxt *bp, void *msg, u32 msg_len, int timeout)
@@ -4335,10 +4361,8 @@ static int bnxt_hwrm_func_drv_rgtr(struct bnxt *bp)
 
 	mutex_lock(&bp->hwrm_cmd_lock);
 	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
-	if (rc)
-		rc = -EIO;
-	else if (resp->flags &
-		 cpu_to_le32(FUNC_DRV_RGTR_RESP_FLAGS_IF_CHANGE_SUPPORTED))
+	if (!rc && (resp->flags &
+		    cpu_to_le32(FUNC_DRV_RGTR_RESP_FLAGS_IF_CHANGE_SUPPORTED)))
 		bp->fw_cap |= BNXT_FW_CAP_IF_CHANGE;
 	mutex_unlock(&bp->hwrm_cmd_lock);
 	return rc;
@@ -4761,7 +4785,7 @@ static int bnxt_hwrm_vnic_set_rss_p5(struct bnxt *bp, u16 vnic_id, bool set_rss)
 		}
 		rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 		if (rc)
-			return -EIO;
+			return rc;
 	}
 	return 0;
 }
@@ -5521,7 +5545,7 @@ static int bnxt_hwrm_get_rings(struct bnxt *bp)
 	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 	if (rc) {
 		mutex_unlock(&bp->hwrm_cmd_lock);
-		return -EIO;
+		return rc;
 	}
 
 	hw_resc->resv_tx_rings = le16_to_cpu(resp->alloc_tx_rings);
@@ -5685,7 +5709,7 @@ bnxt_hwrm_reserve_pf_rings(struct bnxt *bp, int tx_rings, int rx_rings,
 
 	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 	if (rc)
-		return -ENOMEM;
+		return rc;
 
 	if (bp->hwrm_spec_code < 0x10601)
 		bp->hw_resc.resv_tx_rings = tx_rings;
@@ -5710,7 +5734,7 @@ bnxt_hwrm_reserve_vf_rings(struct bnxt *bp, int tx_rings, int rx_rings,
 				     cp_rings, stats, vnics);
 	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 	if (rc)
-		return -ENOMEM;
+		return rc;
 
 	rc = bnxt_hwrm_get_rings(bp);
 	return rc;
@@ -5891,9 +5915,7 @@ static int bnxt_hwrm_check_vf_rings(struct bnxt *bp, int tx_rings, int rx_rings,
 
 	req.flags = cpu_to_le32(flags);
 	rc = hwrm_send_message_silent(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
-	if (rc)
-		return -ENOMEM;
-	return 0;
+	return rc;
 }
 
 static int bnxt_hwrm_check_pf_rings(struct bnxt *bp, int tx_rings, int rx_rings,
@@ -5921,9 +5943,7 @@ static int bnxt_hwrm_check_pf_rings(struct bnxt *bp, int tx_rings, int rx_rings,
 
 	req.flags = cpu_to_le32(flags);
 	rc = hwrm_send_message_silent(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
-	if (rc)
-		return -ENOMEM;
-	return 0;
+	return rc;
 }
 
 static int bnxt_hwrm_check_rings(struct bnxt *bp, int tx_rings, int rx_rings,
@@ -6483,8 +6503,6 @@ static int bnxt_hwrm_func_backing_store_cfg(struct bnxt *bp, u32 enables)
 	}
 	req.flags = cpu_to_le32(flags);
 	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
-	if (rc)
-		rc = -EIO;
 	return rc;
 }
 
@@ -6746,10 +6764,8 @@ int bnxt_hwrm_func_resc_qcaps(struct bnxt *bp, bool all)
 	mutex_lock(&bp->hwrm_cmd_lock);
 	rc = _hwrm_send_message_silent(bp, &req, sizeof(req),
 				       HWRM_CMD_TIMEOUT);
-	if (rc) {
-		rc = -EIO;
+	if (rc)
 		goto hwrm_func_resc_qcaps_exit;
-	}
 
 	hw_resc->max_tx_sch_inputs = le16_to_cpu(resp->max_tx_scheduler_inputs);
 	if (!all)
@@ -7257,8 +7273,6 @@ static int bnxt_hwrm_set_br_mode(struct bnxt *bp, u16 br_mode)
 	else
 		return -EINVAL;
 	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
-	if (rc)
-		rc = -EIO;
 	return rc;
 }
 
@@ -7278,8 +7292,6 @@ static int bnxt_hwrm_set_cache_line_size(struct bnxt *bp, int size)
 		req.options = FUNC_CFG_REQ_OPTIONS_CACHE_LINESIZE_SIZE_128;
 
 	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
-	if (rc)
-		rc = -EIO;
 	return rc;
 }
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
index 07301cb..a2ffc3e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
@@ -377,8 +377,6 @@ static int bnxt_hwrm_set_dcbx_app(struct bnxt *bp, struct dcb_app *app,
 	set.data_len = cpu_to_le16(sizeof(*data) + sizeof(*fw_app) * n);
 	set.hdr_cnt = 1;
 	rc = hwrm_send_message(bp, &set, sizeof(set), HWRM_CMD_TIMEOUT);
-	if (rc)
-		rc = -EIO;
 
 set_app_exit:
 	dma_free_coherent(&bp->pdev->dev, data_len, data, mapping);
@@ -433,8 +431,6 @@ static int bnxt_hwrm_queue_dscp2pri_cfg(struct bnxt *bp, struct dcb_app *app,
 	dscp2pri->pri = app->priority;
 	req.entry_cnt = cpu_to_le16(1);
 	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
-	if (rc)
-		rc = -EIO;
 	dma_free_coherent(&bp->pdev->dev, sizeof(*dscp2pri), dscp2pri,
 			  mapping);
 	return rc;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index c05d663..7d9a8c4 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -109,13 +109,9 @@ static int bnxt_hwrm_nvm_req(struct bnxt *bp, u32 param_id, void *msg,
 		memcpy(buf, data_addr, bytesize);
 
 	dma_free_coherent(&bp->pdev->dev, bytesize, data_addr, data_dma_addr);
-	if (rc == HWRM_ERR_CODE_RESOURCE_ACCESS_DENIED) {
+	if (rc == -EACCES)
 		netdev_err(bp->dev, "PF does not have admin privileges to modify NVM config\n");
-		return -EACCES;
-	} else if (rc) {
-		return -EIO;
-	}
-	return 0;
+	return rc;
 }
 
 static int bnxt_dl_nvm_param_get(struct devlink *dl, u32 id,
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 72bb730..a3a8722 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1743,12 +1743,8 @@ static int bnxt_flash_nvram(struct net_device *dev,
 	rc = hwrm_send_message(bp, &req, sizeof(req), FLASH_NVRAM_TIMEOUT);
 	dma_free_coherent(&bp->pdev->dev, data_len, kmem, dma_handle);
 
-	if (rc == HWRM_ERR_CODE_RESOURCE_ACCESS_DENIED) {
+	if (rc == -EACCES)
 		bnxt_print_admin_err(bp);
-		rc = -EACCES;
-	} else if (rc) {
-		rc = -EIO;
-	}
 	return rc;
 }
 
@@ -1798,12 +1794,8 @@ static int bnxt_firmware_reset(struct net_device *dev,
 	}
 
 	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
-	if (rc == HWRM_ERR_CODE_RESOURCE_ACCESS_DENIED) {
+	if (rc == -EACCES)
 		bnxt_print_admin_err(bp);
-		rc = -EACCES;
-	} else if (rc) {
-		rc = -EIO;
-	}
 	return rc;
 }
 
@@ -2098,12 +2090,8 @@ static int bnxt_flash_package_from_file(struct net_device *dev,
 flash_pkg_exit:
 	mutex_unlock(&bp->hwrm_cmd_lock);
 err_exit:
-	if (hwrm_err == HWRM_ERR_CODE_RESOURCE_ACCESS_DENIED) {
+	if (hwrm_err == -EACCES)
 		bnxt_print_admin_err(bp);
-		rc = -EACCES;
-	} else if (hwrm_err) {
-		rc = -EOPNOTSUPP;
-	}
 	return rc;
 }
 
@@ -2642,8 +2630,6 @@ static int bnxt_set_phys_id(struct net_device *dev,
 		led_cfg->led_group_id = bp->leds[i].led_group_id;
 	}
 	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
-	if (rc)
-		rc = -EIO;
 	return rc;
 }
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
index 2b90a2b..9972862 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
@@ -133,7 +133,7 @@ static int bnxt_hwrm_func_qcfg_flags(struct bnxt *bp, struct bnxt_vf_info *vf)
 	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 	if (rc) {
 		mutex_unlock(&bp->hwrm_cmd_lock);
-		return -EIO;
+		return rc;
 	}
 	vf->func_qcfg_flags = le16_to_cpu(resp->flags);
 	mutex_unlock(&bp->hwrm_cmd_lock);
@@ -164,9 +164,7 @@ static int bnxt_hwrm_set_trusted_vf(struct bnxt *bp, struct bnxt_vf_info *vf)
 	else
 		req.flags = cpu_to_le32(FUNC_CFG_REQ_FLAGS_TRUSTED_VF_DISABLE);
 	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
-	if (rc)
-		return -EIO;
-	return 0;
+	return rc;
 }
 
 int bnxt_set_vf_trust(struct net_device *dev, int vf_id, bool trusted)
@@ -564,10 +562,8 @@ static int bnxt_hwrm_func_vf_resc_cfg(struct bnxt *bp, int num_vfs)
 		req.vf_id = cpu_to_le16(pf->first_vf_id + i);
 		rc = _hwrm_send_message(bp, &req, sizeof(req),
 					HWRM_CMD_TIMEOUT);
-		if (rc) {
-			rc = -ENOMEM;
+		if (rc)
 			break;
-		}
 		pf->active_vfs = i + 1;
 		pf->vf[i].fw_fid = pf->first_vf_id + i;
 	}
@@ -664,8 +660,6 @@ static int bnxt_hwrm_func_cfg(struct bnxt *bp, int num_vfs)
 		total_vf_tx_rings += vf_tx_rsvd;
 	}
 	mutex_unlock(&bp->hwrm_cmd_lock);
-	if (rc)
-		rc = -ENOMEM;
 	if (pf->active_vfs) {
 		hw_resc->max_tx_rings -= total_vf_tx_rings;
 		hw_resc->max_rx_rings -= vf_rx_rings * num_vfs;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index dd621f6..c8062d0 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -319,8 +319,6 @@ static int bnxt_hwrm_cfa_flow_free(struct bnxt *bp,
 	if (rc)
 		netdev_info(bp->dev, "%s: Error rc=%d", __func__, rc);
 
-	if (rc)
-		rc = -EIO;
 	return rc;
 }
 
@@ -515,11 +513,6 @@ static int bnxt_hwrm_cfa_flow_alloc(struct bnxt *bp, struct bnxt_tc_flow *flow,
 		}
 	}
 	mutex_unlock(&bp->hwrm_cmd_lock);
-
-	if (rc == HWRM_ERR_CODE_RESOURCE_ALLOC_ERROR)
-		rc = -ENOSPC;
-	else if (rc)
-		rc = -EIO;
 	return rc;
 }
 
@@ -591,8 +584,6 @@ static int hwrm_cfa_decap_filter_alloc(struct bnxt *bp,
 	}
 	mutex_unlock(&bp->hwrm_cmd_lock);
 
-	if (rc)
-		rc = -EIO;
 	return rc;
 }
 
@@ -609,8 +600,6 @@ static int hwrm_cfa_decap_filter_free(struct bnxt *bp,
 	if (rc)
 		netdev_info(bp->dev, "%s: Error rc=%d", __func__, rc);
 
-	if (rc)
-		rc = -EIO;
 	return rc;
 }
 
@@ -660,8 +649,6 @@ static int hwrm_cfa_encap_record_alloc(struct bnxt *bp,
 	}
 	mutex_unlock(&bp->hwrm_cmd_lock);
 
-	if (rc)
-		rc = -EIO;
 	return rc;
 }
 
@@ -678,8 +665,6 @@ static int hwrm_cfa_encap_record_free(struct bnxt *bp,
 	if (rc)
 		netdev_info(bp->dev, "%s: Error rc=%d", __func__, rc);
 
-	if (rc)
-		rc = -EIO;
 	return rc;
 }
 
@@ -1457,8 +1442,6 @@ bnxt_hwrm_cfa_flow_stats_get(struct bnxt *bp, int num_flows,
 	}
 	mutex_unlock(&bp->hwrm_cmd_lock);
 
-	if (rc)
-		rc = -EIO;
 	return rc;
 }
 
-- 
2.5.1

