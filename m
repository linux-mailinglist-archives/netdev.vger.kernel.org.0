Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4316603FE
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 17:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234989AbjAFQJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 11:09:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235047AbjAFQIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 11:08:55 -0500
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0F2776238;
        Fri,  6 Jan 2023 08:08:30 -0800 (PST)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
        (authenticated bits=0)
        by dilbert.mork.no (8.15.2/8.15.2) with ESMTPSA id 306G861L1390823
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Fri, 6 Jan 2023 16:08:07 GMT
Received: from miraculix.mork.no ([IPv6:2a01:799:c9a:3202:549f:9f7a:c9d8:875b])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 306G81XI2910658
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Fri, 6 Jan 2023 17:08:01 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1673021281; bh=EWbAkaWMwM+ddCnHHCeZvsK8g1GQ+twZTFv+8M5+ooQ=;
        h=From:To:Cc:Subject:Date:Message-Id:References:From;
        b=X7BsuPAVtbKmrlvRies8ZcW7P9/S2WsMkCGJBA/T9jcJ7MZv9KOq2WXfq0AZoYaqx
         4ri+RKhtLmqdA+iXXFDyhYg0CcIJGeM7D+K0vELMGscey/WaTaL2PM4yPtR7X3t2KD
         8YnYn6p7l2Jk+uz9l3BA/+neh9SSUydkguz7oJVo=
Received: (nullmailer pid 100763 invoked by uid 1000);
        Fri, 06 Jan 2023 16:07:58 -0000
From:   =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To:     netdev@vger.kernel.org
Cc:     Hayes Wang <hayeswang@realtek.com>, linux-usb@vger.kernel.org,
        Oliver Neukum <oliver@neukum.org>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH 2/2] cdc_ether: no need to blacklist any r8152 devices
Date:   Fri,  6 Jan 2023 17:07:39 +0100
Message-Id: <20230106160739.100708-3-bjorn@mork.no>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230106160739.100708-1-bjorn@mork.no>
References: <20230106160739.100708-1-bjorn@mork.no>
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

The r8152 driver does not need this anymore.

Dropping blacklist entries adds optional support for these
devices in ECM mode.

The 8153 devices are handled by the r8153_ecm driver when
in ECM mode, and must still be blacklisted here.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
 drivers/net/usb/cdc_ether.c | 114 ------------------------------------
 1 file changed, 114 deletions(-)

diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index 8911cd2ed534..9568fe5612ca 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -747,13 +747,6 @@ static const struct usb_device_id	products[] = {
 	.driver_info = 0,
 },
 
-/* Realtek RTL8152 Based USB 2.0 Ethernet Adapters */
-{
-	USB_DEVICE_AND_INTERFACE_INFO(REALTEK_VENDOR_ID, 0x8152, USB_CLASS_COMM,
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
-	.driver_info = 0,
-},
-
 /* Realtek RTL8153 Based USB 3.0 Ethernet Adapters */
 {
 	USB_DEVICE_AND_INTERFACE_INFO(REALTEK_VENDOR_ID, 0x8153, USB_CLASS_COMM,
@@ -761,71 +754,6 @@ static const struct usb_device_id	products[] = {
 	.driver_info = 0,
 },
 
-/* Samsung USB Ethernet Adapters */
-{
-	USB_DEVICE_AND_INTERFACE_INFO(SAMSUNG_VENDOR_ID, 0xa101, USB_CLASS_COMM,
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
-	.driver_info = 0,
-},
-
-#if IS_ENABLED(CONFIG_USB_RTL8152)
-/* Linksys USB3GIGV1 Ethernet Adapter */
-{
-	USB_DEVICE_AND_INTERFACE_INFO(LINKSYS_VENDOR_ID, 0x0041, USB_CLASS_COMM,
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
-	.driver_info = 0,
-},
-#endif
-
-/* Lenovo ThinkPad OneLink+ Dock (based on Realtek RTL8153) */
-{
-	USB_DEVICE_AND_INTERFACE_INFO(LENOVO_VENDOR_ID, 0x3054, USB_CLASS_COMM,
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
-	.driver_info = 0,
-},
-
-/* ThinkPad USB-C Dock (based on Realtek RTL8153) */
-{
-	USB_DEVICE_AND_INTERFACE_INFO(LENOVO_VENDOR_ID, 0x3062, USB_CLASS_COMM,
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
-	.driver_info = 0,
-},
-
-/* ThinkPad Thunderbolt 3 Dock (based on Realtek RTL8153) */
-{
-	USB_DEVICE_AND_INTERFACE_INFO(LENOVO_VENDOR_ID, 0x3069, USB_CLASS_COMM,
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
-	.driver_info = 0,
-},
-
-/* ThinkPad Thunderbolt 3 Dock Gen 2 (based on Realtek RTL8153) */
-{
-	USB_DEVICE_AND_INTERFACE_INFO(LENOVO_VENDOR_ID, 0x3082, USB_CLASS_COMM,
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
-	.driver_info = 0,
-},
-
-/* Lenovo Thinkpad USB 3.0 Ethernet Adapters (based on Realtek RTL8153) */
-{
-	USB_DEVICE_AND_INTERFACE_INFO(LENOVO_VENDOR_ID, 0x7205, USB_CLASS_COMM,
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
-	.driver_info = 0,
-},
-
-/* Lenovo USB C to Ethernet Adapter (based on Realtek RTL8153) */
-{
-	USB_DEVICE_AND_INTERFACE_INFO(LENOVO_VENDOR_ID, 0x720c, USB_CLASS_COMM,
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
-	.driver_info = 0,
-},
-
-/* Lenovo USB-C Travel Hub (based on Realtek RTL8153) */
-{
-	USB_DEVICE_AND_INTERFACE_INFO(LENOVO_VENDOR_ID, 0x7214, USB_CLASS_COMM,
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
-	.driver_info = 0,
-},
-
 /* Lenovo Powered USB-C Travel Hub (4X90S92381, based on Realtek RTL8153) */
 {
 	USB_DEVICE_AND_INTERFACE_INFO(LENOVO_VENDOR_ID, 0x721e, USB_CLASS_COMM,
@@ -833,48 +761,6 @@ static const struct usb_device_id	products[] = {
 	.driver_info = 0,
 },
 
-/* ThinkPad USB-C Dock Gen 2 (based on Realtek RTL8153) */
-{
-	USB_DEVICE_AND_INTERFACE_INFO(LENOVO_VENDOR_ID, 0xa387, USB_CLASS_COMM,
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
-	.driver_info = 0,
-},
-
-/* NVIDIA Tegra USB 3.0 Ethernet Adapters (based on Realtek RTL8153) */
-{
-	USB_DEVICE_AND_INTERFACE_INFO(NVIDIA_VENDOR_ID, 0x09ff, USB_CLASS_COMM,
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
-	.driver_info = 0,
-},
-
-/* Microsoft Surface 2 dock (based on Realtek RTL8152) */
-{
-	USB_DEVICE_AND_INTERFACE_INFO(MICROSOFT_VENDOR_ID, 0x07ab, USB_CLASS_COMM,
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
-	.driver_info = 0,
-},
-
-/* Microsoft Surface Ethernet Adapter (based on Realtek RTL8153) */
-{
-	USB_DEVICE_AND_INTERFACE_INFO(MICROSOFT_VENDOR_ID, 0x07c6, USB_CLASS_COMM,
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
-	.driver_info = 0,
-},
-
-/* Microsoft Surface Ethernet Adapter (based on Realtek RTL8153B) */
-{
-	USB_DEVICE_AND_INTERFACE_INFO(MICROSOFT_VENDOR_ID, 0x0927, USB_CLASS_COMM,
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
-	.driver_info = 0,
-},
-
-/* TP-LINK UE300 USB 3.0 Ethernet Adapters (based on Realtek RTL8153) */
-{
-	USB_DEVICE_AND_INTERFACE_INFO(TPLINK_VENDOR_ID, 0x0601, USB_CLASS_COMM,
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
-	.driver_info = 0,
-},
-
 /* Aquantia AQtion USB to 5GbE Controller (based on AQC111U) */
 {
 	USB_DEVICE_AND_INTERFACE_INFO(AQUANTIA_VENDOR_ID, 0xc101,
-- 
2.30.2

