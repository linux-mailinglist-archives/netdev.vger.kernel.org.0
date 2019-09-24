Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8437BD2A6
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 21:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410043AbfIXT3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 15:29:40 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:53454 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409758AbfIXT3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 15:29:39 -0400
Received: by mail-pl1-f202.google.com with SMTP id g13so390792plq.20
        for <netdev@vger.kernel.org>; Tue, 24 Sep 2019 12:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=9lyd/OGRWu2T77jL2o1qpzkNA2DEbU24ACMy4vbRMkM=;
        b=qAtKieAyjiy0/ITUORlc7X5E3vX3I6LprV/ie2BaDLS8An9mA9Z97mpxj/1CUWDG/e
         yKnB1WmzsZYWSxI3r/sdcSodFbApZezCXkl052K8JYWDhz4kk6aGcD7gdbDfUPUHmZDl
         4r1R4PAQwuTVuuK+2NJ/WXtGAIlbZeYlWbK4Y4UTx9rgzhu6U9RMWT2cqGT3Bj7ZUfJa
         nEliVnyW3rwGkarshZ0bSeN9rTtdSNsWaz2LjaiMufqxWVt9THLHJhDNgCJQlUhPkKKV
         zQUZXmeD231OTGQLdLQp1ja0za9Wqs9hbsV/PQOMjOMgil7ZiQ605VXTvwlu7RIakPZP
         /zIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=9lyd/OGRWu2T77jL2o1qpzkNA2DEbU24ACMy4vbRMkM=;
        b=kMxLgwd89DjidoxFc0RJivxMlAUbWJDIge6TSBtfqx+2fq3PRxdmzVN58GFGyrlrIW
         +yDvCBo3dWCxnTkB+kWmGajsUFhzaXHMCuB2Z4sj86GQZm84RKYrB5LlSZt3kZFqLL2Z
         h2EbHmvkZoATx52+hmeS6lnglmkjEOiX7Na1TxOkFikDxjIhg5fKgiAaDMoj5TttkvOt
         0B1aU1AHRu/OnLw+ma8IfHloiAvD4ar2VAu473hVzTRUrxFu92yN2Uez4/zlQ2/7Odh4
         4Q6HPp6S3oWLl1laknX368v0+Xk4ybAN2z1bbxt9d9UPg3HCGmMBDrpWs3QQliQHmnrm
         NhMA==
X-Gm-Message-State: APjAAAWzd4cdnhCncJwjLWvR7lyu8BEP1fmaPGTTjfL9Pvl6rKE6CjBS
        sZ8bYREmYYDHQpY2kN60mIwQn9GVpFilRg==
X-Google-Smtp-Source: APXvYqy+3zt4YD+h79yUKZTq1m937Ee+d8ln0Im3iGvQ1K3KdMQsXTpWNFrCCy3XvMVeSveLTbKcM8Qa04n0Tw==
X-Received: by 2002:a65:66c4:: with SMTP id c4mr4695732pgw.246.1569353378542;
 Tue, 24 Sep 2019 12:29:38 -0700 (PDT)
Date:   Tue, 24 Sep 2019 12:29:34 -0700
Message-Id: <20190924192934.212317-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.351.gc4317032e6-goog
Subject: [PATCH net] kcm: disable preemption in kcm_parse_func_strparser()
From:   Eric Dumazet <edumazet@google.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        bpf <bpf@vger.kernel.org>, syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit a2c11b034142 ("kcm: use BPF_PROG_RUN")
syzbot easily triggers the warning in cant_sleep().

As explained in commit 6cab5e90ab2b ("bpf: run bpf programs
with preemption disabled") we need to disable preemption before
running bpf programs.

BUG: assuming atomic context at net/kcm/kcmsock.c:382
in_atomic(): 0, irqs_disabled(): 0, pid: 7, name: kworker/u4:0
3 locks held by kworker/u4:0/7:
 #0: ffff888216726128 ((wq_completion)kstrp){+.+.}, at: __write_once_size include/linux/compiler.h:226 [inline]
 #0: ffff888216726128 ((wq_completion)kstrp){+.+.}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888216726128 ((wq_completion)kstrp){+.+.}, at: atomic64_set include/asm-generic/atomic-instrumented.h:855 [inline]
 #0: ffff888216726128 ((wq_completion)kstrp){+.+.}, at: atomic_long_set include/asm-generic/atomic-long.h:40 [inline]
 #0: ffff888216726128 ((wq_completion)kstrp){+.+.}, at: set_work_data kernel/workqueue.c:620 [inline]
 #0: ffff888216726128 ((wq_completion)kstrp){+.+.}, at: set_work_pool_and_clear_pending kernel/workqueue.c:647 [inline]
 #0: ffff888216726128 ((wq_completion)kstrp){+.+.}, at: process_one_work+0x88b/0x1740 kernel/workqueue.c:2240
 #1: ffff8880a989fdc0 ((work_completion)(&strp->work)){+.+.}, at: process_one_work+0x8c1/0x1740 kernel/workqueue.c:2244
 #2: ffff888098998d10 (sk_lock-AF_INET){+.+.}, at: lock_sock include/net/sock.h:1522 [inline]
 #2: ffff888098998d10 (sk_lock-AF_INET){+.+.}, at: strp_sock_lock+0x2e/0x40 net/strparser/strparser.c:440
CPU: 0 PID: 7 Comm: kworker/u4:0 Not tainted 5.3.0+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: kstrp strp_work
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x172/0x1f0 lib/dump_stack.c:113
 __cant_sleep kernel/sched/core.c:6826 [inline]
 __cant_sleep.cold+0xa4/0xbc kernel/sched/core.c:6803
 kcm_parse_func_strparser+0x54/0x200 net/kcm/kcmsock.c:382
 __strp_recv+0x5dc/0x1b20 net/strparser/strparser.c:221
 strp_recv+0xcf/0x10b net/strparser/strparser.c:343
 tcp_read_sock+0x285/0xa00 net/ipv4/tcp.c:1639
 strp_read_sock+0x14d/0x200 net/strparser/strparser.c:366
 do_strp_work net/strparser/strparser.c:414 [inline]
 strp_work+0xe3/0x130 net/strparser/strparser.c:423
 process_one_work+0x9af/0x1740 kernel/workqueue.c:2269

Fixes: a2c11b034142 ("kcm: use BPF_PROG_RUN")
Fixes: 6cab5e90ab2b ("bpf: run bpf programs with preemption disabled")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/kcm/kcmsock.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 8f12f5c6ab875ebaa6c59c6268c337919fb43bb9..ea9e73428ed9c8b7bb3441947151c41f0c099185 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -378,8 +378,12 @@ static int kcm_parse_func_strparser(struct strparser *strp, struct sk_buff *skb)
 {
 	struct kcm_psock *psock = container_of(strp, struct kcm_psock, strp);
 	struct bpf_prog *prog = psock->bpf_prog;
+	int res;
 
-	return BPF_PROG_RUN(prog, skb);
+	preempt_disable();
+	res = BPF_PROG_RUN(prog, skb);
+	preempt_enable();
+	return res;
 }
 
 static int kcm_read_sock_done(struct strparser *strp, int err)
-- 
2.23.0.351.gc4317032e6-goog

