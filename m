Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A543A2A708E
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 23:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732318AbgKDWeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 17:34:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726777AbgKDWeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 17:34:09 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF41EC0613CF
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 14:34:08 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id 133so18519249pfx.11
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 14:34:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OCmgQu7BenHssMoseN6UpJ97h++GTY8j0hPVyIa/xQw=;
        b=uWAw1HiQkcf7TxfNY1eCWxS0MC3bRWNEd8O8XSkzNUn3R1pZNoSc7Qdk8dpCyDx9sd
         BHM/VDeFuGJDLIzqIhIZzuWiKSomS1z22oaHJ9nOHufLyEW2nqcwVgtE/9VM0grRd6m8
         2gfkx9ritLUimXcQCq6PvYos7QfREps3Gu9bece8HAX3Iy3smg7Odlssivua6+zygZe5
         wYXJARi98mL1bhLRrDzlPg8zNCisr3k1b39SboOcouOxOumwLj2+UhRgrrUy5XFH0Sg4
         jtO6zthlOXiD0ZEsy812BTrtZNBn86RyVtjg13KyBdtXx5mcymDsofjzKwiQbCwtse1u
         G5Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OCmgQu7BenHssMoseN6UpJ97h++GTY8j0hPVyIa/xQw=;
        b=BqKIkkWAbF0rteS+C6+CE6wMMfpGs/Jafa6AYNbFUTvHs9+TQo68sdrGWmKCJdkxIg
         8v6aQTG9uL/ro27oPoiP+NByWUIjjXxvntcmAt/27T+p3XFrxsm0IMT5a3/k1Ajup4x0
         xjM2VRj7jaJOZACTSj66n79CWyABYHgNhJd+/GI0IFAtsmQcMg33vlvhJf7k3uJSjhDS
         y+yHnWnOI0Tpui3gtGMQ6+W8bnWbr9LAhMXd0QY740rwbglrKn7CNrKDTDkv2kUhRjip
         1gkhLtO2km64jGxlh8hHDGM8S09mycp7ynriCvo7jhFl6E3481DSsRsTevyMygMRWY5y
         HGUA==
X-Gm-Message-State: AOAM532uSxGidENtfaSvLaEUy7YBNh6ifYtBr+7BdOpkJdxJJmSWPYEi
        KPzE9i/3RVdR8lNPOZSa2HabZPi9KlBQBw==
X-Google-Smtp-Source: ABdhPJxH9W+vYnFqGCVH9nmWOXoyHTeOhgmZ+9/pMB5R0p2MYASLlmgkl4grWe/gmj/WByvXXmLL5Q==
X-Received: by 2002:a62:64c1:0:b029:18a:d791:8162 with SMTP id y184-20020a6264c10000b029018ad7918162mr201285pfb.24.1604529248166;
        Wed, 04 Nov 2020 14:34:08 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id z10sm3284559pff.218.2020.11.04.14.34.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2020 14:34:07 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 5/6] ionic: use mc sync for multicast filters
Date:   Wed,  4 Nov 2020 14:33:53 -0800
Message-Id: <20201104223354.63856-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201104223354.63856-1-snelson@pensando.io>
References: <20201104223354.63856-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We should be using the multicast sync routines for the
multicast filters.

Fixes: 1800eee16676 ("net: ionic: Replace in_interrupt() usage.")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 28044240caf2..a58bb572b23b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1158,6 +1158,14 @@ static void ionic_dev_uc_sync(struct net_device *netdev, bool from_ndo)
 
 }
 
+static void ionic_dev_mc_sync(struct net_device *netdev, bool from_ndo)
+{
+	if (from_ndo)
+		__dev_mc_sync(netdev, ionic_ndo_addr_add, ionic_ndo_addr_del);
+	else
+		__dev_mc_sync(netdev, ionic_addr_add, ionic_addr_del);
+}
+
 static void ionic_set_rx_mode(struct net_device *netdev, bool from_ndo)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
@@ -1189,7 +1197,7 @@ static void ionic_set_rx_mode(struct net_device *netdev, bool from_ndo)
 	}
 
 	/* same for multicast */
-	ionic_dev_uc_sync(netdev, from_ndo);
+	ionic_dev_mc_sync(netdev, from_ndo);
 	nfilters = le32_to_cpu(lif->identity->eth.max_mcast_filters);
 	if (netdev_mc_count(netdev) > nfilters) {
 		rx_mode |= IONIC_RX_MODE_F_ALLMULTI;
-- 
2.17.1

