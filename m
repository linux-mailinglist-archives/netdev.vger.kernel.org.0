Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB9BD329285
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 21:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243650AbhCAUqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 15:46:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239828AbhCAUnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 15:43:53 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FCE0C06178A
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 12:43:12 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id h9so3257475qtq.7
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 12:43:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZRRNElgGOrQy90lAfZacJe2AKjVRmRS8fPPCyjr3PWQ=;
        b=HgcLlGlEVYJ2DUAOt8BTHoX8moTnPbkbi5TLbHhaOzSqYCfAt4OCr3CbyWdoN3/rAr
         DX5+84PF+iK0J+wr/W9wXk2he5yiS0nA5OQtNqynOx4mCBX3ff4PNF+hlkDXS6+EOxX+
         3Oevsrmnauh8mSXX2eCEL8Fp4vlZFYVZsvywGIP+ijHykkOx9FtSxzWvwi7fuL0keSML
         VJe9tjGnUpoz5cgtYiV5F/RlQNhx6iSaM1RF/IKB0vYhzM4WvSdcAOMF8jTU7KpnaT2E
         8SajaOCpvErUrDlk7L8RtZafk37CxCOmazGfu1TGZjMsLZ6twfJVfqqW8U+f3aZTxMBE
         QEnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZRRNElgGOrQy90lAfZacJe2AKjVRmRS8fPPCyjr3PWQ=;
        b=hpp4xZKmUstOmJVWnXAXjEXZBoc/D84+MyJqKm0TA9gNecVTUrxPQKXU5AMjt1a724
         NA79/xgbRxBF+8FRRdXMZjNmX+271aDDn8LBsOVsg+TEAWLv0LSAXXOJx95+tJfFtsA5
         6GoeqHPrf1UYhgxo8qdF93P9dirudRKfF8zhDako8nyK2cQ6NcEsFm8JRludfmkLZHc1
         vFV2ASX6dlkzgccd51VCbKCLQMgNCeV81HXYX5+X5SWEyXUfGT9CI2t1JQfXbYU9gr/x
         UwVf9a29Nljyw3qCjYoujaPRU4dFBReml8x2GWf/d8cnUTvo1WekE58TDmtL87RCMLLD
         C7kg==
X-Gm-Message-State: AOAM5324yB3TF88C14WREfkqceMWAAKoW6OmP9pFrzcN8QFjkbG+n2I9
        DJL51rUptoB314gSg/rc8H3XyjiQG2KqDLOVgqy/LQ==
X-Google-Smtp-Source: ABdhPJwbDvJqK/vh1C9m3V1Sj0rcvcJFmhmlUNTW5fI3w0G528712vMXZL0d+YbZlJAhnyaPbxP1fUjb008iC2MwH3g=
X-Received: by 2002:ac8:6f3b:: with SMTP id i27mr3748150qtv.67.1614631391417;
 Mon, 01 Mar 2021 12:43:11 -0800 (PST)
MIME-Version: 1.0
References: <000000000000911d3905b459824c@google.com> <000000000000e56a2605b616b2d9@google.com>
 <YD0UjWjQmYgY4Qgh@nuc10> <CACT4Y+YQzTkk=UPNH5g96e+yPYyaPBemmhqXz5oaWEvW9xb-rQ@mail.gmail.com>
 <YD1RE3O4FBkKK32l@nuc10>
In-Reply-To: <YD1RE3O4FBkKK32l@nuc10>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 1 Mar 2021 21:43:00 +0100
Message-ID: <CACT4Y+bvWyipjZ6P6gkno0ZHRWPJ-HFGiT3yECqQU37a0E_tgQ@mail.gmail.com>
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

On Mon, Mar 1, 2021 at 9:39 PM Rustam Kovhaev <rkovhaev@gmail.com> wrote:
>
> On Mon, Mar 01, 2021 at 08:05:42PM +0100, Dmitry Vyukov wrote:
> > On Mon, Mar 1, 2021 at 5:21 PM Rustam Kovhaev <rkovhaev@gmail.com> wrote:
> > >
> > > On Wed, Dec 09, 2020 at 10:58:10PM -0800, syzbot wrote:
> > > > syzbot has found a reproducer for the following issue on:
> > > >
> > > > HEAD commit:    a68a0262 mm/madvise: remove racy mm ownership check
> > > > git tree:       upstream
> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=11facf17500000
> > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=4305fa9ea70c7a9f
> > > > dashboard link: https://syzkaller.appspot.com/bug?extid=f3694595248708227d35
> > > > compiler:       gcc (GCC) 10.1.0-syz 20200507
> > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=159a9613500000
> > > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11bf7123500000
> > > >
> > > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > > Reported-by: syzbot+f3694595248708227d35@syzkaller.appspotmail.com
> > > >
> > > > Debian GNU/Linux 9 syzkaller ttyS0
> > > > Warning: Permanently added '10.128.0.9' (ECDSA) to the list of known hosts.
> > > > executing program
> > > > executing program
> > > > executing program
> > > > BUG: memory leak
> > > > unreferenced object 0xffff88810efccc80 (size 64):
> > > >   comm "syz-executor334", pid 8460, jiffies 4294945724 (age 13.850s)
> > > >   hex dump (first 32 bytes):
> > > >     c0 cb 14 04 00 ea ff ff c0 c2 11 04 00 ea ff ff  ................
> > > >     c0 56 3f 04 00 ea ff ff 40 18 38 04 00 ea ff ff  .V?.....@.8.....
> > > >   backtrace:
> > > >     [<0000000036ae98a7>] kmalloc_node include/linux/slab.h:575 [inline]
> > > >     [<0000000036ae98a7>] bpf_ringbuf_area_alloc kernel/bpf/ringbuf.c:94 [inline]
> > > >     [<0000000036ae98a7>] bpf_ringbuf_alloc kernel/bpf/ringbuf.c:135 [inline]
> > > >     [<0000000036ae98a7>] ringbuf_map_alloc kernel/bpf/ringbuf.c:183 [inline]
> > > >     [<0000000036ae98a7>] ringbuf_map_alloc+0x1be/0x410 kernel/bpf/ringbuf.c:150
> > > >     [<00000000d2cb93ae>] find_and_alloc_map kernel/bpf/syscall.c:122 [inline]
> > > >     [<00000000d2cb93ae>] map_create kernel/bpf/syscall.c:825 [inline]
> > > >     [<00000000d2cb93ae>] __do_sys_bpf+0x7d0/0x30a0 kernel/bpf/syscall.c:4381
> > > >     [<000000008feaf393>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
> > > >     [<00000000e1f53cfd>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > >
> > > >
> > >
> > > i am pretty sure that this one is a false positive
> > > the problem with reproducer is that it does not terminate all of the
> > > child processes that it spawns
> > >
> > > i confirmed that it is a false positive by tracing __fput() and
> > > bpf_map_release(), i ran reproducer, got kmemleak report, then i
> > > manually killed those running leftover processes from reproducer and
> > > then both functions were executed and memory was freed
> > >
> > > i am marking this one as:
> > > #syz invalid
> >
> > Hi Rustam,
> >
> > Thanks for looking into this.
> >
> > I wonder how/where are these objects referenced? If they are not
> > leaked and referenced somewhere, KMEMLEAK should not report them as
> > leaks.
> > So even if this is a false positive for BPF, this is a true positive
> > bug and something to fix for KMEMLEAK ;)
> > And syzbot will probably re-create this bug report soon as this still
> > happens and is not a one-off thing.
>
> hi Dmitry, i haven't thought of it this way, but i guess you are right,
> it is a kmemleak bug, ideally kmemleak should be aware that there are
> still running processes holding references to bpf fd/anonymous inodes
> which in their turn hold references to allocated bpf maps

KMEMLEAK scans whole memory, so if there are pointers to the object
anywhere in memory, KMEMLEAK should not report them as leaked. Running
processes have no direct effect on KMEMLEAK logic.
So the question is: where are these pointers to these objects? If we
answer this, we can check how/why KMEMLEAK misses them. Are they
mangled in some way?
