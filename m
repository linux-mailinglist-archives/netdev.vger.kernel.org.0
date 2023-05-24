Return-Path: <netdev+bounces-5168-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 315E070FEB6
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 21:49:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A313F1C20C87
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 19:49:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEC8B22611;
	Wed, 24 May 2023 19:49:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECA360862
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 19:49:18 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD91135;
	Wed, 24 May 2023 12:49:17 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id 34C90219A6;
	Wed, 24 May 2023 19:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1684957756; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Oe6PbmV+u0O1cIClXtL/J9wL1QeLe0YddSZe0fda1gI=;
	b=FcQIqFkcUjGOxN14HJUnQV3up919Be3U+MMGnlk6758fwqlx6v5djo7OKFr7AxkVYMAKRq
	SThlNn8xxkzKn32+zXcnuuVjgE5Ir6L8SUdoe3eijtbndMy02zuoAR+BZEaK0ndIepLZlX
	qLD03WyHoYROpAlXF0XuXjNY/TxYgmc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1684957756;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Oe6PbmV+u0O1cIClXtL/J9wL1QeLe0YddSZe0fda1gI=;
	b=G03yMKHGQFbB97ZwrChpX6CxgzePmJ7RdJ1jIXE80oIyib5SunDjvnF/y0euknYcviueAQ
	VmdTZw3Oxhh73TBA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
	by relay2.suse.de (Postfix) with ESMTP id E98D32C141;
	Wed, 24 May 2023 19:49:15 +0000 (UTC)
From: Thomas Bogendoerfer <tbogendoerfer@suse.de>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Asmaa Mnebhi <asmaa@nvidia.com>,
	Liming Sun <limings@nvidia.com>,
	David Thompson <davthompson@nvidia.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 net] net: mellanox: mlxbf_gige: Fix skb_panic splat under memory pressure
Date: Wed, 24 May 2023 21:49:08 +0200
Message-Id: <20230524194908.147145-1-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Do skb_put() after a new skb has been successfully allocated otherwise
the reused skb leads to skb_panics or incorrect packet sizes.

Fixes: f92e1869d74e ("Add Mellanox BlueField Gigabit Ethernet driver")
Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
---
Changes in v2:
- moved skb_put() after dma_unmap_single()
- added Fixes tag
- fixed typos in commit log

 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_rx.c    | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_rx.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_rx.c
index afa3b92a6905..0d5a41a2ae01 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_rx.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_rx.c
@@ -245,12 +245,6 @@ static bool mlxbf_gige_rx_packet(struct mlxbf_gige *priv, int *rx_pkts)
 
 		skb = priv->rx_skb[rx_pi_rem];
 
-		skb_put(skb, datalen);
-
-		skb->ip_summed = CHECKSUM_NONE; /* device did not checksum packet */
-
-		skb->protocol = eth_type_trans(skb, netdev);
-
 		/* Alloc another RX SKB for this same index */
 		rx_skb = mlxbf_gige_alloc_skb(priv, MLXBF_GIGE_DEFAULT_BUF_SZ,
 					      &rx_buf_dma, DMA_FROM_DEVICE);
@@ -259,6 +253,13 @@ static bool mlxbf_gige_rx_packet(struct mlxbf_gige *priv, int *rx_pkts)
 		priv->rx_skb[rx_pi_rem] = rx_skb;
 		dma_unmap_single(priv->dev, *rx_wqe_addr,
 				 MLXBF_GIGE_DEFAULT_BUF_SZ, DMA_FROM_DEVICE);
+
+		skb_put(skb, datalen);
+
+		skb->ip_summed = CHECKSUM_NONE; /* device did not checksum packet */
+
+		skb->protocol = eth_type_trans(skb, netdev);
+
 		*rx_wqe_addr = rx_buf_dma;
 	} else if (rx_cqe & MLXBF_GIGE_RX_CQE_PKT_STATUS_MAC_ERR) {
 		priv->stats.rx_mac_errors++;
-- 
2.35.3


