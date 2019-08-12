Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 377DC8A6E6
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 21:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbfHLTLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 15:11:52 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:41221 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbfHLTLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 15:11:52 -0400
Received: by mail-yb1-f195.google.com with SMTP id n7so4236975ybd.8;
        Mon, 12 Aug 2019 12:11:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=oWFM6rsWwr2/8NmCYG8dA8Afg3RG0C8rbixsAOZiZhE=;
        b=VJb9ZR4CPV3So7W3wv26gLPoXvFhcBA/IEF/Ju1HN+bXVruAmKoGhIJ5rnzbWMgSZE
         fALw598tdsp4F0NtyJVp8dtpSp8I8scOpmp1Y5IcxtMUAnAjjjTWbnnnonVCYlKk78Wm
         4MSlYWx/dLGGlHeMGyRlM0EzStng3K0oFpNlmJRD3neToHHd4Qz4Q7xJ47iE2QNO/Tkk
         nAAeMdTbi5R8NnvqlqGsQBHcCYLo/HMYcSM3kvz79Q35QLBFQtXu/fjtLcpeNm0DR1ng
         0jgLlsdTPjGDIV/zQ0iCQqNhnLw1C1fqokk+inKWZq4HHbQBOVz3fPMar/1r3BCYHaAa
         vPJg==
X-Gm-Message-State: APjAAAUzNKrVKPQMMhgtHfFQJdpuLrThZxx2yduU6+EOcygxEuYj9nWb
        wE0DHQPGDlbSCVvyp/HEiL4=
X-Google-Smtp-Source: APXvYqyEJYx2b36OinXqAO2z76u3/xvYcHi3C4xSFH4ddR32DXQs6x+YIR2GBrmU4FmV71KsqNvSbw==
X-Received: by 2002:a25:57d5:: with SMTP id l204mr24262546ybb.508.1565637111019;
        Mon, 12 Aug 2019 12:11:51 -0700 (PDT)
Received: from BlueSky.guest.pso.uga.edu (75-131-184-98.static.gwnt.ga.charter.com. [75.131.184.98])
        by smtp.gmail.com with ESMTPSA id x15sm2001013ywj.63.2019.08.12.12.11.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 12 Aug 2019 12:11:50 -0700 (PDT)
From:   Wenwen Wang <wenwen@cs.uga.edu>
To:     Wenwen Wang <wenwen@cs.uga.edu>
Cc:     Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org (open list:MELLANOX ETHERNET DRIVER (mlx4_en)),
        linux-rdma@vger.kernel.org (open list:MELLANOX MLX4 core VPI driver),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] net/mlx4_en: fix a memory leak bug
Date:   Mon, 12 Aug 2019 14:11:35 -0500
Message-Id: <1565637095-7972-1-git-send-email-wenwen@cs.uga.edu>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In mlx4_en_config_rss_steer(), 'rss_map->indir_qp' is allocated through
kzalloc(). After that, mlx4_qp_alloc() is invoked to configure RSS
indirection. However, if mlx4_qp_alloc() fails, the allocated
'rss_map->indir_qp' is not deallocated, leading to a memory leak bug.

To fix the above issue, add the 'qp_alloc_err' label to free
'rss_map->indir_qp'.

Fixes: 4931c6ef04b4 ("net/mlx4_en: Optimized single ring steering")

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
---
 drivers/net/ethernet/mellanox/mlx4/en_rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 6c01314..db3552f 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -1187,7 +1187,7 @@ int mlx4_en_config_rss_steer(struct mlx4_en_priv *priv)
 	err = mlx4_qp_alloc(mdev->dev, priv->base_qpn, rss_map->indir_qp);
 	if (err) {
 		en_err(priv, "Failed to allocate RSS indirection QP\n");
-		goto rss_err;
+		goto qp_alloc_err;
 	}
 
 	rss_map->indir_qp->event = mlx4_en_sqp_event;
@@ -1241,6 +1241,7 @@ int mlx4_en_config_rss_steer(struct mlx4_en_priv *priv)
 		       MLX4_QP_STATE_RST, NULL, 0, 0, rss_map->indir_qp);
 	mlx4_qp_remove(mdev->dev, rss_map->indir_qp);
 	mlx4_qp_free(mdev->dev, rss_map->indir_qp);
+qp_alloc_err:
 	kfree(rss_map->indir_qp);
 	rss_map->indir_qp = NULL;
 rss_err:
-- 
2.7.4

