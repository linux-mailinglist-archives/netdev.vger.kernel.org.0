Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9059E3CC99
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 15:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389744AbfFKNJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 09:09:42 -0400
Received: from mx-relay92-hz2.antispameurope.com ([94.100.136.192]:39622 "EHLO
        mx-relay92-hz2.antispameurope.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387560AbfFKNJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 09:09:42 -0400
Received: from b2b-92-50-72-125.unitymedia.biz ([92.50.72.125]) by mx-relay92-hz2.antispameurope.com;
 Tue, 11 Jun 2019 15:09:38 +0200
Received: from [192.168.101.59] (192.168.101.59) by eks-ex.eks-engel.local
 (192.168.100.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1034.26; Tue, 11 Jun
 2019 15:09:05 +0200
Subject: Re: DSA with MV88E6321 and imx28
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>
References: <20190605184724.GB19590@lunn.ch>
 <c27f2b9b-90d7-db63-f01c-2dfaef7a014b@eks-engel.de>
 <20190606122437.GA20899@lunn.ch>
 <86c1e7b1-ef38-7383-5617-94f9e677370b@eks-engel.de>
 <20190606133501.GC19590@lunn.ch>
 <e01b05e4-5190-1da6-970d-801e9fba6d49@eks-engel.de>
 <20190606135903.GE19590@lunn.ch>
 <8903b07b-4ac5-019a-14a1-d2fc6a57c0bb@eks-engel.de>
 <20190607124750.GJ20899@lunn.ch>
 <635c884a-185d-5b3b-7f91-ce058d9726f4@eks-engel.de>
 <20190611121938.GA20904@lunn.ch>
From:   Benjamin Beckmeyer <beb@eks-engel.de>
Message-ID: <68671792-a720-6fa5-0a6e-0cd9f57c67eb@eks-engel.de>
Date:   Tue, 11 Jun 2019 15:09:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190611121938.GA20904@lunn.ch>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [192.168.101.59]
X-ClientProxiedBy: eks-ex.eks-engel.local (192.168.100.30) To
 eks-ex.eks-engel.local (192.168.100.30)
X-cloud-security-sender: beb@eks-engel.de
X-cloud-security-recipient: netdev@vger.kernel.org
X-cloud-security-Virusscan: CLEAN
X-cloud-security-disclaimer: This E-Mail was scanned by E-Mailservice on mx-relay92-hz2.antispameurope.com with ED54B960669
X-cloud-security-connect: b2b-92-50-72-125.unitymedia.biz[92.50.72.125], TLS=1, IP=92.50.72.125
X-cloud-security: scantime:27.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Tue, Jun 11, 2019 at 09:36:16AM +0200, Benjamin Beckmeyer wrote:
>>>> So all ports are now in forwarding mode (Switch port register 0x4 of all ports 
>>>> are 0x7f), but I don't reach it over ping.
>>> Hi
>>>
>>> The most common error for people new to DSA is forgetting to bring
>>> the master interface up.
>>>
>>> The second thing to understand is that by default, all interfaces are
>>> separated. So the switch won't bridge frames between ports, until you
>>> add the ports to a Linux bridge. But you can give each interface its
>>> own IP address.
>>>
>>>     Andrew
>> Hi Andrew,
>> thanks for your help again. Sorry for the late reply we had a stats day yesterday. 
>> What interface do you mean with master interface? I assume, you mean eth0 (cpu port)?
> Yes. The master interface is the pipe between the host and the
> switch. It is only used as a pipe. It needs to be up, but there is no
> point having an IP address on it, since it cannot send packets itself.
>
> lan1-4 are slave interfaces. They can have IP addresses.
>
>> I deleted the IP address of this interface and tried to add it to the bridge:
>>
>> brctl addif bridge0 eth0
>> brctl: bridge bridge0: Invalid argument
> Yes, you should not do this. Just have the master interface up, but
> otherwise leave it alone. It also needs to be up before you bring the
> slave interfaces up.
>
>> I tried this with all lan1-4 interfaces and they just work and directly after
>> I added them I got some information about the port:
>>
>> brctl addif br0 lan4
>> [  156.085842] br0: port 4(lan4) entered blocking state
>> [  156.091022] br0: port 4(lan4) entered disabled state
>>
>> After I brought up the bridge with:
>>
>> ip link set br0 up
>> [  445.313697] br0: port 4(lan4) entered blocking state
>> [  445.318896] br0: port 4(lan4) entered forwarding state
>>
>> So I gave my eth0 an IP address and started tcpdump on eth0:
> No. If you have created a bridge, put the IP address on the bridge.
> If you have a slave which is not part of the bridge, you can give it
> an IP address. Just treat the interfaces as Linux interfaces. Run
> dhclient on them, use ethtool, iproute2, an snmp agent, add them to a
> bridge. They are just normal Linux interfaces, which can make use of
> the switch hardware to accelerate some operations, like bridging
> frames.
>
>    Andrew

Hi Andrew,
it set up a bridge now, added all four ethernet ports to it, brought all four
interfaces up and the bridge up and gave the bridge an IP address.
If I try to capture on the bridge interface nothing is coming in. On the eth0
interface at least the ARP request comes in.

I captured a ping from my device to my computer to look if outgoing is working
(captured on both devices). Here is the output from my device where i started the:

00:24:24.752057 ARP, Request who-has 192.168.10.2 tell 192.168.10.1, length 28
	0x0000:  0001 0800 0604 0001 6a2a ad79 def5 c0a8  ........j*.y....
	0x0010:  0a01 0000 0000 0000 c0a8 0a02            ............

and here the output of the receiver:

14:49:06.725940 MEDSA 0.2:0: ARP, Request who-has benjamin-HP tell 192.168.10.1, length 42
	0x0000:  0000 4010 0000 0806 0001 0800 0604 0001  ..@.............
	0x0010:  6a2a ad79 def5 c0a8 0a01 0000 0000 0000  j*.y............
	0x0020:  c0a8 0a02 0000 0000 0000 0000 0000 0000  ................
	0x0030:  0000

I'm really stuck at the moment because I don't know what to do further. I think, 
I did everything what is needed.
And I know when I configure the switch manually via MDIO the connection is working.
When I'm looking for traffic in ifconfig on all ports there is everywhere 0 bytes 
except for eth0.
Do you have any ideas?

	Benjamin

