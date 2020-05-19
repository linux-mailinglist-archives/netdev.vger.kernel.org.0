Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7DA11D8D84
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 04:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbgESCOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 22:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728176AbgESCOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 22:14:45 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C62C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 19:14:45 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id n15so680283pjt.4
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 19:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AhUGXmhIPXNNzPbRTQ0HIuIoiJj9B+8WZPxkPGecESA=;
        b=bxOku0ZqyAoE14VQ0Jpjjy5/d89KNz8W4jFJeHJYBPYn/4mJdeAKUPIgjA9I90CCk4
         Ol/qvjm80OgMHW1kdgG+mJiAZxAtAMw3CdYpbLwP++2yUV8H9AVOCw2qrv/m7qgl+Mgj
         xg+oNS/Yv6I11X+2Zd6k3W4PPPOXAVfYLC1wE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AhUGXmhIPXNNzPbRTQ0HIuIoiJj9B+8WZPxkPGecESA=;
        b=oRaAb0PDXJ7g2mprbPEpmqmlhWeyXaEjlQDGqLHew84vvmZRevt7++60yoQhI94mc5
         oVGze1HE+84WfGtB/cIA5wATM/iT3b9yTga0pDPJDpo71NaitBXhKJ9rtbv4IJ09YvCn
         kfAwbB0uqoYM7FyEA9Hydc80OLwIVm8+Sg2HBVe/eBxR6jjeuL/4q3qcKnmcmPxpIoQn
         VaOq6e9xI/uB3eX1HZVYNhYV05+DFmRno9l7UXId+jKWzvWjxO3HUyDJp58iMnXx31uY
         ixvJYwPsWH0sPcAE7F/ECg8qB7QzOmrT1v6KH0zV2Uoq+NDdAzsHL2PYt+P3s1tNAgwp
         trHQ==
X-Gm-Message-State: AOAM532DlcNocIVhickg5lndZPXyz4+drE/Xy/G0raw8NwVc7WCdpvUj
        83fEIofoL8Fdhz9tcFWfN280Rw==
X-Google-Smtp-Source: ABdhPJzbfH3UjTa5oAtQf9oU1F+VQoigXQLu/fCALC+xthciBDIfFaqiHaWMgDQjdsk/0ai9JUMTHg==
X-Received: by 2002:a17:90b:e0f:: with SMTP id ge15mr2507183pjb.140.1589854485043;
        Mon, 18 May 2020 19:14:45 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id 5sm664753pjf.19.2020.05.18.19.14.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 May 2020 19:14:44 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        jiri@mellanox.com, idosch@mellanox.com, petrm@mellanox.com
Subject: [PATCH net-next 5/6] vxlan: support for nexthop notifiers
Date:   Mon, 18 May 2020 19:14:33 -0700
Message-Id: <1589854474-26854-6-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1589854474-26854-1-git-send-email-roopa@cumulusnetworks.com>
References: <1589854474-26854-1-git-send-email-roopa@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>

vxlan driver registers for nexthop add/del notifiers to
cleanup fdb entries pointing to such nexthops.

Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
---
 drivers/net/vxlan.c | 33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 01933e9..f9c27ff 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -81,6 +81,7 @@ struct vxlan_fdb {
 	u16		  flags;	/* see ndm_flags and below */
 	struct list_head  nh_list;
 	struct nexthop __rcu *nh;
+	struct vxlan_dev  *vdev;
 };
 
 #define NTF_VXLAN_ADDED_BY_USER 0x100
@@ -813,8 +814,9 @@ static int vxlan_gro_complete(struct sock *sk, struct sk_buff *skb, int nhoff)
 	return eth_gro_complete(skb, nhoff + sizeof(struct vxlanhdr));
 }
 
-static struct vxlan_fdb *vxlan_fdb_alloc(const u8 *mac, __u16 state,
-					 __be32 src_vni, __u16 ndm_flags)
+static struct vxlan_fdb *vxlan_fdb_alloc(struct vxlan_dev *vxlan, const u8 *mac,
+					 __u16 state, __be32 src_vni,
+					 __u16 ndm_flags)
 {
 	struct vxlan_fdb *f;
 
@@ -826,6 +828,7 @@ static struct vxlan_fdb *vxlan_fdb_alloc(const u8 *mac, __u16 state,
 	f->updated = f->used = jiffies;
 	f->vni = src_vni;
 	f->nh = NULL;
+	f->vdev = vxlan;
 	INIT_LIST_HEAD(&f->nh_list);
 	INIT_LIST_HEAD(&f->remotes);
 	memcpy(f->eth_addr, mac, ETH_ALEN);
@@ -921,7 +924,7 @@ static int vxlan_fdb_create(struct vxlan_dev *vxlan,
 		return -ENOSPC;
 
 	netdev_dbg(vxlan->dev, "add %pM -> %pIS\n", mac, ip);
-	f = vxlan_fdb_alloc(mac, state, src_vni, ndm_flags);
+	f = vxlan_fdb_alloc(vxlan, mac, state, src_vni, ndm_flags);
 	if (!f)
 		return -ENOMEM;
 
@@ -986,6 +989,7 @@ static void vxlan_fdb_destroy(struct vxlan_dev *vxlan, struct vxlan_fdb *f,
 	}
 
 	hlist_del_rcu(&f->hlist);
+	f->vdev = NULL;
 	call_rcu(&f->rcu, vxlan_fdb_free);
 }
 
@@ -4581,6 +4585,25 @@ static struct notifier_block vxlan_switchdev_notifier_block __read_mostly = {
 	.notifier_call = vxlan_switchdev_event,
 };
 
+static int vxlan_nexthop_event(struct notifier_block *nb,
+			       unsigned long event, void *ptr)
+{
+	struct nexthop *nh = ptr;
+	struct vxlan_fdb *fdb, *tmp;
+
+	if (!nh || event != NEXTHOP_EVENT_DEL)
+		return NOTIFY_DONE;
+
+	list_for_each_entry_safe(fdb, tmp, &nh->fdb_list, nh_list)
+		vxlan_fdb_destroy(fdb->vdev, fdb, false, false);
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block vxlan_nexthop_notifier_block __read_mostly = {
+	.notifier_call = vxlan_nexthop_event,
+};
+
 static __net_init int vxlan_init_net(struct net *net)
 {
 	struct vxlan_net *vn = net_generic(net, vxlan_net_id);
@@ -4592,7 +4615,7 @@ static __net_init int vxlan_init_net(struct net *net)
 	for (h = 0; h < PORT_HASH_SIZE; ++h)
 		INIT_HLIST_HEAD(&vn->sock_list[h]);
 
-	return 0;
+	return register_nexthop_notifier(net, &vxlan_nexthop_notifier_block);
 }
 
 static void vxlan_destroy_tunnels(struct net *net, struct list_head *head)
@@ -4625,6 +4648,8 @@ static void __net_exit vxlan_exit_batch_net(struct list_head *net_list)
 
 	rtnl_lock();
 	list_for_each_entry(net, net_list, exit_list)
+		unregister_nexthop_notifier(net, &vxlan_nexthop_notifier_block);
+	list_for_each_entry(net, net_list, exit_list)
 		vxlan_destroy_tunnels(net, &list);
 
 	unregister_netdevice_many(&list);
-- 
2.1.4

