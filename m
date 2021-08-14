Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FEE53EC505
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 22:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbhHNU0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 16:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbhHNU0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 16:26:02 -0400
X-Greylist: delayed 558 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 14 Aug 2021 13:25:33 PDT
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F231FC061764
        for <netdev@vger.kernel.org>; Sat, 14 Aug 2021 13:25:33 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id C1F125872FA46; Sat, 14 Aug 2021 22:16:12 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id BEE8160DA1E1A;
        Sat, 14 Aug 2021 22:16:12 +0200 (CEST)
Date:   Sat, 14 Aug 2021 22:16:12 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Bruce Allan <bruce.w.allan@intel.com>,
        David Ertman <david.m.ertman@intel.com>
cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: e1000e: abysmal performance of 8086:15fb rev 20 Ethernet
Message-ID: <74r22ns-61qo-rqn3-n41-9or5n96qq89@vanv.qr>
User-Agent: Alpine 2.24 (LSU 510 2020-10-10)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings.


I have here the following machine:

  Fujitsu Lifebook U7311 laptop (2021)
  product code VFY:U7311MF5AMDE
  Family 6 Model 140 Intel "11th gen" Core i5-1135G7
  i219-LM rev 20 Ethernet chip

and this TGL Eternet performs absolutely miserably, achieving only
like 1/100th of the supposed RX speed most of the time. TX is fine. A
sister laptop, the 3 year older (but arguably newer in all other
numbers?!),

  Lifebook U728 (2018)
  Family 6 Model *142* Intel "8th gen" Core i5-8250U
  i219-LM rev *21* Ethernet chip

does not exhibit any Ethernet-related RX/TX speed bugs of this kind.
The problems occur on current 5.14-rc kernels and earlier versions.
There is no known-good version of Linux to speak of.


== lspci
00:1f.6 Ethernet controller: Intel Corporation Ethernet Connection (13) 
I219-LM (rev 20)
00:1f.6 0200: 8086:15fb (rev 20)
        Subsystem: 1e26:001a

== freebsd-13-release live cd
#pciconf -l
none9@pci0:0:31:6: class=0x020000 rev=0x20 ...
[doesn't even have a driver to test]


== dmesg
[    0.000000] microcode: microcode updated early to revision 0x88, date = 2021-03-31
[    0.000000] Linux version 5.14.0-rc5-1-default+ (root@localhost.localdomain) (gcc (SUSE Linux) 11.1.1 20210721 [revision 076930b9690ac3564638636f6b13bbb6bc608aea], GNU ld (GNU Binutils; openSUSE Tumbleweed) 2.36.1.20210326-4) #3 SMP Sat Aug 14 19:29:53 CEST 2021
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-5.14.0-rc5-1-default+ root=UUID=dc0a25dc-12b4-4b52-9d4e-05fb5c07d3dd splash=silent mitigations=auto quiet
[    6.559429] e1000e: Intel(R) PRO/1000 Network Driver
[    6.559431] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
[    6.560073] e1000e 0000:00:1f.6: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    6.800991] e1000e 0000:00:1f.6 0000:00:1f.6 (uninitialized): registered PHC clock
[    6.876468] e1000e 0000:00:1f.6 eth0: (PCI Express:2.5GT/s:Width x1) ec:79:49:4a:8d:76
[    6.876472] e1000e 0000:00:1f.6 eth0: Intel(R) PRO/1000 Network Connection
[    6.876649] e1000e 0000:00:1f.6 eth0: MAC: 13, PHY: 12, PBA No: FFFFFF-0FF
[   11.279159] e1000e 0000:00:1f.6 eth0: NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx


== ethtool
Settings for eth0:
        Supported ports: [ TP ]
        Supported link modes:   10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
        Supported pause frame use: No
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
        Advertised pause frame use: No
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Speed: 1000Mb/s
        Duplex: Full
        Auto-negotiation: on
        Port: Twisted Pair
        PHYAD: 1
        Transceiver: internal
        MDI-X: on (auto)
        Supports Wake-on: pumbg
        Wake-on: d
        Current message level: 0x00000007 (7)
                               drv probe link
        Link detected: yes

Tried `ethtool -K eth0 rx off tx off sg off tso off ufo off gso off gro off lro
off rxvlan off txvlan off ntuple off rxhash off` with no change in situation.


== Measurements
On the local Ethernet segment...

u7311# iperf3 -Rc fc00::5
Connecting to host fc00::5, port 5201
Reverse mode, remote host fc00::5 is sending
[  5] local fc00::9 port 39154 connected to fc00::5 port 5201
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec  1.20 MBytes  10.0 Mbits/sec                  
[  5]   1.00-2.00   sec  1.84 MBytes  15.4 Mbits/sec                  
[  5]   2.00-3.00   sec  2.44 MBytes  20.5 Mbits/sec                  
[  5]   3.00-4.00   sec  1.44 MBytes  12.1 Mbits/sec                  
[  5]   4.00-5.00   sec   417 KBytes  3.41 Mbits/sec                  
[  5]   5.00-6.00   sec   358 KBytes  2.94 Mbits/sec                  
[  5]   6.00-7.00   sec  1.46 MBytes  12.2 Mbits/sec                  
[  5]   7.00-8.00   sec  1.51 MBytes  12.7 Mbits/sec                  
[  5]   8.00-9.00   sec   431 KBytes  3.53 Mbits/sec                  
[  5]   9.00-10.00  sec   654 KBytes  5.36 Mbits/sec                  
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  11.9 MBytes  9.98 Mbits/sec  959             sender
[  5]   0.00-10.00  sec  11.7 MBytes  9.83 Mbits/sec                  receiver


u7311# iperf3 -c fc00::5
Connecting to host fc00::5, port 5201
[  5] local fc00::9 port 39158 connected to fc00::5 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec   110 MBytes   924 Mbits/sec    0    370 KBytes       
[  5]   1.00-2.00   sec   110 MBytes   922 Mbits/sec    0    389 KBytes       
[  5]   2.00-3.00   sec   110 MBytes   924 Mbits/sec    0    389 KBytes       
[  5]   3.00-4.00   sec   110 MBytes   922 Mbits/sec    0    389 KBytes       


With internet, it's even worse.


u7311# wget -O /dev/zero inai.de/files/large
Location: https://inai.de/files/large [following]
--2021-08-14 21:02:49--  https://inai.de/files/large
Connecting to inai.de (inai.de)|2a01:4f8:10b:45d8::f5|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 1099511627776 (1.0T)
Saving to: ‘/dev/zero’

/dev/zero 0%[..] 152.00K   198KB/s      


u7311# iperf3 -R -c inai.de
Connecting to host inai.de, port 5201
Reverse mode, remote host inai.de is sending
[  5] local 2a02:8108:96c0:1a00::6981 port 46556 connected to 2a01:4f8:10b:45d8::f5 port 5201
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec   107 KBytes   879 Kbits/sec                  
[  5]   1.00-2.00   sec   107 KBytes   880 Kbits/sec                  
[  5]   2.00-3.00   sec   102 KBytes   834 Kbits/sec                  
[  5]   3.00-4.00   sec  90.6 KBytes   743 Kbits/sec                  
[  5]   4.00-5.00   sec  92.0 KBytes   754 Kbits/sec                  
[  5]   5.00-6.00   sec  89.2 KBytes   731 Kbits/sec 
{iptraf-ng is saying: ~1166 kbps incoming, 73 kbps outgoing}


u7311# iperf3 -c inai.de
Connecting to host inai.de, port 5201
[  5] local 2a02:8108:96c0:1a00::6981 port 46560 connected to 2a01:4f8:10b:45d8::f5 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec  7.72 MBytes  64.8 Mbits/sec    1    492 KBytes       
[  5]   1.00-2.00   sec  5.21 MBytes  43.7 Mbits/sec    7    135 KBytes       
[  5]   2.00-3.00   sec  5.21 MBytes  43.7 Mbits/sec    0    162 KBytes       
...
{iptraf-ng is saying: ~1067 kbps incoming, 53464 kbps outgoing}

The available home internet connection is capped at 920 down/50 up
Mbit, so numbers for TX are good, but RX still sucks. With parallel
downloading, the chip lets about 6-10 Mbit through.

u7311# aria2c --file-allocation=none -x 10 -j 10 https://inai.de/files/large
08/14 21:11:58 [NOTICE] Downloading 1 item(s)
[#8b97d9 11MiB/1,024GiB(0%) CN:5 DL:604KiB ETA:493h10m48s]


Sometimes I get this freak uprise in rates after a while.

 # iperf3 -Rc 192.168.0.73
Connecting to host 192.168.0.73, port 5201
Reverse mode, remote host 192.168.0.73 is sending
[  5] local 192.168.0.153 port 48716 connected to 192.168.0.73 port 5201
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec   350 KBytes  2.87 Mbits/sec                  
[  5]   1.00-2.00   sec   321 KBytes  2.63 Mbits/sec                  
[  5]   2.00-3.00   sec   619 KBytes  5.07 Mbits/sec                  
[  5]   3.00-4.00   sec  59.7 MBytes   501 Mbits/sec                  
[  5]   4.00-5.00   sec   111 MBytes   934 Mbits/sec                  
[  5]   5.00-6.00   sec   111 MBytes   934 Mbits/sec                  
[  5]   6.00-7.00   sec   111 MBytes   934 Mbits/sec                  
[  5]   7.00-8.00   sec   111 MBytes   934 Mbits/sec                  
[  5]   8.00-9.00   sec   111 MBytes   934 Mbits/sec
