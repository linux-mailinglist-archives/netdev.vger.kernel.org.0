Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B26CC41D158
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 04:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347686AbhI3CTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 22:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347487AbhI3CTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 22:19:45 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33967C06161C;
        Wed, 29 Sep 2021 19:18:03 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id 11so2689403qvd.11;
        Wed, 29 Sep 2021 19:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y5Gh4oaaULAjy9Ls1siiMfAAe1fncZYaFKEdzt9GEmE=;
        b=A2zaW/6XKD8jFlpoJcgz6e5C+hSh4dXRFewPR0XnnVO5OfIimpY2Q8XWCnZMDjjlDE
         xQvPAEXkV4OmagA1uO0Tv4IYctEGOm/7furs0B13Ov2uHaW6w/wkqFTTzmoWDgpILvVc
         /3rDYYhIeYKFP5/nCBpk8HD8QEIQAZ7fyFsI2m2GSIwVzfURJLbfFjiUdCEv6MfO3M8/
         HOPEDw7Rn7JE7B0ffPUtHJWgmTrKN1e4g1ERyzsCkOHYqqSSw/+3coVwDQE/VLN7QgQE
         28X580sYvFTBhNVAnEHR/5ZcIjBsCDONbiTeQRWW7zJZd/qHYIVt1XBTaUtUg7atz2Cp
         fcow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y5Gh4oaaULAjy9Ls1siiMfAAe1fncZYaFKEdzt9GEmE=;
        b=RNTVCAUx5CE9Jmm5pCbMWMYt9psGwE9lQifxsshzXV5jh3M+xQHdpuid4MZxcSIQvJ
         PPmC7ps2eeGDYA+QlnqtYiiv80pXjXSGkRMx+Q2ZVyh2pNc/ddURm+m1IZ7POzRfzzcV
         kIMmOqPVUJidK7+1fs38cKEkbOyF+RS3Edal8Z0L86IGZqzhld6je2Vg7Dr6xGDuvPCZ
         XLLqrevikCA7bzPFolCgv2HM2reX7HjR3sgxOzMb3L7onWvQ6n13dKtrVV9WLi/+83Nu
         SqzydUK41m+biwevUbXq26hb6rEFgOADt9RkHjHSeF7YHAgY3KGcQep+rwvfx07p1Eym
         qs6Q==
X-Gm-Message-State: AOAM5305zz8xuC5nIbvT2dkyzU1ZkeiWnpeU5J0c++h0s57aSaAONE1H
        soh9REnSFs6PIqL6lcIu8bWNIXyq1Yn9QA==
X-Google-Smtp-Source: ABdhPJz6J7AB2xrlC67LATZk82dpvwfF0XHheMdJ3s3aXb4TY/7OvZt/4Kr+6pudlkrt7EqXiopRng==
X-Received: by 2002:a0c:b45a:: with SMTP id e26mr1634507qvf.59.1632968282132;
        Wed, 29 Sep 2021 19:18:02 -0700 (PDT)
Received: from vpp.lan (h132.37.184.173.dynamic.ip.windstream.net. [173.184.37.132])
        by smtp.gmail.com with ESMTPSA id j15sm977551qth.3.2021.09.29.19.18.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 19:18:01 -0700 (PDT)
From:   Joshua Roys <roysjosh@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Joshua Roys <roysjosh@gmail.com>, ast@kernel.org,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        daniel@iogearbox.net, kuba@kernel.org, bpf@vger.kernel.org,
        tariqt@nvidia.com, linux-rdma@vger.kernel.org
Subject: [PATCH net-next v2] net/mlx4_en: Add XDP_REDIRECT statistics
Date:   Wed, 29 Sep 2021 22:17:18 -0400
Message-Id: <20210930021718.245395-1-roysjosh@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210928132602.1488-1-roysjosh@gmail.com>
References: <20210928132602.1488-1-roysjosh@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add counters for XDP REDIRECT success and failure. This brings the
redirect path in line with metrics gathered via the other XDP paths.

Signed-off-by: Joshua Roys <roysjosh@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c | 8 ++++++++
 drivers/net/ethernet/mellanox/mlx4/en_port.c    | 4 ++++
 drivers/net/ethernet/mellanox/mlx4/en_rx.c      | 4 +++-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h    | 2 ++
 drivers/net/ethernet/mellanox/mlx4/mlx4_stats.h | 4 +++-
 5 files changed, 20 insertions(+), 2 deletions(-)

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
index 0158b88bea5b..f25794a92241 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_port.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_port.c
@@ -244,6 +244,8 @@ int mlx4_en_DUMP_ETH_STATS(struct mlx4_en_dev *mdev, u8 port, u8 reset)
 	priv->port_stats.rx_chksum_complete = 0;
 	priv->port_stats.rx_alloc_pages = 0;
 	priv->xdp_stats.rx_xdp_drop    = 0;
+	priv->xdp_stats.rx_xdp_redirect = 0;
+	priv->xdp_stats.rx_xdp_redirect_full = 0;
 	priv->xdp_stats.rx_xdp_tx      = 0;
 	priv->xdp_stats.rx_xdp_tx_full = 0;
 	for (i = 0; i < priv->rx_ring_num; i++) {
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
index 557d7daac2d3..650e6a1844ae 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -793,11 +793,13 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 			case XDP_PASS:
 				break;
 			case XDP_REDIRECT:
-				if (xdp_do_redirect(dev, &xdp, xdp_prog) >= 0) {
+				if (likely(!xdp_do_redirect(dev, &xdp, xdp_prog))) {
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

