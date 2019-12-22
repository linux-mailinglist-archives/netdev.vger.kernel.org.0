Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89A39128D94
	for <lists+netdev@lfdr.de>; Sun, 22 Dec 2019 12:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfLVL0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Dec 2019 06:26:36 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:40549 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbfLVL0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Dec 2019 06:26:36 -0500
Received: by mail-pj1-f68.google.com with SMTP id bg7so5695491pjb.5
        for <netdev@vger.kernel.org>; Sun, 22 Dec 2019 03:26:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=1gnRohGnFtKKBr32eaVzqYJ/eUUrnj+W8XwXuZrvmzc=;
        b=qHdpVMsDFxX40vbg/BUjbt61/uoGQEXzqN3mdplmnWJXeqBfvl266GkieJT0ej/DN4
         x9zEeIEVU+kgfBmOkQBjqVrmE2E1+4jOvlnWJKjFiZYylFgmaHloaZ42Q0O//h3ZXiaz
         wrRgtX0YSwOod4UpApTWuuBbBY+FsGSvLW/8L+iR9bAIlo14k1PLMzlkMK3tEDhbIvPp
         1cdSKRNN3+hs8slIZaiWxD+s3lhHmhm0EeO+0Qv4VxPYSh3KAktYbOMvu+2W7kZzfMgr
         cDtjUWQQlI1XUAnvF2So+XPVBM6pjnGqov82B5f8gcDKwA24O0+CcLcTBTNepWWBJNGu
         bU8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1gnRohGnFtKKBr32eaVzqYJ/eUUrnj+W8XwXuZrvmzc=;
        b=dngU+TvSCWdEufFWnsyMd370gHSMO1NfYkhRGJNiuIcfH28oV49fjq08DA50BgVKc9
         q3XxUA9wrzLEAiR/VpdGNfrOBDuqlvWLJXhdrB25rgnlT+UXZdXZhcxhU196GK3abJJn
         87Ei6UxTOiZ1o8w5xVoi8ZY9dZG9rtvhMIDSwoZjfnYRJu9ji5vSesgO/558F4IFpNOl
         sfZ2qaOejhNgY3U2XzAEHzifLq3ua8V0OJvhmKAYY/29UVwaM+5clBOGJFAr1jJC2v+p
         ezTK95mpYM8zGjpRRDZ5jiRLH8L6ISvt/XTug/eGXm3Ph8zhzPp4SRaYxQpYCIdICJCL
         GX9g==
X-Gm-Message-State: APjAAAUfGrP6y/V5RPLocd1ZNZiKkKOAgWD1DO3C5STNlVYOd6GOFtEk
        97/430EtJVqb3m88gMmvkyA=
X-Google-Smtp-Source: APXvYqyJDsxNksUp15i7Dr8bt3E7PotaliWqtKDCNdY+t8xLDRxlZFRkupnH17ASGOeqmq9YMzB/TA==
X-Received: by 2002:a17:90a:e389:: with SMTP id b9mr27818870pjz.7.1577013995872;
        Sun, 22 Dec 2019 03:26:35 -0800 (PST)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id e2sm20287805pfh.84.2019.12.22.03.26.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Dec 2019 03:26:35 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 3/6] hsr: add hsr root debugfs directory
Date:   Sun, 22 Dec 2019 11:26:27 +0000
Message-Id: <20191222112627.3162-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
index b9988a662ee1..490896379073 100644
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
index acab9c353a49..55d2057bf749 100644
--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -186,12 +186,18 @@ static inline u16 hsr_get_skb_sequence_nr(struct sk_buff *skb)
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
2.17.1

