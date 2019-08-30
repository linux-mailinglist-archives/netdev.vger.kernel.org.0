Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8400CA2DA6
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 05:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbfH3Dze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 23:55:34 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41338 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727270AbfH3Dzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 23:55:33 -0400
Received: by mail-pf1-f193.google.com with SMTP id 196so3664649pfz.8
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 20:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3qwxRggg6H/R8W+1L4rWEhxGEiQAXCYM0hKstv62OBo=;
        b=EmuUP7Ki0RxnPgCAGDkyNIgGwYxQEcwWp2x6WfG9B8jK5cVS6/jd+9AQOe6DCx9I8T
         Cb6cgqoEyM33yDSd5FdPcxUuM+R+ZdmhkwwS7UM30vs3KDbLCsjqTlqfJyTML11IJX2K
         uuypz+pCxlrMks2akxSELsOyWJ/ZbP+HtSzHk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3qwxRggg6H/R8W+1L4rWEhxGEiQAXCYM0hKstv62OBo=;
        b=k6yW4CLUSI6KaXw0ZuwMSg3D/sgvAiA7jVI36S3EA44rc2Si2rjUItqmb4cXf0ko6f
         BIEmbiVh081q8g2KiU72i/Dr+hrzsqfHtfLTIKGNhjnY2mRU53tOz14S7ObNkJOBCyKY
         fg9fADxzDtwA66p4j2KcuR71pDAupqomDS2I2/cMTILE3pWRa+ESLQwA9vSDKpUfAncK
         aMY3/Kw7jruZXD0vLnpcydB4f3UyoYb2fNgBYpALZRPdmle2Q5H5eDyIWx781g0xaD7X
         Kd6riemwlPUcPS05/dtowkovAitJtu/3YG24F5/BhC//xatkHkHTe+4ryqUSaRQLJvCi
         qMow==
X-Gm-Message-State: APjAAAU+d5xTCeHZ26JJgwxU/hyk0B1d+G8WKAVKjnRnwQhT5JhLo4Pc
        XV0TSfFNU6dZz1JFpBqvrJtqgazLnYg=
X-Google-Smtp-Source: APXvYqwrmdDQHZXZ+pvx5+Tq2B3/znlaTGNZs/0ff05m1C+tprh04f9me0IJML6hxmgUL14A/OsZwQ==
X-Received: by 2002:a63:d30f:: with SMTP id b15mr11151292pgg.341.1567137332268;
        Thu, 29 Aug 2019 20:55:32 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l3sm3658877pjq.24.2019.08.29.20.55.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 20:55:31 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        ray.jui@broadcom.com
Subject: [PATCH net-next v2 01/22] bnxt_en: Use a common function to print the same ethtool -f error message.
Date:   Thu, 29 Aug 2019 23:54:44 -0400
Message-Id: <1567137305-5853-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
References: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The same message is printed 3 times in the code, so use a common function
to do that.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index b624174..72bb730 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1699,6 +1699,11 @@ static u32 bnxt_get_link(struct net_device *dev)
 	return bp->link_info.link_up;
 }
 
+static void bnxt_print_admin_err(struct bnxt *bp)
+{
+	netdev_info(bp->dev, "PF does not have admin privileges to flash or reset the device\n");
+}
+
 static int bnxt_find_nvram_item(struct net_device *dev, u16 type, u16 ordinal,
 				u16 ext, u16 *index, u32 *item_length,
 				u32 *data_length);
@@ -1739,8 +1744,7 @@ static int bnxt_flash_nvram(struct net_device *dev,
 	dma_free_coherent(&bp->pdev->dev, data_len, kmem, dma_handle);
 
 	if (rc == HWRM_ERR_CODE_RESOURCE_ACCESS_DENIED) {
-		netdev_info(dev,
-			    "PF does not have admin privileges to flash the device\n");
+		bnxt_print_admin_err(bp);
 		rc = -EACCES;
 	} else if (rc) {
 		rc = -EIO;
@@ -1795,8 +1799,7 @@ static int bnxt_firmware_reset(struct net_device *dev,
 
 	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 	if (rc == HWRM_ERR_CODE_RESOURCE_ACCESS_DENIED) {
-		netdev_info(dev,
-			    "PF does not have admin privileges to reset the device\n");
+		bnxt_print_admin_err(bp);
 		rc = -EACCES;
 	} else if (rc) {
 		rc = -EIO;
@@ -2096,8 +2099,7 @@ static int bnxt_flash_package_from_file(struct net_device *dev,
 	mutex_unlock(&bp->hwrm_cmd_lock);
 err_exit:
 	if (hwrm_err == HWRM_ERR_CODE_RESOURCE_ACCESS_DENIED) {
-		netdev_info(dev,
-			    "PF does not have admin privileges to flash the device\n");
+		bnxt_print_admin_err(bp);
 		rc = -EACCES;
 	} else if (hwrm_err) {
 		rc = -EOPNOTSUPP;
-- 
2.5.1

