Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66CFE32FAEF
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 14:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbhCFNss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Mar 2021 08:48:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbhCFNsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Mar 2021 08:48:17 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D882C06174A;
        Sat,  6 Mar 2021 05:48:17 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id d11so2796849plo.8;
        Sat, 06 Mar 2021 05:48:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=e4ypv4W27d2sjTQZzu/YE+vdRdz7Ylx2KBLR/wy3z20=;
        b=b1amEmZWdb256Tqfj+9BOOr1Ir0dUwNVVVcaeUoq7CUL+c0Y6sRmvKzBlCBaReK8um
         snqJ+anhP/cNNNx18WJLfjJyPaJNUDyg7YLieOQ615IkPWyt8tW6NnDlNUqhQm/zPNuu
         xH14ny1rCYPLRtjMgEoDNBdxaP5dT+nNUFEn/HgRvnOxs/omxK+6o2iD0qaSmc4862qm
         OpAArO+rrUhycGFjzITend6iuYRwjlVZlDehnQzADdYehAtlgU4npMOpCBrKUO6Dumy4
         cbrjDPoj051q+ut9p8CLYCA47+fZ5f4ou7+ds+QuNN9Or811PV5L47hwHE2jTOmZTIJ2
         3Q0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=e4ypv4W27d2sjTQZzu/YE+vdRdz7Ylx2KBLR/wy3z20=;
        b=hAbaH1pFsSbFwxcAFza6S+I6rDwHRUFeTHEWYiupjzQwg3QWRhqNaCT/ERLZAbMhdm
         PEOZAvnvk2IDvYjsXMgnec1uZ0MaXtBfHQNtCgbLAwP9aF5b1NZdYeRKdnMeqr4pMb8p
         WXQgxMdrPy9Z4xZYHEsGpMMYekmizEhf4EEY/19AFo7a5QDmRLe3sfxN/0a6c3o54GpY
         o3C2mR+3tnRz9VY4CAsQqzC1oirygrtrQ/DFalBse7zu6UH0oir3ECgSco/8kff4JHsJ
         lhMyahke4wA8ZxBZSwdN5okQj7eKjyFD58uYe3Adn7ziZLhs1nCB5wDyj49KyxRa6FtD
         81pw==
X-Gm-Message-State: AOAM533PxzIKpKr44wc4mNPQOC5/SaS9qxJvm+lm9CF9Ta9TbIFnXfD2
        CUxXTH8xbN4bgVciYolKB7I=
X-Google-Smtp-Source: ABdhPJzzf7jdviTJjizo7FHVeWLpTUCDtFhwyTDIFvPlOEYiDTx7KqzY21sxZm8QihNrnfChOXsHMw==
X-Received: by 2002:a17:902:be06:b029:e3:7031:bef with SMTP id r6-20020a170902be06b02900e370310befmr13069364pls.19.1615038496990;
        Sat, 06 Mar 2021 05:48:16 -0800 (PST)
Received: from localhost.localdomain ([45.135.186.66])
        by smtp.gmail.com with ESMTPSA id m6sm5687271pff.197.2021.03.06.05.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Mar 2021 05:48:16 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     saeedm@nvidia.com, leon@kernel.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: mellanox: mlx5: fix error return code of mlx5e_stats_flower()
Date:   Sat,  6 Mar 2021 05:47:18 -0800
Message-Id: <20210306134718.17566-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When mlx5e_tc_get_counter() returns NULL to counter or
mlx5_devcom_get_peer_data() returns NULL to peer_esw, no error return 
code of mlx5e_stats_flower() is assigned.
To fix this bug, err is assigned with -EINVAL in these cases.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 0da69b98f38f..1f2c9da7bd35 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4380,8 +4380,10 @@ int mlx5e_stats_flower(struct net_device *dev, struct mlx5e_priv *priv,
 
 	if (mlx5e_is_offloaded_flow(flow) || flow_flag_test(flow, CT)) {
 		counter = mlx5e_tc_get_counter(flow);
-		if (!counter)
+		if (!counter) {
+			err = -EINVAL;
 			goto errout;
+		}
 
 		mlx5_fc_query_cached(counter, &bytes, &packets, &lastuse);
 	}
@@ -4390,8 +4392,10 @@ int mlx5e_stats_flower(struct net_device *dev, struct mlx5e_priv *priv,
 	 * un-offloaded while the other rule is offloaded.
 	 */
 	peer_esw = mlx5_devcom_get_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
-	if (!peer_esw)
+	if (!peer_esw) {
+		err = -EINVAL;
 		goto out;
+	}
 
 	if (flow_flag_test(flow, DUP) &&
 	    flow_flag_test(flow->peer_flow, OFFLOADED)) {
@@ -4400,8 +4404,10 @@ int mlx5e_stats_flower(struct net_device *dev, struct mlx5e_priv *priv,
 		u64 lastuse2;
 
 		counter = mlx5e_tc_get_counter(flow->peer_flow);
-		if (!counter)
+		if (!counter) {
+			err = -EINVAL;
 			goto no_peer_counter;
+		}
 		mlx5_fc_query_cached(counter, &bytes2, &packets2, &lastuse2);
 
 		bytes += bytes2;
-- 
2.17.1

