Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A536641D61
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 15:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbiLDORD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 09:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbiLDOQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 09:16:59 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2040.outbound.protection.outlook.com [40.107.243.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793181741B
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 06:16:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jFABqyuJ4NKOr4XNc1tEO/i20n5HODhlJeI54dGPz1NCP5GXIAouhwFv6+INjbfY68/NfQ6Fgl3niVi6r++gu2j33Nep72XyDtnFHQlTaS85yx0KUhmmisb7O6ObqhTdghBNCVz3rYwsMyzgMao0EP2lCsGSgheqH8xgDZ+W1hp3/XO6LR0rOCj4sqv73dextm/xRCwvL1VFWNmELhtwNDvahj/dmlfG65c+NrEVVk5cxuYfNNvZYyFoqTa1dt5gj8vhyPwjOcZZvChshxGfmVTmiD3cD+m3pEfLCIpr5augdX7TvL5zPuOdatoqeNJVAWP4gvN4c9WbbaoiGqgyZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GhDlb8jL8S94Uay1+/DxuoQBvdivmilavc+TsBlhFLo=;
 b=ZrRl4/u9ovB/ntejoZ5BNivSzBri56rG2N4J/UwcoVW15BBaaiEcpkWkyhAWnbKDPGmvT/cv86ukRPSuWu/rpL+/BzX7lPUNA13Bph2rm98hJ0t54lbjG89FQFdegzgnoHdJNQQNSiGINx6tkMT+TZ+mw5GIul7SPd4lyjRLLM7UQxGzM4QTdEYCT17YpIhyaNp/0g9muTUQ5QERTe/N+ogXmeFdGDQHt0fB9Tc1gq0XVLNy9M5ZmaMqY+yAO8C0uZgGwqbQXYg7eZrt53MalBZWqALSAIsI4ZaO75eThCr44+UVe4D7Q6noCCCYSeHa/JfitM7cEQGdIPqUEREh6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GhDlb8jL8S94Uay1+/DxuoQBvdivmilavc+TsBlhFLo=;
 b=OUXprYVOqBiL/HqaS0arH09r6/hqqyC6k/YsIu2KbERs0fy5xtzKVeb7V+J7dAjdEEHahSrjZP8O9fjigjUwYp5lvyC/msEcGJrl2allG8NhqC/dGdXvREKYYLx8tBsERKd5Rzt2NTOUAytEdP6Lq5GQt2jS4/1e5uachV1WDh9NeJ4eWj7Vw1L3ek43EGHQb+QcppmeZU9aYvu4thN3D2D5WJWLoMYlK7wecnVZyyl9j1DlEY8+7UL+ns6pDSakjhgPNgl/48WTmhz4DGWYsHph9HeVE7s7vF9nc+2MpJwhoJfTKNIWh5v59/5Kl228y1AeTODRhETUe6y3AXTdZw==
Received: from DS7PR03CA0288.namprd03.prod.outlook.com (2603:10b6:5:3ad::23)
 by CH0PR12MB5089.namprd12.prod.outlook.com (2603:10b6:610:bc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Sun, 4 Dec
 2022 14:16:57 +0000
Received: from DM6NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::d8) by DS7PR03CA0288.outlook.office365.com
 (2603:10b6:5:3ad::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13 via Frontend
 Transport; Sun, 4 Dec 2022 14:16:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT018.mail.protection.outlook.com (10.13.172.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.13 via Frontend Transport; Sun, 4 Dec 2022 14:16:56 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 4 Dec 2022
 06:16:48 -0800
Received: from nps-server-23.mtl.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Sun, 4 Dec 2022 06:16:46 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>
CC:     <danielj@nvidia.com>, <yishaih@nvidia.com>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <parav@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: [PATCH net-next V3 2/8] devlink: Validate port function request
Date:   Sun, 4 Dec 2022 16:16:26 +0200
Message-ID: <20221204141632.201932-3-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221204141632.201932-1-shayd@nvidia.com>
References: <20221204141632.201932-1-shayd@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT018:EE_|CH0PR12MB5089:EE_
X-MS-Office365-Filtering-Correlation-Id: 25bd8e70-f7c9-444b-972f-08dad6023390
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vXxq6dBneXONcEgNJbJuVcd8dIJ/4F+KmvV/8sQ+7sF+zgxdXyFw5AIx8+MBfMwQYlsMSNb8ApkWL2WDhvo/6TNJ5PGC4J2plkA3ta195ZWXi7rKjhzIjZGTg2YJvBzyxbnnio2pzCKgjY0TQ3Rv8tM0KH0qKiiDPBEA7IxaRK40WO13Ud2CQN227ZmrQNsG615yeZDJ2sDTN7F6HONeSKE+0hUKQFI9tUr/HIPv+xjXuC8Vk0+NFPprn4bm0mgbuOqiHcZoj65E3qEKVw2ZGzYUUSjxEOjaqS9Ibav0AE/FmQopyIVkDZHWtajr7760fSag/rJ7YDhdYAvzj+ESb5BaBZ1fPJ62agUfqbNkgn3cZFwBvnfYnD83WZTNAAlr182leKiE7AY03Yixw9KsdRafrvNRrouLJ9PC4oIAPlsJEV/PpduRyJAxCG2lIrBX4/1d1rCnvFjUN6K7OQziVSEX77xoWKrkkgWSRA0Ccu1ig1zMNJvfJtMICzbP1YpTu4ejc1MCbtZz9yVeRWZS+uSoEALRDXE0PSGONMGVuVxi1eQLYlRkj9/mliETivdvu0IBF7Jbe1B67OwABqkooFDwP3C/HGiZaIrWOzLLTHXVMPbRwzUUJm53B1jZCU1ufxAl/Ohegu5ZGCyGl6IGy2diKzidTWJrQYQaR0BHSx7YCi2/kI+sNcSE2bVcOloaMrjYJRU/Bx1E6yrlb0vzaw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(396003)(39860400002)(451199015)(36840700001)(46966006)(40470700004)(426003)(47076005)(478600001)(86362001)(40460700003)(356005)(7636003)(40480700001)(36756003)(82740400003)(26005)(36860700001)(83380400001)(2616005)(16526019)(1076003)(336012)(186003)(82310400005)(8676002)(5660300002)(41300700001)(107886003)(15650500001)(6666004)(70586007)(4326008)(110136005)(70206006)(316002)(8936002)(54906003)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2022 14:16:56.8176
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 25bd8e70-f7c9-444b-972f-08dad6023390
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5089
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to avoid partial request processing, validate the request
before processing it.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
v2->v3:
 - replace NL_SET_ERR_MSG_MOD with NL_SET_ERR_MSG_ATTR
---
 net/core/devlink.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index fca3ebee97b0..2b6e11277837 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1644,11 +1644,6 @@ static int devlink_port_function_hw_addr_set(struct devlink_port *port,
 		}
 	}
 
-	if (!ops->port_function_hw_addr_set) {
-		NL_SET_ERR_MSG_MOD(extack, "Port doesn't support function attributes");
-		return -EOPNOTSUPP;
-	}
-
 	return ops->port_function_hw_addr_set(port, hw_addr, hw_addr_len,
 					      extack);
 }
@@ -1662,12 +1657,27 @@ static int devlink_port_fn_state_set(struct devlink_port *port,
 
 	state = nla_get_u8(attr);
 	ops = port->devlink->ops;
-	if (!ops->port_fn_state_set) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "Function does not support state setting");
+	return ops->port_fn_state_set(port, state, extack);
+}
+
+static int devlink_port_function_validate(struct devlink_port *devlink_port,
+					  struct nlattr **tb,
+					  struct netlink_ext_ack *extack)
+{
+	const struct devlink_ops *ops = devlink_port->devlink->ops;
+
+	if (tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR] &&
+	    !ops->port_function_hw_addr_set) {
+		NL_SET_ERR_MSG_ATTR(extack, tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR],
+				    "Port doesn't support function attributes");
 		return -EOPNOTSUPP;
 	}
-	return ops->port_fn_state_set(port, state, extack);
+	if (tb[DEVLINK_PORT_FN_ATTR_STATE] && !ops->port_fn_state_set) {
+		NL_SET_ERR_MSG_ATTR(extack, tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR],
+				    "Function does not support state setting");
+		return -EOPNOTSUPP;
+	}
+	return 0;
 }
 
 static int devlink_port_function_set(struct devlink_port *port,
@@ -1684,6 +1694,10 @@ static int devlink_port_function_set(struct devlink_port *port,
 		return err;
 	}
 
+	err = devlink_port_function_validate(port, tb, extack);
+	if (err)
+		return err;
+
 	attr = tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR];
 	if (attr) {
 		err = devlink_port_function_hw_addr_set(port, attr, extack);
-- 
2.38.1

