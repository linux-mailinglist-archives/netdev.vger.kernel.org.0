Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC686D2A2B
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 23:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233075AbjCaVqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 17:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232327AbjCaVqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 17:46:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 387831EFE3
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 14:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680299175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BWAjKcn7KmjDYRHOryY9yAx4ZqStu9DbyRutO1cNTys=;
        b=FKWsf8Y4++dz8RckS/OC4jXZUZA1f4Pfc/rekUh5lHGhcpDIwYX2s1j8h3Vc8RUuh2wHB8
        jJdhGbxvWj2QWB5Z3Q2Ro9J+igRuNylH471wPzTHH1RZGKitHbvjNbuGezPsPVJHCLX6eN
        jqNXQK3LSz4pGFsvkluUoTw51Fvw4Z8=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-606-cRRCgkTuOVehCbWLpPRIPA-1; Fri, 31 Mar 2023 17:46:14 -0400
X-MC-Unique: cRRCgkTuOVehCbWLpPRIPA-1
Received: by mail-oi1-f198.google.com with SMTP id n205-20020acabdd6000000b003846654dd65so5777072oif.19
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 14:46:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680299173;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BWAjKcn7KmjDYRHOryY9yAx4ZqStu9DbyRutO1cNTys=;
        b=Vta7N3ltgGx3DVrTL3l+UFwjH2vj0ovMSvALzcUlbAV9f7UXh7Rk8xdmlnaEei2IJ0
         w9Ft2/9eoqqRLpRsxFwjWlbXoLyNDsoev0nsX/BeeDr/FRWAAknxC99VVaP+kICX5uXH
         nRXXACjD9Zk9cDGS48+RsGz1CMUNmlMyXmxUiJP9wiHiLhDoEiXhU6MDdO3iBAxIjBqu
         T3ERdkE5Q1KeZcWRWBT5V8Lu3kzU7JOuzst0oenUHtZ+6V8+ZUDtl5Cu2sU10A31B4HT
         wXDhvYi7Vg0kDnKHM1O9V4/WJ6DZSILs+c0wjKbqB3ZLZbGmvKsxncke2jY/1THADErE
         n0HQ==
X-Gm-Message-State: AAQBX9fWL2gCLlQkuAJFpp/nIso/zi49p1OO9JCxBWXKeBWN170HwYtV
        Aejp1aRpOM9t/lqBTK1sm8AxrYnsDViW2cLp8FtXZicZICHePASaRXB+UdK/llc50pv3/UThrWe
        3OLXK5RZ6272Cw4WZ
X-Received: by 2002:a54:4519:0:b0:389:2d2b:4b1b with SMTP id l25-20020a544519000000b003892d2b4b1bmr8396897oil.43.1680299173525;
        Fri, 31 Mar 2023 14:46:13 -0700 (PDT)
X-Google-Smtp-Source: AKy350Zx2tJIil7EtW85aEQyo8RTGjEHt7aKU8TOLaUPn71QidrVG+oC5h5rPNpRYe4KMVFNW/3RtA==
X-Received: by 2002:a54:4519:0:b0:389:2d2b:4b1b with SMTP id l25-20020a544519000000b003892d2b4b1bmr8396874oil.43.1680299173054;
        Fri, 31 Mar 2023 14:46:13 -0700 (PDT)
Received: from halaney-x13s.attlocal.net (104-53-165-62.lightspeed.stlsmo.sbcglobal.net. [104.53.165.62])
        by smtp.gmail.com with ESMTPSA id x80-20020a4a4153000000b0053d9be4be68sm1328531ooa.19.2023.03.31.14.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 14:46:12 -0700 (PDT)
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
Subject: [PATCH net-next v3 01/12] dt-bindings: net: snps,dwmac: Update interrupt-names
Date:   Fri, 31 Mar 2023 16:45:38 -0500
Message-Id: <20230331214549.756660-2-ahalaney@redhat.com>
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

As commit fc191af1bb0d ("net: stmmac: platform: Fix misleading
interrupt error msg") noted, not every stmmac based platform
makes use of the 'eth_wake_irq' or 'eth_lpi' interrupts.

So, update the 'interrupt-names' inside 'snps,dwmac' YAML
bindings to reflect the same.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---

Changes since v2:
    * Add Krzysztof's Reviewed-by tag

Changes since v1:
    * Dropped Krzysztof's Acked-by since changes requested
    * Changed interrupt-names items per Krzysztof

 Documentation/devicetree/bindings/net/snps,dwmac.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 74f2ddc12018..5a4737e969a3 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -105,7 +105,7 @@ properties:
     minItems: 1
     items:
       - const: macirq
-      - const: eth_wake_irq
+      - enum: [eth_wake_irq, eth_lpi]
       - const: eth_lpi
 
   clocks:
-- 
2.39.2

