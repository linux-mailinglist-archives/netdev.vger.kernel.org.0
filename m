Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5544241E59F
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 02:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351093AbhJAAyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 20:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349760AbhJAAyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 20:54:37 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CBFC06176A
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 17:52:54 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id me3-20020a17090b17c300b0019f44d2e401so3971444pjb.5
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 17:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CXjBna4HYl4iHw62ZyeTaK7T4OPPc9zVEwlUvVwTzN8=;
        b=JpdkIOLNQxCMLgSt8tjmrDbvWvWAgV8QHlmK5j0BACWuUl3J923Dpt8VC4x2n0nf4N
         zjDVDymAr+kSA9joyv/ZopjNUVFZ6wjk2XPbfk2E2VETWyqDiWulmAVljTFBoGXW1Hb4
         Zn/VCdVObug/DkzkkQde3sdxBdNWDF/lC/ipKUKzE0G+R3CWEw66yHVkCB7/rb1q1ra6
         GOxJCW43zr6S/TFbimbFLPaGn7C7jSFlh7hC21SZp8Ul/0G+0o6YfLJwz15cfLrS16WZ
         +LHJ6kHqXye4+ULUTc9I0vvkfntoF5/XSuiIIAqntCJx91HuSvdmqrqEYhzwaa/xaJhR
         X20w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CXjBna4HYl4iHw62ZyeTaK7T4OPPc9zVEwlUvVwTzN8=;
        b=Spj+isSRy0POaOrjgG6Zq/vAH9FMvIe2H7bfzg1sA9g3CgWcyEQXHxcIKemAQaQIRs
         7isF9Xpivu1sBH8n/uLut4BFG/2MB6SPjgxqKrB4dDPugCzt3+aWq2e3tF5byN72nYHg
         mnffBkC14cdrnBO66t2JZCtCy9naykY3LIjmfX9OC0xhqVoZDNq/5WMRHQTiBVLgZvuo
         JyZBjGrZ7q6/5UCCfhDWwWkXcLGXhtw3p6UFOCTtAkdTibLWXZriuAGgIsfm919ROvYj
         4CrCBT9o6dMcMlk1lB1/wxT+TdQ+GhZsMbOIiAUngIG55NZERVgO7EsIP1s0W3/dY/QH
         kJ5Q==
X-Gm-Message-State: AOAM533ZF1pd8TrFUt3j9ugWojhIGyfA9YsW7GhIGhjdXmUZXzPDOy6a
        1r8zBnYaIXkmGBlx/9uaUqI=
X-Google-Smtp-Source: ABdhPJxasZFak1nYcypIdGoqAtoF0zi9RkKZ5kYf5KxMEQ0qhcfQYq1ugAUm/C7Eo48skbeIMGx4oQ==
X-Received: by 2002:a17:90b:3b8b:: with SMTP id pc11mr9912682pjb.180.1633049573504;
        Thu, 30 Sep 2021 17:52:53 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:b59b:abc0:171:fe0e])
        by smtp.gmail.com with ESMTPSA id m1sm4397425pfc.183.2021.09.30.17.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 17:52:53 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH V2 net-next] net/mlx4_en: avoid one cache line miss to ring doorbell
Date:   Thu, 30 Sep 2021 17:52:49 -0700
Message-Id: <20211001005249.3945672-1-eric.dumazet@gmail.com>
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
V2: added __iomem attribute to remove sparse errors (Jakub)

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
index ad0a8b488832c8cdca2790e47fc778fe15686f7f..e132ff4c82f2d33045f6c9aeecaaa409a41e0b0d 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -283,6 +283,7 @@ struct mlx4_en_tx_ring {
 	struct mlx4_bf		bf;
 
 	/* Following part should be mostly read */
+	void __iomem		*doorbell_address;
 	__be32			doorbell_qpn;
 	__be32			mr_key;
 	u32			size; /* number of TXBBs */
-- 
2.33.0.800.g4c38ced690-goog

