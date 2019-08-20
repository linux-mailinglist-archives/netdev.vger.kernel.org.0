Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F03395DDD
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 13:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729908AbfHTLwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 07:52:12 -0400
Received: from smtp2.goneo.de ([85.220.129.33]:52262 "EHLO smtp2.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729556AbfHTLwL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 07:52:11 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp2.goneo.de (Postfix) with ESMTP id C7F1D23FC29;
        Tue, 20 Aug 2019 13:52:07 +0200 (CEST)
X-Virus-Scanned: by goneo
X-Spam-Flag: NO
X-Spam-Score: -3.129
X-Spam-Level: 
X-Spam-Status: No, score=-3.129 tagged_above=-999 tests=[ALL_TRUSTED=-1,
        AWL=-0.229, BAYES_00=-1.9] autolearn=ham
Received: from smtp2.goneo.de ([127.0.0.1])
        by localhost (smtp2.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id MoqZxFqK0rzQ; Tue, 20 Aug 2019 13:52:01 +0200 (CEST)
Received: from lem-wkst-02.lemonage.de. (hq.lemonage.de [87.138.178.34])
        by smtp2.goneo.de (Postfix) with ESMTPA id 175ED23F84E;
        Tue, 20 Aug 2019 13:52:01 +0200 (CEST)
From:   Lars Poeschel <poeschel@lemonage.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Allison Randal <allison@lohutok.net>,
        Steve Winslow <swinslow@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Lars Poeschel <poeschel@lemonage.de>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kees Cook <keescook@chromium.org>,
        Jilayne Lovejoy <opensource@jilayne.com>,
        netdev@vger.kernel.org (open list:NFC SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Cc:     Johan Hovold <johan@kernel.org>
Subject: [PATCH v6 4/7] nfc: pn533: Split pn533 init & nfc_register
Date:   Tue, 20 Aug 2019 14:03:41 +0200
Message-Id: <20190820120345.22593-4-poeschel@lemonage.de>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190820120345.22593-1-poeschel@lemonage.de>
References: <20190820120345.22593-1-poeschel@lemonage.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a problem in the initialisation and setup of the pn533: It
registers with nfc too early. It could happen, that it finished
registering with nfc and someone starts using it. But setup of the pn533
is not yet finished. Bad or at least unintended things could happen.
So I split out nfc registering (and unregistering) to seperate functions
that have to be called late in probe then.

Cc: Johan Hovold <johan@kernel.org>
Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
---
Changes in v6:
- Rebased the patch series on v5.3-rc5

Changes in v5:
- This patch is new in v5

 drivers/nfc/pn533/i2c.c   | 17 +++++-----
 drivers/nfc/pn533/pn533.c | 66 ++++++++++++++++++++-------------------
 drivers/nfc/pn533/pn533.h | 11 ++++---
 drivers/nfc/pn533/usb.c   | 12 +++++--
 4 files changed, 59 insertions(+), 47 deletions(-)

diff --git a/drivers/nfc/pn533/i2c.c b/drivers/nfc/pn533/i2c.c
index 1abd40398a5a..e9e5a1ec8857 100644
--- a/drivers/nfc/pn533/i2c.c
+++ b/drivers/nfc/pn533/i2c.c
@@ -193,12 +193,10 @@ static int pn533_i2c_probe(struct i2c_client *client,
 	phy->i2c_dev = client;
 	i2c_set_clientdata(client, phy);
 
-	priv = pn533_register_device(PN533_DEVICE_PN532,
-				     PN533_NO_TYPE_B_PROTOCOLS,
+	priv = pn53x_common_init(PN533_DEVICE_PN532,
 				     PN533_PROTO_REQ_ACK_RESP,
 				     phy, &i2c_phy_ops, NULL,
-				     &phy->i2c_dev->dev,
-				     &client->dev);
+				     &phy->i2c_dev->dev);
 
 	if (IS_ERR(priv)) {
 		r = PTR_ERR(priv);
@@ -220,13 +218,17 @@ static int pn533_i2c_probe(struct i2c_client *client,
 	if (r)
 		goto fn_setup_err;
 
-	return 0;
+	r = pn53x_register_nfc(priv, PN533_NO_TYPE_B_PROTOCOLS, &client->dev);
+	if (r)
+		goto fn_setup_err;
+
+	return r;
 
 fn_setup_err:
 	free_irq(client->irq, phy);
 
 irq_rqst_err:
-	pn533_unregister_device(phy->priv);
+	pn53x_common_clean(phy->priv);
 
 	return r;
 }
@@ -239,7 +241,8 @@ static int pn533_i2c_remove(struct i2c_client *client)
 
 	free_irq(client->irq, phy);
 
-	pn533_unregister_device(phy->priv);
+	pn53x_unregister_nfc(phy->priv);
+	pn53x_common_clean(phy->priv);
 
 	return 0;
 }
diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
index 64836c727aee..a8c756caa678 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -2590,14 +2590,12 @@ int pn533_finalize_setup(struct pn533 *dev)
 }
 EXPORT_SYMBOL_GPL(pn533_finalize_setup);
 
-struct pn533 *pn533_register_device(u32 device_type,
-				u32 protocols,
+struct pn533 *pn53x_common_init(u32 device_type,
 				enum pn533_protocol_type protocol_type,
 				void *phy,
 				struct pn533_phy_ops *phy_ops,
 				struct pn533_frame_ops *fops,
-				struct device *dev,
-				struct device *parent)
+				struct device *dev)
 {
 	struct pn533 *priv;
 	int rc = -ENOMEM;
@@ -2638,43 +2636,18 @@ struct pn533 *pn533_register_device(u32 device_type,
 	skb_queue_head_init(&priv->fragment_skb);
 
 	INIT_LIST_HEAD(&priv->cmd_queue);
-
-	priv->nfc_dev = nfc_allocate_device(&pn533_nfc_ops, protocols,
-					   priv->ops->tx_header_len +
-					   PN533_CMD_DATAEXCH_HEAD_LEN,
-					   priv->ops->tx_tail_len);
-	if (!priv->nfc_dev) {
-		rc = -ENOMEM;
-		goto destroy_wq;
-	}
-
-	nfc_set_parent_dev(priv->nfc_dev, parent);
-	nfc_set_drvdata(priv->nfc_dev, priv);
-
-	rc = nfc_register_device(priv->nfc_dev);
-	if (rc)
-		goto free_nfc_dev;
-
 	return priv;
 
-free_nfc_dev:
-	nfc_free_device(priv->nfc_dev);
-
-destroy_wq:
-	destroy_workqueue(priv->wq);
 error:
 	kfree(priv);
 	return ERR_PTR(rc);
 }
-EXPORT_SYMBOL_GPL(pn533_register_device);
+EXPORT_SYMBOL_GPL(pn53x_common_init);
 
-void pn533_unregister_device(struct pn533 *priv)
+void pn53x_common_clean(struct pn533 *priv)
 {
 	struct pn533_cmd *cmd, *n;
 
-	nfc_unregister_device(priv->nfc_dev);
-	nfc_free_device(priv->nfc_dev);
-
 	flush_delayed_work(&priv->poll_work);
 	destroy_workqueue(priv->wq);
 
@@ -2689,8 +2662,37 @@ void pn533_unregister_device(struct pn533 *priv)
 
 	kfree(priv);
 }
-EXPORT_SYMBOL_GPL(pn533_unregister_device);
+EXPORT_SYMBOL_GPL(pn53x_common_clean);
+
+int pn53x_register_nfc(struct pn533 *priv, u32 protocols,
+			struct device *parent)
+{
+	int rc = -ENOMEM;
+
+	priv->nfc_dev = nfc_allocate_device(&pn533_nfc_ops, protocols,
+					   priv->ops->tx_header_len +
+					   PN533_CMD_DATAEXCH_HEAD_LEN,
+					   priv->ops->tx_tail_len);
+	if (!priv->nfc_dev)
+		return -ENOMEM;
+
+	nfc_set_parent_dev(priv->nfc_dev, parent);
+	nfc_set_drvdata(priv->nfc_dev, priv);
+
+	rc = nfc_register_device(priv->nfc_dev);
+	if (rc)
+		nfc_free_device(priv->nfc_dev);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(pn53x_register_nfc);
 
+void pn53x_unregister_nfc(struct pn533 *priv)
+{
+	nfc_unregister_device(priv->nfc_dev);
+	nfc_free_device(priv->nfc_dev);
+}
+EXPORT_SYMBOL_GPL(pn53x_unregister_nfc);
 
 MODULE_AUTHOR("Lauro Ramos Venancio <lauro.venancio@openbossa.org>");
 MODULE_AUTHOR("Aloisio Almeida Jr <aloisio.almeida@openbossa.org>");
diff --git a/drivers/nfc/pn533/pn533.h b/drivers/nfc/pn533/pn533.h
index 570ee0a3e832..510ddebbd896 100644
--- a/drivers/nfc/pn533/pn533.h
+++ b/drivers/nfc/pn533/pn533.h
@@ -219,18 +219,19 @@ struct pn533_phy_ops {
 };
 
 
-struct pn533 *pn533_register_device(u32 device_type,
-				u32 protocols,
+struct pn533 *pn53x_common_init(u32 device_type,
 				enum pn533_protocol_type protocol_type,
 				void *phy,
 				struct pn533_phy_ops *phy_ops,
 				struct pn533_frame_ops *fops,
-				struct device *dev,
-				struct device *parent);
+				struct device *dev);
 
 int pn533_finalize_setup(struct pn533 *dev);
-void pn533_unregister_device(struct pn533 *priv);
+void pn53x_common_clean(struct pn533 *priv);
 void pn533_recv_frame(struct pn533 *dev, struct sk_buff *skb, int status);
+int pn53x_register_nfc(struct pn533 *priv, u32 protocols,
+			struct device *parent);
+void pn53x_unregister_nfc(struct pn533 *priv);
 
 bool pn533_rx_frame_is_cmd_response(struct pn533 *dev, void *frame);
 bool pn533_rx_frame_is_ack(void *_frame);
diff --git a/drivers/nfc/pn533/usb.c b/drivers/nfc/pn533/usb.c
index c5289eaf17ee..a1c6a41944c6 100644
--- a/drivers/nfc/pn533/usb.c
+++ b/drivers/nfc/pn533/usb.c
@@ -534,9 +534,9 @@ static int pn533_usb_probe(struct usb_interface *interface,
 		goto error;
 	}
 
-	priv = pn533_register_device(id->driver_info, protocols, protocol_type,
+	priv = pn53x_common_init(id->driver_info, protocol_type,
 					phy, &usb_phy_ops, fops,
-					&phy->udev->dev, &interface->dev);
+					&phy->udev->dev);
 
 	if (IS_ERR(priv)) {
 		rc = PTR_ERR(priv);
@@ -550,9 +550,14 @@ static int pn533_usb_probe(struct usb_interface *interface,
 		goto error;
 
 	usb_set_intfdata(interface, phy);
+	rc = pn53x_register_nfc(priv, protocols, &interface->dev);
+	if (rc)
+		goto err_clean;
 
 	return 0;
 
+err_clean:
+	pn53x_common_clean(priv);
 error:
 	usb_free_urb(phy->in_urb);
 	usb_free_urb(phy->out_urb);
@@ -570,7 +575,8 @@ static void pn533_usb_disconnect(struct usb_interface *interface)
 	if (!phy)
 		return;
 
-	pn533_unregister_device(phy->priv);
+	pn53x_unregister_nfc(phy->priv);
+	pn53x_common_clean(phy->priv);
 
 	usb_set_intfdata(interface, NULL);
 
-- 
2.23.0.rc1

