Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB78427CC3
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 20:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhJISrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 14:47:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbhJISrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 14:47:35 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1B30C061762
        for <netdev@vger.kernel.org>; Sat,  9 Oct 2021 11:45:38 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id t11so8331711plq.11
        for <netdev@vger.kernel.org>; Sat, 09 Oct 2021 11:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zqrdA9hmbN0YxI+DGUZ6MDC55gPnl4GEcET7fUQhqS4=;
        b=eAoQPoyNMcko6UG3y15Pj4c3DAEETUIwMmsqgk2FpfXbEcjxSoBHy51C4yTj1XaRPO
         l2W7QaOrXfl6AiuCx9/H8PbQm/WJqQb2nC++6Zwdv93G3KkKvVR6ryeKe7D5ri16Zyee
         GRy9dD2zsFe/RaP8kLfJ1xJJV+SmAAan2SMBX7lRIdWuB/ZwTohG9e1gf1sN6INIWD9b
         Za0XAyKeCfIU+vZ3nBJHU/8aIfrcBzqMlZTqxtcFP3crQ7yPLS8Vw07cHLPVrDcnedWq
         7c+eS1+jds8ieCjzF9j8hWtHuU1mUhGA83X0hjMXKGzV0khokLOSGrGiOElgxbeeBWNn
         ud9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zqrdA9hmbN0YxI+DGUZ6MDC55gPnl4GEcET7fUQhqS4=;
        b=M6fiw/E8FrfMo1xpBT3kmP3QWwkdhKTig6mqgIZ1FZs8T9CcqwQF6W/m8+8a58F8h+
         tVye8PRwQRg1lGLquWuyvUKEGvv5UF5FHg+eGuY2GE29eGdpf70TVEGwtPtydOTqg4zs
         3ErEh29xTZEz8ixmx2Z0fq3He949ideWqs6w1B3qMmO53vxmWWjSRRCbHQlEiH8Veax0
         X+4ZpysXArLVx7pwXraXwAPVJ1Y3ccZpTxqQV4WQqpkIY9fX8qvrpUIAhtCxTQP9cli6
         GrVkpZuYTht6cmKz+XnMS5hBeY/JGP1Sn4NqzUSWudm/wW3UFmMCxVEkJyCasljOLpCp
         BX0g==
X-Gm-Message-State: AOAM531yv80wmS09SksBq0ybraj+Ecz0HbgJvg8l3QpVaqQBOzy6qu7C
        2T/+39eitk6rRx0ccASn89aiYg==
X-Google-Smtp-Source: ABdhPJy38de5D7bJE0ReUbJEeKd+J0uRdPSVx/sR8mesXezuRR8+etxJK6D2u1fcNGW4DhXJkqsvjA==
X-Received: by 2002:a17:90a:8c90:: with SMTP id b16mr18489553pjo.71.1633805138200;
        Sat, 09 Oct 2021 11:45:38 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id s30sm3368433pgo.39.2021.10.09.11.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 11:45:37 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 7/9] ionic: handle vlan id overflow
Date:   Sat,  9 Oct 2021 11:45:21 -0700
Message-Id: <20211009184523.73154-8-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211009184523.73154-1-snelson@pensando.io>
References: <20211009184523.73154-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add vlans to the existing rx_filter_sync mechanics currently
used for managing mac filters.

Older versions of our firmware had no enforced limits on the
number of vlans that the LIF could request, but requesting large
numbers of vlans caused issues in FW memory management, so an
arbitrary limit was added in the FW.  The FW now returns -ENOSPC
when it hits that limit, which the driver needs to handle.

Unfortunately, the FW doesn't advertise the vlan id limit,
as it does with mac filters, so the driver won't know the
limit until it bumps into it.  We'll grab the current vlan id
count and use that as the limit from there on and thus prevent
getting any more -ENOSPC errors.

Just as is done for the mac filters, the device puts the device
into promiscuous mode when -ENOSPC is seen for vlan ids, and
the driver will track the vlans that aren't synced to the FW.
When vlans are removed, the driver will retry the un-synced
vlans.  If all outstanding vlans are synced, the promiscuous
mode will be disabled.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 52 +++++--------------
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  2 +
 .../ethernet/pensando/ionic/ionic_rx_filter.c | 41 ++++++++++++++-
 .../ethernet/pensando/ionic/ionic_rx_filter.h |  2 +
 4 files changed, 56 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 4a080612142a..893a80e36632 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1273,7 +1273,7 @@ void ionic_lif_rx_mode(struct ionic_lif *lif)
 	rx_mode |= (nd_flags & IFF_PROMISC) ? IONIC_RX_MODE_F_PROMISC : 0;
 	rx_mode |= (nd_flags & IFF_ALLMULTI) ? IONIC_RX_MODE_F_ALLMULTI : 0;
 
-	/* sync the mac filters */
+	/* sync the filters */
 	ionic_rx_filter_sync(lif);
 
 	/* check for overflow state
@@ -1284,7 +1284,8 @@ void ionic_lif_rx_mode(struct ionic_lif *lif)
 	 */
 	nfilters = le32_to_cpu(lif->identity->eth.max_ucast_filters);
 
-	if ((lif->nucast + lif->nmcast) >= nfilters) {
+	if (((lif->nucast + lif->nmcast) >= nfilters) ||
+	    (lif->max_vlans && lif->nvlans >= lif->max_vlans)) {
 		rx_mode |= IONIC_RX_MODE_F_PROMISC;
 		rx_mode |= IONIC_RX_MODE_F_ALLMULTI;
 	} else {
@@ -1672,59 +1673,30 @@ static int ionic_vlan_rx_add_vid(struct net_device *netdev, __be16 proto,
 				 u16 vid)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
-	struct ionic_admin_ctx ctx = {
-		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
-		.cmd.rx_filter_add = {
-			.opcode = IONIC_CMD_RX_FILTER_ADD,
-			.lif_index = cpu_to_le16(lif->index),
-			.match = cpu_to_le16(IONIC_RX_FILTER_MATCH_VLAN),
-			.vlan.vlan = cpu_to_le16(vid),
-		},
-	};
 	int err;
 
-	netdev_dbg(netdev, "rx_filter add VLAN %d\n", vid);
-	err = ionic_adminq_post_wait(lif, &ctx);
+	err = ionic_lif_vlan_add(lif, vid);
 	if (err)
 		return err;
 
-	spin_lock_bh(&lif->rx_filters.lock);
-	err = ionic_rx_filter_save(lif, 0, IONIC_RXQ_INDEX_ANY, 0, &ctx,
-				   IONIC_FILTER_STATE_SYNCED);
-	spin_unlock_bh(&lif->rx_filters.lock);
+	ionic_lif_rx_mode(lif);
 
-	return err;
+	return 0;
 }
 
 static int ionic_vlan_rx_kill_vid(struct net_device *netdev, __be16 proto,
 				  u16 vid)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
-	struct ionic_admin_ctx ctx = {
-		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
-		.cmd.rx_filter_del = {
-			.opcode = IONIC_CMD_RX_FILTER_DEL,
-			.lif_index = cpu_to_le16(lif->index),
-		},
-	};
-	struct ionic_rx_filter *f;
-
-	spin_lock_bh(&lif->rx_filters.lock);
-
-	f = ionic_rx_filter_by_vlan(lif, vid);
-	if (!f) {
-		spin_unlock_bh(&lif->rx_filters.lock);
-		return -ENOENT;
-	}
+	int err;
 
-	netdev_dbg(netdev, "rx_filter del VLAN %d (id %d)\n",
-		   vid, f->filter_id);
+	err = ionic_lif_vlan_del(lif, vid);
+	if (err)
+		return err;
 
-	ctx.cmd.rx_filter_del.filter_id = cpu_to_le32(f->filter_id);
-	ionic_rx_filter_free(lif, f);
-	spin_unlock_bh(&lif->rx_filters.lock);
+	ionic_lif_rx_mode(lif);
 
-	return ionic_adminq_post_wait(lif, &ctx);
+	return 0;
 }
 
 int ionic_lif_rss_config(struct ionic_lif *lif, const u16 types,
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 541aa54e4ffd..9f7ab2f17f93 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -192,6 +192,8 @@ struct ionic_lif {
 	u16 lif_type;
 	unsigned int nmcast;
 	unsigned int nucast;
+	unsigned int nvlans;
+	unsigned int max_vlans;
 	char name[IONIC_LIF_NAME_MAX_SZ];
 
 	union ionic_lif_identity *identity;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
index 40a12b9df982..366f15794866 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
@@ -337,8 +337,16 @@ static int ionic_lif_filter_add(struct ionic_lif *lif,
 
 	/* Don't bother with the write to FW if we know there's no room,
 	 * we can try again on the next sync attempt.
+	 * Since the FW doesn't have a way to tell us the vlan limit,
+	 * we start max_vlans at 0 until we hit the ENOSPC error.
 	 */
 	switch (le16_to_cpu(ctx.cmd.rx_filter_add.match)) {
+	case IONIC_RX_FILTER_MATCH_VLAN:
+		netdev_dbg(lif->netdev, "%s: rx_filter add VLAN %d\n",
+			   __func__, ctx.cmd.rx_filter_add.vlan.vlan);
+		if (lif->max_vlans && lif->nvlans >= lif->max_vlans)
+			err = -ENOSPC;
+		break;
 	case IONIC_RX_FILTER_MATCH_MAC:
 		netdev_dbg(lif->netdev, "%s: rx_filter add ADDR %pM\n",
 			   __func__, ctx.cmd.rx_filter_add.mac.addr);
@@ -368,13 +376,19 @@ static int ionic_lif_filter_add(struct ionic_lif *lif,
 
 		spin_unlock_bh(&lif->rx_filters.lock);
 
-		if (err == -ENOSPC)
+		if (err == -ENOSPC) {
+			if (le16_to_cpu(ctx.cmd.rx_filter_add.match) == IONIC_RX_FILTER_MATCH_VLAN)
+				lif->max_vlans = lif->nvlans;
 			return 0;
+		}
 
 		return err;
 	}
 
 	switch (le16_to_cpu(ctx.cmd.rx_filter_add.match)) {
+	case IONIC_RX_FILTER_MATCH_VLAN:
+		lif->nvlans++;
+		break;
 	case IONIC_RX_FILTER_MATCH_MAC:
 		if (is_multicast_ether_addr(ctx.cmd.rx_filter_add.mac.addr))
 			lif->nmcast++;
@@ -413,6 +427,16 @@ int ionic_lif_addr_add(struct ionic_lif *lif, const u8 *addr)
 	return ionic_lif_filter_add(lif, &ac);
 }
 
+int ionic_lif_vlan_add(struct ionic_lif *lif, const u16 vid)
+{
+	struct ionic_rx_filter_add_cmd ac = {
+		.match = cpu_to_le16(IONIC_RX_FILTER_MATCH_VLAN),
+		.vlan.vlan = cpu_to_le16(vid),
+	};
+
+	return ionic_lif_filter_add(lif, &ac);
+}
+
 static int ionic_lif_filter_del(struct ionic_lif *lif,
 				struct ionic_rx_filter_add_cmd *ac)
 {
@@ -435,6 +459,11 @@ static int ionic_lif_filter_del(struct ionic_lif *lif,
 	}
 
 	switch (le16_to_cpu(ac->match)) {
+	case IONIC_RX_FILTER_MATCH_VLAN:
+		netdev_dbg(lif->netdev, "%s: rx_filter del VLAN %d id %d\n",
+			   __func__, ac->vlan.vlan, f->filter_id);
+		lif->nvlans--;
+		break;
 	case IONIC_RX_FILTER_MATCH_MAC:
 		netdev_dbg(lif->netdev, "%s: rx_filter del ADDR %pM id %d\n",
 			   __func__, ac->mac.addr, f->filter_id);
@@ -471,6 +500,16 @@ int ionic_lif_addr_del(struct ionic_lif *lif, const u8 *addr)
 	return ionic_lif_filter_del(lif, &ac);
 }
 
+int ionic_lif_vlan_del(struct ionic_lif *lif, const u16 vid)
+{
+	struct ionic_rx_filter_add_cmd ac = {
+		.match = cpu_to_le16(IONIC_RX_FILTER_MATCH_VLAN),
+		.vlan.vlan = cpu_to_le16(vid),
+	};
+
+	return ionic_lif_filter_del(lif, &ac);
+}
+
 struct sync_item {
 	struct list_head list;
 	struct ionic_rx_filter f;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.h b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.h
index a66e35f0833b..87b2666f248b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.h
@@ -44,5 +44,7 @@ struct ionic_rx_filter *ionic_rx_filter_rxsteer(struct ionic_lif *lif);
 void ionic_rx_filter_sync(struct ionic_lif *lif);
 int ionic_lif_list_addr(struct ionic_lif *lif, const u8 *addr, bool mode);
 int ionic_rx_filters_need_sync(struct ionic_lif *lif);
+int ionic_lif_vlan_add(struct ionic_lif *lif, const u16 vid);
+int ionic_lif_vlan_del(struct ionic_lif *lif, const u16 vid);
 
 #endif /* _IONIC_RX_FILTER_H_ */
-- 
2.17.1

