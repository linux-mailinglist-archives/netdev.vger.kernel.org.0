Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22BE3DE3C2
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 07:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbfJUFew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 01:34:52 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37611 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbfJUFev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 01:34:51 -0400
Received: by mail-pf1-f195.google.com with SMTP id y5so7667548pfo.4
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 22:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RvU7BBypAdgw2Idz4ifubDjhL6/yA+mEd0XAiktWYDc=;
        b=DNbaRG5dDhrWfkAquGFyNzHVw1qh/jBkbLPTrStF5ITX+Aaf+ba3A/GvGRmGH8x1a1
         c411/zwrxnduruBlTozWM4WtIIXZYxvTsxGwzoFnHkbpfYNMpIEfqKZRFY4j3t6+5Hls
         DuKzORSIhdQ0R0jqlWiYC+lQj7pH0yLtsZWEc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RvU7BBypAdgw2Idz4ifubDjhL6/yA+mEd0XAiktWYDc=;
        b=WIIzORGkNKX3op3tvv+z+qxg4+qBC0YB7DnbghXA2Qm4QgDmNq0CDAoFoIqp1ceRJ+
         /877KoMXoFpQxIR+pVYAXTDGEu79VyNrNZEmyrhQ99xCMbEfquIgrN2BT74LwMEgAFN3
         MaDCOi/eGnQM4JvLfv1B8Na0Iujtiuiy75XRP/EU0tMVCQUwIDfYBPSaK8gSQUKg6VVP
         PnI7p86tPsKa0UpMdc0hbGNXBt4RUqL0lOvQkp4nbFDlF21f0jJYpglEG6Ptxg710t0G
         0OZLnXb0F+HL1qazM8UdQ0VGfwemr+SxMXygpRkwwi8jZvL9P3ZnxCIyzHfN5rofeIJw
         xpaQ==
X-Gm-Message-State: APjAAAWi8AjN8GdpAXcILhPRRpu7r5TWvsKR0MBoBznzkRy6OU2QG4Xf
        k1zpFipumwWbsqMZHTQXtmLTZZ2GVvk=
X-Google-Smtp-Source: APXvYqxKxK8fvNQqhi4//vN9aAKkeNkG229/+E3zLPavJsRfImpeDfwe/L2joYbNx30CzPs/rcHLyg==
X-Received: by 2002:a63:40b:: with SMTP id 11mr23901983pge.425.1571636090527;
        Sun, 20 Oct 2019 22:34:50 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w2sm14713255pfn.57.2019.10.20.22.34.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Oct 2019 22:34:49 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net 1/5] bnxt_en: Fix the size of devlink MSIX parameters.
Date:   Mon, 21 Oct 2019 01:34:25 -0400
Message-Id: <1571636069-14179-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571636069-14179-1-git-send-email-michael.chan@broadcom.com>
References: <1571636069-14179-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

The current code that rounds up the NVRAM parameter bit size to the next
byte size for the devlink parameter is not always correct.  The MSIX
devlink parameters are 4 bytes and we don't get the correct size
using this method.

Fix it by adding a new dl_num_bytes member to the bnxt_dl_nvm_param
structure which statically provides bytesize information according
to the devlink parameter type definition.

Fixes: 782a624d00fa ("bnxt_en: Add bnxt_en initial port params table and register it")
Cc: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 28 +++++++++++------------
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h |  3 ++-
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index e664392..68f74f5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -215,15 +215,15 @@ enum bnxt_dl_param_id {
 
 static const struct bnxt_dl_nvm_param nvm_params[] = {
 	{DEVLINK_PARAM_GENERIC_ID_ENABLE_SRIOV, NVM_OFF_ENABLE_SRIOV,
-	 BNXT_NVM_SHARED_CFG, 1},
+	 BNXT_NVM_SHARED_CFG, 1, 1},
 	{DEVLINK_PARAM_GENERIC_ID_IGNORE_ARI, NVM_OFF_IGNORE_ARI,
-	 BNXT_NVM_SHARED_CFG, 1},
+	 BNXT_NVM_SHARED_CFG, 1, 1},
 	{DEVLINK_PARAM_GENERIC_ID_MSIX_VEC_PER_PF_MAX,
-	 NVM_OFF_MSIX_VEC_PER_PF_MAX, BNXT_NVM_SHARED_CFG, 10},
+	 NVM_OFF_MSIX_VEC_PER_PF_MAX, BNXT_NVM_SHARED_CFG, 10, 4},
 	{DEVLINK_PARAM_GENERIC_ID_MSIX_VEC_PER_PF_MIN,
-	 NVM_OFF_MSIX_VEC_PER_PF_MIN, BNXT_NVM_SHARED_CFG, 7},
+	 NVM_OFF_MSIX_VEC_PER_PF_MIN, BNXT_NVM_SHARED_CFG, 7, 4},
 	{BNXT_DEVLINK_PARAM_ID_GRE_VER_CHECK, NVM_OFF_DIS_GRE_VER_CHECK,
-	 BNXT_NVM_SHARED_CFG, 1},
+	 BNXT_NVM_SHARED_CFG, 1, 1},
 };
 
 static int bnxt_hwrm_nvm_req(struct bnxt *bp, u32 param_id, void *msg,
@@ -232,8 +232,8 @@ static int bnxt_hwrm_nvm_req(struct bnxt *bp, u32 param_id, void *msg,
 	struct hwrm_nvm_get_variable_input *req = msg;
 	void *data_addr = NULL, *buf = NULL;
 	struct bnxt_dl_nvm_param nvm_param;
-	int bytesize, idx = 0, rc, i;
 	dma_addr_t data_dma_addr;
+	int idx = 0, rc, i;
 
 	/* Get/Set NVM CFG parameter is supported only on PFs */
 	if (BNXT_VF(bp))
@@ -254,10 +254,9 @@ static int bnxt_hwrm_nvm_req(struct bnxt *bp, u32 param_id, void *msg,
 	else if (nvm_param.dir_type == BNXT_NVM_FUNC_CFG)
 		idx = bp->pf.fw_fid - BNXT_FIRST_PF_FID;
 
-	bytesize = roundup(nvm_param.num_bits, BITS_PER_BYTE) / BITS_PER_BYTE;
-	switch (bytesize) {
+	switch (nvm_param.dl_num_bytes) {
 	case 1:
-		if (nvm_param.num_bits == 1)
+		if (nvm_param.nvm_num_bits == 1)
 			buf = &val->vbool;
 		else
 			buf = &val->vu8;
@@ -272,29 +271,30 @@ static int bnxt_hwrm_nvm_req(struct bnxt *bp, u32 param_id, void *msg,
 		return -EFAULT;
 	}
 
-	data_addr = dma_alloc_coherent(&bp->pdev->dev, bytesize,
+	data_addr = dma_alloc_coherent(&bp->pdev->dev, nvm_param.dl_num_bytes,
 				       &data_dma_addr, GFP_KERNEL);
 	if (!data_addr)
 		return -ENOMEM;
 
 	req->dest_data_addr = cpu_to_le64(data_dma_addr);
-	req->data_len = cpu_to_le16(nvm_param.num_bits);
+	req->data_len = cpu_to_le16(nvm_param.nvm_num_bits);
 	req->option_num = cpu_to_le16(nvm_param.offset);
 	req->index_0 = cpu_to_le16(idx);
 	if (idx)
 		req->dimensions = cpu_to_le16(1);
 
 	if (req->req_type == cpu_to_le16(HWRM_NVM_SET_VARIABLE)) {
-		memcpy(data_addr, buf, bytesize);
+		memcpy(data_addr, buf, nvm_param.dl_num_bytes);
 		rc = hwrm_send_message(bp, msg, msg_len, HWRM_CMD_TIMEOUT);
 	} else {
 		rc = hwrm_send_message_silent(bp, msg, msg_len,
 					      HWRM_CMD_TIMEOUT);
 	}
 	if (!rc && req->req_type == cpu_to_le16(HWRM_NVM_GET_VARIABLE))
-		memcpy(buf, data_addr, bytesize);
+		memcpy(buf, data_addr, nvm_param.dl_num_bytes);
 
-	dma_free_coherent(&bp->pdev->dev, bytesize, data_addr, data_dma_addr);
+	dma_free_coherent(&bp->pdev->dev, nvm_param.dl_num_bytes, data_addr,
+			  data_dma_addr);
 	if (rc == -EACCES)
 		netdev_err(bp->dev, "PF does not have admin privileges to modify NVM config\n");
 	return rc;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
index b97e0ba..2f4fd0a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
@@ -52,7 +52,8 @@ struct bnxt_dl_nvm_param {
 	u16 id;
 	u16 offset;
 	u16 dir_type;
-	u16 num_bits;
+	u16 nvm_num_bits;
+	u8 dl_num_bytes;
 };
 
 void bnxt_devlink_health_report(struct bnxt *bp, unsigned long event);
-- 
2.5.1

