Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98FF46C2477
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 23:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjCTWRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 18:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbjCTWRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 18:17:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B2734327
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 15:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679350598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YlOqWVli75QXNprPmQyXqnWUqk+FMVr+7rpbpXO8i/U=;
        b=Raa0ZMCDbV6YAoaFohVYWBRxo/wN7JN2RxF+MqkZtbpoZyPIz+T577IRSktIWVy1/TUk85
        7Qw5Sy60pfhBRy218Ial8DrkPY8y49TADFrl+GeaSCEBJxbcwXHmxUmK1mB6d5mXTcQzVg
        vOaLLquKmi4qiCSoCTrrDqXXvv1879k=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-59-WC7fCfv4P_SR3K8DXSlvAA-1; Mon, 20 Mar 2023 18:16:37 -0400
X-MC-Unique: WC7fCfv4P_SR3K8DXSlvAA-1
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-17abfe9fd10so7698934fac.0
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 15:16:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679350597;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YlOqWVli75QXNprPmQyXqnWUqk+FMVr+7rpbpXO8i/U=;
        b=WCkbpq0ECcn/T6uLkqUdaYyvAkRqsbpu6NMtAVgjqmKP/NQXYDlFBbRQH2fvOGFFSJ
         rdhan3P0GofDFG5gM5HjAFozPydcF+aUD1l6G3zajbGPMR17E0707W4BWqJpRoBRiH16
         Ud4q8WatXvRFCRFsMw0DAn4Gdve3OYNwy6EMO9mEaTJKeSKPbpt+XhhMygSCg2ju3VP7
         sFLNeoYc1BvhV5vqbVPofmd6BaaKOQNLqfj2UQ4QceQ686MSrLUzg7I0Syc7JUcW83m6
         1BEH0xKRkdUMFc+SVy9u6pRKG9GP+dTavNlYTgAirStt6Ec3a0puMRw1cLwKZH5vpswq
         9JYQ==
X-Gm-Message-State: AO0yUKXiPjGAB13iFD6eK1WIKT/wZFUnO6SQ2A9D2YSQY0gEjd2dPO1a
        BLUrGzRglCqiVZ2ZIuorXt0/zhPvvkq19qIsvwXj12RnIwPk/z7vaEZIhILgzK1EaCfiHuYMTXZ
        2qHZ/j70S0rAIAS2C
X-Received: by 2002:a4a:d50d:0:b0:525:432a:90b0 with SMTP id m13-20020a4ad50d000000b00525432a90b0mr826248oos.1.1679350597016;
        Mon, 20 Mar 2023 15:16:37 -0700 (PDT)
X-Google-Smtp-Source: AK7set+sFN8OAUwmdLsJ9ZBRkT2O9PURonEVDvf0kVHAlkwFMtWoYbZeUAmr9vMfEPdP9CsKmxVlEQ==
X-Received: by 2002:a4a:d50d:0:b0:525:432a:90b0 with SMTP id m13-20020a4ad50d000000b00525432a90b0mr826216oos.1.1679350596785;
        Mon, 20 Mar 2023 15:16:36 -0700 (PDT)
Received: from halaney-x13s.redhat.com (104-53-165-62.lightspeed.stlsmo.sbcglobal.net. [104.53.165.62])
        by smtp.gmail.com with ESMTPSA id q204-20020a4a33d5000000b0053853156b5csm4092465ooq.8.2023.03.20.15.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 15:16:36 -0700 (PDT)
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
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com, echanude@redhat.com,
        Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH net-next v2 01/12] dt-bindings: net: snps,dwmac: Update interrupt-names
Date:   Mon, 20 Mar 2023 17:16:06 -0500
Message-Id: <20230320221617.236323-2-ahalaney@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320221617.236323-1-ahalaney@redhat.com>
References: <20230320221617.236323-1-ahalaney@redhat.com>
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

From: Bhupesh Sharma <bhupesh.sharma@linaro.org>

As commit fc191af1bb0d ("net: stmmac: platform: Fix misleading
interrupt error msg") noted, not every stmmac based platform
makes use of the 'eth_wake_irq' or 'eth_lpi' interrupts.

So, update the 'interrupt-names' inside 'snps,dwmac' YAML
bindings to reflect the same.

Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---

Changes since v1:
	* Dropped Krzysztof's Acked-by since changes requested
	* Changed interrupt-names items per Krzysztof

 Documentation/devicetree/bindings/net/snps,dwmac.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 16b7d2904696..df4c5d184446 100644
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

