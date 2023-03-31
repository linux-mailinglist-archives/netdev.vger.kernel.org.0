Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7AB46D2A2F
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 23:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbjCaVri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 17:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbjCaVrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 17:47:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA7021AA4
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 14:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680299179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8lcrUOTtZQ8Y8eq1MxEjtzOYPZBObLg5qooJNdijlKM=;
        b=JXZZzlpIXl+B8QmxybzRhWx9NB7THU12s21Ge8LnZptAN7JyRy2TyrUZvQS9IRTGhoZ6Fp
        z+VBvkeeZi0hsppOKDOIzp73QERyo7jvY5CrjCnAF7ZxyzUzA6UX/Ut6hTk8oNtzuIpe+W
        UT4XZuNqc4u7hxBA1rwPYVG4WwEObw0=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-327-2Zv1O4_SMTWBi8F8lmflug-1; Fri, 31 Mar 2023 17:46:18 -0400
X-MC-Unique: 2Zv1O4_SMTWBi8F8lmflug-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-1802c0ae9bbso2336324fac.5
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 14:46:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680299177;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8lcrUOTtZQ8Y8eq1MxEjtzOYPZBObLg5qooJNdijlKM=;
        b=RIWW/3BMK5uBO0R/MOtVFd2lvzppVMmV/WdIyaXypKTYk4eR7IJeh+R8FkTOoiiYWW
         QBUZmPKbTrJryYiNYix1XD8sr7o0YNyfydtaj4UsP+tMmAUmPNZVoybnzRjmYzHbn/9u
         WNGCwAJOFaMPNLVBwKmG6TG7lcQ1LuI/tCinw1TlOwuK88g1HEgMq+TdAhblixtmhgbb
         EcAv8TgpC8Hh/u5aYdDQa6viMyYH0j9pJMH/h84b5S0CJ3AlJFsTFuXuS+D3HshGDyES
         qp/EMz9O4+PLmyBwPHfNNN/K4NAilVUExP7yM9sqG/DMZcxbr+rG9/j4wYzoscUUtiWn
         y0ZA==
X-Gm-Message-State: AAQBX9eGOSAfntqYZm/EtmckWO4JKVIYFSPyjtifPx4GSsdwSjeFs8g/
        kbdHBirwzXBva2iShXC10E0zrLp830xaVfV6L/BeyZdwEHzHSPade9bnY7tomPWaD7rHv3dSxye
        4bAT+6D1vvuo5hKro
X-Received: by 2002:a9d:6a4a:0:b0:6a1:6cf9:49ee with SMTP id h10-20020a9d6a4a000000b006a16cf949eemr4413153otn.9.1680299177277;
        Fri, 31 Mar 2023 14:46:17 -0700 (PDT)
X-Google-Smtp-Source: AKy350aUQ7W33R935fGo9TuSQD3HX9RxY871Aop63H4kyUDTxL9RxaeaTlk4Ws52w4rzbyNf1gKQ5Q==
X-Received: by 2002:a9d:6a4a:0:b0:6a1:6cf9:49ee with SMTP id h10-20020a9d6a4a000000b006a16cf949eemr4413139otn.9.1680299177094;
        Fri, 31 Mar 2023 14:46:17 -0700 (PDT)
Received: from halaney-x13s.attlocal.net (104-53-165-62.lightspeed.stlsmo.sbcglobal.net. [104.53.165.62])
        by smtp.gmail.com with ESMTPSA id x80-20020a4a4153000000b0053d9be4be68sm1328531ooa.19.2023.03.31.14.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 14:46:16 -0700 (PDT)
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
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH net-next v3 02/12] dt-bindings: net: snps,dwmac: Add Qualcomm Ethernet ETHQOS compatibles
Date:   Fri, 31 Mar 2023 16:45:39 -0500
Message-Id: <20230331214549.756660-3-ahalaney@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230331214549.756660-1-ahalaney@redhat.com>
References: <20230331214549.756660-1-ahalaney@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bhupesh Sharma <bhupesh.sharma@linaro.org>

Add Qualcomm Ethernet ETHQOS compatible checks
in snps,dwmac YAML binding document.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---

Changes since v1 and v2:
    * None

 Documentation/devicetree/bindings/net/snps,dwmac.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 5a4737e969a3..1e7982704114 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -65,6 +65,8 @@ properties:
         - ingenic,x2000-mac
         - loongson,ls2k-dwmac
         - loongson,ls7a-dwmac
+        - qcom,qcs404-ethqos
+        - qcom,sm8150-ethqos
         - renesas,r9a06g032-gmac
         - renesas,rzn1-gmac
         - rockchip,px30-gmac
@@ -625,6 +627,8 @@ allOf:
               - ingenic,x1600-mac
               - ingenic,x1830-mac
               - ingenic,x2000-mac
+              - qcom,qcs404-ethqos
+              - qcom,sm8150-ethqos
               - snps,dwmac-4.00
               - snps,dwmac-4.10a
               - snps,dwmac-4.20a
-- 
2.39.2

