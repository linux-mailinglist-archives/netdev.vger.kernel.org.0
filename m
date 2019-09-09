Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 413A1AD5D4
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 11:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728492AbfIIJge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 05:36:34 -0400
Received: from mail.online.net ([62.210.16.11]:51302 "EHLO mail.online.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728293AbfIIJge (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 05:36:34 -0400
X-Greylist: delayed 452 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Sep 2019 05:36:32 EDT
Received: from localhost (localhost [127.0.0.1])
        by mail.online.net (Postfix) with ESMTP id 8815511740DC0;
        Mon,  9 Sep 2019 11:28:59 +0200 (CEST)
Received: from mail.online.net ([127.0.0.1])
        by localhost (mail.online.net [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id PH4oKPqHfumU; Mon,  9 Sep 2019 11:28:59 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mail.online.net (Postfix) with ESMTP id 088EF11740DC5;
        Mon,  9 Sep 2019 11:28:59 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.online.net 088EF11740DC5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=online.net;
        s=4EC61654-9574-11E8-870F-3D38CA7095BF; t=1568021339;
        bh=Stjf29fQ6O8lWdno1KLdSmGcU+KfXpZCT6LzQ45LWmU=;
        h=Mime-Version:From:Date:Message-Id:To;
        b=GoaWgVOODvu04g26+BK1l7Yh1EBDNztbzqrXGhjsZNTmpariVFB8MG9PpcDIsHyqE
         mYxwnrYYvFSkSa5YEScYuaFtsaQr15cxeb2P2wEETbTxHyGbyGGm3xk12/fAQi3AW9
         UG7YAgufMrvKUFJZM66HXwidNW1OzRieytRAY7Sl4Omql7FJRez7Ts0TSQ0TKoT898
         xugpL4VOb0lxaMElZJUAeM7YpYT/g8ta6gsvwkmdKnrtr5etuzHb1hbkogdLAhTYTB
         RkL1Krr3+vgIcBrucC9ZZ8VdSW9DaINMbD7mN0oFpdQ7EeWhekt1hxxatsJYwK6Ks2
         oxNjv/T/UOiSQ==
X-Virus-Scanned: amavisd-new at mail.online.net
Received: from mail.online.net ([127.0.0.1])
        by localhost (mail.online.net [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id CMB6Pq72iqUe; Mon,  9 Sep 2019 11:28:58 +0200 (CEST)
Received: from [10.33.104.38] (unknown [195.154.229.35])
        by mail.online.net (Postfix) with ESMTPSA id E655411740DC4;
        Mon,  9 Sep 2019 11:28:58 +0200 (CEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: VRF Issue Since kernel 5
From:   Alexis Bauvin <abauvin@online.net>
In-Reply-To: <CWLP265MB1554308A1373D9ECE68CB854FDB70@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
Date:   Mon, 9 Sep 2019 11:28:58 +0200
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <9E920DE7-9CC9-493C-A1D2-957FE1AED897@online.net>
References: <CWLP265MB1554308A1373D9ECE68CB854FDB70@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
To:     Gowen <gowen@potatocomputing.co.uk>
X-Mailer: Apple Mail (2.3445.9.1)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

There has been some changes regarding VRF isolation in Linux 5 IIRC, =
namely proper
isolation of the default VRF.

Some things you may try:

- looking at the l3mdev_accept sysctls (e.g. =
`net.ipv4.tcp_l3mdev_accept`)
- querying stuff from the management vrf through `ip vrf exec vrf-mgmt =
<stuff>`
  e.g. `ip vrf exec vrf-mgmt curl kernel.org`
       `ip vrf exec vrf-mgmt dig @1.1.1.1 kernel.org`
- reversing your logic: default VRF is your management one, the other =
one is for your
  other boxes

Also, your `unreachable default metric 4278198272` route looks odd to =
me.

What are your routing rules? (`ip rule`)

Alexis

> Le 9 sept. 2019 =C3=A0 09:46, Gowen <gowen@potatocomputing.co.uk> a =
=C3=A9crit :
>=20
> Hi there,
>=20
> Dave A said this was the mailer to send this to:
>=20
>=20
> I=E2=80=99ve been using my management interface in a VRF for several =
months now and it=E2=80=99s worked perfectly =E2=80=93 I=E2=80=99ve been =
able to update/upgrade the packages just fine and iptables works =
excellently with it =E2=80=93 exactly as I needed.
>=20
>=20
> Since Kernel 5 though I am no longer able to update =E2=80=93 but the =
issue is quite a curious one as some traffic appears to be fine (DNS =
lookups use VRF correctly) but others don=E2=80=99t (updating/upgrading =
the packages)
>=20
>=20
> I have on this device 2 interfaces:
> Eth0 for management =E2=80=93 inbound SSH, DNS, updates/upgrades
> Eth1 for managing other boxes (ansible using SSH)
>=20
>=20
> Link and addr info shown below:
>=20
>=20
> Admin@NETM06:~$ ip link show
> 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN =
mode DEFAULT group default qlen 1000
>     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master =
mgmt-vrf state UP mode DEFAULT group default qlen 1000
>     link/ether 00:22:48:07:cc:ad brd ff:ff:ff:ff:ff:ff
> 3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP =
mode DEFAULT group default qlen 1000
>     link/ether 00:22:48:07:c9:6c brd ff:ff:ff:ff:ff:ff
> 4: mgmt-vrf: <NOARP,MASTER,UP,LOWER_UP> mtu 65536 qdisc noqueue state =
UP mode DEFAULT group default qlen 1000
>     link/ether 8a:f6:26:65:02:5a brd ff:ff:ff:ff:ff:ff
>=20
>=20
> Admin@NETM06:~$ ip addr
> 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN =
group default qlen 1000
>     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
>     inet 127.0.0.1/8 scope host lo
>        valid_lft forever preferred_lft forever
>     inet6 ::1/128 scope host
>        valid_lft forever preferred_lft forever
> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master =
mgmt-vrf state UP group default qlen 1000
>     link/ether 00:22:48:07:cc:ad brd ff:ff:ff:ff:ff:ff
>     inet 10.24.12.10/24 brd 10.24.12.255 scope global eth0
>        valid_lft forever preferred_lft forever
>     inet6 fe80::222:48ff:fe07:ccad/64 scope link
>        valid_lft forever preferred_lft forever
> 3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP =
group default qlen 1000
>     link/ether 00:22:48:07:c9:6c brd ff:ff:ff:ff:ff:ff
>     inet 10.24.12.9/24 brd 10.24.12.255 scope global eth1
>        valid_lft forever preferred_lft forever
>     inet6 fe80::222:48ff:fe07:c96c/64 scope link
>        valid_lft forever preferred_lft forever
> 4: mgmt-vrf: <NOARP,MASTER,UP,LOWER_UP> mtu 65536 qdisc noqueue state =
UP group default qlen 1000
>     link/ether 8a:f6:26:65:02:5a brd ff:ff:ff:ff:ff:ff
>=20
>=20
>=20
> the production traffic is all in the 10.0.0.0/8 network (eth1 global =
VRF) except for a few subnets (DNS) which are routed out eth0 (mgmt-vrf)
>=20
>=20
> Admin@NETM06:~$ ip route show
> default via 10.24.12.1 dev eth0
> 10.0.0.0/8 via 10.24.12.1 dev eth1
> 10.24.12.0/24 dev eth1 proto kernel scope link src 10.24.12.9
> 10.24.65.0/24 via 10.24.12.1 dev eth0
> 10.25.65.0/24 via 10.24.12.1 dev eth0
> 10.26.0.0/21 via 10.24.12.1 dev eth0
> 10.26.64.0/21 via 10.24.12.1 dev eth0
>=20
>=20
> Admin@NETM06:~$ ip route show vrf mgmt-vrf
> default via 10.24.12.1 dev eth0
> unreachable default metric 4278198272
> 10.24.12.0/24 dev eth0 proto kernel scope link src 10.24.12.10
> 10.24.65.0/24 via 10.24.12.1 dev eth0
> 10.25.65.0/24 via 10.24.12.1 dev eth0
> 10.26.0.0/21 via 10.24.12.1 dev eth0
> 10.26.64.0/21 via 10.24.12.1 dev eth0
>=20
>=20
>=20
> The strange activity occurs when I enter the command =E2=80=9Csudo apt =
update=E2=80=9D as I can resolve the DNS request (10.24.65.203 or =
10.24.64.203, verified with tcpdump) out eth0 but for the actual update =
traffic there is no activity:
>=20
>=20
> sudo tcpdump -i eth0 '(host 10.24.65.203 or host 10.25.65.203) and =
port 53' -n
> <OUTPUT OMITTED FOR BREVITY>
> 10:06:05.268735 IP 10.24.12.10.39963 > 10.24.65.203.53: 48798+ [1au] =
A? security.ubuntu.com. (48)
> <OUTPUT OMITTED FOR BREVITY>
> 10:06:05.284403 IP 10.24.65.203.53 > 10.24.12.10.39963: 48798 13/0/1 A =
91.189.91.23, A 91.189.88.24, A 91.189.91.26, A 91.189.88.162, A =
91.189.88.149, A 91.189.91.24, A 91.189.88.173, A 91.189.88.177, A =
91.189.88.31, A 91.189.91.14, A 91.189.88.176, A 91.189.88.175, A =
91.189.88.174 (256)
>=20
>=20
>=20
> You can see that the update traffic is returned but is not accepted by =
the stack and a RST is sent
>=20
>=20
> Admin@NETM06:~$ sudo tcpdump -i eth0 '(not host 168.63.129.16 and port =
80)' -n
> tcpdump: verbose output suppressed, use -v or -vv for full protocol =
decode
> listening on eth0, link-type EN10MB (Ethernet), capture size 262144 =
bytes
> 10:17:12.690658 IP 10.24.12.10.40216 > 91.189.88.175.80: Flags [S], =
seq 2279624826, win 64240, options [mss 1460,sackOK,TS val 2029365856 =
ecr 0,nop,wscale 7], length 0
> 10:17:12.691929 IP 10.24.12.10.52362 > 91.189.95.83.80: Flags [S], seq =
1465797256, win 64240, options [mss 1460,sackOK,TS val 3833463674 ecr =
0,nop,wscale 7], length 0
> 10:17:12.696270 IP 91.189.88.175.80 > 10.24.12.10.40216: Flags [S.], =
seq 968450722, ack 2279624827, win 28960, options [mss 1418,sackOK,TS =
val 81957103 ecr 2029365856,nop,wscale 7], length 0                      =
                                                                         =
                            =20
> 10:17:12.696301 IP 10.24.12.10.40216 > 91.189.88.175.80: Flags [R], =
seq 2279624827, win 0, length 0
> 10:17:12.697884 IP 91.189.95.83.80 > 10.24.12.10.52362: Flags [S.], =
seq 4148330738, ack 1465797257, win 28960, options [mss 1418,sackOK,TS =
val 2257624414 ecr 3833463674,nop,wscale 8], length 0                    =
                                                                         =
                           =20
> 10:17:12.697909 IP 10.24.12.10.52362 > 91.189.95.83.80: Flags [R], seq =
1465797257, win 0, length 0
>=20
>=20
>=20
>=20
> I can emulate the DNS lookup using netcat in the vrf:
>=20
>=20
> sudo ip vrf exec mgmt-vrf nc -u 10.24.65.203 53
>=20
>=20
> then interactively enter the binary for a www.google.co.uk request:
>=20
>=20
> =
0035624be394010000010000000000010377777706676f6f676c6502636f02756b00000100=
010000290200000000000000
>=20
>=20
> This returns as expected:
>=20
>=20
> =
00624be394010000010000000000010377777706676f6f676c6502636f02756b0000010001=
0000290200000000000000
>=20
>=20
> I can run:
>=20
>=20
> Admin@NETM06:~$ host www.google.co.uk
> www.google.co.uk has address 172.217.169.3
> www.google.co.uk has IPv6 address 2a00:1450:4009:80d::2003
>=20
>=20
> but I get a timeout for:
>=20
>=20
> sudo ip vrf  exec mgmt-vrf host www.google.co.uk
> ;; connection timed out; no servers could be reached
>=20
>=20
>=20
> However I can take a repo address and vrf exec to it on port 80:
>=20
>=20
> Admin@NETM06:~$ sudo ip vrf  exec mgmt-vrf nc 91.189.91.23 80
> hello
> HTTP/1.1 400 Bad Request
> <OUTPUT OMITTED>
>=20
> My iptables rule:
>=20
>=20
> sudo iptables -Z
> Admin@NETM06:~$ sudo iptables -L -v
> Chain INPUT (policy DROP 16 packets, 3592 bytes)
> pkts bytes target     prot opt in     out     source               =
destination
>    44  2360 ACCEPT     tcp  --  any    any     anywhere             =
anywhere             tcp spt:http ctstate RELATED,ESTABLISHED
>    83 10243 ACCEPT     udp  --  any    any     anywhere             =
anywhere             udp spt:domain ctstate RELATED,ESTABLISHED
>=20
>=20
>=20
> I cannot find out why the update isn=E2=80=99t working. Any help =
greatly appreciated
>=20
>=20
> Kind Regards,
>=20
>=20
> Gareth

