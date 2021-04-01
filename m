Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1208351F4D
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 21:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235564AbhDATFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 15:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236737AbhDATDX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 15:03:23 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1BCDC03D204
        for <netdev@vger.kernel.org>; Thu,  1 Apr 2021 10:56:29 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id h3so1977039pfr.12
        for <netdev@vger.kernel.org>; Thu, 01 Apr 2021 10:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1PcQBqZO/OuFJbPE1c9v76O0Mi9ax4xYZNgyDhATWB4=;
        b=0jZt5EzxW/Vxje/K8oKc2NpVSJX8DQ4eiPKqxRzE3qkS2RGgaN4bwUcq9jqT6ZuOmW
         U0jzK2jVDgvkHoxOSLVXyq3DtoNs8AjjUCPRZNfR1NF1yFMl3w5S05uV8g/O+6ioPY5g
         BrHPyjbC9FbhEJReZ9ymTnMAWohDrSNp+zSxxqKTkIgEhNNseEt5LTHGwYe+IgrawIdJ
         XHCWqnEGzfzsJoAshdmaKiRiKZW6JtQI22BX5XHAD0bk6lTeoRBwfJZuI/4iyV+JwWhB
         7zLsOT68+BBKlnD70WbXWQSvTy/6axGgGZbI9s1HbJ/oDLDz2acOTVHRKGhAX/eGluhF
         zmhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1PcQBqZO/OuFJbPE1c9v76O0Mi9ax4xYZNgyDhATWB4=;
        b=aeILX7NIaksPOdNZfdpD4k+tEFHD5+1grRm2st829fzWuC4pmGeI3r2Pte3J3NKq3T
         h3Zd6dau19FVGC4jjKoPV8JyZNaikYcHmLhvv2N0cpMup9v+GxXuecJ/TkBnhdgNWvR4
         CIvhJsScP7X962oO9Jmmwco9DayCm8llNu5H3BAkR9URRseakLHTacDfD4k/q4bJhwD7
         9WKb+ZQ3Y5yqBCVa7wnfGbEmO70PqwLx2HImNPM9lS74lOlQjL9mKJT0Uoi4T6vBfjeM
         2OBEmmb12n3ZaF1WLtQyPbpAle+osc3p2axOAHkb5TTASDkoyYQd52I5MiYRnqdv8ue9
         zkeA==
X-Gm-Message-State: AOAM531sOR9JFDQiejle8AqFhwZlyyqta5lEhPXYr0oh7C0KsKdbdIrf
        1mW5uQXnP8FztcaKsc6GwJwbTfCtPBUrCA==
X-Google-Smtp-Source: ABdhPJzFcCLm8TO6I4tWnECR+sQiL3aqa4Ra5OPHmMzf2Ch8RY+KXz3TdO0n0Io+8UBBMe9AWBCZhQ==
X-Received: by 2002:a63:1022:: with SMTP id f34mr8640174pgl.263.1617299789174;
        Thu, 01 Apr 2021 10:56:29 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id n5sm6195909pfq.44.2021.04.01.10.56.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 10:56:28 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>,
        Allen Hubbe <allenbh@pensando.io>
Subject: [PATCH net-next 07/12] ionic: add rx filtering for hw timestamp steering
Date:   Thu,  1 Apr 2021 10:56:05 -0700
Message-Id: <20210401175610.44431-8-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210401175610.44431-1-snelson@pensando.io>
References: <20210401175610.44431-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add handling of the new Rx packet classification filter type.
This simple bit of classification allows for steering packets
to a separate Rx queue for processing.

Signed-off-by: Allen Hubbe <allenbh@pensando.io>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../ethernet/pensando/ionic/ionic_rx_filter.c | 21 +++++++++++++++++++
 .../ethernet/pensando/ionic/ionic_rx_filter.h |  1 +
 2 files changed, 22 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
index cd0076fc3044..d71316d9ded2 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
@@ -140,6 +140,9 @@ int ionic_rx_filter_save(struct ionic_lif *lif, u32 flow_id, u16 rxq_index,
 	case IONIC_RX_FILTER_MATCH_MAC_VLAN:
 		key = le16_to_cpu(ac->mac_vlan.vlan);
 		break;
+	case IONIC_RX_FILTER_STEER_PKTCLASS:
+		key = 0;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -210,3 +213,21 @@ struct ionic_rx_filter *ionic_rx_filter_by_addr(struct ionic_lif *lif,
 
 	return NULL;
 }
+
+struct ionic_rx_filter *ionic_rx_filter_rxsteer(struct ionic_lif *lif)
+{
+	struct ionic_rx_filter *f;
+	struct hlist_head *head;
+	unsigned int key;
+
+	key = hash_32(0, IONIC_RX_FILTER_HASH_BITS);
+	head = &lif->rx_filters.by_hash[key];
+
+	hlist_for_each_entry(f, head, by_hash) {
+		if (le16_to_cpu(f->cmd.match) != IONIC_RX_FILTER_STEER_PKTCLASS)
+			continue;
+		return f;
+	}
+
+	return NULL;
+}
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.h b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.h
index cf8f4c0a961c..1ead48be3c83 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.h
@@ -31,5 +31,6 @@ int ionic_rx_filter_save(struct ionic_lif *lif, u32 flow_id, u16 rxq_index,
 			 u32 hash, struct ionic_admin_ctx *ctx);
 struct ionic_rx_filter *ionic_rx_filter_by_vlan(struct ionic_lif *lif, u16 vid);
 struct ionic_rx_filter *ionic_rx_filter_by_addr(struct ionic_lif *lif, const u8 *addr);
+struct ionic_rx_filter *ionic_rx_filter_rxsteer(struct ionic_lif *lif);
 
 #endif /* _IONIC_RX_FILTER_H_ */
-- 
2.17.1

