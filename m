Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C36E511415E
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 14:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729544AbfLENT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 08:19:58 -0500
Received: from www62.your-server.de ([213.133.104.62]:35820 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729240AbfLENT6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 08:19:58 -0500
Received: from 29.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.29] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1icr2v-00019m-4m; Thu, 05 Dec 2019 14:19:53 +0100
Date:   Thu, 5 Dec 2019 14:19:52 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Daniel Axtens <dja@axtens.net>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+82e323920b78d54aaed5@syzkaller.appspotmail.com>,
        kasan-dev <kasan-dev@googlegroups.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: Re: BUG: unable to handle kernel paging request in pcpu_alloc
Message-ID: <20191205131952.GD29780@localhost.localdomain>
References: <000000000000314c120598dc69bd@google.com>
 <CACT4Y+ZTXKP0MAT3ivr5HO-skZOjSVdz7RbDoyc522_Nbk8nKQ@mail.gmail.com>
 <877e3be6eu.fsf@dja-thinkpad.axtens.net>
 <20191205125900.GB29780@localhost.localdomain>
 <871rtiex4e.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871rtiex4e.fsf@dja-thinkpad.axtens.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25654/Thu Dec  5 10:46:25 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 06, 2019 at 12:10:41AM +1100, Daniel Axtens wrote:
> Daniel Borkmann <daniel@iogearbox.net> writes:
> > On Thu, Dec 05, 2019 at 03:35:21PM +1100, Daniel Axtens wrote:
> >> >> HEAD commit:    1ab75b2e Add linux-next specific files for 20191203
> >> >> git tree:       linux-next
> >> >> console output: https://syzkaller.appspot.com/x/log.txt?x=10edf2eae00000
> >> >> kernel config:  https://syzkaller.appspot.com/x/.config?x=de1505c727f0ec20
> >> >> dashboard link: https://syzkaller.appspot.com/bug?extid=82e323920b78d54aaed5
> >> >> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> >> >> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=156ef061e00000
> >> >> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11641edae00000
> >> >>
> >> >> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> >> >> Reported-by: syzbot+82e323920b78d54aaed5@syzkaller.appspotmail.com
> >> >
> >> > +Daniel, is it the same as:
> >> > https://syzkaller.appspot.com/bug?id=f6450554481c55c131cc23d581fbd8ea42e63e18
> >> > If so, is it possible to make KASAN detect this consistently with the
> >> > same crash type so that syzbot does not report duplicates?
> >> 
> >> It looks like both of these occur immediately after failure injection. I
> >> think my assumption that I could ignore the chance of failures in the
> >> per-cpu allocation path will have to be revisited. That's annoying.
> >> 
> >> I'll try to spin something today but Andrey feel free to pip me at the
> >> post again :)
> >> 
> >> I'm not 100% confident to call them dups just yet, but I'm about 80%
> >> confident that they are.
> >
> > Ok. Double checked BPF side yesterday night, but looks sane to me and the
> > fault also hints into pcpu_alloc() rather than BPF code. Daniel, from your
> > above reply, I read that you are aware of how the bisected commit would
> > have caused the fault?
> 
> Yes, this one is on me - I did not take into account the brutal
> efficiency of the fault injector when implementing my KASAN support for
> vmalloc areas. I have a fix, I'm just doing final tests now.

Perfect, thanks a lot!
