Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D45FA172DB
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 09:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbfEHHva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 03:51:30 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:53806 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725884AbfEHHv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 03:51:29 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id A51F3C0108;
        Wed,  8 May 2019 07:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1557301882; bh=N1nNw0lR2Hfa0vE0MbFOgbVnpAJnZjXAL+geIRasaBg=;
        h=From:To:Cc:Subject:Date:From;
        b=hlB54AbeYegPKqTidrJxDgirL8G3+ESTbiCcjLF2pvO03Uvm7B57nfhaLuBTj5LKT
         53irTN1Q+AWWJmPl6PHjOwIU5n/4D3ISTYE4HbBuIpZpI+JB3MNijUopT3Mc97SQ6n
         3AU1rWfflx9V45QFpMH3CR5wAMahn6qSQdthYm4LizBJL+z2kBY1NUFOHpWR4Mck01
         iCR8/tUSmR4WCVvTMlnjrRLJrbZssHo7jcvAJA/sG67JqteRK9SutLu7IDfLoW0b1C
         wkTDbEwJB/oNH2E4FUyGX60Ah8Uug8XxsqU5Isb6DzKefjzDSa2xvjXGxyLQuKXYVA
         N/H7XX+dCHPJw==
Received: from de02.synopsys.com (germany.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 4C1A2A02CF;
        Wed,  8 May 2019 07:51:28 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 40EAA3D513;
        Wed,  8 May 2019 09:51:27 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next 00/11] net: stmmac: Selftests
Date:   Wed,  8 May 2019 09:51:00 +0200
Message-Id: <cover.1557300602.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ Submitting with net-next closed for proper review and testing. ]

This introduces selftests support in stmmac driver. We add 4 basic sanity
checks and MAC loopback support for all cores within the driver. This way
more tests can easily be added in the future and can be run in virtually
any MAC/GMAC/QoS/XGMAC platform.

Having this we can find regressions and missing features in the driver
while at the same time we can check if the IP is correctly working.

We have been using this for some time now and I do have more tests to
submit in the feature. My experience is that although writing the tests
adds more development time, the gain results are obvious.

I let this feature optional within the driver under a Kconfig option.

For this series the output result will be something like this
(e.g. for dwmac1000):
----
# ethtool -t eth0
The test result is PASS
The test extra info:
1. MAC Loopback                 0
2. PHY Loopback                 -95
3. MMC Counters                 0
4. EEE                          -95
5. Hash Filter MC               0
6. Perfect Filter UC            0
7. Flow Control                 0
----

(Error code -95 means EOPNOTSUPP in current HW).

Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>

Jose Abreu (11):
  net: stmmac: Add MAC loopback callback to HWIF
  net: stmmac: dwmac100: Add MAC loopback support
  net: stmmac: dwmac1000: Add MAC loopback support
  net: stmmac: dwmac4/5: Add MAC loopback support
  net: stmmac: dwxgmac2: Add MAC loopback support
  net: stmmac: Switch MMC functions to HWIF callbacks
  net: stmmac: dwmac1000: Also pass control frames while in promisc mode
  net: stmmac: dwmac4/5: Also pass control frames while in promisc mode
  net: stmmac: dwxgmac2: Also pass control frames while in promisc mode
  net: stmmac: Introduce selftests support
  net: stmmac: dwmac1000: Fix Hash Filter

 drivers/net/ethernet/stmicro/stmmac/Kconfig        |   9 +
 drivers/net/ethernet/stmicro/stmmac/Makefile       |   2 +
 drivers/net/ethernet/stmicro/stmmac/common.h       |   1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac1000.h    |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac1000_core.c   |  16 +-
 .../net/ethernet/stmicro/stmmac/dwmac100_core.c    |  13 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h       |   2 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |  17 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     |   2 +
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    |  15 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.c         |   9 +
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |  21 +
 drivers/net/ethernet/stmicro/stmmac/mmc.h          |   4 -
 drivers/net/ethernet/stmicro/stmmac/mmc_core.c     |  13 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |  22 +
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |   8 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   4 +-
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c | 743 +++++++++++++++++++++
 18 files changed, 889 insertions(+), 13 deletions(-)
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c

-- 
2.7.4

