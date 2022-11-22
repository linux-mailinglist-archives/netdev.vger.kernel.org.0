Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4195633D71
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 14:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbiKVNWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 08:22:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233716AbiKVNV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 08:21:56 -0500
X-Greylist: delayed 518 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 22 Nov 2022 05:21:54 PST
Received: from forward102o.mail.yandex.net (forward102o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::602])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39B163CD8;
        Tue, 22 Nov 2022 05:21:54 -0800 (PST)
Received: from iva6-2d18925256a6.qloud-c.yandex.net (iva6-2d18925256a6.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:7594:0:640:2d18:9252])
        by forward102o.mail.yandex.net (Yandex) with ESMTP id 9B4E06FF8662;
        Tue, 22 Nov 2022 16:04:58 +0300 (MSK)
Received: by iva6-2d18925256a6.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id geBn8MwPXD-4vVS71lp;
        Tue, 22 Nov 2022 16:04:57 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1669122297;
        bh=1cRGGL/kLGljOEZTXyM0po699HUG3YBlqIEPDsuujzc=;
        h=Message-Id:Date:Cc:Subject:To:From;
        b=b7JrSEpOInh+WonMh4KYuKtr+RCXYQmr11SqVgF0VpX2x/dGpgTCFDLGp10MSR5rc
         h7q6QqqatP/BqE3lMaKY8qwocVMs3AL0y8UdIqxZmRcEWnrJtqXhNQiJ7dTfaKCkTo
         m1ZvuaoTl4GXAR1Ae+n3TFPyZT21flE9SJmCP8Wk=
Authentication-Results: iva6-2d18925256a6.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
From:   Peter Kosyh <pkosyh@yandex.ru>
To:     Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Cc:     Peter Kosyh <pkosyh@yandex.ru>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: [PATCH] mlx4: use snprintf() instead of sprintf() for safety
Date:   Tue, 22 Nov 2022 16:04:53 +0300
Message-Id: <20221122130453.730657-1-pkosyh@yandex.ru>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use snprintf() to avoid the potential buffer overflow. Although in the
current code this is hardly possible, the safety is unclean.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Peter Kosyh <pkosyh@yandex.ru>
---
 drivers/net/ethernet/mellanox/mlx4/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index d3fc86cd3c1d..0616d352451b 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -3057,7 +3057,8 @@ static int mlx4_init_port_info(struct mlx4_dev *dev, int port)
 		info->base_qpn = mlx4_get_base_qpn(dev, port);
 	}
 
-	sprintf(info->dev_name, "mlx4_port%d", port);
+	snprintf(info->dev_name, sizeof(info->dev_name),
+		 "mlx4_port%d", port);
 	info->port_attr.attr.name = info->dev_name;
 	if (mlx4_is_mfunc(dev)) {
 		info->port_attr.attr.mode = 0444;
@@ -3077,7 +3078,8 @@ static int mlx4_init_port_info(struct mlx4_dev *dev, int port)
 		return err;
 	}
 
-	sprintf(info->dev_mtu_name, "mlx4_port%d_mtu", port);
+	snprintf(info->dev_mtu_name, sizeof(info->dev_mtu_name),
+		 "mlx4_port%d_mtu", port);
 	info->port_mtu_attr.attr.name = info->dev_mtu_name;
 	if (mlx4_is_mfunc(dev)) {
 		info->port_mtu_attr.attr.mode = 0444;
-- 
2.38.1

