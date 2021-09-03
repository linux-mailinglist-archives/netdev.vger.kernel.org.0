Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F305F3FFB38
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 09:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348061AbhICHmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 03:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234815AbhICHmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 03:42:12 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E34CC061575;
        Fri,  3 Sep 2021 00:41:13 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id u6so3691443pfi.0;
        Fri, 03 Sep 2021 00:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=o5FprG6RzkGJc/C+n+tTnfjcp9TMywhTG5mvqkk94ns=;
        b=jP0XZ8KN+HJfkZoQ6yd7GQLenMc9wpXpBcFYcTg1At2K1dyijVYNGuaQ+DtMmCZL+6
         ip6O2Ft1N3fMX2Sr9XDVPQSSzgcAB/5DLIxVZclpDrPjFlYNPbcHlnqceFZhgpN2A30e
         zPfNbDahv6z+j8Ihn9WdJAzRc0i5mgcU9rsIOkeeXcG0taGQ81ubJHD+uiaJ7CRse7Ww
         pee9ojl2otlgFfduOx8z4V7ypLGNZlbMUPX2AzX+03YKP8hedQPoDWgDsMAsnFR2KZPD
         BjFClsZRjkX1Yulmr7Ub2cWA0mWURTEIeiZznDk400hXCedtEzEsqu8yJOIRHksAVVN4
         xwVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=o5FprG6RzkGJc/C+n+tTnfjcp9TMywhTG5mvqkk94ns=;
        b=rly82v2NrRomgA7JOTUlCqBGE8yYyy5h3+ZyvKT+WQFFW7NJSZCj7Jc7IF1MNbWK7u
         WKQ79ApIbDIpjr3mruuiLx8LW/wjmJRNnB75n8W2fn9cWr6eHozmcn8eSLqfN4VU6JN1
         iiYE7Ske6iyUS3ev0veQDFFCJ6rSN1RmHsRFxk3IJBk7qeohaR/tqNXckV+cm0rCSh4Y
         ygLtzMezPcvJ9xMMNUQP1OA+r7ZcfjJq+d8Yc11EJuhGoqOkZPHranYKcEPaLENNX8qO
         JVkAwMKmL/nJ/Z0hu7BUiEeiS1Vl/5AQsq6taP7nu2CInnhLG/54xxFWosJIbCkPtljp
         DdhQ==
X-Gm-Message-State: AOAM533B2cI5sfpnTcLGKcFsjDxEGkbrmaTJy0K+D0chRfix06Ur4V3k
        fkJQDUBNvUVQQbCQfS221W09wmZjwQIhf5AFcg==
X-Google-Smtp-Source: ABdhPJxcsPdX1DVIdW7/x0qLcobHn8z0XwLxQzPUkFgDsWKAsQQFHfJCfwUEOuHlRhZhLM3yTgc4lXwV0Vj6UHSaTns=
X-Received: by 2002:a62:7c0d:0:b0:3fe:60d2:bce2 with SMTP id
 x13-20020a627c0d000000b003fe60d2bce2mr2299342pfc.27.1630654872635; Fri, 03
 Sep 2021 00:41:12 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Sun <sunhao.th@gmail.com>
Date:   Fri, 3 Sep 2021 15:41:01 +0800
Message-ID: <CACkBjsY9f5=M=8qFwVBWzoJdspenxSxHCL-hdT4YmznAzNUZfw@mail.gmail.com>
Subject: WARNING in submit_bio_checks
To:     axboe@kernel.dk, linux-block@vger.kernel.org
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

When using Healer to fuzz the latest Linux kernel, the following crash
was triggered.

HEAD commit: 7d2a07b76933 Linux 5.14
git tree: upstream
console output:
https://drive.google.com/file/d/1g67CqWvvbFRJyFBoHJk59BMQH3UcvNQx/view?usp=sharing
kernel config: https://drive.google.com/file/d/1XD9WYDViQLSXN7RGwH8AGGDvP9JvOghx/view?usp=sharing
C reproducer: https://drive.google.com/file/d/1Mox767TITuZDWxGR8B2RdBH4tAU4bYfq/view?usp=sharing
Syzlang reproducer:
https://drive.google.com/file/d/1pzANwS2DrA6owxrHieLNyKWmUgKOtwVl/view?usp=sharing

If you fix this issue, please add the following tag to the commit:
Reported-by: Hao Sun <sunhao.th@gmail.com>

------------[ cut here ]------------
Trying to write to read-only block-device nullb0 (partno 0)
WARNING: CPU: 1 PID: 11327 at block/blk-core.c:700 bio_check_ro
block/blk-core.c:700 [inline]
WARNING: CPU: 1 PID: 11327 at block/blk-core.c:700
submit_bio_checks+0x1605/0x1a70 block/blk-core.c:813
Modules linked in:
CPU: 1 PID: 11327 Comm: syz-executor Not tainted 5.14.0 #25
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:bio_check_ro block/blk-core.c:700 [inline]
RIP: 0010:submit_bio_checks+0x1605/0x1a70 block/blk-core.c:813
Code: 00 00 45 0f b6 a4 24 90 05 00 00 48 8d 74 24 60 48 89 ef e8 8d
54 fe ff 48 c7 c7 e0 b7 de 89 48 89 c6 44 89 e2 e8 ac 9e 1a 05 <0f> 0b
e9 91 f3 ff ff e8 8f fc b1 fd e8 9a d5 5b 05 31 ff 89 c3 89
RSP: 0018:ffffc90004007198 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff888100ec6430 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff88810338d640 RDI: fffff52000800e25
RBP: ffff8881140748c0 R08: ffffffff815d0995 R09: 0000000000000000
R10: 0000000000000005 R11: ffffed10233e3f53 R12: 0000000000000000
R13: ffff8881140748d0 R14: ffff8881083c21c0 R15: ffff888100ec69a4
FS:  0000000000000000(0000) GS:ffff888119f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000556c5662e990 CR3: 000000000b68e001 CR4: 0000000000770ee0
PKRU: 55555554
Call Trace:
 submit_bio_noacct+0x96/0x1460 block/blk-core.c:1028
 submit_bio+0x10a/0x460 block/blk-core.c:1105
 submit_bh_wbc+0x5eb/0x7f0 fs/buffer.c:3050
 __block_write_full_page+0x853/0x13a0 fs/buffer.c:1805
 block_write_full_page+0x4f3/0x610 fs/buffer.c:2976
 __writepage+0x60/0x180 mm/page-writeback.c:2314
 write_cache_pages+0x78e/0x1280 mm/page-writeback.c:2249
 generic_writepages mm/page-writeback.c:2340 [inline]
 generic_writepages+0xed/0x160 mm/page-writeback.c:2329
 do_writepages+0xfa/0x2a0 mm/page-writeback.c:2355
 __filemap_fdatawrite_range+0x2aa/0x390 mm/filemap.c:413
 filemap_write_and_wait_range mm/filemap.c:686 [inline]
 filemap_write_and_wait_range+0x65/0x100 mm/filemap.c:680
 filemap_write_and_wait include/linux/fs.h:2897 [inline]
 __sync_blockdev+0x84/0xe0 fs/block_dev.c:526
 sync_blockdev fs/block_dev.c:535 [inline]
 blkdev_put+0x53f/0x720 fs/block_dev.c:1532
 blkdev_close+0x8c/0xb0 fs/block_dev.c:1586
 __fput+0x288/0x920 fs/file_table.c:280
 task_work_run+0xe0/0x1a0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:32 [inline]
 do_exit+0xbe4/0x2e00 kernel/exit.c:825
 do_group_exit+0x125/0x340 kernel/exit.c:922
 get_signal+0x4d5/0x25a0 kernel/signal.c:2808
 arch_do_signal_or_restart+0x2ed/0x1c40 arch/x86/kernel/signal.c:865
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x192/0x2a0 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:302
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4739cd
Code: Unable to access opcode bytes at RIP 0x4739a3.
RSP: 002b:00007f9d66b2a218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: 0000000000000000 RBX: 000000000059c0a0 RCX: 00000000004739cd
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000059c0a8
RBP: 000000000059c0a8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000059c0ac
R13: 00007ffdcc4a841f R14: 00007ffdcc4a85c0 R15: 00007f9d66b2a300
