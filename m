Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8DBB1791DB
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 15:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729118AbgCDOBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 09:01:52 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:43183 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727543AbgCDOBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 09:01:52 -0500
Received: by mail-qv1-f65.google.com with SMTP id eb12so799040qvb.10
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 06:01:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G0ueur8yv4OrtDwVZmhHtECCa81dEuCkbNZ37/oy970=;
        b=Ya2Z4J+eSxcQOV5d06oszbIa4X3j37zkrPzHWr0m3VLWWSE1EpJa9FWGk7hG+HoJEr
         rlbglJpdg914NhjhUsqzPVyikAOqcMKVFgktQn4Km1tQM6K/ihGTBdUq2zsDFlmf7U3L
         iiH49uNN2pf2Ud+s+iy6wcW06lTqGYd1QCWWnGP+7i1vkR9sVOG3Ke/Ioe4rbw5NaPp/
         W1AyYXz4gn0iXeY719PABEp5qB/usWXyVK3ZgkJysq7lP97oSC43J8f8hD/k5IdEbywu
         SMD/nRV2mfbDoAHUWnnpfex6uOub565TcIL2jOlin9jB23XcKiA3AX6hptbCeWUMo6b8
         B8Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G0ueur8yv4OrtDwVZmhHtECCa81dEuCkbNZ37/oy970=;
        b=f7lSJhX8FMo/8W+aGlFKGWyc6D2hQyI2G2iBiOvkpmPUf1w7flK9pKoDSvU5+khZ0i
         2VEMQBFJj5WGNGlmBs4CfzS+F9dyGdPgBzDWhFNT46vsy8N7iUhLWDNKd6QY0RJBw5BQ
         REB8sSVV/ba0MJT0x2MXfK5/i9N5jaS3bHlrzi7iYXYr9av8w/mB/J9dJlp3uV39S0R9
         RfQU780qTG8pTHegwXlL/lnzPHojdT+wS2//31W4XDMd38GSGRknlprvGkjqmj87GvNr
         eKB0of8Sf85/q8LgcIGkCsA6MYvN6hU4q3P35ws7T83dif/E6GbaWyjywg+3CRqVS2SG
         Wzmw==
X-Gm-Message-State: ANhLgQ2GNoL2hxxvOL26xkB+xV9H0yvVfQFVC1eb7p71bKK+vxscHw2Q
        8l34GrJv1WO0HACDmVyRHc0RNcXPrc9D7+7t7pI2Kg==
X-Google-Smtp-Source: ADFU+vuG2iyYLMGh1IS6iEIu1LfzAukMoPtBNYT3AqGM+4EzVMaxPhdBu/huB7llcCDwIDusMq73zFG0FIMAdCKs77w=
X-Received: by 2002:a0c:e982:: with SMTP id z2mr2124951qvn.22.1583330510867;
 Wed, 04 Mar 2020 06:01:50 -0800 (PST)
MIME-Version: 1.0
References: <0000000000005c967305a006d54d@google.com> <20200304135351.GN2596@hirez.programming.kicks-ass.net>
In-Reply-To: <20200304135351.GN2596@hirez.programming.kicks-ass.net>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 4 Mar 2020 15:01:05 +0100
Message-ID: <CACT4Y+b2Xu_Oj5GnnQFeYQBnyx5+3Fdeaj-OJY4jLyxoS0szkw@mail.gmail.com>
Subject: Re: WARNING: locking bug in __perf_event_task_sched_in
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     syzbot <syzbot+3daecb3e8271380aeb51@syzkaller.appspotmail.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, jolsa@redhat.com,
        Martin KaFai Lau <kafai@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 happOn Wed, Mar 4, 2020 at 2:54 PM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Wed, Mar 04, 2020 at 04:48:13AM -0800, syzbot wrote:
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    f8788d86 Linux 5.6-rc3
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=13bcd8f9e00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=5d2e033af114153f
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3daecb3e8271380aeb51
> > compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> >
> > Unfortunately, I don't have any reproducer for this crash yet.
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+3daecb3e8271380aeb51@syzkaller.appspotmail.com
> >
> > ------------[ cut here ]------------
> > DEBUG_LOCKS_WARN_ON(1)
> > WARNING: CPU: 0 PID: 22488 at kernel/locking/lockdep.c:167 hlock_class kernel/locking/lockdep.c:167 [inline]
> > WARNING: CPU: 0 PID: 22488 at kernel/locking/lockdep.c:167 __lock_acquire+0x18b8/0x1bc0 kernel/locking/lockdep.c:3950
>
> Something went sideways bad, could be you've overflowed lockdep_depth.
> For some reason the check:
>
>         if (unlikely(curr->lockdep_depth >= MAX_LOCK_DEPTH))
>
> is rather late.. Dunno, most times I've hit lockdep errors like this,
> something else was screwy and we're just the ones to trip over it.

"BUG: MAX_LOCK_DEPTH too low!" is not happening on its own, the last
"BUG: MAX_LOCK_DEPTH too low!" happened 600 days ago:
https://syzkaller.appspot.com/bug?extid=802a5abb8abae86eb6de
