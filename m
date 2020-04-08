Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 974631A2707
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 18:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729684AbgDHQT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 12:19:26 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40571 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728294AbgDHQT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 12:19:26 -0400
Received: by mail-pg1-f196.google.com with SMTP id c5so3532230pgi.7
        for <netdev@vger.kernel.org>; Wed, 08 Apr 2020 09:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WeJEtpgO4/t/2ysUfaYVIIRsRSLfmGetHSYYcz2hOlo=;
        b=XIoKRCLmRgyB2nzcfJTLyXUT2tYkI1qN+chnLNkOpG0v/vkNXMAkk+Umvib5WrGW23
         s6dBah+QQOM2tzce24VzfOqJ6BVsipqsuCcKYNqRToigvBK21yXY0u9sm9rT3XF8PrXf
         gjs7XoVniEA80frzlXZbrvhKWnsBi2KXOrKJXUx9/+oPEyrARwWv+9UEoqnBcJ0x4EI6
         ekcKTnFciat4zbnc65Ml99ynj6rSxKxMK8MCLu9Guq1Es1A7XJXtyz/d3lnXBZR6fSPs
         B6YG1RjDVP6vD7+ZrnOBxq4CSgRKg+5LJzjIblHVwH36opk2LLJ41G96YEy1wu6bfkhR
         uP1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WeJEtpgO4/t/2ysUfaYVIIRsRSLfmGetHSYYcz2hOlo=;
        b=UnXvd6U+EWbHrXvuM20r792w+2eXcK9AEqbZpd/A+F6T0BXv2DMnBDJFDbZBsbzZ4Y
         POiRlGIHwCTm0U6uVLukF019d20Yu0jprBKMwWcmUU3tAmVXvA8qwrYL3ubr8ZLnhTcj
         kHaVUMf2zSRDoejN1PscRHhrT1ovzzKtZoJ0MT6wsNeDuMbOjM/hFi4LTKZ0pCt7A5lA
         zbZ7olLW4AlCzUmUPKiM9yslEFRiHYVZjPiakJzAWQreqHkRYJmZ3S00uTcVQNuYaQuh
         uyJbiK2t25jGfCGZme7VVWwXlL+CbBBED3I6uLih0UmVbMZx9Xr9CSVKOd4A+ZMhnrFw
         EZuQ==
X-Gm-Message-State: AGi0Pub3CVUVs34MeJS3S3EO7/BJhyqGO56EE3fRdDbDGw6hJSfIUgQe
        FeOABHtGl6tnlAHWa8KquuRK4kJrp8k=
X-Google-Smtp-Source: APiQypJVgFxz9MiEeOlzyjPVPFjd5ZnxDOD1eHFbl6dkUQgo1JAQMS0o8Zzziy2cfHRGQpn37wReXA==
X-Received: by 2002:a63:3d04:: with SMTP id k4mr7749708pga.115.1586362764640;
        Wed, 08 Apr 2020 09:19:24 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id s12sm16021693pgi.38.2020.04.08.09.19.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Apr 2020 09:19:24 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 1/2] ionic: replay filters after fw upgrade
Date:   Wed,  8 Apr 2020 09:19:11 -0700
Message-Id: <20200408161912.17153-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200408161912.17153-1-snelson@pensando.io>
References: <20200408161912.17153-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The NIC's filters are lost in the midst of the fw-upgrade
so we need to replay them into the FW.  We also remove the
unused ionic_rx_filter_del() function.

Fixes: c672412f6172 ("ionic: remove lifs on fw reset")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 12 +++--
 .../ethernet/pensando/ionic/ionic_rx_filter.c | 52 +++++++++++++++----
 .../ethernet/pensando/ionic/ionic_rx_filter.h |  2 +-
 3 files changed, 51 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 4b8a76098ca3..f8f437aec027 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2127,6 +2127,8 @@ static void ionic_lif_handle_fw_up(struct ionic_lif *lif)
 	if (lif->registered)
 		ionic_lif_set_netdev_info(lif);
 
+	ionic_rx_filter_replay(lif);
+
 	if (netif_running(lif->netdev)) {
 		err = ionic_txrx_alloc(lif);
 		if (err)
@@ -2206,9 +2208,9 @@ static void ionic_lif_deinit(struct ionic_lif *lif)
 	if (!test_bit(IONIC_LIF_F_FW_RESET, lif->state)) {
 		cancel_work_sync(&lif->deferred.work);
 		cancel_work_sync(&lif->tx_timeout_work);
+		ionic_rx_filters_deinit(lif);
 	}
 
-	ionic_rx_filters_deinit(lif);
 	if (lif->netdev->features & NETIF_F_RXHASH)
 		ionic_lif_rss_deinit(lif);
 
@@ -2421,9 +2423,11 @@ static int ionic_lif_init(struct ionic_lif *lif)
 	if (err)
 		goto err_out_notifyq_deinit;
 
-	err = ionic_rx_filters_init(lif);
-	if (err)
-		goto err_out_notifyq_deinit;
+	if (!test_bit(IONIC_LIF_F_FW_RESET, lif->state)) {
+		err = ionic_rx_filters_init(lif);
+		if (err)
+			goto err_out_notifyq_deinit;
+	}
 
 	err = ionic_station_set(lif);
 	if (err)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
index 7a093f148ee5..f3c7dd1596ee 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
@@ -17,17 +17,49 @@ void ionic_rx_filter_free(struct ionic_lif *lif, struct ionic_rx_filter *f)
 	devm_kfree(dev, f);
 }
 
-int ionic_rx_filter_del(struct ionic_lif *lif, struct ionic_rx_filter *f)
+void ionic_rx_filter_replay(struct ionic_lif *lif)
 {
-	struct ionic_admin_ctx ctx = {
-		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
-		.cmd.rx_filter_del = {
-			.opcode = IONIC_CMD_RX_FILTER_DEL,
-			.filter_id = cpu_to_le32(f->filter_id),
-		},
-	};
-
-	return ionic_adminq_post_wait(lif, &ctx);
+	struct ionic_rx_filter_add_cmd *ac;
+	struct ionic_admin_ctx ctx;
+	struct ionic_rx_filter *f;
+	struct hlist_head *head;
+	struct hlist_node *tmp;
+	unsigned int i;
+	int err = 0;
+
+	ac = &ctx.cmd.rx_filter_add;
+
+	for (i = 0; i < IONIC_RX_FILTER_HLISTS; i++) {
+		head = &lif->rx_filters.by_id[i];
+		hlist_for_each_entry_safe(f, tmp, head, by_id) {
+			ctx.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work);
+			memcpy(ac, &f->cmd, sizeof(f->cmd));
+			dev_dbg(&lif->netdev->dev, "replay filter command:\n");
+			dynamic_hex_dump("cmd ", DUMP_PREFIX_OFFSET, 16, 1,
+					 &ctx.cmd, sizeof(ctx.cmd), true);
+
+			err = ionic_adminq_post_wait(lif, &ctx);
+			if (err) {
+				switch (le16_to_cpu(ac->match)) {
+				case IONIC_RX_FILTER_MATCH_VLAN:
+					netdev_info(lif->netdev, "Replay failed - %d: vlan %d\n",
+						    err,
+						    le16_to_cpu(ac->vlan.vlan));
+					break;
+				case IONIC_RX_FILTER_MATCH_MAC:
+					netdev_info(lif->netdev, "Replay failed - %d: mac %pM\n",
+						    err, ac->mac.addr);
+					break;
+				case IONIC_RX_FILTER_MATCH_MAC_VLAN:
+					netdev_info(lif->netdev, "Replay failed - %d: vlan %d mac %pM\n",
+						    err,
+						    le16_to_cpu(ac->vlan.vlan),
+						    ac->mac.addr);
+					break;
+				}
+			}
+		}
+	}
 }
 
 int ionic_rx_filters_init(struct ionic_lif *lif)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.h b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.h
index b6aec9c19918..cf8f4c0a961c 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.h
@@ -24,7 +24,7 @@ struct ionic_rx_filters {
 };
 
 void ionic_rx_filter_free(struct ionic_lif *lif, struct ionic_rx_filter *f);
-int ionic_rx_filter_del(struct ionic_lif *lif, struct ionic_rx_filter *f);
+void ionic_rx_filter_replay(struct ionic_lif *lif);
 int ionic_rx_filters_init(struct ionic_lif *lif);
 void ionic_rx_filters_deinit(struct ionic_lif *lif);
 int ionic_rx_filter_save(struct ionic_lif *lif, u32 flow_id, u16 rxq_index,
-- 
2.17.1

