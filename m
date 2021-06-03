Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC3039A960
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbhFCRlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:41:12 -0400
Received: from mg.ssi.bg ([178.16.128.9]:52868 "EHLO mg.ssi.bg"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231246AbhFCRlM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:41:12 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jun 2021 13:41:10 EDT
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id 4909531AD7;
        Thu,  3 Jun 2021 20:32:17 +0300 (EEST)
Received: from ink.ssi.bg (ink.ssi.bg [178.16.128.7])
        by mg.ssi.bg (Proxmox) with ESMTP id 30E0031ACD;
        Thu,  3 Jun 2021 20:32:16 +0300 (EEST)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id 2B7ED3C0332;
        Thu,  3 Jun 2021 20:32:13 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.16.1/8.16.1) with ESMTP id 153HW882019762;
        Thu, 3 Jun 2021 20:32:09 +0300
Date:   Thu, 3 Jun 2021 20:32:08 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Xin Long <lucien.xin@gmail.com>
cc:     syzbot <syzbot+e562383183e4b1766930@syzkaller.appspotmail.com>,
        coreteam@netfilter.org, Simon Horman <horms@verge.net.au>,
        LKML <linux-kernel@vger.kernel.org>, lvs-devel@vger.kernel.org,
        network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: [syzbot] memory leak in ip_vs_add_service
In-Reply-To: <CADvbK_duDeZidW1mgSyNo+f1Hj4L0V6=L-Upfgp+5DEu5P-8Ag@mail.gmail.com>
Message-ID: <b216d7a4-c3dd-3714-3897-3124769c88f2@ssi.bg>
References: <000000000000c91e6f05c3144acc@google.com> <CADvbK_duDeZidW1mgSyNo+f1Hj4L0V6=L-Upfgp+5DEu5P-8Ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Wed, 2 Jun 2021, Xin Long wrote:

> On Mon, May 24, 2021 at 10:33 AM syzbot
> <syzbot+e562383183e4b1766930@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    c3d0e3fd Merge tag 'fs.idmapped.mount_setattr.v5.13-rc3' o..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=148d0bd7d00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=ae7b129a135ab06b
> > dashboard link: https://syzkaller.appspot.com/bug?extid=e562383183e4b1766930
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15585a4bd00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13900753d00000
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+e562383183e4b1766930@syzkaller.appspotmail.com
> >
> > BUG: memory leak
> > unreferenced object 0xffff888115227800 (size 512):
> >   comm "syz-executor263", pid 8658, jiffies 4294951882 (age 12.560s)
> >   hex dump (first 32 bytes):
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >   backtrace:
> >     [<ffffffff83977188>] kmalloc include/linux/slab.h:556 [inline]
> >     [<ffffffff83977188>] kzalloc include/linux/slab.h:686 [inline]
> >     [<ffffffff83977188>] ip_vs_add_service+0x598/0x7c0 net/netfilter/ipvs/ip_vs_ctl.c:1343
> >     [<ffffffff8397d770>] do_ip_vs_set_ctl+0x810/0xa40 net/netfilter/ipvs/ip_vs_ctl.c:2570
> >     [<ffffffff838449a8>] nf_setsockopt+0x68/0xa0 net/netfilter/nf_sockopt.c:101
> >     [<ffffffff839ae4e9>] ip_setsockopt+0x259/0x1ff0 net/ipv4/ip_sockglue.c:1435
> >     [<ffffffff839fa03c>] raw_setsockopt+0x18c/0x1b0 net/ipv4/raw.c:857
> >     [<ffffffff83691f20>] __sys_setsockopt+0x1b0/0x360 net/socket.c:2117
> >     [<ffffffff836920f2>] __do_sys_setsockopt net/socket.c:2128 [inline]
> >     [<ffffffff836920f2>] __se_sys_setsockopt net/socket.c:2125 [inline]
> >     [<ffffffff836920f2>] __x64_sys_setsockopt+0x22/0x30 net/socket.c:2125
> >     [<ffffffff84350efa>] do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
> >     [<ffffffff84400068>] entry_SYSCALL_64_after_hwframe+0x44/0xae
> do_ip_vs_set_ctl() allows users to add svc with the flags field set.
> when IP_VS_SVC_F_HASHED is used, and in ip_vs_svc_hash()
> called ip_vs_add_service() will trigger the err msg:
> 
> IPVS: ip_vs_svc_hash(): request for already hashed, called from
> do_ip_vs_set_ctl+0x810/0xa40
> 
> and the svc allocated will leak.
> 
> so fix it by mask the flags with ~IP_VS_SVC_F_HASHED in
> ip_vs_copy_usvc_compat(), while at it also remove the unnecessary
> flag IP_VS_SVC_F_HASHED set in ip_vs_edit_service().

	The net tree already contains fix for this problem.

Regards

--
Julian Anastasov <ja@ssi.bg>

