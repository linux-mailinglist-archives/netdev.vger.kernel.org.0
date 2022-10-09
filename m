Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDB55F9226
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233016AbiJIWqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232359AbiJIWof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:44:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CBE642ADE;
        Sun,  9 Oct 2022 15:23:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3417C60C2E;
        Sun,  9 Oct 2022 22:21:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99B0C433D7;
        Sun,  9 Oct 2022 22:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354114;
        bh=KWPK2MnRKXZeRFuCu81J/mBsA7ZnHbQLErCv5OnMa0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lKabvF/JNJ0BynUu0+qyW7J+H1Pm6DbJ4Hp9/Xo0w6UQg9i81gVfmFCBP96cR23l0
         Wl3HLJYag1WVZ0IfwMx67B5Gy//zCS9Ou6hjmd4Yc/JYl2LUrpqlb8T7vkoGFtT8WY
         NiIswNvBnkhq4+f0BpaxAIQb+j0cDM7+b8zt7fhlszKBEQoOZfLBXYkEc2S7xVXLFA
         sL48PVJOiLQie8TbevNMAi4NHhGqAqfUJWN0BOajOCIP59Y2lr/qUNOjbMrQ+EENH3
         dsZYqK/WxZFhi8y8H+HxTcA7nT/BWMiljuaAaO0rorssiAmwV5R7gG/nCpxm194mJN
         qWksN3cTd/+Ew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     GUO Zihua <guozihua@huawei.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, khalasa@piap.pl,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 10/34] net: xscale: Fix return type for implementation of ndo_start_xmit
Date:   Sun,  9 Oct 2022 18:21:04 -0400
Message-Id: <20221009222129.1218277-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009222129.1218277-1-sashal@kernel.org>
References: <20221009222129.1218277-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: GUO Zihua <guozihua@huawei.com>

[ Upstream commit 0dbaf0fa62329d9fe452d9041a707a33f6274f1f ]

Since Linux now supports CFI, it will be a good idea to fix mismatched
return type for implementation of hooks. Otherwise this might get
cought out by CFI and cause a panic.

eth_xmit() would return either NETDEV_TX_BUSY or NETDEV_TX_OK, so
change the return type to netdev_tx_t directly.

Signed-off-by: GUO Zihua <guozihua@huawei.com>
Link: https://lore.kernel.org/r/20220902081612.60405-1-guozihua@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index 403358f2c853..5775e58b0745 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -820,7 +820,7 @@ static void eth_txdone_irq(void *unused)
 	}
 }
 
-static int eth_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t eth_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct port *port = netdev_priv(dev);
 	unsigned int txreadyq = port->plat->txreadyq;
-- 
2.35.1

