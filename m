Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE1E1AAEB2
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 18:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410430AbgDOQr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 12:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1416247AbgDOQq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 12:46:57 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FCFC061A0C
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 09:46:56 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id p1so536135plq.6
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 09:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=3+cY7c915DQ6khdbvK3zJY/puy4ZsV+5U/U95SO/wlY=;
        b=et8gadLfqvivJBeMdCZ2u7qPu3EYMS7mmqh+WcMmRmyrVQ2tyUtu/SamoqMy5UNbGy
         2bwhlAFkjXB4vKWjGI38K6Uylk46M/gEJDFn1Oj9AabiQmNBzEA6TO/zpAcEXLZ+gVjI
         MEGAi7qayD7t6jTI2R5d1L6rmCFawyM5+EhjNM6QoK03H1Ra+mJLbVXb5yWIwAPlbHzh
         GdH1qmyl8mzzqPTmUZ5nqRIuabLVqyNE31iswLZiM4J54csyhZlsvvpIG38ilGw/1m70
         vD77f6ycKW2sJgWBO/M7wbcM5MUdpr8DkBYzfq9vJlgwJhzjMTHw6WLGtuYZxbiK6Iab
         mcNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=3+cY7c915DQ6khdbvK3zJY/puy4ZsV+5U/U95SO/wlY=;
        b=dt9yUaln8thayNsiX6dUH6Lk+jGarlqUP7y+hd+iMEY0hB0cZXKIqgkIVGlI+1vAC1
         f/p5Vz/gukq6233WFtpQZoCgjLOM8gl7BISASdCJonaMDTs5vsYkH/Do9Sm3mnnObLTB
         bKL309Ji+7goNTWPJV5+Rp3jlXqjFDdGTEecigJUtlwlU9PSTGaF/O+4AYqdZQlKPhRs
         zWp3oUq+pRRVXPm+4MtbyMaibg1DYsgY92GcAZUs3Kv1MnupY+nidcBKs8UTFcnKGC/T
         mrPVHcAfKYPxlxvfhvK+QN3KyKgfYDdm8JEPy/UER/srBgz1I6mW04it2gB79LCe+Zn+
         jZQA==
X-Gm-Message-State: AGi0Pub2bP1CZJLkHUcL8kR1G7qYSEAdh9JO9D3Sx1Qq/aVX57q7cm2S
        +Imja6tIrNIH4tWnB7g8Pj6ML9CU4TOHHw==
X-Google-Smtp-Source: APiQypJgLlmmmZvrWgLm0waa74tdnmo9CGnQBWazoKE9xTdXN8GJ3oEWM8uYzj7qYzL2wk9SbUKjBw+pl44ODQ==
X-Received: by 2002:a17:90b:3444:: with SMTP id lj4mr113797pjb.37.1586969215453;
 Wed, 15 Apr 2020 09:46:55 -0700 (PDT)
Date:   Wed, 15 Apr 2020 09:46:52 -0700
Message-Id: <20200415164652.68245-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.0.110.g2183baf09c-goog
Subject: [PATCH net-next] net/mlx4_en: avoid indirect call in TX completion
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 9ecc2d86171a ("net/mlx4_en: add xdp forwarding and data write support")
brought another indirect call in fast path.

Use INDIRECT_CALL_2() helper to avoid the cost of the indirect call
when/if CONFIG_RETPOLINE=y

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Tariq Toukan <tariqt@mellanox.com>
Cc: Willem de Bruijn <willemb@google.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_tx.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index 4d5ca302c067126b8627cb4809485b45c10e2460..a30edb436f4af11526e04c09623840288ebe4a29 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -43,6 +43,7 @@
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <linux/moduleparam.h>
+#include <linux/indirect_call_wrapper.h>
 
 #include "mlx4_en.h"
 
@@ -261,6 +262,10 @@ static void mlx4_en_stamp_wqe(struct mlx4_en_priv *priv,
 	}
 }
 
+INDIRECT_CALLABLE_DECLARE(u32 mlx4_en_free_tx_desc(struct mlx4_en_priv *priv,
+						   struct mlx4_en_tx_ring *ring,
+						   int index, u64 timestamp,
+						   int napi_mode));
 
 u32 mlx4_en_free_tx_desc(struct mlx4_en_priv *priv,
 			 struct mlx4_en_tx_ring *ring,
@@ -329,6 +334,11 @@ u32 mlx4_en_free_tx_desc(struct mlx4_en_priv *priv,
 	return tx_info->nr_txbb;
 }
 
+INDIRECT_CALLABLE_DECLARE(u32 mlx4_en_recycle_tx_desc(struct mlx4_en_priv *priv,
+						      struct mlx4_en_tx_ring *ring,
+						      int index, u64 timestamp,
+						      int napi_mode));
+
 u32 mlx4_en_recycle_tx_desc(struct mlx4_en_priv *priv,
 			    struct mlx4_en_tx_ring *ring,
 			    int index, u64 timestamp,
@@ -449,7 +459,9 @@ bool mlx4_en_process_tx_cq(struct net_device *dev,
 				timestamp = mlx4_en_get_cqe_ts(cqe);
 
 			/* free next descriptor */
-			last_nr_txbb = ring->free_tx_desc(
+			last_nr_txbb = INDIRECT_CALL_2(ring->free_tx_desc,
+						       mlx4_en_free_tx_desc,
+						       mlx4_en_recycle_tx_desc,
 					priv, ring, ring_index,
 					timestamp, napi_budget);
 
-- 
2.26.0.110.g2183baf09c-goog

