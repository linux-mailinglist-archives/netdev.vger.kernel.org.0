Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6A391E95B3
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 06:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387414AbgEaEsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 00:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387410AbgEaEsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 00:48:51 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B87C05BD43
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 21:48:51 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id k2so3558253pjs.2
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 21:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QQuE+DBZlLqSBcSGuHdf8Whpv1PGyDsHzi+wuEr71ZM=;
        b=PtDUDC5P/V9mVBaopW+ZvSljj6rVRsqtJ8S2NpxGKg+KohFmk6zA2OqIa52Ur2OxWL
         8KY0uaoFdctXnNmGp4H5qsXNQ/V1RN1lRyTEfWikJYEc/TpPgn93xQkSJwV7rCFM6rgH
         FASDvnGQPXESI04jsFQyO2fnOYdYIeXuO6sNE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QQuE+DBZlLqSBcSGuHdf8Whpv1PGyDsHzi+wuEr71ZM=;
        b=YFBF7d9aw4RDLjGLWKySL3qxSF0xZNF7TdjaaPUiU/GDkKEYXG7cvTpUbX3eM2W4ph
         RMw3N+dj2+0QZoApltw1GAKOx/zRtHPVf05soY3qON+PRu7GSBZj0PmWdKvQyUPQwCy2
         cigC0yuXmmRvgzrekfVkwFJcNfoI4lmm/y6ipswZHXtZ7Hp7YHzZJLSRcROz7LaGS/lG
         K1/CH7wm+Z+aC0Lz2e0uhoLgC7gTuShkElJcecXPmXt5zx8oF6M0FKq3Sh/D5IRdjWHN
         mlvYK/vH0IS3zILGuQYPevi7v4GEusYXePZMjrkSbU0kOroYao48QBmVaBf03GLM8uOL
         NARw==
X-Gm-Message-State: AOAM5308KXiD/lR8Ugso0VIW2qGH3JxUbiH0aB+LxRONQZf+LsFBb9s3
        KBTBb4TjrhsojLC5rozGuByCtA==
X-Google-Smtp-Source: ABdhPJxNqBwGisG9RyFx54ajh8bjmFdD71iHg89TGAafVhv6W+UKQozvXze6gH10NJQlBdl/CcvWWw==
X-Received: by 2002:a17:902:26f:: with SMTP id 102mr13886798plc.209.1590900528525;
        Sat, 30 May 2020 21:48:48 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id m2sm3584312pjk.52.2020.05.30.21.48.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 30 May 2020 21:48:47 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        nikolay@cumulusnetworks.com, jiri@mellanox.com,
        idosch@mellanox.com, petrm@mellanox.com
Subject: [PATCH net-next v2 2/3] vxlan: few locking fixes in nexthop event handler
Date:   Sat, 30 May 2020 21:48:40 -0700
Message-Id: <1590900521-14647-3-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1590900521-14647-1-git-send-email-roopa@cumulusnetworks.com>
References: <1590900521-14647-1-git-send-email-roopa@cumulusnetworks.com>
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

