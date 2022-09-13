Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB4D5B77A9
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 19:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232793AbiIMRSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 13:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232769AbiIMRRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 13:17:34 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B3B46616;
        Tue, 13 Sep 2022 09:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663085116; x=1694621116;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Cb8wF47Gufv1Zl9sCCgpwO9plAkkFxVtctfAOUBp6Kc=;
  b=pdX5JE6LzE6m1FaM3CHfj4misVQFeXLIosRG3UoQ9aw6nhW6PLS3eLdz
   kg7EydvBOqZAyFXDDNYH9lT1VaqwSBxa675fz/JhcIOvL02e3fhsvYcoV
   wlwyZjYCB72rjckgfBBmy2xR3kN7Wnl/QcEUTYBtu07UfNec15k6gmUO0
   XuUrBUOVfN4i4/b8xRv1VfozrtSEy09Ocxs95wGKXzgLiWZ1ZCVyhovfp
   17H9PxOxaNLHItENdkZVhp9Oa6XFYbtg1jVLJ3/haWZvFJU7TYjpsrknr
   BnkAUpV6Fs00hL3ONXoszTDC1b0jPC8Tm3h/5neRYAEJ6sRC1apdt7Qnp
   w==;
X-IronPort-AV: E=Sophos;i="5.93,313,1654585200"; 
   d="scan'208";a="190664653"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Sep 2022 09:05:15 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 13 Sep 2022 09:05:15 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 13 Sep 2022 09:05:09 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <arun.ramadoss@microchip.com>,
        <prasanna.vengateshan@microchip.com>, <hkallweit1@gmail.com>
Subject: [Patch net-next 3/5] net: dsa: microchip: lan937x: return zero if mdio node not present
Date:   Tue, 13 Sep 2022 21:34:25 +0530
Message-ID: <20220913160427.12749-4-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220913160427.12749-1-arun.ramadoss@microchip.com>
References: <20220913160427.12749-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, if the mdio node is not present in the dts file then
lan937x_mdio_register return -ENODEV and entire probing process fails.
To make the mdio_register generic for all ksz series switches and to
maintain back-compatibility with existing dts file, return -ENODEV is
replaced with return 0.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/lan937x_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index 1f4472c90a1f..36acef385de3 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -214,10 +214,8 @@ static int lan937x_mdio_register(struct ksz_device *dev)
 	int ret;
 
 	mdio_np = of_get_child_by_name(dev->dev->of_node, "mdio");
-	if (!mdio_np) {
-		dev_err(ds->dev, "no MDIO bus node\n");
-		return -ENODEV;
-	}
+	if (!mdio_np)
+		return 0;
 
 	bus = devm_mdiobus_alloc(ds->dev);
 	if (!bus) {
-- 
2.36.1

