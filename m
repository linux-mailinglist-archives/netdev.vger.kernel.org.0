Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97B873FF181
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 18:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346373AbhIBQfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 12:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242414AbhIBQfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 12:35:13 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2E50C061575
        for <netdev@vger.kernel.org>; Thu,  2 Sep 2021 09:34:14 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id f129so2551795pgc.1
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 09:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=rd0JI1KNkxFupgaAoOUSZYub8eQLw+ItUpUeKvUy2AE=;
        b=CECSXYz34IdyhPpX60QFrbwZCvPD8SJ/SA2bHezFu4XR0Dh4aeAxq9jqPaz+H9FflE
         BbHf39Och/zyr3/BFF+tqAcTf+YRw6XOd9XlGfmLEDQkf4HrElH4RkIfJ2eoRxD8SMlK
         zsPM87FQcVuBizHITWPz2Zw+bEROPzeIAjcqJGvsxumS/wLBf+70N7sM1C+U1ZCvntj+
         JkDDcOha5Ytrgop/I3zvP779rHdHXrS1fVRnjJuD0BFpwdsiSyzGHvh+sZlC60Rtikdm
         0qxRESJS5KfurqFvDsQL+Ke/UHa6jrIOZIr6yPnXU73lsKuHENfE0fs7Yf3+3y+AABuG
         pjlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=rd0JI1KNkxFupgaAoOUSZYub8eQLw+ItUpUeKvUy2AE=;
        b=OzrmCyoQGFpv6QMSdOp2HIRq6ulradH7E2t/xBcXqGw+Qa1OAIcwSkRGOimbzNfD4T
         yYyIGSK2RKmYg38VpkvreS0GE4R4TfrkbG1YMPgy8BkKFHI4kdyDszNX64Z3ModDcNBh
         /U1n6oCTD2uQUH5bW8zWg+PbfiJ9LhiyKy2gz3b60kgK6VLNajw0Gau8Vta03vLRDBD6
         ZnZm+9ljpFqIkFl1Z22UWMSIurYGzc+0FL0MRN5wkCwrnYPmsLqFWXxzdg+u7DTwimMa
         mMhSqkTOt9qL+qP/F35v3TS5hhWqflSpy6ItITBZFT/50g2qUYw1o8CMRWG7byrEIGR/
         gnaQ==
X-Gm-Message-State: AOAM533FjhSWaQ2Va//tXXxLbOeyAmIYUi96Yst3zdl1wqRxbD83OWwy
        qaOHlxEkXHRKTrtUVKU0xMTzig==
X-Google-Smtp-Source: ABdhPJxXSixNtqV8b79Cw3tVodPYrfleOlm2AlJN7uZQePLVNYPQ9VhHIwRhV1wrI7eeqTraEFSu0w==
X-Received: by 2002:a63:1618:: with SMTP id w24mr3988517pgl.146.1630600454284;
        Thu, 02 Sep 2021 09:34:14 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id i8sm2978698pfo.117.2021.09.02.09.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 09:34:13 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net] ionic: fix double use of queue-lock
Date:   Thu,  2 Sep 2021 09:34:07 -0700
Message-Id: <20210902163407.60523-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Deadlock seen in an instance where the hwstamp configuration
is changed while the driver is running:

[ 3988.736671]  schedule_preempt_disabled+0xe/0x10
[ 3988.736676]  __mutex_lock.isra.5+0x276/0x4e0
[ 3988.736683]  __mutex_lock_slowpath+0x13/0x20
[ 3988.736687]  ? __mutex_lock_slowpath+0x13/0x20
[ 3988.736692]  mutex_lock+0x2f/0x40
[ 3988.736711]  ionic_stop_queues_reconfig+0x16/0x40 [ionic]
[ 3988.736726]  ionic_reconfigure_queues+0x43e/0xc90 [ionic]
[ 3988.736738]  ionic_lif_config_hwstamp_rxq_all+0x85/0x90 [ionic]
[ 3988.736751]  ionic_lif_hwstamp_set_ts_config+0x29c/0x360 [ionic]
[ 3988.736763]  ionic_lif_hwstamp_set+0x76/0xf0 [ionic]
[ 3988.736776]  ionic_eth_ioctl+0x33/0x40 [ionic]
[ 3988.736781]  dev_ifsioc+0x12c/0x420
[ 3988.736785]  dev_ioctl+0x316/0x720

This can be demonstrated with "ptp4l -m -i <intf>"

To fix this, we pull the use of the queue_lock further up above the
callers of ionic_reconfigure_queues() and ionic_stop_queues_reconfig().

Fixes: 7ee99fc5ed2e ("ionic: pull hwstamp queue_lock up a level")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_ethtool.c |  5 +++++
 drivers/net/ethernet/pensando/ionic/ionic_lif.c     | 12 ++++++++----
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index e91b4874a57f..3de1a03839e2 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -582,7 +582,10 @@ static int ionic_set_ringparam(struct net_device *netdev,
 
 	qparam.ntxq_descs = ring->tx_pending;
 	qparam.nrxq_descs = ring->rx_pending;
+
+	mutex_lock(&lif->queue_lock);
 	err = ionic_reconfigure_queues(lif, &qparam);
+	mutex_unlock(&lif->queue_lock);
 	if (err)
 		netdev_info(netdev, "Ring reconfiguration failed, changes canceled: %d\n", err);
 
@@ -679,7 +682,9 @@ static int ionic_set_channels(struct net_device *netdev,
 		return 0;
 	}
 
+	mutex_lock(&lif->queue_lock);
 	err = ionic_reconfigure_queues(lif, &qparam);
+	mutex_unlock(&lif->queue_lock);
 	if (err)
 		netdev_info(netdev, "Queue reconfiguration failed, changes canceled: %d\n", err);
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 23c9e196a784..381966e8f557 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1715,7 +1715,6 @@ static int ionic_set_mac_address(struct net_device *netdev, void *sa)
 static void ionic_stop_queues_reconfig(struct ionic_lif *lif)
 {
 	/* Stop and clean the queues before reconfiguration */
-	mutex_lock(&lif->queue_lock);
 	netif_device_detach(lif->netdev);
 	ionic_stop_queues(lif);
 	ionic_txrx_deinit(lif);
@@ -1734,8 +1733,7 @@ static int ionic_start_queues_reconfig(struct ionic_lif *lif)
 	 * DOWN and UP to try to reset and clear the issue.
 	 */
 	err = ionic_txrx_init(lif);
-	mutex_unlock(&lif->queue_lock);
-	ionic_link_status_check_request(lif, CAN_SLEEP);
+	ionic_link_status_check_request(lif, CAN_NOT_SLEEP);
 	netif_device_attach(lif->netdev);
 
 	return err;
@@ -1765,9 +1763,13 @@ static int ionic_change_mtu(struct net_device *netdev, int new_mtu)
 		return 0;
 	}
 
+	mutex_lock(&lif->queue_lock);
 	ionic_stop_queues_reconfig(lif);
 	netdev->mtu = new_mtu;
-	return ionic_start_queues_reconfig(lif);
+	err = ionic_start_queues_reconfig(lif);
+	mutex_unlock(&lif->queue_lock);
+
+	return err;
 }
 
 static void ionic_tx_timeout_work(struct work_struct *ws)
@@ -1783,8 +1785,10 @@ static void ionic_tx_timeout_work(struct work_struct *ws)
 	if (!netif_running(lif->netdev))
 		return;
 
+	mutex_lock(&lif->queue_lock);
 	ionic_stop_queues_reconfig(lif);
 	ionic_start_queues_reconfig(lif);
+	mutex_unlock(&lif->queue_lock);
 }
 
 static void ionic_tx_timeout(struct net_device *netdev, unsigned int txqueue)
-- 
2.17.1

