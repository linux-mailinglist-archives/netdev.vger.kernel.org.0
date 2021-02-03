Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929D130DFFF
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 17:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbhBCQsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 11:48:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbhBCQsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 11:48:18 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDDF7C061573;
        Wed,  3 Feb 2021 08:47:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FXQrxdNgWCg9t/vLa4D9ZuZRDMCP+8XGxw4US1HhTog=; b=c/OoSJg12hg6TA08ZMmxC5U9K6
        OCpV83Oj8NGNClORnhfhbI+dp8Rp3puLSaw1gWZH10ZU8jjt1xRn2fku8g6kCldtIewKCeiEzQpHa
        FIkmhWmSoPI9iLIVqaoiCBF07qtkda4NJTYCHHF+NHpyMELJEKAw+NmkVRr26TUDkT/M+kbutGnkg
        sDM2tIeXHKQfOib1zfHstjrnNZ0GKFSLvvOTiCu6Z73ngCe1kPW+PXeFusDNYZ/3DMbOoNhuUbgtB
        ohbMnefixVQ7LgJJcSpYv4iVSBo2H/YpoFMC9iA8Yx35EoZdMvHxrj1aORXdUHBNR3TWKvrlHqQk4
        D8XtPzYA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l7LIa-00HCKb-H6; Wed, 03 Feb 2021 16:46:38 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A8E0F301A66;
        Wed,  3 Feb 2021 17:46:33 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 97C5520B4DFEB; Wed,  3 Feb 2021 17:46:33 +0100 (CET)
Date:   Wed, 3 Feb 2021 17:46:33 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Ivan Babrou <ivan@cloudflare.com>
Cc:     kernel-team <kernel-team@cloudflare.com>,
        Ignat Korchagin <ignat@cloudflare.com>,
        Hailong liu <liu.hailong6@zte.com.cn>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Julien Thierry <jthierry@redhat.com>,
        Jiri Slaby <jirislaby@kernel.org>, kasan-dev@googlegroups.com,
        linux-mm@kvack.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Robert Richter <rric@kernel.org>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf@vger.kernel.org
Subject: Re: BUG: KASAN: stack-out-of-bounds in
 unwind_next_frame+0x1df5/0x2650
Message-ID: <YBrTaVVfWu2R0Hgw@hirez.programming.kicks-ass.net>
References: <CABWYdi3HjduhY-nQXzy2ezGbiMB1Vk9cnhW2pMypUa+P1OjtzQ@mail.gmail.com>
 <CABWYdi27baYc3ShHcZExmmXVmxOQXo9sGO+iFhfZLq78k8iaAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABWYdi27baYc3ShHcZExmmXVmxOQXo9sGO+iFhfZLq78k8iaAg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 02, 2021 at 07:09:44PM -0800, Ivan Babrou wrote:
> On Thu, Jan 28, 2021 at 7:35 PM Ivan Babrou <ivan@cloudflare.com> wrote:

> > ==================================================================
> > [  128.368523][    C0] BUG: KASAN: stack-out-of-bounds in
> > unwind_next_frame (arch/x86/kernel/unwind_orc.c:371
> > arch/x86/kernel/unwind_orc.c:544)
> > [  128.369744][    C0] Read of size 8 at addr ffff88802fceede0 by task
> > kworker/u2:2/591

Can you pretty please not line-wrap console output? It's unreadable.

> edfd9b7838ba5e47f19ad8466d0565aba5c59bf0 is the first bad commit
> commit edfd9b7838ba5e47f19ad8466d0565aba5c59bf0

Not sure what tree you're on, but that's not the upstream commit.

> Author: Steven Rostedt (VMware) <rostedt@goodmis.org>
> Date:   Tue Aug 18 15:57:52 2020 +0200
> 
>     tracepoint: Optimize using static_call()
> 

There's a known issue with that patch, can you try:

  http://lkml.kernel.org/r/20210202220121.435051654@goodmis.org
