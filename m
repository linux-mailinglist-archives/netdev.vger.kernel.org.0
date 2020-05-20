Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6938F1DA948
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 06:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726737AbgETEds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 00:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbgETEdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 00:33:45 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF591C061A0E
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 21:33:45 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id r22so840979pga.12
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 21:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=h+hhQmrJ6HCY9TQ31d4smzPdyfCPwbWlYkBnMGeZIvA=;
        b=ZEOMc+Jy92vzs8CxRIJkpr9VldUeTnJuOb7naMwC8ktkFh5kSwjtsnBzy7Twm3hkIL
         qgn7+IK5PdMFaXhwf5+8OMNPq2mh3C0ZKxgSTcPuZJIDnMcsQ4QAq0jPWLzhAvO2JEH9
         C7pdDaKBbD4zguNN1Nm+K74nlyM7coVgcdAOI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=h+hhQmrJ6HCY9TQ31d4smzPdyfCPwbWlYkBnMGeZIvA=;
        b=k4F3Jridu0px1gNMfzqF85RpjreZCuXGQB2WJfjOS5teY8UM94agrD3Nb5S5YEkWMX
         cqRkH3wyLIn/Juc5ZNrpqoVgYlEv2chZ0bruVVQ1g2zq+Xz7wE+SB5ZsIZ3hrbkgvAhT
         xHV2szrsfgNlLmTT+e/FPKdbNRxW3HoZ6tlxMnFE0Z1B3gfBWmLVUpcLrZdsrMQ5qMZI
         m+Tc4brMK07T+MqSfFFNf3WTAaEmMl6P0IVvrsxwKF9yUN0/iNJHKiZegw3exxnoC4JX
         526pMHi8wPoueX1rRUMgjYRLNon9T+/amiazGSILZZw1LJSIqZP7WFd0i1dVlO1Hc0Y6
         MHLQ==
X-Gm-Message-State: AOAM5309WotgoJNK+FXtiVOP24+8CY1rJNZAHIEFQpOAksOrXjauWAi6
        /2++f0HsnGN/9oethDLOVFCw8Q==
X-Google-Smtp-Source: ABdhPJzFR3Y5RygPH1TDRAXhwVEe4OY2P2EKVj1ViwDpW6qMq40mEaOt5pofzeac5zQh51PjTYKXHg==
X-Received: by 2002:aa7:9d0e:: with SMTP id k14mr2419209pfp.13.1589949225224;
        Tue, 19 May 2020 21:33:45 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id g17sm753250pgg.43.2020.05.19.21.33.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 May 2020 21:33:44 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        jiri@mellanox.com, idosch@mellanox.com, petrm@mellanox.com
Subject: [PATCH net-next v2 4/5] vxlan: support for nexthop notifiers
Date:   Tue, 19 May 2020 21:33:33 -0700
Message-Id: <1589949214-14711-5-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1589949214-14711-1-git-send-email-roopa@cumulusnetworks.com>
References: <1589949214-14711-1-git-send-email-roopa@cumulusnetworks.com>
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
index 380d887..275b55e 100644
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
@@ -923,7 +926,7 @@ static int vxlan_fdb_create(struct vxlan_dev *vxlan,
 		return -ENOSPC;
 
 	netdev_dbg(vxlan->dev, "add %pM -> %pIS\n", mac, ip);
-	f = vxlan_fdb_alloc(mac, state, src_vni, ndm_flags);
+	f = vxlan_fdb_alloc(vxlan, mac, state, src_vni, ndm_flags);
 	if (!f)
 		return -ENOMEM;
 
@@ -988,6 +991,7 @@ static void vxlan_fdb_destroy(struct vxlan_dev *vxlan, struct vxlan_fdb *f,
 	}
 
 	hlist_del_rcu(&f->hlist);
+	f->vdev = NULL;
 	call_rcu(&f->rcu, vxlan_fdb_free);
 }
 
@@ -4593,6 +4597,25 @@ static struct notifier_block vxlan_switchdev_notifier_block __read_mostly = {
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
@@ -4604,7 +4627,7 @@ static __net_init int vxlan_init_net(struct net *net)
 	for (h = 0; h < PORT_HASH_SIZE; ++h)
 		INIT_HLIST_HEAD(&vn->sock_list[h]);
 
-	return 0;
+	return register_nexthop_notifier(net, &vxlan_nexthop_notifier_block);
 }
 
 static void vxlan_destroy_tunnels(struct net *net, struct list_head *head)
@@ -4637,6 +4660,8 @@ static void __net_exit vxlan_exit_batch_net(struct list_head *net_list)
 
 	rtnl_lock();
 	list_for_each_entry(net, net_list, exit_list)
+		unregister_nexthop_notifier(net, &vxlan_nexthop_notifier_block);
+	list_for_each_entry(net, net_list, exit_list)
 		vxlan_destroy_tunnels(net, &list);
 
 	unregister_netdevice_many(&list);
-- 
2.1.4

