Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42F5489739
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 08:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbfHLGgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 02:36:14 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:44199 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbfHLGgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 02:36:14 -0400
Received: by mail-yw1-f68.google.com with SMTP id l79so38333803ywe.11;
        Sun, 11 Aug 2019 23:36:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=kslLH4Uqs+rGxpqwQFf+1cq9Y1E7WzeuukGAnIal7z0=;
        b=dS+6OhJRFhKArjmG/gu/Muevn9h8UX4xXBB0Ss1a5zALcuRaqZP/oLvFm8Xp+fndEZ
         5lRdq/qtJuwoqnRT0haMpmFp3GN8uK9Lgyy2ivKx7yAFWOAKlFV5Gn/eqbJ4ZqFRg7MR
         plQXDT/zpVBPq8+XqVMEFPybfjU3nsD+ZdWYTi85X+IsyWbx4LdcXTUwYcpNl9XUDTl1
         blX5/gK9ijV7SP5ZQ+P7LRwEtVE/PE7XO8scKhdjx/gtNKIrU46m82pGuTVEOwN45zKg
         efA0qIflZ9ZVN2rPA2NWmoZjADvrAvWuPpwGxmJ5rwRDh4QfC46Mem8uuH6w6GJ7BGY4
         aypg==
X-Gm-Message-State: APjAAAVDObY/tCQAcNWp2+1FhcQRCar2MLcpJI5My51MAgrC1bsEMEBg
        +AC2/zsIjcKaSalZxF1yxAXaHD3Lyvg=
X-Google-Smtp-Source: APXvYqyEH4UpzW429OeouTIxC9M996cLjK/PStI+h3bBVuoPhPsqS7myPAFcrl1ssuzlf5lq+bMdTg==
X-Received: by 2002:a0d:c945:: with SMTP id l66mr2618710ywd.291.1565591773268;
        Sun, 11 Aug 2019 23:36:13 -0700 (PDT)
Received: from localhost.localdomain (24-158-240-219.dhcp.smyr.ga.charter.com. [24.158.240.219])
        by smtp.gmail.com with ESMTPSA id q132sm24029658ywb.26.2019.08.11.23.36.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 11 Aug 2019 23:36:12 -0700 (PDT)
From:   Wenwen Wang <wenwen@cs.uga.edu>
To:     Wenwen Wang <wenwen@cs.uga.edu>
Cc:     Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org (open list:MELLANOX ETHERNET DRIVER (mlx4_en)),
        linux-rdma@vger.kernel.org (open list:MELLANOX MLX4 core VPI driver),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] net/mlx4_en: fix a memory leak bug
Date:   Mon, 12 Aug 2019 01:36:05 -0500
Message-Id: <1565591765-6461-1-git-send-email-wenwen@cs.uga.edu>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In mlx4_en_config_rss_steer(), 'rss_map->indir_qp' is allocated through
kzalloc(). After that, mlx4_qp_alloc() is invoked to configure RSS
indirection. However, if mlx4_qp_alloc() fails, the allocated
'rss_map->indir_qp' is not deallocated, leading to a memory leak bug.

To fix the above issue, add the 'mlx4_err' label to free
'rss_map->indir_qp'.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
---
 drivers/net/ethernet/mellanox/mlx4/en_rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 6c01314..9476dbd 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -1187,7 +1187,7 @@ int mlx4_en_config_rss_steer(struct mlx4_en_priv *priv)
 	err = mlx4_qp_alloc(mdev->dev, priv->base_qpn, rss_map->indir_qp);
 	if (err) {
 		en_err(priv, "Failed to allocate RSS indirection QP\n");
-		goto rss_err;
+		goto mlx4_err;
 	}
 
 	rss_map->indir_qp->event = mlx4_en_sqp_event;
@@ -1241,6 +1241,7 @@ int mlx4_en_config_rss_steer(struct mlx4_en_priv *priv)
 		       MLX4_QP_STATE_RST, NULL, 0, 0, rss_map->indir_qp);
 	mlx4_qp_remove(mdev->dev, rss_map->indir_qp);
 	mlx4_qp_free(mdev->dev, rss_map->indir_qp);
+mlx4_err:
 	kfree(rss_map->indir_qp);
 	rss_map->indir_qp = NULL;
 rss_err:
-- 
2.7.4

