Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17FE238BD6D
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 06:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239094AbhEUE2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 00:28:47 -0400
Received: from inva020.nxp.com ([92.121.34.13]:47194 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239065AbhEUE21 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 00:28:27 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id C00781A044F;
        Fri, 21 May 2021 06:26:33 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 inva020.eu-rdc02.nxp.com C00781A044F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com;
        s=nselector3; t=1621571193;
        bh=wmrQZJnvsK/YpHBbN6kF1obxIzNuyuELS5e2tkyqutM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IRzCgWWtdd3sK+iReBajEXRlFiXw8++subHGYe3Kt9nZRJLbvQJpgpjY1eNt+k1sM
         Q0keUlyv98f94R9k74AeiwBZlkLoAmNve8zlaX4WcqxBc5TO4RGV0CnvPwVay64+0C
         XfmJrHBYnMo5mEuccTdTXYRJRwec1INQ6KNlDf61lAWVydjmxFoflBmufLNAK+XSzm
         sash822EXdP9OMQkZ+cQE6V8dUL1lhMWktXwgzSGPo4Fy+TE4nmdLMR3rz5B7lT4QN
         /gXxNPF0J5dSuHvD6KZTrK/u5tBz0B+ZrLs7ZmTR16sJbjxH/wajJcESzNyoQ1hvxo
         ZsNEygqUFUmVw==
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 115281A0425;
        Fri, 21 May 2021 06:26:31 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 inva020.eu-rdc02.nxp.com 115281A0425
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 6A538402B0;
        Fri, 21 May 2021 12:26:27 +0800 (+08)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next, v2, 7/7] enetc: support PTP domain timestamp conversion
Date:   Fri, 21 May 2021 12:36:19 +0800
Message-Id: <20210521043619.44694-8-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210521043619.44694-1-yangbo.lu@nxp.com>
References: <20210521043619.44694-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support timestamp conversion to specified PTP domain in PTP packet.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
Changes for v2:
	- Fixed build waring.
	- Updated copyright.
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 39 ++++++++++++++++++--
 1 file changed, 35 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 3ca93adb9662..cd0429c73999 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
-/* Copyright 2017-2019 NXP */
+/* Copyright 2017-2021 NXP */
 
 #include "enetc.h"
 #include <linux/bpf_trace.h>
@@ -7,6 +7,7 @@
 #include <linux/udp.h>
 #include <linux/vmalloc.h>
 #include <linux/ptp_classify.h>
+#include <linux/ptp_clock_kernel.h>
 #include <net/pkt_sched.h>
 
 static int enetc_num_stack_tx_queues(struct enetc_ndev_priv *priv)
@@ -472,13 +473,36 @@ static void enetc_get_tx_tstamp(struct enetc_hw *hw, union enetc_tx_bd *txbd,
 	*tstamp = (u64)hi << 32 | tstamp_lo;
 }
 
-static void enetc_tstamp_tx(struct sk_buff *skb, u64 tstamp)
+static int enetc_ptp_parse_domain(struct sk_buff *skb, u8 *domain)
+{
+	unsigned int ptp_class;
+	struct ptp_header *hdr;
+
+	ptp_class = ptp_classify_raw(skb);
+	if (ptp_class == PTP_CLASS_NONE)
+		return -EINVAL;
+
+	hdr = ptp_parse_header(skb, ptp_class);
+	if (!hdr)
+		return -EINVAL;
+
+	*domain = hdr->domain_number;
+	return 0;
+}
+
+static void enetc_tstamp_tx(struct enetc_ndev_priv *priv, struct sk_buff *skb,
+			    u64 tstamp)
 {
 	struct skb_shared_hwtstamps shhwtstamps;
+	u64 ts = tstamp;
+	u8 domain;
 
 	if (skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS) {
+		if (!enetc_ptp_parse_domain(skb, &domain))
+			ptp_clock_domain_tstamp(priv->ptp_dev, &ts, domain);
+
 		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
-		shhwtstamps.hwtstamp = ns_to_ktime(tstamp);
+		shhwtstamps.hwtstamp = ns_to_ktime(ts);
 		skb_txtime_consumed(skb);
 		skb_tstamp_tx(skb, &shhwtstamps);
 	}
@@ -575,7 +599,7 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 				 */
 				schedule_work(&priv->tx_onestep_tstamp);
 			} else if (unlikely(do_twostep_tstamp)) {
-				enetc_tstamp_tx(skb, tstamp);
+				enetc_tstamp_tx(priv, skb, tstamp);
 				do_twostep_tstamp = false;
 			}
 			napi_consume_skb(skb, napi_budget);
@@ -698,6 +722,7 @@ static void enetc_get_rx_tstamp(struct net_device *ndev,
 	struct enetc_hw *hw = &priv->si->hw;
 	u32 lo, hi, tstamp_lo;
 	u64 tstamp;
+	u8 domain;
 
 	if (le16_to_cpu(rxbd->r.flags) & ENETC_RXBD_FLAG_TSTMP) {
 		lo = enetc_rd_reg_hot(hw->reg + ENETC_SICTR0);
@@ -708,6 +733,12 @@ static void enetc_get_rx_tstamp(struct net_device *ndev,
 			hi -= 1;
 
 		tstamp = (u64)hi << 32 | tstamp_lo;
+
+		skb_reset_mac_header(skb);
+
+		if (!enetc_ptp_parse_domain(skb, &domain))
+			ptp_clock_domain_tstamp(priv->ptp_dev, &tstamp, domain);
+
 		memset(shhwtstamps, 0, sizeof(*shhwtstamps));
 		shhwtstamps->hwtstamp = ns_to_ktime(tstamp);
 	}
-- 
2.25.1

