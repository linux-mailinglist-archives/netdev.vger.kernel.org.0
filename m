Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD90E412E92
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 08:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbhIUGYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 02:24:55 -0400
Received: from zeniv-ca.linux.org.uk ([142.44.231.140]:51744 "EHLO
        zeniv-ca.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbhIUGYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 02:24:54 -0400
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mSZBV-0064HG-Dp; Tue, 21 Sep 2021 06:23:17 +0000
Date:   Tue, 21 Sep 2021 06:23:17 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     syzbot <syzbot+533f389d4026d86a2a95@syzkaller.appspotmail.com>
Cc:     andrii@kernel.org, ast@kernel.org, axboe@kernel.dk,
        bpf@vger.kernel.org, cgroups@vger.kernel.org,
        christian.brauner@ubuntu.com, christian@brauner.io,
        daniel@iogearbox.net, dkadashev@gmail.com, hannes@cmpxchg.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        lizefan.x@bytedance.com, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        tj@kernel.org, torvalds@linux-foundation.org, yhs@fb.com
Subject: Re: [syzbot] general protection fault in percpu_ref_put
Message-ID: <YUl6VZhPHBqAx+6g@zeniv-ca.linux.org.uk>
References: <000000000000f8be2b05cc788686@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000f8be2b05cc788686@google.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 07:55:16PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    4357f03d6611 Merge tag 'pm-5.15-rc2' of git://git.kernel.o..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=173e2d27300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=ccfb8533b1cbe3b1
> dashboard link: https://syzkaller.appspot.com/bug?extid=533f389d4026d86a2a95
> compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1395c6f1300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11568cad300000
> 
> The issue was bisected to:
> 
> commit 020250f31c4c75ac7687a673e29c00786582a5f4
> Author: Dmitry Kadashev <dkadashev@gmail.com>
> Date:   Thu Jul 8 06:34:43 2021 +0000
> 
>     namei: make do_linkat() take struct filename
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=137e8a4b300000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=10fe8a4b300000
> console output: https://syzkaller.appspot.com/x/log.txt?x=177e8a4b300000

I would be very surprised if that was true.  After the first step of bisect
you've traded one oops for another, and *that* went to do_linkat() breakage.
Which should be fixed by fdfc346302a7.

Look at the oopsen - initial and final ones look very different.
