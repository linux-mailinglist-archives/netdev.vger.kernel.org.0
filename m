Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55D3C44D212
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 07:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbhKKG4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 01:56:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbhKKG4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 01:56:15 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD6EAC061766
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 22:53:26 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so3950057pjb.1
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 22:53:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9Ei6J2RlcbOG/FecECv4wnp+rVeKrIA1snLHEYJiK7o=;
        b=nG1TmuqDG25GRunjekrdrijmOKmDnhGXA4iUIfq8qYJGNKVQPgmJ/dShAz72CfWfDP
         ozlEOPHfWTWnthZ+yTpxsKfxoUSRekXZ2KMCWzLCT/pUngAnnGDr9181BjMjGXG2fX58
         a8g5sabYtLy2sX85WpNo7BvNChsuBm7hyV5ydn2tXSGQI3rGz1XzUaBKtOiXQFDUMyIS
         SBAfNDTsB4Yei9iSNOG7nDe87JPFoLlhI2hbZwmpA88iKJGCeOPg2Jik8WJrYbT/zpvG
         mqs4FaZKJ5hhRi2Dd4VOj5/SkJHmXuFpVSlfvbj+93/vPEArfQeeboM06r6BMg6QscZp
         cwjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9Ei6J2RlcbOG/FecECv4wnp+rVeKrIA1snLHEYJiK7o=;
        b=qlYKV5fGsj6RCHcH2JoeGQDcaCZ+H3XQETwFgp5leuJI9nS3y3dcBPiMwWfE0F0AeN
         dfSyow/6Pq+t3fC/VCYjxoVkQnUwxU7qzM0VRDSRwJXTvcmcBilfTnulOIdkMLyiTi2F
         P6+YLDFNvB7xnvScnbkQbgid4+NmgDFt4pgFUR30eqskwQX+uUGrbADcc2mou0ZqnZqF
         AQEBAkmUQg/j3msW+sjAaDzu4yleN4Olyjbd3JA7BqsqKz92/wdvfe/ziX6QRewCUsvM
         juJPSn6R3BjGcJTmf8RLjjhhJM3B0FVO2UBr1uWpy2uan97lt1achsPhAi9sO5JMalan
         DqGw==
X-Gm-Message-State: AOAM531yEPZewd+rEQDCQ/3jyoCdzxF8VvOyYcms6wCbRFgpmf5O0zB+
        EQv4X9oao4CTrJCr/+cdmbnlxYL6o0I=
X-Google-Smtp-Source: ABdhPJxLUR/el9OHAqt5/5pmZHd5SRkdOfBWq4p3COPYhOlO0Q0KgZ6BSw01RstdIy6s/e4P5a2vQw==
X-Received: by 2002:a17:90b:19c8:: with SMTP id nm8mr24289956pjb.163.1636613606294;
        Wed, 10 Nov 2021 22:53:26 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:9e5b:8f30:564d:2a17])
        by smtp.gmail.com with ESMTPSA id z23sm1346861pgn.14.2021.11.10.22.53.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 22:53:25 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, x86@kernel.org,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [RFC] x86/csum: rewrite csum_partial()
Date:   Wed, 10 Nov 2021 22:53:22 -0800
Message-Id: <20211111065322.1261275-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

With more NIC supporting CHECKSUM_COMPLETE, and IPv6 being widely used.
csum_partial() is heavily used with small amount of bytes,
and is consuming many cycles.

IPv6 header size for instance is 40 bytes.

Another thing to consider is that NET_IP_ALIGN is 0 on x86,
meaning that network headers in RX path are not word-aligned,
unless the driver forces this.

This means that csum_partial() fetches one u16
to 'align the buffer', then perform seven u64 additions
with carry in a loop, then a remaining u32, then a remaining u16.

With this new version, we perform 10 u32 adds with carry, to
avoid the expensive 64->32 transformation. Using 5 u64 adds
plus one add32_with_carry() is more expensive.

Also note that this avoids loops for less than ~60 bytes.

Tested on various cpus, all of them show a big reduction in
csum_partial() cost (by 30 to 75 %)

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
---
 arch/x86/lib/csum-partial_64.c | 146 +++++++++++++++++----------------
 1 file changed, 77 insertions(+), 69 deletions(-)

diff --git a/arch/x86/lib/csum-partial_64.c b/arch/x86/lib/csum-partial_64.c
index e7925d668b680269fb2442766deaf416dc42f9a1..f48fe0ec9663ff3afa1b5403f135407b8b0fde01 100644
--- a/arch/x86/lib/csum-partial_64.c
+++ b/arch/x86/lib/csum-partial_64.c
@@ -21,97 +21,105 @@ static inline unsigned short from32to16(unsigned a)
 }
 
 /*
- * Do a 64-bit checksum on an arbitrary memory area.
+ * Do a checksum on an arbitrary memory area.
  * Returns a 32bit checksum.
  *
  * This isn't as time critical as it used to be because many NICs
  * do hardware checksumming these days.
- * 
- * Things tried and found to not make it faster:
- * Manual Prefetching
- * Unrolling to an 128 bytes inner loop.
- * Using interleaving with more registers to break the carry chains.
+ *
+ * Still, with CHECKSUM_COMPLETE this is called to compute
+ * checksums on IPv6 headers (40 bytes) and other small parts.
  */
 static unsigned do_csum(const unsigned char *buff, unsigned len)
 {
-	unsigned odd, count;
-	unsigned long result = 0;
+	unsigned long dwords;
+	unsigned odd, result = 0;
 
-	if (unlikely(len == 0))
-		return result; 
 	odd = 1 & (unsigned long) buff;
 	if (unlikely(odd)) {
+		if (unlikely(len == 0))
+			return result;
 		result = *buff << 8;
 		len--;
 		buff++;
 	}
-	count = len >> 1;		/* nr of 16-bit words.. */
-	if (count) {
-		if (2 & (unsigned long) buff) {
-			result += *(unsigned short *)buff;
-			count--;
-			len -= 2;
-			buff += 2;
-		}
-		count >>= 1;		/* nr of 32-bit words.. */
-		if (count) {
-			unsigned long zero;
-			unsigned count64;
-			if (4 & (unsigned long) buff) {
-				result += *(unsigned int *) buff;
-				count--;
-				len -= 4;
-				buff += 4;
-			}
-			count >>= 1;	/* nr of 64-bit words.. */
+	if (unlikely(len >= 64)) {
+		unsigned long temp64 = result;
+		do {
+			asm("	addq 0*8(%[src]),%[res]\n"
+			    "	adcq 1*8(%[src]),%[res]\n"
+			    "	adcq 2*8(%[src]),%[res]\n"
+			    "	adcq 3*8(%[src]),%[res]\n"
+			    "	adcq 4*8(%[src]),%[res]\n"
+			    "	adcq 5*8(%[src]),%[res]\n"
+			    "	adcq 6*8(%[src]),%[res]\n"
+			    "	adcq 7*8(%[src]),%[res]\n"
+			    "	adcq $0,%[res]"
+			    : [res] "=r" (temp64)
+			    : [src] "r" (buff), "[res]" (temp64)
+			    : "memory");
+			buff += 64;
+			len -= 64;
+		} while (len >= 64);
+		result = add32_with_carry(temp64 >> 32, temp64 & 0xffffffff);
+	}
 
-			/* main loop using 64byte blocks */
-			zero = 0;
-			count64 = count >> 3;
-			while (count64) { 
-				asm("addq 0*8(%[src]),%[res]\n\t"
-				    "adcq 1*8(%[src]),%[res]\n\t"
-				    "adcq 2*8(%[src]),%[res]\n\t"
-				    "adcq 3*8(%[src]),%[res]\n\t"
-				    "adcq 4*8(%[src]),%[res]\n\t"
-				    "adcq 5*8(%[src]),%[res]\n\t"
-				    "adcq 6*8(%[src]),%[res]\n\t"
-				    "adcq 7*8(%[src]),%[res]\n\t"
-				    "adcq %[zero],%[res]"
-				    : [res] "=r" (result)
-				    : [src] "r" (buff), [zero] "r" (zero),
-				    "[res]" (result));
-				buff += 64;
-				count64--;
-			}
+	dwords = len >> 2;
+	if (dwords) { /* dwords is in [1..15] */
+		unsigned long dest;
 
-			/* last up to 7 8byte blocks */
-			count %= 8; 
-			while (count) { 
-				asm("addq %1,%0\n\t"
-				    "adcq %2,%0\n" 
-					    : "=r" (result)
-				    : "m" (*(unsigned long *)buff), 
-				    "r" (zero),  "0" (result));
-				--count; 
-				buff += 8;
-			}
-			result = add32_with_carry(result>>32,
-						  result&0xffffffff); 
+		/*
+		 * This implements an optimized version of
+		 * switch (dwords) {
+		 * case 15: res = add_with_carry(res, buf32[14]); fallthrough;
+		 * case 14: res = add_with_carry(res, buf32[13]); fallthrough;
+		 * case 13: res = add_with_carry(res, buf32[12]); fallthrough;
+		 * ...
+		 * case 3: res = add_with_carry(res, buf32[2]); fallthrough;
+		 * case 2: res = add_with_carry(res, buf32[1]); fallthrough;
+		 * case 1: res = add_with_carry(res, buf32[0]); fallthrough;
+		 * }
+		 *
+		 * "adcl 8byteoff(%reg1),%reg2" are using either 3 or 4 bytes.
+		 */
+		asm("	call 1f\n"
+		    "1:	pop %[dest]\n"
+		    "	lea (2f-1b)(%[dest],%[skip],4),%[dest]\n"
+		    "	clc\n"
+		    "	jmp *%[dest]\n               .align 4\n"
+		    "2:\n"
+		    "	adcl 14*4(%[src]),%[res]\n   .align 4\n"
+		    "	adcl 13*4(%[src]),%[res]\n   .align 4\n"
+		    "	adcl 12*4(%[src]),%[res]\n   .align 4\n"
+		    "	adcl 11*4(%[src]),%[res]\n   .align 4\n"
+		    "	adcl 10*4(%[src]),%[res]\n   .align 4\n"
+		    "	adcl 9*4(%[src]),%[res]\n   .align 4\n"
+		    "	adcl 8*4(%[src]),%[res]\n   .align 4\n"
+		    "	adcl 7*4(%[src]),%[res]\n   .align 4\n"
+		    "	adcl 6*4(%[src]),%[res]\n   .align 4\n"
+		    "	adcl 5*4(%[src]),%[res]\n   .align 4\n"
+		    "	adcl 4*4(%[src]),%[res]\n   .align 4\n"
+		    "	adcl 3*4(%[src]),%[res]\n   .align 4\n"
+		    "	adcl 2*4(%[src]),%[res]\n   .align 4\n"
+		    "	adcl 1*4(%[src]),%[res]\n   .align 4\n"
+		    "	adcl 0*4(%[src]),%[res]\n"
+		    "	adcl $0,%[res]"
+			: [res] "=r" (result), [dest] "=&r" (dest)
+			: [src] "r" (buff), "[res]" (result),
+			  [skip] "r" (dwords ^ 15)
+			: "memory");
+	}
 
-			if (len & 4) {
-				result += *(unsigned int *) buff;
-				buff += 4;
-			}
-		}
+	if (len & 3U) {
+		buff += len & ~3U;
+		result = from32to16(result);
 		if (len & 2) {
 			result += *(unsigned short *) buff;
 			buff += 2;
 		}
+		if (len & 1)
+			result += *buff;
 	}
-	if (len & 1)
-		result += *buff;
-	result = add32_with_carry(result>>32, result & 0xffffffff); 
 	if (unlikely(odd)) { 
 		result = from32to16(result);
 		result = ((result >> 8) & 0xff) | ((result & 0xff) << 8);
-- 
2.34.0.rc0.344.g81b53c2807-goog

