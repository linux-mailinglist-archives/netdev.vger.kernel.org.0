Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E881571CBF
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 18:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732528AbfGWQTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 12:19:55 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:38852 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730794AbfGWQTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 12:19:55 -0400
Received: by mail-io1-f66.google.com with SMTP id j6so7937466ioa.5
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 09:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KUWPAynNUOSPRo6XFgibVfZiG/NBm56uoCBvbOY3YfY=;
        b=JkbWvc/L1jVe2xvK16FWiec+u9Wkn8bLEHQ2Otwk2wo1fNf36vdNCarOj/+5+9ysB7
         hGoVJ50RzrPUQhM8qtVkV4bG9/Nd4DxPKWQ/IbhdfoxeWYoLpk5L4af4Tbtwj9ohVnmD
         DsRzgjjoRFG7pAJsFp53eVnfm889mNyAtvzp4TdAmo79hACuf0DY1h1YvaJZs4fp1GBn
         K55GH9Y5p1iFw+h2gyNS3Q/8MPrzQV9yW8qdTsQKhg7hxLcsFJPdfd+4vtu/xUQIUFyG
         4QnSyRhM4W2erjcNAhgZyLlpCANYFNdeyB1869FdH2o+ByDy8DxuOdC2ypiXseqMvsaH
         D0Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KUWPAynNUOSPRo6XFgibVfZiG/NBm56uoCBvbOY3YfY=;
        b=XfAIMZsCMcizfhhz60CK6kmaW+Ae2aI+lEjfIi7nDKKRj7lEjuCoM3rlXhwHVTnzul
         G/oLSzu9gpTllZiFIUJA+ySPhuMlKOtTb/4US6X2NOb5d+UW0nkJa/8lUueNpm5bjs+v
         j0DszH8ZckiR/OTCxzeXMp8UeCOvu5SnE75BBQV3LXLSpP+xHeaEfFXazPqvCjqnPL44
         4zlgyqUB+d1CL4Gx45AZL7mOB9lZq0Ze8YAUdEfkf8jP0WLU2BAP/Fzap+hL9aRSz/cT
         IeuPqOMRC8c1Krj2L4srFcoXySAxOAXivRReXQ4SA2dfTU8810YBfjbZakDizDg8b3Rs
         h6kg==
X-Gm-Message-State: APjAAAVk7pJj9EsnzA/ebrn5ML3htPS56ont2UcBL+tjYMk+VnZ7L9+L
        XL9pJ0gsWOsMBpFDn15Fus64jVwAm1llVDC+3J5Cyw==
X-Google-Smtp-Source: APXvYqztMLs7k36jGVQTGcnvuK+zFovr4er0TeB/3FrZTzVj2pa0EprwgjDyKnzaW+HqFtXQxcESSC8IEb5DWxlnLvQ=
X-Received: by 2002:a5e:de0d:: with SMTP id e13mr47762250iok.144.1563898793984;
 Tue, 23 Jul 2019 09:19:53 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000ad1dfe058e5b89ab@google.com>
In-Reply-To: <000000000000ad1dfe058e5b89ab@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 23 Jul 2019 18:19:42 +0200
Message-ID: <CACT4Y+a7eGJpsrenA-0RbWmwktDj5+XV4xaTeU+fiL5KXNbrqg@mail.gmail.com>
Subject: Re: memory leak in rds_send_probe
To:     syzbot <syzbot+5134cdf021c4ed5aaa5f@syzkaller.appspotmail.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Cc:     LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 6:18 PM syzbot
<syzbot+5134cdf021c4ed5aaa5f@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    c6dd78fc Merge branch 'x86-urgent-for-linus' of git://git...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=14be98c8600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=8de7d700ea5ac607
> dashboard link: https://syzkaller.appspot.com/bug?extid=5134cdf021c4ed5aaa5f
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=145df0c8600000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=170001f4600000

+net/rds/message.c maintainers

> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+5134cdf021c4ed5aaa5f@syzkaller.appspotmail.com
>
> BUG: memory leak
> unreferenced object 0xffff8881234e9c00 (size 512):
>    comm "kworker/u4:2", pid 286, jiffies 4294948041 (age 7.750s)
>    hex dump (first 32 bytes):
>      01 00 00 00 00 00 00 00 08 9c 4e 23 81 88 ff ff  ..........N#....
>      08 9c 4e 23 81 88 ff ff 18 9c 4e 23 81 88 ff ff  ..N#......N#....
>    backtrace:
>      [<0000000032e378fa>] kmemleak_alloc_recursive
> /./include/linux/kmemleak.h:43 [inline]
>      [<0000000032e378fa>] slab_post_alloc_hook /mm/slab.h:522 [inline]
>      [<0000000032e378fa>] slab_alloc /mm/slab.c:3319 [inline]
>      [<0000000032e378fa>] __do_kmalloc /mm/slab.c:3653 [inline]
>      [<0000000032e378fa>] __kmalloc+0x16d/0x2d0 /mm/slab.c:3664
>      [<0000000015bc9536>] kmalloc /./include/linux/slab.h:557 [inline]
>      [<0000000015bc9536>] kzalloc /./include/linux/slab.h:748 [inline]
>      [<0000000015bc9536>] rds_message_alloc+0x3e/0xc0 /net/rds/message.c:291
>      [<00000000a806d18d>] rds_send_probe.constprop.0+0x42/0x2f0
> /net/rds/send.c:1419
>      [<00000000794a00cc>] rds_send_pong+0x1e/0x23 /net/rds/send.c:1482
>      [<00000000b2a248d0>] rds_recv_incoming+0x27e/0x460 /net/rds/recv.c:343
>      [<00000000ea1503db>] rds_loop_xmit+0x86/0x100 /net/rds/loop.c:96
>      [<00000000a9857f5a>] rds_send_xmit+0x524/0x9a0 /net/rds/send.c:355
>      [<00000000557b0101>] rds_send_worker+0x3c/0xd0 /net/rds/threads.c:200
>      [<000000004ba94868>] process_one_work+0x23f/0x490
> /kernel/workqueue.c:2269
>      [<00000000e793f811>] worker_thread+0x195/0x580 /kernel/workqueue.c:2415
>      [<000000003ee8c1a1>] kthread+0x13e/0x160 /kernel/kthread.c:255
>      [<000000004cd53c81>] ret_from_fork+0x1f/0x30
> /arch/x86/entry/entry_64.S:352
>
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000ad1dfe058e5b89ab%40google.com.
