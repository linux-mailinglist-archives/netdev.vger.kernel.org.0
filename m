Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1778C4D6E09
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 11:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbiCLK2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 05:28:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231720AbiCLK2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 05:28:22 -0500
Received: from mail2-relais-roc.national.inria.fr (mail2-relais-roc.national.inria.fr [192.134.164.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C89A1E6951;
        Sat, 12 Mar 2022 02:27:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=E22sNuoFdaUOS4+WwLkXyv8STbZDc50AAO8Dj225850=;
  b=ihL6XsakQk6+pfogM7zSLsmG19WLigBxJRkJgmSwuffhYtEaSzep0klY
   QFHKPcST9D03gZdcVWLX4I24nZEdikdu/p7Qwm1jDC9aVN85Rpqfphn9T
   A0F3ENhgKUCkb74WcGH1PiiJ8q7akjDZeB8G7aZa7r6B1KBQi0yLCLpQ2
   M=;
Authentication-Results: mail2-relais-roc.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.90,175,1643670000"; 
   d="scan'208";a="25781348"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.90.48])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2022 11:27:11 +0100
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] net/mlx4_en: use kzalloc
Date:   Sat, 12 Mar 2022 11:27:01 +0100
Message-Id: <20220312102705.71413-3-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220312102705.71413-1-Julia.Lawall@inria.fr>
References: <20220312102705.71413-1-Julia.Lawall@inria.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use kzalloc instead of kmalloc + memset.

The semantic patch that makes this change is:
(https://coccinelle.gitlabpages.inria.fr/website/)

//<smpl>
@@
expression res, size, flag;
@@
- res = kmalloc(size, flag);
+ res = kzalloc(size, flag);
  ...
- memset(res, 0, size);
//</smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 drivers/net/ethernet/mellanox/mlx4/en_rx.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 8cfc649f226b..8f762fc170b3 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -1067,7 +1067,7 @@ static int mlx4_en_config_rss_qp(struct mlx4_en_priv *priv, int qpn,
 	struct mlx4_qp_context *context;
 	int err = 0;
 
-	context = kmalloc(sizeof(*context), GFP_KERNEL);
+	context = kzalloc(sizeof(*context), GFP_KERNEL);
 	if (!context)
 		return -ENOMEM;
 
@@ -1078,7 +1078,6 @@ static int mlx4_en_config_rss_qp(struct mlx4_en_priv *priv, int qpn,
 	}
 	qp->event = mlx4_en_sqp_event;
 
-	memset(context, 0, sizeof(*context));
 	mlx4_en_fill_qp_context(priv, ring->actual_size, ring->stride, 0, 0,
 				qpn, ring->cqn, -1, context);
 	context->db_rec_addr = cpu_to_be64(ring->wqres.db.dma);

