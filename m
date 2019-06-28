Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75929591A0
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 04:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbfF1Csb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 22:48:31 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35106 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726640AbfF1Csb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 22:48:31 -0400
Received: by mail-pf1-f193.google.com with SMTP id d126so2195804pfd.2;
        Thu, 27 Jun 2019 19:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=prlSiId7QUiI+gwDR3lnnk/Z2jqfqNZ31yKhyD9ZPF8=;
        b=IBlKG/Q8XveEB6OeIWXJy2mRovNArp+euqYYCB2YnENrgJ4K8qRb9kUUSc/UHJmeJu
         QsgSBPekbDw/x1bLXzP2Q77Wq1Q0dku1gHinyiGfE/Qh6OVZZD9ifqeH99zH+MpEXSBL
         uDj7rb/wlynrgxiHvCB2JrTRi8JMUNOcQCxwGi9gha2X7khlIu7nfxVrUf7KZr+v9Kz8
         b3U30Fx5ygo/xlcEpmpbaBlIUZALg5WWvFmpyv8PdFzklI0aof7ShafkNvKYvaTh+RAW
         zxP/+Jfm4Uoi4fm0x8JlMFf7sCU9ypqgoM6iQxkXDSCfh9+s2slFIYFwHLF1NI6Mh40I
         d7nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=prlSiId7QUiI+gwDR3lnnk/Z2jqfqNZ31yKhyD9ZPF8=;
        b=TBGdYYIE1wmP4YgI7YPRTzDPXL9O6RBtdLuDdxgi3DzUjUAoKn6cI1pePZb9wSX7i7
         8adPpf8pn2DDAGaas7Ye2YUF9w4zevmY9i/Z2GdAAfYTCi1k4BuF8/JVi7zNGwmlvJkG
         0mfasnOxI5fpkx7INZNtFtmmYy6u2653nu+fD9V5ygJFqEE/IAI3qcPop7QW2MT7/TN/
         zjNFiLCsTpOr3JwvzPCpGtM5Wh4CuX3R9jebpSd2odJrNQyNME4N3OnuMR8YSEaDuXxZ
         aOSa52i4yjDJuhFzjG75vQMmXiuMlFkXmL9w/p9Plf7RjRGhrS9pGZP/HiinnivQQ58a
         wuWg==
X-Gm-Message-State: APjAAAVemTcjw/iMLPtqD8nxh8N7M94omLiEcloVged5wpKWWLXC53ku
        d5Q7ZMyVSKQsw8sRo41SJP3dpDaKZNdlXw==
X-Google-Smtp-Source: APXvYqy+DgQ8zAryFrqOja9lxR8wZdey0asEb3QKzT72OcwoSboTb2UzSP+g6tk8HDCaq4BNSZEJqw==
X-Received: by 2002:a17:90a:b011:: with SMTP id x17mr10189290pjq.113.1561690110442;
        Thu, 27 Jun 2019 19:48:30 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id q198sm451906pfq.155.2019.06.27.19.48.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 19:48:30 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Fuqian Huang <huangfq.daxian@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        Tariq Toukan <tariqt@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH v2 15/27] net: use zeroing allocator rather than allocator followed by memset zero
Date:   Fri, 28 Jun 2019 10:48:22 +0800
Message-Id: <20190628024824.15581-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace allocator followed by memset with 0 with zeroing allocator.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/net/eql.c                                       | 3 +--
 drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c | 4 +---
 drivers/net/ethernet/cavium/liquidio/cn23xx_vf_device.c | 4 +---
 drivers/net/ethernet/mellanox/mlx4/en_rx.c              | 3 +--
 4 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/eql.c b/drivers/net/eql.c
index 74263f8efe1a..2f101a6036e6 100644
--- a/drivers/net/eql.c
+++ b/drivers/net/eql.c
@@ -419,14 +419,13 @@ static int eql_enslave(struct net_device *master_dev, slaving_request_t __user *
 	if ((master_dev->flags & IFF_UP) == IFF_UP) {
 		/* slave is not a master & not already a slave: */
 		if (!eql_is_master(slave_dev) && !eql_is_slave(slave_dev)) {
-			slave_t *s = kmalloc(sizeof(*s), GFP_KERNEL);
+			slave_t *s = kzalloc(sizeof(*s), GFP_KERNEL);
 			equalizer_t *eql = netdev_priv(master_dev);
 			int ret;
 
 			if (!s)
 				return -ENOMEM;
 
-			memset(s, 0, sizeof(*s));
 			s->dev = slave_dev;
 			s->priority = srq.priority;
 			s->priority_bps = srq.priority;
diff --git a/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c b/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c
index 43d11c38b38a..cf3835da32c8 100644
--- a/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c
+++ b/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c
@@ -719,12 +719,10 @@ static int cn23xx_setup_pf_mbox(struct octeon_device *oct)
 	for (i = 0; i < oct->sriov_info.max_vfs; i++) {
 		q_no = i * oct->sriov_info.rings_per_vf;
 
-		mbox = vmalloc(sizeof(*mbox));
+		mbox = vzalloc(sizeof(*mbox));
 		if (!mbox)
 			goto free_mbox;
 
-		memset(mbox, 0, sizeof(struct octeon_mbox));
-
 		spin_lock_init(&mbox->lock);
 
 		mbox->oct_dev = oct;
diff --git a/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_device.c b/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_device.c
index fda49404968c..b3bd2767d3dd 100644
--- a/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_device.c
+++ b/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_device.c
@@ -279,12 +279,10 @@ static int cn23xx_setup_vf_mbox(struct octeon_device *oct)
 {
 	struct octeon_mbox *mbox = NULL;
 
-	mbox = vmalloc(sizeof(*mbox));
+	mbox = vzalloc(sizeof(*mbox));
 	if (!mbox)
 		return 1;
 
-	memset(mbox, 0, sizeof(struct octeon_mbox));
-
 	spin_lock_init(&mbox->lock);
 
 	mbox->oct_dev = oct;
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 6c01314e87b0..f1dff5c47676 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -1062,7 +1062,7 @@ static int mlx4_en_config_rss_qp(struct mlx4_en_priv *priv, int qpn,
 	struct mlx4_qp_context *context;
 	int err = 0;
 
-	context = kmalloc(sizeof(*context), GFP_KERNEL);
+	context = kzalloc(sizeof(*context), GFP_KERNEL);
 	if (!context)
 		return -ENOMEM;
 
@@ -1073,7 +1073,6 @@ static int mlx4_en_config_rss_qp(struct mlx4_en_priv *priv, int qpn,
 	}
 	qp->event = mlx4_en_sqp_event;
 
-	memset(context, 0, sizeof(*context));
 	mlx4_en_fill_qp_context(priv, ring->actual_size, ring->stride, 0, 0,
 				qpn, ring->cqn, -1, context);
 	context->db_rec_addr = cpu_to_be64(ring->wqres.db.dma);
-- 
2.11.0

