Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7438725E3F5
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 01:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728270AbgIDXJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 19:09:45 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:53112 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728202AbgIDXJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 19:09:44 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 084N9frB003080;
        Fri, 4 Sep 2020 18:09:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1599260981;
        bh=9zdhcOMR7Ccf+ysTWrNasl7P6ckqRz+nS1O8WjwH018=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=Pyg/QxS3ChvkIMSgBQnETdA5Qs/ABXFMyLdRSuNpKjags6s97lJwPv+Bf3fhatjDv
         Ly2NwtQt9tmnXu3iLWGBF+s4rIFidttBiBixpSJRgUmW5djVtjkhSJHlbRLvA73dk8
         BIR9Pqs3fVSb1lcWI0iPT3I3o4sXQdaX6AC8j+fU=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 084N9fIJ066633
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 4 Sep 2020 18:09:41 -0500
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 4 Sep
 2020 18:09:40 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 4 Sep 2020 18:09:40 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 084N9dUD007506;
        Fri, 4 Sep 2020 18:09:40 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 1/9] net: ethernet: ti: ale: add cpsw_ale_get_num_entries api
Date:   Sat, 5 Sep 2020 02:09:16 +0300
Message-ID: <20200904230924.9971-2-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200904230924.9971-1-grygorii.strashko@ti.com>
References: <20200904230924.9971-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add cpsw_ale_get_num_entries() API to return number of ALE table entries
and update existing drivers to use it.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-ethtool.c | 10 ++++++----
 drivers/net/ethernet/ti/cpsw_ale.c          |  5 +++++
 drivers/net/ethernet/ti/cpsw_ale.h          |  1 +
 drivers/net/ethernet/ti/cpsw_ethtool.c      |  3 ++-
 4 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-ethtool.c b/drivers/net/ethernet/ti/am65-cpsw-ethtool.c
index 496dafb25128..6e4d4f9e32e0 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-ethtool.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-ethtool.c
@@ -572,13 +572,14 @@ static int am65_cpsw_nway_reset(struct net_device *ndev)
 static int am65_cpsw_get_regs_len(struct net_device *ndev)
 {
 	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
-	u32 i, regdump_len = 0;
+	u32 ale_entries, i, regdump_len = 0;
 
+	ale_entries = cpsw_ale_get_num_entries(common->ale);
 	for (i = 0; i < ARRAY_SIZE(am65_cpsw_regdump); i++) {
 		if (am65_cpsw_regdump[i].hdr.module_id ==
 		    AM65_CPSW_REGDUMP_MOD_CPSW_ALE_TBL) {
 			regdump_len += sizeof(struct am65_cpsw_regdump_hdr);
-			regdump_len += common->ale->params.ale_entries *
+			regdump_len += ale_entries *
 				       ALE_ENTRY_WORDS * sizeof(u32);
 			continue;
 		}
@@ -592,10 +593,11 @@ static void am65_cpsw_get_regs(struct net_device *ndev,
 			       struct ethtool_regs *regs, void *p)
 {
 	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
-	u32 i, j, pos, *reg = p;
+	u32 ale_entries, i, j, pos, *reg = p;
 
 	/* update CPSW IP version */
 	regs->version = AM65_CPSW_REGDUMP_VER;
+	ale_entries = cpsw_ale_get_num_entries(common->ale);
 
 	pos = 0;
 	for (i = 0; i < ARRAY_SIZE(am65_cpsw_regdump); i++) {
@@ -603,7 +605,7 @@ static void am65_cpsw_get_regs(struct net_device *ndev,
 
 		if (am65_cpsw_regdump[i].hdr.module_id ==
 		    AM65_CPSW_REGDUMP_MOD_CPSW_ALE_TBL) {
-			u32 ale_tbl_len = common->ale->params.ale_entries *
+			u32 ale_tbl_len = ale_entries *
 					  ALE_ENTRY_WORDS * sizeof(u32) +
 					  sizeof(struct am65_cpsw_regdump_hdr);
 			reg[pos++] = ale_tbl_len;
diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
index 9ad872bfae3a..a94aef3f54a5 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -1079,3 +1079,8 @@ void cpsw_ale_dump(struct cpsw_ale *ale, u32 *data)
 		data += ALE_ENTRY_WORDS;
 	}
 }
+
+u32 cpsw_ale_get_num_entries(struct cpsw_ale *ale)
+{
+	return ale ? ale->params.ale_entries : 0;
+}
diff --git a/drivers/net/ethernet/ti/cpsw_ale.h b/drivers/net/ethernet/ti/cpsw_ale.h
index 6a3cb6898728..735692f066bf 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.h
+++ b/drivers/net/ethernet/ti/cpsw_ale.h
@@ -119,6 +119,7 @@ int cpsw_ale_control_get(struct cpsw_ale *ale, int port, int control);
 int cpsw_ale_control_set(struct cpsw_ale *ale, int port,
 			 int control, int value);
 void cpsw_ale_dump(struct cpsw_ale *ale, u32 *data);
+u32 cpsw_ale_get_num_entries(struct cpsw_ale *ale);
 
 static inline int cpsw_ale_get_vlan_p0_untag(struct cpsw_ale *ale, u16 vid)
 {
diff --git a/drivers/net/ethernet/ti/cpsw_ethtool.c b/drivers/net/ethernet/ti/cpsw_ethtool.c
index fa54efe3be63..4d02c5135611 100644
--- a/drivers/net/ethernet/ti/cpsw_ethtool.c
+++ b/drivers/net/ethernet/ti/cpsw_ethtool.c
@@ -339,7 +339,8 @@ int cpsw_get_regs_len(struct net_device *ndev)
 {
 	struct cpsw_common *cpsw = ndev_to_cpsw(ndev);
 
-	return cpsw->data.ale_entries * ALE_ENTRY_WORDS * sizeof(u32);
+	return cpsw_ale_get_num_entries(cpsw->ale) *
+	       ALE_ENTRY_WORDS * sizeof(u32);
 }
 
 void cpsw_get_regs(struct net_device *ndev, struct ethtool_regs *regs, void *p)
-- 
2.17.1

