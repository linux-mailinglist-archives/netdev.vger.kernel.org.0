Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD882B4CA1
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 18:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732759AbgKPRXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 12:23:44 -0500
Received: from mail-oi1-f173.google.com ([209.85.167.173]:37299 "EHLO
        mail-oi1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730176AbgKPRXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 12:23:44 -0500
Received: by mail-oi1-f173.google.com with SMTP id m17so19622741oie.4;
        Mon, 16 Nov 2020 09:23:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Wx3yKrnCjPjE6j1ql3vWwjCf9V8ob1xy4I0VI3w+CV8=;
        b=LVA8w6NnuB0UkJoeG14fzQtmjoQPFFRf2jl3rcN3IjXFb3ogC2nSSIxEWXpu8bHqZd
         6F6yxl15MToJ4m72Qd/cHRxixq8+SPRSvUd31r9mZfjXIG6cIOgmAXcmuWJ2kSiw9koo
         CaXoUEr/5qeGaBVmhW8PlIJ6JvM01oU6FRHQ8z7+hs63jOnn55kaDE9hxy5aZbZ+gIJ9
         yQA9HK0yjBNbPjGY6qPqVA/Df5a+qSZ96uYlFgilnAB6wnprbXdumH2uOi0zL0Xlgtsz
         s4EIoQdh3vVrmdtBVA/4uxxPiPdUawHuz5Jm2IlkWlTSF0PdMYLaF9s6inlmrSYlzASD
         bpXg==
X-Gm-Message-State: AOAM530X2Fmujth5Vj0VEv2Iip8QddO7VaVE4blkDT5uNVcuWKfra2xN
        DPTNSyoaOgbtdiOQOcbjTlakMFw49olLMmIslvLbb5GBQtioXg==
X-Google-Smtp-Source: ABdhPJxxlnzlofxhGTASHbqM68kieoQ7cmBRdXD9P2eYRgeQY8IY3mLFwlpU+mnjJaIpRvNmcVviYhFsBJ9eAzgzV7A=
X-Received: by 2002:a54:4101:: with SMTP id l1mr321407oic.151.1605547422537;
 Mon, 16 Nov 2020 09:23:42 -0800 (PST)
MIME-Version: 1.0
From:   Roland Dreier <roland@kernel.org>
Date:   Mon, 16 Nov 2020 09:23:26 -0800
Message-ID: <CAG4TOxPXerpdxxyTbo+BFxBAvDHNFg38hf0zz5eigBJokhLWvA@mail.gmail.com>
Subject: cdc_ncm kernel log spam with trendnet 2.5G USB adapter
To:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Oliver Neukum <oliver@neukum.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, I recently got a 2.5G USB adapter, and although it works fine, the
driver continually spams the kernel log with messages like

[127662.025647] cdc_ncm 4-1:2.0 enx3c8cf8f942e0: network connection: connected
[127662.057680] cdc_ncm 4-1:2.0 enx3c8cf8f942e0: 2500 mbit/s downlink
2500 mbit/s uplink
[127662.089794] cdc_ncm 4-1:2.0 enx3c8cf8f942e0: network connection: connected
[127662.121831] cdc_ncm 4-1:2.0 enx3c8cf8f942e0: 2500 mbit/s downlink
2500 mbit/s uplink
[127662.153858] cdc_ncm 4-1:2.0 enx3c8cf8f942e0: network connection: connected
...

Looking at the code in cdc_ncm.c it seems the device is just sending
USB_CDC_NOTIFY_NETWORK_CONNECTION and USB_CDC_NOTIFY_SPEED_CHANGE urbs
over and over, and the driver logs every single one.

Should we add code to the driver to keep track of what the last event
was and only log if the state has really change?

Thanks!
  Roland

Full details on the adapter, in case it matters:

Bus 004 Device 005: ID 20f4:e02b TRENDnet USB 10/100/1G/2.5G LAN
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               3.20
  bDeviceClass            0
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0         9
  idVendor           0x20f4 TRENDnet
  idProduct          0xe02b
  bcdDevice           30.04
  iManufacturer           1
  iProduct                2
  iSerial                 6
  bNumConfigurations      3
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength       0x0039
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              512mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
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
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               0
        bMaxBurst               3
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               0
        bMaxBurst               3
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval              11
        bMaxBurst               0
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength       0x0068
    bNumInterfaces          2
    bConfigurationValue     2
    iConfiguration          0
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              512mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         2 Communications
      bInterfaceSubClass     13
      bInterfaceProtocol      0
      iInterface              5
      CDC Header:
        bcdCDC               1.10
      CDC Union:
        bMasterInterface        0
        bSlaveInterface         1
      CDC Ethernet:
        iMacAddress                      3 (??)
        bmEthernetStatistics    0x0031500f
        wMaxSegmentSize               1518
        wNumberMCFilters            0x8000
        bNumberPowerFilters              0
      CDC NCM:
        bcdNcmVersion        1.00
        bmNetworkCapabilities 0x2b
          8-byte ntb input size
          max datagram size
          net address
          packet filter
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0010  1x 16 bytes
        bInterval               8
        bMaxBurst               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass        10 CDC Data
      bInterfaceSubClass      0
      bInterfaceProtocol      1
      iInterface              0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       1
      bNumEndpoints           2
      bInterfaceClass        10 CDC Data
      bInterfaceSubClass      0
      bInterfaceProtocol      1
      iInterface              4
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               0
        bMaxBurst               3
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               0
        bMaxBurst               3
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength       0x0062
    bNumInterfaces          2
    bConfigurationValue     3
    iConfiguration          0
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              512mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         2 Communications
      bInterfaceSubClass      6 Ethernet Networking
      bInterfaceProtocol      0
      iInterface              5
      CDC Header:
        bcdCDC               1.10
      CDC Union:
        bMasterInterface        0
        bSlaveInterface         1
      CDC Ethernet:
        iMacAddress                      3 (??)
        bmEthernetStatistics    0x0031500f
        wMaxSegmentSize               1518
        wNumberMCFilters            0x8000
        bNumberPowerFilters              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0010  1x 16 bytes
        bInterval               8
        bMaxBurst               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass        10 CDC Data
      bInterfaceSubClass      0
      bInterfaceProtocol      0
      iInterface              0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       1
      bNumEndpoints           2
      bInterfaceClass        10 CDC Data
      bInterfaceSubClass      0
      bInterfaceProtocol      0
      iInterface              4
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               0
        bMaxBurst               3
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               0
        bMaxBurst               3
