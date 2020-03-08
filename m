Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 398C117D6E0
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 23:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgCHWqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 18:46:25 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:34586 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbgCHWqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 18:46:24 -0400
Received: by mail-pj1-f66.google.com with SMTP id 39so332745pjo.1
        for <netdev@vger.kernel.org>; Sun, 08 Mar 2020 15:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=piA4JE8qXH0rtb4DPipyI595w8WvA8wUN5p6cooSAJ4=;
        b=dTw1fJQZilCeE6rZzgINUPnMJxSzyCKAQBhCBckwvsAYKbrjKv3eFhB1ElNl7D/+Ax
         IeiZM4dW+i1y4c41FE9ctT9It9IWezlP3JIEP2kVjL5bdUYtVYL4oozRd5gjIO9mEVPW
         +MglK5TFyzG6TyZabsuv60XXYggA9KAq6fYwk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=piA4JE8qXH0rtb4DPipyI595w8WvA8wUN5p6cooSAJ4=;
        b=ZWAR4ymt85ctVAJMss++ltYNHC5eFX8z69l6in3qtwQr355f5l3BhhGDwI+VgxVsP/
         kB7y4obvpekzU4mpncuwUiIU8LUFIYzvgWZCiTfy8vEZJ7L1TvkI9hfksC9ghJoiVsy5
         lETG3KV5KrHfPwEWINvbudvg4WUDdM23ufJwi1z2lYyE6xuFhkAykginBu9hqRabIu5p
         Kx+25Hc3ge3lDMt3EAIOcrTOn9AIGr9CEZijrQ1O5akbh+0BDONRVkWoYvRrXaqAH77q
         bL/uXPGYzlUt7ikNb4NSKrTFC81NieD/hBDBzK1h37fjTJwhSDNx69j3HyVEFJGRvasg
         ED8A==
X-Gm-Message-State: ANhLgQ26usFB0i4vAugdmaSV8I8i1EwKugE0fKYX7nA97duTWNKAOIZ/
        xRZVKS7OB55lMd4Zw9tf7bF/Iw==
X-Google-Smtp-Source: ADFU+vu9mpLp1QgmgYn95XGVHrF5Ek3EGMpdwZEqh67626oIjAZEHB4YlfbBX1YuEfJ0QsrKl80g4Q==
X-Received: by 2002:a17:90a:b381:: with SMTP id e1mr15396561pjr.38.1583707583392;
        Sun, 08 Mar 2020 15:46:23 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x66sm31241397pgb.9.2020.03.08.15.46.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Mar 2020 15:46:22 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next 7/8] bnxt_en: Return -EAGAIN if fw command returns BUSY
Date:   Sun,  8 Mar 2020 18:45:53 -0400
Message-Id: <1583707554-1163-8-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1583707554-1163-1-git-send-email-michael.chan@broadcom.com>
References: <1583707554-1163-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

If firmware command returns error code as HWRM_ERR_CODE_BUSY, which
means it cannot handle the command due to a conflicting command
from another function, convert it to -EAGAIN.  If it is an ethtool
operation, this error code will be returned to userspace.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index e5da60a..02ac718 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4161,6 +4161,7 @@ static int bnxt_hwrm_to_stderr(u32 hwrm_err)
 	case HWRM_ERR_CODE_NO_BUFFER:
 		return -ENOMEM;
 	case HWRM_ERR_CODE_HOT_RESET_PROGRESS:
+	case HWRM_ERR_CODE_BUSY:
 		return -EAGAIN;
 	case HWRM_ERR_CODE_CMD_NOT_SUPPORTED:
 		return -EOPNOTSUPP;
-- 
2.5.1

