Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 528DA3E9A74
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 23:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232282AbhHKVio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 17:38:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:34636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232194AbhHKVih (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 17:38:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51632610A4;
        Wed, 11 Aug 2021 21:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628717892;
        bh=kjx6Pvr5fISUXR8WW/cPxePudW9lAKXpLS65VFngd3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eaoVDLhoTXZsHY2fglhJoiFE0qmkpUSkIYizFIdhlOBf5mmP+Wz4YsB4/jcf7EfsJ
         hKZRYEYfPraQSyc0oJPgGrXgmGsga1OHsdcNTZi7jhxwd3A5O8ix6+EGLaRRThCOlB
         0zODKR0sPMLa2L71GjWIT6Sf8AUscJjqpVWMLh/PKApDmx1eyAcvtDwp0m5LmbHGai
         dcV1aleUFGl6qM4YnDPfpE5Jj3sHnw4yLbeW5C6TO60i+mDGipZaoU/GhR8Vc7daw1
         LYXYOpQTt9xRCYG4UoHfk0NvcQIm4r+Q0lozofyqw5d7+ytNyJon0W7+ZtSRSID/RC
         nDFpZCANmO70A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     michael.chan@broadcom.com, huangjw@broadcom.com,
        eddie.wai@broadcom.com, prashant@broadcom.com, gospo@broadcom.com,
        netdev@vger.kernel.org, edwin.peer@broadcom.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2 4/4] bnxt: count Tx drops
Date:   Wed, 11 Aug 2021 14:37:49 -0700
Message-Id: <20210811213749.3276687-5-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210811213749.3276687-1-kuba@kernel.org>
References: <20210811213749.3276687-1-kuba@kernel.org>
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
index 79bbd6ec7ef7..642d7aa4676e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -394,6 +394,7 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	i = skb_get_queue_mapping(skb);
 	if (unlikely(i >= bp->tx_nr_rings)) {
 		dev_kfree_skb_any(skb);
+		atomic_long_inc(&dev->tx_dropped);
 		return NETDEV_TX_OK;
 	}
 
@@ -674,6 +675,7 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	tx_buf->skb = NULL;
 	if (txr->kick_pending)
 		bnxt_txr_db_kick(bp, txr, txr->tx_prod);
+	atomic_long_inc(&dev->tx_dropped);
 	return NETDEV_TX_OK;
 }
 
-- 
2.31.1

