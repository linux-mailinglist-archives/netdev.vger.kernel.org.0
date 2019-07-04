Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C417C5F003
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 02:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbfGDAVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 20:21:45 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:47084 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727100AbfGDAVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 20:21:43 -0400
Received: by mail-pg1-f196.google.com with SMTP id i8so1992788pgm.13
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 17:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o8vYj2PYFtbLQn1GzKCADWnrJYtwlqK2JEKvEmstBIk=;
        b=vWjt0FG640Jbi8Fvr054OWosOJd0zvvIhfGyAXBeiM9WNY1r9m/1+9n9ptFrnfpijj
         XxhG88NDh2Nw4xJ+gJznI1uhK+uBpUm8kwcdq/TLabru27klinjJSVtrrgwj8Tn/+Q37
         Ge71a+R2Nt0npUfJvSU9L2AGtV5vspaYz4RIDFgOKIsP/xk9IDvOXB1B08zGjX5x5BEm
         zxHrqwair0tPpvfDxWE1urvAC8T/csGLzMyT0YyOi/yh17zJjKtewblDI6zn6BbTVtCL
         ftVenS0ol4WRXsK++7tHyFpZ2qaESKzYMEbWeDuZgj5IYh+t7qEogv8SwTxhUqWFGCDI
         9n2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o8vYj2PYFtbLQn1GzKCADWnrJYtwlqK2JEKvEmstBIk=;
        b=oHNzui50PfIb7AfRguCG9Mjb32dxr9GkD6miEbo3a0M7rTIgprsOgFgCWlIkXZEvLG
         Mak87aYpFSE5+EKwpjsU363PEIIV/RUc/7OeSfQtjLldPlPnrFYtKSaFmL0HanDFlTr8
         g8nITdeSqbf7hH2H1NB8+TFcgrue3qiha1V6xilbsANssvleqDms/5ECM6RrTXLJNRfh
         Oy6FExeOAlMCIQAALHzA6B4DLf+s53xPA5VvBo2+bs28oECUvOWsQNosdSAUz3beuIvX
         duf6qksYol5QVK+4O0t7W9Sz4xmIgkwyJ3ZEZXzfltmciE+LWpn1ymjwMzzN+aIJ4XgB
         akPA==
X-Gm-Message-State: APjAAAUYfQm9poWkm7ZDSyRNsVHr2H4jREW8iVXJIwkuunkA3WFRrSrU
        ZlZew2IWIBlQLx6kggtye3oP2aBE330=
X-Google-Smtp-Source: APXvYqxvysmmsNMLed1GMPe/7w3urGcZRzsAV7WdoG9b0+vR2FH7s8OJhkNqccIqGdcxOwBvKMq6mQ==
X-Received: by 2002:a63:1f1f:: with SMTP id f31mr10375369pgf.353.1562199702227;
        Wed, 03 Jul 2019 17:21:42 -0700 (PDT)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id e11sm7252426pfm.35.2019.07.03.17.21.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 17:21:41 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+c6167ec3de7def23d1e8@syzkaller.appspotmail.com,
        Arvid Brodin <arvid.brodin@alten.se>
Subject: [Patch net 2/3] hsr: implement dellink to clean up resources
Date:   Wed,  3 Jul 2019 17:21:13 -0700
Message-Id: <20190704002114.29004-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190704002114.29004-1-xiyou.wangcong@gmail.com>
References: <20190704002114.29004-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hsr_link_ops implements ->newlink() but not ->dellink(),
which leads that resources not released after removing the device,
particularly the entries in self_node_db and node_db.

So add ->dellink() implementation to replace the priv_destructor.
This also makes the code slightly easier to understand.

Reported-by: syzbot+c6167ec3de7def23d1e8@syzkaller.appspotmail.com
Cc: Arvid Brodin <arvid.brodin@alten.se>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/hsr/hsr_device.c   | 13 +++++--------
 net/hsr/hsr_device.h   |  1 +
 net/hsr/hsr_framereg.c | 11 ++++++++++-
 net/hsr/hsr_framereg.h |  3 ++-
 net/hsr/hsr_netlink.c  |  7 +++++++
 5 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index f48b6a275cf0..4ea7d54a8262 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -344,10 +344,7 @@ static void hsr_announce(struct timer_list *t)
 	rcu_read_unlock();
 }
 
-/* According to comments in the declaration of struct net_device, this function
- * is "Called from unregister, can be used to call free_netdev". Ok then...
- */
-static void hsr_dev_destroy(struct net_device *hsr_dev)
+void hsr_dev_destroy(struct net_device *hsr_dev)
 {
 	struct hsr_priv *hsr;
 	struct hsr_port *port;
@@ -357,15 +354,16 @@ static void hsr_dev_destroy(struct net_device *hsr_dev)
 
 	hsr_debugfs_term(hsr);
 
-	rtnl_lock();
 	list_for_each_entry_safe(port, tmp, &hsr->ports, port_list)
 		hsr_del_port(port);
-	rtnl_unlock();
 
 	del_timer_sync(&hsr->prune_timer);
 	del_timer_sync(&hsr->announce_timer);
 
 	synchronize_rcu();
+
+	hsr_del_self_node(&hsr->self_node_db);
+	hsr_del_nodes(&hsr->node_db);
 }
 
 static const struct net_device_ops hsr_device_ops = {
@@ -392,7 +390,6 @@ void hsr_dev_setup(struct net_device *dev)
 	dev->priv_flags |= IFF_NO_QUEUE;
 
 	dev->needs_free_netdev = true;
-	dev->priv_destructor = hsr_dev_destroy;
 
 	dev->hw_features = NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_HIGHDMA |
 			   NETIF_F_GSO_MASK | NETIF_F_HW_CSUM |
@@ -497,7 +494,7 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 	list_for_each_entry_safe(port, tmp, &hsr->ports, port_list)
 		hsr_del_port(port);
 err_add_port:
-	hsr_del_node(&hsr->self_node_db);
+	hsr_del_self_node(&hsr->self_node_db);
 
 	return res;
 }
diff --git a/net/hsr/hsr_device.h b/net/hsr/hsr_device.h
index 6d7759c4f5f9..d0fa6b0696d2 100644
--- a/net/hsr/hsr_device.h
+++ b/net/hsr/hsr_device.h
@@ -14,6 +14,7 @@
 void hsr_dev_setup(struct net_device *dev);
 int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 		     unsigned char multicast_spec, u8 protocol_version);
+void hsr_dev_destroy(struct net_device *hsr_dev);
 void hsr_check_carrier_and_operstate(struct hsr_priv *hsr);
 bool is_hsr_master(struct net_device *dev);
 int hsr_get_max_mtu(struct hsr_priv *hsr);
diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index 2d7a19750436..292be446007b 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -104,7 +104,7 @@ int hsr_create_self_node(struct list_head *self_node_db,
 	return 0;
 }
 
-void hsr_del_node(struct list_head *self_node_db)
+void hsr_del_self_node(struct list_head *self_node_db)
 {
 	struct hsr_node *node;
 
@@ -117,6 +117,15 @@ void hsr_del_node(struct list_head *self_node_db)
 	}
 }
 
+void hsr_del_nodes(struct list_head *node_db)
+{
+	struct hsr_node *node;
+	struct hsr_node *tmp;
+
+	list_for_each_entry_safe(node, tmp, node_db, mac_list)
+		kfree(node);
+}
+
 /* Allocate an hsr_node and add it to node_db. 'addr' is the node's address_A;
  * seq_out is used to initialize filtering of outgoing duplicate frames
  * originating from the newly added node.
diff --git a/net/hsr/hsr_framereg.h b/net/hsr/hsr_framereg.h
index a3bdcdab469d..89a3ce38151d 100644
--- a/net/hsr/hsr_framereg.h
+++ b/net/hsr/hsr_framereg.h
@@ -12,7 +12,8 @@
 
 struct hsr_node;
 
-void hsr_del_node(struct list_head *self_node_db);
+void hsr_del_self_node(struct list_head *self_node_db);
+void hsr_del_nodes(struct list_head *node_db);
 struct hsr_node *hsr_add_node(struct list_head *node_db, unsigned char addr[],
 			      u16 seq_out);
 struct hsr_node *hsr_get_node(struct hsr_port *port, struct sk_buff *skb,
diff --git a/net/hsr/hsr_netlink.c b/net/hsr/hsr_netlink.c
index 8f8337f893ba..160edd24de4e 100644
--- a/net/hsr/hsr_netlink.c
+++ b/net/hsr/hsr_netlink.c
@@ -69,6 +69,12 @@ static int hsr_newlink(struct net *src_net, struct net_device *dev,
 	return hsr_dev_finalize(dev, link, multicast_spec, hsr_version);
 }
 
+static void hsr_dellink(struct net_device *hsr_dev, struct list_head *head)
+{
+	hsr_dev_destroy(hsr_dev);
+	unregister_netdevice_queue(hsr_dev, head);
+}
+
 static int hsr_fill_info(struct sk_buff *skb, const struct net_device *dev)
 {
 	struct hsr_priv *hsr;
@@ -113,6 +119,7 @@ static struct rtnl_link_ops hsr_link_ops __read_mostly = {
 	.priv_size	= sizeof(struct hsr_priv),
 	.setup		= hsr_dev_setup,
 	.newlink	= hsr_newlink,
+	.dellink	= hsr_dellink,
 	.fill_info	= hsr_fill_info,
 };
 
-- 
2.21.0

