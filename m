Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8B915D386
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 17:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbfGBPvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 11:51:47 -0400
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:40022 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726962AbfGBPvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 11:51:46 -0400
Received: from bretzel.dev.6wind.com (unknown [10.16.0.19])
        by proxy.6wind.com (Postfix) with ESMTPS id 36B4C2DD900;
        Tue,  2 Jul 2019 17:51:44 +0200 (CEST)
Received: from dichtel by bretzel.dev.6wind.com with local (Exim 4.89)
        (envelope-from <dichtel@bretzel.dev.6wind.com>)
        id 1hiL4K-0002z8-5H; Tue, 02 Jul 2019 17:51:44 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     steffen.klassert@secunet.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        Benedict Wong <benedictwong@google.com>,
        Shannon Nelson <shannon.nelson@oracle.com>,
        Antony Antony <antony@phenome.org>,
        Eyal Birger <eyal.birger@gmail.com>,
        Julien Floret <julien.floret@6wind.com>
Subject: [PATCH ipsec v2] xfrm interface: fix memory leak on creation
Date:   Tue,  2 Jul 2019 17:51:39 +0200
Message-Id: <20190702155139.11399-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following commands produce a backtrace and return an error but the xfrm
interface is created (in the wrong netns):
$ ip netns add foo
$ ip netns add bar
$ ip -n foo netns set bar 0
$ ip -n foo link add xfrmi0 link-netnsid 0 type xfrm dev lo if_id 23
RTNETLINK answers: Invalid argument
$ ip -n bar link ls xfrmi0
2: xfrmi0@lo: <NOARP,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/none 00:00:00:00:00:00 brd 00:00:00:00:00:00

Here is the backtrace:
[   79.879174] WARNING: CPU: 0 PID: 1178 at net/core/dev.c:8172 rollback_registered_many+0x86/0x3c1
[   79.880260] Modules linked in: xfrm_interface nfsv3 nfs_acl auth_rpcgss nfsv4 nfs lockd grace sunrpc fscache button parport_pc parport serio_raw evdev pcspkr loop ext4 crc16 mbcache jbd2 crc32c_generic ide_cd_mod ide_gd_mod cdrom ata_$
eneric ata_piix libata scsi_mod 8139too piix psmouse i2c_piix4 ide_core 8139cp mii i2c_core floppy
[   79.883698] CPU: 0 PID: 1178 Comm: ip Not tainted 5.2.0-rc6+ #106
[   79.884462] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
[   79.885447] RIP: 0010:rollback_registered_many+0x86/0x3c1
[   79.886120] Code: 01 e8 d7 7d c6 ff 0f 0b 48 8b 45 00 4c 8b 20 48 8d 58 90 49 83 ec 70 48 8d 7b 70 48 39 ef 74 44 8a 83 d0 04 00 00 84 c0 75 1f <0f> 0b e8 61 cd ff ff 48 b8 00 01 00 00 00 00 ad de 48 89 43 70 66
[   79.888667] RSP: 0018:ffffc900015ab740 EFLAGS: 00010246
[   79.889339] RAX: ffff8882353e5700 RBX: ffff8882353e56a0 RCX: ffff8882353e5710
[   79.890174] RDX: ffffc900015ab7e0 RSI: ffffc900015ab7e0 RDI: ffff8882353e5710
[   79.891029] RBP: ffffc900015ab7e0 R08: ffffc900015ab7e0 R09: ffffc900015ab7e0
[   79.891866] R10: ffffc900015ab7a0 R11: ffffffff82233fec R12: ffffc900015ab770
[   79.892728] R13: ffffffff81eb7ec0 R14: ffff88822ed6cf00 R15: 00000000ffffffea
[   79.893557] FS:  00007ff350f31740(0000) GS:ffff888237a00000(0000) knlGS:0000000000000000
[   79.894581] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   79.895317] CR2: 00000000006c8580 CR3: 000000022c272000 CR4: 00000000000006f0
[   79.896137] Call Trace:
[   79.896464]  unregister_netdevice_many+0x12/0x6c
[   79.896998]  __rtnl_newlink+0x6e2/0x73b
[   79.897446]  ? __kmalloc_node_track_caller+0x15e/0x185
[   79.898039]  ? pskb_expand_head+0x5f/0x1fe
[   79.898556]  ? stack_access_ok+0xd/0x2c
[   79.899009]  ? deref_stack_reg+0x12/0x20
[   79.899462]  ? stack_access_ok+0xd/0x2c
[   79.899927]  ? stack_access_ok+0xd/0x2c
[   79.900404]  ? __module_text_address+0x9/0x4f
[   79.900910]  ? is_bpf_text_address+0x5/0xc
[   79.901390]  ? kernel_text_address+0x67/0x7b
[   79.901884]  ? __kernel_text_address+0x1a/0x25
[   79.902397]  ? unwind_get_return_address+0x12/0x23
[   79.903122]  ? __cmpxchg_double_slab.isra.37+0x46/0x77
[   79.903772]  rtnl_newlink+0x43/0x56
[   79.904217]  rtnetlink_rcv_msg+0x200/0x24c

In fact, each time a xfrm interface was created, a netdev was allocated
by __rtnl_newlink()/rtnl_create_link() and then another one by
xfrmi_newlink()/xfrmi_create(). Only the second one was registered, it's
why the previous commands produce a backtrace: dev_change_net_namespace()
was called on a netdev with reg_state set to NETREG_UNINITIALIZED (the
first one).

CC: Lorenzo Colitti <lorenzo@google.com>
CC: Benedict Wong <benedictwong@google.com>
CC: Steffen Klassert <steffen.klassert@secunet.com>
CC: Shannon Nelson <shannon.nelson@oracle.com>
CC: Antony Antony <antony@phenome.org>
CC: Eyal Birger <eyal.birger@gmail.com>
Fixes: f203b76d7809 ("xfrm: Add virtual xfrm interfaces")
Reported-by: Julien Floret <julien.floret@6wind.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---

v1 -> v2:
 - fix typos in commit log

 net/xfrm/xfrm_interface.c | 98 +++++++++++----------------------------
 1 file changed, 28 insertions(+), 70 deletions(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index ad3a2555c517..7dbe0c608df5 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -133,7 +133,7 @@ static void xfrmi_dev_free(struct net_device *dev)
 	free_percpu(dev->tstats);
 }
 
-static int xfrmi_create2(struct net_device *dev)
+static int xfrmi_create(struct net_device *dev)
 {
 	struct xfrm_if *xi = netdev_priv(dev);
 	struct net *net = dev_net(dev);
@@ -156,54 +156,7 @@ static int xfrmi_create2(struct net_device *dev)
 	return err;
 }
 
-static struct xfrm_if *xfrmi_create(struct net *net, struct xfrm_if_parms *p)
-{
-	struct net_device *dev;
-	struct xfrm_if *xi;
-	char name[IFNAMSIZ];
-	int err;
-
-	if (p->name[0]) {
-		strlcpy(name, p->name, IFNAMSIZ);
-	} else {
-		err = -EINVAL;
-		goto failed;
-	}
-
-	dev = alloc_netdev(sizeof(*xi), name, NET_NAME_UNKNOWN, xfrmi_dev_setup);
-	if (!dev) {
-		err = -EAGAIN;
-		goto failed;
-	}
-
-	dev_net_set(dev, net);
-
-	xi = netdev_priv(dev);
-	xi->p = *p;
-	xi->net = net;
-	xi->dev = dev;
-	xi->phydev = dev_get_by_index(net, p->link);
-	if (!xi->phydev) {
-		err = -ENODEV;
-		goto failed_free;
-	}
-
-	err = xfrmi_create2(dev);
-	if (err < 0)
-		goto failed_dev_put;
-
-	return xi;
-
-failed_dev_put:
-	dev_put(xi->phydev);
-failed_free:
-	free_netdev(dev);
-failed:
-	return ERR_PTR(err);
-}
-
-static struct xfrm_if *xfrmi_locate(struct net *net, struct xfrm_if_parms *p,
-				   int create)
+static struct xfrm_if *xfrmi_locate(struct net *net, struct xfrm_if_parms *p)
 {
 	struct xfrm_if __rcu **xip;
 	struct xfrm_if *xi;
@@ -211,17 +164,11 @@ static struct xfrm_if *xfrmi_locate(struct net *net, struct xfrm_if_parms *p,
 
 	for (xip = &xfrmn->xfrmi[0];
 	     (xi = rtnl_dereference(*xip)) != NULL;
-	     xip = &xi->next) {
-		if (xi->p.if_id == p->if_id) {
-			if (create)
-				return ERR_PTR(-EEXIST);
-
+	     xip = &xi->next)
+		if (xi->p.if_id == p->if_id)
 			return xi;
-		}
-	}
-	if (!create)
-		return ERR_PTR(-ENODEV);
-	return xfrmi_create(net, p);
+
+	return NULL;
 }
 
 static void xfrmi_dev_uninit(struct net_device *dev)
@@ -686,21 +633,33 @@ static int xfrmi_newlink(struct net *src_net, struct net_device *dev,
 			struct netlink_ext_ack *extack)
 {
 	struct net *net = dev_net(dev);
-	struct xfrm_if_parms *p;
+	struct xfrm_if_parms p;
 	struct xfrm_if *xi;
+	int err;
 
-	xi = netdev_priv(dev);
-	p = &xi->p;
-
-	xfrmi_netlink_parms(data, p);
+	xfrmi_netlink_parms(data, &p);
 
 	if (!tb[IFLA_IFNAME])
 		return -EINVAL;
 
-	nla_strlcpy(p->name, tb[IFLA_IFNAME], IFNAMSIZ);
+	nla_strlcpy(p.name, tb[IFLA_IFNAME], IFNAMSIZ);
 
-	xi = xfrmi_locate(net, p, 1);
-	return PTR_ERR_OR_ZERO(xi);
+	xi = xfrmi_locate(net, &p);
+	if (xi)
+		return -EEXIST;
+
+	xi = netdev_priv(dev);
+	xi->p = p;
+	xi->net = net;
+	xi->dev = dev;
+	xi->phydev = dev_get_by_index(net, p.link);
+	if (!xi->phydev)
+		return -ENODEV;
+
+	err = xfrmi_create(dev);
+	if (err < 0)
+		dev_put(xi->phydev);
+	return err;
 }
 
 static void xfrmi_dellink(struct net_device *dev, struct list_head *head)
@@ -717,9 +676,8 @@ static int xfrmi_changelink(struct net_device *dev, struct nlattr *tb[],
 
 	xfrmi_netlink_parms(data, &xi->p);
 
-	xi = xfrmi_locate(net, &xi->p, 0);
-
-	if (IS_ERR_OR_NULL(xi)) {
+	xi = xfrmi_locate(net, &xi->p);
+	if (!xi) {
 		xi = netdev_priv(dev);
 	} else {
 		if (xi->dev != dev)
-- 
2.21.0

