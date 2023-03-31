Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 066D66D2A39
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 23:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233179AbjCaVru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 17:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233151AbjCaVrr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 17:47:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C261222EB4
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 14:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680299188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DldK2I/IPaSgIsH620iyq/+h6bSvEy3k1WBvR82ldeo=;
        b=QqjggBiHJaH+0FPds+NimR1nwJbxu3VPsnqG3uiv8kgq9+D2CqkbeTOGNESPi8/TAid2hx
        mq0qdizHuwYTzZG12vGrCHfoysWJVmJ8i6iE+GaQAf97KEXA2cR9u6I0Y2BLYYkrBUVDVr
        h4txe5RunPfddUEpyOY1k9iLSXSxeZ8=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-hRfr6zLOOd2IV3H0a3hx3A-1; Fri, 31 Mar 2023 17:46:26 -0400
X-MC-Unique: hRfr6zLOOd2IV3H0a3hx3A-1
Received: by mail-oi1-f200.google.com with SMTP id r133-20020acaf38b000000b00386b94ef384so5768870oih.16
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 14:46:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680299184;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DldK2I/IPaSgIsH620iyq/+h6bSvEy3k1WBvR82ldeo=;
        b=L1ySte3Zyquo1DxjsxJYJL4d5gCKXKruwjU4azGli6oTpSWRgrSMF/K1VD24um8mRR
         aA+biGuCyZ93OBKMuKDMRIrh8vrv3jPq7Dp1ieEg8OqICN7rDRhtnppUIto/pKTVFXwn
         4wy1LEIHr3MDR7Z+IjmEZwNHaX1lY6Bybgg9pxbZ6Wli4NTl7tBduxw/N/WZSbuUqpcf
         2Ka6XtcfLjx3PgNDfgu6ir7OyZv+3Hw6yvMi4AbX0KT0+csj9pSDAIdNbDZ//lEBXC+0
         qhKFnHJJTfmDAepQK4GnQ27M9LKMJLsxBmD1S6W6MnDunjrbrHq6ksO/dhD97z1o90DB
         Cykw==
X-Gm-Message-State: AO0yUKXSDVt8ddRA1HsKzEYDnq58DMEXYmYGnrpYog5nDp3wAGl2UF9z
        gKWj0aOWWUT8g9Z4kOamk9l9Upt1pIOhdy5TQdEht6KFrroNF8jPzF5SkasWZYHNVA6S6kO+MsF
        rjqZiMdkpCG0p3I3h
X-Received: by 2002:a4a:498a:0:b0:525:129c:6165 with SMTP id z132-20020a4a498a000000b00525129c6165mr14258277ooa.6.1680299183782;
        Fri, 31 Mar 2023 14:46:23 -0700 (PDT)
X-Google-Smtp-Source: AK7set+27vkGs1bWdUnyWKF+VnjPQB0+2s07heID2AGWKfhkeapB9Pm6gnRicXouOLV40Cd+zuAqbA==
X-Received: by 2002:a4a:498a:0:b0:525:129c:6165 with SMTP id z132-20020a4a498a000000b00525129c6165mr14258259ooa.6.1680299183586;
        Fri, 31 Mar 2023 14:46:23 -0700 (PDT)
Received: from halaney-x13s.attlocal.net (104-53-165-62.lightspeed.stlsmo.sbcglobal.net. [104.53.165.62])
        by smtp.gmail.com with ESMTPSA id x80-20020a4a4153000000b0053d9be4be68sm1328531ooa.19.2023.03.31.14.46.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 14:46:23 -0700 (PDT)
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
Subject: [PATCH net-next v3 04/12] dt-bindings: net: qcom,ethqos: Add Qualcomm sc8280xp compatibles
Date:   Fri, 31 Mar 2023 16:45:41 -0500
Message-Id: <20230331214549.756660-5-ahalaney@redhat.com>
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

The sc8280xp has a new version of the ETHQOS hardware in it, EMAC v3.
Add a compatible for this.

Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---

Changes since v2:
    * *Really* alphabetical sorting (sorry Krzysztof!)

Changes since v1:
    * Alphabetical sorting (Krzysztof)
 Documentation/devicetree/bindings/net/qcom,ethqos.yaml | 1 +
 Documentation/devicetree/bindings/net/snps,dwmac.yaml  | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/qcom,ethqos.yaml b/Documentation/devicetree/bindings/net/qcom,ethqos.yaml
index 88234a2010b1..60a38044fb19 100644
--- a/Documentation/devicetree/bindings/net/qcom,ethqos.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ethqos.yaml
@@ -20,6 +20,7 @@ properties:
   compatible:
     enum:
       - qcom,qcs404-ethqos
+      - qcom,sc8280xp-ethqos
       - qcom,sm8150-ethqos
 
   reg:
diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 1e7982704114..da311c1f2c88 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -66,6 +66,7 @@ properties:
         - loongson,ls2k-dwmac
         - loongson,ls7a-dwmac
         - qcom,qcs404-ethqos
+        - qcom,sc8280xp-ethqos
         - qcom,sm8150-ethqos
         - renesas,r9a06g032-gmac
         - renesas,rzn1-gmac
@@ -574,6 +575,7 @@ allOf:
               - ingenic,x1600-mac
               - ingenic,x1830-mac
               - ingenic,x2000-mac
+              - qcom,sc8280xp-ethqos
               - snps,dwmac-3.50a
               - snps,dwmac-4.10a
               - snps,dwmac-4.20a
@@ -628,6 +630,7 @@ allOf:
               - ingenic,x1830-mac
               - ingenic,x2000-mac
               - qcom,qcs404-ethqos
+              - qcom,sc8280xp-ethqos
               - qcom,sm8150-ethqos
               - snps,dwmac-4.00
               - snps,dwmac-4.10a
-- 
2.39.2

