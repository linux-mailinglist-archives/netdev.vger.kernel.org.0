Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE84034404A
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 12:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbhCVL5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 07:57:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:45968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230293AbhCVL5H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 07:57:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6B3161994;
        Mon, 22 Mar 2021 11:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616414226;
        bh=fi5OxG2FihnWpnafMgRyJTvjUbox1QRr98ztmyJO8DI=;
        h=From:To:Cc:Subject:Date:From;
        b=Q3EO4JwMI6jYU8ZjOOMD9sDgeizAirLCyFjMfcd1r0bh0KeTW9yOVQhrA4Ajr6e/Z
         FyFg8YJJqLhzPTFnokP1ll+/ysqUeTg7vrO2DlZobzKsk5s4DruolS0kJMZOAgQmKH
         Z/tVyexXjfD+y4iO8T5aKucUin8pbLPuFLhPeYB5y3L09KG5cSphJsPYH3/D3HaGrp
         pAAE2Gg0s/oUlAKJLgiPy+p5wLSwvsAHfQsdXoXVluXBuKR+6D8CCYPIis4eiDNZc2
         aF8s5VyNg6Iic+XpdESIkH0dOwkV4CsSGIFgvKvjisuzQbMiZv4jYtmS3X8aLLQC5w
         r7rjp0ZztvsIQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Willem de Bruijn <willemb@google.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH net-next] ipv6: fix clang Wformat warning
Date:   Mon, 22 Mar 2021 12:56:49 +0100
Message-Id: <20210322115701.4035289-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
2.29.2

