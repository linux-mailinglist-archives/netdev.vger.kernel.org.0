Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 564974A824F
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 11:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347718AbiBCKaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 05:30:02 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:34640 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbiBCKaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 05:30:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643884201; x=1675420201;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1TXPyy/kpZBNxO1tbtGx3iBoVnJzfJ227qS4/tBvr18=;
  b=LYJZ6XT+Hd0/9mScnCjCfZWzcX34xsA+MSAoIuY4EvOvv5CRs4tkBQLP
   FL96IaQCZLClIyzDu0AJffAkQAEKYzkHqOOXP/TUapxTC6+zV9yCuTCxY
   s4H70GI58T3ny3RYgoBa08eRILQxTSQ1vo1vEs2iANe0tTWPwo+tBICuv
   yKKwaPKU8eamOoyXHsHNDlGAjkD/yerc4s1QnAHZZeVlCFEZDl2Y16TNo
   4DUKZ6i/H/Imlpj30bp+Lqf6XlLqosDYFHabP/HszoGRr5HSCoS4frNVe
   nlF5/kMiCIXAXQsj9KniYAXovTTtL/HF5iK4CIkb78ywm28gtxvKMUfm/
   g==;
IronPort-SDR: KptEahQXKMdnpFose7f1Df66KQBgN5k2e7W95KLW+AC4ubFgizza4MgTI+t5MrZ24ksmbfM/w1
 F68uLGKNQG6XHcStLBz+aPNh7uL5GEAtdkYyqVjYOmE6ca+EP42zwUSWue4JN9rPA7DHGLuugo
 LJWgr4dp/Z4NBtlHxGRml6/x9DVELeVMXtxm5h0XiHG2fnTs+oQVQUTAej+OccO7oxIxNY0QWj
 hLS8s1OkI606jg6a4WaC/Rkg81utatMXOWKT7J/cKPt1f1yyrd9D7I3RdG4n0Ydag2ut8pLOzP
 xwO4ms0GBCABQaEFHUvGAKYw
X-IronPort-AV: E=Sophos;i="5.88,339,1635231600"; 
   d="scan'208";a="84547385"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Feb 2022 03:30:00 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 3 Feb 2022 03:30:01 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 3 Feb 2022 03:29:59 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>
Subject: [PATCH net] net: sparx5: Fix get_stat64 crash in tcpdump
Date:   Thu, 3 Feb 2022 11:29:00 +0100
Message-ID: <20220203102900.528987-1-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This problem was found with Sparx5 when the tcpdump tool requests the
do_get_stats64 (sparx5_get_stats64) statistic.

The portstats pointer was incorrectly incremented when fetching priority
based statistics.

Fixes: af4b11022e2d (net: sparx5: add ethtool configuration and statistics support)
Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c b/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c
index 59783fc46a7b..10b866e9f726 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c
@@ -1103,7 +1103,7 @@ void sparx5_get_stats64(struct net_device *ndev,
 	stats->tx_carrier_errors = portstats[spx5_stats_tx_csense_cnt];
 	stats->tx_window_errors = portstats[spx5_stats_tx_late_coll_cnt];
 	stats->rx_dropped = portstats[spx5_stats_ana_ac_port_stat_lsb_cnt];
-	for (idx = 0; idx < 2 * SPX5_PRIOS; ++idx, ++stats)
+	for (idx = 0; idx < 2 * SPX5_PRIOS; ++idx)
 		stats->rx_dropped += portstats[spx5_stats_green_p0_rx_port_drop
 					       + idx];
 	stats->tx_dropped = portstats[spx5_stats_tx_local_drop];
-- 
2.35.1

