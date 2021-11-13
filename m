Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5E9A44F20B
	for <lists+netdev@lfdr.de>; Sat, 13 Nov 2021 08:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232651AbhKMHqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Nov 2021 02:46:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbhKMHqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Nov 2021 02:46:52 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861AFC061766
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 23:44:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=V3nFAw5TIShrKKI+XDyLuXD5wBOlrVbaU1jxZoX0En8=; b=m7I+9+YDIhJcYFkjoNG8qnPD+3
        Hij4SJkJHEMNEfzQdYPCvp61c6Lu///Mr5daUAJIAjJsEvJXzGxeij/eMlXqugN443WB96CAttR5p
        Bv+C82QgpDl2OZbLCON+s/uxO5MT/dSg5CPq1JO7z55BFi4AQFt1qF67iqK+C39Vi09dxnKuDKRT7
        inDa5rkC4x+W9CC3ehMTQMKOxIaoDe5w1r15ZtMtvcSPxnWqTIdhYD+7NNYIMhceXGhYed5sHb4P8
        v7yBpUWswYe1KhFDPHIWYi3Rv2TLvcYPB7YFyDcFw2YLo3COm1nn1So9PQ2CnLo+QK/GYa0/vsUU8
        T72IsEXQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mlnhV-0047jM-20; Sat, 13 Nov 2021 07:43:49 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 32C4030001B;
        Sat, 13 Nov 2021 08:43:49 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 0D775205E4DB6; Sat, 13 Nov 2021 08:43:49 +0100 (CET)
Date:   Sat, 13 Nov 2021 08:43:49 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, x86@kernel.org,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v2] x86/csum: rewrite csum_partial()
Message-ID: <YY9stWBgy2uWslgq@hirez.programming.kicks-ass.net>
References: <20211112161950.528886-1-eric.dumazet@gmail.com>
 <YY6aKcUyZaERbBih@hirez.programming.kicks-ass.net>
 <CANn89iK=Ayph82DptYEGv4a+n2AnqgVMDhA2iLaJm=mQmE-tow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iK=Ayph82DptYEGv4a+n2AnqgVMDhA2iLaJm=mQmE-tow@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 12, 2021 at 09:23:39AM -0800, Eric Dumazet wrote:
> On Fri, Nov 12, 2021 at 8:45 AM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> 
> >
> > Looks nice, happen to have shiny perf numbers to show how awesome it it?
> > :-)
> 
> On a networking load on cascadlake, line rate received on a single thread, I see
> perf -e cycles:pp -C <cpu>
> 
> Before:
>        4.16%  [kernel]       [k] csum_partial
> After:
>         0.83%  [kernel]       [k] csum_partial
> 
> If run in a loop 1,000,000 times,
> 
> Before:
>        26,922,913      cycles                    # 3846130.429 GHz
>         80,302,961      instructions              #    2.98  insn per
> cycle
>         21,059,816      branches                  # 3008545142.857
> M/sec
>              2,896      branch-misses             #    0.01% of all
> branches
> After:
>         17,960,709      cycles                    # 3592141.800 GHz
>         41,292,805      instructions              #    2.30  insn per
> cycle
>         11,058,119      branches                  # 2211623800.000
> M/sec
>              2,997      branch-misses             #    0.03% of all
> branches
> 
> Thanks for your help !

I've added these numbers to the Changelog and will queue the patch in
x86/core once -rc1 happens.

Thanks!
