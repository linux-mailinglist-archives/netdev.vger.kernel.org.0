Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E76A3BC116
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 17:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233366AbhGEPle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 11:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234105AbhGEPlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 11:41:31 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59CEEC061574
        for <netdev@vger.kernel.org>; Mon,  5 Jul 2021 08:38:53 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id d12so18627276pgd.9
        for <netdev@vger.kernel.org>; Mon, 05 Jul 2021 08:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4W4d/nkYx4Mla7iCAH4eZcYB0hVDv7++rO1p/nGxERs=;
        b=VBRqrepJ8KVNthnbx1Zn4/KdB5aOeOA2TwDYboexi6pzsfdviosQucxsUahfRb26p2
         APXwC7LgwLALACoGkG/uWn1I5hNeM/pz5s44nZs0fZz6e229gahoAEHCapxDRhLgK1g+
         nj0ilousARx03UpKAiQs0bVrPTX/3xwhLIZ0sXqn5R3DLr3G5in5Tvpmll5It2L4tds2
         S1sDGupBTd+phAHgaZ3J8fMoNmPIzGm/9u/GMZWxFuzobNjFMAIn2OnXB1XTQwLAZDkI
         qikG3D6xLyuCZTd3cGBwz0eSaGqfQrvoa5eAX5iiujXDF28wzg2yTc9fUGYf9RjfLTKL
         b0WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4W4d/nkYx4Mla7iCAH4eZcYB0hVDv7++rO1p/nGxERs=;
        b=K1IIMF8oo53d3s8YpFRsOi2H3ZxtzE5iSSQoXnlXL6NbhjgxRASHJ8GKZ38iVHooLM
         xlrPuxpu9IaTlBZ0ieGupViUGiHxZeCla+fs5muPFfwhhUDYODD4Hk+r/m0sF9wleDK7
         FiTotmgcDRuGVv1CrbjebpvF7spqLgseWgVzPpN4uETHEdcS9zC7oEpXKyhL8rOYnO2B
         opkQEzk0TD7KgJNETnZRBmSULEVt3KfhniZDRd1EHkC9ew6W+XwMgm06BRXl1WY6rUiI
         PUr9Uh2S+M/UCE5nLE/7SsRnhFU2OkspOD5We2xyx3X+dpv1kV2pyutm9k36jMKaCorg
         4XXQ==
X-Gm-Message-State: AOAM531h8xL0GvqqSin8b47/5qA9if/xZBYGX9YW3CoMVZeBMzVOa1Y6
        zG3JITZpTLT7eBNLqELagpw=
X-Google-Smtp-Source: ABdhPJycaLgSodeOf23RDbXCbdIrPuZ8fzWq1/Th2MBB9l2ZZYdFvz6abQkjyMrWBTQDqTAYAFvIlQ==
X-Received: by 2002:aa7:820d:0:b029:2f1:d22d:f21d with SMTP id k13-20020aa7820d0000b02902f1d22df21dmr15742463pfi.7.1625499532930;
        Mon, 05 Jul 2021 08:38:52 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id k10sm9310353pfp.63.2021.07.05.08.38.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 08:38:52 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, jarod@redhat.com,
        intel-wired-lan@lists.osuosl.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 5/9] bonding: fix suspicious RCU usage in bond_ipsec_del_sa()
Date:   Mon,  5 Jul 2021 15:38:10 +0000
Message-Id: <20210705153814.11453-6-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210705153814.11453-1-ap420073@gmail.com>
References: <20210705153814.11453-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To dereference bond->curr_active_slave, it uses rcu_dereference().
But it and the caller doesn't acquire RCU so a warning occurs.
So add rcu_read_lock().

Test commands:
    ip netns add A
    ip netns exec A bash
    modprobe netdevsim
    echo "1 1" > /sys/bus/netdevsim/new_device
    ip link add bond0 type bond
    ip link set eth0 master bond0
    ip link set eth0 up
    ip link set bond0 up
    ip x s add proto esp dst 14.1.1.1 src 15.1.1.1 spi 0x07 mode \
transport reqid 0x07 replay-window 32 aead 'rfc4106(gcm(aes))' \
0x44434241343332312423222114131211f4f3f2f1 128 sel src 14.0.0.52/24 \
dst 14.0.0.70/24 proto tcp offload dev bond0 dir in
    ip x s f

Splat looks like:
=============================
WARNING: suspicious RCU usage
5.13.0-rc3+ #1168 Not tainted
-----------------------------
drivers/net/bonding/bond_main.c:448 suspicious rcu_dereference_check()
usage!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
2 locks held by ip/705:
 #0: ffff888106701780 (&net->xfrm.xfrm_cfg_mutex){+.+.}-{3:3},
at: xfrm_netlink_rcv+0x59/0x80 [xfrm_user]
 #1: ffff8880075b0098 (&x->lock){+.-.}-{2:2},
at: xfrm_state_delete+0x16/0x30

stack backtrace:
CPU: 6 PID: 705 Comm: ip Not tainted 5.13.0-rc3+ #1168
Call Trace:
 dump_stack+0xa4/0xe5
 bond_ipsec_del_sa+0x16a/0x1c0 [bonding]
 __xfrm_state_delete+0x51f/0x730
 xfrm_state_delete+0x1e/0x30
 xfrm_state_flush+0x22f/0x390
 xfrm_flush_sa+0xd8/0x260 [xfrm_user]
 ? xfrm_flush_policy+0x290/0x290 [xfrm_user]
 xfrm_user_rcv_msg+0x331/0x660 [xfrm_user]
 ? rcu_read_lock_sched_held+0x91/0xc0
 ? xfrm_user_state_lookup.constprop.39+0x320/0x320 [xfrm_user]
 ? find_held_lock+0x3a/0x1c0
 ? mutex_lock_io_nested+0x1210/0x1210
 ? sched_clock_cpu+0x18/0x170
 netlink_rcv_skb+0x121/0x350
[ ... ]

Fixes: 18cb261afd7b ("bonding: support hardware encryption offload to slaves")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
v1 -> v2:
 - no change

 drivers/net/bonding/bond_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index e1009e169d42..7659e1fab19e 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -444,21 +444,24 @@ static void bond_ipsec_del_sa(struct xfrm_state *xs)
 	if (!bond_dev)
 		return;
 
+	rcu_read_lock();
 	bond = netdev_priv(bond_dev);
 	slave = rcu_dereference(bond->curr_active_slave);
 
 	if (!slave)
-		return;
+		goto out;
 
 	xs->xso.real_dev = slave->dev;
 
 	if (!(slave->dev->xfrmdev_ops
 	      && slave->dev->xfrmdev_ops->xdo_dev_state_delete)) {
 		slave_warn(bond_dev, slave->dev, "%s: no slave xdo_dev_state_delete\n", __func__);
-		return;
+		goto out;
 	}
 
 	slave->dev->xfrmdev_ops->xdo_dev_state_delete(xs);
+out:
+	rcu_read_unlock();
 }
 
 /**
-- 
2.17.1

