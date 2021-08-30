Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABEB33FB5F8
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 14:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236843AbhH3MYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 08:24:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231165AbhH3MYu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 08:24:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B1B5610E6;
        Mon, 30 Aug 2021 12:23:51 +0000 (UTC)
Date:   Mon, 30 Aug 2021 14:23:48 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     syzbot <syzbot+d1e3b1d92d25abf97943@syzkaller.appspotmail.com>
Cc:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        casey@schaufler-ca.com, daniel@iogearbox.net, dhowells@redhat.com,
        dvyukov@google.com, jmorris@namei.org, kafai@fb.com,
        kpsingh@google.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        paul@paul-moore.com, selinux@vger.kernel.org,
        songliubraving@fb.com, stephen.smalley.work@gmail.com,
        syzkaller-bugs@googlegroups.com, tonymarislogistics@yandex.com,
        viro@zeniv.linux.org.uk, yhs@fb.com
Subject: Re: [syzbot] general protection fault in legacy_parse_param
Message-ID: <20210830122348.jffs5dmq6z25qzw5@wittgenstein>
References: <0000000000004e5ec705c6318557@google.com>
 <0000000000008d2a0005ca951d94@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0000000000008d2a0005ca951d94@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 27, 2021 at 07:11:18PM -0700, syzbot wrote:
> syzbot has bisected this issue to:
> 
> commit 54261af473be4c5481f6196064445d2945f2bdab
> Author: KP Singh <kpsingh@google.com>
> Date:   Thu Apr 30 15:52:40 2020 +0000
> 
>     security: Fix the default value of fs_context_parse_param hook
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=160c5d75300000
> start commit:   77dd11439b86 Merge tag 'drm-fixes-2021-08-27' of git://ano..
> git tree:       upstream
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=150c5d75300000
> console output: https://syzkaller.appspot.com/x/log.txt?x=110c5d75300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=2fd902af77ff1e56
> dashboard link: https://syzkaller.appspot.com/bug?extid=d1e3b1d92d25abf97943
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=126d084d300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16216eb1300000
> 
> Reported-by: syzbot+d1e3b1d92d25abf97943@syzkaller.appspotmail.com
> Fixes: 54261af473be ("security: Fix the default value of fs_context_parse_param hook")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

So ok, this seems somewhat clear now. When smack and 
CONFIG_BPF_LSM=y
is selected the bpf LSM will register NOP handlers including

bpf_lsm_fs_context_fs_param()

for the

fs_context_fs_param

LSM hook. The bpf LSM runs last, i.e. after smack according to:

CONFIG_LSM="landlock,lockdown,yama,safesetid,integrity,tomoyo,smack,bpf"

in the appended config. The smack hook runs and sets

param->string = NULL

then the bpf NOP handler runs returning -ENOPARM indicating to the vfs
parameter parser that this is not a security module option so it should
proceed processing the parameter subsequently causing the crash because
param->string is not allowed to be NULL (Which the vfs parameter parser
verifies early in fsconfig().).

If you take the appended syzkaller config and additionally select
kprobes you can observe this by registering bpf kretprobes for:
security_fs_context_parse_param()
smack_fs_context_parse_param()
bpf_lsm_fs_context_parse_param()
in different terminal windows and then running the syzkaller provided
reproducer:

root@f2-vm:~# bpftrace -e 'kretprobe:smack_fs_context_parse_param { printf("returned: %d\n", retval); }'
Attaching 1 probe...
returned: 0

root@f2-vm:~# bpftrace -e 'kretprobe:bpf_lsm_fs_context_parse_param { printf("returned: %d\n", retval); }'
Attaching 1 probe...
returned: -519

root@f2-vm:~# bpftrace -e 'kretprobe:security_fs_context_parse_param { printf("returned: %d\n", retval); }'
Attaching 1 probe...
returned: -519

^^^^^
This will ultimately tell the vfs to move on causing the crash because
param->string is null at that point.

Unless I missed something why that can't happen.

Christian
