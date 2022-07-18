Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06994578121
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 13:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233176AbiGRLno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 07:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbiGRLnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 07:43:43 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8822FB7E8;
        Mon, 18 Jul 2022 04:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1658144622; x=1689680622;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=wMjtHKQDvulOhDTyol3KLlhM58iCXiOSY8YldyJM3P4=;
  b=Zi2DDPnb7aZAeOd6vlt9RKeAR/JftC2o7FaU4GkN2YDu061wyl3qvJLO
   ZG8o2KUPAaCtNubjgZec9ltR/poL9ML0Z848gzda6gvGNBPlJshjHIN6J
   XZ73gF36+xrkAJpHBf66btoHoi4hThpxmJj8iR1KEpYvTRwhVQDz93ohg
   9pb2AgIPUP2SLnIJjNM4NJlcCwgtBVFgGEdnoZsXeVzjQtugHp9PAs+FH
   jQjjtn6yQKZV9B1kJEmWfG2d8xqaO5R9UihGm11blsArge3ieV1AhyWD+
   2WLUFRJmsV+kKvl1gBkAJ8oag7w5bgNu5ofcQUI4qgZjtvAmDQq3aaHV7
   g==;
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="104921901"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Jul 2022 04:43:41 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 18 Jul 2022 04:43:40 -0700
Received: from training-HP-280-G1-MT-PC.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 18 Jul 2022 04:43:36 -0700
From:   Divya Koppera <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <richardcochran@gmail.com>
CC:     <UNGLinuxDriver@microchip.com>, <Madhuri.Sripada@microchip.com>
Subject: [PATCH net-next] net: phy: micrel: Fix warn: passing zero to PTR_ERR
Date:   Mon, 18 Jul 2022 17:13:33 +0530
Message-ID: <20220718114333.4866-1-Divya.Koppera@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Removing NULL check, as using it here is not valid

Fixes New smatch warnings:
drivers/net/phy/micrel.c:2613 lan8814_ptp_probe_once() warn: passing zero to 'PTR_ERR'

vim +/PTR_ERR +2613 drivers/net/phy/micrel.c

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: ece19502834d ("net: phy: micrel: 1588 support for LAN8814 phy")
Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
---
 drivers/net/phy/micrel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index e78d0bf69bc3..04146b936786 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -2812,7 +2812,7 @@ static int lan8814_ptp_probe_once(struct phy_device *phydev)
 
 	shared->ptp_clock = ptp_clock_register(&shared->ptp_clock_info,
 					       &phydev->mdio.dev);
-	if (IS_ERR_OR_NULL(shared->ptp_clock)) {
+	if (IS_ERR(shared->ptp_clock)) {
 		phydev_err(phydev, "ptp_clock_register failed %lu\n",
 			   PTR_ERR(shared->ptp_clock));
 		return -EINVAL;
-- 
2.17.1

