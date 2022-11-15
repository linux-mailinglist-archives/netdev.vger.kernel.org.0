Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33471629527
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 11:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232812AbiKOKCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 05:02:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbiKOKCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 05:02:02 -0500
X-Greylist: delayed 453 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 15 Nov 2022 02:02:00 PST
Received: from forward104p.mail.yandex.net (forward104p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b7:107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5DB20377
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 02:02:00 -0800 (PST)
Received: from sas1-78334f65778a.qloud-c.yandex.net (sas1-78334f65778a.qloud-c.yandex.net [IPv6:2a02:6b8:c08:b21f:0:640:7833:4f65])
        by forward104p.mail.yandex.net (Yandex) with ESMTP id 008AA3C207C1;
        Tue, 15 Nov 2022 12:54:24 +0300 (MSK)
Received: by sas1-78334f65778a.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id N6VIN3dRC5-sMVmkSKg;
        Tue, 15 Nov 2022 12:54:23 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1668506063;
        bh=csrMCDhcVipZ3JOaVIjEpST6t87payJn+IVfN6W6VtU=;
        h=Message-Id:Date:Cc:Subject:To:From;
        b=fB3R86rRrn+1K8q3V0U9cRsfcB0ojmBP6CvBOdcCPj9H7ZNZkfPckL6UdANmPCZc3
         /JH/j6KdkoAMnTT289ZCqe9pjGknMZAzr1IOxSndQbbmru1U+tYbSzPqqFIULbVUxz
         U83dKuWGgtNrO9vKnKeEkfYzdEDCV00jlr/CsTQ8=
Authentication-Results: sas1-78334f65778a.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
From:   Peter Kosyh <pkosyh@yandex.ru>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     Peter Kosyh <pkosyh@yandex.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: [PATCH] net/mlx4: Check retval of mlx4_bitmap_init
Date:   Tue, 15 Nov 2022 12:53:56 +0300
Message-Id: <20221115095356.157451-1-pkosyh@yandex.ru>
X-Mailer: git-send-email 2.38.1
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

