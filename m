Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFA9389AE
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 14:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbfFGMEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 08:04:25 -0400
Received: from mail.digineo.de ([185.162.250.191]:52436 "EHLO mail.digineo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727452AbfFGMEY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 08:04:24 -0400
Received: from [IPv6:2a06:8780:dead:0:ed29:8ab5:f53:e42d] (unknown [IPv6:2a06:8780:dead:0:ed29:8ab5:f53:e42d])
        by mail.digineo.de (Postfix) with ESMTPSA id 490A87461;
        Fri,  7 Jun 2019 12:04:22 +0000 (UTC)
Subject: Re: gue6 bad checksums in udp header
From:   Arthur Skowronek <ags@digineo.de>
To:     Netdev <netdev@vger.kernel.org>
References: <8260b8a8-fb9f-f9a4-f756-9ef04b67f954@digineo.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Message-ID: <11f89a6a-0eb0-eb60-37e8-9fe6e33516ac@digineo.de>
Date:   Fri, 7 Jun 2019 14:04:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:67.0) Gecko/20100101
 Thunderbird/67.0
MIME-Version: 1.0
In-Reply-To: <8260b8a8-fb9f-f9a4-f756-9ef04b67f954@digineo.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry, I forgot to add the maintainers of this subsystem to the CC list.

On 04.06.19 19:46, Arthur Skowronek wrote:
> Hello all,
> 
> it appears that there is an issue with the content of the checksum field 
> in udp packets which are transmitted through a gue encapsulated ipip 
> tunnel over ipv6.
> 
> I spent the past few days with experimenting around with the gue 
> encapsulation capabilities for ipip tunnels in the linux kernel. The 
> first system is running the version 4.14.121 from openwrt on an ubiquiti 
> edgerouter x and the second system is my workstation PC which is running 
> the linux kernel 4.19.47 and arch linux.
> 
> The gue feature on the edgerouter x seems to be broken though.  All 
> packets originating from this system have a bad UDP checksum.  Packets 
> coming from my workstation are fine though. I assume that the problem 
> lies somewhere in the kernel because all operations involving the ip 
> tunnel are handled in kernel and it doesn't seem like userspace is 
> involved at all. I don't think it's an exact issue with the embedded 
> device itself since other UDP packets which are sent over ipv6 are fine. 
> It seems to be an isolated issue with the gue implementation of the 
> kernel in combination with this device.
> 
> This is the script I use to set up the tunneling:
> 
>      # To be executed on the router
>      export systemA='2a06:redacted::163'
>      export systemB='2a06:redacted::21'
> 
>      ip fou add port 9191 gue -6
>      ip link add name fou type ip6tnl \
>          remote "$systemB" local "$systemA" \
>          encap gue encap-dport 9191 encap-sport 9191 mode any
>      ip link set up dev fou
>      ip addr add 'fe80::1' dev fou
> 
>      # To be executed on the workstation
>      export systemA='2a06:redacted::163'
>      export systemB='2a06:redacted::21'
> 
>      ip fou add port 9191 gue -6
>      ip link add name fou type ip6tnl \
>          remote "$systemA" local "$systemB" \
>          encap gue encap-dport 9191 encap-sport 9191 mode any
>      ip link set up dev fou
>      ip addr add 'fe80::2' dev fou
> 
> This works and the interfaces are allocated properly. When I try to ping 
> the workstation from the ERX device now it seems that the packets sent 
> by the router have the wrong UDP checksum though. This is taken from 
> wireshark:
> 
>      Internet Protocol Version 6, Src: 2a06:redacted::163, Dst: 
> 2a06:redacted::21
>          0110 .... = Version: 6
>          .... 0000 0000 .... .... .... .... .... = Traffic Class: 0x00 
> (DSCP: CS0, ECN: Not-ECT)
>          .... .... .... 1101 0000 1111 0000 0001 = Flow Label: 0xd0f01
>          Payload Length: 124
>          Next Header: Destination Options for IPv6 (60)
>          Hop Limit: 64
>          Source: 2a06:redacted::163
>          Destination: 2a06:redacted::21
>          Destination Options for IPv6
>          Next Header: UDP (17)
>          Length: 0
>          [Length: 8 bytes]
>          Tunnel Encapsulation Limit
>          PadN
>      User Datagram Protocol, Src Port: 9191, Dst Port: 9191
>          Source Port: 9191
>          Destination Port: 9191
>          Length: 116
>          Checksum: 0x2272 incorrect, should be 0xec0d (maybe caused by 
> "UDP checksum offload"?)
>          [Checksum Status: Bad]
>          [Stream index: 69]
>          [Timestamps]
>      Data (108 bytes)
>          Data: 00290000600d0f0100403a40fe8000000000000000000000…
>          [Length: 108]
> 
> Unfortunatelly I'm not particularly well versed in the internals of the 
> Linux networking code so it's a little bit difficult for me to debug the 
> problem in greater detail.  From what I can tell it seems like the the 
> checksum is only computed over the pseudo IP header, missing out the UDP 
> Header and the GUE header.  As far as I understand the documents 
> describing UDP in ip6 it seems that the checksum needs to be generated 
> over the entire payload for UDP in ip6 though.
> 
> I don't know how to solve this problem in a way that works nicely with 
> the checksum offloading capabilities in the kernel though.  I have no 
> experience in developing directly in the Linux kernel and this subsystem 
> looks really intimidating to me.  Any help in solving this problem would 
> be greatly appreciated.  Thank you very much.
> 
> 
> Greetings,
> Arthur Skowronek

-- 
Arthur Skowronek
Software Engineer

Digineo GmbH
Fahrenheitstraße 15
28359 Bremen

Telefon: +49 421 167 66 090
Telefax: +49 421 167 66 099

E-Mail: ags@digineo.de
Internet: https://www.digineo.de

Geschäftsführer: Dipl.-Inf. Julian Kornberger
Amtsgericht Bremen HBR 25061
USt-ID: DE 815023724

