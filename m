Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 031A92A8B2A
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 01:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732740AbgKFAMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 19:12:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732706AbgKFAMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 19:12:38 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34BD7C0613D2
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 16:12:38 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id 72so2669302pfv.7
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 16:12:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qmSzPynWQ2lf/qf6sQOjE82uEc89pldFlSfrmsF90B8=;
        b=l/yh2Ywdo1CMf1jQshawgOIlG5+faGJ7cHRkma72EVWFwKPc4noO/SUhb9/fyojyRx
         q3sQsTq9N3zH9iLE/nd20qd+saykGn5rIBHRNM985tKHehyLeXVSwwHw9dW5pW11n9+s
         Db7ILGaeBUvx32bBUkre+6P7A3TkH0ldt5oN5Xjcj/YlOYamthVMaruY/8LlSO3fVIEE
         7Vz2l8bg+Xbq/0S1PNQ44/tk0+xeYxOJxWpO65morHQm95eugGVA8/Pqk2iJHwHl/gNd
         9ShvxCiH31X5tnUneyogzI1eiGVO2Mv3DM8xSA0Tsj5uTvje9DjHrd4P53l7ItVdpiwT
         AGGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qmSzPynWQ2lf/qf6sQOjE82uEc89pldFlSfrmsF90B8=;
        b=m0K3Jjilp4TFSLbtBghLFnW0cnpu/BOWSEoFu7t62trrPfVaTg2IRy73JS7rmn5JxM
         tDW7BKwk1IoHQP4DaQ2vrG+gr4hkqZ2G69eGem4lDK/rNmUNyEYCYv9HynUdw+XTVEHv
         CJwTGFGNTuRLxC7XMxTV+jTagYJRcEtB4+yX5ZLs2Zi+2awnaXmyEd70E2O52hxf4CGY
         O7ktWmjG/757vmGOkhzhuHAoPC0oJE1QCvxQZIXiSmLHvrhmUo4WZL3CQdyt8l/M5eP4
         NRKCNuV+cdtHEA7KHM4WPnIEu3dAJ1skoKwyRrUWRDbNIA1ov+5Xv/zmh05f15Hb4rPm
         hjAQ==
X-Gm-Message-State: AOAM531W8JoqQOjKHzxTkMpGuHt0o97vhkXBnFubLownuZ6aX/XLWfgv
        7QQH3GPu1Xe7ZDFaOx2vMV99bpeKz79+YQ==
X-Google-Smtp-Source: ABdhPJyOH8TvsHHxlt3h90dASAUELZQGQMBC1q74WsgU9mkGyjAmIQmZVW9Zv+8INMkkIrSsC67JuQ==
X-Received: by 2002:a17:90a:7e0a:: with SMTP id i10mr4990923pjl.89.1604621557158;
        Thu, 05 Nov 2020 16:12:37 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 22sm3236009pjb.40.2020.11.05.16.12.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2020 16:12:35 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 5/8] ionic: use mc sync for multicast filters
Date:   Thu,  5 Nov 2020 16:12:17 -0800
Message-Id: <20201106001220.68130-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201106001220.68130-1-snelson@pensando.io>
References: <20201106001220.68130-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We should be using the multicast sync routines for the multicast
filters.  Also, let's just flatten the logic a bit and pull
the small unicast routine back into ionic_set_rx_mode().

Fixes: 1800eee16676 ("net: ionic: Replace in_interrupt() usage.")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 990bd9ce93c2..a0d26fe4cbc3 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1149,15 +1149,6 @@ static void _ionic_lif_rx_mode(struct ionic_lif *lif, unsigned int rx_mode,
 	}
 }
 
-static void ionic_dev_uc_sync(struct net_device *netdev, bool from_ndo)
-{
-	if (from_ndo)
-		__dev_uc_sync(netdev, ionic_ndo_addr_add, ionic_ndo_addr_del);
-	else
-		__dev_uc_sync(netdev, ionic_addr_add, ionic_addr_del);
-
-}
-
 static void ionic_set_rx_mode(struct net_device *netdev, bool from_ndo)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
@@ -1177,7 +1168,10 @@ static void ionic_set_rx_mode(struct net_device *netdev, bool from_ndo)
 	 *       we remove our overflow flag and check the netdev flags
 	 *       to see if we can disable NIC PROMISC
 	 */
-	ionic_dev_uc_sync(netdev, from_ndo);
+	if (from_ndo)
+		__dev_uc_sync(netdev, ionic_ndo_addr_add, ionic_ndo_addr_del);
+	else
+		__dev_uc_sync(netdev, ionic_addr_add, ionic_addr_del);
 	nfilters = le32_to_cpu(lif->identity->eth.max_ucast_filters);
 	if (netdev_uc_count(netdev) + 1 > nfilters) {
 		rx_mode |= IONIC_RX_MODE_F_PROMISC;
@@ -1189,7 +1183,10 @@ static void ionic_set_rx_mode(struct net_device *netdev, bool from_ndo)
 	}
 
 	/* same for multicast */
-	ionic_dev_uc_sync(netdev, from_ndo);
+	if (from_ndo)
+		__dev_mc_sync(netdev, ionic_ndo_addr_add, ionic_ndo_addr_del);
+	else
+		__dev_mc_sync(netdev, ionic_addr_add, ionic_addr_del);
 	nfilters = le32_to_cpu(lif->identity->eth.max_mcast_filters);
 	if (netdev_mc_count(netdev) > nfilters) {
 		rx_mode |= IONIC_RX_MODE_F_ALLMULTI;
-- 
2.17.1

