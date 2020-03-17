Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32D5A1888DD
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 16:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbgCQPQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 11:16:56 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40152 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726780AbgCQPQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 11:16:55 -0400
Received: by mail-wm1-f67.google.com with SMTP id z12so13264305wmf.5
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 08:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tpPs0wL9XdLkeDf8fvlZo9vBIif3PvGrP1NtM1raA04=;
        b=QONtf8AVd4DIPUJiCu0NTBbM+l1O9FrpRTgeDogEjn1W3s1SULRpU8QZ7aTS31qNSi
         UYv9FTrlqLtOW3pJ96f/+F4na4H21pr5pa++OjXqtLvAonC8zD0B7sz8dSkS8ENwJNhb
         ZdvEd6Rnkw/trcjKQiGx8yu96RxHVqi5r6d48=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tpPs0wL9XdLkeDf8fvlZo9vBIif3PvGrP1NtM1raA04=;
        b=S6Z4R18cTHVOmEG79IDsIXVXOts0PLd6T5zn6pYbZ2HeXfTggUEa9LQIdbxvkgn8gz
         6wh0J5yfEhEDa+mm3H/IXxEr4Riz1Mx1N3TuTadM2ZvZgXeoXb3DwIj2qIvMfb07Q0bY
         AiBuKAsiAJUExgqlcL1sX2ETlVJ0C4dAtDWLlAFjucFP7q48dumkcK8nv1odgCrUANv+
         FMaPCR+Y8IesgeCT9Lmw2K6l8in5QWbP/L+CFIQcY6yJ/uqB7uK0RqbHVZiwNgM33wv7
         3Pp9kbsYkqPp/mMp17i61jhUCueEJjzv1y/YhdiIp5o4+OrDOBtMTtoQVVLgq7besfWO
         SCdg==
X-Gm-Message-State: ANhLgQ2YLfaPFjiDs3iE5Dh7U5a0DPEony2TqO7TWvf/Y+93ZNSO0D2W
        U4QQvZaK/nkX1a/HHdUG9x68jA==
X-Google-Smtp-Source: ADFU+vu++aCEXMUCBeXjZ1bFS4MyEjbPeANiw/jVVX4dZv/Nd0xm7Ng1LP/a9rPeVdrqyYe8ACFgpA==
X-Received: by 2002:a1c:a345:: with SMTP id m66mr6082939wme.114.1584458213593;
        Tue, 17 Mar 2020 08:16:53 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id x6sm4943916wrm.29.2020.03.17.08.16.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Mar 2020 08:16:53 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH net-next 04/11] bnxt_en: Refactor bnxt_hwrm_get_nvm_cfg_ver()
Date:   Tue, 17 Mar 2020 20:44:41 +0530
Message-Id: <1584458082-29207-5-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1584458082-29207-1-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1584458082-29207-1-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor bnxt_hwrm_get_nvm_cfg_ver() and move hwrm specific
code to bnxt_hwrm_nvm_get_var(), to be called multiple times.

Also, rename bnxt_hwrm_get_nvm_cfg_ver() to bnxt_get_nvm_cfg_ver()

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 27 +++++++++++++++--------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 4a623ff..f08db49 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -359,25 +359,34 @@ static void bnxt_copy_from_nvm_data(union devlink_param_value *dst,
 		dst->vu8 = (u8)val32;
 }
 
-static int bnxt_hwrm_get_nvm_cfg_ver(struct bnxt *bp,
-				     union devlink_param_value *nvm_cfg_ver)
+static int bnxt_hwrm_nvm_get_var(struct bnxt *bp, dma_addr_t data_dma_addr,
+				 u16 offset, u16 num_bits)
 {
 	struct hwrm_nvm_get_variable_input req = {0};
+
+	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_NVM_GET_VARIABLE, -1, -1);
+	req.dest_data_addr = cpu_to_le64(data_dma_addr);
+	req.option_num = cpu_to_le16(offset);
+	req.data_len = cpu_to_le16(num_bits);
+
+	return hwrm_send_message_silent(bp, &req, sizeof(req),
+					HWRM_CMD_TIMEOUT);
+}
+
+static int bnxt_get_nvm_cfg_ver(struct bnxt *bp,
+				union devlink_param_value *nvm_cfg_ver)
+{
 	union bnxt_nvm_data *data;
 	dma_addr_t data_dma_addr;
 	int rc;
 
-	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_NVM_GET_VARIABLE, -1, -1);
 	data = dma_alloc_coherent(&bp->pdev->dev, sizeof(*data),
 				  &data_dma_addr, GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
-	req.dest_data_addr = cpu_to_le64(data_dma_addr);
-	req.data_len = cpu_to_le16(BNXT_NVM_CFG_VER_BITS);
-	req.option_num = cpu_to_le16(NVM_OFF_NVM_CFG_VER);
-
-	rc = hwrm_send_message_silent(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	rc = bnxt_hwrm_nvm_get_var(bp, data_dma_addr, NVM_OFF_NVM_CFG_VER,
+				   BNXT_NVM_CFG_VER_BITS);
 	if (!rc)
 		bnxt_copy_from_nvm_data(nvm_cfg_ver, data,
 					BNXT_NVM_CFG_VER_BITS,
@@ -439,7 +448,7 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 			return rc;
 	}
 
-	if (BNXT_PF(bp) && !bnxt_hwrm_get_nvm_cfg_ver(bp, &nvm_cfg_ver)) {
+	if (BNXT_PF(bp) && !bnxt_get_nvm_cfg_ver(bp, &nvm_cfg_ver)) {
 		u32 ver = nvm_cfg_ver.vu32;
 
 		sprintf(buf, "%X.%X.%X", (ver >> 16) & 0xF, (ver >> 8) & 0xF,
-- 
1.8.3.1

