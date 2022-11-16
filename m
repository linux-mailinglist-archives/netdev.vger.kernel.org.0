Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1B8962B77C
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 11:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiKPKQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 05:16:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiKPKQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 05:16:21 -0500
X-Greylist: delayed 484 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 16 Nov 2022 02:16:20 PST
Received: from forward102j.mail.yandex.net (forward102j.mail.yandex.net [5.45.198.243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 083321162
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 02:16:19 -0800 (PST)
Received: from myt6-265321db07ea.qloud-c.yandex.net (myt6-265321db07ea.qloud-c.yandex.net [IPv6:2a02:6b8:c12:2626:0:640:2653:21db])
        by forward102j.mail.yandex.net (Yandex) with ESMTP id 088D74BE8949;
        Wed, 16 Nov 2022 13:08:13 +0300 (MSK)
Received: by myt6-265321db07ea.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id 7MrG7c1Z7t-8BWKF2aq;
        Wed, 16 Nov 2022 13:08:12 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1668593292;
        bh=kdaDzxfYDv3GBYVHVMGCcNxtk7neJ5xD8h4TT/+emMQ=;
        h=Message-Id:Date:Cc:Subject:To:From;
        b=m0NyKTaKO16jULYUT55xjeSTJEODYu95RV5UFOeIyPo4Gj8ZjQZmhGxyF1Tpd7td2
         vfYztBqQRLH3I+A9VtJFcT/Ggfx3klKSIes+Pk7fmMBBXacbN3ZIqyWZPjyFX7kb+4
         s5tnD5RSBYrjVaVfO9FzivCJISpWQBC7Nje2+uhA=
Authentication-Results: myt6-265321db07ea.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
From:   Peter Kosyh <pkosyh@yandex.ru>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     Peter Kosyh <pkosyh@yandex.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: [PATCH net v2] net/mlx4: Check retval of mlx4_bitmap_init
Date:   Wed, 16 Nov 2022 13:08:06 +0300
Message-Id: <20221116100806.226699-1-pkosyh@yandex.ru>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

Signed-off-by: Peter Kosyh <pkosyh@yandex.ru>

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
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

