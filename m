Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E919662D95
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 18:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237578AbjAIRtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 12:49:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237322AbjAIRrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 12:47:07 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96AC32646
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 09:45:55 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id bn26so9037458wrb.0
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 09:45:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=my6K8WfaV8OBcEHlajm+pAlQLMbwnRAqnVV0EWJPD+M=;
        b=f8546yXbDGBZ2/Cab4AwVn+CY73PZix4rzGPYYVM0ehIlbInz0tsCHofPUAYh4FMfz
         BltT713JgdnrnrSpYZZaYMW07SS2kjKJgPaBIAfjKMWvyBzubdgq99q9ufeDpVO6yEP7
         Z6n1ov4R827R6nW+PaUO2aiuGgb8kcDj+1o2Vu9pq+YqOF3Kow8g4QXdkx4a66zQQuNE
         CmiJ8+Qh1JEnHIv1ek3IfJmvXEh1KCV8T4w25JzOaWGMdK7VEhDpt2UB7Q0MzXZmHGlk
         k4F/+ho6dBz3Dln/Lw3BnRyY6atTXYDrgb17tUy5VOUtBNGFUNqVi7O7UWQTcNypssGe
         cnZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=my6K8WfaV8OBcEHlajm+pAlQLMbwnRAqnVV0EWJPD+M=;
        b=0E3NyAJ0QM/Mrv14XJXbwdIJ6b+CELSgCuskDhUWbyY/CHBARRm+WNG1mVFFYXSFxm
         IYuSQdulZdrhjth6vVNhMtkthoGDG5LSuzs28LDdMduggHdeKWVgq15fzLdEQueHkZL5
         WKM0TV2UMSWMz25Ur1NZEXfAuAEtphKYcLyTNGwmzkRNjM6i0YrKDA5LzcqE1H1PnwCo
         sbOfXg8hBgMtVL00k7GENT0QjoWIfeij9hk0lQMztM/BxnDdCPFZ522Dk2En8rzhybbG
         VAk1ZiEjseFPLXo0J+qwtQqJEgTW5hRhYbqqoU7xtpBAqFGSPjE+L5spw6t1Ql2x76LS
         /s2A==
X-Gm-Message-State: AFqh2kp8npvEOAh7AUKy67DCXtOHi+wXSQM1RIcl+vpWObSvDpeWMHgv
        tH/heJ5gGXVkq92apD7y6LsLTg==
X-Google-Smtp-Source: AMrXdXvl5wsiu+cNpizaVJFWRHQ6Yuw6VrDw/F/LMZCUxOZm7siOcV1jqP2kHD93R/Tca7UPu7QwlA==
X-Received: by 2002:a05:6000:90a:b0:2a2:e87a:b4e1 with SMTP id bz10-20020a056000090a00b002a2e87ab4e1mr13759954wrb.36.1673286355114;
        Mon, 09 Jan 2023 09:45:55 -0800 (PST)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:c88:901e:c74c:8e80])
        by smtp.gmail.com with ESMTPSA id m1-20020a5d6241000000b002bbdaf21744sm6142902wrv.113.2023.01.09.09.45.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 09:45:54 -0800 (PST)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Georgi Djakov <djakov@kernel.org>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Alex Elder <elder@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux.dev, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 17/18] dt-bindings: arm: qcom: document the sa8775p reference board
Date:   Mon,  9 Jan 2023 18:45:10 +0100
Message-Id: <20230109174511.1740856-18-brgl@bgdev.pl>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230109174511.1740856-1-brgl@bgdev.pl>
References: <20230109174511.1740856-1-brgl@bgdev.pl>
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

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Add a new compatible for the sa8775p-ride board.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 Documentation/devicetree/bindings/arm/qcom.yaml | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/qcom.yaml b/Documentation/devicetree/bindings/arm/qcom.yaml
index 27063a045bd0..7490eb0c3e3c 100644
--- a/Documentation/devicetree/bindings/arm/qcom.yaml
+++ b/Documentation/devicetree/bindings/arm/qcom.yaml
@@ -751,6 +751,11 @@ properties:
           - const: qcom,qcs404-evb
           - const: qcom,qcs404
 
+      - items:
+          - enum:
+              - qcom,sa8775p-ride
+          - const: qcom,sa8775p
+
       - items:
           - enum:
               - qcom,sa8155p-adp
-- 
2.37.2

