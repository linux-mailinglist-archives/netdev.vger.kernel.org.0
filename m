Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1B725FF21
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730560AbgIGQ2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:28:16 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:55818 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729898AbgIGObz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 10:31:55 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 087EVnR7113918;
        Mon, 7 Sep 2020 09:31:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1599489109;
        bh=EKYl7mQIBm5oIDjkydzatKB4BPZHHjRPDKZKyEOhuak=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=cEwyQuR0WBzO4KwlDHzW8fVlOIig4GgwESQBnjcvqR/GH6MA6xJjGQ9c7lMHBl1ue
         yNbV/OXCWtXoh78oMOJNAz4goVlONfAhQkFL/Swj184vctBecGzQ4Oh4/f0aFTclaF
         FyuNPZkcH25HQ7hUk74sah7H0sm9bmjwRnFF+JQU=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 087EVnun001324;
        Mon, 7 Sep 2020 09:31:49 -0500
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 7 Sep
 2020 09:31:49 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 7 Sep 2020 09:31:49 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 087EVmGF072934;
        Mon, 7 Sep 2020 09:31:49 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v2 2/9] net: ethernet: ti: ale: add static configuration
Date:   Mon, 7 Sep 2020 17:31:36 +0300
Message-ID: <20200907143143.13735-3-grygorii.strashko@ti.com>
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

