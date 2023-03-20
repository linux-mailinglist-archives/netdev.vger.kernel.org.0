Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 049FC6C24A5
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 23:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbjCTWT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 18:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbjCTWSj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 18:18:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498AD366A1
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 15:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679350639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MuxRwUN7QuGJgCb1sgNXeyD5mGPP+IwVPMi41UhPJrI=;
        b=V3UHwHjnGa10y7FVQWMkzU0QeWlDsjmIgRO+/oTakBvs7ShpxjqnVVG2fWrkmhytMbj0Ol
        6mbzL8v96BrsTQQjrgpHeXNmjXHHApi87T04vxStOtSI9HVfYKHIV0GbB2A06+xJQzzJt3
        b3tZejNMBTGpGc5mup7+0AVamdMxUFY=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-328-EE16JJNwNvWBoj-NLn6CFg-1; Mon, 20 Mar 2023 18:17:17 -0400
X-MC-Unique: EE16JJNwNvWBoj-NLn6CFg-1
Received: by mail-oo1-f72.google.com with SMTP id o191-20020a4a2cc8000000b0053ad135ccb3so2071579ooo.16
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 15:17:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679350637;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MuxRwUN7QuGJgCb1sgNXeyD5mGPP+IwVPMi41UhPJrI=;
        b=B1TFhPwpYRYv8yMp7b3Wp9ue2n4Qjtn2HJ833sojkbidHmD/XQg59brGEbhHGAcAtq
         X0FDBZQWkz3p1BZC0e+OE77A/jmYt5HRFd8sRz7HaBwu6P9oFWeWRAdMiB0ziTZZ++Qg
         KZlMFgOrXJvFq02ROjlPAby37R3V8r9pViz72fo7x+fPdHScjviAddEOXcXXkTENKLbn
         pwlm5BfLdhzcFznRIQOYbORahOq7FUTdkqACJlxztCIwtKuVYhxUfUyLq/p6d6l5AoXU
         HzY/9YD0X18WU8Mpd4XIDa3B59pLWXi38fXHi+vyyQmmC0cPNFdcUF9bqr6YjZ/OaPrX
         Nh0Q==
X-Gm-Message-State: AO0yUKWK0l3XuVXgNqtmBQFg/8ujaVdb6wygV5NzeIxEfVA0c72wQ7/V
        w/Q9mHphbsWaTwqcNPu8KfGSMNaSN5jwdKywXz70YuXzxpmv2WYC7T9E5WgT2dWpwnNvxy3gTt+
        bPbRGGdY1qJfBp4VO
X-Received: by 2002:a9d:7315:0:b0:693:c9f9:64ab with SMTP id e21-20020a9d7315000000b00693c9f964abmr160597otk.3.1679350637056;
        Mon, 20 Mar 2023 15:17:17 -0700 (PDT)
X-Google-Smtp-Source: AK7set98Og6GyTgodqKCDDtTyRzUmO/nuo0gcym2TARwdc/GXk398TERm6JpLQcmViXh/KUjabkepA==
X-Received: by 2002:a9d:7315:0:b0:693:c9f9:64ab with SMTP id e21-20020a9d7315000000b00693c9f964abmr160571otk.3.1679350636869;
        Mon, 20 Mar 2023 15:17:16 -0700 (PDT)
Received: from halaney-x13s.redhat.com (104-53-165-62.lightspeed.stlsmo.sbcglobal.net. [104.53.165.62])
        by smtp.gmail.com with ESMTPSA id q204-20020a4a33d5000000b0053853156b5csm4092465ooq.8.2023.03.20.15.17.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 15:17:16 -0700 (PDT)
From:   Andrew Halaney <ahalaney@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, vkoul@kernel.org,
        bhupesh.sharma@linaro.org, mturquette@baylibre.com,
        sboyd@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, richardcochran@gmail.com,
        linux@armlinux.org.uk, veekhee@apple.com,
        tee.min.tan@linux.intel.com, mohammad.athari.ismail@intel.com,
        jonathanh@nvidia.com, ruppala@nvidia.com, bmasney@redhat.com,
        andrey.konovalov@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-clk@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, ncai@quicinc.com,
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com, echanude@redhat.com,
        Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH net-next v2 11/12] net: stmmac: dwmac-qcom-ethqos: Use loopback_en for all speeds
Date:   Mon, 20 Mar 2023 17:16:16 -0500
Message-Id: <20230320221617.236323-12-ahalaney@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320221617.236323-1-ahalaney@redhat.com>
References: <20230320221617.236323-1-ahalaney@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It seems that this variable should be used for all speeds, not just
1000/100.

While at it refactor it slightly to be more readable, including fixing
the typo in the variable name.

Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---

Changes since v1:
	* Use a consistent subject prefix with other stmmac changes in series (myself)

 .../stmicro/stmmac/dwmac-qcom-ethqos.c        | 36 +++++++++----------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
index e89937916741..41e6f4fa92f3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -78,7 +78,7 @@ struct ethqos_emac_por {
 struct ethqos_emac_driver_data {
 	const struct ethqos_emac_por *por;
 	unsigned int num_por;
-	bool rgmii_config_looback_en;
+	bool rgmii_config_loopback_en;
 };
 
 struct qcom_ethqos {
@@ -91,7 +91,7 @@ struct qcom_ethqos {
 
 	const struct ethqos_emac_por *por;
 	unsigned int num_por;
-	bool rgmii_config_looback_en;
+	bool rgmii_config_loopback_en;
 };
 
 static int rgmii_readl(struct qcom_ethqos *ethqos, unsigned int offset)
@@ -183,7 +183,7 @@ static const struct ethqos_emac_por emac_v2_3_0_por[] = {
 static const struct ethqos_emac_driver_data emac_v2_3_0_data = {
 	.por = emac_v2_3_0_por,
 	.num_por = ARRAY_SIZE(emac_v2_3_0_por),
-	.rgmii_config_looback_en = true,
+	.rgmii_config_loopback_en = true,
 };
 
 static const struct ethqos_emac_por emac_v2_1_0_por[] = {
@@ -198,7 +198,7 @@ static const struct ethqos_emac_por emac_v2_1_0_por[] = {
 static const struct ethqos_emac_driver_data emac_v2_1_0_data = {
 	.por = emac_v2_1_0_por,
 	.num_por = ARRAY_SIZE(emac_v2_1_0_por),
-	.rgmii_config_looback_en = false,
+	.rgmii_config_loopback_en = false,
 };
 
 static int ethqos_dll_configure(struct qcom_ethqos *ethqos)
@@ -281,6 +281,7 @@ static int ethqos_rgmii_macro_init(struct qcom_ethqos *ethqos)
 {
 	int phy_mode;
 	int phase_shift;
+	int loopback;
 
 	/* Determine if the PHY adds a 2 ns TX delay or the MAC handles it */
 	phy_mode = device_get_phy_mode(&ethqos->pdev->dev);
@@ -293,6 +294,12 @@ static int ethqos_rgmii_macro_init(struct qcom_ethqos *ethqos)
 	rgmii_updatel(ethqos, RGMII_CONFIG2_TX_TO_RX_LOOPBACK_EN,
 		      0, RGMII_IO_MACRO_CONFIG2);
 
+	/* Determine if this platform wants loopback enabled after programming */
+	if (ethqos->rgmii_config_loopback_en)
+		loopback = RGMII_CONFIG_LOOPBACK_EN;
+	else
+		loopback = 0;
+
 	/* Select RGMII, write 0 to interface select */
 	rgmii_updatel(ethqos, RGMII_CONFIG_INTF_SEL,
 		      0, RGMII_IO_MACRO_CONFIG);
@@ -325,12 +332,8 @@ static int ethqos_rgmii_macro_init(struct qcom_ethqos *ethqos)
 		rgmii_updatel(ethqos, SDCC_DDR_CONFIG_PRG_DLY_EN,
 			      SDCC_DDR_CONFIG_PRG_DLY_EN,
 			      SDCC_HC_REG_DDR_CONFIG);
-		if (ethqos->rgmii_config_looback_en)
-			rgmii_updatel(ethqos, RGMII_CONFIG_LOOPBACK_EN,
-				      RGMII_CONFIG_LOOPBACK_EN, RGMII_IO_MACRO_CONFIG);
-		else
-			rgmii_updatel(ethqos, RGMII_CONFIG_LOOPBACK_EN,
-				      0, RGMII_IO_MACRO_CONFIG);
+		rgmii_updatel(ethqos, RGMII_CONFIG_LOOPBACK_EN,
+			      loopback, RGMII_IO_MACRO_CONFIG);
 		break;
 
 	case SPEED_100:
@@ -362,13 +365,8 @@ static int ethqos_rgmii_macro_init(struct qcom_ethqos *ethqos)
 		rgmii_updatel(ethqos, SDCC_DDR_CONFIG_EXT_PRG_RCLK_DLY_EN,
 			      SDCC_DDR_CONFIG_EXT_PRG_RCLK_DLY_EN,
 			      SDCC_HC_REG_DDR_CONFIG);
-		if (ethqos->rgmii_config_looback_en)
-			rgmii_updatel(ethqos, RGMII_CONFIG_LOOPBACK_EN,
-				      RGMII_CONFIG_LOOPBACK_EN, RGMII_IO_MACRO_CONFIG);
-		else
-			rgmii_updatel(ethqos, RGMII_CONFIG_LOOPBACK_EN,
-				      0, RGMII_IO_MACRO_CONFIG);
-
+		rgmii_updatel(ethqos, RGMII_CONFIG_LOOPBACK_EN,
+			      loopback, RGMII_IO_MACRO_CONFIG);
 		break;
 
 	case SPEED_10:
@@ -402,7 +400,7 @@ static int ethqos_rgmii_macro_init(struct qcom_ethqos *ethqos)
 			      SDCC_DDR_CONFIG_EXT_PRG_RCLK_DLY_EN,
 			      SDCC_HC_REG_DDR_CONFIG);
 		rgmii_updatel(ethqos, RGMII_CONFIG_LOOPBACK_EN,
-			      RGMII_CONFIG_LOOPBACK_EN, RGMII_IO_MACRO_CONFIG);
+			      loopback, RGMII_IO_MACRO_CONFIG);
 		break;
 	default:
 		dev_err(&ethqos->pdev->dev,
@@ -547,7 +545,7 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 	data = of_device_get_match_data(&pdev->dev);
 	ethqos->por = data->por;
 	ethqos->num_por = data->num_por;
-	ethqos->rgmii_config_looback_en = data->rgmii_config_looback_en;
+	ethqos->rgmii_config_loopback_en = data->rgmii_config_loopback_en;
 
 	ethqos->rgmii_clk = devm_clk_get(&pdev->dev, "rgmii");
 	if (IS_ERR(ethqos->rgmii_clk)) {
-- 
2.39.2

