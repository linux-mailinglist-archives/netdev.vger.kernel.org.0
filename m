Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0679A43B8A0
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 19:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237959AbhJZRzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 13:55:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:46898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235511AbhJZRzQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 13:55:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5424F60F24;
        Tue, 26 Oct 2021 17:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635270772;
        bh=q1s9j7XyxvrIzFpRwu72zOAIJs53uU4IGpbqEBBiijg=;
        h=From:To:Cc:Subject:Date:From;
        b=mKz1KUhIX1W3dC3QskpoPtaD+dZktn7Olu59sybFoZ2s6xmIGpOTUNL3COCDjF0LN
         n/rI+U7Lv29vRUrXOOiGI7F7YTYEbASDtGWnmhEVnJkNeyLU6C+zdrH8dQYi+bhOx4
         X461bJj9YLLlma6PweADAUAg138I3NZZy4Joz3wWYQYWt9NUNaiyNYvyZvg9ZQl4fA
         vusum/B/Fz7/T3A/eU6eVxqsZXe2qbhx2buDvU93N40j9HTKJ7QWbHY8t0pqAXoYAJ
         VScS295XauXXkKwDUq6F+37Id5OeKFf84Mk1jCyyLdxvKQYl19UqDzZsDt2ItlhY5d
         oA1RGIfxchEWw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, mchehab@kernel.org,
        linux-media@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] media: use eth_hw_addr_set()
Date:   Tue, 26 Oct 2021 10:52:50 -0700
Message-Id: <20211026175250.3197558-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it go through appropriate helpers.

Convert media from memcpy(... 6) and memcpy(... addr_len) to
eth_hw_addr_set():

  @@
  expression dev, np;
  @@
  - memcpy(dev->dev_addr, np, 6)
  + eth_hw_addr_set(dev, np)
  @@
  - memcpy(dev->dev_addr, np, dev->addr_len)
  + eth_hw_addr_set(dev, np)

Make sure we don't cast off const qualifier from dev->dev_addr.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/media/dvb-core/dvb_net.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
index dddebea644bb..8a2febf33ce2 100644
--- a/drivers/media/dvb-core/dvb_net.c
+++ b/drivers/media/dvb-core/dvb_net.c
@@ -1008,7 +1008,7 @@ static u8 mask_promisc[6]={0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
 
 static int dvb_net_filter_sec_set(struct net_device *dev,
 		   struct dmx_section_filter **secfilter,
-		   u8 *mac, u8 *mac_mask)
+		   const u8 *mac, u8 *mac_mask)
 {
 	struct dvb_net_priv *priv = netdev_priv(dev);
 	int ret;
@@ -1052,7 +1052,7 @@ static int dvb_net_feed_start(struct net_device *dev)
 	int ret = 0, i;
 	struct dvb_net_priv *priv = netdev_priv(dev);
 	struct dmx_demux *demux = priv->demux;
-	unsigned char *mac = (unsigned char *) dev->dev_addr;
+	const unsigned char *mac = (const unsigned char *) dev->dev_addr;
 
 	netdev_dbg(dev, "rx_mode %i\n", priv->rx_mode);
 	mutex_lock(&priv->mutex);
@@ -1272,7 +1272,7 @@ static int dvb_net_set_mac (struct net_device *dev, void *p)
 	struct dvb_net_priv *priv = netdev_priv(dev);
 	struct sockaddr *addr=p;
 
-	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
+	eth_hw_addr_set(dev, addr->sa_data);
 
 	if (netif_running(dev))
 		schedule_work(&priv->restart_net_feed_wq);
@@ -1367,7 +1367,7 @@ static int dvb_net_add_if(struct dvb_net *dvbnet, u16 pid, u8 feedtype)
 			 dvbnet->dvbdev->adapter->num, if_num);
 
 	net->addr_len = 6;
-	memcpy(net->dev_addr, dvbnet->dvbdev->adapter->proposed_mac, 6);
+	eth_hw_addr_set(net, dvbnet->dvbdev->adapter->proposed_mac);
 
 	dvbnet->device[if_num] = net;
 
-- 
2.31.1

