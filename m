Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 386063828BC
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 11:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236089AbhEQJtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 05:49:51 -0400
Received: from mga05.intel.com ([192.55.52.43]:33296 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236032AbhEQJtu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 05:49:50 -0400
IronPort-SDR: HXHRLbWzGJuVEVzlt4HsG6QirUBiQI9uF7kvbnqqEZPh4hiG4N7asbXJ3vd+0jdwo3TVd0vxKM
 6bloxCvw8/vg==
X-IronPort-AV: E=McAfee;i="6200,9189,9986"; a="285958469"
X-IronPort-AV: E=Sophos;i="5.82,307,1613462400"; 
   d="scan'208";a="285958469"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2021 02:48:33 -0700
IronPort-SDR: BtMZeH5xv+CEdiQruJx2fAA9YSh2lB5octWCZn2VKPrz0BtrG/Rzd0FlZF1u9p6gPLMT7qdW//
 DWvsCgc6r2Xw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,307,1613462400"; 
   d="scan'208";a="540355990"
Received: from mike-ilbpg1.png.intel.com ([10.88.227.76])
  by fmsmga001.fm.intel.com with ESMTP; 17 May 2021 02:48:29 -0700
From:   Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
To:     Jose.Abreu@synopsys.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, kuba@kernel.org, netdev@vger.kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        davem@davemloft.net, mcoquelin.stm32@gmail.com,
        weifeng.voon@intel.com, boon.leong.ong@intel.com,
        tee.min.tan@intel.com, vee.khee.wong@linux.intel.com,
        vee.khee.wong@intel.com, michael.wei.hong.sit@intel.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/2] Introducing support for DWC xpcs Energy Efficient Ethernet
Date:   Mon, 17 May 2021 17:43:30 +0800
Message-Id: <20210517094332.24976-1-michael.wei.hong.sit@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The goal of this patch set is to enable EEE in the xpcs so that when
EEE is enabled, the MAC-->xpcs-->PHY have all the EEE related
configurations enabled.

Patch 1 adds the functions to enable EEE in the xpcs and sets it to
transparent mode.
Patch 2 adds the callbacks to configure the xpcs EEE mode.

The results are tested by checking the lpi counters of the tx and rx
path of the interface. When EEE is enabled, the lpi counters should
increament as it enters and exits lpi states.

host@EHL$ ethtool --show-eee enp0s30f4
EEE Settings for enp0s30f4:
        EEE status: disabled
        Tx LPI: disabled
        Supported EEE link modes:  100baseT/Full
                                   1000baseT/Full
        Advertised EEE link modes:  Not reported
        Link partner advertised EEE link modes:  100baseT/Full
                                                 1000baseT/Full
host@EHL$ ethtool -S enp0s30f4 | grep lpi
     irq_tx_path_in_lpi_mode_n: 0
     irq_tx_path_exit_lpi_mode_n: 0
     irq_rx_path_in_lpi_mode_n: 0
     irq_rx_path_exit_lpi_mode_n: 0
host@EHL$ ethtool --set-eee enp0s30f4 eee on
host@EHL$ [  110.265154] intel-eth-pci 0000:00:1e.4 enp0s30f4: Link is Down
[  112.315155] intel-eth-pci 0000:00:1e.4 enp0s30f4: Link is Up - 1Gbps/Full - flow control off
[  112.324612] IPv6: ADDRCONF(NETDEV_CHANGE): enp0s30f4: link becomes ready
host@EHL$ ethtool --show-eee enp0s30f4
EEE Settings for enp0s30f4:
        EEE status: enabled - active
        Tx LPI: 1000000 (us)
        Supported EEE link modes:  100baseT/Full
                                   1000baseT/Full
        Advertised EEE link modes:  100baseT/Full
                                    1000baseT/Full
        Link partner advertised EEE link modes:  100baseT/Full
                                                 1000baseT/Full
host@EHL$ ethtool -S enp0s30f4 | grep lpi
     irq_tx_path_in_lpi_mode_n: 6
     irq_tx_path_exit_lpi_mode_n: 5
     irq_rx_path_in_lpi_mode_n: 7
     irq_rx_path_exit_lpi_mode_n: 6
host@EHL$ ping 192.168.1.1
PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
64 bytes from 192.168.1.1: icmp_seq=1 ttl=64 time=1.02 ms
64 bytes from 192.168.1.1: icmp_seq=2 ttl=64 time=0.510 ms
64 bytes from 192.168.1.1: icmp_seq=3 ttl=64 time=0.489 ms
64 bytes from 192.168.1.1: icmp_seq=4 ttl=64 time=0.484 ms
64 bytes from 192.168.1.1: icmp_seq=5 ttl=64 time=0.504 ms
64 bytes from 192.168.1.1: icmp_seq=6 ttl=64 time=0.466 ms
64 bytes from 192.168.1.1: icmp_seq=7 ttl=64 time=0.529 ms
64 bytes from 192.168.1.1: icmp_seq=8 ttl=64 time=0.519 ms
64 bytes from 192.168.1.1: icmp_seq=9 ttl=64 time=0.518 ms
64 bytes from 192.168.1.1: icmp_seq=10 ttl=64 time=0.501 ms

--- 192.168.1.1 ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9216ms
rtt min/avg/max/mdev = 0.466/0.553/1.018/0.155 ms
host@EHL$ ethtool -S enp0s30f4 | grep lpi
     irq_tx_path_in_lpi_mode_n: 22
     irq_tx_path_exit_lpi_mode_n: 21
     irq_rx_path_in_lpi_mode_n: 21
     irq_rx_path_exit_lpi_mode_n: 20

Michael Sit Wei Hong (2):
  net: pcs: Introducing support for DWC xpcs Energy Efficient Ethernet
  net: stmmac: Add callbacks for DWC xpcs Energy Efficient Ethernet

 .../net/ethernet/stmicro/stmmac/dwmac-intel.c | 11 ++++
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |  2 +
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  |  6 +++
 drivers/net/pcs/pcs-xpcs.c                    | 51 +++++++++++++++++++
 include/linux/pcs/pcs-xpcs.h                  |  2 +
 include/linux/stmmac.h                        |  1 +
 6 files changed, 73 insertions(+)

-- 
2.17.1

