Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D62F361A1F
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 08:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238802AbhDPG4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 02:56:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36875 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231193AbhDPG4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 02:56:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618556169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9zKGmOBl5s2voXBRRJzrAfe9LNA8/Ea0W/gGIHB5lVM=;
        b=Q9W1Yzu7HGMGWhQ0NIlea2AAxGix8IGyELartX1dBBmbJ+5nzEWL860iKISPUd227aJVO9
        n4xnSMz/2l5WovJ7g7MpYXwxaCxRqCxA9Vrhih3fsBRwjSG1nSvMQVmqovlC9J+9SVr5HB
        NM7Nra+QsfFAImH+pZUPQKlfWkYaplI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-_kvajnzhMbef5Yart1B8YQ-1; Fri, 16 Apr 2021 02:56:07 -0400
X-MC-Unique: _kvajnzhMbef5Yart1B8YQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AC57F1854E20;
        Fri, 16 Apr 2021 06:56:05 +0000 (UTC)
Received: from krava (unknown [10.40.193.247])
        by smtp.corp.redhat.com (Postfix) with SMTP id 1B5EA6F98C;
        Fri, 16 Apr 2021 06:55:58 +0000 (UTC)
Date:   Fri, 16 Apr 2021 08:55:57 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Julia Lawall <julia.lawall@inria.fr>
Subject: Re: [PATCHv5 bpf-next 0/7] bpf: Tracing and lsm programs re-attach
Message-ID: <YHk0/QgLQagZMQpf@krava>
References: <20210414195147.1624932-1-jolsa@kernel.org>
 <CAADnVQK9+Rj8CCC0JZaQaovWqeJKWoAQihOU3eMjf94mk9e+xA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQK9+Rj8CCC0JZaQaovWqeJKWoAQihOU3eMjf94mk9e+xA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 04:45:24PM -0700, Alexei Starovoitov wrote:
> On Wed, Apr 14, 2021 at 12:52 PM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > hi,
> > while adding test for pinning the module while there's
> > trampoline attach to it, I noticed that we don't allow
> > link detach and following re-attach for trampolines.
> > Adding that for tracing and lsm programs.
> >
> > You need to have patch [1] from bpf tree for test module
> > attach test to pass.
> >
> > v5 changes:
> >   - fixed missing hlist_del_init change
> >   - fixed several ASSERT calls
> >   - added extra patch for missing ';'
> >   - added ASSERT macros to lsm test
> >   - added acks
> 
> It doesn't work:

hi,
I got the same warning when running test without the
patch [1] I mentioned:
  861de02e5f3f bpf: Take module reference for trampoline in module

I still don't see it in bpf-next/master

jirka

> [   52.763254] ------------[ cut here ]------------
> [   52.763767] WARNING: CPU: 2 PID: 1967 at kernel/bpf/syscall.c:2518
> bpf_tracing_link_release+0x34/0x40
> [   52.764666] Modules linked in: bpf_preload [last unloaded: bpf_testmod]
> [   52.765310] CPU: 2 PID: 1967 Comm: test_progs Tainted: G
> O      5.12.0-rc4-01652-gf03a9b92b5f3 #3293
> [   52.766279] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS 1.11.0-2.el7 04/01/2014
> [   52.767128] RIP: 0010:bpf_tracing_link_release+0x34/0x40
> [   52.767653] Code: 8b 77 48 48 8b 7f 18 e8 ea 67 02 00 85 c0 75 1a
> 48 8b 7b 48 e8 ad 60 02 00 48 8b 7b 50 48 85 ff 74 06 5b e9 6e ff ff
> ff 5b c3 <0f> 0b eb e2 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89
> fd 8b
> [   52.769444] RSP: 0018:ffffc900001bfe98 EFLAGS: 00010286
> [   52.769957] RAX: 00000000ffffffed RBX: ffff88810218e420 RCX: 0000000000000000
> [   52.770642] RDX: ffff888105e89f80 RSI: ffffffff8118e539 RDI: ffff88811cafec10
> [   52.771338] RBP: ffff88810218e420 R08: 0000000000000270 R09: 00000000000003cb
> [   52.772041] R10: ffff8881002a1090 R11: ffff888237d2aaf0 R12: ffff888101951030
> [   52.772729] R13: ffff888100226f20 R14: ffff88810629f180 R15: ffff888105e89f80
> [   52.773419] FS:  00007f82c7b93700(0000) GS:ffff888237d00000(0000)
> knlGS:0000000000000000
> [   52.774213] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   52.774784] CR2: 00007f82c7ba1000 CR3: 0000000105cfc006 CR4: 00000000003706e0
> [   52.775494] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   52.776199] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [   52.776887] Call Trace:
> [   52.777143]  bpf_link_free+0x25/0x40
> [   52.777525]  bpf_link_release+0x11/0x20
> [   52.777924]  __fput+0x9f/0x240
> [   52.778234]  task_work_run+0x63/0xb0
> [   52.778588]  exit_to_user_mode_prepare+0x132/0x140
> [   52.779064]  syscall_exit_to_user_mode+0x1d/0x40
> [   52.779519]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   52.780026] RIP: 0033:0x7f82c6f3815d
> [   52.780384] Code: c2 20 00 00 75 10 b8 03 00 00 00 0f 05 48 3d 01
> f0 ff ff 73 31 c3 48 83 ec 08 e8 ee fb ff ff 48 89 04 24 b8 03 00 00
> 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 37 fc ff ff 48 89 d0 48 83 c4 08 48
> 3d 01
> test_module_attach:FAIL:delete_module unexpected success: 0
> libbpf: prog 'handle_fexit': failed to attach: No such file or directory
> test_module_attach:FAIL:attach_fexit unexpected error: -2
> #68 module_attach:FAIL
> 
> and another in:
> ./test_progs -t module
> [  156.660834] ------------[ cut here ]------------
> [  156.661414] WARNING: CPU: 3 PID: 2511 at kernel/trace/ftrace.c:6321
> ftrace_module_enable+0x33a/0x370
> [  156.662445] Modules linked in: bpf_testmod(O+) bpf_preload [last
> unloaded: bpf_testmod]
> [  156.663325] CPU: 3 PID: 2511 Comm: test_progs Tainted: G        W
> O      5.12.0-rc4-01652-gf03a9b92b5f3 #3293
> [  156.664369] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS 1.11.0-2.el7 04/01/2014
> [  156.665265] RIP: 0010:ftrace_module_enable+0x33a/0x370
> [  156.665890] Code: 00 00 74 9d 48 0d 00 00 00 10 48 89 45 08 e9 db
> fe ff ff 8b 8b 98 01 00 00 48 01 ca 48 39 d0 0f 83 2c fd ff ff e9 66
> fd ff ff <0f> 0b e9 bd fe ff ff 0f 0b e9 b6 fe ff ff 48 83 78 10 00 0f
> 85 dd
> [  156.667822] RSP: 0018:ffffc900001c7d50 EFLAGS: 00010206
> [  156.668354] RAX: 0000000000000000 RBX: ffffffffa001c380 RCX: 0000000000005000
> [  156.669079] RDX: 0000000000031045 RSI: ffffffffa0019080 RDI: 0000000000000000
> [  156.669793] RBP: ffff888104bd9020 R08: ffffffff83174f00 R09: 0000000000000000
> [  156.670529] R10: 0000000000000001 R11: ffffffffa0019080 R12: ffff88810092e480
> [  156.671368] R13: 61c8864680b583eb R14: 0000000000000002 R15: 0000000000000000
> [  156.672135] FS:  00007f198becc700(0000) GS:ffff888237d80000(0000)
> knlGS:0000000000000000
> [  156.672973] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  156.673625] CR2: 00000000006a14f0 CR3: 00000001169be003 CR4: 00000000003706e0
> [  156.674411] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  156.675209] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  156.675959] Call Trace:
> [  156.676209]  load_module+0x1f71/0x27d0
> [  156.676623]  ? __do_sys_finit_module+0x8f/0xc0
> [  156.677084]  __do_sys_finit_module+0x8f/0xc0
> [  156.677525]  do_syscall_64+0x2d/0x40
> [  156.677932]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  156.678465] RIP: 0033:0x7f198afa37f9
> [  156.678837] Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40
> 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24
> 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 57 76 2b 00 f7 d8 64 89
> 01 48
> [  156.680812] RSP: 002b:00007ffc428756d8 EFLAGS: 00000202 ORIG_RAX:
> 0000000000000139
> [  156.681614] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007f198afa37f9
> [  156.682344] RDX: 0000000000000000 RSI: 00000000006a14f7 RDI: 0000000000000004
> [  156.683111] RBP: 00007ffc428758b8 R08: 00007f198becc700 R09: 00007ffc428758b8
> [  156.683842] R10: 00007f198becc700 R11: 0000000000000202 R12: 000000000040bce0
> [  156.684590] R13: 00007ffc428758b0 R14: 0000000000000000 R15: 0000000000000000
> [  156.685335] ---[ end trace 7086b04742183c35 ]---
> #58 ksyms_module:OK
> 

