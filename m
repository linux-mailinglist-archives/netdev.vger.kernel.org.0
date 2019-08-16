Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF1C90B06
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 00:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727927AbfHPWdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 18:33:54 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35255 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727834AbfHPWdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 18:33:52 -0400
Received: by mail-pf1-f196.google.com with SMTP id d85so3841820pfd.2
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 15:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=j9TfBHHbq+7kzy8vOIKScq0AhTKwzCpory37PRlKdvM=;
        b=chWfjTgw79mlIxKPo73oCkA17rpnz3txOuqGijK+U99eArDqGuNce5bFl1PSaExKe7
         YYzSocMWYFrei64NpBaB9aLT3FAdpd8RCQkueZrdMhaGNfNOng/m/8jbZ9TaMXVvKJ4o
         QW539tGL2o28zUohBLhGtzyha+WCXU1C7DeWM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=j9TfBHHbq+7kzy8vOIKScq0AhTKwzCpory37PRlKdvM=;
        b=EAH1BEMgb45dSwE5qxzSnIka8QYFttZb0nRXVle4Uhgxa/wcVxZM2cEBXPbhv9Kb2C
         iIRrdNtbKxTWXh1ueCXVUbs/+aBdqdbtI0HXfTgYx8/JBzmheZMHYJ292MU/H16qXiRs
         KWxe/itV+b6TgU1xQZHwUQxb5BpMcu2AwZx6YAuEXv4xhz8ArCxZgqoEJSzNVTdj/AOZ
         IwTcj80Efmy0H+r1i3TR7mnJ97Ib2eSrgAsW5oTsagCRagXuBViU/l3v6dQItasi9cjg
         6fE3bntGXMv66VL9GGak9+sEKMM0BfWzxM4q8E7NbUWxnyLp1+q64lCOGajM9U1FK3TH
         l1fg==
X-Gm-Message-State: APjAAAV6h2QJPP2DCQCEsDSyrMPuTrfF3KUfHh1Yia4vlESIAbi56mTD
        rF+g0NzOWz11FPCTdRM5T+i/8w==
X-Google-Smtp-Source: APXvYqw47FeII3qARiN7JPzisdF0tjbtfd1+btFgnvJajPlhLUioubgJAOM8Fgo/dsR5mGwlGB88MA==
X-Received: by 2002:a17:90a:4803:: with SMTP id a3mr9611774pjh.58.1565994831521;
        Fri, 16 Aug 2019 15:33:51 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o35sm5728404pgm.29.2019.08.16.15.33.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 15:33:51 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net 3/6] bnxt_en: Fix handling FRAG_ERR when NVM_INSTALL_UPDATE cmd fails
Date:   Fri, 16 Aug 2019 18:33:34 -0400
Message-Id: <1565994817-6328-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1565994817-6328-1-git-send-email-michael.chan@broadcom.com>
References: <1565994817-6328-1-git-send-email-michael.chan@broadcom.com>
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

