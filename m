Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3A556AA4D
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 20:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235825AbiGGSPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 14:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235567AbiGGSPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 14:15:46 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B705327CEB
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 11:15:44 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 196-20020a6300cd000000b0040c9c64e7e4so8940572pga.9
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 11:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=WyqPYSVnBKbl/nr40y7sE7AfbPIEB8jJthH3qsZRwTA=;
        b=dnqfTJXGdi0+0FQWJVIluP9qFR8tn9FFDKE/o7TQ9D9+9nSIvt3ROmw8bwLqp/nk0a
         bf0FuVwic/qm0DrYAJCc1pFXDdpTPmT0tSbEICTZ+pfYV8DKzRFTdF+141+GjWUjwQRp
         QzLvsqovmrnEMyfDJ/7HdhFzKkCciuR3Qi1ipw5Cf7TI8Nz9EV4yYk3UBrTQYNHllrja
         bTeWVLAzCLBiMBiVRXMeEqceXRlQr+0luk8omnYLqhs/NFnKe48+83GAn6wUStYTqssD
         8UL1kyN+jlNMOBCpH9Uw7CRSsyrrMlr41sMk6fy8bYqO6OEoVY1b3mo2E3g0pxJf4FgO
         JoHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=WyqPYSVnBKbl/nr40y7sE7AfbPIEB8jJthH3qsZRwTA=;
        b=TJlNSCddv8zboJ0anGmwkF2eWsgXt7/UKvzasNwpNZv76bN28UjUmSZHVDttU7fzah
         MWdsYzz93gZwXbX4+RloOXMmJKlaTJKxtr+8CzBFbNr7RHC/I9rZxB1v4gfNtjrShEf1
         +rZfvyW+0ylAf+GET/Z33dENjCdnnLbMazXhuj3u/QvJLdMu/bh8TFO2Is7Tl7qRuIfs
         CYDTAkTLUMz3XeScEUEFyHN6QfwlYsM99MOOjDALM4BmA3oYNoND20smvl9/PctjfE8F
         nRZaAwGL3wkLcjberqn4aCxl1mPAD95Ck4auO0quweCZdGsstGzDfmt+LWgo1S5c/9tT
         QrSw==
X-Gm-Message-State: AJIora/197dCcSbAx0SKBangyRploBGdriBtqpsfzp+CFo8XHura3ZWK
        vK8GlYGt46nLB2HF/OBXsaZ2BQBrB6GfjRUiBg==
X-Google-Smtp-Source: AGRyM1vSxJ9bzN8oLzDMI9yoXtg62L3jELXqZ7ufsfb/vBottKkE9UgYhVK36UnCmznaz0cAiYEvHbEc1ywsdTpTaw==
X-Received: from justinstitt.mtv.corp.google.com ([2620:15c:211:202:4640:519a:f833:9a5])
 (user=justinstitt job=sendgmr) by 2002:aa7:8e86:0:b0:528:c755:1d96 with SMTP
 id a6-20020aa78e86000000b00528c7551d96mr5326209pfr.30.1657217744245; Thu, 07
 Jul 2022 11:15:44 -0700 (PDT)
Date:   Thu,  7 Jul 2022 11:15:32 -0700
Message-Id: <20220707181532.762452-1-justinstitt@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH] net: ipv4: esp4: fix clang -Wformat warning
From:   Justin Stitt <justinstitt@google.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Justin Stitt <justinstitt@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When building with Clang we encounter this warning:
| net/ipv4/esp4.c:1114:5: error: format specifies type 'unsigned short'
| but the argument has type 'int' [-Werror,-Wformat]
| aalg_desc->uinfo.auth.icv_fullbits / 8);

`aalg_desc->uinfo.auth.icv_fullbits` is a u16 but due to default
argument promotion becomes an int.

Variadic functions (printf-like) undergo default argument promotion.
Documentation/core-api/printk-formats.rst specifically recommends using
the promoted-to-type's format flag.

As per C11 6.3.1.1:
(https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1548.pdf) `If an int
can represent all values of the original type ..., the value is
converted to an int; otherwise, it is converted to an unsigned int.
These are called the integer promotions.` Thus it makes sense to change
%hu to %d not only to follow this standard but to suppress the warning
as well.

Nathan also mentions: This solution is in line with printk-formats.rst
after commit cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging use
of unnecessary %h[xudi] and %hh[xudi]").

Link: https://github.com/ClangBuiltLinux/linux/issues/378
Suggested-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Justin Stitt <justinstitt@google.com>
---
This is the exact same issue (and fix) as:
https://lore.kernel.org/all/20220707173040.704116-1-justinstitt@google.com/

This really should have been a 2-patch series but I've been going
through warnings and systematically fixing them whilst submitting
patches as I go.

 net/ipv4/esp4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index b21238df3301..de48dcac18eb 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -1108,7 +1108,7 @@ static int esp_init_authenc(struct xfrm_state *x)
 		err = -EINVAL;
 		if (aalg_desc->uinfo.auth.icv_fullbits / 8 !=
 		    crypto_aead_authsize(aead)) {
-			pr_info("ESP: %s digestsize %u != %hu\n",
+			pr_info("ESP: %s digestsize %u != %d\n",
 				x->aalg->alg_name,
 				crypto_aead_authsize(aead),
 				aalg_desc->uinfo.auth.icv_fullbits / 8);
-- 
2.37.0.rc0.161.g10f37bed90-goog

