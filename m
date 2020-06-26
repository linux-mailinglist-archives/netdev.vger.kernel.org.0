Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D27920B87A
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 20:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbgFZSlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 14:41:10 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:6596 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725900AbgFZSlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 14:41:05 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05QIf47M010746;
        Fri, 26 Jun 2020 11:41:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=XzeM9pmjg6yOxXKq+tJP9TUnKltZaAe+/yOSw4CjfXQ=;
 b=RAAi8meubstQXinuhoksmTqkhtfdNJbwIUz3R094g+eCUJ8rPGgkU2IMOjDqX5qijS1n
 03Lk4atqUaXIviLGsHul7z8dEtufh+HJH5awvXGJNWbc6OWoaRWqdqPy0RXNknqXgpFP
 CIB1bvIgyNe2DZ4lx80HTSf/5x28QsN0KPLSpKDQMerXZHfFOoOFY3smzlUi7MvutijX
 cE5BZ0ohbuS1Ap4CWMYpS+Ps9mS9fWeOfP/yQlaeVp18ZsJMdAWsvqXZX1mjCRfRzmfJ
 HhwefPsgKNHevj1t0zFS7C0aqR9lZUDogtRH27US4Q2yLckhZVm3yyWzcTCA1lEjlWSb Aw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 31uuqh5u8k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 26 Jun 2020 11:41:04 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 26 Jun
 2020 11:40:59 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 26 Jun
 2020 11:40:58 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 26 Jun 2020 11:40:58 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id 0FC7D3F703F;
        Fri, 26 Jun 2020 11:40:56 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 8/8] net: atlantic: put ptp code under IS_REACHABLE check
Date:   Fri, 26 Jun 2020 21:40:38 +0300
Message-ID: <20200626184038.857-9-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200626184038.857-1-irusskikh@marvell.com>
References: <20200626184038.857-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_10:2020-06-26,2020-06-26 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A1 requires additional processing for both egress and ingress to support
PTP.
And it makes sense to get rid of this processing altogether (via ifdef),
if PTP clock is disabled globally.

This patch puts the PTP code under the corresponding IS_REACHABLE check.

Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
---
 .../ethernet/aquantia/atlantic/aq_ethtool.c   |  2 ++
 .../net/ethernet/aquantia/atlantic/aq_main.c  | 20 +++++++++++++++----
 .../net/ethernet/aquantia/atlantic/aq_ptp.c   |  9 +++++++--
 .../net/ethernet/aquantia/atlantic/aq_ring.c  |  2 ++
 4 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
index 51dfc12a44be..a8f0fbbbd91a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -607,7 +607,9 @@ static int aq_ethtool_get_ts_info(struct net_device *ndev,
 			    BIT(HWTSTAMP_FILTER_PTP_V2_L2_EVENT) |
 			    BIT(HWTSTAMP_FILTER_PTP_V2_EVENT);
 
+#if IS_REACHABLE(CONFIG_PTP_1588_CLOCK)
 	info->phc_index = ptp_clock_index(aq_ptp_get_ptp_clock(aq_nic->aq_ptp));
+#endif
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index 8a1da044e908..dfb29b933eb7 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -1,7 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/*
- * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
+/* Atlantic Network Driver
+ *
+ * Copyright (C) 2014-2019 aQuantia Corporation
+ * Copyright (C) 2019-2020 Marvell International Ltd.
  */
 
 /* File aq_main.c: Main file for aQuantia Linux driver. */
@@ -98,6 +99,7 @@ static int aq_ndev_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct aq_nic_s *aq_nic = netdev_priv(ndev);
 
+#if IS_REACHABLE(CONFIG_PTP_1588_CLOCK)
 	if (unlikely(aq_utils_obj_test(&aq_nic->flags, AQ_NIC_PTP_DPATH_UP))) {
 		/* Hardware adds the Timestamp for PTPv2 802.AS1
 		 * and PTPv2 IPv4 UDP.
@@ -114,6 +116,7 @@ static int aq_ndev_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		    unlikely(eth_hdr(skb)->h_proto == htons(ETH_P_1588)))
 			return aq_ptp_xmit(aq_nic, skb);
 	}
+#endif
 
 	skb_tx_timestamp(skb);
 	return aq_nic_xmit(aq_nic, skb);
@@ -222,6 +225,7 @@ static void aq_ndev_set_multicast_settings(struct net_device *ndev)
 	(void)aq_nic_set_multicast_list(aq_nic, ndev);
 }
 
+#if IS_REACHABLE(CONFIG_PTP_1588_CLOCK)
 static int aq_ndev_config_hwtstamp(struct aq_nic_s *aq_nic,
 				   struct hwtstamp_config *config)
 {
@@ -256,26 +260,31 @@ static int aq_ndev_config_hwtstamp(struct aq_nic_s *aq_nic,
 
 	return aq_ptp_hwtstamp_config_set(aq_nic->aq_ptp, config);
 }
+#endif
 
 static int aq_ndev_hwtstamp_set(struct aq_nic_s *aq_nic, struct ifreq *ifr)
 {
 	struct hwtstamp_config config;
+#if IS_REACHABLE(CONFIG_PTP_1588_CLOCK)
 	int ret_val;
+#endif
 
 	if (!aq_nic->aq_ptp)
 		return -EOPNOTSUPP;
 
 	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
 		return -EFAULT;
-
+#if IS_REACHABLE(CONFIG_PTP_1588_CLOCK)
 	ret_val = aq_ndev_config_hwtstamp(aq_nic, &config);
 	if (ret_val)
 		return ret_val;
+#endif
 
 	return copy_to_user(ifr->ifr_data, &config, sizeof(config)) ?
 	       -EFAULT : 0;
 }
 
+#if IS_REACHABLE(CONFIG_PTP_1588_CLOCK)
 static int aq_ndev_hwtstamp_get(struct aq_nic_s *aq_nic, struct ifreq *ifr)
 {
 	struct hwtstamp_config config;
@@ -287,6 +296,7 @@ static int aq_ndev_hwtstamp_get(struct aq_nic_s *aq_nic, struct ifreq *ifr)
 	return copy_to_user(ifr->ifr_data, &config, sizeof(config)) ?
 	       -EFAULT : 0;
 }
+#endif
 
 static int aq_ndev_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
 {
@@ -296,8 +306,10 @@ static int aq_ndev_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
 	case SIOCSHWTSTAMP:
 		return aq_ndev_hwtstamp_set(aq_nic, ifr);
 
+#if IS_REACHABLE(CONFIG_PTP_1588_CLOCK)
 	case SIOCGHWTSTAMP:
 		return aq_ndev_hwtstamp_get(aq_nic, ifr);
+#endif
 	}
 
 	return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
index 599ced261b2a..cb9bf41470fd 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* Aquantia Corporation Network Driver
- * Copyright (C) 2014-2019 Aquantia Corporation. All rights reserved
+/* Atlantic Network Driver
+ *
+ * Copyright (C) 2014-2019 aQuantia Corporation
+ * Copyright (C) 2019-2020 Marvell International Ltd.
  */
 
 /* File aq_ptp.c:
@@ -18,6 +20,8 @@
 #include "aq_phy.h"
 #include "aq_filters.h"
 
+#if IS_REACHABLE(CONFIG_PTP_1588_CLOCK)
+
 #define AQ_PTP_TX_TIMEOUT        (HZ *  10)
 
 #define POLL_SYNC_TIMER_MS 15
@@ -1389,3 +1393,4 @@ static void aq_ptp_poll_sync_work_cb(struct work_struct *w)
 		schedule_delayed_work(&aq_ptp->poll_sync, timeout);
 	}
 }
+#endif
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index b67b24a0d9a6..8dd59e9fc3aa 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -490,6 +490,7 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 
 void aq_ring_hwts_rx_clean(struct aq_ring_s *self, struct aq_nic_s *aq_nic)
 {
+#if IS_REACHABLE(CONFIG_PTP_1588_CLOCK)
 	while (self->sw_head != self->hw_head) {
 		u64 ns;
 
@@ -501,6 +502,7 @@ void aq_ring_hwts_rx_clean(struct aq_ring_s *self, struct aq_nic_s *aq_nic)
 
 		self->sw_head = aq_ring_next_dx(self, self->sw_head);
 	}
+#endif
 }
 
 int aq_ring_rx_fill(struct aq_ring_s *self)
-- 
2.25.1

