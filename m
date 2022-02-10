Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DED24B18E5
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 23:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345338AbiBJW4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 17:56:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344698AbiBJW4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 17:56:15 -0500
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D213A55A4;
        Thu, 10 Feb 2022 14:56:15 -0800 (PST)
Received: by mail-qv1-xf31.google.com with SMTP id a28so6647069qvb.10;
        Thu, 10 Feb 2022 14:56:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=U+3vkzFEGdGmmOjt1hV/DkqJX2a2lDje4tkvz+fEZaQ=;
        b=MFInfE/srC1pPDAgWjrnrRsQPNZIeBeOJeGNEpcwJWUHy5BMVWL1fOMhBwZlPtHJ7U
         5+f1DO4pOifTAEDBOPhFoA/C+0OyKnEvmniHExfoa6cTBor9+2wvjUlLQzfxqeEybm6x
         qfWlqqfDBqMeSdLtUXEtDSRryd+N7lu01bXnLYqvyo4/FLvUFyU4wZhtVt6jvLtVSECd
         cOuSyWxl738PHxvFhnUvNoeVKQigAJ6KajAfW0lsUfEAMrvkcq+FyMbshLeXQjStCI0k
         b6MEWuwYm17L7/+dtp8iAPjFhhLX/TUU5rfVoBX6mQtu/ioNLZ9o8CSaMO4yQWr5+vEO
         SLPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U+3vkzFEGdGmmOjt1hV/DkqJX2a2lDje4tkvz+fEZaQ=;
        b=Jij3xI+ZDRGhCfg92+HwenrtsDp8cz0RK+VUAyv6qf6609SToArghho8x0sizok/hi
         j404Z9aBc/thtlUg8Lkfxk67SVdeH33PnTTGA0908QTNTe0/YD2mR8NK8tYBHDESMpgf
         6/2eTwb/BQq7ZPpiX47I3V0gZEAGKbenDXLRUTJD1/2sfKKdc3igknFedJRbzDPwD/P+
         ZrFM+KM8QH2xzOIkN/ySfTGJ+vcRbrC9/w3mRUvxGPm6xR+YT7THNCFLM3vEgUO4TAQr
         17+HvrO4E36IUrRuRvhRliZn0hR7mS7WjWAOdXYu8bQqlEFjbN1otsUYukp6kmv5PX6J
         9tJA==
X-Gm-Message-State: AOAM530AVFC6wCWZ0bXL5zqjOdP8QaPnmzsG9edPF4Xdc17gv/fH1fd6
        g0YP8GOdRykwNegTR40ORao=
X-Google-Smtp-Source: ABdhPJwtwRaFQJWdH3kBC2E+PysWAfr7+FtW7sdEitaMsJ++lw+fh4m6p8FaQrmqF1WnluhFWEb7Zw==
X-Received: by 2002:a05:6214:401c:: with SMTP id kd28mr2551247qvb.111.1644533774923;
        Thu, 10 Feb 2022 14:56:14 -0800 (PST)
Received: from localhost ([12.28.44.171])
        by smtp.gmail.com with ESMTPSA id g17sm9045729qkl.122.2022.02.10.14.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 14:56:14 -0800 (PST)
From:   Yury Norov <yury.norov@gmail.com>
To:     Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Laight <David.Laight@aculab.com>,
        Joe Perches <joe@perches.com>, Dennis Zhou <dennis@kernel.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Nicholas Piggin <npiggin@gmail.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Alexey Klimov <aklimov@redhat.com>,
        linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller " <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
Subject: [PATCH 02/49] net: systemport: don't use bitmap_weight() in bcm_sysport_rule_set()
Date:   Thu, 10 Feb 2022 14:48:46 -0800
Message-Id: <20220210224933.379149-3-yury.norov@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220210224933.379149-1-yury.norov@gmail.com>
References: <20220210224933.379149-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't call bitmap_weight() if the following code can get by
without it.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 60dde29974bf..5284a5c961db 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -2180,13 +2180,9 @@ static int bcm_sysport_rule_set(struct bcm_sysport_priv *priv,
 	if (nfc->fs.ring_cookie != RX_CLS_FLOW_WAKE)
 		return -EOPNOTSUPP;
 
-	/* All filters are already in use, we cannot match more rules */
-	if (bitmap_weight(priv->filters, RXCHK_BRCM_TAG_MAX) ==
-	    RXCHK_BRCM_TAG_MAX)
-		return -ENOSPC;
-
 	index = find_first_zero_bit(priv->filters, RXCHK_BRCM_TAG_MAX);
 	if (index >= RXCHK_BRCM_TAG_MAX)
+		/* All filters are already in use, we cannot match more rules */
 		return -ENOSPC;
 
 	/* Location is the classification ID, and index is the position
-- 
2.32.0

