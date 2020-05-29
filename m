Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C38211E7537
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 07:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725920AbgE2FMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 01:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbgE2FMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 01:12:45 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9194C08C5C6
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 22:12:44 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id d66so677483pfd.6
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 22:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QQuE+DBZlLqSBcSGuHdf8Whpv1PGyDsHzi+wuEr71ZM=;
        b=aQtshDYEEuhW80F0i5xpsESZt9xJeWzwKhJ0+hmtFJ7h03eNQ8j542BfGNVBToSY8q
         KusnRAEkltcvVT+nU81xQ8S834ebUNgB+1vXDEwPHrDWRQa5suWishaX59RYHsaVF8wC
         RGeYLKKJoL/56BpyOlzS9SlfFm+VX/Az7d5Ew=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QQuE+DBZlLqSBcSGuHdf8Whpv1PGyDsHzi+wuEr71ZM=;
        b=hefLYzYT1KPkQx1xP9OK6hl+hA5E7acDkmD/D4cc7fuJJz9/BmVoPyvdeEu5I1M9lS
         a/DoFw1PkiM3yj9H2qczSIcW440QDxZROJudVFXbOlMuk8dhgIecnVvBRT5H3hNxV4Q3
         EvJsZodUbFhPk7jZiUfjNhULSGy1h+RB1Xcnzm5YevclTQJKXLCj4aK3/f6aIhl2fS78
         fXIpia8kRSpIahj4Zub/GcJoATXllOFLvYIcP5DiVwNg8pz3jD6Ic0ok9Xk8BZhx4jYO
         1Nh2f0WXFQINJPOzPSSI5lZpExy0b+qjSv2JMMTELNXArswv1s23TfrHjT2QkSnzg4W0
         BxFw==
X-Gm-Message-State: AOAM5330HADoc7W3h/F1+bp/Jl/CGRr8zuGOC4mpmvpeg5su9TTofRXJ
        KqgMpfpqRgqrfq/GQrh0i8mxtgXD+Os=
X-Google-Smtp-Source: ABdhPJzLdLf9eY4v9VqDI4NIwQl8uLX3a3Zrtt7h3HQUmiWunGSkVM7oh0lkvfF1pYBYuwo6JMo3TA==
X-Received: by 2002:a63:482:: with SMTP id 124mr6561564pge.169.1590729164370;
        Thu, 28 May 2020 22:12:44 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id z20sm6935634pjn.53.2020.05.28.22.12.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 28 May 2020 22:12:43 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        nikolay@cumulusnetworks.com, jiri@mellanox.com,
        idosch@mellanox.com, petrm@mellanox.com
Subject: [PATCH net-next 2/2] vxlan: few locking fixes in nexthop event handler
Date:   Thu, 28 May 2020 22:12:36 -0700
Message-Id: <1590729156-35543-3-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1590729156-35543-1-git-send-email-roopa@cumulusnetworks.com>
References: <1590729156-35543-1-git-send-email-roopa@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>

- remove fdb from nh_list before the rcu grace period
- protect fdb->vdev with rcu
- hold spin lock before destroying fdb

Fixes: c7cdbe2efc40 ("vxlan: support for nexthop notifiers")
Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
Reviewed-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 drivers/net/vxlan.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index fe606c6..39bc10a 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -81,7 +81,7 @@ struct vxlan_fdb {
 	u16		  flags;	/* see ndm_flags and below */
 	struct list_head  nh_list;
 	struct nexthop __rcu *nh;
-	struct vxlan_dev  *vdev;
+	struct vxlan_dev  __rcu *vdev;
 };
 
 #define NTF_VXLAN_ADDED_BY_USER 0x100
@@ -837,7 +837,7 @@ static struct vxlan_fdb *vxlan_fdb_alloc(struct vxlan_dev *vxlan, const u8 *mac,
 	f->updated = f->used = jiffies;
 	f->vni = src_vni;
 	f->nh = NULL;
-	f->vdev = vxlan;
+	RCU_INIT_POINTER(f->vdev, vxlan);
 	INIT_LIST_HEAD(&f->nh_list);
 	INIT_LIST_HEAD(&f->remotes);
 	memcpy(f->eth_addr, mac, ETH_ALEN);
@@ -963,7 +963,7 @@ static void __vxlan_fdb_free(struct vxlan_fdb *f)
 	nh = rcu_dereference_raw(f->nh);
 	if (nh) {
 		rcu_assign_pointer(f->nh, NULL);
-		list_del_rcu(&f->nh_list);
+		rcu_assign_pointer(f->vdev, NULL);
 		nexthop_put(nh);
 	}
 
@@ -1000,7 +1000,7 @@ static void vxlan_fdb_destroy(struct vxlan_dev *vxlan, struct vxlan_fdb *f,
 	}
 
 	hlist_del_rcu(&f->hlist);
-	f->vdev = NULL;
+	list_del_rcu(&f->nh_list);
 	call_rcu(&f->rcu, vxlan_fdb_free);
 }
 
@@ -4615,17 +4615,35 @@ static struct notifier_block vxlan_switchdev_notifier_block __read_mostly = {
 	.notifier_call = vxlan_switchdev_event,
 };
 
+static void vxlan_fdb_nh_flush(struct nexthop *nh)
+{
+	struct vxlan_fdb *fdb;
+	struct vxlan_dev *vxlan;
+	u32 hash_index;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(fdb, &nh->fdb_list, nh_list) {
+		vxlan = rcu_dereference(fdb->vdev);
+		WARN_ON(!vxlan);
+		hash_index = fdb_head_index(vxlan, fdb->eth_addr,
+					    vxlan->default_dst.remote_vni);
+		spin_lock_bh(&vxlan->hash_lock[hash_index]);
+		if (!hlist_unhashed(&fdb->hlist))
+			vxlan_fdb_destroy(vxlan, fdb, false, false);
+		spin_unlock_bh(&vxlan->hash_lock[hash_index]);
+	}
+	rcu_read_unlock();
+}
+
 static int vxlan_nexthop_event(struct notifier_block *nb,
 			       unsigned long event, void *ptr)
 {
 	struct nexthop *nh = ptr;
-	struct vxlan_fdb *fdb, *tmp;
 
 	if (!nh || event != NEXTHOP_EVENT_DEL)
 		return NOTIFY_DONE;
 
-	list_for_each_entry_safe(fdb, tmp, &nh->fdb_list, nh_list)
-		vxlan_fdb_destroy(fdb->vdev, fdb, false, false);
+	vxlan_fdb_nh_flush(nh);
 
 	return NOTIFY_DONE;
 }
-- 
2.1.4

