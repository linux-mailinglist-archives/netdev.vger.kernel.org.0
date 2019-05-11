Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B63C21A821
	for <lists+netdev@lfdr.de>; Sat, 11 May 2019 16:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728583AbfEKOow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 May 2019 10:44:52 -0400
Received: from smtp-out.xnet.cz ([178.217.244.18]:43011 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726240AbfEKOow (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 May 2019 10:44:52 -0400
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id 62BDF469C;
        Sat, 11 May 2019 16:44:46 +0200 (CEST)
Received: from localhost (meh.true.cz [local])
        by meh.true.cz (OpenSMTPD) with ESMTPA id 13d147d3;
        Sat, 11 May 2019 16:44:44 +0200 (CEST)
Date:   Sat, 11 May 2019 16:44:44 +0200
From:   Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Andy Duan <fugang.duan@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "john@phrozen.org" <john@phrozen.org>,
        "bgolaszewski@baylibre.com" <bgolaszewski@baylibre.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alban Bedel <albeu@free.fr>, devicetree@vger.kernel.org
Subject: NVMEM address DT post processing [Was: Re: [PATCH net 0/3] add
 property "nvmem_macaddr_swap" to swap macaddr bytes order]
Message-ID: <20190511144444.GU81826@meh.true.cz>
Reply-To: Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
References: <1557476567-17397-4-git-send-email-fugang.duan@nxp.com>
 <1557476567-17397-3-git-send-email-fugang.duan@nxp.com>
 <1557476567-17397-2-git-send-email-fugang.duan@nxp.com>
 <1557476567-17397-1-git-send-email-fugang.duan@nxp.com>
 <20190510112822.GT81826@meh.true.cz>
 <20190510113155.mvpuhe4yzxdaanei@flea>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190510113155.mvpuhe4yzxdaanei@flea>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maxime Ripard <maxime.ripard@bootlin.com> [2019-05-10 13:31:55]:

Hi,

> > This reverse byte order format/layout is one of a few other storage formats
> > currently used by vendors, some other (creative) vendors are currently
> > providing MAC addresses in NVMEMs as ASCII text in following two formats
> > (hexdump -C /dev/mtdX):
> >
> >  a) 0090FEC9CBE5 - MAC address stored as ASCII without colon between octets
> >
> >   00000090  57 2e 4c 41 4e 2e 4d 41  43 2e 41 64 64 72 65 73  |W.LAN.MAC.Addres|
> >   000000a0  73 3d 30 30 39 30 46 45  43 39 43 42 45 35 00 48  |s=0090FEC9CBE5.H|
> >   000000b0  57 2e 4c 41 4e 2e 32 47  2e 30 2e 4d 41 43 2e 41  |W.LAN.2G.0.MAC.A|
> >
> >   (From https://github.com/openwrt/openwrt/pull/1448#issuecomment-442476695)
> >
> >  b) D4:EE:07:33:6C:20 - MAC address stored as ASCII with colon between octets
> >
> >   00000180  66 61 63 5f 6d 61 63 20  3d 20 44 34 3a 45 45 3a  |fac_mac = D4:EE:|
> >   00000190  30 37 3a 33 33 3a 36 43  3a 32 30 0a 42 44 49 4e  |07:33:6C:20.BDIN|
> >
> >   (From https://github.com/openwrt/openwrt/pull/1906#issuecomment-483881911)
> >
> > > The patch set is to add property "nvmem_macaddr_swap" to swap
> > > macaddr bytes order.
> >
> > so it would allow following DT construct (simplified):
> >
> >  &eth0 {
> > 	nvmem-cells = <&eth0_addr>;
> > 	nvmem-cell-names = "mac-address";
> > 	nvmem_macaddr_swap;
> >  };
> >
> > I'm not sure about the `nvmem_macaddr_swap` property name, as currently there
> > are no other properties with underscores, so it should be probably named as
> > `nvmem-macaddr-swap`. DT specs permits use of the underscores, but the
> > estabilished convention is probably prefered.
> >
> > In order to cover all above mentioned use cases, it would make more sense
> > to add a description of the MAC address layout to the DT and use this
> > information to properly postprocess the NVMEM content into usable MAC
> > address?
> >
> > Something like this?
> >
> >  - nvmem-cells: phandle, reference to an nvmem node for the MAC address
> >  - nvmem-cell-names: string, should be "mac-address" if nvmem is to be used
> >  - nvmem-mac-address-layout: string, specifies MAC address storage layout.
> >    Supported values are: "binary", "binary-swapped", "ascii", "ascii-delimited".
> >    "binary" is the default.
> >
> > Or perhaps something like this?
> >
> >  - nvmem-cells: phandle, reference to an nvmem node for the MAC address
> >  - nvmem-cell-names: string, should be any of the supported values.
> >    Supported values are: "mac-address", "mac-address-swapped",
> >    "mac-address-ascii", "mac-address-ascii-delimited".
> >
> > I'm more inclined towards the first proposed solution, as I would like to
> > propose MAC address octet incrementation feature in the future, so it would
> > become:
> >
> >  - nvmem-cells: phandle, reference to an nvmem node for the MAC address
> >  - nvmem-cell-names: string, should be "mac-address" if nvmem is to be used
> >  - nvmem-mac-address-layout: string, specifies MAC address storage layout.
> >    Supported values are: "binary", "binary-swapped", "ascii", "ascii-delimited".
> >    "binary" is the default.
> >  - nvmem-mac-address-increment: number, value by which should be
> >    incremented MAC address octet, could be negative value as well.
> >  - nvmem-mac-address-increment-octet: number, valid values 0-5, default is 5.
> >    Specifies MAC address octet used for `nvmem-mac-address-increment`.
> >
> > What do you think?
> 
> It looks to me that it should be abstracted away by the nvmem
> interface and done at the provider level, not the customer.

So something like this?

diff --git a/Documentation/devicetree/bindings/nvmem/nvmem.txt b/Documentation/devicetree/bindings/nvmem/nvmem.txt
index fd06c09b822b..d781e47b049d 100644
--- a/Documentation/devicetree/bindings/nvmem/nvmem.txt
+++ b/Documentation/devicetree/bindings/nvmem/nvmem.txt
@@ -1,12 +1,14 @@
 = NVMEM(Non Volatile Memory) Data Device Tree Bindings =
 
 This binding is intended to represent the location of hardware
-configuration data stored in NVMEMs like eeprom, efuses and so on.
+configuration data stored in NVMEMs like eeprom, efuses and so on. This
+binding provides some basic transformation of the stored data as well.
 
 On a significant proportion of boards, the manufacturer has stored
 some data on NVMEM, for the OS to be able to retrieve these information
 and act upon it. Obviously, the OS has to know about where to retrieve
-these data from, and where they are stored on the storage device.
+these data from, where they are stored on the storage device and how to
+postprocess them.
 
 This document is here to document this.
 
@@ -29,6 +31,19 @@ Optional properties:
 bits:  Is pair of bit location and number of bits, which specifies offset
        in bit and number of bits within the address range specified by reg property.
        Offset takes values from 0-7.
+byte-indices: array, encoded as an arbitrary number of (offset, length) pairs,
+            within the address range specified by reg property. Each pair is
+            then processed with byte-transform in order to produce single u8
+            sized byte.
+byte-transform: string, specifies the transformation which should be applied
+              to every byte-indices pair in order to produce usable u8 sized byte,
+              possible values are "none", "ascii" and "bcd". Default is "none".
+byte-adjust: number, value by which should be adjusted resulting output byte at
+           byte-adjust-at offset.
+byte-adjust-at: number, specifies offset of resulting output byte which should be
+              adjusted by byte-adjust value, default is 0.
+byte-result-swap: boolean, specifies if the resulting output bytes should be
+                swapped prior to return
 
 For example:
 
@@ -59,6 +74,36 @@ For example:
                ...
        };
 
+Another example where we've MAC address for eth1 stored in the NOR EEPROM as
+following sequence of bytes (output of hexdump -C /dev/mtdX):
+
+ 00000180  66 61 63 5f 6d 61 63 20  3d 20 44 34 3a 45 45 3a  |fac_mac = D4:EE:|
+ 00000190  30 37 3a 33 33 3a 36 43  3a 32 30 0a 42 44 49 4e  |07:33:6C:20.BDIN|
+
+Which means, that MAC address is stored in EEPROM as D4:EE:07:33:6C:20, so
+ASCII delimited by colons, but we can't use this MAC address directly as
+there's only one MAC address stored in the EEPROM and we need to increment last
+octet/byte in this address in order to get usable MAC address for eth1 device.
+
+ eth1_addr: eth-mac-addr@18a {
+     reg = <0x18a 0x11>;
+     byte-indices = < 0 2
+                      3 2
+                      6 2
+                      9 2
+                     12 2
+                     15 2>;
+     byte-transform = "ascii";
+     byte-increment = <1>;
+     byte-increment-at = <5>;
+     byte-result-swap;
+ };
+
+ &eth1 {
+     nvmem-cells = <&eth1_addr>;
+     nvmem-cell-names = "mac-address";
+ };
+
 = Data consumers =
 Are device nodes which consume nvmem data cells/providers.
