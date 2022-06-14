Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25BD454A751
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 05:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245310AbiFNDFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 23:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239608AbiFNDFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 23:05:08 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F9D2981C;
        Mon, 13 Jun 2022 20:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655175907; x=1686711907;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0q3A6ZlYknCDTiDq54GQ1dl5Y2j8+ayQDmnfAoNRMts=;
  b=FHgjKKk/nAIrS4ilRsAUMrJbtEmz0T4r3N24DjdilinVrGqIg+PKng2e
   w96xzgp8mgw4jzEQMjB35e8Snke2LOfBGpUfN0T3JMDHou33cDDb0BXty
   j+RTsz0kCmaTKPe64U+eBWpZnNN4x3JfplQIWh2h0hNSFrUgQxU456HN4
   ZoYJcxi5JJvIEo4BbtKwKETW6+0TcycZxAS0xbLNQ8kfzFZIrApSP3503
   Z7q4IZLYZC9d6rvkFFGfJZu9c3QyQeXRxLWTBRtyzspdVm7BslBMDfXyL
   qKzsi2XGSFmbfAg3dzLj1YZZ09DtBYRQKnB4DSCuXPlAGKhIWKqzCXouC
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10377"; a="278518732"
X-IronPort-AV: E=Sophos;i="5.91,298,1647327600"; 
   d="scan'208";a="278518732"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 20:05:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,298,1647327600"; 
   d="scan'208";a="761787650"
Received: from p12hl98bong5.png.intel.com ([10.158.65.178])
  by orsmga005.jf.intel.com with ESMTP; 13 Jun 2022 20:05:02 -0700
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Riva <emilio.riva@ericsson.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net-next v4 0/5] pcs-xpcs, stmmac: add 1000BASE-X AN for network switch
Date:   Tue, 14 Jun 2022 11:00:25 +0800
Message-Id: <20220614030030.1249850-1-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thanks for review feedback from Russell in [1] and [2]. I have changed
the v4 implementation as follow.

v4 changes:
1/5 - Squash v3:1/7 & 2/7 patches into v4:1/6 so that it passes build.
2/5 - [No change] same as v3:3/7
3/5 - [Fix] Fix issues identified by Russell in [1]
4/5 - [Fix] Drop v3:5/7 patch per input by Russell in [2] and make
            dwmac-intel clear the ovr_an_inband flag if fixed-link
            is used in ACPI _DSD.
5/5 - [No change] same as v3:7/7

The patches are built with C=1 and W=1 and I have found no additional
warn and error from these patches (as advised by Jakub)

The record for v3 changes is in [3]
1/7 - [New] Update xpcs_do_config to accept advertising input
2/7 - [New] Fix to compilation issue introduced v1. Update xpcs_do_config
            for sja1105.
3/7 - Same as 3/4 of v1 series.
4/7 - [Fix] Fix numerous issues identified by Russell King.
5/7 - [New] Make fixed-link setting takes precedence over ovr_an_inband.
            This is a fix to a bug introduced earlier. Separate patch
            will be sent later.
6/7 - [New] Allow phy-mode ACPI _DSD setting for dwmac-intel to overwrite
            the phy_interface detected through PCI DevID.
7/7 - [New] Make mdio register flow to skip PHY scanning if fixed-link
            is specified.

Reference:
[1] https://patchwork.kernel.org/comment/24890210/
[2] https://patchwork.kernel.org/comment/24890222/
[3] https://patchwork.kernel.org/project/netdevbpf/cover/20220610033610.114084-1-boon.leong.ong@intel.com/

Thanks
Boon Leong

Ong Boon Leong (5):
  net: make xpcs_do_config to accept advertising for pcs-xpcs and
    sja1105
  stmmac: intel: prepare to support 1000BASE-X phy interface setting
  net: pcs: xpcs: add CL37 1000BASE-X AN support
  stmmac: intel: add phy-mode and fixed-link ACPI _DSD setting support
  net: stmmac: make mdio register skips PHY scanning for fixed-link

 drivers/net/dsa/sja1105/sja1105_main.c        |   2 +-
 .../net/ethernet/stmicro/stmmac/dwmac-intel.c |  30 ++-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  11 +-
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c |  14 ++
 drivers/net/pcs/pcs-xpcs.c                    | 178 +++++++++++++++++-
 drivers/net/pcs/pcs-xpcs.h                    |   3 +-
 include/linux/pcs/pcs-xpcs.h                  |   3 +-
 7 files changed, 228 insertions(+), 13 deletions(-)

--
2.25.1

