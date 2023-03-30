Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC7B6CFDAB
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 10:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbjC3IEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 04:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbjC3IDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 04:03:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A7F7695
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 01:03:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 683DE61F46
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 08:03:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14321C433EF;
        Thu, 30 Mar 2023 08:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680163403;
        bh=fVGweFyqjjyGxV3P3pNnWhUwVeFFAtoFWV0Vk7hMuhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P4ZWvysSY1C4dkZGy97JquKN3AOyyAK+TuWmw5PjolxXFHHajdPQu2UUHS5MSYILR
         7u7PywlWS/0PhGGJNVJaiXuDmTwgQ9DktGPEIquv8/WiUuwPkWiCkvb3jcB1459xnb
         r+770pI7gVkSRCI2YsNV4V3jmaPmZ3CREs/Hlg4qFF/lFCvlIGpKYZTHuk7ZjThvp2
         Imc5y8fVdC0Wc6szNdF6E3lHexjY05OdtJ0yH+r5nHb+t438+niHfPs5QZgJjcCpqp
         dFzT4fKA/fjJQrryblrT78GzTN24K3vycOh3Cq5i4NC/THejSb0tL2SWg4DB9IYkU5
         BMPMTSSbR9TJg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH net-next 08/10] net/mlx5e: Reduce contention in IPsec workqueue
Date:   Thu, 30 Mar 2023 11:02:29 +0300
Message-Id: <5dc224a4decd09c14f645d38173e1a1710802cd8.1680162300.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1680162300.git.leonro@nvidia.com>
References: <cover.1680162300.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

IPsec workqueue shouldn't be declared as ordered queue with one work
per-CPU, and can be safely changed to be unordered with default number
of works per-CPU.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index b8058f89365e..fa66f4f3cba7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -561,8 +561,8 @@ void mlx5e_ipsec_init(struct mlx5e_priv *priv)
 
 	xa_init_flags(&ipsec->sadb, XA_FLAGS_ALLOC);
 	ipsec->mdev = priv->mdev;
-	ipsec->wq = alloc_ordered_workqueue("mlx5e_ipsec: %s", 0,
-					    priv->netdev->name);
+	ipsec->wq = alloc_workqueue("mlx5e_ipsec: %s", WQ_UNBOUND, 0,
+				    priv->netdev->name);
 	if (!ipsec->wq)
 		goto err_wq;
 
-- 
2.39.2

