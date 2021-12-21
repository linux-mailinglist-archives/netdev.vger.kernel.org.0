Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930A847C23B
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 16:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238931AbhLUPGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 10:06:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238925AbhLUPGY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 10:06:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 300C7C061574;
        Tue, 21 Dec 2021 07:06:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDE08B816D7;
        Tue, 21 Dec 2021 15:06:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F15C36AEC;
        Tue, 21 Dec 2021 15:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640099181;
        bh=PIOehpe8QrxD1SierEdBT+o1WEmyINgWWB7fwouxwWk=;
        h=From:To:Cc:Subject:Date:From;
        b=PSQMdPegvQw0MAoG/PKYkSxrMHYvUAuvM2OKsgmTZYV3YLa33p57e8V/L6cHDLazA
         J2Jy0ej0VZSHSfF0wurtXOEz/uS0nl167dwPqq1lB+qIX1E2k3yQsJT8Yv83UD3rMQ
         2h9be3oLgyrazho19fYh5GjAPqaKEQeHw2kN3lf35YRxwlRZMuJjKJweCzMZnz1YSm
         YdR74HOlsC6PcWbj8aJfjhqIxG8RQ9iHZtseEMe32z35a21tEf8OgfoswnQftB8j+D
         Ihao0dTZwzk252w8sPsi7WRWw9uSCTxmiU1a9VqCPrID2gA/jG0HcA948t03ZGE4UT
         yveG+BZe/1Nhw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     herbert@gondor.apana.org.au
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        stable@vger.kernel.org, x86@kernel.org, ardb@kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH crypto] x86/aesni: don't require alignment of data
Date:   Tue, 21 Dec 2021 07:06:11 -0800
Message-Id: <20211221150611.3692437-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

x86 AES-NI routines can deal with unaligned data. Crypto context
(key, iv etc.) have to be aligned but we take care of that separately
by copying it onto the stack. We were feeding unaligned data into
crypto routines up until commit 83c83e658863 ("crypto: aesni -
refactor scatterlist processing") switched to use the full
skcipher API which uses cra_alignmask to decide data alignment.

This fixes 21% performance regression in kTLS.

Tested by booting with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y
(and running thru various kTLS packets).

CC: stable@vger.kernel.org # 5.15+
Fixes: 83c83e658863 ("crypto: aesni - refactor scatterlist processing")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: herbert@gondor.apana.org.au
CC: x86@kernel.org
CC: ardb@kernel.org
CC: linux-crypto@vger.kernel.org
---
 arch/x86/crypto/aesni-intel_glue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index e09f4672dd38..41901ba9d3a2 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -1107,7 +1107,7 @@ static struct aead_alg aesni_aeads[] = { {
 		.cra_flags		= CRYPTO_ALG_INTERNAL,
 		.cra_blocksize		= 1,
 		.cra_ctxsize		= sizeof(struct aesni_rfc4106_gcm_ctx),
-		.cra_alignmask		= AESNI_ALIGN - 1,
+		.cra_alignmask		= 0,
 		.cra_module		= THIS_MODULE,
 	},
 }, {
@@ -1124,7 +1124,7 @@ static struct aead_alg aesni_aeads[] = { {
 		.cra_flags		= CRYPTO_ALG_INTERNAL,
 		.cra_blocksize		= 1,
 		.cra_ctxsize		= sizeof(struct generic_gcmaes_ctx),
-		.cra_alignmask		= AESNI_ALIGN - 1,
+		.cra_alignmask		= 0,
 		.cra_module		= THIS_MODULE,
 	},
 } };
-- 
2.31.1

