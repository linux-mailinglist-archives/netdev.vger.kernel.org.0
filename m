Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ACE46B5383
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 22:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbjCJV4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 16:56:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231864AbjCJV4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 16:56:31 -0500
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F652278F
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 13:53:08 -0800 (PST)
Received: by mail-ed1-f53.google.com with SMTP id da10so26182473edb.3
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 13:53:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678484812;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cXkeI9EeTTwYzqS8yh9dXecDUjO0MyQx/L2af0F4moE=;
        b=rxWWjbUO8rJ97FJPVEFDo7oU7FjP8u/rEsKV/5EOl6dj3XiLbs93OlAjpxA7EfxgcG
         Tz6CdfursdQopp7xcuk3pGth7B2oloQRPjpr7MpIJwEVYOtUKUrQirTEiCnm/UQJ1vb1
         FOcgfucgjChDKOR7B5OJNrtaSfzxdaJhslaEYbBLAtS5K4z3qObS+mzs13cuZYS32Ena
         H6z71v0dZ2I8nHC7cs9N1+1cPJf/CtMqLpggIkUUAYRRkf9+kckxm2F1AxiPA7p6e03g
         bkc5OpBl00nAbkUr2EQwaOTLaL1fK7qtrEAI9KYr3A7pIA79M0+rH83tVyRRzIEwtn/w
         lmlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678484812;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cXkeI9EeTTwYzqS8yh9dXecDUjO0MyQx/L2af0F4moE=;
        b=SaU4wnSkN9AYY01PGF1330c3ovVkZmnY2gc0M8G2lw5zmAayAsn86FTWEtx5A72QuY
         0eVQew0txJHh6gN3byVT71wJk26oTx0o/5/4pS2C7/uYiXV8Yj5CxaGUwWZv3f4Q1RK9
         dkhav4/IUWRpIFY+7cIKxTMR44lwJnCQfa5dJqC4uTTn0ADPUkIQCtpbN9Adf4rZPsNs
         Ey9tR81aTOW34jkHqaEAGyphPW71p3saAjNij33ve3cKKrZNZRZk1ASHX1sdIiyQ5S/A
         ejBmJzHege306E2Wox9Hz1O1WIhjtHsZBT9yH9fCq/tWbuL+HcFWDANx7hThGxfRY8Q6
         8OBg==
X-Gm-Message-State: AO0yUKXvjOfxlfYBUYF7HmkgYo34zg15evtUXQHPB5hPX5SZXkiR7Twv
        4WY+0xVTXwVRpN4c8YttDAH5pg==
X-Google-Smtp-Source: AK7set9FnQbKV7O9a3DrWLVTokM/lU2Y8DlMciq0r4LeGCxvD6J/xsbXRQD1z+zirQTi2clWFbtiFQ==
X-Received: by 2002:a05:6402:2d3:b0:4c3:15f0:1100 with SMTP id b19-20020a05640202d300b004c315f01100mr25626233edx.29.1678484811998;
        Fri, 10 Mar 2023 13:46:51 -0800 (PST)
Received: from krzk-bin.. ([2a02:810d:15c0:828:34:52e3:a77e:cac5])
        by smtp.gmail.com with ESMTPSA id t5-20020a50ab45000000b004bf7905559asm488088edc.44.2023.03.10.13.46.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 13:46:47 -0800 (PST)
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
Subject: [PATCH 4/5] net: samsung: sxgbe: drop of_match_ptr for ID table
Date:   Fri, 10 Mar 2023 22:46:31 +0100
Message-Id: <20230310214632.275648-4-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230310214632.275648-1-krzysztof.kozlowski@linaro.org>
References: <20230310214632.275648-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver can match only via the DT table so the table should be always
used and the of_match_ptr does not have any sense (this also allows ACPI
matching via PRP0001, even though it is not relevant here).

  drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c:220:34: error: ‘sxgbe_dt_ids’ defined but not used [-Werror=unused-const-variable=]

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c
index 926532466691..4e5526303f07 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c
@@ -229,7 +229,7 @@ static struct platform_driver sxgbe_platform_driver = {
 	.driver	= {
 		.name		= SXGBE_RESOURCE_NAME,
 		.pm		= &sxgbe_platform_pm_ops,
-		.of_match_table	= of_match_ptr(sxgbe_dt_ids),
+		.of_match_table	= sxgbe_dt_ids,
 	},
 };
 
-- 
2.34.1

