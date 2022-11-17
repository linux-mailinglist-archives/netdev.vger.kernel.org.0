Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E00C62DFD1
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 16:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbiKQP2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 10:28:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbiKQP2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 10:28:18 -0500
Received: from forward107p.mail.yandex.net (forward107p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b7:115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3233B200
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 07:28:15 -0800 (PST)
Received: from forward100q.mail.yandex.net (forward100q.mail.yandex.net [IPv6:2a02:6b8:c0e:4b:0:640:4012:bb97])
        by forward107p.mail.yandex.net (Yandex) with ESMTP id 467CD5573722;
        Thu, 17 Nov 2022 18:28:12 +0300 (MSK)
Received: from vla3-23c3b031fed5.qloud-c.yandex.net (vla3-23c3b031fed5.qloud-c.yandex.net [IPv6:2a02:6b8:c15:2582:0:640:23c3:b031])
        by forward100q.mail.yandex.net (Yandex) with ESMTP id 441606F40007;
        Thu, 17 Nov 2022 18:28:12 +0300 (MSK)
Received: by vla3-23c3b031fed5.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id BxffULxHfn-SBVS67PW;
        Thu, 17 Nov 2022 18:28:11 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1668698891;
        bh=Q5sQUBhLocZrlWcp5LysK6gLlppGdh7eBr2MibVK1GQ=;
        h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
        b=EzFO6KJD+KPI+Gft+/VBozmU5DW6vcyyLYfo+Jca37JyIAb3wm9n5x6mKWmg5wa3o
         sS4EP50j9nBSoktrXbcxZW8fJlnNodqXqgvbak5ip5E2CjnQZ0gxx8XpG1tp4o0DWB
         cUnL9q+NbqiKDIo7+jTanxWNOkODvpLaP1jxMimc=
Authentication-Results: vla3-23c3b031fed5.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
From:   Peter Kosyh <pkosyh@yandex.ru>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     Peter Kosyh <pkosyh@yandex.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: [PATCH net v3] net/mlx4: Check retval of mlx4_bitmap_init
Date:   Thu, 17 Nov 2022 18:28:06 +0300
Message-Id: <20221117152806.278072-1-pkosyh@yandex.ru>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <Y3YPV4csGxEJ6uSl@unreal>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If mlx4_bitmap_init fails, mlx4_bitmap_alloc_range will dereference
the NULL pointer (bitmap->table).

Make sure, that mlx4_bitmap_alloc_range called in no error case.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: d57febe1a478 ("net/mlx4: Add A0 hybrid steering")
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Peter Kosyh <pkosyh@yandex.ru>
---
 drivers/net/ethernet/mellanox/mlx4/qp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/qp.c b/drivers/net/ethernet/mellanox/mlx4/qp.c
index b149e601f673..48cfaa7eaf50 100644
--- a/drivers/net/ethernet/mellanox/mlx4/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx4/qp.c
@@ -697,7 +697,8 @@ static int mlx4_create_zones(struct mlx4_dev *dev,
 			err = mlx4_bitmap_init(*bitmap + k, 1,
 					       MLX4_QP_TABLE_RAW_ETH_SIZE - 1, 0,
 					       0);
-			mlx4_bitmap_alloc_range(*bitmap + k, 1, 1, 0);
+			if (!err)
+				mlx4_bitmap_alloc_range(*bitmap + k, 1, 1, 0);
 		}
 
 		if (err)
-- 
2.38.1

