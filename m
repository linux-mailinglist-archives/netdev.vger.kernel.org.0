Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C008F6A3187
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 15:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbjBZO7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 09:59:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbjBZO6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 09:58:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D88C21C7F0;
        Sun, 26 Feb 2023 06:52:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5727EB80C85;
        Sun, 26 Feb 2023 14:51:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12AA4C433EF;
        Sun, 26 Feb 2023 14:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677423116;
        bh=USqgpsnQfhZpd3+9AdfFOzrtKRs5nYEw9de0Pe5OFtA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UsTEAjAokA+uAEahEdC70KfkV56n9VsBJaSJHZrhMqVGSjvKhlLm2VBG7Xlh0K8HB
         ecDoXBrfiufH9nmQNDk8wSv366/WWH/VmJ8n6KDUaebDuN6MCk+CxRASfz8moen+VU
         OxSXx7TeWq6XYUfHdKxvfTP5l1OkfO1y2Cx/r8FRq4ZKYi59cx7YrXusNGraIG4Eaz
         e/PyYnd7nfS3ccOlr94cPkLIVSzdCjRJYbA7r0vfe9J6WUJoOogbmeq+UmLWgdkpSq
         2QOtZdFf2Hz4QR7DCSHNdLhMkUrnl5xJ+8+pZ22ybKPOmD/K4VJ/TW6o5AeULbMIZP
         qdBycKkuinOxw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, opendmb@gmail.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 12/19] net: bcmgenet: Add a check for oversized packets
Date:   Sun, 26 Feb 2023 09:51:14 -0500
Message-Id: <20230226145123.829229-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226145123.829229-1-sashal@kernel.org>
References: <20230226145123.829229-1-sashal@kernel.org>
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

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 5c0862c2c962052ed5055220a00ac1cefb92fbcd ]

Occasionnaly we may get oversized packets from the hardware which
exceed the nomimal 2KiB buffer size we allocate SKBs with. Add an early
check which drops the packet to avoid invoking skb_over_panic() and move
on to processing the next packet.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index e03e2bfcc6a10..1b725a021455b 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1823,6 +1823,14 @@ static unsigned int bcmgenet_desc_rx(struct bcmgenet_rx_ring *ring,
 			  __func__, p_index, ring->c_index,
 			  ring->read_ptr, dma_length_status);
 
+		if (unlikely(len > RX_BUF_LENGTH)) {
+			netif_err(priv, rx_status, dev, "oversized packet\n");
+			dev->stats.rx_length_errors++;
+			dev->stats.rx_errors++;
+			dev_kfree_skb_any(skb);
+			goto next;
+		}
+
 		if (unlikely(!(dma_flag & DMA_EOP) || !(dma_flag & DMA_SOP))) {
 			netif_err(priv, rx_status, dev,
 				  "dropping fragmented packet!\n");
-- 
2.39.0

