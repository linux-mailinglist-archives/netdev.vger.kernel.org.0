Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE813BA21F
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 16:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbhGBO35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 10:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233069AbhGBO35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 10:29:57 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 334BEC061762
        for <netdev@vger.kernel.org>; Fri,  2 Jul 2021 07:27:25 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id s13so2562130plg.12
        for <netdev@vger.kernel.org>; Fri, 02 Jul 2021 07:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5c9yonRBpikN+A7jwgmhiRsocYAMP+mu2erUEYpEtGs=;
        b=sajdtdVWoa2Z4r8ijBO7Ldnv+JtO/hdY5my6Vt+xnEL0TKP+ril4eKdzsFOmqkhfUv
         UVM1HyYRs+vFqBSrBpUY9psp/OMav7N9Q5vB7sBUWEra06XY9KYCfk6i5N64Re68PtTP
         CGhWNqgJJq8snP/Sqt/Y23QKNDtbn+Mi1SOsiaUAwYYBOUDVxsEYn7UM23Q/rkppvU8L
         LE/7AsF7zTjUxMgnSpI/ovrfkyh6BL3w0k9WpIfx2N5XB8cOaZBgp4IdVpVAwl40okxS
         kq1b6+f8RJNsP/4ADdiLUtlHnutgHOU8/PLWoOGLvO7wJQXWfrqoxgZa/bjuwXyKZYUM
         d4yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5c9yonRBpikN+A7jwgmhiRsocYAMP+mu2erUEYpEtGs=;
        b=rHMVw6sVr9b8SjRaiGtPrVASX5CREpBogYZ5lxIyKvL1Nl6IdZUd2/iOEDffwmxcDv
         1HEqhJDyGBae6tYdHSogN9+ZbWjptJjutJcV3iMNNRK8RVibvwY4jofTGteOXNmCQ/iU
         QTjYDc8HK+wRSjjjnD20RwtI9PERwOm1ba/RbsEGvBxV5nLQEimyItM3pDfBtok6GiWu
         qApuygm0mfwpxorDLGOf9baSlkFjRgkh30cL2hR5tOO/u1cMuKOPgLjEzDvm3sJHFb65
         x2auOmJCKUXF7QYow/bTvBjIno564ld/ZpXQxTxJEM9E1Sk0IvsZeLpUY8+wGjaG1XSg
         Go5A==
X-Gm-Message-State: AOAM532Ivr+DumGBslPv6/iPwob3t0cbBBt/UsGSCXYPi8PVEYbEP2sJ
        wScBlNnXIfwLnj3kC3owWmA=
X-Google-Smtp-Source: ABdhPJyweG76uBYOJYrQh88/3auaWugmpGjNw3MTiddU2Bdwiq6UZn7UyD2uJhbxJtTXKQ5kHnauHQ==
X-Received: by 2002:a17:90b:1403:: with SMTP id jo3mr91045pjb.160.1625236044705;
        Fri, 02 Jul 2021 07:27:24 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id nr12sm12683747pjb.1.2021.07.02.07.27.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jul 2021 07:27:23 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, jarod@redhat.com,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 2/8] bonding: fix null dereference in bond_ipsec_add_sa()
Date:   Fri,  2 Jul 2021 14:26:42 +0000
Message-Id: <20210702142648.7677-3-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210702142648.7677-1-ap420073@gmail.com>
References: <20210702142648.7677-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If bond doesn't have real device, bond->curr_active_slave is null.
But bond_ipsec_add_sa() dereferences bond->curr_active_slave without
null checking.
So, null-ptr-deref would occur.

Test commands:
    ip link add bond0 type bond
    ip link set bond0 up
    ip x s add proto esp dst 14.1.1.1 src 15.1.1.1 spi \
0x07 mode transport reqid 0x07 replay-window 32 aead 'rfc4106(gcm(aes))' \
0x44434241343332312423222114131211f4f3f2f1 128 sel src 14.0.0.52/24 \
dst 14.0.0.70/24 proto tcp offload dev bond0 dir in

Splat looks like:
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 4 PID: 680 Comm: ip Not tainted 5.13.0-rc3+ #1168
RIP: 0010:bond_ipsec_add_sa+0xc4/0x2e0 [bonding]
Code: 85 21 02 00 00 4d 8b a6 48 0c 00 00 e8 75 58 44 ce 85 c0 0f 85 14
01 00 00 48 b8 00 00 00 00 00 fc ff df 4c 89 e2 48 c1 ea 03 <80> 3c 02
00 0f 85 fc 01 00 00 48 8d bb e0 02 00 00 4d 8b 2c 24 48
RSP: 0018:ffff88810946f508 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffff88810b4e8040 RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffffffff8fe34280 RDI: ffff888115abe100
RBP: ffff88810946f528 R08: 0000000000000003 R09: fffffbfff2287e11
R10: 0000000000000001 R11: ffff888115abe0c8 R12: 0000000000000000
R13: ffffffffc0aea9a0 R14: ffff88800d7d2000 R15: ffff88810b4e8330
FS:  00007efc5552e680(0000) GS:ffff888119c00000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055c2530dbf40 CR3: 0000000103056004 CR4: 00000000003706e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
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
[ ...]

Fixes: 18cb261afd7b ("bonding: support hardware encryption offload to slaves")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/bonding/bond_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index fd7b7f894917..e1009e169d42 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -411,6 +411,11 @@ static int bond_ipsec_add_sa(struct xfrm_state *xs)
 	rcu_read_lock();
 	bond = netdev_priv(bond_dev);
 	slave = rcu_dereference(bond->curr_active_slave);
+	if (!slave) {
+		rcu_read_unlock();
+		return -ENODEV;
+	}
+
 	xs->xso.real_dev = slave->dev;
 	bond->xs = xs;
 
-- 
2.17.1

