Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 482B21E7B4F
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 13:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgE2LKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 07:10:49 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:39924 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725306AbgE2LKp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 07:10:45 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 5CF3F205CD;
        Fri, 29 May 2020 13:10:43 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id pQ6UF2M3Y-3w; Fri, 29 May 2020 13:10:42 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 78000205B5;
        Fri, 29 May 2020 13:10:42 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 29 May 2020 13:10:42 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 29 May
 2020 13:10:41 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 3B31D3180704;
 Fri, 29 May 2020 13:04:12 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 11/15] xfrm interface: fix oops when deleting a x-netns interface
Date:   Fri, 29 May 2020 13:04:04 +0200
Message-ID: <20200529110408.6349-12-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200529110408.6349-1-steffen.klassert@secunet.com>
References: <20200529110408.6349-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Here is the steps to reproduce the problem:
ip netns add foo
ip netns add bar
ip -n foo link add xfrmi0 type xfrm dev lo if_id 42
ip -n foo link set xfrmi0 netns bar
ip netns del foo
ip netns del bar

Which results to:
[  186.686395] general protection fault, probably for non-canonical address 0x6b6b6b6b6b6b6bd3: 0000 [#1] SMP PTI
[  186.687665] CPU: 7 PID: 232 Comm: kworker/u16:2 Not tainted 5.6.0+ #1
[  186.688430] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
[  186.689420] Workqueue: netns cleanup_net
[  186.689903] RIP: 0010:xfrmi_dev_uninit+0x1b/0x4b [xfrm_interface]
[  186.690657] Code: 44 f6 ff ff 31 c0 5b 5d 41 5c 41 5d 41 5e c3 48 8d 8f c0 08 00 00 8b 05 ce 14 00 00 48 8b 97 d0 08 00 00 48 8b 92 c0 0e 00 00 <48> 8b 14 c2 48 8b 02 48 85 c0 74 19 48 39 c1 75 0c 48 8b 87 c0 08
[  186.692838] RSP: 0018:ffffc900003b7d68 EFLAGS: 00010286
[  186.693435] RAX: 000000000000000d RBX: ffff8881b0f31000 RCX: ffff8881b0f318c0
[  186.694334] RDX: 6b6b6b6b6b6b6b6b RSI: 0000000000000246 RDI: ffff8881b0f31000
[  186.695190] RBP: ffffc900003b7df0 R08: ffff888236c07740 R09: 0000000000000040
[  186.696024] R10: ffffffff81fce1b8 R11: 0000000000000002 R12: ffffc900003b7d80
[  186.696859] R13: ffff8881edcc6a40 R14: ffff8881a1b6e780 R15: ffffffff81ed47c8
[  186.697738] FS:  0000000000000000(0000) GS:ffff888237dc0000(0000) knlGS:0000000000000000
[  186.698705] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  186.699408] CR2: 00007f2129e93148 CR3: 0000000001e0a000 CR4: 00000000000006e0
[  186.700221] Call Trace:
[  186.700508]  rollback_registered_many+0x32b/0x3fd
[  186.701058]  ? __rtnl_unlock+0x20/0x3d
[  186.701494]  ? arch_local_irq_save+0x11/0x17
[  186.702012]  unregister_netdevice_many+0x12/0x55
[  186.702594]  default_device_exit_batch+0x12b/0x150
[  186.703160]  ? prepare_to_wait_exclusive+0x60/0x60
[  186.703719]  cleanup_net+0x17d/0x234
[  186.704138]  process_one_work+0x196/0x2e8
[  186.704652]  worker_thread+0x1a4/0x249
[  186.705087]  ? cancel_delayed_work+0x92/0x92
[  186.705620]  kthread+0x105/0x10f
[  186.706000]  ? __kthread_bind_mask+0x57/0x57
[  186.706501]  ret_from_fork+0x35/0x40
[  186.706978] Modules linked in: xfrm_interface nfsv3 nfs_acl auth_rpcgss nfsv4 nfs lockd grace fscache sunrpc button parport_pc parport serio_raw evdev pcspkr loop ext4 crc16 mbcache jbd2 crc32c_generic 8139too ide_cd_mod cdrom ide_gd_mod ata_generic ata_piix libata scsi_mod piix psmouse i2c_piix4 ide_core 8139cp i2c_core mii floppy
[  186.710423] ---[ end trace 463bba18105537e5 ]---

The problem is that x-netns xfrm interface are not removed when the link
netns is removed. This causes later this oops when thoses interfaces are
removed.

Let's add a handler to remove all interfaces related to a netns when this
netns is removed.

Fixes: f203b76d7809 ("xfrm: Add virtual xfrm interfaces")
Reported-by: Christophe Gouault <christophe.gouault@6wind.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_interface.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 3361e3ac5714..1e115cbf21d3 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -750,7 +750,28 @@ static struct rtnl_link_ops xfrmi_link_ops __read_mostly = {
 	.get_link_net	= xfrmi_get_link_net,
 };
 
+static void __net_exit xfrmi_exit_batch_net(struct list_head *net_exit_list)
+{
+	struct net *net;
+	LIST_HEAD(list);
+
+	rtnl_lock();
+	list_for_each_entry(net, net_exit_list, exit_list) {
+		struct xfrmi_net *xfrmn = net_generic(net, xfrmi_net_id);
+		struct xfrm_if __rcu **xip;
+		struct xfrm_if *xi;
+
+		for (xip = &xfrmn->xfrmi[0];
+		     (xi = rtnl_dereference(*xip)) != NULL;
+		     xip = &xi->next)
+			unregister_netdevice_queue(xi->dev, &list);
+	}
+	unregister_netdevice_many(&list);
+	rtnl_unlock();
+}
+
 static struct pernet_operations xfrmi_net_ops = {
+	.exit_batch = xfrmi_exit_batch_net,
 	.id   = &xfrmi_net_id,
 	.size = sizeof(struct xfrmi_net),
 };
-- 
2.17.1

