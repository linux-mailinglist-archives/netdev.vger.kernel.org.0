Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA9262287C1
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729362AbgGURqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729233AbgGURq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 13:46:29 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09399C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:46:29 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id k4so10567796pld.12
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2MeQw586Xvul3UPgOiH9C1DV0+f0Az+s6rymzSAlROs=;
        b=yEB0nPFkmzCjFwUn8TRp7H2wAloYT9fNfPSsBVpuHZJbBL919iXv+hsjpco6HPxM+y
         soLihtBzhc+vLidY2J67qe6lh6TvrGZ7KuW35y16EB9XmhsaS3YqdRpnq/QzZQrzBbLQ
         PoDoJxmtq/zembDeuhZEK/JWiMSOwmZtqFH9d4/ZKksZdhpBVX1WG/oPqbLt1QjHkj66
         kxAwAoXZ/qNLIO4INlzZ8YUCCJS3jmxUM++WF85tdamfWMoALEhR1oHE8DKeyVPWgCA4
         aT/uhDIR7WU8ab1Fd/4QO50sD43hEF56cedG9VNMicNPBaX1VXwk0c9y5z3kn8BC2REJ
         KjlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2MeQw586Xvul3UPgOiH9C1DV0+f0Az+s6rymzSAlROs=;
        b=FLBlKZ1sZsHBju2ckY1u/XJIxtNlqWw/U5QOF9RgoWGVSVPHq3dKwsQOHJWYw71M7m
         2nbZg7hGEYEHOMzSoxrrURUbWuN6RzfNOaBU2mzGeffPD8yHaB2KjunBggg7LZ9K9skE
         POL9zCN0vkQtYlZwovsXWcLjqZYOcqS3LJshy50x11zllo7ZsENEiPhMnKhmLmJRMjE0
         kXuq7w/1I3dMU3lavbEeY5qOsuLvOR9yTBdRn0PKBdep4cVIrJPPYXGo3pb9Nv670JJk
         6A1dhJc2Jsz0/Px4GCDFyGvKq/WTwMcq8/mCkTOnwS7okqVOW5Uq7TvaRDf/gRItSV0M
         GU2A==
X-Gm-Message-State: AOAM532Hxud2h27qN+viE8c3BRSOTS9XWM7capkGWKImJR5qRW4+DIga
        h8W8IFbeiwuTGB9bJiustHNvJ6W9Ljw=
X-Google-Smtp-Source: ABdhPJxMRg7nR6rPjR00Af7JM5iIuZ8xJRbJkFVvTdQteZyCuv0EIioPJRJo8cwXIPaq33GYGus6rw==
X-Received: by 2002:a17:902:a5c5:: with SMTP id t5mr23326582plq.47.1595353588209;
        Tue, 21 Jul 2020 10:46:28 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id c14sm4598712pgb.1.2020.07.21.10.46.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jul 2020 10:46:27 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net 2/6] ionic: add missing filter locking
Date:   Tue, 21 Jul 2020 10:46:15 -0700
Message-Id: <20200721174619.39860-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721174619.39860-1-snelson@pensando.io>
References: <20200721174619.39860-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For completeness, add a couple more uses of the Rx filter
list locks.

Fixes: c1e329ebec8d ("ionic: Add management of rx filters")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
index 80eeb7696e01..cc2a6977081a 100644
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
-- 
2.17.1

