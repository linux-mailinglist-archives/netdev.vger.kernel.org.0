Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF3A35FA34
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 16:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbfGDOjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 10:39:41 -0400
Received: from mx-relay30-hz1.antispameurope.com ([94.100.133.206]:58697 "EHLO
        mx-relay30-hz1.antispameurope.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727388AbfGDOjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 10:39:41 -0400
Received: from b2b-92-50-72-125.unitymedia.biz ([92.50.72.125]) by mx-relay30-hz1.antispameurope.com;
 Thu, 04 Jul 2019 16:39:34 +0200
Received: from [192.168.101.59] (192.168.101.59) by eks-ex.eks-engel.local
 (192.168.100.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1034.26; Thu, 4 Jul
 2019 16:39:21 +0200
Subject: Re: i.mx6ul with DSA in multi chip addressing mode - no MDIO access
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>
References: <21680b63-2d87-6841-23eb-551e58866719@eks-engel.de>
 <20190703155518.GE18473@lunn.ch>
 <d1181129-ec9d-01c1-3102-e1dc5dec0378@eks-engel.de>
 <20190704132756.GB13859@lunn.ch>
From:   Benjamin Beckmeyer <beb@eks-engel.de>
Message-ID: <00b365da-9c7a-a78a-c10a-f031748e0af7@eks-engel.de>
Date:   Thu, 4 Jul 2019 16:39:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190704132756.GB13859@lunn.ch>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [192.168.101.59]
X-ClientProxiedBy: eks-ex.eks-engel.local (192.168.100.30) To
 eks-ex.eks-engel.local (192.168.100.30)
X-cloud-security-sender: beb@eks-engel.de
X-cloud-security-recipient: netdev@vger.kernel.org
X-cloud-security-Virusscan: CLEAN
X-cloud-security-disclaimer: This E-Mail was scanned by E-Mailservice on mx-relay30-hz1.antispameurope.com with 580013A0B34
X-cloud-security-connect: b2b-92-50-72-125.unitymedia.biz[92.50.72.125], TLS=1, IP=92.50.72.125
X-cloud-security: scantime:1.212
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Thu, Jul 04, 2019 at 10:54:47AM +0200, Benjamin Beckmeyer wrote:
>> On 03.07.19 17:55, Andrew Lunn wrote:
>>> On Wed, Jul 03, 2019 at 03:10:34PM +0200, Benjamin Beckmeyer wrote:
>>>> Hey folks,
>>>>
>>>> I'm having a problem with a custom i.mx6ul board. When DSA is loaded I can't 
>>>> get access to the switch via MDIO, but the DSA is working properly. I set up
>>>> a bridge for testing and the switch is in forwarding mode and i can ping the 
>>>> board. But the MDIO access isn't working at address 2 for the switch. When I 
>>>> delete the DSA from the devicetree and start the board up, I can access the 
>>>> switch via MDIO.
>>>>
>>>> With DSA up and running:
>>>>
>>>> mii -i 2 0 0x9800
>>>> mii -i 2 1
>>>> phyid:2, reg:0x01 -> 0x4000
>>>> mii -i 2 0 0x9803
>>>> mii -i 2 1
>>>> phyid:2, reg:0x01 -> 0x4000
>>>> mii -i 2 1 0x1883
>>>> mii -i 2 1
>>>> phyid:2, reg:0x01 -> 0x4000
>>> Hi Benjamin
>>>
>>> I'm guessing that the driver is also using register 0 and 1 at the
>>> same time you are, e.g. to poll the PHYs for link status etc.
>>>
>>> There are trace points for MDIO, so you can get the kernel to log all
>>> registers access. That should confirm if i'm right.
>>>
>>> 	  Andrew
>> Hi Andrew,
>> you were absolutly right. The bus is really busy the whole time, I've 
>> checked that with the tracepoints in mdio_access.
>>
>> But I'm still wondering why isn't that with a single chip addressing 
>> mode configured switch? I mean, okay, the switch has more ports, but
>> I've checked the accesses for both. The 6321(single chip addressing 
>> mode) has around 4-5 accesses to the MDIO bus and the 6390(multi chip 
>> addressing mode) has around 600 accesses per second. 
> Hi Benjamin
>
> In single chip mode, reading a register is atomic. With multi-chip,
> you need to access two registers, so it clearly is not atomic. And so
> any other action on the bus will cause you problems when doing things
> from user space without being able to take the register mutex.
>
> But 4-5 vs 600 suggests you don't have the interrupt line in your
> device tree. If you have the interrupt line connected to a GPIO, and
> the driver knows about it, it has no need to poll the PHYs. I also
> added support for 'polled interrupts', as a fall back when then
> interrupt is not listed in device tree. 10 times a second the driver
> polls the interrupt status register, and if any interrupts have
> happened within the switch, it triggers the needed handlers. Reading
> one status register every 100ms is much less effort than reading all
> the PHY status registers once per second.
>
> Still, 600 per second sounds too high. Do you have an SNMP agent
> getting statistics?
>
> 	Andrew

Hi Andrew,
thanks for the hint with the interrupt line. I added it now but I'm 
having the same problem. But it is older kernel and tomorrow I will try
a newer kernel in which your patch with the polled setup is applied to.
And I will get an oscilloscop to look if anything is happening on the 
interrupt line. 

Is this device tree snip correct (about interrupts)?

--snip

&fec1 {
        pinctrl-names = "default";
        pinctrl-0 = <&pinctrl_enet1>;
        reset-gpios = <&gpio5 9 GPIO_ACTIVE_LOW>;
        phy-supply = <&reg_3v3>;
        phy-mode = "rmii";
        phy-handle = <&fecphy1>;
        status = "okay";

        mdio0: mdio {
                #address-cells = <1>;
                #size-cells = <0>;

                fecphy1: fecphy1@1 {
                        reg = <0x1>;
                };
        };
};

&mdio0 {
        interrupt-parent = <&gpio1>;
        interrupts = <3 IRQ_TYPE_LEVEL_HIGH>;

        switch0: switch0@2 {
                compatible = "marvell,mv88e6190";
                reg = <2>;
                pinctrl-0 = <&pinctrl_gpios>;
                reset-gpios = <&gpio4 16 GPIO_ACTIVE_LOW>;
                dsa,member = <0 0>;

                ports {
                        #address-cells = <1>;
                        #size-cells = <0>;

                        port@0 {
                                reg = <0>;
                                label = "cpu";
                                ethernet = <&fec1>;
                                phy-mode = "rmii";
                                fixed-link {
                                        speed = <100>;
                                        full-duplex;
                                };
                        };

--snip

There is no SNMP agent running at all.

Cheers, 
Benjamin

