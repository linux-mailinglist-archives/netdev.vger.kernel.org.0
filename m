Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15ADC139196
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 14:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgAMNCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 08:02:53 -0500
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:56766 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726505AbgAMNCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 08:02:53 -0500
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id C5545C05D0;
        Mon, 13 Jan 2020 13:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1578920572; bh=bjsugJXpoh9gzcAjdUQ3cVUezQOFhoojeDQOsagF9zw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=acBTZXU1AEDhKGfH3xSIjJ854J5wmdNoXDmQxDMuWCI8sUbVsC+dQYVa3m90CJsxZ
         RRIxIxwYiHoJWjntzzK3kQgGJqUeNFi+WsCYO+rg5uKvF2pn5xF5m0HjayL44/HAkH
         13YWKcghHtt8isMR+g+0NhpPIsUxjkpZCzbha1VgOUrZLlKXAyH4b0DjJzMuks/JU7
         qFJVnlFnvHif9c6lEnQlVn0NCDX9CRAPnwx9aTxpnE+PFvyWaQP5OTm02AzkLUW7M9
         tNzBgG3YPMC+PQEagD30xU9jQ3yL1drcRXgZ6b37pVMXcsMZ9S2vJkEGSLqFeNJDPU
         GmGPKLCPFLtsQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 8B15DA007E;
        Mon, 13 Jan 2020 13:02:50 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 8/8] net: stmmac: selftests: Add a test for TBS feature
Date:   Mon, 13 Jan 2020 14:02:43 +0100
Message-Id: <1b6c8e386ac74978c18201b9a11f4ed10ecfc89a.1578920367.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1578920366.git.Jose.Abreu@synopsys.com>
References: <cover.1578920366.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1578920366.git.Jose.Abreu@synopsys.com>
References: <cover.1578920366.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new test for TBS feature which is used in ETF scheduler. In this
test, we send a packet with a launch time specified as now + 500ms and
check if the packet was transmitted on that time frame.

Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c | 73 ++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index d50ae59fe3d8..7cc59e66e42a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -14,6 +14,7 @@
 #include <linux/phy.h>
 #include <linux/udp.h>
 #include <net/pkt_cls.h>
+#include <net/pkt_sched.h>
 #include <net/tcp.h>
 #include <net/udp.h>
 #include <net/tc_act/tc_gact.h>
@@ -50,6 +51,7 @@ struct stmmac_packet_attrs {
 	u8 id;
 	int sarc;
 	u16 queue_mapping;
+	u64 timestamp;
 };
 
 static u8 stmmac_test_next_id;
@@ -208,6 +210,9 @@ static struct sk_buff *stmmac_test_get_udp_skb(struct stmmac_priv *priv,
 	skb->pkt_type = PACKET_HOST;
 	skb->dev = priv->dev;
 
+	if (attr->timestamp)
+		skb->tstamp = ns_to_ktime(attr->timestamp);
+
 	return skb;
 }
 
@@ -1723,6 +1728,70 @@ static int stmmac_test_sph(struct stmmac_priv *priv)
 	return 0;
 }
 
+static int stmmac_test_tbs(struct stmmac_priv *priv)
+{
+#define STMMAC_TBS_LT_OFFSET		(500 * 1000 * 1000) /* 500 ms*/
+	struct stmmac_packet_attrs attr = { };
+	struct tc_etf_qopt_offload qopt;
+	u64 start_time, curr_time = 0;
+	unsigned long flags;
+	int ret, i;
+
+	if (!priv->hwts_tx_en)
+		return -EOPNOTSUPP;
+
+	/* Find first TBS enabled Queue, if any */
+	for (i = 0; i < priv->plat->tx_queues_to_use; i++)
+		if (priv->tx_queue[i].tbs_avail)
+			break;
+
+	if (i >= priv->plat->tx_queues_to_use || !priv->tx_queue[i].tbs_avail)
+		return -EOPNOTSUPP;
+
+	qopt.enable = true;
+	qopt.queue = i;
+
+	ret = stmmac_tc_setup_etf(priv, priv, &qopt);
+	if (ret)
+		return ret;
+
+	spin_lock_irqsave(&priv->ptp_lock, flags);
+	stmmac_get_systime(priv, priv->ptpaddr, &curr_time);
+	spin_unlock_irqrestore(&priv->ptp_lock, flags);
+
+	if (!curr_time) {
+		ret = -EOPNOTSUPP;
+		goto fail_disable;
+	}
+
+	start_time = curr_time;
+	curr_time += STMMAC_TBS_LT_OFFSET;
+
+	attr.dst = priv->dev->dev_addr;
+	attr.timestamp = curr_time;
+	attr.timeout = nsecs_to_jiffies(2 * STMMAC_TBS_LT_OFFSET);
+	attr.queue_mapping = i;
+
+	pr_info("%s: start_time=0x%lld\n", __func__, start_time);
+	ret = __stmmac_test_loopback(priv, &attr);
+	if (ret)
+		goto fail_disable;
+
+	/* Check if expected time has elapsed */
+	spin_lock_irqsave(&priv->ptp_lock, flags);
+	stmmac_get_systime(priv, priv->ptpaddr, &curr_time);
+	spin_unlock_irqrestore(&priv->ptp_lock, flags);
+
+	pr_info("%s: curr_time=0x%lld\n", __func__, curr_time);
+	if ((curr_time - start_time) < STMMAC_TBS_LT_OFFSET)
+		ret = -EINVAL;
+
+fail_disable:
+	qopt.enable = false;
+	stmmac_tc_setup_etf(priv, priv, &qopt);
+	return ret;
+}
+
 #define STMMAC_LOOPBACK_NONE	0
 #define STMMAC_LOOPBACK_MAC	1
 #define STMMAC_LOOPBACK_PHY	2
@@ -1856,6 +1925,10 @@ static const struct stmmac_test {
 		.name = "Split Header               ",
 		.lb = STMMAC_LOOPBACK_PHY,
 		.fn = stmmac_test_sph,
+	}, {
+		.name = "TBS (ETF Scheduler)        ",
+		.lb = STMMAC_LOOPBACK_PHY,
+		.fn = stmmac_test_tbs,
 	},
 };
 
-- 
2.7.4

