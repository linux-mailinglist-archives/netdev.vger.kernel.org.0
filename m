Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C074B5E5C05
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 09:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbiIVHMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 03:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbiIVHMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 03:12:21 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AAA1B776F;
        Thu, 22 Sep 2022 00:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663830729; x=1695366729;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TqSw95am9Kp3Rxvnu/GBt9EmDaerXeLzQ41xHw+Pn4g=;
  b=qTpPkfMMC5g8uGb2ivfQGtwBH+hTmi5NP22+XnK9jEBOM8NGX3r9qlvC
   5CAJhVwnKAV9UW937NGVhRVZjjU00+l+u+sM3xOnd7j59sQ9NA1rIXEQ5
   KwNxhlWV9z61GosSPXPZ8Nb5aX5gufT3yQAnzb1PKQEs7+2DTfl1lwoze
   dQt9d8puBKj7ASoIsSCywhHVQDk9/Yo2+B8U5PddtdK+kSG69bchT96aj
   vPUlIfPfACMPSff/O81d4SscEe5ksH00HKFpQ7nqcjU/6mzaZyguHGyRu
   yuLiccNW1nB7+TAxIR/C2yIV6BSsz9BdT9j9RLvmFl/jBKeHq0FuZe1Sg
   A==;
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="181470958"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Sep 2022 00:12:06 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 22 Sep 2022 00:12:03 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Thu, 22 Sep 2022 00:11:57 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <arun.ramadoss@microchip.com>,
        <prasanna.vengateshan@microchip.com>, <hkallweit1@gmail.com>
Subject: [Patch net-next v4 3/6] net: dsa: microchip: lan937x: return zero if mdio node not present
Date:   Thu, 22 Sep 2022 12:40:25 +0530
Message-ID: <20220922071028.18012-4-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220922071028.18012-1-arun.ramadoss@microchip.com>
References: <20220922071028.18012-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
index 2664331cc743..d7382a77d454 100644
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

