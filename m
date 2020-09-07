Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84C5A25FEFF
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729919AbgIGOdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 10:33:14 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:55816 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729896AbgIGObz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 10:31:55 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 087EVm53113911;
        Mon, 7 Sep 2020 09:31:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1599489108;
        bh=9zdhcOMR7Ccf+ysTWrNasl7P6ckqRz+nS1O8WjwH018=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=lu0duZYyQh7/VdKn07lhW1meZp3a1NzzWpzFzfFAdotOzBNBvc11FBYaJhP9u0Wwf
         TxR2bhxdmL7aikSAllJu2kS5ytyQL6OjTsY03da+0rubrnviM+aHAeyo8QUjYMH9sW
         eBNFEL5mV0hrPU8IjJFcZxz2EPSua3dkUZun1FRM=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 087EVmTe095335
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 7 Sep 2020 09:31:48 -0500
Received: from DFLE112.ent.ti.com (10.64.6.33) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 7 Sep
 2020 09:31:47 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 7 Sep 2020 09:31:47 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 087EVkNt072909;
        Mon, 7 Sep 2020 09:31:47 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v2 1/9] net: ethernet: ti: ale: add cpsw_ale_get_num_entries api
Date:   Mon, 7 Sep 2020 17:31:35 +0300
Message-ID: <20200907143143.13735-2-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200907143143.13735-1-grygorii.strashko@ti.com>
References: <20200907143143.13735-1-grygorii.strashko@ti.com>
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

