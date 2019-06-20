Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFFB4DB1F
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 22:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbfFTUYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 16:24:44 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36737 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727125AbfFTUYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 16:24:41 -0400
Received: by mail-pl1-f195.google.com with SMTP id k8so1846012plt.3
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 13:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=n9pN/D3HOEDApM/r9Ym/VuhVtqeeV9YpstcV+NPTJ5Y=;
        b=eTTqqxcDVzk8+JnJ4nyrKfSej2J3GcC8o0f5BffxzCIR1C+D2/edmpNTXXtAPWtolp
         ZW8b8gkMS/eZ+SD1Bu+f8rbZyxZuCuzD1yzgQ7XVYD3vwSKysoUMF6drIfmFws0BLo+D
         qU//IR/DbVKbNxDUmT24YhXT6b7kKNVR7couvW6KKrR2+G7dJKsgty4WYyyHJLJmS9oJ
         NDBcII/SM1miUbCHGaMZVAgiBVI++MzhwOtR3TlePFqMJCnDjXt+I/gzhw4SFIh0dGje
         JRLBHoFsKKkJAOUYYvfYm5yF80VL1LukbBb7C4Xpe/PIz59iMb0AzKy97kT8lBmpSsDN
         LKqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=n9pN/D3HOEDApM/r9Ym/VuhVtqeeV9YpstcV+NPTJ5Y=;
        b=Qm5FeUsC72MpkGb9zWWQSxqw0vc8dnE0UTF/uzNnUpm5lzZzxBj/bin2GwjuE4dCKX
         1r9OP9wrB26EZeAYl5MQfKEJI82C+eldELMqBOuq2K6pl1T9caGGjx/MSzpnEXa/SsN3
         qzxXFGzl5Kno4a8OlDpkJmv6hRKWWwcz4SLkhZnlO7JeJ4ADJ0ZKcN5tqTnkYXK64jcy
         +atbHJal+aOH+iyRUh6bctS0T7BAPn038OMy0KTncUg350uaNmgpiRTkAjO8LI3FUDr0
         K57J2wnQWMTX9dM6/kYAmQI2GRdwzfXYxGedSQEELrFYOKMEzF5FPrdzxh8O8pmPKGd4
         KW4Q==
X-Gm-Message-State: APjAAAUk6SX4bhTL17J7AL1soMoNDD4XZHJE0virMCVmnxoBOLZB9OyE
        I/+DAxjG6empQCrdiS/8EVeeDulCTE8=
X-Google-Smtp-Source: APXvYqxMM6qzk8fD2bZpVoN/APbtW6qj2zi75DhjLWTL9zKYPnpIEwjvWaN+Z5n9dA1V50o6FtzRaA==
X-Received: by 2002:a17:902:2a29:: with SMTP id i38mr99399900plb.46.1561062280113;
        Thu, 20 Jun 2019 13:24:40 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id h26sm340537pfq.64.2019.06.20.13.24.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 13:24:39 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org
Subject: [PATCH net-next 10/18] ionic: Add management of rx filters
Date:   Thu, 20 Jun 2019 13:24:16 -0700
Message-Id: <20190620202424.23215-11-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190620202424.23215-1-snelson@pensando.io>
References: <20190620202424.23215-1-snelson@pensando.io>
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
 .../ethernet/pensando/ionic/ionic_rx_filter.c | 139 ++++++++++++++++++
 .../ethernet/pensando/ionic/ionic_rx_filter.h |  34 +++++
 5 files changed, 183 insertions(+), 2 deletions(-)
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
index c6444174f649..ac4a8dbd33fb 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -678,6 +678,8 @@ static void ionic_lif_deinit(struct lif *lif)
 
 	clear_bit(LIF_INITED, lif->state);
 
+	ionic_rx_filters_deinit(lif);
+
 	napi_disable(&lif->adminqcq->napi);
 	ionic_lif_qcq_deinit(lif, lif->notifyqcq);
 	ionic_lif_qcq_deinit(lif, lif->adminqcq);
@@ -1053,6 +1055,10 @@ static int ionic_lif_init(struct lif *lif)
 	if (err)
 		goto err_out_notifyq_deinit;
 
+	err = ionic_rx_filters_init(lif);
+	if (err)
+		goto err_out_notifyq_deinit;
+
 	set_bit(LIF_INITED, lif->state);
 
 	return 0;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 03d3685ad98e..8129fa20695a 100644
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
index 000000000000..618b7c4b9674
--- /dev/null
+++ b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
@@ -0,0 +1,139 @@
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
+	struct hlist_head *head;
+	struct rx_filter *f;
+	unsigned int key;
+
+	f = devm_kzalloc(dev, sizeof(*f), GFP_KERNEL);
+	if (!f)
+		return -ENOMEM;
+
+	f->flow_id = flow_id;
+	f->filter_id = le32_to_cpu(ctx->comp.rx_filter_add.filter_id);
+	f->rxq_index = rxq_index;
+	memcpy(&f->cmd, &ctx->cmd, sizeof(f->cmd));
+
+	INIT_HLIST_NODE(&f->by_hash);
+	INIT_HLIST_NODE(&f->by_id);
+
+	switch (le16_to_cpu(f->cmd.match)) {
+	case RX_FILTER_MATCH_VLAN:
+		key = le16_to_cpu(f->cmd.vlan.vlan) & RX_FILTER_HLISTS_MASK;
+		break;
+	case RX_FILTER_MATCH_MAC:
+		key = *(u32 *)f->cmd.mac.addr & RX_FILTER_HLISTS_MASK;
+		break;
+	case RX_FILTER_MATCH_MAC_VLAN:
+		key = le16_to_cpu(f->cmd.mac_vlan.vlan) & RX_FILTER_HLISTS_MASK;
+		break;
+	default:
+		return -ENOTSUPP;
+	}
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

