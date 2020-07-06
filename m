Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A84F621529E
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 08:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728890AbgGFGU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 02:20:58 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:57834 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728880AbgGFGU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 02:20:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594016456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=92GZ3FW44LhK6ZPwgvJk40XZq6/hfhz1RbVOBgdDt9s=;
        b=Gz9H1zHRSYmx12KOxzF8jPynQnKvG0qDX5XfHgVV2IsqhsbncKuQbkGSklyixSh02UgfdN
        kgXSv9IkUiNHDd0A8LwSLozkliVmZjXeW9jFhr7B+rCrn9krV5ZfPMB93ZwX3UDyoXT7l6
        q72ubUJno3MLc+dA2+nlSJ72rjXXNZ8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-rgku8C6SNBGrib4AcC-GFw-1; Mon, 06 Jul 2020 02:20:46 -0400
X-MC-Unique: rgku8C6SNBGrib4AcC-GFw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F2616107ACCD;
        Mon,  6 Jul 2020 06:20:43 +0000 (UTC)
Received: from carbon (unknown [10.40.208.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F8972DE72;
        Mon,  6 Jul 2020 06:20:33 +0000 (UTC)
Date:   Mon, 6 Jul 2020 08:20:31 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     syzbot <syzbot+c3157bda041952444952@syzkaller.appspotmail.com>
Cc:     brouer@redhat.com, andriin@fb.com, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@chromium.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Subject: Re: WARNING in bpf_xdp_adjust_tail
Message-ID: <20200706082031.3e9f206e@carbon>
In-Reply-To: <0000000000001936ab05a9ac97d1@google.com>
References: <0000000000001936ab05a9ac97d1@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 05 Jul 2020 00:20:18 -0700
syzbot <syzbot+c3157bda041952444952@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following crash on:

It is WARN that trigger this, due to panic_on_warn set.

It's great to see that syzbot report these, as the WARN_ONCE is meant
to catch drivers that forget to init xdp->frame_sz.  In this case it is
XDP-generic that manage to get an oversized SKB run through this code
path.


> HEAD commit:    2ce578ca net: ipv4: Fix wrong type conversion from hint to..
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=1190cf23100000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=bf3aec367b9ab569
> dashboard link: https://syzkaller.appspot.com/bug?extid=c3157bda041952444952
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+c3157bda041952444952@syzkaller.appspotmail.com
> 

It would be practical to get the WARN message here (from console output):
 [  511.164212][T22595] Too BIG xdp->frame_sz = 131072

As call-stack indicate this is XDP-generic (do_xdp_generic).
Thus the xdp->frame_sz calc comes from:

	xdp->data_hard_start = skb->data - skb_headroom(skb);
	/* SKB "head" area always have tailroom for skb_shared_info */
	xdp->frame_sz  = (void *)skb_end_pointer(skb) - xdp->data_hard_start;
	xdp->frame_sz += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));

I'm surprised to see a 128KiB (128*1024) sized SKB here (in "head" area).
How can this happen?


> WARNING: CPU: 0 PID: 22595 at net/core/filter.c:3463 ____bpf_xdp_adjust_tail net/core/filter.c:3463 [inline]
> WARNING: CPU: 0 PID: 22595 at net/core/filter.c:3463 bpf_xdp_adjust_tail+0x18e/0x1e0 net/core/filter.c:3452
> Kernel panic - not syncing: panic_on_warn set ...
> CPU: 0 PID: 22595 Comm: syz-executor.4 Not tainted 5.8.0-rc2-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x18f/0x20d lib/dump_stack.c:118
>  panic+0x2e3/0x75c kernel/panic.c:231
>  __warn.cold+0x20/0x45 kernel/panic.c:600
>  report_bug+0x1bd/0x210 lib/bug.c:198
>  exc_invalid_op+0x24d/0x400 arch/x86/kernel/traps.c:235
>  asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:563
> RIP: 0010:____bpf_xdp_adjust_tail net/core/filter.c:3463 [inline]
> RIP: 0010:bpf_xdp_adjust_tail+0x18e/0x1e0 net/core/filter.c:3452
> Code: 37 fb 84 db 74 09 49 c7 c4 ea ff ff ff eb c7 e8 f8 f5 37 fb 44 89 e6 48 c7 c7 e0 fc fd 88 c6 05 dc f5 6d 04 01 e8 94 3b 09 fb <0f> 0b eb d8 e8 d9 48 77 fb e9 c5 fe ff ff e8 df 48 77 fb e9 92 fe
> RSP: 0018:ffffc900018878e0 EFLAGS: 00010286
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 0000000000040000 RSI: ffffffff815ce8d7 RDI: fffff52000310f0e
> RBP: 0000000000000000 R08: 0000000000000001 R09: ffff8880ae620fcb
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000020000
> R13: ffff88804c20feef R14: ffff88804c20feef R15: 0000000000000000
>  bpf_prog_4add87e5301a4105+0x20/0x818
>  bpf_prog_run_xdp include/linux/filter.h:734 [inline]
>  netif_receive_generic_xdp+0x70f/0x1760 net/core/dev.c:4647
>  do_xdp_generic net/core/dev.c:4735 [inline]
>  do_xdp_generic+0x96/0x1a0 net/core/dev.c:4728
>  tun_get_user+0x22d2/0x35b0 drivers/net/tun.c:1905
>  tun_chr_write_iter+0xba/0x151 drivers/net/tun.c:1999
>  call_write_iter include/linux/fs.h:1907 [inline]
>  new_sync_write+0x422/0x650 fs/read_write.c:484
>  __vfs_write+0xc9/0x100 fs/read_write.c:497
>  vfs_write+0x268/0x5d0 fs/read_write.c:559
>  ksys_write+0x12d/0x250 fs/read_write.c:612
>  do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:359
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x416661
> Code: Bad RIP value.
> RSP: 002b:00007f8bc3971c60 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 00000000005095a0 RCX: 0000000000416661
> RDX: 000000000000fdef RSI: 0000000020000080 RDI: 00000000000000f0
> RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
> R10: 00007f8bc39729d0 R11: 0000000000000293 R12: 00000000ffffffff
> R13: 0000000000000bfd R14: 00000000004ce559 R15: 00007f8bc39726d4
> Kernel Offset: disabled
> 
> 
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

