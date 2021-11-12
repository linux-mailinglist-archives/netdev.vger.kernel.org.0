Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2BCB44EB8E
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 17:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235142AbhKLQsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 11:48:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233445AbhKLQs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 11:48:29 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A08C061766
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 08:45:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lElUIF6JDk4lgFVCgziZqcyAcOXW72j39FyZpK9atDo=; b=l9bEYnbX92RilP0GeY0EpxghLo
        MeA81Emuy6aqM5cF/3O9oOJiDdkvuN7g8q31Xd7WMBlYqg8zT9SGWLQHGrFXhFIWygR4L/fm6RPGt
        5mALdebS4WlGH5MWlc972jFpyjU+wnwSn4e2Asi8WKNW1w+D80i6CaBJCWP93b89yeYjnYZbb6twL
        cL2G8ANdLafUB27PoZv1WOq4j9gw+22PyD55IyreDt9YWnmRZ5OQRJQb+WJJ89dZH6Xl0D37o6GCk
        1hsDxYC6+FNTSBwSD1TcHhHDQkrFi8I4feQyKSWtKAMOSQ3xLn0Ju0sC0MWGfvveiT52/mWt4izvy
        /xoRrJYQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mlZg9-003gAk-Cq; Fri, 12 Nov 2021 16:45:30 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 7E834300024;
        Fri, 12 Nov 2021 17:45:29 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 538662C70C9B3; Fri, 12 Nov 2021 17:45:29 +0100 (CET)
Date:   Fri, 12 Nov 2021 17:45:29 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>, x86@kernel.org,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v2] x86/csum: rewrite csum_partial()
Message-ID: <YY6aKcUyZaERbBih@hirez.programming.kicks-ass.net>
References: <20211112161950.528886-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211112161950.528886-1-eric.dumazet@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 12, 2021 at 08:19:50AM -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> With more NIC supporting CHECKSUM_COMPLETE, and IPv6 being widely used.
> csum_partial() is heavily used with small amount of bytes,
> and is consuming many cycles.
> 
> IPv6 header size for instance is 40 bytes.
> 
> Another thing to consider is that NET_IP_ALIGN is 0 on x86,
> meaning that network headers are not word-aligned, unless
> the driver forces this.
> 
> This means that csum_partial() fetches one u16
> to 'align the buffer', then perform three u64 additions
> with carry in a loop, then a remaining u32, then a remaining u16.
> 
> With this new version, we perform a loop only for the 64 bytes blocks,
> then the remaining is bisected.
> 
> Tested on various cpus, all of them show a big reduction in
> csum_partial() cost (by 50 to 80 %)
> 
> v3: - use "+r" (temp64) asm constraints (Andrew).
>     - fold do_csum() in csum_partial(), as gcc does not inline it.
>     - fix bug added in v2 for the "odd" case.
>     - back using addcq, as Andrew pointed the clang bug that was adding
> 	  a stall on my hosts.
>       (separate patch to add32_with_carry() will follow)
>     - use load_unaligned_zeropad() for final 1-7 bytes (Peter & Alexander).
> 
> v2: - removed the hard-coded switch(), as it was not RETPOLINE aware.
>     - removed the final add32_with_carry() that we were doing
>       in csum_partial(), we can simply pass @sum to do_csum().
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Looks nice, happen to have shiny perf numbers to show how awesome it it?
:-)
