Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4D8323CD9
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 14:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234165AbhBXM4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 07:56:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:50150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235195AbhBXMw1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 07:52:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C09C64F0F;
        Wed, 24 Feb 2021 12:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171060;
        bh=IGfOMlUG53o63vW+euXyrD0sQKcMORJ1+ERPMlIBnAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DeXft+YRLe2ZQhbrZ3qdb+nlHav9qseKLDKqRKdFyjjtSQBcYm8EHtuSiWJ4Gcg9F
         iwMgE/38u3Kpz2TOi9TULxPxLdGQMPpv9tl3hNDYWRx5DaHe61zXJyGA0i0QT2agfJ
         E5iiYyDjPiVVfSLSoh4adjuc9ACgkIFCNUP/mGV2nWb/lpSkZnZIF7xyxCnSLHC/q2
         0W4ZFXclGyALbSDTxsM7q5KA2vlvNNUwA0jHrS6OFPOHQ1HSC+nqR0J9GOjM8tVni6
         2X/yqOrx6JzXUN8gzkhfK8ofPIX/kt0MuSvV83cuF7ijMWTldux2amtty4x1RJqnUi
         Ww7msh51eKCLw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vsevolod Kozlov <zaba@mm.st>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 24/67] wilc1000: Fix use of void pointer as a wrong struct type
Date:   Wed, 24 Feb 2021 07:49:42 -0500
Message-Id: <20210224125026.481804-24-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125026.481804-1-sashal@kernel.org>
References: <20210224125026.481804-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vsevolod Kozlov <zaba@mm.st>

[ Upstream commit 6fe91b69ceceea832a73d35185df04b3e877f399 ]

ac_classify() expects a struct sk_buff* as its second argument, which is
a member of struct tx_complete_data. priv happens to be a pointer to
struct tx_complete_data, so passing it directly to ac_classify() leads
to wrong behaviour and occasional panics.

Since there is only one caller of wilc_wlan_txq_add_net_pkt and it
already knows the type behind this pointer, and the structure is already
in the header file, change the function signature to use the real type
instead of void* in order to prevent confusion.

Signed-off-by: Vsevolod Kozlov <zaba@mm.st>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/YCQomJ1mO5BLxYOT@Vsevolods-Mini.lan
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/microchip/wilc1000/netdev.c |  2 +-
 drivers/net/wireless/microchip/wilc1000/wlan.c   | 15 ++++++++-------
 drivers/net/wireless/microchip/wilc1000/wlan.h   |  3 ++-
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.c b/drivers/net/wireless/microchip/wilc1000/netdev.c
index 2a1fbbdd6a4bd..0c188310919e1 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.c
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.c
@@ -737,7 +737,7 @@ netdev_tx_t wilc_mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 
 	vif->netstats.tx_packets++;
 	vif->netstats.tx_bytes += tx_data->size;
-	queue_count = wilc_wlan_txq_add_net_pkt(ndev, (void *)tx_data,
+	queue_count = wilc_wlan_txq_add_net_pkt(ndev, tx_data,
 						tx_data->buff, tx_data->size,
 						wilc_tx_complete);
 
diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index c12f27be9f790..31d51385ba934 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -408,7 +408,8 @@ static inline u8 ac_change(struct wilc *wilc, u8 *ac)
 	return 1;
 }
 
-int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
+int wilc_wlan_txq_add_net_pkt(struct net_device *dev,
+			      struct tx_complete_data *tx_data, u8 *buffer,
 			      u32 buffer_size,
 			      void (*tx_complete_fn)(void *, int))
 {
@@ -420,27 +421,27 @@ int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
 	wilc = vif->wilc;
 
 	if (wilc->quit) {
-		tx_complete_fn(priv, 0);
+		tx_complete_fn(tx_data, 0);
 		return 0;
 	}
 
 	tqe = kmalloc(sizeof(*tqe), GFP_ATOMIC);
 
 	if (!tqe) {
-		tx_complete_fn(priv, 0);
+		tx_complete_fn(tx_data, 0);
 		return 0;
 	}
 	tqe->type = WILC_NET_PKT;
 	tqe->buffer = buffer;
 	tqe->buffer_size = buffer_size;
 	tqe->tx_complete_func = tx_complete_fn;
-	tqe->priv = priv;
+	tqe->priv = tx_data;
 	tqe->vif = vif;
 
-	q_num = ac_classify(wilc, priv);
+	q_num = ac_classify(wilc, tx_data->skb);
 	tqe->q_num = q_num;
 	if (ac_change(wilc, &q_num)) {
-		tx_complete_fn(priv, 0);
+		tx_complete_fn(tx_data, 0);
 		kfree(tqe);
 		return 0;
 	}
@@ -451,7 +452,7 @@ int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
 			tcp_process(dev, tqe);
 		wilc_wlan_txq_add_to_tail(dev, q_num, tqe);
 	} else {
-		tx_complete_fn(priv, 0);
+		tx_complete_fn(tx_data, 0);
 		kfree(tqe);
 	}
 
diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.h b/drivers/net/wireless/microchip/wilc1000/wlan.h
index 3d2104f198192..d55eb6b3a12a9 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.h
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.h
@@ -399,7 +399,8 @@ int wilc_wlan_firmware_download(struct wilc *wilc, const u8 *buffer,
 				u32 buffer_size);
 int wilc_wlan_start(struct wilc *wilc);
 int wilc_wlan_stop(struct wilc *wilc, struct wilc_vif *vif);
-int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
+int wilc_wlan_txq_add_net_pkt(struct net_device *dev,
+			      struct tx_complete_data *tx_data, u8 *buffer,
 			      u32 buffer_size,
 			      void (*tx_complete_fn)(void *, int));
 int wilc_wlan_handle_txq(struct wilc *wl, u32 *txq_count);
-- 
2.27.0

