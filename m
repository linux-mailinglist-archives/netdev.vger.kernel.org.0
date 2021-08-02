Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17DC3DCF2A
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 06:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbhHBENb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 00:13:31 -0400
Received: from lpdvsmtp11.broadcom.com ([192.19.166.231]:46088 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230155AbhHBENY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 00:13:24 -0400
Received: from dhcp-10-123-153-22.dhcp.broadcom.net (bgccx-dev-host-lnx2.bec.broadcom.net [10.123.153.22])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 358C6EA;
        Sun,  1 Aug 2021 21:06:55 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 358C6EA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1627877218;
        bh=3YsWoTLeFWoxXWisQI0tsXhvXveAsNz1lXovnBROzoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i4FyRUS5UnYGmhZvQug5xsEHvMwKN3KJSAOVk/ZqmeygWNbCX4ngIEAvGsgiL2iuE
         6EhK4mgnaFsM7AEkbFucQS7XS/ddoBuVhh0XfvWMVI+1zoGt+nH1Yc2Z0gjzQpR4zr
         jQ1GUNhOR4yHUg3XI755nNHoI0viNODTOsgVkrmM=
From:   Kalesh A P <kalesh-anakkur.purayil@broadcom.com>
To:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com
Cc:     netdev@vger.kernel.org, edwin.peer@broadcom.com,
        michael.chan@broadcom.com
Subject: [PATCH net-next 2/2] bnxt_en: Add device capabilities to devlink info_get cb
Date:   Mon,  2 Aug 2021 09:57:40 +0530
Message-Id: <20210802042740.10355-3-kalesh-anakkur.purayil@broadcom.com>
X-Mailer: git-send-email 2.10.1
In-Reply-To: <20210802042740.10355-1-kalesh-anakkur.purayil@broadcom.com>
References: <20210802042740.10355-1-kalesh-anakkur.purayil@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

HWRM_VER_GET and FUNC_QCAPS command response provides the support
to indicate various device capabilities.

Expose these details via the devlink info.

Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 31 +++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 64381be..0ae5f47 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -379,6 +379,25 @@ static int bnxt_hwrm_get_nvm_cfg_ver(struct bnxt *bp,
 	return rc;
 }
 
+static int bnxt_dl_dev_capability_info_put(struct bnxt *bp, struct devlink_info_req *req)
+{
+	int rc;
+
+	if (bp->fw_cap & BNXT_FW_CAP_HOT_RESET) {
+		rc = devlink_info_device_capability_put(req, "hot_reset");
+		if (rc)
+			return rc;
+	}
+
+	if (bp->fw_cap & BNXT_FW_CAP_ERROR_RECOVERY) {
+		rc = devlink_info_device_capability_put(req, "error_recovery");
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
 static int bnxt_dl_info_put(struct bnxt *bp, struct devlink_info_req *req,
 			    enum bnxt_dl_version_type type, const char *key,
 			    char *buf)
@@ -557,8 +576,16 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 	snprintf(roce_ver, FW_VER_STR_LEN, "%d.%d.%d.%d",
 		 nvm_dev_info.roce_fw_major, nvm_dev_info.roce_fw_minor,
 		 nvm_dev_info.roce_fw_build, nvm_dev_info.roce_fw_patch);
-	return bnxt_dl_info_put(bp, req, BNXT_VERSION_STORED,
-				DEVLINK_INFO_VERSION_GENERIC_FW_ROCE, roce_ver);
+	rc = bnxt_dl_info_put(bp, req, BNXT_VERSION_STORED,
+			      DEVLINK_INFO_VERSION_GENERIC_FW_ROCE, roce_ver);
+	if (rc)
+		return rc;
+
+	rc = bnxt_dl_dev_capability_info_put(bp, req);
+	if (rc)
+		return rc;
+
+	return 0;
 }
 
 static int bnxt_hwrm_nvm_req(struct bnxt *bp, u32 param_id, void *msg,
-- 
2.10.1

