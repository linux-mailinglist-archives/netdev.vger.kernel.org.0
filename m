Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A56D044D43E
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 10:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhKKJrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 04:47:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhKKJrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 04:47:17 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73B7CC061766
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 01:44:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qRRZXBN4MyCx/aCGB3xD+ZLB3GjtaRm3tKSwuUzML+c=; b=uNPFJv2ZTc1ksHZzCPkq1WPniy
        WTjg1owhysQT0kDvrhZk/6eMo5TLQoroXH5iKio+7TtlUjdXFmzJ9K6TCFgi7mFYMjf6hnCf/Aupm
        n2xerAPahhxTw31OUA7DUbdCnICw6aDgo5gOB+E+es0Mpht5NRkYoO1mrfU0uu3CleBDVSc3oX6R+
        fjeNkHSXotDhFyOrEvn9rMbAVO8YlRmpXrKYiTymOBb+JJdYKC1QDgezRsPMeLI9RoPI3kcNVnC+H
        84LLkzg7vhVg4hsVpvb9W3Sb2Y3W8VLHd5iQsILckCHAfj0Q4Gq2yrwkqAaY8xOTafA+nQQfbvRFd
        gXCyv6ng==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ml6d2-002cXI-Fn; Thu, 11 Nov 2021 09:44:21 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 496093000D5;
        Thu, 11 Nov 2021 10:44:20 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id F31FF2058B524; Thu, 11 Nov 2021 10:44:19 +0100 (CET)
Date:   Thu, 11 Nov 2021 10:44:19 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>, x86@kernel.org,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [RFC] x86/csum: rewrite csum_partial()
Message-ID: <YYzl8/7N+Tv/j0RV@hirez.programming.kicks-ass.net>
References: <20211111065322.1261275-1-eric.dumazet@gmail.com>
 <YYzd+zdzqUM5/ZKL@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYzd+zdzqUM5/ZKL@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 11, 2021 at 10:10:19AM +0100, Peter Zijlstra wrote:
> On Wed, Nov 10, 2021 at 10:53:22PM -0800, Eric Dumazet wrote:
> > +		/*
> > +		 * This implements an optimized version of
> > +		 * switch (dwords) {
> > +		 * case 15: res = add_with_carry(res, buf32[14]); fallthrough;
> > +		 * case 14: res = add_with_carry(res, buf32[13]); fallthrough;
> > +		 * case 13: res = add_with_carry(res, buf32[12]); fallthrough;
> > +		 * ...
> > +		 * case 3: res = add_with_carry(res, buf32[2]); fallthrough;
> > +		 * case 2: res = add_with_carry(res, buf32[1]); fallthrough;
> > +		 * case 1: res = add_with_carry(res, buf32[0]); fallthrough;
> > +		 * }
> > +		 *
> > +		 * "adcl 8byteoff(%reg1),%reg2" are using either 3 or 4 bytes.
> > +		 */
> > +		asm("	call 1f\n"
> > +		    "1:	pop %[dest]\n"
> 
> That's terrible. I think on x86_64 we can do: lea (%%rip), %[dest], not
> sure what would be the best way on i386.
> 
> > +		    "	lea (2f-1b)(%[dest],%[skip],4),%[dest]\n"
> > +		    "	clc\n"
> > +		    "	jmp *%[dest]\n               .align 4\n"
> 
> That's an indirect branch, you can't do that these days. This would need
> to use JMP_NOSPEC (except we don't have a !ASSEMBLER version of that.
> But that would also completely and utterly destroy performance.
> 
> Also, objtool would complain about this if it hadn't tripped over that
> first instruction:
> 
>  arch/x86/lib/csum-partial_64.o: warning: objtool: do_csum()+0x84: indirect jump found in RETPOLINE build
> 
> I'm not sure what the best way is to unroll loops without using computed
> gotos/jump-tables though :/
> 
> > +		    "2:\n"
> > +		    "	adcl 14*4(%[src]),%[res]\n   .align 4\n"
> > +		    "	adcl 13*4(%[src]),%[res]\n   .align 4\n"
> > +		    "	adcl 12*4(%[src]),%[res]\n   .align 4\n"
> > +		    "	adcl 11*4(%[src]),%[res]\n   .align 4\n"
> > +		    "	adcl 10*4(%[src]),%[res]\n   .align 4\n"
> > +		    "	adcl 9*4(%[src]),%[res]\n   .align 4\n"
> > +		    "	adcl 8*4(%[src]),%[res]\n   .align 4\n"
> > +		    "	adcl 7*4(%[src]),%[res]\n   .align 4\n"
> > +		    "	adcl 6*4(%[src]),%[res]\n   .align 4\n"
> > +		    "	adcl 5*4(%[src]),%[res]\n   .align 4\n"
> > +		    "	adcl 4*4(%[src]),%[res]\n   .align 4\n"
> > +		    "	adcl 3*4(%[src]),%[res]\n   .align 4\n"
> > +		    "	adcl 2*4(%[src]),%[res]\n   .align 4\n"
> > +		    "	adcl 1*4(%[src]),%[res]\n   .align 4\n"
> > +		    "	adcl 0*4(%[src]),%[res]\n"
> > +		    "	adcl $0,%[res]"
> 
> If only the CPU would accept: REP ADCL (%%rsi), %[res]   :/
> 
> > +			: [res] "=r" (result), [dest] "=&r" (dest)
> > +			: [src] "r" (buff), "[res]" (result),
> > +			  [skip] "r" (dwords ^ 15)
> > +			: "memory");
> > +	}

This is the best I could come up with ...

--- a/arch/x86/lib/csum-partial_64.c
+++ b/arch/x86/lib/csum-partial_64.c
@@ -32,7 +32,6 @@ static inline unsigned short from32to16(
  */
 static unsigned do_csum(const unsigned char *buff, unsigned len)
 {
-	unsigned long dwords;
 	unsigned odd, result = 0;
 
 	odd = 1 & (unsigned long) buff;
@@ -64,50 +63,54 @@ static unsigned do_csum(const unsigned c
 		result = add32_with_carry(temp64 >> 32, temp64 & 0xffffffff);
 	}
 
-	dwords = len >> 2;
-	if (dwords) { /* dwords is in [1..15] */
-		unsigned long dest;
-
-		/*
-		 * This implements an optimized version of
-		 * switch (dwords) {
-		 * case 15: res = add_with_carry(res, buf32[14]); fallthrough;
-		 * case 14: res = add_with_carry(res, buf32[13]); fallthrough;
-		 * case 13: res = add_with_carry(res, buf32[12]); fallthrough;
-		 * ...
-		 * case 3: res = add_with_carry(res, buf32[2]); fallthrough;
-		 * case 2: res = add_with_carry(res, buf32[1]); fallthrough;
-		 * case 1: res = add_with_carry(res, buf32[0]); fallthrough;
-		 * }
-		 *
-		 * "adcl 8byteoff(%reg1),%reg2" are using either 3 or 4 bytes.
-		 */
-		asm("	call 1f\n"
-		    "1:	pop %[dest]\n"
-		    "	lea (2f-1b)(%[dest],%[skip],4),%[dest]\n"
-		    "	clc\n"
-		    "	jmp *%[dest]\n               .align 4\n"
-		    "2:\n"
-		    "	adcl 14*4(%[src]),%[res]\n   .align 4\n"
-		    "	adcl 13*4(%[src]),%[res]\n   .align 4\n"
-		    "	adcl 12*4(%[src]),%[res]\n   .align 4\n"
-		    "	adcl 11*4(%[src]),%[res]\n   .align 4\n"
-		    "	adcl 10*4(%[src]),%[res]\n   .align 4\n"
-		    "	adcl 9*4(%[src]),%[res]\n   .align 4\n"
-		    "	adcl 8*4(%[src]),%[res]\n   .align 4\n"
-		    "	adcl 7*4(%[src]),%[res]\n   .align 4\n"
-		    "	adcl 6*4(%[src]),%[res]\n   .align 4\n"
-		    "	adcl 5*4(%[src]),%[res]\n   .align 4\n"
-		    "	adcl 4*4(%[src]),%[res]\n   .align 4\n"
-		    "	adcl 3*4(%[src]),%[res]\n   .align 4\n"
-		    "	adcl 2*4(%[src]),%[res]\n   .align 4\n"
-		    "	adcl 1*4(%[src]),%[res]\n   .align 4\n"
-		    "	adcl 0*4(%[src]),%[res]\n"
-		    "	adcl $0,%[res]"
-			: [res] "=r" (result), [dest] "=&r" (dest)
-			: [src] "r" (buff), "[res]" (result),
-			  [skip] "r" (dwords ^ 15)
-			: "memory");
+	if (len >> 2) { /* dwords is in [1..15] */
+		if (len >= 32) {
+			asm("	addl 0*4(%[src]),%[res]\n"
+			    "	adcl 1*4(%[src]),%[res]\n"
+			    "	adcl 2*4(%[src]),%[res]\n"
+			    "	adcl 3*4(%[src]),%[res]\n"
+			    "	adcl 4*4(%[src]),%[res]\n"
+			    "	adcl 5*4(%[src]),%[res]\n"
+			    "	adcl 6*4(%[src]),%[res]\n"
+			    "	adcl 7*4(%[src]),%[res]\n"
+			    "	adcl $0,%[res]"
+			    : [res] "=r" (result)
+			    : [src] "r" (buff), "[res]" (result)
+			    : "memory");
+			buff += 32;
+			len -= 32;
+		}
+		if (len >= 16) {
+			asm("	addl 0*4(%[src]),%[res]\n"
+			    "	adcl 1*4(%[src]),%[res]\n"
+			    "	adcl 2*4(%[src]),%[res]\n"
+			    "	adcl 3*4(%[src]),%[res]\n"
+			    "	adcl $0,%[res]"
+			    : [res] "=r" (result)
+			    : [src] "r" (buff), "[res]" (result)
+			    : "memory");
+			buff += 16;
+			len -= 16;
+		}
+		if (len >= 8) {
+			asm("	addl 0*4(%[src]),%[res]\n"
+			    "	adcl 1*4(%[src]),%[res]\n"
+			    "	adcl $0,%[res]"
+			    : [res] "=r" (result)
+			    : [src] "r" (buff), "[res]" (result)
+			    : "memory");
+			buff += 8;
+			len -= 8;
+		}
+		if (len >= 4) {
+			asm("	addl 0*4(%[src]),%[res]\n"
+			    "	adcl $0,%[res]"
+			    : [res] "=r" (result)
+			    : [src] "r" (buff), "[res]" (result)
+			    : "memory");
+			buff += 4;
+			len -= 4;
+		}
 	}
 
 	if (len & 3U) {
@@ -120,7 +123,7 @@ static unsigned do_csum(const unsigned c
 		if (len & 1)
 			result += *buff;
 	}
-	if (unlikely(odd)) { 
+	if (unlikely(odd)) {
 		result = from32to16(result);
 		result = ((result >> 8) & 0xff) | ((result & 0xff) << 8);
 	}
