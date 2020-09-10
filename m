Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 026F2265126
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgIJUqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:46:14 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:47162 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbgIJU2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 16:28:31 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 08AKSKuC116343;
        Thu, 10 Sep 2020 15:28:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1599769700;
        bh=Zxj6hx5gut77UxwO3zQp4eiDftnAuhdhN797m8w7ynk=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=M7b266WGy0wNn0fszZjLJbtIAOLgnWiMoZqxTAUT4qV3ceBHyq2SsXsi6jXms2qd8
         trcA8HGPMMc4okPwnxLGAmMs4pHFltaqeYhD384aF/FkhM53e0g/qyXCj/SfZQQRYM
         8/6xGSyETAr1P6XOKOUE1L4sZF8s9c5qYa5/L88s=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08AKSKXX052061;
        Thu, 10 Sep 2020 15:28:20 -0500
Received: from DFLE101.ent.ti.com (10.64.6.22) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 10
 Sep 2020 15:28:19 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 10 Sep 2020 15:28:19 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08AKSI00040826;
        Thu, 10 Sep 2020 15:28:19 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v3 2/9] net: ethernet: ti: ale: add static configuration
Date:   Thu, 10 Sep 2020 23:28:00 +0300
Message-ID: <20200910202807.17473-3-grygorii.strashko@ti.com>
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

As existing, as newly introduced CPSW ALE versions have differences in
supported features and ALE table formats. Especially it's actual for the
recent AM65x/J721E/J7200 SoC and feature AM64x, which supports features
like: auto-aging, classifiers, Link aggregation, additional hw filtering,
etc.

Existing ALE configuration interface is not practical in terms of adding
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
 drivers/net/ethernet/ti/cpsw_ale.c | 82 ++++++++++++++++++++++++++++++
 drivers/net/ethernet/ti/cpsw_ale.h |  1 +
 2 files changed, 83 insertions(+)

diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
index a94aef3f54a5..e70c9697ef47 100644
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

