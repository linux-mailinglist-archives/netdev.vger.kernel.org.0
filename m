Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1E713AE656
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 11:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhFUJsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 05:48:07 -0400
Received: from mga18.intel.com ([134.134.136.126]:3834 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230076AbhFUJsF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 05:48:05 -0400
IronPort-SDR: cHFZM0PVUvRDvL/jVqZQ+Hd2lzSZziz7Ocn+HVfS1+JF+JOpGt/6sAtUFpcqJqy2xQ6Px+tHzJ
 fM8T95/PUhPA==
X-IronPort-AV: E=McAfee;i="6200,9189,10021"; a="194122078"
X-IronPort-AV: E=Sophos;i="5.83,289,1616482800"; 
   d="scan'208";a="194122078"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2021 02:45:50 -0700
IronPort-SDR: nIkB7J4kkZxPiDf69wxwy5j5R1+1vIPvaZQbgEj/mN0Lco/uqlvODIKzhNAUmC8XyEIrNTu+Ql
 zZzkrbYj/pLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,289,1616482800"; 
   d="scan'208";a="638720236"
Received: from peileeli.png.intel.com ([172.30.240.12])
  by fmsmga006.fm.intel.com with ESMTP; 21 Jun 2021 02:45:44 -0700
From:   Ling Pei Lee <pei.lee.ling@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     pei.lee.ling@intel.com
Subject: [PATCH net-next V1 0/4] Add option to enable PHY WOL with PMT enabled
Date:   Mon, 21 Jun 2021 17:45:32 +0800
Message-Id: <20210621094536.387442-1-pei.lee.ling@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset main objective is to provide an option to enable PHY WoL even the
PMT is enabled by default in the HW features.

The current stmmac driver WOL implementation will enable MAC WOL if MAC HW PMT
feature is on. Else, the driver will check for PHY WOL support.
Intel EHL mgbe are designed to wake up through PHY WOL
although the HW PMT is enabled.Hence, introduced use_phy_wol platform
data to provide this PHY WOL option. Set use_phy_wol will disable the plat->pmt
which currently used to determine the system to wake up by MAC WOL or PHY WOL.

During testing, it is discovered that PHY did not reconfigured the PHY WOL
after waking up from S3/S4 through magic packet. During the driver resume flow,
the driver will reconfigure the PHY WOL depending on the ethool WOL settings.

This WOL patchset includes of setting the device power state to D3hot.
This is because the EHL PSE will need to PSE mgbe to be in D3 state in order
for the PSE to goes into suspend mode.

Ling Pei Lee (2):
  net: stmmac: option to enable PHY WOL with PMT enabled
  stmmac: intel: Enable PHY WOL option in EHL

Muhammad Husaini Zulkifli (1):
  net: stmmac: Reconfigure the PHY WOL settings in stmmac_resume()

Voon Weifeng (1):
  stmmac: intel: set PCI_D3hot in suspend

 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c |  2 ++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 13 ++++++++++++-
 include/linux/stmmac.h                            |  1 +
 3 files changed, 15 insertions(+), 1 deletion(-)

-- 
2.25.1

