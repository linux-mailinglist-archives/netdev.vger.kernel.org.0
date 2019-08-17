Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69509912EE
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 23:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbfHQVFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 17:05:32 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33542 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbfHQVFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 17:05:32 -0400
Received: by mail-pf1-f195.google.com with SMTP id g2so4932553pfq.0
        for <netdev@vger.kernel.org>; Sat, 17 Aug 2019 14:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=j9TfBHHbq+7kzy8vOIKScq0AhTKwzCpory37PRlKdvM=;
        b=QYsZMrVLqpbYtdLh82tXfPbey69ZVWVjKR+kn3vk6KUI005Xd5afxTyIE74fQg8aa1
         hK8U6zrtQqhDmHbcB5Cy24KDMWr/oV2PGZxf7+cgg6ozAtAClCP1xAamxO2zinlP45CL
         t+ZKvsvuIIyjTI6suJuezcnoj+OouwRm+TkBk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=j9TfBHHbq+7kzy8vOIKScq0AhTKwzCpory37PRlKdvM=;
        b=qyShunC8swEz9U4zYp1x8snME9hPdkFtTgVl4HqQPuY4iPPp0NJoKLhTVXdSyj1CAJ
         sHJwSijO+aapUnvq+F5utzkGMfS/kVgC4y/oMp+vgILa6F/SGDx8s1NAKwuV7ILmuCvt
         pCS63CZm1bK5SvFyteqd1lZEpskDq5r5vuvXOTd1i/ijUL/3hfc70mv/6AGOyGjnQO59
         DACwwZ2UsezjGM9tGQDDabTg36ZeKAKjrZOx8ZGh75OqxFxRNzZYBgzCtGpGr+kPCYwg
         RG8gw3My9AiarGZDOPCmJXqABhmZ2BIossvfcSlGHrST/9FAa/zTa9+uWmDk7fjt/PCU
         QUeQ==
X-Gm-Message-State: APjAAAUT+jy003m0nE+PLiZKAx16pIl05jrsIbFtWsUUq4mPW57rvVGK
        qpQiRLvuQtc3VqxUOQxoYDX1RgNbwgw=
X-Google-Smtp-Source: APXvYqyw0eYccjUNINF2TjN7XlBaDSgDYOtxA0oMIIi0cC6RGhLHj61VbtfxMI2sRi8R3u7p9TkX+Q==
X-Received: by 2002:a63:6c7:: with SMTP id 190mr13235461pgg.7.1566075931516;
        Sat, 17 Aug 2019 14:05:31 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e189sm9099295pgc.15.2019.08.17.14.05.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 17 Aug 2019 14:05:31 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net v2 3/6] bnxt_en: Fix handling FRAG_ERR when NVM_INSTALL_UPDATE cmd fails
Date:   Sat, 17 Aug 2019 17:04:49 -0400
Message-Id: <1566075892-30064-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1566075892-30064-1-git-send-email-michael.chan@broadcom.com>
References: <1566075892-30064-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

If FW returns FRAG_ERR in response error code, driver is resending the
command only when HWRM command returns success. Fix the code to resend
NVM_INSTALL_UPDATE command with DEFRAG install flags, if FW returns
FRAG_ERR in its response error code.

Fixes: cb4d1d626145 ("bnxt_en: Retry failed NVM_INSTALL_UPDATE with defragmentation flag enabled.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index c7ee63d..8445a0c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2016,21 +2016,19 @@ static int bnxt_flash_package_from_file(struct net_device *dev,
 	mutex_lock(&bp->hwrm_cmd_lock);
 	hwrm_err = _hwrm_send_message(bp, &install, sizeof(install),
 				      INSTALL_PACKAGE_TIMEOUT);
-	if (hwrm_err)
-		goto flash_pkg_exit;
-
-	if (resp->error_code) {
+	if (hwrm_err) {
 		u8 error_code = ((struct hwrm_err_output *)resp)->cmd_err;
 
-		if (error_code == NVM_INSTALL_UPDATE_CMD_ERR_CODE_FRAG_ERR) {
+		if (resp->error_code && error_code ==
+		    NVM_INSTALL_UPDATE_CMD_ERR_CODE_FRAG_ERR) {
 			install.flags |= cpu_to_le16(
 			       NVM_INSTALL_UPDATE_REQ_FLAGS_ALLOWED_TO_DEFRAG);
 			hwrm_err = _hwrm_send_message(bp, &install,
 						      sizeof(install),
 						      INSTALL_PACKAGE_TIMEOUT);
-			if (hwrm_err)
-				goto flash_pkg_exit;
 		}
+		if (hwrm_err)
+			goto flash_pkg_exit;
 	}
 
 	if (resp->result) {
-- 
2.5.1

