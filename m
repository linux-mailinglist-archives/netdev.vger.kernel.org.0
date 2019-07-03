Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDF4F5E4E8
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 15:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfGCNK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 09:10:58 -0400
Received: from mx-relay47-hz2.antispameurope.com ([94.100.136.247]:57750 "EHLO
        mx-relay47-hz2.antispameurope.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725933AbfGCNK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 09:10:58 -0400
Received: from b2b-92-50-72-125.unitymedia.biz ([92.50.72.125]) by mx-relay47-hz2.antispameurope.com;
 Wed, 03 Jul 2019 15:10:41 +0200
Received: from [192.168.101.59] (192.168.101.59) by eks-ex.eks-engel.local
 (192.168.100.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1034.26; Wed, 3 Jul
 2019 15:10:35 +0200
To:     <netdev@vger.kernel.org>
From:   Benjamin Beckmeyer <beb@eks-engel.de>
Subject: i.mx6ul with DSA in multi chip addressing mode - no MDIO access
Message-ID: <21680b63-2d87-6841-23eb-551e58866719@eks-engel.de>
Date:   Wed, 3 Jul 2019 15:10:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [192.168.101.59]
X-ClientProxiedBy: eks-ex.eks-engel.local (192.168.100.30) To
 eks-ex.eks-engel.local (192.168.100.30)
X-cloud-security-sender: beb@eks-engel.de
X-cloud-security-recipient: netdev@vger.kernel.org
X-cloud-security-Virusscan: CLEAN
X-cloud-security-disclaimer: This E-Mail was scanned by E-Mailservice on mx-relay47-hz2.antispameurope.com with B84CA40314
X-cloud-security-connect: b2b-92-50-72-125.unitymedia.biz[92.50.72.125], TLS=1, IP=92.50.72.125
X-cloud-security: scantime:.1954
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey folks,

I'm having a problem with a custom i.mx6ul board. When DSA is loaded I can't 
get access to the switch via MDIO, but the DSA is working properly. I set up
a bridge for testing and the switch is in forwarding mode and i can ping the 
board. But the MDIO access isn't working at address 2 for the switch. When I 
delete the DSA from the devicetree and start the board up, I can access the 
switch via MDIO.

With DSA up and running:

mii -i 2 0 0x9800
mii -i 2 1
phyid:2, reg:0x01 -> 0x4000
mii -i 2 0 0x9803
mii -i 2 1
phyid:2, reg:0x01 -> 0x4000
mii -i 2 1 0x1883
mii -i 2 1
phyid:2, reg:0x01 -> 0x4000

No DSA:

mii -i 2 0 0x9800
mii -i 2 1
phyid:2, reg:0x01 -> 0xde04
mii -i 2 0 0x9803
mii -i 2 1
phyid:2, reg:0x01 -> 0x3901
mii -i 2 1 0x1883
mii -i 2 1
phyid:2, reg:0x01 -> 0x1883

Here is the device tree for our board:
&mdio0 {
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

                        port@1 {
                                reg = <1>;
                                label = "lan1";
                        };
                        port@2 {
                                reg = <2>;
                                label = "lan2";
                        };

                        port@3 {
                                reg = <3>;
                                label = "lan3";
                        };

                        port@4 {
                                reg = <4>;
                                label = "lan4";
                        };

                        port@5 {
                                reg = <5>;
                                label = "lan5";
                        };

                        port@6 {
                                reg = <6>;
                                label = "lan6";
                        };

                        port@7 {
                                reg = <7>;
                                label = "lan7";
                        };
                        port@8 {
                                reg = <8>;
                                label = "lan8";
                        };
                        port@9 {
                                reg = <9>;
                                label = "serdes1";
                                fixed-link {
                                        speed = <1000>;
                                        full-duplex;
                                };
                        };
                        port@10 {
                                reg = <10>;
                                label = "serdes2";
                                fixed-link {
                                        speed = <1000>;
                                        full-duplex;
                                };
                        };
                };
        };
};

On a different custom board we have another switching chip in single chip 
addressing mode the MDIO access works like a charm with activated DSA.

Currently I'm on linux-4.14.118. Other kernels (4.19.55, 5.1.14) I've 
tested stuck at or reboot while DSA is loading. Same devicetree there.
Let me know if you need some more input.

Thanks in advance for your help.

Best regards, 
Benjamin Beckmeyer

