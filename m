Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 982621D1F2D
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390681AbgEMT2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:28:09 -0400
Received: from verein.lst.de ([213.95.11.211]:48313 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390291AbgEMT2J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 15:28:09 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3747968B05; Wed, 13 May 2020 21:28:05 +0200 (CEST)
Date:   Wed, 13 May 2020 21:28:04 +0200
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
Subject: Re: [PATCH 11/18] maccess: remove strncpy_from_unsafe
Message-ID: <20200513192804.GA30751@lst.de>
References: <20200513160038.2482415-1-hch@lst.de> <20200513160038.2482415-12-hch@lst.de> <CAHk-=wj=u+nttmd1huNES2U=9nePtmk7WgR8cMLCYS8wc=rhdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wj=u+nttmd1huNES2U=9nePtmk7WgR8cMLCYS8wc=rhdA@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 12:11:27PM -0700, Linus Torvalds wrote:
> On Wed, May 13, 2020 at 9:01 AM Christoph Hellwig <hch@lst.de> wrote:
> >
> > +static void bpf_strncpy(char *buf, long unsafe_addr)
> > +{
> > +       buf[0] = 0;
> > +       if (strncpy_from_kernel_nofault(buf, (void *)unsafe_addr,
> > +                       BPF_STRNCPY_LEN))
> > +               strncpy_from_user_nofault(buf, (void __user *)unsafe_addr,
> > +                               BPF_STRNCPY_LEN);
> > +}
> 
> This seems buggy when I look at it.
> 
> It seems to think that strncpy_from_kernel_nofault() returns an error code.
> 
> Not so, unless I missed where you changed the rules.

I didn't change the rules, so yes, this is wrong.

> Also, I do wonder if we shouldn't gate this on TASK_SIZE, and do the
> user trial first. On architectures where this thing is valid in the
> first place (ie kernel and user addresses are separate), the test for
> address size would allow us to avoid a pointless fault due to an
> invalid kernel access to user space.
> 
> So I think this function should look something like
> 
>   static void bpf_strncpy(char *buf, long unsafe_addr)
>   {
>           /* Try user address */
>           if (unsafe_addr < TASK_SIZE) {
>                   void __user *ptr = (void __user *)unsafe_addr;
>                   if (strncpy_from_user_nofault(buf, ptr, BPF_STRNCPY_LEN) >= 0)
>                           return;
>           }
> 
>           /* .. fall back on trying kernel access */
>           buf[0] = 0;
>           strncpy_from_kernel_nofault(buf, (void *)unsafe_addr,
> BPF_STRNCPY_LEN);
>   }
> 
> or similar. No?

So on say s390 TASK_SIZE_USUALLy is (-PAGE_SIZE), which means we'd alway
try the user copy first, which seems odd.

I'd really like to here from the bpf folks what the expected use case
is here, and if the typical argument is kernel or user memory.
