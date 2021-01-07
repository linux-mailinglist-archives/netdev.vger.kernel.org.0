Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BABC2EC7D4
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 02:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbhAGBuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 20:50:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:34840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726641AbhAGBuA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 20:50:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B30CF22EBF;
        Thu,  7 Jan 2021 01:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609984159;
        bh=doqZnSsLCdDqGPlvrZj/h0iAnNN1drlPUlLMSBzsonk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hGbJmoFDZMv+INHH05XMsJw9v6I3OfRL2/dXi+RTnL+VwKu5wLcV6VxSD0ikLT8Y2
         Z52dYK3l4pf5142GRL4W7Rt8RrDRp2nY2JUY5cdNVuFgwGDqT/NsTErCN5j58Ra36k
         1daBb1Iz7ZEwkqcrvats/lQkKF65NJNfEutcikPJqu4an2fOrpe8z+3nhkHzRJDH0T
         JFjtMTHTfDqSFVJtl67HhhXVG/zVX2UXdAi+NWppphyJxnpBeHBp4jJ1ApXvewKSo7
         l4ZHXInUhEbXuYLUr1WGmVhw/9sra2XwPIfRxGOqUBjW+lQTciJZzvNBABYKJJ+FCn
         fFQlGzH2sJ6Hw==
Date:   Wed, 6 Jan 2021 17:49:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Willem de Bruijn <willemb@google.com>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Matthew Wilcox <willy@infradead.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [BUG] from x86: Support kmap_local() forced debugging
Message-ID: <20210106174917.3f8ad0d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAHk-=wh2895wXEXYtb70CTgW+UR7jfh6VFhJB_bOrF0L7UKoEg@mail.gmail.com>
References: <20201118194838.753436396@linutronix.de>
        <20201118204007.169209557@linutronix.de>
        <20210106180132.41dc249d@gandalf.local.home>
        <CAHk-=wh2895wXEXYtb70CTgW+UR7jfh6VFhJB_bOrF0L7UKoEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Jan 2021 17:03:48 -0800 Linus Torvalds wrote:
> I wonder whether there is other code that "knows" about kmap() only
> affecting PageHighmem() pages thing that is no longer true.
> 
> Looking at some other code, skb_gro_reset_offset() looks suspiciously
> like it also thinks highmem pages are special.
> 
> Adding the networking people involved in this area to the cc too.

Thanks for the detailed analysis! skb_gro_reset_offset() checks if
kernel can read data in the fragments directly as an optimization, 
in case the entire header is in a fragment. 

IIUC DEBUG_KMAP_LOCAL_FORCE_MAP only affects the mappings from
explicit kmap calls, which GRO won't make - it will fall back to
pulling the header out of the fragment and end up in skb_copy_bits(),
i.e. the loop you fixed. So GRO should be good. I think..
