Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5BADDE3C3
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 07:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfJUFe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 01:34:58 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33367 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbfJUFe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 01:34:57 -0400
Received: by mail-pg1-f195.google.com with SMTP id i76so7060694pgc.0
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 22:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Sh7c0XGOO0SGXZZ2YykQmnYSBANjM+EMO3A+acsP2MA=;
        b=fpgOze+qJ+ooV/8r/9SWdg8aHv2LTX/Z7hkhzw+acThEOEhgC4hzaTCDUfhBytwW9+
         +GgEHC7oPCc/k7LGnIBDLHH8dmrSGztjIU4zyCmhhehB3G/CoOrBhQX3vX1o+6DCN+Ey
         XDqECr+xdyFAOm//dIFBalmKRxNbAoMLmWS8A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Sh7c0XGOO0SGXZZ2YykQmnYSBANjM+EMO3A+acsP2MA=;
        b=YmD4SWgZAA3RdQYJljwFB6NmWgKiTj/naTMJLAFMGOGvxDsZR53O0TB6IiNPedyRsX
         DYOYIyH5r8Z1+y6p7kTJJaY46WZl5U43FyU260ZNfwod69DtuOWw9+s2fB2mxYeLXhg4
         A9drz1CvUgurzQPgY/MmrM90nRcOTDrYMvwkEJtwNhHbCUPhTz3y+OSlvzOtaVK+999F
         sgNyvM98wteg6EiaPLC94Lc4C/Ya25JbqE8OtWZcTW03vOdilqPoti3J98vmgc76c0aO
         Oun0+mQIv/dkYn0lqS7CU3nOC5v4i5oBNZFFLlliDKAQAJcfl9vw4iH6KBMNXDJ/vKXl
         eY0g==
X-Gm-Message-State: APjAAAW1bL1ohAHi8ON7XYElfX2aYy9ODo0LSQpLknbJZ/MHtFURZe6O
        5Y/Pdb1A3aJwhuFkzqhcZzJ+jA==
X-Google-Smtp-Source: APXvYqwhjD23o9zUZzAWJLf8Ews/LG/R3QQiHdsOIl5gohyR9XBqn0cxKv/nnx7MUf3GMHqNpr65Jw==
X-Received: by 2002:a63:934d:: with SMTP id w13mr5644090pgm.185.1571636093185;
        Sun, 20 Oct 2019 22:34:53 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w2sm14713255pfn.57.2019.10.20.22.34.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Oct 2019 22:34:52 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net 2/5] bnxt_en: Fix devlink NVRAM related byte order related issues.
Date:   Mon, 21 Oct 2019 01:34:26 -0400
Message-Id: <1571636069-14179-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571636069-14179-1-git-send-email-michael.chan@broadcom.com>
References: <1571636069-14179-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current code does not do endian swapping between the devlink
parameter and the internal NVRAM representation.  Define a union to
represent the little endian NVRAM data and add 2 helper functions to
copy to and from the NVRAM data with the proper byte swapping.

Fixes: 782a624d00fa ("bnxt_en: Add bnxt_en initial port params table and register it")
Cc: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 81 +++++++++++++++--------
 1 file changed, 54 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 68f74f5..bd4b9f3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -226,12 +226,55 @@ static const struct bnxt_dl_nvm_param nvm_params[] = {
 	 BNXT_NVM_SHARED_CFG, 1, 1},
 };
 
+union bnxt_nvm_data {
+	u8	val8;
+	__le32	val32;
+};
+
+static void bnxt_copy_to_nvm_data(union bnxt_nvm_data *dst,
+				  union devlink_param_value *src,
+				  int nvm_num_bits, int dl_num_bytes)
+{
+	u32 val32 = 0;
+
+	if (nvm_num_bits == 1) {
+		dst->val8 = src->vbool;
+		return;
+	}
+	if (dl_num_bytes == 4)
+		val32 = src->vu32;
+	else if (dl_num_bytes == 2)
+		val32 = (u32)src->vu16;
+	else if (dl_num_bytes == 1)
+		val32 = (u32)src->vu8;
+	dst->val32 = cpu_to_le32(val32);
+}
+
+static void bnxt_copy_from_nvm_data(union devlink_param_value *dst,
+				    union bnxt_nvm_data *src,
+				    int nvm_num_bits, int dl_num_bytes)
+{
+	u32 val32;
+
+	if (nvm_num_bits == 1) {
+		dst->vbool = src->val8;
+		return;
+	}
+	val32 = le32_to_cpu(src->val32);
+	if (dl_num_bytes == 4)
+		dst->vu32 = val32;
+	else if (dl_num_bytes == 2)
+		dst->vu16 = (u16)val32;
+	else if (dl_num_bytes == 1)
+		dst->vu8 = (u8)val32;
+}
+
 static int bnxt_hwrm_nvm_req(struct bnxt *bp, u32 param_id, void *msg,
 			     int msg_len, union devlink_param_value *val)
 {
 	struct hwrm_nvm_get_variable_input *req = msg;
-	void *data_addr = NULL, *buf = NULL;
 	struct bnxt_dl_nvm_param nvm_param;
+	union bnxt_nvm_data *data;
 	dma_addr_t data_dma_addr;
 	int idx = 0, rc, i;
 
@@ -254,26 +297,9 @@ static int bnxt_hwrm_nvm_req(struct bnxt *bp, u32 param_id, void *msg,
 	else if (nvm_param.dir_type == BNXT_NVM_FUNC_CFG)
 		idx = bp->pf.fw_fid - BNXT_FIRST_PF_FID;
 
-	switch (nvm_param.dl_num_bytes) {
-	case 1:
-		if (nvm_param.nvm_num_bits == 1)
-			buf = &val->vbool;
-		else
-			buf = &val->vu8;
-		break;
-	case 2:
-		buf = &val->vu16;
-		break;
-	case 4:
-		buf = &val->vu32;
-		break;
-	default:
-		return -EFAULT;
-	}
-
-	data_addr = dma_alloc_coherent(&bp->pdev->dev, nvm_param.dl_num_bytes,
-				       &data_dma_addr, GFP_KERNEL);
-	if (!data_addr)
+	data = dma_alloc_coherent(&bp->pdev->dev, sizeof(*data),
+				  &data_dma_addr, GFP_KERNEL);
+	if (!data)
 		return -ENOMEM;
 
 	req->dest_data_addr = cpu_to_le64(data_dma_addr);
@@ -284,17 +310,18 @@ static int bnxt_hwrm_nvm_req(struct bnxt *bp, u32 param_id, void *msg,
 		req->dimensions = cpu_to_le16(1);
 
 	if (req->req_type == cpu_to_le16(HWRM_NVM_SET_VARIABLE)) {
-		memcpy(data_addr, buf, nvm_param.dl_num_bytes);
+		bnxt_copy_to_nvm_data(data, val, nvm_param.nvm_num_bits,
+				      nvm_param.dl_num_bytes);
 		rc = hwrm_send_message(bp, msg, msg_len, HWRM_CMD_TIMEOUT);
 	} else {
 		rc = hwrm_send_message_silent(bp, msg, msg_len,
 					      HWRM_CMD_TIMEOUT);
+		if (!rc)
+			bnxt_copy_from_nvm_data(val, data,
+						nvm_param.nvm_num_bits,
+						nvm_param.dl_num_bytes);
 	}
-	if (!rc && req->req_type == cpu_to_le16(HWRM_NVM_GET_VARIABLE))
-		memcpy(buf, data_addr, nvm_param.dl_num_bytes);
-
-	dma_free_coherent(&bp->pdev->dev, nvm_param.dl_num_bytes, data_addr,
-			  data_dma_addr);
+	dma_free_coherent(&bp->pdev->dev, sizeof(*data), data, data_dma_addr);
 	if (rc == -EACCES)
 		netdev_err(bp->dev, "PF does not have admin privileges to modify NVM config\n");
 	return rc;
-- 
2.5.1

