Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C28122D33C
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 02:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgGYAXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 20:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726862AbgGYAXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 20:23:37 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 069ADC0619E4
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:23:36 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id z3so6133149pfn.12
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lOR9/zBAb01k7ZXVYP++slFKXOOwYGAqUV0OjsIrV38=;
        b=cu+zVerAdjgAgo48WX5BJrP/MVZ5vvFWW6wKlog6BH8DPbKmD55/NnbsPO+8eepVSc
         DZsNwy/W5dHW31FFz98EHQF5zgHGP6mxfCw4TOHJMYLzjnQoSM7F4zp4VihXLmKrkXn9
         RATPcbeyp9bzh/zdDWLvbMUHNDzY1AK57R6uA6YS7AruWW81DtGWy0EEd+Iw4scXVOnr
         aX7en+DBfLtN0O8/w53BaGKEAimueTO0OAMT/YXFb1ShdOfJhsaQUEPMJIg7Hjoijkqb
         kfqqq8fYjFP5TzNuLTsFZd8tk58VvX4fZRB2fj6yrhy6b8EX8gkovU5ox0ctZToWfI7w
         qtJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lOR9/zBAb01k7ZXVYP++slFKXOOwYGAqUV0OjsIrV38=;
        b=bETEz5Jp32xU5Sa5uVVXQE9+eJtW9F7U4ZWxxzJfoNxsXB8VYOVSf3OdeiA5G8jQC5
         QZIe0uh6KP2m7K8iSjjitNYZd76EFWMBJ1RADokqMINglUNWPLD4znf9GS8qQhF6Vowi
         73FBcuo69PlU9D7sJOVZVMzeB/LUFxOgJjZM69p21IGMJ/E1dP1NM4g+fKJAe0Xa0Bf8
         rXOO8yJMrhcqFsUUpmJVOd32c/g5QFRP//Ox/gEYdfLTrZr+8Uvw15mDDQVqHpeiXseP
         U6MxUMQQxDw428neG2Drnk0J5qlrnIYYK7DywZpkBK48LLpH8fuq6to1KyDkIOzOMkjR
         nEwQ==
X-Gm-Message-State: AOAM5339czo9xZf7Icxl0Ap+dMJAomFf0xpzP97ZW1HGmHEbFduAe6t/
        MWquVGcgrMy2xOlv/AbhGZaYfdfCDxg=
X-Google-Smtp-Source: ABdhPJzQ7dQvYOcAyCfvexeF45kML3DDPy81d3iaCIvLyGGxLlFyj595kfjJx5cV7561loCjdvSEKA==
X-Received: by 2002:a63:6dc1:: with SMTP id i184mr10602333pgc.345.1595636615319;
        Fri, 24 Jul 2020 17:23:35 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id lr1sm8400368pjb.27.2020.07.24.17.23.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Jul 2020 17:23:34 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 2/4] ionic: recover from ringsize change failure
Date:   Fri, 24 Jul 2020 17:23:24 -0700
Message-Id: <20200725002326.41407-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200725002326.41407-1-snelson@pensando.io>
References: <20200725002326.41407-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the ringsize change fails, try restoring the previous setting.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../ethernet/pensando/ionic/ionic_ethtool.c   | 23 ++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index e03ea9b18f95..b48f0e46584b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -480,6 +480,8 @@ static int ionic_set_ringparam(struct net_device *netdev,
 			       struct ethtool_ringparam *ring)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
+	int tx_start, rx_start;
+	int err;
 
 	if (ring->rx_mini_pending || ring->rx_jumbo_pending) {
 		netdev_info(netdev, "Changing jumbo or mini descriptors not supported\n");
@@ -497,7 +499,26 @@ static int ionic_set_ringparam(struct net_device *netdev,
 	    ring->rx_pending == lif->nrxq_descs)
 		return 0;
 
-	return ionic_reset_queues(lif, ionic_set_ringsize, ring);
+	tx_start = lif->ntxq_descs;
+	rx_start = lif->nrxq_descs;
+
+	err = ionic_reset_queues(lif, ionic_set_ringsize, ring);
+
+	if (err) {
+		int my_err;
+
+		netdev_warn(netdev, "Ringsize change failed, restoring ring sizes\n");
+		ring->tx_pending = tx_start;
+		ring->rx_pending = rx_start;
+		my_err = ionic_reset_queues(lif, ionic_set_ringsize, ring);
+
+		if (my_err) {
+			netdev_err(netdev, "Ringsize restore failed\n");
+			err = my_err;
+		}
+	}
+
+	return err;
 }
 
 static void ionic_get_channels(struct net_device *netdev,
-- 
2.17.1

