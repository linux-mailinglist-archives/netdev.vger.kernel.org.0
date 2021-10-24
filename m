Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7A914388FB
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 15:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbhJXNQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 09:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbhJXNQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 09:16:25 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3FF6C061764;
        Sun, 24 Oct 2021 06:14:04 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id x192so4810309lff.12;
        Sun, 24 Oct 2021 06:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sdtRwE7raNMG9b6Kywf2PuE83TcK3rYR5PBzfwDvk/U=;
        b=MKJQHSqbBlDdeebWKVtymJp1+H8oXVzLDG94eNl4GYSa4c0B9AiCb2MnZh3b3rroVC
         AsK6w8Jf8WR2qJJUzJ5+4EAkNTy5/gqV+XQPcW1OGuoRxo+aUK7X6e12TLmusIWWR0X5
         k+rPzpJZakovBi+YeyW1xWnt6Nv7GOTBVW2daQ7G0/beRa4fd+4vijI1XfexlylM2MPb
         MSCJsuZ/BjA5ezf+3DuOLHwjJl9IughtLC0eSLLG6ASAaohWPYpupTTZjeyvkKHipZ+p
         Vx2oEgs686zs5YSrRRQN2/tiBiqK8JLAeRoOKnvVPUNk59IAPQqlpBVrAPKR6ol0TtQc
         Kmig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sdtRwE7raNMG9b6Kywf2PuE83TcK3rYR5PBzfwDvk/U=;
        b=vDpgZuBuNio63YgkU5/SUPbctoumREVGKWtEAlyOCzp5UMU3nGK8b4qaM80vcyr2HK
         9ob8+MQtumrpZRrO9CfQokFfMn2TGtNPLMHyjqvidJWtdSkVbOkg5wwXFrTnwhvjM5pw
         E3Xs4zPydJDPAG6I8X/AZlrlwl8o/UcTuoEdSX1tg8sGkXf/fzsyxhXMBM9w8HeKQKRs
         5QOs7gw6H7hLPfN240nlieKFP9OXKyRm8XQKjKQnOZdlfRgoYsjYfLUG7PHcW0YwV0N5
         pu9BzlrgcJvIZ4jmGaDTF7QNGj6tKkdEAREtvNAjlyG+eb7Fcf8M5vMs8tlVdmdcAfyr
         hN3Q==
X-Gm-Message-State: AOAM532xb88WKL4ij4b9k8jvYlT+Iid3cLsXJU4FQ371ABgfV1lsaGQz
        K8uDQaPUBcHb4Ojzp9RXxsY=
X-Google-Smtp-Source: ABdhPJx30mP6p+5BvOabIuXMRBYxdCnrssFirxzI/+F0sSWKEKGgka5JalWFFlE7vB2B3pE6nBVkFg==
X-Received: by 2002:a05:6512:13a5:: with SMTP id p37mr11097183lfa.403.1635081242266;
        Sun, 24 Oct 2021 06:14:02 -0700 (PDT)
Received: from localhost.localdomain ([94.103.235.8])
        by smtp.gmail.com with ESMTPSA id q24sm1323575lfr.138.2021.10.24.06.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Oct 2021 06:14:01 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, davem@davemloft.net, kuba@kernel.org
Cc:     b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+28b0702ada0bf7381f58@syzkaller.appspotmail.com
Subject: [PATCH] net: batman-adv: fix error handling
Date:   Sun, 24 Oct 2021 16:13:56 +0300
Message-Id: <20211024131356.10699-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <2056331.oJahCzYEoq@sven-desktop>
References: <2056331.oJahCzYEoq@sven-desktop>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported ODEBUG warning in batadv_nc_mesh_free(). The problem was
in wrong error handling in batadv_mesh_init().

Before this patch batadv_mesh_init() was calling batadv_mesh_free() in case
of any batadv_*_init() calls failure. This approach may work well, when
there is some kind of indicator, which can tell which parts of batadv are
initialized; but there isn't any.

All written above lead to cleaning up uninitialized fields. Even if we hide
ODEBUG warning by initializing bat_priv->nc.work, syzbot was able to hit
GPF in batadv_nc_purge_paths(), because hash pointer in still NULL. [1]

To fix these bugs we can unwind batadv_*_init() calls one by one.
It is good approach for 2 reasons: 1) It fixes bugs on error handling
path 2) It improves the performance, since we won't call unneeded
batadv_*_free() functions.

So, this patch makes all batadv_*_init() clean up all allocated memory
before returning with an error to no call correspoing batadv_*_free()
and open-codes batadv_mesh_free() with proper order to avoid touching
uninitialized fields.

Link: https://lore.kernel.org/netdev/000000000000c87fbd05cef6bcb0@google.com/ [1]
Reported-and-tested-by: syzbot+28b0702ada0bf7381f58@syzkaller.appspotmail.com
Fixes: c6c8fea29769 ("net: Add batman-adv meshing protocol")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 net/batman-adv/bridge_loop_avoidance.c |  8 +++-
 net/batman-adv/main.c                  | 56 ++++++++++++++++++--------
 net/batman-adv/network-coding.c        |  4 +-
 net/batman-adv/translation-table.c     |  4 +-
 4 files changed, 52 insertions(+), 20 deletions(-)

diff --git a/net/batman-adv/bridge_loop_avoidance.c b/net/batman-adv/bridge_loop_avoidance.c
index 1669744304c5..17687848daec 100644
--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -1560,10 +1560,14 @@ int batadv_bla_init(struct batadv_priv *bat_priv)
 		return 0;
 
 	bat_priv->bla.claim_hash = batadv_hash_new(128);
-	bat_priv->bla.backbone_hash = batadv_hash_new(32);
+	if (!bat_priv->bla.claim_hash)
+		return -ENOMEM;
 
-	if (!bat_priv->bla.claim_hash || !bat_priv->bla.backbone_hash)
+	bat_priv->bla.backbone_hash = batadv_hash_new(32);
+	if (!bat_priv->bla.backbone_hash) {
+		batadv_hash_destroy(bat_priv->bla.claim_hash);
 		return -ENOMEM;
+	}
 
 	batadv_hash_set_lock_class(bat_priv->bla.claim_hash,
 				   &batadv_claim_hash_lock_class_key);
diff --git a/net/batman-adv/main.c b/net/batman-adv/main.c
index 3ddd66e4c29e..5207cd8d6ad8 100644
--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -190,29 +190,41 @@ int batadv_mesh_init(struct net_device *soft_iface)
 
 	bat_priv->gw.generation = 0;
 
-	ret = batadv_v_mesh_init(bat_priv);
-	if (ret < 0)
-		goto err;
-
 	ret = batadv_originator_init(bat_priv);
-	if (ret < 0)
-		goto err;
+	if (ret < 0) {
+		atomic_set(&bat_priv->mesh_state, BATADV_MESH_DEACTIVATING);
+		goto err_orig;
+	}
 
 	ret = batadv_tt_init(bat_priv);
-	if (ret < 0)
-		goto err;
+	if (ret < 0) {
+		atomic_set(&bat_priv->mesh_state, BATADV_MESH_DEACTIVATING);
+		goto err_tt;
+	}
+
+	ret = batadv_v_mesh_init(bat_priv);
+	if (ret < 0) {
+		atomic_set(&bat_priv->mesh_state, BATADV_MESH_DEACTIVATING);
+		goto err_v;
+	}
 
 	ret = batadv_bla_init(bat_priv);
-	if (ret < 0)
-		goto err;
+	if (ret < 0) {
+		atomic_set(&bat_priv->mesh_state, BATADV_MESH_DEACTIVATING);
+		goto err_bla;
+	}
 
 	ret = batadv_dat_init(bat_priv);
-	if (ret < 0)
-		goto err;
+	if (ret < 0) {
+		atomic_set(&bat_priv->mesh_state, BATADV_MESH_DEACTIVATING);
+		goto err_dat;
+	}
 
 	ret = batadv_nc_mesh_init(bat_priv);
-	if (ret < 0)
-		goto err;
+	if (ret < 0) {
+		atomic_set(&bat_priv->mesh_state, BATADV_MESH_DEACTIVATING);
+		goto err_nc;
+	}
 
 	batadv_gw_init(bat_priv);
 	batadv_mcast_init(bat_priv);
@@ -222,8 +234,20 @@ int batadv_mesh_init(struct net_device *soft_iface)
 
 	return 0;
 
-err:
-	batadv_mesh_free(soft_iface);
+err_nc:
+	batadv_dat_free(bat_priv);
+err_dat:
+	batadv_bla_free(bat_priv);
+err_bla:
+	batadv_v_mesh_free(bat_priv);
+err_v:
+	batadv_tt_free(bat_priv);
+err_tt:
+	batadv_originator_free(bat_priv);
+err_orig:
+	batadv_purge_outstanding_packets(bat_priv, NULL);
+	atomic_set(&bat_priv->mesh_state, BATADV_MESH_INACTIVE);
+
 	return ret;
 }
 
diff --git a/net/batman-adv/network-coding.c b/net/batman-adv/network-coding.c
index 9f06132e007d..0a7f1d36a6a8 100644
--- a/net/batman-adv/network-coding.c
+++ b/net/batman-adv/network-coding.c
@@ -152,8 +152,10 @@ int batadv_nc_mesh_init(struct batadv_priv *bat_priv)
 				   &batadv_nc_coding_hash_lock_class_key);
 
 	bat_priv->nc.decoding_hash = batadv_hash_new(128);
-	if (!bat_priv->nc.decoding_hash)
+	if (!bat_priv->nc.decoding_hash) {
+		batadv_hash_destroy(bat_priv->nc.coding_hash);
 		goto err;
+	}
 
 	batadv_hash_set_lock_class(bat_priv->nc.decoding_hash,
 				   &batadv_nc_decoding_hash_lock_class_key);
diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index e0b3dace2020..4b7ad6684bc4 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -4162,8 +4162,10 @@ int batadv_tt_init(struct batadv_priv *bat_priv)
 		return ret;
 
 	ret = batadv_tt_global_init(bat_priv);
-	if (ret < 0)
+	if (ret < 0) {
+		batadv_tt_local_table_free(bat_priv);
 		return ret;
+	}
 
 	batadv_tvlv_handler_register(bat_priv, batadv_tt_tvlv_ogm_handler_v1,
 				     batadv_tt_tvlv_unicast_handler_v1,
-- 
2.33.1

