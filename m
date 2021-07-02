Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 994A83BA224
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 16:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbhGBOaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 10:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233117AbhGBOaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 10:30:07 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E0BCC061762
        for <netdev@vger.kernel.org>; Fri,  2 Jul 2021 07:27:35 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id a127so9055194pfa.10
        for <netdev@vger.kernel.org>; Fri, 02 Jul 2021 07:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mCsrNIIGzkQPNYdQ5/v9Q6VIXTZBuJVwXW0NnffdHXo=;
        b=iv2ZkdN4zWLPnbmQv2Ntr8MK2GQ6eBybcRjFwjlhI2Y+w5PRPtWf7yFpjzkypM3o9r
         9IuG4EZ+FHx654KtLiH4TABP4jDWUPcSTZE2Hg5RvgQ1LX5OYTLOdY6T1tyXcly23qOd
         iMmQtY3JomcodHQzWFAnZGJLYJPhhgd4Y1r6HBph0ESA4dJalenaxKImUa++cMcbsc/s
         ENHWAJ9IDuPLsHILXouXEjrjcF406WdbtB0XPlJkBLxU670ZpFQU+ZpLV0QlL38PmQrI
         YA1KxzkW/9mgB8cPewQDOQGUa+KEwP7/m6pWKM6G0nt2CQIwMd/XtdqOpXqP8H1jPuM0
         I8NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mCsrNIIGzkQPNYdQ5/v9Q6VIXTZBuJVwXW0NnffdHXo=;
        b=DNrOYdRTm10ZtEzSc8e3pc1fVVDX6eKuQUUqn40EFL1i/7L4sojNnIkvO946e7gUO/
         cVxc1GkNN11nyYYnEFY/DvQrUL4mqFD3OSKph5mPg6zVvU6IRl7oKKmMVLvvNBgBmKjZ
         4eaZxxEghC+1IRNOfX2CU+UdgVj5QiaPTJoGDA7BycgKhBXPF4213AVBmds4KAb7gdsQ
         cAYuGWtdIbQTkwB7Kdsj1uhDgGATiMr+b1831nXBewl+KNtZBCvx946Z/6clPy9W7Ttb
         u1tMNCCYCY1wqRDSKLsYnmMeTT+KjmVaSgytUNm5jhueL3rGZVGqmep0gEywodC2QT1D
         oD4A==
X-Gm-Message-State: AOAM533nLEiV7OWiXMMY7G8nJ8dg20CAsCV2WYHpZLWUKiZHI+2zdhFB
        PNZU8rPePYksqAF4M8Vtv58=
X-Google-Smtp-Source: ABdhPJzEvjiQ+VHYHX0kTuhnPEKsGDCvbSOQyGUTZgKdPWONZagGDgQeEMQ1sGDII5Z+noV3qAReJw==
X-Received: by 2002:a63:1542:: with SMTP id 2mr271706pgv.329.1625236054590;
        Fri, 02 Jul 2021 07:27:34 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id nr12sm12683747pjb.1.2021.07.02.07.27.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jul 2021 07:27:34 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, jarod@redhat.com,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 5/8] bonding: fix suspicious RCU usage in bond_ipsec_del_sa()
Date:   Fri,  2 Jul 2021 14:26:45 +0000
Message-Id: <20210702142648.7677-6-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210702142648.7677-1-ap420073@gmail.com>
References: <20210702142648.7677-1-ap420073@gmail.com>
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

