Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34B9E367B93
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 09:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbhDVH4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 03:56:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:8505 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235216AbhDVH4W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 03:56:22 -0400
IronPort-SDR: OqLHi50YqvrKXDavl7Q9poUmzrRFeUhwvjPM4WyPfGLCp4pRFCrZ4aqKCDbxeOcOXKhnH1xQjr
 DEwIBj8nrneg==
X-IronPort-AV: E=McAfee;i="6200,9189,9961"; a="195956917"
X-IronPort-AV: E=Sophos;i="5.82,241,1613462400"; 
   d="scan'208";a="195956917"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2021 00:55:30 -0700
IronPort-SDR: AnLohqrXKePUG3FK/r/YhrgSUVOLhDx35E99eZ0bP/F835kQJLLCBvwb72EMuNWCFRIPT1SolH
 iNkXSTlJh7fQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,242,1613462400"; 
   d="scan'208";a="421282417"
Received: from mismail5-ilbpg0.png.intel.com ([10.88.229.82])
  by fmsmga008.fm.intel.com with ESMTP; 22 Apr 2021 00:55:26 -0700
From:   mohammad.athari.ismail@intel.com
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Chuah@vger.kernel.org, Kim Tatt <kim.tatt.chuah@intel.com>
Cc:     Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mohammad.athari.ismail@intel.com
Subject: [PATCH net-next 2/2] stmmac: intel: Enable HW descriptor prefetch by default
Date:   Thu, 22 Apr 2021 15:55:01 +0800
Message-Id: <20210422075501.20207-3-mohammad.athari.ismail@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210422075501.20207-1-mohammad.athari.ismail@intel.com>
References: <20210422075501.20207-1-mohammad.athari.ismail@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>

Enable HW descriptor prefetch by default by setting plat->dma_cfg->dche =
true in intel_mgbe_common_data(). Need to be noted that this capability
only be supported in DWMAC core version 5.20 onwards. In stmmac, there is
a checking to check the core version. If the core version is below 5.20,
this capability wouldn`t be configured.

Below is the iperf result comparison between HW descriptor prefetch
disabled(DCHE=0b) and enabled(DCHE=1b). Tested on Intel Elkhartlake
platform with DWMAC Core 5.20. Observed line rate performance
improvement with HW descriptor prefetch enabled.

DCHE = 0b
[  5] local 169.254.1.162 port 42123 connected to 169.254.244.142 port 5201
[ ID] Interval           Transfer     Bitrate         Total Datagrams
[  5]   0.00-1.00   sec  96.7 MBytes   811 Mbits/sec  70050
[  5]   1.00-2.00   sec  96.5 MBytes   809 Mbits/sec  69850
[  5]   2.00-3.00   sec  96.3 MBytes   808 Mbits/sec  69720
[  5]   3.00-4.00   sec  95.9 MBytes   804 Mbits/sec  69450
[  5]   4.00-5.00   sec  96.0 MBytes   806 Mbits/sec  69530
[  5]   5.00-6.00   sec  96.8 MBytes   812 Mbits/sec  70080
[  5]   6.00-7.00   sec  96.9 MBytes   813 Mbits/sec  70140
[  5]   7.00-8.00   sec  96.8 MBytes   812 Mbits/sec  70080
[  5]   8.00-9.00   sec  97.0 MBytes   814 Mbits/sec  70230
[  5]   9.00-10.00  sec  96.9 MBytes   813 Mbits/sec  70170
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Jitter    Lost/Total Datagrams
[  5]   0.00-10.00  sec   966 MBytes   810 Mbits/sec  0.000 ms  0/699300 (0%)  sender
[  5]   0.00-10.00  sec   966 MBytes   810 Mbits/sec  0.011 ms  0/699265 (0%)  receiver

DCHE = 1b
[  5] local 169.254.1.162 port 49740 connected to 169.254.244.142 port 5201
[ ID] Interval           Transfer     Bitrate         Total Datagrams
[  5]   0.00-1.00   sec  97.9 MBytes   821 Mbits/sec  70880
[  5]   1.00-2.00   sec  98.1 MBytes   823 Mbits/sec  71060
[  5]   2.00-3.00   sec  98.2 MBytes   824 Mbits/sec  71140
[  5]   3.00-4.00   sec  98.2 MBytes   824 Mbits/sec  71090
[  5]   4.00-5.00   sec  98.1 MBytes   823 Mbits/sec  71050
[  5]   5.00-6.00   sec  98.1 MBytes   823 Mbits/sec  71040
[  5]   6.00-7.00   sec  98.1 MBytes   823 Mbits/sec  71050
[  5]   7.00-8.00   sec  98.2 MBytes   824 Mbits/sec  71140
[  5]   8.00-9.00   sec  98.2 MBytes   824 Mbits/sec  71120
[  5]   9.00-10.00  sec  98.3 MBytes   824 Mbits/sec  71150
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Jitter    Lost/Total Datagrams
[  5]   0.00-10.00  sec   981 MBytes   823 Mbits/sec  0.000 ms  0/710720 (0%)  sender
[  5]   0.00-10.00  sec   981 MBytes   823 Mbits/sec  0.041 ms  0/710650 (0%) receiver

Signed-off-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 4bd038acb1b9..80728a4c0e3f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -471,6 +471,7 @@ static int intel_mgbe_common_data(struct pci_dev *pdev,
 	plat->dma_cfg->fixed_burst = 0;
 	plat->dma_cfg->mixed_burst = 0;
 	plat->dma_cfg->aal = 0;
+	plat->dma_cfg->dche = true;
 
 	plat->axi = devm_kzalloc(&pdev->dev, sizeof(*plat->axi),
 				 GFP_KERNEL);
-- 
2.17.1

