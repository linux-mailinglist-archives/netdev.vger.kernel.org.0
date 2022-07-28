Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD88584734
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 22:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbiG1UrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 16:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232622AbiG1Uq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 16:46:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 447EA69F25
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 13:46:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EECBAB82433
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 20:46:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C964C433C1;
        Thu, 28 Jul 2022 20:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659041212;
        bh=QymjzhlEytB2mFhWj2DsC2zVWpoGqzSXxhiVVDayyhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iD/iliDzPHj0bjyhC/24pl86qFjbzTowUYc8x/YuOTffMFMv1RnimRmVftBx1xM6X
         YMDuhYoECHAoEgDl1yP/VJIYB/8CDBOMfltWmq9HCsX/8wJGaHYux7S21XpWZZWdhh
         eaNgtPOUmQGD6+z41+w/0TWE6yOGA+gJuxLfpKfKArHVBGIlXdD5JwkMPlXBholTZO
         S+yP/QSyzox3CXtcY9yJx25hlF4Q5LDqXpmJXjeXFy9pAn+7jkmBCqdEqI1CCYpQ2K
         /P9r2unyGzHB37qMQqhdnCrLLfVdY4ENcanCrHCg9XKN2WlLCAOvQ5UumuapbUOdMe
         fNIK3WaMwN0SA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [net 1/9] net/mlx5e: Remove WARN_ON when trying to offload an unsupported TLS cipher/version
Date:   Thu, 28 Jul 2022 13:46:32 -0700
Message-Id: <20220728204640.139990-2-saeed@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220728204640.139990-1-saeed@kernel.org>
References: <20220728204640.139990-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gal Pressman <gal@nvidia.com>

The driver reports whether TX/RX TLS device offloads are supported, but
not which ciphers/versions, these should be handled by returning
-EOPNOTSUPP when .tls_dev_add() is called.

Remove the WARN_ON kernel trace when the driver gets a request to
offload a cipher/version that is not supported as it is expected.

Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
index 814f2a56f633..30a70d139046 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
@@ -54,7 +54,7 @@ static int mlx5e_ktls_add(struct net_device *netdev, struct sock *sk,
 	struct mlx5_core_dev *mdev = priv->mdev;
 	int err;
 
-	if (WARN_ON(!mlx5e_ktls_type_check(mdev, crypto_info)))
+	if (!mlx5e_ktls_type_check(mdev, crypto_info))
 		return -EOPNOTSUPP;
 
 	if (direction == TLS_OFFLOAD_CTX_DIR_TX)
-- 
2.37.1

