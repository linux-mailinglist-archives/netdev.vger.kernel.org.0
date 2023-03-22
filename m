Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84CAA6C3F88
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 02:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbjCVBO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 21:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbjCVBOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 21:14:51 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB91452936
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 18:14:48 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id p20-20020a056830319400b0069f914e5c74so1326118ots.3
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 18:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kali.org; s=google; t=1679447688;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aL/N9AV3WhGqQ+Vb9bYix0gGfCvLXKt0K6k2QBL/KxM=;
        b=aJjrv5RzCRlgZ56o2/+n2nWWuZ96bMUoY++1xmdw0KnkyVlj9GTrI6MhJc13w2vKNV
         S6ll7BCqmgfDtSEWnVK/HZapj4kW4jmOxM3qjlt1k9VTas68WF3NeFR/vmeVGxMuzZSx
         idnxS8UB8mO6rhBO0qEKRAIsv+MAUko9PdtIiGxxkkR1vVKmcp0UrUuY1lJU2UFDiDxo
         KWJfsdG3EgQYkdM3Z5TkFo5O+JtqB0chaGqGMSuCIWVq1iykEE7ORAUdPLdQxoYGZ9lg
         mzeyd2ZjQrfxwOT7BBkIxhcsDtSUgy7Uj93EiwZEE6fFF8WSK074s8hIoWxBf8KUqMAm
         BZUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679447688;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aL/N9AV3WhGqQ+Vb9bYix0gGfCvLXKt0K6k2QBL/KxM=;
        b=rauvZ21bggoECkUlDGzQqzOkU02ZE1RJ1xSbrJr2Si0xAtkk2g7IVTWnBoupbGe7x2
         gsubetKlH2xCWxRLMeSYO5OA+Ewh+7r9908pNSoGRZM8aCBnCJvmth0dInqMmWO2Bi0C
         nUz5hrhei7nBxzw9WZ7fWEx1eq1hOfhiVb5OqqrkAszKAg5/asVjJEirNDR213+Ejblx
         CY78nDxK7lj2CpYNtkox8ZANjfCj6VA0Iinna2jlUHZiaag4G4YE5ydJkwfKK3SoD62w
         ///v0OV2dZOhc7kjE/KtqLV9aENbZAkN6e9eZetC1STLKJLyEvSt9rHgQ73rqmkeJTHi
         K/Ow==
X-Gm-Message-State: AO0yUKWeWIDKV1MAgGQCcnn0MCamqAAlgc62XdKWad0DmEBc+OLlQkFX
        KjAWoiWme9zT9Ta8giKU7O5vCQ==
X-Google-Smtp-Source: AK7set9K1MSbCV1ueihm5z69nVjnORAmEu3Xc9pzp+x6xd3F+89wz1dITK3sA8Vnh8KYCZdkJzoDGQ==
X-Received: by 2002:a9d:615a:0:b0:699:221e:b07d with SMTP id c26-20020a9d615a000000b00699221eb07dmr233302otk.11.1679447688094;
        Tue, 21 Mar 2023 18:14:48 -0700 (PDT)
Received: from localhost (23-118-233-243.lightspeed.snantx.sbcglobal.net. [23.118.233.243])
        by smtp.gmail.com with ESMTPSA id o23-20020a9d6d17000000b0069d80ce577asm5778527otp.18.2023.03.21.18.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 18:14:47 -0700 (PDT)
From:   Steev Klimaszewski <steev@kali.org>
To:     Steev Klimaszewski <steev@kali.org>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
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
        Mark Pearson <markpearson@lenovo.com>,
        Brian Masney <bmasney@redhat.com>,
        Johan Hovold <johan+linaro@kernel.org>
Subject: [PATCH v7 3/4] arm64: dts: qcom: sc8280xp: Define uart2
Date:   Tue, 21 Mar 2023 20:14:41 -0500
Message-Id: <20230322011442.34475-4-steev@kali.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322011442.34475-1-steev@kali.org>
References: <20230322011442.34475-1-steev@kali.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

Add the definition for uart2 for sc8280xp devices.

Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Steev Klimaszewski <steev@kali.org>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
---
Changes since v6:
 * No changes

Changes since v5:
 * Add sentence to git commit description.
 * Add Johan's R-b

Changes since v4:
 * None

Changes since v3:
 * Fix commit message changelog

Changes since v2:
 * No changes since v2

Changes since v1:
 * change subject line, move node, and add my s-o-b
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
index 05544a6c1b21..f1d0e8d5edd2 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -1209,6 +1209,20 @@ spi2: spi@988000 {
 				status = "disabled";
 			};
 
+			uart2: serial@988000 {
+				compatible = "qcom,geni-uart";
+				reg = <0 0x00988000 0 0x4000>;
+				clocks = <&gcc GCC_QUPV3_WRAP0_S2_CLK>;
+				clock-names = "se";
+				interrupts = <GIC_SPI 603 IRQ_TYPE_LEVEL_HIGH>;
+				operating-points-v2 = <&qup_opp_table_100mhz>;
+				power-domains = <&rpmhpd SC8280XP_CX>;
+				interconnects = <&clk_virt MASTER_QUP_CORE_0 0 &clk_virt SLAVE_QUP_CORE_0 0>,
+						<&gem_noc MASTER_APPSS_PROC 0 &config_noc SLAVE_QUP_0 0>;
+				interconnect-names = "qup-core", "qup-config";
+				status = "disabled";
+			};
+
 			i2c3: i2c@98c000 {
 				compatible = "qcom,geni-i2c";
 				reg = <0 0x0098c000 0 0x4000>;
-- 
2.39.2

