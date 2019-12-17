Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08CA4122C36
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 13:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbfLQMqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 07:46:21 -0500
Received: from sv2-smtprelay2.synopsys.com ([149.117.73.133]:50910 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727519AbfLQMqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 07:46:20 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 68CA94268D;
        Tue, 17 Dec 2019 12:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1576586779; bh=7NQjEW95aI/xz0UWPZxjxnNVqObM0l68OQ7cF2ISsc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=WSnreI+uDDIuYil8ajFHW3FieYqXH3d9fyM6AB0hMCMbvfdpJAVEsqTGFIK4dEDDU
         0ts9rCKqTO6q4Kwx4SYKDE9etyBhn5DW+0j7MqcCDBmq0LWQi8u4WkEoYiiko49ejq
         6QW26pqGAOtwEccufd+rlbPqnLA5GM+6uOwDIEt1RZT+T/Z+H7h/og8l1+HQNbJUsE
         jm3DIy0KnEWXe42q+J1pC6r7lJ6fbVVJTJwu8X7AeK5y7Abad11SuMp0zkhQvjCflz
         Avn+VixMz+dP6WCIgcmONgOJ72b9tsRWker8e8wkoJroozJeWf1PJL5WGUHukow2eG
         cdcAHZjzx9N5Q==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 08AE6A00A6;
        Tue, 17 Dec 2019 12:46:18 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 7/7] net: stmmac: Integrate EST with TAPRIO scheduler API
Date:   Tue, 17 Dec 2019 13:46:11 +0100
Message-Id: <0a37387c1bb2561583e6ac8c7788659741876f32.1576586602.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1576586602.git.Jose.Abreu@synopsys.com>
References: <cover.1576586602.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1576586602.git.Jose.Abreu@synopsys.com>
References: <cover.1576586602.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have the EST code for XGMAC and QoS we can use it with the
TAPRIO scheduler. Integrate it into the main driver and use the API to
configure the EST feature.

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
 drivers/net/ethernet/stmicro/stmmac/hwif.h        |   5 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   2 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c   | 108 ++++++++++++++++++++++
 3 files changed, 115 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 9fd34df6eb16..22f79c0a9343 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -521,6 +521,7 @@ struct stmmac_priv;
 struct tc_cls_u32_offload;
 struct tc_cbs_qopt_offload;
 struct flow_cls_offload;
+struct tc_taprio_qopt_offload;
 
 struct stmmac_tc_ops {
 	int (*init)(struct stmmac_priv *priv);
@@ -530,6 +531,8 @@ struct stmmac_tc_ops {
 			 struct tc_cbs_qopt_offload *qopt);
 	int (*setup_cls)(struct stmmac_priv *priv,
 			 struct flow_cls_offload *cls);
+	int (*setup_taprio)(struct stmmac_priv *priv,
+			    struct tc_taprio_qopt_offload *qopt);
 };
 
 #define stmmac_tc_init(__priv, __args...) \
@@ -540,6 +543,8 @@ struct stmmac_tc_ops {
 	stmmac_do_callback(__priv, tc, setup_cbs, __args)
 #define stmmac_tc_setup_cls(__priv, __args...) \
 	stmmac_do_callback(__priv, tc, setup_cls, __args)
+#define stmmac_tc_setup_taprio(__priv, __args...) \
+	stmmac_do_callback(__priv, tc, setup_taprio, __args)
 
 struct stmmac_counters;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index b3c6c5e29404..03bd32420b3b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4074,6 +4074,8 @@ static int stmmac_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 						  priv, priv, true);
 	case TC_SETUP_QDISC_CBS:
 		return stmmac_tc_setup_cbs(priv, priv, type_data);
+	case TC_SETUP_QDISC_TAPRIO:
+		return stmmac_tc_setup_taprio(priv, priv, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 7d972e0fd2b0..58d4ce094381 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -591,9 +591,117 @@ static int tc_setup_cls(struct stmmac_priv *priv,
 	return ret;
 }
 
+static int tc_setup_taprio(struct stmmac_priv *priv,
+			   struct tc_taprio_qopt_offload *qopt)
+{
+	u32 size, wid = priv->dma_cap.estwid, dep = priv->dma_cap.estdep;
+	struct plat_stmmacenet_data *plat = priv->plat;
+	struct timespec64 time;
+	int i, ret = 0;
+
+	if (!priv->dma_cap.estsel)
+		return -EOPNOTSUPP;
+
+	switch (wid) {
+	case 0x1:
+		wid = 16;
+		break;
+	case 0x2:
+		wid = 20;
+		break;
+	case 0x3:
+		wid = 24;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	switch (dep) {
+	case 0x1:
+		dep = 64;
+		break;
+	case 0x2:
+		dep = 128;
+		break;
+	case 0x3:
+		dep = 256;
+		break;
+	case 0x4:
+		dep = 512;
+		break;
+	case 0x5:
+		dep = 1024;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	if (!qopt->enable)
+		goto disable;
+	if (qopt->num_entries >= dep)
+		return -EINVAL;
+	if (!qopt->base_time)
+		return -ERANGE;
+	if (!qopt->cycle_time)
+		return -ERANGE;
+
+	if (!plat->est) {
+		plat->est = devm_kzalloc(priv->device, sizeof(*plat->est),
+					 GFP_KERNEL);
+		if (!plat->est)
+			return -ENOMEM;
+	} else {
+		memset(plat->est, 0, sizeof(*plat->est));
+	}
+
+	size = qopt->num_entries;
+
+	priv->plat->est->gcl_size = size;
+	priv->plat->est->enable = qopt->enable;
+
+	for (i = 0; i < size; i++) {
+		s64 delta_ns = qopt->entries[i].interval;
+		u32 gates = qopt->entries[i].gate_mask;
+
+		if (delta_ns > GENMASK(wid, 0))
+			return -ERANGE;
+		if (gates > GENMASK(31 - wid, 0))
+			return -ERANGE;
+		if (qopt->entries[i].command != TC_TAPRIO_CMD_SET_GATES)
+			return -EOPNOTSUPP;
+
+		priv->plat->est->gcl[i] = delta_ns | (gates << wid);
+	}
+
+	/* Adjust for real system time */
+	time = ktime_to_timespec64(qopt->base_time);
+	priv->plat->est->btr[0] = (u32)time.tv_nsec;
+	priv->plat->est->btr[1] = (u32)time.tv_sec;
+
+	priv->plat->est->ctr[0] = (u32)(qopt->cycle_time % NSEC_PER_SEC);
+	priv->plat->est->ctr[1] = (u32)(qopt->cycle_time / NSEC_PER_SEC);
+
+	ret = stmmac_est_configure(priv, priv->ioaddr, priv->plat->est,
+				   priv->plat->clk_ptp_rate);
+	if (ret) {
+		netdev_err(priv->dev, "failed to configure EST\n");
+		goto disable;
+	}
+
+	netdev_info(priv->dev, "configured EST\n");
+	return 0;
+
+disable:
+	priv->plat->est->enable = false;
+	stmmac_est_configure(priv, priv->ioaddr, priv->plat->est,
+			     priv->plat->clk_ptp_rate);
+	return ret;
+}
+
 const struct stmmac_tc_ops dwmac510_tc_ops = {
 	.init = tc_init,
 	.setup_cls_u32 = tc_setup_cls_u32,
 	.setup_cbs = tc_setup_cbs,
 	.setup_cls = tc_setup_cls,
+	.setup_taprio = tc_setup_taprio,
 };
-- 
2.7.4

