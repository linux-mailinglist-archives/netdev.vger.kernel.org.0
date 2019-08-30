Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1603DA2DA9
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 05:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbfH3Dzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 23:55:39 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43806 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727717AbfH3Dzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 23:55:37 -0400
Received: by mail-pf1-f194.google.com with SMTP id v12so3657766pfn.10
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 20:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+lPtZxzHcSuAaJZU0yo88MX03RCHbTP0inXfJMaIAvk=;
        b=PDFSgQSvIvOaWSkcQHWZct/yj8ZFSAlGy7cgu14NQuY3lsuV+CLgeMTjt6MKLXi2sR
         z8qEcs1FndoFEwn8zYSdsrv6QYr+miyK+nX0cVy6GQ106nKNsWlY/Hlw3PWvsUdmuxOR
         acRjlYDyJ0Pcd08ndQCL7VjJSjse5wQKBD00o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+lPtZxzHcSuAaJZU0yo88MX03RCHbTP0inXfJMaIAvk=;
        b=T15Fbmxtp11FPDhogkIEUlmP50cjGDf6XxiAhcakS23HJDfL8/iB3Gv0hqcngOFznQ
         NgWKtR09tVpV8J+N8HK3hd/zvb/nuJ5Y4OU8H3xpC55fjamGcb0TefzVjtQMscKC27VV
         5pJiX745oiF50LWS64eXnulq2UIqPE1aWe5vD/R1evjqm6uC84ChATgi5o4JI7F+TUYX
         O2O/ShTKj2PppqcXuOCSVDHNj3/XQ/4AfeVa3ZP69QKY11Kuj/hm2zCm6ZK1usuQTgSx
         Dif/VJoqdYYosF0n9H8mxfrrVLsTuaYo0yeyhJhr5COp/gI1qoTZWP4VmCwFB9zjo2w2
         7y2A==
X-Gm-Message-State: APjAAAXsYfhMS1KCV5BrQ6TClUKJmnmfR6tYRJqVRUwLhnfDwS/D3YUE
        g/JTeG3qE/MDGuAIuYNKGTigKQ==
X-Google-Smtp-Source: APXvYqx1o8czKgzg6Cxkqqa+LOzo2iYg66R3CTDPiZvghf8nc9+qrLovKE4WRNBhtQGk2Y1qq/UXpw==
X-Received: by 2002:a63:cc14:: with SMTP id x20mr11499561pgf.142.1567137336027;
        Thu, 29 Aug 2019 20:55:36 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l3sm3658877pjq.24.2019.08.29.20.55.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 20:55:34 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        ray.jui@broadcom.com
Subject: [PATCH net-next v2 04/22] bnxt_en: Simplify error checking in the SR-IOV message forwarding functions.
Date:   Thu, 29 Aug 2019 23:54:47 -0400
Message-Id: <1567137305-5853-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
References: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are 4 functions handling message forwarding for SR-IOV.  They
check for non-zero firmware response code and then return -1.  There
is no need to do this anymore.  The main messaging function will
now return standard error code.  Since we don't need to examine the
response, we can use the hwrm_send_message() variant which will
take the mutex automatically.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c | 72 +++----------------------
 1 file changed, 8 insertions(+), 64 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
index 9972862..b6a84d0 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
@@ -25,7 +25,6 @@
 static int bnxt_hwrm_fwd_async_event_cmpl(struct bnxt *bp,
 					  struct bnxt_vf_info *vf, u16 event_id)
 {
-	struct hwrm_fwd_async_event_cmpl_output *resp = bp->hwrm_cmd_resp_addr;
 	struct hwrm_fwd_async_event_cmpl_input req = {0};
 	struct hwrm_async_event_cmpl *async_cmpl;
 	int rc = 0;
@@ -40,23 +39,10 @@ static int bnxt_hwrm_fwd_async_event_cmpl(struct bnxt *bp,
 	async_cmpl->type = cpu_to_le16(ASYNC_EVENT_CMPL_TYPE_HWRM_ASYNC_EVENT);
 	async_cmpl->event_id = cpu_to_le16(event_id);
 
-	mutex_lock(&bp->hwrm_cmd_lock);
-	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
-
-	if (rc) {
+	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	if (rc)
 		netdev_err(bp->dev, "hwrm_fwd_async_event_cmpl failed. rc:%d\n",
 			   rc);
-		goto fwd_async_event_cmpl_exit;
-	}
-
-	if (resp->error_code) {
-		netdev_err(bp->dev, "hwrm_fwd_async_event_cmpl error %d\n",
-			   resp->error_code);
-		rc = -1;
-	}
-
-fwd_async_event_cmpl_exit:
-	mutex_unlock(&bp->hwrm_cmd_lock);
 	return rc;
 }
 
@@ -864,7 +850,6 @@ static int bnxt_hwrm_fwd_resp(struct bnxt *bp, struct bnxt_vf_info *vf,
 {
 	int rc = 0;
 	struct hwrm_fwd_resp_input req = {0};
-	struct hwrm_fwd_resp_output *resp = bp->hwrm_cmd_resp_addr;
 
 	if (BNXT_FWD_RESP_SIZE_ERR(msg_size))
 		return -EINVAL;
@@ -879,22 +864,9 @@ static int bnxt_hwrm_fwd_resp(struct bnxt *bp, struct bnxt_vf_info *vf,
 	req.encap_resp_cmpl_ring = encap_resp_cpr;
 	memcpy(req.encap_resp, encap_resp, msg_size);
 
-	mutex_lock(&bp->hwrm_cmd_lock);
-	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
-
-	if (rc) {
+	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	if (rc)
 		netdev_err(bp->dev, "hwrm_fwd_resp failed. rc:%d\n", rc);
-		goto fwd_resp_exit;
-	}
-
-	if (resp->error_code) {
-		netdev_err(bp->dev, "hwrm_fwd_resp error %d\n",
-			   resp->error_code);
-		rc = -1;
-	}
-
-fwd_resp_exit:
-	mutex_unlock(&bp->hwrm_cmd_lock);
 	return rc;
 }
 
@@ -903,7 +875,6 @@ static int bnxt_hwrm_fwd_err_resp(struct bnxt *bp, struct bnxt_vf_info *vf,
 {
 	int rc = 0;
 	struct hwrm_reject_fwd_resp_input req = {0};
-	struct hwrm_reject_fwd_resp_output *resp = bp->hwrm_cmd_resp_addr;
 
 	if (BNXT_REJ_FWD_RESP_SIZE_ERR(msg_size))
 		return -EINVAL;
@@ -914,22 +885,9 @@ static int bnxt_hwrm_fwd_err_resp(struct bnxt *bp, struct bnxt_vf_info *vf,
 	req.encap_resp_target_id = cpu_to_le16(vf->fw_fid);
 	memcpy(req.encap_request, vf->hwrm_cmd_req_addr, msg_size);
 
-	mutex_lock(&bp->hwrm_cmd_lock);
-	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
-
-	if (rc) {
+	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	if (rc)
 		netdev_err(bp->dev, "hwrm_fwd_err_resp failed. rc:%d\n", rc);
-		goto fwd_err_resp_exit;
-	}
-
-	if (resp->error_code) {
-		netdev_err(bp->dev, "hwrm_fwd_err_resp error %d\n",
-			   resp->error_code);
-		rc = -1;
-	}
-
-fwd_err_resp_exit:
-	mutex_unlock(&bp->hwrm_cmd_lock);
 	return rc;
 }
 
@@ -938,7 +896,6 @@ static int bnxt_hwrm_exec_fwd_resp(struct bnxt *bp, struct bnxt_vf_info *vf,
 {
 	int rc = 0;
 	struct hwrm_exec_fwd_resp_input req = {0};
-	struct hwrm_exec_fwd_resp_output *resp = bp->hwrm_cmd_resp_addr;
 
 	if (BNXT_EXEC_FWD_RESP_SIZE_ERR(msg_size))
 		return -EINVAL;
@@ -949,22 +906,9 @@ static int bnxt_hwrm_exec_fwd_resp(struct bnxt *bp, struct bnxt_vf_info *vf,
 	req.encap_resp_target_id = cpu_to_le16(vf->fw_fid);
 	memcpy(req.encap_request, vf->hwrm_cmd_req_addr, msg_size);
 
-	mutex_lock(&bp->hwrm_cmd_lock);
-	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
-
-	if (rc) {
+	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	if (rc)
 		netdev_err(bp->dev, "hwrm_exec_fw_resp failed. rc:%d\n", rc);
-		goto exec_fwd_resp_exit;
-	}
-
-	if (resp->error_code) {
-		netdev_err(bp->dev, "hwrm_exec_fw_resp error %d\n",
-			   resp->error_code);
-		rc = -1;
-	}
-
-exec_fwd_resp_exit:
-	mutex_unlock(&bp->hwrm_cmd_lock);
 	return rc;
 }
 
-- 
2.5.1

