Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86E72128D92
	for <lists+netdev@lfdr.de>; Sun, 22 Dec 2019 12:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfLVL0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Dec 2019 06:26:22 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39643 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbfLVL0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Dec 2019 06:26:22 -0500
Received: by mail-pf1-f195.google.com with SMTP id q10so7720366pfs.6
        for <netdev@vger.kernel.org>; Sun, 22 Dec 2019 03:26:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=jn68yGHhMRDz0iUlyMWkxF+0O5bK1yIcHYNGv2AQZQY=;
        b=Xn/0rH1F+jaiYC58r6SgrzD7ISKhouelOwg3tVztrsgymOyLtbT1i+HhyKEG237WIG
         /k+hgEud58yl6UmeLL1JZ2Su1tRD56YIEP6oFy9o5OHN0PsWOFnsp2ztISj5g6Cz/AW0
         m708d0NthynXFaBnGfF+MO5QIFUrRlQW33iwb4BymYTa2jAJBigJuUz/sgGfA8WtM6QG
         e0/s4KKXIv2NRNB7a7g7dxU/hwqwuuPMAK2Esh+eNBULET3xHTflT5dHOLEXy+lF8DLH
         v0P2jFIAsspcRiJawMYJk9Zao++WB6mrx7EYb3ks7HswyslE7OqqVghXVzw/C/M4+J/t
         4w5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=jn68yGHhMRDz0iUlyMWkxF+0O5bK1yIcHYNGv2AQZQY=;
        b=oePDPB6gHjHbWY8m9d+QKfZGXO13ydE1G5EzaqU9MbBk0BuwrCLVkRJ3m+31CUicnw
         hhdnJ+As3uXSpgXrbTP8Jp9SkFxwsRcuhBdZQcUv0rN1W8sT1QdcOk+6g0qHPdugcduz
         JKcbq1C0ZjrR0B4gAJmvG/MWHmIGQ/jV4Q/1LWmrF5PbLW9QIvJfuALClE8jTJ3SHbUI
         kksSA/0kfTVEJYMZzkZCGtqmysdFnpj6llWpL2Fyj3Nop7zqAdiuvC3kde/7xSu0tSLp
         Xqi4hPU3fU71UNmXsH3TKpWfiuvjRJqYJhuSuQ8AObl5X3hxZfxYZnnWgbBSYxwvzpgO
         Cmaw==
X-Gm-Message-State: APjAAAX46FkaybZr1zKqHjWGjnAbiF37G6b5wJoWJSpf5EFLmeoZghUi
        vRWF9/tmkUj5g5h77N8Fbdc=
X-Google-Smtp-Source: APXvYqzX68qc5pVqRj1AryeLrXeWCcEuOx78rtS9FARdRqYwiQz6hNAT/1VX+fjVltRXfd+uKjl4rg==
X-Received: by 2002:aa7:8695:: with SMTP id d21mr27127372pfo.199.1577013981956;
        Sun, 22 Dec 2019 03:26:21 -0800 (PST)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id r62sm20619838pfc.89.2019.12.22.03.26.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Dec 2019 03:26:21 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 2/6] hsr: fix error handling routine in hsr_dev_finalize()
Date:   Sun, 22 Dec 2019 11:26:15 +0000
Message-Id: <20191222112615.3083-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hsr_dev_finalize() is called to create new hsr interface.
There are some wrong error handling codes.

1. wrong checking return value of debugfs_create_{dir/file}.
These function doesn't return NULL. If error occurs in there,
it returns error pointer.
So, it should check error pointer instead of NULL.

2. It doesn't unregister interface if it fails to setup hsr interface.
If it fails to initialize hsr interface after register_netdevice(),
it should call unregister_netdevice().

3. Ignore failure of creation of debugfs
If creating of debugfs dir and file is failed, creating hsr interface
will be failed. But debugfs doesn't affect actual logic of hsr module.
So, ignoring this is more correct and this behavior is more general.

Fixes: c5a759117210 ("net/hsr: Use list_head (and rcu) instead of array for slave devices.")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/hsr/hsr_debugfs.c | 15 +++++++--------
 net/hsr/hsr_device.c  | 19 ++++++++++---------
 net/hsr/hsr_main.h    | 11 ++++-------
 3 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/net/hsr/hsr_debugfs.c b/net/hsr/hsr_debugfs.c
index 6135706f03d5..6618a9d8e58e 100644
--- a/net/hsr/hsr_debugfs.c
+++ b/net/hsr/hsr_debugfs.c
@@ -77,15 +77,14 @@ static const struct file_operations hsr_fops = {
  * When debugfs is configured this routine sets up the node_table file per
  * hsr device for dumping the node_table entries
  */
-int hsr_debugfs_init(struct hsr_priv *priv, struct net_device *hsr_dev)
+void hsr_debugfs_init(struct hsr_priv *priv, struct net_device *hsr_dev)
 {
-	int rc = -1;
 	struct dentry *de = NULL;
 
 	de = debugfs_create_dir(hsr_dev->name, NULL);
-	if (!de) {
+	if (IS_ERR(de)) {
 		pr_err("Cannot create hsr debugfs root\n");
-		return rc;
+		return;
 	}
 
 	priv->node_tbl_root = de;
@@ -93,13 +92,13 @@ int hsr_debugfs_init(struct hsr_priv *priv, struct net_device *hsr_dev)
 	de = debugfs_create_file("node_table", S_IFREG | 0444,
 				 priv->node_tbl_root, priv,
 				 &hsr_fops);
-	if (!de) {
+	if (IS_ERR(de)) {
 		pr_err("Cannot create hsr node_table directory\n");
-		return rc;
+		debugfs_remove(priv->node_tbl_root);
+		priv->node_tbl_root = NULL;
+		return;
 	}
 	priv->node_tbl_file = de;
-
-	return 0;
 }
 
 /* hsr_debugfs_term - Tear down debugfs intrastructure
diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index b01e1bae4ddc..e73549075a03 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -477,30 +477,31 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 
 	res = hsr_add_port(hsr, hsr_dev, HSR_PT_MASTER);
 	if (res)
-		goto err_add_port;
+		goto err_add_master;
 
 	res = register_netdevice(hsr_dev);
 	if (res)
-		goto fail;
+		goto err_unregister;
 
 	res = hsr_add_port(hsr, slave[0], HSR_PT_SLAVE_A);
 	if (res)
-		goto fail;
+		goto err_add_slaves;
+
 	res = hsr_add_port(hsr, slave[1], HSR_PT_SLAVE_B);
 	if (res)
-		goto fail;
+		goto err_add_slaves;
 
+	hsr_debugfs_init(hsr, hsr_dev);
 	mod_timer(&hsr->prune_timer, jiffies + msecs_to_jiffies(PRUNE_PERIOD));
-	res = hsr_debugfs_init(hsr, hsr_dev);
-	if (res)
-		goto fail;
 
 	return 0;
 
-fail:
+err_add_slaves:
+	unregister_netdevice(hsr_dev);
+err_unregister:
 	list_for_each_entry_safe(port, tmp, &hsr->ports, port_list)
 		hsr_del_port(port);
-err_add_port:
+err_add_master:
 	hsr_del_self_node(&hsr->self_node_db);
 
 	return res;
diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
index 96fac696a1e1..acab9c353a49 100644
--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -184,15 +184,12 @@ static inline u16 hsr_get_skb_sequence_nr(struct sk_buff *skb)
 }
 
 #if IS_ENABLED(CONFIG_DEBUG_FS)
-int hsr_debugfs_init(struct hsr_priv *priv, struct net_device *hsr_dev);
+void hsr_debugfs_init(struct hsr_priv *priv, struct net_device *hsr_dev);
 void hsr_debugfs_term(struct hsr_priv *priv);
 #else
-static inline int hsr_debugfs_init(struct hsr_priv *priv,
-				   struct net_device *hsr_dev)
-{
-	return 0;
-}
-
+static inline void hsr_debugfs_init(struct hsr_priv *priv,
+				    struct net_device *hsr_dev)
+{}
 static inline void hsr_debugfs_term(struct hsr_priv *priv)
 {}
 #endif
-- 
2.17.1

