Return-Path: <netdev+bounces-1090-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 81C036FC245
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 11:05:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AEB711C20B05
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 09:05:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BD31883E;
	Tue,  9 May 2023 09:05:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8885220F7;
	Tue,  9 May 2023 09:05:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1BE1C433D2;
	Tue,  9 May 2023 09:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683623124;
	bh=QLYhntYxwt19zmngRGRxtr4Qs1Z1rP5xaER/eXm+Q0Q=;
	h=From:To:Cc:Subject:Date:From;
	b=lLzIsyGYCGIThiExYUH/ilqNmTWr3YAeOSjGty3/0pn1ko+yAqcshgJ7I00lyyXiw
	 N5ibkBbFV0NmJWyMbmTLWqub+B2Fr8x3p36nHdgHUUXzEHisYTz/RoWLL2VTcZM6le
	 uw1jr0zkDrVIx1IbCWqIh/hASSaSppISHXPzbqezI9f2A7ecrSOWpKuzvxznej2ejw
	 76Hfgoyl+r0kevrIqGihuKX5b/8bLc8RZc3obZUydNHJBoRwTZ0B5B5SqTJmFZKClP
	 /zDXFLonul1xY5vMmycPfnjiup4aIgXkKOM9M6tkz7jYdjRKhdZAh8tB6XsvTceKU/
	 SLXBB1I9cttng==
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: netdev@vger.kernel.org
Cc: lorenzo.bianconi@redhat.com,
	bpf@vger.kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	hawk@kernel.org,
	john.fastabend@gmail.com,
	linyunsheng@huawei.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	jbenc@redhat.com
Subject: [PATCH net-next] net: veth: make PAGE_POOL_STATS optional
Date: Tue,  9 May 2023 11:05:16 +0200
Message-Id: <c9e132c3f08c456ad0462342bb0a104f0f8c0b24.1683622992.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since veth is very likely to be enabled and there are some drivers
(e.g. mlx5) where CONFIG_PAGE_POOL_STATS is optional, make
CONFIG_PAGE_POOL_STATS optional for veth too in order to keep it
optional when required.

Suggested-by: Jiri Benc <jbenc@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/Kconfig |  1 -
 drivers/net/veth.c  | 24 +++++++++++++++++-------
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index d0a1ed216d15..368c6f5b327e 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -403,7 +403,6 @@ config TUN_VNET_CROSS_LE
 config VETH
 	tristate "Virtual ethernet pair device"
 	select PAGE_POOL
-	select PAGE_POOL_STATS
 	help
 	  This device is a local ethernet tunnel. Devices are created in pairs.
 	  When one end receives the packet it appears on its pair and vice
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 3ae496011640..614f3e3efab0 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -176,12 +176,27 @@ static int veth_get_sset_count(struct net_device *dev, int sset)
 	}
 }
 
+static void veth_get_page_pool_stats(struct net_device *dev, u64 *data)
+{
+#ifdef CONFIG_PAGE_POOL_STATS
+	struct veth_priv *priv = netdev_priv(dev);
+	struct page_pool_stats pp_stats = {};
+	int i;
+
+	for (i = 0; i < dev->real_num_rx_queues; i++) {
+		if (!priv->rq[i].page_pool)
+			continue;
+		page_pool_get_stats(priv->rq[i].page_pool, &pp_stats);
+	}
+	page_pool_ethtool_stats_get(data, &pp_stats);
+#endif /* CONFIG_PAGE_POOL_STATS */
+}
+
 static void veth_get_ethtool_stats(struct net_device *dev,
 		struct ethtool_stats *stats, u64 *data)
 {
 	struct veth_priv *rcv_priv, *priv = netdev_priv(dev);
 	struct net_device *peer = rtnl_dereference(priv->peer);
-	struct page_pool_stats pp_stats = {};
 	int i, j, idx, pp_idx;
 
 	data[0] = peer ? peer->ifindex : 0;
@@ -225,12 +240,7 @@ static void veth_get_ethtool_stats(struct net_device *dev,
 	}
 
 page_pool_stats:
-	for (i = 0; i < dev->real_num_rx_queues; i++) {
-		if (!priv->rq[i].page_pool)
-			continue;
-		page_pool_get_stats(priv->rq[i].page_pool, &pp_stats);
-	}
-	page_pool_ethtool_stats_get(&data[pp_idx], &pp_stats);
+	veth_get_page_pool_stats(dev, &data[pp_idx]);
 }
 
 static void veth_get_channels(struct net_device *dev,
-- 
2.40.1


