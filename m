Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCCA4B9286
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 21:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232560AbiBPUik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 15:38:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231636AbiBPUih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 15:38:37 -0500
Received: from smtp.smtpout.orange.fr (smtp10.smtpout.orange.fr [80.12.242.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C622AF3D2
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 12:38:24 -0800 (PST)
Received: from pop-os.home ([90.126.236.122])
        by smtp.orange.fr with ESMTPA
        id KR40nslflEuQ2KR41nMhWF; Wed, 16 Feb 2022 21:38:23 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Wed, 16 Feb 2022 21:38:23 +0100
X-ME-IP: 90.126.236.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Subject: [PATCH] net: nixge: Use GFP_KERNEL instead of GFP_ATOMIC when possible
Date:   Wed, 16 Feb 2022 21:38:11 +0100
Message-Id: <28d2c8e05951ad02a57eb48333672947c8bb4f81.1645043881.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NIXGE_MAX_JUMBO_FRAME_SIZE is over 9000 bytes and RX_BD_NUM 128.

So this loop allocates more than 1 Mo of memory.

Previous memory allocations in this function already use GFP_KERNEL, so
use __netdev_alloc_skb_ip_align() and an explicit GFP_KERNEL instead of a
implicit GFP_ATOMIC.

This gives more opportunities of successful allocation.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/ni/nixge.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
index 07a00dd9cfe0..4b3482ce90a1 100644
--- a/drivers/net/ethernet/ni/nixge.c
+++ b/drivers/net/ethernet/ni/nixge.c
@@ -324,8 +324,9 @@ static int nixge_hw_dma_bd_init(struct net_device *ndev)
 					 + sizeof(*priv->rx_bd_v) *
 					 ((i + 1) % RX_BD_NUM));
 
-		skb = netdev_alloc_skb_ip_align(ndev,
-						NIXGE_MAX_JUMBO_FRAME_SIZE);
+		skb = __netdev_alloc_skb_ip_align(ndev,
+						  NIXGE_MAX_JUMBO_FRAME_SIZE,
+						  GFP_KERNEL);
 		if (!skb)
 			goto out;
 
-- 
2.32.0

