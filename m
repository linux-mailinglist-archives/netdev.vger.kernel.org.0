Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C21315F9323
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233938AbiJIW4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233906AbiJIWyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:54:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D281A30F42;
        Sun,  9 Oct 2022 15:29:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94ACB60C9B;
        Sun,  9 Oct 2022 22:27:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1344FC43143;
        Sun,  9 Oct 2022 22:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354442;
        bh=6pXatSmbyDtqd6YOeUxy2HdOBNYXNZb/IiZmzN8QFVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o8HW5hMLu9Cqk1Vrc5Wvx+6AeSZMJTB699qE+bgmuZsCFZJr8K5ueAU7hN9scdUER
         emK8OgEz2+FgfsFDOthKvIecoHhPY7mficlHWB6zVwYcyNm11Ci2cf0tPlWxJx3ki1
         1W5ASwrW1VLFM+EEXdsTr7FeFr062f5tMZ/NVLRyLdf95dxUx+js4VfcvUmhvvwlv+
         D/UqYo3FYm+j7mLGfQ100Qsdgl8r0MmbkJx6UvBbXvlAo/Ia8oeCl08yFIWO1gTBCX
         F4LHWZL/+bDOXTuWpx70GUjS/atPGSYp579M8K4Vvm3OHT3k/LvmkOWqirjUNKZlwf
         1P27JPyY8nAmQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     GUO Zihua <guozihua@huawei.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, khalasa@piap.pl,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 05/16] net: xscale: Fix return type for implementation of ndo_start_xmit
Date:   Sun,  9 Oct 2022 18:27:01 -0400
Message-Id: <20221009222713.1220394-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009222713.1220394-1-sashal@kernel.org>
References: <20221009222713.1220394-1-sashal@kernel.org>
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
index fa32391720fe..62fcdf75a011 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -835,7 +835,7 @@ static void eth_txdone_irq(void *unused)
 	}
 }
 
-static int eth_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t eth_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct port *port = netdev_priv(dev);
 	unsigned int txreadyq = port->plat->txreadyq;
-- 
2.35.1

