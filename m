Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1C2437533
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 15:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbfFFN1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 09:27:39 -0400
Received: from mx-relay56-hz2.antispameurope.com ([94.100.136.156]:59518 "EHLO
        mx-relay56-hz2.antispameurope.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726014AbfFFN1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 09:27:38 -0400
Received: from b2b-92-50-72-125.unitymedia.biz ([92.50.72.125]) by mx-relay56-hz2.antispameurope.com;
 Thu, 06 Jun 2019 15:27:26 +0200
Received: from [192.168.101.59] (192.168.101.59) by eks-ex.eks-engel.local
 (192.168.100.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1034.26; Thu, 6 Jun
 2019 15:27:22 +0200
Subject: Re: DSA with MV88E6321 and imx28
To:     Andrew Lunn <andrew@lunn.ch>, <netdev@vger.kernel.org>
References: <8812014c-1105-5fb6-bc20-bad0f86d33ea@eks-engel.de>
 <20190604135000.GD16951@lunn.ch>
 <854a0d9c-17a2-c502-458d-4d02a2cd90bb@eks-engel.de>
 <20190605122404.GH16951@lunn.ch>
 <414bd616-9383-073d-b3f3-6b6138c8b163@eks-engel.de>
 <20190605133102.GF19627@lunn.ch>
 <20907497-526d-67b2-c100-37047fa1f0d8@eks-engel.de>
 <20190605184724.GB19590@lunn.ch>
 <c27f2b9b-90d7-db63-f01c-2dfaef7a014b@eks-engel.de>
 <20190606122437.GA20899@lunn.ch>
From:   Benjamin Beckmeyer <beb@eks-engel.de>
Message-ID: <86c1e7b1-ef38-7383-5617-94f9e677370b@eks-engel.de>
Date:   Thu, 6 Jun 2019 15:27:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190606122437.GA20899@lunn.ch>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [192.168.101.59]
X-ClientProxiedBy: eks-ex.eks-engel.local (192.168.100.30) To
 eks-ex.eks-engel.local (192.168.100.30)
X-cloud-security-sender: beb@eks-engel.de
X-cloud-security-recipient: netdev@vger.kernel.org
X-cloud-security-Virusscan: CLEAN
X-cloud-security-disclaimer: This E-Mail was scanned by E-Mailservice on mx-relay56-hz2.antispameurope.com with 282F34E1B0D
X-cloud-security-connect: b2b-92-50-72-125.unitymedia.biz[92.50.72.125], TLS=1, IP=92.50.72.125
X-cloud-security: scantime:1.334
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 06.06.19 14:24, Andrew Lunn wrote:
> On Thu, Jun 06, 2019 at 10:49:08AM +0200, Benjamin Beckmeyer wrote:
>>>> I removed all phy-handle for the internal ports and in the mdio part 
>>>> is only port 2 and 6 by now. But the Serdes ports are still not be
>>>> recognized. So maybe there is still something wrong?
>>> What do you mean by SERDES? Do you mean they are connected to an SFP
>>> cage? If so, you need to add an SFP node. Take a look at
>>> vf610-zii-dev-rev-c.dts for an example.
>>>
>>> 	Andrew
>> Hey Andrew,
>> I've looked into the device tree. Why do they reference to i2c? We have
>> 1x8 SFF tranceivers. Should I just add an i2c entry for it, because the 
>> value is required?
> Hi Benjamin
>
> Do you have a diagram of the board you can share with me. I'm confused
> about which ports have external copper PHYs and which have SFF
> connected to them., and if you are using copper PHYs with SERDES
> interfaces not RGMII.
>
> Each port needs to have some sort of 'PHY' connected to it. Either a
> copper PHY, an SFP/SFF, or a fake PHY using fixed-link.
>
>> Do you know which switch chip they use in the  vf610-zii-dev-rev-c?
> That board uses two 6390X. There is also ZII CF1 is if i remember
> correctly a 6352, and has one SFF.
>
> If you have an SFF connected to a port, you need its i2c bus, so that
> PHYLINK can read the SFF EEPROM to determine its capabilities and
> correctly configure the MAC to fit the SFF. Plus you get all the
> diagnostics, etc.
>
>   Andrew

Hi Andrew,
From our hardware developer I know now that we are using a "mini" SFF 
which has no i2c eeprom. 

Switch				|	external
Port 0 - internal serdes 0x0c --|-------Mini SFF 1x8 Transceiver
				|
Port 0 - internal serdes 0x0d --|-------Mini SFF 1x8 Transceiver
				|
Port 2 ----------RGMII----------|-------KSZ9031 PHY 0x02(strap)--Transceiver
				|
Port 3 - internal PHY 0x03 -----|-------Transceiver
				|
Port 3 - internal PHY 0x04 -----|-------Transceiver
				|			
Port 5 - CPU-Port RMII ---------|-------CPU
				|
Port 6 ----------RGMII----------|-------KSZ9031 PHY 0x06(strap)--Transceiver


Hopefully this makes it more clear to you. 

