Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B35EB170682
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 18:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgBZRss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 12:48:48 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:36070 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbgBZRsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 12:48:47 -0500
Received: by mail-pj1-f68.google.com with SMTP id gv17so1552265pjb.1
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 09:48:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=UagKW/ZHLsnwygzzM41BQuciv7JPrh1DPKs7YCN3uYI=;
        b=i42SYEIU3PZPO7kWBKClBuLZ6CnqvTpOlZclAkGKYbgFyOJOeVdZL6sGzQG3uyJ6g4
         rRX05OmOM7+8iFknfuiCFQFY+zXkd+yukgzPuiGs3pSnpAzI8GKkVMcAkeGud5QLP2lJ
         xiQ2twlcDuPDsOGq22mgh7pkvUuALGiRNl2nNhHyQ08vOf4bQl8uVOKv6tNk+N7zBv6A
         tN0LfP+BQg8eI55IdgZUSVeusVblKyAgzZ8SXeWbFpefkUO3Jet18eXT80keu6PdxPsX
         JZOv6EUdQDXyeADwkVaHouZciEwUzzTk9py9yf/K9G0MFfwrD2jSPJBnrCC6mvPqUbSa
         IrxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=UagKW/ZHLsnwygzzM41BQuciv7JPrh1DPKs7YCN3uYI=;
        b=fuWoBQLvee/QG0cGI8AtWcMTL20u0x+m4hmVlL9BnjTpKozvOHeof/dZEHdew7/PXn
         /pqlZgcTnVMxV60ro1bsCtI3UoYW9CrtfZeNcMxk4FDLuhm8xXZfiT5D8Pyqee8FLEtC
         TJIhNfTytPf01caaNkgVk326DkNsar4zY33kDDlpDUnRI55zZmW1Y38u4Xs50+57ry+1
         FFqNVNvqpEldoNGAdgifdbeZPxirEg+ZeVWHy1fRxmr55dAKoPG5scc+7bZf21U07qoU
         EwoF9AO5oBmITK/Pk/DegTBXGNtvfJHSWKnQ0Okuph/jBtSSTsEZMCAuQiG1inFanfjP
         /GoA==
X-Gm-Message-State: APjAAAWgkzCxSa+VXW9NCjESdlnnSZn3Go33+vkXCDpnrgIXSKshLaRV
        X81w3ryxTd+nyWyLJsc1P2w=
X-Google-Smtp-Source: APXvYqxwsefdQVtUJQxp6ZD9zLydYBjrp95dKUnJ/X6ID4cNJ8zx3iRX9BlsW0BPIbq869AtKP73UA==
X-Received: by 2002:a17:902:8d92:: with SMTP id v18mr473255plo.18.1582739326061;
        Wed, 26 Feb 2020 09:48:46 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id e18sm4004525pfm.24.2020.02.26.09.48.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 09:48:45 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, subashab@codeaurora.org,
        stranche@codeaurora.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 08/10] net: rmnet: use upper/lower device infrastructure
Date:   Wed, 26 Feb 2020 17:48:39 +0000
Message-Id: <20200226174839.6109-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netdev_upper_dev_link() is useful to manage lower/upper interfaces.
And this function internally validates looping, maximum depth.
All or most virtual interfaces that could have a real interface
(e.g. macsec, macvlan, ipvlan etc.) use lower/upper infrastructure.

Test commands:
    ip link add dummy0 type dummy
    ip link add rmnet1 link dummy0 type rmnet mux_id 1
    for i in {2..100}
    do
        let A=$i-1
        ip link add rmnet$i link rmnet$A type rmnet mux_id $i
    done
    ip link del dummy0

The purpose of the test commands is to make stack overflow.

Splat looks like:
[   54.352441][ T2169] BUG: KASAN: use-after-free in usage_match+0x85/0xa0
[   54.353332][ T2169] Read of size 8 at addr ffff8880a6eae420 by task ip/2169
[   54.404290][ T2169]
[   54.404615][ T2169] CPU: 1 PID: 2169 Comm: ip Not tainted 5.5.0+ #422
[   54.409543][ T2169] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   54.410619][ T2169] Call Trace:
[   54.411051][ T2169]
[   54.411345][ T2169] Allocated by task 1:
[   54.793962][ T2169] (stack is not available)
[   54.794566][ T2169]
[   54.794880][ T2169] Freed by task 2519193708:
[   54.795487][ T2169] BUG: unable to handle page fault for address: ffffffff9b9dbe58
[   54.796508][ T2169] #PF: supervisor read access in kernel mode
[   54.797274][ T2169] #PF: error_code(0x0000) - not-present page
[   54.798058][ T2169] PGD 11b818067 P4D 11b818067 PUD 11b819063 PMD 0
[   54.798879][ T2169] Thread overran stack, or stack corrupted
[   54.799451][ T2169] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
[   55.293798][ T2169] CPU: 1 PID: 2169 Comm: ip Not tainted 5.5.0+ #422
[   55.294661][ T2169] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   55.296407][ T2169] RIP: 0010:stack_depot_fetch+0x10/0x30
[   55.297122][ T2169] Code: ff e9 f9 fe ff ff 48 89 df e8 9c 1d 91 ff e9 ca fe ff ff cc cc cc cc cc cc cc 89 f8 0
[   55.299622][ T2169] RSP: 0018:ffff8880a6eae2c8 EFLAGS: 00010006
[   55.798954][ T2169] RAX: 00000000001fffff RBX: ffff8880a6eaea48 RCX: 0000000000000000
[   55.799997][ T2169] RDX: 0000000000000019 RSI: ffff8880a6eae2d0 RDI: 0000000000003ff0
[   55.801075][ T2169] RBP: ffffea00029baa00 R08: ffffed101aabe403 R09: ffffed101aabe403
[   55.802147][ T2169] R10: 0000000000000001 R11: ffffed101aabe402 R12: ffff8880d0660400
[   55.803174][ T2169] R13: ffff8880a6ead900 R14: ffff8880a6eae4f0 R15: ffff8880a6eae610
[   55.804192][ T2169] FS:  00007fc124f030c0(0000) GS:ffff8880d5400000(0000) knlGS:0000000000000000
[   55.805328][ T2169] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   55.806193][ T2169] CR2: ffffffff9b9dbe58 CR3: 00000000a9a20004 CR4: 00000000000606e0
[   55.807223][ T2169] Call Trace:
[   55.807642][ T2169] Modules linked in: rmnet dummy veth openvswitch nsh nf_conncount nf_nat nf_conntrack nf_dex
[   56.293411][ T2169] CR2: ffffffff9b9dbe58
[   56.294041][ T2169] ---[ end trace 0c069624f07c5c8c ]---
[   56.294761][ T2169] RIP: 0010:stack_depot_fetch+0x10/0x30
[   56.295494][ T2169] Code: ff e9 f9 fe ff ff 48 89 df e8 9c 1d 91 ff e9 ca fe ff ff cc cc cc cc cc cc cc 89 f8 0
[   56.298122][ T2169] RSP: 0018:ffff8880a6eae2c8 EFLAGS: 00010006
[   56.298728][ T2169] RAX: 00000000001fffff RBX: ffff8880a6eaea48 RCX: 0000000000000000
[   56.299770][ T2169] RDX: 0000000000000019 RSI: ffff8880a6eae2d0 RDI: 0000000000003ff0
[   56.799064][ T2169] RBP: ffffea00029baa00 R08: ffffed101aabe403 R09: ffffed101aabe403
[   56.800117][ T2169] R10: 0000000000000001 R11: ffffed101aabe402 R12: ffff8880d0660400
[   56.801137][ T2169] R13: ffff8880a6ead900 R14: ffff8880a6eae4f0 R15: ffff8880a6eae610
[   56.802181][ T2169] FS:  00007fc124f030c0(0000) GS:ffff8880d5400000(0000) knlGS:0000000000000000
[   56.803325][ T2169] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   56.804173][ T2169] CR2: ffffffff9b9dbe58 CR3: 00000000a9a20004 CR4: 00000000000606e0
[   56.805198][ T2169] Kernel panic - not syncing: Fatal exception

Fixes: b37f78f234bf ("net: qualcomm: rmnet: Fix crash on real dev unregistration")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 .../ethernet/qualcomm/rmnet/rmnet_config.c    | 35 +++++++++----------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
index bdb88472a0a0..5b642123c178 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -61,9 +61,6 @@ static int rmnet_unregister_real_device(struct net_device *real_dev,
 
 	kfree(port);
 
-	/* release reference on real_dev */
-	dev_put(real_dev);
-
 	netdev_dbg(real_dev, "Removed from rmnet\n");
 	return 0;
 }
@@ -89,9 +86,6 @@ static int rmnet_register_real_device(struct net_device *real_dev)
 		return -EBUSY;
 	}
 
-	/* hold on to real dev for MAP data */
-	dev_hold(real_dev);
-
 	for (entry = 0; entry < RMNET_MAX_LOGICAL_EP; entry++)
 		INIT_HLIST_HEAD(&port->muxed_ep[entry]);
 
@@ -161,6 +155,10 @@ static int rmnet_newlink(struct net *src_net, struct net_device *dev,
 	if (err)
 		goto err1;
 
+	err = netdev_upper_dev_link(real_dev, dev, extack);
+	if (err < 0)
+		goto err2;
+
 	port->rmnet_mode = mode;
 
 	hlist_add_head_rcu(&ep->hlnode, &port->muxed_ep[mux_id]);
@@ -177,6 +175,8 @@ static int rmnet_newlink(struct net *src_net, struct net_device *dev,
 
 	return 0;
 
+err2:
+	unregister_netdevice(dev);
 err1:
 	rmnet_unregister_real_device(real_dev, port);
 err0:
@@ -208,33 +208,30 @@ static void rmnet_dellink(struct net_device *dev, struct list_head *head)
 		rmnet_vnd_dellink(mux_id, port, ep);
 		kfree(ep);
 	}
+	netdev_upper_dev_unlink(real_dev, dev);
 	rmnet_unregister_real_device(real_dev, port);
 
 	unregister_netdevice_queue(dev, head);
 }
 
-static void rmnet_force_unassociate_device(struct net_device *dev)
+static void rmnet_force_unassociate_device(struct net_device *real_dev)
 {
-	struct net_device *real_dev = dev;
 	struct hlist_node *tmp_ep;
 	struct rmnet_endpoint *ep;
 	struct rmnet_port *port;
 	unsigned long bkt_ep;
 	LIST_HEAD(list);
 
-	if (!rmnet_is_real_dev_registered(real_dev))
-		return;
-
 	ASSERT_RTNL();
 
-	port = rmnet_get_port_rtnl(dev);
+	port = rmnet_get_port_rtnl(real_dev);
 
-	rmnet_unregister_bridge(dev, port);
+	rmnet_unregister_bridge(real_dev, port);
 
 	hash_for_each_safe(port->muxed_ep, bkt_ep, tmp_ep, ep, hlnode) {
+		netdev_upper_dev_unlink(real_dev, ep->egress_dev);
 		unregister_netdevice_queue(ep->egress_dev, &list);
 		rmnet_vnd_dellink(ep->mux_id, port, ep);
-
 		hlist_del_init_rcu(&ep->hlnode);
 		kfree(ep);
 	}
@@ -247,15 +244,15 @@ static void rmnet_force_unassociate_device(struct net_device *dev)
 static int rmnet_config_notify_cb(struct notifier_block *nb,
 				  unsigned long event, void *data)
 {
-	struct net_device *dev = netdev_notifier_info_to_dev(data);
+	struct net_device *real_dev = netdev_notifier_info_to_dev(data);
 
-	if (!dev)
+	if (!rmnet_is_real_dev_registered(real_dev))
 		return NOTIFY_DONE;
 
 	switch (event) {
 	case NETDEV_UNREGISTER:
-		netdev_dbg(dev, "Kernel unregister\n");
-		rmnet_force_unassociate_device(dev);
+		netdev_dbg(real_dev, "Kernel unregister\n");
+		rmnet_force_unassociate_device(real_dev);
 		break;
 
 	default:
@@ -485,8 +482,8 @@ static int __init rmnet_init(void)
 
 static void __exit rmnet_exit(void)
 {
-	unregister_netdevice_notifier(&rmnet_dev_notifier);
 	rtnl_link_unregister(&rmnet_link_ops);
+	unregister_netdevice_notifier(&rmnet_dev_notifier);
 }
 
 module_init(rmnet_init)
-- 
2.17.1

