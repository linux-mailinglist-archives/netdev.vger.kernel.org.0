Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D226B6667A9
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 01:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235089AbjALAcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 19:32:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231803AbjALAcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 19:32:47 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 360A63AB3C
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 16:32:39 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id mh11-20020a17090b4acb00b002271dde7ec6so3322725pjb.0
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 16:32:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nzrwtqxoT18C90ko5qH29Hib1sKDyAaEMw0UcTVessw=;
        b=n2yvGxbBFX7t9PiANHIQyUwJNBnwzqrvrJFiO5Qwj1ybG5utvRZcKBoC/NBDysFwoo
         voWvdLYBg4FTeAF9w3unUUQu+WTn4xalhjhfM5Fy+pSEsPpiI25HSY8RRRx71ulAKJi/
         8+amnGxQ2+eWHADBniFbT8KAzaEmntuROVUVOoe3e1TzbSkSlqAc7wCdesEQFUTLaa/M
         wmA2a3W5g1lPUPLO6bCoQdsbojsVZWLznjE3tpJX1/xV89f+It8h3fRcK/Gwq0oCI9dM
         4WkeDmkCVXO0ocz1r42DrAO7dmsyMwYKUafdPt98HXXsvNZ9T8W40m3LB8q11Fu2z28n
         MsJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nzrwtqxoT18C90ko5qH29Hib1sKDyAaEMw0UcTVessw=;
        b=ObtG3/FSuAdHcW/Q99edcFy379xTtGjTqdkHx5k4keHusx2o2SkLq2XPAW7ZWsfpA/
         MgBQ+uqgJDPY7mBccrXoRQCl/aV7QcGdVyqpUNlWL6E8gs212TKXfaQStKzIYO3Xa/X6
         oEu7yMgQs0v2A+Q4sGifrVPQ5L6HJqlbtXJ2vkXmdqJVp0UbfbJJPRA4df4fHX89VHiT
         hrdLuJFaBuu0cDF+FYNwBYSEeZDha8f1EMRzW5WkxVfjpBXuuweKw66gBejmSVqNL6hM
         Me4KunB3L9JbDntpjhjF3mDKYTSzn63zXpsCnYT+sJsfCUS4QCxy180XyAiVLpIcRtvh
         r6gQ==
X-Gm-Message-State: AFqh2koDer5/GueJRrOaX3tfO79bCt6UKjNsPnOBPHcyF/o5b15Pn5Zm
        zV9azIkZJVumBPiudmpB5a75aME=
X-Google-Smtp-Source: AMrXdXvGwBR+Xz2rnWOsP7J9wi4G6WqGe2zY4FgboDQtN0gZ89zyCZu6ufFE5ViZdUfMrXEqpQDqBdI=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:902:7c96:b0:192:b0a0:788f with SMTP id
 y22-20020a1709027c9600b00192b0a0788fmr4251867pll.51.1673483558603; Wed, 11
 Jan 2023 16:32:38 -0800 (PST)
Date:   Wed, 11 Jan 2023 16:32:17 -0800
In-Reply-To: <20230112003230.3779451-1-sdf@google.com>
Mime-Version: 1.0
References: <20230112003230.3779451-1-sdf@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230112003230.3779451-5-sdf@google.com>
Subject: [PATCH bpf-next v7 04/17] bpf: Reshuffle some parts of bpf/offload.c
From:   Stanislav Fomichev <sdf@google.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To avoid adding forward declarations in the main patch, shuffle
some code around. No functional changes.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Anatoly Burakov <anatoly.burakov@intel.com>
Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: Maryam Tahhan <mtahhan@redhat.com>
Cc: xdp-hints@xdp-project.net
Cc: netdev@vger.kernel.org
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 kernel/bpf/offload.c | 222 +++++++++++++++++++++++--------------------
 1 file changed, 117 insertions(+), 105 deletions(-)

diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
index 621e8738f304..deb06498da0b 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -74,6 +74,121 @@ bpf_offload_find_netdev(struct net_device *netdev)
 	return rhashtable_lookup_fast(&offdevs, &netdev, offdevs_params);
 }
 
+static int __bpf_offload_dev_netdev_register(struct bpf_offload_dev *offdev,
+					     struct net_device *netdev)
+{
+	struct bpf_offload_netdev *ondev;
+	int err;
+
+	ondev = kzalloc(sizeof(*ondev), GFP_KERNEL);
+	if (!ondev)
+		return -ENOMEM;
+
+	ondev->netdev = netdev;
+	ondev->offdev = offdev;
+	INIT_LIST_HEAD(&ondev->progs);
+	INIT_LIST_HEAD(&ondev->maps);
+
+	down_write(&bpf_devs_lock);
+	err = rhashtable_insert_fast(&offdevs, &ondev->l, offdevs_params);
+	if (err) {
+		netdev_warn(netdev, "failed to register for BPF offload\n");
+		goto err_unlock_free;
+	}
+
+	list_add(&ondev->offdev_netdevs, &offdev->netdevs);
+	up_write(&bpf_devs_lock);
+	return 0;
+
+err_unlock_free:
+	up_write(&bpf_devs_lock);
+	kfree(ondev);
+	return err;
+}
+
+static void __bpf_prog_offload_destroy(struct bpf_prog *prog)
+{
+	struct bpf_prog_offload *offload = prog->aux->offload;
+
+	if (offload->dev_state)
+		offload->offdev->ops->destroy(prog);
+
+	/* Make sure BPF_PROG_GET_NEXT_ID can't find this dead program */
+	bpf_prog_free_id(prog, true);
+
+	list_del_init(&offload->offloads);
+	kfree(offload);
+	prog->aux->offload = NULL;
+}
+
+static int bpf_map_offload_ndo(struct bpf_offloaded_map *offmap,
+			       enum bpf_netdev_command cmd)
+{
+	struct netdev_bpf data = {};
+	struct net_device *netdev;
+
+	ASSERT_RTNL();
+
+	data.command = cmd;
+	data.offmap = offmap;
+	/* Caller must make sure netdev is valid */
+	netdev = offmap->netdev;
+
+	return netdev->netdev_ops->ndo_bpf(netdev, &data);
+}
+
+static void __bpf_map_offload_destroy(struct bpf_offloaded_map *offmap)
+{
+	WARN_ON(bpf_map_offload_ndo(offmap, BPF_OFFLOAD_MAP_FREE));
+	/* Make sure BPF_MAP_GET_NEXT_ID can't find this dead map */
+	bpf_map_free_id(&offmap->map, true);
+	list_del_init(&offmap->offloads);
+	offmap->netdev = NULL;
+}
+
+static void __bpf_offload_dev_netdev_unregister(struct bpf_offload_dev *offdev,
+						struct net_device *netdev)
+{
+	struct bpf_offload_netdev *ondev, *altdev;
+	struct bpf_offloaded_map *offmap, *mtmp;
+	struct bpf_prog_offload *offload, *ptmp;
+
+	ASSERT_RTNL();
+
+	down_write(&bpf_devs_lock);
+	ondev = rhashtable_lookup_fast(&offdevs, &netdev, offdevs_params);
+	if (WARN_ON(!ondev))
+		goto unlock;
+
+	WARN_ON(rhashtable_remove_fast(&offdevs, &ondev->l, offdevs_params));
+	list_del(&ondev->offdev_netdevs);
+
+	/* Try to move the objects to another netdev of the device */
+	altdev = list_first_entry_or_null(&offdev->netdevs,
+					  struct bpf_offload_netdev,
+					  offdev_netdevs);
+	if (altdev) {
+		list_for_each_entry(offload, &ondev->progs, offloads)
+			offload->netdev = altdev->netdev;
+		list_splice_init(&ondev->progs, &altdev->progs);
+
+		list_for_each_entry(offmap, &ondev->maps, offloads)
+			offmap->netdev = altdev->netdev;
+		list_splice_init(&ondev->maps, &altdev->maps);
+	} else {
+		list_for_each_entry_safe(offload, ptmp, &ondev->progs, offloads)
+			__bpf_prog_offload_destroy(offload->prog);
+		list_for_each_entry_safe(offmap, mtmp, &ondev->maps, offloads)
+			__bpf_map_offload_destroy(offmap);
+	}
+
+	WARN_ON(!list_empty(&ondev->progs));
+	WARN_ON(!list_empty(&ondev->maps));
+	kfree(ondev);
+unlock:
+	up_write(&bpf_devs_lock);
+}
+
 int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr)
 {
 	struct bpf_offload_netdev *ondev;
@@ -206,21 +321,6 @@ bpf_prog_offload_remove_insns(struct bpf_verifier_env *env, u32 off, u32 cnt)
 	up_read(&bpf_devs_lock);
 }
 
-static void __bpf_prog_offload_destroy(struct bpf_prog *prog)
-{
-	struct bpf_prog_offload *offload = prog->aux->offload;
-
-	if (offload->dev_state)
-		offload->offdev->ops->destroy(prog);
-
-	/* Make sure BPF_PROG_GET_NEXT_ID can't find this dead program */
-	bpf_prog_free_id(prog, true);
-
-	list_del_init(&offload->offloads);
-	kfree(offload);
-	prog->aux->offload = NULL;
-}
-
 void bpf_prog_offload_destroy(struct bpf_prog *prog)
 {
 	down_write(&bpf_devs_lock);
@@ -340,22 +440,6 @@ int bpf_prog_offload_info_fill(struct bpf_prog_info *info,
 const struct bpf_prog_ops bpf_offload_prog_ops = {
 };
 
-static int bpf_map_offload_ndo(struct bpf_offloaded_map *offmap,
-			       enum bpf_netdev_command cmd)
-{
-	struct netdev_bpf data = {};
-	struct net_device *netdev;
-
-	ASSERT_RTNL();
-
-	data.command = cmd;
-	data.offmap = offmap;
-	/* Caller must make sure netdev is valid */
-	netdev = offmap->netdev;
-
-	return netdev->netdev_ops->ndo_bpf(netdev, &data);
-}
-
 struct bpf_map *bpf_map_offload_map_alloc(union bpf_attr *attr)
 {
 	struct net *net = current->nsproxy->net_ns;
@@ -405,15 +489,6 @@ struct bpf_map *bpf_map_offload_map_alloc(union bpf_attr *attr)
 	return ERR_PTR(err);
 }
 
-static void __bpf_map_offload_destroy(struct bpf_offloaded_map *offmap)
-{
-	WARN_ON(bpf_map_offload_ndo(offmap, BPF_OFFLOAD_MAP_FREE));
-	/* Make sure BPF_MAP_GET_NEXT_ID can't find this dead map */
-	bpf_map_free_id(&offmap->map, true);
-	list_del_init(&offmap->offloads);
-	offmap->netdev = NULL;
-}
-
 void bpf_map_offload_map_free(struct bpf_map *map)
 {
 	struct bpf_offloaded_map *offmap = map_to_offmap(map);
@@ -592,77 +667,14 @@ bool bpf_offload_prog_map_match(struct bpf_prog *prog, struct bpf_map *map)
 int bpf_offload_dev_netdev_register(struct bpf_offload_dev *offdev,
 				    struct net_device *netdev)
 {
-	struct bpf_offload_netdev *ondev;
-	int err;
-
-	ondev = kzalloc(sizeof(*ondev), GFP_KERNEL);
-	if (!ondev)
-		return -ENOMEM;
-
-	ondev->netdev = netdev;
-	ondev->offdev = offdev;
-	INIT_LIST_HEAD(&ondev->progs);
-	INIT_LIST_HEAD(&ondev->maps);
-
-	down_write(&bpf_devs_lock);
-	err = rhashtable_insert_fast(&offdevs, &ondev->l, offdevs_params);
-	if (err) {
-		netdev_warn(netdev, "failed to register for BPF offload\n");
-		goto err_unlock_free;
-	}
-
-	list_add(&ondev->offdev_netdevs, &offdev->netdevs);
-	up_write(&bpf_devs_lock);
-	return 0;
-
-err_unlock_free:
-	up_write(&bpf_devs_lock);
-	kfree(ondev);
-	return err;
+	return __bpf_offload_dev_netdev_register(offdev, netdev);
 }
 EXPORT_SYMBOL_GPL(bpf_offload_dev_netdev_register);
 
 void bpf_offload_dev_netdev_unregister(struct bpf_offload_dev *offdev,
 				       struct net_device *netdev)
 {
-	struct bpf_offload_netdev *ondev, *altdev;
-	struct bpf_offloaded_map *offmap, *mtmp;
-	struct bpf_prog_offload *offload, *ptmp;
-
-	ASSERT_RTNL();
-
-	down_write(&bpf_devs_lock);
-	ondev = rhashtable_lookup_fast(&offdevs, &netdev, offdevs_params);
-	if (WARN_ON(!ondev))
-		goto unlock;
-
-	WARN_ON(rhashtable_remove_fast(&offdevs, &ondev->l, offdevs_params));
-	list_del(&ondev->offdev_netdevs);
-
-	/* Try to move the objects to another netdev of the device */
-	altdev = list_first_entry_or_null(&offdev->netdevs,
-					  struct bpf_offload_netdev,
-					  offdev_netdevs);
-	if (altdev) {
-		list_for_each_entry(offload, &ondev->progs, offloads)
-			offload->netdev = altdev->netdev;
-		list_splice_init(&ondev->progs, &altdev->progs);
-
-		list_for_each_entry(offmap, &ondev->maps, offloads)
-			offmap->netdev = altdev->netdev;
-		list_splice_init(&ondev->maps, &altdev->maps);
-	} else {
-		list_for_each_entry_safe(offload, ptmp, &ondev->progs, offloads)
-			__bpf_prog_offload_destroy(offload->prog);
-		list_for_each_entry_safe(offmap, mtmp, &ondev->maps, offloads)
-			__bpf_map_offload_destroy(offmap);
-	}
-
-	WARN_ON(!list_empty(&ondev->progs));
-	WARN_ON(!list_empty(&ondev->maps));
-	kfree(ondev);
-unlock:
-	up_write(&bpf_devs_lock);
+	__bpf_offload_dev_netdev_unregister(offdev, netdev);
 }
 EXPORT_SYMBOL_GPL(bpf_offload_dev_netdev_unregister);
 
-- 
2.39.0.314.g84b9a713c41-goog

