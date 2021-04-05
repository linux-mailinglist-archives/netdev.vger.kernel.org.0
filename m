Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E59735418C
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 13:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234784AbhDELfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 07:35:43 -0400
Received: from mga06.intel.com ([134.134.136.31]:35073 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233431AbhDELfn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 07:35:43 -0400
IronPort-SDR: vMK0n5+Ef8Ueq2qkpEA5hMEk3A80yZuZbE2mYZ/OBOIu8ajR9u59GPFsshJyPwTfTzfVzy9xUs
 yj5v+CSPYs9w==
X-IronPort-AV: E=McAfee;i="6000,8403,9944"; a="254169324"
X-IronPort-AV: E=Sophos;i="5.81,306,1610438400"; 
   d="scan'208";a="254169324"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2021 04:35:36 -0700
IronPort-SDR: TH5332Obysrd576bvhDuX4G61pJrWOIGOPgjXXKzhsGeuYxOzI3cwwEVNUTpUN+a1TOvETpiaM
 Pvpcw7po8nKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,306,1610438400"; 
   d="scan'208";a="378939399"
Received: from mike-ilbpg1.png.intel.com ([10.88.227.76])
  by orsmga003.jf.intel.com with ESMTP; 05 Apr 2021 04:35:28 -0700
From:   Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, linux@armlinux.org.uk,
        weifeng.voon@intel.com, boon.leong.ong@intel.com,
        qiangqing.zhang@nxp.com, vee.khee.wong@intel.com,
        fugang.duan@nxp.com, kim.tatt.chuah@intel.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com
Subject: [PATCH net-next v2 0/2] Enable 2.5Gbps speed for stmmac
Date:   Mon,  5 Apr 2021 19:29:51 +0800
Message-Id: <20210405112953.26008-1-michael.wei.hong.sit@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset enables 2.5Gbps speed mode for stmmac.
Link speed mode is detected and configured at serdes power up sequence.
For 2.5G, we do not use SGMII in-band AN, we check the link speed mode
in the serdes and disable the in-band AN accordingly.

Changes:
v1 -> v2
 patch 1/2
 -Remove MAC supported link speed masking

 patch 2/2
 -Add supported link speed masking in the PCS

iperf3 and ping for 2.5Gbps and regression test on 10M/100M/1000Mbps
is done to prevent regresson issues.

10Mbps
host@EHL$ ethtool -s enp0s30f4 duplex full speed 10
[  310.132264] intel-eth-pci 0000:00:1e.4 enp0s30f4: Link is Down
[  312.438102] intel-eth-pci 0000:00:1e.4 enp0s30f4: Link is Up - 10Mbps/Full - flow control off
[  312.447652] IPv6: ADDRCONF(NETDEV_CHANGE): enp0s30f4: link becomes ready
host@EHL$ iperf3 -c 192.168.1.1
Connecting to host 192.168.1.1, port 5201
[  5] local 192.168.1.2 port 60706 connected to 192.168.1.1 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec  1.26 MBytes  10.6 Mbits/sec    0   29.7 KBytes
[  5]   1.00-2.00   sec  1.09 MBytes  9.17 Mbits/sec    0   29.7 KBytes
[  5]   2.00-3.00   sec  1.09 MBytes  9.17 Mbits/sec    0   29.7 KBytes
[  5]   3.00-4.00   sec  1.15 MBytes  9.68 Mbits/sec    0   29.7 KBytes
[  5]   4.00-5.00   sec  1.09 MBytes  9.17 Mbits/sec    0   29.7 KBytes
[  5]   5.00-6.00   sec  1.09 MBytes  9.17 Mbits/sec    0   29.7 KBytes
[  5]   6.00-7.00   sec  1.15 MBytes  9.68 Mbits/sec    0   29.7 KBytes
[  5]   7.00-8.00   sec  1.09 MBytes  9.17 Mbits/sec    0   29.7 KBytes
[  5]   8.00-9.00   sec  1.09 MBytes  9.17 Mbits/sec    0   29.7 KBytes
[  5]   9.00-10.00  sec  1.15 MBytes  9.68 Mbits/sec    0   29.7 KBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  11.3 MBytes  9.47 Mbits/sec    0             sender
[  5]   0.00-10.01  sec  11.1 MBytes  9.34 Mbits/sec                  receiver

iperf Done.
host@EHL$ ping 192.168.1.1
PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
64 bytes from 192.168.1.1: icmp_seq=1 ttl=64 time=0.557 ms
64 bytes from 192.168.1.1: icmp_seq=2 ttl=64 time=0.528 ms
64 bytes from 192.168.1.1: icmp_seq=3 ttl=64 time=0.535 ms
64 bytes from 192.168.1.1: icmp_seq=4 ttl=64 time=0.525 ms
64 bytes from 192.168.1.1: icmp_seq=5 ttl=64 time=0.527 ms
64 bytes from 192.168.1.1: icmp_seq=6 ttl=64 time=0.555 ms
64 bytes from 192.168.1.1: icmp_seq=7 ttl=64 time=0.539 ms
64 bytes from 192.168.1.1: icmp_seq=8 ttl=64 time=0.588 ms
64 bytes from 192.168.1.1: icmp_seq=9 ttl=64 time=0.570 ms
64 bytes from 192.168.1.1: icmp_seq=10 ttl=64 time=0.540 ms

--- 192.168.1.1 ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9194ms
rtt min/avg/max/mdev = 0.525/0.546/0.588/0.019 ms
host@EHL$

100Mbps
host@EHL$ ethtool -s enp0s30f4 duplex full speed 100
[  204.178572] intel-eth-pci 0000:00:1e.4 enp0s30f4: Link is Down
[  207.990094] intel-eth-pci 0000:00:1e.4 enp0s30f4: Link is Up - 100Mbps/Full - flow control off
[  207.999744] IPv6: ADDRCONF(NETDEV_CHANGE): enp0s30f4: link becomes ready
host@EHL$ iperf3 -c 192.168.1.1
Connecting to host 192.168.1.1, port 5201
[  5] local 192.168.1.2 port 60702 connected to 192.168.1.1 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec  11.6 MBytes  97.0 Mbits/sec    1    102 KBytes
[  5]   1.00-2.00   sec  10.9 MBytes  91.7 Mbits/sec    0    102 KBytes
[  5]   2.00-3.00   sec  10.8 MBytes  90.5 Mbits/sec    0    102 KBytes
[  5]   3.00-4.00   sec  11.0 MBytes  92.6 Mbits/sec    0    102 KBytes
[  5]   4.00-5.00   sec  10.8 MBytes  90.6 Mbits/sec    0    102 KBytes
[  5]   5.00-6.00   sec  11.0 MBytes  92.6 Mbits/sec    0    102 KBytes
[  5]   6.00-7.00   sec  11.0 MBytes  92.6 Mbits/sec    0    102 KBytes
[  5]   7.00-8.00   sec  10.8 MBytes  90.6 Mbits/sec    0    102 KBytes
[  5]   8.00-9.00   sec  11.0 MBytes  92.6 Mbits/sec    0    102 KBytes
[  5]   9.00-10.00  sec  11.0 MBytes  92.6 Mbits/sec    0    102 KBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec   110 MBytes  92.3 Mbits/sec    1             sender
[  5]   0.00-10.00  sec   109 MBytes  91.8 Mbits/sec                  receiver

iperf Done.
host@EHL$ ping 192.168.1.1
PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
64 bytes from 192.168.1.1: icmp_seq=1 ttl=64 time=0.331 ms
64 bytes from 192.168.1.1: icmp_seq=2 ttl=64 time=0.322 ms
64 bytes from 192.168.1.1: icmp_seq=3 ttl=64 time=0.315 ms
64 bytes from 192.168.1.1: icmp_seq=4 ttl=64 time=0.315 ms
64 bytes from 192.168.1.1: icmp_seq=5 ttl=64 time=0.295 ms
64 bytes from 192.168.1.1: icmp_seq=6 ttl=64 time=0.300 ms
64 bytes from 192.168.1.1: icmp_seq=7 ttl=64 time=0.307 ms
64 bytes from 192.168.1.1: icmp_seq=8 ttl=64 time=0.294 ms
64 bytes from 192.168.1.1: icmp_seq=9 ttl=64 time=0.292 ms
64 bytes from 192.168.1.1: icmp_seq=10 ttl=64 time=0.297 ms

--- 192.168.1.1 ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9215ms
rtt min/avg/max/mdev = 0.292/0.306/0.331/0.012 ms

1G speed
host@EHL$ iperf3 -c 192.168.1.1
Connecting to host 192.168.1.1, port 5201
[  5] local 192.168.1.2 port 60698 connected to 192.168.1.1 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec   114 MBytes   954 Mbits/sec    0    533 KBytes
[  5]   1.00-2.00   sec   112 MBytes   942 Mbits/sec    0    591 KBytes
[  5]   2.00-3.00   sec   113 MBytes   945 Mbits/sec    0    621 KBytes
[  5]   3.00-4.00   sec   112 MBytes   941 Mbits/sec    0    621 KBytes
[  5]   4.00-5.00   sec   112 MBytes   942 Mbits/sec    0    764 KBytes
[  5]   5.00-6.00   sec   112 MBytes   944 Mbits/sec    0    764 KBytes
[  5]   6.00-7.00   sec   111 MBytes   933 Mbits/sec    0    803 KBytes
[  5]   7.00-8.00   sec   112 MBytes   944 Mbits/sec    0    803 KBytes
[  5]   8.00-9.00   sec   112 MBytes   944 Mbits/sec    0    843 KBytes
[  5]   9.00-10.00  sec   112 MBytes   944 Mbits/sec    0    843 KBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  1.10 GBytes   943 Mbits/sec    0             sender
[  5]   0.00-10.00  sec  1.09 GBytes   940 Mbits/sec                  receiver

iperf Done.
host@EHL$ ping 192.168.1.1
PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
64 bytes from 192.168.1.1: icmp_seq=1 ttl=64 time=0.299 ms
64 bytes from 192.168.1.1: icmp_seq=2 ttl=64 time=0.277 ms
64 bytes from 192.168.1.1: icmp_seq=3 ttl=64 time=0.277 ms
64 bytes from 192.168.1.1: icmp_seq=4 ttl=64 time=0.286 ms
64 bytes from 192.168.1.1: icmp_seq=5 ttl=64 time=0.330 ms
64 bytes from 192.168.1.1: icmp_seq=6 ttl=64 time=0.276 ms
64 bytes from 192.168.1.1: icmp_seq=7 ttl=64 time=0.296 ms
64 bytes from 192.168.1.1: icmp_seq=8 ttl=64 time=0.272 ms
64 bytes from 192.168.1.1: icmp_seq=9 ttl=64 time=0.276 ms
64 bytes from 192.168.1.1: icmp_seq=10 ttl=64 time=0.274 ms

--- 192.168.1.1 ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9196ms
rtt min/avg/max/mdev = 0.272/0.286/0.330/0.017 ms

2.5G speed
host@EHL$ iperf3 -c 192.168.1.1
Connecting to host 192.168.1.1, port 5201
[  5] local 192.168.1.2 port 55160 connected to 192.168.1.1 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec   175 MBytes  1.47 Gbits/sec   17    683 KBytes
[  5]   1.00-2.00   sec   202 MBytes  1.70 Gbits/sec    0    707 KBytes
[  5]   2.00-3.00   sec   204 MBytes  1.71 Gbits/sec    0    751 KBytes
[  5]   3.00-4.00   sec   204 MBytes  1.71 Gbits/sec    0    773 KBytes
[  5]   4.00-5.00   sec   202 MBytes  1.70 Gbits/sec    0    773 KBytes
[  5]   5.00-6.00   sec   204 MBytes  1.71 Gbits/sec    0    798 KBytes
[  5]   6.00-7.00   sec   204 MBytes  1.71 Gbits/sec    0    807 KBytes
[  5]   7.00-8.00   sec   204 MBytes  1.71 Gbits/sec    0    807 KBytes
[  5]   8.00-9.00   sec   204 MBytes  1.71 Gbits/sec    0    807 KBytes
[  5]   9.00-10.00  sec   202 MBytes  1.70 Gbits/sec    0    807 KBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  1.96 GBytes  1.68 Gbits/sec   17             sender
[  5]   0.00-10.00  sec  1.96 GBytes  1.68 Gbits/sec                  receiver

iperf Done.
host@EHL$ ping 192.168.1.1
PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
64 bytes from 192.168.1.1: icmp_seq=1 ttl=64 time=0.671 ms
64 bytes from 192.168.1.1: icmp_seq=2 ttl=64 time=0.300 ms
64 bytes from 192.168.1.1: icmp_seq=3 ttl=64 time=0.300 ms
64 bytes from 192.168.1.1: icmp_seq=4 ttl=64 time=0.291 ms
64 bytes from 192.168.1.1: icmp_seq=5 ttl=64 time=0.296 ms
64 bytes from 192.168.1.1: icmp_seq=6 ttl=64 time=0.301 ms
64 bytes from 192.168.1.1: icmp_seq=7 ttl=64 time=0.328 ms
64 bytes from 192.168.1.1: icmp_seq=8 ttl=64 time=0.306 ms
64 bytes from 192.168.1.1: icmp_seq=9 ttl=64 time=0.299 ms
64 bytes from 192.168.1.1: icmp_seq=10 ttl=64 time=0.293 ms

--- 192.168.1.1 ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9251ms
rtt min/avg/max/mdev = 0.291/0.338/0.671/0.111 ms

Voon Weifeng (2):
  net: stmmac: enable 2.5Gbps link speed
  net: pcs: configure xpcs 2.5G speed mode

 .../net/ethernet/stmicro/stmmac/dwmac-intel.c | 44 ++++++++++++++++++-
 .../net/ethernet/stmicro/stmmac/dwmac-intel.h | 13 ++++++
 .../net/ethernet/stmicro/stmmac/dwmac4_core.c |  1 +
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 20 ++++++++-
 drivers/net/pcs/pcs-xpcs.c                    | 39 ++++++++++++++++
 include/linux/pcs/pcs-xpcs.h                  |  1 +
 include/linux/stmmac.h                        |  2 +
 7 files changed, 117 insertions(+), 3 deletions(-)

-- 
2.17.1

