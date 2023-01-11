Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 043EB6654D4
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 07:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235631AbjAKGtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 01:49:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbjAKGtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 01:49:19 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD4310558
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 22:49:06 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id fz16-20020a17090b025000b002269d6c2d83so3227675pjb.0
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 22:49:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=edgeble-ai.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v6oPssMQRYRXIYCOfMp0bkJRvG7DgiHOFHZTd1dGl0E=;
        b=Ie7iNftIr1QUxuimLann2hOzWgGdQRi29/xAeDcLQWDXd2OPzSnJMNox5qtKpj7gWJ
         UqUhfEOD/RidpZqWzu2J77YeDjJFV3YJ2mXLDeMVSlcWmwIydyucxiAlFs2cBKLlYsHh
         sFKcL4c7Wq2S4SxWCMkVLiPZuVsE1ItLIAluFxcdl34xW54zqNyg0zxqAp7hGd2fkPBM
         OzI5O+/qqIYMFMGkXZU2c0suW7B0HR2Dl8kM162w96wWvYf+FLwgwXzqz+rTNwVgutCz
         8X/VXY5SD4ijNNWdPR5vAl2W5DIjIhqJ5d5grzGggKm3/9doqzDgQLRjY3ckWjFMani8
         2CEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v6oPssMQRYRXIYCOfMp0bkJRvG7DgiHOFHZTd1dGl0E=;
        b=N8PnU5AnEmQl7bTzng3opzPM9HHn80CIMytt8w8aPd5bKLOZsEtvseLCsY0kHYbPvl
         uh2W0nU2tfGXVxAHcHsbrYDRfjDWAK8x9h5vUpM8Awdgv7DuDUkxdhkBpeSsy6DZWj4G
         m0AaoZwglAiU406MF0qlDjUS9o3MNNE8kfSrLbbZIIizL1WUwi4feKKbXRFL/f4MSavi
         T/RasYm7QMgev9uWixtz14/LOIf6shVTEt1IUbXhDtx5p+jpVZFpiuEyQ4/mSYCWg9Zl
         7VaeKHUhcINbIDJYrSRj0fBR+qzTOo4lE8evA/ssUNLusE113HfGwCq0S8a7/m5nvb75
         3RTw==
X-Gm-Message-State: AFqh2kqw0SsH5S3VKi28qZL0KsdiXNz0me4u4ekt4Feq2SvhzK7pfv22
        Zb9wLoRu/q2jP2gWoyABvdKzMg==
X-Google-Smtp-Source: AMrXdXvD28Q1bpjA2TAUIObCBGuW6pqghWR4+QjFqarx4Hf7Lggo09ttNj/cyct8l1yB315Yy/LFAQ==
X-Received: by 2002:a05:6a20:c183:b0:a4:526a:3f25 with SMTP id bg3-20020a056a20c18300b000a4526a3f25mr90205897pzb.44.1673419746404;
        Tue, 10 Jan 2023 22:49:06 -0800 (PST)
Received: from archl-hc1b.. ([45.112.3.15])
        by smtp.gmail.com with ESMTPSA id m2-20020a170902db0200b001930e89f5f6sm9301861plx.98.2023.01.10.22.49.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 22:49:05 -0800 (PST)
From:   Anand Moon <anand@edgeble.ai>
To:     Heiko Stuebner <heiko@sntech.de>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Johan Jonker <jbx6244@gmail.com>, Anand Moon <anand@edgeble.ai>,
        Jagan Teki <jagan@edgeble.ai>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCHv4 linux-next 3/4] Rockchip RV1126 has GMAC 10/100/1000M ethernet controller
Date:   Wed, 11 Jan 2023 06:48:38 +0000
Message-Id: <20230111064842.5322-3-anand@edgeble.ai>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230111064842.5322-1-anand@edgeble.ai>
References: <20230111064842.5322-1-anand@edgeble.ai>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Ethernet GMAC node for RV1126 SoC.

Signed-off-by: Anand Moon <anand@edgeble.ai>
Signed-off-by: Jagan Teki <jagan@edgeble.ai>
---
v4: sort the node as reg adds. update the commit message.
v3: drop the gmac_clkin_m0 & gmac_clkin_m1 fix clock node which are not
    used, Add SoB of Jagan Teki.
v2: drop SoB of Jagan Teki.
---
 arch/arm/boot/dts/rv1126.dtsi | 49 +++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/arch/arm/boot/dts/rv1126.dtsi b/arch/arm/boot/dts/rv1126.dtsi
index 1cb43147e90b..1f07d0a4fa73 100644
--- a/arch/arm/boot/dts/rv1126.dtsi
+++ b/arch/arm/boot/dts/rv1126.dtsi
@@ -332,6 +332,55 @@ timer0: timer@ff660000 {
 		clock-names = "pclk", "timer";
 	};
 
+	gmac: ethernet@ffc40000 {
+		compatible = "rockchip,rv1126-gmac", "snps,dwmac-4.20a";
+		reg = <0xffc40000 0x4000>;
+		interrupts = <GIC_SPI 95 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 96 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "macirq", "eth_wake_irq";
+		rockchip,grf = <&grf>;
+		clocks = <&cru CLK_GMAC_SRC>, <&cru CLK_GMAC_TX_RX>,
+			 <&cru CLK_GMAC_TX_RX>, <&cru CLK_GMAC_REF>,
+			 <&cru ACLK_GMAC>, <&cru PCLK_GMAC>,
+			 <&cru CLK_GMAC_TX_RX>, <&cru CLK_GMAC_PTPREF>;
+		clock-names = "stmmaceth", "mac_clk_rx",
+			      "mac_clk_tx", "clk_mac_ref",
+			      "aclk_mac", "pclk_mac",
+			      "clk_mac_speed", "ptp_ref";
+		resets = <&cru SRST_GMAC_A>;
+		reset-names = "stmmaceth";
+
+		snps,mixed-burst;
+		snps,tso;
+
+		snps,axi-config = <&stmmac_axi_setup>;
+		snps,mtl-rx-config = <&mtl_rx_setup>;
+		snps,mtl-tx-config = <&mtl_tx_setup>;
+		status = "disabled";
+
+		mdio: mdio {
+			compatible = "snps,dwmac-mdio";
+			#address-cells = <0x1>;
+			#size-cells = <0x0>;
+		};
+
+		stmmac_axi_setup: stmmac-axi-config {
+			snps,wr_osr_lmt = <4>;
+			snps,rd_osr_lmt = <8>;
+			snps,blen = <0 0 0 0 16 8 4>;
+		};
+
+		mtl_rx_setup: rx-queues-config {
+			snps,rx-queues-to-use = <1>;
+			queue0 {};
+		};
+
+		mtl_tx_setup: tx-queues-config {
+			snps,tx-queues-to-use = <1>;
+			queue0 {};
+		};
+	};
+
 	emmc: mmc@ffc50000 {
 		compatible = "rockchip,rv1126-dw-mshc", "rockchip,rk3288-dw-mshc";
 		reg = <0xffc50000 0x4000>;
-- 
2.39.0

