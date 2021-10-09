Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58682427CC0
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 20:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbhJISri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 14:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbhJISrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 14:47:33 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2FF6C061570
        for <netdev@vger.kernel.org>; Sat,  9 Oct 2021 11:45:36 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id a11so8415864plm.0
        for <netdev@vger.kernel.org>; Sat, 09 Oct 2021 11:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Y32UIRGWq/fDw9IngSgbVO50yJkl01SHF3LsQZzy4EA=;
        b=hlc6Qb4bxCK/hW6BTDfTdQPZyZmVbPieyWxZslt1447iVqCQkwRavbA2eHfGAb3mZW
         cNpaXAOq4jsU+B6zW19aAM83HU9kDWPscHwnOqWoBT6w4Y75twLCJ4B1VCdaq4QXvQgG
         xe0g3t18gBEyEHiXZpi9c5pLh2QRtqNMOsMpJvELI/tBbzPbYg5juFcsz1am0stAXuXd
         0835/kQPhcBj5gVBSIKxmXnv3K+CzCV8GANjMlxpg5cAnuP3R9oTiLA6fsU0AlI4o5tg
         slB6faowlFt0FZb3AMjXPJ2Qs4rgE9z0pfyprx9P22t+JbuDLkwFRZbMAstrY0RuKGKS
         utbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Y32UIRGWq/fDw9IngSgbVO50yJkl01SHF3LsQZzy4EA=;
        b=47yPhn3NKNBW9UAQeX34inCj+7Erx2mS6DVjIEKf58BGetdKVgyfHafnLvDlxsHqNE
         s1ZEBtNo2UxySA4BRgKVKTacwNSerIswXivb4iTiFBr/nC3FZa4/FQuATd3RfwCR7WTK
         J0fU80knyVmq6e0PjVVV4NEjTcq//C2csilNkI/z1gi3KAji6QbYD9dbMR2aFxMCujPg
         5mtxmjJ0yZNYhYaMPPhL60FMhmprjLdSw3Upr3C4h0qf38U2YnVon8gx3rhUf76tzQcS
         FRjx/iTIyyVnc8jctiiZ1gE2QjOJzkZna9QSdBGcl/RrB3VRTWNG0BN23VQ9RGauHkqp
         36gw==
X-Gm-Message-State: AOAM531yq8PhpIu3YchZa28WQ03Bxc5X+TnNQlgNOlPu/Wp2TE7/3r5l
        FCeICa8/03NkJA7JLKR2U3H6IA==
X-Google-Smtp-Source: ABdhPJxURjUN9vbUzuD/LxANPiCJ9SPofCm8Q1TsN66Y+xDjbpVzDUCpf1w7PfwKtmVGidsbvK0Opg==
X-Received: by 2002:a17:90a:1507:: with SMTP id l7mr19518371pja.141.1633805136275;
        Sat, 09 Oct 2021 11:45:36 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id s30sm3368433pgo.39.2021.10.09.11.45.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 11:45:35 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 5/9] ionic: generic filter add
Date:   Sat,  9 Oct 2021 11:45:19 -0700
Message-Id: <20211009184523.73154-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211009184523.73154-1-snelson@pensando.io>
References: <20211009184523.73154-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for adding vlan overflow management, rework
the ionic_lif_addr_add() function to something a little more
generic that can be used for other filter types.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../ethernet/pensando/ionic/ionic_rx_filter.c | 68 +++++++++++++------
 1 file changed, 46 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
index 38109244a722..10837e41f819 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
@@ -301,22 +301,19 @@ int ionic_lif_list_addr(struct ionic_lif *lif, const u8 *addr, bool mode)
 	return 0;
 }
 
-int ionic_lif_addr_add(struct ionic_lif *lif, const u8 *addr)
+static int ionic_lif_filter_add(struct ionic_lif *lif,
+				struct ionic_rx_filter_add_cmd *ac)
 {
 	struct ionic_admin_ctx ctx = {
 		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
-		.cmd.rx_filter_add = {
-			.opcode = IONIC_CMD_RX_FILTER_ADD,
-			.lif_index = cpu_to_le16(lif->index),
-			.match = cpu_to_le16(IONIC_RX_FILTER_MATCH_MAC),
-		},
 	};
-	int nfilters = le32_to_cpu(lif->identity->eth.max_ucast_filters);
-	bool mc = is_multicast_ether_addr(addr);
 	struct ionic_rx_filter *f;
+	int nfilters;
 	int err = 0;
 
-	memcpy(ctx.cmd.rx_filter_add.mac.addr, addr, ETH_ALEN);
+	ctx.cmd.rx_filter_add = *ac;
+	ctx.cmd.rx_filter_add.opcode = IONIC_CMD_RX_FILTER_ADD,
+	ctx.cmd.rx_filter_add.lif_index = cpu_to_le16(lif->index),
 
 	spin_lock_bh(&lif->rx_filters.lock);
 	f = ionic_rx_filter_find(lif, &ctx.cmd.rx_filter_add);
@@ -338,37 +335,53 @@ int ionic_lif_addr_add(struct ionic_lif *lif, const u8 *addr)
 	if (err)
 		return err;
 
-	netdev_dbg(lif->netdev, "rx_filter add ADDR %pM\n", addr);
-
 	/* Don't bother with the write to FW if we know there's no room,
 	 * we can try again on the next sync attempt.
 	 */
-	if ((lif->nucast + lif->nmcast) >= nfilters)
-		err = -ENOSPC;
-	else
+	switch (le16_to_cpu(ctx.cmd.rx_filter_add.match)) {
+	case IONIC_RX_FILTER_MATCH_MAC:
+		netdev_dbg(lif->netdev, "%s: rx_filter add ADDR %pM\n",
+			   __func__, ctx.cmd.rx_filter_add.mac.addr);
+		nfilters = le32_to_cpu(lif->identity->eth.max_ucast_filters);
+		if ((lif->nucast + lif->nmcast) >= nfilters)
+			err = -ENOSPC;
+		break;
+	}
+
+	if (err != -ENOSPC)
 		err = ionic_adminq_post_wait(lif, &ctx);
 
 	spin_lock_bh(&lif->rx_filters.lock);
+
 	if (err && err != -EEXIST) {
 		/* set the state back to NEW so we can try again later */
 		f = ionic_rx_filter_find(lif, &ctx.cmd.rx_filter_add);
 		if (f && f->state == IONIC_FILTER_STATE_SYNCED) {
 			f->state = IONIC_FILTER_STATE_NEW;
-			set_bit(IONIC_LIF_F_FILTER_SYNC_NEEDED, lif->state);
+
+			/* If -ENOSPC we won't waste time trying to sync again
+			 * until there is a delete that might make room
+			 */
+			if (err != -ENOSPC)
+				set_bit(IONIC_LIF_F_FILTER_SYNC_NEEDED, lif->state);
 		}
 
 		spin_unlock_bh(&lif->rx_filters.lock);
 
 		if (err == -ENOSPC)
 			return 0;
-		else
-			return err;
+
+		return err;
 	}
 
-	if (mc)
-		lif->nmcast++;
-	else
-		lif->nucast++;
+	switch (le16_to_cpu(ctx.cmd.rx_filter_add.match)) {
+	case IONIC_RX_FILTER_MATCH_MAC:
+		if (is_multicast_ether_addr(ctx.cmd.rx_filter_add.mac.addr))
+			lif->nmcast++;
+		else
+			lif->nucast++;
+		break;
+	}
 
 	f = ionic_rx_filter_find(lif, &ctx.cmd.rx_filter_add);
 	if (f && f->state == IONIC_FILTER_STATE_OLD) {
@@ -389,6 +402,17 @@ int ionic_lif_addr_add(struct ionic_lif *lif, const u8 *addr)
 	return err;
 }
 
+int ionic_lif_addr_add(struct ionic_lif *lif, const u8 *addr)
+{
+	struct ionic_rx_filter_add_cmd ac = {
+		.match = cpu_to_le16(IONIC_RX_FILTER_MATCH_MAC),
+	};
+
+	memcpy(&ac.mac.addr, addr, ETH_ALEN);
+
+	return ionic_lif_filter_add(lif, &ac);
+}
+
 int ionic_lif_addr_del(struct ionic_lif *lif, const u8 *addr)
 {
 	struct ionic_admin_ctx ctx = {
@@ -493,7 +517,7 @@ void ionic_rx_filter_sync(struct ionic_lif *lif)
 	}
 
 	list_for_each_entry_safe(sync_item, spos, &sync_add_list, list) {
-		(void)ionic_lif_addr_add(lif, sync_item->f.cmd.mac.addr);
+		(void)ionic_lif_filter_add(lif, &sync_item->f.cmd);
 
 		list_del(&sync_item->list);
 		devm_kfree(dev, sync_item);
-- 
2.17.1

