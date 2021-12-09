Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6F646E1A7
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 05:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbhLIEsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 23:48:16 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:12188 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbhLIEsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 23:48:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=iHd/0RCXjKTxd8QykVdQ8eE0fAUunRy92vDapu3L2UI=;
        b=PVou7tpO6ziwvgFEhisz4H5HwQuKBdWNcveSI+DO2mhS4Z4+tHK2nmiTAozBf0DkYpFv
        B63j4bguA25IJyh+DXmozmPmdpEmgi2FeQtGNvMwLqhldeuX/ihTxNwOKFh1GRYQYfcS9c
        daPXBhM0ZP3H/cVsMYKnz1HNBaFZ5b/zA+fkwKvMB9+q54j51Gby93jcj2kOrAunEYDHUD
        f+qsCk0ysIGP3pJAjzQ2RUHEbVmZ/QxxEJvq4zH8p9HKiCP/GYNmRx2/LW8AQWus2m7+ZE
        HB+GuyQxNctfLSc4EaFrlk3c4ngW7xVHSDbkbGOrWUyQLQqocFFMQDwj2t0ggtZQ==
Received: by filterdrecv-7bc86b958d-jb29x with SMTP id filterdrecv-7bc86b958d-jb29x-1-61B189AE-2
        2021-12-09 04:44:30.260943231 +0000 UTC m=+8490286.153384126
Received: from pearl.egauge.net (unknown)
        by ismtpd0046p1las1.sendgrid.net (SG) with ESMTP
        id 3tBTAwxpQySG7nZd1a6wSQ
        Thu, 09 Dec 2021 04:44:30.074 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 901AA7002CB; Wed,  8 Dec 2021 21:44:29 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH 4/4] wilc1000: Rename workqueue from "WILC_wq" to "NETDEV-wq"
Date:   Thu, 09 Dec 2021 04:44:30 +0000 (UTC)
Message-Id: <20211209044411.3482259-5-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211209044411.3482259-1-davidm@egauge.net>
References: <20211209044411.3482259-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvJ72WeUfXsZj0NWYv?=
 =?us-ascii?Q?g3sVTEVN8mxHsYb55kisYzRTpJ7dNjzBIVALAra?=
 =?us-ascii?Q?PW2za18MOtTrVquRvGVSfDw8SEuoqqiml2jbSFR?=
 =?us-ascii?Q?xrx1LLiSE+VO3Mxdlhp7XRNHPNFyXTXTCZhLO2K?=
 =?us-ascii?Q?0kZz6fduK8+GGoY4tFS9dZ7=2F1iV=2FhaXvEXmvDR?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Mosberger-Tang <davidm@egauge.net>
X-Entity-ID: Xg4JGAcGrJFIz2kDG9eoaQ==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This follows normal Linux convention and is more useful since the new
name will make it apparent which network device the work-queue is for
(e.g., the name will be "wlan0-wq" for network device "wlan0").

hif_workqueue allocation has to move from
cfg80211.c:wilc_cfg80211_init() to netdev.c:wilc_netdev_ifc_init()
because the network device name is not known until after the netdev is
registered.  The move also makes sense because netdev.c is already
responsible for destroying the work queue when it is no longer needed.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 .../net/wireless/microchip/wilc1000/cfg80211.c    | 10 +---------
 drivers/net/wireless/microchip/wilc1000/netdev.c  | 15 +++++++++++++--
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/cfg80211.c b/drivers/net/wireless/microchip/wilc1000/cfg80211.c
index dc4bfe7be378..8d8378bafd9b 100644
--- a/drivers/net/wireless/microchip/wilc1000/cfg80211.c
+++ b/drivers/net/wireless/microchip/wilc1000/cfg80211.c
@@ -1737,23 +1737,15 @@ int wilc_cfg80211_init(struct wilc **wilc, struct device *dev, int io_type,
 	INIT_LIST_HEAD(&wl->rxq_head.list);
 	INIT_LIST_HEAD(&wl->vif_list);
 
-	wl->hif_workqueue = create_singlethread_workqueue("WILC_wq");
-	if (!wl->hif_workqueue) {
-		ret = -ENOMEM;
-		goto free_cfg;
-	}
 	vif = wilc_netdev_ifc_init(wl, "wlan%d", WILC_STATION_MODE,
 				   NL80211_IFTYPE_STATION, false);
 	if (IS_ERR(vif)) {
 		ret = PTR_ERR(vif);
-		goto free_hq;
+		goto free_cfg;
 	}
 
 	return 0;
 
-free_hq:
-	destroy_workqueue(wl->hif_workqueue);
-
 free_cfg:
 	wilc_wlan_cfg_deinit(wl);
 
diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.c b/drivers/net/wireless/microchip/wilc1000/netdev.c
index e3b7629b9410..19e36bf4f36c 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.c
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.c
@@ -962,8 +962,15 @@ struct wilc_vif *wilc_netdev_ifc_init(struct wilc *wl, const char *name,
 		ret = register_netdev(ndev);
 
 	if (ret) {
-		free_netdev(ndev);
-		return ERR_PTR(-EFAULT);
+		ret = -EFAULT;
+		goto error;
+	}
+
+	wl->hif_workqueue = alloc_ordered_workqueue("%s-wq", WQ_MEM_RECLAIM,
+						    ndev->name);
+	if (!wl->hif_workqueue) {
+		ret = -ENOMEM;
+		goto error;
 	}
 
 	ndev->needs_free_netdev = true;
@@ -977,6 +984,10 @@ struct wilc_vif *wilc_netdev_ifc_init(struct wilc *wl, const char *name,
 	synchronize_srcu(&wl->srcu);
 
 	return vif;
+
+  error:
+	free_netdev(ndev);
+	return ERR_PTR(ret);
 }
 
 MODULE_LICENSE("GPL");
-- 
2.25.1

