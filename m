Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4543C556
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 09:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404272AbfFKHoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 03:44:06 -0400
Received: from mx-relay74-hz1.antispameurope.com ([94.100.133.237]:37018 "EHLO
        mx-relay74-hz1.antispameurope.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2403897AbfFKHoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 03:44:05 -0400
X-Greylist: delayed 447 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Jun 2019 03:44:05 EDT
Received: from b2b-92-50-72-125.unitymedia.biz ([92.50.72.125]) by mx-relay74-hz1.antispameurope.com;
 Tue, 11 Jun 2019 09:36:30 +0200
Received: from [192.168.101.59] (192.168.101.59) by eks-ex.eks-engel.local
 (192.168.100.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1034.26; Tue, 11 Jun
 2019 09:36:16 +0200
Subject: Re: DSA with MV88E6321 and imx28
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>
References: <20190605133102.GF19627@lunn.ch>
 <20907497-526d-67b2-c100-37047fa1f0d8@eks-engel.de>
 <20190605184724.GB19590@lunn.ch>
 <c27f2b9b-90d7-db63-f01c-2dfaef7a014b@eks-engel.de>
 <20190606122437.GA20899@lunn.ch>
 <86c1e7b1-ef38-7383-5617-94f9e677370b@eks-engel.de>
 <20190606133501.GC19590@lunn.ch>
 <e01b05e4-5190-1da6-970d-801e9fba6d49@eks-engel.de>
 <20190606135903.GE19590@lunn.ch>
 <8903b07b-4ac5-019a-14a1-d2fc6a57c0bb@eks-engel.de>
 <20190607124750.GJ20899@lunn.ch>
From:   Benjamin Beckmeyer <beb@eks-engel.de>
Message-ID: <635c884a-185d-5b3b-7f91-ce058d9726f4@eks-engel.de>
Date:   Tue, 11 Jun 2019 09:36:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190607124750.GJ20899@lunn.ch>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [192.168.101.59]
X-ClientProxiedBy: eks-ex.eks-engel.local (192.168.100.30) To
 eks-ex.eks-engel.local (192.168.100.30)
X-cloud-security-sender: beb@eks-engel.de
X-cloud-security-recipient: netdev@vger.kernel.org
X-cloud-security-Virusscan: CLEAN
X-cloud-security-disclaimer: This E-Mail was scanned by E-Mailservice on mx-relay74-hz1.antispameurope.com with 9A18B70434A
X-cloud-security-connect: b2b-92-50-72-125.unitymedia.biz[92.50.72.125], TLS=1, IP=92.50.72.125
X-cloud-security: scantime:8.249
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> So all ports are now in forwarding mode (Switch port register 0x4 of all ports 
>> are 0x7f), but I don't reach it over ping.
> Hi
>
> The most common error for people new to DSA is forgetting to bring
> the master interface up.
>
> The second thing to understand is that by default, all interfaces are
> separated. So the switch won't bridge frames between ports, until you
> add the ports to a Linux bridge. But you can give each interface its
> own IP address.
>
>     Andrew

Hi Andrew,
thanks for your help again. Sorry for the late reply we had a stats day yesterday. 
What interface do you mean with master interface? I assume, you mean eth0 (cpu port)?
I deleted the IP address of this interface and tried to add it to the bridge:

brctl addif bridge0 eth0
brctl: bridge bridge0: Invalid argument

I tried this with all lan1-4 interfaces and they just work and directly after
I added them I got some information about the port:

brctl addif br0 lan4
[  156.085842] br0: port 4(lan4) entered blocking state
[  156.091022] br0: port 4(lan4) entered disabled state

After I brought up the bridge with:

ip link set br0 up
[  445.313697] br0: port 4(lan4) entered blocking state
[  445.318896] br0: port 4(lan4) entered forwarding state

So I gave my eth0 an IP address and started tcpdump on eth0:

tcpdump -i eth0
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on eth0, link-type EN10MB (Ethernet), capture size 65535 bytes
01:11:36.040006 ARP, Request who-has 192.168.10.1 tell 192.168.10.2, length 46
01:11:37.062283 ARP, Request who-has 192.168.10.1 tell 192.168.10.2, length 46
01:11:38.086465 ARP, Request who-has 192.168.10.1 tell 192.168.10.2, length 46

How you can see, I get the ARP request but no reply from my device. No ping is
working. All interfaces are up:

ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,ALLMULTI,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 6a:d0:d5:9c:fe:f3 brd ff:ff:ff:ff:ff:ff
    inet 192.168.10.201/24 brd 192.168.10.255 scope global eth0
       valid_lft forever preferred_lft forever
3: Serdes0@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop switchid 00000000 state DOWN group default qlen 1000
    link/ether 6a:d0:d5:9c:fe:f3 brd ff:ff:ff:ff:ff:ff
4: Serdes1@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop switchid 00000000 state DOWN group default qlen 1000
    link/ether 6a:d0:d5:9c:fe:f3 brd ff:ff:ff:ff:ff:ff
5: lan1@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br0 switchid 00000000 state UP group default qlen 1000
    link/ether 6a:d0:d5:9c:fe:f3 brd ff:ff:ff:ff:ff:ff
6: lan2@eth0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue master br0 switchid 00000000 state LOWERLAYERDOWN group default qlen 1000
    link/ether 6a:d0:d5:9c:fe:f3 brd ff:ff:ff:ff:ff:ff
7: lan3@eth0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue master br0 switchid 00000000 state LOWERLAYERDOWN group default qlen 1000
    link/ether 6a:d0:d5:9c:fe:f3 brd ff:ff:ff:ff:ff:ff
8: lan4@eth0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue master br0 switchid 00000000 state LOWERLAYERDOWN group default qlen 1000
    link/ether 6a:d0:d5:9c:fe:f3 brd ff:ff:ff:ff:ff:ff
9: br0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 6a:d0:d5:9c:fe:f3 brd ff:ff:ff:ff:ff:ff

Am I doing something wrong or maybe I forget something?

Cheers,
Benjamin

