Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F054A1CCD21
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 21:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729137AbgEJTDF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 10 May 2020 15:03:05 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:22797 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728756AbgEJTDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 15:03:05 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-133-7jIaSIUuNyWgyf7ofW108g-1; Sun, 10 May 2020 20:03:01 +0100
X-MC-Unique: 7jIaSIUuNyWgyf7ofW108g-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Sun, 10 May 2020 20:03:00 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Sun, 10 May 2020 20:03:00 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'linux-kernel' <linux-kernel@vger.kernel.org>,
        "'x86@kernel.org'" <x86@kernel.org>,
        'Thomas Gleixner' <tglx@linutronix.de>
CC:     "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH v2] x86: Optimise x86 IP checksum code
Thread-Topic: [PATCH v2] x86: Optimise x86 IP checksum code
Thread-Index: AdYm/VZGETJD/lnbRaKYogOSYrBH0w==
Date:   Sun, 10 May 2020 19:03:00 +0000
Message-ID: <d7d167a576934b149a90e46e2247b91b@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Performance improvements to the amd64 IP checksum code.
Summing to alternate registers almost doubles the performace
(probably from 4 to 6.2 bytes/clock) on Ivy Bridge cpu.
Loop carrying the carry flag improves Haswell from 7 to 8 bytes/clock.
Older cpu will still approach 4 bytes/clock.
All achieved with a less loop unrolling - improving the performance
for small buffers that are not a multiple of the loop span.

Signed-off-by: David Laight <david.laight@aculab.com>
--

Changes since v1:
- Added cast to result.

I spent far too long looking at this for some code that has to calculate the
UDP checksum before sending packets through a raw IPv4 socket.

Prior to Ivy (maybe Sandy) bridge adc always took two clocks, so the adc chain
can only run at 4 bytes/clock (the same as 32bit adds to a 64 bit register).
In Ivy bridge the 'carry' flag is available a clock earlier so 8 bytes/clock
is technically possible.

In order to 'loop carry' the carry flag some ingenuity is needed.
Although 'dec reg' doesn't change carry, it has a partial dependency against
the flags register - which makes the loop very slow.
The loop instruction (dec %cx, jump non-zero) is far too slow on Intel cpu.
But jcxz (jump if %cx zero) is about the same as a normal conditional jump.

I did get about 12 bytes/clock using adox/adcx but that would need run-time
patching and some cpu that support the instructions may run them very slowly.

arch/x86/lib/csum-partial_64.c | 192 +++++++++++++++++++++--------------------
 1 file changed, 98 insertions(+), 94 deletions(-)

diff --git a/arch/x86/lib/csum-partial_64.c b/arch/x86/lib/csum-partial_64.c
index e7925d6..7f25ab2 100644
--- a/arch/x86/lib/csum-partial_64.c
+++ b/arch/x86/lib/csum-partial_64.c
@@ -10,113 +10,118 @@
 #include <linux/export.h>
 #include <asm/checksum.h>
 
-static inline unsigned short from32to16(unsigned a) 
-{
-	unsigned short b = a >> 16; 
-	asm("addw %w2,%w0\n\t"
-	    "adcw $0,%w0\n" 
-	    : "=r" (b)
-	    : "0" (b), "r" (a));
-	return b;
-}
-
 /*
  * Do a 64-bit checksum on an arbitrary memory area.
  * Returns a 32bit checksum.
  *
  * This isn't as time critical as it used to be because many NICs
  * do hardware checksumming these days.
+ *
+ * All Intel cpus prior to Ivy Bridge (mayby Sandy Bridge) have a 2 clock
+ * latency on the result of adc.
+ * This limits any adc loop to 4 bytes/clock - the same as a C loop
+ * that adds 32 bit values to a 64 bit register.
+ * On Ivy bridge the adc result latency is still 2 clocks, but the carry
+ * latency is reduced to 1 clock.
+ * So summing to alternate registers increases the throughput to approaching
+ * 8 bytes/clock.
+ * Older cpu (eg core 2) have a 6+ clock delay accessing any of the flags
+ * after a partial update (eg adc after inc).
+ * The stange 'jecxz' loop avoids this.
+ * The Ivy bridge then needs the loop unrolling once more to approach
+ * 8 bytes per clock.
  * 
- * Things tried and found to not make it faster:
- * Manual Prefetching
- * Unrolling to an 128 bytes inner loop.
- * Using interleaving with more registers to break the carry chains.
+ * On 7th gen cpu using adox/adoc can get 12 bytes/clock (maybe 16?)
+ * provided the loop is unrolled further than the one below.
+ * But some other cpu that support the adx take 6 clocks for each.
+ *
+ * The 'sum' value on entry is added in, it can exceed 32 bits but
+ * must not get to 56 bits.
  */
-static unsigned do_csum(const unsigned char *buff, unsigned len)
+static unsigned do_csum(const unsigned char *buff, long len, u64 sum)
 {
-	unsigned odd, count;
-	unsigned long result = 0;
+	unsigned int src_align;
+	u64 sum_0 = 0, sum_1;
+	long len_tmp;
+	bool odd = false;
 
-	if (unlikely(len == 0))
-		return result; 
-	odd = 1 & (unsigned long) buff;
-	if (unlikely(odd)) {
-		result = *buff << 8;
-		len--;
-		buff++;
-	}
-	count = len >> 1;		/* nr of 16-bit words.. */
-	if (count) {
-		if (2 & (unsigned long) buff) {
-			result += *(unsigned short *)buff;
-			count--;
-			len -= 2;
-			buff += 2;
+	/* 64bit align the base address */
+	src_align = (unsigned long)buff & 7;
+	if (src_align) {
+		if (unlikely(src_align & 1)) {
+			sum <<= 8;
+			/* The extra flag generates better code! */
+			odd = true;
 		}
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
+		buff -= src_align;
+		len += src_align;
+		if (likely(src_align == 4))
+			sum_0 = *(u32 *)(buff + 4);
+		else
+			/* Mask off unwanted low bytes from full 64bit word */
+			sum_0 = *(u64 *)buff & (~0ull << (src_align * 8));
+		if (unlikely(len < 8)) {
+			/* Mask off the unwanted high bytes */
+			sum += sum_0 & ~(~0ull << (len * 8));
+			goto reduce_32;
+		}
+		len -= 8;
+		buff += 8;
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
+	/* Read first 8 bytes to 16 byte align the loop below */
+	sum_1 = len & 8 ? *(u64 *)buff : 0;
 
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
+	/* The main loop uses negative offsets from the end of the buffer */
+	buff += len;
 
-			if (len & 4) {
-				result += *(unsigned int *) buff;
-				buff += 4;
-			}
-		}
-		if (len & 2) {
-			result += *(unsigned short *) buff;
-			buff += 2;
-		}
+	/* Add in trailing bytes to 64bit align the length */
+	if (len & 7) {
+		unsigned int tail_len = len & 7;
+		buff -= tail_len;
+		if (likely(tail_len == 4))
+			sum += *(u32 *)buff;
+		else
+			/* Mask off the unwanted high bytes */
+			sum += *(u64 *)buff & ~(~0ull << (tail_len * 8));
 	}
-	if (len & 1)
-		result += *buff;
-	result = add32_with_carry(result>>32, result & 0xffffffff); 
-	if (unlikely(odd)) { 
-		result = from32to16(result);
-		result = ((result >> 8) & 0xff) | ((result & 0xff) << 8);
-	}
-	return result;
+
+	/* Align and negate len so that we need to sum [buff[len]..buf[0]) */
+	len = -(len & ~15);
+
+	/*
+	 * Align the byte count to a multiple of 16 then
+	 * add 64 bit words to alternating registers.
+	 * Finally reduce to 64 bits.
+	 */
+	asm(	"	bt    $4, %[len]\n"
+		"	jnc   10f\n"
+		"	add   (%[buff], %[len]), %[sum_0]\n"
+		"	adc   8(%[buff], %[len]), %[sum_1]\n"
+		"	lea   16(%[len]), %[len]\n"
+		"10:	jecxz 20f\n"
+		"	adc   (%[buff], %[len]), %[sum_0]\n"
+		"	adc   8(%[buff], %[len]), %[sum_1]\n"
+		"	lea   32(%[len]), %[len_tmp]\n"
+		"	adc   16(%[buff], %[len]), %[sum_0]\n"
+		"	adc   24(%[buff], %[len]), %[sum_1]\n"
+		"	mov   %[len_tmp], %[len]\n"
+		"	jmp   10b\n"
+		"20:	adc   %[sum_0], %[sum]\n"
+		"	adc   %[sum_1], %[sum]\n"
+		"	adc   $0, %[sum]\n"
+	    : [sum] "+&r" (sum), [sum_0] "+&r" (sum_0), [sum_1] "+&r" (sum_1),
+	    	[len] "+&c" (len), [len_tmp] "=&r" (len_tmp)
+	    : [buff] "r" (buff)
+	    : "memory" );
+
+reduce_32:
+	sum = add32_with_carry(sum>>32, sum & 0xffffffff); 
+
+	if (unlikely(odd))
+		return __builtin_bswap32(sum);
+
+	return sum;
 }
 
 /*
@@ -133,8 +138,7 @@ static unsigned do_csum(const unsigned char *buff, unsigned len)
  */
 __wsum csum_partial(const void *buff, int len, __wsum sum)
 {
-	return (__force __wsum)add32_with_carry(do_csum(buff, len),
-						(__force u32)sum);
+	return (__force __wsum)do_csum(buff, len, (__force u32)sum);
 }
 EXPORT_SYMBOL(csum_partial);
 
-- 
1.8.1.2

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

