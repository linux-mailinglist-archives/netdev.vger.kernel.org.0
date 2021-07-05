Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 000633BC112
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 17:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234080AbhGEPl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 11:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234028AbhGEPlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 11:41:19 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9DC1C061768
        for <netdev@vger.kernel.org>; Mon,  5 Jul 2021 08:38:39 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id h6so9307000plf.11
        for <netdev@vger.kernel.org>; Mon, 05 Jul 2021 08:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wSBI/a1YQn+fTxpONrrL4XFvQob9I0YMvY/ZJ5LMK3E=;
        b=f5+9SbWD/jRiNMaaB2WfXHDjTQ2flSxuQlYkTNKNBY/kuRJfYeuy+MoIlBKm8vmJvW
         iuuw8RLEy2vWuy/hPohfE2w8RLnczkOTVd2IOvdaYtJB6DvYAS0MEea8lyekBZl6YZMR
         +zSXZI1kmWygmTbors7EKK7+LdBzExRc+0PD7b3Vb3n04azoUatzPjvUugEiMW5P2i9p
         O5DeKEdvWDAx3HwF+yAD7fZaKZtMVEJ2DwVlY0YcQwyK8wR5PsLyaZGEZMzaCspgjArl
         FBt2iX63mR5jlDh4J1ZjtVFpWmGo+TrpiNoGXVUZ+iL92rAoGTiEijKYQhXaaOCxc3G+
         5JKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wSBI/a1YQn+fTxpONrrL4XFvQob9I0YMvY/ZJ5LMK3E=;
        b=r46rv4H2dzpk7bV+6MxNnE4C5mryoKLyiCdL2/cH6UlpZutKqz4XRSen6X5Y7CWcsu
         erZ//R2S0WWETWDurTmAG6Gw8SyZuPpQ5cqd662jr7fUdgI8gEIsx1qqxT1WRXoqTL9D
         6ShARiXP3t3o8zSFLyHfkx+NspmtqgGCDcYMFnruKLB92M/b9uUhBKdc36H7gPy6dmKw
         4Ni+iliZkM5mcuqi7MzA2OfgszLru6HFIL/R+aQEGHrhlg1YRhK8+c9VfUN58jpR38vY
         cpPnRxkv3h+OMyu5PMM5APn1AdgoAUt6KZbKlSpmaPcEpTKSoueH37DtKR3uXTACEeTq
         ktDQ==
X-Gm-Message-State: AOAM53116H3i7hQWwJWGSV6sSckJlVY/EF0MkpEJD8BkKCzUXzuz+zbl
        1IGcD7Z93jekqcVreU+QORA=
X-Google-Smtp-Source: ABdhPJyKzrJtJlTJeDdbnrA6jkSUOr7Gr4Hy9TszNesvCuP6GZlQR0FuKluTwHc+NzJA13U3P7Av+g==
X-Received: by 2002:a17:902:fe10:b029:127:6549:fe98 with SMTP id g16-20020a170902fe10b02901276549fe98mr12973708plj.25.1625499519314;
        Mon, 05 Jul 2021 08:38:39 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id k10sm9310353pfp.63.2021.07.05.08.38.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 08:38:38 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, jarod@redhat.com,
        intel-wired-lan@lists.osuosl.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 1/9] bonding: fix suspicious RCU usage in bond_ipsec_add_sa()
Date:   Mon,  5 Jul 2021 15:38:06 +0000
Message-Id: <20210705153814.11453-2-ap420073@gmail.com>
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
    ip link add dummy0 type dummy
    ip link add bond0 type bond
    ip link set dummy0 master bond0
    ip link set dummy0 up
    ip link set bond0 up
    ip x s add proto esp dst 14.1.1.1 src 15.1.1.1 spi 0x07 \
	    mode transport \
	    reqid 0x07 replay-window 32 aead 'rfc4106(gcm(aes))' \
	    0x44434241343332312423222114131211f4f3f2f1 128 sel \
	    src 14.0.0.52/24 dst 14.0.0.70/24 proto tcp offload \
	    dev bond0 dir in

Splat looks like:
=============================
WARNING: suspicious RCU usage
5.13.0-rc3+ #1168 Not tainted
-----------------------------
drivers/net/bonding/bond_main.c:411 suspicious rcu_dereference_check() usage!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
1 lock held by ip/684:
 #0: ffffffff9a2757c0 (&net->xfrm.xfrm_cfg_mutex){+.+.}-{3:3},
at: xfrm_netlink_rcv+0x59/0x80 [xfrm_user]
   55.191733][  T684] stack backtrace:
CPU: 0 PID: 684 Comm: ip Not tainted 5.13.0-rc3+ #1168
Call Trace:
 dump_stack+0xa4/0xe5
 bond_ipsec_add_sa+0x18c/0x1f0 [bonding]
 xfrm_dev_state_add+0x2a9/0x770
 ? memcpy+0x38/0x60
 xfrm_add_sa+0x2278/0x3b10 [xfrm_user]
 ? xfrm_get_policy+0xaa0/0xaa0 [xfrm_user]
 ? register_lock_class+0x1750/0x1750
 xfrm_user_rcv_msg+0x331/0x660 [xfrm_user]
 ? rcu_read_lock_sched_held+0x91/0xc0
 ? xfrm_user_state_lookup.constprop.39+0x320/0x320 [xfrm_user]
 ? find_held_lock+0x3a/0x1c0
 ? mutex_lock_io_nested+0x1210/0x1210
 ? sched_clock_cpu+0x18/0x170
 netlink_rcv_skb+0x121/0x350
 ? xfrm_user_state_lookup.constprop.39+0x320/0x320 [xfrm_user]
 ? netlink_ack+0x9d0/0x9d0
 ? netlink_deliver_tap+0x17c/0xa50
 xfrm_netlink_rcv+0x68/0x80 [xfrm_user]
 netlink_unicast+0x41c/0x610
 ? netlink_attachskb+0x710/0x710
 netlink_sendmsg+0x6b9/0xb70
[ ... ]

Fixes: 18cb261afd7b ("bonding: support hardware encryption offload to slaves")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
v1 -> v2:
 - no change

 drivers/net/bonding/bond_main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 03b1a93d7fea..fd7b7f894917 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -403,10 +403,12 @@ static int bond_ipsec_add_sa(struct xfrm_state *xs)
 	struct net_device *bond_dev = xs->xso.dev;
 	struct bonding *bond;
 	struct slave *slave;
+	int err;
 
 	if (!bond_dev)
 		return -EINVAL;
 
+	rcu_read_lock();
 	bond = netdev_priv(bond_dev);
 	slave = rcu_dereference(bond->curr_active_slave);
 	xs->xso.real_dev = slave->dev;
@@ -415,10 +417,13 @@ static int bond_ipsec_add_sa(struct xfrm_state *xs)
 	if (!(slave->dev->xfrmdev_ops
 	      && slave->dev->xfrmdev_ops->xdo_dev_state_add)) {
 		slave_warn(bond_dev, slave->dev, "Slave does not support ipsec offload\n");
+		rcu_read_unlock();
 		return -EINVAL;
 	}
 
-	return slave->dev->xfrmdev_ops->xdo_dev_state_add(xs);
+	err = slave->dev->xfrmdev_ops->xdo_dev_state_add(xs);
+	rcu_read_unlock();
+	return err;
 }
 
 /**
-- 
2.17.1

