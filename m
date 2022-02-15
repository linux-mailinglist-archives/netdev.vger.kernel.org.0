Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDEFF4B6395
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 07:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234528AbiBOGdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 01:33:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234460AbiBOGdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 01:33:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C555ABBE0E
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 22:32:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7BEC9B81678
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 06:32:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCBB9C340EC;
        Tue, 15 Feb 2022 06:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644906764;
        bh=5UH7/m4pb3ZVfEozoD+dfgALZoKi32j5fyqTrK308fM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A4Ui3YI1kvE9v44mgDmyLgrPBWOWg5NuYMz3HNkD3vuyhzpoUMs3DZK3gXqs6kpOY
         oePE60U5zVigA1rw3xZcC8pnyJStxnkvFVRIEJGOH2HbS630+izSTGBIX9kTJS+M8l
         9+oiJag4gfqyygy+rNFkI8i9Zgq8cY1GxRxAfI0X+mXcl0lI/7PW1bwddyRX4t9Ewg
         47x4HKYdUnhkfzJSI2OsnWMW9Vt7oTFxDyo66SHNMcWvRMbtaig7rNMxxQu00GfshP
         z/Hp28sEwi/nMBDmxjqjtg2fXigoK5QWtcnK2RzcHIAbhEBnq8YD4plDHTT5DrA4NX
         CwN+aftM6za6A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 15/15] net/mlx5e: Optimize the common case condition in mlx5e_select_queue
Date:   Mon, 14 Feb 2022 22:32:29 -0800
Message-Id: <20220215063229.737960-16-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215063229.737960-1-saeed@kernel.org>
References: <20220215063229.737960-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

Check all booleans for special queues at once, when deciding whether to
go to the fast path in mlx5e_select_queue. Pack them into bitfields to
have some room for extensibility.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/selq.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c b/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
index 667bc95a0d44..d98a277eb7f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
@@ -12,8 +12,13 @@ struct mlx5e_selq_params {
 	unsigned int num_regular_queues;
 	unsigned int num_channels;
 	unsigned int num_tcs;
-	bool is_htb;
-	bool is_ptp;
+	union {
+		u8 is_special_queues;
+		struct {
+			bool is_htb : 1;
+			bool is_ptp : 1;
+		};
+	};
 };
 
 int mlx5e_selq_init(struct mlx5e_selq *selq, struct mutex *state_lock)
@@ -164,7 +169,7 @@ u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
 	if (unlikely(!selq))
 		return 0;
 
-	if (likely(!selq->is_ptp && !selq->is_htb)) {
+	if (likely(!selq->is_special_queues)) {
 		/* No special queues, netdev_pick_tx returns one of the regular ones. */
 
 		txq_ix = netdev_pick_tx(dev, skb, NULL);
-- 
2.34.1

