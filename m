Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0797F1D9D09
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 18:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729238AbgESQlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 12:41:49 -0400
Received: from verein.lst.de ([213.95.11.211]:44884 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728689AbgESQlt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 12:41:49 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8FD3068B02; Tue, 19 May 2020 18:41:46 +0200 (CEST)
Date:   Tue, 19 May 2020 18:41:46 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-parisc@vger.kernel.org,
        linux-um <linux-um@lists.infradead.org>,
        Netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/20] maccess: remove strncpy_from_unsafe
Message-ID: <20200519164146.GA28313@lst.de>
References: <20200519134449.1466624-1-hch@lst.de> <20200519134449.1466624-13-hch@lst.de> <CAHk-=whE_C2JF0ywF09iMBWtquEfMM3aSxCeLrb5S75EdHr1JA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whE_C2JF0ywF09iMBWtquEfMM3aSxCeLrb5S75EdHr1JA@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 19, 2020 at 09:25:57AM -0700, Linus Torvalds wrote:
> On Tue, May 19, 2020 at 6:45 AM Christoph Hellwig <hch@lst.de> wrote:
> >
> > +       if (IS_ENABLED(CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE) &&
> > +           compat && (unsigned long)unsafe_ptr < TASK_SIZE)
> > +               ret = strncpy_from_user_nofault(dst, user_ptr, size);
> > +       else
> > +               ret = strncpy_from_kernel_nofault(dst, unsafe_ptr, size);
> 
> These conditionals are completely illegible.

I had a lot of folks complaining about things like:

#ifdef CONFIG_FOO
	if (foo)
		do_stuff();
	else
#endif
		do_something_else();

which I personally don't mind at all, so I switched to this style.

>   static long bpf_strncpy_from_legacy(void *dest, const void
> *unsafe_ptr, long size, bool legacy)
>   {
>   #ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
>         if (legacy && addr < TASK_SIZE)
>             return strncpy_from_user_nofault(dst, (const void __user
> *) unsafe_ptr, size);
>   #endif
> 
>         return strncpy_from_kernel_nofault(dst, unsafe_ptr, size);
>   }
> 
> and then you'd just use
> 
>         if (bpf_strncpy_from_unsafe(dst, unsafe_ptr, size, compat) < 0)
>                 memset(dst, 0, size);
> 
> and avoid any complicated conditionals, goto's, and make the code much
> easier to understand thanks to having a big comment about the legacy
> case.

Sure.

> In fact, separately I'd probably want that "compat" naming to be
> scrapped entirely in that file.

Not my choice..  Maybe Daniel has a recommendation of what to change
there, but I'd love to not have to deal with that renaming as well
in this series.
