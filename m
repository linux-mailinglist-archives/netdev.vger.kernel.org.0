Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45D285F8FC0
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbiJIWMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbiJIWLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:11:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 371E23056B;
        Sun,  9 Oct 2022 15:09:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73F7860CBB;
        Sun,  9 Oct 2022 22:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B4BC433C1;
        Sun,  9 Oct 2022 22:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353369;
        bh=CPnKM7zg/5Q/YE8kdmtbxIWQTQQLqgqzifqktpcnhWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FY8nPkOzvz+DEcQ/RLqajGKuMiIiCJ6zKPGSfroW7I2g6hMGtngmv6+uCm2YBsJaT
         Brnj+DIvSc8Mjk/XGP+Dm79yUUGPuA1dnNRU/XjGGft7PRWuPkdwTLe0nTppqP7l6g
         0j2eBNxjIkRSyCC7jINu78VPsVAG15fsZJtnsSu0ZHl8ZWVd8xrxHJVtacs73Li1/j
         iMzezK07XKH8pxBjCpumD7dH4d/A4YF8NU0801x5diBDzb2BBQ5H+vDmEOFx/OIrOS
         e1xAX3squ6a36MDT3+OY2aDzg/tEY6h2RJcMisUWXmJ0/jNNq3x+7nDYdQO1ZKLqXc
         6OAN+v7b697ZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     GUO Zihua <guozihua@huawei.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, wellslutw@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 30/77] net: sunplus: Fix return type for implementation of ndo_start_xmit
Date:   Sun,  9 Oct 2022 18:07:07 -0400
Message-Id: <20221009220754.1214186-30-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009220754.1214186-1-sashal@kernel.org>
References: <20221009220754.1214186-1-sashal@kernel.org>
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

[ Upstream commit 7b620e156097028e4c9b6481a84ec1e1e72877ca ]

Since Linux now supports CFI, it will be a good idea to fix mismatched
return type for implementation of hooks. Otherwise this might get
cought out by CFI and cause a panic.

spl2sw_ethernet_start_xmit() would return either NETDEV_TX_BUSY or
NETDEV_TX_OK, so change the return type to netdev_tx_t directly.

Signed-off-by: GUO Zihua <guozihua@huawei.com>
Link: https://lore.kernel.org/r/20220902081550.60095-1-guozihua@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sunplus/spl2sw_driver.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sunplus/spl2sw_driver.c b/drivers/net/ethernet/sunplus/spl2sw_driver.c
index 546206640492..38e478aa415c 100644
--- a/drivers/net/ethernet/sunplus/spl2sw_driver.c
+++ b/drivers/net/ethernet/sunplus/spl2sw_driver.c
@@ -62,7 +62,8 @@ static int spl2sw_ethernet_stop(struct net_device *ndev)
 	return 0;
 }
 
-static int spl2sw_ethernet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+static netdev_tx_t spl2sw_ethernet_start_xmit(struct sk_buff *skb,
+					      struct net_device *ndev)
 {
 	struct spl2sw_mac *mac = netdev_priv(ndev);
 	struct spl2sw_common *comm = mac->comm;
-- 
2.35.1

