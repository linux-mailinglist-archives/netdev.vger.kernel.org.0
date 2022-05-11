Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9593C5233A9
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 15:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243196AbiEKNEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 09:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243223AbiEKNE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 09:04:28 -0400
Received: from m15112.mail.126.com (m15112.mail.126.com [220.181.15.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2CC1423725D;
        Wed, 11 May 2022 06:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=cA20v
        jSQc0xTB5lj5GoeWHAPefqE6IHlE3Nbb8SvDhw=; b=eHhPo9MMLFFQdNOxPzh4R
        dHDDNEJiYPWGiEIA/opcQbywOmTnsgv8An0DrOvcPjpt6/0guDU/RBEBF7Efdhpy
        9BHQFyxEAGbhGNcX4VU1HX/Z5CtV00J6rOLs5ty0x1WLp5UBYxjcaLG2a16YAqif
        PjWeOKI+AHBYdFy7rY5LPs=
Received: from ubuntu.localdomain (unknown [58.213.83.157])
        by smtp2 (Coremail) with SMTP id DMmowACXi_3xs3tivSKkBQ--.64503S4;
        Wed, 11 May 2022 21:02:43 +0800 (CST)
From:   Bernard Zhao <zhaojunkui2008@126.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        Bernard Zhao <zhaojunkui2008@126.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     bernard@vivo.com
Subject: [PATCH v2] usb/peak_usb: cleanup code
Date:   Wed, 11 May 2022 06:02:38 -0700
Message-Id: <20220511130240.790771-1-zhaojunkui2008@126.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DMmowACXi_3xs3tivSKkBQ--.64503S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxZr4DCry7tFWxJr45Zr4xZwb_yoW5KrWDpa
        1rAFW7Kr4UKF1rG348tr1ku3Way3W8Ka4Skryqqw1F9r1qg393XF95CFySvrs7Z39ru3Wa
        qa1Utr18Ar1UGr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pEv388UUUUU=
X-Originating-IP: [58.213.83.157]
X-CM-SenderInfo: p2kd0y5xqn3xasqqmqqrswhudrp/1tbiLRT9qlpD935HVQAAss
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The variable fi and bi only used in branch if (!dev->prev_siblings)
, fi & bi not kmalloc in else branch, so move kfree into branch
if (!dev->prev_siblings),this change is to cleanup the code a bit.

Signed-off-by: Bernard Zhao <zhaojunkui2008@126.com>

---
Changes since V1:
* move all the content of the if (!dev->prev_siblings) to a new
function.
---
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c | 57 +++++++++++++--------
 1 file changed, 36 insertions(+), 21 deletions(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
index ebe087f258e3..5e472fe086a8 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
@@ -841,32 +841,28 @@ static int pcan_usb_pro_stop(struct peak_usb_device *dev)
 	return 0;
 }
 
-/*
- * called when probing to initialize a device object.
- */
-static int pcan_usb_pro_init(struct peak_usb_device *dev)
+static int pcan_usb_pro_init_first_channel(struct peak_usb_device *dev, struct pcan_usb_pro_interface **usb_if)
 {
-	struct pcan_usb_pro_device *pdev =
-			container_of(dev, struct pcan_usb_pro_device, dev);
-	struct pcan_usb_pro_interface *usb_if = NULL;
-	struct pcan_usb_pro_fwinfo *fi = NULL;
-	struct pcan_usb_pro_blinfo *bi = NULL;
+	struct pcan_usb_pro_interface *pusb_if = NULL;
 	int err;
 
 	/* do this for 1st channel only */
 	if (!dev->prev_siblings) {
+		struct pcan_usb_pro_fwinfo *fi = NULL;
+		struct pcan_usb_pro_blinfo *bi = NULL;
+
 		/* allocate netdevices common structure attached to first one */
-		usb_if = kzalloc(sizeof(struct pcan_usb_pro_interface),
+		pusb_if = kzalloc(sizeof(struct pcan_usb_pro_interface),
 				 GFP_KERNEL);
 		fi = kmalloc(sizeof(struct pcan_usb_pro_fwinfo), GFP_KERNEL);
 		bi = kmalloc(sizeof(struct pcan_usb_pro_blinfo), GFP_KERNEL);
-		if (!usb_if || !fi || !bi) {
+		if (!pusb_if || !fi || !bi) {
 			err = -ENOMEM;
 			goto err_out;
 		}
 
 		/* number of ts msgs to ignore before taking one into account */
-		usb_if->cm_ignore_count = 5;
+		pusb_if->cm_ignore_count = 5;
 
 		/*
 		 * explicit use of dev_xxx() instead of netdev_xxx() here:
@@ -903,18 +899,14 @@ static int pcan_usb_pro_init(struct peak_usb_device *dev)
 		     pcan_usb_pro.name,
 		     bi->hw_rev, bi->serial_num_hi, bi->serial_num_lo,
 		     pcan_usb_pro.ctrl_count);
+
+		kfree(bi);
+		kfree(fi);
 	} else {
-		usb_if = pcan_usb_pro_dev_if(dev->prev_siblings);
+		pusb_if = pcan_usb_pro_dev_if(dev->prev_siblings);
 	}
 
-	pdev->usb_if = usb_if;
-	usb_if->dev[dev->ctrl_idx] = dev;
-
-	/* set LED in default state (end of init phase) */
-	pcan_usb_pro_set_led(dev, PCAN_USBPRO_LED_DEVICE, 1);
-
-	kfree(bi);
-	kfree(fi);
+	*usb_if = pusb_if;
 
 	return 0;
 
@@ -926,6 +918,29 @@ static int pcan_usb_pro_init(struct peak_usb_device *dev)
 	return err;
 }
 
+/*
+ * called when probing to initialize a device object.
+ */
+static int pcan_usb_pro_init(struct peak_usb_device *dev)
+{
+	struct pcan_usb_pro_device *pdev =
+			container_of(dev, struct pcan_usb_pro_device, dev);
+	struct pcan_usb_pro_interface *usb_if = NULL;
+	int err;
+
+	err = pcan_usb_pro_init_first_channel(dev, &usb_if);
+	if (err)
+		return err;
+
+	pdev->usb_if = usb_if;
+	usb_if->dev[dev->ctrl_idx] = dev;
+
+	/* set LED in default state (end of init phase) */
+	pcan_usb_pro_set_led(dev, PCAN_USBPRO_LED_DEVICE, 1);
+
+	return 0;
+}
+
 static void pcan_usb_pro_exit(struct peak_usb_device *dev)
 {
 	struct pcan_usb_pro_device *pdev =
-- 
2.33.1

