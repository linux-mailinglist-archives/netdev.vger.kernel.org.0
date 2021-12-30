Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE2B48DF3C
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 21:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbiAMUxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 15:53:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232824AbiAMUxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 15:53:13 -0500
Received: from kurisu.lahfa.xyz (unknown [IPv6:2001:bc8:38ee::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709CBC061574
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 12:53:13 -0800 (PST)
Date:   Thu, 30 Dec 2021 01:03:38 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lahfa.xyz; s=kurisu;
        t=1642107190; bh=iTfq66PUjMBwL/9YH8MY1lcOgOiI85LGd4kLjTqbsfc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=RUEHAZRqcoo2O3TRQGHD/rpz5vq4PnB9YknOFEB2g9SOIl+fPENHMEVa/GGS6SX57
         0gVM0gPl0C454rCgsxNWI6LNfDINM2mkK2NuuRwacJZ0E4k7/o3cRkv6Ukhs7YORnO
         EzJaQoEPAdgcvpSt0i3yccPjNnJ3Mlw75IM5Ct7I=
From:   Ryan Lahfa <ryan@lahfa.xyz>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Hayes Wang <hayeswang@realtek.com>
Subject: Re: RTL8156(A|B) chip requires r8156 to be force loaded to operate
Message-ID: <20211230000338.6q6zlj7ibvuz7yqt@Thors>
References: <20211224203018.z2n7sylht47ownga@Thors>
 <20211227182124.5cbc0d07@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bsmd42vk4v3v3v7h"
Content-Disposition: inline
In-Reply-To: <20211227182124.5cbc0d07@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bsmd42vk4v3v3v7h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 27, 2021 at 06:21:24PM -0800, Jakub Kicinski wrote:
> On Fri, 24 Dec 2021 21:30:18 +0100 Ryan Lahfa wrote:
> > Hi all,
> > 
> > I recently bought an USB-C 2.5Gbps external network card, which shows in
> > `lsusb` as:
> > 
> > > Bus 002 Device 003: ID 0bda:8156 Realtek Semiconductor Corp. USB 10/100/1G/2.5G LAN  
> > 
> > By default, on my distribution (NixOS "21.11pre319254.b5182c214fa")'s
> > latest kernel (`pkgs.linuxPackages_latest`) which shows in `uname -nar`
> > as:
> > 
> > > Linux $machine 5.15.10 #1-NixOS SMP Fri Dec 17 09:30:17 UTC 2021 x86_64 GNU/Linux  
> > 
> > The network card is loaded with `cdc_ncm` driver and is unable to detect
> > any carrier even when one is actually plugged in, I tried multiple
> > things, I confirmed independently that the carrier is working.
> > 
> > Through further investigations and with the help of a user on
> > Libera.Chat #networking channel, we blacklisted `cdc_ncm`, but nothing
> > get loaded in turn.
> > 
> > Then, I forced the usage of r8152 for the device 0bda:8156 using `echo
> > 0bda 8156 > /sys/bus/usb/drivers/r8152/new_id`, and... miracle.
> > Everything just worked.
> > 
> > I am uncertain whether this falls in kernel's responsibility or not, it
> > seems indeed that my device is listed for r8152: https://github.com/torvalds/linux/blob/master/drivers/net/usb/r8152.c#L9790 introduced by this commit https://github.com/torvalds/linux/commit/195aae321c829dd1945900d75561e6aa79cce208 if I understand well, which is tagged for 5.15.
> > 
> > I am curious to see how difficult would that be to write a patch for
> > this and fix it, meanwhile, here is my modest contribution with this bug
> > report, hopefully, this is the right place for them.
> 
> Can you please share the output of lsusb -d '0bda:8156' -vv ?

Here it is, attached.

Kind regards,
-- 
Ryan Lahfa

--bsmd42vk4v3v3v7h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=lsusb_output


Bus 002 Device 006: ID 0bda:8156 Realtek Semiconductor Corp. USB 10/100/1G/2.5G LAN
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               3.20
  bDeviceClass            0 
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0         9
  idVendor           0x0bda Realtek Semiconductor Corp.
  idProduct          0x8156 
  bcdDevice           31.04
  iManufacturer           1 Realtek
  iProduct                2 USB 10/100/1G/2.5G LAN
  iSerial                 6 401000001
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
    MaxPower              256mA
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
    MaxPower              256mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         2 Communications
      bInterfaceSubClass     13 
      bInterfaceProtocol      0 
      iInterface              5 CDC Communications Control
      CDC Header:
        bcdCDC               1.10
      CDC Union:
        bMasterInterface        0
        bSlaveInterface         1 
      CDC Ethernet:
        iMacAddress                      3 00E04C680590
        bmEthernetStatistics    0x0031501f
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
        bInterval              11
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
      iInterface              4 Ethernet Data
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
    MaxPower              256mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         2 Communications
      bInterfaceSubClass      6 Ethernet Networking
      bInterfaceProtocol      0 
      iInterface              5 CDC Communications Control
      CDC Header:
        bcdCDC               1.10
      CDC Union:
        bMasterInterface        0
        bSlaveInterface         1 
      CDC Ethernet:
        iMacAddress                      3 00E04C680590
        bmEthernetStatistics    0x0031501f
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
        bInterval              11
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
      iInterface              4 Ethernet Data
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
Binary Object Store Descriptor:
  bLength                 5
  bDescriptorType        15
  wTotalLength       0x0016
  bNumDeviceCaps          2
  USB 2.0 Extension Device Capability:
    bLength                 7
    bDescriptorType        16
    bDevCapabilityType      2
    bmAttributes   0x00000002
      HIRD Link Power Management (LPM) Supported
  SuperSpeed USB Device Capability:
    bLength                10
    bDescriptorType        16
    bDevCapabilityType      3
    bmAttributes         0x02
      Latency Tolerance Messages (LTM) Supported
    wSpeedsSupported   0x000e
      Device can operate at Full Speed (12Mbps)
      Device can operate at High Speed (480Mbps)
      Device can operate at SuperSpeed (5Gbps)
    bFunctionalitySupport   2
      Lowest fully-functional device speed is High Speed (480Mbps)
    bU1DevExitLat          10 micro seconds
    bU2DevExitLat        2047 micro seconds
Device Status:     0x001c
  (Bus Powered)
  U1 Enabled
  U2 Enabled
  Latency Tolerance Messaging (LTM) Enabled

--bsmd42vk4v3v3v7h--
