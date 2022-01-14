Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B426448EB8A
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 15:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237352AbiANOUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 09:20:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235371AbiANOUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 09:20:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CD3C061574;
        Fri, 14 Jan 2022 06:20:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3708461CE8;
        Fri, 14 Jan 2022 14:20:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7FD1C36AEA;
        Fri, 14 Jan 2022 14:20:37 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="fbH4Mvht"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1642170037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=arKs06J8UnnDJVyqeR4qdEPwABwHy9oEX6qlki11Aeg=;
        b=fbH4MvhtEoAfMs7PWUduRCDd/1cRJ0xxZYCa/rpJzGbOQ/4YYmHdft+o3OVCa9YjbkOMrI
        mHvbHRa0dKiGasg5p2vtSYfyxyRrs8VsV9wXFvisUtLikoiFZ3CPiVT9A0HsCLX0b7bYbM
        sIPCgYPeDrC0w8IARRvoVomeKYr/YWo=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 67a4c572 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 14 Jan 2022 14:20:37 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: [PATCH RFC v2 1/3] bpf: move from sha1 to blake2s in tag calculation
Date:   Fri, 14 Jan 2022 15:20:13 +0100
Message-Id: <20220114142015.87974-2-Jason@zx2c4.com>
In-Reply-To: <20220114142015.87974-1-Jason@zx2c4.com>
References: <20220114142015.87974-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BLAKE2s is faster and more secure. SHA-1 has been broken for a long time
now. This also removes quite a bit of code, and lets us potentially
remove sha1 from lib, which would further reduce vmlinux size.

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 kernel/bpf/core.c | 39 ++++-----------------------------------
 1 file changed, 4 insertions(+), 35 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index de3e5bc6781f..20a799d36ba8 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -33,6 +33,7 @@
 #include <linux/extable.h>
 #include <linux/log2.h>
 #include <linux/bpf_verifier.h>
+#include <crypto/blake2s.h>
 
 #include <asm/barrier.h>
 #include <asm/unaligned.h>
@@ -265,24 +266,16 @@ void __bpf_prog_free(struct bpf_prog *fp)
 
 int bpf_prog_calc_tag(struct bpf_prog *fp)
 {
-	const u32 bits_offset = SHA1_BLOCK_SIZE - sizeof(__be64);
 	u32 raw_size = bpf_prog_tag_scratch_size(fp);
-	u32 digest[SHA1_DIGEST_WORDS];
-	u32 ws[SHA1_WORKSPACE_WORDS];
-	u32 i, bsize, psize, blocks;
 	struct bpf_insn *dst;
 	bool was_ld_map;
-	u8 *raw, *todo;
-	__be32 *result;
-	__be64 *bits;
+	u8 *raw;
+	int i;
 
 	raw = vmalloc(raw_size);
 	if (!raw)
 		return -ENOMEM;
 
-	sha1_init(digest);
-	memset(ws, 0, sizeof(ws));
-
 	/* We need to take out the map fd for the digest calculation
 	 * since they are unstable from user space side.
 	 */
@@ -307,31 +300,7 @@ int bpf_prog_calc_tag(struct bpf_prog *fp)
 		}
 	}
 
-	psize = bpf_prog_insn_size(fp);
-	memset(&raw[psize], 0, raw_size - psize);
-	raw[psize++] = 0x80;
-
-	bsize  = round_up(psize, SHA1_BLOCK_SIZE);
-	blocks = bsize / SHA1_BLOCK_SIZE;
-	todo   = raw;
-	if (bsize - psize >= sizeof(__be64)) {
-		bits = (__be64 *)(todo + bsize - sizeof(__be64));
-	} else {
-		bits = (__be64 *)(todo + bsize + bits_offset);
-		blocks++;
-	}
-	*bits = cpu_to_be64((psize - 1) << 3);
-
-	while (blocks--) {
-		sha1_transform(digest, todo, ws);
-		todo += SHA1_BLOCK_SIZE;
-	}
-
-	result = (__force __be32 *)digest;
-	for (i = 0; i < SHA1_DIGEST_WORDS; i++)
-		result[i] = cpu_to_be32(digest[i]);
-	memcpy(fp->tag, result, sizeof(fp->tag));
-
+	blake2s(fp->tag, raw, NULL, sizeof(fp->tag), bpf_prog_insn_size(fp), 0);
 	vfree(raw);
 	return 0;
 }
-- 
2.34.1

