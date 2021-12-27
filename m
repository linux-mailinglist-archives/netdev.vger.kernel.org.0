Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 735434803A6
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 20:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbhL0TE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 14:04:29 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39650 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232158AbhL0TEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 14:04:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBAF16117C;
        Mon, 27 Dec 2021 19:04:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CCE8C36AEF;
        Mon, 27 Dec 2021 19:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640631864;
        bh=S0D5ppS/ebuk5l/JaItyCx/IasEWVfqc00pxAA1Olac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NxTiycHJ5giykdfcctX4h0RqFklqmYAsIHjE77w1obSEVFLeFZID3fNh4dUGejO14
         t7YKptJFQNf4MPa9SHdux6gImX4uVI90sZeU/5cXG56gzX566wSFf6YDGsUC/iUiB+
         VqIxOdypEFMHqsuryrhY0dhzCn2+HXKqRlLzrhj3rg9PLoJEJROSFBDCYasUlyiUgV
         ixU5komSKuGMiOq8j7FeXs3TIN7s88t4qP3YAblhBd1qvYn5BGcwqumVMFubbJt5ET
         stCfFnWA5zCkGKdlKtymY6mHjvCSBCZ9i21K44etJQOTlDGXhWdT4bHRx4gzHx3UyS
         B/+EDtKLkeZ4g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     George Kennedy <george.kennedy@oracle.com>,
        syzkaller <syzkaller@googlegroups.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 16/26] tun: avoid double free in tun_free_netdev
Date:   Mon, 27 Dec 2021 14:03:17 -0500
Message-Id: <20211227190327.1042326-16-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227190327.1042326-1-sashal@kernel.org>
References: <20211227190327.1042326-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: George Kennedy <george.kennedy@oracle.com>

[ Upstream commit 158b515f703e75e7d68289bf4d98c664e1d632df ]

Avoid double free in tun_free_netdev() by moving the
dev->tstats and tun->security allocs to a new ndo_init routine
(tun_net_init()) that will be called by register_netdevice().
ndo_init is paired with the desctructor (tun_free_netdev()),
so if there's an error in register_netdevice() the destructor
will handle the frees.

BUG: KASAN: double-free or invalid-free in selinux_tun_dev_free_security+0x1a/0x20 security/selinux/hooks.c:5605

CPU: 0 PID: 25750 Comm: syz-executor416 Not tainted 5.16.0-rc2-syzk #1
Hardware name: Red Hat KVM, BIOS
Call Trace:
<TASK>
__dump_stack lib/dump_stack.c:88 [inline]
dump_stack_lvl+0x89/0xb5 lib/dump_stack.c:106
print_address_description.constprop.9+0x28/0x160 mm/kasan/report.c:247
kasan_report_invalid_free+0x55/0x80 mm/kasan/report.c:372
____kasan_slab_free mm/kasan/common.c:346 [inline]
__kasan_slab_free+0x107/0x120 mm/kasan/common.c:374
kasan_slab_free include/linux/kasan.h:235 [inline]
slab_free_hook mm/slub.c:1723 [inline]
slab_free_freelist_hook mm/slub.c:1749 [inline]
slab_free mm/slub.c:3513 [inline]
kfree+0xac/0x2d0 mm/slub.c:4561
selinux_tun_dev_free_security+0x1a/0x20 security/selinux/hooks.c:5605
security_tun_dev_free_security+0x4f/0x90 security/security.c:2342
tun_free_netdev+0xe6/0x150 drivers/net/tun.c:2215
netdev_run_todo+0x4df/0x840 net/core/dev.c:10627
rtnl_unlock+0x13/0x20 net/core/rtnetlink.c:112
__tun_chr_ioctl+0x80c/0x2870 drivers/net/tun.c:3302
tun_chr_ioctl+0x2f/0x40 drivers/net/tun.c:3311
vfs_ioctl fs/ioctl.c:51 [inline]
__do_sys_ioctl fs/ioctl.c:874 [inline]
__se_sys_ioctl fs/ioctl.c:860 [inline]
__x64_sys_ioctl+0x19d/0x220 fs/ioctl.c:860
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x3a/0x80 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x44/0xae

Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: George Kennedy <george.kennedy@oracle.com>
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/r/1639679132-19884-1-git-send-email-george.kennedy@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 115 ++++++++++++++++++++++++----------------------
 1 file changed, 59 insertions(+), 56 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 1572878c34031..45a67e72a02c6 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -209,6 +209,9 @@ struct tun_struct {
 	struct tun_prog __rcu *steering_prog;
 	struct tun_prog __rcu *filter_prog;
 	struct ethtool_link_ksettings link_ksettings;
+	/* init args */
+	struct file *file;
+	struct ifreq *ifr;
 };
 
 struct veth {
@@ -216,6 +219,9 @@ struct veth {
 	__be16 h_vlan_TCI;
 };
 
+static void tun_flow_init(struct tun_struct *tun);
+static void tun_flow_uninit(struct tun_struct *tun);
+
 static int tun_napi_receive(struct napi_struct *napi, int budget)
 {
 	struct tun_file *tfile = container_of(napi, struct tun_file, napi);
@@ -953,6 +959,49 @@ static int check_filter(struct tap_filter *filter, const struct sk_buff *skb)
 
 static const struct ethtool_ops tun_ethtool_ops;
 
+static int tun_net_init(struct net_device *dev)
+{
+	struct tun_struct *tun = netdev_priv(dev);
+	struct ifreq *ifr = tun->ifr;
+	int err;
+
+	dev->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
+	if (!dev->tstats)
+		return -ENOMEM;
+
+	spin_lock_init(&tun->lock);
+
+	err = security_tun_dev_alloc_security(&tun->security);
+	if (err < 0) {
+		free_percpu(dev->tstats);
+		return err;
+	}
+
+	tun_flow_init(tun);
+
+	dev->hw_features = NETIF_F_SG | NETIF_F_FRAGLIST |
+			   TUN_USER_FEATURES | NETIF_F_HW_VLAN_CTAG_TX |
+			   NETIF_F_HW_VLAN_STAG_TX;
+	dev->features = dev->hw_features | NETIF_F_LLTX;
+	dev->vlan_features = dev->features &
+			     ~(NETIF_F_HW_VLAN_CTAG_TX |
+			       NETIF_F_HW_VLAN_STAG_TX);
+
+	tun->flags = (tun->flags & ~TUN_FEATURES) |
+		      (ifr->ifr_flags & TUN_FEATURES);
+
+	INIT_LIST_HEAD(&tun->disabled);
+	err = tun_attach(tun, tun->file, false, ifr->ifr_flags & IFF_NAPI,
+			 ifr->ifr_flags & IFF_NAPI_FRAGS, false);
+	if (err < 0) {
+		tun_flow_uninit(tun);
+		security_tun_dev_free_security(tun->security);
+		free_percpu(dev->tstats);
+		return err;
+	}
+	return 0;
+}
+
 /* Net device detach from fd. */
 static void tun_net_uninit(struct net_device *dev)
 {
@@ -1169,6 +1218,7 @@ static int tun_net_change_carrier(struct net_device *dev, bool new_carrier)
 }
 
 static const struct net_device_ops tun_netdev_ops = {
+	.ndo_init		= tun_net_init,
 	.ndo_uninit		= tun_net_uninit,
 	.ndo_open		= tun_net_open,
 	.ndo_stop		= tun_net_close,
@@ -1252,6 +1302,7 @@ static int tun_xdp_tx(struct net_device *dev, struct xdp_buff *xdp)
 }
 
 static const struct net_device_ops tap_netdev_ops = {
+	.ndo_init		= tun_net_init,
 	.ndo_uninit		= tun_net_uninit,
 	.ndo_open		= tun_net_open,
 	.ndo_stop		= tun_net_close,
@@ -1292,7 +1343,7 @@ static void tun_flow_uninit(struct tun_struct *tun)
 #define MAX_MTU 65535
 
 /* Initialize net device. */
-static void tun_net_init(struct net_device *dev)
+static void tun_net_initialize(struct net_device *dev)
 {
 	struct tun_struct *tun = netdev_priv(dev);
 
@@ -2206,11 +2257,6 @@ static void tun_free_netdev(struct net_device *dev)
 	BUG_ON(!(list_empty(&tun->disabled)));
 
 	free_percpu(dev->tstats);
-	/* We clear tstats so that tun_set_iff() can tell if
-	 * tun_free_netdev() has been called from register_netdevice().
-	 */
-	dev->tstats = NULL;
-
 	tun_flow_uninit(tun);
 	security_tun_dev_free_security(tun->security);
 	__tun_set_ebpf(tun, &tun->steering_prog, NULL);
@@ -2716,41 +2762,16 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 		tun->rx_batched = 0;
 		RCU_INIT_POINTER(tun->steering_prog, NULL);
 
-		dev->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
-		if (!dev->tstats) {
-			err = -ENOMEM;
-			goto err_free_dev;
-		}
-
-		spin_lock_init(&tun->lock);
-
-		err = security_tun_dev_alloc_security(&tun->security);
-		if (err < 0)
-			goto err_free_stat;
-
-		tun_net_init(dev);
-		tun_flow_init(tun);
+		tun->ifr = ifr;
+		tun->file = file;
 
-		dev->hw_features = NETIF_F_SG | NETIF_F_FRAGLIST |
-				   TUN_USER_FEATURES | NETIF_F_HW_VLAN_CTAG_TX |
-				   NETIF_F_HW_VLAN_STAG_TX;
-		dev->features = dev->hw_features | NETIF_F_LLTX;
-		dev->vlan_features = dev->features &
-				     ~(NETIF_F_HW_VLAN_CTAG_TX |
-				       NETIF_F_HW_VLAN_STAG_TX);
-
-		tun->flags = (tun->flags & ~TUN_FEATURES) |
-			      (ifr->ifr_flags & TUN_FEATURES);
-
-		INIT_LIST_HEAD(&tun->disabled);
-		err = tun_attach(tun, file, false, ifr->ifr_flags & IFF_NAPI,
-				 ifr->ifr_flags & IFF_NAPI_FRAGS, false);
-		if (err < 0)
-			goto err_free_flow;
+		tun_net_initialize(dev);
 
 		err = register_netdevice(tun->dev);
-		if (err < 0)
-			goto err_detach;
+		if (err < 0) {
+			free_netdev(dev);
+			return err;
+		}
 		/* free_netdev() won't check refcnt, to avoid race
 		 * with dev_put() we need publish tun after registration.
 		 */
@@ -2767,24 +2788,6 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 
 	strcpy(ifr->ifr_name, tun->dev->name);
 	return 0;
-
-err_detach:
-	tun_detach_all(dev);
-	/* We are here because register_netdevice() has failed.
-	 * If register_netdevice() already called tun_free_netdev()
-	 * while dealing with the error, dev->stats has been cleared.
-	 */
-	if (!dev->tstats)
-		goto err_free_dev;
-
-err_free_flow:
-	tun_flow_uninit(tun);
-	security_tun_dev_free_security(tun->security);
-err_free_stat:
-	free_percpu(dev->tstats);
-err_free_dev:
-	free_netdev(dev);
-	return err;
 }
 
 static void tun_get_iff(struct tun_struct *tun, struct ifreq *ifr)
-- 
2.34.1

