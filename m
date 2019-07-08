Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D973E62981
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 21:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404158AbfGHT0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 15:26:10 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42149 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404105AbfGHTZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 15:25:49 -0400
Received: by mail-pl1-f194.google.com with SMTP id ay6so8767644plb.9
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 12:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=plkRr1YIlh+mZqe8HrINY0aBeazGwC+BezMcbCTMbr4=;
        b=4GoYYWW8mfBGYmUPQwlrrSU2EL971Upm42NJh+rgBcW9PPCFnQcyh1KPm1im0s2kNe
         aAcrx3OkT/iN1oJecPhJxcfxnn2HkecKXywuxArRQo4A679rKkKeZ5hx3Qvc1CZM0pln
         hP97N/krdThe02Qnx7jQQTpuND7+oWUlRf0NYdrHCALxo3iPy+5OCYqlCLYf85jeiHcd
         l4U/h+lUZfwITeEFaDGrXWe5LHb5JgWSisKplpyoc6KmKsYFMdmTSPgCwVBZZZtd+Wh3
         aQTR2YWlShwNXXoosJRtR/tedQlllyCLYJ21/dNRoYySV5nmVp0DDaFWwBzgsKDEubhh
         z4Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=plkRr1YIlh+mZqe8HrINY0aBeazGwC+BezMcbCTMbr4=;
        b=C0khSRm2MCecHSL6RLPYIYD2Jz8nMMtEv4+PdcXoVsfaeFSSaE5mnjcPTqRIVVvVwM
         NfU+hWtaEvoUs6snXqch/6pANehGlA9g3dOsCUHCr0QyGhxW7mY731x9ipk/8QQkd92H
         N0Y0iL2dUb1IYUPliKlGWPOJrR1V3/KdDBvvFWapwoICvMAQQm3pSs5N9wQpBIgvAtb5
         K/ZH0jDAFau5D2ojUlwe4fSNJ3giBY41DauGPu+OaHnP6T61SPQXeU7Zl2Q+nuXOwGkl
         TbhsobaMLfRnBpLrQ582R2BzTNYSEb+7FUC2ND1AhwNlhKO98eF9iI2V//VLuegq9say
         vDFw==
X-Gm-Message-State: APjAAAWoEFE/YCxp00C+G8AulLh5NKffLCTfuuSPjLblgyeYFpK8Tza5
        vMEAwZPTui6ZamY6WLoAVmXiPg==
X-Google-Smtp-Source: APXvYqy4KVCWcEl/X+7YPa129VoBOi39KKb5hPLwB0MWfv9iaUbxYgrNiNeFDFLTy7uVehOj4i752Q==
X-Received: by 2002:a17:902:ab83:: with SMTP id f3mr27133139plr.122.1562613948325;
        Mon, 08 Jul 2019 12:25:48 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id n19sm20006770pfa.11.2019.07.08.12.25.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 12:25:47 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org
Subject: [PATCH v3 net-next 10/19] ionic: Add management of rx filters
Date:   Mon,  8 Jul 2019 12:25:23 -0700
Message-Id: <20190708192532.27420-11-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190708192532.27420-1-snelson@pensando.io>
References: <20190708192532.27420-1-snelson@pensando.io>
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
 .../ethernet/pensando/ionic/ionic_rx_filter.c | 142 ++++++++++++++++++
 .../ethernet/pensando/ionic/ionic_rx_filter.h |  34 +++++
 5 files changed, 186 insertions(+), 2 deletions(-)
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
index 000000000000..621e0159aba8
--- /dev/null
+++ b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
@@ -0,0 +1,142 @@
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
+	ac = (struct rx_filter_add_cmd *)&ctx->cmd;
+
+	switch (le16_to_cpu(ac->match)) {
+	case RX_FILTER_MATCH_VLAN:
+		key = le16_to_cpu(ac->vlan.vlan) & RX_FILTER_HLISTS_MASK;
+		break;
+	case RX_FILTER_MATCH_MAC:
+		key = *(u32 *)ac->mac.addr & RX_FILTER_HLISTS_MASK;
+		break;
+	case RX_FILTER_MATCH_MAC_VLAN:
+		key = le16_to_cpu(ac->mac_vlan.vlan) & RX_FILTER_HLISTS_MASK;
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
+	unsigned int key = vid & RX_FILTER_HLISTS_MASK;
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
+	unsigned int key = *(u32 *)addr & RX_FILTER_HLISTS_MASK;
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
index 000000000000..c8688124465a
--- /dev/null
+++ b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.h
@@ -0,0 +1,34 @@
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
+#define RX_FILTER_HLISTS	BIT(10)
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

