Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0F1468DAD
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733213AbfGOOAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:00:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:42506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730253AbfGOOAo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:00:44 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D395B212F5;
        Mon, 15 Jul 2019 14:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199243;
        bh=i4Fr5DmmIIgN53QY+lTYkRosT5StZK7kC3TGBD1CP7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uRdSDmS6E/zNK96KsO+Ps9pOD7pPHcBlMSW5V2gq8nMjhuvIOab0avilYhyjNQ47C
         NE81x4p5Ki7k6N7RKD0UjjoodI4A1wt2tZKZq5yTR/7K626wFqTSUWoAZJUzQT/gNE
         EhV74zXxaSgt/w/FVwNs8EeUYSyLHiIPUQqJyl4s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Taehee Yoo <ap420073@gmail.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 220/249] vxlan: do not destroy fdb if register_netdevice() is failed
Date:   Mon, 15 Jul 2019 09:46:25 -0400
Message-Id: <20190715134655.4076-220-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 7c31e54aeee517d1318dfc0bde9fa7de75893dc6 ]

__vxlan_dev_create() destroys FDB using specific pointer which indicates
a fdb when error occurs.
But that pointer should not be used when register_netdevice() fails because
register_netdevice() internally destroys fdb when error occurs.

This patch makes vxlan_fdb_create() to do not link fdb entry to vxlan dev
internally.
Instead, a new function vxlan_fdb_insert() is added to link fdb to vxlan
dev.

vxlan_fdb_insert() is called after calling register_netdevice().
This routine can avoid situation that ->ndo_uninit() destroys fdb entry
in error path of register_netdevice().
Hence, error path of __vxlan_dev_create() routine can have an opportunity
to destroy default fdb entry by hand.

Test command
    ip link add bonding_masters type vxlan id 0 group 239.1.1.1 \
	    dev enp0s9 dstport 4789

Splat looks like:
[  213.392816] kasan: GPF could be caused by NULL-ptr deref or user memory access
[  213.401257] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
[  213.402178] CPU: 0 PID: 1414 Comm: ip Not tainted 5.2.0-rc5+ #256
[  213.402178] RIP: 0010:vxlan_fdb_destroy+0x120/0x220 [vxlan]
[  213.402178] Code: df 48 8b 2b 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 06 01 00 00 4c 8b 63 08 48 b8 00 00 00 00 00 fc d
[  213.402178] RSP: 0018:ffff88810cb9f0a0 EFLAGS: 00010202
[  213.402178] RAX: dffffc0000000000 RBX: ffff888101d4a8c8 RCX: 0000000000000000
[  213.402178] RDX: 1bd5a00000000040 RSI: ffff888101d4a8c8 RDI: ffff888101d4a8d0
[  213.402178] RBP: 0000000000000000 R08: fffffbfff22b72d9 R09: 0000000000000000
[  213.402178] R10: 00000000ffffffef R11: 0000000000000000 R12: dead000000000200
[  213.402178] R13: ffff88810cb9f1f8 R14: ffff88810efccda0 R15: ffff88810efccda0
[  213.402178] FS:  00007f7f6621a0c0(0000) GS:ffff88811b000000(0000) knlGS:0000000000000000
[  213.402178] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  213.402178] CR2: 000055746f0807d0 CR3: 00000001123e0000 CR4: 00000000001006f0
[  213.402178] Call Trace:
[  213.402178]  __vxlan_dev_create+0x3a9/0x7d0 [vxlan]
[  213.402178]  ? vxlan_changelink+0x740/0x740 [vxlan]
[  213.402178]  ? rcu_read_unlock+0x60/0x60 [vxlan]
[  213.402178]  ? __kasan_kmalloc.constprop.3+0xa0/0xd0
[  213.402178]  vxlan_newlink+0x8d/0xc0 [vxlan]
[  213.402178]  ? __vxlan_dev_create+0x7d0/0x7d0 [vxlan]
[  213.554119]  ? __netlink_ns_capable+0xc3/0xf0
[  213.554119]  __rtnl_newlink+0xb75/0x1180
[  213.554119]  ? rtnl_link_unregister+0x230/0x230
[ ... ]

Fixes: 0241b836732f ("vxlan: fix default fdb entry netlink notify ordering during netdev create")
Suggested-by: Roopa Prabhu <roopa@cumulusnetworks.com>
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Acked-by: Roopa Prabhu <roopa@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan.c | 37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 083f3f0bf37f..b4283f52a09d 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -804,6 +804,14 @@ static struct vxlan_fdb *vxlan_fdb_alloc(struct vxlan_dev *vxlan,
 	return f;
 }
 
+static void vxlan_fdb_insert(struct vxlan_dev *vxlan, const u8 *mac,
+			     __be32 src_vni, struct vxlan_fdb *f)
+{
+	++vxlan->addrcnt;
+	hlist_add_head_rcu(&f->hlist,
+			   vxlan_fdb_head(vxlan, mac, src_vni));
+}
+
 static int vxlan_fdb_create(struct vxlan_dev *vxlan,
 			    const u8 *mac, union vxlan_addr *ip,
 			    __u16 state, __be16 port, __be32 src_vni,
@@ -829,18 +837,13 @@ static int vxlan_fdb_create(struct vxlan_dev *vxlan,
 		return rc;
 	}
 
-	++vxlan->addrcnt;
-	hlist_add_head_rcu(&f->hlist,
-			   vxlan_fdb_head(vxlan, mac, src_vni));
-
 	*fdb = f;
 
 	return 0;
 }
 
-static void vxlan_fdb_free(struct rcu_head *head)
+static void __vxlan_fdb_free(struct vxlan_fdb *f)
 {
-	struct vxlan_fdb *f = container_of(head, struct vxlan_fdb, rcu);
 	struct vxlan_rdst *rd, *nd;
 
 	list_for_each_entry_safe(rd, nd, &f->remotes, list) {
@@ -850,6 +853,13 @@ static void vxlan_fdb_free(struct rcu_head *head)
 	kfree(f);
 }
 
+static void vxlan_fdb_free(struct rcu_head *head)
+{
+	struct vxlan_fdb *f = container_of(head, struct vxlan_fdb, rcu);
+
+	__vxlan_fdb_free(f);
+}
+
 static void vxlan_fdb_destroy(struct vxlan_dev *vxlan, struct vxlan_fdb *f,
 			      bool do_notify, bool swdev_notify)
 {
@@ -977,6 +987,7 @@ static int vxlan_fdb_update_create(struct vxlan_dev *vxlan,
 	if (rc < 0)
 		return rc;
 
+	vxlan_fdb_insert(vxlan, mac, src_vni, f);
 	rc = vxlan_fdb_notify(vxlan, f, first_remote_rtnl(f), RTM_NEWNEIGH,
 			      swdev_notify, extack);
 	if (rc)
@@ -3571,12 +3582,17 @@ static int __vxlan_dev_create(struct net *net, struct net_device *dev,
 	if (err)
 		goto errout;
 
-	/* notify default fdb entry */
 	if (f) {
+		vxlan_fdb_insert(vxlan, all_zeros_mac,
+				 vxlan->default_dst.remote_vni, f);
+
+		/* notify default fdb entry */
 		err = vxlan_fdb_notify(vxlan, f, first_remote_rtnl(f),
 				       RTM_NEWNEIGH, true, extack);
-		if (err)
-			goto errout;
+		if (err) {
+			vxlan_fdb_destroy(vxlan, f, false, false);
+			goto unregister;
+		}
 	}
 
 	list_add(&vxlan->next, &vn->vxlan_list);
@@ -3588,7 +3604,8 @@ static int __vxlan_dev_create(struct net *net, struct net_device *dev,
 	 * destroy the entry by hand here.
 	 */
 	if (f)
-		vxlan_fdb_destroy(vxlan, f, false, false);
+		__vxlan_fdb_free(f);
+unregister:
 	if (unregister)
 		unregister_netdevice(dev);
 	return err;
-- 
2.20.1

