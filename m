Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 972FD24AF19
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 08:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbgHTGOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 02:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgHTGOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 02:14:01 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B9AC061383
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 23:14:00 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id dd12so488856qvb.0
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 23:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jfZ8AEDo5b6yM2W8sFrMWFRKou8veGh90s+SGjERmgE=;
        b=Pg0Vt16UN94wMHwX8Jg15yh0TnJwz1aiilNhssiuaeTm0HKGqIGsaYga/FvxwXWYV+
         8QhbzNpU5JawQJp6GPpBksX3QCgXdnfiSu3RsPgTPeK+OIyedumsfAZ7n8J10ZbcVITz
         0fCka7CdNIGbKT9ccOCr/QyhLNH2no0Z2WGRgq6KD4H12y+8/k7gXzacrN+S//8eGX6I
         fBcsrhgtA9b7/lfo1XwLXfS4e2kIsVtIZfm54JTL7pHTmakJAWHvclNGelzXqd03orKN
         Xnx/Qpru1ozi49919sz5XYbSRT2VeTiHQuW+CB86FFkt95k0c3Ha145MbV8DpLHNgkIu
         86DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jfZ8AEDo5b6yM2W8sFrMWFRKou8veGh90s+SGjERmgE=;
        b=M1Yo/ihZz7cYPnGFflchQ1P8psKzcufbyLaxMnApmyyp7nCOEVZwBOnE53eofrZ5fj
         yceRiPxDg4bMPTAy/m8UEznzMsESd6VRmIBz8i8NBtMBPSwlfIRUkxI79cIUVrkBjnlm
         C0pj9e1TBj/slIquxmziYuAYJwOo6zaLVbACClkI3oTw0yPWVw+ru2CXb+SUi52L1uUQ
         LqfpvY/Gm9/16x9MWCdKWTHLATYb1LeMqxQodIhadabUdjCaUs5WPRrQEYHgV7WFsc1w
         tuVTk0ddZQYljzQoP4RmoNFGgVgffGUgF7buCJUGMDNqYh3zq8ulenNFoeo38A9m9QZi
         AeHQ==
X-Gm-Message-State: AOAM532yoNXSc7mP3Z3DpwIiG0EsJE14izNwUkXpl20FmFmn5z10hscR
        FJSasBcb9Q/Sqa+T3XuY+vnSIacWKCN7uIVoNo8CBw==
X-Google-Smtp-Source: ABdhPJyQv4MwYbNOvB6guMd+CnDeGOCpwWpHMxEZy35VcLiAqzoitjW5LQgbN7vgNzxeLiQLr2WNkPgz37YJ+e+H17g=
X-Received: by 2002:a0c:8d4a:: with SMTP id s10mr1745746qvb.34.1597904039193;
 Wed, 19 Aug 2020 23:13:59 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000c57f2d05ac4c5b8e@google.com> <20200820060713.smilfw3otuunnepe@Rk>
In-Reply-To: <20200820060713.smilfw3otuunnepe@Rk>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 20 Aug 2020 08:13:47 +0200
Message-ID: <CACT4Y+ZcU11Y0OrxsdKcwqAmJ2BmnP9pCYB1gtiBgciM0+H=cA@mail.gmail.com>
Subject: Re: BUG: corrupted list in kobject_add_internal
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     syzbot <syzbot+dd768a260f7358adbaf9@syzkaller.appspotmail.com>,
        abhishekpandit@chromium.org, David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        netdev <netdev@vger.kernel.org>,
        Rafael Wysocki <rafael@kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        linux-kernel-mentees@lists.linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 8:07 AM Coiby Xu <coiby.xu@gmail.com> wrote:
>
> On Fri, Aug 07, 2020 at 09:47:20AM -0700, syzbot wrote:
> >Hello,
> >
> >syzbot found the following issue on:
> >
> >HEAD commit:    5a30a789 Merge tag 'x86-urgent-2020-08-02' of git://git.ke..
> >git tree:       upstream
> >console output: https://syzkaller.appspot.com/x/log.txt?x=1660c858900000
> >kernel config:  https://syzkaller.appspot.com/x/.config?x=c0cfcf935bcc94d2
> >dashboard link: https://syzkaller.appspot.com/bug?extid=dd768a260f7358adbaf9
> >compiler:       gcc (GCC) 10.1.0-syz 20200507
> >syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14b73afc900000
> >C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=124893a4900000
> >
> >The issue was bisected to:
> >
> >commit 4f40afc6c76451daff7d0dcfc8a3d113ccf65bfc
> >Author: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> >Date:   Wed Mar 11 15:54:01 2020 +0000
> >
> >    Bluetooth: Handle BR/EDR devices during suspend
> >
> >bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11cb1e0a900000
> >final oops:     https://syzkaller.appspot.com/x/report.txt?x=13cb1e0a900000
> >console output: https://syzkaller.appspot.com/x/log.txt?x=15cb1e0a900000
> >
> >IMPORTANT: if you fix the issue, please add the following tag to the commit:
> >Reported-by: syzbot+dd768a260f7358adbaf9@syzkaller.appspotmail.com
> >Fixes: 4f40afc6c764 ("Bluetooth: Handle BR/EDR devices during suspend")
> >
> >debugfs: Directory '200' with parent 'hci0' already present!
> >list_add double add: new=ffff88808e9b6418, prev=ffff88808e9b6418, next=ffff8880a973ef00.
> >------------[ cut here ]------------
> >kernel BUG at lib/list_debug.c:29!
> >invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> >CPU: 1 PID: 6882 Comm: kworker/u5:1 Not tainted 5.8.0-rc7-syzkaller #0
> >Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> >Workqueue: hci0 hci_rx_work
> >RIP: 0010:__list_add_valid.cold+0x26/0x3c lib/list_debug.c:29
> >Code: 57 ff ff ff 4c 89 e1 48 c7 c7 20 92 93 88 e8 b1 f1 c1 fd 0f 0b 48 89 f2 4c 89 e1 48 89 ee 48 c7 c7 60 93 93 88 e8 9a f1 c1 fd <0f> 0b 48 89 f1 48 c7 c7 e0 92 93 88 4c 89 e6 e8 86 f1 c1 fd 0f 0b
> >RSP: 0018:ffffc90001777830 EFLAGS: 00010282
> >RAX: 0000000000000058 RBX: ffff8880a973ef00 RCX: 0000000000000000
> >RDX: ffff888094f1c200 RSI: ffffffff815d4ef7 RDI: fffff520002eeef8
> >RBP: ffff88808e9b6418 R08: 0000000000000058 R09: ffff8880ae7318e7
> >R10: 0000000000000000 R11: 0000000000000000 R12: ffff8880a973ef00
> >R13: ffff888087315270 R14: ffff88808e9b6430 R15: ffff88808e9b6418
> >FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
> >CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >CR2: 00007ffdcd6db747 CR3: 000000009ba09000 CR4: 00000000001406e0
> >DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >Call Trace:
> > __list_add include/linux/list.h:67 [inline]
> > list_add_tail include/linux/list.h:100 [inline]
> > kobj_kset_join lib/kobject.c:196 [inline]
> > kobject_add_internal+0x18d/0x940 lib/kobject.c:246
> > kobject_add_varg lib/kobject.c:390 [inline]
> > kobject_add+0x150/0x1c0 lib/kobject.c:442
> > device_add+0x35a/0x1be0 drivers/base/core.c:2633
> > hci_conn_add_sysfs+0x84/0xe0 net/bluetooth/hci_sysfs.c:53
> > hci_conn_complete_evt net/bluetooth/hci_event.c:2607 [inline]
> > hci_event_packet+0xe0b/0x86f5 net/bluetooth/hci_event.c:6033
> > hci_rx_work+0x22e/0xb10 net/bluetooth/hci_core.c:4705
> > process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
> > worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
> > kthread+0x3b5/0x4a0 kernel/kthread.c:291
> > ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293
> >Modules linked in:
> >---[ end trace b1bcc552c32d25e9 ]---
> >RIP: 0010:__list_add_valid.cold+0x26/0x3c lib/list_debug.c:29
> >Code: 57 ff ff ff 4c 89 e1 48 c7 c7 20 92 93 88 e8 b1 f1 c1 fd 0f 0b 48 89 f2 4c 89 e1 48 89 ee 48 c7 c7 60 93 93 88 e8 9a f1 c1 fd <0f> 0b 48 89 f1 48 c7 c7 e0 92 93 88 4c 89 e6 e8 86 f1 c1 fd 0f 0b
> >RSP: 0018:ffffc90001777830 EFLAGS: 00010282
> >RAX: 0000000000000058 RBX: ffff8880a973ef00 RCX: 0000000000000000
> >RDX: ffff888094f1c200 RSI: ffffffff815d4ef7 RDI: fffff520002eeef8
> >RBP: ffff88808e9b6418 R08: 0000000000000058 R09: ffff8880ae7318e7
> >R10: 0000000000000000 R11: 0000000000000000 R12: ffff8880a973ef00
> >R13: ffff888087315270 R14: ffff88808e9b6430 R15: ffff88808e9b6418
> >FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
> >CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >CR2: 00007ffdcd6db747 CR3: 0000000009a79000 CR4: 00000000001406e0
> >DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >
> >
> >---
> >This report is generated by a bot. It may contain errors.
> >See https://goo.gl/tpsmEJ for more information about syzbot.
> >syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> >syzbot will keep track of this issue. See:
> >https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> >For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> >syzbot can test patches for this issue, for details see:
> >https://goo.gl/tpsmEJ#testing-patches
> >
> >--
> >You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> >To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> >To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000c57f2d05ac4c5b8e%40google.com.
>
> This problem occurs because the HCI_EV_CONN_COMPLETE event packet is sent
> twice for the same HCI connection,
>
>      struct hci_ev_conn_complete complete;
>      memset(&complete, 0, sizeof(complete));
>      complete.status = 0;
>      complete.handle = HCI_HANDLE_1;
>      memset(&complete.bdaddr, 0xaa, 6);
>      *(uint8_t*)&complete.bdaddr.b[5] = 0x10;
>      complete.link_type = ACL_LINK;
>      complete.encr_mode = 0;
>      hci_send_event_packet(vhci_fd, HCI_EV_CONN_COMPLETE, &complete,
>                              sizeof(complete));
>
> which leads to kobject_add being called twice. Thus duplicate
> (struct hci_conn *conn)->dev.kobj.entry is inserted into
> (struct hci_conn *conn)->dev.kobj.kset->list.
>
> But if it's the HCI connection creator's responsibility to
> not send the HCI_EV_CONN_COMPLETE event packet twice, then it's not a
> valid bug. Or should we make the kernel more robust by defending against
> this case?

Hi Coiby,

Whoever is sending HCI_EV_CONN_COMPLETE, this should not corrupt
kernel memory. Even if it's firmware, it's not necessary trusted, see:
https://www.blackhat.com/us-20/briefings/schedule/index.html#finding-new-bluetooth-low-energy-exploits-via-reverse-engineering-multiple-vendors-firmwares-19655
and:
https://www.armis.com/bleedingbit/
So if an attacker takes over firmware, they can then corrupt kernel memory.
