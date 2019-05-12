Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC4711ABFE
	for <lists+netdev@lfdr.de>; Sun, 12 May 2019 14:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbfELMTR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 12 May 2019 08:19:17 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:41817 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbfELMTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 May 2019 08:19:16 -0400
Received: from localhost (unknown [109.190.253.16])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 50D68200003;
        Sun, 12 May 2019 12:19:11 +0000 (UTC)
Date:   Sun, 12 May 2019 14:19:10 +0200
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
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
Subject: Re: NVMEM address DT post processing [Was: Re: [PATCH net 0/3] add
 property "nvmem_macaddr_swap" to swap macaddr bytes order]
Message-ID: <20190512121910.432t2vncvmpu26qg@flea>
References: <1557476567-17397-4-git-send-email-fugang.duan@nxp.com>
 <1557476567-17397-3-git-send-email-fugang.duan@nxp.com>
 <1557476567-17397-2-git-send-email-fugang.duan@nxp.com>
 <1557476567-17397-1-git-send-email-fugang.duan@nxp.com>
 <20190510112822.GT81826@meh.true.cz>
 <20190510113155.mvpuhe4yzxdaanei@flea>
 <20190511144444.GU81826@meh.true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20190511144444.GU81826@meh.true.cz>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 11, 2019 at 04:44:44PM +0200, Petr Štetiar wrote:
> So something like this?
>
> diff --git a/Documentation/devicetree/bindings/nvmem/nvmem.txt b/Documentation/devicetree/bindings/nvmem/nvmem.txt
> index fd06c09b822b..d781e47b049d 100644
> --- a/Documentation/devicetree/bindings/nvmem/nvmem.txt
> +++ b/Documentation/devicetree/bindings/nvmem/nvmem.txt
> @@ -1,12 +1,14 @@
>  = NVMEM(Non Volatile Memory) Data Device Tree Bindings =
>
>  This binding is intended to represent the location of hardware
> -configuration data stored in NVMEMs like eeprom, efuses and so on.
> +configuration data stored in NVMEMs like eeprom, efuses and so on. This
> +binding provides some basic transformation of the stored data as well.
>
>  On a significant proportion of boards, the manufacturer has stored
>  some data on NVMEM, for the OS to be able to retrieve these information
>  and act upon it. Obviously, the OS has to know about where to retrieve
> -these data from, and where they are stored on the storage device.
> +these data from, where they are stored on the storage device and how to
> +postprocess them.
>
>  This document is here to document this.
>
> @@ -29,6 +31,19 @@ Optional properties:
>  bits:  Is pair of bit location and number of bits, which specifies offset
>         in bit and number of bits within the address range specified by reg property.
>         Offset takes values from 0-7.
> +byte-indices: array, encoded as an arbitrary number of (offset, length) pairs,
> +            within the address range specified by reg property. Each pair is
> +            then processed with byte-transform in order to produce single u8
> +            sized byte.
> +byte-transform: string, specifies the transformation which should be applied
> +              to every byte-indices pair in order to produce usable u8 sized byte,
> +              possible values are "none", "ascii" and "bcd". Default is "none".
> +byte-adjust: number, value by which should be adjusted resulting output byte at
> +           byte-adjust-at offset.
> +byte-adjust-at: number, specifies offset of resulting output byte which should be
> +              adjusted by byte-adjust value, default is 0.
> +byte-result-swap: boolean, specifies if the resulting output bytes should be
> +                swapped prior to return
>
>  For example:
>
> @@ -59,6 +74,36 @@ For example:
>                 ...
>         };
>
> +Another example where we've MAC address for eth1 stored in the NOR EEPROM as
> +following sequence of bytes (output of hexdump -C /dev/mtdX):
> +
> + 00000180  66 61 63 5f 6d 61 63 20  3d 20 44 34 3a 45 45 3a  |fac_mac = D4:EE:|
> + 00000190  30 37 3a 33 33 3a 36 43  3a 32 30 0a 42 44 49 4e  |07:33:6C:20.BDIN|
> +
> +Which means, that MAC address is stored in EEPROM as D4:EE:07:33:6C:20, so
> +ASCII delimited by colons, but we can't use this MAC address directly as
> +there's only one MAC address stored in the EEPROM and we need to increment last
> +octet/byte in this address in order to get usable MAC address for eth1 device.
> +
> + eth1_addr: eth-mac-addr@18a {
> +     reg = <0x18a 0x11>;
> +     byte-indices = < 0 2
> +                      3 2
> +                      6 2
> +                      9 2
> +                     12 2
> +                     15 2>;
> +     byte-transform = "ascii";
> +     byte-increment = <1>;
> +     byte-increment-at = <5>;
> +     byte-result-swap;
> + };
> +
> + &eth1 {
> +     nvmem-cells = <&eth1_addr>;
> +     nvmem-cell-names = "mac-address";
> + };
> +

Something along those lines yes. I'm not sure why in your example the
cell doesn't start at the mac address itself, instead of starting at
the key + having to specify an offset though. The reg property is the
offset already.

Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
