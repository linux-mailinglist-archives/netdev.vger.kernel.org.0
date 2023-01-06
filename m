Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22C6A6603FB
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 17:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234899AbjAFQJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 11:09:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235035AbjAFQIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 11:08:55 -0500
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D1976236;
        Fri,  6 Jan 2023 08:08:30 -0800 (PST)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
        (authenticated bits=0)
        by dilbert.mork.no (8.15.2/8.15.2) with ESMTPSA id 306G86rB1390826
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Fri, 6 Jan 2023 16:08:08 GMT
Received: from miraculix.mork.no ([IPv6:2a01:799:c9a:3202:549f:9f7a:c9d8:875b])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 306G81gH2910666
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Fri, 6 Jan 2023 17:08:01 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1673021281; bh=IbzAfsJX6p1UR5ah8lPKhO6P5iUb3FesNxCigHYPheo=;
        h=From:To:Cc:Subject:Date:Message-Id:References:From;
        b=Rw612A+FNHGg5tXUsd07ltn8q+WRdyzxWzTBkABngiT5shiVZnRcICztHHQuvROrc
         1WJL6tLKHzZFjchcRWdn3X5Mhf0hF+DzMWkQP3eyWMPPDjOy7aQ+k1m6efQ56/S1HD
         sTpCz1/hvLDr1AHHzlIAZtIJkPrJaH/jSkk1Zrwc=
Received: (nullmailer pid 100761 invoked by uid 1000);
        Fri, 06 Jan 2023 16:07:58 -0000
From:   =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To:     netdev@vger.kernel.org
Cc:     Hayes Wang <hayeswang@realtek.com>, linux-usb@vger.kernel.org,
        Oliver Neukum <oliver@neukum.org>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH 1/2] r8152: add USB device driver for config selection
Date:   Fri,  6 Jan 2023 17:07:38 +0100
Message-Id: <20230106160739.100708-2-bjorn@mork.no>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230106160739.100708-1-bjorn@mork.no>
References: <20230106160739.100708-1-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.7 at canardo
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Subclassing the generic USB device driver to override the
default configuration selection regardless of matching interface
drivers.

The r815x family devices expose a vendor specific function which
the r8152 interface driver wants to handle.  This is the preferred
device mode. Additionally one or more USB class functions are
usually supported for hosts lacking a vendor specific driver. The
choice is USB configuration based, with one alternate function per
configuration.

Example device with both NCM and ECM alternate cfgs:

T:  Bus=02 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  4 Spd=5000 MxCh= 0
D:  Ver= 3.20 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 9 #Cfgs=  3
P:  Vendor=0bda ProdID=8156 Rev=31.00
S:  Manufacturer=Realtek
S:  Product=USB 10/100/1G/2.5G LAN
S:  SerialNumber=001000001
C:* #Ifs= 1 Cfg#= 1 Atr=a0 MxPwr=256mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=00 Driver=r8152
E:  Ad=81(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=83(I) Atr=03(Int.) MxPS=   2 Ivl=128ms
C:  #Ifs= 2 Cfg#= 2 Atr=a0 MxPwr=256mA
I:  If#= 0 Alt= 0 #EPs= 1 Cls=02(comm.) Sub=0d Prot=00 Driver=
E:  Ad=83(I) Atr=03(Int.) MxPS=  16 Ivl=128ms
I:  If#= 1 Alt= 0 #EPs= 0 Cls=0a(data ) Sub=00 Prot=01 Driver=
I:  If#= 1 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=01 Driver=
E:  Ad=81(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
C:  #Ifs= 2 Cfg#= 3 Atr=a0 MxPwr=256mA
I:  If#= 0 Alt= 0 #EPs= 1 Cls=02(comm.) Sub=06 Prot=00 Driver=
E:  Ad=83(I) Atr=03(Int.) MxPS=  16 Ivl=128ms
I:  If#= 1 Alt= 0 #EPs= 0 Cls=0a(data ) Sub=00 Prot=00 Driver=
I:  If#= 1 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=00 Driver=
E:  Ad=81(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms

A problem with this is that Linux will prefer class functions over
vendor specific functions. Using the above example, Linux defaults
to cfg #2, running the device in a sub-optimal NCM mode.

Previously we've attempted to work around the problem by
blacklisting the devices in the ECM class driver "cdc_ether", and
matching on the ECM class function in the vendor specific interface
driver. The latter has been used to switch back to the vendor
specific configuration when the driver is probed for a class
function.

This workaround has several issues;
- class driver blacklists is additional maintanence cruft in an
  unrelated driver
- class driver blacklists prevents users from optionally running
  the devices in class mode
- each device needs double match entries in the vendor driver
- the initial probing as a class function slows down device
  discovery

Now these issues have become even worse with the introduction of
firmware supporting both NCM and ECM, where NCM ends up as the
default mode in Linux. To use the same workaround, we now have
to blacklist the devices in to two different class drivers and
add yet another match entry to the vendor specific driver.

This patch implements an alternative workaround strategy -
independent of the interface drivers.  It avoids adding a
blacklist to the cdc_ncm driver and will let us remove the
existing blacklist from the cdc_ether driver.

As an additional bonus, removing the blacklists allow users to
select one of the other device modes if wanted.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
 drivers/net/usb/r8152.c | 113 ++++++++++++++++++++++++++++------------
 1 file changed, 81 insertions(+), 32 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index a481a1d831e2..66e70b5f8417 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -9618,6 +9618,9 @@ static int rtl8152_probe(struct usb_interface *intf,
 	if (version == RTL_VER_UNKNOWN)
 		return -ENODEV;
 
+	if (intf->cur_altsetting->desc.bInterfaceClass != USB_CLASS_VENDOR_SPEC)
+		return -ENODEV;
+
 	if (!rtl_vendor_mode(intf))
 		return -ENODEV;
 
@@ -9814,42 +9817,34 @@ static void rtl8152_disconnect(struct usb_interface *intf)
 	}
 }
 
-#define REALTEK_USB_DEVICE(vend, prod)	{ \
-	USB_DEVICE_INTERFACE_CLASS(vend, prod, USB_CLASS_VENDOR_SPEC), \
-}, \
-{ \
-	USB_DEVICE_AND_INTERFACE_INFO(vend, prod, USB_CLASS_COMM, \
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE), \
-}
-
 /* table of devices that work with this driver */
 static const struct usb_device_id rtl8152_table[] = {
 	/* Realtek */
-	REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8050),
-	REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8053),
-	REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8152),
-	REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8153),
-	REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8155),
-	REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8156),
+	{ USB_DEVICE(VENDOR_ID_REALTEK, 0x8050) },
+	{ USB_DEVICE(VENDOR_ID_REALTEK, 0x8053) },
+	{ USB_DEVICE(VENDOR_ID_REALTEK, 0x8152) },
+	{ USB_DEVICE(VENDOR_ID_REALTEK, 0x8153) },
+	{ USB_DEVICE(VENDOR_ID_REALTEK, 0x8155) },
+	{ USB_DEVICE(VENDOR_ID_REALTEK, 0x8156) },
 
 	/* Microsoft */
-	REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x07ab),
-	REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x07c6),
-	REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x0927),
-	REALTEK_USB_DEVICE(VENDOR_ID_SAMSUNG, 0xa101),
-	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x304f),
-	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3054),
-	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3062),
-	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3069),
-	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3082),
-	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x7205),
-	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x720c),
-	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x7214),
-	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x721e),
-	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0xa387),
-	REALTEK_USB_DEVICE(VENDOR_ID_LINKSYS, 0x0041),
-	REALTEK_USB_DEVICE(VENDOR_ID_NVIDIA,  0x09ff),
-	REALTEK_USB_DEVICE(VENDOR_ID_TPLINK,  0x0601),
+	{ USB_DEVICE(VENDOR_ID_MICROSOFT, 0x07ab) },
+	{ USB_DEVICE(VENDOR_ID_MICROSOFT, 0x07c6) },
+	{ USB_DEVICE(VENDOR_ID_MICROSOFT, 0x0927) },
+	{ USB_DEVICE(VENDOR_ID_SAMSUNG, 0xa101) },
+	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x304f) },
+	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x3054) },
+	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x3062) },
+	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x3069) },
+	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x3082) },
+	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x7205) },
+	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x720c) },
+	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x7214) },
+	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x721e) },
+	{ USB_DEVICE(VENDOR_ID_LENOVO,  0xa387) },
+	{ USB_DEVICE(VENDOR_ID_LINKSYS, 0x0041) },
+	{ USB_DEVICE(VENDOR_ID_NVIDIA,  0x09ff) },
+	{ USB_DEVICE(VENDOR_ID_TPLINK,  0x0601) },
 	{}
 };
 
@@ -9869,7 +9864,61 @@ static struct usb_driver rtl8152_driver = {
 	.disable_hub_initiated_lpm = 1,
 };
 
-module_usb_driver(rtl8152_driver);
+static int rtl8152_cfgselector_probe(struct usb_device *udev)
+{
+	struct usb_host_config *c;
+	int i, num_configs;
+
+	/* The vendor mode is not always config #1, so to find it out. */
+	c = udev->config;
+	num_configs = udev->descriptor.bNumConfigurations;
+	for (i = 0; i < num_configs; (i++, c++)) {
+		struct usb_interface_descriptor	*desc = NULL;
+
+		if (!c->desc.bNumInterfaces)
+			continue;
+		desc = &c->intf_cache[0]->altsetting->desc;
+		if (desc->bInterfaceClass == USB_CLASS_VENDOR_SPEC)
+			break;
+	}
+
+	if (i == num_configs)
+		return -ENODEV;
+
+	if (usb_set_configuration(udev, c->desc.bConfigurationValue)) {
+		dev_err(&udev->dev, "Failed to set configuration %d\n",
+			c->desc.bConfigurationValue);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static struct usb_device_driver rtl8152_cfgselector_driver = {
+	.name =		MODULENAME "-cfgselector",
+	.probe =	rtl8152_cfgselector_probe,
+	.id_table =	rtl8152_table,
+	.generic_subclass = 1,
+};
+
+static int __init rtl8152_driver_init(void)
+{
+	int ret;
+
+	ret = usb_register_device_driver(&rtl8152_cfgselector_driver, THIS_MODULE);
+	if (ret)
+		return ret;
+	return usb_register(&rtl8152_driver);
+}
+
+static void __exit rtl8152_driver_exit(void)
+{
+	usb_deregister(&rtl8152_driver);
+	usb_deregister_device_driver(&rtl8152_cfgselector_driver);
+}
+
+module_init(rtl8152_driver_init);
+module_exit(rtl8152_driver_exit);
 
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
-- 
2.30.2

