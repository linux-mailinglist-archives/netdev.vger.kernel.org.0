Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEF124C0FC3
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 11:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239462AbiBWKD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 05:03:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239453AbiBWKD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 05:03:26 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04048A339;
        Wed, 23 Feb 2022 02:02:58 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id q23so3935531wra.2;
        Wed, 23 Feb 2022 02:02:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SqAxPQEsa3A4xyob3zluFv3tjziMIdKJYPYJeW3AAL8=;
        b=MBhdzcrVPaltuC7QO4FnB3SnkoeVXpFvLTouDASO7IzH2peZCz9lBAMGqOWde8Qh8D
         kDOHiVkykGHwJ9ODUCowoUI5o8pHBoXYYTm8ATT3j0JUyxrqlLHIERCZnrLli6QX00Ow
         ARevI9oTrw6Ql0amtIF96nKDvBQ9IRAHmr1mVVGh8IVL6kL5UvvSlCTqbxzYnSEZvw58
         nc82P9ORs3OhQEn60SVYMaBi5QPQPP2fM2POKJutuOt+Y6q+71UeevbRXTpV3xLjaYIf
         8XeNS0KGWZbwj0GuBmUdHJ/zi9K2C3BiL7MgnFzPYxm5wMxePOyJmfELVNujZYFKUQLE
         R4Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SqAxPQEsa3A4xyob3zluFv3tjziMIdKJYPYJeW3AAL8=;
        b=ScmgGOwBvYXoVL39h/ShGnowRZTiOaJY0SwKnxsgOv9b5BbevCrE27kVqxJfIjDj39
         CMdbXeqrHbXPqjtq2jhcAJd40aRNIXnSUvCs99GefckcDMzyZ6KfzDAMpehh7jJBaLzb
         /7JXwIHN3qjYqMtVbZzmSwAcv3+hqfPgzzSvHgRbnMKpH34oTh4EyMzXX2ufX9tBkq9O
         egP31AaZ6bE0LIyIu8EinBkk3wm5jN0ru/VHEaraVZo9jbKW3gUhQ1hqhp2Ik+VH/Bi9
         y5ghCztTJMdFQXQuXUn5a8NY4UzLAp18fiXC9f8Px2zGxfYREAzYUrqoIomNZ5fvB9WQ
         Sj2g==
X-Gm-Message-State: AOAM531G+XWC+70xuJYtzo6TGHQn8+ecdT2QvQcbw8FfrXHJr4dpZxjT
        Qix7PZUtGjtvZ3/ZI0e11mjzKTxs9q4=
X-Google-Smtp-Source: ABdhPJyen0Gk7YkQnDQ//DA3TU+euR7cTv4E1ji+jT3VElJm06SuRDFWQiJ5DQuVZ8gyfFYvc+vmfg==
X-Received: by 2002:a5d:47cc:0:b0:1e8:50e2:94cd with SMTP id o12-20020a5d47cc000000b001e850e294cdmr22222983wrc.34.1645610577241;
        Wed, 23 Feb 2022 02:02:57 -0800 (PST)
Received: from localhost.localdomain (host-79-27-0-81.retail.telecomitalia.it. [79.27.0.81])
        by smtp.gmail.com with ESMTPSA id f14sm5856887wmq.3.2022.02.23.02.02.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 02:02:56 -0800 (PST)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     Karsten Graul <kgraul@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Lu <tonylu@linux.alibaba.com>
Cc:     "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        syzbot+4f322a6d84e991c38775@syzkaller.appspotmail.com
Subject: [PATCH] net/smc: Use a mutex for locking "struct smc_pnettable"
Date:   Wed, 23 Feb 2022 11:02:52 +0100
Message-Id: <20220223100252.22562-1-fmdefrancesco@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

smc_pnetid_by_table_ib() uses read_lock() and then it calls smc_pnet_apply_ib()
which, in turn, calls mutex_lock(&smc_ib_devices.mutex).

read_lock() disables preemption. Therefore, the code acquires a mutex while in
atomic context and it leads to a SAC bug.

Fix this bug by replacing the rwlock with a mutex.

Reported-and-tested-by: syzbot+4f322a6d84e991c38775@syzkaller.appspotmail.com
Fixes: 64e28b52c7a6 ("net/smc: add pnet table namespace support")
Confirmed-by: Tony Lu <tonylu@linux.alibaba.com>
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
---
 net/smc/smc_pnet.c | 42 +++++++++++++++++++++---------------------
 net/smc/smc_pnet.h |  2 +-
 2 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index 0599246c0376..29f0a559d884 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -113,7 +113,7 @@ static int smc_pnet_remove_by_pnetid(struct net *net, char *pnet_name)
 	pnettable = &sn->pnettable;
 
 	/* remove table entry */
-	write_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry_safe(pnetelem, tmp_pe, &pnettable->pnetlist,
 				 list) {
 		if (!pnet_name ||
@@ -131,7 +131,7 @@ static int smc_pnet_remove_by_pnetid(struct net *net, char *pnet_name)
 			rc = 0;
 		}
 	}
-	write_unlock(&pnettable->lock);
+	mutex_unlock(&pnettable->lock);
 
 	/* if this is not the initial namespace, stop here */
 	if (net != &init_net)
@@ -192,7 +192,7 @@ static int smc_pnet_add_by_ndev(struct net_device *ndev)
 	sn = net_generic(net, smc_net_id);
 	pnettable = &sn->pnettable;
 
-	write_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry_safe(pnetelem, tmp_pe, &pnettable->pnetlist, list) {
 		if (pnetelem->type == SMC_PNET_ETH && !pnetelem->ndev &&
 		    !strncmp(pnetelem->eth_name, ndev->name, IFNAMSIZ)) {
@@ -206,7 +206,7 @@ static int smc_pnet_add_by_ndev(struct net_device *ndev)
 			break;
 		}
 	}
-	write_unlock(&pnettable->lock);
+	mutex_unlock(&pnettable->lock);
 	return rc;
 }
 
@@ -224,7 +224,7 @@ static int smc_pnet_remove_by_ndev(struct net_device *ndev)
 	sn = net_generic(net, smc_net_id);
 	pnettable = &sn->pnettable;
 
-	write_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry_safe(pnetelem, tmp_pe, &pnettable->pnetlist, list) {
 		if (pnetelem->type == SMC_PNET_ETH && pnetelem->ndev == ndev) {
 			dev_put_track(pnetelem->ndev, &pnetelem->dev_tracker);
@@ -237,7 +237,7 @@ static int smc_pnet_remove_by_ndev(struct net_device *ndev)
 			break;
 		}
 	}
-	write_unlock(&pnettable->lock);
+	mutex_unlock(&pnettable->lock);
 	return rc;
 }
 
@@ -370,7 +370,7 @@ static int smc_pnet_add_eth(struct smc_pnettable *pnettable, struct net *net,
 	strncpy(new_pe->eth_name, eth_name, IFNAMSIZ);
 	rc = -EEXIST;
 	new_netdev = true;
-	write_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry(tmp_pe, &pnettable->pnetlist, list) {
 		if (tmp_pe->type == SMC_PNET_ETH &&
 		    !strncmp(tmp_pe->eth_name, eth_name, IFNAMSIZ)) {
@@ -385,9 +385,9 @@ static int smc_pnet_add_eth(struct smc_pnettable *pnettable, struct net *net,
 					     GFP_ATOMIC);
 		}
 		list_add_tail(&new_pe->list, &pnettable->pnetlist);
-		write_unlock(&pnettable->lock);
+		mutex_unlock(&pnettable->lock);
 	} else {
-		write_unlock(&pnettable->lock);
+		mutex_unlock(&pnettable->lock);
 		kfree(new_pe);
 		goto out_put;
 	}
@@ -448,7 +448,7 @@ static int smc_pnet_add_ib(struct smc_pnettable *pnettable, char *ib_name,
 	new_pe->ib_port = ib_port;
 
 	new_ibdev = true;
-	write_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry(tmp_pe, &pnettable->pnetlist, list) {
 		if (tmp_pe->type == SMC_PNET_IB &&
 		    !strncmp(tmp_pe->ib_name, ib_name, IB_DEVICE_NAME_MAX)) {
@@ -458,9 +458,9 @@ static int smc_pnet_add_ib(struct smc_pnettable *pnettable, char *ib_name,
 	}
 	if (new_ibdev) {
 		list_add_tail(&new_pe->list, &pnettable->pnetlist);
-		write_unlock(&pnettable->lock);
+		mutex_unlock(&pnettable->lock);
 	} else {
-		write_unlock(&pnettable->lock);
+		mutex_unlock(&pnettable->lock);
 		kfree(new_pe);
 	}
 	return (new_ibdev) ? 0 : -EEXIST;
@@ -605,7 +605,7 @@ static int _smc_pnet_dump(struct net *net, struct sk_buff *skb, u32 portid,
 	pnettable = &sn->pnettable;
 
 	/* dump pnettable entries */
-	read_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry(pnetelem, &pnettable->pnetlist, list) {
 		if (pnetid && !smc_pnet_match(pnetelem->pnet_name, pnetid))
 			continue;
@@ -620,7 +620,7 @@ static int _smc_pnet_dump(struct net *net, struct sk_buff *skb, u32 portid,
 			break;
 		}
 	}
-	read_unlock(&pnettable->lock);
+	mutex_unlock(&pnettable->lock);
 	return idx;
 }
 
@@ -864,7 +864,7 @@ int smc_pnet_net_init(struct net *net)
 	struct smc_pnetids_ndev *pnetids_ndev = &sn->pnetids_ndev;
 
 	INIT_LIST_HEAD(&pnettable->pnetlist);
-	rwlock_init(&pnettable->lock);
+	mutex_init(&pnettable->lock);
 	INIT_LIST_HEAD(&pnetids_ndev->list);
 	rwlock_init(&pnetids_ndev->lock);
 
@@ -944,7 +944,7 @@ static int smc_pnet_find_ndev_pnetid_by_table(struct net_device *ndev,
 	sn = net_generic(net, smc_net_id);
 	pnettable = &sn->pnettable;
 
-	read_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry(pnetelem, &pnettable->pnetlist, list) {
 		if (pnetelem->type == SMC_PNET_ETH && ndev == pnetelem->ndev) {
 			/* get pnetid of netdev device */
@@ -953,7 +953,7 @@ static int smc_pnet_find_ndev_pnetid_by_table(struct net_device *ndev,
 			break;
 		}
 	}
-	read_unlock(&pnettable->lock);
+	mutex_unlock(&pnettable->lock);
 	return rc;
 }
 
@@ -1156,7 +1156,7 @@ int smc_pnetid_by_table_ib(struct smc_ib_device *smcibdev, u8 ib_port)
 	sn = net_generic(&init_net, smc_net_id);
 	pnettable = &sn->pnettable;
 
-	read_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry(tmp_pe, &pnettable->pnetlist, list) {
 		if (tmp_pe->type == SMC_PNET_IB &&
 		    !strncmp(tmp_pe->ib_name, ib_name, IB_DEVICE_NAME_MAX) &&
@@ -1166,7 +1166,7 @@ int smc_pnetid_by_table_ib(struct smc_ib_device *smcibdev, u8 ib_port)
 			break;
 		}
 	}
-	read_unlock(&pnettable->lock);
+	mutex_unlock(&pnettable->lock);
 
 	return rc;
 }
@@ -1185,7 +1185,7 @@ int smc_pnetid_by_table_smcd(struct smcd_dev *smcddev)
 	sn = net_generic(&init_net, smc_net_id);
 	pnettable = &sn->pnettable;
 
-	read_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry(tmp_pe, &pnettable->pnetlist, list) {
 		if (tmp_pe->type == SMC_PNET_IB &&
 		    !strncmp(tmp_pe->ib_name, ib_name, IB_DEVICE_NAME_MAX)) {
@@ -1194,7 +1194,7 @@ int smc_pnetid_by_table_smcd(struct smcd_dev *smcddev)
 			break;
 		}
 	}
-	read_unlock(&pnettable->lock);
+	mutex_unlock(&pnettable->lock);
 
 	return rc;
 }
diff --git a/net/smc/smc_pnet.h b/net/smc/smc_pnet.h
index 14039272f7e4..80a88eea4949 100644
--- a/net/smc/smc_pnet.h
+++ b/net/smc/smc_pnet.h
@@ -29,7 +29,7 @@ struct smc_link_group;
  * @pnetlist: List of PNETIDs
  */
 struct smc_pnettable {
-	rwlock_t lock;
+	struct mutex lock;
 	struct list_head pnetlist;
 };
 
-- 
2.34.1

