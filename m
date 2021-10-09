Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70F08427CBD
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 20:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbhJISrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 14:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbhJISrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 14:47:31 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD6AFC061570
        for <netdev@vger.kernel.org>; Sat,  9 Oct 2021 11:45:33 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id np13so10024912pjb.4
        for <netdev@vger.kernel.org>; Sat, 09 Oct 2021 11:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dLUYf3IO+geaxiyWZv7krbcqOQ6TyS6gJ1exzgQUyns=;
        b=MhGZlbQicjXqnyBPEIJ52Ol0Jwzj/shW8jJnDWe3/nrErBSQySoO+MPh6OSRDq7Cma
         BgP+T5ebhl4QICMrtArPMa64XNdpP8mnJ3Oroxs9O91hXHMD+AB2pBylPO6BAO/BWF5j
         +YOV1nsI7kIe0s27XptEHLOIEfGj/GSwAs3W8FG7xca/SsQoaMK0u6i1lZPkQmOMJTrt
         nmicZ+lNlS3x7oaFPCF8tCrZC8btJtffw1AWYTLqISfXvzygSX1HtmbbIj0P7Hawc/iz
         w8QUzWEgH/JYd9eybjVwkSnzMMHhTS8Vx2bHJQztQwCeNI5Zyh0miQhXXXftVmbndsk9
         khjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dLUYf3IO+geaxiyWZv7krbcqOQ6TyS6gJ1exzgQUyns=;
        b=PxDwzwsffCKQ7pgNDNr2qEj7mTujrHZJvSijCtJAVQGvlcrrif0pAWpCtdhZhg+uZm
         9uzSnzW4fVDl+Hf515bsTLI/VSXgJNh/FYSys+nPJ+W9EQmColcFePzGLBPNB21sX+Jz
         +F/c2G4DmujZNHpNS5Mb0906ucGd/hGsItyZIWY2eN1Db7BbUhSUJcDQ95RlJStc3epw
         zGZjPzguNIQ2YXvvTygaHge4EpFm86b3JsoC4HZqKD4/bFOKBNJn7DjWsaAKSc8edtkG
         N8G29wDxGozmLlLjYj3idkX5W6tNiOo2dUIUkp7PeupzE6nNAsu5iocTdBnfSc/BxbUY
         OU6A==
X-Gm-Message-State: AOAM532GZUg60Nfix6+wfl2712g1JelZHDh6Fozpts15MkFcwFaYu42b
        +AEy3jj4UesxWk5/5wCXQ2ehyg==
X-Google-Smtp-Source: ABdhPJyrN+5VchvwaIaWFRg/uvc3oZelss/VTO/UvxmqcN2mBOdSg2y1rwBfvURgq34IYsvhfFKDbA==
X-Received: by 2002:a17:90a:9404:: with SMTP id r4mr19568166pjo.240.1633805133433;
        Sat, 09 Oct 2021 11:45:33 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id s30sm3368433pgo.39.2021.10.09.11.45.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 11:45:33 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 2/9] ionic: move lif mac address functions
Date:   Sat,  9 Oct 2021 11:45:16 -0700
Message-Id: <20211009184523.73154-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211009184523.73154-1-snelson@pensando.io>
References: <20211009184523.73154-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The routines that add and delete mac addresses from the
firmware really should be in the file with the rest of
the filter management.  This simply moves the functions
with no logic changes.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 131 ------------------
 .../ethernet/pensando/ionic/ionic_rx_filter.c | 131 ++++++++++++++++++
 2 files changed, 131 insertions(+), 131 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 775ce83a1b28..968403a01477 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1242,137 +1242,6 @@ void ionic_get_stats64(struct net_device *netdev,
 	ns->tx_errors = ns->tx_aborted_errors;
 }
 
-int ionic_lif_addr_add(struct ionic_lif *lif, const u8 *addr)
-{
-	struct ionic_admin_ctx ctx = {
-		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
-		.cmd.rx_filter_add = {
-			.opcode = IONIC_CMD_RX_FILTER_ADD,
-			.lif_index = cpu_to_le16(lif->index),
-			.match = cpu_to_le16(IONIC_RX_FILTER_MATCH_MAC),
-		},
-	};
-	int nfilters = le32_to_cpu(lif->identity->eth.max_ucast_filters);
-	bool mc = is_multicast_ether_addr(addr);
-	struct ionic_rx_filter *f;
-	int err = 0;
-
-	memcpy(ctx.cmd.rx_filter_add.mac.addr, addr, ETH_ALEN);
-
-	spin_lock_bh(&lif->rx_filters.lock);
-	f = ionic_rx_filter_by_addr(lif, addr);
-	if (f) {
-		/* don't bother if we already have it and it is sync'd */
-		if (f->state == IONIC_FILTER_STATE_SYNCED) {
-			spin_unlock_bh(&lif->rx_filters.lock);
-			return 0;
-		}
-
-		/* mark preemptively as sync'd to block any parallel attempts */
-		f->state = IONIC_FILTER_STATE_SYNCED;
-	} else {
-		/* save as SYNCED to catch any DEL requests while processing */
-		err = ionic_rx_filter_save(lif, 0, IONIC_RXQ_INDEX_ANY, 0, &ctx,
-					   IONIC_FILTER_STATE_SYNCED);
-	}
-	spin_unlock_bh(&lif->rx_filters.lock);
-	if (err)
-		return err;
-
-	netdev_dbg(lif->netdev, "rx_filter add ADDR %pM\n", addr);
-
-	/* Don't bother with the write to FW if we know there's no room,
-	 * we can try again on the next sync attempt.
-	 */
-	if ((lif->nucast + lif->nmcast) >= nfilters)
-		err = -ENOSPC;
-	else
-		err = ionic_adminq_post_wait(lif, &ctx);
-
-	spin_lock_bh(&lif->rx_filters.lock);
-	if (err && err != -EEXIST) {
-		/* set the state back to NEW so we can try again later */
-		f = ionic_rx_filter_by_addr(lif, addr);
-		if (f && f->state == IONIC_FILTER_STATE_SYNCED) {
-			f->state = IONIC_FILTER_STATE_NEW;
-			set_bit(IONIC_LIF_F_FILTER_SYNC_NEEDED, lif->state);
-		}
-
-		spin_unlock_bh(&lif->rx_filters.lock);
-
-		if (err == -ENOSPC)
-			return 0;
-		else
-			return err;
-	}
-
-	if (mc)
-		lif->nmcast++;
-	else
-		lif->nucast++;
-
-	f = ionic_rx_filter_by_addr(lif, addr);
-	if (f && f->state == IONIC_FILTER_STATE_OLD) {
-		/* Someone requested a delete while we were adding
-		 * so update the filter info with the results from the add
-		 * and the data will be there for the delete on the next
-		 * sync cycle.
-		 */
-		err = ionic_rx_filter_save(lif, 0, IONIC_RXQ_INDEX_ANY, 0, &ctx,
-					   IONIC_FILTER_STATE_OLD);
-	} else {
-		err = ionic_rx_filter_save(lif, 0, IONIC_RXQ_INDEX_ANY, 0, &ctx,
-					   IONIC_FILTER_STATE_SYNCED);
-	}
-
-	spin_unlock_bh(&lif->rx_filters.lock);
-
-	return err;
-}
-
-int ionic_lif_addr_del(struct ionic_lif *lif, const u8 *addr)
-{
-	struct ionic_admin_ctx ctx = {
-		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
-		.cmd.rx_filter_del = {
-			.opcode = IONIC_CMD_RX_FILTER_DEL,
-			.lif_index = cpu_to_le16(lif->index),
-		},
-	};
-	struct ionic_rx_filter *f;
-	int state;
-	int err;
-
-	spin_lock_bh(&lif->rx_filters.lock);
-	f = ionic_rx_filter_by_addr(lif, addr);
-	if (!f) {
-		spin_unlock_bh(&lif->rx_filters.lock);
-		return -ENOENT;
-	}
-
-	netdev_dbg(lif->netdev, "rx_filter del ADDR %pM (id %d)\n",
-		   addr, f->filter_id);
-
-	state = f->state;
-	ctx.cmd.rx_filter_del.filter_id = cpu_to_le32(f->filter_id);
-	ionic_rx_filter_free(lif, f);
-
-	if (is_multicast_ether_addr(addr) && lif->nmcast)
-		lif->nmcast--;
-	else if (!is_multicast_ether_addr(addr) && lif->nucast)
-		lif->nucast--;
-
-	spin_unlock_bh(&lif->rx_filters.lock);
-
-	if (state != IONIC_FILTER_STATE_NEW) {
-		err = ionic_adminq_post_wait(lif, &ctx);
-		if (err && err != -EEXIST)
-			return err;
-	}
-
-	return 0;
-}
-
 static int ionic_addr_add(struct net_device *netdev, const u8 *addr)
 {
 	return ionic_lif_list_addr(netdev_priv(netdev), addr, ADD_ADDR);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
index 69728f9013cb..19115d966693 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
@@ -286,6 +286,137 @@ int ionic_lif_list_addr(struct ionic_lif *lif, const u8 *addr, bool mode)
 	return 0;
 }
 
+int ionic_lif_addr_add(struct ionic_lif *lif, const u8 *addr)
+{
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.rx_filter_add = {
+			.opcode = IONIC_CMD_RX_FILTER_ADD,
+			.lif_index = cpu_to_le16(lif->index),
+			.match = cpu_to_le16(IONIC_RX_FILTER_MATCH_MAC),
+		},
+	};
+	int nfilters = le32_to_cpu(lif->identity->eth.max_ucast_filters);
+	bool mc = is_multicast_ether_addr(addr);
+	struct ionic_rx_filter *f;
+	int err = 0;
+
+	memcpy(ctx.cmd.rx_filter_add.mac.addr, addr, ETH_ALEN);
+
+	spin_lock_bh(&lif->rx_filters.lock);
+	f = ionic_rx_filter_by_addr(lif, addr);
+	if (f) {
+		/* don't bother if we already have it and it is sync'd */
+		if (f->state == IONIC_FILTER_STATE_SYNCED) {
+			spin_unlock_bh(&lif->rx_filters.lock);
+			return 0;
+		}
+
+		/* mark preemptively as sync'd to block any parallel attempts */
+		f->state = IONIC_FILTER_STATE_SYNCED;
+	} else {
+		/* save as SYNCED to catch any DEL requests while processing */
+		err = ionic_rx_filter_save(lif, 0, IONIC_RXQ_INDEX_ANY, 0, &ctx,
+					   IONIC_FILTER_STATE_SYNCED);
+	}
+	spin_unlock_bh(&lif->rx_filters.lock);
+	if (err)
+		return err;
+
+	netdev_dbg(lif->netdev, "rx_filter add ADDR %pM\n", addr);
+
+	/* Don't bother with the write to FW if we know there's no room,
+	 * we can try again on the next sync attempt.
+	 */
+	if ((lif->nucast + lif->nmcast) >= nfilters)
+		err = -ENOSPC;
+	else
+		err = ionic_adminq_post_wait(lif, &ctx);
+
+	spin_lock_bh(&lif->rx_filters.lock);
+	if (err && err != -EEXIST) {
+		/* set the state back to NEW so we can try again later */
+		f = ionic_rx_filter_by_addr(lif, addr);
+		if (f && f->state == IONIC_FILTER_STATE_SYNCED) {
+			f->state = IONIC_FILTER_STATE_NEW;
+			set_bit(IONIC_LIF_F_FILTER_SYNC_NEEDED, lif->state);
+		}
+
+		spin_unlock_bh(&lif->rx_filters.lock);
+
+		if (err == -ENOSPC)
+			return 0;
+		else
+			return err;
+	}
+
+	if (mc)
+		lif->nmcast++;
+	else
+		lif->nucast++;
+
+	f = ionic_rx_filter_by_addr(lif, addr);
+	if (f && f->state == IONIC_FILTER_STATE_OLD) {
+		/* Someone requested a delete while we were adding
+		 * so update the filter info with the results from the add
+		 * and the data will be there for the delete on the next
+		 * sync cycle.
+		 */
+		err = ionic_rx_filter_save(lif, 0, IONIC_RXQ_INDEX_ANY, 0, &ctx,
+					   IONIC_FILTER_STATE_OLD);
+	} else {
+		err = ionic_rx_filter_save(lif, 0, IONIC_RXQ_INDEX_ANY, 0, &ctx,
+					   IONIC_FILTER_STATE_SYNCED);
+	}
+
+	spin_unlock_bh(&lif->rx_filters.lock);
+
+	return err;
+}
+
+int ionic_lif_addr_del(struct ionic_lif *lif, const u8 *addr)
+{
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.rx_filter_del = {
+			.opcode = IONIC_CMD_RX_FILTER_DEL,
+			.lif_index = cpu_to_le16(lif->index),
+		},
+	};
+	struct ionic_rx_filter *f;
+	int state;
+	int err;
+
+	spin_lock_bh(&lif->rx_filters.lock);
+	f = ionic_rx_filter_by_addr(lif, addr);
+	if (!f) {
+		spin_unlock_bh(&lif->rx_filters.lock);
+		return -ENOENT;
+	}
+
+	netdev_dbg(lif->netdev, "rx_filter del ADDR %pM (id %d)\n",
+		   addr, f->filter_id);
+
+	state = f->state;
+	ctx.cmd.rx_filter_del.filter_id = cpu_to_le32(f->filter_id);
+	ionic_rx_filter_free(lif, f);
+
+	if (is_multicast_ether_addr(addr) && lif->nmcast)
+		lif->nmcast--;
+	else if (!is_multicast_ether_addr(addr) && lif->nucast)
+		lif->nucast--;
+
+	spin_unlock_bh(&lif->rx_filters.lock);
+
+	if (state != IONIC_FILTER_STATE_NEW) {
+		err = ionic_adminq_post_wait(lif, &ctx);
+		if (err && err != -EEXIST)
+			return err;
+	}
+
+	return 0;
+}
+
 struct sync_item {
 	struct list_head list;
 	struct ionic_rx_filter f;
-- 
2.17.1

