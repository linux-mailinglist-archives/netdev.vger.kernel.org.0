Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1DFA33AACE
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 06:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbhCOFYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 01:24:03 -0400
Received: from mga07.intel.com ([134.134.136.100]:59451 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229529AbhCOFXe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 01:23:34 -0400
IronPort-SDR: l/7SinN5KluWQfeET+SqAJrPXV7p7ef3rNxocDG3mQy8zxrXS8RbwlaNyY6lLrdCYNyss5s2gk
 kqQsEMYFmHxQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9923"; a="253054412"
X-IronPort-AV: E=Sophos;i="5.81,249,1610438400"; 
   d="scan'208";a="253054412"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2021 22:23:29 -0700
IronPort-SDR: JcCFDc4GqxOuzFSlKoQE1YDvqDCOUrp0+IvN/UezeggyZhQX8Q+CicrTPBBiV2gLi5uSBQ7Fh6
 RDChyKjyZirw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,249,1610438400"; 
   d="scan'208";a="373313736"
Received: from glass.png.intel.com ([10.158.65.59])
  by orsmga006.jf.intel.com with ESMTP; 14 Mar 2021 22:23:25 -0700
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King i <linux@armlinux.org.uk>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Fugang Duan <fugang.duan@nxp.com>
Subject: [PATCH net-next 0/6] net: pcs, stmmac: add C37 AN SGMII support
Date:   Mon, 15 Mar 2021 13:27:05 +0800
Message-Id: <20210315052711.16728-1-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

This patch series adds MAC-side SGMII support to stmmac driver and it is
changed as follow:-

1/6: Refactor the current C73 implementation in pcs-xpcs to prepare for
     adding C37 AN later.
2/6: Add MAC-side SGMII C37 AN support to pcs-xpcs
3,4/6: make phylink_parse_mode() to work for non-DT platform so that
       we can use stmmac platform_data to set it.
5/6: Make stmmac_open() to only skip PHY init if C73 is used, otherwise
     C37 AN will need phydev to be connected to phylink.
6/6: Finally, add pcs-xpcs SGMII interface support to Intel mGbE
     controller.

The patch series have been tested on EHL CRB PCH TSN (eth2) controller
that has Marvell 88E1512 PHY attached over SGMII interface and the
iterative tests of speed change (AN) + ping test have been successful.

[63446.009295] intel-eth-pci 0000:00:1e.4 eth2: Link is Down
[63449.986365] intel-eth-pci 0000:00:1e.4 eth2: Link is Up - 1Gbps/Full - flow control off
[63449.987625] IPv6: ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
[63451.248064] intel-eth-pci 0000:00:1e.4 eth2: Link is Down
[63454.082366] intel-eth-pci 0000:00:1e.4 eth2: Link is Up - 100Mbps/Full - flow control off
[63454.083650] IPv6: ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
[63456.465179] intel-eth-pci 0000:00:1e.4 eth2: Link is Down
[63459.202367] intel-eth-pci 0000:00:1e.4 eth2: Link is Up - 10Mbps/Full - flow control off
[63459.203639] IPv6: ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
[63460.882832] intel-eth-pci 0000:00:1e.4 eth2: Link is Down
[63464.322366] intel-eth-pci 0000:00:1e.4 eth2: Link is Up - 1Gbps/Full - flow control off

Thanks
Boon Leong

Ong Boon Leong (6):
  net: pcs: rearrange C73 functions to prepare for C37 support later
  net: pcs: add C37 SGMII AN support for intel mGbE controller
  net: phylink: make phylink_parse_mode() support non-DT platform
  net: stmmac: make in-band AN mode parsing is supported for non-DT
  net: stmmac: ensure phydev is attached to phylink for C37 AN
  stmmac: intel: add pcs-xpcs for Intel mGbE controller

 .../net/ethernet/stmicro/stmmac/dwmac-intel.c |  15 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |   4 +-
 drivers/net/pcs/pcs-xpcs.c                    | 257 ++++++++++++++++--
 drivers/net/phy/phylink.c                     |   5 +-
 include/linux/pcs/pcs-xpcs.h                  |   5 +
 include/linux/phylink.h                       |   2 +
 include/linux/stmmac.h                        |   1 +
 7 files changed, 258 insertions(+), 31 deletions(-)

-- 
2.25.1

