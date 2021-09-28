Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D89841B000
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 15:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240859AbhI1N2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 09:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233878AbhI1N2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 09:28:32 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A73C061575;
        Tue, 28 Sep 2021 06:26:53 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id 138so40173963qko.10;
        Tue, 28 Sep 2021 06:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RHL6JZa8EAnILkEzg08qxNM2V7eltepufz30/GOy0a8=;
        b=VNmAl3HuXqZ3h88WrHO6AEiHj5XNCYICoC6s9tx17Xj0cEk0kKv9bfJXwofrKSM65V
         0HGCmrKwyInqFid1biTCpZM8cKNw3bSu9x5FH5M09Zv4CvD/7DHtw0IWgyQvfGuxXv8L
         ywgk36aC8H2j0jQlYW0mXioqh/ZcDhngbBHQgG7lwGfhekom0PbZZhDwo7YtINfaqlct
         UiO8p49TL+TPM3XihphVY9ICAmTP+hBiTnkNhchK8Up8mSvBjC0AvvR8WJQqYdwAHsK9
         JdYlC2cSxOcgp4T7feQ4UXH6Y+N76tgBNm71gKvIb0xqMs/5aQEm+J7pd6Tv9AfSMZL6
         QeuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RHL6JZa8EAnILkEzg08qxNM2V7eltepufz30/GOy0a8=;
        b=mFj1l4K/nqBq8eH2YKxb4GgLtKQvjhajGeI2rhaF6F2flgci/ZIVviWtz67+veXw7w
         6rVztm+c0vbLYoCfRo72yCUf388AocZDqVaeHTKavP5ztPP1g+8R3C3iw6D2BHWftB3+
         3zLRRuU9phcVifocFa97ILGY+Vs1FIW68ys/UHJMOjLjpMvxBMV/fmGsuwU+Pefi+1pY
         UJyT/SGzqaflomTgp8XOOU2h8mM1nBqv/xmdR5ESHFUS6eAwygvtH+vNFNKFQl0ZF1Nu
         kvJmV/N0qXXhY/Mc5q2bpNzox5emarDHVh+zzlbxue8fySHrY2lXsPNX6pacMLy0CtCU
         emyQ==
X-Gm-Message-State: AOAM531e5VhIbITfIm4oUsuuRHrj/W///5lRyc4ha3Yo8OwFxy/jVSO2
        U+D0rpAysfbbm3arzUPOy1sS19/UeKejCg==
X-Google-Smtp-Source: ABdhPJztGAYHpMfCs90Rq3lMs0XN6uvUaNGsEGa5iW3IcORsJzUKJeTHxx8+8j4xyWqfSwNk8Xlh0g==
X-Received: by 2002:a37:6895:: with SMTP id d143mr5275997qkc.217.1632835612125;
        Tue, 28 Sep 2021 06:26:52 -0700 (PDT)
Received: from vpp.lan (h112.166.20.98.dynamic.ip.windstream.net. [98.20.166.112])
        by smtp.gmail.com with ESMTPSA id d82sm1673492qke.55.2021.09.28.06.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 06:26:51 -0700 (PDT)
From:   Joshua Roys <roysjosh@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Joshua Roys <roysjosh@gmail.com>, ast@kernel.org,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        daniel@iogearbox.net, kuba@kernel.org, bpf@vger.kernel.org,
        tariqt@nvidia.com, linux-rdma@vger.kernel.org
Subject: [PATCH net-next] net: mlx4: Add XDP_REDIRECT statistics
Date:   Tue, 28 Sep 2021 09:26:02 -0400
Message-Id: <20210928132602.1488-1-roysjosh@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <8d7773a0-054a-84d5-e0b6-66a13509149e@gmail.com>
References: <8d7773a0-054a-84d5-e0b6-66a13509149e@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Address feedback for XDP_REDIRECT patch.

Signed-off-by: Joshua Roys <roysjosh@gmail.com>
---
 .../net/ethernet/mellanox/mlx4/en_ethtool.c    |  8 ++++++++
 drivers/net/ethernet/mellanox/mlx4/en_port.c   | 18 +++++++++++-------
 drivers/net/ethernet/mellanox/mlx4/en_rx.c     |  4 +++-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h   |  2 ++
 .../net/ethernet/mellanox/mlx4/mlx4_stats.h    |  4 +++-
 5 files changed, 27 insertions(+), 9 deletions(-)

Tested with VPP 21.06 on Fedora 34.

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
index ef518b1040f7..66c8ae29bc7a 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -197,6 +197,8 @@ static const char main_strings[][ETH_GSTRING_LEN] = {
 
 	/* xdp statistics */
 	"rx_xdp_drop",
+	"rx_xdp_redirect",
+	"rx_xdp_redirect_fail",
 	"rx_xdp_tx",
 	"rx_xdp_tx_full",
 
@@ -428,6 +430,8 @@ static void mlx4_en_get_ethtool_stats(struct net_device *dev,
 		data[index++] = priv->rx_ring[i]->bytes;
 		data[index++] = priv->rx_ring[i]->dropped;
 		data[index++] = priv->rx_ring[i]->xdp_drop;
+		data[index++] = priv->rx_ring[i]->xdp_redirect;
+		data[index++] = priv->rx_ring[i]->xdp_redirect_fail;
 		data[index++] = priv->rx_ring[i]->xdp_tx;
 		data[index++] = priv->rx_ring[i]->xdp_tx_full;
 	}
@@ -519,6 +523,10 @@ static void mlx4_en_get_strings(struct net_device *dev,
 				"rx%d_dropped", i);
 			sprintf(data + (index++) * ETH_GSTRING_LEN,
 				"rx%d_xdp_drop", i);
+			sprintf(data + (index++) * ETH_GSTRING_LEN,
+				"rx%d_xdp_redirect", i);
+			sprintf(data + (index++) * ETH_GSTRING_LEN,
+				"rx%d_xdp_redirect_fail", i);
 			sprintf(data + (index++) * ETH_GSTRING_LEN,
 				"rx%d_xdp_tx", i);
 			sprintf(data + (index++) * ETH_GSTRING_LEN,
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_port.c b/drivers/net/ethernet/mellanox/mlx4/en_port.c
index 0158b88bea5b..043cc9d75b3e 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_port.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_port.c
@@ -239,13 +239,15 @@ int mlx4_en_DUMP_ETH_STATS(struct mlx4_en_dev *mdev, u8 port, u8 reset)
 
 	mlx4_en_fold_software_stats(dev);
 
-	priv->port_stats.rx_chksum_good = 0;
-	priv->port_stats.rx_chksum_none = 0;
-	priv->port_stats.rx_chksum_complete = 0;
-	priv->port_stats.rx_alloc_pages = 0;
-	priv->xdp_stats.rx_xdp_drop    = 0;
-	priv->xdp_stats.rx_xdp_tx      = 0;
-	priv->xdp_stats.rx_xdp_tx_full = 0;
+	priv->port_stats.rx_chksum_good      = 0;
+	priv->port_stats.rx_chksum_none      = 0;
+	priv->port_stats.rx_chksum_complete  = 0;
+	priv->port_stats.rx_alloc_pages      = 0;
+	priv->xdp_stats.rx_xdp_drop          = 0;
+	priv->xdp_stats.rx_xdp_redirect      = 0;
+	priv->xdp_stats.rx_xdp_redirect_fail = 0;
+	priv->xdp_stats.rx_xdp_tx            = 0;
+	priv->xdp_stats.rx_xdp_tx_full       = 0;
 	for (i = 0; i < priv->rx_ring_num; i++) {
 		const struct mlx4_en_rx_ring *ring = priv->rx_ring[i];
 
@@ -255,6 +257,8 @@ int mlx4_en_DUMP_ETH_STATS(struct mlx4_en_dev *mdev, u8 port, u8 reset)
 		priv->port_stats.rx_chksum_complete += READ_ONCE(ring->csum_complete);
 		priv->port_stats.rx_alloc_pages += READ_ONCE(ring->rx_alloc_pages);
 		priv->xdp_stats.rx_xdp_drop	+= READ_ONCE(ring->xdp_drop);
+		priv->xdp_stats.rx_xdp_redirect += READ_ONCE(ring->xdp_redirect);
+		priv->xdp_stats.rx_xdp_redirect_fail += READ_ONCE(ring->xdp_redirect_fail);
 		priv->xdp_stats.rx_xdp_tx	+= READ_ONCE(ring->xdp_tx);
 		priv->xdp_stats.rx_xdp_tx_full	+= READ_ONCE(ring->xdp_tx_full);
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 557d7daac2d3..8f09b1de4125 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -793,11 +793,13 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 			case XDP_PASS:
 				break;
 			case XDP_REDIRECT:
-				if (xdp_do_redirect(dev, &xdp, xdp_prog) >= 0) {
+				if (!xdp_do_redirect(dev, &xdp, xdp_prog)) {
+					ring->xdp_redirect++;
 					xdp_redir_flush = true;
 					frags[0].page = NULL;
 					goto next;
 				}
+				ring->xdp_redirect_fail++;
 				trace_xdp_exception(dev, xdp_prog, act);
 				goto xdp_drop_no_cnt;
 			case XDP_TX:
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
index f3d1a20201ef..f6c90e97b4cd 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -340,6 +340,8 @@ struct mlx4_en_rx_ring {
 	unsigned long csum_complete;
 	unsigned long rx_alloc_pages;
 	unsigned long xdp_drop;
+	unsigned long xdp_redirect;
+	unsigned long xdp_redirect_fail;
 	unsigned long xdp_tx;
 	unsigned long xdp_tx_full;
 	unsigned long dropped;
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_stats.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_stats.h
index 7b51ae8cf759..e9cd4bb6f83d 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_stats.h
@@ -42,9 +42,11 @@ struct mlx4_en_port_stats {
 
 struct mlx4_en_xdp_stats {
 	unsigned long rx_xdp_drop;
+	unsigned long rx_xdp_redirect;
+	unsigned long rx_xdp_redirect_fail;
 	unsigned long rx_xdp_tx;
 	unsigned long rx_xdp_tx_full;
-#define NUM_XDP_STATS		3
+#define NUM_XDP_STATS		5
 };
 
 struct mlx4_en_phy_stats {
-- 
2.31.1

