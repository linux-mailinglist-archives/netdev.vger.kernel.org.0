Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A090BC1167
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 18:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728793AbfI1Qud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 12:50:33 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43416 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfI1Qud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Sep 2019 12:50:33 -0400
Received: by mail-pf1-f193.google.com with SMTP id a2so3218908pfo.10;
        Sat, 28 Sep 2019 09:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MN6+dK8M4Q+jB3mNh8/eTLkmi5cM1iythP1/K5SkMhU=;
        b=f22UrAi7nK84VrQkGirbDgyejVB8sbDj1+jafqhaVJF36edVx+SV0+hxqdgzlYRYSE
         UEyc+kaG7FVACKES3EfiVzji1IYYQwfUd5Atk8tjmoJrMsRf7q2Vzel29oG1vi9pTWiP
         48iRXw3ffNaRhXpaLoZQDBspgdfUnjeX8Ue/o1jTwPzTLqPw4zRy7I42QiB/dxPbtPhw
         nbOqnp8uSMGWf6Ry2Z76/PatuBoQGQGWxP9jlrbm7O+aX1C4JEdb3glpVm9L3YA3zWZe
         NPFg0AOltnVdL3nVIHby1/xiLr5GwgRfvcmFy/shZddbUMnlz91LelI13QKTa3IDXvNv
         tYbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MN6+dK8M4Q+jB3mNh8/eTLkmi5cM1iythP1/K5SkMhU=;
        b=YjOH9WMO/nPZXyftQWdAYdWHjkIwN5O+xjmZDbvtXAYtRXj+AStcmeU59AWL86smBN
         6Z2WB6Opt+mC1GwHwZqCnFnkotYVkslcOUOa7tB7woqxNGBDmtIHk4VSh7Wgw03neoKp
         EI6gpiSY90Wt7d50bnHcORiZa5oXGd4qf7lw0pjhy20aIHlQgJfHlIEkDxxRiWHDPlaQ
         HRxR9bqTl3OWhkh/emqjge7A+t3+85DHTqQy3Su7YYEFh1isB/ft1xo6sjNaMN8JWSiI
         4VVVFVIOcbK1xIoVRx4vmkemLFcMUdvnZSYxjv1BZeVRpdrViJVy17iD6NTJ/dXxDdz6
         cz1g==
X-Gm-Message-State: APjAAAWAVY9s7nWV+AxxvoJQBjJyoPUT8kePPapFkK7QfdRIq4PPlhbB
        117InH/HoWrTwrEilFz5iBw=
X-Google-Smtp-Source: APXvYqykDCLpaZRApGUZrXeJbijKNWCt+VLmFuUfJvYjXwab5xq7w41moohw+uwRU9V4HkH9P0/hrw==
X-Received: by 2002:a17:90a:e382:: with SMTP id b2mr16936513pjz.94.1569689432448;
        Sat, 28 Sep 2019 09:50:32 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id 30sm8663092pjk.25.2019.09.28.09.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Sep 2019 09:50:31 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, jakub.kicinski@netronome.com,
        johannes@sipsolutions.net, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, jiri@resnulli.us, sd@queasysnail.net,
        roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        jay.vosburgh@canonical.com, schuffelen@google.com, bjorn@mork.no
Cc:     ap420073@gmail.com
Subject: [PATCH net v4 10/12] vxlan: add adjacent link to limit depth level
Date:   Sat, 28 Sep 2019 16:48:41 +0000
Message-Id: <20190928164843.31800-11-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190928164843.31800-1-ap420073@gmail.com>
References: <20190928164843.31800-1-ap420073@gmail.com>
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

v3 -> v4 :
 - Fix wrong usage netdev_upper_dev_link() in the vxlan.c
 - Preserve reverse christmas tree variable ordering in the vxlan.c
v1 -> v3 :
 - This patch is not changed

 drivers/net/vxlan.c | 52 ++++++++++++++++++++++++++++++++++++---------
 include/net/vxlan.h |  1 +
 2 files changed, 43 insertions(+), 10 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 3d9bcc957f7d..5537998d6137 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -3566,10 +3566,13 @@ static int __vxlan_dev_create(struct net *net, struct net_device *dev,
 {
 	struct vxlan_net *vn = net_generic(net, vxlan_net_id);
 	struct vxlan_dev *vxlan = netdev_priv(dev);
+	struct net_device *remote_dev = NULL;
 	struct vxlan_fdb *f = NULL;
 	bool unregister = false;
+	struct vxlan_rdst *dst;
 	int err;
 
+	dst = &vxlan->default_dst;
 	err = vxlan_dev_configure(net, dev, conf, false, extack);
 	if (err)
 		return err;
@@ -3577,14 +3580,14 @@ static int __vxlan_dev_create(struct net *net, struct net_device *dev,
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
@@ -3595,26 +3598,41 @@ static int __vxlan_dev_create(struct net *net, struct net_device *dev,
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
+	if (remote_dev)
+		dst->remote_dev = remote_dev;
 	return 0;
-
+unlink:
+	if (remote_dev)
+		netdev_upper_dev_unlink(remote_dev, dev);
 errout:
 	/* unregister_netdevice() destroys the default FDB entry with deletion
 	 * notification. But the addition notification was not sent yet, so
@@ -3932,11 +3950,12 @@ static int vxlan_changelink(struct net_device *dev, struct nlattr *tb[],
 			    struct netlink_ext_ack *extack)
 {
 	struct vxlan_dev *vxlan = netdev_priv(dev);
-	struct vxlan_rdst *dst = &vxlan->default_dst;
 	struct net_device *lowerdev;
 	struct vxlan_config conf;
+	struct vxlan_rdst *dst;
 	int err;
 
+	dst = &vxlan->default_dst;
 	err = vxlan_nl2conf(tb, data, dev, &conf, true, extack);
 	if (err)
 		return err;
@@ -3946,6 +3965,11 @@ static int vxlan_changelink(struct net_device *dev, struct nlattr *tb[],
 	if (err)
 		return err;
 
+	err = netdev_adjacent_change_prepare(dst->remote_dev, lowerdev, dev,
+					     extack);
+	if (err)
+		return err;
+
 	/* handle default dst entry */
 	if (!vxlan_addr_equal(&conf.remote_ip, &dst->remote_ip)) {
 		u32 hash_index = fdb_head_index(vxlan, all_zeros_mac, conf.vni);
@@ -3962,6 +3986,8 @@ static int vxlan_changelink(struct net_device *dev, struct nlattr *tb[],
 					       NTF_SELF, true, extack);
 			if (err) {
 				spin_unlock_bh(&vxlan->hash_lock[hash_index]);
+				netdev_adjacent_change_abort(dst->remote_dev,
+							     lowerdev, dev);
 				return err;
 			}
 		}
@@ -3979,6 +4005,10 @@ static int vxlan_changelink(struct net_device *dev, struct nlattr *tb[],
 	if (conf.age_interval != vxlan->cfg.age_interval)
 		mod_timer(&vxlan->age_timer, jiffies);
 
+	netdev_adjacent_change_commit(dst->remote_dev, lowerdev, dev);
+	if (lowerdev && lowerdev != dst->remote_dev)
+		dst->remote_dev = lowerdev;
+
 	vxlan_config_apply(dev, &conf, lowerdev, vxlan->net, true);
 	return 0;
 }
@@ -3991,6 +4021,8 @@ static void vxlan_dellink(struct net_device *dev, struct list_head *head)
 
 	list_del(&vxlan->next);
 	unregister_netdevice_queue(dev, head);
+	if (vxlan->default_dst.remote_dev)
+		netdev_upper_dev_unlink(vxlan->default_dst.remote_dev, dev);
 }
 
 static size_t vxlan_get_size(const struct net_device *dev)
diff --git a/include/net/vxlan.h b/include/net/vxlan.h
index 335283dbe9b3..373aadcfea21 100644
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

