Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 040215F90A4
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231990AbiJIW0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231874AbiJIWZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:25:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE315371B9;
        Sun,  9 Oct 2022 15:18:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57014B80E01;
        Sun,  9 Oct 2022 22:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C03C43470;
        Sun,  9 Oct 2022 22:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353793;
        bh=JF8IQTbsC6N87DfSyshxttKLI6W3enf94RRTRa+ZpgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LZy3QzGIMiu8ZAJAi7TxAe5/gqojCl/CImR4eiJFchIzbUIj4PirGLhRwAQkm6fV8
         Kqh0Uj2YQv2AzrTARzHDolz8migIyNqGgPb5Xg16AvCmZJ7A6TlsLOPjiexwNL3aKP
         7koj8XAfZgRtrckbBMFxemQxFi8RKyXxdtZETEuBDssOGy8IKhcCCtJwBv2TJMEUIq
         BVh1GuDxdKc6tyURG6d3TDvlSsRIzjMKWa7BBnCVeSaSiplGPKRo/JG74BvlyxN6l1
         blD0wlVFdBAIUy5F/CCAo36KdSeyZVyDFhd3BSVmzBCatTCtK/mrU6MAq/Ii+LRqYp
         1s4GOpCtqnbpg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     GUO Zihua <guozihua@huawei.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, wellslutw@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 27/73] net: sunplus: Fix return type for implementation of ndo_start_xmit
Date:   Sun,  9 Oct 2022 18:14:05 -0400
Message-Id: <20221009221453.1216158-27-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009221453.1216158-1-sashal@kernel.org>
References: <20221009221453.1216158-1-sashal@kernel.org>
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
index 3773ce5e12cc..dbbb3727040f 100644
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

