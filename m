Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9FBC5636C3
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 17:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbiGAPQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 11:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbiGAPQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 11:16:28 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BC430F7D;
        Fri,  1 Jul 2022 08:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656688587; x=1688224587;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XFBVO6SXrO3FNt7nyhFxNsDwduLPRRwR8Ddld4oarBA=;
  b=pO03cPW4b+OBmQTnv4drWTE/971ObouaPTu8Atnljj9izaY2pi1yx5xZ
   mriUWBD5z3vzaChQQGjx2lHYAJVWYosQjJfpA4AT6GnDXDiRa3Gfw5nqQ
   qS8JvSzM6APAv3/XFXKtJAHuO9IH3t0dVxdsJ50DffJDQgkxEysmvO6TG
   +ltM91ajkzbgJmqmh8t+MYjG7OS9k+uPBXA76+J29r1W4dFcLXUbVUxpc
   5hVbfPO3AAc9Z84Nb01txnMzScMEaZwTQH9AR3aDkv9rGqNMSQdx9QESC
   BZLBCE8zpJ0i1u7Yo1RaD+T8GAtRLnMIY50xZVFmSHh6129Lbudc48i2u
   A==;
X-IronPort-AV: E=Sophos;i="5.92,237,1650956400"; 
   d="scan'208";a="102673275"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Jul 2022 08:16:26 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 1 Jul 2022 08:16:25 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 1 Jul 2022 08:16:06 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Rob Herring" <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Subject: [Patch net-next v15 13/13] net: dsa: microchip: add LAN937x in the ksz spi probe
Date:   Fri, 1 Jul 2022 20:46:00 +0530
Message-ID: <20220701151600.31805-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220701144652.10526-1-arun.ramadoss@microchip.com>
References: <20220701144652.10526-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add the LAN937x part support in the existing ksz_spi_probe.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz_spi.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz_spi.c b/drivers/net/dsa/microchip/ksz_spi.c
index 69fabb190f26..4844830dca72 100644
--- a/drivers/net/dsa/microchip/ksz_spi.c
+++ b/drivers/net/dsa/microchip/ksz_spi.c
@@ -166,6 +166,26 @@ static const struct of_device_id ksz_dt_ids[] = {
 		.compatible = "microchip,ksz9567",
 		.data = &ksz_switch_chips[KSZ9567]
 	},
+	{
+		.compatible = "microchip,lan9370",
+		.data = &ksz_switch_chips[LAN9370]
+	},
+	{
+		.compatible = "microchip,lan9371",
+		.data = &ksz_switch_chips[LAN9371]
+	},
+	{
+		.compatible = "microchip,lan9372",
+		.data = &ksz_switch_chips[LAN9372]
+	},
+	{
+		.compatible = "microchip,lan9373",
+		.data = &ksz_switch_chips[LAN9373]
+	},
+	{
+		.compatible = "microchip,lan9374",
+		.data = &ksz_switch_chips[LAN9374]
+	},
 	{},
 };
 MODULE_DEVICE_TABLE(of, ksz_dt_ids);
@@ -182,6 +202,11 @@ static const struct spi_device_id ksz_spi_ids[] = {
 	{ "ksz9563" },
 	{ "ksz8563" },
 	{ "ksz9567" },
+	{ "lan9370" },
+	{ "lan9371" },
+	{ "lan9372" },
+	{ "lan9373" },
+	{ "lan9374" },
 	{ },
 };
 MODULE_DEVICE_TABLE(spi, ksz_spi_ids);
@@ -206,6 +231,7 @@ MODULE_ALIAS("spi:ksz9893");
 MODULE_ALIAS("spi:ksz9563");
 MODULE_ALIAS("spi:ksz8563");
 MODULE_ALIAS("spi:ksz9567");
+MODULE_ALIAS("spi:lan937x");
 MODULE_AUTHOR("Tristram Ha <Tristram.Ha@microchip.com>");
 MODULE_DESCRIPTION("Microchip ksz Series Switch SPI Driver");
 MODULE_LICENSE("GPL");
-- 
2.36.1

