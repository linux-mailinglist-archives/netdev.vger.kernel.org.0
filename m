Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F234067461A
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 23:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbjASWcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 17:32:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbjASWcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 17:32:10 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44700AA5CC
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 14:15:45 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id s22-20020a17090aad9600b002271d094c82so3984704pjq.7
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 14:15:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uMaUYQPa2AhEmnKp+IZRnF6MpMm+3BbdF8Ehc7q/MJI=;
        b=lACtULaEZHOcrFUwEH/ChiiKUljLURG4Tgr2q9MCzMGGJWe43oxsctHjVNa1SAtZ3p
         unukQsq79EwpvbjXElUgRC6oWAknn1r1IjN7U2k4dDijarxxWWW8ZQf5uveMoFlLupjD
         hoOO9XBOZo+4ad+k2oQH2VvhCxSK/ecrWUgaXCsuzw0ejsCdTlCjobkmGZ4UFJ+Nu760
         0OaTTo/TOoWadF+SJW4Vl5+rfgNsZynC4bC1sWzBmkZ7Zp5i2w7x/ZWGWRt2RRHsDK0U
         qunTRupw9IXiINXyRF80saREfB/2RYXihIp72Pw6BloXtbBtXxRrqglcBTja1rMyWgbF
         vDOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uMaUYQPa2AhEmnKp+IZRnF6MpMm+3BbdF8Ehc7q/MJI=;
        b=zFLzmRhtzEpll3II0nQmaWn+5asbwEcV6WuV/UWpSiLX+iRUgJvCPiusKjNKTlSsWL
         va6OblEtP0yPVyZyqgVhEzOlWK2XQu/IlZBGMRb5n9cf1wZMVimU1HYWWdkLOFtkkemi
         1NEvE6IYALXXTRsNUfsllmMY1+Pc8G23HrfpbTfTQTouF8S5uhAmoBKbbUN2AjuoelnJ
         HR7l37L+DJ910IC6ju+O4ihhkP+wrWrVfOQIbMDDfeE+iyL/A+A0z+GwQrRvjyvWsatp
         dJIuxkMQgjVV/D1yAs1zEwJ/KNgpm6zg1vs+5/B9PPi8MijhdPWpsHnCABSUJT+0PGt/
         qwpw==
X-Gm-Message-State: AFqh2koVFJGqGEspHXgQaqAHHF2OioFE0e9/X5QTey7aJQl+mWyPpW/e
        o2+IywEd+HBWf3Zmoz0JEYOCeWM=
X-Google-Smtp-Source: AMrXdXstVQHnjFfw9iuQKM9xdSl+RzH0uWDNEnnmPq7sYK/u40J7QhTV0x9urDgv5hKOeViGzzc5GnU=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:aa7:972c:0:b0:579:6402:5b39 with SMTP id
 k12-20020aa7972c000000b0057964025b39mr1197545pfg.11.1674166544545; Thu, 19
 Jan 2023 14:15:44 -0800 (PST)
Date:   Thu, 19 Jan 2023 14:15:23 -0800
In-Reply-To: <20230119221536.3349901-1-sdf@google.com>
Mime-Version: 1.0
References: <20230119221536.3349901-1-sdf@google.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <20230119221536.3349901-5-sdf@google.com>
Subject: [PATCH bpf-next v8 04/17] bpf: Reshuffle some parts of bpf/offload.c
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
2.39.0.246.g2a6d74b583-goog

