Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82626252F06
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 14:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730049AbgHZMyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 08:54:31 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:44439 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729941AbgHZMy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 08:54:29 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@mellanox.com)
        with SMTP; 26 Aug 2020 15:54:21 +0300
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.234.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 07QCsLG5003731;
        Wed, 26 Aug 2020 15:54:21 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH net-next 3/3] net/mlx4_en: RX, Add a prefetch command for small L1_CACHE_BYTES
Date:   Wed, 26 Aug 2020 15:54:18 +0300
Message-Id: <20200826125418.11379-4-tariqt@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200826125418.11379-1-tariqt@mellanox.com>
References: <20200826125418.11379-1-tariqt@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A single cacheline might not contain the packet header for
small L1_CACHE_BYTES values.
Use net_prefetch() as it issues an additional prefetch
in this case.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index b50c567ef508..99d7737e8ad6 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -705,7 +705,7 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 
 		frags = ring->rx_info + (index << priv->log_rx_info);
 		va = page_address(frags[0].page) + frags[0].page_offset;
-		prefetchw(va);
+		net_prefetchw(va);
 		/*
 		 * make sure we read the CQE after we read the ownership bit
 		 */
-- 
2.21.0

