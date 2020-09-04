Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF8825E3F7
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 01:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbgIDXJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 19:09:53 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:51102 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728202AbgIDXJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 19:09:52 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 084N9mU6127065;
        Fri, 4 Sep 2020 18:09:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1599260988;
        bh=408RxOZL+TuTw395fjk5ZN/Abws4dUsJ35e8tGDoCfE=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=F5eaRxQ73G32YX5i2l+exIkUUshbovc0H9GbQcOLhi302T6iMzNLSoX9Ieio101lg
         BL5n9dRHFNBgJN+fmJnxxhAwyOaysX9735rz5nIFS/HSAAvaZmMp9ysN+x3hnUf+x2
         sNTMomplCXw5k7LPjFp7v/DL1eCUGUurxNGtGj5I=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 084N9m9X028930
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 4 Sep 2020 18:09:48 -0500
Received: from DLEE110.ent.ti.com (157.170.170.21) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 4 Sep
 2020 18:09:47 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 4 Sep 2020 18:09:47 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 084N9kQX007597;
        Fri, 4 Sep 2020 18:09:47 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 2/9] net: ethernet: ti: ale: add static configuration
Date:   Sat, 5 Sep 2020 02:09:17 +0300
Message-ID: <20200904230924.9971-3-grygorii.strashko@ti.com>
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

As existing, as newly introduced CPSW ALE versions have differences in
supported features and ALE table formats. Especially it's actual for the
recent AM65x/J721E/J7200 and future AM64x SoCs, which supports features
like: auto-aging, classifiers, Link aggregation, additional HW filtering,
etc.

The existing ALE configuration interface is not practical in terms of adding
new features and requires consumers to program a lot static parameters. Any
attempt to add new options will case endless adding and maintaining
different combination of flags and options.

Hence CPSW ALE configuration is static and fixed for SoC (or set of SoC) It
is reasonable to add support for static ALE configurations inside ALE
module. This patch adds static ALE configuration table for different ALE
versions and provides option for consumers to select required ALE
configuration by providing ALE const char *dev_id identifier.

This feature is not enabled by default until existing CPSW drivers will be
modified by follow up patches.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/cpsw_ale.c | 84 +++++++++++++++++++++++++++++-
 drivers/net/ethernet/ti/cpsw_ale.h |  1 +
 2 files changed, 83 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
index a94aef3f54a5..766197003971 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -46,6 +46,29 @@
 
 #define AM65_CPSW_ALE_THREAD_DEF_REG 0x134
 
+enum {
+	CPSW_ALE_F_STATUS_REG = BIT(0), /* Status register present */
+	CPSW_ALE_F_HW_AUTOAGING = BIT(1), /* HW auto aging */
+
+	CPSW_ALE_F_COUNT
+};
+
+/**
+ * struct ale_dev_id - The ALE version/SoC specific configuration
+ * @dev_id: ALE version/SoC id
+ * @features: features supported by ALE
+ * @tbl_entries: number of ALE entries
+ * @major_ver_mask: mask of ALE Major Version Value in ALE_IDVER reg.
+ * @nu_switch_ale: NU Switch ALE
+ */
+struct cpsw_ale_dev_id {
+	const char *dev_id;
+	u32 features;
+	u32 tbl_entries;
+	u32 major_ver_mask;
+	bool nu_switch_ale;
+};
+
 #define ALE_TABLE_WRITE		BIT(31)
 
 #define ALE_TYPE_FREE			0
@@ -979,11 +1002,70 @@ void cpsw_ale_stop(struct cpsw_ale *ale)
 	cpsw_ale_control_set(ale, 0, ALE_ENABLE, 0);
 }
 
+static const struct cpsw_ale_dev_id cpsw_ale_id_match[] = {
+	{
+		/* am3/4/5, dra7. dm814x, 66ak2hk-gbe */
+		.dev_id = "cpsw",
+		.tbl_entries = 1024,
+		.major_ver_mask = 0xff,
+	},
+	{
+		/* 66ak2h_xgbe */
+		.dev_id = "66ak2h-xgbe",
+		.tbl_entries = 2048,
+		.major_ver_mask = 0xff,
+	},
+	{
+		.dev_id = "66ak2el",
+		.features = CPSW_ALE_F_STATUS_REG,
+		.major_ver_mask = 0x7,
+		.nu_switch_ale = true,
+	},
+	{
+		.dev_id = "66ak2g",
+		.features = CPSW_ALE_F_STATUS_REG,
+		.tbl_entries = 64,
+		.major_ver_mask = 0x7,
+		.nu_switch_ale = true,
+	},
+	{
+		.dev_id = "am65x-cpsw2g",
+		.features = CPSW_ALE_F_STATUS_REG | CPSW_ALE_F_HW_AUTOAGING,
+		.tbl_entries = 64,
+		.major_ver_mask = 0x7,
+		.nu_switch_ale = true,
+	},
+	{ },
+};
+
+static const struct
+cpsw_ale_dev_id *cpsw_ale_match_id(const struct cpsw_ale_dev_id *id,
+				   const char *dev_id)
+{
+	if (!dev_id)
+		return NULL;
+
+	while (id->dev_id) {
+		if (strcmp(dev_id, id->dev_id) == 0)
+			return id;
+		id++;
+	}
+	return NULL;
+}
+
 struct cpsw_ale *cpsw_ale_create(struct cpsw_ale_params *params)
 {
+	const struct cpsw_ale_dev_id *ale_dev_id;
 	struct cpsw_ale *ale;
 	u32 rev, ale_entries;
 
+	ale_dev_id = cpsw_ale_match_id(cpsw_ale_id_match, params->dev_id);
+	if (ale_dev_id) {
+		params->ale_entries = ale_dev_id->tbl_entries;
+		params->major_ver_mask = ale_dev_id->major_ver_mask;
+		params->nu_switch_ale = ale_dev_id->nu_switch_ale;
+	}
+
 	ale = devm_kzalloc(params->dev, sizeof(*ale), GFP_KERNEL);
 	if (!ale)
 		return ERR_PTR(-ENOMEM);
@@ -999,8 +1081,6 @@ struct cpsw_ale *cpsw_ale_create(struct cpsw_ale_params *params)
 	ale->ageout = ale->params.ale_ageout * HZ;
 
 	rev = readl_relaxed(ale->params.ale_regs + ALE_IDVER);
-	if (!ale->params.major_ver_mask)
-		ale->params.major_ver_mask = 0xff;
 	ale->version =
 		(ALE_VERSION_MAJOR(rev, ale->params.major_ver_mask) << 8) |
 		 ALE_VERSION_MINOR(rev);
diff --git a/drivers/net/ethernet/ti/cpsw_ale.h b/drivers/net/ethernet/ti/cpsw_ale.h
index 735692f066bf..53ad4246617e 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.h
+++ b/drivers/net/ethernet/ti/cpsw_ale.h
@@ -24,6 +24,7 @@ struct cpsw_ale_params {
 	 * pass it from caller.
 	 */
 	u32			major_ver_mask;
+	const char		*dev_id;
 };
 
 struct cpsw_ale {
-- 
2.17.1

