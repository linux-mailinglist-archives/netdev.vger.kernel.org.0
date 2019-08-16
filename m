Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1482A90B07
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 00:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbfHPWdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 18:33:54 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38414 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727898AbfHPWdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 18:33:53 -0400
Received: by mail-pf1-f196.google.com with SMTP id o70so3827245pfg.5
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 15:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Fp4fQXmbQWiRT3Tg1PjQ+KQDvMa3B/ngssjpquIumrY=;
        b=U6K/y5PDi70ZXeN/u7ZU5tdlWtmxALesgp8Rru3Y/wxoVoJIixwqd3oWLCQG1u6j0g
         6sgpntavpbUMllEQu+xhSQg8VBwDZYZI1qaCxgA1TCM4LeP06dKQZVNbpaagCRzUyGsn
         0LulZGxDdfu2izIz986aYar9EtSStozHUDUoA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Fp4fQXmbQWiRT3Tg1PjQ+KQDvMa3B/ngssjpquIumrY=;
        b=tuH1anGtKFsDU1s5TDvtFes65TPfwf0heyaugTx20NIfUbzdA2UxcsE8HYkjFboQdC
         y5JWK01RtXNNck8THXPmthUCYOMu7snU0zQ3D/ht70Y5tqv/wb53T5DkkBwbur4qfSBj
         +74PMEnrAOMANvCyfyDbDBR8pfoCD+8ZexFZ48YaXKDBwbYs69oPZlCzzo0DnrUOopEq
         laLYMKuFeSeIiHxFzp3oycYHgKwh+8pAgJp3uGYHOrYIk3YUVO2AVlzxJST4du61Bvho
         j1ssoCD9zqXTHQEy18gMZzk7YhShTs+wKEiVArmSpAOMcqhsm3gUPoTyMAOKisaFDKlS
         WjtA==
X-Gm-Message-State: APjAAAW5yfHiIyTuZiAGUvdDOvj0FJ3gvkV/2ug+R2OkfKK3z7imtupz
        oQuAiujSjG/1mYIF/bvfhzzfKg==
X-Google-Smtp-Source: APXvYqya8IrO/8ucSx5R4hgZQL/RN73DSbTo2OsNRFtUBPRU4AwJwye67oBVUxiLOYzV0J9mEV5RKA==
X-Received: by 2002:a17:90a:c588:: with SMTP id l8mr9534392pjt.57.1565994832714;
        Fri, 16 Aug 2019 15:33:52 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o35sm5728404pgm.29.2019.08.16.15.33.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 15:33:52 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net 4/6] bnxt_en: Suppress HWRM errors for HWRM_NVM_GET_VARIABLE command
Date:   Fri, 16 Aug 2019 18:33:35 -0400
Message-Id: <1565994817-6328-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1565994817-6328-1-git-send-email-michael.chan@broadcom.com>
References: <1565994817-6328-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

For newly added NVM parameters, older firmware may not have the support.
Suppress the error message to avoid the unncessary error message which is
triggered when devlink calls the driver during initialization.

Fixes: 782a624d00fa ("bnxt_en: Add bnxt_en initial params table and register it.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 549c90d3..c05d663 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -98,10 +98,13 @@ static int bnxt_hwrm_nvm_req(struct bnxt *bp, u32 param_id, void *msg,
 	if (idx)
 		req->dimensions = cpu_to_le16(1);
 
-	if (req->req_type == cpu_to_le16(HWRM_NVM_SET_VARIABLE))
+	if (req->req_type == cpu_to_le16(HWRM_NVM_SET_VARIABLE)) {
 		memcpy(data_addr, buf, bytesize);
-
-	rc = hwrm_send_message(bp, msg, msg_len, HWRM_CMD_TIMEOUT);
+		rc = hwrm_send_message(bp, msg, msg_len, HWRM_CMD_TIMEOUT);
+	} else {
+		rc = hwrm_send_message_silent(bp, msg, msg_len,
+					      HWRM_CMD_TIMEOUT);
+	}
 	if (!rc && req->req_type == cpu_to_le16(HWRM_NVM_GET_VARIABLE))
 		memcpy(buf, data_addr, bytesize);
 
-- 
2.5.1

