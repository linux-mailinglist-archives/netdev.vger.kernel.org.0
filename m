Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B39D5398956
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbhFBMXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbhFBMXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 08:23:12 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486BDC061574
        for <netdev@vger.kernel.org>; Wed,  2 Jun 2021 05:21:29 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id qq22so3512866ejb.9
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 05:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NDzypEDM/24TkYjn79MJZnAtZopAlw6XztPsiEC1pYI=;
        b=HiBf+gKm9Bfe7LY/suQevGiGQXlMvF4x5eHbiVgIwy64N/ompnzjIZkJSx/s6nGTsA
         WUih3mVlSPvAWU8hsz2TxuLtcP9HjrvBOdHgtntcjTrwBXR+j1JugV6g5yTBu8rMyM2C
         pFp1Pj3msmopO7uRtkVQw00NPMUa9I8Aqt8foIfR7FRJ4w8JnF5I/bDIkbHj5Tk52sZz
         XbyEtOU6qNYqCFi7PrI+vXpJbYY7xSgw0I+hcnrWHgQMJAaabfdfaLvV4fp8ccVVdW9N
         +5BfaSSfnWBL/qWEcbUaF14zocZ6u8uA5CYQNmsGkBQXGhBwHfh7w457VqkI3XFQtL0I
         A6Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NDzypEDM/24TkYjn79MJZnAtZopAlw6XztPsiEC1pYI=;
        b=QJqQUOCbgBOy8/L0G2KbegZcRlYfZF6NHDD7jMTQq1uR5gn/p0Ixu4MbRCEmlGzpx1
         4H/lApWrPM+BtR4vpTyGqkKPHAksvL0J+HFcRBkuU98ALqlANUteBBHJdwSAsqy5RQ/c
         lfQLiNMgaKtb5GDzPwfICxTSrDtqLHQk1ErHF8jFXPQ77ZeNSxIpAQk0RSKfXoEVGELj
         klwqQUcDNqpwD+NxS0yOqt2TwhbrWXL9Y+0IEHI8qsnF2f/IbEA6vcWGROi5o7k+z9ZL
         xJZ+JgVTBzgRFrhDePP4X/okkIp/N8iSE3E4ZYs4JEjCYVhjzSWzfVU+ZJPEX5yzDaUM
         2nvA==
X-Gm-Message-State: AOAM530LeaqMBBB6WCn5bp8JSZSrEgmXjGAypzZ74ZUw0JwYtZCJY/El
        VZ8J6Av56NLdJ1FIkcCZws4=
X-Google-Smtp-Source: ABdhPJznHcPXWwC9JGARuvCi+S2eCDBvlJddPOWaPPJrQ9HyTkNp3q5/2gCHIDWpQtHtpDJpIr1MSQ==
X-Received: by 2002:a17:906:3042:: with SMTP id d2mr34537309ejd.234.1622636487854;
        Wed, 02 Jun 2021 05:21:27 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id gw7sm1448745ejb.5.2021.06.02.05.21.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 05:21:27 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Michael Walle <michael@walle.cc>, Po Liu <po.liu@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Po Liu <Po.Liu@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 2/2] net: enetc: count the tc-taprio window drops
Date:   Wed,  2 Jun 2021 15:21:14 +0300
Message-Id: <20210602122114.2082344-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210602122114.2082344-1-olteanv@gmail.com>
References: <20210602122114.2082344-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Po Liu <Po.Liu@nxp.com>

The enetc scheduler for IEEE 802.1Qbv has 2 options (depending on
PTGCR[TG_DROP_DISABLE]) when we attempt to send an oversized packet
which will never fit in its allotted time slot for its traffic class:
either block the entire port due to head-of-line blocking, or drop the
packet and set a bit in the writeback format of the transmit buffer
descriptor, allowing other packets to be sent.

We obviously choose the second option in the driver, but we do not
detect the drop condition, so from the perspective of the network stack,
the packet is sent and no error counter is incremented.

This change checks the writeback of the TX BD when tc-taprio is enabled,
and increments a specific ethtool statistics counter and a generic
"tx_dropped" counter in ndo_get_stats64.

Signed-off-by: Po Liu <Po.Liu@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c        | 13 +++++++++++--
 drivers/net/ethernet/freescale/enetc/enetc.h        |  2 ++
 .../net/ethernet/freescale/enetc/enetc_ethtool.c    |  2 ++
 drivers/net/ethernet/freescale/enetc/enetc_hw.h     |  1 +
 4 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 3ca93adb9662..3f1cb921571a 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -170,7 +170,8 @@ static int enetc_map_tx_buffs(struct enetc_bdr *tx_ring, struct sk_buff *skb)
 	}
 
 	tx_swbd->do_twostep_tstamp = do_twostep_tstamp;
-	tx_swbd->check_wb = tx_swbd->do_twostep_tstamp;
+	tx_swbd->qbv_en = !!(priv->active_offloads & ENETC_F_QBV);
+	tx_swbd->check_wb = tx_swbd->do_twostep_tstamp || tx_swbd->qbv_en;
 
 	if (do_vlan || do_onestep_tstamp || do_twostep_tstamp)
 		flags |= ENETC_TXBD_FLAGS_EX;
@@ -525,9 +526,9 @@ static void enetc_recycle_xdp_tx_buff(struct enetc_bdr *tx_ring,
 
 static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 {
+	int tx_frm_cnt = 0, tx_byte_cnt = 0, tx_win_drop = 0;
 	struct net_device *ndev = tx_ring->ndev;
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
-	int tx_frm_cnt = 0, tx_byte_cnt = 0;
 	struct enetc_tx_swbd *tx_swbd;
 	int i, bds_to_clean;
 	bool do_twostep_tstamp;
@@ -557,6 +558,10 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 						    &tstamp);
 				do_twostep_tstamp = true;
 			}
+
+			if (tx_swbd->qbv_en &&
+			    txbd->wb.status & ENETC_TXBD_STATS_WIN)
+				tx_win_drop++;
 		}
 
 		if (tx_swbd->is_xdp_tx)
@@ -610,6 +615,7 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 	tx_ring->next_to_clean = i;
 	tx_ring->stats.packets += tx_frm_cnt;
 	tx_ring->stats.bytes += tx_byte_cnt;
+	tx_ring->stats.win_drop += tx_win_drop;
 
 	if (unlikely(tx_frm_cnt && netif_carrier_ok(ndev) &&
 		     __netif_subqueue_stopped(ndev, tx_ring->index) &&
@@ -2271,6 +2277,7 @@ struct net_device_stats *enetc_get_stats(struct net_device *ndev)
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct net_device_stats *stats = &ndev->stats;
 	unsigned long packets = 0, bytes = 0;
+	unsigned long tx_dropped = 0;
 	int i;
 
 	for (i = 0; i < priv->num_rx_rings; i++) {
@@ -2286,10 +2293,12 @@ struct net_device_stats *enetc_get_stats(struct net_device *ndev)
 	for (i = 0; i < priv->num_tx_rings; i++) {
 		packets += priv->tx_ring[i]->stats.packets;
 		bytes	+= priv->tx_ring[i]->stats.bytes;
+		tx_dropped += priv->tx_ring[i]->stats.win_drop;
 	}
 
 	stats->tx_packets = packets;
 	stats->tx_bytes = bytes;
+	stats->tx_dropped = tx_dropped;
 
 	return stats;
 }
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 08b283347d9c..2a5973aebc31 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -34,6 +34,7 @@ struct enetc_tx_swbd {
 	u8 is_eof:1;
 	u8 is_xdp_tx:1;
 	u8 is_xdp_redirect:1;
+	u8 qbv_en:1;
 };
 
 #define ENETC_RX_MAXFRM_SIZE	ENETC_MAC_MAXFRM_SIZE
@@ -70,6 +71,7 @@ struct enetc_ring_stats {
 	unsigned int xdp_redirect_sg;
 	unsigned int recycles;
 	unsigned int recycle_failures;
+	unsigned int win_drop;
 };
 
 struct enetc_xdp_data {
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index ebccaf02411c..4d55e78fa353 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -204,6 +204,7 @@ static const char tx_ring_stats[][ETH_GSTRING_LEN] = {
 	"Tx ring %2d frames",
 	"Tx ring %2d XDP frames",
 	"Tx ring %2d XDP drops",
+	"Tx window drop %2d frames",
 };
 
 static int enetc_get_sset_count(struct net_device *ndev, int sset)
@@ -279,6 +280,7 @@ static void enetc_get_ethtool_stats(struct net_device *ndev,
 		data[o++] = priv->tx_ring[i]->stats.packets;
 		data[o++] = priv->tx_ring[i]->stats.xdp_tx;
 		data[o++] = priv->tx_ring[i]->stats.xdp_tx_drops;
+		data[o++] = priv->tx_ring[i]->stats.win_drop;
 	}
 
 	for (i = 0; i < priv->num_rx_rings; i++) {
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 0f5f081a5baf..e7fa4fb85d0b 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -543,6 +543,7 @@ enum enetc_txbd_flags {
 	ENETC_TXBD_FLAGS_EX = BIT(6),
 	ENETC_TXBD_FLAGS_F = BIT(7)
 };
+#define ENETC_TXBD_STATS_WIN	BIT(7)
 #define ENETC_TXBD_TXSTART_MASK GENMASK(24, 0)
 #define ENETC_TXBD_FLAGS_OFFSET 24
 
-- 
2.25.1

