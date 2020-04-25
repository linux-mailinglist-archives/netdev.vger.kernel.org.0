Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48BF61B89C7
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 00:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbgDYWT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 18:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726220AbgDYWT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 18:19:56 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE31AC09B04F
        for <netdev@vger.kernel.org>; Sat, 25 Apr 2020 15:19:54 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id ev8so14038585qvb.7
        for <netdev@vger.kernel.org>; Sat, 25 Apr 2020 15:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=sUoTXLrqW7jvRrwwNnKZNqSzfQofAGNmokAfk8NRRkY=;
        b=PupAoPGfTW4nwfFS252wpQsDbaawLNmkFwv0vFFgrHEwOMblRu3oidNPl7U012fsM8
         nFtmMMZxM5f57BOB6nEdHTkUZRuo/rCxixiv+WwM9OC4ifs/iaVwh6JhY6fdLcusdcKd
         Lr/ZhXdDUHnK07jN8v6Qei6uPX8tYxgq+YZNsoZP9ed7Z2VZtJI2L38UA3gTxDccs5tQ
         9tjo5DFyq4leq9cY7GGngudFhSEwuo1UUyQbmdfa4mliMzXPK4HeeOZqn26Ge42rikmn
         DXbeYJdSKKHiUdpl7dEXb3KD+qfkNwXdxklDNewrsuUL6aOeshqw7IJhZ+3S1YR7RUzu
         Iu5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=sUoTXLrqW7jvRrwwNnKZNqSzfQofAGNmokAfk8NRRkY=;
        b=kFsNuO4+goJ1FuNPbXDrx5nXBLd19603WNa/21UvKjLC03tHDgbulBliqzQScjIDdv
         oKgdokrwk8AUhigjtpwXZGC77Cz0oqRVFBpWcvFPkRP1pvA0lDmA6e215kc1vhC6yDk9
         PP1KWHqwEdLmPbtcuLomBQS0sGvhDx4EhLCUrtGk/tKRshK9/0NBv4g2qiTPvPd8JV96
         tc65TuvxDmoUd8H6lejclFJyb1CcOQf859YLSpwql7rp62BL5rlUPa834+v3cH/a376z
         XPPlhIel+qAX4Ax4713p0pfrNwBkZAz+StBeCoY0oQVHicEZXuhSFa+EBF4UCmeUK3jn
         h9rA==
X-Gm-Message-State: AGi0PuaBqlS/sl7NFJhHr4LGNmQEOq8qV+7H5MEghUan/mT2r03qYOrl
        VkcwNvNUlRWvYfkuAyDNNQJPL7vKS3UWAg==
X-Google-Smtp-Source: APiQypIhNfuzqmKWTyf4lArlK8QEwmApQI1wfkruyxPXIG3LiCrITcO92huF7OF1eJPvQjtxopxEY2IpeoD8dg==
X-Received: by 2002:a05:6214:1462:: with SMTP id c2mr15618958qvy.202.1587853193942;
 Sat, 25 Apr 2020 15:19:53 -0700 (PDT)
Date:   Sat, 25 Apr 2020 15:19:51 -0700
Message-Id: <20200425221951.151564-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.303.gf8c07b1a785-goog
Subject: [PATCH net] sch_choke: avoid potential panic in choke_reset()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If choke_init() could not allocate q->tab, we would crash later
in choke_reset().

BUG: KASAN: null-ptr-deref in memset include/linux/string.h:366 [inline]
BUG: KASAN: null-ptr-deref in choke_reset+0x208/0x340 net/sched/sch_choke.c:326
Write of size 8 at addr 0000000000000000 by task syz-executor822/7022

CPU: 1 PID: 7022 Comm: syz-executor822 Not tainted 5.7.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 __kasan_report.cold+0x5/0x4d mm/kasan/report.c:515
 kasan_report+0x33/0x50 mm/kasan/common.c:625
 check_memory_region_inline mm/kasan/generic.c:187 [inline]
 check_memory_region+0x141/0x190 mm/kasan/generic.c:193
 memset+0x20/0x40 mm/kasan/common.c:85
 memset include/linux/string.h:366 [inline]
 choke_reset+0x208/0x340 net/sched/sch_choke.c:326
 qdisc_reset+0x6b/0x520 net/sched/sch_generic.c:910
 dev_deactivate_queue.constprop.0+0x13c/0x240 net/sched/sch_generic.c:1138
 netdev_for_each_tx_queue include/linux/netdevice.h:2197 [inline]
 dev_deactivate_many+0xe2/0xba0 net/sched/sch_generic.c:1195
 dev_deactivate+0xf8/0x1c0 net/sched/sch_generic.c:1233
 qdisc_graft+0xd25/0x1120 net/sched/sch_api.c:1051
 tc_modify_qdisc+0xbab/0x1a00 net/sched/sch_api.c:1670
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5454
 netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2469
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6bf/0x7e0 net/socket.c:2362
 ___sys_sendmsg+0x100/0x170 net/socket.c:2416
 __sys_sendmsg+0xec/0x1b0 net/socket.c:2449
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295

Fixes: 77e62da6e60c ("sch_choke: drop all packets in queue during reset")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/sched/sch_choke.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_choke.c b/net/sched/sch_choke.c
index a36974e9c601eca97ea98501f0c05f75d0a9fe3e..1bcf8fbfd40e4c56baddd8b8f0fe1bb804cc5b4e 100644
--- a/net/sched/sch_choke.c
+++ b/net/sched/sch_choke.c
@@ -323,7 +323,8 @@ static void choke_reset(struct Qdisc *sch)
 
 	sch->q.qlen = 0;
 	sch->qstats.backlog = 0;
-	memset(q->tab, 0, (q->tab_mask + 1) * sizeof(struct sk_buff *));
+	if (q->tab)
+		memset(q->tab, 0, (q->tab_mask + 1) * sizeof(struct sk_buff *));
 	q->head = q->tail = 0;
 	red_restart(&q->vars);
 }
-- 
2.26.2.303.gf8c07b1a785-goog

