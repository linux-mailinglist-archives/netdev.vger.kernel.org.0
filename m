Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D71868B88E
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 10:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbjBFJXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 04:23:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbjBFJXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 04:23:43 -0500
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A87F5DBCF
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 01:23:41 -0800 (PST)
Received: by mail-il1-f200.google.com with SMTP id s12-20020a056e021a0c00b0030efd0ed890so7577552ild.7
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 01:23:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dGITBZxgoauLGx4MPTAVJHBqYi+srkjpnuWRVkWIaKk=;
        b=df7WkyTcSIJxN98S6XCgh1yor4pUKpm5FL1ZSusl8dWodXoSM+N2hOahwyFk1JhEnR
         +uU++Z8myUoZYltDjO5VX3duNQcSJaB3po37uVMfCJR/csNf04TdLE5ps8/aQCusLN2x
         qAZFEFaneV/sY+pBbRrCVb7eXH1+90Uf1ByiRV9mrmi4b60kb7CplIPKNd/IopAu/7yz
         IEQFjV1Kv8nvvRfMpBG0Iekr3cCk96RPwDpMkNycUJrT82p+67oSGwdWuGThXdjIuzik
         aRE8jSZnTGtxedyFVNq1CaCTSKmwcpQPMHAcCZaDMMNaG6l589o8B0LHAOZgljB6T2Y1
         vcfg==
X-Gm-Message-State: AO0yUKV/DCSID+YJS/y6R9h+NdltMlHxMQoa/xOSVM8R7e5D54FcFp0e
        Q2cK3TxO2i3JxeB3HjNw/c2T1iJ4RbZbyVfK0uYFh6oNpfGh
X-Google-Smtp-Source: AK7set/BM6NEgMLhcIsrQN4uFlJgd6pF6Xtqu+E+0ocSq+oVHq8ZJRjLTTjBHZfH/i01AI59Z+1MloDysqdnuBZkasw352xBLnum
MIME-Version: 1.0
X-Received: by 2002:a92:c7d3:0:b0:313:d260:41ce with SMTP id
 g19-20020a92c7d3000000b00313d26041cemr126203ilk.123.1675675421011; Mon, 06
 Feb 2023 01:23:41 -0800 (PST)
Date:   Mon, 06 Feb 2023 01:23:40 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003a78a905f4049614@google.com>
Subject: [syzbot] kernel BUG in process_one_work
From:   syzbot <syzbot+c0998868487c1f7e05e5@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        bpf@vger.kernel.org, davem@davemloft.net, dhowells@redhat.com,
        edumazet@google.com, hch@lst.de, jhubbard@nvidia.com,
        kuba@kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, npiggin@gmail.com, pabeni@redhat.com,
        peterz@infradead.org, syzkaller-bugs@googlegroups.com,
        will@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    4fafd96910ad Add linux-next specific files for 20230203
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17e5d623480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1d2fba7d42502ca4
dashboard link: https://syzkaller.appspot.com/bug?extid=c0998868487c1f7e05e5
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=148901bb480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14911ba5480000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/348cc2da441a/disk-4fafd969.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e2dedc500f12/vmlinux-4fafd969.xz
kernel image: https://storage.googleapis.com/syzbot-assets/fae710d9ebd8/bzImage-4fafd969.xz

The issue was bisected to:

commit 920756a3306a35f1c08f25207d375885bef98975
Author: David Howells <dhowells@redhat.com>
Date:   Sat Jan 21 12:51:18 2023 +0000

    block: Convert bio_iov_iter_get_pages to use iov_iter_extract_pages

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13d93dd9480000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10393dd9480000
console output: https://syzkaller.appspot.com/x/log.txt?x=17d93dd9480000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c0998868487c1f7e05e5@syzkaller.appspotmail.com
Fixes: 920756a3306a ("block: Convert bio_iov_iter_get_pages to use iov_iter_extract_pages")

skbuff: skb_over_panic: text:ffffffff8615b76f len:20 put:20 head:0000000000000000 data:0000000000000000 tail:0x14 end:0x0 dev:<NULL>
------------[ cut here ]------------
kernel BUG at net/core/skbuff.c:122!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 26 Comm: kworker/1:1 Not tainted 6.2.0-rc6-next-20230203-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/12/2023
Workqueue: events nsim_dev_trap_report_work
RIP: 0010:skb_panic+0x152/0x1d0 net/core/skbuff.c:122
Code: 0f b6 04 01 84 c0 74 04 3c 03 7e 20 8b 4b 70 41 56 45 89 e8 48 c7 c7 40 11 5c 8b 41 57 56 48 89 ee 52 4c 89 e2 e8 de 43 5e f9 <0f> 0b 4c 89 4c 24 10 48 89 54 24 08 48 89 34 24 e8 a9 66 c9 f9 4c
RSP: 0018:ffffc90000a1fbc0 EFLAGS: 00010286
RAX: 0000000000000084 RBX: ffff88802b3e6500 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff8168dfbc RDI: 0000000000000005
RBP: ffffffff8b5c1f80 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000080000001 R11: 0000000000000000 R12: ffffffff8615b76f
R13: 0000000000000014 R14: ffffffff8b5c1100 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fdf942b0150 CR3: 000000007a8e3000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 skb_over_panic net/core/skbuff.c:127 [inline]
 skb_put+0x16f/0x1a0 net/core/skbuff.c:2261
 nsim_dev_trap_skb_build drivers/net/netdevsim/dev.c:764 [inline]
 nsim_dev_trap_report drivers/net/netdevsim/dev.c:808 [inline]
 nsim_dev_trap_report_work+0x4df/0xc80 drivers/net/netdevsim/dev.c:853
 process_one_work+0x9bf/0x1820 kernel/workqueue.c:2390
 worker_thread+0x669/0x1090 kernel/workqueue.c:2537
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:skb_panic+0x152/0x1d0 net/core/skbuff.c:122
Code: 0f b6 04 01 84 c0 74 04 3c 03 7e 20 8b 4b 70 41 56 45 89 e8 48 c7 c7 40 11 5c 8b 41 57 56 48 89 ee 52 4c 89 e2 e8 de 43 5e f9 <0f> 0b 4c 89 4c 24 10 48 89 54 24 08 48 89 34 24 e8 a9 66 c9 f9 4c
RSP: 0018:ffffc90000a1fbc0 EFLAGS: 00010286
RAX: 0000000000000084 RBX: ffff88802b3e6500 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff8168dfbc RDI: 0000000000000005
RBP: ffffffff8b5c1f80 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000080000001 R11: 0000000000000000 R12: ffffffff8615b76f
R13: 0000000000000014 R14: ffffffff8b5c1100 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fdf942b0150 CR3: 000000007a8e3000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
