Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58955CD8B0
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 20:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfJFSpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 14:45:25 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:44583 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfJFSpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 14:45:24 -0400
Received: by mail-qt1-f195.google.com with SMTP id u40so16103977qth.11;
        Sun, 06 Oct 2019 11:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZMrZ1RubZY9dyZJ9Hkb1yPFx5en+hRm60DJ8k1k6vSg=;
        b=sd0OiqMr5oiSOqh/1GM2pf4ESTmHrrgBjeKXfjitHhBf4pj4o1OuSMBVRC5HXz4biP
         zYoMBWsEwqHoFTgM9OWX2stj+66/9YsuNlN3JWyv2hg+gAeVHAeLJSYOv3Pl6pb3pE/H
         e0as4YJnQibs1GDl722UdJKquZB5J0MsYYO3BRzjKWmGHjfHhzg4xkAtgB+zT/W7gS6T
         uKcPSJDB8/LXl9B9dkaEHsnNbesPURuqhm+/D/YluqQMCZyvzVyXXttxI9tUy54OebAo
         us2jxAGv8UCjJRRdFA2gsFEgqiVclT4nkp5G5e8h3zMyP3ZucuwK2bW2IT7cI1O3t0Gi
         hJVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZMrZ1RubZY9dyZJ9Hkb1yPFx5en+hRm60DJ8k1k6vSg=;
        b=Aq6x4t1j4QDKDdSu1MSwLXxRZwxJNMGaunOOlv8Y1dXANYxhPe9e/NjmRTU1AYi9d9
         6qEGZIid60NjUyV7pbRowGhAxKfL+WAJtXPa8sWJyNdzyiMejJv9/OZd7lP66PvzQlJD
         gEXyEfzfqCHYSI3wYE7SOo+p6qDvjUBdAsvQNZADKWGzwOSvTPeg1DihBgHNVIWiaLZD
         ka4rFSYnr/Y0WuQpFJtX9lvsr7rjRWKTl9iOg4ggSZm1DIXk7OEbUVyx8V6twXIoVqoC
         iKQ2/fU7LbYSYOPPhWYU3unlkC8BU+o7zHQXAbGsg9h4UTR/HSa13WyKzGpii4YcObt5
         XxCA==
X-Gm-Message-State: APjAAAUYNYsP5HLL5/Lc9S8Jxixb+odCo4RzVtcBbVm7cDo23ZVnRVFc
        3mnuuW/ChU+hRm/0OFd4fXs8nvAK
X-Google-Smtp-Source: APXvYqwBa99OxIXSIXW8z7fEMc8gNDcJmwc8glhoOkclr8oJJdigdpqpIWyeg2BA5rNH3vMjJLHjNg==
X-Received: by 2002:ac8:7019:: with SMTP id x25mr27196849qtm.133.1570387523264;
        Sun, 06 Oct 2019 11:45:23 -0700 (PDT)
Received: from localhost.localdomain ([2804:431:c7cb:21c2:d505:73c7:4df5:8eac])
        by smtp.gmail.com with ESMTPSA id l23sm11275578qta.53.2019.10.06.11.45.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Oct 2019 11:45:22 -0700 (PDT)
From:   jcfaracco@gmail.com
To:     netdev@vger.kernel.org
Cc:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, dnmendes76@gmail.com
Subject: [PATCH RFC net-next 1/2] drivers: net: virtio_net: Add tx_timeout stats field
Date:   Sun,  6 Oct 2019 15:45:14 -0300
Message-Id: <20191006184515.23048-2-jcfaracco@gmail.com>
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

For debug purpose of TX timeout events, a tx_timeout entry was added to
monitor this special case: when dev_watchdog identifies a tx_timeout and
throw an exception. We can both consider this event as an error, but
driver should report as a tx_timeout statistic.

Signed-off-by: Julio Faracco <jcfaracco@gmail.com>
Signed-off-by: Daiane Mendes <dnmendes76@gmail.com>
Cc: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 4f3de0ac8b0b..27f9b212c9f5 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -75,6 +75,7 @@ struct virtnet_sq_stats {
 	u64 xdp_tx;
 	u64 xdp_tx_drops;
 	u64 kicks;
+	u64 tx_timeouts;
 };
 
 struct virtnet_rq_stats {
@@ -98,6 +99,7 @@ static const struct virtnet_stat_desc virtnet_sq_stats_desc[] = {
 	{ "xdp_tx",		VIRTNET_SQ_STAT(xdp_tx) },
 	{ "xdp_tx_drops",	VIRTNET_SQ_STAT(xdp_tx_drops) },
 	{ "kicks",		VIRTNET_SQ_STAT(kicks) },
+	{ "tx_timeouts",	VIRTNET_SQ_STAT(tx_timeouts) },
 };
 
 static const struct virtnet_stat_desc virtnet_rq_stats_desc[] = {
@@ -1721,7 +1723,7 @@ static void virtnet_stats(struct net_device *dev,
 	int i;
 
 	for (i = 0; i < vi->max_queue_pairs; i++) {
-		u64 tpackets, tbytes, rpackets, rbytes, rdrops;
+		u64 tpackets, tbytes, terrors, rpackets, rbytes, rdrops;
 		struct receive_queue *rq = &vi->rq[i];
 		struct send_queue *sq = &vi->sq[i];
 
@@ -1729,6 +1731,7 @@ static void virtnet_stats(struct net_device *dev,
 			start = u64_stats_fetch_begin_irq(&sq->stats.syncp);
 			tpackets = sq->stats.packets;
 			tbytes   = sq->stats.bytes;
+			terrors  = sq->stats.tx_timeouts;
 		} while (u64_stats_fetch_retry_irq(&sq->stats.syncp, start));
 
 		do {
@@ -1743,6 +1746,7 @@ static void virtnet_stats(struct net_device *dev,
 		tot->rx_bytes   += rbytes;
 		tot->tx_bytes   += tbytes;
 		tot->rx_dropped += rdrops;
+		tot->tx_errors  += terrors;
 	}
 
 	tot->tx_dropped = dev->stats.tx_dropped;
-- 
2.21.0

