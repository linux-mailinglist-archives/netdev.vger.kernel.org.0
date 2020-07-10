Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D338F21AD16
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 04:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbgGJCa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 22:30:58 -0400
Received: from mail-eopbgr30081.outbound.protection.outlook.com ([40.107.3.81]:54404
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726945AbgGJCa5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 22:30:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Argp1Q5OrGTlK4kjsMSgookAndPbx5UaNnJcCLo7PBAoLRLYOKXMIYKoj6/StfobdkIEvhs92W+e3998pfkyGR3YTPxuE9GDwv8idCJFpNDorMWueW3sj+sEyhUi9j9iBwvNnHk+ZdYXEmIQWpQEP55KzPjBy27VlWQxzPuqGrhabBVrTH4XXURLIRYhOeS3u3My/N22oVZk6jFAeyP4uVhGunbsSlShbnOU3KPjtaD3/JhRBYhW0DXrAKDgB5VWmVMzKi/hfxKwp49J9ojAn9SS3x3VUueLxtZpPBada1CdcZmgETDJZD33heQZhg4lSrQMQH7kKGYpwksx0HfUDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6KFoXoZEZ66XQEa4/zwDKjh4ICorS0TeJVsNBqo+vqA=;
 b=Ty+ccKipjdi/UiCwTuMKv+XsW/KrjTkijqsDFSgzFRAU3iG9T1IoANwlQ6X153wjGHT4zE4FCgt7ZUHVOy8CNNJSVpbfKwsQAsG8r7M2ChwyK2aRPr5GVDyVTOeqfBlOeaqHb0PIwAUK2kYFnQXda/4744gatzG9FBUebZZLaEFno5dq7SZH0/B8fOQSZRQyMn5iiqAT0qTyrLB9nC1ci4tmOHwZ6TqEWYs6LAp+q3f2xOePi/9RxVsr8xOBw/Ed+0A2cBw0hmAJVWYbzgBjAbgQY9cllWBnoKWE9YOtPL7tjqbwu6CEE2m/It5AjNlOPTfJpxl0NcbHCTS6PDQ+ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6KFoXoZEZ66XQEa4/zwDKjh4ICorS0TeJVsNBqo+vqA=;
 b=MtbVv31CH0KxyLt7OE4bg1cSLbklcSjy22dV8lXnb3EOICSdNnhFyY/zLY1yXt7nXVNQ5NWN0fShSqzGqfWI68ZA0ZkVJ/W2Cwrn1Y+LaF+OtnNS4DMVf5MqZF+FlUbKxyGkW5jZ0GBPNtAaXcNV67nGBnsN23cgmqRYBRf4TmI=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7120.eurprd05.prod.outlook.com (2603:10a6:800:185::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Fri, 10 Jul
 2020 02:30:50 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.022; Fri, 10 Jul 2020
 02:30:50 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Huy Nguyen <huyn@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 1/9] net/mlx5: Fix eeprom support for SFP module
Date:   Thu,  9 Jul 2020 19:30:10 -0700
Message-Id: <20200710023018.31905-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200710023018.31905-1-saeedm@mellanox.com>
References: <20200710023018.31905-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0064.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::41) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0064.namprd06.prod.outlook.com (2603:10b6:a03:14b::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Fri, 10 Jul 2020 02:30:48 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1751a5a8-d788-4f00-8ed7-08d8247942cb
X-MS-TrafficTypeDiagnostic: VI1PR05MB7120:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB7120BE770F9E7813F6BF61E7BE650@VI1PR05MB7120.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JbYd3CUXS6ATLiKxbuIFw3cSmyDh+BjRaP9Gh4/lsxJa9x5TsQgPx1WAS6kqCB/EWJwY1x3BYdTsXOPh+hFFwFKKpSsB/bIlDX9msTmLRR84D9f9ODdwWNQOl42veZeEvXw1lsOAKNsSul7Quhmp2Ks15Ti+lvbr0etQt2onQ+0HNAlr1/b9zZdZfOjWaQLhDwWF3XUZeSydYg0pkhNcagcP2cqC8oS2IC8DiTm/Epr71IjPNwN6+MIemDdrh0DMIQ2O46GbroT59py0adwRWCZw35zCtLwGiBwSC1ahiJX0vJvaCyEoVxHhfsin7PnRI1kGb27JXnJRzulkGhihpueFQb6vp5lT50JFI5pgByk1iLqmU2aQKEOW5F5UZrCf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(136003)(39860400002)(366004)(346002)(478600001)(26005)(4326008)(86362001)(52116002)(83380400001)(956004)(2906002)(186003)(16526019)(6506007)(2616005)(6666004)(5660300002)(8676002)(8936002)(66946007)(107886003)(66556008)(316002)(66476007)(1076003)(6512007)(110136005)(36756003)(6486002)(54906003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: jSM12PfMBnlQgd+xcAGdoj91QknYrOnxalFJnBK3MRMw97sHkVUBjMjeC2/f5Yw9jWKxbbf1ZY0AVWHZFODip11u6NFtXC/yQ7QoxpLYe6Apvw8IYYsGYyDXF+SK/r+wANr3DHBEjOQnc0x5nys0dURKLnVICy3MQnJ1WmhFUNv3d2xgezeRJBhCvNidC26UBFXasrcsy1xnqO/E42dK11Zy7zecTmfuK0CiahNxHCRxjiqbREFJvzb9GtLBz+UFuzGey5HMPMY5MmogYogOPdDXPbhE7QDe4R3qqE5B0Q2r/8LuhBw+a7xrN5dA0wlNPzU3Gqc+iyYZoxoQ1gH4FLNE+zi2jPe3UF6Bo/W9m3KRottEySP6zbBrav2u/krMKHXwyECkK+DL3DVpuUOw6qbTgSTzqMnMkiVHehSMgVQs6yCQZPgb0zmacGeeSMBHMwEumFVKtFTFXzuNSkCx0t6n+KtXv8/OrY9CkUO8hKk=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1751a5a8-d788-4f00-8ed7-08d8247942cb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 02:30:50.5133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W996Sz5cHL72rHm/GZILO6thsPgB2BinNTQXc8xAH101FK+kFGBptq3TXWR2UyI2YibkNB4BhBM2u6JVqjadCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7120
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

Fix eeprom SFP query support by setting i2c_addr, offset and page number
correctly. Unlike QSFP modules, SFP eeprom params are as follow:
- i2c_addr is 0x50 for offset 0 - 255 and 0x51 for offset 256 - 511.
- Page number is always zero.
- Page offset is always relative to zero.

As part of eeprom query, query the module ID (SFP / QSFP*) via helper
function to set the params accordingly.

In addition, change mlx5_qsfp_eeprom_page() input type to be u16 to avoid
unnecessary casting.

Fixes: a708fb7b1f8d ("net/mlx5e: ethtool, Add support for EEPROM high pages query")
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Huy Nguyen <huyn@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/port.c    | 93 +++++++++++++++----
 1 file changed, 77 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/port.c b/drivers/net/ethernet/mellanox/mlx5/core/port.c
index 9f829e68fc73..e4186e84b3ff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -293,7 +293,40 @@ static int mlx5_query_module_num(struct mlx5_core_dev *dev, int *module_num)
 	return 0;
 }
 
-static int mlx5_eeprom_page(int offset)
+static int mlx5_query_module_id(struct mlx5_core_dev *dev, int module_num,
+				u8 *module_id)
+{
+	u32 in[MLX5_ST_SZ_DW(mcia_reg)] = {};
+	u32 out[MLX5_ST_SZ_DW(mcia_reg)];
+	int err, status;
+	u8 *ptr;
+
+	MLX5_SET(mcia_reg, in, i2c_device_address, MLX5_I2C_ADDR_LOW);
+	MLX5_SET(mcia_reg, in, module, module_num);
+	MLX5_SET(mcia_reg, in, device_address, 0);
+	MLX5_SET(mcia_reg, in, page_number, 0);
+	MLX5_SET(mcia_reg, in, size, 1);
+	MLX5_SET(mcia_reg, in, l, 0);
+
+	err = mlx5_core_access_reg(dev, in, sizeof(in), out,
+				   sizeof(out), MLX5_REG_MCIA, 0, 0);
+	if (err)
+		return err;
+
+	status = MLX5_GET(mcia_reg, out, status);
+	if (status) {
+		mlx5_core_err(dev, "query_mcia_reg failed: status: 0x%x\n",
+			      status);
+		return -EIO;
+	}
+	ptr = MLX5_ADDR_OF(mcia_reg, out, dword_0);
+
+	*module_id = ptr[0];
+
+	return 0;
+}
+
+static int mlx5_qsfp_eeprom_page(u16 offset)
 {
 	if (offset < MLX5_EEPROM_PAGE_LENGTH)
 		/* Addresses between 0-255 - page 00 */
@@ -307,7 +340,7 @@ static int mlx5_eeprom_page(int offset)
 		    MLX5_EEPROM_HIGH_PAGE_LENGTH);
 }
 
-static int mlx5_eeprom_high_page_offset(int page_num)
+static int mlx5_qsfp_eeprom_high_page_offset(int page_num)
 {
 	if (!page_num) /* Page 0 always start from low page */
 		return 0;
@@ -316,35 +349,62 @@ static int mlx5_eeprom_high_page_offset(int page_num)
 	return page_num * MLX5_EEPROM_HIGH_PAGE_LENGTH;
 }
 
+static void mlx5_qsfp_eeprom_params_set(u16 *i2c_addr, int *page_num, u16 *offset)
+{
+	*i2c_addr = MLX5_I2C_ADDR_LOW;
+	*page_num = mlx5_qsfp_eeprom_page(*offset);
+	*offset -=  mlx5_qsfp_eeprom_high_page_offset(*page_num);
+}
+
+static void mlx5_sfp_eeprom_params_set(u16 *i2c_addr, int *page_num, u16 *offset)
+{
+	*i2c_addr = MLX5_I2C_ADDR_LOW;
+	*page_num = 0;
+
+	if (*offset < MLX5_EEPROM_PAGE_LENGTH)
+		return;
+
+	*i2c_addr = MLX5_I2C_ADDR_HIGH;
+	*offset -= MLX5_EEPROM_PAGE_LENGTH;
+}
+
 int mlx5_query_module_eeprom(struct mlx5_core_dev *dev,
 			     u16 offset, u16 size, u8 *data)
 {
-	int module_num, page_num, status, err;
+	int module_num, status, err, page_num = 0;
+	u32 in[MLX5_ST_SZ_DW(mcia_reg)] = {};
 	u32 out[MLX5_ST_SZ_DW(mcia_reg)];
-	u32 in[MLX5_ST_SZ_DW(mcia_reg)];
-	u16 i2c_addr;
-	void *ptr = MLX5_ADDR_OF(mcia_reg, out, dword_0);
+	u16 i2c_addr = 0;
+	u8 module_id;
+	void *ptr;
 
 	err = mlx5_query_module_num(dev, &module_num);
 	if (err)
 		return err;
 
-	memset(in, 0, sizeof(in));
-	size = min_t(int, size, MLX5_EEPROM_MAX_BYTES);
-
-	/* Get the page number related to the given offset */
-	page_num = mlx5_eeprom_page(offset);
+	err = mlx5_query_module_id(dev, module_num, &module_id);
+	if (err)
+		return err;
 
-	/* Set the right offset according to the page number,
-	 * For page_num > 0, relative offset is always >= 128 (high page).
-	 */
-	offset -= mlx5_eeprom_high_page_offset(page_num);
+	switch (module_id) {
+	case MLX5_MODULE_ID_SFP:
+		mlx5_sfp_eeprom_params_set(&i2c_addr, &page_num, &offset);
+		break;
+	case MLX5_MODULE_ID_QSFP:
+	case MLX5_MODULE_ID_QSFP_PLUS:
+	case MLX5_MODULE_ID_QSFP28:
+		mlx5_qsfp_eeprom_params_set(&i2c_addr, &page_num, &offset);
+		break;
+	default:
+		mlx5_core_err(dev, "Module ID not recognized: 0x%x\n", module_id);
+		return -EINVAL;
+	}
 
 	if (offset + size > MLX5_EEPROM_PAGE_LENGTH)
 		/* Cross pages read, read until offset 256 in low page */
 		size -= offset + size - MLX5_EEPROM_PAGE_LENGTH;
 
-	i2c_addr = MLX5_I2C_ADDR_LOW;
+	size = min_t(int, size, MLX5_EEPROM_MAX_BYTES);
 
 	MLX5_SET(mcia_reg, in, l, 0);
 	MLX5_SET(mcia_reg, in, module, module_num);
@@ -365,6 +425,7 @@ int mlx5_query_module_eeprom(struct mlx5_core_dev *dev,
 		return -EIO;
 	}
 
+	ptr = MLX5_ADDR_OF(mcia_reg, out, dword_0);
 	memcpy(data, ptr, size);
 
 	return size;
-- 
2.26.2

