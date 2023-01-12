Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00491666F0E
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 11:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239716AbjALKGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 05:06:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231699AbjALKFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 05:05:11 -0500
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FEE7186E0;
        Thu, 12 Jan 2023 02:01:42 -0800 (PST)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
        (authenticated bits=0)
        by dilbert.mork.no (8.15.2/8.15.2) with ESMTPSA id 30CA1Jc81795562
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 10:01:20 GMT
Received: from miraculix.mork.no ([IPv6:2a01:799:c9a:3202:549f:9f7a:c9d8:875b])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 30CA1EsE3816905
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 11:01:14 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1673517674; bh=tOuAEvT9QbZA1yHsnnoh3aX1wkDxXxd0nH+tePPAzec=;
        h=From:To:Cc:Subject:Date:Message-Id:References:From;
        b=D4qUMaDiDGLhc9I4tmGuj8L3KNMLwXM4vwFWO4WpQtC3IkvvZ/qKcwb3dfys8pWhc
         MrgVFDfmLtwIKmEv13erZtM8Oj816aelJL17cD9mOOC6M6fp0BYncMIqkJGEBmSzh6
         +JjEW6ptBjbZKD7UNQtpvm26FEliRJsIAzbPiFnA=
Received: (nullmailer pid 180761 invoked by uid 1000);
        Thu, 12 Jan 2023 10:01:14 -0000
From:   =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH net-next] r8152; preserve device list format
Date:   Thu, 12 Jan 2023 11:01:00 +0100
Message-Id: <20230112100100.180708-1-bjorn@mork.no>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <87k01s6tkr.fsf@miraculix.mork.no>
References: <87k01s6tkr.fsf@miraculix.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.7 at canardo
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        UPPERCASE_50_75 autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a partial revert of commit ec51fbd1b8a2 ("r8152:
add USB device driver for config selection")

Keep a simplified version of the REALTEK_USB_DEVICE macro
to avoid unnecessary reformatting of the device list. This
makes new device ID additions apply cleanly across driver
versions.

Fixes: ec51fbd1b8a2 ("r8152: add USB device driver for config selection")
Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
The patch in
https://lore.kernel.org/lkml/20230111133228.190801-1-andre.przywara@arm.com/
will apply cleanly on top of this.

This fix will also prevent a lot of stable backporting hassle.

Sorry for not thinking the change completely through before
submitting.  I should never have touched the rtl8152_table.


Bjørn

 drivers/net/usb/r8152.c | 48 +++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 23 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 66e70b5f8417..3d4631dae00f 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -9817,34 +9817,36 @@ static void rtl8152_disconnect(struct usb_interface *intf)
 	}
 }
 
+#define REALTEK_USB_DEVICE(vend, prod)	{ USB_DEVICE(vend, prod) }
+
 /* table of devices that work with this driver */
 static const struct usb_device_id rtl8152_table[] = {
 	/* Realtek */
-	{ USB_DEVICE(VENDOR_ID_REALTEK, 0x8050) },
-	{ USB_DEVICE(VENDOR_ID_REALTEK, 0x8053) },
-	{ USB_DEVICE(VENDOR_ID_REALTEK, 0x8152) },
-	{ USB_DEVICE(VENDOR_ID_REALTEK, 0x8153) },
-	{ USB_DEVICE(VENDOR_ID_REALTEK, 0x8155) },
-	{ USB_DEVICE(VENDOR_ID_REALTEK, 0x8156) },
+	REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8050),
+	REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8053),
+	REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8152),
+	REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8153),
+	REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8155),
+	REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8156),
 
 	/* Microsoft */
-	{ USB_DEVICE(VENDOR_ID_MICROSOFT, 0x07ab) },
-	{ USB_DEVICE(VENDOR_ID_MICROSOFT, 0x07c6) },
-	{ USB_DEVICE(VENDOR_ID_MICROSOFT, 0x0927) },
-	{ USB_DEVICE(VENDOR_ID_SAMSUNG, 0xa101) },
-	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x304f) },
-	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x3054) },
-	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x3062) },
-	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x3069) },
-	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x3082) },
-	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x7205) },
-	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x720c) },
-	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x7214) },
-	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x721e) },
-	{ USB_DEVICE(VENDOR_ID_LENOVO,  0xa387) },
-	{ USB_DEVICE(VENDOR_ID_LINKSYS, 0x0041) },
-	{ USB_DEVICE(VENDOR_ID_NVIDIA,  0x09ff) },
-	{ USB_DEVICE(VENDOR_ID_TPLINK,  0x0601) },
+	REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x07ab),
+	REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x07c6),
+	REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x0927),
+	REALTEK_USB_DEVICE(VENDOR_ID_SAMSUNG, 0xa101),
+	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x304f),
+	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3054),
+	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3062),
+	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3069),
+	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3082),
+	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x7205),
+	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x720c),
+	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x7214),
+	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x721e),
+	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0xa387),
+	REALTEK_USB_DEVICE(VENDOR_ID_LINKSYS, 0x0041),
+	REALTEK_USB_DEVICE(VENDOR_ID_NVIDIA,  0x09ff),
+	REALTEK_USB_DEVICE(VENDOR_ID_TPLINK,  0x0601),
 	{}
 };
 
-- 
2.30.2

