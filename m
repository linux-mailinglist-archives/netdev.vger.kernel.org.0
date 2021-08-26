Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 823CD3F7FD1
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 03:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236408AbhHZB0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 21:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235803AbhHZBZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 21:25:59 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8773C061757
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 18:25:12 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id w8so1568096pgf.5
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 18:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FVkBinBo+Kb3aZE+XR0l9FV3nudzIFyBRhYauYRYGvs=;
        b=oJRRiMm5L9ddM2HTEEVDTJC5f84BVtA+QgXw27v5GVd9KgF3euZJDEquIKeJy7uo63
         tRZCxBEB4q2gDC/eXljIZqLLVFCJHG3UeYc/NcB4GdcIdCpGRcgF+/4Hm4TkCv72ncxC
         7yh9G7CJNMu3YRHEWx/FzWupXoN233povCpClLz6aL6JlpC8Oy524UnJ6HRKFusBwwY7
         PSBpiLORT5rjbJM6XAwqf8Fep5VtMLLlocPyAWnYB7NzEdvDYXcm1pV6s975DQVshuYe
         c+mQWG3k9jq2BqkhUl4VmpyICjypNdZpNRJt7LiwDS0nnxvHZOL57P/OxTTq0j9RUCa3
         kFqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FVkBinBo+Kb3aZE+XR0l9FV3nudzIFyBRhYauYRYGvs=;
        b=KH8Vpf5mhL0dtjdAsWCO/pLAcOrDTA6uqj+5YEbR3mQMfytGj3r840wOFE14kG6Jzb
         L5Lbkz7aXcTSqjtsWSJ6asD6Zgt6zADj8XAkM4z9dUIw3HgDmnW22CXNxwgMZRU/kgvx
         EZWxHeMS4zTkI8RKkTbW6BsFt9bOjyE8sjaWuEPPTOFo5N0EJLKSrwxTY+Aedp9qH+RR
         RKXHYoMHb7NPXqx76u5naIao2Udai6cbo/lm/9q6OgGGlNok7xYEFE67JxboYWIJepCI
         y409HlrAbzMRxczgl8V9mfF8IYfaWxsKUy8HUPhbzhAtOTu6AtBCmyy1jNU6Spys41fA
         tNVg==
X-Gm-Message-State: AOAM531+NsGVQKvT0gWnRmykNHPMs0g5q6rOfK2VQwaAUPaoPdfGDN+7
        J12zARPFo403HRgEbR66qBcKLg==
X-Google-Smtp-Source: ABdhPJylr0q0Y6qqk4/yh5EwdajLGA0TVormQXFLeLVshIl9j3dhtNdUDbchhn/A1ykhU892j7QPDw==
X-Received: by 2002:a63:68a:: with SMTP id 132mr1044326pgg.154.1629941112341;
        Wed, 25 Aug 2021 18:25:12 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h13sm1113458pgh.93.2021.08.25.18.25.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 18:25:11 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 5/5] ionic: handle mac filter overflow
Date:   Wed, 25 Aug 2021 18:24:50 -0700
Message-Id: <20210826012451.54456-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210826012451.54456-1-snelson@pensando.io>
References: <20210826012451.54456-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure we go into PROMISC mode when we have too many
filters by specifically counting the filters that successfully
get saved to the firmware.

The device advertises max_ucast_filters and max_mcast_filters,
but really only has max_ucast_filters slots available for
uc and mc filters combined.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 40 ++++++++++++++-----
 1 file changed, 29 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index b248c2e97582..e494d6b909c7 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1256,6 +1256,8 @@ int ionic_lif_addr_add(struct ionic_lif *lif, const u8 *addr)
 			.match = cpu_to_le16(IONIC_RX_FILTER_MATCH_MAC),
 		},
 	};
+	int nfilters = le32_to_cpu(lif->identity->eth.max_ucast_filters);
+	bool mc = is_multicast_ether_addr(addr);
 	struct ionic_rx_filter *f;
 	int err = 0;
 
@@ -1282,7 +1284,13 @@ int ionic_lif_addr_add(struct ionic_lif *lif, const u8 *addr)
 
 	netdev_dbg(lif->netdev, "rx_filter add ADDR %pM\n", addr);
 
-	err = ionic_adminq_post_wait(lif, &ctx);
+	/* Don't bother with the write to FW if we know there's no room,
+	 * we can try again on the next sync attempt.
+	 */
+	if ((lif->nucast + lif->nmcast) >= nfilters)
+		err = -ENOSPC;
+	else
+		err = ionic_adminq_post_wait(lif, &ctx);
 
 	spin_lock_bh(&lif->rx_filters.lock);
 	if (err && err != -EEXIST) {
@@ -1292,9 +1300,18 @@ int ionic_lif_addr_add(struct ionic_lif *lif, const u8 *addr)
 			f->state = IONIC_FILTER_STATE_NEW;
 
 		spin_unlock_bh(&lif->rx_filters.lock);
-		return err;
+
+		if (err == -ENOSPC)
+			return 0;
+		else
+			return err;
 	}
 
+	if (mc)
+		lif->nmcast++;
+	else
+		lif->nucast++;
+
 	f = ionic_rx_filter_by_addr(lif, addr);
 	if (f && f->state == IONIC_FILTER_STATE_OLD) {
 		/* Someone requested a delete while we were adding
@@ -1340,6 +1357,12 @@ int ionic_lif_addr_del(struct ionic_lif *lif, const u8 *addr)
 	state = f->state;
 	ctx.cmd.rx_filter_del.filter_id = cpu_to_le32(f->filter_id);
 	ionic_rx_filter_free(lif, f);
+
+	if (is_multicast_ether_addr(addr) && lif->nmcast)
+		lif->nmcast--;
+	else if (!is_multicast_ether_addr(addr) && lif->nucast)
+		lif->nucast--;
+
 	spin_unlock_bh(&lif->rx_filters.lock);
 
 	if (state != IONIC_FILTER_STATE_NEW) {
@@ -1392,21 +1415,16 @@ void ionic_lif_rx_mode(struct ionic_lif *lif)
 	 *       to see if we can disable NIC PROMISC
 	 */
 	nfilters = le32_to_cpu(lif->identity->eth.max_ucast_filters);
-	if (netdev_uc_count(netdev) + 1 > nfilters) {
+	if ((lif->nucast + lif->nmcast) >= nfilters) {
 		rx_mode |= IONIC_RX_MODE_F_PROMISC;
+		rx_mode |= IONIC_RX_MODE_F_ALLMULTI;
 		lif->uc_overflow = true;
+		lif->mc_overflow = true;
 	} else if (lif->uc_overflow) {
 		lif->uc_overflow = false;
+		lif->mc_overflow = false;
 		if (!(nd_flags & IFF_PROMISC))
 			rx_mode &= ~IONIC_RX_MODE_F_PROMISC;
-	}
-
-	nfilters = le32_to_cpu(lif->identity->eth.max_mcast_filters);
-	if (netdev_mc_count(netdev) > nfilters) {
-		rx_mode |= IONIC_RX_MODE_F_ALLMULTI;
-		lif->mc_overflow = true;
-	} else if (lif->mc_overflow) {
-		lif->mc_overflow = false;
 		if (!(nd_flags & IFF_ALLMULTI))
 			rx_mode &= ~IONIC_RX_MODE_F_ALLMULTI;
 	}
-- 
2.17.1

