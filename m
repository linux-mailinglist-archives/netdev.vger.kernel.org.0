Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDCF3123A26
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 23:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbfLQWiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 17:38:19 -0500
Received: from foss.arm.com ([217.140.110.172]:50992 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725812AbfLQWiT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 17:38:19 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 69A711FB;
        Tue, 17 Dec 2019 14:38:18 -0800 (PST)
Received: from mbp (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7B2153F718;
        Tue, 17 Dec 2019 14:38:15 -0800 (PST)
Date:   Tue, 17 Dec 2019 22:38:09 +0000
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
Message-ID: <20191217223808.GA14982@mbp>
References: <000000000000a6f2030598bbe38c@google.com>
 <0000000000000e32950599ac5a96@google.com>
 <20191216150017.GA27202@linux.fritz.box>
 <CAJ8uoz3nCxcmnPonNunYhswskidn=PnN8=4_jXW4B=Xu4k_DoQ@mail.gmail.com>
 <CAJ8uoz312gDBGpqOJiKqrXn456sy6u+Gnvcvv_+0=EimasRoUw@mail.gmail.com>
 <20191217154031.GI5624@arrakis.emea.arm.com>
 <CAJ8uoz3yDK8sEE05cKA8siBi-Dc0wtbe1-zYgbz_-pd5t69j8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ8uoz3yDK8sEE05cKA8siBi-Dc0wtbe1-zYgbz_-pd5t69j8w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 04:57:34PM +0100, Magnus Karlsson wrote:
> On Tue, Dec 17, 2019 at 4:40 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
> > On Tue, Dec 17, 2019 at 02:27:22PM +0100, Magnus Karlsson wrote:
> > > On Mon, Dec 16, 2019 at 4:10 PM Magnus Karlsson
> > > <magnus.karlsson@gmail.com> wrote:
> > > > On Mon, Dec 16, 2019 at 4:00 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > > > > On Sat, Dec 14, 2019 at 08:20:07AM -0800, syzbot wrote:
> > > > > > syzbot has found a reproducer for the following crash on:
> > > > > >
> > > > > > HEAD commit:    1d1997db Revert "nfp: abm: fix memory leak in nfp_abm_u32_..
> > > > > > git tree:       net-next
> > > > > > console output: https://syzkaller.appspot.com/x/log.txt?x=1029f851e00000
> > > > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=cef1fd5032faee91
> > > > > > dashboard link: https://syzkaller.appspot.com/bug?extid=9301f2f33873407d5b33
> > > > > > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > > > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=119d9fb1e00000
> > > > > >
> > > > > > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > > > > > Reported-by: syzbot+9301f2f33873407d5b33@syzkaller.appspotmail.com
> > > > >
> > > > > Bjorn / Magnus, given xsk below, PTAL, thanks!
> > > >
> > > > Thanks. I will take a look at it right away.
> > > >
> > > > /Magnus
> > >
> > > After looking through the syzcaller report, I have the following
> > > hypothesis that would dearly need some comments from MM-savy people
> > > out there. Syzcaller creates, using mmap, a memory area that is
> >
> > I guess that's not an anonymous mmap() since we don't seem to have a
> > struct page for src in cow_user_page() (the WARN_ON_ONCE path). Do you
> > have more information on the mmap() call?
> 
> I have this from the syzcaller logs:
> 
> mmap(&(0x7f0000001000/0x2000)=nil, 0x2000, 0xfffffe, 0x12, r8, 0x0)
> getsockopt$XDP_MMAP_OFFSETS(r8, 0x11b, 0x7, &(0x7f0000001300),
> &(0x7f0000000100)=0x60)
> 
> The full log can be found at:
> https://syzkaller.appspot.com/x/repro.syz?x=119d9fb1e00000

Thanks. Prior to mmap, we have:

r8 = socket$xdp(0x2c, 0x3, 0x0)

So basically we have an mmap() on a socket descriptor with a subsequent
copy_to_user() writing this range. We do we even end up doing CoW on
such mapping? Maybe the socket code should also implement the .fault()
file op. It needs more digging.

-- 
Catalin
