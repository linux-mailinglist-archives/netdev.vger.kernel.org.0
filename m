Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52389196350
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 04:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbgC1DO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 23:14:58 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:56122 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbgC1DO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 23:14:57 -0400
Received: by mail-pj1-f68.google.com with SMTP id mj6so4694341pjb.5
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 20:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=q3cXOsoIY9aiuZ7Q3iUyVb6hvRBLAcV0wpCQ6ZWH0ig=;
        b=eSDa244BhIwqj8g8xIw8qm6GfVPMTMk6olsY7guv2pPEy1AG55O5n1h6BnoxL7LtA9
         TAzwtksuSPH+vrRBCYlpS4fxAUnM14cF1UrimV27o9vHTbSLxCGOV/LQwFkk8Z/hP+Ti
         WySuUSIGhvgey5vOF7HZQk2G6g6eVXhsB9EJ3OwpV/e8cn6nvE8Wi4Rm2NMZgV1QFyev
         GDrywjxc7ga5pLo/57sTVdUgaXJLrkOCE96bFV8PxoVmAo4HgjDvS8IFtc+JxosZDmmU
         Q4eapro24BLrK2gMdoBAAn14zgU5VvO5c/Y26Uu/8wXJeDBImQ39Y1lQV4jVRk2bH0kZ
         ZDIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=q3cXOsoIY9aiuZ7Q3iUyVb6hvRBLAcV0wpCQ6ZWH0ig=;
        b=W9LJDf+Qt6cXGS3JjUW439mGsKkguaGmqB9iJuX0RrchsYoWpI2tGSYYeAveOZVCjs
         +OKKCDGjRZQvLRJJO2g5YcuBHs38R2fAw6I1qe9CXRgjzfozKNxJ5ahVVqLWUYpq1nf/
         OknRcbxwWpmeuQ2SRHMtaOtGURc47hXMB6racq0XMZN9WJ88qhG5wir71DnHMTWqk8+E
         1DZCl4D4p2X1EqdnMuB4TOXyMFapJnkyqr1OZyE4x9z1iAU4NVSlHTGFBaFiceYWi+zP
         3iTu9VIPOykMQ0RPTV6Yqu+iMWIsOCsHfqKCK/JOfNVG9QYm1AKcDnNTseFfrdz1piOq
         3ytQ==
X-Gm-Message-State: ANhLgQ0GDTPsy9unHpA6OZ3DHYnAJnL00PYA0OliDIsv4/4cmg6xD2zo
        Wg5GBvQ0eD3SFCTcNefTHjO56g==
X-Google-Smtp-Source: ADFU+vsW48vaAclRqBPxtsdPdxDiXEWflwPcPrMPRIsVFsL5Pi9EpfgNc/Ps4YmO7Z6q5+BQfTuJkg==
X-Received: by 2002:a17:90b:2352:: with SMTP id ms18mr2452747pjb.97.1585365295294;
        Fri, 27 Mar 2020 20:14:55 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id o65sm5208391pfg.187.2020.03.27.20.14.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 Mar 2020 20:14:54 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 1/8] ionic: decouple link message from netdev state
Date:   Fri, 27 Mar 2020 20:14:41 -0700
Message-Id: <20200328031448.50794-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200328031448.50794-1-snelson@pensando.io>
References: <20200328031448.50794-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rearrange the link_up/link_down messages so that we announce
link up when we first notice that the link is up when the
driver loads, and decouple the link_up/link_down messages from
the UP and DOWN netdev state.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 32 +++++++++++--------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 8b442eb010a2..3e9c0e9bcad2 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -73,31 +73,35 @@ static void ionic_link_status_check(struct ionic_lif *lif)
 	u16 link_status;
 	bool link_up;
 
+	if (lif->ionic->is_mgmt_nic)
+		return;
+
 	link_status = le16_to_cpu(lif->info->status.link_status);
 	link_up = link_status == IONIC_PORT_OPER_STATUS_UP;
 
-	/* filter out the no-change cases */
-	if (link_up == netif_carrier_ok(netdev))
-		goto link_out;
-
 	if (link_up) {
-		netdev_info(netdev, "Link up - %d Gbps\n",
-			    le32_to_cpu(lif->info->status.link_speed) / 1000);
+		if (!netif_carrier_ok(netdev)) {
+			u32 link_speed;
 
-		if (test_bit(IONIC_LIF_F_UP, lif->state)) {
-			netif_tx_wake_all_queues(lif->netdev);
+			ionic_port_identify(lif->ionic);
+			link_speed = le32_to_cpu(lif->info->status.link_speed);
+			netdev_info(netdev, "Link up - %d Gbps\n",
+				    link_speed / 1000);
 			netif_carrier_on(netdev);
 		}
+
+		if (test_bit(IONIC_LIF_F_UP, lif->state))
+			netif_tx_wake_all_queues(lif->netdev);
 	} else {
-		netdev_info(netdev, "Link down\n");
+		if (netif_carrier_ok(netdev)) {
+			netdev_info(netdev, "Link down\n");
+			netif_carrier_off(netdev);
+		}
 
-		/* carrier off first to avoid watchdog timeout */
-		netif_carrier_off(netdev);
 		if (test_bit(IONIC_LIF_F_UP, lif->state))
 			netif_tx_stop_all_queues(netdev);
 	}
 
-link_out:
 	clear_bit(IONIC_LIF_F_LINK_CHECK_REQUESTED, lif->state);
 }
 
@@ -1587,8 +1591,6 @@ int ionic_open(struct net_device *netdev)
 	struct ionic_lif *lif = netdev_priv(netdev);
 	int err;
 
-	netif_carrier_off(netdev);
-
 	err = ionic_txrx_alloc(lif);
 	if (err)
 		return err;
@@ -1936,6 +1938,8 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
 	ionic_ethtool_set_ops(netdev);
 
 	netdev->watchdog_timeo = 2 * HZ;
+	netif_carrier_off(netdev);
+
 	netdev->min_mtu = IONIC_MIN_MTU;
 	netdev->max_mtu = IONIC_MAX_MTU;
 
-- 
2.17.1

