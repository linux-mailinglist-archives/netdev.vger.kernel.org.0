Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 736A670BB1
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 23:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732863AbfGVVlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 17:41:11 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35925 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732787AbfGVVkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 17:40:40 -0400
Received: by mail-pg1-f194.google.com with SMTP id l21so18284918pgm.3
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 14:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=5xTJj1hxUz/n/9699y8vV+IFQDZyTJiYtBtWeP8N8QI=;
        b=WHfbWpZd3PdlekITGWRrC7GeLkph6O0u+5nBE7CzSrMneXXYUJ+yeyi6+laLC/9fce
         gthjV5euVdIV1Gd8x06Iu6OtPJeftpbM8GyKjL1I9HBxpQPnpnM/Gvk/6m/n2cOnYUmG
         2zrrEA4LHlGh32jdWYwnBjziCyaX8YbNyxFaKtDOmMgrL2YC8GnWmEpr21JLkKIIDSQY
         GZ7QPC18bMtbZGYYlZTDEm+OfXytzNvyhzi4ynHYCBbWI40ecHBjXCgeBn1A78+Ejmhx
         U9+cpMJPAbwgWEXVO4pRdCMHhsvkpGqJWK36Sx2XZHK+m89fSDridz7rRbAzV9qsEn/D
         ZghA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=5xTJj1hxUz/n/9699y8vV+IFQDZyTJiYtBtWeP8N8QI=;
        b=sA202RxbYlKuO6zwb8ihpmoTBHWXjJnY7XGkdHMbd2YxyUH1Dda8F8eRfPRQEH8pTZ
         bfMCZ1V2CaZXRpxeCpNfh5pETqR9Ds24cVD6R7GU9XuCsJ6MWpCvyuGU0u1NDfDVjeue
         mUvSJQcRVkjRJ0y/Y6U8s2PsDtB+PXsXO8uRWEIv37ELePoks+KK4Ognt0VTDdoqLHc1
         QkZWv3+BTLLQvkXjOk28ajO5WezHfvUtb9cDcEJxzqARZcJC2bWGPTba5pip70Y2KjNU
         JUXifSTgtBrnAMW0s+TKv9rnsUU2FryE0kLYUhyTP4Svu52iM4wRw1ZEFvhalzwfwu/K
         kweA==
X-Gm-Message-State: APjAAAVlGSis99IPG5P2nhiidnmdVP8ZMudPvKRLw4UNbBLZF9ImySbQ
        ahNccj1W2WGBqxC/xJRkaJlPsg==
X-Google-Smtp-Source: APXvYqwjuMRs2mM2g6HygFmHyUOJYGksEnkfA5ESqgXS2INILIZqkMXide5oFaHZJRdxrDRJEC0zlg==
X-Received: by 2002:a63:b102:: with SMTP id r2mr3302749pgf.370.1563831639295;
        Mon, 22 Jul 2019 14:40:39 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id p65sm40593714pfp.58.2019.07.22.14.40.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jul 2019 14:40:38 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v4 net-next 10/19] ionic: Add management of rx filters
Date:   Mon, 22 Jul 2019 14:40:14 -0700
Message-Id: <20190722214023.9513-11-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190722214023.9513-1-snelson@pensando.io>
References: <20190722214023.9513-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set up the infrastructure for managing Rx filters.  We can't ask the
hardware for what filters it has, so we keep a local list of filters
that we've pushed into the HW.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/Makefile  |   4 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   |   6 +
 .../net/ethernet/pensando/ionic/ionic_lif.h   |   2 +
 .../ethernet/pensando/ionic/ionic_rx_filter.c | 143 ++++++++++++++++++
 .../ethernet/pensando/ionic/ionic_rx_filter.h |  35 +++++
 5 files changed, 188 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_rx_filter.h

diff --git a/drivers/net/ethernet/pensando/ionic/Makefile b/drivers/net/ethernet/pensando/ionic/Makefile
index 04d519d00be6..7d9cdc5f02a1 100644
--- a/drivers/net/ethernet/pensando/ionic/Makefile
+++ b/drivers/net/ethernet/pensando/ionic/Makefile
@@ -3,5 +3,5 @@
 
 obj-$(CONFIG_IONIC) := ionic.o
 
-ionic-y := ionic_main.o ionic_bus_pci.o ionic_dev.o ionic_debugfs.o \
-	   ionic_lif.o
+ionic-y := ionic_main.o ionic_bus_pci.o ionic_dev.o \
+	   ionic_lif.o ionic_rx_filter.o ionic_debugfs.o
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 005b1d908fa1..72ac0fd56b69 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -667,6 +667,8 @@ static void ionic_lif_deinit(struct lif *lif)
 
 	clear_bit(LIF_INITED, lif->state);
 
+	ionic_rx_filters_deinit(lif);
+
 	napi_disable(&lif->adminqcq->napi);
 	ionic_lif_qcq_deinit(lif, lif->notifyqcq);
 	ionic_lif_qcq_deinit(lif, lif->adminqcq);
@@ -1033,6 +1035,10 @@ static int ionic_lif_init(struct lif *lif)
 	if (err)
 		goto err_out_notifyq_deinit;
 
+	err = ionic_rx_filters_init(lif);
+	if (err)
+		goto err_out_notifyq_deinit;
+
 	set_bit(LIF_INITED, lif->state);
 
 	return 0;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index ef3f7340a277..9f112aa69033 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -5,6 +5,7 @@
 #define _IONIC_LIF_H_
 
 #include <linux/pci.h>
+#include "ionic_rx_filter.h"
 
 #define IONIC_ADMINQ_LENGTH	16	/* must be a power of two */
 #define IONIC_NOTIFYQ_LENGTH	64	/* must be a power of two */
@@ -92,6 +93,7 @@ struct lif {
 	dma_addr_t info_pa;
 	u32 info_sz;
 
+	struct rx_filters rx_filters;
 	unsigned long *dbid_inuse;
 	unsigned int dbid_count;
 	struct dentry *dentry;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
new file mode 100644
index 000000000000..e0b67fd90b11
--- /dev/null
+++ b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
@@ -0,0 +1,143 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
+
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+
+#include "ionic.h"
+#include "ionic_lif.h"
+#include "ionic_rx_filter.h"
+
+void ionic_rx_filter_free(struct lif *lif, struct rx_filter *f)
+{
+	struct device *dev = lif->ionic->dev;
+
+	hlist_del(&f->by_id);
+	hlist_del(&f->by_hash);
+	devm_kfree(dev, f);
+}
+
+int ionic_rx_filter_del(struct lif *lif, struct rx_filter *f)
+{
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.rx_filter_del = {
+			.opcode = CMD_OPCODE_RX_FILTER_DEL,
+			.filter_id = cpu_to_le32(f->filter_id),
+		},
+	};
+
+	return ionic_adminq_post_wait(lif, &ctx);
+}
+
+int ionic_rx_filters_init(struct lif *lif)
+{
+	unsigned int i;
+
+	spin_lock_init(&lif->rx_filters.lock);
+
+	for (i = 0; i < RX_FILTER_HLISTS; i++) {
+		INIT_HLIST_HEAD(&lif->rx_filters.by_hash[i]);
+		INIT_HLIST_HEAD(&lif->rx_filters.by_id[i]);
+	}
+
+	return 0;
+}
+
+void ionic_rx_filters_deinit(struct lif *lif)
+{
+	struct hlist_head *head;
+	struct hlist_node *tmp;
+	struct rx_filter *f;
+	unsigned int i;
+
+	for (i = 0; i < RX_FILTER_HLISTS; i++) {
+		head = &lif->rx_filters.by_id[i];
+		hlist_for_each_entry_safe(f, tmp, head, by_id)
+			ionic_rx_filter_free(lif, f);
+	}
+}
+
+int ionic_rx_filter_save(struct lif *lif, u32 flow_id, u16 rxq_index,
+			 u32 hash, struct ionic_admin_ctx *ctx)
+{
+	struct device *dev = lif->ionic->dev;
+	struct rx_filter_add_cmd *ac;
+	struct hlist_head *head;
+	struct rx_filter *f;
+	unsigned int key;
+
+	ac = &ctx->cmd.rx_filter_add;
+
+	switch (le16_to_cpu(ac->match)) {
+	case RX_FILTER_MATCH_VLAN:
+		key = le16_to_cpu(ac->vlan.vlan);
+		break;
+	case RX_FILTER_MATCH_MAC:
+		key = *(u32 *)ac->mac.addr;
+		break;
+	case RX_FILTER_MATCH_MAC_VLAN:
+		key = le16_to_cpu(ac->mac_vlan.vlan);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	f = devm_kzalloc(dev, sizeof(*f), GFP_KERNEL);
+	if (!f)
+		return -ENOMEM;
+
+	f->flow_id = flow_id;
+	f->filter_id = le32_to_cpu(ctx->comp.rx_filter_add.filter_id);
+	f->rxq_index = rxq_index;
+	memcpy(&f->cmd, ac, sizeof(f->cmd));
+
+	INIT_HLIST_NODE(&f->by_hash);
+	INIT_HLIST_NODE(&f->by_id);
+
+	spin_lock_bh(&lif->rx_filters.lock);
+
+	key = hash_32(key, RX_FILTER_HASH_BITS);
+	head = &lif->rx_filters.by_hash[key];
+	hlist_add_head(&f->by_hash, head);
+
+	key = f->filter_id & RX_FILTER_HLISTS_MASK;
+	head = &lif->rx_filters.by_id[key];
+	hlist_add_head(&f->by_id, head);
+
+	spin_unlock_bh(&lif->rx_filters.lock);
+
+	return 0;
+}
+
+struct rx_filter *ionic_rx_filter_by_vlan(struct lif *lif, u16 vid)
+{
+	unsigned int key = hash_32(vid, RX_FILTER_HASH_BITS);
+	struct hlist_head *head = &lif->rx_filters.by_hash[key];
+	struct rx_filter *f;
+
+	hlist_for_each_entry(f, head, by_hash) {
+		if (le16_to_cpu(f->cmd.match) != RX_FILTER_MATCH_VLAN)
+			continue;
+		if (le16_to_cpu(f->cmd.vlan.vlan) == vid)
+			return f;
+	}
+
+	return NULL;
+}
+
+struct rx_filter *ionic_rx_filter_by_addr(struct lif *lif, const u8 *addr)
+{
+	unsigned int key = hash_32(*(u32 *)addr, RX_FILTER_HASH_BITS);
+	struct hlist_head *head = &lif->rx_filters.by_hash[key];
+	struct rx_filter *f;
+
+	hlist_for_each_entry(f, head, by_hash) {
+		if (le16_to_cpu(f->cmd.match) != RX_FILTER_MATCH_MAC)
+			continue;
+		if (memcmp(addr, f->cmd.mac.addr, ETH_ALEN) == 0)
+			return f;
+	}
+
+	return NULL;
+}
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.h b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.h
new file mode 100644
index 000000000000..67ae279a4cb6
--- /dev/null
+++ b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
+
+#ifndef _IONIC_RX_FILTER_H_
+#define _IONIC_RX_FILTER_H_
+
+#define RXQ_INDEX_ANY		(0xFFFF)
+struct rx_filter {
+	u32 flow_id;
+	u32 filter_id;
+	u16 rxq_index;
+	struct rx_filter_add_cmd cmd;
+	struct hlist_node by_hash;
+	struct hlist_node by_id;
+};
+
+#define RX_FILTER_HASH_BITS	10
+#define RX_FILTER_HLISTS	BIT(RX_FILTER_HASH_BITS)
+#define RX_FILTER_HLISTS_MASK	(RX_FILTER_HLISTS - 1)
+struct rx_filters {
+	spinlock_t lock;				/* filter list lock */
+	struct hlist_head by_hash[RX_FILTER_HLISTS];	/* by skb hash */
+	struct hlist_head by_id[RX_FILTER_HLISTS];	/* by filter_id */
+};
+
+void ionic_rx_filter_free(struct lif *lif, struct rx_filter *f);
+int ionic_rx_filter_del(struct lif *lif, struct rx_filter *f);
+int ionic_rx_filters_init(struct lif *lif);
+void ionic_rx_filters_deinit(struct lif *lif);
+int ionic_rx_filter_save(struct lif *lif, u32 flow_id, u16 rxq_index,
+			 u32 hash, struct ionic_admin_ctx *ctx);
+struct rx_filter *ionic_rx_filter_by_vlan(struct lif *lif, u16 vid);
+struct rx_filter *ionic_rx_filter_by_addr(struct lif *lif, const u8 *addr);
+
+#endif /* _IONIC_RX_FILTER_H_ */
-- 
2.17.1

