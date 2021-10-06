Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78D904241F0
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 17:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239270AbhJFP6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 11:58:33 -0400
Received: from foss.arm.com ([217.140.110.172]:42956 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235957AbhJFP6c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 11:58:32 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DE0086D;
        Wed,  6 Oct 2021 08:56:39 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 666F63F70D;
        Wed,  6 Oct 2021 08:56:37 -0700 (PDT)
Date:   Wed, 6 Oct 2021 16:58:11 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     davem@davemloft.net, michael.riesch@wolfvision.net,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        p.zabel@pengutronix.de, lgirdwood@gmail.com, broonie@kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [BUG RESEND] net: stmmac: dwmac-rk: Ethernet broken on rockpro64 by
 commit 2d26f6e39afb ("net: stmmac: dwmac-rk: fix unbalanced
 pm_runtime_enable warnings")
Message-ID: <YV3Hk2R4uDKbTy43@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Resending this because my previous email client inserted HTML into the email,
which was then rejected by the linux-kernel@vger.kernel.org spam filter.

After commit 2d26f6e39afb ("net: stmmac: dwmac-rk: fix unbalanced
pm_runtime_enable warnings"), the network card on my rockpro64-v2 was left
unable to get a DHCP lease from the network. The offending commit was found by
bisecting the kernel; I tried reverting the commit from v5.15-rc4 and the
network card started working as expected.

I can help with testing a fix or further diagnosing if needed.

his is what I get with a kernel built from v5.15-rc4 (so with the commit *not*
reverted). Full dmesg at [1].

root@rockpro ~ # uname -a
Linux rockpro 5.15.0-rc4 #83 SMP PREEMPT Wed Oct 6 16:06:31 BST 2021 aarch64 GNU/Linux
root@rockpro ~ # ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether ce:71:c1:ee:97:e8 brd ff:ff:ff:ff:ff:ff
root@rockpro ~ # ip l set eth0 up
[   33.398930] rk_gmac-dwmac fe300000.ethernet eth0: PHY [stmmac-0:00] driver [Generic PHY] (irq=POLL)
[   33.404390] rk_gmac-dwmac fe300000.ethernet eth0: Register MEM_TYPE_PAGE_POOL RxQ-0
[   33.405795] rk_gmac-dwmac fe300000.ethernet eth0: No Safety Features support found
[   33.406479] rk_gmac-dwmac fe300000.ethernet eth0: PTP not supported by HW
[   33.407528] rk_gmac-dwmac fe300000.ethernet eth0: configuring for phy/rgmii link mode
root@rockpro ~ # [   37.503570] rk_gmac-dwmac fe300000.ethernet eth0: Link is Up - 1Gbps/Full - flow control rx/tx

root@rockpro ~ # ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether ce:71:c1:ee:97:e8 brd ff:ff:ff:ff:ff:ff
root@rockpro ~ # dhclient --version
isc-dhclient-4.4.2-P1
root@rockpro ~ # dhclient -v eth0
Internet Systems Consortium DHCP Client 4.4.2-P1
Copyright 2004-2021 Internet Systems Consortium.
All rights reserved.
For info, please visit https://www.isc.org/software/dhcp/

Listening on LPF/eth0/ce:71:c1:ee:97:e8
Sending on   LPF/eth0/ce:71:c1:ee:97:e8
Sending on   Socket/fallback
DHCPREQUEST for 192.168.0.43 on eth0 to 255.255.255.255 port 67
DHCPREQUEST for 192.168.0.43 on eth0 to 255.255.255.255 port 67
DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 8
DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 7
DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 20
DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 20
DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 6
No DHCPOFFERS received.
Trying recorded lease 192.168.0.43
ping: socket: Address family not supported by protocol
PING 192.168.0.1 (192.168.0.1) 56(84) bytes of data.

--- 192.168.0.1 ping statistics ---
1 packets transmitted, 0 received, +1 errors, 100% packet loss, time 0ms

No working leases in persistent database - sleeping.

With the commit reverted, the NIC is working again (dmesg at [2]).

root@rockpro ~ # uname -a
Linux rockpro 5.15.0-rc4-00001-g6ac1832b7cc5 #84 SMP PREEMPT Wed Oct 6 16:24:54 BST 2021 aarch64 GNU/Linux
root@rockpro ~ # ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether ce:71:c1:ee:97:e8 brd ff:ff:ff:ff:ff:ff
root@rockpro ~ # ip l set eth0 up
[   76.094639] rk_gmac-dwmac fe300000.ethernet eth0: PHY [stmmac-0:00] driver [Generic PHY] (irq=POLL)
[   76.100233] rk_gmac-dwmac fe300000.ethernet eth0: Register MEM_TYPE_PAGE_POOL RxQ-0
[   76.101646] rk_gmac-dwmac fe300000.ethernet eth0: No Safety Features support found
[   76.102374] rk_gmac-dwmac fe300000.ethernet eth0: PTP not supported by HW
[   76.103335] rk_gmac-dwmac fe300000.ethernet eth0: configuring for phy/rgmii link mode
root@rockpro ~ # [   80.191353] rk_gmac-dwmac fe300000.ethernet eth0: Link is Up - 1Gbps/Full - flow control rx/tx

root@rockpro ~ # ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether ce:71:c1:ee:97:e8 brd ff:ff:ff:ff:ff:ff
root@rockpro ~ # dhclient --version
isc-dhclient-4.4.2-P1
root@rockpro ~ # dhclient -v eth0
Internet Systems Consortium DHCP Client 4.4.2-P1
Copyright 2004-2021 Internet Systems Consortium.
All rights reserved.
For info, please visit https://www.isc.org/software/dhcp/

Listening on LPF/eth0/ce:71:c1:ee:97:e8
Sending on   LPF/eth0/ce:71:c1:ee:97:e8
Sending on   Socket/fallback
DHCPREQUEST for 192.168.0.43 on eth0 to 255.255.255.255 port 67
DHCPACK of 192.168.0.43 from 192.168.0.1
bound to 192.168.0.43 -- renewal in 36072 seconds.
root@rockpro ~ # ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether ce:71:c1:ee:97:e8 brd ff:ff:ff:ff:ff:ff
    inet 192.168.0.43/24 brd 192.168.0.255 scope global eth0
       valid_lft forever preferred_lft forever
root@rockpro ~ # ping google.com
ping: socket: Address family not supported by protocol
PING google.com (172.217.169.46) 56(84) bytes of data.
64 bytes from lhr48s08-in-f14.1e100.net (172.217.169.46): icmp_seq=1 ttl=117 time=21.7 ms
64 bytes from lhr48s08-in-f14.1e100.net (172.217.169.46): icmp_seq=2 ttl=117 time=19.1 ms

--- google.com ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 19.058/20.392/21.726/1.334 ms

Pastebins will expire after 6 months.

[1] https://pastebin.com/JrViZTPe
[2] https://pastebin.com/EwEbWRfY

Thanks,
Alex
