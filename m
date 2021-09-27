Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D259C418DF5
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 05:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbhI0Dgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 23:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231892AbhI0Dgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Sep 2021 23:36:51 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA8BC061575;
        Sun, 26 Sep 2021 20:35:14 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id k23so11467466pji.0;
        Sun, 26 Sep 2021 20:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m5WZR48joH/DWIfUQt3Hj/snlovzm3leyn1lmRhg9Lw=;
        b=dFTPmmsXNA/a6MEeNigL/5ywUT5tdtMx+y1xbDJoryTtV7kexubc+zCL84/XjCm4u/
         DQyB2ALmI2GvQSAfp9NQzsawiPMi+JI6/PUGV/YcT4zb7VR3GeKbxhIbMNR88IOBNCha
         JMvXp6eKW8eOoF0M/xANxOh67IFtE8QgLjg/GZx4rc+1+cy0uJ6DQnbv57agYQVqW0dE
         lnj/vKeIRedjQdHFkHKxat0WdjUUQ6wcctjETycumsgHrxTdpWbw1ZxfQ8+UA9e44ujK
         Dc55ycm+CLyFOHleTNhwiqWWV9TkWUV9jOAhshbz2xW5la2onp4OAOkb9ILEDXre2r2c
         PiCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m5WZR48joH/DWIfUQt3Hj/snlovzm3leyn1lmRhg9Lw=;
        b=NV6pQI8emlBCOBi7RG1yLInvlYf9SqGoggMIbWfAtbqZt2v87WcNIbLrCeauo8DFEo
         9ZrtsdKCxOamKPC7vqi5lTplIoO2dMVIPK0loJy14dXdYRnxldsEwV8Aqd1+NZYiYmW2
         P/Ep+r8aJwCZDqTxVmBSWpklfoQ+9G2gCaqGqEPdhw2uRahlpRAgd5xjKUME/qDW41eK
         tgk23neYfO2TPN2I4/++NdCaMQCjrw7fIAsKD77jpbdePaZFMfFBGKliMuVBNpGxnCCO
         +VicGKbgfZjrD8Nl9J5ajCtTixBw6aIQG4HKXK5EP+PoyO8HTGaMGo1M/6e5ov9fQc5o
         0yog==
X-Gm-Message-State: AOAM533oAAP+xatL6BAHOCODqMWUpxQaiVkaS/eN2+hirvnazOp/RYPF
        TXhPmG/sRTVQ48wqWd3KcmboejsQN2CC/DoZ
X-Google-Smtp-Source: ABdhPJzbYff7CI1vCp8skAgZ2uT+hAYeyl8COT3SM9aXHaTe6Wt5be8QriWyZwCovv7bAqJapbbtLw==
X-Received: by 2002:a17:90a:ba14:: with SMTP id s20mr17492220pjr.20.1632713713597;
        Sun, 26 Sep 2021 20:35:13 -0700 (PDT)
Received: from localhost.localdomain ([210.99.160.97])
        by smtp.googlemail.com with ESMTPSA id r206sm1404320pfc.218.2021.09.26.20.35.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Sep 2021 20:35:13 -0700 (PDT)
From:   MichelleJin <shjy180909@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, johannes@sipsolutions.net
Cc:     saeedm@nvidia.com, leon@kernel.org, roid@nvidia.com,
        paulb@nvidia.com, ozsh@nvidia.com, lariel@nvidia.com,
        cmi@nvidia.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH net-next v4 1/3] net/mlx5e: check return value of rhashtable_init
Date:   Mon, 27 Sep 2021 03:34:55 +0000
Message-Id: <20210927033457.1020967-2-shjy180909@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210927033457.1020967-1-shjy180909@gmail.com>
References: <20210927033457.1020967-1-shjy180909@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When rhashtable_init() fails, it returns -EINVAL.
However, since error return value of rhashtable_init is not checked,
it can cause use of uninitialized pointers.
So, fix unhandled errors of rhashtable_init.

Signed-off-by: MichelleJin <shjy180909@gmail.com>
---

v1->v2:
 - change commit message
 - fix unneeded destroying of ht
v2->v3:
 - nothing changed
v3->v4:
 - nothing changed

 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 6c949abcd2e1..225748a9e52a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -2127,12 +2127,20 @@ mlx5_tc_ct_init(struct mlx5e_priv *priv, struct mlx5_fs_chains *chains,
 
 	ct_priv->post_act = post_act;
 	mutex_init(&ct_priv->control_lock);
-	rhashtable_init(&ct_priv->zone_ht, &zone_params);
-	rhashtable_init(&ct_priv->ct_tuples_ht, &tuples_ht_params);
-	rhashtable_init(&ct_priv->ct_tuples_nat_ht, &tuples_nat_ht_params);
+	if (rhashtable_init(&ct_priv->zone_ht, &zone_params))
+		goto err_ct_zone_ht;
+	if (rhashtable_init(&ct_priv->ct_tuples_ht, &tuples_ht_params))
+		goto err_ct_tuples_ht;
+	if (rhashtable_init(&ct_priv->ct_tuples_nat_ht, &tuples_nat_ht_params))
+		goto err_ct_tuples_nat_ht;
 
 	return ct_priv;
 
+err_ct_tuples_nat_ht:
+	rhashtable_destroy(&ct_priv->ct_tuples_ht);
+err_ct_tuples_ht:
+	rhashtable_destroy(&ct_priv->zone_ht);
+err_ct_zone_ht:
 err_ct_nat_tbl:
 	mlx5_chains_destroy_global_table(chains, ct_priv->ct);
 err_ct_tbl:
-- 
2.25.1

