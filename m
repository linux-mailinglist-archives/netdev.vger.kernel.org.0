Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 098785B49B5
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 23:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbiIJVWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 17:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiIJVVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 17:21:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B1244D170;
        Sat, 10 Sep 2022 14:18:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C160E60E86;
        Sat, 10 Sep 2022 21:18:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F263DC433B5;
        Sat, 10 Sep 2022 21:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844697;
        bh=LiI4v9vBPc7mLT6eREo4zXLAyk3E8pYsOLWHLK96i/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IoPjhHHBgDKQv+O7iiVxbQ/YWZFv05Z4tFwxfrnCvVAlSoDC1nWy29jSMs6Y+Q008
         a+tYRC2+XmeEQeOIKfK49hCfCFJi0tgHZyiVmeChHYHptWFdIa0eb7XIg8Pco5nabi
         2w7R2dTgScNKH0GMFeudzY/YZp7pg1f1mAHhg6PAozCa0VBhYm+11G3MmwZtNoHxGX
         SrOix6hzlujYdXShXubUhae6JtMb46G/VkLP7uUHqv/xpQ+0E4kOUQbPZXqvlL7bJt
         +q0nRrvTKzHoTgMKm+C96BWUQ/g11Wuhze2c0f8cEPRUCjWWsFXhmsSu3Un6m3SdR3
         iT3vgvXHPRWtg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li Qiong <liqiong@nfschina.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, varkabhadram@gmail.com,
        alex.aring@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 14/21] ieee802154: cc2520: add rc code in cc2520_tx()
Date:   Sat, 10 Sep 2022 17:17:45 -0400
Message-Id: <20220910211752.70291-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220910211752.70291-1-sashal@kernel.org>
References: <20220910211752.70291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Li Qiong <liqiong@nfschina.com>

[ Upstream commit ffd7bdddaab193c38416fd5dd416d065517d266e ]

The rc code is 0 at the error path "status & CC2520_STATUS_TX_UNDERFLOW".
Assign rc code with '-EINVAL' at this error path to fix it.

Signed-off-by: Li Qiong <liqiong@nfschina.com>
Link: https://lore.kernel.org/r/20220829071259.18330-1-liqiong@nfschina.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/cc2520.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ieee802154/cc2520.c b/drivers/net/ieee802154/cc2520.c
index 89c046b204e0c..4517517215f2b 100644
--- a/drivers/net/ieee802154/cc2520.c
+++ b/drivers/net/ieee802154/cc2520.c
@@ -504,6 +504,7 @@ cc2520_tx(struct ieee802154_hw *hw, struct sk_buff *skb)
 		goto err_tx;
 
 	if (status & CC2520_STATUS_TX_UNDERFLOW) {
+		rc = -EINVAL;
 		dev_err(&priv->spi->dev, "cc2520 tx underflow exception\n");
 		goto err_tx;
 	}
-- 
2.35.1

