Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8F345FFE4
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 16:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346781AbhK0PhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 10:37:04 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:38648 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347347AbhK0PfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Nov 2021 10:35:04 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=cuibixuan@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0UyTp5Uj_1638027102;
Received: from VM20210331-25.tbsite.net(mailfrom:cuibixuan@linux.alibaba.com fp:SMTPD_---0UyTp5Uj_1638027102)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 27 Nov 2021 23:31:46 +0800
From:   Bixuan Cui <cuibixuan@linux.alibaba.com>
To:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     cuibixuan@linux.alibaba.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Subject: [PATCH -next] bpf: Add oversize check before call kvmalloc()
Date:   Sat, 27 Nov 2021 23:31:42 +0800
Message-Id: <1638027102-22686-1-git-send-email-cuibixuan@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 7661809d493b ("mm: don't allow oversized kvmalloc() calls") add
the oversize check. When the allocation is larger than what kvmalloc()
supports, the following warning triggered:

WARNING: CPU: 1 PID: 372 at mm/util.c:597 kvmalloc_node+0x111/0x120
mm/util.c:597
Modules linked in:
CPU: 1 PID: 372 Comm: syz-executor.4 Not tainted 5.15.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
Google 01/01/2011
RIP: 0010:kvmalloc_node+0x111/0x120 mm/util.c:597
Code: 01 00 00 00 4c 89 e7 e8 7d f7 0c 00 49 89 c5 e9 69 ff ff ff e8 60
20 d1 ff 41 89 ed 41 81 cd 00 20 01 00 eb 95 e8 4f 20 d1 ff <0f> 0b e9
4c ff ff ff 0f 1f 84 00 00 00 00 00 55 48 89 fd 53 e8 36
RSP: 0018:ffffc90002bf7c98 EFLAGS: 00010216
RAX: 00000000000000ec RBX: 1ffff9200057ef9f RCX: ffffc9000ac63000
RDX: 0000000000040000 RSI: ffffffff81a6a621 RDI: 0000000000000003
RBP: 0000000000102cc0 R08: 000000007fffffff R09: 00000000ffffffff
R10: ffffffff81a6a5de R11: 0000000000000000 R12: 00000000ffff9aaa
R13: 0000000000000000 R14: 00000000ffffffff R15: 0000000000000000
FS:  00007f05f2573700(0000) GS:ffff8880b9d00000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2f424000 CR3: 0000000027d2c000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 kvmalloc include/linux/slab.h:741 [inline]
 map_lookup_elem kernel/bpf/syscall.c:1090 [inline]
 __sys_bpf+0x3a5b/0x5f00 kernel/bpf/syscall.c:4603
 __do_sys_bpf kernel/bpf/syscall.c:4722 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:4720 [inline]
 __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:4720
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The type of 'value_size' is u32, its value may exceed INT_MAX.

Reported-by: syzbot+cecf5b7071a0dfb76530@syzkaller.appspotmail.com
Signed-off-by: Bixuan Cui <cuibixuan@linux.alibaba.com>
---
 kernel/bpf/syscall.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 1033ee8..f5bc380 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1094,6 +1094,10 @@ static int map_lookup_elem(union bpf_attr *attr)
 	}
 
 	value_size = bpf_map_value_size(map);
+	if (value_size > INT_MAX) {
+		err = -EINVAL;
+		goto err_put;
+	}
 
 	err = -ENOMEM;
 	value = kvmalloc(value_size, GFP_USER | __GFP_NOWARN);
-- 
1.8.3.1

