Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68C30632CD5
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 20:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbiKUTQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 14:16:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbiKUTQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 14:16:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A103B66CAD
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 11:15:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 505A4B815D8
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 19:15:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D980AC43148;
        Mon, 21 Nov 2022 19:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669058150;
        bh=iVpNL4ZdQVbg5k5TiocvWucQSS530ONdakGLBRKiBjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZijP+883nyhD1bGJr9T85BiWwPn5UNr+beonUDy2biARMOg0w8UZtgSL9TEWXt5Dv
         WSW6vubx8UbsQDZjlBEuIQzAL4NLOp4/r+DbjaAIoOhI7jwG3QdKGdGaXgIdYa0KN9
         3SYj4R6w626kmHLE0LzMsDes6ArgH6PFC5On6nG1ONMMLuBxEN+PsgIcTeCMJTF012
         6cX1xhAha1ZtzZXJgFuV0xXdIWuIPc+UqQGh8ahaB8rIWSZp3YeZi2oYAPVAgUKF4c
         5l//fBL1KxE7waz+JWBjWjXaXDAATOe4NZbke2iyh2MPHHGLBoVQLEUy3LY9BGvt4K
         ulAzdXC4ekUiA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        uwe@kleine-koenig.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 04/12] net/mlxsw: Convert to i2c's .probe_new()
Date:   Mon, 21 Nov 2022 11:15:38 -0800
Message-Id: <20221121191546.1853970-5-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221121191546.1853970-1-kuba@kernel.org>
References: <20221121191546.1853970-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

.probe_new() doesn't get the i2c_device_id * parameter, so determine
that explicitly in the probe function.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/i2c.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/i2c.c b/drivers/net/ethernet/mellanox/mlxsw/i2c.c
index f5f5f8dc3d19..2c586c2308ae 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/i2c.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/i2c.c
@@ -632,9 +632,9 @@ static const struct mlxsw_bus mlxsw_i2c_bus = {
 	.cmd_exec		= mlxsw_i2c_cmd_exec,
 };
 
-static int mlxsw_i2c_probe(struct i2c_client *client,
-			   const struct i2c_device_id *id)
+static int mlxsw_i2c_probe(struct i2c_client *client)
 {
+	const struct i2c_device_id *id = i2c_client_get_device_id(client);
 	const struct i2c_adapter_quirks *quirks = client->adapter->quirks;
 	struct mlxsw_i2c *mlxsw_i2c;
 	u8 status;
@@ -751,7 +751,7 @@ static void mlxsw_i2c_remove(struct i2c_client *client)
 
 int mlxsw_i2c_driver_register(struct i2c_driver *i2c_driver)
 {
-	i2c_driver->probe = mlxsw_i2c_probe;
+	i2c_driver->probe_new = mlxsw_i2c_probe;
 	i2c_driver->remove = mlxsw_i2c_remove;
 	return i2c_add_driver(i2c_driver);
 }
-- 
2.38.1

