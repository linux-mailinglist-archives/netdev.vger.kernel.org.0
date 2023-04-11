Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1F6D6DE54F
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 22:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjDKUGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 16:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjDKUF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 16:05:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93FA3468F
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 13:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681243473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YeRMoDwNgHrXxiMag5H3EfyVB1iYobNV8jx2yu9ZLd4=;
        b=dGAB8m0ykpKCSiLiBJ8EAwWgw+VUlCjfVvEskXbOzlNQc8xHjFBqGeg8AFNtCKvDc9t3CV
        jPVrcodcnXk3sSzU5u0pAfMmxVo4+s2xUdHgbGUz2C75BQgz8IaTsuKyoeMkDdnX5FY5L6
        Vuzd82Tq3FH0kw9WPqw81ds4PDoLUHw=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-66-ssgGI_dSNaiJyQiZptVUyg-1; Tue, 11 Apr 2023 16:04:32 -0400
X-MC-Unique: ssgGI_dSNaiJyQiZptVUyg-1
Received: by mail-ot1-f72.google.com with SMTP id x5-20020a9d6285000000b006a12c805a17so312735otk.11
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 13:04:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681243472;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YeRMoDwNgHrXxiMag5H3EfyVB1iYobNV8jx2yu9ZLd4=;
        b=4ex5gtGLCBcWq/ygKq6qfBU552Rpi+bJ/hU2r3Abb+ZZNuqKBF+y0tlwy7hTa9kohy
         dzHOZMefbvSdpTS9dfjVKX/1hbgxUbpZ2OCJ3IBgA5Qan+A6Fl9QRxZyYfAeS6x/KeOz
         hkbpIlvcoziO/G4/2oiITEJ+fUGMoGlYDvr61rujZii0YigyCP7DCJMwwqvEdPPeK9ef
         zMKbf/K13s6CqfDfnHLa7e1AlLcQ3ZugQ0voH+/uUhzOJYVLVpUDJ1iuzSbBvTFw7E47
         MqQ7ScTmexmp4vywUzUMw6Fpb7qR8nqbgHKgVBXp5ZZ99CZGZfXPjbedawYt7DlqeD4U
         /KUg==
X-Gm-Message-State: AAQBX9dphIKe+/nZwvC5gdI5uVw5QNadfC07JRx5t39sdULCeZKPjBVI
        YAXuMs9AegJan4LATzIG+D/nhLhD7vCKoxewq8DKrKGQ1MR+rr2KFg0Ae/YftpWrkERuujhYQnc
        bK10G1VPsn7tD/Bwh
X-Received: by 2002:aca:be88:0:b0:387:11d6:d48d with SMTP id o130-20020acabe88000000b0038711d6d48dmr6269970oif.37.1681243471828;
        Tue, 11 Apr 2023 13:04:31 -0700 (PDT)
X-Google-Smtp-Source: AKy350ayqSH+7Hj8HEiFSaaeuV9ioyjXPt4cbYwGEzo7vQ16BMv3GHZIKe3My4U0lgrvHGPyDqwn4A==
X-Received: by 2002:aca:be88:0:b0:387:11d6:d48d with SMTP id o130-20020acabe88000000b0038711d6d48dmr6269958oif.37.1681243471614;
        Tue, 11 Apr 2023 13:04:31 -0700 (PDT)
Received: from halaney-x13s.attlocal.net (104-53-165-62.lightspeed.stlsmo.sbcglobal.net. [104.53.165.62])
        by smtp.gmail.com with ESMTPSA id e20-20020a056808149400b00387764759a3sm5868545oiw.24.2023.04.11.13.04.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 13:04:31 -0700 (PDT)
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
Subject: [PATCH net-next v4 01/12] dt-bindings: net: snps,dwmac: Update interrupt-names
Date:   Tue, 11 Apr 2023 15:03:58 -0500
Message-Id: <20230411200409.455355-2-ahalaney@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230411200409.455355-1-ahalaney@redhat.com>
References: <20230411200409.455355-1-ahalaney@redhat.com>
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

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---

Changes since v3:
    * None

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

