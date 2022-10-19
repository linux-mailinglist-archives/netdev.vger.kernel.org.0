Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54311603B70
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 10:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiJSI1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 04:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiJSI1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 04:27:10 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C97FD657F;
        Wed, 19 Oct 2022 01:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666168030; x=1697704030;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=MXelgcyJAvDzDyiQRCyTuEGTLOVMAItrzyFRkWJ6X4k=;
  b=iJmgftERtcRAMzFhq2u+FlZLbTCBkI6wWztxMaY2OVP8+Uaeh7TQItOn
   OgOYLxLfdRiZoq3i8NkueeDSepI0sn0zLrSKyjMJ45I1ru43xSbjE/0+e
   u5lXuM1LLv0ozEh/6rSjhWIs1i3K/UeSyU5HLwQjAjLCXVrWt6pi8fAyA
   mdt44iIoPq0WLkaNBk42EiknEwgpsZs3WCcaIw7sb5otL2wv8fAkR7r+q
   epUdjWagPNOQlNXn1umO+VimhmAPEdRLLbCsR0E8VM56+WHPbtLrssNSh
   aKqR+szs6asQFn26aXGxpXj9UmSZgWLrYkd2XjmuDxF8/XorB4oQEYtvx
   A==;
X-IronPort-AV: E=Sophos;i="5.95,195,1661842800"; 
   d="scan'208";a="179506375"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Oct 2022 01:27:09 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 19 Oct 2022 01:27:08 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 19 Oct 2022 01:27:06 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net] net: lan966x: Fix the rx drop counter
Date:   Wed, 19 Oct 2022 10:30:56 +0200
Message-ID: <20221019083056.2744282-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the rx drop is calculated as the sum of multiple HW drop
counters. The issue is that not all the HW drop counters were added for
the rx drop counter. So if for example you have a police that drops
frames, they were not see in the rx drop counter.
Fix this by updating how the rx drop counter is calculated. It is
required to add also RX_RED_PRIO_* HW counters.

Fixes: 12c2d0a5b8e2 ("net: lan966x: add ethtool configuration and statistics")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/lan966x/lan966x_ethtool.c   | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c b/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c
index e58a27fd8b508..fea42542be280 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c
@@ -656,7 +656,15 @@ void lan966x_stats_get(struct net_device *dev,
 	stats->rx_dropped = dev->stats.rx_dropped +
 		lan966x->stats[idx + SYS_COUNT_RX_LONG] +
 		lan966x->stats[idx + SYS_COUNT_DR_LOCAL] +
-		lan966x->stats[idx + SYS_COUNT_DR_TAIL];
+		lan966x->stats[idx + SYS_COUNT_DR_TAIL] +
+		lan966x->stats[idx + SYS_COUNT_RX_RED_PRIO_0] +
+		lan966x->stats[idx + SYS_COUNT_RX_RED_PRIO_1] +
+		lan966x->stats[idx + SYS_COUNT_RX_RED_PRIO_2] +
+		lan966x->stats[idx + SYS_COUNT_RX_RED_PRIO_3] +
+		lan966x->stats[idx + SYS_COUNT_RX_RED_PRIO_4] +
+		lan966x->stats[idx + SYS_COUNT_RX_RED_PRIO_5] +
+		lan966x->stats[idx + SYS_COUNT_RX_RED_PRIO_6] +
+		lan966x->stats[idx + SYS_COUNT_RX_RED_PRIO_7];
 
 	for (i = 0; i < LAN966X_NUM_TC; i++) {
 		stats->rx_dropped +=
-- 
2.38.0

