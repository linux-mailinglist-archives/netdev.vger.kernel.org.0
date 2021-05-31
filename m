Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB1339563B
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 09:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhEaHhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 03:37:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60529 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbhEaHhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 03:37:09 -0400
Received: from mail-wm1-f72.google.com ([209.85.128.72])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lncSP-0002h6-Rd
        for netdev@vger.kernel.org; Mon, 31 May 2021 07:35:29 +0000
Received: by mail-wm1-f72.google.com with SMTP id g9-20020a05600c4ec9b0290198e2707cecso1803164wmq.3
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 00:35:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XhZpqiw5yroQ5T5SjmtgyekQkcqwTSamV1tsKU5zvv4=;
        b=o3tzuHpAejnpFkIRe+8gS03Iah1xbYZqsb7omldsfbYSXSJnCbJvKmdCLzSNB7Ob1P
         R7z+T3nlg1TCJnetb5ILi30McjPmKxniGsT2RO4PbUqfb06HtScLF/kjesxyjX+oM9s4
         jEY2MdmdD1Eeqgpj3jccYw+NLG0UKW9N+f1goeF/2sJUNZ9xIVrrfj2PkVBW3zVR9Wkr
         e/OXN/W5FFj1uW/PyQycO+aEAeKWvUTme5yaHMnB1sfgYmzxuwvCoTgdFo3p8gWMzy7a
         GzfE8IuFxOiL4fDIG7KvU5P8PSn7quLp1+9h9SgLlXrcyGQ8C2HK5aeSyzEDxlYw+x01
         6zWQ==
X-Gm-Message-State: AOAM532P8YkkMmHbzKlAPVlJizOTH+C7Xb5XV+6j/3SEkpzp0v3yF67K
        mYJ34Vfs3C/pBMEGjos50dYCRr03khnW4tOS73SwIKUslsxmaBCMEkDUD1Dco/NavCYoaIUyJox
        Pa3jcK9D3kTj0BbxzsHiL4LRFbrIxww4WOA==
X-Received: by 2002:a5d:6701:: with SMTP id o1mr21259649wru.390.1622446529559;
        Mon, 31 May 2021 00:35:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxk5BA7dTNQ/7+z47YXbPG4XygKbY+0a1oPfGA6FykbFNsBqdHggXywOWUiRmA9mrf397cOBg==
X-Received: by 2002:a5d:6701:: with SMTP id o1mr21259636wru.390.1622446529384;
        Mon, 31 May 2021 00:35:29 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-185-9.adslplus.ch. [188.155.185.9])
        by smtp.gmail.com with ESMTPSA id g10sm17217780wrq.12.2021.05.31.00.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 00:35:29 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 01/11] nfc: fdp: drop ftrace-like debugging messages
Date:   Mon, 31 May 2021 09:35:12 +0200
Message-Id: <20210531073522.6720-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the kernel has ftrace, any debugging calls that just do "made
it to this function!" and "leaving this function!" can be removed.
Better to use standard debugging tools.

This allows also to remove several local variables and entire
fdp_nci_recv_frame() function (whose purpose was only to log).

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/fdp/fdp.c | 31 -------------------------------
 drivers/nfc/fdp/fdp.h |  1 -
 drivers/nfc/fdp/i2c.c | 12 +-----------
 3 files changed, 1 insertion(+), 43 deletions(-)

diff --git a/drivers/nfc/fdp/fdp.c b/drivers/nfc/fdp/fdp.c
index 125d71c27b8b..7863b2536999 100644
--- a/drivers/nfc/fdp/fdp.c
+++ b/drivers/nfc/fdp/fdp.c
@@ -237,28 +237,18 @@ static int fdp_nci_send_patch(struct nci_dev *ndev, u8 conn_id, u8 type)
 static int fdp_nci_open(struct nci_dev *ndev)
 {
 	struct fdp_nci_info *info = nci_get_drvdata(ndev);
-	struct device *dev = &info->phy->i2c_dev->dev;
-
-	dev_dbg(dev, "%s\n", __func__);
 
 	return info->phy_ops->enable(info->phy);
 }
 
 static int fdp_nci_close(struct nci_dev *ndev)
 {
-	struct fdp_nci_info *info = nci_get_drvdata(ndev);
-	struct device *dev = &info->phy->i2c_dev->dev;
-
-	dev_dbg(dev, "%s\n", __func__);
 	return 0;
 }
 
 static int fdp_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
 {
 	struct fdp_nci_info *info = nci_get_drvdata(ndev);
-	struct device *dev = &info->phy->i2c_dev->dev;
-
-	dev_dbg(dev, "%s\n", __func__);
 
 	if (atomic_dec_and_test(&info->data_pkt_counter))
 		info->data_pkt_counter_cb(ndev);
@@ -266,16 +256,6 @@ static int fdp_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
 	return info->phy_ops->write(info->phy, skb);
 }
 
-int fdp_nci_recv_frame(struct nci_dev *ndev, struct sk_buff *skb)
-{
-	struct fdp_nci_info *info = nci_get_drvdata(ndev);
-	struct device *dev = &info->phy->i2c_dev->dev;
-
-	dev_dbg(dev, "%s\n", __func__);
-	return nci_recv_frame(ndev, skb);
-}
-EXPORT_SYMBOL(fdp_nci_recv_frame);
-
 static int fdp_nci_request_firmware(struct nci_dev *ndev)
 {
 	struct fdp_nci_info *info = nci_get_drvdata(ndev);
@@ -476,8 +456,6 @@ static int fdp_nci_setup(struct nci_dev *ndev)
 	int r;
 	u8 patched = 0;
 
-	dev_dbg(dev, "%s\n", __func__);
-
 	r = nci_core_init(ndev);
 	if (r)
 		goto error;
@@ -585,9 +563,7 @@ static int fdp_nci_core_reset_ntf_packet(struct nci_dev *ndev,
 					  struct sk_buff *skb)
 {
 	struct fdp_nci_info *info = nci_get_drvdata(ndev);
-	struct device *dev = &info->phy->i2c_dev->dev;
 
-	dev_dbg(dev, "%s\n", __func__);
 	info->setup_reset_ntf = 1;
 	wake_up(&info->setup_wq);
 
@@ -598,9 +574,7 @@ static int fdp_nci_prop_patch_ntf_packet(struct nci_dev *ndev,
 					  struct sk_buff *skb)
 {
 	struct fdp_nci_info *info = nci_get_drvdata(ndev);
-	struct device *dev = &info->phy->i2c_dev->dev;
 
-	dev_dbg(dev, "%s\n", __func__);
 	info->setup_patch_ntf = 1;
 	info->setup_patch_status = skb->data[0];
 	wake_up(&info->setup_wq);
@@ -773,11 +747,6 @@ EXPORT_SYMBOL(fdp_nci_probe);
 
 void fdp_nci_remove(struct nci_dev *ndev)
 {
-	struct fdp_nci_info *info = nci_get_drvdata(ndev);
-	struct device *dev = &info->phy->i2c_dev->dev;
-
-	dev_dbg(dev, "%s\n", __func__);
-
 	nci_unregister_device(ndev);
 	nci_free_device(ndev);
 }
diff --git a/drivers/nfc/fdp/fdp.h b/drivers/nfc/fdp/fdp.h
index 9bd1f3f23e2d..ead3b21ccae6 100644
--- a/drivers/nfc/fdp/fdp.h
+++ b/drivers/nfc/fdp/fdp.h
@@ -25,6 +25,5 @@ int fdp_nci_probe(struct fdp_i2c_phy *phy, struct nfc_phy_ops *phy_ops,
 		  struct nci_dev **ndev, int tx_headroom, int tx_tailroom,
 		  u8 clock_type, u32 clock_freq, u8 *fw_vsc_cfg);
 void fdp_nci_remove(struct nci_dev *ndev);
-int fdp_nci_recv_frame(struct nci_dev *ndev, struct sk_buff *skb);
 
 #endif /* __LOCAL_FDP_H_ */
diff --git a/drivers/nfc/fdp/i2c.c b/drivers/nfc/fdp/i2c.c
index 997e0806821a..c5596e514648 100644
--- a/drivers/nfc/fdp/i2c.c
+++ b/drivers/nfc/fdp/i2c.c
@@ -49,7 +49,6 @@ static int fdp_nci_i2c_enable(void *phy_id)
 {
 	struct fdp_i2c_phy *phy = phy_id;
 
-	dev_dbg(&phy->i2c_dev->dev, "%s\n", __func__);
 	fdp_nci_i2c_reset(phy);
 
 	return 0;
@@ -59,7 +58,6 @@ static void fdp_nci_i2c_disable(void *phy_id)
 {
 	struct fdp_i2c_phy *phy = phy_id;
 
-	dev_dbg(&phy->i2c_dev->dev, "%s\n", __func__);
 	fdp_nci_i2c_reset(phy);
 }
 
@@ -197,7 +195,6 @@ static int fdp_nci_i2c_read(struct fdp_i2c_phy *phy, struct sk_buff **skb)
 static irqreturn_t fdp_nci_i2c_irq_thread_fn(int irq, void *phy_id)
 {
 	struct fdp_i2c_phy *phy = phy_id;
-	struct i2c_client *client;
 	struct sk_buff *skb;
 	int r;
 
@@ -206,9 +203,6 @@ static irqreturn_t fdp_nci_i2c_irq_thread_fn(int irq, void *phy_id)
 		return IRQ_NONE;
 	}
 
-	client = phy->i2c_dev;
-	dev_dbg(&client->dev, "%s\n", __func__);
-
 	r = fdp_nci_i2c_read(phy, &skb);
 
 	if (r == -EREMOTEIO)
@@ -217,7 +211,7 @@ static irqreturn_t fdp_nci_i2c_irq_thread_fn(int irq, void *phy_id)
 		return IRQ_HANDLED;
 
 	if (skb != NULL)
-		fdp_nci_recv_frame(phy->ndev, skb);
+		nci_recv_frame(phy->ndev, skb);
 
 	return IRQ_HANDLED;
 }
@@ -288,8 +282,6 @@ static int fdp_nci_i2c_probe(struct i2c_client *client)
 	u32 clock_freq;
 	int r = 0;
 
-	dev_dbg(dev, "%s\n", __func__);
-
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
 		nfc_err(dev, "No I2C_FUNC_I2C support\n");
 		return -ENODEV;
@@ -351,8 +343,6 @@ static int fdp_nci_i2c_remove(struct i2c_client *client)
 {
 	struct fdp_i2c_phy *phy = i2c_get_clientdata(client);
 
-	dev_dbg(&client->dev, "%s\n", __func__);
-
 	fdp_nci_remove(phy->ndev);
 	fdp_nci_i2c_disable(phy);
 
-- 
2.27.0

