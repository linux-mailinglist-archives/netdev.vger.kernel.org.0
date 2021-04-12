Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C44A35B8CE
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 05:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236653AbhDLDHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 23:07:05 -0400
Received: from m12-13.163.com ([220.181.12.13]:35439 "EHLO m12-13.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236339AbhDLDHD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Apr 2021 23:07:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=yD6c6fsWrJHK90pler
        DKXssM9P4DHsxvALO+xKMOr0M=; b=gK0Q7J8nlRmcLtsr/+SrO+dG15UXlJH5IM
        qXTQf3SYPgF6jLRKBZFxvOwL0n1Bda2S1DBczTE/i3S3MWTQK7QxA8Mo4JTshb24
        Je7cXaIpz9FS1vGZhehSTsoZXb+4eZX2wlQUL3fz5qW6xFeDCGUkt7To1j7UMtGw
        iq197+eAo=
Received: from wengjianfeng.ccdomain.com (unknown [218.17.89.92])
        by smtp9 (Coremail) with SMTP id DcCowACnS8VYrnNgOR8hFg--.48726S2;
        Mon, 12 Apr 2021 10:20:10 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     gustavoars@kernel.org, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH v2] nfc: pn533: remove redundant assignment
Date:   Mon, 12 Apr 2021 10:20:06 +0800
Message-Id: <20210412022006.28532-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: DcCowACnS8VYrnNgOR8hFg--.48726S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxAw1kXr1ktFW8tw4xtrWrZrb_yoW5WF1fpF
        ZrZa43CryUKrWvva1UGws8Z3W3Xrs2yr9rKFWkKas7AFyDZF4kAFWFqF10grn5WrykCry3
        ArWqqF45GayUtFUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jQDG5UUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/1tbiwRtysVr7sfj1DwAAsL
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

In many places,first assign a value to a variable and then return
the variable. which is redundant, we should directly return the value.
in pn533_rf_field funciton,return rc also in the if statement, so we
use return 0 to replace the last return rc.

Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
---
 drivers/nfc/pn533/i2c.c   |  8 ++------
 drivers/nfc/pn533/pn533.c | 17 ++++-------------
 2 files changed, 6 insertions(+), 19 deletions(-)

diff --git a/drivers/nfc/pn533/i2c.c b/drivers/nfc/pn533/i2c.c
index 0207e66..795da9b 100644
--- a/drivers/nfc/pn533/i2c.c
+++ b/drivers/nfc/pn533/i2c.c
@@ -40,11 +40,8 @@ static int pn533_i2c_send_ack(struct pn533 *dev, gfp_t flags)
 	struct i2c_client *client = phy->i2c_dev;
 	static const u8 ack[6] = {0x00, 0x00, 0xff, 0x00, 0xff, 0x00};
 	/* spec 6.2.1.3:  Preamble, SoPC (2), ACK Code (2), Postamble */
-	int rc;
-
-	rc = i2c_master_send(client, ack, 6);
 
-	return rc;
+	return i2c_master_send(client, ack, 6);
 }
 
 static int pn533_i2c_send_frame(struct pn533 *dev,
@@ -199,8 +196,7 @@ static int pn533_i2c_probe(struct i2c_client *client,
 				&phy->i2c_dev->dev);
 
 	if (IS_ERR(priv)) {
-		r = PTR_ERR(priv);
-		return r;
+		return PTR_ERR(priv);
 	}
 
 	phy->priv = priv;
diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
index f1469ac..e196732 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -489,12 +489,8 @@ static int pn533_send_data_async(struct pn533 *dev, u8 cmd_code,
 				 pn533_send_async_complete_t complete_cb,
 				 void *complete_cb_context)
 {
-	int rc;
-
-	rc = __pn533_send_async(dev, cmd_code, req, complete_cb,
+	return __pn533_send_async(dev, cmd_code, req, complete_cb,
 				complete_cb_context);
-
-	return rc;
 }
 
 static int pn533_send_cmd_async(struct pn533 *dev, u8 cmd_code,
@@ -502,12 +498,8 @@ static int pn533_send_cmd_async(struct pn533 *dev, u8 cmd_code,
 				pn533_send_async_complete_t complete_cb,
 				void *complete_cb_context)
 {
-	int rc;
-
-	rc = __pn533_send_async(dev, cmd_code, req, complete_cb,
+	return __pn533_send_async(dev, cmd_code, req, complete_cb,
 				complete_cb_context);
-
-	return rc;
 }
 
 /*
@@ -2617,7 +2609,7 @@ static int pn533_rf_field(struct nfc_dev *nfc_dev, u8 rf)
 		return rc;
 	}
 
-	return rc;
+	return 0;
 }
 
 static int pn532_sam_configuration(struct nfc_dev *nfc_dev)
@@ -2791,7 +2783,6 @@ struct pn533 *pn53x_common_init(u32 device_type,
 				struct device *dev)
 {
 	struct pn533 *priv;
-	int rc = -ENOMEM;
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -2833,7 +2824,7 @@ struct pn533 *pn53x_common_init(u32 device_type,
 
 error:
 	kfree(priv);
-	return ERR_PTR(rc);
+	return ERR_PTR(-ENOMEM);
 }
 EXPORT_SYMBOL_GPL(pn53x_common_init);
 
-- 
1.9.1


