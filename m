Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5305E175206
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 04:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgCBDHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 22:07:36 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42581 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726720AbgCBDHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 22:07:35 -0500
Received: by mail-pf1-f193.google.com with SMTP id 15so4817931pfo.9
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 19:07:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=V4IGtzvYBQmJamTAPcYizZMCcaggwR6ffcm8oX5SXh4=;
        b=UmOK7yewjvstHQvH7Xb7z2muqfX7c9g/i8Q/26gYieg8nWzG6ngX9ZAH2zFKKrLqhC
         h018P4r1plDu9Nc39Sujc7yzJBIm6WodeYEe2UcB8bVRgVlgH2bJDB1qtHKDHNUvhMNA
         924GSDg4wtte+i7KfKcvUS+hqwkqZJirxRqBU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=V4IGtzvYBQmJamTAPcYizZMCcaggwR6ffcm8oX5SXh4=;
        b=QRU+auWo2vb+3QR+r2W5mUjm3YnjXCw7rQoHgnESMYCUDhyHT3Ib2mZeKTwi+qp/RL
         6U4H2UpKCbg4ZPdG/EDdQHgjrmI6EDXoq3tmh+MKnpCSqQCsAsYoDv+kL3+lKPgiqNfM
         TRWOFCKiIBNYrrdCM38/ityjFIddTDrTJJZXL28RUuYzHT5wqKpPbl+SJ6KQnMzoNlbD
         h0POgg15ypxcH7UrD5XkL/Z4V7q05XXYvWOm4fE5pm+3iQLRU43d9kcprsVTS7EXqP89
         ewWJq3A8u72oZyI0gs57p4x+bFz2Kym1/O1tuhoOzWKLvFQBLKvE7n7YXKo9h51YHN8G
         xI1Q==
X-Gm-Message-State: APjAAAVFL1vMSwijEYDiHwi6z+K1pynOZpc05uZPLiexKBXgBWkMbJTE
        tfbehaHpG48YT086FdD6qJK0reE2hOQ=
X-Google-Smtp-Source: APXvYqxzK4oBSxnSp/YjedmCiGW6X7EGoNDG3RxLCLUc4G8E05I9O9zTMNGVX9Fm9KWOvSDqPAnN+w==
X-Received: by 2002:aa7:96c7:: with SMTP id h7mr15373212pfq.211.1583118454079;
        Sun, 01 Mar 2020 19:07:34 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f1sm9809278pjq.31.2020.03.01.19.07.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 01 Mar 2020 19:07:33 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 2/2] bnxt_en: fix error handling when flashing from file
Date:   Sun,  1 Mar 2020 22:07:18 -0500
Message-Id: <1583118438-18829-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1583118438-18829-1-git-send-email-michael.chan@broadcom.com>
References: <1583118438-18829-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edwin Peer <edwin.peer@broadcom.com>

After bnxt_hwrm_do_send_message() was updated to return standard error
codes in a recent commit, a regression in bnxt_flash_package_from_file()
was introduced.  The return value does not properly reflect all
possible firmware errors when calling firmware to flash the package.

Fix it by consolidating all errors in one local variable rc instead
of having 2 variables for different errors.

Fixes: d4f1420d3656 ("bnxt_en: Convert error code in firmware message response to standard code.")
Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 24 +++++++++++------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index e8fc167..1f67e67 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2007,8 +2007,8 @@ int bnxt_flash_package_from_file(struct net_device *dev, const char *filename,
 	struct hwrm_nvm_install_update_output *resp = bp->hwrm_cmd_resp_addr;
 	struct hwrm_nvm_install_update_input install = {0};
 	const struct firmware *fw;
-	int rc, hwrm_err = 0;
 	u32 item_len;
+	int rc = 0;
 	u16 index;
 
 	bnxt_hwrm_fw_set_time(bp);
@@ -2052,15 +2052,14 @@ int bnxt_flash_package_from_file(struct net_device *dev, const char *filename,
 			memcpy(kmem, fw->data, fw->size);
 			modify.host_src_addr = cpu_to_le64(dma_handle);
 
-			hwrm_err = hwrm_send_message(bp, &modify,
-						     sizeof(modify),
-						     FLASH_PACKAGE_TIMEOUT);
+			rc = hwrm_send_message(bp, &modify, sizeof(modify),
+					       FLASH_PACKAGE_TIMEOUT);
 			dma_free_coherent(&bp->pdev->dev, fw->size, kmem,
 					  dma_handle);
 		}
 	}
 	release_firmware(fw);
-	if (rc || hwrm_err)
+	if (rc)
 		goto err_exit;
 
 	if ((install_type & 0xffff) == 0)
@@ -2069,20 +2068,19 @@ int bnxt_flash_package_from_file(struct net_device *dev, const char *filename,
 	install.install_type = cpu_to_le32(install_type);
 
 	mutex_lock(&bp->hwrm_cmd_lock);
-	hwrm_err = _hwrm_send_message(bp, &install, sizeof(install),
-				      INSTALL_PACKAGE_TIMEOUT);
-	if (hwrm_err) {
+	rc = _hwrm_send_message(bp, &install, sizeof(install),
+				INSTALL_PACKAGE_TIMEOUT);
+	if (rc) {
 		u8 error_code = ((struct hwrm_err_output *)resp)->cmd_err;
 
 		if (resp->error_code && error_code ==
 		    NVM_INSTALL_UPDATE_CMD_ERR_CODE_FRAG_ERR) {
 			install.flags |= cpu_to_le16(
 			       NVM_INSTALL_UPDATE_REQ_FLAGS_ALLOWED_TO_DEFRAG);
-			hwrm_err = _hwrm_send_message(bp, &install,
-						      sizeof(install),
-						      INSTALL_PACKAGE_TIMEOUT);
+			rc = _hwrm_send_message(bp, &install, sizeof(install),
+						INSTALL_PACKAGE_TIMEOUT);
 		}
-		if (hwrm_err)
+		if (rc)
 			goto flash_pkg_exit;
 	}
 
@@ -2094,7 +2092,7 @@ int bnxt_flash_package_from_file(struct net_device *dev, const char *filename,
 flash_pkg_exit:
 	mutex_unlock(&bp->hwrm_cmd_lock);
 err_exit:
-	if (hwrm_err == -EACCES)
+	if (rc == -EACCES)
 		bnxt_print_admin_err(bp);
 	return rc;
 }
-- 
2.5.1

