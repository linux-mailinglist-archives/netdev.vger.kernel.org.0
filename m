Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A45714C9EA
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 12:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgA2LvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 06:51:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:40164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbgA2LvK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jan 2020 06:51:10 -0500
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7C222063A;
        Wed, 29 Jan 2020 11:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580298669;
        bh=B5hScC8FkjJMZs+jrZ+ZORlawmXI5gC9Xgyk4ruzC5w=;
        h=From:To:Cc:Subject:Date:From;
        b=bjukZ6AMCKp0a960SyZY2ndNgXwNrR8pYq8gxCnbvpJVq6RBNWp5ASwH5Sq9mJegL
         cM1fog1jluGjGrmGf5TPK6m+3akiBLJPxZsg98kF0J71ColEEbHTWJnyWUbW/2XtwB
         p04CTrf0LVP+1LVTXlW5uAvi8L+q5sAJzybC7KB0=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     ilias.apalodimas@linaro.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com,
        sven.auhagen@voleatech.de, andrew@lunn.ch
Subject: [PATCH net] net: mvneta: fix XDP support if sw bm is used as fallback
Date:   Wed, 29 Jan 2020 12:50:53 +0100
Message-Id: <50f682e9e1f835011df18e08c837e61a0b579c15.1580296745.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to fix XDP support if sw buffer management is used as fallback
for hw bm devices, define MVNETA_SKB_HEADROOM as maximum between
XDP_PACKET_HEADROOM and NET_SKB_PAD and let the hw aligns the IP header
to 4-byte boundary.
Fix rx_offset_correction initialization if mvneta_bm_port_init fails in
mvneta_resume routine

Fixes: 0db51da7a8e9 ("net: mvneta: add basic XDP support")
Tested-by: Sven Auhagen <sven.auhagen@voleatech.de>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 2dfbfdff45a8..037e054b01a2 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -324,8 +324,7 @@
 	      ETH_HLEN + ETH_FCS_LEN,			     \
 	      cache_line_size())
 
-#define MVNETA_SKB_HEADROOM	(max(XDP_PACKET_HEADROOM, NET_SKB_PAD) + \
-				 NET_IP_ALIGN)
+#define MVNETA_SKB_HEADROOM	max(XDP_PACKET_HEADROOM, NET_SKB_PAD)
 #define MVNETA_SKB_PAD	(SKB_DATA_ALIGN(sizeof(struct skb_shared_info) + \
 			 MVNETA_SKB_HEADROOM))
 #define MVNETA_SKB_SIZE(len)	(SKB_DATA_ALIGN(len) + MVNETA_SKB_PAD)
@@ -1167,6 +1166,7 @@ static void mvneta_bm_update_mtu(struct mvneta_port *pp, int mtu)
 	mvneta_bm_pool_destroy(pp->bm_priv, pp->pool_short, 1 << pp->id);
 
 	pp->bm_priv = NULL;
+	pp->rx_offset_correction = MVNETA_SKB_HEADROOM;
 	mvreg_write(pp, MVNETA_ACC_MODE, MVNETA_ACC_MODE_EXT1);
 	netdev_info(pp->dev, "fail to update MTU, fall back to software BM\n");
 }
@@ -4948,7 +4948,6 @@ static int mvneta_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
 	pp->id = global_port_id++;
-	pp->rx_offset_correction = MVNETA_SKB_HEADROOM;
 
 	/* Obtain access to BM resources if enabled and already initialized */
 	bm_node = of_parse_phandle(dn, "buffer-manager", 0);
@@ -4973,6 +4972,10 @@ static int mvneta_probe(struct platform_device *pdev)
 	}
 	of_node_put(bm_node);
 
+	/* sw buffer management */
+	if (!pp->bm_priv)
+		pp->rx_offset_correction = MVNETA_SKB_HEADROOM;
+
 	err = mvneta_init(&pdev->dev, pp);
 	if (err < 0)
 		goto err_netdev;
@@ -5130,6 +5133,7 @@ static int mvneta_resume(struct device *device)
 		err = mvneta_bm_port_init(pdev, pp);
 		if (err < 0) {
 			dev_info(&pdev->dev, "use SW buffer management\n");
+			pp->rx_offset_correction = MVNETA_SKB_HEADROOM;
 			pp->bm_priv = NULL;
 		}
 	}
-- 
2.21.1

