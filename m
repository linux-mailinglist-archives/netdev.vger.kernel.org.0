Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2985CD8B3
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 20:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbfJFSp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 14:45:29 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36366 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfJFSp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 14:45:27 -0400
Received: by mail-qt1-f193.google.com with SMTP id o12so16171767qtf.3;
        Sun, 06 Oct 2019 11:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4+0D96UNcW16NmIZzh7KLXswmY9Zu6wl9T6ptTV3qho=;
        b=LIipmTrSU2Fe7zrquUlZt36LofVfmw3+efcqrExFJHFJhnuGug1fg54yhAKr7GI67j
         oHtpp0/ZG1zdhEP4F/1qVBRiCqmBHkuM6EALQP0f8gkp8nzvn+uwVoYV7ofke98Bskod
         qTiaaaKA+fynSBP/Hq+zdbb3hKP3koKjW2nv+bqjCYeBhox4ahHMelYD87/YJnoUoTMP
         0ySAtNVExLQ8bEP+EKJGNm1TPOE6DmuYCO5z530P4LbtzdY1flCarykY7hvancmGb0I1
         JHsaMpbHBWVJjLmot+yNSGZp5Qb6INnVlzBvlAvTqxpdMMl8fOWLnz9pCa6UP47EeTlX
         BC1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4+0D96UNcW16NmIZzh7KLXswmY9Zu6wl9T6ptTV3qho=;
        b=PzWWpNbYIx1ALAWebDpcqrf6rAHUPLj4kkFO359TDHN39DjpBZnT3eaZYXTtp2AZ6m
         xvXc4R8O6fizVdfJa4gIQCrlqEdoCrKTe25C9oFQQVbXElEnJjIY2gotfuElEASVflpk
         V6gtWbLy9wybikNj1P1773DMrq+NdTiIrObJNrmWS7tiCUynAvM1vHEb844W5+xayKLA
         Epk3IE7LVOTCbUot2qpmnRvlMn/f4x7U7WXFrJ9k7H+7/CAnC8bN2aaWAzllLvX26y6/
         YNE0yy3dgoS1ULSo0TW/Mig+MeWd4fqy7GXxAHMt8JfTKdoEQzeNcy0WmCS0Bt4RlH3q
         0WqA==
X-Gm-Message-State: APjAAAX5Ci77A5c/ipmbZeBFpAfPhOr2RMFM53cUhLAxrYgU7MJqTZfX
        au6AB4k6FlzYpX4X3VbEMIABpSeE
X-Google-Smtp-Source: APXvYqwyYoGFKHQ3ZpcvefRTboKWPKKGWbn+30cPAqkuyZJeDXn9fIj71SEwzOe/jCe7kt2p5MMoHQ==
X-Received: by 2002:a0c:add6:: with SMTP id x22mr24177091qvc.203.1570387525924;
        Sun, 06 Oct 2019 11:45:25 -0700 (PDT)
Received: from localhost.localdomain ([2804:431:c7cb:21c2:d505:73c7:4df5:8eac])
        by smtp.gmail.com with ESMTPSA id l23sm11275578qta.53.2019.10.06.11.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Oct 2019 11:45:25 -0700 (PDT)
From:   jcfaracco@gmail.com
To:     netdev@vger.kernel.org
Cc:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, dnmendes76@gmail.com
Subject: [PATCH RFC net-next 2/2] drivers: net: virtio_net: Add tx_timeout function
Date:   Sun,  6 Oct 2019 15:45:15 -0300
Message-Id: <20191006184515.23048-3-jcfaracco@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191006184515.23048-1-jcfaracco@gmail.com>
References: <20191006184515.23048-1-jcfaracco@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julio Faracco <jcfaracco@gmail.com>

To enable dev_watchdog, virtio_net should have a tx_timeout defined 
(.ndo_tx_timeout). This is only a skeleton to throw a warn message. It 
notifies the event in some specific queue of device. This function 
still counts tx_timeout statistic and consider this event as an error 
(one error per queue), reporting it.

Signed-off-by: Julio Faracco <jcfaracco@gmail.com>
Signed-off-by: Daiane Mendes <dnmendes76@gmail.com>
Cc: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 27f9b212c9f5..4b703b4b9441 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2585,6 +2585,29 @@ static int virtnet_set_features(struct net_device *dev,
 	return 0;
 }
 
+static void virtnet_tx_timeout(struct net_device *dev)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+	u32 i;
+
+	/* find the stopped queue the same way dev_watchdog() does */
+	for (i = 0; i < vi->curr_queue_pairs; i++) {
+		struct send_queue *sq = &vi->sq[i];
+
+		if (!netif_xmit_stopped(netdev_get_tx_queue(dev, i)))
+			continue;
+
+		u64_stats_update_begin(&sq->stats.syncp);
+		sq->stats.tx_timeouts++;
+		u64_stats_update_end(&sq->stats.syncp);
+
+		netdev_warn(dev, "TX timeout on send queue: %d, sq: %s, vq: %d, name: %s\n",
+			    i, sq->name, sq->vq->index, sq->vq->name);
+
+		dev->stats.tx_errors++;
+	}
+}
+
 static const struct net_device_ops virtnet_netdev = {
 	.ndo_open            = virtnet_open,
 	.ndo_stop   	     = virtnet_close,
@@ -2600,6 +2623,7 @@ static const struct net_device_ops virtnet_netdev = {
 	.ndo_features_check	= passthru_features_check,
 	.ndo_get_phys_port_name	= virtnet_get_phys_port_name,
 	.ndo_set_features	= virtnet_set_features,
+	.ndo_tx_timeout		= virtnet_tx_timeout,
 };
 
 static void virtnet_config_changed_work(struct work_struct *work)
@@ -3018,6 +3042,9 @@ static int virtnet_probe(struct virtio_device *vdev)
 	dev->netdev_ops = &virtnet_netdev;
 	dev->features = NETIF_F_HIGHDMA;
 
+	/* Set up dev_watchdog cycle. */
+	dev->watchdog_timeo = 5 * HZ;
+
 	dev->ethtool_ops = &virtnet_ethtool_ops;
 	SET_NETDEV_DEV(dev, &vdev->dev);
 
-- 
2.21.0

