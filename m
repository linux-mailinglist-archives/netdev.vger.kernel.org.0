Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 677BF39B769
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 13:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbhFDLDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 07:03:45 -0400
Received: from mga18.intel.com ([134.134.136.126]:48730 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229667AbhFDLDp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 07:03:45 -0400
IronPort-SDR: s0f+iqyYQlWQLogcIDcAU5eGjFD1x6phVMwssU+BOgbJqjkoOVRR51jys66H2YheIos9OLrQmw
 xvPTn/VwWSyg==
X-IronPort-AV: E=McAfee;i="6200,9189,10004"; a="191607352"
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="191607352"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 04:01:57 -0700
IronPort-SDR: tfrMjjOSer8xvW/7qLa61UoulYdVJa8BtDnc+N7QlPrBQ8vp91Y2Tnts32JGnz/PF6wa32mtRa
 d8EXe6AasFSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="448220339"
Received: from mike-ilbpg1.png.intel.com ([10.88.227.76])
  by fmsmga008.fm.intel.com with ESMTP; 04 Jun 2021 04:01:52 -0700
From:   Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
To:     Jose.Abreu@synopsys.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, kuba@kernel.org, netdev@vger.kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        davem@davemloft.net, mcoquelin.stm32@gmail.com,
        weifeng.voon@intel.com, boon.leong.ong@intel.com,
        tee.min.tan@intel.com, vee.khee.wong@linux.intel.com,
        vee.khee.wong@intel.com, michael.wei.hong.sit@intel.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        vladimir.oltean@nxp.com
Subject: [RESEND PATCH net-next v5 0/3] Enable 2.5Gbps speed for stmmac
Date:   Fri,  4 Jun 2021 18:57:30 +0800
Message-Id: <20210604105733.31092-1-michael.wei.hong.sit@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Intel mGbE supports 2.5Gbps link speed by overclocking the clock rate
by 2.5 times to support 2.5Gbps link speed. In this mode, the serdes/PHY
operates at a serial baud rate of 3.125 Gbps and the PCS data path and
GMII interface of the MAC operate at 312.5 MHz instead of 125 MHz.
This is configured in the BIOS during boot up. The kernel driver is not able
access to modify the clock rate for 1Gbps/2.5G mode on the fly. The way to
determine the current 1G/2.5G mode is by reading a dedicated adhoc
register through mdio bus.

Changes:
v4 -> v5
 patch 1/3
 - Rebase to latest code changes after Vladimir's code is merged and fix
   build warnings

v3 -> v4
 patch 1/3
 - Rebase to latest code and Initialize 'found' to 0 to avoid build warning

 patch 2/3
 - Fix indentation issue from v3

v2 -> v3
 patch 1/3
 -New patch added to restructure the code. enabling reading the dedicated
  adhoc register to determine link speed mode.

 patch 2/3
 -Restructure for 2.5G speed to use 2500BaseX configuration as the
  PHY interface.

 patch 3/3
 -Restructure to read serdes registers to set max_speed and configure to
  use 2500BaseX in 2.5G speeds.

v1 -> v2
 patch 1/2
 -Remove MAC supported link speed masking

 patch 2/2
 -Add supported link speed masking in the PCS

iperf3 and ping for 2.5Gbps and regression test on 10M/100M/1000Mbps
is done to prevent regresson issues.

2500Mbps
PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
64 bytes from 192.168.1.1: icmp_seq=1 ttl=64 time=0.526 ms
64 bytes from 192.168.1.1: icmp_seq=2 ttl=64 time=0.509 ms
64 bytes from 192.168.1.1: icmp_seq=3 ttl=64 time=0.507 ms
64 bytes from 192.168.1.1: icmp_seq=4 ttl=64 time=0.508 ms
64 bytes from 192.168.1.1: icmp_seq=5 ttl=64 time=0.539 ms
64 bytes from 192.168.1.1: icmp_seq=6 ttl=64 time=0.516 ms
64 bytes from 192.168.1.1: icmp_seq=7 ttl=64 time=0.548 ms
64 bytes from 192.168.1.1: icmp_seq=8 ttl=64 time=0.513 ms
64 bytes from 192.168.1.1: icmp_seq=9 ttl=64 time=0.509 ms
64 bytes from 192.168.1.1: icmp_seq=10 ttl=64 time=0.508 ms

--- 192.168.1.1 ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9222ms
rtt min/avg/max/mdev = 0.507/0.518/0.548/0.013 ms

Connecting to host 192.168.1.1, port 5201
[  5] local 192.168.1.2 port 40092 connected to 192.168.1.1 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec   205 MBytes  1.72 Gbits/sec    0    604 KBytes       
[  5]   1.00-2.00   sec   205 MBytes  1.72 Gbits/sec    0    632 KBytes       
[  5]   2.00-3.00   sec   205 MBytes  1.72 Gbits/sec    0    632 KBytes       
[  5]   3.00-4.00   sec   206 MBytes  1.73 Gbits/sec    0    632 KBytes       
[  5]   4.00-5.00   sec   205 MBytes  1.72 Gbits/sec    0    632 KBytes       
[  5]   5.00-6.00   sec   206 MBytes  1.73 Gbits/sec    0    632 KBytes       
[  5]   6.00-7.00   sec   204 MBytes  1.71 Gbits/sec    0    632 KBytes       
[  5]   7.00-8.00   sec   206 MBytes  1.73 Gbits/sec    0    632 KBytes       
[  5]   8.00-9.00   sec   205 MBytes  1.72 Gbits/sec    0    632 KBytes       
[  5]   9.00-10.00  sec   206 MBytes  1.73 Gbits/sec    0    632 KBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  2.00 GBytes  1.72 Gbits/sec    0             sender
[  5]   0.00-10.00  sec  2.00 GBytes  1.72 Gbits/sec                  receiver

iperf Done.

10Mbps
host@EHL$ ethtool -s enp0s30f4 duplex full speed 10
PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
64 bytes from 192.168.1.1: icmp_seq=1 ttl=64 time=1.46 ms
64 bytes from 192.168.1.1: icmp_seq=2 ttl=64 time=0.761 ms
64 bytes from 192.168.1.1: icmp_seq=3 ttl=64 time=0.744 ms
64 bytes from 192.168.1.1: icmp_seq=4 ttl=64 time=0.753 ms
64 bytes from 192.168.1.1: icmp_seq=5 ttl=64 time=0.746 ms
64 bytes from 192.168.1.1: icmp_seq=6 ttl=64 time=0.786 ms
64 bytes from 192.168.1.1: icmp_seq=7 ttl=64 time=0.740 ms
64 bytes from 192.168.1.1: icmp_seq=8 ttl=64 time=0.757 ms
64 bytes from 192.168.1.1: icmp_seq=9 ttl=64 time=0.742 ms
64 bytes from 192.168.1.1: icmp_seq=10 ttl=64 time=0.772 ms

--- 192.168.1.1 ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9208ms
rtt min/avg/max/mdev = 0.740/0.826/1.461/0.212 ms

Connecting to host 192.168.1.1, port 5201
[  5] local 192.168.1.2 port 35304 connected to 192.168.1.1 port 5201
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
[  5]   0.00-10.01  sec  11.1 MBytes  9.33 Mbits/sec                  receiver

iperf Done.

100Mbps
host@EHL$ ethtool -s enp0s30f4 duplex full speed 100
PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
64 bytes from 192.168.1.1: icmp_seq=1 ttl=64 time=1.05 ms
64 bytes from 192.168.1.1: icmp_seq=2 ttl=64 time=0.535 ms
64 bytes from 192.168.1.1: icmp_seq=3 ttl=64 time=0.522 ms
64 bytes from 192.168.1.1: icmp_seq=4 ttl=64 time=0.529 ms
64 bytes from 192.168.1.1: icmp_seq=5 ttl=64 time=0.523 ms
64 bytes from 192.168.1.1: icmp_seq=6 ttl=64 time=0.543 ms
64 bytes from 192.168.1.1: icmp_seq=7 ttl=64 time=0.553 ms
64 bytes from 192.168.1.1: icmp_seq=8 ttl=64 time=0.542 ms
64 bytes from 192.168.1.1: icmp_seq=9 ttl=64 time=0.517 ms
64 bytes from 192.168.1.1: icmp_seq=10 ttl=64 time=0.515 ms

--- 192.168.1.1 ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9233ms
rtt min/avg/max/mdev = 0.515/0.582/1.048/0.155 ms

Connecting to host 192.168.1.1, port 5201
[  5] local 192.168.1.2 port 35308 connected to 192.168.1.1 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec  11.8 MBytes  99.1 Mbits/sec    0    147 KBytes       
[  5]   1.00-2.00   sec  10.9 MBytes  91.2 Mbits/sec    0    187 KBytes       
[  5]   2.00-3.00   sec  11.4 MBytes  95.4 Mbits/sec    0    230 KBytes       
[  5]   3.00-4.00   sec  10.9 MBytes  91.7 Mbits/sec    0    230 KBytes       
[  5]   4.00-5.00   sec  10.4 MBytes  87.6 Mbits/sec    0    230 KBytes       
[  5]   5.00-6.00   sec  10.9 MBytes  91.7 Mbits/sec    0    230 KBytes       
[  5]   6.00-7.00   sec  10.9 MBytes  91.7 Mbits/sec    0    230 KBytes       
[  5]   7.00-8.00   sec  10.9 MBytes  91.7 Mbits/sec    0    230 KBytes       
[  5]   8.00-9.00   sec  10.9 MBytes  91.7 Mbits/sec    0    230 KBytes       
[  5]   9.00-10.00  sec  10.9 MBytes  91.7 Mbits/sec    0    230 KBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec   110 MBytes  92.4 Mbits/sec    0             sender
[  5]   0.00-10.01  sec   109 MBytes  91.5 Mbits/sec                  receiver

iperf Done.

1000Mbps
host@EHL$ ethtool -s enp0s30f4 duplex full speed 1000
PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
64 bytes from 192.168.1.1: icmp_seq=1 ttl=64 time=1.02 ms
64 bytes from 192.168.1.1: icmp_seq=2 ttl=64 time=0.507 ms
64 bytes from 192.168.1.1: icmp_seq=3 ttl=64 time=0.539 ms
64 bytes from 192.168.1.1: icmp_seq=4 ttl=64 time=0.506 ms
64 bytes from 192.168.1.1: icmp_seq=5 ttl=64 time=0.504 ms
64 bytes from 192.168.1.1: icmp_seq=6 ttl=64 time=0.489 ms
64 bytes from 192.168.1.1: icmp_seq=7 ttl=64 time=0.499 ms
64 bytes from 192.168.1.1: icmp_seq=8 ttl=64 time=0.483 ms
64 bytes from 192.168.1.1: icmp_seq=9 ttl=64 time=0.480 ms
64 bytes from 192.168.1.1: icmp_seq=10 ttl=64 time=0.493 ms

--- 192.168.1.1 ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9213ms
rtt min/avg/max/mdev = 0.480/0.551/1.015/0.155 ms

Connecting to host 192.168.1.1, port 5201
[  5] local 192.168.1.2 port 35312 connected to 192.168.1.1 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec   114 MBytes   960 Mbits/sec    0    437 KBytes       
[  5]   1.00-2.00   sec   112 MBytes   940 Mbits/sec    0    437 KBytes       
[  5]   2.00-3.00   sec   112 MBytes   937 Mbits/sec    0    437 KBytes       
[  5]   3.00-4.00   sec   112 MBytes   941 Mbits/sec    0    437 KBytes       
[  5]   4.00-5.00   sec   112 MBytes   939 Mbits/sec    0    457 KBytes       
[  5]   5.00-6.00   sec   112 MBytes   941 Mbits/sec    0    457 KBytes       
[  5]   6.00-7.00   sec   112 MBytes   944 Mbits/sec    0    457 KBytes       
[  5]   7.00-8.00   sec   112 MBytes   937 Mbits/sec    0    457 KBytes       
[  5]   8.00-9.00   sec   113 MBytes   946 Mbits/sec    0    457 KBytes       
[  5]   9.00-10.00  sec   112 MBytes   937 Mbits/sec    0    457 KBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  1.10 GBytes   942 Mbits/sec    0             sender
[  5]   0.00-10.00  sec  1.10 GBytes   941 Mbits/sec                  receiver

iperf Done.

Voon Weifeng (3):
  net: stmmac: split xPCS setup from mdio register
  net: pcs: add 2500BASEX support for Intel mGbE controller
  net: stmmac: enable Intel mGbE 2.5Gbps link speed

 .../net/ethernet/stmicro/stmmac/dwmac-intel.c | 48 +++++++++++++-
 .../net/ethernet/stmicro/stmmac/dwmac-intel.h | 13 ++++
 .../net/ethernet/stmicro/stmmac/dwmac4_core.c |  1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  1 +
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 14 ++++
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c | 64 ++++++++++---------
 drivers/net/pcs/pcs-xpcs.c                    | 56 ++++++++++++++++
 include/linux/pcs/pcs-xpcs.h                  |  1 +
 include/linux/stmmac.h                        |  1 +
 9 files changed, 169 insertions(+), 30 deletions(-)

-- 
2.17.1

