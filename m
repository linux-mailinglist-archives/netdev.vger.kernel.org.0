Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9DF635F162
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 12:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233557AbhDNKRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 06:17:34 -0400
Received: from mailout1.secunet.com ([62.96.220.44]:33382 "EHLO
        mailout1.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233391AbhDNKR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 06:17:27 -0400
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id A8F0F800058;
        Wed, 14 Apr 2021 12:17:04 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 14 Apr 2021 12:17:04 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 14 Apr
 2021 12:17:03 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 999C831803D4; Wed, 14 Apr 2021 12:17:03 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 3/3] ipv6: fix clang Wformat warning
Date:   Wed, 14 Apr 2021 12:17:01 +0200
Message-ID: <20210414101701.324777-4-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210414101701.324777-1-steffen.klassert@secunet.com>
References: <20210414101701.324777-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

When building with 'make W=1', clang warns about a mismatched
format string:

net/ipv6/ah6.c:710:4: error: format specifies type 'unsigned short' but the argument has type 'int' [-Werror,-Wformat]
                        aalg_desc->uinfo.auth.icv_fullbits/8);
                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
include/linux/printk.h:375:34: note: expanded from macro 'pr_info'
        printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
                                ~~~     ^~~~~~~~~~~
net/ipv6/esp6.c:1153:5: error: format specifies type 'unsigned short' but the argument has type 'int' [-Werror,-Wformat]
                                aalg_desc->uinfo.auth.icv_fullbits / 8);
                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
include/linux/printk.h:375:34: note: expanded from macro 'pr_info'
        printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
                                ~~~     ^~~~~~~~~~~

Here, the result of dividing a 16-bit number by a 32-bit number
produces a 32-bit result, which is printed as a 16-bit integer.

Change the %hu format to the normal %u, which has the same effect
but avoids the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv6/ah6.c  | 2 +-
 net/ipv6/esp6.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ah6.c b/net/ipv6/ah6.c
index 440080da805b..01c638f5d8b8 100644
--- a/net/ipv6/ah6.c
+++ b/net/ipv6/ah6.c
@@ -705,7 +705,7 @@ static int ah6_init_state(struct xfrm_state *x)
 
 	if (aalg_desc->uinfo.auth.icv_fullbits/8 !=
 	    crypto_ahash_digestsize(ahash)) {
-		pr_info("AH: %s digestsize %u != %hu\n",
+		pr_info("AH: %s digestsize %u != %u\n",
 			x->aalg->alg_name, crypto_ahash_digestsize(ahash),
 			aalg_desc->uinfo.auth.icv_fullbits/8);
 		goto error;
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 153ad103ba74..831a588b04a2 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -1147,7 +1147,7 @@ static int esp_init_authenc(struct xfrm_state *x)
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

