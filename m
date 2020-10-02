Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B368281735
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 17:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387983AbgJBP4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 11:56:00 -0400
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:17874 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387688AbgJBPz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 11:55:59 -0400
Received: from tomoyo.flets-east.jp ([153.230.197.127])
        by mwinf5d76 with ME
        id b3vk230042lQRaH033vrag; Fri, 02 Oct 2020 17:55:57 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Fri, 02 Oct 2020 17:55:57 +0200
X-ME-IP: 153.230.197.127
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Oliver Neukum <oneukum@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Cc:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Jakub Kicinski <kuba@kernel.org>,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH v3 7/7] usb: cdc-acm: add quirk to blacklist ETAS ES58X devices
Date:   Sat,  3 Oct 2020 00:41:51 +0900
Message-Id: <20201002154219.4887-8-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201002154219.4887-1-mailhol.vincent@wanadoo.fr>
References: <20200926175810.278529-1-mailhol.vincent@wanadoo.fr>
 <20201002154219.4887-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ES58X devices has a CDC ACM interface (used for debug
purpose). During probing, the device is thus recognized as USB Modem
(CDC ACM), preventing the etas-es58x module to load:
  usbcore: registered new interface driver etas_es58x
  usb 1-1.1: new full-speed USB device number 14 using xhci_hcd
  usb 1-1.1: New USB device found, idVendor=108c, idProduct=0159, bcdDevice= 1.00
  usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
  usb 1-1.1: Product: ES581.4
  usb 1-1.1: Manufacturer: ETAS GmbH
  usb 1-1.1: SerialNumber: 2204355
  cdc_acm 1-1.1:1.0: No union descriptor, testing for castrated device
  cdc_acm 1-1.1:1.0: ttyACM0: USB ACM device

Thus, these have been added to the ignore list in
drivers/usb/class/cdc-acm.c

N.B. Future firmware release of the ES58X will remove the CDC-ACM
interface.

`lsusb -v` of the three devices variant (ES581.4, ES582.1 and
ES584.1):

  Bus 001 Device 011: ID 108c:0159 Robert Bosch GmbH ES581.4
  Device Descriptor:
    bLength                18
    bDescriptorType         1
    bcdUSB               1.10
    bDeviceClass            2 Communications
    bDeviceSubClass         0
    bDeviceProtocol         0
    bMaxPacketSize0        64
    idVendor           0x108c Robert Bosch GmbH
    idProduct          0x0159
    bcdDevice            1.00
    iManufacturer           1 ETAS GmbH
    iProduct                2 ES581.4
    iSerial                 3 2204355
    bNumConfigurations      1
    Configuration Descriptor:
      bLength                 9
      bDescriptorType         2
      wTotalLength       0x0035
      bNumInterfaces          1
      bConfigurationValue     1
      iConfiguration          5 Bus Powered Configuration
      bmAttributes         0x80
        (Bus Powered)
      MaxPower              100mA
      Interface Descriptor:
        bLength                 9
        bDescriptorType         4
        bInterfaceNumber        0
        bAlternateSetting       0
        bNumEndpoints           3
        bInterfaceClass         2 Communications
        bInterfaceSubClass      2 Abstract (modem)
        bInterfaceProtocol      0
        iInterface              4 ACM Control Interface
        CDC Header:
          bcdCDC               1.10
        CDC Call Management:
          bmCapabilities       0x01
            call management
          bDataInterface          0
        CDC ACM:
          bmCapabilities       0x06
            sends break
            line coding and serial state
        Endpoint Descriptor:
          bLength                 7
          bDescriptorType         5
          bEndpointAddress     0x81  EP 1 IN
          bmAttributes            3
            Transfer Type            Interrupt
            Synch Type               None
            Usage Type               Data
          wMaxPacketSize     0x0010  1x 16 bytes
          bInterval              10
        Endpoint Descriptor:
          bLength                 7
          bDescriptorType         5
          bEndpointAddress     0x82  EP 2 IN
          bmAttributes            2
            Transfer Type            Bulk
            Synch Type               None
            Usage Type               Data
          wMaxPacketSize     0x0040  1x 64 bytes
          bInterval               0
        Endpoint Descriptor:
          bLength                 7
          bDescriptorType         5
          bEndpointAddress     0x03  EP 3 OUT
          bmAttributes            2
            Transfer Type            Bulk
            Synch Type               None
            Usage Type               Data
          wMaxPacketSize     0x0040  1x 64 bytes
          bInterval               0
  Device Status:     0x0000
    (Bus Powered)

  Bus 001 Device 012: ID 108c:0168 Robert Bosch GmbH ES582
  Device Descriptor:
    bLength                18
    bDescriptorType         1
    bcdUSB               2.00
    bDeviceClass            2 Communications
    bDeviceSubClass         0
    bDeviceProtocol         0
    bMaxPacketSize0        64
    idVendor           0x108c Robert Bosch GmbH
    idProduct          0x0168
    bcdDevice            1.00
    iManufacturer           1 ETAS GmbH
    iProduct                2 ES582
    iSerial                 3 0108933
    bNumConfigurations      1
    Configuration Descriptor:
      bLength                 9
      bDescriptorType         2
      wTotalLength       0x0043
      bNumInterfaces          2
      bConfigurationValue     1
      iConfiguration          0
      bmAttributes         0x80
        (Bus Powered)
      MaxPower              500mA
      Interface Descriptor:
        bLength                 9
        bDescriptorType         4
        bInterfaceNumber        0
        bAlternateSetting       0
        bNumEndpoints           1
        bInterfaceClass         2 Communications
        bInterfaceSubClass      2 Abstract (modem)
        bInterfaceProtocol      1 AT-commands (v.25ter)
        iInterface              0
        CDC Header:
          bcdCDC               1.10
        CDC ACM:
          bmCapabilities       0x02
            line coding and serial state
        CDC Union:
          bMasterInterface        0
          bSlaveInterface         1
        CDC Call Management:
          bmCapabilities       0x03
            call management
            use DataInterface
          bDataInterface          1
        Endpoint Descriptor:
          bLength                 7
          bDescriptorType         5
          bEndpointAddress     0x83  EP 3 IN
          bmAttributes            3
            Transfer Type            Interrupt
            Synch Type               None
            Usage Type               Data
          wMaxPacketSize     0x0040  1x 64 bytes
          bInterval              16
      Interface Descriptor:
        bLength                 9
        bDescriptorType         4
        bInterfaceNumber        1
        bAlternateSetting       0
        bNumEndpoints           2
        bInterfaceClass        10 CDC Data
        bInterfaceSubClass      0
        bInterfaceProtocol      0
        iInterface              0
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
  Device Qualifier (for other device speed):
    bLength                10
    bDescriptorType         6
    bcdUSB               2.00
    bDeviceClass            2 Communications
    bDeviceSubClass         0
    bDeviceProtocol         0
    bMaxPacketSize0        64
    bNumConfigurations      1
  Device Status:     0x0000
    (Bus Powered)

  Bus 001 Device 013: ID 108c:0169 Robert Bosch GmbH ES584.1
  Device Descriptor:
    bLength                18
    bDescriptorType         1
    bcdUSB               2.00
    bDeviceClass            2 Communications
    bDeviceSubClass         0
    bDeviceProtocol         0
    bMaxPacketSize0        64
    idVendor           0x108c Robert Bosch GmbH
    idProduct          0x0169
    bcdDevice            1.00
    iManufacturer           1 ETAS GmbH
    iProduct                2 ES584.1
    iSerial                 3 0100320
    bNumConfigurations      1
    Configuration Descriptor:
      bLength                 9
      bDescriptorType         2
      wTotalLength       0x0043
      bNumInterfaces          2
      bConfigurationValue     1
      iConfiguration          0
      bmAttributes         0x80
        (Bus Powered)
      MaxPower              500mA
      Interface Descriptor:
        bLength                 9
        bDescriptorType         4
        bInterfaceNumber        0
        bAlternateSetting       0
        bNumEndpoints           1
        bInterfaceClass         2 Communications
        bInterfaceSubClass      2 Abstract (modem)
        bInterfaceProtocol      1 AT-commands (v.25ter)
        iInterface              0
        CDC Header:
          bcdCDC               1.10
        CDC ACM:
          bmCapabilities       0x02
            line coding and serial state
        CDC Union:
          bMasterInterface        0
          bSlaveInterface         1
        CDC Call Management:
          bmCapabilities       0x03
            call management
            use DataInterface
          bDataInterface          1
        Endpoint Descriptor:
          bLength                 7
          bDescriptorType         5
          bEndpointAddress     0x83  EP 3 IN
          bmAttributes            3
            Transfer Type            Interrupt
            Synch Type               None
            Usage Type               Data
          wMaxPacketSize     0x0040  1x 64 bytes
          bInterval              16
      Interface Descriptor:
        bLength                 9
        bDescriptorType         4
        bInterfaceNumber        1
        bAlternateSetting       0
        bNumEndpoints           2
        bInterfaceClass        10 CDC Data
        bInterfaceSubClass      0
        bInterfaceProtocol      0
        iInterface              0
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
  Device Qualifier (for other device speed):
    bLength                10
    bDescriptorType         6
    bcdUSB               2.00
    bDeviceClass            2 Communications
    bDeviceSubClass         0
    bDeviceProtocol         0
    bMaxPacketSize0        64
    bNumConfigurations      1
  Device Status:     0x0000
    (Bus Powered)

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---

Changes in v3: None

Changes in v2:
  - Added dmesg and lsusb -v information and rephrased the comment.
---
 drivers/usb/class/cdc-acm.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 7f6f3ab5b8a6..ed9355094e8c 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1906,6 +1906,17 @@ static const struct usb_device_id acm_ids[] = {
 	.driver_info = IGNORE_DEVICE,
 	},
 
+	/* Exclude ETAS ES58x */
+	{ USB_DEVICE(0x108c, 0x0159), /* ES581.4 */
+	.driver_info = IGNORE_DEVICE,
+	},
+	{ USB_DEVICE(0x108c, 0x0168), /* ES582.1 */
+	.driver_info = IGNORE_DEVICE,
+	},
+	{ USB_DEVICE(0x108c, 0x0169), /* ES584.1 */
+	.driver_info = IGNORE_DEVICE,
+	},
+
 	{ USB_DEVICE(0x1bc7, 0x0021), /* Telit 3G ACM only composition */
 	.driver_info = SEND_ZERO_PACKET,
 	},
-- 
2.26.2

