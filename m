Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6998F212F68
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 00:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgGBWUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 18:20:39 -0400
Received: from mail-eopbgr70087.outbound.protection.outlook.com ([40.107.7.87]:22294
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726102AbgGBWUi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 18:20:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ITdsIqyVBQcG+Q6ZklAfTAYHxwNP4VUtoQfsqGrGGdlBDk1LoPV4Zqg4hgc75GEwz9tivsxafdzu/XCd/GPrJiIBQXaHolZFp1YWrbAJ9qx0Fl9j4313lij5B0BPmxWj3VtYmGFvDV8iT1AfcV8l4nLcccWYlQooZR6gOpuQe26JzHe+2MyhheF3ZOtt0R4EU8meWmTHD7OjhVDZiDc9CzMtU6/56zNARpIVOG4DPK3QSyrNF92OS3PSAlkBXllBJAT+468JpP4iC+9Jjpjyh5hel6UTP05bVHpTTNcWXNw9dXalW5Y3lnRnKv3M8fvgrKoPOqhRH8P+pEfY0ZqXBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6KFoXoZEZ66XQEa4/zwDKjh4ICorS0TeJVsNBqo+vqA=;
 b=duZfmN5l1vP35VYTVcA7DCZKOsZdIRXnbBBkc+Wbdf/mFaAWED3ifZKEKuOmyZS7Prkj8O+zcB9LF3fOI7Ib5ajxD0ff4l7ZIgtTyW3NX76GOfUlAZb5z0Rf52yG+PxPSYez9VIR7gLbHgIrCOHTYeZnQWApZmxesAL0MTzDAxzq/7Uz+JdMJPzPK3pq7/E3ozBPADSiWSfZWNE47epOBNISSwiYgUd4mVtvq2sRU2QzYP7o4ga0Gj2GkcsaQLXYMyoYsZNb9EuBaL+RzTGqAaVIJc0fKQIpO0Y2viIFOXcBhoNoFPx1aKs1bd3VM4RLYWHOsoviuWFBZ6ZnstDU9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6KFoXoZEZ66XQEa4/zwDKjh4ICorS0TeJVsNBqo+vqA=;
 b=GooyXo2ELXkXtkaMRrrzhvONXgOorRhlNan6K0MSll1rzu5Y8ByjCdhSl5oBmgEI6MuV3pY9aq18Pn+ite163+NNitla7qK0QYcjkonniYqeOAGT7lSddnJ6YE9LLuhWqavIbJYJNyG+Ne5kYx0Nqx89Co/js5JjquCDLyCNBcE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6109.eurprd05.prod.outlook.com (2603:10a6:803:e4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22; Thu, 2 Jul
 2020 22:20:33 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3153.023; Thu, 2 Jul 2020
 22:20:33 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Huy Nguyen <huyn@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 01/11] net/mlx5: Fix eeprom support for SFP module
Date:   Thu,  2 Jul 2020 15:19:13 -0700
Message-Id: <20200702221923.650779-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200702221923.650779-1-saeedm@mellanox.com>
References: <20200702221923.650779-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0030.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::40) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0030.namprd04.prod.outlook.com (2603:10b6:a03:1d0::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22 via Frontend Transport; Thu, 2 Jul 2020 22:20:31 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: be5bf754-312a-4e12-8e21-08d81ed622ef
X-MS-TrafficTypeDiagnostic: VI1PR05MB6109:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6109C14B55E414A7ACC65027BE6D0@VI1PR05MB6109.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-Forefront-PRVS: 0452022BE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: euNWxNCd/Hf1rB+g2cGB9T9zlU2JIfOMsKtt6EQtjkEButT64hrW44acnbHPqaUNZD0bjKsTLwQ7/RIkTYPON6EasLpf7F9ZFjVmPOktLBZfSkkIA1tHjDY1SwL13EdJ+V74eueNt5AH+DnmKmuoF4hboe+SdQ8MqSfto0Q3iK7hcCO7nx7f0s1Ln5jsOZ+P5qnw9WI9DrQmSiFivmEIj+PBm3vzyxuMbWePXLw3mvEAo3zk6IKdSZ7S1a4aMzcyCXgu7S3xK6s8OE6hEbX9Hduw0vnj4zYQNqXhxDChfrUPJ5TbiQsV43zQJYlh7+8Oa0ypSuOS51OmLodDq32GQCxG8K9miVYQNXm9gusgyex+T/+vbNRwWP9isUsJb0gv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(376002)(346002)(396003)(136003)(26005)(2616005)(316002)(956004)(6666004)(5660300002)(8936002)(86362001)(110136005)(186003)(16526019)(107886003)(83380400001)(4326008)(66946007)(54906003)(8676002)(6506007)(6486002)(1076003)(36756003)(52116002)(6512007)(66476007)(2906002)(66556008)(478600001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 2ACLLJ1om2/Cvn2nDHDu9FVde59q2uohqkuIdTM0t0Jo8SA3iQPLi89q1s36qOHOUpLW8t8tzMwvDN857CWYqKR8OARqVhZjTwo5UdkVueGtGUBEpmIYkiXKWQCBnFU8A4EItfn2qKVK5cI9OxvkNRcMhRLZ3Gn4LEwEMZkYMUzoiz+vz4aB482gjmYBrEmIc7RkftVmuoDzzvK9wX1v+/EGNv+ZFuUvhwm4oK99q1nQNxqv/0ly3WJeMp52J0RtDM+vAg7inMyPvXy+PCqik0j0qC1tMHhkDjht6pmbf9AfQYKh5zhkZ3RCUCjReSNDMa39DmhhrTi0QdMG+18nOz1yhY6AKY2omeTWkG74aWfj0cNK3O+H/1pcIGtAwHkB3B8Za525xtczVDB6f+gubEYYF5fPusC7PSm67Sf5FM7+coh+KsIuf7S3RNhvmpQweAUIHIx/z2OWYu9PwABKDFyBYyLO+OrIqENWfRJUj4o=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be5bf754-312a-4e12-8e21-08d81ed622ef
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2020 22:20:33.3073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2z6Ayu+pc77G4Y5PzjfBciemIDLmqkmVTrlS+61OsJ9S03DaNOKzp0UtyBK3E8v+3rsOXBOL/XJ6geV7efFXog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6109
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

