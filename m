Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2297021AFA6
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 08:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgGJGo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 02:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727771AbgGJGoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 02:44:24 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D53C08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 23:44:24 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id e3so2100566qvo.10
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 23:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vwz+QQBqGjFo22n8XglIjR24++K8e2Dkq99y6Z3jnoc=;
        b=UfIywh60iuAjvuHmQ+aB1J6A9AvWYHKgO4tAcicn+NMdY+qr9TkTCtJvHz3Z9KAdPB
         HsTzAiR8q/2qqYkRXgruq4jwmsrPN9IGV8bCZDGGR2mabOh12KVqZpWf6PQsI78QHwOO
         BkP1snpG+0Lu4DuVCgmkDJKZDQssc40ShAs6ah1sP1g8JOaRgqcCNk4pJRWLY9Yl4DQn
         WVEa90X1j8qDO7rcASbudoW/QxQbOPKLY3cUc1fsZHDvHhCNfaqLfUw+ytiLGe0U7ssi
         ZxLFE6lISwK/U0oCeAE2YiZzoSQRXG/xqXqolisVpERlJQmCDv8KBkK3g3NmLous0Svf
         iQuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vwz+QQBqGjFo22n8XglIjR24++K8e2Dkq99y6Z3jnoc=;
        b=l6vbROjZTryWLe3kYGuUnKYgWGGOPgQKo9rtsSlbwGOhJCXdoUeAvNtvYV7pTU57gu
         VRAaRnaqLRLm7fPhA69ZxEpv4cmfA6TtvtT6muAVMY1Lux+QQHOA0gJYm+r3LT/vtTub
         1Zzluhhj/IJqeciBY/qiYjBe+sjyPYJBxoClzs+5Pvv6jdmJ3Ix/y5olAxaW1R4jYje8
         OkVcbi2rm4QW+AIYqI5rTdQUEsYugbt20UP2T8gsZh+c6UZgMbhzgbLoqHS+uzJ8mLR8
         lxonaTzbNbDx8NbU4mL3Rx/1xA/WJ4Nucvke4IKvsGAnUcZF6Q/pG22jZwtBWtG9mlww
         eRsQ==
X-Gm-Message-State: AOAM530kcVl5Pbea9EMYjjikMQyMFI43zuUpgVXGi7g5Fd8b911f6kHb
        gaK0ELejQ1OTHUn67xrLZaeLIOvmjlVBActyXl/How==
X-Google-Smtp-Source: ABdhPJwjmfIdnmqpO9ckG/tCE2cuQghvc+AAvH+hShSxpGGzzqY+mTrx+Ha41XfvzaZ8i6m8UD3CNSino3e890NdxS4=
X-Received: by 2002:a05:6214:d4d:: with SMTP id 13mr32588447qvr.22.1594363463503;
 Thu, 09 Jul 2020 23:44:23 -0700 (PDT)
MIME-Version: 1.0
References: <CAJ5WPnHxmanrgV0jKRiZt42YAA-H-_3HBC9LpPrYmgAcaxA5jw@mail.gmail.com>
 <CAJ5WPnGbWOqn7=WzYn4Kh-C9uCkBv=gTAmv+b+ofigVwoiUVbw@mail.gmail.com>
In-Reply-To: <CAJ5WPnGbWOqn7=WzYn4Kh-C9uCkBv=gTAmv+b+ofigVwoiUVbw@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 10 Jul 2020 08:44:12 +0200
Message-ID: <CACT4Y+aryQ+jaMBSk1Wvu_h-y7_6HisWz5Q==REcZfTg8-=-4w@mail.gmail.com>
Subject: Re: memory leak in ip_mc_add_src ( Not tainted 5.8.0-rc3+)
To:     cH3332 XR <ch3332xr@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 8:32 AM cH3332 XR <ch3332xr@gmail.com> wrote:
>
>
> Hi,
> SYZKALLER found the following Memory leak

FWIW also reported by syzbot a year ago:
https://syzkaller.appspot.com/bug?id=c2e9e4f014f416e492dd46a41c068af268169d8e

> -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
> BUG: memory leak
> unreferenced object 0xffff955412ff9e00 (size 32):
>   comm "syz-executor.3", pid 4726, jiffies 4294777846 (age 3098.168s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     06 00 00 00 00 00 00 00 ac 1e 00 04 00 00 00 00  ................
>   backtrace:
>     [<000000002976d53e>] ip_mc_add_src+0x35f/0x3e0
>     [<00000000f22fc984>] ip_mc_source+0x2db/0x4e0
>     [<00000000a814b668>] do_ip_setsockopt.isra.14+0x541/0x11c0
>     [<0000000071f25adf>] ip_setsockopt+0x33/0xa0
>     [<00000000a49ec12e>] udp_setsockopt+0x40/0x90
>     [<000000002cc8a42f>] __sys_setsockopt+0x99/0x120
>     [<00000000167d1a29>] __x64_sys_setsockopt+0x22/0x30
>     [<00000000971d38a0>] do_syscall_64+0x3e/0x70
>     [<00000000b19407da>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> BUG: memory leak
> unreferenced object 0xffff955412ff9280 (size 32):
>   comm "syz-executor.3", pid 4726, jiffies 4294777846 (age 3098.168s)
>   hex dump (first 32 bytes):
>     20 0d 77 0c 54 95 ff ff 00 00 00 00 00 00 00 00   .w.T...........
>     07 00 00 00 00 00 00 00 ac 1e 00 04 00 01 00 00  ................
>   backtrace:
>     [<000000002976d53e>] ip_mc_add_src+0x35f/0x3e0
>     [<00000000f22fc984>] ip_mc_source+0x2db/0x4e0
>     [<00000000a814b668>] do_ip_setsockopt.isra.14+0x541/0x11c0
>     [<0000000071f25adf>] ip_setsockopt+0x33/0xa0
>     [<00000000a49ec12e>] udp_setsockopt+0x40/0x90
>     [<000000002cc8a42f>] __sys_setsockopt+0x99/0x120
>     [<00000000167d1a29>] __x64_sys_setsockopt+0x22/0x30
>     [<00000000971d38a0>] do_syscall_64+0x3e/0x70
>     [<00000000b19407da>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> BUG: memory leak
> unreferenced object 0xffff95540c770d20 (size 32):
>   comm "syz-executor.3", pid 27224, jiffies 4297068116 (age 807.903s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     01 00 00 00 00 00 00 00 ac 1e 01 04 00 01 00 00  ................
>   backtrace:
>     [<00000000a201d800>] ip_mc_add_src+0x1b2/0x3e0
>     [<00000000f22fc984>] ip_mc_source+0x2db/0x4e0
>     [<00000000a814b668>] do_ip_setsockopt.isra.14+0x541/0x11c0
>     [<0000000071f25adf>] ip_setsockopt+0x33/0xa0
>     [<00000000a49ec12e>] udp_setsockopt+0x40/0x90
>     [<000000002cc8a42f>] __sys_setsockopt+0x99/0x120
>     [<00000000167d1a29>] __x64_sys_setsockopt+0x22/0x30
>     [<00000000971d38a0>] do_syscall_64+0x3e/0x70
>     [<00000000b19407da>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> BUG: leak checking failed
>
> ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
> Execute Syzkaller programs
> https://github.com/google/syzkaller/blob/master/docs/executing_syzkaller_programs.md
>
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller/CAJ5WPnGbWOqn7%3DWzYn4Kh-C9uCkBv%3DgTAmv%2Bb%2BofigVwoiUVbw%40mail.gmail.com.
