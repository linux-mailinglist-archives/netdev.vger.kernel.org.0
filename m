Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A74BC6EC7EB
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 10:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbjDXIbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 04:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjDXIbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 04:31:09 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26A0B0
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 01:31:06 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id 2adb3069b0e04-4efea87c578so2305e87.1
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 01:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682325065; x=1684917065;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=R+OahxMAVmQfev2ZxChkwLH4e1xTOOhd3vvP7QZ00NE=;
        b=Kf1sD+GUH5ccLoKZlEtdVT0Gp45kr1DeAC2QMBBz/SlJAdlgFOP1Fk/Mvz22XfhHrz
         yJnkuykq7h/iBuPX0i9HWh2O5uTRZCqs15LYuk7V0FgWGgeBDTAIEmE5YzyK8fPCBZig
         Z3rsss9yloAPmWnSGh+E91XRnJDZuCdOIc6De6+x8MRng3BdMPhGJv6jyb7GmgCCiEu+
         gFIHxzrbdYHSCO7a/3ivPnbQb0sScMkpG8xrsqf9jQpkVhZDHKk2zadzcjay+ES9x9Xp
         WeJNDQosuZkBi85N1Pmz2K1a9ByUz0XnaaoKfgyp2y8IANnjyTInH+bQnrbYl5I2pEkP
         i6EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682325065; x=1684917065;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R+OahxMAVmQfev2ZxChkwLH4e1xTOOhd3vvP7QZ00NE=;
        b=TR9qXFpBL98rM45306DEFoZGGUk7YYfWaneSQ+qknnDZmrJV1ddwpcPgh3YriwT+Cu
         MjgOTxWpENf2LZtjtpM+qi3SPeYeZngqXekOTBw94DiqbBNaiInOq3kcGLoRdC84v9eP
         VxNUikauGaj2rQnRN8LRosEnF/jvxk6707PdHTB3d5c65+hgqQcdn+vRrUJ7z0hV/z3m
         4NMgl1IBb2k4MSgm3VqI15tLkJKovG7I2vHSf3MoRqJZ9zrp1w9P4dB9+U+Ssnb/JSbK
         B37WHXLSwmLjc3h7IJ5+m1kVW/Jw4rZ4vxBlilv3rhZsR/bLaxI94GhHNdfgQO9hZfTb
         p9xA==
X-Gm-Message-State: AAQBX9fx5fFzR77WWy2lEQbjQ5yHSN7UbERMAWgwcySf8rKUKylDqlLQ
        tdljpMVXpj3NVtL7xhxhQAaozsfBpZXnXUhsnEgoKw==
X-Google-Smtp-Source: AKy350Ztz0so1N7bmoRmue+lrejsdK+DfVnS8+93q89Js0Ka/JOL8zPDHbyLP6rvGoNcO/VkuGFFDgchYMO7h73f7Uc=
X-Received: by 2002:a05:6512:12ce:b0:4e8:3f1e:de43 with SMTP id
 p14-20020a05651212ce00b004e83f1ede43mr228809lfg.7.1682325064945; Mon, 24 Apr
 2023 01:31:04 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000e7c6d205fa10a3cd@google.com>
In-Reply-To: <000000000000e7c6d205fa10a3cd@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 24 Apr 2023 10:30:51 +0200
Message-ID: <CACT4Y+YajDb5QpSziTazoyn587JXwXet2w7Jkqkj9v31HZtJxw@mail.gmail.com>
Subject: Re: [syzbot] [afs?] [net?] KCSAN: data-race in rxrpc_send_data / rxrpc_set_call_completion
To:     syzbot <syzbot+ebc945fdb4acd72cba78@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, dhowells@redhat.com, edumazet@google.com,
        kuba@kernel.org, linux-afs@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        marc.dionne@auristor.com, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Apr 2023 at 10:17, syzbot
<syzbot+ebc945fdb4acd72cba78@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    148341f0a2f5 Merge tag 'vfs.misc.fixes.v6.3-rc6' of git://..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=14a62269c80000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=54d63ee086ae78d0
> dashboard link: https://syzkaller.appspot.com/bug?extid=ebc945fdb4acd72cba78
> compiler:       Debian clang version 15.0.7, GNU ld (GNU Binutils for Debian) 2.35.2
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/1c557f92a6e1/disk-148341f0.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/f2c85210e1ce/vmlinux-148341f0.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/b019d0447709/bzImage-148341f0.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+ebc945fdb4acd72cba78@syzkaller.appspotmail.com

If I am reading this correctly, rxrpc_send_data() can read wrong
call->completion and state and incorrectly exit with an error if
rxrpc_wait_to_be_connected() exists early right after observing error
set here:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/rxrpc/sendmsg.c?id=148341f0a2f53b5e8808d093333d85170586a15d#n58
The code seems to assume that at that point all writes done by
rxrpc_set_call_completion() are already finished, but it's not
necessarily the case.






> ==================================================================
> BUG: KCSAN: data-race in rxrpc_send_data / rxrpc_set_call_completion
>
> write to 0xffff888159cf3c50 of 4 bytes by task 25673 on cpu 1:
>  rxrpc_set_call_completion+0x71/0x1c0 net/rxrpc/call_state.c:22
>  rxrpc_send_data_packet+0xba9/0x1650 net/rxrpc/output.c:479
>  rxrpc_transmit_one+0x1e/0x130 net/rxrpc/output.c:714
>  rxrpc_decant_prepared_tx net/rxrpc/call_event.c:326 [inline]
>  rxrpc_transmit_some_data+0x496/0x600 net/rxrpc/call_event.c:350
>  rxrpc_input_call_event+0x564/0x1220 net/rxrpc/call_event.c:464
>  rxrpc_io_thread+0x307/0x1d80 net/rxrpc/io_thread.c:461
>  kthread+0x1ac/0x1e0 kernel/kthread.c:376
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
>
> read to 0xffff888159cf3c50 of 4 bytes by task 25672 on cpu 0:
>  rxrpc_send_data+0x29e/0x1950 net/rxrpc/sendmsg.c:296
>  rxrpc_do_sendmsg+0xb7a/0xc20 net/rxrpc/sendmsg.c:726
>  rxrpc_sendmsg+0x413/0x520 net/rxrpc/af_rxrpc.c:565
>  sock_sendmsg_nosec net/socket.c:724 [inline]
>  sock_sendmsg net/socket.c:747 [inline]
>  ____sys_sendmsg+0x375/0x4c0 net/socket.c:2501
>  ___sys_sendmsg net/socket.c:2555 [inline]
>  __sys_sendmmsg+0x263/0x500 net/socket.c:2641
>  __do_sys_sendmmsg net/socket.c:2670 [inline]
>  __se_sys_sendmmsg net/socket.c:2667 [inline]
>  __x64_sys_sendmmsg+0x57/0x60 net/socket.c:2667
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> value changed: 0x00000000 -> 0xffffffea
>
> Reported by Kernel Concurrency Sanitizer on:
> CPU: 0 PID: 25672 Comm: syz-executor.5 Not tainted 6.3.0-rc5-syzkaller-00005-g148341f0a2f5 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023
> ==================================================================
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
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000e7c6d205fa10a3cd%40google.com.
