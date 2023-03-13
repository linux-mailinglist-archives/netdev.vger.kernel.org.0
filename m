Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF7346B7E69
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 17:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbjCMQ7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 12:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbjCMQ7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 12:59:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D404F28D2B
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 09:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678726667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E28u3AC299JmAvjZr4iCran+GZMgF1vAVhXdcyHNMWs=;
        b=M0rnmW8xmTfzi1jnVxU4b4e9UaGXkzrmjfG2V4vxECG4XkClyOePV+0my0dkEHvjhQ7LdI
        56n4QlA8MYuIrUjx+NMpNEG3UcutCQgLYEk3kFO31z8lnqFJMpun+nugKZQYao1rhtFRxP
        CLQaRHmXuPfPFiTVqvoax0b0GQavmBE=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-460-qaLH8XycMMCRFmTWKzs9sA-1; Mon, 13 Mar 2023 12:57:38 -0400
X-MC-Unique: qaLH8XycMMCRFmTWKzs9sA-1
Received: by mail-oo1-f71.google.com with SMTP id d201-20020a4a52d2000000b0051faef7ba52so3547202oob.11
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 09:57:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678726658;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E28u3AC299JmAvjZr4iCran+GZMgF1vAVhXdcyHNMWs=;
        b=OkJuYh0DOEOeTjzmsiAYYvhYoOyI3rVhsF1gsl6/aN50NhDUg+FBdHFfHu4YwJVLQi
         oAaU0dVe7nQVn6DTluHfZUA/NBX+h/dRVlnhki8s2Ucscaz8ZcW1jYtp/t+uGapBhU5w
         kLzuxN0ZUzcX5rBASlPkQfYqeMF4hNkeb3+Cml9UmLAKAzK5TJkZ7IQPyl6jLB6A8op4
         QDsVs8ZrtRJwFSyVIYwNl+HjpX4jdglAjZfAjRD/Cvwi884m6LvrtM7uuZJifkxf+1Pa
         gkYm+QiHu9dvya3y4jJSPHFjOQgSr3J0xPyLmeaYHySDdOsb9MHTKkjkaiIJY0AKJT/G
         /bUw==
X-Gm-Message-State: AO0yUKUbJUR6s4P0B4md8CIO8nlrg4FR7iQFpqIlbZGCHaubN3hwo/Zo
        keos7hziFYlIIIkc/bA3UiNhDC9oXKs2suo1R5LLpB1E/UdwlZgcphwdIWpJey4qB2ftZIta68u
        Tw4nKwctmCHU+KTt/
X-Received: by 2002:a54:4486:0:b0:384:704:9b5c with SMTP id v6-20020a544486000000b0038407049b5cmr15120530oiv.32.1678726658078;
        Mon, 13 Mar 2023 09:57:38 -0700 (PDT)
X-Google-Smtp-Source: AK7set86f0/F8S5PouGiQEFyz9bxsIyQVNlLEzYRDmqmHJ8dbjOt3VXvUOdMwGwjDGA6EL6dvlxIJg==
X-Received: by 2002:a54:4486:0:b0:384:704:9b5c with SMTP id v6-20020a544486000000b0038407049b5cmr15120491oiv.32.1678726657851;
        Mon, 13 Mar 2023 09:57:37 -0700 (PDT)
Received: from halaney-x13s.attlocal.net ([2600:1700:1ff0:d0e0::21])
        by smtp.gmail.com with ESMTPSA id o2-20020acad702000000b00384d3003fa3sm3365273oig.26.2023.03.13.09.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 09:57:37 -0700 (PDT)
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
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com,
        Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH net-next 04/11] dt-bindings: net: qcom,ethqos: Add Qualcomm sc8280xp compatibles
Date:   Mon, 13 Mar 2023 11:56:13 -0500
Message-Id: <20230313165620.128463-5-ahalaney@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230313165620.128463-1-ahalaney@redhat.com>
References: <20230313165620.128463-1-ahalaney@redhat.com>
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

The sc8280xp has a new version of the ETHQOS hardware in it, EMAC v3.
Add a compatible for this.

Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---
 Documentation/devicetree/bindings/net/qcom,ethqos.yaml | 1 +
 Documentation/devicetree/bindings/net/snps,dwmac.yaml  | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/qcom,ethqos.yaml b/Documentation/devicetree/bindings/net/qcom,ethqos.yaml
index 68ef43fb283d..89c17ed0442f 100644
--- a/Documentation/devicetree/bindings/net/qcom,ethqos.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ethqos.yaml
@@ -24,6 +24,7 @@ properties:
     enum:
       - qcom,qcs404-ethqos
       - qcom,sm8150-ethqos
+      - qcom,sc8280xp-ethqos
 
   reg:
     maxItems: 2
diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 3ca1239da448..f981a89ab2a5 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -67,6 +67,7 @@ properties:
         - loongson,ls7a-dwmac
         - qcom,qcs404-ethqos
         - qcom,sm8150-ethqos
+        - qcom,sc8280xp-ethqos
         - renesas,r9a06g032-gmac
         - renesas,rzn1-gmac
         - rockchip,px30-gmac
@@ -574,6 +575,7 @@ allOf:
               - ingenic,x1600-mac
               - ingenic,x1830-mac
               - ingenic,x2000-mac
+              - qcom,sc8280xp-ethqos
               - snps,dwmac-3.50a
               - snps,dwmac-4.10a
               - snps,dwmac-4.20a
@@ -629,6 +631,7 @@ allOf:
               - ingenic,x2000-mac
               - qcom,qcs404-ethqos
               - qcom,sm8150-ethqos
+              - qcom,sc8280xp-ethqos
               - snps,dwmac-4.00
               - snps,dwmac-4.10a
               - snps,dwmac-4.20a
-- 
2.39.2

