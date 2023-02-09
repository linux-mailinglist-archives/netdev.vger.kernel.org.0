Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0534C68FCE9
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 03:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbjBICJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 21:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbjBICJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 21:09:31 -0500
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 344DC274B5
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 18:09:25 -0800 (PST)
Received: by mail-qv1-xf2f.google.com with SMTP id d7so492911qvz.3
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 18:09:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kali.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ErEfS9bjsXHZf8zW3eSPIlB6x60rqZJ+hhTJR6OvqGc=;
        b=fjZV9pIdx9EwPU6LiQEp4Di0RywW13a19YPevr0FjfutfFo/SyYbOvgwAmrwEpSiRj
         9kP3ZmTRPSd4sx8NhzFFoLZd7p/bKBzxYwOhPpJfsu9YXpXecb/ohtQwE80BsHvutrBC
         bYl22uNLgi58lw/P/IPyoMcsw4RmbHrJ/bbnMuSyt8axKjfcFcH5KkWBJpBFTIBeIUak
         JfQql1C4u8VBaHzgAUxaFDPNLjafXir4BKMWi9uQ/jZxqTDu/d73ra7suflOvSnKo2X+
         DdnwMiP+LDzFrHeXV4hyeAPbdg3JZYrgm6UuB6CL9HK71MuPOzV320Cw9chxlQ3SHiO2
         MW0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ErEfS9bjsXHZf8zW3eSPIlB6x60rqZJ+hhTJR6OvqGc=;
        b=mhAEIZsopwce6KIZ/1FEcFU802p8nfHuge4m6j1qIVVaF8P8av8RUQIJxWEfKG2mUk
         IKHLW7+BzQZZL8VnPFYyzrsyWuy83JtUyKOEuCnuJTLXtzifCgXu1zj7DTISu6w6Y8xN
         o5RLZj0ho85IJGCTfWUyYXToLrnS+NZCKbd7ffew/meOQJSx2WNVws44uQyzkwqVCzZU
         LHWNkmsK1nacfwtTVaXCSqm8UTIeYyLKhP5nj8Nj7CGJwxKBL7ZiBJSE8aNxZhSt4jah
         guybb+NeWRFqy9+ZbQlvtKZrKpuJbBJ0sjZnJcAJdb8lhg1D2RnMpB9Hf6XzpP5E2sBq
         2G9A==
X-Gm-Message-State: AO0yUKX7cWHqGsiTh3PHNGd0I//AjqZjPLUpEK9NI6AzOjUpgkXKzOQC
        v+pHgWl9NQwHKhYJoleLv9IVQw==
X-Google-Smtp-Source: AK7set8hh8Lu1pnPRIR1M8xWEO62IR7mHbVlghjQdpH418aIHEOCN0LcujGzRFyAhy5HaEClqjiINQ==
X-Received: by 2002:ad4:5b87:0:b0:545:fe7f:437a with SMTP id 7-20020ad45b87000000b00545fe7f437amr13502008qvp.0.1675908564289;
        Wed, 08 Feb 2023 18:09:24 -0800 (PST)
Received: from localhost (23-118-233-243.lightspeed.snantx.sbcglobal.net. [23.118.233.243])
        by smtp.gmail.com with ESMTPSA id o186-20020a37bec3000000b007208a81e11esm398544qkf.41.2023.02.08.18.09.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 18:09:23 -0800 (PST)
From:   Steev Klimaszewski <steev@kali.org>
To:     Steev Klimaszewski <steev@kali.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Sven Peter <sven@svenpeter.dev>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>
Subject: [PATCH v5 4/4] arm64: dts: qcom: thinkpad-x13s: Add bluetooth
Date:   Wed,  8 Feb 2023 20:09:16 -0600
Message-Id: <20230209020916.6475-5-steev@kali.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230209020916.6475-1-steev@kali.org>
References: <20230209020916.6475-1-steev@kali.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Lenovo Thinkpad X13s has a WCN6855 Bluetooth controller on uart2,
add this.

Signed-off-by: Steev Klimaszewski <steev@kali.org>
Link: https://lore.kernel.org/r/20230207052829.3996-5-steev@kali.org
---
Changes since v4:
 * Address Konrad's review comments.

Changes since v3:
 * Add vreg_s1c
 * Add regulators and not dead code
 * Fix commit message changelog

Changes since v2:
 * Remove dead code and add TODO comment
 * Make dtbs_check happy with the pin definitions
 .../qcom/sc8280xp-lenovo-thinkpad-x13s.dts    | 76 +++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
index f936b020a71d..ad20cfb3a830 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
+++ b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
@@ -24,6 +24,8 @@ / {
 	aliases {
 		i2c4 = &i2c4;
 		i2c21 = &i2c21;
+		serial0 = &uart17;
+		serial1 = &uart2;
 	};
 
 	wcd938x: audio-codec {
@@ -297,6 +299,15 @@ pmc8280c-rpmh-regulators {
 		qcom,pmic-id = "c";
 		vdd-bob-supply = <&vreg_vph_pwr>;
 
+		vreg_s1c: smps1 {
+			regulator-name = "vreg_s1c";
+			regulator-min-microvolt = <1880000>;
+			regulator-max-microvolt = <1900000>;
+			regulator-allowed-modes = <RPMH_REGULATOR_MODE_AUTO>,
+						  <RPMH_REGULATOR_MODE_RET>;
+			regulator-allow-set-load;
+		};
+
 		vreg_l1c: ldo1 {
 			regulator-name = "vreg_l1c";
 			regulator-min-microvolt = <1800000>;
@@ -712,6 +723,32 @@ &qup0 {
 	status = "okay";
 };
 
+&uart2 {
+	pinctrl-0 = <&uart2_state>;
+	pinctrl-names = "default";
+
+	status = "okay";
+
+	bluetooth {
+		compatible = "qcom,wcn6855-bt";
+
+		vddio-supply = <&vreg_s10b>;
+		vddbtcxmx-supply = <&vreg_s12b>;
+		vddrfacmn-supply = <&vreg_s12b>;
+		vddrfa0p8-supply = <&vreg_s12b>;
+		vddrfa1p2-supply = <&vreg_s11b>;
+		vddrfa1p7-supply = <&vreg_s1c>;
+
+		max-speed = <3200000>;
+
+		enable-gpios = <&tlmm 133 GPIO_ACTIVE_HIGH>;
+		swctrl-gpios = <&tlmm 132 GPIO_ACTIVE_HIGH>;
+
+		pinctrl-0 = <&bt_en>;
+		pinctrl-names = "default";
+	};
+};
+
 &qup1 {
 	status = "okay";
 };
@@ -720,6 +757,11 @@ &qup2 {
 	status = "okay";
 };
 
+&uart17 {
+	compatible = "qcom,geni-debug-uart";
+	status = "okay";
+};
+
 &remoteproc_adsp {
 	firmware-name = "qcom/sc8280xp/LENOVO/21BX/qcadsp8280.mbn";
 
@@ -980,6 +1022,19 @@ hastings_reg_en: hastings-reg-en-state {
 &tlmm {
 	gpio-reserved-ranges = <70 2>, <74 6>, <83 4>, <125 2>, <128 2>, <154 7>;
 
+	bt_en: bt-en-state {
+		hstp-sw-ctrl-pins {
+			pins = "gpio132";
+			function = "gpio";
+		};
+
+		hstp-bt-en-pins {
+			pins = "gpio133";
+			function = "gpio";
+			drive-strength = <16>;
+		};
+	};
+
 	edp_reg_en: edp-reg-en-state {
 		pins = "gpio25";
 		function = "gpio";
@@ -1001,6 +1056,27 @@ i2c4_default: i2c4-default-state {
 		bias-disable;
 	};
 
+	uart2_state: uart2-state {
+		cts-pins {
+			pins = "gpio122";
+			function = "qup2";
+			bias-disable;
+		};
+
+		rts-tx-pins {
+			pins = "gpio122", "gpio123";
+			function = "qup2";
+			drive-strength = <2>;
+			bias-disable;
+		};
+
+		rx-pins {
+			pins = "gpio124";
+			function = "qup2";
+			bias-pull-up;
+		};
+	};
+
 	i2c21_default: i2c21-default-state {
 		pins = "gpio81", "gpio82";
 		function = "qup21";
-- 
2.39.1

