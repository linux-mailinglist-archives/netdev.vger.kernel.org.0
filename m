Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98DDA6D2A4B
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 23:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233238AbjCaVsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 17:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233237AbjCaVs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 17:48:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456CB23B45
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 14:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680299198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qACvXNoEnX2lVAx6UnLm5++0SRgSju5l/WpOwhVlX2M=;
        b=DzYDHYIINKS1s4PCVh9GSo6e7KXGCPo50auTVYs6R3yXn717W5EDDL6OvYQTMfVTjjq+pW
        PYpHKynn4TNgZJJ5h1CvI7UhPUX3tYhPNfCuQVuJqnAangWPem7ymMxSoRlbiepKeGLI0b
        LM16V35iKqRlgDNTnEa3vW6/XTS0574=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-14-euoQFPQFMBugbdSZmfO2zA-1; Fri, 31 Mar 2023 17:46:32 -0400
X-MC-Unique: euoQFPQFMBugbdSZmfO2zA-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-17f12d9b68eso9713236fac.11
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 14:46:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680299191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qACvXNoEnX2lVAx6UnLm5++0SRgSju5l/WpOwhVlX2M=;
        b=YjgT7NslFjVgtg77RPcTr7M/hr6YkJP6ZRtqXpl+onXew3grZL7w9caR9RJ5C05p7T
         B7vqZX2d2hJvLgziJnkMHnU14ofbp1BwC3IHy5nNkVtUP99zq8XRgiKWQwnfVCtTHKtV
         UYVPHtR/q2xnWHCWOE0VdZv/KT3zbndMYhJV7FyaGVMgoa6U7n94PVC595PT82Kkm1M6
         L6pB8Xbt7o9BJQ7ZuYi1lB7uABEroQIAaRb664he7C74RXLF+OoAxhB9frh05tkg48i3
         gO6VQL2hXF9fQLiMZ0aT0WLsp9/jM+FjkuqyG2Ml1NlWc8Ct52v6tj5HL0Dom34ZUQNw
         ylZw==
X-Gm-Message-State: AO0yUKX2D2AYJcG/71YsmjfpIaNIi7cIl0vCWfZMh/ZtHmuQJgqd+4ZS
        MeyQMAaic5BpJ2y8tlBP/98XBELJ/l6RxBaX308zlOdo2UzagGdxF0RmrxxNxJIjolY04frgilA
        Z5Ehfu9WljBuUdO8i
X-Received: by 2002:a4a:4185:0:b0:533:c6b7:27dc with SMTP id x127-20020a4a4185000000b00533c6b727dcmr12902162ooa.0.1680299191482;
        Fri, 31 Mar 2023 14:46:31 -0700 (PDT)
X-Google-Smtp-Source: AK7set822UYJHwGM7owlnRUxqK6f0CJtFjIBd5BokBFZ7cUXSCSQ9eyAJDzp0jQbAnb0TfpNiU6TyQ==
X-Received: by 2002:a4a:4185:0:b0:533:c6b7:27dc with SMTP id x127-20020a4a4185000000b00533c6b727dcmr12902133ooa.0.1680299191225;
        Fri, 31 Mar 2023 14:46:31 -0700 (PDT)
Received: from halaney-x13s.attlocal.net (104-53-165-62.lightspeed.stlsmo.sbcglobal.net. [104.53.165.62])
        by smtp.gmail.com with ESMTPSA id x80-20020a4a4153000000b0053d9be4be68sm1328531ooa.19.2023.03.31.14.46.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 14:46:30 -0700 (PDT)
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
Subject: [PATCH net-next v3 06/12] net: stmmac: Fix DMA typo
Date:   Fri, 31 Mar 2023 16:45:43 -0500
Message-Id: <20230331214549.756660-7-ahalaney@redhat.com>
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

DAM is supposed to be DMA. Fix it to improve readability.

Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---

Changes since v2:
    * New patch, stumbled into this typo when refactoring

 drivers/net/ethernet/stmicro/stmmac/common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 54bb072aeb2d..4ad692c4116c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -242,7 +242,7 @@ struct stmmac_safety_stats {
 
 #define SF_DMA_MODE 1		/* DMA STORE-AND-FORWARD Operation Mode */
 
-/* DAM HW feature register fields */
+/* DMA HW feature register fields */
 #define DMA_HW_FEAT_MIISEL	0x00000001	/* 10/100 Mbps Support */
 #define DMA_HW_FEAT_GMIISEL	0x00000002	/* 1000 Mbps Support */
 #define DMA_HW_FEAT_HDSEL	0x00000004	/* Half-Duplex Support */
-- 
2.39.2

