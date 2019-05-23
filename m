Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F256E275D4
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 08:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbfEWGAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 02:00:04 -0400
Received: from mx-relay08-hz2.antispameurope.com ([83.246.65.94]:34324 "EHLO
        mx-relay08-hz2.antispameurope.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725848AbfEWGAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 02:00:04 -0400
X-Greylist: delayed 443 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 May 2019 02:00:04 EDT
Received: from b2b-92-50-72-125.unitymedia.biz ([92.50.72.125]) by mx-relay08-hz2.antispameurope.com;
 Thu, 23 May 2019 07:52:40 +0200
Received: from [192.168.101.59] (192.168.101.59) by eks-ex.eks-engel.local
 (192.168.100.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1034.26; Thu, 23 May
 2019 07:52:38 +0200
Subject: Re: DSA setup IMX6ULL and Marvell 88E6390 with 2 Ethernet Phys - CPU
 Port is not working
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>
References: <944bfcc1-b118-3b4a-9bd7-53e1ca85be0a@eks-engel.de>
 <20190523050909.B87FB134148@control02-haj2.antispameurope.com>
From:   Benjamin Beckmeyer <beb@eks-engel.de>
Message-ID: <25a1f661-277b-e4b3-ffee-9092af6abf5d@eks-engel.de>
Date:   Thu, 23 May 2019 07:52:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190523050909.B87FB134148@control02-haj2.antispameurope.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [192.168.101.59]
X-ClientProxiedBy: eks-ex.eks-engel.local (192.168.100.30) To
 eks-ex.eks-engel.local (192.168.100.30)
X-cloud-security-sender: beb@eks-engel.de
X-cloud-security-recipient: netdev@vger.kernel.org
X-cloud-security-Virusscan: CLEAN
X-cloud-security-disclaimer: This E-Mail was scanned by E-Mailservice on mx-relay08-hz2.antispameurope.com with 6FEB4BA0044
X-cloud-security-connect: b2b-92-50-72-125.unitymedia.biz[92.50.72.125], TLS=1, IP=92.50.72.125
X-cloud-security: scantime:.1852
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 22.05.19 18:32, Andrew Lunn wrote:
> On Wed, May 22, 2019 at 10:33:29AM +0200, Benjamin Beckmeyer wrote:
>> Hi all,
>>
>> I'm currently working on a custom board with the imx6ull processor and the 6390 
>> switching chip. This is our hardware setup. 
>>
>> ------------     ---------         ---------    MAC     ------------
>> |   i.MX   | MAC |  PHY  |   PHY   |  PHY  |------------|  88E6390 |
>> |   6ULL   |-----|KSZ8081|---------|LAN8742|	MDIO	|P0        |
>> |          |     |ID 0x1 |         | ID0x0 |------------|          |
>> |          |     ---------         ---------            |          |
>> |          |	     |                                  |MULTI CHIP|
>> |          |	     |MDIO                              |ADDR MODE |
>> |          |	     |                                  |          |
>> |          |--------------------------------------------|   PHY ID |
>> |          |                    MDIO                    |     0x2  |
>> ------------						------------
> Hi Benjamin
>
> KSZ8081 is a 10/100 PHY, i think.
> LAN8742 is also a 10/100 PHY.
>
> However, DSA will configure the CPU port MAC to its maximum speed. So
> port 0 will be doing 1G. I don't know if specifying phy-mode = "rmii"
> is enough. You should take a look at the port status and configuration
> registers, see if the MAC is being forced to 1G, or 100M.
>
> You could add a fixed-phy to port 0 with speed 100. That will at least
> get the MAC part configured correctly.
>
> Is the LAN8742 strapped so that on power on it will auto-neg? I've
> seen a few board with this back-to-back PHY setup, and they just rely
> on the PHYs doing the right thing on power up, no software involved.
>
>    Andrew

Good morning Andrew,
thanks for your reply. You're right, both PHYs are 10/100.

I already added a fixed-link like this:

			port@0 {
				reg = <0>;
				label = "cpu";
				ethernet = <&fec1>;
				phy-mode = "rmii";
				phy-handle = <&switch0phy0>;
                                fixed-link {
                                        speed = <100>;
                                        full-duplex;
                                };
			};

I hope you mean that with fixed-phy? But this doesn't changed anything.

I would like to look at the port registers, but how can I read it when DSA 
is started? When I delete the whole DSA part from the devicetree I found the 
switch in multi chip addressing mode and can read the registers per indirect
reads from PHY ID 0x2. But when DSA is initialized our MII tool(which tool 
could I use for that? ethtool?) gives back some odd values. Of course, I 
would like to read it when DSA is running.

We will check the strapping again, because we have a strange behavior. On 
some boots the external MDIO found a PHY at PHY ID 0x0 and on some it found
nothing. 

Thanks,
Benjamin

