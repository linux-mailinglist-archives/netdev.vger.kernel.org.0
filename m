Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3A9B60614
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 14:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbfGEMls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 08:41:48 -0400
Received: from mx-relay57-hz2.antispameurope.com ([94.100.136.157]:56219 "EHLO
        mx-relay57-hz2.antispameurope.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727275AbfGEMls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 08:41:48 -0400
Received: from b2b-92-50-72-125.unitymedia.biz ([92.50.72.125]) by mx-relay57-hz2.antispameurope.com;
 Fri, 05 Jul 2019 14:41:45 +0200
Received: from [192.168.101.59] (192.168.101.59) by eks-ex.eks-engel.local
 (192.168.100.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1034.26; Fri, 5 Jul
 2019 14:41:44 +0200
Subject: Re: i.mx6ul with DSA in multi chip addressing mode - no MDIO access
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>
References: <21680b63-2d87-6841-23eb-551e58866719@eks-engel.de>
 <20190703155518.GE18473@lunn.ch>
 <d1181129-ec9d-01c1-3102-e1dc5dec0378@eks-engel.de>
 <20190704132756.GB13859@lunn.ch>
 <00b365da-9c7a-a78a-c10a-f031748e0af7@eks-engel.de>
 <20190704155347.GJ18473@lunn.ch>
From:   Benjamin Beckmeyer <beb@eks-engel.de>
Message-ID: <ba64f1f9-14c7-2835-f6e7-0dd07039fb18@eks-engel.de>
Date:   Fri, 5 Jul 2019 14:41:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190704155347.GJ18473@lunn.ch>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [192.168.101.59]
X-ClientProxiedBy: eks-ex.eks-engel.local (192.168.100.30) To
 eks-ex.eks-engel.local (192.168.100.30)
X-cloud-security-sender: beb@eks-engel.de
X-cloud-security-recipient: netdev@vger.kernel.org
X-cloud-security-Virusscan: CLEAN
X-cloud-security-disclaimer: This E-Mail was scanned by E-Mailservice on mx-relay57-hz2.antispameurope.com with D870F10C7B90
X-cloud-security-connect: b2b-92-50-72-125.unitymedia.biz[92.50.72.125], TLS=1, IP=92.50.72.125
X-cloud-security: scantime:.1891
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> &mdio0 {
>>         interrupt-parent = <&gpio1>;
>>         interrupts = <3 IRQ_TYPE_LEVEL_HIGH>;
>>
>>         switch0: switch0@2 {
>>                 compatible = "marvell,mv88e6190";
>>                 reg = <2>;
>>                 pinctrl-0 = <&pinctrl_gpios>;
>>                 reset-gpios = <&gpio4 16 GPIO_ACTIVE_LOW>;
>>                 dsa,member = <0 0>;
> This is wrong. The interrupt is a switch property, not an MDIO bus
> property. So it belongs inside the switch node.
>
> 	  Andrew

Hi Andrew,

in the documentation for Marvell DSA the interrupt properties are in 
the MDIO part. Maybe the documentation for device tree is wrong or 
unclear?

I switched to the kernel 5.1.16 to take advantage of your new code.
At the moment I deleted all interrupt properties from my device tree 
and if I get you right now the access should be trigger all 100ms but 
I have accesses within the tracing about 175 times a second.

Here is a snip from my trace without IRQ
2188000.etherne-223   [000] ....   109.932406: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0x40a8
 2188000.etherne-223   [000] ....   109.932501: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1b64
 2188000.etherne-223   [000] ....   109.933113: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9b60
 2188000.etherne-223   [000] ....   109.933261: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1b60
 2188000.etherne-223   [000] ....   109.933359: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0xc801
 2188000.etherne-223   [000] ....   110.041683: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1b60
 2188000.etherne-223   [000] ....   110.041817: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9b60
 2188000.etherne-223   [000] ....   110.041919: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1b60
 2188000.etherne-223   [000] ....   110.042025: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0xc801

Am I doing it right with the tracing points? I run just

echo 1 > /sys/kernel/debug/tracing/events/mdio/mdio_access/enable
cat /sys/kernel/debug/tracing/trace

Here is the another device tree I tried, but with this I get accesses 
on the bus in about every 50 microseconds!

--snip
&mdio0 {
        switch0: switch0@2 {
                compatible = "marvell,mv88e6190";
                reg = <2>;
                pinctrl-0 = <&pinctrl_switch_irq>;
                interrupt-parent = <&gpio1>;
                interrupts = <3 IRQ_TYPE_LEVEL_LOW>;
                interrupt-controller;
                #interrupt-cells = <2>;
                dsa,member = <0 0>;

                ports {
                        #address-cells = <1>;
                        #size-cells = <0>;
--snip

Here is a snip from my trace with IRQ.
irq/54-2188000.-223   [000] ....   958.940744: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1b64
 irq/54-2188000.-223   [000] ....   958.940800: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9b60
 irq/54-2188000.-223   [000] ....   958.940857: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1b60
 irq/54-2188000.-223   [000] ....   958.940914: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0xc801
 irq/54-2188000.-223   [000] ....   958.940984: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1b60
 irq/54-2188000.-223   [000] ....   958.941043: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9b60
 irq/54-2188000.-223   [000] ....   958.941100: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1b60
 irq/54-2188000.-223   [000] ....   958.941158: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x01 val:0xc801
 irq/54-2188000.-223   [000] ....   958.941218: mdio_access: 2188000.ethernet-1 read  phy:0x02 reg:0x00 val:0x1b60
 irq/54-2188000.-223   [000] ....   958.941276: mdio_access: 2188000.ethernet-1 write phy:0x02 reg:0x00 val:0x9b64

Thanks,
Benny

