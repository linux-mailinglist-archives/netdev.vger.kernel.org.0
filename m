Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2FAA1E75D9
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 08:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgE2GXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 02:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbgE2GXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 02:23:18 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CDA4C08C5C6
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 23:23:17 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id g28so542167qkl.0
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 23:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cbdCSdtN8MlEhy96fo0b/kgF8o/dxXmYFgFHXfsQv9Y=;
        b=sbSiOsJHKJSFNfIX5xzLMhbE1MIQmcsP1dekTBZvlGLwGmkCCFsDC9rYxDLW6Y5+Ij
         zU0HE+96iqJkM/ZLhnSvSJUgvDeeOUNj8rfylXh2LFEM2Wkg9YE8mcOd23WzH+wEm99s
         IhD/bA2BcLcWBNgG978CnVfz0TDIxnrSuahGxz5UZuRAXFNp8x3rXa+TdfaHjz3BhM14
         d4QcOYP8rjv+bb+avo/aCYZQbF/u69O5VGV/EzlpRdXXTuB0NVF5Eh3MxSwnCDUljXrb
         8JwxZyGN7ObHm+nZozkcXq3w0rjBme46ns25FnSa+l5eoQrDcon1Rg76xgScVVguCRP3
         xOjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cbdCSdtN8MlEhy96fo0b/kgF8o/dxXmYFgFHXfsQv9Y=;
        b=WZEZGrwMqssPW3xygei9TTX3iTCHqeLMm8GzQhD0jIyWcVnFkXCquidw8nsHVBqQPr
         O7gkLPkrqhBcVuVVJ5UCdmuyyILARoKJfgGI7E6bWv5VEgebLD9qT8UFFcuqn9Is6zjx
         Jq+JLTq3feZF3kRGa9YqOBiinwGIt1d+qk+omTlWgK2On5RS627UrlUdNBpwqP6R/O4z
         atSygie6qTuuAUwK9QtUCl03obLRCWYpKaI/oQgex2QsEYpIz9XLYAH9KQeBANot2Glf
         ZY7m8K0RHf2kgpok8RuLunfDrba8uB+n4tw9BLzU1n2pyvWJ+/7O+Kd8QY1Inm28j3hF
         1+MA==
X-Gm-Message-State: AOAM531C/nLuYKDlhxjmQwIYJbk3G2xdltOFJTsIWRhGl8Y/pbk8k9tG
        Ru/gI5XuJIcG6XQObjtpvWnLIGhdBp/xsgaqmmA1WQ==
X-Google-Smtp-Source: ABdhPJxFqH0HE+qC5mgRzELqtLAed1ZLm0Ye0EXdi/0rdCqectpaAzdhoiEBwtETbrDxs9yhIADFS/9mgvsPnPJ46Mg=
X-Received: by 2002:a37:4b0c:: with SMTP id y12mr6034999qka.43.1590733396384;
 Thu, 28 May 2020 23:23:16 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000018e1d305a6b80a73@google.com> <d65c8424-e78c-63f9-3711-532494619dc6@fb.com>
In-Reply-To: <d65c8424-e78c-63f9-3711-532494619dc6@fb.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 29 May 2020 08:23:05 +0200
Message-ID: <CACT4Y+aNBkhxuMOk4_eqEmLjHkjbw4wt0nBvtFCw2ssn3m2NTA@mail.gmail.com>
Subject: Re: general protection fault in inet_unhash
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     syzbot <syzbot+3610d489778b57cc8031@syzkaller.appspotmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>, guro@fb.com,
        kuba@kernel.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 28, 2020 at 11:01 PM 'Andrii Nakryiko' via syzkaller-bugs
<syzkaller-bugs@googlegroups.com> wrote:
>
> On 5/28/20 9:44 AM, syzbot wrote:
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    dc0f3ed1 net: phy: at803x: add cable diagnostics suppor=
t f..
> > git tree:       net-next
> > console output: https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__=
syzkaller.appspot.com_x_log.txt-3Fx-3D17289cd2100000&d=3DDwIBaQ&c=3D5VD0RTt=
NlTh3ycd41b3MUw&r=3Dvxqvl81C2rT6GOGdPyz8iQ&m=3DsMAtpavBBjBzFzT0V8c6FcH8cu2M=
9da3ZozO5Lc8do0&s=3Dt1v5ZakZM9Aw_9u_I6FbFZ28U0GFs0e9dMMUOyiDxO4&e=3D
> > kernel config:  https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__=
syzkaller.appspot.com_x_.config-3Fx-3D7e1bc97341edbea6&d=3DDwIBaQ&c=3D5VD0R=
TtNlTh3ycd41b3MUw&r=3Dvxqvl81C2rT6GOGdPyz8iQ&m=3DsMAtpavBBjBzFzT0V8c6FcH8cu=
2M9da3ZozO5Lc8do0&s=3DyeXCTODuJF6ExmCJ-ppqMHsfvMCbCQ9zkmZi3W6NGHo&e=3D
> > dashboard link: https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__=
syzkaller.appspot.com_bug-3Fextid-3D3610d489778b57cc8031&d=3DDwIBaQ&c=3D5VD=
0RTtNlTh3ycd41b3MUw&r=3Dvxqvl81C2rT6GOGdPyz8iQ&m=3DsMAtpavBBjBzFzT0V8c6FcH8=
cu2M9da3ZozO5Lc8do0&s=3D8fAJHh81yojiinnGJzTw6hN4w4A6XRZST4463CWL9Y8&e=3D
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__=
syzkaller.appspot.com_x_repro.syz-3Fx-3D15f237aa100000&d=3DDwIBaQ&c=3D5VD0R=
TtNlTh3ycd41b3MUw&r=3Dvxqvl81C2rT6GOGdPyz8iQ&m=3DsMAtpavBBjBzFzT0V8c6FcH8cu=
2M9da3ZozO5Lc8do0&s=3DcPv-hQsGYs0CVz3I26BmauS0hQ8_YTWHeH5p-U5ElWY&e=3D
> > C reproducer:   https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__=
syzkaller.appspot.com_x_repro.c-3Fx-3D1553834a100000&d=3DDwIBaQ&c=3D5VD0RTt=
NlTh3ycd41b3MUw&r=3Dvxqvl81C2rT6GOGdPyz8iQ&m=3DsMAtpavBBjBzFzT0V8c6FcH8cu2M=
9da3ZozO5Lc8do0&s=3Dr6sGJDOgosZDE9sRxqFnVibDNJFt_6IteSWeqEQLbNE&e=3D
> >
> > The bug was bisected to:
> >
> > commit af6eea57437a830293eab56246b6025cc7d46ee7
> > Author: Andrii Nakryiko <andriin@fb.com>
> > Date:   Mon Mar 30 02:59:58 2020 +0000
> >
> >      bpf: Implement bpf_link-based cgroup BPF program attachment
> >
> > bisection log:  https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__=
syzkaller.appspot.com_x_bisect.txt-3Fx-3D1173cd7e100000&d=3DDwIBaQ&c=3D5VD0=
RTtNlTh3ycd41b3MUw&r=3Dvxqvl81C2rT6GOGdPyz8iQ&m=3DsMAtpavBBjBzFzT0V8c6FcH8c=
u2M9da3ZozO5Lc8do0&s=3DrJIpYFSAMRfea3349dd7PhmLD_hriVwq8ZtTHcSagBA&e=3D
> > final crash:    https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__=
syzkaller.appspot.com_x_report.txt-3Fx-3D1373cd7e100000&d=3DDwIBaQ&c=3D5VD0=
RTtNlTh3ycd41b3MUw&r=3Dvxqvl81C2rT6GOGdPyz8iQ&m=3DsMAtpavBBjBzFzT0V8c6FcH8c=
u2M9da3ZozO5Lc8do0&s=3DTWpx5JNdxKiKPABUScn8WB7u3fXueCp7BXwQHg4Unz0&e=3D
> > console output: https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__=
syzkaller.appspot.com_x_log.txt-3Fx-3D1573cd7e100000&d=3DDwIBaQ&c=3D5VD0RTt=
NlTh3ycd41b3MUw&r=3Dvxqvl81C2rT6GOGdPyz8iQ&m=3DsMAtpavBBjBzFzT0V8c6FcH8cu2M=
9da3ZozO5Lc8do0&s=3D-SMhn-dVZI4W51EZQ8Im0sdThgwt9M6fxUt3_bcYvk8&e=3D
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the comm=
it:
> > Reported-by: syzbot+3610d489778b57cc8031@syzkaller.appspotmail.com
> > Fixes: af6eea57437a ("bpf: Implement bpf_link-based cgroup BPF program =
attachment")
> >
> > general protection fault, probably for non-canonical address 0xdffffc00=
00000001: 0000 [#1] PREEMPT SMP KASAN
> > KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
> > CPU: 0 PID: 7063 Comm: syz-executor654 Not tainted 5.7.0-rc6-syzkaller =
#0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS=
 Google 01/01/2011
> > RIP: 0010:inet_unhash+0x11f/0x770 net/ipv4/inet_hashtables.c:600
>
> No idea why it was bisected to bpf_link change. It seems completely
> struct sock-related. Seems like

Hi Andrii,

You can always find a detailed explanation of syzbot bisections under
the "bisection log" link.

> struct inet_hashinfo *hashinfo =3D sk->sk_prot->h.hashinfo;
>
> ends up being NULL.
>
> Can some more networking-savvy people help with investigating this, pleas=
e?
>
> > Code: 03 0f b6 04 02 84 c0 74 08 3c 03 0f 8e dd 04 00 00 48 8d 7d 08 44=
 8b 73 08 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 =
0f 85 55 05 00 00 48 8d 7d 14 4c 8b 6d 08 48 b8 00 00
> > RSP: 0018:ffffc90001777d30 EFLAGS: 00010202
> > RAX: dffffc0000000000 RBX: ffff88809a6df940 RCX: ffffffff8697c242
> > RDX: 0000000000000001 RSI: ffffffff8697c251 RDI: 0000000000000008
> > RBP: 0000000000000000 R08: ffff88809f3ae1c0 R09: fffffbfff1514cc1
> > R10: ffffffff8a8a6607 R11: fffffbfff1514cc0 R12: ffff88809a6df9b0
> > R13: 0000000000000007 R14: 0000000000000000 R15: ffffffff873a4d00
> > FS:  0000000001d2b880(0000) GS:ffff8880ae600000(0000) knlGS:00000000000=
00000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00000000006cd090 CR3: 000000009403a000 CR4: 00000000001406f0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >   sk_common_release+0xba/0x370 net/core/sock.c:3210
> >   inet_create net/ipv4/af_inet.c:390 [inline]
> >   inet_create+0x966/0xe00 net/ipv4/af_inet.c:248
> >   __sock_create+0x3cb/0x730 net/socket.c:1428
> >   sock_create net/socket.c:1479 [inline]
> >   __sys_socket+0xef/0x200 net/socket.c:1521
> >   __do_sys_socket net/socket.c:1530 [inline]
> >   __se_sys_socket net/socket.c:1528 [inline]
> >   __x64_sys_socket+0x6f/0xb0 net/socket.c:1528
> >   do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
> >   entry_SYSCALL_64_after_hwframe+0x49/0xb3
> > RIP: 0033:0x441e29
> > Code: e8 fc b3 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89=
 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 =
ff ff 0f 83 eb 08 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> > RSP: 002b:00007ffdce184148 EFLAGS: 00000246 ORIG_RAX: 0000000000000029
> > RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000441e29
> > RDX: 0000000000000073 RSI: 0000000000000002 RDI: 0000000000000002
> > RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> > R13: 0000000000402c30 R14: 0000000000000000 R15: 0000000000000000
> > Modules linked in:
> > ---[ end trace 23b6578228ce553e ]---
> > RIP: 0010:inet_unhash+0x11f/0x770 net/ipv4/inet_hashtables.c:600
> > Code: 03 0f b6 04 02 84 c0 74 08 3c 03 0f 8e dd 04 00 00 48 8d 7d 08 44=
 8b 73 08 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 =
0f 85 55 05 00 00 48 8d 7d 14 4c 8b 6d 08 48 b8 00 00
> > RSP: 0018:ffffc90001777d30 EFLAGS: 00010202
> > RAX: dffffc0000000000 RBX: ffff88809a6df940 RCX: ffffffff8697c242
> > RDX: 0000000000000001 RSI: ffffffff8697c251 RDI: 0000000000000008
> > RBP: 0000000000000000 R08: ffff88809f3ae1c0 R09: fffffbfff1514cc1
> > R10: ffffffff8a8a6607 R11: fffffbfff1514cc0 R12: ffff88809a6df9b0
> > R13: 0000000000000007 R14: 0000000000000000 R15: ffffffff873a4d00
> > FS:  0000000001d2b880(0000) GS:ffff8880ae600000(0000) knlGS:00000000000=
00000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00000000006cd090 CR3: 000000009403a000 CR4: 00000000001406f0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >
> >
> > ---
> > This bug is generated by a bot. It may contain errors.
> > See https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__goo.gl_tpsmE=
J&d=3DDwIBaQ&c=3D5VD0RTtNlTh3ycd41b3MUw&r=3Dvxqvl81C2rT6GOGdPyz8iQ&m=3DsMAt=
pavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=3DNELwknC4AyuWSJIHbwt_O_c0jfPc_6D=
9RuKHh_adQ_Y&e=3D  for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this bug report. See:
> > https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__goo.gl_tpsmEJ-23=
status&d=3DDwIBaQ&c=3D5VD0RTtNlTh3ycd41b3MUw&r=3Dvxqvl81C2rT6GOGdPyz8iQ&m=
=3DsMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=3DYfV-e6A04EIqHwezxYop7CpJ=
yhXD8DVzwTPUT0xckaM&e=3D  for how to communicate with syzbot.
> > For information about bisection process see: https://urldefense.proofpo=
int.com/v2/url?u=3Dhttps-3A__goo.gl_tpsmEJ-23bisection&d=3DDwIBaQ&c=3D5VD0R=
TtNlTh3ycd41b3MUw&r=3Dvxqvl81C2rT6GOGdPyz8iQ&m=3DsMAtpavBBjBzFzT0V8c6FcH8cu=
2M9da3ZozO5Lc8do0&s=3DxOFzqI48uvECf4XFjlhNl4LBOT02lz1HlCL6MT1uMrI&e=3D
> > syzbot can test patches for this bug, for details see:
> > https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__goo.gl_tpsmEJ-23=
testing-2Dpatches&d=3DDwIBaQ&c=3D5VD0RTtNlTh3ycd41b3MUw&r=3Dvxqvl81C2rT6GOG=
dPyz8iQ&m=3DsMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=3D_cj6MOAz3yNlXgj=
MuyRu6ZOEjRvYWEvtTd7kE46wVfo&e=3D
> >
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgi=
d/syzkaller-bugs/d65c8424-e78c-63f9-3711-532494619dc6%40fb.com.
