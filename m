Return-Path: <netdev+bounces-8656-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EF08725161
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 03:08:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B4D0281068
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 01:08:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71E6B7C;
	Wed,  7 Jun 2023 01:08:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3D5627
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 01:08:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B0FC4339B;
	Wed,  7 Jun 2023 01:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686100108;
	bh=h806LUlShbEMZ6iJ2AKEySQ9iyfzy6Q6qNhuUw6zAeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=atteOfbWZGl/rESSq3vSo81Jr6NbwBTFxxa3GgCONwFAih39oQIkXaVyyK6YPSr+t
	 b0d7MBprknrzYg51H8M1RY4Y3vWVqJ5B3IOM5ZxLKSXcimepXr9ekVTKzp6cbz3iqO
	 qMVW9R6OdCywCMNTUrjS2Z/sAayaDNABmzPWLn25GehXRRSHZE1J9dapY8BjGNb39i
	 Uycy5Gf+z5WDScYal7tugaW7O0nwH7eTuEtYxl/aVLOPbpjHTOUGjmulTJul/k+DQN
	 91dieHtTKhI4LWNRxxSN2ttbftlCq+l0qdyRKsNBikdqkquCRfnbwsIIfe01F+sRVr
	 tUno8E1pRcj5Q==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>,
	jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com
Subject: [PATCH net 2/2] eth: ixgbe: fix the wake condition
Date: Tue,  6 Jun 2023 18:08:26 -0700
Message-Id: <20230607010826.960226-2-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230607010826.960226-1-kuba@kernel.org>
References: <20230607010826.960226-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Flip the netif_carrier_ok() condition in queue wake logic.
When I moved it to inside __netif_txq_completed_wake()
I missed negating it.

This made the condition ineffective and could probably
lead to crashes.

Fixes: 301f227fc860 ("net: piggy back on the memory barrier in bql when waking queues")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: jesse.brandeburg@intel.com
CC: anthony.l.nguyen@intel.com
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 5d83c887a3fc..1726297f2e0d 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -1256,7 +1256,7 @@ static bool ixgbe_clean_tx_irq(struct ixgbe_q_vector *q_vector,
 	if (!__netif_txq_completed_wake(txq, total_packets, total_bytes,
 					ixgbe_desc_unused(tx_ring),
 					TX_WAKE_THRESHOLD,
-					netif_carrier_ok(tx_ring->netdev) &&
+					!netif_carrier_ok(tx_ring->netdev) ||
 					test_bit(__IXGBE_DOWN, &adapter->state)))
 		++tx_ring->tx_stats.restart_queue;
 
-- 
2.40.1


