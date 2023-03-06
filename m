Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE3BF6ABEE9
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 12:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjCFL7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 06:59:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjCFL7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 06:59:47 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A4D9005;
        Mon,  6 Mar 2023 03:59:45 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id cw28so37457055edb.5;
        Mon, 06 Mar 2023 03:59:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678103984;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XgdPOEM8RBTy365QmN+fEheLbyriJx79lGmHw+gn/p4=;
        b=ERl72lr3zbaFhn17xJ7NEAeevk5TF0NYBctWin4Izb8vyKtpBQ9tmyKTJxeTV+HyAx
         GXkcBAOFZCzMjE2qYeyjOHr3k0n1LfC72wvkAZdbvnuOk7PyOycSji6jES6G0HxFE+Tj
         N5cRf+kwjVrHByUg5Bja2vI7uJpoxSIWAbwjQSLMevaoe4rgN/TFALNCcHnHNhj176Z+
         TbLWF0FM9HIvl5exdWl1RhIG3MRwH9kvkNLQnSAUh6cCYJEiKKyApeAfsqJixC3yMOGC
         x+xizA+EcuPBmU4QsTY+wwQvyvPemdo/0BaPItthRooy7Jnu494AMugujuUE3rLy2r7w
         HtmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678103984;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XgdPOEM8RBTy365QmN+fEheLbyriJx79lGmHw+gn/p4=;
        b=2UjWJAE7mwRsnSxnr8+RkEs3Y0tZtJVAXtHNdm9ra39uiUmsFYx3Wdgj07cSqTGa62
         p5IgN7LmUqSxhWFHNJI9E84CjpAlBRKMtSF3DUexMljxpQZoBF2TEjDJ66aRrfCoL1fr
         Kmlh1+Wodo7cGexEU+c2rBSTrkS65mPLnNYo9NKG4QPdM6i23zsCbgFNKbjcPYPAuMpq
         ij3et+bD/Pt31BDRA4VsGRLMUniOh+yWXBxc+wlnEdn+5FDi3qr1MlpN2pW9M92UiaTC
         NzDSqDFefPQ+Do4O9PQR5AD/q2CJbnZMMUsrO9sYMf9Cn+1x9tqQxhv7qFozqzkme4py
         9Yng==
X-Gm-Message-State: AO0yUKWU2HWGEarKTYe5kWB31mCNMTB8mgjTrh73BwpDjixmvMo3/BDd
        d1QBg0HIMBpLgLvDTFKXRWw=
X-Google-Smtp-Source: AK7set+seClU0mXMgVr5l8pjA39IwhQ0nENhLdK++G5FttV7/octICwZ0D7DPNIl0aTyMkVYT7RHSQ==
X-Received: by 2002:a17:907:6e87:b0:8b0:f59e:ab1b with SMTP id sh7-20020a1709076e8700b008b0f59eab1bmr11801466ejc.75.1678103984088;
        Mon, 06 Mar 2023 03:59:44 -0800 (PST)
Received: from labdl-itc-sw04.tmt.telital.com (host-217-57-98-66.business.telecomitalia.it. [217.57.98.66])
        by smtp.googlemail.com with ESMTPSA id e25-20020a170906081900b008eb2a1474d0sm4479757ejd.77.2023.03.06.03.59.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 03:59:43 -0800 (PST)
From:   Enrico Sau <enrico.sau@gmail.com>
To:     Bj?rn Mork <bjorn@mork.no>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, Enrico Sau <enrico.sau@gmail.com>
Subject: [PATCH NET 1/1] net: usb: cdc_mbim: avoid altsetting toggling for Telit FE990
Date:   Mon,  6 Mar 2023 12:59:33 +0100
Message-Id: <20230306115933.198259-1-enrico.sau@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add quirk CDC_MBIM_FLAG_AVOID_ALTSETTING_TOGGLE for Telit FE990
0x1081 composition in order to avoid bind error.

Signed-off-by: Enrico Sau <enrico.sau@gmail.com>
---

This is the verbose lsusb:

Bus 001 Device 008: ID 1bc7:1081 Telit Wireless Solutions FE990
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.10
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  idVendor           0x1bc7 Telit Wireless Solutions
  idProduct          0x1081 
  bcdDevice            5.04
  iManufacturer           1 Telit Wireless Solutions
  iProduct                2 FE990
  iSerial                 3 9455d1d2
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength       0x0151
    bNumInterfaces          8
    bConfigurationValue     1
    iConfiguration          4 DIAG_ADB_MBIM_NMEA_DUN_DUN_SER
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol     48 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass     66 
      bInterfaceProtocol      1 
      iInterface              5 ADB Interface
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
    Interface Association:
      bLength                 8
      bDescriptorType        11
      bFirstInterface         2
      bInterfaceCount         2
      bFunctionClass          2 Communications
      bFunctionSubClass      14 
      bFunctionProtocol       0 
      iFunction               0 
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         2 Communications
      bInterfaceSubClass     14 
      bInterfaceProtocol      0 
      iInterface              6 MBIM Control
      CDC Header:
        bcdCDC               1.10
      CDC Union:
        bMasterInterface        2
        bSlaveInterface         3 
      CDC MBIM:
        bcdMBIMVersion       1.00
        wMaxControlMessage   4096
        bNumberFilters       32
        bMaxFilterSize       128
        wMaxSegmentSize      2048
        bmNetworkCapabilities 0x20
          8-byte ntb input size
      CDC MBIM Extended:
        bcdMBIMExtendedVersion           1.00
        bMaxOutstandingCommandMessages     64
        wMTU                             1500
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               9
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass        10 CDC Data
      bInterfaceSubClass      0 
      bInterfaceProtocol      2 
      iInterface              0 
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       1
      bNumEndpoints           2
      bInterfaceClass        10 CDC Data
      bInterfaceSubClass      0 
      bInterfaceProtocol      2 
      iInterface              7 MBIM Data
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x8e  EP 14 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x0f  EP 15 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        4
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol     96 
      iInterface              0 
      ** UNRECOGNIZED:  05 24 00 10 01
      ** UNRECOGNIZED:  05 24 01 00 00
      ** UNRECOGNIZED:  04 24 02 02
      ** UNRECOGNIZED:  05 24 06 00 00
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x85  EP 5 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x000a  1x 10 bytes
        bInterval               9
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        5
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol     64 
      iInterface              0 
      ** UNRECOGNIZED:  05 24 00 10 01
      ** UNRECOGNIZED:  05 24 01 00 00
      ** UNRECOGNIZED:  04 24 02 02
      ** UNRECOGNIZED:  05 24 06 00 00
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x87  EP 7 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x000a  1x 10 bytes
        bInterval               9
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x86  EP 6 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x04  EP 4 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        6
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol     64 
      iInterface              0 
      ** UNRECOGNIZED:  05 24 00 10 01
      ** UNRECOGNIZED:  05 24 01 00 00
      ** UNRECOGNIZED:  04 24 02 02
      ** UNRECOGNIZED:  05 24 06 00 00
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x89  EP 9 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x000a  1x 10 bytes
        bInterval               9
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x88  EP 8 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x05  EP 5 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        7
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol     64 
      iInterface              0 
      ** UNRECOGNIZED:  05 24 00 10 01
      ** UNRECOGNIZED:  05 24 01 00 00
      ** UNRECOGNIZED:  04 24 02 02
      ** UNRECOGNIZED:  05 24 06 00 00
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x8b  EP 11 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x000a  1x 10 bytes
        bInterval               9
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x8a  EP 10 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x06  EP 6 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
Binary Object Store Descriptor:
  bLength                 5
  bDescriptorType        15
  wTotalLength       0x002a
  bNumDeviceCaps          3
  USB 2.0 Extension Device Capability:
    bLength                 7
    bDescriptorType        16
    bDevCapabilityType      2
    bmAttributes   0x0000010e
      BESL Link Power Management (LPM) Supported
    BESL value      256 us 
  SuperSpeed USB Device Capability:
    bLength                10
    bDescriptorType        16
    bDevCapabilityType      3
    bmAttributes         0x00
    wSpeedsSupported   0x000f
      Device can operate at Low Speed (1Mbps)
      Device can operate at Full Speed (12Mbps)
      Device can operate at High Speed (480Mbps)
      Device can operate at SuperSpeed (5Gbps)
    bFunctionalitySupport   1
      Lowest fully-functional device speed is Full Speed (12Mbps)
    bU1DevExitLat           0 micro seconds
    bU2DevExitLat           0 micro seconds
  SuperSpeedPlus USB Device Capability:
    bLength                20
    bDescriptorType        16
    bDevCapabilityType     10
    bmAttributes         0x00000001
      Sublink Speed Attribute count 1
      Sublink Speed ID count 0
    wFunctionalitySupport   0x1100
    bmSublinkSpeedAttr[0]   0x000a4030
      Speed Attribute ID: 0 10Gb/s Symmetric RX SuperSpeedPlus
    bmSublinkSpeedAttr[1]   0x000a40b0
      Speed Attribute ID: 0 10Gb/s Symmetric TX SuperSpeedPlus
can't get debug descriptor: Resource temporarily unavailable
Device Status:     0x0000
  (Bus Powered)

---
 drivers/net/usb/cdc_mbim.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/usb/cdc_mbim.c b/drivers/net/usb/cdc_mbim.c
index c89639381eca..cd4083e0b3b9 100644
--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -665,6 +665,11 @@ static const struct usb_device_id mbim_devs[] = {
 	  .driver_info = (unsigned long)&cdc_mbim_info_avoid_altsetting_toggle,
 	},
 
+	/* Telit FE990 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x1bc7, 0x1081, USB_CLASS_COMM, USB_CDC_SUBCLASS_MBIM, USB_CDC_PROTO_NONE),
+	  .driver_info = (unsigned long)&cdc_mbim_info_avoid_altsetting_toggle,
+	},
+
 	/* default entry */
 	{ USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_MBIM, USB_CDC_PROTO_NONE),
 	  .driver_info = (unsigned long)&cdc_mbim_info_zlp,
-- 
2.25.1

