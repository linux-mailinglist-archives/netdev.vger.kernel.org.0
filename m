Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7AB480925
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 13:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbhL1Mfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 07:35:55 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:17307 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231271AbhL1Mfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 07:35:55 -0500
Received: from canpemm500009.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JNYrx1wQNz9rwh;
        Tue, 28 Dec 2021 20:34:57 +0800 (CST)
Received: from localhost.localdomain (10.175.102.38) by
 canpemm500009.china.huawei.com (7.192.105.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 28 Dec 2021 20:35:52 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christophe Ricard <christophe.ricard@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>
CC:     Wei Yongjun <weiyongjun1@huawei.com>, <netdev@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: [PATCH net] NFC: st21nfca: Fix memory leak in device probe and remove
Date:   Tue, 28 Dec 2021 12:48:11 +0000
Message-ID: <20211228124811.3122182-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.102.38]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500009.china.huawei.com (7.192.105.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'phy->pending_skb' is alloced when device probe, but forgot to free
in the error handling path and remove path, this cause memory leak
as follows:

unreferenced object 0xffff88800bc06800 (size 512):
  comm "8", pid 11775, jiffies 4295159829 (age 9.032s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000d66c09ce>] __kmalloc_node_track_caller+0x1ed/0x450
    [<00000000c93382b3>] kmalloc_reserve+0x37/0xd0
    [<000000005fea522c>] __alloc_skb+0x124/0x380
    [<0000000019f29f9a>] st21nfca_hci_i2c_probe+0x170/0x8f2

Fix it by freeing 'pending_skb' in error and remove.

Fixes: 68957303f44a ("NFC: ST21NFCA: Add driver for STMicroelectronics ST21NFCA NFC Chip")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

diff --git a/drivers/nfc/st21nfca/i2c.c b/drivers/nfc/st21nfca/i2c.c
index f126ce96a7df..35b32fb90906 100644
--- a/drivers/nfc/st21nfca/i2c.c
+++ b/drivers/nfc/st21nfca/i2c.c
@@ -524,7 +524,8 @@ static int st21nfca_hci_i2c_probe(struct i2c_client *client,
 	phy->gpiod_ena = devm_gpiod_get(dev, "enable", GPIOD_OUT_LOW);
 	if (IS_ERR(phy->gpiod_ena)) {
 		nfc_err(dev, "Unable to get ENABLE GPIO\n");
-		return PTR_ERR(phy->gpiod_ena);
+		r = PTR_ERR(phy->gpiod_ena);
+		goto out_free;
 	}
 
 	phy->se_status.is_ese_present =
@@ -535,7 +536,7 @@ static int st21nfca_hci_i2c_probe(struct i2c_client *client,
 	r = st21nfca_hci_platform_init(phy);
 	if (r < 0) {
 		nfc_err(&client->dev, "Unable to reboot st21nfca\n");
-		return r;
+		goto out_free;
 	}
 
 	r = devm_request_threaded_irq(&client->dev, client->irq, NULL,
@@ -544,15 +545,23 @@ static int st21nfca_hci_i2c_probe(struct i2c_client *client,
 				ST21NFCA_HCI_DRIVER_NAME, phy);
 	if (r < 0) {
 		nfc_err(&client->dev, "Unable to register IRQ handler\n");
-		return r;
+		goto out_free;
 	}
 
-	return st21nfca_hci_probe(phy, &i2c_phy_ops, LLC_SHDLC_NAME,
-					ST21NFCA_FRAME_HEADROOM,
-					ST21NFCA_FRAME_TAILROOM,
-					ST21NFCA_HCI_LLC_MAX_PAYLOAD,
-					&phy->hdev,
-					&phy->se_status);
+	r = st21nfca_hci_probe(phy, &i2c_phy_ops, LLC_SHDLC_NAME,
+			       ST21NFCA_FRAME_HEADROOM,
+			       ST21NFCA_FRAME_TAILROOM,
+			       ST21NFCA_HCI_LLC_MAX_PAYLOAD,
+			       &phy->hdev,
+			       &phy->se_status);
+	if (r)
+		goto out_free;
+
+	return 0;
+
+out_free:
+	kfree_skb(phy->pending_skb);
+	return r;
 }
 
 static int st21nfca_hci_i2c_remove(struct i2c_client *client)
@@ -563,6 +572,8 @@ static int st21nfca_hci_i2c_remove(struct i2c_client *client)
 
 	if (phy->powered)
 		st21nfca_hci_i2c_disable(phy);
+	if (phy->pending_skb)
+		kfree_skb(phy->pending_skb);
 
 	return 0;
 }
-- 
2.25.1

