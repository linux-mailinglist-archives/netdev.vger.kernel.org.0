Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 728726C7A7A
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 09:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbjCXI4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 04:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231846AbjCXI4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 04:56:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8FE72658F
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 01:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679648134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZxAkhHKrYJ0srGFc3F0EV6dWbdN1epluNmQZ05UnH9k=;
        b=AARZirLiwtJ6cYdaJS1y3dkVt/XRggbWuSe0do1q8fJ5axRgqa3JvTEzAtn/Y35VpDGxd5
        s83A2ZZnY0NsOumUNi6CdeHkDA82AiuaqunmqiLVjY+WnkBBJzc/FpUtSMH2XKv3HqJidl
        I4QTrqypIr+zbHXsnG7xy8wGkoeF/ck=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-575-7bzGR5FCP_6g5zgXKHG9cg-1; Fri, 24 Mar 2023 04:55:33 -0400
X-MC-Unique: 7bzGR5FCP_6g5zgXKHG9cg-1
Received: by mail-ed1-f69.google.com with SMTP id r19-20020a50aad3000000b005002e950cd3so2236475edc.11
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 01:55:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679648130;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZxAkhHKrYJ0srGFc3F0EV6dWbdN1epluNmQZ05UnH9k=;
        b=1W5+Yt0MDxMvH0Kaps7aYk8Lair5xjhEz6NrV98pHS+7xvFdF0M3XiZ5qQZ7txaKOx
         1lBP5yAvxrhxHtcZua5UP/c5d2piWULA/KhLG0Dnep3Dj8Dmklg27w1de8fKnp5X9zDm
         rOw7iDcbV3VymbHw09fSAFojMu1cOLcK3EWrtHws2qSjxJYmwZRETifzvZwVhdwmDR0/
         WDj2rpHYNtEogn8cTTMaQ1GIeGHW2JmFvVyuwWU2YVpF4d0q6wDEAXhy7mzzqoh3Ay0g
         pr/a610nDpekA/0o/Pqp/6PYz6/5igCVvqP733m7NL10MvoAUZJZpxBl2yBNSedtYQ9+
         rhMg==
X-Gm-Message-State: AAQBX9ccR6s/XqmltX8Sr/8cC7PF0JYCXGIk5gG1jti4ZZf9e64NUOuh
        /6MgvaygdvznYXjFz/bphpo6+xV0rT14crd/Qegryfa8zp7yLwNRtYeh0WzfSU1H2Ik9cnbCB2T
        2doEWMwujYOdh7oa6
X-Received: by 2002:aa7:cb02:0:b0:502:23a0:3fd2 with SMTP id s2-20020aa7cb02000000b0050223a03fd2mr519188edt.9.1679648130722;
        Fri, 24 Mar 2023 01:55:30 -0700 (PDT)
X-Google-Smtp-Source: AKy350YX/uSWz3mgiMf1oLd8gIw+qkgSA+ogg0wBEi0hrBE02dOvFyR/TyWJq9OfZyEEElYpo3ibwQ==
X-Received: by 2002:aa7:cb02:0:b0:502:23a0:3fd2 with SMTP id s2-20020aa7cb02000000b0050223a03fd2mr519164edt.9.1679648130400;
        Fri, 24 Mar 2023 01:55:30 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-98.retail.telecomitalia.it. [82.53.134.98])
        by smtp.gmail.com with ESMTPSA id u7-20020a170906b10700b0092f38a6d082sm9899665ejy.209.2023.03.24.01.55.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 01:55:29 -0700 (PDT)
Date:   Fri, 24 Mar 2023 09:55:27 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     syzbot <syzbot+befff0a9536049e7902e@syzkaller.appspotmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Bobby Eshleman <bobby.eshleman@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, stefanha@redhat.com,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
Subject: Re: [syzbot] [kvm?] [net?] [virt?] general protection fault in
 virtio_transport_purge_skbs
Message-ID: <CAGxU2F6m4KWXwOF8StjWbb=S6HRx=GhV_ONDcZxCZsDkvuaeUg@mail.gmail.com>
References: <000000000000708b1005f79acf5c@google.com>
 <CAGxU2F4ZiNEyrZzEJnYjYDz6CxniPGNW7AwyMLPLTxA2UbBWhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGxU2F4ZiNEyrZzEJnYjYDz6CxniPGNW7AwyMLPLTxA2UbBWhA@mail.gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 24, 2023 at 9:31 AM Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> Hi Bobby,
> can you take a look at this report?
>
> It seems related to the changes we made to support skbuff.

Could it be a problem of concurrent access to pkt_queue ?

IIUC we should hold pkt_queue.lock when we call skb_queue_splice_init()
and remove pkt_list_lock. (or hold pkt_list_lock when calling
virtio_transport_purge_skbs, but pkt_list_lock seems useless now that
we use skbuff)

#syz test https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git fff5a5e7f528

--- a/net/vmw_vsock/vsock_loopback.c
+++ b/net/vmw_vsock/vsock_loopback.c
@@ -15,7 +15,6 @@
 struct vsock_loopback {
        struct workqueue_struct *workqueue;
 
-       spinlock_t pkt_list_lock; /* protects pkt_list */
        struct sk_buff_head pkt_queue;
        struct work_struct pkt_work;
 };
@@ -32,9 +31,7 @@ static int vsock_loopback_send_pkt(struct sk_buff *skb)
        struct vsock_loopback *vsock = &the_vsock_loopback;
        int len = skb->len;
 
-       spin_lock_bh(&vsock->pkt_list_lock);
        skb_queue_tail(&vsock->pkt_queue, skb);
-       spin_unlock_bh(&vsock->pkt_list_lock);
 
        queue_work(vsock->workqueue, &vsock->pkt_work);
 
@@ -113,9 +110,9 @@ static void vsock_loopback_work(struct work_struct *work)
 
        skb_queue_head_init(&pkts);
 
-       spin_lock_bh(&vsock->pkt_list_lock);
+       spin_lock_bh(&vsock->pkt_queue.lock);
        skb_queue_splice_init(&vsock->pkt_queue, &pkts);
-       spin_unlock_bh(&vsock->pkt_list_lock);
+       spin_unlock_bh(&vsock->pkt_queue.lock);
 
        while ((skb = __skb_dequeue(&pkts))) {
                virtio_transport_deliver_tap_pkt(skb);
@@ -132,7 +129,6 @@ static int __init vsock_loopback_init(void)
        if (!vsock->workqueue)
                return -ENOMEM;
 
-       spin_lock_init(&vsock->pkt_list_lock);
        skb_queue_head_init(&vsock->pkt_queue);
        INIT_WORK(&vsock->pkt_work, vsock_loopback_work);

>
> Thanks,
> Stefano
>
> On Fri, Mar 24, 2023 at 1:52 AM syzbot
> <syzbot+befff0a9536049e7902e@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    fff5a5e7f528 Merge tag 'for-linus' of git://git.armlinux.o..
> > git tree:       upstream
> > console+strace: https://syzkaller.appspot.com/x/log.txt?x=1136e97ac80000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=aaa4b45720ca0519
> > dashboard link: https://syzkaller.appspot.com/bug?extid=befff0a9536049e7902e
> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14365781c80000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12eebc66c80000
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/997791f5f9e1/disk-fff5a5e7.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/0b0155b5eac1/vmlinux-fff5a5e7.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/8d98dd2ba6b6/bzImage-fff5a5e7.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+befff0a9536049e7902e@syzkaller.appspotmail.com
> >
> > general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
> > KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> > CPU: 0 PID: 8759 Comm: syz-executor379 Not tainted 6.3.0-rc3-syzkaller-00026-gfff5a5e7f528 #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023
> > RIP: 0010:virtio_transport_purge_skbs+0x139/0x4c0 net/vmw_vsock/virtio_transport_common.c:1370
> > Code: 00 00 00 00 fc ff df 48 89 c2 48 89 44 24 28 48 c1 ea 03 48 8d 04 1a 48 89 44 24 10 eb 29 e8 ee 27 a3 f7 48 89 e8 48 c1 e8 03 <80> 3c 18 00 0f 85 a6 02 00 00 49 39 ec 48 8b 55 00 49 89 ef 0f 84
> > RSP: 0018:ffffc90006427b48 EFLAGS: 00010256
> > RAX: 0000000000000000 RBX: dffffc0000000000 RCX: 0000000000000000
> > RDX: ffff8880211157c0 RSI: ffffffff89dfbd12 RDI: ffff88802c11a018
> > RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000003
> > R10: fffff52000c84f5b R11: 0000000000000000 R12: ffffffff92179188
> > R13: ffffc90006427ba0 R14: ffff88801e0f1100 R15: ffff88802c11a000
> > FS:  00007f01fdd51700(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007f01fdd30718 CR3: 000000002a3f9000 CR4: 0000000000350ef0
> > Call Trace:
> >  <TASK>
> >  vsock_loopback_cancel_pkt+0x1c/0x20 net/vmw_vsock/vsock_loopback.c:48
> >  vsock_transport_cancel_pkt net/vmw_vsock/af_vsock.c:1284 [inline]
> >  vsock_connect+0x852/0xcc0 net/vmw_vsock/af_vsock.c:1426
> >  __sys_connect_file+0x153/0x1a0 net/socket.c:2001
> >  __sys_connect+0x165/0x1a0 net/socket.c:2018
> >  __do_sys_connect net/socket.c:2028 [inline]
> >  __se_sys_connect net/socket.c:2025 [inline]
> >  __x64_sys_connect+0x73/0xb0 net/socket.c:2025
> >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
> >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > RIP: 0033:0x7f01fdda0159
> > Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 41 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007f01fdd51308 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
> > RAX: ffffffffffffffda RBX: 00007f01fde28428 RCX: 00007f01fdda0159
> > RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
> > RBP: 00007f01fde28420 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000246 R12: 00007f01fddf606c
> > R13: 0000000000000000 R14: 00007f01fdd51400 R15: 0000000000022000
> >  </TASK>
> > Modules linked in:
> > ---[ end trace 0000000000000000 ]---
> > RIP: 0010:virtio_transport_purge_skbs+0x139/0x4c0 net/vmw_vsock/virtio_transport_common.c:1370
> > Code: 00 00 00 00 fc ff df 48 89 c2 48 89 44 24 28 48 c1 ea 03 48 8d 04 1a 48 89 44 24 10 eb 29 e8 ee 27 a3 f7 48 89 e8 48 c1 e8 03 <80> 3c 18 00 0f 85 a6 02 00 00 49 39 ec 48 8b 55 00 49 89 ef 0f 84
> > RSP: 0018:ffffc90006427b48 EFLAGS: 00010256
> > RAX: 0000000000000000 RBX: dffffc0000000000 RCX: 0000000000000000
> > RDX: ffff8880211157c0 RSI: ffffffff89dfbd12 RDI: ffff88802c11a018
> > RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000003
> > R10: fffff52000c84f5b R11: 0000000000000000 R12: ffffffff92179188
> > R13: ffffc90006427ba0 R14: ffff88801e0f1100 R15: ffff88802c11a000
> > FS:  00007f01fdd51700(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007f01fdd30718 CR3: 000000002a3f9000 CR4: 0000000000350ef0
> > ----------------
> > Code disassembly (best guess), 6 bytes skipped:
> >    0:   df 48 89                fisttps -0x77(%rax)
> >    3:   c2 48 89                retq   $0x8948
> >    6:   44 24 28                rex.R and $0x28,%al
> >    9:   48 c1 ea 03             shr    $0x3,%rdx
> >    d:   48 8d 04 1a             lea    (%rdx,%rbx,1),%rax
> >   11:   48 89 44 24 10          mov    %rax,0x10(%rsp)
> >   16:   eb 29                   jmp    0x41
> >   18:   e8 ee 27 a3 f7          callq  0xf7a3280b
> >   1d:   48 89 e8                mov    %rbp,%rax
> >   20:   48 c1 e8 03             shr    $0x3,%rax
> > * 24:   80 3c 18 00             cmpb   $0x0,(%rax,%rbx,1) <-- trapping instruction
> >   28:   0f 85 a6 02 00 00       jne    0x2d4
> >   2e:   49 39 ec                cmp    %rbp,%r12
> >   31:   48 8b 55 00             mov    0x0(%rbp),%rdx
> >   35:   49 89 ef                mov    %rbp,%r15
> >   38:   0f                      .byte 0xf
> >   39:   84                      .byte 0x84
> >
> >
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > syzbot can test patches for this issue, for details see:
> > https://goo.gl/tpsmEJ#testing-patches
> >

