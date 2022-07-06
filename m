Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 137F4568F55
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 18:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233028AbiGFQky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 12:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232351AbiGFQkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 12:40:53 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEBEE193E2;
        Wed,  6 Jul 2022 09:40:52 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id z12so11457399qki.3;
        Wed, 06 Jul 2022 09:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OBd8LZPGUvsdQXbTc4zaMRavgLTINIjBhOwnEvOAp84=;
        b=ZrZyMrDdlVjKts2PmrZmt56BY3UuXlBAzb6LEmnLkJyKhmTuBnUEmGhcYe7aCOyVd9
         d4lr+SZkZXmZLVlDTlIFRytxNX0CFjk4tDolpJA/8lfyviYbWN2fq/jwyVc1TfuBak70
         rH+ZVbiNhBFcVxr5sf/N9YbSqULOlwzrsrzUf13Rq71d+9aQJs4EcOelL9GYah891hQX
         +vzrxleQc08QXlbYgOUyrRYs2TktGV3bD2KVUGocKwq0Kqz9chdUxZ2c9LeBAuMQnwtp
         axFe+jBsB75O3dlxrZyveDb4wPvlAD0o30cr73CgvAX7d6l2wTW1cY3oTYf/gdlzjAqb
         PSJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OBd8LZPGUvsdQXbTc4zaMRavgLTINIjBhOwnEvOAp84=;
        b=hDEm21nxrzEabsVy3BuY+ePXBIDblsGh4PHnr1B6Vqfs8QW+SCKiZyG+u9yyPrDKCQ
         CcNQOHLQSaehGmHvThOOC2v7sCBd7L7/fvZ0d6+vTuHwADNXVqKVmIFIfzrPGqVSP/eL
         pLtYhpqU4v6zb7c4P/hGN07C1kidQNfwvCfyEv+QN0tW+UOhJeweX73DvetSOUYefD31
         7jIZwxtUcoWImbu+ohQE0vG727KNomJ+oqgowi+QC2Z/4LUiVgGOdEJ4CODBUD0hnj5V
         OjhdoSaoSu/hswsRf8khmY1RZpkvKVO5SU4cZIOo2CDLETX3ffpGnxT6op9xG0GKWwLf
         +7fQ==
X-Gm-Message-State: AJIora+H2g6KWw6GdfRQ3Ut8fgyX5Dl4bg1sU6PJQpqhyqrkBbRVjLNt
        2yVhtMbbR17J0N0e6U4juYU=
X-Google-Smtp-Source: AGRyM1tiH6XKwk3Yt445j7VE5/fPEUbexDerGd9aO4cYBUHHeH1jJF1bBxKh2MghQ5ubkKueDZkIBg==
X-Received: by 2002:a05:620a:4724:b0:6af:dd84:1f33 with SMTP id bs36-20020a05620a472400b006afdd841f33mr27938530qkb.464.1657125651758;
        Wed, 06 Jul 2022 09:40:51 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:b82:8788:1659:63af])
        by smtp.gmail.com with ESMTPSA id k22-20020a05620a415600b006b4880b08a9sm4779043qko.88.2022.07.06.09.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 09:40:51 -0700 (PDT)
Date:   Wed, 6 Jul 2022 09:40:48 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     syzbot <syzbot+a0e6f8738b58f7654417@syzkaller.appspotmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Wei Wang <weiwan@google.com>
Subject: Re: [syzbot] WARNING in sk_stream_kill_queues (8)
Message-ID: <YsW7EP45TloIyEtv@pop-os.localdomain>
References: <000000000000b06e5505e299a9b6@google.com>
 <CANn89iLuGKyVcNAAjvwWk8HoJrNgZ5HM4itXEsnqzU=+xZLKOQ@mail.gmail.com>
 <CANn89iLvG0QBVkdhbC-x59ac=B=j+ZxXitBGanBo+8ThMJGG1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iLvG0QBVkdhbC-x59ac=B=j+ZxXitBGanBo+8ThMJGG1g@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 07:46:35PM +0200, Eric Dumazet wrote:
> On Wed, Jun 29, 2022 at 7:45 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Wed, Jun 29, 2022 at 7:41 PM syzbot
> > <syzbot+a0e6f8738b58f7654417@syzkaller.appspotmail.com> wrote:
> > >
> > > Hello,
> > >
> > > syzbot found the following issue on:
> > >
> > > HEAD commit:    aab35c3d5112 Add linux-next specific files for 20220627
> > > git tree:       linux-next
> > > console+strace: https://syzkaller.appspot.com/x/log.txt?x=126fef90080000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=6a874f114a1e4a6b
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=a0e6f8738b58f7654417
> > > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14ae0c98080000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=145124f4080000
> > >
> > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > Reported-by: syzbot+a0e6f8738b58f7654417@syzkaller.appspotmail.com
> > >
> > > nf_conntrack: default automatic helper assignment has been turned off for security reasons and CT-based firewall rule not found. Use the iptables CT target to attach helpers instead.
> > > ------------[ cut here ]------------
> > > WARNING: CPU: 1 PID: 3601 at net/core/stream.c:205 sk_stream_kill_queues+0x2ee/0x3d0 net/core/stream.c:205
> > > Modules linked in:
> > > CPU: 1 PID: 3601 Comm: syz-executor340 Not tainted 5.19.0-rc4-next-20220627-syzkaller #0
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > > RIP: 0010:sk_stream_kill_queues+0x2ee/0x3d0 net/core/stream.c:205
> > > Code: 03 0f b6 04 02 84 c0 74 08 3c 03 0f 8e ec 00 00 00 8b ab 28 02 00 00 e9 60 ff ff ff e8 3b 9a 29 fa 0f 0b eb 97 e8 32 9a 29 fa <0f> 0b eb a0 e8 29 9a 29 fa 0f 0b e9 6a fe ff ff e8 0d a1 75 fa e9
> > > RSP: 0018:ffffc90002e6fbf0 EFLAGS: 00010293
> > > RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> > > RDX: ffff88801e90ba80 RSI: ffffffff87511cce RDI: 0000000000000005
> > > RBP: 0000000000000b00 R08: 0000000000000005 R09: 0000000000000000
> > > R10: 0000000000000b00 R11: 0000000000000004 R12: ffff88801e0c8e28
> > > R13: ffffffff913121c0 R14: ffff88801e0c8c28 R15: ffff88801e0c8db8
> > > FS:  0000000000000000(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 000000000045b630 CR3: 000000000ba8e000 CR4: 00000000003506e0
> > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > Call Trace:
> > >  <TASK>
> > >  inet_csk_destroy_sock+0x1a5/0x440 net/ipv4/inet_connection_sock.c:1013
> > >  __tcp_close+0xb92/0xf50 net/ipv4/tcp.c:2963
> > >  tcp_close+0x29/0xc0 net/ipv4/tcp.c:2975
> > >  inet_release+0x12e/0x270 net/ipv4/af_inet.c:428
> > >  __sock_release+0xcd/0x280 net/socket.c:650
> > >  sock_close+0x18/0x20 net/socket.c:1365
> > >  __fput+0x277/0x9d0 fs/file_table.c:317
> > >  task_work_run+0xdd/0x1a0 kernel/task_work.c:177
> > >  exit_task_work include/linux/task_work.h:38 [inline]
> > >  do_exit+0xaf1/0x29f0 kernel/exit.c:795
> > >  do_group_exit+0xd2/0x2f0 kernel/exit.c:925
> > >  __do_sys_exit_group kernel/exit.c:936 [inline]
> > >  __se_sys_exit_group kernel/exit.c:934 [inline]
> > >  __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:934
> > >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> > >  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> > >  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> > > RIP: 0033:0x7f080e760989
> > > Code: Unable to access opcode bytes at RIP 0x7f080e76095f.
> > > RSP: 002b:00007ffcee785818 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> > > RAX: ffffffffffffffda RBX: 00007f080e7d4270 RCX: 00007f080e760989
> > > RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
> > > RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000000000010
> > > R10: 0000000000000010 R11: 0000000000000246 R12: 00007f080e7d4270
> > > R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
> > >  </TASK>
> > >
> > >
> > > ---
> > > This report is generated by a bot. It may contain errors.
> > > See https://goo.gl/tpsmEJ for more information about syzbot.
> > > syzbot engineers can be reached at syzkaller@googlegroups.com.
> > >
> > > syzbot will keep track of this issue. See:
> > > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > > syzbot can test patches for this issue, for details see:
> > > https://goo.gl/tpsmEJ#testing-patches
> >
> > Stanislav has bisected the issue to:
> >
> > commit 965b57b469a589d64d81b1688b38dcb537011bb0
> > Author: Cong Wang <cong.wang@bytedance.com>
> > Date:   Wed Jun 15 09:20:12 2022 -0700
> >
> >     net: Introduce a new proto_ops ->read_skb()
> >
> >     Currently both splice() and sockmap use ->read_sock() to
> >     read skb from receive queue, but for sockmap we only read
> >     one entire skb at a time, so ->read_sock() is too conservative
> >     to use. Introduce a new proto_ops ->read_skb() which supports
> >     this sematic, with this we can finally pass the ownership of
> >     skb to recv actors.
> >
> >     For non-TCP protocols, all ->read_sock() can be simply
> >     converted to ->read_skb().
> >
> >     Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> >     Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> >     Reviewed-by: John Fastabend <john.fastabend@gmail.com>
> >     Link: https://lore.kernel.org/bpf/20220615162014.89193-3-xiyou.wangcong@gmail.com
> 
> Repro is doing something like:
> 

I will look into this tonight.

Thanks for the report!
