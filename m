Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB743EACC0
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 23:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238058AbhHLVnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 17:43:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:53918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234075AbhHLVnN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 17:43:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20D1E6109F;
        Thu, 12 Aug 2021 21:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628804567;
        bh=FDGPQNmkcRz+DxpsoVR3+WzeTBNFDfe6SaMpF2iQ3FU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FuiNfKznlumwLgv5WE1DhjTer43i4subffegp6IGbFIdhCemUGOmY7dszl1zxEhsz
         nN7Akb2Jl4lROW6wQC/Hf/SnE0PdVVfKiEAIannC2/+oW/zldDLIkUZD7p3e6Wm5pw
         HEf5oM4A2y8z9J/X1uN6Cx4o/kFvbDnp/+gdtNbr3Pl/n8ZHfbsvzkdfcS7laooLQZ
         YEVi5aGqVpd2aa6Z5W9o3RUg3hf+mAXfg5iAFPnNfaaHJu07ei3YbLEud8dGGDBreD
         qV9o6BqiL9lnv7Goahzs5iA2d3hpPG8P2ddTSotvw5nkQiOCI3pQow4GLcoWgHXa2c
         zTePQQvBuv+Rw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com,
        prashant@broadcom.com, eddie.wai@broadcom.com,
        huangjw@broadcom.com, gospo@broadcom.com, edwin.peer@broadcom.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v3 4/4] bnxt: count Tx drops
Date:   Thu, 12 Aug 2021 14:42:42 -0700
Message-Id: <20210812214242.578039-5-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210812214242.578039-1-kuba@kernel.org>
References: <20210812214242.578039-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drivers should count packets they are dropping.

Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 389016ea65cf..dd2d2a5fef15 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -412,6 +412,7 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	i = skb_get_queue_mapping(skb);
 	if (unlikely(i >= bp->tx_nr_rings)) {
 		dev_kfree_skb_any(skb);
+		atomic_long_inc(&dev->tx_dropped);
 		return NETDEV_TX_OK;
 	}
 
@@ -687,6 +688,7 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (txr->kick_pending)
 		bnxt_txr_db_kick(bp, txr, txr->tx_prod);
 	txr->tx_buf_ring[txr->tx_prod].skb = NULL;
+	atomic_long_inc(&dev->tx_dropped);
 	return NETDEV_TX_OK;
 }
 
-- 
2.31.1

