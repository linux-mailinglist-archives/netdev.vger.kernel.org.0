Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A86F063E694
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 01:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiLAAhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 19:37:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbiLAAhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 19:37:08 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D90FE54344
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 16:37:06 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id p13-20020a05600c468d00b003cf8859ed1bso306645wmo.1
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 16:37:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3JeRAanxnv877HgY1VwoLNPFNGeS96ErsmmM19RQ7Ns=;
        b=bQuwkrinCmDXQj479XSAUAxt6eFSL31t0OV5HA13r4HQ4ZEPmpHOwhXawVTb6tAZPM
         OU1sO/d2v3XJ0VvZFEIneqW4h3uV+r6NKC6ZfNp+3RkJM+qo/Eqw97eaFde9BHGepkfF
         4GMCMBZFmvuLyujjVGTuvA2MD4CMZ2oe4vKd7xbPfz2WNDkuT2nfT8aqFo6YwZxpvWbg
         61z4Cce132Qd1aOoJoLwYvA0BvVaQGfHs0oBaK7VW0qy0YQFkEudgjLPF6TRsqQJj6uB
         fQ5dFkJ5ZwLNieyib9VM0htH7hcHCadYISWnvd56P90qTQkWQfLOU1NorvsIDZes1iOE
         /6ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3JeRAanxnv877HgY1VwoLNPFNGeS96ErsmmM19RQ7Ns=;
        b=SZvoI3ecZHE6XIJz4Cp/lSjeya0aJ8kDonYMAHGM/z5nGnmxU/Rad40g7MIeQa+75V
         Snm46Fi+3bzgnvV74zp88R52aFxzUvF6Gx2QEljh+KCeSZyXAhlThke+zPcOxTRpFhJE
         aOY6u9TB5vo3qcRz5aG1+Us7TCNzX0XSZBO6qPohGyUDn09qdFZMm7F/BpG+BsoWsUw9
         pejT/ytWus3CY3R7jx2d7ANjGK+O2xqVdS9hoDRqdDWPx3XPQqFuLLi/Sg0FHz9t5RWC
         I9vHW2U4KXetJW80G8wnz9rR1nKG5zlLb/InORaiKw+/yjfZXOEBJKIB09/T5IDUH1c4
         eFjA==
X-Gm-Message-State: ANoB5pmsPMtW3Jmg3xpB4xxa8RlH3mi32LSRJHPb/DHEcaPvLAU6OwEP
        wn2ceH4yHxQ8UYu5lori3Ls=
X-Google-Smtp-Source: AA0mqf4zxiByzBmhAl570TB+mUl6z64Q68H6cct5VylU7syTryg4kDoykJwigoHHDA465HGtOL/dkw==
X-Received: by 2002:a05:600c:2108:b0:3cf:aae0:802a with SMTP id u8-20020a05600c210800b003cfaae0802amr37294724wml.112.1669855025231;
        Wed, 30 Nov 2022 16:37:05 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id e4-20020adff344000000b00236488f62d6sm3059511wrp.79.2022.11.30.16.37.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 16:37:04 -0800 (PST)
Date:   Thu, 1 Dec 2022 01:37:08 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     kuba@kernel.org, netdev@vger.kernel.org
Cc:     peppe.cavallaro@st.com, andrew@lunn.ch
Subject: [PATCH net] stmmac: fix potential division by 0
Message-ID: <Y4f3NGAZ2rqHkjWV@gvm01>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Depending on the HW platform and configuration, the
stmmac_config_sub_second_increment() function may return 0 in the
sec_inc variable. Therefore, the subsequent div_u64 operation can Oops
the kernel because of the divisor being 0.

Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 23ec0a9e396c..6ed1704b638d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -848,7 +848,7 @@ int stmmac_init_tstamp_counter(struct stmmac_priv *priv, u32 systime_flags)
 	stmmac_config_sub_second_increment(priv, priv->ptpaddr,
 					   priv->plat->clk_ptp_rate,
 					   xmac, &sec_inc);
-	temp = div_u64(1000000000ULL, sec_inc);
+	temp = div_u64(1000000000ULL, max_t(u32, sec_inc, 1));
 
 	/* Store sub second increment for later use */
 	priv->sub_second_inc = sec_inc;
-- 
2.35.1

