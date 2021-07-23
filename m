Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 117CB3D403C
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 20:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbhGWRlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 13:41:16 -0400
Received: from tulum.helixd.com ([162.252.81.98]:48491 "EHLO tulum.helixd.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229459AbhGWRlQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 13:41:16 -0400
X-Greylist: delayed 69993 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Jul 2021 13:41:16 EDT
Received: from [IPv6:2600:8801:8800:12e8:90af:18a5:3772:6653] (unknown [IPv6:2600:8801:8800:12e8:90af:18a5:3772:6653])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        (Authenticated sender: dalcocer@helixd.com)
        by tulum.helixd.com (Postfix) with ESMTPSA id 3582420591;
        Fri, 23 Jul 2021 11:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tulum.helixd.com;
        s=mail; t=1627064508;
        bh=ciewzSL6EnsO3RNuSM0Bfc4PKdti7t/I94oGMMQpDZ4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=KnvQ7UXug3UMIKoH3yOE8K2RsRzSpLTyq0nsTQFcSWoGs0Cir59L8HndFjhmZsrn4
         Y060tTLvRiN4U5hd0EtmcXYBNFqLWkSFti5cxM21PZj1nYB9JjeTl2Nw5uiFi7u/dn
         PFglTy1re6K1g3wDZUq5a/byaomwjbebL3iNlhLg=
Subject: Re: Marvell switch port shows LOWERLAYERDOWN, ping fails
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
References: <6a70869d-d8d5-4647-0640-4e95866a0392@helixd.com>
 <YPrHJe+zJGJ7oezW@lunn.ch>
From:   Dario Alcocer <dalcocer@helixd.com>
Message-ID: <0188e53d-1535-658a-4134-a5f05f214bef@helixd.com>
Date:   Fri, 23 Jul 2021 11:21:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YPrHJe+zJGJ7oezW@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/23/21 6:41 AM, Andrew Lunn wrote:
> On Thu, Jul 22, 2021 at 03:55:04PM -0700, Dario Alcocer wrote:
>> root@dali:~# ip link
>> 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
>>      link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
>> 2: can0: <NOARP,ECHO> mtu 16 qdisc noop state DOWN mode DEFAULT group default qlen 10
>>      link/can
>> 3: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1508 qdisc mq state UP mode DEFAULT group default qlen 1000
>>      link/ether aa:10:22:58:38:77 brd ff:ff:ff:ff:ff:ff
>> 4: sit0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>>      link/sit 0.0.0.0 brd 0.0.0.0
>> 5: lan1@eth0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state LOWERLAYERDOWN mode DEFAULT group default qlen 1000
>>      link/ether aa:10:22:58:38:77 brd ff:ff:ff:ff:ff:ff
> 
> NO-CARRIER suggests a PHY problem. You should see it report link up if
> it really is up.
> 
> When then switch probes the PHYs should also probe. What PHY driver is
> being used? You want the Marvell PHY driver, not genphy.

Looks like the Marvell PHY driver is being used:

root@dali:~# grep -i phy /var/log/messages
Jan  1 00:00:10 (none) user.info kernel: [    4.126862] libphy: 
mv88e6xxx SMI: probed
Jan  1 00:00:10 (none) user.info kernel: [    5.620909] mv88e6085 
stmmac-0:1a lan1 (uninitialized): PHY [mv88e6xxx-0:00] driver [Marvell 
88E1540]
Jan  1 00:00:10 (none) user.info kernel: [    5.669606] mv88e6085 
stmmac-0:1a lan2 (uninitialized): PHY [mv88e6xxx-0:01] driver [Marvell 
88E1540]
Jan  1 00:00:10 (none) user.info kernel: [    5.719458] mv88e6085 
stmmac-0:1a lan3 (uninitialized): PHY [mv88e6xxx-0:02] driver [Marvell 
88E1540]
Jan  1 00:00:10 (none) user.info kernel: [    7.103178] mv88e6085 
stmmac-0:1e lan4 (uninitialized): PHY [mv88e6xxx-2:00] driver [Marvell 
88E1540]
Jan  1 00:00:10 (none) user.info kernel: [    7.151820] mv88e6085 
stmmac-0:1e dmz (uninitialized): PHY [mv88e6xxx-2:01] driver [Marvell 
88E1540]
Nov  1 12:01:37 (none) user.info kernel: [  107.993670] mv88e6085 
stmmac-0:1a lan1: configuring for phy/gmii link mode


>> 6: lan2@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>>      link/ether aa:10:22:58:38:77 brd ff:ff:ff:ff:ff:ff
>> 7: lan3@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>>      link/ether aa:10:22:58:38:77 brd ff:ff:ff:ff:ff:ff
>> 8: lan4@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>>      link/ether aa:10:22:58:38:77 brd ff:ff:ff:ff:ff:ff
>> 9: dmz@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>>      link/ether aa:10:22:58:38:77 brd ff:ff:ff:ff:ff:ff
>> root@dali:~# ip route
>> default via 192.168.0.1 dev eth0
> 
> That is not correct. eth0 just acts as a pipe towards the switch. It
> does not have an IP address, and there should not be any routes using
> it. It needs to be configured up, but that is all.
> 

I've been fighting with Busybox init to just bring up eth0 with no IPv4 
configuration, without success. I'll go back and review the Busybox docs 
to see how to bring up eth0 without any IPv4 configuration.

>> The DSA switch tree is configured using this device tree fragment:
>>
>> gmac0 {
>>      status = "okay";
>>      phy-mode = "gmii";
> 
> gmii? That is a bit unusual. You normally see rgmii.
> 

I reviewed the schematic again and confirmed that gmii is being used. 
The schematic shows RXD[7:0] and TXD[7:0] connected to port 6. However, 
I just noticed no skew values are specified for RXD[7:4] and TXD[7:4]. I 
  should fix that.

>>      txc-skew-ps = <0xbb8>;
>>      rxc-skew-ps = <0xbb8>;
>>      txen-skew-ps = <0>;
>>      rxdv-skew-ps = <0>;
>>      rxd0-skew-ps = <0>;
>>      rxd1-skew-ps = <0>;
>>      rxd2-skew-ps = <0>;
>>      rxd3-skew-ps = <0>;
>>      txd0-skew-ps = <0>;
>>      txd1-skew-ps = <0>;
>>      txd2-skew-ps = <0>;
>>      txd3-skew-ps = <0>;
>>      max-frame-size = <3800>;
>>
>>      fixed-link {
>>      speed = <0x3e8>;
> 
> decimal would be much more readable. Or is this not the source .dts
> file, but you have decompiled the DTB back to DTS?
> 

The original .dts was auto-generated using Altera tools, which emit 
hexadecimal. I've been converting to decimal as I make changes to the 
.dts. The speed value 0x3e8 is 1000 decimal.

>>          full-duplex;
>>          pause;
>>      };
>>
>>      mdio {
>>          compatible = "snps,dwmac-mdio";
>>          #address-cells = <0x1>;
>>          #size-cells = <0x0>;
>>
>>          switch0: switch0@1a {
>>              compatible = "marvell,mv88e6085";
>>              reg = <0x1a>;
>>              dsa,member = <0 0>;
>>              ports {
>>                  #address-cells = <1>;
>>                  #size-cells = <0>;
>>                  port@0 {
>>                      reg = <0>;
>>                      label = "lan1";
>>                  };
>>                  port@1 {
>>                      reg = <1>;
>>                      label = "lan2";
>>                  };
>>                  port@2 {
>>                      reg = <2>;
>>                      label = "lan3";
>>                  };
>>                  switch0port4: port@4 {
>>                      reg = <4>;
>>                      phy-mode = "rgmii-id";
>>                      link = <&switch1port4>;
>>                      fixed-link {
>>                          speed = <1000>;
>>                          full-duplex;
>>                      };
>>                  };
>>                  port@6 {
>>                      reg = <6>;
>>                      ethernet = <&gmac0>;
>>                      label = "cpu";
>>                  };
>>              };
>>          };
>>          switch1: switch1@1e {
>>              compatible = "marvell,mv88e6085";
>>              reg = <0x1e>;
>>              dsa,member = <0 1>;
>>              ports {
>>                  #address-cells = <1>;
>>                  #size-cells = <0>;
>>                  port@0 {
>>                      reg = <0>;
>>                      label = "lan4";
>>                  };
>>                  port@1 {
>>                      reg = <1>;
>>                      label = "dmz";
>>                  };
>>                  switch1port4: port@4 {
>>                      reg = <4>;
>>                      link = <&switch0port4>;
>>                      phy-mode = "rgmii-id";
> 
> You probably don't want both ends of the link in rgmii-id mode. That
> will give you twice the delay.

Ok, I'll change phy-mode to "rgmii" for both ends. It's a little 
confusing that there's a reference to phy-mode at all, though, given the 
actual connection is SERDES. My understanding is SERDES is a digital, 
PHY-less connection.

I'll update the .dts to include the missing skew settings and the 
phy-mode setting for the dsa ports, then post my results. (I've already 
fixed the .dts to specify the correct switch for the cpu port, an error 
I caught after posting.)

Thanks for the input!
