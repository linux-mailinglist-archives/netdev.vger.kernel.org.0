Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7B1F348BC5
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 09:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbhCYInm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 04:43:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:7496 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229581AbhCYIn0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 04:43:26 -0400
IronPort-SDR: k1s6ZKSjpGS9P8PZ38Z8BhLRk0keOCkHgpYtRgTXLqD9iaCFFIQ+uYTNf5uiNDiXvdGrrP7FP8
 X1Dbni3gdbcA==
X-IronPort-AV: E=McAfee;i="6000,8403,9933"; a="211011884"
X-IronPort-AV: E=Sophos;i="5.81,277,1610438400"; 
   d="scan'208";a="211011884"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 01:43:22 -0700
IronPort-SDR: fJZzd5nGYoKPqFh+DrHt1gqjj+Tmxc21r1WP59YUtGkRT5CXBzDBXw882eQVdMej+UBKJm5Np+
 d1DlS/yffTIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,277,1610438400"; 
   d="scan'208";a="452976285"
Received: from mike-ilbpg1.png.intel.com ([10.88.227.76])
  by orsmga001.jf.intel.com with ESMTP; 25 Mar 2021 01:43:17 -0700
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
Subject: [PATCH net-next v3 0/2] Enable 2.5Gbps speed for stmmac and xPCS
Date:   Thu, 25 Mar 2021 16:38:04 +0800
Message-Id: <20210325083806.19382-1-michael.wei.hong.sit@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset enables 2.5Gbps speed mode for stmmac and xPCS.
For 2.5G, we do not use SGMII in-band AN, we check the link speed mode
in the serdes and disable the in-band AN accordingly.

iperf3 and ping for 2.5Gbps and regression test on 10M/100M/1000Mbps
is done to prevent regresson issues.

10Mbps
host@EHL$ ethtool -s enp0s30f4 speed 10 duplex full autoneg on
[   76.022186] intel-eth-pci 0000:00:1e.4 enp0s30f4: Link is Down
[   79.420699] intel-eth-pci 0000:00:1e.4 enp0s30f4: Link is Up - 10Mbps/Full - flow control off
[   79.430270] IPv6: ADDRCONF(NETDEV_CHANGE): enp0s30f4: link becomes ready
host@EHL$ iperf3 -c 192.168.1.1 Connecting to host 192.168.1.1, port 5201 [  5] local 192.168.1.2 port 33462 connected to 192.168.1.1 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec  1.26 MBytes  10.6 Mbits/sec    0   29.7 KBytes
[  5]   1.00-2.00   sec  1.09 MBytes  9.18 Mbits/sec    0   29.7 KBytes
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
[  5]   0.00-10.01  sec  11.1 MBytes  9.33 Mbits/sec                  receiver

iperf Done.
host@EHL$ ping 192.168.1.1
PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
64 bytes from 192.168.1.1: icmp_seq=1 ttl=64 time=0.634 ms
64 bytes from 192.168.1.1: icmp_seq=2 ttl=64 time=0.599 ms
64 bytes from 192.168.1.1: icmp_seq=3 ttl=64 time=0.594 ms
64 bytes from 192.168.1.1: icmp_seq=4 ttl=64 time=0.650 ms
64 bytes from 192.168.1.1: icmp_seq=5 ttl=64 time=0.591 ms
64 bytes from 192.168.1.1: icmp_seq=6 ttl=64 time=0.586 ms
64 bytes from 192.168.1.1: icmp_seq=7 ttl=64 time=0.582 ms
64 bytes from 192.168.1.1: icmp_seq=8 ttl=64 time=0.610 ms
64 bytes from 192.168.1.1: icmp_seq=9 ttl=64 time=0.585 ms
64 bytes from 192.168.1.1: icmp_seq=10 ttl=64 time=0.577 ms
64 bytes from 192.168.1.1: icmp_seq=11 ttl=64 time=0.612 ms
--- 192.168.1.1 ping statistics ---
11 packets transmitted, 11 received, 0% packet loss, time 10224ms rtt min/avg/max/mdev = 0.577/0.601/0.650/0.021 ms

100Mbps
host@EHL$ ethtool -s enp0s30f4 speed 100 duplex full autoneg on
[  269.425955] intel-eth-pci 0000:00:1e.4 enp0s30f4: Link is Down
[  271.932821] intel-eth-pci 0000:00:1e.4 enp0s30f4: Link is Up - 100Mbps/Full - flow control off [  271.942493] IPv6: ADDRCONF(NETDEV_CHANGE): enp0s30f4: link becomes ready
host@EHL$ iperf3 -c 192.168.1.1 Connecting to host 192.168.1.1, port 5201 [  5] local 192.168.1.2 port 33466 connected to 192.168.1.1 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec  11.6 MBytes  97.5 Mbits/sec    0    100 KBytes
[  5]   1.00-2.00   sec  11.0 MBytes  92.6 Mbits/sec    0    100 KBytes
[  5]   2.00-3.00   sec  11.0 MBytes  92.6 Mbits/sec    0    100 KBytes
[  5]   3.00-4.00   sec  11.3 MBytes  94.5 Mbits/sec    0    100 KBytes
[  5]   4.00-5.00   sec  11.0 MBytes  92.6 Mbits/sec    0    100 KBytes
[  5]   5.00-6.00   sec  11.0 MBytes  92.6 Mbits/sec    0    100 KBytes
[  5]   6.00-7.00   sec  11.0 MBytes  92.6 Mbits/sec    0    100 KBytes
[  5]   7.00-8.00   sec  11.3 MBytes  94.5 Mbits/sec    0    100 KBytes
[  5]   8.00-9.00   sec  11.0 MBytes  92.6 Mbits/sec    0    100 KBytes
[  5]   9.00-10.00  sec  11.0 MBytes  92.6 Mbits/sec    0    100 KBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec   111 MBytes  93.4 Mbits/sec    0             sender
[  5]   0.00-10.01  sec   111 MBytes  93.0 Mbits/sec                  receiver

iperf Done.
host@EHL$ ping 192.168.1.1
PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
64 bytes from 192.168.1.1: icmp_seq=1 ttl=64 time=0.393 ms
64 bytes from 192.168.1.1: icmp_seq=2 ttl=64 time=0.354 ms
64 bytes from 192.168.1.1: icmp_seq=3 ttl=64 time=0.414 ms
64 bytes from 192.168.1.1: icmp_seq=4 ttl=64 time=0.377 ms
64 bytes from 192.168.1.1: icmp_seq=5 ttl=64 time=0.426 ms
64 bytes from 192.168.1.1: icmp_seq=6 ttl=64 time=0.379 ms
64 bytes from 192.168.1.1: icmp_seq=7 ttl=64 time=0.348 ms
64 bytes from 192.168.1.1: icmp_seq=8 ttl=64 time=0.354 ms
64 bytes from 192.168.1.1: icmp_seq=9 ttl=64 time=0.351 ms
64 bytes from 192.168.1.1: icmp_seq=10 ttl=64 time=0.351 ms
64 bytes from 192.168.1.1: icmp_seq=11 ttl=64 time=0.429 ms
--- 192.168.1.1 ping statistics ---
11 packets transmitted, 11 received, 0% packet loss, time 10254ms rtt min/avg/max/mdev = 0.348/0.379/0.429/0.030 ms

1G speed
host@EHL$ ping 192.168.1.1
PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
64 bytes from 192.168.1.1: icmp_seq=1 ttl=64 time=1.15 ms
64 bytes from 192.168.1.1: icmp_seq=2 ttl=64 time=0.601 ms
--- 192.168.1.1 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms rtt min/avg/max/mdev = 0.601/0.874/1.147/0.273 ms host@EHL$ ^C host@EHL$ ping 192.168.1.1^C host@EHL$ ^C host@EHL$ iperf3 -c 192.168.1.1 Connecting to host 192.168.1.1, port 5201 [  5] local 192.168.1.2 port 47884 connected to 192.168.1.1 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec   114 MBytes   957 Mbits/sec    2    571 KBytes
[  5]   1.00-2.00   sec   111 MBytes   933 Mbits/sec    1    525 KBytes
[  5]   2.00-3.00   sec   111 MBytes   933 Mbits/sec    0    624 KBytes
[  5]   3.00-4.00   sec   111 MBytes   933 Mbits/sec    0    718 KBytes
[  5]   4.00-5.00   sec   111 MBytes   933 Mbits/sec    0    799 KBytes
[  5]   5.00-6.00   sec   111 MBytes   933 Mbits/sec    2    450 KBytes
[  5]   6.00-7.00   sec   111 MBytes   933 Mbits/sec    0    570 KBytes
[  5]   7.00-8.00   sec   111 MBytes   933 Mbits/sec    0    673 KBytes
[  5]   8.00-9.00   sec   111 MBytes   933 Mbits/sec    2    551 KBytes
[  5]   9.00-10.00  sec   112 MBytes   944 Mbits/sec    1    471 KBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  1.09 GBytes   937 Mbits/sec    8             sender
[  5]   0.00-10.00  sec  1.09 GBytes   933 Mbits/sec                  receiver

iperf Done.

2.5G speed
host@EHL$ iperf3 -c 192.168.1.1
Connecting to host 192.168.1.1, port 5201
[  5] local 192.168.1.2 port 58650 connected to 192.168.1.1 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec   192 MBytes  1.61 Gbits/sec    0    710 KBytes
[  5]   1.00-2.00   sec   190 MBytes  1.59 Gbits/sec    0    710 KBytes
[  5]   2.00-3.00   sec   190 MBytes  1.59 Gbits/sec    0    710 KBytes
[  5]   3.00-4.00   sec   189 MBytes  1.58 Gbits/sec    0    795 KBytes
[  5]   4.00-5.00   sec   190 MBytes  1.59 Gbits/sec    0    795 KBytes
[  5]   5.00-6.00   sec   189 MBytes  1.58 Gbits/sec    0    795 KBytes
[  5]   6.00-7.00   sec   190 MBytes  1.59 Gbits/sec    0    840 KBytes
[  5]   7.00-8.00   sec   190 MBytes  1.59 Gbits/sec    0    840 KBytes
[  5]   8.00-9.00   sec   189 MBytes  1.58 Gbits/sec    0    840 KBytes
[  5]   9.00-10.00  sec   190 MBytes  1.59 Gbits/sec    0    840 KBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  1.85 GBytes  1.59 Gbits/sec    0             sender
[  5]   0.00-10.01  sec  1.85 GBytes  1.59 Gbits/sec                  receiver

iperf Done.
host@EHL$ ping 192.168.1.1
PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
64 bytes from 192.168.1.1: icmp_seq=1 ttl=64 time=0.458 ms
64 bytes from 192.168.1.1: icmp_seq=2 ttl=64 time=0.395 ms
64 bytes from 192.168.1.1: icmp_seq=3 ttl=64 time=0.374 ms
64 bytes from 192.168.1.1: icmp_seq=4 ttl=64 time=0.343 ms
64 bytes from 192.168.1.1: icmp_seq=5 ttl=64 time=0.346 ms
64 bytes from 192.168.1.1: icmp_seq=6 ttl=64 time=0.347 ms
64 bytes from 192.168.1.1: icmp_seq=7 ttl=64 time=0.347 ms
64 bytes from 192.168.1.1: icmp_seq=8 ttl=64 time=0.363 ms
64 bytes from 192.168.1.1: icmp_seq=9 ttl=64 time=0.347 ms
64 bytes from 192.168.1.1: icmp_seq=10 ttl=64 time=0.340 ms

--- 192.168.1.1 ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9218ms
rtt min/avg/max/mdev = 0.340/0.366/0.458/0.034 ms

Voon Weifeng (2):
  net: stmmac: enable 2.5Gbps link speed
  net: pcs: configure xpcs 2.5G speed mode

 .../net/ethernet/stmicro/stmmac/dwmac-intel.c | 44 ++++++++++++++++++-
 .../net/ethernet/stmicro/stmmac/dwmac-intel.h | 13 ++++++
 .../net/ethernet/stmicro/stmmac/dwmac4_core.c |  1 +
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 35 ++++++++++++++-
 drivers/net/pcs/pcs-xpcs.c                    | 23 ++++++++++
 drivers/net/phy/phylink.c                     |  2 +
 include/linux/pcs/pcs-xpcs.h                  |  1 +
 include/linux/stmmac.h                        |  2 +
 8 files changed, 118 insertions(+), 3 deletions(-)

-- 
2.17.1

