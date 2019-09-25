Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A22CBD8B8
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 09:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442457AbfIYHGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 03:06:52 -0400
Received: from uho.ysoft.cz ([81.19.3.130]:58992 "EHLO uho.ysoft.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2442434AbfIYHGw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Sep 2019 03:06:52 -0400
Received: from [10.1.8.111] (unknown [10.1.8.111])
        by uho.ysoft.cz (Postfix) with ESMTP id 5E08EA31B2;
        Wed, 25 Sep 2019 09:06:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ysoft.com;
        s=20160406-ysoft-com; t=1569395209;
        bh=zCCMfLOJ58qBCGOvwvgBsne9lEgXGyjACQoImEiYO0k=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=PNG5yAki0p/JfgkNyJ5fCRPjAmqO8HbvFl9fcdsVz14TTyIV6+V+mj5NRsvkNlP0Z
         P7/6qxkl3MPyxt/RKJy1F3QgS3ve3UenZIL26tfMCOrl4E5EBEuZHKgYb5pSeateFu
         INy/4OZ0Mox23s6QDW2Y20FOsTR12n1HSAUUP7a0=
Subject: Re: [BUG] Unable to handle kernel NULL pointer dereference in
 phy_support_asym_pause
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
References: <573ffa6a-f29a-84d9-5895-b3d6cc389619@ysoft.com>
 <20190924123126.GE14477@lunn.ch>
 <e7bffa36-f218-d71e-c416-38aff73d35dd@ysoft.com>
 <20190925004437.GA1253@lunn.ch>
From:   =?UTF-8?B?TWljaGFsIFZva8OhxI0=?= <michal.vokac@ysoft.com>
Message-ID: <8255596c-7866-10a2-f656-fa3472c69ea1@ysoft.com>
Date:   Wed, 25 Sep 2019 09:06:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190925004437.GA1253@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25. 09. 19 2:44, Andrew Lunn wrote:
> On Tue, Sep 24, 2019 at 03:10:44PM +0200, Michal Vokáč wrote:
>> On 24. 09. 19 14:31, Andrew Lunn wrote:
>> I added the printk and the above fix and can confirm that it is the CPU
>> port and the phy is NULL pointer:
>>
>> [    6.976366] qca8k 2188000.ethernet-1:0a: Using legacy PHYLIB callbacks. Please migrate to PHYLINK!
>> [    6.992021] qca8k 2188000.ethernet-1:0a: port: 0, phy: 0
>> [    7.001323] qca8k 2188000.ethernet-1:0a eth2 (uninitialized): PHY [2188000.ethernet-1:01] driver [Generic PHY]
>> [    7.014221] qca8k 2188000.ethernet-1:0a eth2 (uninitialized): phy: setting supported 00,00000000,000062ef advertising 00,00000000,000062ef
>> [    7.030598] qca8k 2188000.ethernet-1:0a eth1 (uninitialized): PHY [2188000.ethernet-1:02] driver [Generic PHY]
>> [    7.043500] qca8k 2188000.ethernet-1:0a eth1 (uninitialized): phy: setting supported 00,00000000,000062ef advertising 00,00000000,000062ef
>> [    7.063335] DSA: tree 0 setup
>>
>> Now the device boots but there is a problem with the CPU port configuration:
> 
> Hi Michal
> 
> Thanks for testing. I will post a different fix very soon.

Thank you, I tested the patch it and it does the business.

>> root@hydraco:~# ifconfig eth0 up
>> [  255.256047] Generic PHY fixed-0:00: attached PHY driver [Generic PHY] (mii_bus:phy_addr=fixed-0:00, irq=POLL)
>> [  255.272449] fec 2188000.ethernet eth0: Link is Up - 1Gbps/Full - flow control off
>> [  255.286539] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
>> root@hydraco:~# ifconfig eth1 up
>> [  268.350078] qca8k 2188000.ethernet-1:0a: port: 3, phy: -393143296
>> [  268.364442] qca8k 2188000.ethernet-1:0a eth1: configuring for phy/ link mode
>> [  268.375400] qca8k 2188000.ethernet-1:0a eth1: phylink_mac_config: mode=phy//Unknown/Unknown adv=00,00000000,000062ef pause=10 link=0 an=1
>> [  268.393901] qca8k 2188000.ethernet-1:0a eth1: phy link up /1Gbps/Full
>> [  268.404849] qca8k 2188000.ethernet-1:0a eth1: phylink_mac_config: mode=phy//1Gbps/Full adv=00,00000000,00000000 pause=0e link=1 an=0
>> [  268.420740] qca8k 2188000.ethernet-1:0a eth1: Link is Up - 1Gbps/Full - flow control rx/tx
>> [  268.432995] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
>> root@hydraco:~# udhcpc -i eth1
>> udhcpc (v1.23.2) started
>> Sending discover...
>> Sending discover...
>> Sending discover...
> 
> This i think is something different. What looks odd is
> imx6dl-yapp4-common.dtsi
> 
> &fec {
>          pinctrl-names = "default";
>          pinctrl-0 = <&pinctrl_enet>;
>          phy-mode = "rgmii-id";
>          phy-reset-gpios = <&gpio1 25 GPIO_ACTIVE_LOW>;
>          phy-reset-duration = <20>;
>          phy-supply = <&sw2_reg>;
>          phy-handle = <&ethphy0>;
>          status = "okay";
> 
> 
> 	mdio {
> 
>                 switch@10 {
>                          compatible = "qca,qca8334";
>                          reg = <10>;
> 
>                          switch_ports: ports {
>                                  #address-cells = <1>;
>                                  #size-cells = <0>;
> 
>                                  ethphy0: port@0 {
>                                          reg = <0>;
>                                          label = "cpu";
>                                          phy-mode = "rgmii-id";
>                                          ethernet = <&fec>;
> 
> Both the FEC and the CPU port are set to use rgmii-id". So we are
> getting double delays.
> 
> Try changing one of these to plain rgmii.

Actually, when this file was introduced in [1] I had rgmii-id for the FEC
and rgmii for the CPU port.

Later on the RGMII mode was "fixed" in [2] and that broke the CPU port
for the first time. The problem was fixed by introducing RGMII_ID mode [3]
and using this mode for the CPU port [4].

So now I tried setting rgmii for the FEC but it does not help.
Any other ideas?

Michal

[1] 87489ec3a77f ("ARM: dts: imx: Add Y Soft IOTA Draco, Hydra and Ursa boards")
[2] 5ecdd77c61c8 ("net: dsa: qca8k: disable delay for RGMII mode")
[3] a968b5e9d587 ("net: dsa: qca8k: Enable delay for RGMII_ID mode")
[4] 1a7ee0efb26d ("ARM: dts: imx6dl-yapp4: Use rgmii-id phy mode on the cpu port")

