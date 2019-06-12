Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA64C4203A
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 11:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437184AbfFLJF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 05:05:29 -0400
Received: from mx-relay73-hz1.antispameurope.com ([94.100.132.237]:35209 "EHLO
        mx-relay73-hz1.antispameurope.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390115AbfFLJF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 05:05:28 -0400
Received: from b2b-92-50-72-125.unitymedia.biz ([92.50.72.125]) by mx-relay73-hz1.antispameurope.com;
 Wed, 12 Jun 2019 11:05:26 +0200
Received: from [192.168.101.59] (192.168.101.59) by eks-ex.eks-engel.local
 (192.168.100.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1034.26; Wed, 12 Jun
 2019 11:05:22 +0200
Subject: Re: DSA with MV88E6321 and imx28
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>
References: <20190606122437.GA20899@lunn.ch>
 <86c1e7b1-ef38-7383-5617-94f9e677370b@eks-engel.de>
 <20190606133501.GC19590@lunn.ch>
 <e01b05e4-5190-1da6-970d-801e9fba6d49@eks-engel.de>
 <20190606135903.GE19590@lunn.ch>
 <8903b07b-4ac5-019a-14a1-d2fc6a57c0bb@eks-engel.de>
 <20190607124750.GJ20899@lunn.ch>
 <635c884a-185d-5b3b-7f91-ce058d9726f4@eks-engel.de>
 <20190611121938.GA20904@lunn.ch>
 <68671792-a720-6fa5-0a6e-0cd9f57c67eb@eks-engel.de>
 <20190611132746.GA22832@lunn.ch>
From:   Benjamin Beckmeyer <beb@eks-engel.de>
Message-ID: <93127324-0b09-7ea7-d54a-42d247570e73@eks-engel.de>
Date:   Wed, 12 Jun 2019 11:05:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190611132746.GA22832@lunn.ch>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [192.168.101.59]
X-ClientProxiedBy: eks-ex.eks-engel.local (192.168.100.30) To
 eks-ex.eks-engel.local (192.168.100.30)
X-cloud-security-sender: beb@eks-engel.de
X-cloud-security-recipient: netdev@vger.kernel.org
X-cloud-security-Virusscan: CLEAN
X-cloud-security-disclaimer: This E-Mail was scanned by E-Mailservice on mx-relay73-hz1.antispameurope.com with 3812F709265
X-cloud-security-connect: b2b-92-50-72-125.unitymedia.biz[92.50.72.125], TLS=1, IP=92.50.72.125
X-cloud-security: scantime:1.260
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>> I captured a ping from my device to my computer to look if outgoing is working
>> (captured on both devices). Here is the output from my device where i started the:
>>
>> 00:24:24.752057 ARP, Request who-has 192.168.10.2 tell 192.168.10.1, length 28
>> 	0x0000:  0001 0800 0604 0001 6a2a ad79 def5 c0a8  ........j*.y....
>> 	0x0010:  0a01 0000 0000 0000 c0a8 0a02            ............
>>
>> and here the output of the receiver:
>>
>> 14:49:06.725940 MEDSA 0.2:0: ARP, Request who-has benjamin-HP tell 192.168.10.1, length 42
>> 	0x0000:  0000 4010 0000 0806 0001 0800 0604 0001  ..@.............
>> 	0x0010:  6a2a ad79 def5 c0a8 0a01 0000 0000 0000  j*.y............
>> 	0x0020:  c0a8 0a02 0000 0000 0000 0000 0000 0000  ................
>> 	0x0030:  0000
>>
>> I'm really stuck at the moment because I don't know what to do further. I think, 
>> I did everything what is needed.
>> And I know when I configure the switch manually via MDIO the connection is working.
>> When I'm looking for traffic in ifconfig on all ports there is everywhere 0 bytes 
>> except for eth0.
>> Do you have any ideas?
> I would start simple and build up. Don't use a bridge. Just put the IP
> address 192.168.10.1 on the slave interface for port 2.
>
> So something like:
>
> ip link set eth0 up
> ip addr add 192.168.10.1/24 dev lan2
> ip link set lan2 up
>
> then you can try ping 192.168.10.2.
>
> Then trace the packet along the path. Does the ARP request make it to
> 192.168.10.2? Is a reply sent? ethtool -S lan2 will show you the
> packet counts. Do the counters show the ARP going out and the reply
> coming back?
>
>        Andrew

Hi Andrew,

it is finally running in DSA mode. Thanks so much, Andrew. I can set an
IP address to all ports individually and running it now in a bridge with 
all 4 copper ports. Set an IP address to the bridge and get a ping reply 
from  all ports. So far, that is all what I have to test, for now. 

I warned you before, I will go back to another custom board. But now with 
more experience thanks to you.

Cheers,
Benjamin

