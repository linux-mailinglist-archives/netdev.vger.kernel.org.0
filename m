Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93BA81C4994
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 00:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728232AbgEDW2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 18:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728212AbgEDW2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 18:28:33 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA1FEC061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 15:28:33 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 18so45679pfv.8
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 15:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1cB14twuekU1YJH/tSo1tdOgfx/DodnrUu3THkwnHrg=;
        b=KAX4gB4F6XIexWZLE5LSGwAG9LraR0WVVNsx/8jylzNVCOiy+tXiIUCWGn2crzhxrV
         68zZ004IWcLnCkaaitNaQ3XVzK5MgTlXa9gZgxnKZqSCnAkcdGdrX0EsPeEF2LOla0ep
         9hr2K8KmKroODWczHcs3140xbTCJDolnHbrtE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1cB14twuekU1YJH/tSo1tdOgfx/DodnrUu3THkwnHrg=;
        b=nQHLO3qyH1QUJ7Zb1EkgmkwDVeVZE64ZawRNqWdeB4bV5YhbLiDddqLSO8h0ctsjWo
         Lt6PRXAjCAsiINaQEKjkPwwuqIlpVmIsvU+a1k5uwWx8B44xOZa1kDeY+bA5fKNG7GX1
         60P/0GxflRupP9Dbd6YL5fQNL3UQaAlq6AsLvURswITORVtHxJ4g9JUinM1vHebMcrZb
         4ZrnjFrCboWFqFZLGCtmLyULWNQrJZcbCJDCwBU3V2BgBHgx+F27G9Bh5lORj/26nBfs
         z+nde8h0fqi30BSfp/gxgC0B70oXNKekRwP5991gmfK339/v49xKG5ZknmSUZIIp45AH
         Geww==
X-Gm-Message-State: AGi0PuZui81IckPzIKPVSXeEM2hBm2xNE6ss7iP3rorw+L6qMewbEBRH
        WIlkpiq0mFo8F6gKyo+ZeX+TCQ==
X-Google-Smtp-Source: APiQypJbZ/3lrcqM9MFsZKQ2/wI88DTeTw5BaeFytNe36gQb6rrYerdo49PPYKDevBhBAxPDD1tq1A==
X-Received: by 2002:a63:f70f:: with SMTP id x15mr337107pgh.199.1588631313164;
        Mon, 04 May 2020 15:28:33 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id ie17sm21213pjb.19.2020.05.04.15.28.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 May 2020 15:28:32 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        idosch@mellanox.com, jiri@mellanox.com, petrm@mellanox.com
Subject: [RFC PATCH net-next 4/5] vxlan: support for nexthop notifiers
Date:   Mon,  4 May 2020 15:28:20 -0700
Message-Id: <1588631301-21564-5-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1588631301-21564-1-git-send-email-roopa@cumulusnetworks.com>
References: <1588631301-21564-1-git-send-email-roopa@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>

vxlan driver registers for nexthop add/del notifiers to
cleanup fdb entries pointing to nexthops.

Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
---
 drivers/net/vxlan.c | 36 +++++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 176f2b3..df6c5ff 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -81,6 +81,7 @@ struct vxlan_fdb {
 	u16		  flags;	/* see ndm_flags and below */
 	struct list_head  nh_list;
 	struct nexthop	  *nh;
+	struct vxlan_dev  *vdev;
 };
 
 #define NTF_VXLAN_ADDED_BY_USER 0x100
@@ -811,8 +812,9 @@ static int vxlan_gro_complete(struct sock *sk, struct sk_buff *skb, int nhoff)
 	return eth_gro_complete(skb, nhoff + sizeof(struct vxlanhdr));
 }
 
-static struct vxlan_fdb *vxlan_fdb_alloc(const u8 *mac, __u16 state,
-					 __be32 src_vni, __u16 ndm_flags)
+static struct vxlan_fdb *vxlan_fdb_alloc(struct vxlan_dev *vxlan, const u8 *mac,
+					 __u16 state, __be32 src_vni,
+					 __u16 ndm_flags)
 {
 	struct vxlan_fdb *f;
 
@@ -824,6 +826,7 @@ static struct vxlan_fdb *vxlan_fdb_alloc(const u8 *mac, __u16 state,
 	f->updated = f->used = jiffies;
 	f->vni = src_vni;
 	f->nh = NULL;
+	f->vdev = vxlan;
 	INIT_LIST_HEAD(&f->nh_list);
 	INIT_LIST_HEAD(&f->remotes);
 	memcpy(f->eth_addr, mac, ETH_ALEN);
@@ -902,7 +905,7 @@ static int vxlan_fdb_create(struct vxlan_dev *vxlan,
 		return -ENOSPC;
 
 	netdev_dbg(vxlan->dev, "add %pM -> %pIS\n", mac, ip);
-	f = vxlan_fdb_alloc(mac, state, src_vni, ndm_flags);
+	f = vxlan_fdb_alloc(vxlan, mac, state, src_vni, ndm_flags);
 	if (!f)
 		return -ENOMEM;
 
@@ -954,6 +957,7 @@ static void vxlan_fdb_destroy(struct vxlan_dev *vxlan, struct vxlan_fdb *f,
 					 swdev_notify, NULL);
 
 	hlist_del_rcu(&f->hlist);
+	f->vdev = NULL;
 	call_rcu(&f->rcu, vxlan_fdb_free);
 }
 
@@ -4576,6 +4580,25 @@ static struct notifier_block vxlan_switchdev_notifier_block __read_mostly = {
 	.notifier_call = vxlan_switchdev_event,
 };
 
+static int vxlan_nexthop_event(struct notifier_block *nb,
+			       unsigned long event, void *ptr)
+{
+	struct nexthop *nh = ptr;
+	struct vxlan_fdb *fdb;
+
+	if (!nh || event != NEXTHOP_EVENT_DEL)
+		return NOTIFY_DONE;
+
+	list_for_each_entry(fdb, &nh->fdb_list, nh_list)
+		vxlan_fdb_destroy(fdb->vdev, fdb, true, false);
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
@@ -4655,7 +4678,13 @@ static int __init vxlan_init_module(void)
 	if (rc)
 		goto out4;
 
+	rc = register_nexthop_notifier(&vxlan_nexthop_notifier_block);
+	if (rc)
+		goto out5;
+
 	return 0;
+out5:
+	rtnl_link_unregister(&vxlan_link_ops);
 out4:
 	unregister_switchdev_notifier(&vxlan_switchdev_notifier_block);
 out3:
@@ -4672,6 +4701,7 @@ static void __exit vxlan_cleanup_module(void)
 	rtnl_link_unregister(&vxlan_link_ops);
 	unregister_switchdev_notifier(&vxlan_switchdev_notifier_block);
 	unregister_netdevice_notifier(&vxlan_notifier_block);
+	unregister_nexthop_notifier(&vxlan_nexthop_notifier_block);
 	unregister_pernet_subsys(&vxlan_net_ops);
 	/* rcu_barrier() is called by netns */
 }
-- 
2.1.4

