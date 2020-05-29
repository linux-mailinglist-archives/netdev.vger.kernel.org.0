Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE351E7160
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 02:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438120AbgE2A0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 20:26:06 -0400
Received: from correo.us.es ([193.147.175.20]:44332 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438097AbgE2AZ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 20:25:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1CC23CF677
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 02:25:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0C9E9DA716
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 02:25:54 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 02430DA711; Fri, 29 May 2020 02:25:54 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8C7E8DA710;
        Fri, 29 May 2020 02:25:51 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 29 May 2020 02:25:51 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 1FB0D426CCB9;
        Fri, 29 May 2020 02:25:51 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, paulb@mellanox.com,
        ozsh@mellanox.com, vladbu@mellanox.com, jiri@resnulli.us,
        kuba@kernel.org, saeedm@mellanox.com, michael.chan@broadcom.com,
        sriharsha.basavapatna@broadcom.com
Subject: [PATCH net-next 2/8] net: flow_offload: consolidate indirect flow_block infrastructure
Date:   Fri, 29 May 2020 02:25:35 +0200
Message-Id: <20200529002541.19743-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200529002541.19743-1-pablo@netfilter.org>
References: <20200529002541.19743-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tunnel devices provide no dev->netdev_ops->ndo_setup_tc(...) interface.
The tunnel device and route control plane does not provide an obvious
way to relate tunnel and physical devices.

This patch allows drivers to register a tunnel device offload handler
for the tc and netfilter frontends through flow_indr_dev_register() and
flow_indr_dev_unregister().

The frontend calls flow_indr_dev_setup_offload() that iterates over the
list of drivers that are offering tunnel device hardware offload
support and it sets up the flow block for this tunnel device.

If the driver module is removed, the indirect flow_block ends up with a
stale callback reference. The module removal path triggers the
dev_shutdown() path to remove the qdisc and the flow_blocks for the
physical devices. However, this is not useful for tunnel devices, where
relation between the physical and the tunnel device is not explicit.

This patch introduces a cleanup callback that is invoked when the driver
module is removed to clean up the tunnel device flow_block. This patch
defines struct flow_block_indr and it uses it from flow_block_cb to
store the information that front-end requires to perform the
flow_block_cb cleanup on module removal.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/flow_offload.h |  19 +++++
 net/core/flow_offload.c    | 157 +++++++++++++++++++++++++++++++++++++
 2 files changed, 176 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 95d633785ef9..5493282348fa 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -443,6 +443,16 @@ enum tc_setup_type;
 typedef int flow_setup_cb_t(enum tc_setup_type type, void *type_data,
 			    void *cb_priv);
 
+struct flow_block_cb;
+
+struct flow_block_indr {
+	struct list_head		list;
+	struct net_device		*dev;
+	enum flow_block_binder_type	binder_type;
+	void				*data;
+	void				(*cleanup)(struct flow_block_cb *block_cb);
+};
+
 struct flow_block_cb {
 	struct list_head	driver_list;
 	struct list_head	list;
@@ -450,6 +460,7 @@ struct flow_block_cb {
 	void			*cb_ident;
 	void			*cb_priv;
 	void			(*release)(void *cb_priv);
+	struct flow_block_indr	indr;
 	unsigned int		refcnt;
 };
 
@@ -523,6 +534,14 @@ static inline void flow_block_init(struct flow_block *flow_block)
 typedef int flow_indr_block_bind_cb_t(struct net_device *dev, void *cb_priv,
 				      enum tc_setup_type type, void *type_data);
 
+int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv);
+void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
+			      flow_setup_cb_t *setup_cb);
+int flow_indr_dev_setup_offload(struct net_device *dev,
+				enum tc_setup_type type, void *data,
+				struct flow_block_offload *bo,
+				void (*cleanup)(struct flow_block_cb *block_cb));
+
 typedef void flow_indr_block_cmd_t(struct net_device *dev,
 				   flow_indr_block_bind_cb_t *cb, void *cb_priv,
 				   enum flow_block_command command);
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index e64941c526b1..8cd7da2586ae 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -317,6 +317,163 @@ int flow_block_cb_setup_simple(struct flow_block_offload *f,
 }
 EXPORT_SYMBOL(flow_block_cb_setup_simple);
 
+static DEFINE_MUTEX(flow_indr_block_lock);
+static LIST_HEAD(flow_block_indr_list);
+static LIST_HEAD(flow_block_indr_dev_list);
+
+struct flow_indr_dev {
+	struct list_head		list;
+	flow_indr_block_bind_cb_t	*cb;
+	void				*cb_priv;
+	refcount_t			refcnt;
+	struct rcu_head			rcu;
+};
+
+static struct flow_indr_dev *flow_indr_dev_alloc(flow_indr_block_bind_cb_t *cb,
+						 void *cb_priv)
+{
+	struct flow_indr_dev *indr_dev;
+
+	indr_dev = kmalloc(sizeof(*indr_dev), GFP_KERNEL);
+	if (!indr_dev)
+		return NULL;
+
+	indr_dev->cb		= cb;
+	indr_dev->cb_priv	= cb_priv;
+	refcount_set(&indr_dev->refcnt, 1);
+
+	return indr_dev;
+}
+
+int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv)
+{
+	struct flow_indr_dev *indr_dev;
+
+	mutex_lock(&flow_indr_block_lock);
+	list_for_each_entry(indr_dev, &flow_block_indr_dev_list, list) {
+		if (indr_dev->cb == cb &&
+		    indr_dev->cb_priv == cb_priv) {
+			refcount_inc(&indr_dev->refcnt);
+			mutex_unlock(&flow_indr_block_lock);
+			return 0;
+		}
+	}
+
+	indr_dev = flow_indr_dev_alloc(cb, cb_priv);
+	if (!indr_dev) {
+		mutex_unlock(&flow_indr_block_lock);
+		return -ENOMEM;
+	}
+
+	list_add(&indr_dev->list, &flow_block_indr_dev_list);
+	mutex_unlock(&flow_indr_block_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(flow_indr_dev_register);
+
+static void __flow_block_indr_cleanup(flow_setup_cb_t *setup_cb, void *cb_priv,
+				      struct list_head *cleanup_list)
+{
+	struct flow_block_cb *this, *next;
+
+	list_for_each_entry_safe(this, next, &flow_block_indr_list, indr.list) {
+		if (this->cb == setup_cb &&
+		    this->cb_priv == cb_priv) {
+			list_move(&this->indr.list, cleanup_list);
+			return;
+		}
+	}
+}
+
+static void flow_block_indr_notify(struct list_head *cleanup_list)
+{
+	struct flow_block_cb *this, *next;
+
+	list_for_each_entry_safe(this, next, cleanup_list, indr.list) {
+		list_del(&this->indr.list);
+		this->indr.cleanup(this);
+	}
+}
+
+void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
+			      flow_setup_cb_t *setup_cb)
+{
+	struct flow_indr_dev *this, *next, *indr_dev = NULL;
+	LIST_HEAD(cleanup_list);
+
+	mutex_lock(&flow_indr_block_lock);
+	list_for_each_entry_safe(this, next, &flow_block_indr_dev_list, list) {
+		if (this->cb == cb &&
+		    this->cb_priv == cb_priv &&
+		    refcount_dec_and_test(&this->refcnt)) {
+			indr_dev = this;
+			list_del(&indr_dev->list);
+			break;
+		}
+	}
+
+	if (!indr_dev) {
+		mutex_unlock(&flow_indr_block_lock);
+		return;
+	}
+
+	__flow_block_indr_cleanup(setup_cb, cb_priv, &cleanup_list);
+	mutex_unlock(&flow_indr_block_lock);
+
+	flow_block_indr_notify(&cleanup_list);
+	kfree(indr_dev);
+}
+EXPORT_SYMBOL(flow_indr_dev_unregister);
+
+static void flow_block_indr_init(struct flow_block_cb *flow_block,
+				 struct flow_block_offload *bo,
+				 struct net_device *dev, void *data,
+				 void (*cleanup)(struct flow_block_cb *block_cb))
+{
+	flow_block->indr.binder_type = bo->binder_type;
+	flow_block->indr.data = data;
+	flow_block->indr.dev = dev;
+	flow_block->indr.cleanup = cleanup;
+}
+
+static void __flow_block_indr_binding(struct flow_block_offload *bo,
+				      struct net_device *dev, void *data,
+				      void (*cleanup)(struct flow_block_cb *block_cb))
+{
+	struct flow_block_cb *block_cb;
+
+	list_for_each_entry(block_cb, &bo->cb_list, list) {
+		switch (bo->command) {
+		case FLOW_BLOCK_BIND:
+			flow_block_indr_init(block_cb, bo, dev, data, cleanup);
+			list_add(&block_cb->indr.list, &flow_block_indr_list);
+			break;
+		case FLOW_BLOCK_UNBIND:
+			list_del(&block_cb->indr.list);
+			break;
+		}
+	}
+}
+
+int flow_indr_dev_setup_offload(struct net_device *dev,
+				enum tc_setup_type type, void *data,
+				struct flow_block_offload *bo,
+				void (*cleanup)(struct flow_block_cb *block_cb))
+{
+	struct flow_indr_dev *this;
+
+	mutex_lock(&flow_indr_block_lock);
+	list_for_each_entry(this, &flow_block_indr_dev_list, list)
+		this->cb(dev, this->cb_priv, type, bo);
+
+	__flow_block_indr_binding(bo, dev, data, cleanup);
+	mutex_unlock(&flow_indr_block_lock);
+
+	return list_empty(&bo->cb_list) ? -EOPNOTSUPP : 0;
+}
+EXPORT_SYMBOL(flow_indr_dev_setup_offload);
+
 static LIST_HEAD(block_cb_list);
 
 static struct rhashtable indr_setup_block_ht;
-- 
2.20.1

