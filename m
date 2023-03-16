Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7A266BC4E8
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 04:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbjCPDsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 23:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbjCPDsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 23:48:11 -0400
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA7D95E18
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 20:48:08 -0700 (PDT)
Received: by mail-oo1-xc33.google.com with SMTP id e12-20020a4ada0c000000b0052cdbbdc803so56757oou.2
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 20:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kali.org; s=google; t=1678938488;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P5k0MpROYmNIFyhNt58/vZyAcXOPLCZ4HfbC8v8vSu0=;
        b=gHp306H1ws67pGCjAxqVeEjgRcm58bI99uENR3NItKXv0zmq88SfsKKg2aRPUKc3d6
         9W4OdskUgLbL2KCae+aSrPmZZLuBnQRgFfwxCgrpn5//O6A9FUwOnRf9uHyIIZtPxlrV
         0WtQTAyIdNc4wZmByJUYdt75sJFUQcW3d0OqL3iLmuPkKCK2ChZl+PoB0G2O8NQjDTMQ
         U13IxYpAHmSO6cD/aJhzLZ8uwjWOQUFHxkI5tET3124eKn6JWpWBjGeKXxMU0ll6Jo8w
         FzAXFcq+i1BqED7RM3Cgg5oLkejUm6uZ0rw8tjzjGE++VFUsGDGptD9OXDMi+3rHgi6M
         f0CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678938488;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P5k0MpROYmNIFyhNt58/vZyAcXOPLCZ4HfbC8v8vSu0=;
        b=S4cK540pwiZmVTZkH1O7yrE0qaDlfgjEzDLnpFqjrFWBaGf3SVjowuZ0V3QWgs24Pz
         k3TjRVQrKsZvz33TFkC/HoN+WX5xTh1f8Vy7FxE3VGYICRTYBON/6X9HlVYaSQzesNpW
         dEm7VWk6LiesgLsDVjTm/qg9C6auE0hge/ANz7iEXASZ3sxdo0KoWeKL9enInhUB5um3
         3zQUDS8YDH9GQVTztjc/Smso3tlOsdu+6ZcfK34lL3LIMppnzvJxVvygtyr2sr4EUNg2
         5vhmgpZiGPzBwn933lY+G8Yqina0J5KZpSjHh3q9lOVe98vpmB8oCiO7QQCbDz541vRx
         u23g==
X-Gm-Message-State: AO0yUKXdrF81F2WsHvJ4dOYppaXRrZFBaZ7nYy6HgjEmE89oWeznJH7/
        lq8lJymzUY8oKo4t4dQcTA5Fdg==
X-Google-Smtp-Source: AK7set+qa3GoD52/n0ocIee//zcf0iKMu+e50nhBD6cDh4j19D3Rj0XYV22WozhPzcOW/BOyRrbcsA==
X-Received: by 2002:a05:6820:123:b0:525:2e75:a615 with SMTP id i3-20020a056820012300b005252e75a615mr19291967ood.8.1678938487958;
        Wed, 15 Mar 2023 20:48:07 -0700 (PDT)
Received: from localhost (23-118-233-243.lightspeed.snantx.sbcglobal.net. [23.118.233.243])
        by smtp.gmail.com with ESMTPSA id d188-20020a4a52c5000000b005315e8ca468sm1809064oob.17.2023.03.15.20.48.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 20:48:07 -0700 (PDT)
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
Subject: [PATCH v6 3/4] arm64: dts: qcom: sc8280xp: Define uart2
Date:   Wed, 15 Mar 2023 22:47:57 -0500
Message-Id: <20230316034759.73489-4-steev@kali.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230316034759.73489-1-steev@kali.org>
References: <20230316034759.73489-1-steev@kali.org>
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

From: Bjorn Andersson <bjorn.andersson@linaro.org>

Add the definition for uart2 for sc8280xp devices.

Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Steev Klimaszewski <steev@kali.org>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
---
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
index 86e5ecd6a7b8..37ea05df66a5 100644
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

