Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBA7268CEF8
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 06:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbjBGF26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 00:28:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbjBGF2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 00:28:53 -0500
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C5A2412B
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 21:28:39 -0800 (PST)
Received: by mail-oo1-xc32.google.com with SMTP id r192-20020a4a37c9000000b00517677496d0so1322406oor.13
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 21:28:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kali.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gd4sYDNe6UVOrg+q9jpwoTsY9NpzBuVI5nXxucyMsZw=;
        b=EDW35YE/XRTMMUEDQNybDT4BzNWrzrsr6SEz8tih38Ww92U1TfwKe9dIJCgF5AsHNI
         yYOeV9usgnONpu2u8IDgVQaTstSn2T8OFHFGWT7O4PzdWe7xtbLaKznmXfywTOZJL7P8
         N6ezM9J47wm/eLLMb2+V5BzFArqzpN5nHU6t+Vw/JvyZ8D15v7Bl/65Q2ZBG+PC2mEfS
         8I6Okf+ly3oPRxnIQxYiasmtk1BTthtmWAyomqLON1LCh3YPCVa+3zZRdUO/sqnTz0eE
         taMpP3Yd/WRtUcW14zTV69y15MLbvSK+zfnsr+NWfoiBtQTnxyrBlG1lFvpI+r7/8SrN
         Z5CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gd4sYDNe6UVOrg+q9jpwoTsY9NpzBuVI5nXxucyMsZw=;
        b=RhDlOOSg13R45vvRH+56Bo7fGSQIDzjHU0fqkGyFK8tttAgqTEy7PRVRVOuVfLB9zz
         W1DGU5bsknCFmBjjqB/QVUh18F6IbEslkttbAhU6I41IjE8fri8jPWZaRQjpwF9KEuI/
         yFa1Lqf428wpdyv3saasbac6gRAKjp002m6YhTKkfWxdyONqI4YTRKdKOM7O41tHXPzN
         phUbmeAvCEjDvljpN/VPnXqS9xnnQr7cWFLb3CjWs5pD+d7UXFFBVWirJXHcdlS+kYZb
         oWaetuwkSBS6/Arjr+xVDj/IR0lv3c8PvygYvmXM2d1M6T9twQJOpQ+8N9cY/2+PLY6/
         lcpw==
X-Gm-Message-State: AO0yUKUKmTT1WSwrWDELpgc6QBTzHLRUBTjLpM4rEDMuN/aR3HNtMhTV
        9z8CDRcC1WsLB6q5C6AmCA5seCGFHQUWhWZJSL8=
X-Google-Smtp-Source: AK7set9Uy3D004ifBj8bxCumSdcCXKbgivSVVGaqxQArAm5s+JDPXWj34hs2WLgu1SHb2En8zit28g==
X-Received: by 2002:a4a:88c5:0:b0:51a:be3:bcff with SMTP id q5-20020a4a88c5000000b0051a0be3bcffmr955384ooh.7.1675747719599;
        Mon, 06 Feb 2023 21:28:39 -0800 (PST)
Received: from localhost (23-118-233-243.lightspeed.snantx.sbcglobal.net. [23.118.233.243])
        by smtp.gmail.com with ESMTPSA id l14-20020a4ae38e000000b004a0ad937ccdsm581478oov.1.2023.02.06.21.28.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 21:28:39 -0800 (PST)
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
Subject: [PATCH v4 4/4] arm64: dts: qcom: thinkpad-x13s: Add bluetooth
Date:   Mon,  6 Feb 2023 23:28:29 -0600
Message-Id: <20230207052829.3996-5-steev@kali.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230207052829.3996-1-steev@kali.org>
References: <20230207052829.3996-1-steev@kali.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Lenovo Thinkpad X13s has a WCN6855 Bluetooth controller on uart2,
add this.

Signed-off-by: Steev Klimaszewski <steev@kali.org>
---

Changes since v3:
 * Add vreg_s1c
 * Add regulators and not dead code
 * Fix commit message changelog

Changes since v2:
 * Remove dead code and add TODO comment
 * Make dtbs_check happy with the pin definitions
---
 .../qcom/sc8280xp-lenovo-thinkpad-x13s.dts    | 76 +++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
index f936b020a71d..8e3c6524e7c6 100644
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
@@ -297,6 +299,14 @@ pmc8280c-rpmh-regulators {
 		qcom,pmic-id = "c";
 		vdd-bob-supply = <&vreg_vph_pwr>;
 
+		vreg_s1c: smps1 {
+			regulator-name = "vreg_s1c";
+			regulator-min-microvolt = <1880000>;
+			regulator-max-microvolt = <1900000>;
+			regulator-allowed-modes = <RPMH_REGULATOR_MODE_AUTO>;
+			regulator-allow-set-load;
+		};
+
 		vreg_l1c: ldo1 {
 			regulator-name = "vreg_l1c";
 			regulator-min-microvolt = <1800000>;
@@ -712,6 +722,32 @@ &qup0 {
 	status = "okay";
 };
 
+&uart2 {
+	status = "okay";
+
+	pinctrl-names = "default";
+	pinctrl-0 = <&uart2_state>;
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
+		pinctrl-names = "default";
+		pinctrl-0 = <&bt_en>;
+	};
+};
+
 &qup1 {
 	status = "okay";
 };
@@ -720,6 +756,12 @@ &qup2 {
 	status = "okay";
 };
 
+&uart17 {
+	compatible = "qcom,geni-debug-uart";
+
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
2.39.0

