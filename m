Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 204D1396EEC
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 10:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233485AbhFAIak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 04:30:40 -0400
Received: from inva020.nxp.com ([92.121.34.13]:46994 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233451AbhFAIae (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 04:30:34 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 8A0141A0984;
        Tue,  1 Jun 2021 10:28:52 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 inva020.eu-rdc02.nxp.com 8A0141A0984
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com;
        s=nselector3; t=1622536132;
        bh=7KIiz9aJ9kl78LKRrsVHskesiQqeHXWB0XHkiZOuBeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n9nMCEbBHycWNzN7ql/bcSW9cp4UxZLQ5jW48kpd7JB44jEvU/ppQr+MJdJ4PY67d
         T9d4NFHKb2zhHyF/dcYijDi7bg5klGhtF7Xnb9TQ71z/vpzNNQVkKmxJtizSsGpj5e
         AJKmG7MbKbysGOIGKsZzjXgleVJKok3LKUacTULJ9eHRoPxIkhkorRmKw4dtAZP2Hx
         QN35Pmgn+4j2MXgHK0siytoEtsj+UBvNnJjY0meO1ncJfpVvFNnJC4DDOsdZ4RMbmx
         JBSxOD5ZM1sH9J4z6m3S5Dt7VyLYaIRsceVA7CkEwN89QV0ylOwWC2urmXieo3GoOq
         tU5tw/N7DlEFQ==
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 54BFE1A189C;
        Tue,  1 Jun 2021 10:28:44 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 inva020.eu-rdc02.nxp.com 54BFE1A189C
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id EA5544031B;
        Tue,  1 Jun 2021 16:28:33 +0800 (+08)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     davem@davemloft.net, joabreu@synopsys.com, kuba@kernel.org,
        alexandre.torgue@st.com, peppe.cavallaro@st.com,
        mcoquelin.stm32@gmail.com
Cc:     netdev@vger.kernel.org, boon.leong.ong@intel.com,
        weifeng.voon@intel.com, vee.khee.wong@intel.com,
        tee.min.tan@intel.com, mohammad.athari.ismail@intel.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        leoyang.li@nxp.com, vladimir.oltean@nxp.com,
        qiangqing.zhang@nxp.com, rui.sousa@nxp.com, mingkai.hu@nxp.com,
        yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com
Subject: [PATCH v1 net-next 2/3] net: stmmac: add mutex lock to protect est parameters
Date:   Tue,  1 Jun 2021 16:38:12 +0800
Message-Id: <20210601083813.1078-3-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210601083813.1078-1-xiaoliang.yang_1@nxp.com>
References: <20210601083813.1078-1-xiaoliang.yang_1@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a mutex lock to protect est structure parameters so that the
EST parameters can be updated by other threads.

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c | 8 ++++++++
 include/linux/stmmac.h                          | 1 +
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index d7d448c5a72b..8e1f9a18ef59 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -798,14 +798,18 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 					 GFP_KERNEL);
 		if (!plat->est)
 			return -ENOMEM;
+
+		mutex_init(&priv->plat->est->lock);
 	} else {
 		memset(plat->est, 0, sizeof(*plat->est));
 	}
 
 	size = qopt->num_entries;
 
+	mutex_lock(&priv->plat->est->lock);
 	priv->plat->est->gcl_size = size;
 	priv->plat->est->enable = qopt->enable;
+	mutex_unlock(&priv->plat->est->lock);
 
 	for (i = 0; i < size; i++) {
 		s64 delta_ns = qopt->entries[i].interval;
@@ -842,6 +846,7 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 	time = stmmac_calc_tas_basetime(qopt->base_time, current_time_ns,
 					qopt->cycle_time);
 
+	mutex_lock(&priv->plat->est->lock);
 	priv->plat->est->btr[0] = (u32)time.tv_nsec;
 	priv->plat->est->btr[1] = (u32)time.tv_sec;
 
@@ -859,6 +864,7 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 
 	ret = stmmac_est_configure(priv, priv->ioaddr, priv->plat->est,
 				   priv->plat->clk_ptp_rate);
+	mutex_unlock(&priv->plat->est->lock);
 	if (ret) {
 		netdev_err(priv->dev, "failed to configure EST\n");
 		goto disable;
@@ -874,9 +880,11 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 	return 0;
 
 disable:
+	mutex_lock(&priv->plat->est->lock);
 	priv->plat->est->enable = false;
 	stmmac_est_configure(priv, priv->ioaddr, priv->plat->est,
 			     priv->plat->clk_ptp_rate);
+	mutex_unlock(&priv->plat->est->lock);
 
 	priv->plat->fpe_cfg->enable = false;
 	stmmac_fpe_configure(priv, priv->ioaddr,
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index e14a12df381b..c38b65aaf8c2 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -115,6 +115,7 @@ struct stmmac_axi {
 
 #define EST_GCL		1024
 struct stmmac_est {
+	struct mutex lock;
 	int enable;
 	u32 btr_offset[2];
 	u32 btr[2];
-- 
2.17.1

