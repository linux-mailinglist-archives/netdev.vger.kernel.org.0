Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFFA144DB75
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 19:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233928AbhKKSNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 13:13:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbhKKSNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 13:13:18 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E01C061766
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 10:10:29 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id k4so6343587plx.8
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 10:10:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2hbxcGdbqWNtO508aPnYX55OPutjvdd+CY5vEVUnG0E=;
        b=QW0brS9OnnH+o6xyDY+Sg3p4VLqp4ErqqNs8AKIvgock62gfatwkrJ/Bxys/cVWiYM
         SnwzWOfUFU2oTfPbsCrV6GUeP/4Qxug/gZkqJWTWNjB4wlKDXedRDi6m9PIaI+i8gcVE
         n7Wmw0cSZiFOuWnBeH1bewKk16fVUNFiv75MMYxuPjGSgx903FC17aIy09a7p4fy+G2S
         yJqqNRIYc225q5UTbta614RaguEYrkf/PUqzqFvd2kjl6fzLmeCaZb9N0GDHeF6gyUup
         s0eWRsZdta9kaLeVRVsHgW9834jWfzGPDbxxX9sEqnYz2Rxg1+QcY42mJfCHxlAE5oIC
         zPLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2hbxcGdbqWNtO508aPnYX55OPutjvdd+CY5vEVUnG0E=;
        b=NpQTyd5A8cuv3aGakGeuhPzBB6CX+6cLrD0PaI5Op00ML1WDaryJlKOjhcxiS7e2+G
         7I6FzQhmTmUiHaGsraq3oh+u+ntENQiWiAxzqQfXCnTpadlGlp93oG/8mv5max8tiauh
         fVNQq2TwdBSBp1wErE/4iNYrwy4YRWiQxvAeActK0j5kPGr0+nwD2UWlkaknKcm8qiMj
         A9CDmU2Q2CpWTpedF5zbmvBpCNQnIJVB2UHejotFZObRMl98UIRWhMnbre8dSnHfvjJU
         bvUVAwx+cV4WGLYJFhU+vO3w6XZWPosbuOpeCXNNTELEMFmIZq+GwkdzebZSwIwFTrpS
         hZfA==
X-Gm-Message-State: AOAM530scEaXjLE/qpXiD1TcuDRHgnPzn08bALh1GuFo4Ss2pK5pbSQQ
        IvfjREZwJdu4jiUu4r7mrNveb4Pj8A4=
X-Google-Smtp-Source: ABdhPJyzWZxtJjJESmldPJk9o5uy1U5kD+EsHmMIWCJUn9J9WrJ/TtODKKT6rmq9PmWq/7VacaoH/Q==
X-Received: by 2002:a17:90b:3b8e:: with SMTP id pc14mr10158372pjb.129.1636654228961;
        Thu, 11 Nov 2021 10:10:28 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:9e5b:8f30:564d:2a17])
        by smtp.gmail.com with ESMTPSA id l3sm3623846pff.4.2021.11.11.10.10.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 10:10:28 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, x86@kernel.org,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v1] x86/csum: rewrite csum_partial()
Date:   Thu, 11 Nov 2021 10:10:25 -0800
Message-Id: <20211111181025.2139131-1-eric.dumazet@gmail.com>
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
to 'align the buffer', then perform seven u64 additions
with carry in a loop, then a remaining u32, then a remaining u16.

With this new version, we perform 10 u32 adds with carry, to
avoid the expensive 64->32 transformation.

Also note that this avoids loops for less than ~60 bytes.

Tested on various cpus, all of them show a big reduction in
csum_partial() cost (by 50 to 75 %)

v2: - removed the hard-coded switch(), as it was not RETPOLINE aware.
    - removed the final add32_with_carry() that we were doing
      in csum_partial(), we can simply pass @sum to do_csum()

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/lib/csum-partial_64.c | 151 +++++++++++++++++----------------
 1 file changed, 76 insertions(+), 75 deletions(-)

diff --git a/arch/x86/lib/csum-partial_64.c b/arch/x86/lib/csum-partial_64.c
index e7925d668b680269fb2442766deaf416dc42f9a1..910806a1b954c5fed90020191143d16aec74bf0a 100644
--- a/arch/x86/lib/csum-partial_64.c
+++ b/arch/x86/lib/csum-partial_64.c
@@ -21,97 +21,99 @@ static inline unsigned short from32to16(unsigned a)
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
-static unsigned do_csum(const unsigned char *buff, unsigned len)
+static unsigned do_csum(const unsigned char *buff, unsigned len, u32 result)
 {
-	unsigned odd, count;
-	unsigned long result = 0;
+	unsigned odd;
 
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
-
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
-
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
-
-			if (len & 4) {
-				result += *(unsigned int *) buff;
-				buff += 4;
-			}
-		}
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
+	if (len & 32) {
+		asm("	addl 0*4(%[src]),%[res]\n"
+		    "	adcl 1*4(%[src]),%[res]\n"
+		    "	adcl 2*4(%[src]),%[res]\n"
+		    "	adcl 3*4(%[src]),%[res]\n"
+		    "	adcl 4*4(%[src]),%[res]\n"
+		    "	adcl 5*4(%[src]),%[res]\n"
+		    "	adcl 6*4(%[src]),%[res]\n"
+		    "	adcl 7*4(%[src]),%[res]\n"
+		    "	adcl $0,%[res]"
+			: [res] "=r" (result)
+			: [src] "r" (buff), "[res]" (result)
+			: "memory");
+		buff += 32;
+	}
+	if (len & 16) {
+		asm("	addl 0*4(%[src]),%[res]\n"
+		    "	adcl 1*4(%[src]),%[res]\n"
+		    "	adcl 2*4(%[src]),%[res]\n"
+		    "	adcl 3*4(%[src]),%[res]\n"
+		    "	adcl $0,%[res]"
+			: [res] "=r" (result)
+			: [src] "r" (buff), "[res]" (result)
+			: "memory");
+		buff += 16;
+	}
+	if (len & 8) {
+		asm("	addl 0*4(%[src]),%[res]\n"
+		    "	adcl 1*4(%[src]),%[res]\n"
+		    "	adcl $0,%[res]"
+			: [res] "=r" (result)
+			: [src] "r" (buff), "[res]" (result)
+			: "memory");
+		buff += 8;
+	}
+	if (len & 4) {
+		asm("	addl 0*4(%[src]),%[res]\n"
+		    "	adcl $0,%[res]\n"
+			: [res] "=r" (result)
+			: [src] "r" (buff), "[res]" (result)
+			: "memory");
+		buff += 4;
+	}
+	if (len & 3U) {
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
@@ -133,8 +135,7 @@ static unsigned do_csum(const unsigned char *buff, unsigned len)
  */
 __wsum csum_partial(const void *buff, int len, __wsum sum)
 {
-	return (__force __wsum)add32_with_carry(do_csum(buff, len),
-						(__force u32)sum);
+	return (__force __wsum)do_csum(buff, len, (__force u32)sum);
 }
 EXPORT_SYMBOL(csum_partial);
 
-- 
2.34.0.rc1.387.gb447b232ab-goog

