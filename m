Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26E6A6CAD58
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 20:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232714AbjC0Slw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 14:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232588AbjC0Slq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 14:41:46 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11olkn2081e.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::81e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 655C71B6;
        Mon, 27 Mar 2023 11:41:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iLbhvPmXmigDRffW5Y+JvsdPB01/kRX9rtsMRgfNFfvZ77DAqabnz2fSuOS8nLMy6CXytaK/7bUFOZkkJKBvqevCQUqpMNXyK3fzy0aRbsKxw1fV/Y8tP/LsQzOuRQRlYrAmHlMJq3/lUiip52LQfyPb23Bw7f6L3Qa6d2YfS1+gAxpp0OP+P7jfWWGG3jUw488Qitx64ko6rCjhJ/knBhKHO8NIXG8C5UuEVHuoFZ7rJBK/vaZdE2GMhS84kcHtGg2jlDDSjxZBBwTh0UXcWF4W9tgc01meSsgjtGJOPlPx0p+Qgmp2y6tUd7MkfxBUSm0RDRDPwxpbjtjSKKEwFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o5jzP+PrGWDa0xRXH3/Y49+Pox7Si9cezgjlFiFatwQ=;
 b=WN2kJa9HhT53h6gv2GJPNW1qaDQ2XhBxiMyV2rjHOJYNbHks7ChUmsbOpmTvRbpAfUcxiHMmwff1lQSebeFsC7ZSxYdC9Kzd2IjO0jKpPmVrnmEz4fckgRM4SyN1I55In+LHdYRM3RfNUxozQ7J2IibS0lyHRJHhvz8aWqfsPSBAba7+Mo/MzQV37vFlVqIyZACR3iDarSuXN4CzLDdG5lzIGBo/NHTzRF9CgVkBWXpNvDowuXCG/OhX8jcKTyLBagMpq3Z3DlHH3X1bgLePap9ojq/C2ooGgVwug3ZvZXGwQVWG5b7QjoCJeooPKRWEdIYSNvTk6M6kyAK43k2Y2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o5jzP+PrGWDa0xRXH3/Y49+Pox7Si9cezgjlFiFatwQ=;
 b=MTlqAx5y0Txh+na1K31LGRHAHQtb/aLWGvSIIGTneRbzFh/wAlg2ECerMC7a6fqP1ie45TT36afa33pAm07J2O6gDPG06e9winonEDIhjGVgsuc01KX/jSJpRF/Qn7HCd+V74n0hHmk7JFvspx/2AcpDmz9kDTd/8dIX69AKKxoiM94/WbggiD50ZO3rrfa+VhrN/bolM0ZHIbb2bwgCBJHcubGYbTVlZc/2NRM0CEvpKdwwcrq4b4/v57WA772x58b+PrF1GJtsHppMsJxkHp3+EorPEVg5aSxA63RhjXMdLTSKqmflZyLuKlvXjqYxA/0/qbMAD/qpjiq1gm/MkA==
Received: from MW5PR03MB6932.namprd03.prod.outlook.com (2603:10b6:303:1cd::22)
 by BY5PR03MB5251.namprd03.prod.outlook.com (2603:10b6:a03:22b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Mon, 27 Mar
 2023 18:40:10 +0000
Received: from MW5PR03MB6932.namprd03.prod.outlook.com
 ([fe80::191c:ca4e:23a0:274f]) by MW5PR03MB6932.namprd03.prod.outlook.com
 ([fe80::191c:ca4e:23a0:274f%8]) with mapi id 15.20.6178.037; Mon, 27 Mar 2023
 18:40:10 +0000
From:   Min Li <lnimi@hotmail.com>
To:     richardcochran@gmail.com, lee@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH mfd v2 1/3] mfd: rsmu: support 32-bit address space
Date:   Mon, 27 Mar 2023 14:39:53 -0400
Message-ID: <MW5PR03MB693295AF31ABCAF6AE52EE74A08B9@MW5PR03MB6932.namprd03.prod.outlook.com>
X-Mailer: git-send-email 2.39.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [EDBOH9aZytHkWMcnoRwEiK8+gP4gIhgY]
X-ClientProxiedBy: YQBPR0101CA0092.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:4::25) To MW5PR03MB6932.namprd03.prod.outlook.com
 (2603:10b6:303:1cd::22)
X-Microsoft-Original-Message-ID: <20230327183955.30239-1-lnimi@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW5PR03MB6932:EE_|BY5PR03MB5251:EE_
X-MS-Office365-Filtering-Correlation-Id: 3db95087-66ad-4e99-75f4-08db2ef2b168
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K3Vc73ULLSgd8GviWF6EOso6grA+GQAI8eKC2Cb+s51fIrXt0iSm9tnhLbXj0L6u/JXFf3yPkFidUmYPUdFqSUsvfZrGSdm/Ramv1Yb/7qJ7taIUcZz47MtX5sKCYbmQTWE9ekIxaEONwO0WRP+IlZVwGdxgah69eDx4DRS2wsjaei7maPCl6jlvtzmlBXnS6vdfGNbGFkRmMzaK1QLskrpc4NO1eCVhJNwcwAWAE4IioQ8xS5B1PtLW3SYsBPTerDcYNCekoyxdPHw33XenjGZu1UxqzqzlRLR+by5DJ48Y3pbhwk/fBJWJiezA9PrOUJmdE3/G9XndBuEYTxLdI68IUW/c324UTfM5d7BzBVXe3G9qVqL+/+A7waJcnHm4DFgCvVrUeFwYkVVTy9yXWUk/Vnpv9YXyvtBOY5eX7mG5vf4DIL0CUN9Vbjxbcyj34Id3bNV/CJQrf7QmFFR9gwLQhoAZ4WffIGKRgEVDScfSxMPmszQcz6Po4XS7L4KKyisPG8dR7Ea3tzfZg/24Uvp0j2SwtGXl8mUpztLBe9fyxkrplODfMSJzEi7bZQIl
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T7yqETUQBB6+dG1nbabviQLNeYpwgcE9Pxu1oY6naOc5F3aQKOzkGcWDmAju?=
 =?us-ascii?Q?aDdciZOG+3nayyyConmwRb9CKpOYPNygUWHJMSIhRPns9nVJzsNrX88zIb4e?=
 =?us-ascii?Q?N95Mr7kkpnv7gmeD6h9knoDkUsyHQepGrePYka+1ojFaCuWHQCqc5sv9ieRY?=
 =?us-ascii?Q?guuI1sX3vtJH4gP9lkc9eY7CtXR3pcCNDy6KjgPL+GIKXtLUXBy6Sf6DN6vx?=
 =?us-ascii?Q?5TJuVhTzLw30HcZ3rshfe6CmAYuJsv9hs9LuMF/YeF1ukYuNRCtmegIgTBdW?=
 =?us-ascii?Q?5pj0JI5FQhMWVqwuue6UylMh74Nd4cwA42GTvw6+Y0D6YOsLC16yVqlW+sXQ?=
 =?us-ascii?Q?amh8RV8Db8MidVflwOGAGnr4uagTlfeBsIO1nNv+yf8XPN44zCWWqZlNmCxm?=
 =?us-ascii?Q?xSd5q7kPGxwIvjToCYhkAQGD773PmNcsVc1kbIRXTSjhH/1kCv2a0tcxOtya?=
 =?us-ascii?Q?aeV4plW/HDoGWMABVrcBMUjUmIs4nD5q8mOIlakI3gDzXNWTnnLjLBzy0EKV?=
 =?us-ascii?Q?2kxyoWUh+pqUvQwwsjjYAXdtimMp18B6HyFEx9YMfPlaUVmd4socpsAAI6ew?=
 =?us-ascii?Q?6m3aL8E0XOutNWInIKNTbmtWzy6OCxVn5Ssd5MxILIxxULv6S7mFboamt1UB?=
 =?us-ascii?Q?3/emy1Zo4CPOoUfjagUmT0mg6rbD92MT29/uczrRcFxqZ/7F2fX5CQdbke/2?=
 =?us-ascii?Q?QF22mMotjh5TZyJeS8u3W+jUqYL2HWM6/Aq2TFfjA2KVq2iWKoGrl+8UeaQg?=
 =?us-ascii?Q?HMWiT+nDEG7tUaAdI2ikTv5FkWB7LPJI8QAq2zxzRCX7lM570YGpDIY8Nqvt?=
 =?us-ascii?Q?kL5NdgNakbpKC+XtEI2whAslz68RoE9EmLEwTirV7ExMQUEkbBZUQdF2PJNV?=
 =?us-ascii?Q?VyXkEtqmYohByVHlB40ubnT+w7c95JpNLVAb+yX9MQ/p0y1lZowQMxmvunHD?=
 =?us-ascii?Q?g1amM6SfnPbFoM6HnCDc/ZnDysHdmMKHrLug2u6zEMhJefa69bi5SF/UdeuH?=
 =?us-ascii?Q?stKlIdVRndJdMi9jyFLafjJSbcM8L0rmlN6ikDPb/9WAu36k+IF9VE/Y6JOq?=
 =?us-ascii?Q?Fxcjt0ufAZ3mKT5l+lEOvWsVnN2VaQkoKKCiISSUuUv9gEVGHJ/oHnCmExrS?=
 =?us-ascii?Q?Lyd8UgYhvoJOMOeHpo45RYGjn5sh7JmDyLVKRPfzKdyj0Xd8adN5ev04c77j?=
 =?us-ascii?Q?+vUOsq8GA/dBc9qwTbFrAxiaOXOscfNtGG0V1g=3D=3D?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-685f7.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 3db95087-66ad-4e99-75f4-08db2ef2b168
X-MS-Exchange-CrossTenant-AuthSource: MW5PR03MB6932.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 18:40:10.2662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR03MB5251
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Min Li <min.li.xe@renesas.com>

We used to assume 0x2010xxxx address. Now that we
need to access 0x2011xxxx address, we need to
support read/write the whole 32-bit address space.

Also defined RSMU_MAX_WRITE_COUNT and
RSMU_MAX_READ_COUNT for readability

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
changelog
-change commit message to include defining RSMU_MAX_WRITE/WRITE_COUNT

 drivers/mfd/rsmu.h       |   2 +
 drivers/mfd/rsmu_i2c.c   | 172 +++++++++++++++++++++++++++++++--------
 drivers/mfd/rsmu_spi.c   |  52 +++++++-----
 include/linux/mfd/rsmu.h |   5 +-
 4 files changed, 175 insertions(+), 56 deletions(-)

diff --git a/drivers/mfd/rsmu.h b/drivers/mfd/rsmu.h
index bb88597d189f..1bb04cafa45d 100644
--- a/drivers/mfd/rsmu.h
+++ b/drivers/mfd/rsmu.h
@@ -10,6 +10,8 @@
 
 #include <linux/mfd/rsmu.h>
 
+#define RSMU_CM_SCSR_BASE		0x20100000
+
 int rsmu_core_init(struct rsmu_ddata *rsmu);
 void rsmu_core_exit(struct rsmu_ddata *rsmu);
 
diff --git a/drivers/mfd/rsmu_i2c.c b/drivers/mfd/rsmu_i2c.c
index 15d25b081434..171b0544b778 100644
--- a/drivers/mfd/rsmu_i2c.c
+++ b/drivers/mfd/rsmu_i2c.c
@@ -18,11 +18,12 @@
 #include "rsmu.h"
 
 /*
- * 16-bit register address: the lower 8 bits of the register address come
- * from the offset addr byte and the upper 8 bits come from the page register.
+ * 32-bit register address: the lower 8 bits of the register address come
+ * from the offset addr byte and the upper 24 bits come from the page register.
  */
-#define	RSMU_CM_PAGE_ADDR		0xFD
-#define	RSMU_CM_PAGE_WINDOW		256
+#define	RSMU_CM_PAGE_ADDR		0xFC
+#define RSMU_CM_PAGE_MASK		0xFFFFFF00
+#define RSMU_CM_ADDRESS_MASK		0x000000FF
 
 /*
  * 15-bit register address: the lower 7 bits of the register address come
@@ -31,18 +32,6 @@
 #define	RSMU_SABRE_PAGE_ADDR		0x7F
 #define	RSMU_SABRE_PAGE_WINDOW		128
 
-static const struct regmap_range_cfg rsmu_cm_range_cfg[] = {
-	{
-		.range_min = 0,
-		.range_max = 0xD000,
-		.selector_reg = RSMU_CM_PAGE_ADDR,
-		.selector_mask = 0xFF,
-		.selector_shift = 0,
-		.window_start = 0,
-		.window_len = RSMU_CM_PAGE_WINDOW,
-	}
-};
-
 static const struct regmap_range_cfg rsmu_sabre_range_cfg[] = {
 	{
 		.range_min = 0,
@@ -55,35 +44,142 @@ static const struct regmap_range_cfg rsmu_sabre_range_cfg[] = {
 	}
 };
 
-static bool rsmu_cm_volatile_reg(struct device *dev, unsigned int reg)
+static bool rsmu_sabre_volatile_reg(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
-	case RSMU_CM_PAGE_ADDR:
+	case RSMU_SABRE_PAGE_ADDR:
 		return false;
 	default:
 		return true;
 	}
 }
 
-static bool rsmu_sabre_volatile_reg(struct device *dev, unsigned int reg)
+static int rsmu_read_device(struct rsmu_ddata *rsmu, u8 reg, u8 *buf, u16 bytes)
 {
-	switch (reg) {
-	case RSMU_SABRE_PAGE_ADDR:
-		return false;
-	default:
-		return true;
+	struct i2c_client *client = to_i2c_client(rsmu->dev);
+	struct i2c_msg msg[2];
+	int cnt;
+
+	msg[0].addr = client->addr;
+	msg[0].flags = 0;
+	msg[0].len = 1;
+	msg[0].buf = &reg;
+
+	msg[1].addr = client->addr;
+	msg[1].flags = I2C_M_RD;
+	msg[1].len = bytes;
+	msg[1].buf = buf;
+
+	cnt = i2c_transfer(client->adapter, msg, 2);
+
+	if (cnt < 0) {
+		dev_err(rsmu->dev, "i2c_transfer failed at addr: %04x!", reg);
+		return cnt;
+	} else if (cnt != 2) {
+		dev_err(rsmu->dev,
+			"i2c_transfer sent only %d of 2 messages", cnt);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int rsmu_write_device(struct rsmu_ddata *rsmu, u8 reg, u8 *buf, u16 bytes)
+{
+	struct i2c_client *client = to_i2c_client(rsmu->dev);
+	/* we add 1 byte for device register */
+	u8 msg[RSMU_MAX_WRITE_COUNT + 1];
+	int cnt;
+
+	if (bytes > RSMU_MAX_WRITE_COUNT)
+		return -EINVAL;
+
+	msg[0] = reg;
+	memcpy(&msg[1], buf, bytes);
+
+	cnt = i2c_master_send(client, msg, bytes + 1);
+
+	if (cnt < 0) {
+		dev_err(&client->dev,
+			"i2c_master_send failed at addr: %04x!", reg);
+		return cnt;
 	}
+
+	return 0;
+}
+
+static int rsmu_write_page_register(struct rsmu_ddata *rsmu, u32 reg)
+{
+	u32 page = reg & RSMU_CM_PAGE_MASK;
+	u8 buf[4];
+	int err;
+
+	/* Do not modify offset register for none-scsr registers */
+	if (reg < RSMU_CM_SCSR_BASE)
+		return 0;
+
+	/* Simply return if we are on the same page */
+	if (rsmu->page == page)
+		return 0;
+
+	buf[0] = 0x0;
+	buf[1] = (u8)((page >> 8) & 0xFF);
+	buf[2] = (u8)((page >> 16) & 0xFF);
+	buf[3] = (u8)((page >> 24) & 0xFF);
+
+	err = rsmu_write_device(rsmu, RSMU_CM_PAGE_ADDR, buf, sizeof(buf));
+	if (err)
+		dev_err(rsmu->dev, "Failed to set page offset 0x%x\n", page);
+	else
+		/* Remember the last page */
+		rsmu->page = page;
+
+	return err;
+}
+
+static int rsmu_reg_read(void *context, unsigned int reg, unsigned int *val)
+{
+	struct rsmu_ddata *rsmu = i2c_get_clientdata((struct i2c_client *)context);
+	u8 addr = (u8)(reg & RSMU_CM_ADDRESS_MASK);
+	int err;
+
+	err = rsmu_write_page_register(rsmu, reg);
+	if (err)
+		return err;
+
+	err = rsmu_read_device(rsmu, addr, (u8 *)val, 1);
+	if (err)
+		dev_err(rsmu->dev, "Failed to read offset address 0x%x\n", addr);
+
+	return err;
+}
+
+static int rsmu_reg_write(void *context, unsigned int reg, unsigned int val)
+{
+	struct rsmu_ddata *rsmu = i2c_get_clientdata((struct i2c_client *)context);
+	u8 addr = (u8)(reg & RSMU_CM_ADDRESS_MASK);
+	u8 data = (u8)val;
+	int err;
+
+	err = rsmu_write_page_register(rsmu, reg);
+	if (err)
+		return err;
+
+	err = rsmu_write_device(rsmu, addr, &data, 1);
+	if (err)
+		dev_err(rsmu->dev,
+			"Failed to write offset address 0x%x\n", addr);
+
+	return err;
 }
 
 static const struct regmap_config rsmu_cm_regmap_config = {
-	.reg_bits = 8,
+	.reg_bits = 32,
 	.val_bits = 8,
-	.max_register = 0xD000,
-	.ranges = rsmu_cm_range_cfg,
-	.num_ranges = ARRAY_SIZE(rsmu_cm_range_cfg),
-	.volatile_reg = rsmu_cm_volatile_reg,
-	.cache_type = REGCACHE_RBTREE,
-	.can_multi_write = true,
+	.max_register = 0x20120000,
+	.reg_read = rsmu_reg_read,
+	.reg_write = rsmu_reg_write,
+	.cache_type = REGCACHE_NONE,
 };
 
 static const struct regmap_config rsmu_sabre_regmap_config = {
@@ -101,14 +197,14 @@ static const struct regmap_config rsmu_sl_regmap_config = {
 	.reg_bits = 16,
 	.val_bits = 8,
 	.reg_format_endian = REGMAP_ENDIAN_BIG,
-	.max_register = 0x339,
+	.max_register = 0x340,
 	.cache_type = REGCACHE_NONE,
 	.can_multi_write = true,
 };
 
-static int rsmu_i2c_probe(struct i2c_client *client)
+static int rsmu_i2c_probe(struct i2c_client *client,
+			  const struct i2c_device_id *id)
 {
-	const struct i2c_device_id *id = i2c_client_get_device_id(client);
 	const struct regmap_config *cfg;
 	struct rsmu_ddata *rsmu;
 	int ret;
@@ -136,7 +232,11 @@ static int rsmu_i2c_probe(struct i2c_client *client)
 		dev_err(rsmu->dev, "Unsupported RSMU device type: %d\n", rsmu->type);
 		return -ENODEV;
 	}
-	rsmu->regmap = devm_regmap_init_i2c(client, cfg);
+
+	if (rsmu->type == RSMU_CM)
+		rsmu->regmap = devm_regmap_init(&client->dev, NULL, client, cfg);
+	else
+		rsmu->regmap = devm_regmap_init_i2c(client, cfg);
 	if (IS_ERR(rsmu->regmap)) {
 		ret = PTR_ERR(rsmu->regmap);
 		dev_err(rsmu->dev, "Failed to allocate register map: %d\n", ret);
@@ -180,7 +280,7 @@ static struct i2c_driver rsmu_i2c_driver = {
 		.name = "rsmu-i2c",
 		.of_match_table = of_match_ptr(rsmu_i2c_of_match),
 	},
-	.probe_new = rsmu_i2c_probe,
+	.probe = rsmu_i2c_probe,
 	.remove	= rsmu_i2c_remove,
 	.id_table = rsmu_i2c_id,
 };
diff --git a/drivers/mfd/rsmu_spi.c b/drivers/mfd/rsmu_spi.c
index 2428aaa9aaed..a4a595bb8d0d 100644
--- a/drivers/mfd/rsmu_spi.c
+++ b/drivers/mfd/rsmu_spi.c
@@ -19,19 +19,21 @@
 
 #define	RSMU_CM_PAGE_ADDR		0x7C
 #define	RSMU_SABRE_PAGE_ADDR		0x7F
-#define	RSMU_HIGHER_ADDR_MASK		0xFF80
-#define	RSMU_HIGHER_ADDR_SHIFT		7
-#define	RSMU_LOWER_ADDR_MASK		0x7F
+#define	RSMU_PAGE_MASK			0xFFFFFF80
+#define	RSMU_ADDR_MASK			0x7F
 
 static int rsmu_read_device(struct rsmu_ddata *rsmu, u8 reg, u8 *buf, u16 bytes)
 {
 	struct spi_device *client = to_spi_device(rsmu->dev);
 	struct spi_transfer xfer = {0};
 	struct spi_message msg;
-	u8 cmd[256] = {0};
-	u8 rsp[256] = {0};
+	u8 cmd[RSMU_MAX_READ_COUNT + 1] = {0};
+	u8 rsp[RSMU_MAX_READ_COUNT + 1] = {0};
 	int ret;
 
+	if (bytes > RSMU_MAX_READ_COUNT)
+		return -EINVAL;
+
 	cmd[0] = reg | 0x80;
 	xfer.rx_buf = rsp;
 	xfer.len = bytes + 1;
@@ -66,7 +68,10 @@ static int rsmu_write_device(struct rsmu_ddata *rsmu, u8 reg, u8 *buf, u16 bytes
 	struct spi_device *client = to_spi_device(rsmu->dev);
 	struct spi_transfer xfer = {0};
 	struct spi_message msg;
-	u8 cmd[256] = {0};
+	u8 cmd[RSMU_MAX_WRITE_COUNT + 1] = {0};
+
+	if (bytes > RSMU_MAX_WRITE_COUNT)
+		return -EINVAL;
 
 	cmd[0] = reg;
 	memcpy(&cmd[1], buf, bytes);
@@ -86,26 +91,35 @@ static int rsmu_write_device(struct rsmu_ddata *rsmu, u8 reg, u8 *buf, u16 bytes
  * 16-bit register address: the lower 7 bits of the register address come
  * from the offset addr byte and the upper 9 bits come from the page register.
  */
-static int rsmu_write_page_register(struct rsmu_ddata *rsmu, u16 reg)
+static int rsmu_write_page_register(struct rsmu_ddata *rsmu, u32 reg)
 {
 	u8 page_reg;
-	u8 buf[2];
+	u8 buf[4];
 	u16 bytes;
-	u16 page;
+	u32 page;
 	int err;
 
 	switch (rsmu->type) {
 	case RSMU_CM:
+		/* Do not modify page register for none-scsr registers */
+		if (reg < RSMU_CM_SCSR_BASE)
+			return 0;
 		page_reg = RSMU_CM_PAGE_ADDR;
-		page = reg & RSMU_HIGHER_ADDR_MASK;
+		page = reg & RSMU_PAGE_MASK;
 		buf[0] = (u8)(page & 0xff);
 		buf[1] = (u8)((page >> 8) & 0xff);
-		bytes = 2;
+		buf[2] = (u8)((page >> 16) & 0xff);
+		buf[3] = (u8)((page >> 24) & 0xff);
+		bytes = 4;
 		break;
 	case RSMU_SABRE:
+		/* Do not modify page register if reg is page register itself */
+		if ((reg & RSMU_ADDR_MASK) == RSMU_ADDR_MASK)
+			return 0;
 		page_reg = RSMU_SABRE_PAGE_ADDR;
-		page = reg >> RSMU_HIGHER_ADDR_SHIFT;
-		buf[0] = (u8)(page & 0xff);
+		page = reg & RSMU_PAGE_MASK;
+		/* The three page bits are located in the single Page Register */
+		buf[0] = (u8)((page >> 7) & 0x7);
 		bytes = 1;
 		break;
 	default:
@@ -129,8 +143,8 @@ static int rsmu_write_page_register(struct rsmu_ddata *rsmu, u16 reg)
 
 static int rsmu_reg_read(void *context, unsigned int reg, unsigned int *val)
 {
-	struct rsmu_ddata *rsmu = spi_get_drvdata(context);
-	u8 addr = (u8)(reg & RSMU_LOWER_ADDR_MASK);
+	struct rsmu_ddata *rsmu = spi_get_drvdata((struct spi_device *)context);
+	u8 addr = (u8)(reg & RSMU_ADDR_MASK);
 	int err;
 
 	err = rsmu_write_page_register(rsmu, reg);
@@ -146,8 +160,8 @@ static int rsmu_reg_read(void *context, unsigned int reg, unsigned int *val)
 
 static int rsmu_reg_write(void *context, unsigned int reg, unsigned int val)
 {
-	struct rsmu_ddata *rsmu = spi_get_drvdata(context);
-	u8 addr = (u8)(reg & RSMU_LOWER_ADDR_MASK);
+	struct rsmu_ddata *rsmu = spi_get_drvdata((struct spi_device *)context);
+	u8 addr = (u8)(reg & RSMU_ADDR_MASK);
 	u8 data = (u8)val;
 	int err;
 
@@ -164,9 +178,9 @@ static int rsmu_reg_write(void *context, unsigned int reg, unsigned int val)
 }
 
 static const struct regmap_config rsmu_cm_regmap_config = {
-	.reg_bits = 16,
+	.reg_bits = 32,
 	.val_bits = 8,
-	.max_register = 0xD000,
+	.max_register = 0x20120000,
 	.reg_read = rsmu_reg_read,
 	.reg_write = rsmu_reg_write,
 	.cache_type = REGCACHE_NONE,
diff --git a/include/linux/mfd/rsmu.h b/include/linux/mfd/rsmu.h
index 6870de608233..0379aa207428 100644
--- a/include/linux/mfd/rsmu.h
+++ b/include/linux/mfd/rsmu.h
@@ -8,6 +8,9 @@
 #ifndef __LINUX_MFD_RSMU_H
 #define __LINUX_MFD_RSMU_H
 
+#define RSMU_MAX_WRITE_COUNT	(255)
+#define RSMU_MAX_READ_COUNT	(255)
+
 /* The supported devices are ClockMatrix, Sabre and SnowLotus */
 enum rsmu_type {
 	RSMU_CM		= 0x34000,
@@ -31,6 +34,6 @@ struct rsmu_ddata {
 	struct regmap *regmap;
 	struct mutex lock;
 	enum rsmu_type type;
-	u16 page;
+	u32 page;
 };
 #endif /*  __LINUX_MFD_RSMU_H */
-- 
2.39.2

