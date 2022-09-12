Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 058FB5B535B
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 07:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiILFPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 01:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiILFPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 01:15:35 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513D517050;
        Sun, 11 Sep 2022 22:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662959731; x=1694495731;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=kHjZUGKOIELCEpR9rLYYd64wZk3rM2bDxxUENZDLGa4=;
  b=SCpsh/++VumAdEK/ZbjmfxHRsVWzZngCL4Tb56EUqx8t2XoriRLpdTCk
   eH9+SneNJwf3hM+JjHNdnSqr3qw1HZsEIRTTruLL1ACC1mYxIIAQC7L13
   ZS1w4qqGGXP+RKMQ3Pq58+5y9kqvT26eiwnGv7rK9mlAxQRg0f16mfym9
   5G5kAeDXFWaoP3PFfnt/SdkQyCuyH8q1okVkXBq/p0Q+rSbZuZWrwL2W/
   cUG2riX2Dtt0qL728QQhJT78w4lMyFo/QIMGiBeVOiOWyDVpDU4v+r5rW
   Isn3o13UZGmNhEcckXFfUrGwEUmA2S1DQh0F9ek6LaHY/Y3MfXhw1u1Jl
   w==;
X-IronPort-AV: E=Sophos;i="5.93,308,1654585200"; 
   d="scan'208";a="176642009"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Sep 2022 22:15:28 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sun, 11 Sep 2022 22:15:25 -0700
Received: from che-lt-i67786lx.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Sun, 11 Sep 2022 22:15:21 -0700
From:   Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <arun.ramadoss@microchip.com>
Subject: [Patch net] net: dsa: microchip: lan937x: fix maximum frame length check
Date:   Mon, 12 Sep 2022 10:42:28 +0530
Message-ID: <20220912051228.1306074-1-rakesh.sankaranarayanan@microchip.com>
X-Mailer: git-send-email 2.34.1
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

Maximum frame length check is enabled in lan937x switch on POR, But it
is found to be disabled on driver during port setup operation. Due to
this, packets are not dropped when transmitted with greater than configured
value. For testing, setup made for lan1->lan2 transmission and configured
lan1 interface with a frame length (less than 1500 as mentioned in
documentation) and transmitted packets with greater than configured value.
Expected no packets at lan2 end, but packets observed at lan2.

Based on the documentation, packets should get discarded if the actual
packet length doesn't match the frame length configured. Frame length check
should be disabled only for cascaded ports due to tailtags.

This feature was disabled on ksz9477 series due to ptp issue, which is
not in lan937x series. But since lan937x took ksz9477 as base, frame
length check disabled here as well. Patch added to remove this portion
from port setup so that maximum frame length check will be active for
normal ports.

Fixes: 55ab6ffaf378 ("net: dsa: microchip: add DSA support for microchip LAN937x")
Signed-off-by: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
---
 drivers/net/dsa/microchip/lan937x_main.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index 4867aa62dd4c..7d06488d1eea 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -296,10 +296,6 @@ void lan937x_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 		lan937x_port_cfg(dev, port, REG_PORT_CTRL_0,
 				 PORT_TAIL_TAG_ENABLE, true);
 
-	/* disable frame check length field */
-	lan937x_port_cfg(dev, port, REG_PORT_MAC_CTRL_0, PORT_CHECK_LENGTH,
-			 false);
-
 	/* set back pressure for half duplex */
 	lan937x_port_cfg(dev, port, REG_PORT_MAC_CTRL_1, PORT_BACK_PRESSURE,
 			 true);
-- 
2.34.1

