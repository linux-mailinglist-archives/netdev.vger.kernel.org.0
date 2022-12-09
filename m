Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B559C648ADA
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 23:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbiLIWr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 17:47:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiLIWrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 17:47:21 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C52A5DDC;
        Fri,  9 Dec 2022 14:47:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670626040; x=1702162040;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version;
  bh=B2lfXxHngQm03n83AdhmQkCAaE+4zb2T+WSAC7zt58o=;
  b=UanF4I5ghcQex1rlFV0NZZfYDT/Kl+4h3Vx/pDW9gxbv1HNln03R0+SO
   5OQEdb0Aly1ZqhUrhVwHBYEn8ZeapnVN/BvVn1K5l6Z6JZGSOcyurbGNF
   Gv0nIM61dG3LYBau8vhWtPGcBH8J3/GGvXCfUlBr9eT6hkw06nO5WLFj9
   y2dUKlNJdxJfi0DPZUTi9z2+f7peJZCHlNa9xcolhjy5jG8bUcoabNPtG
   7H4qyvU+xZ6vjLXIAJmlDwSMfMlfJZuth/aLzrIvkDGCVZ6PXdK7/vfWD
   +84MLyPFgZDCZ/qbhOIEIf7Zle1EeAQM0xHeMVaujQUrZhQ4KwruO3c9A
   A==;
X-IronPort-AV: E=Sophos;i="5.96,232,1665471600"; 
   d="scan'208";a="203381007"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Dec 2022 15:47:19 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 9 Dec 2022 15:47:18 -0700
Received: from AUS-LT-C33025.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 9 Dec 2022 15:47:17 -0700
From:   Jerry Ray <jerry.ray@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, <jbe@pengutronix.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux@armlinux.org.uk>, Jerry Ray <jerry.ray@microchip.com>
Subject: [PATCH net-next v5 3/6] dsa: lan9303: Add exception logic for read failure
Date:   Fri, 9 Dec 2022 16:47:10 -0600
Message-ID: <20221209224713.19980-4-jerry.ray@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221209224713.19980-1-jerry.ray@microchip.com>
References: <20221209224713.19980-1-jerry.ray@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While it is highly unlikely a read will ever fail, This code fragment is
now in a function that allows us to return an error code. A read failure
here will cause the lan9303_probe to fail.

Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
---
 drivers/net/dsa/lan9303-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 20fc2af62531..b0f49d9c3d0c 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -887,7 +887,9 @@ static int lan9303_check_device(struct lan9303 *chip)
 	}
 
 	/* Virtual Phy: Remove Turbo 200Mbit mode */
-	lan9303_read(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, &reg);
+	ret = lan9303_read(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, &reg);
+	if (ret)
+		return (ret);
 
 	reg &= ~LAN9303_VIRT_SPECIAL_TURBO;
 	regmap_write(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, reg);
-- 
2.17.1

