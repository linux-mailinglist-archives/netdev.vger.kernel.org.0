Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B80351BB0A5
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 23:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgD0Vh2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 27 Apr 2020 17:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726194AbgD0Vh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 17:37:28 -0400
Received: from wp148.webpack.hosteurope.de (wp148.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:849b::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C946BC0610D5;
        Mon, 27 Apr 2020 14:37:27 -0700 (PDT)
Received: from ip1f126570.dynamic.kabel-deutschland.de ([31.18.101.112] helo=roelofs-mbp.fritz.box); authenticated
        by wp148.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1jTBR5-0003oP-S8; Mon, 27 Apr 2020 23:37:07 +0200
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [PATCH] lan743x: Added fixed_phy support
From:   Roelof Berg <rberg@berg-solutions.de>
In-Reply-To: <20200426143116.GC1140627@lunn.ch>
Date:   Mon, 27 Apr 2020 23:37:07 +0200
Cc:     "David S. Miller" <davem@davemloft.net>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <6C2E44BB-F4D1-4BC3-9FCB-55F01DA4A3C9@berg-solutions.de>
References: <rberg@berg-solutions.de>
 <20200425234320.32588-1-rberg@berg-solutions.de>
 <20200426143116.GC1140627@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
X-bounce-key: webpack.hosteurope.de;rberg@berg-solutions.de;1588023447;8c6127ab;
X-HE-SMSGID: 1jTBR5-0003oP-S8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Andrew,

thanks for working together on this. Our target system is an embedded linux device for vehicles, that has all three components as single chips on one PCB: The MCU, the lan743x MAC and a KSZ9893 switch. The busses (PCIe, RGMII are fixed traces on the PCB without any sockets, no phy is between the MAC and the switch. So it is one big PCB with a lot of chips and a few Ethernet jacks for in-vehicle communication.

For an embedded systems vendor it is ok in such a case to configure the kernel to the needs of the system. Configuring is the easiest part, usually the kernel also needs to be patched as well :)

However, I see your concern that a runtime configuration would be more versatile. There are several methods for runtime detection instead of compile time ‚detection‘, e.g. lan743’s EEPROM, the PCI vendor-id as you mentioned (although we wouldn’t strictly need a vendor ID as we have everything on one PCB), or maybe the phy-enumeration if this is unambiguous, and the usual runtime-configuration-means (dev-fs etc.). Also the EEPROM of the lan743x can be used for hardware register configuration, possibly eliminating the need to configure things like the baud rate in the .config.

Four options:
a) We offer this kernel configuration and the next embedded system designer can use phyless MII mode.
b) We change this to a runtime configuration that somehow auto-detects that phyless MII mode is desired.
    (Then the EEPROM/OTP needs to provide baud rate, MII mode and duplex mode by user-register access).
c) We move the configuration of the phyless mode to somewhere like dev-fs
d) We avoid compiled fixed_phy and use a newer method. Like device-tree configuration of fixed_phy (is it working allready ?) or phylink as you originally suggested. Unfortunately I have no test-hardware here that uses a phy.
e) We leave this one away from the kernel if it is unlikely that other embedded systems would use lan8431 in direct (phyless) MII mode as well. Microchip (on cc) could know more about this likelihood.

Any votes from the list members of how to proceed ?

Thanks and have a nice day,
Roelof

> Am 26.04.2020 um 16:31 schrieb Andrew Lunn <andrew@lunn.ch>:
> 
> On Sun, Apr 26, 2020 at 01:43:18AM +0200, Roelof Berg wrote:
>> +# All the following symbols are dependent on LAN743X - do not repeat
>> +# that for each of the symbols.
>> +if LAN743X
>> +
>> +choice LAN743x_MII_MODE
>> +	prompt "MII operation mode"
>> +	default LAN743x_MII_MODE_DEFAULT
>> +	depends on LAN743X
>> +	help
>> +	 Defines the R/G/MII operation mode of the MAC of lan743.
>> +
>> +config LAN743x_MII_MODE_DEFAULT
>> +	bool "Device default"
>> +	help
>> +	 The existing internal device configuration, which may have come from
>> +	 EEPROM or OTP, will remain unchanged.
>> +
>> +config LAN743x_MII_MODE_RGMII
>> +	bool "RGMII"
>> +	help
>> +	 RGMII (Reduced GMII) will be enabled when the driver is loaded.
>> +
>> +config LAN743x_MII_MODE_GMII
>> +	bool "G/MII"
>> +	help
>> +	 GMII (in case of 100 mbit) or MII (in case of 10 mbit) will be enabled when
>> +	 the driver is loaded.
>> +
>> +endchoice
> 
> Hi Roelof
> 
> You should not be putting this sort of configuration into Kconfig. You
> want one kernel to be able to drive all LAN743x instances. Think of a
> Debian kernel, etc.
> 
> So what are you trying to achieve here? What is the big picture?
> 
> You have a PCI device with a LAN743x connected to an Ethernet switch?
> You need the MII interface between the LAN743x and the switch to be
> configured to some specific speed? But you only want to do this for
> your device. How can you identify your device? Do you set the PCI
> vendor/device IDs to something unique?
> 
> You can add to the end of lan743x_pcidev_tbl[] your vendor/device
> ID. In the probe function you can detect your own vendor/product ID
> and then configure things as you need. 
> 
>    Andrew
> 

