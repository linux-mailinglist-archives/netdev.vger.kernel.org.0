Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A2D359DED
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 13:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233554AbhDILul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 07:50:41 -0400
Received: from m12-16.163.com ([220.181.12.16]:41102 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233506AbhDILuj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 07:50:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=5Uf9dfr4JtxSkYao+s
        tE9Z+GaUR3mC5gN8/IqbqlzoM=; b=Sjoe/ROfYKxs2Ce7Ljc2+7BDkZmo60rd9H
        AiIPwjF5CtbOiDFbtIfdziS0jGMMbSYD5MxdGmCx5tpWDEjxa0kOTev4IfCEBo1Y
        2IUrGclv6txY9HJj7w1s1oN/lzQd9CWUYfx8sWGUKtl/RpRgnPVrFHE03g8TdpbB
        +sANnnd98=
Received: from wengjianfeng.ccdomain.com (unknown [119.137.53.45])
        by smtp12 (Coremail) with SMTP id EMCowAC3h0J0P3Bgy3sNkw--.5190S2;
        Fri, 09 Apr 2021 19:50:14 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     gustavoars@kernel.org, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH] nfc: pn533: remove redundant assignment
Date:   Fri,  9 Apr 2021 19:50:09 +0800
Message-Id: <20210409115010.33436-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: EMCowAC3h0J0P3Bgy3sNkw--.5190S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxAw1kXr1ktFW8Kry7JrW7CFg_yoW5urWUpF
        ZrGa43CryUK3yvva1UGws8Za45Jrs7try7KFWkK3ZrZF98AF1kJFWFqFy09Fn5urWkGry7
        ZrWqqFW5GayUtFUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07Uulk-UUUUU=
X-Originating-IP: [119.137.53.45]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/1tbiHRZvsVSIqGtyQgAAs6
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

In many places,first assign a value to a variable and then return
the variable. which is redundant, we should directly return the value.
in pn533_rf_field funciton,return statement in the if statement is
redundant, we just delete it.

Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
---
 drivers/nfc/pn533/i2c.c   |  8 ++------
 drivers/nfc/pn533/pn533.c | 16 +++-------------
 drivers/nfc/pn533/uart.c  |  3 +--
 3 files changed, 6 insertions(+), 21 deletions(-)

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
index f1469ac..61ab4c0 100644
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
@@ -2614,7 +2606,6 @@ static int pn533_rf_field(struct nfc_dev *nfc_dev, u8 rf)
 				     (u8 *)&rf_field, 1);
 	if (rc) {
 		nfc_err(dev->dev, "Error on setting RF field\n");
-		return rc;
 	}
 
 	return rc;
@@ -2791,7 +2782,6 @@ struct pn533 *pn53x_common_init(u32 device_type,
 				struct device *dev)
 {
 	struct pn533 *priv;
-	int rc = -ENOMEM;
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -2833,7 +2823,7 @@ struct pn533 *pn53x_common_init(u32 device_type,
 
 error:
 	kfree(priv);
-	return ERR_PTR(rc);
+	return ERR_PTR(-ENOMEM);
 }
 EXPORT_SYMBOL_GPL(pn53x_common_init);
 
diff --git a/drivers/nfc/pn533/uart.c b/drivers/nfc/pn533/uart.c
index a0665d8..6465348 100644
--- a/drivers/nfc/pn533/uart.c
+++ b/drivers/nfc/pn533/uart.c
@@ -239,9 +239,8 @@ static int pn532_uart_probe(struct serdev_device *serdev)
 {
 	struct pn532_uart_phy *pn532;
 	struct pn533 *priv;
-	int err;
+	int err = -ENOMEM;
 
-	err = -ENOMEM;
 	pn532 = kzalloc(sizeof(*pn532), GFP_KERNEL);
 	if (!pn532)
 		goto err_exit;
-- 
1.9.1


