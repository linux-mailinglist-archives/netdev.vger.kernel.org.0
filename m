Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D73CD2C44A1
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 17:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730439AbgKYQEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 11:04:06 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.165]:25784 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbgKYQEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 11:04:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1606320241;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=LjnFeCgpj60B5cvTEJDsWgPSYIro4/2CufStGHdmH4k=;
        b=rUUv9s9Uw7YrdTEkBzgj2+wJHiV4w7IhVfbKFdUH2Gfpc99ZtmIlaiPkZdXAIvCBvl
        7yDfeOhYIONtmH2whanjClU8+HLiOHdi276uNAahHsAg1UyXeKtivVyk8teNFVAAGRd4
        J7q/8JjZxBiBECl2SKKSeyKp80JCbzkOO/btDPMJ7YTMEM7WOF1cR4Du006Ak5kkplk6
        xmPtGUP0t6g7phtCev4mjRVP2K3KdO1SgDu3DpUg5rbuUtm3OmjRhYIIOgwwXz3saVrI
        LtEnSdV3fXm10ph3yQYDpiMJGx7ic74I9mG/KYmDIUz/FeZTOXZNLVCJyAKWXOjVNF5B
        gLAw==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3TMaFqTEVR+J8xrzF0="
X-RZG-CLASS-ID: mo00
Received: from [192.168.10.137]
        by smtp.strato.de (RZmta 47.3.4 SBL|AUTH)
        with ESMTPSA id n07f3bwAPG3mq4W
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Wed, 25 Nov 2020 17:03:48 +0100 (CET)
Subject: Re: BUG: receive list entry not found for dev vxcan1, id 002, mask
 C00007FF
To:     syzbot <syzbot+381d06e0c8eaacb8706f@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, mkl@pengutronix.de,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000041019205b4c4e9ad@google.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <b134c098-2f34-15ee-cfec-2103a12da326@hartkopp.net>
Date:   Wed, 25 Nov 2020 17:03:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <00000000000041019205b4c4e9ad@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello all,

AFAICS the problems are caused by the WARN() statement here:

https://elixir.bootlin.com/linux/v5.10-rc4/source/net/can/af_can.c#L546

The idea was to check whether CAN protocol implementations work 
correctly on their filter lists.

With the fault injection it seem like we're getting a race between 
closing the socket and removing the netdevice.

This seems to be very seldom but it does not break anything.

Would removing the WARN(1) or replacing it with pr_warn() be ok to close 
this issue?

Best regards,
Oliver

On 23.11.20 12:58, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    c2e7554e Merge tag 'gfs2-v5.10-rc4-fixes' of git://git.ker..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=117f03ba500000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=75292221eb79ace2
> dashboard link: https://syzkaller.appspot.com/bug?extid=381d06e0c8eaacb8706f
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+381d06e0c8eaacb8706f@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> BUG: receive list entry not found for dev vxcan1, id 002, mask C00007FF
> WARNING: CPU: 1 PID: 12946 at net/can/af_can.c:546 can_rx_unregister+0x5a4/0x700 net/can/af_can.c:546
> Modules linked in:
> CPU: 1 PID: 12946 Comm: syz-executor.1 Not tainted 5.10.0-rc4-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:can_rx_unregister+0x5a4/0x700 net/can/af_can.c:546
> Code: 8b 7c 24 78 44 8b 64 24 68 49 c7 c5 20 ac 56 8a e8 01 6c 97 f9 44 89 f9 44 89 e2 4c 89 ee 48 c7 c7 60 ac 56 8a e8 66 af d3 00 <0f> 0b 48 8b 7c 24 28 e8 b0 25 0f 01 e9 54 fb ff ff e8 26 e0 d8 f9
> RSP: 0018:ffffc90017e2fb38 EFLAGS: 00010286
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffff8880147a8000 RSI: ffffffff8158f3c5 RDI: fffff52002fc5f59
> RBP: 0000000000000118 R08: 0000000000000001 R09: ffff8880b9f2011b
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
> R13: ffff8880254c0000 R14: 1ffff92002fc5f6e R15: 00000000c00007ff
> FS:  0000000001ddc940(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b2f121000 CR3: 00000000152c0000 CR4: 00000000001506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   isotp_notifier+0x2a7/0x540 net/can/isotp.c:1303
>   call_netdevice_notifier net/core/dev.c:1735 [inline]
>   call_netdevice_unregister_notifiers+0x156/0x1c0 net/core/dev.c:1763
>   call_netdevice_unregister_net_notifiers net/core/dev.c:1791 [inline]
>   unregister_netdevice_notifier+0xcd/0x170 net/core/dev.c:1870
>   isotp_release+0x136/0x600 net/can/isotp.c:1011
>   __sock_release+0xcd/0x280 net/socket.c:596
>   sock_close+0x18/0x20 net/socket.c:1277
>   __fput+0x285/0x920 fs/file_table.c:281
>   task_work_run+0xdd/0x190 kernel/task_work.c:151
>   tracehook_notify_resume include/linux/tracehook.h:188 [inline]
>   exit_to_user_mode_loop kernel/entry/common.c:164 [inline]
>   exit_to_user_mode_prepare+0x17e/0x1a0 kernel/entry/common.c:191
>   syscall_exit_to_user_mode+0x38/0x260 kernel/entry/common.c:266
>   entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x417811
> Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 a4 1a 00 00 c3 48 83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
> RSP: 002b:000000000169fbf0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
> RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000417811
> RDX: 0000000000000000 RSI: 00000000000013b7 RDI: 0000000000000003
> RBP: 0000000000000001 R08: 00000000acabb3b7 R09: 00000000acabb3bb
> R10: 000000000169fcd0 R11: 0000000000000293 R12: 000000000118c9a0
> R13: 000000000118c9a0 R14: 00000000000003e8 R15: 000000000118bf2c
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
