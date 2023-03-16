Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA2466BC4E2
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 04:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbjCPDsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 23:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbjCPDsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 23:48:07 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A43968EF
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 20:48:04 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id r36so486571oiw.7
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 20:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kali.org; s=google; t=1678938483;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uSyY7SlxR+d84L0jXxMQtH7pmSAq+VT5JxJ+jNGX7FU=;
        b=eaSeh4CySnPOLGf6gcfkpmK/Jktgq0OSAW3Dh43Aop/NSXjC90fCvB1KhwoIFrpsjD
         UCnBq6zdffMtcKzR5FKAjZoFbaO41KHmfwEe9cKqZunwgzaQSnhoceSlrP0+I4eiftKc
         7MbYpWQDVd3kXMfzdnWa/n4JcliShxajPHB0CJxRK+qC9Ye4d/E8ng0DoP2L6gVIkypO
         Jh/YpBWWzHCopNcXvOFfYiF0YcIOMFI+FoI5Hd5G3eGEeDbOra0oX405iDmSzOirzriE
         V4N0nR82Qspyecdefxpr0j+x1AeynhdhtH44nxBkADldapWv3CoTgAAzEU8qYuSaVnQO
         GsIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678938483;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uSyY7SlxR+d84L0jXxMQtH7pmSAq+VT5JxJ+jNGX7FU=;
        b=EjWOvL4rUV4RGQTAO1ivH8VPLw9QlTq+BiOas2KRAcf7bCq4cr9ARCJQs0dqTVkaZD
         8CM2SSzNlW404npeuHvlkvQuVlJYj97x+7/OGJXhQJ9LDZ1KOlcV6egDmsHAo7BTF8WT
         V24sM1KbKjOAikl44zW+RAEoVdTCitEOStDGy0C07cn7rmaSRlRZU5wHt1HcEswsPivs
         QzhPRjiV4kF76P7qH0euelUNPVo481xFxX6TUzrHtBV7ww9a8M5CaRap6SNj9Z/HJTEu
         mDbNdQxNhM+wzgzCJaw4xydXcgPPRDWVU5VhkMhm5aFVtILNLcZMu/2E5wAfxMVYWYN0
         1U3g==
X-Gm-Message-State: AO0yUKU86WgnO7zFYDgd08dIlkDTk2tyIPNGZy7k7MEW2NvejtqIcSZS
        vQ+lAm5Lv0EW4GBw1RL9FBvOYw==
X-Google-Smtp-Source: AK7set/B/ajB1IRxk4NqijKMiZ25OO6/ja2AyMaJtRNcebAoxd/wxZrsALENGadnZv5tV07G4FtCGw==
X-Received: by 2002:a05:6808:20a:b0:37f:acd5:20ff with SMTP id l10-20020a056808020a00b0037facd520ffmr2385249oie.43.1678938483718;
        Wed, 15 Mar 2023 20:48:03 -0700 (PDT)
Received: from localhost (23-118-233-243.lightspeed.snantx.sbcglobal.net. [23.118.233.243])
        by smtp.gmail.com with ESMTPSA id p189-20020acad8c6000000b0037fa035f4f3sm2922348oig.53.2023.03.15.20.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 20:48:03 -0700 (PDT)
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
        Mark Pearson <markpearson@lenovo.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v6 1/4] dt-bindings: net: Add WCN6855 Bluetooth
Date:   Wed, 15 Mar 2023 22:47:55 -0500
Message-Id: <20230316034759.73489-2-steev@kali.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230316034759.73489-1-steev@kali.org>
References: <20230316034759.73489-1-steev@kali.org>
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

Add bindings for the QTI WCN6855 chipset.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Steev Klimaszewski <steev@kali.org>
---
Changes since v5:
 * None

 .../net/bluetooth/qualcomm-bluetooth.yaml       | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/bluetooth/qualcomm-bluetooth.yaml b/Documentation/devicetree/bindings/net/bluetooth/qualcomm-bluetooth.yaml
index a6a6b0e4df7a..68f78b90d23a 100644
--- a/Documentation/devicetree/bindings/net/bluetooth/qualcomm-bluetooth.yaml
+++ b/Documentation/devicetree/bindings/net/bluetooth/qualcomm-bluetooth.yaml
@@ -23,6 +23,7 @@ properties:
       - qcom,wcn3998-bt
       - qcom,qca6390-bt
       - qcom,wcn6750-bt
+      - qcom,wcn6855-bt
 
   enable-gpios:
     maxItems: 1
@@ -133,6 +134,22 @@ allOf:
         - vddrfa1p7-supply
         - vddrfa1p2-supply
         - vddasd-supply
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - qcom,wcn6855-bt
+    then:
+      required:
+        - enable-gpios
+        - swctrl-gpios
+        - vddio-supply
+        - vddbtcxmx-supply
+        - vddrfacmn-supply
+        - vddrfa0p8-supply
+        - vddrfa1p2-supply
+        - vddrfa1p7-supply
 
 examples:
   - |
-- 
2.39.2

