Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFCA541E253
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 21:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344843AbhI3TmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 15:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345286AbhI3TmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 15:42:19 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4760AC06176C
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 12:40:36 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id y5so4791375pll.3
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 12:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DUmy3ftvpt4slivmFdWM/t7fJc6HK6FWGLReMOuefTo=;
        b=I0jl6uUDdjMoor60bTkBVaBdlaOpj5C3cP2XLkWT3uXcH0eMndU9HngqZe96fgKm9O
         I39DezWd0N7rW4KDTu/gcWQPJ/2MswSDaB0sqr0+9r2zTKZsas4TV0L2RNF2Lp4XvIPI
         qSAZvtCWlV4+bnq1BSJdV3Rsia3ih6C1eocEmzatvu4pjgDKw6IFXLztaVcqCGQXoe9v
         OL4x/1ZsS1Ahk2TVx6X087+U35A79xTbiq6M/XyQtVhJNHd5ZXHyFNcDFKgh9O5T5nus
         UjQWcBvLO1hW38ANIqoXm2/S36mN0TmDGqnTqeWjm3Hr2dvEmfBqwK7UGpJ6Zridhdhg
         Dpcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DUmy3ftvpt4slivmFdWM/t7fJc6HK6FWGLReMOuefTo=;
        b=HATNHMcTbV1umE89tTckzt5pLxqOVkk5zkmtG9lJBK6SAdatxYHhlE6ONyJrtKxh/S
         OwjFQ6ovI21SrQGAkCLDmJAykPPoYj+nbgNQwjDg51GAs5Z+3ALKTikH/9Fc8kDfIgGm
         YJ49ANNzzqT2Ie3Lt3VdEzINZM3U7mSgu4OZ/R27Y8hLpCZ4Hh9aqntYfLldRpWjvNc5
         TSzArsgsyb6C6VXQbt2Z/Tdp+0bee4EIjWoVTuIaMA4JBj6J8i4p7HB3qza+B332shD8
         2dzPne3IN4QsbzYyuKi7okVe0nSjRu9gt9my4uCNJKVrFZea/EPIodrybBb471TDLI30
         8QBw==
X-Gm-Message-State: AOAM5307sfzVNd1xP8l9nv+NldFdQl0WfVqJ5EurOnfYL5mvhFuhWFI3
        uf5kCCpQD1Hfm8DsisvhJqA=
X-Google-Smtp-Source: ABdhPJzuoKWLyfchm72lEUQtNdj/1BqAjdR+xLLaiapLRFEJkrDemgeir2+3dKZha0O2WhvOCEqzkQ==
X-Received: by 2002:a17:90a:f409:: with SMTP id ch9mr7665716pjb.50.1633030835803;
        Thu, 30 Sep 2021 12:40:35 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:b59b:abc0:171:fe0e])
        by smtp.gmail.com with ESMTPSA id b8sm3800781pfi.103.2021.09.30.12.40.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 12:40:35 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next] net/mlx4_en: avoid one cache line miss to ring doorbell
Date:   Thu, 30 Sep 2021 12:40:31 -0700
Message-Id: <20210930194031.3181989-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This patch caches doorbell address directly in struct mlx4_en_tx_ring.

This removes the need to bring in cpu caches whole struct mlx4_uar
in fast path.

Note that mlx4_uar is not guaranteed to be on a local node,
because mlx4_bf_alloc() uses a single free list (priv->bf_list)
regardless of its node parameter.

This kind of change does matter in presence of light/moderate traffic.
In high stress, this read-only line would be kept hot in caches.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_tx.c   | 4 ++--
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index c56b9dba4c71898b61e87fd32e5fa523c313e445..817f4154b86d599cd593876ec83529051d95fe2f 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -130,6 +130,7 @@ int mlx4_en_create_tx_ring(struct mlx4_en_priv *priv,
 		ring->bf_enabled = !!(priv->pflags &
 				      MLX4_EN_PRIV_FLAGS_BLUEFLAME);
 	}
+	ring->doorbell_address = ring->bf.uar->map + MLX4_SEND_DOORBELL;
 
 	ring->hwtstamp_tx_type = priv->hwtstamp_config.tx_type;
 	ring->queue_index = queue_index;
@@ -753,8 +754,7 @@ void mlx4_en_xmit_doorbell(struct mlx4_en_tx_ring *ring)
 #else
 	iowrite32be(
 #endif
-		  (__force u32)ring->doorbell_qpn,
-		  ring->bf.uar->map + MLX4_SEND_DOORBELL);
+		  (__force u32)ring->doorbell_qpn, ring->doorbell_address);
 }
 
 static void mlx4_en_tx_write_desc(struct mlx4_en_tx_ring *ring,
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
index ad0a8b488832c8cdca2790e47fc778fe15686f7f..e1ad64cc0c8784352d18ae89df6d05bd9709e8a0 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -283,6 +283,7 @@ struct mlx4_en_tx_ring {
 	struct mlx4_bf		bf;
 
 	/* Following part should be mostly read */
+	void			*doorbell_address;
 	__be32			doorbell_qpn;
 	__be32			mr_key;
 	u32			size; /* number of TXBBs */
-- 
2.33.0.800.g4c38ced690-goog

