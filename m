Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD19DA91F9
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387760AbfIDSlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 14:41:16 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42339 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732177AbfIDSlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 14:41:16 -0400
Received: by mail-pg1-f196.google.com with SMTP id p3so11686941pgb.9
        for <netdev@vger.kernel.org>; Wed, 04 Sep 2019 11:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=lw2VArFgPnaf+jWzHkiHI61Szxhke5CeCJ9DDvWn0zQ=;
        b=AtznKVfs0EEbiEVtm5kvwui5fyf0cJuQOLziIzgs5GGJG99gT+GEnepRiYQL72onSP
         1uLGTiCikJyObdPVKbkyPmFNLehm+y+49xbv2PiygRGSbbWWtmcMhZ9lU7VWdrb6N43Z
         kI7wxBJGgw7c3u+CHCtDwgWOFJ9x+5fRrEydqmxtn1mSlZhzj7C4w4egRQ97xfffQ90L
         zDmBYfwMPG6FHYB/nY0fzt/7QvSTsk4mCYT+Tyc38trJ1WOWKuAh/I4FDzk3TFvrbexO
         pVIMNt3pj+6YGvomQiLB/JbkS//fVYXh5hThU+DHo2x3ChU4APw0zMPZroGKAH8q9I52
         HckQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=lw2VArFgPnaf+jWzHkiHI61Szxhke5CeCJ9DDvWn0zQ=;
        b=D+odfoHuFAG5eVILnkMTCjMRTjzUmWPkENtA+8NUcxem7IXnB8yJ8c3qJd0r2ArHBO
         1vdbLg5fM4P46Ex9t38uACIaa5v86jnsi/a+loaYj9EW9902mI9Mo7YRVfuo2CqSyTRo
         qklAOckLwZMe7Gp5ZJlTlAIIpErfOYrdcX5+/J2rzKo1DWBykZ1LxiVug8JdjTxWsd4d
         e26/D4pxDccYQ3CARWez7JUXQmbDkhqCLAYu1jMhwvhah1lImZwNrI8xcw1/XCe9e+9D
         C/r+1wN44jrJBE+kDRYABB/CUh0SogjXPxtr+LGKYWZ2KwdwZJ7/IYyep0L5BWqJBjyg
         hMUA==
X-Gm-Message-State: APjAAAUCMoeI7dPfsmu/eyECTNzMgkbl8N+Z99TFw/DLGUDn6uEoqUYJ
        ZEazy3OrEmc6vSxcF2VkCLo=
X-Google-Smtp-Source: APXvYqz/pA0wumvzAryLCV/9gRe2o6q9G+DDvZ0vYmG8uBSRUkQ1yWUTqT5aWBjxtrO0IKe/sEnhSQ==
X-Received: by 2002:a17:90a:9f4b:: with SMTP id q11mr6362182pjv.105.1567622475241;
        Wed, 04 Sep 2019 11:41:15 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.1.1.1.1 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id n185sm23068417pga.16.2019.09.04.11.41.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 11:41:14 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, jiri@resnulli.us,
        sd@queasysnail.net, roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, sashal@kernel.org,
        hare@suse.de, varun@chelsio.com, ubraun@linux.ibm.com,
        kgraul@linux.ibm.com
Cc:     ap420073@gmail.com
Subject: [PATCH net 10/11] vxlan: add adjacent link to limit depth level
Date:   Thu,  5 Sep 2019 03:41:05 +0900
Message-Id: <20190904184105.15424-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current vxlan code doesn't limit the number of nested devices.
Nested devices would be handled recursively and this routine needs
huge stack memory. So, unlimited nested devices could make
stack overflow.

In order to fix this issue, this patch adds adjacent links.
The adjacent link APIs internally check the depth level.

Test commands:
    ip link add dummy0 type dummy
    ip link add vxlan0 type vxlan id 0 group 239.1.1.1 dev dummy0 \
	    dstport 4789
    for i in {1..100}
    do
            let A=$i-1
            ip link add vxlan$i type vxlan id $i group 239.1.1.1 \
		    dev vxlan$A dstport 4789
    done
    ip link del dummy0

The top upper link is vxlan100 and the lowest link is vxlan0.
When vxlan0 is deleting, the upper devices will be deleted recursively.
It needs huge stack memory so it makes stack overflow.

Splat looks like:
[  229.628477] =============================================================================
[  229.629785] BUG page->ptl (Not tainted): Padding overwritten. 0x0000000026abf214-0x0000000091f6abb2
[  229.629785] -----------------------------------------------------------------------------
[  229.629785]
[  229.655439] ==================================================================
[  229.629785] INFO: Slab 0x00000000ff7cfda8 objects=19 used=19 fp=0x00000000fe33776c flags=0x200000000010200
[  229.655688] BUG: KASAN: stack-out-of-bounds in unmap_single_vma+0x25a/0x2e0
[  229.655688] Read of size 8 at addr ffff888113076928 by task vlan-network-in/2334
[  229.655688]
[  229.629785] Padding 0000000026abf214: 00 80 14 0d 81 88 ff ff 68 91 81 14 81 88 ff ff  ........h.......
[  229.629785] Padding 0000000001e24790: 38 91 81 14 81 88 ff ff 68 91 81 14 81 88 ff ff  8.......h.......
[  229.629785] Padding 00000000b39397c8: 33 30 62 a7 ff ff ff ff ff eb 60 22 10 f1 ff 1f  30b.......`"....
[  229.629785] Padding 00000000bc98f53a: 80 60 07 13 81 88 ff ff 00 80 14 0d 81 88 ff ff  .`..............
[  229.629785] Padding 000000002aa8123d: 68 91 81 14 81 88 ff ff f7 21 17 a7 ff ff ff ff  h........!......
[  229.629785] Padding 000000001c8c2369: 08 81 14 0d 81 88 ff ff 03 02 00 00 00 00 00 00  ................
[  229.629785] Padding 000000004e290c5d: 21 90 a2 21 10 ed ff ff 00 00 00 00 00 fc ff df  !..!............
[  229.629785] Padding 000000000e25d731: 18 60 07 13 81 88 ff ff c0 8b 13 05 81 88 ff ff  .`..............
[  229.629785] Padding 000000007adc7ab3: b3 8a b5 41 00 00 00 00                          ...A....
[  229.629785] FIX page->ptl: Restoring 0x0000000026abf214-0x0000000091f6abb2=0x5a
[  ... ]


Fixes: acaf4e70997f ("net: vxlan: when lower dev unregisters remove vxlan dev as well")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/vxlan.c | 71 ++++++++++++++++++++++++++++++++++++++-------
 include/net/vxlan.h |  1 +
 2 files changed, 62 insertions(+), 10 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 3d9bcc957f7d..0d5c8d22d8a4 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -3567,6 +3567,8 @@ static int __vxlan_dev_create(struct net *net, struct net_device *dev,
 	struct vxlan_net *vn = net_generic(net, vxlan_net_id);
 	struct vxlan_dev *vxlan = netdev_priv(dev);
 	struct vxlan_fdb *f = NULL;
+	struct net_device *remote_dev = NULL;
+	struct vxlan_rdst *dst = &vxlan->default_dst;
 	bool unregister = false;
 	int err;
 
@@ -3577,14 +3579,14 @@ static int __vxlan_dev_create(struct net *net, struct net_device *dev,
 	dev->ethtool_ops = &vxlan_ethtool_ops;
 
 	/* create an fdb entry for a valid default destination */
-	if (!vxlan_addr_any(&vxlan->default_dst.remote_ip)) {
+	if (!vxlan_addr_any(&dst->remote_ip)) {
 		err = vxlan_fdb_create(vxlan, all_zeros_mac,
-				       &vxlan->default_dst.remote_ip,
+				       &dst->remote_ip,
 				       NUD_REACHABLE | NUD_PERMANENT,
 				       vxlan->cfg.dst_port,
-				       vxlan->default_dst.remote_vni,
-				       vxlan->default_dst.remote_vni,
-				       vxlan->default_dst.remote_ifindex,
+				       dst->remote_vni,
+				       dst->remote_vni,
+				       dst->remote_ifindex,
 				       NTF_SELF, &f);
 		if (err)
 			return err;
@@ -3595,26 +3597,43 @@ static int __vxlan_dev_create(struct net *net, struct net_device *dev,
 		goto errout;
 	unregister = true;
 
+	if (dst->remote_ifindex) {
+		remote_dev = __dev_get_by_index(net, dst->remote_ifindex);
+		if (!remote_dev)
+			goto errout;
+
+		err = netdev_upper_dev_link(remote_dev, dev, extack);
+		if (err)
+			goto errout;
+	}
+
 	err = rtnl_configure_link(dev, NULL);
 	if (err)
-		goto errout;
+		goto unlink;
 
 	if (f) {
-		vxlan_fdb_insert(vxlan, all_zeros_mac,
-				 vxlan->default_dst.remote_vni, f);
+		vxlan_fdb_insert(vxlan, all_zeros_mac, dst->remote_vni, f);
 
 		/* notify default fdb entry */
 		err = vxlan_fdb_notify(vxlan, f, first_remote_rtnl(f),
 				       RTM_NEWNEIGH, true, extack);
 		if (err) {
 			vxlan_fdb_destroy(vxlan, f, false, false);
+			if (remote_dev)
+				netdev_upper_dev_unlink(remote_dev, dev);
 			goto unregister;
 		}
 	}
 
 	list_add(&vxlan->next, &vn->vxlan_list);
+	if (remote_dev) {
+		dst->remote_dev = remote_dev;
+		dev_hold(remote_dev);
+	}
 	return 0;
-
+unlink:
+	if (remote_dev)
+		netdev_upper_dev_unlink(remote_dev, dev);
 errout:
 	/* unregister_netdevice() destroys the default FDB entry with deletion
 	 * notification. But the addition notification was not sent yet, so
@@ -3936,6 +3955,8 @@ static int vxlan_changelink(struct net_device *dev, struct nlattr *tb[],
 	struct net_device *lowerdev;
 	struct vxlan_config conf;
 	int err;
+	bool linked = false;
+	bool disabled = false;
 
 	err = vxlan_nl2conf(tb, data, dev, &conf, true, extack);
 	if (err)
@@ -3946,6 +3967,16 @@ static int vxlan_changelink(struct net_device *dev, struct nlattr *tb[],
 	if (err)
 		return err;
 
+	if (lowerdev) {
+		if (dst->remote_dev && lowerdev != dst->remote_dev) {
+			netdev_adjacent_dev_disable(dst->remote_dev, dev);
+			disabled = true;
+		}
+		err = netdev_upper_dev_link(lowerdev, dev, extack);
+		if (err)
+			goto err;
+		linked = true;
+	}
 	/* handle default dst entry */
 	if (!vxlan_addr_equal(&conf.remote_ip, &dst->remote_ip)) {
 		u32 hash_index = fdb_head_index(vxlan, all_zeros_mac, conf.vni);
@@ -3962,7 +3993,7 @@ static int vxlan_changelink(struct net_device *dev, struct nlattr *tb[],
 					       NTF_SELF, true, extack);
 			if (err) {
 				spin_unlock_bh(&vxlan->hash_lock[hash_index]);
-				return err;
+				goto err;
 			}
 		}
 		if (!vxlan_addr_any(&dst->remote_ip))
@@ -3979,8 +4010,24 @@ static int vxlan_changelink(struct net_device *dev, struct nlattr *tb[],
 	if (conf.age_interval != vxlan->cfg.age_interval)
 		mod_timer(&vxlan->age_timer, jiffies);
 
+	if (disabled) {
+		netdev_adjacent_dev_enable(dst->remote_dev, dev);
+		netdev_upper_dev_unlink(dst->remote_dev, dev);
+		dev_put(dst->remote_dev);
+	}
+	if (linked) {
+		dst->remote_dev = lowerdev;
+		dev_hold(dst->remote_dev);
+	}
+
 	vxlan_config_apply(dev, &conf, lowerdev, vxlan->net, true);
 	return 0;
+err:
+	if (linked)
+		netdev_upper_dev_unlink(lowerdev, dev);
+	if (disabled)
+		netdev_adjacent_dev_enable(dst->remote_dev, dev);
+	return err;
 }
 
 static void vxlan_dellink(struct net_device *dev, struct list_head *head)
@@ -3991,6 +4038,10 @@ static void vxlan_dellink(struct net_device *dev, struct list_head *head)
 
 	list_del(&vxlan->next);
 	unregister_netdevice_queue(dev, head);
+	if (vxlan->default_dst.remote_dev) {
+		netdev_upper_dev_unlink(vxlan->default_dst.remote_dev, dev);
+		dev_put(vxlan->default_dst.remote_dev);
+	}
 }
 
 static size_t vxlan_get_size(const struct net_device *dev)
diff --git a/include/net/vxlan.h b/include/net/vxlan.h
index dc1583a1fb8a..08e237d7aa73 100644
--- a/include/net/vxlan.h
+++ b/include/net/vxlan.h
@@ -197,6 +197,7 @@ struct vxlan_rdst {
 	u8			 offloaded:1;
 	__be32			 remote_vni;
 	u32			 remote_ifindex;
+	struct net_device	 *remote_dev;
 	struct list_head	 list;
 	struct rcu_head		 rcu;
 	struct dst_cache	 dst_cache;
-- 
2.17.1

