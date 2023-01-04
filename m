Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7480265DF6D
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 23:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240463AbjADWAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 17:00:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240368AbjADWAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 17:00:04 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CE83D9DF
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 13:59:58 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id e184-20020a6369c1000000b0049de6cfcc40so7930215pgc.19
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 13:59:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nzrwtqxoT18C90ko5qH29Hib1sKDyAaEMw0UcTVessw=;
        b=f3kjGH1zA/ej+MdZ3diybR4xZGuBexKRxxzHo/j3NKAFG44R6pDWe2jeyccQgYhNWS
         l+/IH4NpU3AINwho/inBcIjPC0cVMaEGlq0mwedEFzO0BmKSu7OFBl0JLnNSsX6Huhmo
         k6h9wqbKfxa4l3TXijI5dm7gmhOjAjqsIjJCH1iV3G88DN8WD0ZB9VRByEhFKNgd5bp+
         /e2/c+DMXRCgdj4Mwqdsyu4dyU/v9RpbcJ27MW7r85pYU+34McUATNSOtGG4l49bgv/v
         YQpSdLZi224dNRGpQDi5B76IUrRvSS+Tucmv/wd1F/p7rCZ9sraQdYsKriMRfanMTST8
         xb4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nzrwtqxoT18C90ko5qH29Hib1sKDyAaEMw0UcTVessw=;
        b=ypjGx+CeDVH/9K/hiom8qFWCrPDwCx2OFizvLxf/yG+V3MBEoGbdLEsRnJ1+7Zri49
         Tlr0gTMrDeS4kHqgzO3gUXfM1Ma4uW5VquCyfaQCtoFE+I5qGdcyRtinidgPDg9qUtwG
         7sVlQFNiKPO+8As5vhHvKqoYySE9cB0QNFKmzY0uf7VPmiR4nuUApSxqUh9NNOoSWQur
         5X9YVaYCfaScwIiddPO0tg1La3K8yFF8aCaSs6tKd3pD2Ptj5NfQS3VZuDSrx//d87gt
         SS0VSPXriDgYMngbKQ6PRnv98QuXeIToYVMJ+lx6wRXJ/8MIhagn7irgmKcTwR2hK5Lx
         dd0A==
X-Gm-Message-State: AFqh2krhyd+tsIGPAPqiMquPiPecwhE4A7VWY/zdn7BeSogXFjrJuYO3
        kNjq7gOVnptG0hrfoW+PZ+HIbas=
X-Google-Smtp-Source: AMrXdXvjFquzSIAnqUcDjDCjU7U7S8SmVBEir9qsnXsKsP8lugaPk6ZDNA6QJgM4y2rOSiiMKf/X8dI=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:aa7:914e:0:b0:578:202d:a33a with SMTP id
 14-20020aa7914e000000b00578202da33amr2340556pfi.23.1672869597727; Wed, 04 Jan
 2023 13:59:57 -0800 (PST)
Date:   Wed,  4 Jan 2023 13:59:36 -0800
In-Reply-To: <20230104215949.529093-1-sdf@google.com>
Mime-Version: 1.0
References: <20230104215949.529093-1-sdf@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230104215949.529093-5-sdf@google.com>
Subject: [PATCH bpf-next v6 04/17] bpf: Reshuffle some parts of bpf/offload.c
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
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

