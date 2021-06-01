Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7557A396EEE
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 10:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233516AbhFAIal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 04:30:41 -0400
Received: from inva021.nxp.com ([92.121.34.21]:41686 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233461AbhFAIaf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 04:30:35 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 3CEED200198;
        Tue,  1 Jun 2021 10:28:50 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 inva021.eu-rdc02.nxp.com 3CEED200198
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com;
        s=nselector4; t=1622536130;
        bh=8Cfa93Zi2tmGCCgYTovwZg/cA+JIPQ43ki+rbiSgANE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UT8yYwRKaQ7O+aU/1nak80KVb4//WT1SBn3yplTbZrTmUYUsvjqkQUNsKiygH5/w0
         PGNHm4KKvVyhmijEIsd+KT3OMvXWU2d352/xukDrt4T0W9YkBJNSHQ9p7luSQb0obt
         gnLwTA6axabYXyZL0J+b/VNBi1Bu1v5OEUfZ4rBCU8NA+QmnfNxeaMlcGaPQLpwjg8
         36hO5WYCk2XpMR9txtEMVrq576y51DQRXh2rTcTeENC1iCq7KzUl3WxrRWINONZA7o
         UmlvB0OMYDCeSFTu03rI3K3lsubIzNHTi+X4sAXipMBMuP9YNTFIT2A0++UuiM7tJj
         VCIT87sM1ZoOw==
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 04204200270;
        Tue,  1 Jun 2021 10:28:42 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 inva021.eu-rdc02.nxp.com 04204200270
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 32AB74031E;
        Tue,  1 Jun 2021 16:28:31 +0800 (+08)
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
Subject: [PATCH v1 net-next 1/3] net: stmmac: separate the tas basetime calculation function
Date:   Tue,  1 Jun 2021 16:38:11 +0800
Message-Id: <20210601083813.1078-2-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210601083813.1078-1-xiaoliang.yang_1@nxp.com>
References: <20210601083813.1078-1-xiaoliang.yang_1@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Separate the TAS basetime calculation function so that it can be
called by other functions.

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  3 ++
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   | 38 ++++++++++++-------
 2 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index b6cd43eda7ac..1ce25c95cb06 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -355,6 +355,9 @@ void stmmac_selftest_run(struct net_device *dev,
 void stmmac_selftest_get_strings(struct stmmac_priv *priv, u8 *data);
 int stmmac_selftest_get_count(struct stmmac_priv *priv);
 #else
+struct timespec64 stmmac_calc_tas_basetime(ktime_t old_base_time,
+					   ktime_t current_time,
+					   u64 cycle_time);
 static inline void stmmac_selftest_run(struct net_device *dev,
 				       struct ethtool_test *etest, u64 *buf)
 {
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 4e70efc45458..d7d448c5a72b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -713,6 +713,29 @@ static int tc_setup_cls(struct stmmac_priv *priv,
 	return ret;
 }
 
+struct timespec64 stmmac_calc_tas_basetime(ktime_t old_base_time,
+					   ktime_t current_time,
+					   u64 cycle_time)
+{
+	struct timespec64 time;
+
+	if (ktime_after(old_base_time, current_time)) {
+		time = ktime_to_timespec64(old_base_time);
+	} else {
+		s64 n;
+		ktime_t base_time;
+
+		n = div64_s64(ktime_sub_ns(current_time, old_base_time),
+			      cycle_time);
+		base_time = ktime_add_ns(old_base_time,
+					 (n + 1) * cycle_time);
+
+		time = ktime_to_timespec64(base_time);
+	}
+
+	return time;
+}
+
 static int tc_setup_taprio(struct stmmac_priv *priv,
 			   struct tc_taprio_qopt_offload *qopt)
 {
@@ -816,19 +839,8 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 	/* Adjust for real system time */
 	priv->ptp_clock_ops.gettime64(&priv->ptp_clock_ops, &current_time);
 	current_time_ns = timespec64_to_ktime(current_time);
-	if (ktime_after(qopt->base_time, current_time_ns)) {
-		time = ktime_to_timespec64(qopt->base_time);
-	} else {
-		ktime_t base_time;
-		s64 n;
-
-		n = div64_s64(ktime_sub_ns(current_time_ns, qopt->base_time),
-			      qopt->cycle_time);
-		base_time = ktime_add_ns(qopt->base_time,
-					 (n + 1) * qopt->cycle_time);
-
-		time = ktime_to_timespec64(base_time);
-	}
+	time = stmmac_calc_tas_basetime(qopt->base_time, current_time_ns,
+					qopt->cycle_time);
 
 	priv->plat->est->btr[0] = (u32)time.tv_nsec;
 	priv->plat->est->btr[1] = (u32)time.tv_sec;
-- 
2.17.1

