Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBC8634F39
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 05:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234023AbiKWEzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 23:55:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235631AbiKWEzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 23:55:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 552B0E068F
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 20:55:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7D2761A3F
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 04:55:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 742C2C433C1;
        Wed, 23 Nov 2022 04:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669179313;
        bh=6CAc1aB4SiA6zhOk/Kz3HDG8f5FhnlI/f0cCxc8NxSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j+ilqJgfqJZgTQRN/wlcl/GjHmiPkET6zmlnVzVywt4Krmgp61jF2k7Zt6se47ged
         Jx1yxwwyIqMJcuwUf/yymgntXA7LuqxxsJOVnTRHIckNmxd7+Jdfuqc4AADU9ef2Yx
         bOXWv0D6DJ/5kzaEPddWEAmxMnO1I9XGnqj3BANUmuHeZDk8PtISnwhY6JnPyX/114
         lp/niz3SCAdJ5Ipd86R+LdyQBWYxZNGaYoj3PsFl7zx924g22ffILVjURBV10z6R/r
         V7xGSXUepvU6CUkBGRrUZGUT8Rnyqh3KdblSJOVVcduZDkqS5mla3NW01FSRqnRhLh
         UxuJPM71wPHyA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        uwe@kleine-koenig.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Subject: [PATCH net-next v2 05/12] nfc: microread: Convert to i2c's .probe_new()
Date:   Tue, 22 Nov 2022 20:55:00 -0800
Message-Id: <20221123045507.2091409-6-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123045507.2091409-1-kuba@kernel.org>
References: <20221123045507.2091409-1-kuba@kernel.org>
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

The probe function doesn't make use of the i2c_device_id * parameter so it
can be trivially converted.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/nfc/microread/i2c.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/microread/i2c.c b/drivers/nfc/microread/i2c.c
index 5eaa18f81355..e72b358a2a12 100644
--- a/drivers/nfc/microread/i2c.c
+++ b/drivers/nfc/microread/i2c.c
@@ -231,8 +231,7 @@ static const struct nfc_phy_ops i2c_phy_ops = {
 	.disable = microread_i2c_disable,
 };
 
-static int microread_i2c_probe(struct i2c_client *client,
-			       const struct i2c_device_id *id)
+static int microread_i2c_probe(struct i2c_client *client)
 {
 	struct microread_i2c_phy *phy;
 	int r;
@@ -287,7 +286,7 @@ static struct i2c_driver microread_i2c_driver = {
 	.driver = {
 		.name = MICROREAD_I2C_DRIVER_NAME,
 	},
-	.probe		= microread_i2c_probe,
+	.probe_new	= microread_i2c_probe,
 	.remove		= microread_i2c_remove,
 	.id_table	= microread_i2c_id,
 };
-- 
2.38.1

