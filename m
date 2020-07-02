Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD067212AD6
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 19:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgGBRI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 13:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbgGBRI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 13:08:27 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A290AC08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 10:08:26 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x3so7261780pfo.9
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 10:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=wBFsGN8RtmTi+aEQfpCs5NO8zCSZYJGZ0idU3csl0aY=;
        b=lWUMagdp66bYvS8nbTglaNYho1x/n1m/g+L3YpIDOa50LQ7MepVCic8m2XLR72TLk7
         g3phNjmWwQ5n9iocDFZpRsTqsXuTeC8/n3kgdszlucrD7fAkw8KRNLeExKY29l2BlV8B
         IEy+crXY/eFcnIbQpRnkipw79kWZ+GBar4CIVddINWCWjAiu3bhcylKCRh2bZF9qEZug
         ZyN6N+w+ln01gx/uaPkjzNrPAJdJxZjTNZEoKne8HiRlPewAweoMSeDyHg4QhzwK2sHd
         ST4n+Uqac757vLurqFRBUyWMHG76WaaodTqB399fvDE4M6kJF8r+F/nIYG0/beQvhMoi
         BQYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wBFsGN8RtmTi+aEQfpCs5NO8zCSZYJGZ0idU3csl0aY=;
        b=nJ9pDVIWyjd5B3UI7w0FxQqHIyr4LiddOJ7b7lytDPLSmtJipB4P6XZ99Ud5gJIcWL
         jxrPuwo8rRlZNJ2HpOzbEE6ClOQMIQk4VA3Z+nvoGrhQurk2wphVpVxZ2Nf8p5oS4Bhc
         A99lkMxX3PPXe0sFAg6vkcIQ65oFhwKgEoV1+HO4L3A6D585qM7cMUdV29cN9zYaxdNs
         C8Po2LAujsIrODHTXPENMUAzZMwoHxJEjWLEeA4zUBNkonLQJCMQouv4F0RVAF95yvm5
         KUeKImd+FaIKnjKSM6L94jImnuFkrfig7caWHBWB58qION2gHFKLhfbgQzd5tObiHn5J
         VtLg==
X-Gm-Message-State: AOAM532gD94pxarq/7UA61VzGrp3KU7/mjnhWlJhXMbGroMxrTxHdgHM
        D8yD77Lv5ei1xsfc6CNo4Nk=
X-Google-Smtp-Source: ABdhPJw8chwzA9QYvREiD7gSOqygo55L1+ww7wc2bCx5PK083wIJhwHOryz0lWc7phqY+hrME+uysQ==
X-Received: by 2002:a63:b956:: with SMTP id v22mr25109206pgo.242.1593709706084;
        Thu, 02 Jul 2020 10:08:26 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id e16sm9392889pff.180.2020.07.02.10.08.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 10:08:24 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, subashab@codeaurora.org,
        stranche@codeaurora.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 1/2] net: rmnet: fix lower interface leak
Date:   Thu,  2 Jul 2020 17:08:18 +0000
Message-Id: <20200702170818.10565-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two types of the lower interface of rmnet that are VND
and BRIDGE.
Each lower interface can have only one type either VND or BRIDGE.
But, there is a case, which uses both lower interface types.
Due to this unexpected behavior, lower interface leak occurs.

Test commands:
    ip link add dummy0 type dummy
    ip link add dummy1 type dummy
    ip link add rmnet0 link dummy0 type rmnet mux_id 1
    ip link set dummy1 master rmnet0
    ip link add rmnet1 link dummy1 type rmnet mux_id 2
    ip link del rmnet0

The dummy1 was attached as BRIDGE interface of rmnet0.
Then, it also was attached as VND interface of rmnet1.
This is unexpected behavior and there is no code for handling this case.
So that below splat occurs when the rmnet0 interface is deleted.

Splat looks like:
[   53.254112][    C1] WARNING: CPU: 1 PID: 1192 at net/core/dev.c:8992 rollback_registered_many+0x986/0xcf0
[   53.254117][    C1] Modules linked in: rmnet dummy openvswitch nsh nf_conncount nf_nat nf_conntrack nf_defrag_ipv6 nfx
[   53.254182][    C1] CPU: 1 PID: 1192 Comm: ip Not tainted 5.8.0-rc1+ #620
[   53.254188][    C1] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   53.254192][    C1] RIP: 0010:rollback_registered_many+0x986/0xcf0
[   53.254200][    C1] Code: 41 8b 4e cc 45 31 c0 31 d2 4c 89 ee 48 89 df e8 e0 47 ff ff 85 c0 0f 84 cd fc ff ff 0f 0b e5
[   53.254205][    C1] RSP: 0018:ffff888050a5f2e0 EFLAGS: 00010287
[   53.254214][    C1] RAX: ffff88805756d658 RBX: ffff88804d99c000 RCX: ffffffff8329d323
[   53.254219][    C1] RDX: 1ffffffff0be6410 RSI: 0000000000000008 RDI: ffffffff85f32080
[   53.254223][    C1] RBP: dffffc0000000000 R08: fffffbfff0be6411 R09: fffffbfff0be6411
[   53.254228][    C1] R10: ffffffff85f32087 R11: 0000000000000001 R12: ffff888050a5f480
[   53.254233][    C1] R13: ffff88804d99c0b8 R14: ffff888050a5f400 R15: ffff8880548ebe40
[   53.254238][    C1] FS:  00007f6b86b370c0(0000) GS:ffff88806c200000(0000) knlGS:0000000000000000
[   53.254243][    C1] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   53.254248][    C1] CR2: 0000562c62438758 CR3: 000000003f600005 CR4: 00000000000606e0
[   53.254253][    C1] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   53.254257][    C1] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   53.254261][    C1] Call Trace:
[   53.254266][    C1]  ? lockdep_hardirqs_on_prepare+0x379/0x540
[   53.254270][    C1]  ? netif_set_real_num_tx_queues+0x780/0x780
[   53.254275][    C1]  ? rmnet_unregister_real_device+0x56/0x90 [rmnet]
[   53.254279][    C1]  ? __kasan_slab_free+0x126/0x150
[   53.254283][    C1]  ? kfree+0xdc/0x320
[   53.254288][    C1]  ? rmnet_unregister_real_device+0x56/0x90 [rmnet]
[   53.254293][    C1]  unregister_netdevice_many.part.135+0x13/0x1b0
[   53.254297][    C1]  rtnl_delete_link+0xbc/0x100
[   53.254301][    C1]  ? rtnl_af_register+0xc0/0xc0
[   53.254305][    C1]  rtnl_dellink+0x2dc/0x840
[   53.254309][    C1]  ? find_held_lock+0x39/0x1d0
[   53.254314][    C1]  ? valid_fdb_dump_strict+0x620/0x620
[   53.254318][    C1]  ? rtnetlink_rcv_msg+0x457/0x890
[   53.254322][    C1]  ? lock_contended+0xd20/0xd20
[   53.254326][    C1]  rtnetlink_rcv_msg+0x4a8/0x890
[ ... ]
[   73.813696][ T1192] unregister_netdevice: waiting for rmnet0 to become free. Usage count = 1

Fixes: 037f9cdf72fb ("net: rmnet: use upper/lower device infrastructure")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 .../ethernet/qualcomm/rmnet/rmnet_config.c    | 21 +++++++++++--------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
index 40efe60eff8d..2c8c252b7b97 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -47,15 +47,23 @@ static int rmnet_unregister_real_device(struct net_device *real_dev)
 	return 0;
 }
 
-static int rmnet_register_real_device(struct net_device *real_dev)
+static int rmnet_register_real_device(struct net_device *real_dev,
+				      struct netlink_ext_ack *extack)
 {
 	struct rmnet_port *port;
 	int rc, entry;
 
 	ASSERT_RTNL();
 
-	if (rmnet_is_real_dev_registered(real_dev))
+	if (rmnet_is_real_dev_registered(real_dev)) {
+		port = rmnet_get_port_rtnl(real_dev);
+		if (port->rmnet_mode != RMNET_EPMODE_VND) {
+			NL_SET_ERR_MSG_MOD(extack, "bridge device already exists");
+			return -EINVAL;
+		}
+
 		return 0;
+	}
 
 	port = kzalloc(sizeof(*port), GFP_KERNEL);
 	if (!port)
@@ -133,7 +141,7 @@ static int rmnet_newlink(struct net *src_net, struct net_device *dev,
 
 	mux_id = nla_get_u16(data[IFLA_RMNET_MUX_ID]);
 
-	err = rmnet_register_real_device(real_dev);
+	err = rmnet_register_real_device(real_dev, extack);
 	if (err)
 		goto err0;
 
@@ -421,11 +429,6 @@ int rmnet_add_bridge(struct net_device *rmnet_dev,
 		return -EINVAL;
 	}
 
-	if (port->rmnet_mode != RMNET_EPMODE_VND) {
-		NL_SET_ERR_MSG_MOD(extack, "bridge device already exists");
-		return -EINVAL;
-	}
-
 	if (rmnet_is_real_dev_registered(slave_dev)) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "slave cannot be another rmnet dev");
@@ -433,7 +436,7 @@ int rmnet_add_bridge(struct net_device *rmnet_dev,
 		return -EBUSY;
 	}
 
-	err = rmnet_register_real_device(slave_dev);
+	err = rmnet_register_real_device(slave_dev, extack);
 	if (err)
 		return -EBUSY;
 
-- 
2.17.1

