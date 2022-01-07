Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2B5487DB2
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 21:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233037AbiAGUYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 15:24:43 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:14901 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232296AbiAGUYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 15:24:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1641587078; x=1673123078;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AQWZ/bMGbUhtDnt+a2a+lSq3fTKK7Ar20f4is6w/atc=;
  b=t33M34LUjORtSMICHo2L2a70d0t335y0SV8Jd4XNfvSmOl4pWevK0dYC
   TGyYGclebzq33G6S50Q4yrUxrrWGpX9dM7BI7gX57EVh1CoGrBP5ONySI
   JvPxroJhkNw2EIyPgPOLdvmF4AwPfBf4B8UbSzRnmELEm+x785+3VRb6M
   0=;
X-IronPort-AV: E=Sophos;i="5.88,270,1635206400"; 
   d="scan'208";a="168677610"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-204be258.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 07 Jan 2022 20:24:26 +0000
Received: from EX13MTAUEE002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-204be258.us-east-1.amazon.com (Postfix) with ESMTPS id 3949442F7E;
        Fri,  7 Jan 2022 20:24:24 +0000 (UTC)
Received: from EX13D08UEE003.ant.amazon.com (10.43.62.118) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Fri, 7 Jan 2022 20:24:22 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D08UEE003.ant.amazon.com (10.43.62.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Fri, 7 Jan 2022 20:24:22 +0000
Received: from dev-dsk-akiyano-1c-2138b29d.eu-west-1.amazon.com (172.19.83.6)
 by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP Server id
 15.0.1497.26 via Frontend Transport; Fri, 7 Jan 2022 20:24:20 +0000
From:   Arthur Kiyanovski <akiyano@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        Nati Koler <nkoler@amazon.com>
Subject: [PATCH V2 net-next 10/10] net: ena: Extract recurring driver reset code into a function
Date:   Fri, 7 Jan 2022 20:23:46 +0000
Message-ID: <20220107202346.3522-11-akiyano@amazon.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220107202346.3522-1-akiyano@amazon.com>
References: <20220107202346.3522-1-akiyano@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create an inline function for resetting the driver
to reduce code duplication.

Signed-off-by: Nati Koler <nkoler@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 45 ++++++--------------
 drivers/net/ethernet/amazon/ena/ena_netdev.h |  9 ++++
 2 files changed, 23 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 0cc72303a2da..53080fd143dc 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -103,7 +103,7 @@ static void ena_tx_timeout(struct net_device *dev, unsigned int txqueue)
 	if (test_and_set_bit(ENA_FLAG_TRIGGER_RESET, &adapter->flags))
 		return;
 
-	adapter->reset_reason = ENA_REGS_RESET_OS_NETDEV_WD;
+	ena_reset_device(adapter, ENA_REGS_RESET_OS_NETDEV_WD);
 	ena_increase_stat(&adapter->dev_stats.tx_timeout, 1, &adapter->syncp);
 
 	netif_err(adapter, tx_err, dev, "Transmit time out\n");
@@ -166,11 +166,9 @@ static int ena_xmit_common(struct net_device *dev,
 			  "Failed to prepare tx bufs\n");
 		ena_increase_stat(&ring->tx_stats.prepare_ctx_err, 1,
 				  &ring->syncp);
-		if (rc != -ENOMEM) {
-			adapter->reset_reason =
-				ENA_REGS_RESET_DRIVER_INVALID_STATE;
-			set_bit(ENA_FLAG_TRIGGER_RESET, &adapter->flags);
-		}
+		if (rc != -ENOMEM)
+			ena_reset_device(adapter,
+					 ENA_REGS_RESET_DRIVER_INVALID_STATE);
 		return rc;
 	}
 
@@ -1279,10 +1277,8 @@ static int handle_invalid_req_id(struct ena_ring *ring, u16 req_id,
 			  req_id, ring->qid);
 
 	ena_increase_stat(&ring->tx_stats.bad_req_id, 1, &ring->syncp);
+	ena_reset_device(ring->adapter, ENA_REGS_RESET_INV_TX_REQ_ID);
 
-	/* Trigger device reset */
-	ring->adapter->reset_reason = ENA_REGS_RESET_INV_TX_REQ_ID;
-	set_bit(ENA_FLAG_TRIGGER_RESET, &ring->adapter->flags);
 	return -EFAULT;
 }
 
@@ -1445,10 +1441,7 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
 		netif_err(adapter, rx_err, rx_ring->netdev,
 			  "Page is NULL. qid %u req_id %u\n", rx_ring->qid, req_id);
 		ena_increase_stat(&rx_ring->rx_stats.bad_req_id, 1, &rx_ring->syncp);
-		adapter->reset_reason = ENA_REGS_RESET_INV_RX_REQ_ID;
-		/* Make sure reset reason is set before triggering the reset */
-		smp_mb__before_atomic();
-		set_bit(ENA_FLAG_TRIGGER_RESET, &adapter->flags);
+		ena_reset_device(adapter, ENA_REGS_RESET_INV_RX_REQ_ID);
 		return NULL;
 	}
 
@@ -1781,15 +1774,12 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 	if (rc == -ENOSPC) {
 		ena_increase_stat(&rx_ring->rx_stats.bad_desc_num, 1,
 				  &rx_ring->syncp);
-		adapter->reset_reason = ENA_REGS_RESET_TOO_MANY_RX_DESCS;
+		ena_reset_device(adapter, ENA_REGS_RESET_TOO_MANY_RX_DESCS);
 	} else {
 		ena_increase_stat(&rx_ring->rx_stats.bad_req_id, 1,
 				  &rx_ring->syncp);
-		adapter->reset_reason = ENA_REGS_RESET_INV_RX_REQ_ID;
+		ena_reset_device(adapter, ENA_REGS_RESET_INV_RX_REQ_ID);
 	}
-
-	set_bit(ENA_FLAG_TRIGGER_RESET, &adapter->flags);
-
 	return 0;
 }
 
@@ -3707,9 +3697,8 @@ static int check_for_rx_interrupt_queue(struct ena_adapter *adapter,
 		netif_err(adapter, rx_err, adapter->netdev,
 			  "Potential MSIX issue on Rx side Queue = %d. Reset the device\n",
 			  rx_ring->qid);
-		adapter->reset_reason = ENA_REGS_RESET_MISS_INTERRUPT;
-		smp_mb__before_atomic();
-		set_bit(ENA_FLAG_TRIGGER_RESET, &adapter->flags);
+
+		ena_reset_device(adapter, ENA_REGS_RESET_MISS_INTERRUPT);
 		return -EIO;
 	}
 
@@ -3746,9 +3735,7 @@ static int check_missing_comp_in_tx_queue(struct ena_adapter *adapter,
 			netif_err(adapter, tx_err, adapter->netdev,
 				  "Potential MSIX issue on Tx side Queue = %d. Reset the device\n",
 				  tx_ring->qid);
-			adapter->reset_reason = ENA_REGS_RESET_MISS_INTERRUPT;
-			smp_mb__before_atomic();
-			set_bit(ENA_FLAG_TRIGGER_RESET, &adapter->flags);
+			ena_reset_device(adapter, ENA_REGS_RESET_MISS_INTERRUPT);
 			return -EIO;
 		}
 
@@ -3774,9 +3761,7 @@ static int check_missing_comp_in_tx_queue(struct ena_adapter *adapter,
 			  "The number of lost tx completions is above the threshold (%d > %d). Reset the device\n",
 			  missed_tx,
 			  adapter->missing_tx_completion_threshold);
-		adapter->reset_reason =
-			ENA_REGS_RESET_MISS_TX_CMPL;
-		set_bit(ENA_FLAG_TRIGGER_RESET, &adapter->flags);
+		ena_reset_device(adapter, ENA_REGS_RESET_MISS_TX_CMPL);
 		rc = -EIO;
 	}
 
@@ -3897,8 +3882,7 @@ static void check_for_missing_keep_alive(struct ena_adapter *adapter)
 			  "Keep alive watchdog timeout.\n");
 		ena_increase_stat(&adapter->dev_stats.wd_expired, 1,
 				  &adapter->syncp);
-		adapter->reset_reason = ENA_REGS_RESET_KEEP_ALIVE_TO;
-		set_bit(ENA_FLAG_TRIGGER_RESET, &adapter->flags);
+		ena_reset_device(adapter, ENA_REGS_RESET_KEEP_ALIVE_TO);
 	}
 }
 
@@ -3909,8 +3893,7 @@ static void check_for_admin_com_state(struct ena_adapter *adapter)
 			  "ENA admin queue is not in running state!\n");
 		ena_increase_stat(&adapter->dev_stats.admin_q_pause, 1,
 				  &adapter->syncp);
-		adapter->reset_reason = ENA_REGS_RESET_ADMIN_TO;
-		set_bit(ENA_FLAG_TRIGGER_RESET, &adapter->flags);
+		ena_reset_device(adapter, ENA_REGS_RESET_ADMIN_TO);
 	}
 }
 
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 1659f0b6b824..1bdce99bf688 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -394,6 +394,15 @@ int ena_update_queue_count(struct ena_adapter *adapter, u32 new_channel_count);
 
 int ena_get_sset_count(struct net_device *netdev, int sset);
 
+static inline void ena_reset_device(struct ena_adapter *adapter,
+				    enum ena_regs_reset_reason_types reset_reason)
+{
+	adapter->reset_reason = reset_reason;
+	/* Make sure reset reason is set before triggering the reset */
+	smp_mb__before_atomic();
+	set_bit(ENA_FLAG_TRIGGER_RESET, &adapter->flags);
+}
+
 enum ena_xdp_errors_t {
 	ENA_XDP_ALLOWED = 0,
 	ENA_XDP_CURRENT_MTU_TOO_LARGE,
-- 
2.32.0

