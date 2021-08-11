Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB27E3E98CF
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 21:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbhHKTdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 15:33:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:37306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231154AbhHKTdG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 15:33:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FB3360E78;
        Wed, 11 Aug 2021 19:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628710362;
        bh=yRxR9zVxzDiH4C30JlrCZffn221Wwn2jJAMg7a3QOR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qq7RSKYweqgpV5WcY72CukfkSU8azFVJSMGEGiw0OagzR5hgs9p5P85D3yfA+SKpi
         L68XjwLrqQUpF/QJtZixOciUgbiZHYqrkX799rwvEc2E/pknmDJpJ7Zq/kGoSKCPS9
         d/fH2oZvItyUZqUBd+6hbHc8h1GOFT1Jp+KtGELjNO2SIAnOAvE2e59AjLwTKRuqcQ
         W6Li7exBJlhTrchhrAGKuvJxvezX3+xhD6gpaiq55+F2w9EFGdqqgoF3uphxhu/fYD
         /5usfs/9W2AN5YAkHc7MwWJV7TLP861VR4tZWm388ZfV6PoP0g1JbDYz2NmzORFsCn
         ro0A4u0gb4nGQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     michael.chan@broadcom.com, huangjw@broadcom.com,
        eddie.wai@broadcom.com, prashant@broadcom.com, gospo@broadcom.com,
        netdev@vger.kernel.org, edwin.peer@broadcom.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 4/4] bnxt: count Tx drops
Date:   Wed, 11 Aug 2021 12:32:39 -0700
Message-Id: <20210811193239.3155396-5-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210811193239.3155396-1-kuba@kernel.org>
References: <20210811193239.3155396-1-kuba@kernel.org>
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
index b80ed556c28b..d5049e714c94 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -393,6 +393,7 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	i = skb_get_queue_mapping(skb);
 	if (unlikely(i >= bp->tx_nr_rings)) {
 		dev_kfree_skb_any(skb);
+		atomic_long_inc(&dev->tx_dropped);
 		return NETDEV_TX_OK;
 	}
 
@@ -673,6 +674,7 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	tx_buf->skb = NULL;
 	if (txr->kick_pending)
 		bnxt_txr_db_kick(bp, txr, prod);
+	atomic_long_inc(&dev->tx_dropped);
 	return NETDEV_TX_OK;
 }
 
-- 
2.31.1

