Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E20555755E2
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 21:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240568AbiGNThF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 15:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238905AbiGNThB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 15:37:01 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C5115B062;
        Thu, 14 Jul 2022 12:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657827420; x=1689363420;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LtHpDNLMAcK5rBLsj0TfF3HcbTfILzQaOwVoqU00jaw=;
  b=x3HYGJOt4+2UZtVKRYL/mlNusEGqCQM3EVVs6VYiBd2b1qpj8l5qzaSN
   xaVnQgzBH0WxU7CjTb+XDMPxjYr5jO3GtgIG8LNeIDJDkjWbq+a9Ofo8m
   gES1HE0f83YUC8aj/GWwqCYtPYPfc7DyC0MmzuT318nb8jbtSGItoPKYT
   iNpH2ztwKAPloGpNAT8fisg7F3iMjyBIqxTG6auptKyRdXTZ2YuR7KDV2
   SoDOG1JSnDZ6//FvFJOTjP/rCewZRc3zdMTFaA4NYYIE9a+SEQSRzkMBX
   4pnhD4+CF/8xVHPhU1jp4FUY3rtNvE38luKlx+zZB5UdCHKLJ5BP4Bt4M
   w==;
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="167895546"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jul 2022 12:36:58 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 14 Jul 2022 12:36:58 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 14 Jul 2022 12:36:56 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <vladimir.oltean@nxp.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net 2/5] net: lan966x: Fix usage of lan966x->mac_lock when entry is added
Date:   Thu, 14 Jul 2022 21:40:37 +0200
Message-ID: <20220714194040.231651-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220714194040.231651-1-horatiu.vultur@microchip.com>
References: <20220714194040.231651-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To add an entry to the MAC table, it is required first to setup the
entry and then issue a command for the MAC to learn the entry.
So if it happens for two threads to add simultaneously an entry in MAC
table then it would be a race condition.
Fix this by using lan966x->mac_lock to protect the HW access.

Fixes: fc0c3fe7486f2 ("net: lan966x: Add function lan966x_mac_ip_learn()")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_mac.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
index 2d2b83c03796..4f8fd5cde950 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
@@ -75,6 +75,9 @@ static int __lan966x_mac_learn(struct lan966x *lan966x, int pgid,
 			       unsigned int vid,
 			       enum macaccess_entry_type type)
 {
+	int ret;
+
+	spin_lock(&lan966x->mac_lock);
 	lan966x_mac_select(lan966x, mac, vid);
 
 	/* Issue a write command */
@@ -86,7 +89,10 @@ static int __lan966x_mac_learn(struct lan966x *lan966x, int pgid,
 	       ANA_MACACCESS_MAC_TABLE_CMD_SET(MACACCESS_CMD_LEARN),
 	       lan966x, ANA_MACACCESS);
 
-	return lan966x_mac_wait_for_completion(lan966x);
+	ret = lan966x_mac_wait_for_completion(lan966x);
+	spin_unlock(&lan966x->mac_lock);
+
+	return ret;
 }
 
 /* The mask of the front ports is encoded inside the mac parameter via a call
-- 
2.33.0

