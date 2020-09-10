Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74B0D265124
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgIJUo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:44:59 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:52878 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbgIJU2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 16:28:47 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 08AKSiHE057726;
        Thu, 10 Sep 2020 15:28:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1599769724;
        bh=TEUYYQ1qI27PNKKbiquGZm0XFdgXPJh+vT+L90Q9M8U=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=OUN3YUgJ/Wxc15jYGArychSIkPhP50y67we7AgCM4XDMIk7jjaZ8/OR+KgAKbKd2u
         MyrMbSO3diBYeTf1A1e+ScyfJJE8aTCus1rdgRS2pHZY1LQ04qtbsgwZfqyXZ2mb0A
         6r+N4wEHz3cCQHBL3CVGv8jcb+1DpCgQjGrQnMAA=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 08AKSidv046612
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 10 Sep 2020 15:28:44 -0500
Received: from DFLE115.ent.ti.com (10.64.6.36) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 10
 Sep 2020 15:28:43 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 10 Sep 2020 15:28:43 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08AKSgqA066314;
        Thu, 10 Sep 2020 15:28:43 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v3 6/9] net: ethernet: ti: ale: make usage of ale dev_id mandatory
Date:   Thu, 10 Sep 2020 23:28:04 +0300
Message-ID: <20200910202807.17473-7-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910202807.17473-1-grygorii.strashko@ti.com>
References: <20200910202807.17473-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hence all existing driver updated to use ALE dev_id the usage of ale dev_id
can be made mandatory and cpsw_ale_create() can be updated to use
"features" property from ALE static configuration.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/cpsw_ale.c | 30 +++++++++++++-----------------
 drivers/net/ethernet/ti/cpsw_ale.h |  1 +
 2 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
index e70c9697ef47..524920a4bff0 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -83,7 +83,6 @@ struct cpsw_ale_dev_id {
 
 #define ALE_TABLE_SIZE_MULTIPLIER	1024
 #define ALE_STATUS_SIZE_MASK		0x1f
-#define ALE_TABLE_SIZE_DEFAULT		64
 
 static inline int cpsw_ale_get_field(u32 *ale_entry, u32 start, u32 bits)
 {
@@ -1060,11 +1059,12 @@ struct cpsw_ale *cpsw_ale_create(struct cpsw_ale_params *params)
 	u32 rev, ale_entries;
 
 	ale_dev_id = cpsw_ale_match_id(cpsw_ale_id_match, params->dev_id);
-	if (ale_dev_id) {
-		params->ale_entries = ale_dev_id->tbl_entries;
-		params->major_ver_mask = ale_dev_id->major_ver_mask;
-		params->nu_switch_ale = ale_dev_id->nu_switch_ale;
-	}
+	if (!ale_dev_id)
+		return ERR_PTR(-EINVAL);
+
+	params->ale_entries = ale_dev_id->tbl_entries;
+	params->major_ver_mask = ale_dev_id->major_ver_mask;
+	params->nu_switch_ale = ale_dev_id->nu_switch_ale;
 
 	ale = devm_kzalloc(params->dev, sizeof(*ale), GFP_KERNEL);
 	if (!ale)
@@ -1079,10 +1079,9 @@ struct cpsw_ale *cpsw_ale_create(struct cpsw_ale_params *params)
 
 	ale->params = *params;
 	ale->ageout = ale->params.ale_ageout * HZ;
+	ale->features = ale_dev_id->features;
 
 	rev = readl_relaxed(ale->params.ale_regs + ALE_IDVER);
-	if (!ale->params.major_ver_mask)
-		ale->params.major_ver_mask = 0xff;
 	ale->version =
 		(ALE_VERSION_MAJOR(rev, ale->params.major_ver_mask) << 8) |
 		 ALE_VERSION_MINOR(rev);
@@ -1090,7 +1089,8 @@ struct cpsw_ale *cpsw_ale_create(struct cpsw_ale_params *params)
 		 ALE_VERSION_MAJOR(rev, ale->params.major_ver_mask),
 		 ALE_VERSION_MINOR(rev));
 
-	if (!ale->params.ale_entries) {
+	if (ale->features & CPSW_ALE_F_STATUS_REG &&
+	    !ale->params.ale_entries) {
 		ale_entries =
 			readl_relaxed(ale->params.ale_regs + ALE_STATUS) &
 			ALE_STATUS_SIZE_MASK;
@@ -1099,16 +1099,12 @@ struct cpsw_ale *cpsw_ale_create(struct cpsw_ale_params *params)
 		 * table which shows the size as a multiple of 1024 entries.
 		 * For these, params.ale_entries will be set to zero. So
 		 * read the register and update the value of ale_entries.
-		 * ALE table on NetCP lite, is much smaller and is indicated
-		 * by a value of zero in ALE_STATUS. So use a default value
-		 * of ALE_TABLE_SIZE_DEFAULT for this. Caller is expected
-		 * to set the value of ale_entries for all other versions
-		 * of ALE.
+		 * return error if ale_entries is zero in ALE_STATUS.
 		 */
 		if (!ale_entries)
-			ale_entries = ALE_TABLE_SIZE_DEFAULT;
-		else
-			ale_entries *= ALE_TABLE_SIZE_MULTIPLIER;
+			return ERR_PTR(-EINVAL);
+
+		ale_entries *= ALE_TABLE_SIZE_MULTIPLIER;
 		ale->params.ale_entries = ale_entries;
 	}
 	dev_info(ale->params.dev,
diff --git a/drivers/net/ethernet/ti/cpsw_ale.h b/drivers/net/ethernet/ti/cpsw_ale.h
index 53ad4246617e..27b30802b384 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.h
+++ b/drivers/net/ethernet/ti/cpsw_ale.h
@@ -32,6 +32,7 @@ struct cpsw_ale {
 	struct timer_list	timer;
 	unsigned long		ageout;
 	u32			version;
+	u32			features;
 	/* These bits are different on NetCP NU Switch ALE */
 	u32			port_mask_bits;
 	u32			port_num_bits;
-- 
2.17.1

