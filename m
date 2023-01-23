Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 413DE67769F
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 09:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbjAWIp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 03:45:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbjAWIp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 03:45:56 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF0918B1C
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 00:45:55 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id i17-20020a25bc11000000b007b59a5b74aaso12348169ybh.7
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 00:45:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kCkgFj+VElXHDgk0rRx+Ql9Kk0tr7AfiZ963MOsBK/w=;
        b=W70D79llVg9x1Hu7G1hmU1VxpRiJWenw9kV4nX6fP/gDwWovx+Dm98W3YzCsfifvyM
         yB7ugve5gezmp/bIZrGc+vqZzXLpzhA4CVezqF7XIoXzjn89b8e6PQ6TBJOWvranSmNg
         9ZXy5ZBCjbgTcpic8TSHiDb/OboykIKlkanwmMNOwh/8qGiXZO81PQex+PSuUvWDEQLR
         NuSmk1ztu4q8lHevxDUjwg73M8pYJdOmKz8R31fo1Kw2BVCgX2+ev8+rtAX+69vRkltK
         4R3iOLVjN9+9Y6w8vZNMDfq/B411xfHapF6CB0UHgtC8Ojyw48El5uXeXRVCjFrRblxD
         2Z+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kCkgFj+VElXHDgk0rRx+Ql9Kk0tr7AfiZ963MOsBK/w=;
        b=io40kKxnXlI74tG68KK7i9ysDL/XNrrXRnUznoT2fwTJ9Y80PaufTFOQ1pfGxtp7vF
         yrzqpD/xKDLuYWva10Cr3gdVT87cx7+vBRHyGdM4ai8L6oaKO0pE71RKlLUc83ClBQID
         zpvnm5SH8q41sYJpHs2uRBIIUD9/2l5Z7Xfu1j/pqaRbUZ5ptlbST4uh3f1EnG59hq9D
         MJIvWsCtZKffTtD1MchxKlwYU82E9PZRXIFrL+9Q7NJpTTTsYnavBGeKwo+p5yz3uv0P
         OEwwwc5xEfxftEFzt3X1sAe8YGMYb5ck5dDOoaQbI7bYkH8fNc7hipVNrSzuvKn/dVyQ
         5n0g==
X-Gm-Message-State: AFqh2krzUbzgshK6+Tu4POej1aA6LddKV6kV6PzLzgfv/CjeIO1uAb5V
        TRL8IYGqGC96Y3DicQhx1+Ave9jVnCDsrA==
X-Google-Smtp-Source: AMrXdXt4rRSaPaCZpbmsHdHaCVNotXm5JSY8hpzu8vbJFE5bzGJdfsToHgwyGo+gT109o8a9+teMdq7YjEDOTA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:5c02:0:b0:4e2:db5a:2c2c with SMTP id
 q2-20020a815c02000000b004e2db5a2c2cmr3106465ywb.202.1674463554326; Mon, 23
 Jan 2023 00:45:54 -0800 (PST)
Date:   Mon, 23 Jan 2023 08:45:52 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.405.gd4c25cc71f-goog
Message-ID: <20230123084552.574396-1-edumazet@google.com>
Subject: [PATCH net] net/sched: sch_taprio: do not schedule in taprio_reset()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As reported by syzbot and hinted by Vinicius, I should not have added
a qdisc_synchronize() call in taprio_reset()

taprio_reset() can be called with qdisc spinlock held (and BH disabled)
as shown in included syzbot report [1].

Only taprio_destroy() needed this synchronization, as explained
in the blamed commit changelog.

[1]

BUG: scheduling while atomic: syz-executor150/5091/0x00000202
2 locks held by syz-executor150/5091:
Modules linked in:
Preemption disabled at:
[<0000000000000000>] 0x0
Kernel panic - not syncing: scheduling while atomic: panic_on_warn set ...
CPU: 1 PID: 5091 Comm: syz-executor150 Not tainted 6.2.0-rc3-syzkaller-00219-g010a74f52203 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/12/2023
Call Trace:
<TASK>
__dump_stack lib/dump_stack.c:88 [inline]
dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
panic+0x2cc/0x626 kernel/panic.c:318
check_panic_on_warn.cold+0x19/0x35 kernel/panic.c:238
__schedule_bug.cold+0xd5/0xfe kernel/sched/core.c:5836
schedule_debug kernel/sched/core.c:5865 [inline]
__schedule+0x34e4/0x5450 kernel/sched/core.c:6500
schedule+0xde/0x1b0 kernel/sched/core.c:6682
schedule_timeout+0x14e/0x2a0 kernel/time/timer.c:2167
schedule_timeout_uninterruptible kernel/time/timer.c:2201 [inline]
msleep+0xb6/0x100 kernel/time/timer.c:2322
qdisc_synchronize include/net/sch_generic.h:1295 [inline]
taprio_reset+0x93/0x270 net/sched/sch_taprio.c:1703
qdisc_reset+0x10c/0x770 net/sched/sch_generic.c:1022
dev_reset_queue+0x92/0x130 net/sched/sch_generic.c:1285
netdev_for_each_tx_queue include/linux/netdevice.h:2464 [inline]
dev_deactivate_many+0x36d/0x9f0 net/sched/sch_generic.c:1351
dev_deactivate+0xed/0x1b0 net/sched/sch_generic.c:1374
qdisc_graft+0xe4a/0x1380 net/sched/sch_api.c:1080
tc_modify_qdisc+0xb6b/0x19a0 net/sched/sch_api.c:1689
rtnetlink_rcv_msg+0x43e/0xca0 net/core/rtnetlink.c:6141
netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2564
netlink_unicast_kernel net/netlink/af_netlink.c:1330 [inline]
netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1356
netlink_sendmsg+0x91b/0xe10 net/netlink/af_netlink.c:1932
sock_sendmsg_nosec net/socket.c:714 [inline]
sock_sendmsg+0xd3/0x120 net/socket.c:734
____sys_sendmsg+0x712/0x8c0 net/socket.c:2476
___sys_sendmsg+0x110/0x1b0 net/socket.c:2530
__sys_sendmsg+0xf7/0x1c0 net/socket.c:2559
do_syscall_x64 arch/x86/entry/common.c:50 [inline]

Fixes: 3a415d59c1db ("net/sched: sch_taprio: fix possible use-after-free")
Link: https://lore.kernel.org/netdev/167387581653.2747.13878941339893288655.git-patchwork-notify@kernel.org/T/
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 net/sched/sch_taprio.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 9a11a499ea2df8d18c9c062496fdcbcf5a861391..c322a61eaeeac4b3744ec7b347d1256a19dfb244 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1700,7 +1700,6 @@ static void taprio_reset(struct Qdisc *sch)
 	int i;
 
 	hrtimer_cancel(&q->advance_timer);
-	qdisc_synchronize(sch);
 
 	if (q->qdiscs) {
 		for (i = 0; i < dev->num_tx_queues; i++)
-- 
2.39.1.405.gd4c25cc71f-goog

