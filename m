Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0522427CC1
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 20:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbhJISrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 14:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbhJISre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 14:47:34 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B22AEC061570
        for <netdev@vger.kernel.org>; Sat,  9 Oct 2021 11:45:37 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id pi19-20020a17090b1e5300b0019fdd3557d3so10245310pjb.5
        for <netdev@vger.kernel.org>; Sat, 09 Oct 2021 11:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gxCLblM/mDLCEortX/fPp/MWAq33Rm2s4118QI/0bT8=;
        b=rCG/Q/w37GxJGz0jA9fYKo1URqvAiFAECZoagJN+YhufGGLDFohPLIrQyDy1XCfYF0
         4lC0u4d0ciTS3BkzrAx1vAH0y5wANa7kcTJl3B2eqnZD+r3iDxy3oCnmTSQWyipG/tpB
         WYjm9bsF2earzz6+B8/gsjSbjVg69iLcT0eJoKo0kxvUmRdIPWFB+oiH45hpZvO6dCGz
         joARErMnNd2PQj4qSNdvUzv1hWLZLI4u4aoD2M6wEWKiB5Ham3HzG2e2JRI/fBFoods5
         bU6zihBPs09BBpjIPjGEOjiv3eZfl2tTQjsq8QLwYr8Mcr5AZzqVPJBZMeyzBv4nVGej
         Ff4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gxCLblM/mDLCEortX/fPp/MWAq33Rm2s4118QI/0bT8=;
        b=ld7oJA5+Sgd2qvko5irJbL1MvKeUoZH9pbTNDUl/ZkBbwP2/MylC9lpE/Kn7EWeAcj
         izw5FcZ9Z6kiZNnoH9vwS723MfR8jxXBa+TnPgGhUlbRd66qpXfKNIBvuUQQd5vBz0C/
         QDoPfinmlHZthmpO3t7RC8yTP6QDBKmw7GIqQpgszzH6RuvQo/ldS6hZxEjm7zB2wCB4
         sxUdzYrAiRFNTmB1QfvCM+W5u6oGeMDhnd4Wn563ei7PDt8NqXYbLDczdc/SIbZonCJS
         pO1S/eOX6v5vlgw2dFL1GwRCkk6/cCekbXsc4ExXI+5RpWLyXLyqS8cQ5LQOSjOTXOhU
         6n2w==
X-Gm-Message-State: AOAM532c/LUegmfMAk41Mii3WUVOK8foVadXzGazkelfgB0HNjr0SjOb
        93fmxbb7hlnycNxSmjE8tw17vW5qVCMewA==
X-Google-Smtp-Source: ABdhPJy8gzDMr4faXKO7vFx72E9zOWgs/+2i+xTNk6ijVeE/5nNR1kXDa+JDeGEvRM1RqOoKEDMMPQ==
X-Received: by 2002:a17:90a:5889:: with SMTP id j9mr20155018pji.91.1633805137275;
        Sat, 09 Oct 2021 11:45:37 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id s30sm3368433pgo.39.2021.10.09.11.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 11:45:36 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 6/9] ionic: generic filter delete
Date:   Sat,  9 Oct 2021 11:45:20 -0700
Message-Id: <20211009184523.73154-7-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211009184523.73154-1-snelson@pensando.io>
References: <20211009184523.73154-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to the filter add, make a generic filter delete.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../ethernet/pensando/ionic/ionic_rx_filter.c | 35 +++++++++++++------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
index 10837e41f819..40a12b9df982 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
@@ -413,7 +413,8 @@ int ionic_lif_addr_add(struct ionic_lif *lif, const u8 *addr)
 	return ionic_lif_filter_add(lif, &ac);
 }
 
-int ionic_lif_addr_del(struct ionic_lif *lif, const u8 *addr)
+static int ionic_lif_filter_del(struct ionic_lif *lif,
+				struct ionic_rx_filter_add_cmd *ac)
 {
 	struct ionic_admin_ctx ctx = {
 		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
@@ -427,24 +428,27 @@ int ionic_lif_addr_del(struct ionic_lif *lif, const u8 *addr)
 	int err;
 
 	spin_lock_bh(&lif->rx_filters.lock);
-	f = ionic_rx_filter_by_addr(lif, addr);
+	f = ionic_rx_filter_find(lif, ac);
 	if (!f) {
 		spin_unlock_bh(&lif->rx_filters.lock);
 		return -ENOENT;
 	}
 
-	netdev_dbg(lif->netdev, "rx_filter del ADDR %pM (id %d)\n",
-		   addr, f->filter_id);
+	switch (le16_to_cpu(ac->match)) {
+	case IONIC_RX_FILTER_MATCH_MAC:
+		netdev_dbg(lif->netdev, "%s: rx_filter del ADDR %pM id %d\n",
+			   __func__, ac->mac.addr, f->filter_id);
+		if (is_multicast_ether_addr(ac->mac.addr) && lif->nmcast)
+			lif->nmcast--;
+		else if (!is_multicast_ether_addr(ac->mac.addr) && lif->nucast)
+			lif->nucast--;
+		break;
+	}
 
 	state = f->state;
 	ctx.cmd.rx_filter_del.filter_id = cpu_to_le32(f->filter_id);
 	ionic_rx_filter_free(lif, f);
 
-	if (is_multicast_ether_addr(addr) && lif->nmcast)
-		lif->nmcast--;
-	else if (!is_multicast_ether_addr(addr) && lif->nucast)
-		lif->nucast--;
-
 	spin_unlock_bh(&lif->rx_filters.lock);
 
 	if (state != IONIC_FILTER_STATE_NEW) {
@@ -456,6 +460,17 @@ int ionic_lif_addr_del(struct ionic_lif *lif, const u8 *addr)
 	return 0;
 }
 
+int ionic_lif_addr_del(struct ionic_lif *lif, const u8 *addr)
+{
+	struct ionic_rx_filter_add_cmd ac = {
+		.match = cpu_to_le16(IONIC_RX_FILTER_MATCH_MAC),
+	};
+
+	memcpy(&ac.mac.addr, addr, ETH_ALEN);
+
+	return ionic_lif_filter_del(lif, &ac);
+}
+
 struct sync_item {
 	struct list_head list;
 	struct ionic_rx_filter f;
@@ -510,7 +525,7 @@ void ionic_rx_filter_sync(struct ionic_lif *lif)
 	 * they can clear room for some new filters
 	 */
 	list_for_each_entry_safe(sync_item, spos, &sync_del_list, list) {
-		(void)ionic_lif_addr_del(lif, sync_item->f.cmd.mac.addr);
+		(void)ionic_lif_filter_del(lif, &sync_item->f.cmd);
 
 		list_del(&sync_item->list);
 		devm_kfree(dev, sync_item);
-- 
2.17.1

