Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D682F44EB42
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 17:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234496AbhKLQWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 11:22:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbhKLQWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 11:22:44 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4571CC061766
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 08:19:54 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so6772696pjb.5
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 08:19:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xMRYZxA32ONQx9oRABmwA3Cgct94yl2E8mP5PQ79wAA=;
        b=RLbGxV97ZjJPLibncskn7Q0pCRk8sgRhdoFsUbXc7kjgy/R7x73nLKsRUaciwqpmQP
         UWYTgUoUN/Nw65faKeIhZjJgMAXwa34EZrA3b8GfErfZfSWDr0QnOp9PrIk8eGNg3g3A
         gX5CGtIIuLz1euRAvsJRLOEcxSDtiAVrZ9JFK8L315eEN5RII/LTX7cZh8c/rD5jwwro
         lIDoHqbOds/GRKeLnOYdy52KaedwFCHJjrN38rL3xs9Qcw8yyNWhGxTaaKm6qM6nV/Uy
         WHmgKNa96nP2fkHDqir9DeM62IXp4rIqfEM2PjEPOps1kheMJ7T0kqrv7nVNWnsZuGWZ
         3M+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xMRYZxA32ONQx9oRABmwA3Cgct94yl2E8mP5PQ79wAA=;
        b=yz/UribLsA6BRIV52m5QEuNsrWmplM2NpIfsnMuUYIbRO0p796EQO1CBSA1J11+8ug
         X0/8HSzUhifTXZUo/XcQQUM4TqTfjfbOMDkTDIWddo0S46NN6xT+cZDX7tty2AtSjdoz
         iaxpZ1WAqyuwsBOkZRpjUnD3a37AoLTVcawC+Rm9FWbm3bFywUQZadPzQ+5iFR1+IN28
         XYmV1QaaO/YQax5VQl3GUgpW7pIiOkef+C6n9b384pMpyIrZtoFGDpBBmPnhX4Zp7/tt
         +d9VXtFUPfNsXyVDoIeZsK7WuUUjTFxBDqmb9v6KNp44tdduGny+Bw7alM+B8fA+Wj68
         54sg==
X-Gm-Message-State: AOAM530OPwH25ZSsBH6yhJTgYoOZ1Iqnts0Hlx7F4xgatN3cj5Zz4q4F
        Sf7JzuIqIlUT+fPbXqXG63s=
X-Google-Smtp-Source: ABdhPJwW6pIWA9DlStmZP4IbZCizhb7ADCENIjxct7kx86AOUAY5e1mLbe9lQ0Y9O9F1W0bILKNz6A==
X-Received: by 2002:a17:90a:fd8c:: with SMTP id cx12mr36858226pjb.11.1636733993834;
        Fri, 12 Nov 2021 08:19:53 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:ccd2:4af5:a996:4901])
        by smtp.gmail.com with ESMTPSA id h18sm7490406pfh.172.2021.11.12.08.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 08:19:53 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, x86@kernel.org,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>
Subject: [PATCH v2] x86/csum: rewrite csum_partial()
Date:   Fri, 12 Nov 2021 08:19:50 -0800
Message-Id: <20211112161950.528886-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
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
meaning that network headers are not word-aligned, unless
the driver forces this.

This means that csum_partial() fetches one u16
to 'align the buffer', then perform three u64 additions
with carry in a loop, then a remaining u32, then a remaining u16.

With this new version, we perform a loop only for the 64 bytes blocks,
then the remaining is bisected.

Tested on various cpus, all of them show a big reduction in
csum_partial() cost (by 50 to 80 %)

v3: - use "+r" (temp64) asm constraints (Andrew).
    - fold do_csum() in csum_partial(), as gcc does not inline it.
    - fix bug added in v2 for the "odd" case.
    - back using addcq, as Andrew pointed the clang bug that was adding
	  a stall on my hosts.
      (separate patch to add32_with_carry() will follow)
    - use load_unaligned_zeropad() for final 1-7 bytes (Peter & Alexander).

v2: - removed the hard-coded switch(), as it was not RETPOLINE aware.
    - removed the final add32_with_carry() that we were doing
      in csum_partial(), we can simply pass @sum to do_csum().

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>
---
 arch/x86/lib/csum-partial_64.c | 162 ++++++++++++++-------------------
 1 file changed, 67 insertions(+), 95 deletions(-)

diff --git a/arch/x86/lib/csum-partial_64.c b/arch/x86/lib/csum-partial_64.c
index e7925d668b680269fb2442766deaf416dc42f9a1..5ec35626945b6db2f7f41c6d46d5e422810eac46 100644
--- a/arch/x86/lib/csum-partial_64.c
+++ b/arch/x86/lib/csum-partial_64.c
@@ -9,6 +9,7 @@
 #include <linux/compiler.h>
 #include <linux/export.h>
 #include <asm/checksum.h>
+#include <asm/word-at-a-time.h>
 
 static inline unsigned short from32to16(unsigned a) 
 {
@@ -21,120 +22,92 @@ static inline unsigned short from32to16(unsigned a)
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
+ * it's best to have buff aligned on a 64-bit boundary
  */
-static unsigned do_csum(const unsigned char *buff, unsigned len)
+__wsum csum_partial(const void *buff, int len, __wsum sum)
 {
-	unsigned odd, count;
-	unsigned long result = 0;
+	u64 temp64 = (__force u64)sum;
+	unsigned odd, result;
 
-	if (unlikely(len == 0))
-		return result; 
 	odd = 1 & (unsigned long) buff;
 	if (unlikely(odd)) {
-		result = *buff << 8;
+		if (unlikely(len == 0))
+			return sum;
+		temp64 += (*(unsigned char *)buff << 8);
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
+	while (unlikely(len >= 64)) {
+		asm("addq 0*8(%[src]),%[res]\n\t"
+		    "adcq 1*8(%[src]),%[res]\n\t"
+		    "adcq 2*8(%[src]),%[res]\n\t"
+		    "adcq 3*8(%[src]),%[res]\n\t"
+		    "adcq 4*8(%[src]),%[res]\n\t"
+		    "adcq 5*8(%[src]),%[res]\n\t"
+		    "adcq 6*8(%[src]),%[res]\n\t"
+		    "adcq 7*8(%[src]),%[res]\n\t"
+		    "adcq $0,%[res]"
+		    : [res] "+r" (temp64)
+		    : [src] "r" (buff)
+		    : "memory");
+		buff += 64;
+		len -= 64;
+	}
+
+	if (len & 32) {
+		asm("addq 0*8(%[src]),%[res]\n\t"
+		    "adcq 1*8(%[src]),%[res]\n\t"
+		    "adcq 2*8(%[src]),%[res]\n\t"
+		    "adcq 3*8(%[src]),%[res]\n\t"
+		    "adcq $0,%[res]"
+			: [res] "+r" (temp64)
+			: [src] "r" (buff)
+			: "memory");
+		buff += 32;
+	}
+	if (len & 16) {
+		asm("addq 0*8(%[src]),%[res]\n\t"
+		    "adcq 1*8(%[src]),%[res]\n\t"
+		    "adcq $0,%[res]"
+			: [res] "+r" (temp64)
+			: [src] "r" (buff)
+			: "memory");
+		buff += 16;
+	}
+	if (len & 8) {
+		asm("addq 0*8(%[src]),%[res]\n\t"
+		    "adcq $0,%[res]"
+			: [res] "+r" (temp64)
+			: [src] "r" (buff)
+			: "memory");
+		buff += 8;
+	}
+	if (len & 7) {
+		unsigned int shift = (8 - (len & 7)) * 8;
+		unsigned long trail;
 
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
+		trail = (load_unaligned_zeropad(buff) << shift) >> shift;
 
-			if (len & 4) {
-				result += *(unsigned int *) buff;
-				buff += 4;
-			}
-		}
-		if (len & 2) {
-			result += *(unsigned short *) buff;
-			buff += 2;
-		}
+		asm("addq %[trail],%[res]\n\t"
+		    "adcq $0,%[res]"
+			: [res] "+r" (temp64)
+			: [trail] "r" (trail));
 	}
-	if (len & 1)
-		result += *buff;
-	result = add32_with_carry(result>>32, result & 0xffffffff); 
+	result = add32_with_carry(temp64 >> 32, temp64 & 0xffffffff);
 	if (unlikely(odd)) { 
 		result = from32to16(result);
 		result = ((result >> 8) & 0xff) | ((result & 0xff) << 8);
 	}
-	return result;
-}
-
-/*
- * computes the checksum of a memory block at buff, length len,
- * and adds in "sum" (32-bit)
- *
- * returns a 32-bit number suitable for feeding into itself
- * or csum_tcpudp_magic
- *
- * this function must be called with even lengths, except
- * for the last fragment, which may be odd
- *
- * it's best to have buff aligned on a 64-bit boundary
- */
-__wsum csum_partial(const void *buff, int len, __wsum sum)
-{
-	return (__force __wsum)add32_with_carry(do_csum(buff, len),
-						(__force u32)sum);
+	return (__force __wsum)result;
 }
 EXPORT_SYMBOL(csum_partial);
 
@@ -147,4 +120,3 @@ __sum16 ip_compute_csum(const void *buff, int len)
 	return csum_fold(csum_partial(buff,len,0));
 }
 EXPORT_SYMBOL(ip_compute_csum);
-
-- 
2.34.0.rc1.387.gb447b232ab-goog

