Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBF6B57B257
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 10:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238628AbiGTIJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 04:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238262AbiGTIJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 04:09:20 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EF0340BE8
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 01:09:19 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id C715B20600;
        Wed, 20 Jul 2022 10:09:16 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id aXHDPR8ANNjo; Wed, 20 Jul 2022 10:09:15 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id B6CAA2060D;
        Wed, 20 Jul 2022 10:09:15 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id ADFD280004A;
        Wed, 20 Jul 2022 10:09:15 +0200 (CEST)
Received: from mbx-dresden-01.secunet.de (10.53.40.199) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 20 Jul 2022 10:09:15 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-dresden-01.secunet.de
 (10.53.40.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 20 Jul
 2022 10:09:14 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 35B7D3182A75; Wed, 20 Jul 2022 10:09:14 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 2/2] net: ipv4: fix clang -Wformat warnings
Date:   Wed, 20 Jul 2022 10:09:12 +0200
Message-ID: <20220720080912.1183369-3-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220720080912.1183369-1-steffen.klassert@secunet.com>
References: <20220720080912.1183369-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-dresden-01.secunet.de (10.53.40.199)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Justin Stitt <justinstitt@google.com>

When building with Clang we encounter these warnings:
| net/ipv4/ah4.c:513:4: error: format specifies type 'unsigned short' but
| the argument has type 'int' [-Werror,-Wformat]
| aalg_desc->uinfo.auth.icv_fullbits / 8);
-
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

Link: https://github.com/ClangBuiltLinux/linux/issues/378
Signed-off-by: Justin Stitt <justinstitt@google.com>
Suggested-by: Joe Perches <joe@perches.com>
Suggested-by: Nathan Chancellor <nathan@kernel.org>
Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv4/ah4.c  | 2 +-
 net/ipv4/esp4.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ah4.c b/net/ipv4/ah4.c
index 6eea1e9e998d..f8ad04470d3a 100644
--- a/net/ipv4/ah4.c
+++ b/net/ipv4/ah4.c
@@ -507,7 +507,7 @@ static int ah_init_state(struct xfrm_state *x)
 
 	if (aalg_desc->uinfo.auth.icv_fullbits/8 !=
 	    crypto_ahash_digestsize(ahash)) {
-		pr_info("%s: %s digestsize %u != %hu\n",
+		pr_info("%s: %s digestsize %u != %u\n",
 			__func__, x->aalg->alg_name,
 			crypto_ahash_digestsize(ahash),
 			aalg_desc->uinfo.auth.icv_fullbits / 8);
diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index b21238df3301..b694f352ce7a 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -1108,7 +1108,7 @@ static int esp_init_authenc(struct xfrm_state *x)
 		err = -EINVAL;
 		if (aalg_desc->uinfo.auth.icv_fullbits / 8 !=
 		    crypto_aead_authsize(aead)) {
-			pr_info("ESP: %s digestsize %u != %hu\n",
+			pr_info("ESP: %s digestsize %u != %u\n",
 				x->aalg->alg_name,
 				crypto_aead_authsize(aead),
 				aalg_desc->uinfo.auth.icv_fullbits / 8);
-- 
2.25.1

