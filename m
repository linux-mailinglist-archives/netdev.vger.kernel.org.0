Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4F334D453
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 17:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbhC2Px6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 11:53:58 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:48692 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbhC2Px0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 11:53:26 -0400
Received: by mail-io1-f71.google.com with SMTP id g12so707866ion.15
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 08:53:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=xexZrPOC/JkSM7BGy7xMMywLm9VNuEHIelH+LRXXkPk=;
        b=rPAgCx7tX4qy4tbS1VyDsfeXs5PyNYHDCdPbjwInbrIsEkc0sbCF+XrtLWTmr/nlAN
         9KqdXBMkBYeRLqyaFU7+4nHpXWFqF5LxO4rJ9Q640s8sYu4QdLRNQ/RSFILV+OoSoyaQ
         t1MukS+AuZnrpzVc5BhWn4EE8g69bQAxCYC0ZuEm+tEeq8MKZBTEV+cuMy8rhIfhaE4f
         TVAfU4WXRjbNvvg8wr0A34weN6LL7ZQuZ2hU9iXmE49cN89AyjujckotWI77v63P082o
         yiIz49Nh2P6BYXDLGmiQs2ngbGz12wm4hgQZAiqOdAvgyD9Qd/6nuYU24OyZuQTO3++5
         DA+Q==
X-Gm-Message-State: AOAM5338bwQOlAwJmWeqfG8k1cvW4O0+N+1uwb1+uPPa235SVKzVRrN1
        3iUzW+wecs26dJY/Pv1urfooVLv2dquGZ51/9lF0E32OHPfV
X-Google-Smtp-Source: ABdhPJzYbRh6VfoSvFixhIbacAK24HM3mTeepga8rAAZQyQiQ8uydiubagx8ofleAiQxtZwE3S+Ks1tmHz1uMhndnkGK1UWoZRLo
MIME-Version: 1.0
X-Received: by 2002:a02:7f8c:: with SMTP id r134mr24510700jac.95.1617033206064;
 Mon, 29 Mar 2021 08:53:26 -0700 (PDT)
Date:   Mon, 29 Mar 2021 08:53:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d6689d05beaee1c9@google.com>
Subject: [syzbot] WARNING: refcount bug in nfc_llcp_local_put
From:   syzbot <syzbot+0aabbccfb4ec7b744ffd@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, bp@alien8.de, davem@davemloft.net,
        hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kuba@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, masahiroy@kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, pbonzini@redhat.com, peterz@infradead.org,
        rafael.j.wysocki@intel.com, rostedt@goodmis.org, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, will@kernel.org,
        x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    75887e88 Merge branch '40GbE' of git://git.kernel.org/pub/..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=131a634ed00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5adab0bdee099d7a
dashboard link: https://syzkaller.appspot.com/bug?extid=0aabbccfb4ec7b744ffd
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15bcd6f6d00000

The issue was bisected to:

commit 997acaf6b4b59c6a9c259740312a69ea549cc684
Author: Mark Rutland <mark.rutland@arm.com>
Date:   Mon Jan 11 15:37:07 2021 +0000

    lockdep: report broken irq restoration

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12279b4ed00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11279b4ed00000
console output: https://syzkaller.appspot.com/x/log.txt?x=16279b4ed00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0aabbccfb4ec7b744ffd@syzkaller.appspotmail.com
Fixes: 997acaf6b4b5 ("lockdep: report broken irq restoration")

------------[ cut here ]------------
refcount_t: underflow; use-after-free.
WARNING: CPU: 0 PID: 11133 at lib/refcount.c:28 refcount_warn_saturate+0x1d1/0x1e0 lib/refcount.c:28
Modules linked in:
CPU: 1 PID: 11133 Comm: syz-executor.0 Not tainted 5.12.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:refcount_warn_saturate+0x1d1/0x1e0 lib/refcount.c:28
Code: e9 db fe ff ff 48 89 df e8 fc ee ee fd e9 8a fe ff ff e8 42 44 ab fd 48 c7 c7 c0 d8 c1 89 c6 05 eb 44 e9 09 01 e8 7c 9b fc 04 <0f> 0b e9 af fe ff ff 0f 1f 84 00 00 00 00 00 41 56 41 55 41 54 55
RSP: 0018:ffffc900033f7b10 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff888040038000 RSI: ffffffff815c4d15 RDI: fffff5200067ef54
RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815bdaae R11: 0000000000000000 R12: 0000000000000000
R13: ffff88814429f018 R14: ffffffff8dab2ec0 R15: ffff888030b20d38
FS:  0000000001fa6400(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000540198 CR3: 00000000142c1000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __refcount_sub_and_test include/linux/refcount.h:283 [inline]
 __refcount_dec_and_test include/linux/refcount.h:315 [inline]
 refcount_dec_and_test include/linux/refcount.h:333 [inline]
 kref_put include/linux/kref.h:64 [inline]
 nfc_llcp_local_put net/nfc/llcp_core.c:183 [inline]
 nfc_llcp_local_put+0x1ab/0x200 net/nfc/llcp_core.c:178
 llcp_sock_destruct+0x81/0x150 net/nfc/llcp_sock.c:950
 __sk_destruct+0x4b/0x900 net/core/sock.c:1795
 sk_destruct+0xbd/0xe0 net/core/sock.c:1839
 __sk_free+0xef/0x3d0 net/core/sock.c:1850
 sock_wfree+0x129/0x240 net/core/sock.c:2074
 skb_release_head_state+0x9f/0x250 net/core/skbuff.c:712
 skb_release_all net/core/skbuff.c:723 [inline]
 __kfree_skb net/core/skbuff.c:739 [inline]
 kfree_skb net/core/skbuff.c:757 [inline]
 kfree_skb+0xfa/0x3f0 net/core/skbuff.c:751
 skb_queue_purge+0x14/0x30 net/core/skbuff.c:3133
 nfc_llcp_socket_release+0x2e/0x870 net/nfc/llcp_core.c:73
 local_cleanup+0x18/0xb0 net/nfc/llcp_core.c:155
 local_release net/nfc/llcp_core.c:174 [inline]
 kref_put include/linux/kref.h:65 [inline]
 nfc_llcp_local_put net/nfc/llcp_core.c:183 [inline]
 nfc_llcp_local_put+0x18c/0x200 net/nfc/llcp_core.c:178
 llcp_sock_destruct+0x81/0x150 net/nfc/llcp_sock.c:950
 __sk_destruct+0x4b/0x900 net/core/sock.c:1795
 sk_destruct+0xbd/0xe0 net/core/sock.c:1839
 __sk_free+0xef/0x3d0 net/core/sock.c:1850
 sk_free+0x78/0xa0 net/core/sock.c:1861


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
