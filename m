Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA4CE9D881
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 23:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729189AbfHZVeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 17:34:02 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44888 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729099AbfHZVeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 17:34:01 -0400
Received: by mail-pl1-f194.google.com with SMTP id t14so10650248plr.11
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 14:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=xW6BtrIUBdZPLCRXpCx0XBKATnPszIQ/RFMdyAVRaVQ=;
        b=1p3TH41H9xoa6w6e8K6pvl8f/43UwA46h00Z+SKXOuYolC23fuc+x4drilMl753xFx
         0wvcP3OZkDeqcd5CV28iWHLgcY0dHypRT2ozjBjJL1ebnuP9XFRai2SpjgFduuCMHr1f
         nh/xQsKy0v27CSJ3sfDmX6FKG6DtCUliEqFNmCTHXqFn/mLece9jZACXrIEvik1RLjU4
         ark3VddZXCAyKCiClO6nPyPJrx5jwmMTWt6IxFeNdFjRbgWgjfRA+ukAMGWZwIaJgiYL
         oFtSGVS82e4tYJzafZ0j7re0Kipn8N/JuKZsw1azbLOWBT7vtKaTf9cATV8jIwDeW4+w
         8IgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=xW6BtrIUBdZPLCRXpCx0XBKATnPszIQ/RFMdyAVRaVQ=;
        b=EdQ34lhUNrzBygDjHDFBjOKIA8bNq0ZhuTXT5QXs5dqEa2iED7QVX/ceu84dtGwYra
         rjRmOZgOYAi0T8ma6qV7cxpi8Ui6JOXgmTboxPGfR2HsMgXwEHTErkl2S5JRP99MKKZo
         8U9Haj/isP8ehR/KvEDmoO5vCJvPcov8GegeU9dLozIBUlY6M/wIIuCFeH2F0l1i8rHr
         RImFQRmCepVMw3X8T7KuMlKii6vCOtE3tmLgJd5J8X6+fk4Kaxa0XUWEb/2gAnc1zyBt
         JQOX8OD1RQod9ySomo5xD+ZWKdr+S5cke77UTo3nvDK2pnuKO0I4+uQCbrs6KcWg9Dz4
         EDPw==
X-Gm-Message-State: APjAAAUnBl0TOQu9Y2/0tIvE08woNLAkaPfxi8veF9SnBmpzzYsASC13
        RR5J5RJWIahGoxT30+pv6Z1FIA==
X-Google-Smtp-Source: APXvYqweiGjETdUcDycaFqkDSVS/SjcIVBbOCNKoZX7AQ/bYgjTECWmZ49XASlH8dmdJWC0+rETZ0A==
X-Received: by 2002:a17:902:8ecc:: with SMTP id x12mr21338147plo.258.1566855240471;
        Mon, 26 Aug 2019 14:34:00 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id j9sm5876905pfi.128.2019.08.26.14.33.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 14:33:59 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v5 net-next 10/18] ionic: Add management of rx filters
Date:   Mon, 26 Aug 2019 14:33:31 -0700
Message-Id: <20190826213339.56909-11-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190826213339.56909-1-snelson@pensando.io>
References: <20190826213339.56909-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set up the infrastructure for managing Rx filters.  We can't ask the
hardware for what filters it has, so we keep a local list of filters
that we've pushed into the HW.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/Makefile  |   2 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   |   6 +
 .../net/ethernet/pensando/ionic/ionic_lif.h   |   2 +
 .../ethernet/pensando/ionic/ionic_rx_filter.c | 150 ++++++++++++++++++
 .../ethernet/pensando/ionic/ionic_rx_filter.h |  35 ++++
 5 files changed, 194 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_rx_filter.h

diff --git a/drivers/net/ethernet/pensando/ionic/Makefile b/drivers/net/ethernet/pensando/ionic/Makefile
index 215ed1ea44df..8c31a90830cf 100644
--- a/drivers/net/ethernet/pensando/ionic/Makefile
+++ b/drivers/net/ethernet/pensando/ionic/Makefile
@@ -4,4 +4,4 @@
 obj-$(CONFIG_IONIC) := ionic.o
 
 ionic-y := ionic_main.o ionic_bus_pci.o ionic_devlink.o ionic_dev.o \
-	   ionic_debugfs.o ionic_lif.o
+	   ionic_debugfs.o ionic_lif.o ionic_rx_filter.o
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index f1c152dd4559..373b93403190 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -831,6 +831,8 @@ static void ionic_lif_deinit(struct ionic_lif *lif)
 
 	clear_bit(IONIC_LIF_INITED, lif->state);
 
+	ionic_rx_filters_deinit(lif);
+
 	napi_disable(&lif->adminqcq->napi);
 	ionic_lif_qcq_deinit(lif, lif->notifyqcq);
 	ionic_lif_qcq_deinit(lif, lif->adminqcq);
@@ -1010,6 +1012,10 @@ static int ionic_lif_init(struct ionic_lif *lif)
 	if (err)
 		goto err_out_notifyq_deinit;
 
+	err = ionic_rx_filters_init(lif);
+	if (err)
+		goto err_out_notifyq_deinit;
+
 	set_bit(IONIC_LIF_INITED, lif->state);
 
 	return 0;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 866411a7a1fe..b1cd51a5162c 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -5,6 +5,7 @@
 #define _IONIC_LIF_H_
 
 #include <linux/pci.h>
+#include "ionic_rx_filter.h"
 
 #define IONIC_ADMINQ_LENGTH	16	/* must be a power of two */
 #define IONIC_NOTIFYQ_LENGTH	64	/* must be a power of two */
@@ -90,6 +91,7 @@ struct ionic_lif {
 	dma_addr_t info_pa;
 	u32 info_sz;
 
+	struct ionic_rx_filters rx_filters;
 	unsigned long *dbid_inuse;
 	unsigned int dbid_count;
 	struct dentry *dentry;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
new file mode 100644
index 000000000000..7a093f148ee5
--- /dev/null
+++ b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
@@ -0,0 +1,150 @@
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
+void ionic_rx_filter_free(struct ionic_lif *lif, struct ionic_rx_filter *f)
+{
+	struct device *dev = lif->ionic->dev;
+
+	hlist_del(&f->by_id);
+	hlist_del(&f->by_hash);
+	devm_kfree(dev, f);
+}
+
+int ionic_rx_filter_del(struct ionic_lif *lif, struct ionic_rx_filter *f)
+{
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.rx_filter_del = {
+			.opcode = IONIC_CMD_RX_FILTER_DEL,
+			.filter_id = cpu_to_le32(f->filter_id),
+		},
+	};
+
+	return ionic_adminq_post_wait(lif, &ctx);
+}
+
+int ionic_rx_filters_init(struct ionic_lif *lif)
+{
+	unsigned int i;
+
+	spin_lock_init(&lif->rx_filters.lock);
+
+	for (i = 0; i < IONIC_RX_FILTER_HLISTS; i++) {
+		INIT_HLIST_HEAD(&lif->rx_filters.by_hash[i]);
+		INIT_HLIST_HEAD(&lif->rx_filters.by_id[i]);
+	}
+
+	return 0;
+}
+
+void ionic_rx_filters_deinit(struct ionic_lif *lif)
+{
+	struct ionic_rx_filter *f;
+	struct hlist_head *head;
+	struct hlist_node *tmp;
+	unsigned int i;
+
+	for (i = 0; i < IONIC_RX_FILTER_HLISTS; i++) {
+		head = &lif->rx_filters.by_id[i];
+		hlist_for_each_entry_safe(f, tmp, head, by_id)
+			ionic_rx_filter_free(lif, f);
+	}
+}
+
+int ionic_rx_filter_save(struct ionic_lif *lif, u32 flow_id, u16 rxq_index,
+			 u32 hash, struct ionic_admin_ctx *ctx)
+{
+	struct device *dev = lif->ionic->dev;
+	struct ionic_rx_filter_add_cmd *ac;
+	struct ionic_rx_filter *f;
+	struct hlist_head *head;
+	unsigned int key;
+
+	ac = &ctx->cmd.rx_filter_add;
+
+	switch (le16_to_cpu(ac->match)) {
+	case IONIC_RX_FILTER_MATCH_VLAN:
+		key = le16_to_cpu(ac->vlan.vlan);
+		break;
+	case IONIC_RX_FILTER_MATCH_MAC:
+		key = *(u32 *)ac->mac.addr;
+		break;
+	case IONIC_RX_FILTER_MATCH_MAC_VLAN:
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
+	key = hash_32(key, IONIC_RX_FILTER_HASH_BITS);
+	head = &lif->rx_filters.by_hash[key];
+	hlist_add_head(&f->by_hash, head);
+
+	key = f->filter_id & IONIC_RX_FILTER_HLISTS_MASK;
+	head = &lif->rx_filters.by_id[key];
+	hlist_add_head(&f->by_id, head);
+
+	spin_unlock_bh(&lif->rx_filters.lock);
+
+	return 0;
+}
+
+struct ionic_rx_filter *ionic_rx_filter_by_vlan(struct ionic_lif *lif, u16 vid)
+{
+	struct ionic_rx_filter *f;
+	struct hlist_head *head;
+	unsigned int key;
+
+	key = hash_32(vid, IONIC_RX_FILTER_HASH_BITS);
+	head = &lif->rx_filters.by_hash[key];
+
+	hlist_for_each_entry(f, head, by_hash) {
+		if (le16_to_cpu(f->cmd.match) != IONIC_RX_FILTER_MATCH_VLAN)
+			continue;
+		if (le16_to_cpu(f->cmd.vlan.vlan) == vid)
+			return f;
+	}
+
+	return NULL;
+}
+
+struct ionic_rx_filter *ionic_rx_filter_by_addr(struct ionic_lif *lif,
+						const u8 *addr)
+{
+	struct ionic_rx_filter *f;
+	struct hlist_head *head;
+	unsigned int key;
+
+	key = hash_32(*(u32 *)addr, IONIC_RX_FILTER_HASH_BITS);
+	head = &lif->rx_filters.by_hash[key];
+
+	hlist_for_each_entry(f, head, by_hash) {
+		if (le16_to_cpu(f->cmd.match) != IONIC_RX_FILTER_MATCH_MAC)
+			continue;
+		if (memcmp(addr, f->cmd.mac.addr, ETH_ALEN) == 0)
+			return f;
+	}
+
+	return NULL;
+}
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.h b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.h
new file mode 100644
index 000000000000..b6aec9c19918
--- /dev/null
+++ b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
+
+#ifndef _IONIC_RX_FILTER_H_
+#define _IONIC_RX_FILTER_H_
+
+#define IONIC_RXQ_INDEX_ANY		(0xFFFF)
+struct ionic_rx_filter {
+	u32 flow_id;
+	u32 filter_id;
+	u16 rxq_index;
+	struct ionic_rx_filter_add_cmd cmd;
+	struct hlist_node by_hash;
+	struct hlist_node by_id;
+};
+
+#define IONIC_RX_FILTER_HASH_BITS	10
+#define IONIC_RX_FILTER_HLISTS		BIT(IONIC_RX_FILTER_HASH_BITS)
+#define IONIC_RX_FILTER_HLISTS_MASK	(IONIC_RX_FILTER_HLISTS - 1)
+struct ionic_rx_filters {
+	spinlock_t lock;				    /* filter list lock */
+	struct hlist_head by_hash[IONIC_RX_FILTER_HLISTS];  /* by skb hash */
+	struct hlist_head by_id[IONIC_RX_FILTER_HLISTS];    /* by filter_id */
+};
+
+void ionic_rx_filter_free(struct ionic_lif *lif, struct ionic_rx_filter *f);
+int ionic_rx_filter_del(struct ionic_lif *lif, struct ionic_rx_filter *f);
+int ionic_rx_filters_init(struct ionic_lif *lif);
+void ionic_rx_filters_deinit(struct ionic_lif *lif);
+int ionic_rx_filter_save(struct ionic_lif *lif, u32 flow_id, u16 rxq_index,
+			 u32 hash, struct ionic_admin_ctx *ctx);
+struct ionic_rx_filter *ionic_rx_filter_by_vlan(struct ionic_lif *lif, u16 vid);
+struct ionic_rx_filter *ionic_rx_filter_by_addr(struct ionic_lif *lif, const u8 *addr);
+
+#endif /* _IONIC_RX_FILTER_H_ */
-- 
2.17.1

