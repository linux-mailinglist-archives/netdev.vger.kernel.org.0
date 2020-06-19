Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDE2201E5D
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 00:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730132AbgFSW5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 18:57:41 -0400
Received: from smtp.uniroma2.it ([160.80.6.16]:33337 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729899AbgFSW4r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 18:56:47 -0400
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 05JMuRJB014086
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 20 Jun 2020 00:56:28 +0200
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Donald Sharp <sharpd@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Dinesh Dutt <didutt@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [net-next,v1,1/5] l3mdev: add infrastructure for table to VRF mapping
Date:   Sat, 20 Jun 2020 00:54:43 +0200
Message-Id: <20200619225447.1445-2-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200619225447.1445-1-andrea.mayer@uniroma2.it>
References: <20200619225447.1445-1-andrea.mayer@uniroma2.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add infrastructure to l3mdev (the core code for Layer 3 master devices) in
order to find out the corresponding VRF device for a given table id.
Therefore, the l3mdev implementations:
 - can register a callback that returns the device index of the l3mdev
   associated with a given table id;
 - can offer the lookup function (table to VRF device).

Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
---
 include/net/l3mdev.h | 39 +++++++++++++++++++
 net/l3mdev/l3mdev.c  | 93 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 132 insertions(+)

diff --git a/include/net/l3mdev.h b/include/net/l3mdev.h
index e942372b077b..031c661aa14d 100644
--- a/include/net/l3mdev.h
+++ b/include/net/l3mdev.h
@@ -10,6 +10,16 @@
 #include <net/dst.h>
 #include <net/fib_rules.h>
 
+enum l3mdev_type {
+	L3MDEV_TYPE_UNSPEC,
+	L3MDEV_TYPE_VRF,
+	__L3MDEV_TYPE_MAX
+};
+
+#define L3MDEV_TYPE_MAX (__L3MDEV_TYPE_MAX - 1)
+
+typedef int (*lookup_by_table_id_t)(struct net *net, u32 table_d);
+
 /**
  * struct l3mdev_ops - l3mdev operations
  *
@@ -37,6 +47,15 @@ struct l3mdev_ops {
 
 #ifdef CONFIG_NET_L3_MASTER_DEV
 
+int l3mdev_table_lookup_register(enum l3mdev_type l3type,
+				 lookup_by_table_id_t fn);
+
+void l3mdev_table_lookup_unregister(enum l3mdev_type l3type,
+				    lookup_by_table_id_t fn);
+
+int l3mdev_ifindex_lookup_by_table_id(enum l3mdev_type l3type, struct net *net,
+				      u32 table_id);
+
 int l3mdev_fib_rule_match(struct net *net, struct flowi *fl,
 			  struct fib_lookup_arg *arg);
 
@@ -280,6 +299,26 @@ struct sk_buff *l3mdev_ip6_out(struct sock *sk, struct sk_buff *skb)
 	return skb;
 }
 
+static inline
+int l3mdev_table_lookup_register(enum l3mdev_type l3type,
+				 lookup_by_table_id_t fn)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline
+void l3mdev_table_lookup_unregister(enum l3mdev_type l3type,
+				    lookup_by_table_id_t fn)
+{
+}
+
+static inline
+int l3mdev_ifindex_lookup_by_table_id(enum l3mdev_type l3type, struct net *net,
+				      u32 table_id)
+{
+	return -ENODEV;
+}
+
 static inline
 int l3mdev_fib_rule_match(struct net *net, struct flowi *fl,
 			  struct fib_lookup_arg *arg)
diff --git a/net/l3mdev/l3mdev.c b/net/l3mdev/l3mdev.c
index f35899d45a9a..e71ca5aec684 100644
--- a/net/l3mdev/l3mdev.c
+++ b/net/l3mdev/l3mdev.c
@@ -9,6 +9,99 @@
 #include <net/fib_rules.h>
 #include <net/l3mdev.h>
 
+static DEFINE_SPINLOCK(l3mdev_lock);
+
+struct l3mdev_handler {
+	lookup_by_table_id_t dev_lookup;
+};
+
+static struct l3mdev_handler l3mdev_handlers[L3MDEV_TYPE_MAX + 1];
+
+static int l3mdev_check_type(enum l3mdev_type l3type)
+{
+	if (l3type <= L3MDEV_TYPE_UNSPEC || l3type > L3MDEV_TYPE_MAX)
+		return -EINVAL;
+
+	return 0;
+}
+
+int l3mdev_table_lookup_register(enum l3mdev_type l3type,
+				 lookup_by_table_id_t fn)
+{
+	struct l3mdev_handler *hdlr;
+	int res;
+
+	res = l3mdev_check_type(l3type);
+	if (res)
+		return res;
+
+	hdlr = &l3mdev_handlers[l3type];
+
+	spin_lock(&l3mdev_lock);
+
+	if (hdlr->dev_lookup) {
+		res = -EBUSY;
+		goto unlock;
+	}
+
+	hdlr->dev_lookup = fn;
+	res = 0;
+
+unlock:
+	spin_unlock(&l3mdev_lock);
+
+	return res;
+}
+EXPORT_SYMBOL_GPL(l3mdev_table_lookup_register);
+
+void l3mdev_table_lookup_unregister(enum l3mdev_type l3type,
+				    lookup_by_table_id_t fn)
+{
+	struct l3mdev_handler *hdlr;
+
+	if (l3mdev_check_type(l3type))
+		return;
+
+	hdlr = &l3mdev_handlers[l3type];
+
+	spin_lock(&l3mdev_lock);
+
+	if (hdlr->dev_lookup == fn)
+		hdlr->dev_lookup = NULL;
+
+	spin_unlock(&l3mdev_lock);
+}
+EXPORT_SYMBOL_GPL(l3mdev_table_lookup_unregister);
+
+int l3mdev_ifindex_lookup_by_table_id(enum l3mdev_type l3type,
+				      struct net *net, u32 table_id)
+{
+	lookup_by_table_id_t lookup;
+	struct l3mdev_handler *hdlr;
+	int ifindex = -EINVAL;
+	int res;
+
+	res = l3mdev_check_type(l3type);
+	if (res)
+		return res;
+
+	hdlr = &l3mdev_handlers[l3type];
+
+	spin_lock(&l3mdev_lock);
+
+	lookup = hdlr->dev_lookup;
+	if (!lookup)
+		goto unlock;
+
+	ifindex = lookup(net, table_id);
+
+unlock:
+	spin_unlock(&l3mdev_lock);
+
+	return ifindex;
+}
+EXPORT_SYMBOL_GPL(l3mdev_ifindex_lookup_by_table_id);
+
 /**
  *	l3mdev_master_ifindex - get index of L3 master device
  *	@dev: targeted interface
-- 
2.20.1

