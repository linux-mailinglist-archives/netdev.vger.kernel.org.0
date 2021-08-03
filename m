Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9492A3DEEB6
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 15:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235954AbhHCNFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 09:05:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:60106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235909AbhHCNFr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 09:05:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00EAC60FA0;
        Tue,  3 Aug 2021 13:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627995936;
        bh=/E40Y8jFSgY4NLV4RFGk9JQAcxFQfFEv8b1C1XDaMfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rj7TJatxeMNsNGeC6MKMTpBl2/yAPXmvid8ON6HCh9O3E0KpFH3Q+l1kl620MtBVo
         LE8FsqebSEK9IwIeOTgZAiDx0FGxmzKQbY6bh99VrWz4V9Eh79Y2laOUJnmZPNfpNa
         1UhuZBf06U8VFcmzEgIj3eEBtooPuoG3I+xOM/2iLWM/lEgczJj5VBgFtz6DYkN9Ny
         +Rr5fDaByB/WOMOvE4OeH7ep91PKR834ZvFQ/GWx1qc4itGBpUUu6BVohNQT9Jv940
         2JHT9r6skdFxGCsdvqM03VzeX6Yb8w95UB3VLtN56jNrFdLL31VPguBoriEI8wXu5L
         8fEH+RrzFJkfA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, simon.horman@corigine.com,
        alexanderduyck@fb.com, oss-drivers@corigine.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/2] net: add netif_set_real_num_queues() for device reconfig
Date:   Tue,  3 Aug 2021 06:05:26 -0700
Message-Id: <20210803130527.2411250-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803130527.2411250-1-kuba@kernel.org>
References: <20210803130527.2411250-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netif_set_real_num_rx_queues() and netif_set_real_num_tx_queues()
can fail which breaks drivers trying to implement reconfiguration
in a way that can't leave the device half-broken. In other words
those functions are incompatible with prepare/commit approach.

Luckily setting real number of queues can fail only if the number
is increased, meaning that if we order operations correctly we
can guarantee ending up with either new config (success), or
the old one (on error).

Provide a helper implementing such logic so that drivers don't
have to duplicate it.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/netdevice.h |  2 ++
 net/core/dev.c            | 44 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index cd136499ec59..1b4d4509d04b 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3916,6 +3916,8 @@ static inline int netif_set_real_num_rx_queues(struct net_device *dev,
 	return 0;
 }
 #endif
+int netif_set_real_num_queues(struct net_device *dev,
+			      unsigned int txq, unsigned int rxq);
 
 static inline struct netdev_rx_queue *
 __netif_get_rx_queue(struct net_device *dev, unsigned int rxq)
diff --git a/net/core/dev.c b/net/core/dev.c
index 4a1401008db9..360cb2f1b1e9 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2973,6 +2973,50 @@ int netif_set_real_num_rx_queues(struct net_device *dev, unsigned int rxq)
 EXPORT_SYMBOL(netif_set_real_num_rx_queues);
 #endif
 
+/**
+ *	netif_set_real_num_queues - set actual number of RX and TX queues used
+ *	@dev: Network device
+ *	@txq: Actual number of TX queues
+ *	@rxq: Actual number of RX queues
+ *
+ *	Set the real number of both TX and RX queues.
+ *	Does nothing if the number of queues is already correct.
+ */
+int netif_set_real_num_queues(struct net_device *dev,
+			      unsigned int txq, unsigned int rxq)
+{
+	unsigned int old_rxq = dev->real_num_rx_queues;
+	int err;
+
+	if (txq < 1 || txq > dev->num_tx_queues ||
+	    rxq < 1 || rxq > dev->num_rx_queues)
+		return -EINVAL;
+
+	/* Start from increases, so the error path only does decreases -
+	 * decreases can't fail.
+	 */
+	if (rxq > dev->real_num_rx_queues) {
+		err = netif_set_real_num_rx_queues(dev, rxq);
+		if (err)
+			return err;
+	}
+	if (txq > dev->real_num_tx_queues) {
+		err = netif_set_real_num_tx_queues(dev, txq);
+		if (err)
+			goto undo_rx;
+	}
+	if (rxq < dev->real_num_rx_queues)
+		WARN_ON(netif_set_real_num_rx_queues(dev, rxq));
+	if (txq < dev->real_num_tx_queues)
+		WARN_ON(netif_set_real_num_tx_queues(dev, txq));
+
+	return 0;
+undo_rx:
+	WARN_ON(netif_set_real_num_rx_queues(dev, old_rxq));
+	return err;
+}
+EXPORT_SYMBOL(netif_set_real_num_queues);
+
 /**
  * netif_get_num_default_rss_queues - default number of RSS queues
  *
-- 
2.31.1

