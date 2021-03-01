Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03D22328D68
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 20:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233823AbhCATK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 14:10:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240974AbhCATGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 14:06:36 -0500
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C62C06178B
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 11:05:55 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id z190so17699825qka.9
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 11:05:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vltDR6nPmExSVgix/uycZqbK9vu4qx0KGQAFBNxtb08=;
        b=dWjxltLxoMhu/cGdlWbJGFN82TRnUTSvcNFt8VbU0lJPhoQbyfb9qzf+Rlm36dRTfn
         R4+hBO+2Df9oSjPSSLAn7AXckKPvLPAeUFHiE9/FQmI/a9jYcKrc9mPne65dElaL/dwH
         zB0pReX7kaNRSciF9JwHZy0YqNsYCQHss6Nro4gmT0BBOtw4lurDzuMId5uiwx84/3d+
         l8IbWc1Qrf7e+bxs2ZHmvHVVs4AA3Yj7fkx6LxNjewK/Yv1zDDHf71BAvOUZaobPg8j1
         JMe/8fz2zB0TeGw+yvzzm+V8KWpgLOD5i7ZDNI9W3fZdYFr2fTpvwknrsDTsO+tAxKAE
         1lpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vltDR6nPmExSVgix/uycZqbK9vu4qx0KGQAFBNxtb08=;
        b=rI0zsaBcEWWhrZWj/i9CKs10bOWqJ1BeXaxxcoSIHu4XBv+2Zlga7H0CbKSru6RB+V
         FSAgOkqFTLBkYOyuI2uy5yjFdwP1Dr4jayiF358m+A4P86dHc3Q+yoWOSUFsddby9X+Z
         3gerM78McBrAX+AMW+Mv6AAoJaDUnRC4bHfHXImhvPdBznTDQrcAJhAhqcmpZnYC5oxH
         hBED5ozyDzAP6jnx0j1rbI0kXqiiKadxy4pRyJxkr5kj74gk/8IvaBcvhVlApHSAGBck
         COodZ2E8ZapdRXxQlcmsOH565GBzMxURtmd/o6KpjHqSKiKot4bvFSrQ07YocpNkZzSY
         69XA==
X-Gm-Message-State: AOAM533KffAgvFJk6fv2v6S9ZFmzh9hFPPkEkmd5h/B7hg9H4edW+g+e
        EDystENFljkvrINAFEupE+7QaJTC8x/knCi1Ukkavw==
X-Google-Smtp-Source: ABdhPJxZwmErIHsA+M8yHabv+voWVmw4iPHqCRMdf3gsDRfgfugEd3e53Nvhbifj61z6HqleXEXvj6IgyDDs3xSZUj0=
X-Received: by 2002:a37:4743:: with SMTP id u64mr9584887qka.350.1614625554022;
 Mon, 01 Mar 2021 11:05:54 -0800 (PST)
MIME-Version: 1.0
References: <000000000000911d3905b459824c@google.com> <000000000000e56a2605b616b2d9@google.com>
 <YD0UjWjQmYgY4Qgh@nuc10>
In-Reply-To: <YD0UjWjQmYgY4Qgh@nuc10>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 1 Mar 2021 20:05:42 +0100
Message-ID: <CACT4Y+YQzTkk=UPNH5g96e+yPYyaPBemmhqXz5oaWEvW9xb-rQ@mail.gmail.com>
Subject: Re: memory leak in bpf
To:     Rustam Kovhaev <rkovhaev@gmail.com>
Cc:     syzbot <syzbot+f3694595248708227d35@syzkaller.appspotmail.com>,
        andrii@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 1, 2021 at 5:21 PM Rustam Kovhaev <rkovhaev@gmail.com> wrote:
>
> On Wed, Dec 09, 2020 at 10:58:10PM -0800, syzbot wrote:
> > syzbot has found a reproducer for the following issue on:
> >
> > HEAD commit:    a68a0262 mm/madvise: remove racy mm ownership check
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=11facf17500000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=4305fa9ea70c7a9f
> > dashboard link: https://syzkaller.appspot.com/bug?extid=f3694595248708227d35
> > compiler:       gcc (GCC) 10.1.0-syz 20200507
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=159a9613500000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11bf7123500000
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+f3694595248708227d35@syzkaller.appspotmail.com
> >
> > Debian GNU/Linux 9 syzkaller ttyS0
> > Warning: Permanently added '10.128.0.9' (ECDSA) to the list of known hosts.
> > executing program
> > executing program
> > executing program
> > BUG: memory leak
> > unreferenced object 0xffff88810efccc80 (size 64):
> >   comm "syz-executor334", pid 8460, jiffies 4294945724 (age 13.850s)
> >   hex dump (first 32 bytes):
> >     c0 cb 14 04 00 ea ff ff c0 c2 11 04 00 ea ff ff  ................
> >     c0 56 3f 04 00 ea ff ff 40 18 38 04 00 ea ff ff  .V?.....@.8.....
> >   backtrace:
> >     [<0000000036ae98a7>] kmalloc_node include/linux/slab.h:575 [inline]
> >     [<0000000036ae98a7>] bpf_ringbuf_area_alloc kernel/bpf/ringbuf.c:94 [inline]
> >     [<0000000036ae98a7>] bpf_ringbuf_alloc kernel/bpf/ringbuf.c:135 [inline]
> >     [<0000000036ae98a7>] ringbuf_map_alloc kernel/bpf/ringbuf.c:183 [inline]
> >     [<0000000036ae98a7>] ringbuf_map_alloc+0x1be/0x410 kernel/bpf/ringbuf.c:150
> >     [<00000000d2cb93ae>] find_and_alloc_map kernel/bpf/syscall.c:122 [inline]
> >     [<00000000d2cb93ae>] map_create kernel/bpf/syscall.c:825 [inline]
> >     [<00000000d2cb93ae>] __do_sys_bpf+0x7d0/0x30a0 kernel/bpf/syscall.c:4381
> >     [<000000008feaf393>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
> >     [<00000000e1f53cfd>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >
> >
>
> i am pretty sure that this one is a false positive
> the problem with reproducer is that it does not terminate all of the
> child processes that it spawns
>
> i confirmed that it is a false positive by tracing __fput() and
> bpf_map_release(), i ran reproducer, got kmemleak report, then i
> manually killed those running leftover processes from reproducer and
> then both functions were executed and memory was freed
>
> i am marking this one as:
> #syz invalid


Hi Rustam,

Thanks for looking into this.

I wonder how/where are these objects referenced? If they are not
leaked and referenced somewhere, KMEMLEAK should not report them as
leaks.
So even if this is a false positive for BPF, this is a true positive
bug and something to fix for KMEMLEAK ;)
And syzbot will probably re-create this bug report soon as this still
happens and is not a one-off thing.
