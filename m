Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C78F168CE9
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 15:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732556AbfGONyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 09:54:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732127AbfGONyn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 09:54:43 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7200C21530;
        Mon, 15 Jul 2019 13:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563198882;
        bh=LaQblhdiV7y0KVA9JzhqcAZ/O1ITWftSFhPSvbzR3lI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GjFfH8ZgUP70jN866EcrL1/2ObMtZGscCpjPzpZLcNHlzupA+oKIXoMjd8U7OHeC7
         RznY8N959qXuRzKyDc0i+sXZpVjuDGMHzqypsJhOUlBpM72gqUQiK/4/DBIzE/p7ka
         QOxwickRCTxp+bNaxB3hMtyJ6LritbBplEgo5bQk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 127/249] net: netsec: initialize tx ring on ndo_open
Date:   Mon, 15 Jul 2019 09:44:52 -0400
Message-Id: <20190715134655.4076-127-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilias Apalodimas <ilias.apalodimas@linaro.org>

[ Upstream commit 39e3622edeffa63c2871153d8743c5825b139968 ]

Since we changed the Tx ring handling and now depends on bit31 to figure
out the owner of the descriptor, we should initialize this every time
the device goes down-up instead of doing it once on driver init. If the
value is not correctly initialized the device won't have any available
descriptors

Changes since v1:
- Typo fixes

Fixes: 35e07d234739 ("net: socionext: remove mmio reads on Tx")
Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/socionext/netsec.c | 32 ++++++++++++++-----------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index cba5881b2746..a10ef700f16d 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -1029,7 +1029,6 @@ static void netsec_free_dring(struct netsec_priv *priv, int id)
 static int netsec_alloc_dring(struct netsec_priv *priv, enum ring_id id)
 {
 	struct netsec_desc_ring *dring = &priv->desc_ring[id];
-	int i;
 
 	dring->vaddr = dma_alloc_coherent(priv->dev, DESC_SZ * DESC_NUM,
 					  &dring->desc_dma, GFP_KERNEL);
@@ -1040,19 +1039,6 @@ static int netsec_alloc_dring(struct netsec_priv *priv, enum ring_id id)
 	if (!dring->desc)
 		goto err;
 
-	if (id == NETSEC_RING_TX) {
-		for (i = 0; i < DESC_NUM; i++) {
-			struct netsec_de *de;
-
-			de = dring->vaddr + (DESC_SZ * i);
-			/* de->attr is not going to be accessed by the NIC
-			 * until netsec_set_tx_de() is called.
-			 * No need for a dma_wmb() here
-			 */
-			de->attr = 1U << NETSEC_TX_SHIFT_OWN_FIELD;
-		}
-	}
-
 	return 0;
 err:
 	netsec_free_dring(priv, id);
@@ -1060,6 +1046,23 @@ static int netsec_alloc_dring(struct netsec_priv *priv, enum ring_id id)
 	return -ENOMEM;
 }
 
+static void netsec_setup_tx_dring(struct netsec_priv *priv)
+{
+	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_TX];
+	int i;
+
+	for (i = 0; i < DESC_NUM; i++) {
+		struct netsec_de *de;
+
+		de = dring->vaddr + (DESC_SZ * i);
+		/* de->attr is not going to be accessed by the NIC
+		 * until netsec_set_tx_de() is called.
+		 * No need for a dma_wmb() here
+		 */
+		de->attr = 1U << NETSEC_TX_SHIFT_OWN_FIELD;
+	}
+}
+
 static int netsec_setup_rx_dring(struct netsec_priv *priv)
 {
 	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_RX];
@@ -1361,6 +1364,7 @@ static int netsec_netdev_open(struct net_device *ndev)
 
 	pm_runtime_get_sync(priv->dev);
 
+	netsec_setup_tx_dring(priv);
 	ret = netsec_setup_rx_dring(priv);
 	if (ret) {
 		netif_err(priv, probe, priv->ndev,
-- 
2.20.1

