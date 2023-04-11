Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75CC6DE579
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 22:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbjDKUHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 16:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjDKUHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 16:07:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66A35BBA
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 13:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681243528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QM/JDn6zIGqyihwEr6VtdCtu+tgT+kE/dI0xjSGrnCs=;
        b=B54gEAMBPN157b40CA8fqOHfKOdXwgxrpNPF5GJ8HCwzeJXlCnBlTukeqJpgAGnuiW/ubb
        x2cM4jeySR7sqhGoWfkaRdK7QnRhR0jqaZgjXYYPQSuaGUA8Yz0/urRvpSuSa0wM/ZlynK
        dzCsTnYloi80UruHUh7cMC25PHtL/os=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-nzxpOIXTP7icFdsWmgVPcA-1; Tue, 11 Apr 2023 16:05:27 -0400
X-MC-Unique: nzxpOIXTP7icFdsWmgVPcA-1
Received: by mail-oi1-f197.google.com with SMTP id by13-20020a056808340d00b00388734df7e8so2582908oib.15
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 13:05:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681243526;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QM/JDn6zIGqyihwEr6VtdCtu+tgT+kE/dI0xjSGrnCs=;
        b=oowKfrhdvfMxOm3PFvzldByFLDa1jNY4vITmiH53cW3OSchhEj7A96mbcXO/184IMO
         eMgQ+5w+SceYzjpgma8OJThFiCoSIP4MaQeM97rlU1qXMke6uR/ASpnkc33PxPa0QW9N
         FmSG7gEGgvfaN5MdqJcXKWmMCDcuQnHWk93CE2YsumhxVo1yffw7IvgmCwxNUNwgiRr4
         YZqMDz3a4apgxPjfNc7xL9xT52z3TBSGgf94Z8zinOLXU0bfI76hD9Dy5pV77JA4pK+U
         InnyEipPik9nlM/V2Y0nAWWQ7K8YS/BohZQ6L+Xm1eeS9oNImHEDG1fHg7OdvOFYVsnT
         9I5A==
X-Gm-Message-State: AAQBX9ccvbUgHCupFW+mALct/9zDlraW1z20J2U9gb9hevWvPFN4EYek
        hu5kE3IKMkxn3XdHpr+CPi5mDSrr69eKM1z4Butcn9c5dMC9IpKbOV1/hZcA9QNI/mNxC52RWq9
        IcMv19xmP36hzSbIm
X-Received: by 2002:aca:2316:0:b0:386:d4f7:6774 with SMTP id e22-20020aca2316000000b00386d4f76774mr1543991oie.37.1681243526115;
        Tue, 11 Apr 2023 13:05:26 -0700 (PDT)
X-Google-Smtp-Source: AKy350Z1td8m+pbS6VB16njtuvKIZOhEXboNsDvHucA6mRo2DZOE2mD1bKXLzpnPYcZ6w6Mo4TPSrg==
X-Received: by 2002:aca:2316:0:b0:386:d4f7:6774 with SMTP id e22-20020aca2316000000b00386d4f76774mr1543980oie.37.1681243525830;
        Tue, 11 Apr 2023 13:05:25 -0700 (PDT)
Received: from halaney-x13s.attlocal.net (104-53-165-62.lightspeed.stlsmo.sbcglobal.net. [104.53.165.62])
        by smtp.gmail.com with ESMTPSA id e20-20020a056808149400b00387764759a3sm5868545oiw.24.2023.04.11.13.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 13:05:25 -0700 (PDT)
From:   Andrew Halaney <ahalaney@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, vkoul@kernel.org,
        bhupesh.sharma@linaro.org, wens@csie.org, jernej.skrabec@gmail.com,
        samuel@sholland.org, mturquette@baylibre.com,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        richardcochran@gmail.com, linux@armlinux.org.uk, veekhee@apple.com,
        tee.min.tan@linux.intel.com, mohammad.athari.ismail@intel.com,
        jonathanh@nvidia.com, ruppala@nvidia.com, bmasney@redhat.com,
        andrey.konovalov@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, ncai@quicinc.com,
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com, echanude@redhat.com,
        Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH net-next v4 11/12] net: stmmac: dwmac-qcom-ethqos: Use loopback_en for all speeds
Date:   Tue, 11 Apr 2023 15:04:08 -0500
Message-Id: <20230411200409.455355-12-ahalaney@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230411200409.455355-1-ahalaney@redhat.com>
References: <20230411200409.455355-1-ahalaney@redhat.com>
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

Changes since v2/v3:
    * None

Changes since v1:
    * Use a consistent subject prefix with other stmmac changes in series (myself)

 .../stmicro/stmmac/dwmac-qcom-ethqos.c        | 36 +++++++++----------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
index abec6dd27992..ec9e93147716 100644
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
 	int phase_shift;
 	int phy_mode;
+	int loopback;
 
 	/* Determine if the PHY adds a 2 ns TX delay or the MAC handles it */
 	phy_mode = device_get_phy_mode(&ethqos->pdev->dev);
@@ -294,6 +295,12 @@ static int ethqos_rgmii_macro_init(struct qcom_ethqos *ethqos)
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
@@ -326,12 +333,8 @@ static int ethqos_rgmii_macro_init(struct qcom_ethqos *ethqos)
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
@@ -363,13 +366,8 @@ static int ethqos_rgmii_macro_init(struct qcom_ethqos *ethqos)
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
@@ -403,7 +401,7 @@ static int ethqos_rgmii_macro_init(struct qcom_ethqos *ethqos)
 			      SDCC_DDR_CONFIG_EXT_PRG_RCLK_DLY_EN,
 			      SDCC_HC_REG_DDR_CONFIG);
 		rgmii_updatel(ethqos, RGMII_CONFIG_LOOPBACK_EN,
-			      RGMII_CONFIG_LOOPBACK_EN, RGMII_IO_MACRO_CONFIG);
+			      loopback, RGMII_IO_MACRO_CONFIG);
 		break;
 	default:
 		dev_err(&ethqos->pdev->dev,
@@ -548,7 +546,7 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 	data = of_device_get_match_data(&pdev->dev);
 	ethqos->por = data->por;
 	ethqos->num_por = data->num_por;
-	ethqos->rgmii_config_looback_en = data->rgmii_config_looback_en;
+	ethqos->rgmii_config_loopback_en = data->rgmii_config_loopback_en;
 
 	ethqos->rgmii_clk = devm_clk_get(&pdev->dev, "rgmii");
 	if (IS_ERR(ethqos->rgmii_clk)) {
-- 
2.39.2

