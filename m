Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9103224999
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 09:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgGRHNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 03:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgGRHNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 03:13:20 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E73EBC0619D2
        for <netdev@vger.kernel.org>; Sat, 18 Jul 2020 00:13:19 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id a24so6446020pfc.10
        for <netdev@vger.kernel.org>; Sat, 18 Jul 2020 00:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ui4CdngTaJdX3BVEL2dnGzIV+F0HAqnJnno19cA/JhE=;
        b=WUMW5r04fpp0iGUJc8xGLrKW25abrAvlZ7E2onuOykbqcpViTmVYzx3U8N7OAwSPch
         cgVHsuTp9gvhI3Cr9d/cBUGlsJ1YV2SPee+B58scf6oIH81ZgZexKJZyjTbiM1bS1h27
         8cQYPl8QWc8w8za0wXVo+7BXkP9xOiIi4V05LOYysoUCiKpgq470fQDbdFL6zkij7iru
         SC5vaOEIgF22zoz14pRHkaSWoo+HqpG46IIUIvDwyu5gdVIt3dknZs6zsJJmtZ8KmaKg
         L8D9+BCdo4Wm9h8JCw44O5Iez4YZ5zCnrgsrYoR+nQvHxTjSf8h5/XnE9lq4kY6Fcgo1
         A1fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ui4CdngTaJdX3BVEL2dnGzIV+F0HAqnJnno19cA/JhE=;
        b=hSSjXa7bxYibrrzXz/RR6gENpD4cf3u+xGyOFRhGzK1x5caLFfjEJcIhK5ft/hbGJ1
         vK3cTBPUhdoPec41UTHhCBMvZZJxOMm/AVl99Tqe+A2UdIaOhvOsw2bb+LxjCprn0Qm6
         sn3WVun2iTK7fct2JBgemVck2NIoQTK68Tl/YWLpf9B0ivZDqkj19Qp7KoMROI4T8Y45
         L/sbQmQyqtJMbu66hKRg7brjxZMzqYIpeBirKQHbuartxp9hQJRFzAVJPLsNG22MICKl
         EoJ2g4FiunZJVILbUm1c4KMSRBjnFH2s5jaXc0k80b+oucoZbz7+E4mi9z2puwBa2OIe
         tt0A==
X-Gm-Message-State: AOAM530Z3dmj9WvxxsSpVzAAtL/ZQswKox9O2626so/rbJ2PU9K7EfEL
        CyqQDTaGtWJQ+yVF7jy+dZjRhPeGPcI=
X-Google-Smtp-Source: ABdhPJzgwTDqRuTXnooWdfZXpLZ5lAYzWtozf/1l51kb7nZFWLsRx3hqzJcV9jI2ivsbJf3z5qQaRw==
X-Received: by 2002:a62:a217:: with SMTP id m23mr10993086pff.291.1595056399242;
        Sat, 18 Jul 2020 00:13:19 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id s6sm9627008pfd.20.2020.07.18.00.13.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2020 00:13:18 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, netdev@vger.kernel.org
Cc:     amwang@redhat.com, ap420073@gmail.com
Subject: [PATCH net] bonding: check error value of register_netdevice() immediately
Date:   Sat, 18 Jul 2020 07:13:06 +0000
Message-Id: <20200718071306.9734-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If register_netdevice() is failed, net_device should not be used
because variables are uninitialized or freed.
So, the routine should be stopped immediately.
But, bond_create() doesn't check return value of register_netdevice()
immediately. That will result in a panic because of using uninitialized
or freed memory.

Test commands:
    modprobe netdev-notifier-error-inject
    echo -22 > /sys/kernel/debug/notifier-error-inject/netdev/\
actions/NETDEV_REGISTER/error
    modprobe bonding max_bonds=3

Splat looks like:
[  375.028492][  T193] general protection fault, probably for non-canonical address 0x6b6b6b6b6b6b6b6b: 0000 [#1] SMP DEBUG_PAGEALLOC PTI
[  375.033207][  T193] CPU: 2 PID: 193 Comm: kworker/2:2 Not tainted 5.8.0-rc4+ #645
[  375.036068][  T193] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
[  375.039673][  T193] Workqueue: events linkwatch_event
[  375.041557][  T193] RIP: 0010:dev_activate+0x4a/0x340
[  375.043381][  T193] Code: 40 a8 04 0f 85 db 00 00 00 8b 83 08 04 00 00 85 c0 0f 84 0d 01 00 00 31 d2 89 d0 48 8d 04 40 48 c1 e0 07 48 03 83 00 04 00 00 <48> 8b 48 10 f6 41 10 01 75 08 f0 80 a1 a0 01 00 00 fd 48 89 48 08
[  375.050267][  T193] RSP: 0018:ffff9f8facfcfdd8 EFLAGS: 00010202
[  375.052410][  T193] RAX: 6b6b6b6b6b6b6b6b RBX: ffff9f8fae6ea000 RCX: 0000000000000006
[  375.055178][  T193] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff9f8fae6ea000
[  375.057762][  T193] RBP: ffff9f8fae6ea000 R08: 0000000000000000 R09: 0000000000000000
[  375.059810][  T193] R10: 0000000000000001 R11: 0000000000000000 R12: ffff9f8facfcfe08
[  375.061892][  T193] R13: ffffffff883587e0 R14: 0000000000000000 R15: ffff9f8fae6ea580
[  375.063931][  T193] FS:  0000000000000000(0000) GS:ffff9f8fbae00000(0000) knlGS:0000000000000000
[  375.066239][  T193] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  375.067841][  T193] CR2: 00007f2f542167a0 CR3: 000000012cee6002 CR4: 00000000003606e0
[  375.069657][  T193] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  375.071471][  T193] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  375.073269][  T193] Call Trace:
[  375.074005][  T193]  linkwatch_do_dev+0x4d/0x50
[  375.075052][  T193]  __linkwatch_run_queue+0x10b/0x200
[  375.076244][  T193]  linkwatch_event+0x21/0x30
[  375.077274][  T193]  process_one_work+0x252/0x600
[  375.078379][  T193]  ? process_one_work+0x600/0x600
[  375.079518][  T193]  worker_thread+0x3c/0x380
[  375.080534][  T193]  ? process_one_work+0x600/0x600
[  375.081668][  T193]  kthread+0x139/0x150
[  375.082567][  T193]  ? kthread_park+0x90/0x90
[  375.083567][  T193]  ret_from_fork+0x22/0x30

Fixes: 9e2e61fbf8ad ("bonding: fix potential deadlock in bond_uninit()")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/bonding/bond_main.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 004919aea5fb..f88cb097b022 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -5053,15 +5053,19 @@ int bond_create(struct net *net, const char *name)
 	bond_dev->rtnl_link_ops = &bond_link_ops;
 
 	res = register_netdevice(bond_dev);
+	if (res < 0) {
+		free_netdev(bond_dev);
+		rtnl_unlock();
+
+		return res;
+	}
 
 	netif_carrier_off(bond_dev);
 
 	bond_work_init_all(bond);
 
 	rtnl_unlock();
-	if (res < 0)
-		free_netdev(bond_dev);
-	return res;
+	return 0;
 }
 
 static int __net_init bond_net_init(struct net *net)
-- 
2.17.1

