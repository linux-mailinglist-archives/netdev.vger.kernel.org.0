Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE8D44D3CC
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 10:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbhKKJNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 04:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbhKKJNR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 04:13:17 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8374FC061766
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 01:10:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l8j9tJ00Ql9MeJ5+QQk4bfpY2azbQHOFwUs/CJt0uBU=; b=J7cYwaK2uJMg2i5hv8JUDGFBZK
        Hh+cZdNF2pT0eKdIxVNc9At35Jo0WAYEVoHKnoKX+CTlM14Fss42Qggq7mX4ttKDe8Aj3t9ZDiK7Y
        tSrxfarqoNkUUWtF1gBWg0PCJb8xu+IrcfhqsNjHWprTASNX8BgtbM2zebys53/7Yf4XBnBr2G9Jv
        +AiTSd7aUZ9fJ19aPSwdzuHFKc3xGGXMb4swhn/zAbtH44Tzy+zqOfRY/NjywmX3rgasvzqiXczI1
        3R7wYXJbUxhGiUEEUTnmfGX804f5zz9JHeNn9vIoL/ITloBC8dKn01760LlIqyD/TWIce8wP96oeZ
        OqFlZkMQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ml668-00FRGT-KO; Thu, 11 Nov 2021 09:10:20 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id B11B130001C;
        Thu, 11 Nov 2021 10:10:19 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 51E182CCBA320; Thu, 11 Nov 2021 10:10:19 +0100 (CET)
Date:   Thu, 11 Nov 2021 10:10:19 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>, x86@kernel.org,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [RFC] x86/csum: rewrite csum_partial()
Message-ID: <YYzd+zdzqUM5/ZKL@hirez.programming.kicks-ass.net>
References: <20211111065322.1261275-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211111065322.1261275-1-eric.dumazet@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 10, 2021 at 10:53:22PM -0800, Eric Dumazet wrote:
> +		/*
> +		 * This implements an optimized version of
> +		 * switch (dwords) {
> +		 * case 15: res = add_with_carry(res, buf32[14]); fallthrough;
> +		 * case 14: res = add_with_carry(res, buf32[13]); fallthrough;
> +		 * case 13: res = add_with_carry(res, buf32[12]); fallthrough;
> +		 * ...
> +		 * case 3: res = add_with_carry(res, buf32[2]); fallthrough;
> +		 * case 2: res = add_with_carry(res, buf32[1]); fallthrough;
> +		 * case 1: res = add_with_carry(res, buf32[0]); fallthrough;
> +		 * }
> +		 *
> +		 * "adcl 8byteoff(%reg1),%reg2" are using either 3 or 4 bytes.
> +		 */
> +		asm("	call 1f\n"
> +		    "1:	pop %[dest]\n"

That's terrible. I think on x86_64 we can do: lea (%%rip), %[dest], not
sure what would be the best way on i386.

> +		    "	lea (2f-1b)(%[dest],%[skip],4),%[dest]\n"
> +		    "	clc\n"
> +		    "	jmp *%[dest]\n               .align 4\n"

That's an indirect branch, you can't do that these days. This would need
to use JMP_NOSPEC (except we don't have a !ASSEMBLER version of that.
But that would also completely and utterly destroy performance.

Also, objtool would complain about this if it hadn't tripped over that
first instruction:

 arch/x86/lib/csum-partial_64.o: warning: objtool: do_csum()+0x84: indirect jump found in RETPOLINE build

I'm not sure what the best way is to unroll loops without using computed
gotos/jump-tables though :/

> +		    "2:\n"
> +		    "	adcl 14*4(%[src]),%[res]\n   .align 4\n"
> +		    "	adcl 13*4(%[src]),%[res]\n   .align 4\n"
> +		    "	adcl 12*4(%[src]),%[res]\n   .align 4\n"
> +		    "	adcl 11*4(%[src]),%[res]\n   .align 4\n"
> +		    "	adcl 10*4(%[src]),%[res]\n   .align 4\n"
> +		    "	adcl 9*4(%[src]),%[res]\n   .align 4\n"
> +		    "	adcl 8*4(%[src]),%[res]\n   .align 4\n"
> +		    "	adcl 7*4(%[src]),%[res]\n   .align 4\n"
> +		    "	adcl 6*4(%[src]),%[res]\n   .align 4\n"
> +		    "	adcl 5*4(%[src]),%[res]\n   .align 4\n"
> +		    "	adcl 4*4(%[src]),%[res]\n   .align 4\n"
> +		    "	adcl 3*4(%[src]),%[res]\n   .align 4\n"
> +		    "	adcl 2*4(%[src]),%[res]\n   .align 4\n"
> +		    "	adcl 1*4(%[src]),%[res]\n   .align 4\n"
> +		    "	adcl 0*4(%[src]),%[res]\n"
> +		    "	adcl $0,%[res]"

If only the CPU would accept: REP ADCL (%%rsi), %[res]   :/

> +			: [res] "=r" (result), [dest] "=&r" (dest)
> +			: [src] "r" (buff), "[res]" (result),
> +			  [skip] "r" (dwords ^ 15)
> +			: "memory");
> +	}
