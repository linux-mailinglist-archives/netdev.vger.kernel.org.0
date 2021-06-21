Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFDC3AEBA4
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 16:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbhFUOqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 10:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbhFUOqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 10:46:38 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9C1C061574
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 07:44:21 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id 22-20020a17090a0c16b0290164a5354ad0so12763856pjs.2
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 07:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dvQaDEHgeDIiALmjPH22iVdsQpMLYlhVmcEtBj+DvV0=;
        b=XWYfbb+y1f0E87k5bhabzep15GvUqF3J5M9yJm6Rj2hruzKpns66VaDZClVYczlmoo
         MHlU6suTi6bTZ2EHaVweFji68hJ3KHWugCxfbEO92mhBy+rTLSfr1D/HScBlVvwbpBYe
         qO2c1RMuJtV69yiOEvBuQ4FtlGXpFG8udtrPL/yTk4Lew/J0Yw93MvWEgR0YBk/vmWzc
         gIilHVI+XFmwiJjmRAE7VtpMFIQ/BDR5UJdW4ijOxxvXGVsKHk4oE3IgsDPZRh5F7Y9n
         GyMLUnqj9mACl6Z161/Yx4v/8UnenTmMBwSyhdEEURDI1wIoLqmJE0z6sq6D463oHcKC
         TAcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dvQaDEHgeDIiALmjPH22iVdsQpMLYlhVmcEtBj+DvV0=;
        b=qSD4Yk0UcslMbz/fyXzJm36BpbCZZw0w+F1Rg4ofsN3AtRjLZjJe6swdTzU637Tr2/
         5oSncbGVeWt6x8/xkjaZNGYZM2eTlDxkPBbh+ji4op/bSXyEQbVCCkIZYdFDjm1DdYcN
         O0Q7S5MMYUcLNuHguEfIQ7ZVmp+BYjvAa+FIK2WhFyN+N9CvbgudLXwKtVxU+LWKOCh7
         6oX467FW13asbXD53C/bpMULSUjZ6rMc7Pe8pScekRfQiY9ZStHhyB0gAkcwVqNXRlH5
         OBNhK5Dk+i9+uadTuMm9o54WKkrUwFBrVSn9QbBVeEU9hV2GOR/aTYTKKaB6xjLtcrfV
         rznA==
X-Gm-Message-State: AOAM532GMFVMQ0cqRFHiKVGKA6cf+PmDgA2D7yKYIM+JDb3y16exs3ey
        T61I3lIL700znunmPPcvR8k=
X-Google-Smtp-Source: ABdhPJzaRtY0JxTo7rdSCJKpcdTDvbkpLcmFwA8VR6YfdJosRCyW3XXHcDqckttxaeJpve3QAH0vtA==
X-Received: by 2002:a17:90b:1d89:: with SMTP id pf9mr38079083pjb.26.1624286660649;
        Mon, 21 Jun 2021 07:44:20 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:21de:f864:55d7:2d0])
        by smtp.gmail.com with ESMTPSA id v21sm4583549pju.47.2021.06.21.07.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 07:44:20 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] vxlan: add missing rcu_read_lock() in neigh_reduce()
Date:   Mon, 21 Jun 2021 07:44:17 -0700
Message-Id: <20210621144417.694367-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

syzbot complained in neigh_reduce(), because rcu_read_lock_bh()
is treated differently than rcu_read_lock()

WARNING: suspicious RCU usage
5.13.0-rc6-syzkaller #0 Not tainted
-----------------------------
include/net/addrconf.h:313 suspicious rcu_dereference_check() usage!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
3 locks held by kworker/0:0/5:
 #0: ffff888011064d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888011064d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888011064d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888011064d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:617 [inline]
 #0: ffff888011064d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:644 [inline]
 #0: ffff888011064d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2247
 #1: ffffc90000ca7da8 ((work_completion)(&port->wq)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2251
 #2: ffffffff8bf795c0 (rcu_read_lock_bh){....}-{1:2}, at: __dev_queue_xmit+0x1da/0x3130 net/core/dev.c:4180

stack backtrace:
CPU: 0 PID: 5 Comm: kworker/0:0 Not tainted 5.13.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events ipvlan_process_multicast
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 __in6_dev_get include/net/addrconf.h:313 [inline]
 __in6_dev_get include/net/addrconf.h:311 [inline]
 neigh_reduce drivers/net/vxlan.c:2167 [inline]
 vxlan_xmit+0x34d5/0x4c30 drivers/net/vxlan.c:2919
 __netdev_start_xmit include/linux/netdevice.h:4944 [inline]
 netdev_start_xmit include/linux/netdevice.h:4958 [inline]
 xmit_one net/core/dev.c:3654 [inline]
 dev_hard_start_xmit+0x1eb/0x920 net/core/dev.c:3670
 __dev_queue_xmit+0x2133/0x3130 net/core/dev.c:4246
 ipvlan_process_multicast+0xa99/0xd70 drivers/net/ipvlan/ipvlan_core.c:287
 process_one_work+0x98d/0x1600 kernel/workqueue.c:2276
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2422
 kthread+0x3b1/0x4a0 kernel/kthread.c:313
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Fixes: f564f45c4518 ("vxlan: add ipv6 proxy support")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 drivers/net/vxlan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 02a14f1b938ad50fc28044b7670ba5f6bf924345..5a8df5a195cb5700c45b4785355ef8ed84866052 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2164,6 +2164,7 @@ static int neigh_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 	struct neighbour *n;
 	struct nd_msg *msg;
 
+	rcu_read_lock();
 	in6_dev = __in6_dev_get(dev);
 	if (!in6_dev)
 		goto out;
@@ -2215,6 +2216,7 @@ static int neigh_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 	}
 
 out:
+	rcu_read_unlock();
 	consume_skb(skb);
 	return NETDEV_TX_OK;
 }
-- 
2.32.0.288.g62a8d224e6-goog

