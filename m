Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0A7A648DCB
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 10:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbiLJJGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 04:06:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiLJJFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 04:05:12 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C09275D5;
        Sat, 10 Dec 2022 01:03:46 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id 3-20020a17090a098300b00219041dcbe9so7382602pjo.3;
        Sat, 10 Dec 2022 01:03:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+JLuq6z6RC38yxJgv0nky22X6DCSZ/hpLwA+DNaYB3g=;
        b=pYzKZaA9CAYA1lV0aFDqGItcg2wPbv7kFZNxnILtD51hI2Z0Slg+qdAQ8nV1HCcfSA
         3p3xy/O3vBdiRfLdB+vj6Ksz9HnYQ4tndul1j1Kus7zt80bmzNr2C2YLRX/tZvXrfkDt
         qUaV1cJq+DcbxSf1zI+/q5Joe+oQ87GTDXGlZFhO1vrjILUOHuORDxcE7IAswjElSI7d
         le6Fl9k5YU3CJ3i6FnIn4RsAlFopeglX3XGEIIIgRNTu5/mqb+gTpi6IRJUwzMzelCed
         facKMtOZwVa5+ygm2R2ua7ITJc3cKCdpWfxXJjFE0bq10g5KfSv9/5tMS9zsdbeoRnTO
         3EGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+JLuq6z6RC38yxJgv0nky22X6DCSZ/hpLwA+DNaYB3g=;
        b=Jh5Ic65uP4swDCyt6PC9bIF7UZf2cFCQjEseRPnM7Dh9beoDzT1r3qeC+vzUAgK4/L
         GLyQFJR1jFB+Rvq31F3rP2PXGyq+K6cTWufqqwUOwS+UT109Zuuh8kKC4kc8tQ+KUzGL
         oSfMelFoMMkUIlP5di3jqfK8vQ+CNCf31oUFLWzAmYzP9XLA+eS+uLdWe9nc1aC6jXEb
         S2zyZhQ8eZyaGqblDHkeSr3fIcnkEYdOszQw44/yftxPZrH4YbtfMXDPhM0V0G3tyJs4
         ckCrdx7FpjCnARLyifpVq52V720U9Ra4xRbnEt++Eom2qFmdK3J/jh14ItpKYqIjh7je
         apLQ==
X-Gm-Message-State: ANoB5plmAfaVw6oOYflOr4cDVW8RaGcdbtWal+2dtppzUhCTwr7Etjth
        3vghoyYwpxGDFAYZkM2vGO4=
X-Google-Smtp-Source: AA0mqf5GYgzbWRjQtqXiUGu1YTp8NbJSFZIcWwB5I4kyyqbNyUl5s6xLM9EWIeUdmcdrqCnGmQYpzg==
X-Received: by 2002:a17:903:120b:b0:188:eec0:f1e with SMTP id l11-20020a170903120b00b00188eec00f1emr11952017plh.63.1670663025813;
        Sat, 10 Dec 2022 01:03:45 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id u7-20020a17090282c700b00186a2444a43sm2549481plz.27.2022.12.10.01.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Dec 2022 01:03:45 -0800 (PST)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Frank Jungclaus <frank.jungclaus@esd.eu>, socketcan@esd.eu,
        Yasushi SHOJI <yashi@spacecubics.com>,
        =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        Hangyu Hua <hbh25y@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Peter Fink <pfink@christ-es.de>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        =?UTF-8?q?Christoph=20M=C3=B6hring?= <cmoehring@christ-es.de>,
        John Whittington <git@jbrengineering.co.uk>,
        Vasanth Sadhasivan <vasanth.sadhasivan@samsara.com>,
        Jimmy Assarsson <extja@kvaser.com>,
        Anssi Hannula <anssi.hannula@bitwise.fi>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Dongliang Mu <dzm91@hust.edu.cn>,
        Sebastian Haas <haas@ems-wuensche.com>,
        Maximilian Schneider <max@schneidersoft.net>,
        Daniel Berglund <db@kvaser.com>,
        Olivier Sobrie <olivier@sobrie.be>,
        =?UTF-8?q?Remigiusz=20Ko=C5=82=C5=82=C4=85taj?= 
        <remigiusz.kollataj@mobica.com>,
        Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>,
        Martin Elshuber <martin.elshuber@theobroma-systems.com>,
        Bernd Krumboeck <b.krumboeck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-usb@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v2 8/9] can: usb: remove useless check on driver data
Date:   Sat, 10 Dec 2022 18:01:56 +0900
Message-Id: <20221210090157.793547-9-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221210090157.793547-1-mailhol.vincent@wanadoo.fr>
References: <20221203133159.94414-1-mailhol.vincent@wanadoo.fr>
 <20221210090157.793547-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Many of the can usb drivers checks in their usb_driver::disconnect()
whether the driver data is NULL or not. This check only makes sense if
the disconnect function can be called more than one time. This is not
the case for can usb drivers.

Remove all checks toward drivers priv data in disconnect().

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/usb/ems_usb.c                    | 14 ++++++--------
 drivers/net/can/usb/esd_usb.c                    | 16 +++++++---------
 drivers/net/can/usb/gs_usb.c                     |  5 -----
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c |  7 +------
 drivers/net/can/usb/ucan.c                       |  6 ++----
 drivers/net/can/usb/usb_8dev.c                   | 11 ++++-------
 6 files changed, 20 insertions(+), 39 deletions(-)

diff --git a/drivers/net/can/usb/ems_usb.c b/drivers/net/can/usb/ems_usb.c
index c64cb40ac8de..8bd555eb741f 100644
--- a/drivers/net/can/usb/ems_usb.c
+++ b/drivers/net/can/usb/ems_usb.c
@@ -1062,18 +1062,16 @@ static void ems_usb_disconnect(struct usb_interface *intf)
 {
 	struct ems_usb *dev = usb_get_intfdata(intf);
 
-	if (dev) {
-		unregister_netdev(dev->netdev);
+	unregister_netdev(dev->netdev);
 
-		unlink_all_urbs(dev);
+	unlink_all_urbs(dev);
 
-		usb_free_urb(dev->intr_urb);
+	usb_free_urb(dev->intr_urb);
 
-		kfree(dev->intr_in_buffer);
-		kfree(dev->tx_msg_buffer);
+	kfree(dev->intr_in_buffer);
+	kfree(dev->tx_msg_buffer);
 
-		free_candev(dev->netdev);
-	}
+	free_candev(dev->netdev);
 }
 
 /* usb specific object needed to register this driver with the usb subsystem */
diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index f3006c6dc5d6..775ab704a295 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -1127,17 +1127,15 @@ static void esd_usb_disconnect(struct usb_interface *intf)
 	device_remove_file(&intf->dev, &dev_attr_hardware);
 	device_remove_file(&intf->dev, &dev_attr_nets);
 
-	if (dev) {
-		for (i = 0; i < dev->net_count; i++) {
-			if (dev->nets[i]) {
-				netdev = dev->nets[i]->netdev;
-				unregister_netdev(netdev);
-				free_candev(netdev);
-			}
+	for (i = 0; i < dev->net_count; i++) {
+		if (dev->nets[i]) {
+			netdev = dev->nets[i]->netdev;
+			unregister_netdev(netdev);
+			free_candev(netdev);
 		}
-		unlink_all_urbs(dev);
-		kfree(dev);
 	}
+	unlink_all_urbs(dev);
+	kfree(dev);
 }
 
 /* usb specific object needed to register this driver with the usb subsystem */
diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 97b1da8fd19f..40190816e313 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -1458,11 +1458,6 @@ static void gs_usb_disconnect(struct usb_interface *intf)
 	struct gs_usb *dev = usb_get_intfdata(intf);
 	unsigned int i;
 
-	if (!dev) {
-		dev_err(&intf->dev, "Disconnect (nodata)\n");
-		return;
-	}
-
 	for (i = 0; i < GS_MAX_INTF; i++)
 		if (dev->canch[i])
 			gs_destroy_candev(dev->canch[i]);
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
index dad916b3288e..9e83b61db96b 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -979,12 +979,7 @@ static int kvaser_usb_probe(struct usb_interface *intf,
 
 static void kvaser_usb_disconnect(struct usb_interface *intf)
 {
-	struct kvaser_usb *dev = usb_get_intfdata(intf);
-
-	if (!dev)
-		return;
-
-	kvaser_usb_remove_interfaces(dev);
+	kvaser_usb_remove_interfaces(usb_get_intfdata(intf));
 }
 
 static struct usb_driver kvaser_usb_driver = {
diff --git a/drivers/net/can/usb/ucan.c b/drivers/net/can/usb/ucan.c
index 429b3519ee7f..205941122f9e 100644
--- a/drivers/net/can/usb/ucan.c
+++ b/drivers/net/can/usb/ucan.c
@@ -1579,10 +1579,8 @@ static void ucan_disconnect(struct usb_interface *intf)
 {
 	struct ucan_priv *up = usb_get_intfdata(intf);
 
-	if (up) {
-		unregister_candev(up->netdev);
-		free_candev(up->netdev);
-	}
+	unregister_candev(up->netdev);
+	free_candev(up->netdev);
 }
 
 static struct usb_device_id ucan_table[] = {
diff --git a/drivers/net/can/usb/usb_8dev.c b/drivers/net/can/usb/usb_8dev.c
index ae618809fc05..4d80049ebff7 100644
--- a/drivers/net/can/usb/usb_8dev.c
+++ b/drivers/net/can/usb/usb_8dev.c
@@ -990,14 +990,11 @@ static void usb_8dev_disconnect(struct usb_interface *intf)
 {
 	struct usb_8dev_priv *priv = usb_get_intfdata(intf);
 
-	if (priv) {
-		netdev_info(priv->netdev, "device disconnected\n");
-
-		unregister_netdev(priv->netdev);
-		unlink_all_urbs(priv);
-		free_candev(priv->netdev);
-	}
+	netdev_info(priv->netdev, "device disconnected\n");
 
+	unregister_netdev(priv->netdev);
+	unlink_all_urbs(priv);
+	free_candev(priv->netdev);
 }
 
 static struct usb_driver usb_8dev_driver = {
-- 
2.37.4

