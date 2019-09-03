Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62990A76FB
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 00:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbfICW3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 18:29:01 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44542 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727281AbfICW27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 18:28:59 -0400
Received: by mail-pg1-f195.google.com with SMTP id i18so9988954pgl.11
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 15:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=+2mYqfnRIym2NCNUE4a1PArqKz1Xq8BduX0kj9MMv8M=;
        b=0pDQbCTszGRI6yy1ykWRcCnOZ5kfJOF/clh3cQs0VNJCS6/1zXlzwltDEd7I+1b59w
         GwLu7kwsjU+pJtpNH68srQm74lE6rh/7ctQElVx/QsPM85q+0H8EBjX0Onc37lbYwOcp
         i29rRfrMTH9KQUHE+o93rWN100Z8XRgJhbyb5M2ofZVU/iRtuOPkqN76znsSjL2iO9rR
         rLcLgLIL6R5IHVRD6s1SEwYzZOZA+hxSOofnqlRcEg9rxSF/OtRPOpuVjsLcSqc/FQwZ
         UgYjTYVVyRaOY7I3YvGufHsj2QSzVkvANcksG5D27CyYCNRzeIpNV4r2ujhMVNZk/dNh
         J/dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=+2mYqfnRIym2NCNUE4a1PArqKz1Xq8BduX0kj9MMv8M=;
        b=S1mUq4oPUaJMiIWt62iKbvSA3Gmg460HgoCdzwNi4eUiQ+m2AcPtdD8nqQ3FuE5C9w
         1iyL6VcjubKqK4zCK+UdU5dDJOdeibwOfWG5lN34PXeUi1sZpzKI89IZbvDYEWE26Dfu
         gyqlPaLMyVQs7+XK3camstLh6VQogafiQ4o2ZlOt68pwFUrQZLuoZP+nJYJ8O/QewYTb
         eDMqtgJognz7hD31ygUPD8yPEWHwKBD6gzwp4lEebKpEIPI9Zg++KNYLAo9lAJ11Tixe
         rOsAUvMp1/WWrqWFp5bYondRFESJ2byA3GRtWiq4JyWF0wdcFqnmEBAQINeP0usotSYt
         O9iw==
X-Gm-Message-State: APjAAAVQKKGko6RA/32ayhgzTwLH5xHLJx3HkgJs43oo5WnNcNQH7R1Z
        lUtGgie7X1j1wsVZav2OeA45Tg==
X-Google-Smtp-Source: APXvYqwEXr9AeiGcrzfUWdsLOXG6x8Jxrb1K1ueLWnnM5mmq4PDiIClMtc/tiz1/Qz0GD/hJNuCtQA==
X-Received: by 2002:aa7:91d7:: with SMTP id z23mr29373071pfa.262.1567549738314;
        Tue, 03 Sep 2019 15:28:58 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id e17sm520520pjt.6.2019.09.03.15.28.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Sep 2019 15:28:57 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v7 net-next 11/19] ionic: Add management of rx filters
Date:   Tue,  3 Sep 2019 15:28:13 -0700
Message-Id: <20190903222821.46161-12-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190903222821.46161-1-snelson@pensando.io>
References: <20190903222821.46161-1-snelson@pensando.io>
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
index 9ccb72d45015..2a3f11962bd1 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -830,6 +830,8 @@ static void ionic_lif_deinit(struct ionic_lif *lif)
 
 	clear_bit(IONIC_LIF_INITED, lif->state);
 
+	ionic_rx_filters_deinit(lif);
+
 	napi_disable(&lif->adminqcq->napi);
 	ionic_lif_qcq_deinit(lif, lif->notifyqcq);
 	ionic_lif_qcq_deinit(lif, lif->adminqcq);
@@ -1009,6 +1011,10 @@ static int ionic_lif_init(struct ionic_lif *lif)
 	if (err)
 		goto err_out_notifyq_deinit;
 
+	err = ionic_rx_filters_init(lif);
+	if (err)
+		goto err_out_notifyq_deinit;
+
 	set_bit(IONIC_LIF_INITED, lif->state);
 
 	return 0;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 1d9a35745bce..53fb4c71a101 100644
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

