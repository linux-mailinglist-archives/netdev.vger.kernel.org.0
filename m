Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEDBD3D518E
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 05:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbhGZCt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 22:49:29 -0400
Received: from m12-18.163.com ([220.181.12.18]:44582 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230272AbhGZCt2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Jul 2021 22:49:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=7op6m56/dGB1Lg2P29
        4qblAAw+jAlLNUp/4RqF0Expo=; b=nrszWcPLo6ajtRzl39293TPa7RfU3QiSJc
        76aJQsuKCRSmUWyuuoYxJidlJVSgGKx+eUH3J67FJ6gXIQrtmmcGDJIeUAQPhfI2
        WBFKb0ZGhJmySfQct1Mh0rr3kBDR53LuokD1IUlVgzKtUDZmaw/bthx3HW7N8ssC
        T4vzQVu1Y=
Received: from wengjianfeng.ccdomain.com (unknown [218.17.89.92])
        by smtp14 (Coremail) with SMTP id EsCowAAnIsIHLP5g+6tMwg--.32144S2;
        Mon, 26 Jul 2021 11:29:14 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     krzysztof.kozlowski@canonical.com, k.opasiak@samsung.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH] nfc: s3fwrn5: remove unnecessary label
Date:   Mon, 26 Jul 2021 11:29:17 +0800
Message-Id: <20210726032917.30076-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: EsCowAAnIsIHLP5g+6tMwg--.32144S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7uw4kuFW8WFWrGrWDXw4ruFg_yoW8CFWrp3
        WrKayjgFW5KF1rWr1ktwsrua4agr4xGryxG39rta93Zr4Fvr1kJw1qvFyI9rW8GFyrCa13
        tF47Zw45CF15Wa7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07bj9N3UUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/xtbBLB-bsV++Mq0n3QAAsd
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

Simplify the code by removing unnecessary label and returning directly.

Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
---
 drivers/nfc/s3fwrn5/firmware.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/nfc/s3fwrn5/firmware.c b/drivers/nfc/s3fwrn5/firmware.c
index eb5d7a5b..1421ffd 100644
--- a/drivers/nfc/s3fwrn5/firmware.c
+++ b/drivers/nfc/s3fwrn5/firmware.c
@@ -421,10 +421,9 @@ int s3fwrn5_fw_download(struct s3fwrn5_fw_info *fw_info)
 
 	tfm = crypto_alloc_shash("sha1", 0, 0);
 	if (IS_ERR(tfm)) {
-		ret = PTR_ERR(tfm);
 		dev_err(&fw_info->ndev->nfc_dev->dev,
 			"Cannot allocate shash (code=%d)\n", ret);
-		goto out;
+		return PTR_ERR(tfm);
 	}
 
 	ret = crypto_shash_tfm_digest(tfm, fw->image, image_size, hash_data);
@@ -433,7 +432,7 @@ int s3fwrn5_fw_download(struct s3fwrn5_fw_info *fw_info)
 	if (ret) {
 		dev_err(&fw_info->ndev->nfc_dev->dev,
 			"Cannot compute hash (code=%d)\n", ret);
-		goto out;
+		return ret;
 	}
 
 	/* Firmware update process */
@@ -446,7 +445,7 @@ int s3fwrn5_fw_download(struct s3fwrn5_fw_info *fw_info)
 	if (ret < 0) {
 		dev_err(&fw_info->ndev->nfc_dev->dev,
 			"Unable to enter update mode\n");
-		goto out;
+		return ret;
 	}
 
 	for (off = 0; off < image_size; off += fw_info->sector_size) {
@@ -455,7 +454,7 @@ int s3fwrn5_fw_download(struct s3fwrn5_fw_info *fw_info)
 		if (ret < 0) {
 			dev_err(&fw_info->ndev->nfc_dev->dev,
 				"Firmware update error (code=%d)\n", ret);
-			goto out;
+			return ret;
 		}
 	}
 
@@ -463,13 +462,12 @@ int s3fwrn5_fw_download(struct s3fwrn5_fw_info *fw_info)
 	if (ret < 0) {
 		dev_err(&fw_info->ndev->nfc_dev->dev,
 			"Unable to complete update mode\n");
-		goto out;
+		return ret;
 	}
 
 	dev_info(&fw_info->ndev->nfc_dev->dev,
 		"Firmware update: success\n");
 
-out:
 	return ret;
 }
 
-- 
1.9.1


