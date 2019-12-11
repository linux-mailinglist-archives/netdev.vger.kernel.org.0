Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7654911A700
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 10:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbfLKJ1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 04:27:37 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:34217 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727493AbfLKJ1h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 04:27:37 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id d86f8824;
        Wed, 11 Dec 2019 08:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=//5qwTghPPq3ufYyCtI8PBz0K
        x8=; b=KLDm1GD3JIdDKDUXiPHEPQcvixQk9WfLbj2Y+DiR5sK4oiLOptHs3gK9c
        xxhVl98rnkkql6T71wweePWc5DypqU3KeNK+hrJvpNZNyvulHos+jUOS1nI9pvtB
        TGX6lUvHihaJCuuEuAoAV/kQCIN57mH62mLRMJQuv13c2jsU61YslYnFsCevKTRF
        8azP/hREllsyrzApWwJC7pGgNCWtJwd3SpVBdxGTGt6cLLGxSi6TsW8W3SoHCDcz
        IRjnFj/aaubEa44LmAiZShluxipse3l8f48NOhnK1X6FvFucxoAxBytByWNLiyNF
        uxt8OGP347CxHqhHlKaWGrgkxMr9Q==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 6aaa56e1 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Wed, 11 Dec 2019 08:31:56 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        sfr@canb.auug.org.au, "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 1/2] crypto: arm/curve25519 - add arch-specific key generation function
Date:   Wed, 11 Dec 2019 10:26:39 +0100
Message-Id: <20191211092640.107621-1-Jason@zx2c4.com>
In-Reply-To: <20191211102455.7b55218e@canb.auug.org.au>
References: <20191211102455.7b55218e@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Somehow this was forgotten when Zinc was being split into oddly shaped
pieces, resulting in linker errors. The x86_64 glue has a specific key
generation implementation, but the Arm one does not. However, it can
still receive the NEON speedups by calling the ordinary DH function
using the base point.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 arch/arm/crypto/curve25519-glue.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/crypto/curve25519-glue.c b/arch/arm/crypto/curve25519-glue.c
index f3f42cf3b893..776ae07e0469 100644
--- a/arch/arm/crypto/curve25519-glue.c
+++ b/arch/arm/crypto/curve25519-glue.c
@@ -38,6 +38,13 @@ void curve25519_arch(u8 out[CURVE25519_KEY_SIZE],
 }
 EXPORT_SYMBOL(curve25519_arch);
 
+void curve25519_base_arch(u8 pub[CURVE25519_KEY_SIZE],
+			  const u8 secret[CURVE25519_KEY_SIZE])
+{
+	return curve25519_arch(pub, secret, curve25519_base_point);
+}
+EXPORT_SYMBOL(curve25519_base_arch);
+
 static int curve25519_set_secret(struct crypto_kpp *tfm, const void *buf,
 				 unsigned int len)
 {
-- 
2.24.0

