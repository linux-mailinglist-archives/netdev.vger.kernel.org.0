Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D924227295
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 01:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbgGTXAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 19:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726943AbgGTXAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 19:00:31 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F84C061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 16:00:31 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id e8so11030164pgc.5
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 16:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FJiUgln0zw/rCfHEe0RyLquX/AQ6TOr/ugaksSmKbDc=;
        b=y2cya/SX4AKV701Buf96Bx6YS+mQeTC+IUeooniSc4Tf9cG16uz4lwA72f3cEG3Yz+
         MrAV1mpPPcdrNohH6kdQ1w+iET4pwhW+C0coRcLHDS7vS2fplJd+lbKpn0D3SL1fIezK
         WGc0i2R5yGfHgE/797WOOnR4T3PTQAHLY+q/ztIeXwqxqQI/dgZj7vwGhZoKzeWDBDNf
         JBOddZVgqRaAP91WJ23p85WOz5J335A3/q7GSHy+emAEFzFTj5ibMnczluN1awbr0lzw
         peB0dsX1wG20x2NcqWA3w6HfxMoL8hLWkxi/DA3JRArW0lq5vSO85aIUctP+l2BTsnhe
         76ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FJiUgln0zw/rCfHEe0RyLquX/AQ6TOr/ugaksSmKbDc=;
        b=r5HgpWV8o2Z7E8KGBEGIZ6lVQodLWAzgnmtWiVXJagc+gLTP990mnE3ur6MjiC1UXY
         PVLedzSPaaytMGlvLXlaaULBjky7cXZ3U6XEhRsfOpO46Y4efzdunrxfKomUKPhKXzqL
         3SpKmZTuQc8g/v7xSIWSIbHN7cyatIXJe1PyEBfZ2cD73sNTYeEGN67S/rlbmFjzi7wX
         sQPNutkb+sWXqm0f/ievspS8q9b3oH209Uikn9/VML2q2dLV1gX+JqTOXBj1apv+p6qn
         mRAjG1uJoVxHPoR6l5oYbdaUz/clK2FFuC03GX66XMszHqPFQW1zcPo4XK95B/cEF+EB
         NSlw==
X-Gm-Message-State: AOAM530/QWhsJFHrTmP9r2OcuFmsiOuSH/9QvZMsM6++8yA9nsplIJ2U
        HddqPESTUTcPjOYRdgbNW9XDIawzfDU=
X-Google-Smtp-Source: ABdhPJxCsIsG53yxtnzQuQeCNqSua5eT01JyGnzen4ATR5mSLSK/6gKyMiTVpLEDjJOGJz8/CG4EwQ==
X-Received: by 2002:a62:ce88:: with SMTP id y130mr21905202pfg.37.1595286030384;
        Mon, 20 Jul 2020 16:00:30 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id n9sm606738pjo.53.2020.07.20.16.00.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Jul 2020 16:00:29 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 2/5] ionic: fix up filter locks and debug msgs
Date:   Mon, 20 Jul 2020 16:00:14 -0700
Message-Id: <20200720230017.20419-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200720230017.20419-1-snelson@pensando.io>
References: <20200720230017.20419-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add in a couple of forgotten spinlocks and fix up some of
the debug messages around filter management.

Fixes: c1e329ebec8d ("ionic: Add management of rx filters")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 17 +++++++----------
 .../ethernet/pensando/ionic/ionic_rx_filter.c   |  5 +++++
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index f49486b6d04d..41e86d6b76b6 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -863,8 +863,7 @@ static int ionic_lif_addr_add(struct ionic_lif *lif, const u8 *addr)
 	if (f)
 		return 0;
 
-	netdev_dbg(lif->netdev, "rx_filter add ADDR %pM (id %d)\n", addr,
-		   ctx.comp.rx_filter_add.filter_id);
+	netdev_dbg(lif->netdev, "rx_filter add ADDR %pM\n", addr);
 
 	memcpy(ctx.cmd.rx_filter_add.mac.addr, addr, ETH_ALEN);
 	err = ionic_adminq_post_wait(lif, &ctx);
@@ -893,6 +892,9 @@ static int ionic_lif_addr_del(struct ionic_lif *lif, const u8 *addr)
 		return -ENOENT;
 	}
 
+	netdev_dbg(lif->netdev, "rx_filter del ADDR %pM (id %d)\n",
+		   addr, f->filter_id);
+
 	ctx.cmd.rx_filter_del.filter_id = cpu_to_le32(f->filter_id);
 	ionic_rx_filter_free(lif, f);
 	spin_unlock_bh(&lif->rx_filters.lock);
@@ -901,9 +903,6 @@ static int ionic_lif_addr_del(struct ionic_lif *lif, const u8 *addr)
 	if (err && err != -EEXIST)
 		return err;
 
-	netdev_dbg(lif->netdev, "rx_filter del ADDR %pM (id %d)\n", addr,
-		   ctx.cmd.rx_filter_del.filter_id);
-
 	return 0;
 }
 
@@ -1351,13 +1350,11 @@ static int ionic_vlan_rx_add_vid(struct net_device *netdev, __be16 proto,
 	};
 	int err;
 
+	netdev_dbg(netdev, "rx_filter add VLAN %d\n", vid);
 	err = ionic_adminq_post_wait(lif, &ctx);
 	if (err)
 		return err;
 
-	netdev_dbg(netdev, "rx_filter add VLAN %d (id %d)\n", vid,
-		   ctx.comp.rx_filter_add.filter_id);
-
 	return ionic_rx_filter_save(lif, 0, IONIC_RXQ_INDEX_ANY, 0, &ctx);
 }
 
@@ -1382,8 +1379,8 @@ static int ionic_vlan_rx_kill_vid(struct net_device *netdev, __be16 proto,
 		return -ENOENT;
 	}
 
-	netdev_dbg(netdev, "rx_filter del VLAN %d (id %d)\n", vid,
-		   le32_to_cpu(ctx.cmd.rx_filter_del.filter_id));
+	netdev_dbg(netdev, "rx_filter del VLAN %d (id %d)\n",
+		   vid, f->filter_id);
 
 	ctx.cmd.rx_filter_del.filter_id = cpu_to_le32(f->filter_id);
 	ionic_rx_filter_free(lif, f);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
index 80eeb7696e01..fb9d828812bd 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
@@ -69,10 +69,12 @@ int ionic_rx_filters_init(struct ionic_lif *lif)
 
 	spin_lock_init(&lif->rx_filters.lock);
 
+	spin_lock_bh(&lif->rx_filters.lock);
 	for (i = 0; i < IONIC_RX_FILTER_HLISTS; i++) {
 		INIT_HLIST_HEAD(&lif->rx_filters.by_hash[i]);
 		INIT_HLIST_HEAD(&lif->rx_filters.by_id[i]);
 	}
+	spin_unlock_bh(&lif->rx_filters.lock);
 
 	return 0;
 }
@@ -84,11 +86,13 @@ void ionic_rx_filters_deinit(struct ionic_lif *lif)
 	struct hlist_node *tmp;
 	unsigned int i;
 
+	spin_lock_bh(&lif->rx_filters.lock);
 	for (i = 0; i < IONIC_RX_FILTER_HLISTS; i++) {
 		head = &lif->rx_filters.by_id[i];
 		hlist_for_each_entry_safe(f, tmp, head, by_id)
 			ionic_rx_filter_free(lif, f);
 	}
+	spin_unlock_bh(&lif->rx_filters.lock);
 }
 
 int ionic_rx_filter_save(struct ionic_lif *lif, u32 flow_id, u16 rxq_index,
@@ -124,6 +128,7 @@ int ionic_rx_filter_save(struct ionic_lif *lif, u32 flow_id, u16 rxq_index,
 	f->filter_id = le32_to_cpu(ctx->comp.rx_filter_add.filter_id);
 	f->rxq_index = rxq_index;
 	memcpy(&f->cmd, ac, sizeof(f->cmd));
+	netdev_dbg(lif->netdev, "rx_filter add filter_id %d\n", f->filter_id);
 
 	INIT_HLIST_NODE(&f->by_hash);
 	INIT_HLIST_NODE(&f->by_id);
-- 
2.17.1

