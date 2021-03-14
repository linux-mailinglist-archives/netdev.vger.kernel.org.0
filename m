Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D981E33A415
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 11:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235155AbhCNKCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 06:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235091AbhCNKBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 06:01:53 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E0BC061765
        for <netdev@vger.kernel.org>; Sun, 14 Mar 2021 03:01:52 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id h3so6410398qvh.8
        for <netdev@vger.kernel.org>; Sun, 14 Mar 2021 03:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V9sT2+1xGWWst4bttpxK8qQ+hu8YuKQN51ohN8OT3c8=;
        b=V0E9YrVrqNrmHyaGGS2inR5EG2jdyBufEWpDo1J7GHy2CDxubNlpcs2qDjK8muao68
         vJ/fBpCplKi9jzNcEsBT+NeZ5ZcU6wbjacQMfVTiCoXeodLZFL+3j9O+EmwgDRcgyqku
         WnLMo7j7BOPADrmvQn5Hf7D/mz9sCpNVKfglfFUsK+aYPBorVNl99DLBSw7mATQJKrm1
         FViIjGdN5yZe1/RNfm4H6Kd592Q1I6cgrIYSYtiRMbY8NbsZtK6RCbnL1ew3GpJ16idM
         8X9VNTXyQeyfLwUac+y1LdoA+rZ/Py48RhmKQL2E/tgLxh7LzN5p/sqB/6qs8KEMFfwp
         vhHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V9sT2+1xGWWst4bttpxK8qQ+hu8YuKQN51ohN8OT3c8=;
        b=DUv3iXtIlCWo+eJ30yxrijauaiobcMJpO/qDuyP89yTqnyp77sjfYSF7K4DAm6Hjfx
         qM5LomJqwswaNOAtu0vNmlgGESskaiocHr0y1GbzojTHJe7YrJzt34ODFT3kC7p5GnIQ
         qCdJ2Z/N/6aGMVAfh4p0yB16QZ216HE3HgSUX2i7Am8zDa45h7PZtYAzb06dfkgmYK/f
         9GXa+2U4yoxfN6z+mlKRM7Sdkt9V0KMN1yI/ncq0PUHMoQJQ/223ECMFmEvPPBdTq1GO
         /jL9i87uXfE9Aj22BtEh1D/bKotoIsblnSn2H8d9n5Vyf8V+7iR+rxpyW7Gh8n+0QdK3
         nfRQ==
X-Gm-Message-State: AOAM532x2Ct3JhGOjkQM/wpbVUOaa2p6qDHZDGaQiRMknggjYgmAFp3Y
        WHLkFtjJBB2CVoqiovz0JzINAJyDiNpl21Ha2dDRbA==
X-Google-Smtp-Source: ABdhPJy+VvF0EiHA6nUvKNqWlrBetdvLNPW+AK/wZIPRYlo9k7aSKbqQa7OoPlVK+wlWobmQl0SijN7Ooh4s/FNr5eA=
X-Received: by 2002:a05:6214:326:: with SMTP id j6mr5856707qvu.13.1615716110661;
 Sun, 14 Mar 2021 03:01:50 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000096cdaa05bd32d46f@google.com> <CACT4Y+ZjdOaX_X530p+vPbG4mbtUuFsJ1v-gD24T4DnFUqcudA@mail.gmail.com>
In-Reply-To: <CACT4Y+ZjdOaX_X530p+vPbG4mbtUuFsJ1v-gD24T4DnFUqcudA@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Sun, 14 Mar 2021 11:01:39 +0100
Message-ID: <CACT4Y+ZjVS+nOxtEByF5-djuhbCYLSDdZ7V04qJ0edpQR0514A@mail.gmail.com>
Subject: Re: [syzbot] BUG: unable to handle kernel access to user memory in sock_ioctl
To:     syzbot <syzbot+c23c5421600e9b454849@syzkaller.appspotmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        linux-riscv <linux-riscv@lists.infradead.org>
Cc:     andrii@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, kpsingh@kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 7:53 PM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Wed, Mar 10, 2021 at 7:28 PM syzbot
> <syzbot+c23c5421600e9b454849@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    0d7588ab riscv: process: Fix no prototype for arch_dup_tas..
> > git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux.git fixes
> > console output: https://syzkaller.appspot.com/x/log.txt?x=122c343ad00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=e3c595255fb2d136
> > dashboard link: https://syzkaller.appspot.com/bug?extid=c23c5421600e9b454849
> > userspace arch: riscv64
> >
> > Unfortunately, I don't have any reproducer for this issue yet.
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+c23c5421600e9b454849@syzkaller.appspotmail.com
>
> +riscv maintainers
>
> Another case of put_user crashing.

There are 58 crashes in sock_ioctl already. Somehow there is a very
significant skew towards crashing with this "user memory without
uaccess routines" in schedule_tail and sock_ioctl of all places in the
kernel that use put_user... This looks very strange... Any ideas
what's special about these 2 locations?


> > Unable to handle kernel access to user memory without uaccess routines at virtual address 0000000020000300
> > Oops [#1]
> > Modules linked in:
> > CPU: 1 PID: 4488 Comm: syz-executor.0 Not tainted 5.12.0-rc2-syzkaller-00467-g0d7588ab9ef9 #0
> > Hardware name: riscv-virtio,qemu (DT)
> > epc : sock_ioctl+0x424/0x6ac net/socket.c:1124
> >  ra : sock_ioctl+0x424/0x6ac net/socket.c:1124
> > epc : ffffffe002aeeb3e ra : ffffffe002aeeb3e sp : ffffffe023867da0
> >  gp : ffffffe005d25378 tp : ffffffe007e116c0 t0 : 0000000000000000
> >  t1 : 0000000000000001 t2 : 0000003fb8035e44 s0 : ffffffe023867e30
> >  s1 : 0000000000040000 a0 : 0000000000000000 a1 : 0000000000000007
> >  a2 : 1ffffffc00fc22d8 a3 : ffffffe003bc1d02 a4 : 0000000000000000
> >  a5 : 0000000000000000 a6 : 0000000000f00000 a7 : ffffffe000082eba
> >  s2 : 0000000000000000 s3 : 0000000000008902 s4 : 0000000020000300
> >  s5 : ffffffe005d2b0d0 s6 : ffffffe010facfc0 s7 : ffffffe008e00000
> >  s8 : 0000000000008903 s9 : ffffffe010fad080 s10: 0000000000000000
> >  s11: 0000000000020000 t3 : 982de389919f6300 t4 : ffffffc401175688
> >  t5 : ffffffc401175691 t6 : 0000000000000007
> > status: 0000000000000120 badaddr: 0000000020000300 cause: 000000000000000f
> > Call Trace:
> > [<ffffffe002aeeb3e>] sock_ioctl+0x424/0x6ac net/socket.c:1124
> > [<ffffffe0003fdb6a>] vfs_ioctl fs/ioctl.c:48 [inline]
> > [<ffffffe0003fdb6a>] __do_sys_ioctl fs/ioctl.c:753 [inline]
> > [<ffffffe0003fdb6a>] sys_ioctl+0x5c2/0xd56 fs/ioctl.c:739
> > [<ffffffe000005562>] ret_from_syscall+0x0/0x2
> > Dumping ftrace buffer:
> >    (ftrace buffer empty)
> > ---[ end trace a5f91e70f37b907b ]---
> >
> >
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
