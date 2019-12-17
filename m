Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07AAD1230A8
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 16:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727766AbfLQPki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 10:40:38 -0500
Received: from foss.arm.com ([217.140.110.172]:40798 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727415AbfLQPkh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 10:40:37 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C29281FB;
        Tue, 17 Dec 2019 07:40:36 -0800 (PST)
Received: from arrakis.emea.arm.com (arrakis.cambridge.arm.com [10.1.197.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0D4A73F67D;
        Tue, 17 Dec 2019 07:40:33 -0800 (PST)
Date:   Tue, 17 Dec 2019 15:40:31 +0000
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        kirill.shutemov@linux.intel.com, justin.he@arm.com,
        linux-mm@kvack.org,
        syzbot <syzbot+9301f2f33873407d5b33@syzkaller.appspotmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, hawk@kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        linux-kernel@vger.kernel.org,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs@googlegroups.com, Yonghong Song <yhs@fb.com>
Subject: Re: WARNING in wp_page_copy
Message-ID: <20191217154031.GI5624@arrakis.emea.arm.com>
References: <000000000000a6f2030598bbe38c@google.com>
 <0000000000000e32950599ac5a96@google.com>
 <20191216150017.GA27202@linux.fritz.box>
 <CAJ8uoz3nCxcmnPonNunYhswskidn=PnN8=4_jXW4B=Xu4k_DoQ@mail.gmail.com>
 <CAJ8uoz312gDBGpqOJiKqrXn456sy6u+Gnvcvv_+0=EimasRoUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ8uoz312gDBGpqOJiKqrXn456sy6u+Gnvcvv_+0=EimasRoUw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Magnus,

Thanks for investigating this. I have more questions below rather than a
solution.

On Tue, Dec 17, 2019 at 02:27:22PM +0100, Magnus Karlsson wrote:
> On Mon, Dec 16, 2019 at 4:10 PM Magnus Karlsson
> <magnus.karlsson@gmail.com> wrote:
> > On Mon, Dec 16, 2019 at 4:00 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > >
> > > On Sat, Dec 14, 2019 at 08:20:07AM -0800, syzbot wrote:
> > > > syzbot has found a reproducer for the following crash on:
> > > >
> > > > HEAD commit:    1d1997db Revert "nfp: abm: fix memory leak in nfp_abm_u32_..
> > > > git tree:       net-next
> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=1029f851e00000
> > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=cef1fd5032faee91
> > > > dashboard link: https://syzkaller.appspot.com/bug?extid=9301f2f33873407d5b33
> > > > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=119d9fb1e00000
> > > >
> > > > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > > > Reported-by: syzbot+9301f2f33873407d5b33@syzkaller.appspotmail.com
> > >
> > > Bjorn / Magnus, given xsk below, PTAL, thanks!
> >
> > Thanks. I will take a look at it right away.
> >
> > /Magnus
> 
> After looking through the syzcaller report, I have the following
> hypothesis that would dearly need some comments from MM-savy people
> out there. Syzcaller creates, using mmap, a memory area that is

I guess that's not an anonymous mmap() since we don't seem to have a
struct page for src in cow_user_page() (the WARN_ON_ONCE path). Do you
have more information on the mmap() call?

> write-only and supplies this to a getsockopt call (in this case
> XDP_STATISTICS, but probably does not matter really) as the area where
> it wants the values to be stored. When the getsockopt implementation
> gets to copy_to_user() to write out the values to user space, it
> encounters a page fault when accessing this write-only page. When
> servicing this, it gets to the following piece of code that triggers
> the warning that syzcaller reports:
> 
> static inline bool cow_user_page(struct page *dst, struct page *src,
>                                  struct vm_fault *vmf)
> {
> ....
> snip
> ....
>        /*
>          * This really shouldn't fail, because the page is there
>          * in the page tables. But it might just be unreadable,
>          * in which case we just give up and fill the result with
>          * zeroes.
>          */
>         if (__copy_from_user_inatomic(kaddr, uaddr, PAGE_SIZE)) {
>                 /*
>                  * Give a warn in case there can be some obscure
>                  * use-case
>                  */
>                 WARN_ON_ONCE(1);
>                 clear_page(kaddr);
>         }

So on x86, a PROT_WRITE-only private page is mapped as non-readable? I
had the impression that write-only still allows reading by looking at
the __P010 definition.

Anyway, if it's not an anonymous mmap(), whoever handled the mapping may
have changed the permissions (e.g. some device).

> So without a warning. My hypothesis is that if we create a page in the
> same way as syzcaller then any getsockopt that does a copy_to_user()
> (pretty much all of them I guess) will get this warning.

The copy_to_user() only triggers the do_wp_page() fault handling. If
this is a CoW page (private read-only presumably, or at least not
writeable), the kernel tries to copy the original page given to
getsockopt into a new page and restart the copy_to_user(). Since the
kernel doesn't have a struct page for this (e.g. PFN mapping), it uses
__copy_from_user_inatomic() which fails because of the read permission.

> I have not tried this, so I might be wrong. If this is true, then the
> question is what to do about it. One possible fix would be just to
> remove the warning to get the same behavior as before. But it was
> probably put there for a reason.

It was there for some obscure cases, as the comment says ;). If the
above is a valid scenario that the user can trigger, we should probably
remove the WARN_ON.

-- 
Catalin
