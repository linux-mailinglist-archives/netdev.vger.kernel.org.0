Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A60E51395D7
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 17:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbgAMQZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 11:25:03 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:37178 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728851AbgAMQYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 11:24:22 -0500
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id BF727C05DC;
        Mon, 13 Jan 2020 16:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1578932661; bh=QFbAowEgES03c5XYlcvZ5klAPG5SDoJ9C9pBH1nnTfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=jo5rAFMt1qGcknTDOEZyL4jidlTULM8iivZaO6vPh6Ofnv8I0xw5sXsBLIKyK5KSS
         8WrpV8FCrW7TtbVE8nJafDNNiCZBbeXEmoj36VeYhtm0+9mda6S/1x7ACfZ5flD3ch
         R9O/qrtjFuYoSPVc0V5ju4lSkgEH0qcyeFTMRzZxN4BZ1WOgH1HpYeA/zvLGukf35g
         3ClgAkzO0fqQryMNzQaevJzyoS5OdhsYU1WmOU8OxHCrVqORbQF2b+d+4gUhfl0Vqi
         YjVnhF8mx5y5fOx1yo57iINyJqd/m5Fwzie2AofyqqT4+Sw6fd5N0ShciJr9KQcHgT
         9i7vkpdeigDSg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 6797BA0062;
        Mon, 13 Jan 2020 16:24:19 +0000 (UTC)
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
Subject: [PATCH net-next v3 2/8] net: stmmac: tc: Add support for ETF Scheduler using TBS
Date:   Mon, 13 Jan 2020 17:24:10 +0100
Message-Id: <eabd50e0464d13911b5512c9f2e0ed0f3dc7e6ef.1578932287.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1578932287.git.Jose.Abreu@synopsys.com>
References: <cover.1578932287.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1578932287.git.Jose.Abreu@synopsys.com>
References: <cover.1578932287.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds the support for ETF scheduler using TBS feature which is available
in XGMAC and QoS IPs.

Changes from v2:
- Fix checkpatch issues (Jakub)
- Use the TBS bitfield

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
 drivers/net/ethernet/stmicro/stmmac/common.h      |  1 +
 drivers/net/ethernet/stmicro/stmmac/hwif.h        |  5 +++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |  2 ++
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c   | 21 +++++++++++++++++++++
 4 files changed, 29 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 31003b67d24f..487099092693 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -368,6 +368,7 @@ struct dma_features {
 	unsigned int estdep;
 	unsigned int estsel;
 	unsigned int fpesel;
+	unsigned int tbssel;
 };
 
 /* RX Buffer size must be multiple of 4/8/16 bytes */
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 71c23cbd7af8..df63b0367aff 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -533,6 +533,7 @@ struct tc_cls_u32_offload;
 struct tc_cbs_qopt_offload;
 struct flow_cls_offload;
 struct tc_taprio_qopt_offload;
+struct tc_etf_qopt_offload;
 
 struct stmmac_tc_ops {
 	int (*init)(struct stmmac_priv *priv);
@@ -544,6 +545,8 @@ struct stmmac_tc_ops {
 			 struct flow_cls_offload *cls);
 	int (*setup_taprio)(struct stmmac_priv *priv,
 			    struct tc_taprio_qopt_offload *qopt);
+	int (*setup_etf)(struct stmmac_priv *priv,
+			 struct tc_etf_qopt_offload *qopt);
 };
 
 #define stmmac_tc_init(__priv, __args...) \
@@ -556,6 +559,8 @@ struct stmmac_tc_ops {
 	stmmac_do_callback(__priv, tc, setup_cls, __args)
 #define stmmac_tc_setup_taprio(__priv, __args...) \
 	stmmac_do_callback(__priv, tc, setup_taprio, __args)
+#define stmmac_tc_setup_etf(__priv, __args...) \
+	stmmac_do_callback(__priv, tc, setup_etf, __args)
 
 struct stmmac_counters;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index baffb4e8d99a..43af4fc5ab8f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4159,6 +4159,8 @@ static int stmmac_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 		return stmmac_tc_setup_cbs(priv, priv, type_data);
 	case TC_SETUP_QDISC_TAPRIO:
 		return stmmac_tc_setup_taprio(priv, priv, type_data);
+	case TC_SETUP_QDISC_ETF:
+		return stmmac_tc_setup_etf(priv, priv, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 6c4686b77516..a4ce165af36b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -727,10 +727,31 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 	return ret;
 }
 
+static int tc_setup_etf(struct stmmac_priv *priv,
+			struct tc_etf_qopt_offload *qopt)
+{
+	if (!priv->dma_cap.tbssel)
+		return -EOPNOTSUPP;
+	if (qopt->queue >= priv->plat->tx_queues_to_use)
+		return -EINVAL;
+	if (!(priv->tx_queue[qopt->queue].tbs & STMMAC_TBS_AVAIL))
+		return -EINVAL;
+
+	if (qopt->enable)
+		priv->tx_queue[qopt->queue].tbs |= STMMAC_TBS_EN;
+	else
+		priv->tx_queue[qopt->queue].tbs &= ~STMMAC_TBS_EN;
+
+	netdev_info(priv->dev, "%s ETF for Queue %d\n",
+		    qopt->enable ? "enabled" : "disabled", qopt->queue);
+	return 0;
+}
+
 const struct stmmac_tc_ops dwmac510_tc_ops = {
 	.init = tc_init,
 	.setup_cls_u32 = tc_setup_cls_u32,
 	.setup_cbs = tc_setup_cbs,
 	.setup_cls = tc_setup_cls,
 	.setup_taprio = tc_setup_taprio,
+	.setup_etf = tc_setup_etf,
 };
-- 
2.7.4

