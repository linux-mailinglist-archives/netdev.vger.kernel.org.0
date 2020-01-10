Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31CBC137971
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 23:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727686AbgAJWFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 17:05:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:51282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727628AbgAJWFe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 17:05:34 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F3E420721;
        Fri, 10 Jan 2020 22:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578693933;
        bh=QZS60J2xT/w2jpWBVFmhMd2SZ58qSZaIYv9hCHexHCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EjwnWD551Ba1lRJRyl0WbVuzL58fAk5ID1kNY2FQVLS1sQr+WuVmTSinjmngmBd14
         4e7Lzb0gXbWeeZHYrRHzAEyJNT5drfTtc3i5KCHllS7EOPGDc47JeCsZRNQoYCPY/8
         ria6mOYbnv4nFWn4Q/Y6hABuL/4x55JVv5xMMgkM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Taehee Yoo <ap420073@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 16/26] hsr: add hsr root debugfs directory
Date:   Fri, 10 Jan 2020 17:05:09 -0500
Message-Id: <20200110220519.28250-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200110220519.28250-1-sashal@kernel.org>
References: <20200110220519.28250-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit c6c4ccd7f96993e106dfea7ef18127f972f2db5e ]

In current hsr code, when hsr interface is created, it creates debugfs
directory /sys/kernel/debug/<interface name>.
If there is same directory or file name in there, it fails.
In order to reduce possibility of failure of creation of debugfs,
this patch adds root directory.

Test commands:
    ip link add dummy0 type dummy
    ip link add dummy1 type dummy
    ip link add hsr0 type hsr slave1 dummy0 slave2 dummy1

Before this patch:
    /sys/kernel/debug/hsr0/node_table

After this patch:
    /sys/kernel/debug/hsr/hsr0/node_table

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_debugfs.c | 23 ++++++++++++++++++++---
 net/hsr/hsr_main.c    |  1 +
 net/hsr/hsr_main.h    |  6 ++++++
 net/hsr/hsr_netlink.c |  1 +
 4 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/net/hsr/hsr_debugfs.c b/net/hsr/hsr_debugfs.c
index 6618a9d8e58e..a7462a718e7b 100644
--- a/net/hsr/hsr_debugfs.c
+++ b/net/hsr/hsr_debugfs.c
@@ -20,6 +20,8 @@
 #include "hsr_main.h"
 #include "hsr_framereg.h"
 
+static struct dentry *hsr_debugfs_root_dir;
+
 static void print_mac_address(struct seq_file *sfp, unsigned char *mac)
 {
 	seq_printf(sfp, "%02x:%02x:%02x:%02x:%02x:%02x:",
@@ -81,9 +83,9 @@ void hsr_debugfs_init(struct hsr_priv *priv, struct net_device *hsr_dev)
 {
 	struct dentry *de = NULL;
 
-	de = debugfs_create_dir(hsr_dev->name, NULL);
+	de = debugfs_create_dir(hsr_dev->name, hsr_debugfs_root_dir);
 	if (IS_ERR(de)) {
-		pr_err("Cannot create hsr debugfs root\n");
+		pr_err("Cannot create hsr debugfs directory\n");
 		return;
 	}
 
@@ -93,7 +95,7 @@ void hsr_debugfs_init(struct hsr_priv *priv, struct net_device *hsr_dev)
 				 priv->node_tbl_root, priv,
 				 &hsr_fops);
 	if (IS_ERR(de)) {
-		pr_err("Cannot create hsr node_table directory\n");
+		pr_err("Cannot create hsr node_table file\n");
 		debugfs_remove(priv->node_tbl_root);
 		priv->node_tbl_root = NULL;
 		return;
@@ -115,3 +117,18 @@ hsr_debugfs_term(struct hsr_priv *priv)
 	debugfs_remove(priv->node_tbl_root);
 	priv->node_tbl_root = NULL;
 }
+
+void hsr_debugfs_create_root(void)
+{
+	hsr_debugfs_root_dir = debugfs_create_dir("hsr", NULL);
+	if (IS_ERR(hsr_debugfs_root_dir)) {
+		pr_err("Cannot create hsr debugfs root directory\n");
+		hsr_debugfs_root_dir = NULL;
+	}
+}
+
+void hsr_debugfs_remove_root(void)
+{
+	/* debugfs_remove() internally checks NULL and ERROR */
+	debugfs_remove(hsr_debugfs_root_dir);
+}
diff --git a/net/hsr/hsr_main.c b/net/hsr/hsr_main.c
index 6deb8fa8d5c8..e28c975520ec 100644
--- a/net/hsr/hsr_main.c
+++ b/net/hsr/hsr_main.c
@@ -123,6 +123,7 @@ static void __exit hsr_exit(void)
 {
 	unregister_netdevice_notifier(&hsr_nb);
 	hsr_netlink_exit();
+	hsr_debugfs_remove_root();
 }
 
 module_init(hsr_init);
diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
index 9ec38e33b8b1..6696923fd4bd 100644
--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -187,12 +187,18 @@ static inline u16 hsr_get_skb_sequence_nr(struct sk_buff *skb)
 #if IS_ENABLED(CONFIG_DEBUG_FS)
 void hsr_debugfs_init(struct hsr_priv *priv, struct net_device *hsr_dev);
 void hsr_debugfs_term(struct hsr_priv *priv);
+void hsr_debugfs_create_root(void);
+void hsr_debugfs_remove_root(void);
 #else
 static inline void hsr_debugfs_init(struct hsr_priv *priv,
 				    struct net_device *hsr_dev)
 {}
 static inline void hsr_debugfs_term(struct hsr_priv *priv)
 {}
+static inline void hsr_debugfs_create_root(void)
+{}
+static inline void hsr_debugfs_remove_root(void)
+{}
 #endif
 
 #endif /*  __HSR_PRIVATE_H */
diff --git a/net/hsr/hsr_netlink.c b/net/hsr/hsr_netlink.c
index 8f8337f893ba..8dc0547f01d0 100644
--- a/net/hsr/hsr_netlink.c
+++ b/net/hsr/hsr_netlink.c
@@ -476,6 +476,7 @@ int __init hsr_netlink_init(void)
 	if (rc)
 		goto fail_genl_register_family;
 
+	hsr_debugfs_create_root();
 	return 0;
 
 fail_genl_register_family:
-- 
2.20.1

