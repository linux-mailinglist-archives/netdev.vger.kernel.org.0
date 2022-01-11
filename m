Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4B648AEDD
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 14:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241150AbiAKNt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 08:49:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241094AbiAKNtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 08:49:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10743C061751;
        Tue, 11 Jan 2022 05:49:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F06A61639;
        Tue, 11 Jan 2022 13:49:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14505C36AEB;
        Tue, 11 Jan 2022 13:49:53 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ZNMGXo8Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1641908991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3WqEHjfqE4Zyzu/qNdBLfRyfBWN4Gk0YJJEdY2wFzB0=;
        b=ZNMGXo8ZDF1V482kGCJu2hQyrdkOmoM1KYlVbLCBgX3oIZ4GMyDDRg5BjQcpOpt12pX1EW
        ffJnHDZ5rIRF8PGiPbG0TCvU5B95x2KQh/A4cD4LvbtVMKbukegYWcQMMYPDlqnqlCEL5B
        3E3AHYACSBfcJC39ELbRwOBr5nMadDU=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a8869ee1 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 11 Jan 2022 13:49:51 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        wireguard@lists.zx2c4.com, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, geert@linux-m68k.org, tytso@mit.edu,
        gregkh@linuxfoundation.org, jeanphilippe.aumasson@gmail.com,
        ardb@kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH crypto 1/2] lib/crypto: blake2s-generic: reduce code size on small systems
Date:   Tue, 11 Jan 2022 14:49:33 +0100
Message-Id: <20220111134934.324663-2-Jason@zx2c4.com>
In-Reply-To: <20220111134934.324663-1-Jason@zx2c4.com>
References: <CAHmME9qbnYmhvsuarButi6s=58=FPiti0Z-QnGMJ=OsMzy1eOg@mail.gmail.com>
 <20220111134934.324663-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Re-wind the loops entirely on kernels optimized for code size. This is
really not good at all performance-wise. But on m68k, it shaves off 4k
of code size, which is apparently important.

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 lib/crypto/blake2s-generic.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/lib/crypto/blake2s-generic.c b/lib/crypto/blake2s-generic.c
index 75ccb3e633e6..990f000e22ee 100644
--- a/lib/crypto/blake2s-generic.c
+++ b/lib/crypto/blake2s-generic.c
@@ -46,7 +46,7 @@ void blake2s_compress_generic(struct blake2s_state *state, const u8 *block,
 {
 	u32 m[16];
 	u32 v[16];
-	int i;
+	int i, j;
 
 	WARN_ON(IS_ENABLED(DEBUG) &&
 		(nblocks > 1 && inc != BLAKE2S_BLOCK_SIZE));
@@ -86,17 +86,23 @@ void blake2s_compress_generic(struct blake2s_state *state, const u8 *block,
 	G(r, 6, v[2], v[ 7], v[ 8], v[13]); \
 	G(r, 7, v[3], v[ 4], v[ 9], v[14]); \
 } while (0)
-		ROUND(0);
-		ROUND(1);
-		ROUND(2);
-		ROUND(3);
-		ROUND(4);
-		ROUND(5);
-		ROUND(6);
-		ROUND(7);
-		ROUND(8);
-		ROUND(9);
-
+		if (IS_ENABLED(CONFIG_CC_OPTIMIZE_FOR_SIZE)) {
+			for (i = 0; i < 10; ++i) {
+				for (j = 0; j < 8; ++j)
+					G(i, j, v[j % 4], v[((j + (j / 4)) % 4) + 4], v[((j + 2 * (j / 4)) % 4) + 8], v[((j + 3 * (j / 4)) % 4) + 12]);
+			}
+		} else {
+			ROUND(0);
+			ROUND(1);
+			ROUND(2);
+			ROUND(3);
+			ROUND(4);
+			ROUND(5);
+			ROUND(6);
+			ROUND(7);
+			ROUND(8);
+			ROUND(9);
+		}
 #undef G
 #undef ROUND
 
-- 
2.34.1

