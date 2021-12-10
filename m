Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1C5346FC80
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 09:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbhLJITR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 03:19:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbhLJITQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 03:19:16 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DEB1C061746
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 00:15:42 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id x131so7759523pfc.12
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 00:15:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1QWrIBxuiHkU9HMZoNWByojt0f4LIg0JcAE6pY56mfk=;
        b=FRtGlJrHWIKgHEJquhtdyuPHmcaVvGQG4rFCzmjE8n+BcDIu6h8DCyMc3uetOoFE9r
         z7M2JUgat34vxFtaQJcPpuDfEMBhXKr+zsHCIMYK0PL3bfDOMPW/nPdFc0ZLGO/TmHZb
         Z86SFwS2atvJjf566oVk2qPw/NlSX+VOmPU6CmCkqHmeLiWc6I3MSDEL7DzDCFGj0q6e
         m3SQqa/ZUSWl95tPidz72gDgTFLl+UhaW3T2dCnqgbdiqw4q7ecjCho5Lc5Xoz9V/m96
         AwbRRamqVpF8a2RW3YuFhg7yKvLcDKA2gRCROyhJmywdkCQKNVf5xY6UppFztpLWpt7r
         B8KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1QWrIBxuiHkU9HMZoNWByojt0f4LIg0JcAE6pY56mfk=;
        b=sBy5LDKMq06FOuIXZcdusAknBIVnVqnTnYSr7Mf9BFP5cz/SaqTxeCpqmOt/zIqhQi
         uGBa0ElFHsDWUL2nYbujN8JrnWy66s803TGe1IT/qvCcQhndQGxxEBKDoid2pBIqUsPM
         mPwq0wMO6T3Kdt/wL4jG8vXQ1N0L4vgZ6Hvnc/IK/zoYmk40Gq66roa/ITDXNgImLrGh
         0u20AUPM/VWBe8ak9AZtgwuCJwzu2pHuTL4v1QLhmAneeYit9xGwsQHjXBUQW6UXg3jH
         KkH46uQlMyIUi84k/M9/aHAIcRGHyrV3fv5AYZrO9ZcAqmEFEs0OeIbw5Tx27NPJjDWd
         n2bw==
X-Gm-Message-State: AOAM531tmy1vkqQG188iQ1o6lPWuHE3dYiY6NZk02bRA3OL3g2CyIVOb
        gqjbd/9d1priyUTGVCFF+MQ=
X-Google-Smtp-Source: ABdhPJzyJMobSgpTEhY4slnnxpuW1OEZmj8pg+rQxenFNaNhiDZLhv0kpPKrq6OzZMame1Z+DP8iug==
X-Received: by 2002:aa7:86c6:0:b0:4a4:ac66:99fc with SMTP id h6-20020aa786c6000000b004a4ac6699fcmr16510943pfo.83.1639124141812;
        Fri, 10 Dec 2021 00:15:41 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4f5:a6b4:3889:ebe5])
        by smtp.gmail.com with ESMTPSA id gc22sm11581649pjb.57.2021.12.10.00.15.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 00:15:41 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH net] sch_cake: do not call cake_destroy() from cake_init()
Date:   Fri, 10 Dec 2021 00:15:36 -0800
Message-Id: <20211210081536.451881-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

qdiscs are not supposed to call their own destroy() method
from init(), because core stack already does that.

syzbot was able to trigger use after free:

DEBUG_LOCKS_WARN_ON(lock->magic != lock)
WARNING: CPU: 0 PID: 21902 at kernel/locking/mutex.c:586 __mutex_lock_common kernel/locking/mutex.c:586 [inline]
WARNING: CPU: 0 PID: 21902 at kernel/locking/mutex.c:586 __mutex_lock+0x9ec/0x12f0 kernel/locking/mutex.c:740
Modules linked in:
CPU: 0 PID: 21902 Comm: syz-executor189 Not tainted 5.16.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__mutex_lock_common kernel/locking/mutex.c:586 [inline]
RIP: 0010:__mutex_lock+0x9ec/0x12f0 kernel/locking/mutex.c:740
Code: 08 84 d2 0f 85 19 08 00 00 8b 05 97 38 4b 04 85 c0 0f 85 27 f7 ff ff 48 c7 c6 20 00 ac 89 48 c7 c7 a0 fe ab 89 e8 bf 76 ba ff <0f> 0b e9 0d f7 ff ff 48 8b 44 24 40 48 8d b8 c8 08 00 00 48 89 f8
RSP: 0018:ffffc9000627f290 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88802315d700 RSI: ffffffff815f1db8 RDI: fffff52000c4fe44
RBP: ffff88818f28e000 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815ebb5e R11: 0000000000000000 R12: 0000000000000000
R13: dffffc0000000000 R14: ffffc9000627f458 R15: 0000000093c30000
FS:  0000555556abc400(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fda689c3303 CR3: 000000001cfbb000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 tcf_chain0_head_change_cb_del+0x2e/0x3d0 net/sched/cls_api.c:810
 tcf_block_put_ext net/sched/cls_api.c:1381 [inline]
 tcf_block_put_ext net/sched/cls_api.c:1376 [inline]
 tcf_block_put+0xbc/0x130 net/sched/cls_api.c:1394
 cake_destroy+0x3f/0x80 net/sched/sch_cake.c:2695
 qdisc_create.constprop.0+0x9da/0x10f0 net/sched/sch_api.c:1293
 tc_modify_qdisc+0x4c5/0x1980 net/sched/sch_api.c:1660
 rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5571
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2496
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x904/0xdf0 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f1bb06badb9
Code: Unable to access opcode bytes at RIP 0x7f1bb06bad8f.
RSP: 002b:00007fff3012a658 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f1bb06badb9
RDX: 0000000000000000 RSI: 00000000200007c0 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000003 R09: 0000000000000003
R10: 0000000000000003 R11: 0000000000000246 R12: 00007fff3012a688
R13: 00007fff3012a6a0 R14: 00007fff3012a6e0 R15: 00000000000013c2
 </TASK>

Fixes: 046f6fd5daef ("sched: Add Common Applications Kept Enhanced (cake) qdisc")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 net/sched/sch_cake.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 3c2300d144681869a37ada0d20966f9b5b145653..857aaebd49f4315502928fb1f75d2c85eb63eb51 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -2736,7 +2736,7 @@ static int cake_init(struct Qdisc *sch, struct nlattr *opt,
 	q->tins = kvcalloc(CAKE_MAX_TINS, sizeof(struct cake_tin_data),
 			   GFP_KERNEL);
 	if (!q->tins)
-		goto nomem;
+		return -ENOMEM;
 
 	for (i = 0; i < CAKE_MAX_TINS; i++) {
 		struct cake_tin_data *b = q->tins + i;
@@ -2766,10 +2766,6 @@ static int cake_init(struct Qdisc *sch, struct nlattr *opt,
 	q->min_netlen = ~0;
 	q->min_adjlen = ~0;
 	return 0;
-
-nomem:
-	cake_destroy(sch);
-	return -ENOMEM;
 }
 
 static int cake_dump(struct Qdisc *sch, struct sk_buff *skb)
-- 
2.34.1.173.g76aa8bc2d0-goog

