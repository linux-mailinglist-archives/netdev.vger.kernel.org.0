Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 655676B5368
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 22:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbjCJVve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 16:51:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbjCJVuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 16:50:54 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE13126EF
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 13:48:05 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id k10so26010376edk.13
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 13:48:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678484813;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lzFx8euiB+sc2RTiijtv6CruVrC3VvrxIigbNh0lHCw=;
        b=ousR3cOJbxC6x+UkyFQcWklCFj80NWbEJGdyDrSjeFRWdxuO7XkM0J4FPY/a+Re+ud
         ZpQPSczG8puqE9oD4FbTWjxSyafng0QhvyE3rX2OhSQboWmKHtyqLje+08ogR2ZXDZF/
         Hapo4z9OPfoaqBiFcu+qSq9P8cOSrWQz62T+DqqBW62Bier/CICZrks4KZkbSAqP8aOe
         JWzDx2VsbmooiWLykyWUZcSZvQJ6a7Ef/Q0Ln6RJugf7UTqAvF9v2V6OasRULflKUcFj
         f4e2VCpmVGy0HqNMsyeM0Od6H2sF0vA3caiLz1yNPppZ3c2+KRXn7MZubpIOVnj+0YHH
         6mpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678484813;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lzFx8euiB+sc2RTiijtv6CruVrC3VvrxIigbNh0lHCw=;
        b=c5o0j3VAhjobnzdbji9UQBuV4xLPF8RQRrybRdbGLKuunq0BXa/4idifA41xZFYBLP
         yM/QGYej4ncnwdD0WuN2M410YfWEisIIf/Kzi78fr9CnfQJqBsZzNA4v3SmJPX2q4yNN
         LAkZe4t0jyo3em9N9uP+RtPoZxM4gKVUQJecEFuLsxD977/ZpCyygtxSp3vA4g9XDuzO
         j7AyhfPFo2puaN+lufOE2aUubP3iO1UEkcxNVijw8Jx0VWji4BgX3D7T/Ch+wjPS3JhO
         nVXKwPOEZGmx8zGccrUdklxY6LJn9HuQlMbFDLacma8a6apdk2FkjTgCydoMC+ndxEQR
         gH1Q==
X-Gm-Message-State: AO0yUKX1zHeMQCCuDR0pVoF8v8WIVAW7JT8NSpKyAs2TpxM3wVwm/nke
        swx3iRzoKj4WhiRRF8gJV1Yjrw==
X-Google-Smtp-Source: AK7set8nWd2eBnYgMGQTtXIPbx0OtD6V7+vbCi+nDaI+pK1IzlYRDbizlxwOP2yZnDYzFE6FeI/EFw==
X-Received: by 2002:a05:6402:1a4d:b0:4a2:223d:4514 with SMTP id bf13-20020a0564021a4d00b004a2223d4514mr25732913edb.8.1678484813196;
        Fri, 10 Mar 2023 13:46:53 -0800 (PST)
Received: from krzk-bin.. ([2a02:810d:15c0:828:34:52e3:a77e:cac5])
        by smtp.gmail.com with ESMTPSA id t5-20020a50ab45000000b004bf7905559asm488088edc.44.2023.03.10.13.46.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 13:46:52 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Byungho An <bh74.an@samsung.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Vinod Koul <vkoul@kernel.org>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 5/5] net: ni: drop of_match_ptr for ID table
Date:   Fri, 10 Mar 2023 22:46:32 +0100
Message-Id: <20230310214632.275648-5-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230310214632.275648-1-krzysztof.kozlowski@linaro.org>
References: <20230310214632.275648-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver can match only via the DT table so the table should be always
used and the of_match_ptr does not have any sense (this also allows ACPI
matching via PRP0001, even though it is not relevant here).

  drivers/net/ethernet/ni/nixge.c:1253:34: error: ‘nixge_dt_ids’ defined but not used [-Werror=unused-const-variable=]

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/net/ethernet/ni/nixge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
index 56e02cba0b8a..0fd156286d4d 100644
--- a/drivers/net/ethernet/ni/nixge.c
+++ b/drivers/net/ethernet/ni/nixge.c
@@ -1422,7 +1422,7 @@ static struct platform_driver nixge_driver = {
 	.remove		= nixge_remove,
 	.driver		= {
 		.name		= "nixge",
-		.of_match_table	= of_match_ptr(nixge_dt_ids),
+		.of_match_table	= nixge_dt_ids,
 	},
 };
 module_platform_driver(nixge_driver);
-- 
2.34.1

