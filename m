Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56740148B40
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 16:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387799AbgAXP2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 10:28:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:38762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387398AbgAXP2d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 10:28:33 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F60620702;
        Fri, 24 Jan 2020 15:28:32 +0000 (UTC)
Date:   Fri, 24 Jan 2020 10:28:30 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        syzbot <syzbot+0c147ca7bd4352547635@syzkaller.appspotmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: WARNING in tracing_func_proto
Message-ID: <20200124102830.52911ff4@gandalf.local.home>
In-Reply-To: <CACT4Y+ZP-7np20GVRu3p+eZys9GPtbu+JpfV+HtsufAzvTgJrg@mail.gmail.com>
References: <0000000000001b2259059c654421@google.com>
        <20200121180255.1c98b54c@gandalf.local.home>
        <20200122055314.GD1847@kadam>
        <CACT4Y+ZP-7np20GVRu3p+eZys9GPtbu+JpfV+HtsufAzvTgJrg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Jan 2020 11:44:13 +0100
Dmitry Vyukov <dvyukov@google.com> wrote:

> FWIW this is invalid use of WARN macros:
> https://elixir.bootlin.com/linux/v5.5-rc7/source/include/asm-generic/bug.h#L72
> This should be replaced with pr_err (if really necessary, kernel does
> not generally spew stacks on every ENOMEM/EINVAL).

That message was added in 2018. The WARN macro in question here, was
added in 2011. Thus, this would be more of a clean up fix.

> 
> There are no _lots_ such wrong uses of WARN in the kernel. There were
> some, all get fixed over time, we are still discovering long tail, but
> it's like one per months at most. Note: syzbot reports each and every
> WARNING. If there were lots, you would notice :)

Hmm, I haven't looked, but are all these correct usage?

 $ git grep WARN_ON HEAD | wc -l
15384

I also checked the number of WARN_ON when that WARN_ON was added:

 $ git grep WARN_ON 07d777fe8c3985bc83428c2866713c2d1b3d4129 | wc -l
4730

A lot more were added since then!

> 
> Sorting this out is critical for just any kernel testing. Otherwise no
> testing system will be able to say if a test triggers something bad in
> kernel or not.
> 
> FWIW there are no local trees for syzbot. It only tests public trees
> as is. Doing otherwise would not work/scale as a process.

Anyway, I'll happily take a patch converting that WARN_ON macro to a
pr_err() print.

-- Steve
