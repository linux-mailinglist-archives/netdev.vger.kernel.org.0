Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C84C16B467
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 23:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728592AbgBXWnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 17:43:43 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20717 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728584AbgBXWnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 17:43:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582584219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+oclofHchw/GDHhS/ehFkqV0QdXivh6ncK51lEL/8AU=;
        b=eQpTpJcy2fgz+GOGqe0oGEELwJooEkYzeC3DSGj3iV6PF6JP9+CgWyjHKAhwQep50B7g+m
        a6tmkA+k1KP2hGKJcUGoidYxFvbH9ZRnkMF2sPllHD3JeoRKzy2Fh+n6H3UOZteXyX7Tsi
        5zIN5lL5UAVUAtzI2bbaa9gxuoteirY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-127-GpfJUv9pOg-tSLx_ZMzHLA-1; Mon, 24 Feb 2020 17:43:35 -0500
X-MC-Unique: GpfJUv9pOg-tSLx_ZMzHLA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A5F618C8C01;
        Mon, 24 Feb 2020 22:43:32 +0000 (UTC)
Received: from ovpn-121-250.rdu2.redhat.com (ovpn-121-250.rdu2.redhat.com [10.10.121.250])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F3009078A;
        Mon, 24 Feb 2020 22:43:27 +0000 (UTC)
Message-ID: <17916d0509978e14d9a5e9eb52d760fa57460542.camel@redhat.com>
Subject: Re: kernel panic: audit: backlog limit exceeded
From:   Eric Paris <eparis@redhat.com>
To:     Paul Moore <paul@paul-moore.com>,
        syzbot <syzbot+9a5e789e4725b9ef1316@syzkaller.appspotmail.com>
Cc:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        dan.carpenter@oracle.com, davem@davemloft.net, fzago@cray.com,
        gregkh@linuxfoundation.org, john.hammond@intel.com,
        linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com
Date:   Mon, 24 Feb 2020 17:43:27 -0500
In-Reply-To: <CAHC9VhQVXk5ucd3=7OC=BxEkZGGLfXv9bESX67Mr-TRmTwxjEg@mail.gmail.com>
References: <0000000000003cbb40059f4e0346@google.com>
         <CAHC9VhQVXk5ucd3=7OC=BxEkZGGLfXv9bESX67Mr-TRmTwxjEg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

https://syzkaller.appspot.com/x/repro.syz?x=151b1109e00000 (the
reproducer listed) looks like it is literally fuzzing the AUDIT_SET.
Which seems like this is working as designed if it is setting the
failure mode to 2.

On Mon, 2020-02-24 at 17:38 -0500, Paul Moore wrote:
> On Mon, Feb 24, 2020 at 3:18 AM syzbot
> <syzbot+9a5e789e4725b9ef1316@syzkaller.appspotmail.com> wrote:
> > Hello,
> > 
> > syzbot found the following crash on:
> > 
> > HEAD commit:    36a44bcd Merge branch 'bnxt_en-shutdown-and-kexec-
> > kdump-re..
> > git tree:       net
> > console output: 
> > https://syzkaller.appspot.com/x/log.txt?x=148bfdd9e00000
> > kernel config:  
> > https://syzkaller.appspot.com/x/.config?x=768cc3d3e277cc16
> > dashboard link: 
> > https://syzkaller.appspot.com/bug?extid=9a5e789e4725b9ef1316
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      
> > https://syzkaller.appspot.com/x/repro.syz?x=151b1109e00000
> > C reproducer:   
> > https://syzkaller.appspot.com/x/repro.c?x=128bfdd9e00000
> > 
> > The bug was bisected to:
> > 
> > commit 0c1b9970ddd4cc41002321c3877e7f91aacb896d
> > Author: Dan Carpenter <dan.carpenter@oracle.com>
> > Date:   Fri Jul 28 14:42:27 2017 +0000
> > 
> >     staging: lustre: lustre: Off by two in lmv_fid2path()
> > 
> > bisection log:  
> > https://syzkaller.appspot.com/x/bisect.txt?x=17e6c3e9e00000
> > final crash:    
> > https://syzkaller.appspot.com/x/report.txt?x=1416c3e9e00000
> > console output: 
> > https://syzkaller.appspot.com/x/log.txt?x=1016c3e9e00000
> > 
> > IMPORTANT: if you fix the bug, please add the following tag to the
> > commit:
> > Reported-by: syzbot+9a5e789e4725b9ef1316@syzkaller.appspotmail.com
> > Fixes: 0c1b9970ddd4 ("staging: lustre: lustre: Off by two in
> > lmv_fid2path()")
> > 
> > audit: audit_backlog=13 > audit_backlog_limit=7
> > audit: audit_lost=1 audit_rate_limit=0 audit_backlog_limit=7
> > Kernel panic - not syncing: audit: backlog limit exceeded
> > CPU: 1 PID: 9913 Comm: syz-executor024 Not tainted 5.6.0-rc1-
> > syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine,
> > BIOS Google 01/01/2011
> > Call Trace:
> >  __dump_stack lib/dump_stack.c:77 [inline]
> >  dump_stack+0x197/0x210 lib/dump_stack.c:118
> >  panic+0x2e3/0x75c kernel/panic.c:221
> >  audit_panic.cold+0x32/0x32 kernel/audit.c:307
> >  audit_log_lost kernel/audit.c:377 [inline]
> >  audit_log_lost+0x8b/0x180 kernel/audit.c:349
> >  audit_log_start kernel/audit.c:1788 [inline]
> >  audit_log_start+0x70e/0x7c0 kernel/audit.c:1745
> >  audit_log+0x95/0x120 kernel/audit.c:2345
> >  xt_replace_table+0x61d/0x830 net/netfilter/x_tables.c:1413
> >  __do_replace+0x1da/0x950 net/ipv6/netfilter/ip6_tables.c:1084
> >  do_replace net/ipv6/netfilter/ip6_tables.c:1157 [inline]
> >  do_ip6t_set_ctl+0x33a/0x4c8 net/ipv6/netfilter/ip6_tables.c:1681
> >  nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
> >  nf_setsockopt+0x77/0xd0 net/netfilter/nf_sockopt.c:115
> >  ipv6_setsockopt net/ipv6/ipv6_sockglue.c:949 [inline]
> >  ipv6_setsockopt+0x147/0x180 net/ipv6/ipv6_sockglue.c:933
> >  tcp_setsockopt net/ipv4/tcp.c:3165 [inline]
> >  tcp_setsockopt+0x8f/0xe0 net/ipv4/tcp.c:3159
> >  sock_common_setsockopt+0x94/0xd0 net/core/sock.c:3149
> >  __sys_setsockopt+0x261/0x4c0 net/socket.c:2130
> >  __do_sys_setsockopt net/socket.c:2146 [inline]
> >  __se_sys_setsockopt net/socket.c:2143 [inline]
> >  __x64_sys_setsockopt+0xbe/0x150 net/socket.c:2143
> >  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
> >  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > RIP: 0033:0x44720a
> > Code: 49 89 ca b8 37 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 1a e0
> > fb ff c3 66 0f 1f 84 00 00 00 00 00 49 89 ca b8 36 00 00 00 0f 05
> > <48> 3d 01 f0 ff ff 0f 83 fa df fb ff c3 66 0f 1f 84 00 00 00 00 00
> > RSP: 002b:00007ffd032dec78 EFLAGS: 00000286 ORIG_RAX:
> > 0000000000000036
> > RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000044720a
> > RDX: 0000000000000040 RSI: 0000000000000029 RDI: 0000000000000003
> > RBP: 00007ffd032deda0 R08: 00000000000003b8 R09: 0000000000004000
> > R10: 00000000006d7b40 R11: 0000000000000286 R12: 00007ffd032deca0
> > R13: 00000000006d9d60 R14: 0000000000000029 R15: 00000000006d7ba0
> > Kernel Offset: disabled
> > Rebooting in 86400 seconds..
> > 
> > 
> > ---
> > This bug is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> > 
> > syzbot will keep track of this bug report. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > For information about bisection process see: 
> > https://goo.gl/tpsmEJ#bisection
> > syzbot can test patches for this bug, for details see:
> > https://goo.gl/tpsmEJ#testing-patches
> 
> Similar to syzbot report 72461ac44b36c98f58e5, see my comments there.
> 

