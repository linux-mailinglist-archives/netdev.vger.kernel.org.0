Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E19C1EBA6F
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 13:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgFBLcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 07:32:05 -0400
Received: from mail-vi1eur05on2054.outbound.protection.outlook.com ([40.107.21.54]:9760
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725900AbgFBLcE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 07:32:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TheUSoRJv47OCoBhPOntthi4ieRc1YqxOnOSdrvaBq1+YBx1WwvkUbBFIvrka+9x4IFfDjnV+ZaA86XlxNu1CKVU86GOJXfRofQkVqWHwmIrxeXsSLdP8dE6R6sB2+7bIDRh8o0jfd0Wl/a7fcnhORNZd4WeVYrnglhkJK9OOUQekEYWka5ORNckyQamRJv301UHsazrfAU8chGqdzFiKy1sgjVcg5TOowXPf89NGQPHmxb6GgF0F1FR5iuRGVe9Rv6Kh4B1e5X/F0xCErGTDA2WdhAWgq8I/G0jXGZwmk0YzKZH74nIQKNE+f7TDaR5THXDcRMwdlqQpXMcOhb/BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/wCwsMA22L0qZootlbQP/Al4oQ/E0oKYswPbwRsaG4Y=;
 b=EM4YAUMUaB75gCwXSc21b95yb3vVxVw5qDDwYG5aMz0+KKJEM9aHTmgVJkmpNIY7m0abbmQVCagJUNUhVEb8x1OPjZ54EXYEPxxPsLcUWj0VanhWLr+NMS/38ozCDFjmmuBkuWWA2GUUGteNqLjGvR7IlWSXXBZAm2iMvRbuv/tYa47xqbLYRxTfGX+hIocuTOCFrlwVN1+48g9hVwe4WXoFUN44L3WPCp+bRXTEiTW9Sk1gGVg3p7wX59gJI5Bueu+ORN0tDQ6hPibZJFWvk+cTiwy9VgL6bZmTVqwPapUzBm96sFyV1N0Q32jwqgu9bOJy1p5mM/9vnZ0z8b+C9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/wCwsMA22L0qZootlbQP/Al4oQ/E0oKYswPbwRsaG4Y=;
 b=adWwf2LMPNn8v003UP7/BGMOGecifH3jp+vJgnv8PAze6no7Hjb7OlYyqXLjHBrz2C+0voYhk9sKIdyfsh7Uu+gEt1U6WqijzndNjGK/EQR55ceMwX/rYHdVrjb66hRI07OnExM3Ntlget/pg9Ch/ygBZxmBEPWulYLx6hF+ba8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
 by AM0PR05MB6628.eurprd05.prod.outlook.com (2603:10a6:20b:15b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Tue, 2 Jun
 2020 11:31:55 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::ccb:c612:f276:a182]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::ccb:c612:f276:a182%6]) with mapi id 15.20.3045.024; Tue, 2 Jun 2020
 11:31:55 +0000
From:   Danielle Ratson <danieller@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, michael.chan@broadcom.com, kuba@kernel.org,
        jeffrey.t.kirsher@intel.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com, snelson@pensando.io,
        drivers@pensando.io, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, mlxsw@mellanox.com,
        Danielle Ratson <danieller@mellanox.com>
Subject: [RFC PATCH net-next 4/8] mlxsw: Set number of port lanes attribute in driver
Date:   Tue,  2 Jun 2020 14:31:15 +0300
Message-Id: <20200602113119.36665-5-danieller@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200602113119.36665-1-danieller@mellanox.com>
References: <20200602113119.36665-1-danieller@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4P190CA0014.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::24) To AM0PR05MB5010.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM4P190CA0014.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21 via Frontend Transport; Tue, 2 Jun 2020 11:31:53 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 33255ab8-36bf-41c1-2b8b-08d806e88dac
X-MS-TrafficTypeDiagnostic: AM0PR05MB6628:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB66281E24DFCEF9B9177EBDD6D58B0@AM0PR05MB6628.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0422860ED4
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b9q+DKDe0sLwWqfXszvsyv0C+2xQy6oRboMcQVXwb3igt/P0yaCaiogjGaP7OLwZz75F1Lidm2f+RnvxmuiWQwQdXuTxCjzwRBu8uLMa/QwSRG5Zw/lweHSwFA673gI0yyFDLE+oBFilUqAVGkFAgGiwRTE358L+HDGNt81TC1IZ+QVhErUwk5RGrfLoOXCgrka4UoZB6nychUPBnlkXbvP8KyABjM7h80MoiCizvlOWcSZjd2t4mMhlruI/WIvNG+xxmH13AWKO2BkZU1d7giUIaUffK+qLgZw34RVtlXGpfuDR/KkaE0i65Tcr5KfTU0A5XyBU/Afs4UQGRh97bz1CYiaR3UOFYadSrax192qUzNmXj3IOULQVGYuVFqF5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5010.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(396003)(136003)(376002)(346002)(186003)(16526019)(26005)(83380400001)(6506007)(86362001)(36756003)(2616005)(2906002)(52116002)(107886003)(6916009)(956004)(6486002)(8676002)(7416002)(66556008)(478600001)(6666004)(6512007)(66476007)(66946007)(5660300002)(316002)(4326008)(8936002)(1076003)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: +c4qCOl69/IQ7b7znKkhlc6klAemvY6hhAF4uySFSpBNTTzooJfpkWn0tGiIC1zjTrWee5s138iuOeZOOBb/VH7tRIGiEC2ckSoa4V1HWAmDH6WL6nVVfpNcruFj/YI1/rv+bYN9Xqq/oOkY8pvDmCfZwSZCwu9h8g1vWAkJDNjto5gut8pBBQOYvtsqBuj1f1yaH+P32WIfnX4hPARLkTenqYRc4kajS+m+arn9AHlExDFGaiZuHU9JlkD9kNQltJkM5mqEq8GwTa6D2bFOgPTcaOlUReOtChjwv1LAorWebMpWe2aNsO9LfLLLGTWumBOmD9sPMjlhCEwqhcpYv57GBWy1KiQFhZk88IJrOYZuA05K1hWPYsYW9o/laHmkxpYqgtrxnHop5NocCiWvKg72Nf1uSMqlrX4Qjtg0bzjIYbu3sDL1RJudREVLrwKVAX790k4o4acp4hP+asWByThIYvciyqfzeHrs4s4FHyFqkRjJ4RxI93bn5Wt/7bB2
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33255ab8-36bf-41c1-2b8b-08d806e88dac
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2020 11:31:55.3924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ND87obwrWdCemjp9TVRDtuPHvppz1XyFalulf1s4kbX/kGokyTIYTm8toUdAn5vZGHnTakzBfgt+TSzqlJJedA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6628
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, port attributes like flavour, port number and whether the
port was split are set when initializing a port.

Set the number of lanes of the port as well so that it could be easily
passed to devlink in the next patch.

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c     | 6 ++++--
 drivers/net/ethernet/mellanox/mlxsw/core.h     | 1 +
 drivers/net/ethernet/mellanox/mlxsw/minimal.c  | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 4 +++-
 drivers/net/ethernet/mellanox/mlxsw/switchib.c | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/switchx2.c | 2 +-
 6 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index bbe7358d4ea5..f44cb1a537f3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -2122,6 +2122,7 @@ static int __mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
 				  enum devlink_port_flavour flavour,
 				  u32 port_number, bool split,
 				  u32 split_port_subnumber,
+				  u32 lanes,
 				  const unsigned char *switch_id,
 				  unsigned char switch_id_len)
 {
@@ -2159,13 +2160,14 @@ static void __mlxsw_core_port_fini(struct mlxsw_core *mlxsw_core, u8 local_port)
 int mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
 			 u32 port_number, bool split,
 			 u32 split_port_subnumber,
+			 u32 lanes,
 			 const unsigned char *switch_id,
 			 unsigned char switch_id_len)
 {
 	return __mlxsw_core_port_init(mlxsw_core, local_port,
 				      DEVLINK_PORT_FLAVOUR_PHYSICAL,
 				      port_number, split, split_port_subnumber,
-				      switch_id, switch_id_len);
+				      lanes, switch_id, switch_id_len);
 }
 EXPORT_SYMBOL(mlxsw_core_port_init);
 
@@ -2186,7 +2188,7 @@ int mlxsw_core_cpu_port_init(struct mlxsw_core *mlxsw_core,
 
 	err = __mlxsw_core_port_init(mlxsw_core, MLXSW_PORT_CPU_PORT,
 				     DEVLINK_PORT_FLAVOUR_CPU,
-				     0, false, 0,
+				     0, false, 0, 0,
 				     switch_id, switch_id_len);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 22b0dfa7cfae..b5c02e6e6865 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -193,6 +193,7 @@ void *mlxsw_core_port_driver_priv(struct mlxsw_core_port *mlxsw_core_port);
 int mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
 			 u32 port_number, bool split,
 			 u32 split_port_subnumber,
+			 u32 lanes,
 			 const unsigned char *switch_id,
 			 unsigned char switch_id_len);
 void mlxsw_core_port_fini(struct mlxsw_core *mlxsw_core, u8 local_port);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index c4caeeadcba9..f9c9d7baf3be 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -164,7 +164,7 @@ mlxsw_m_port_create(struct mlxsw_m *mlxsw_m, u8 local_port, u8 module)
 	int err;
 
 	err = mlxsw_core_port_init(mlxsw_m->core, local_port,
-				   module + 1, false, 0,
+				   module + 1, false, 0, 0,
 				   mlxsw_m->base_mac,
 				   sizeof(mlxsw_m->base_mac));
 	if (err) {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 26e413ad3afb..4b4d639d9ba6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3244,12 +3244,14 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 	struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan;
 	bool split = !!split_base_local_port;
 	struct mlxsw_sp_port *mlxsw_sp_port;
+	u32 lanes = port_mapping->width;
 	struct net_device *dev;
 	int err;
 
 	err = mlxsw_core_port_init(mlxsw_sp->core, local_port,
 				   port_mapping->module + 1, split,
-				   port_mapping->lane / port_mapping->width,
+				   port_mapping->lane / lanes,
+				   lanes,
 				   mlxsw_sp->base_mac,
 				   sizeof(mlxsw_sp->base_mac));
 	if (err) {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/switchib.c b/drivers/net/ethernet/mellanox/mlxsw/switchib.c
index 4ff1e623aa76..1b446e6071b2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/switchib.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/switchib.c
@@ -281,7 +281,7 @@ static int mlxsw_sib_port_create(struct mlxsw_sib *mlxsw_sib, u8 local_port,
 	int err;
 
 	err = mlxsw_core_port_init(mlxsw_sib->core, local_port,
-				   module + 1, false, 0,
+				   module + 1, false, 0, 0,
 				   mlxsw_sib->hw_id, sizeof(mlxsw_sib->hw_id));
 	if (err) {
 		dev_err(mlxsw_sib->bus_info->dev, "Port %d: Failed to init core port\n",
diff --git a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
index b438f5576e18..ac4cd7c23439 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
@@ -1107,7 +1107,7 @@ static int mlxsw_sx_port_eth_create(struct mlxsw_sx *mlxsw_sx, u8 local_port,
 	int err;
 
 	err = mlxsw_core_port_init(mlxsw_sx->core, local_port,
-				   module + 1, false, 0,
+				   module + 1, false, 0, 0,
 				   mlxsw_sx->hw_id, sizeof(mlxsw_sx->hw_id));
 	if (err) {
 		dev_err(mlxsw_sx->bus_info->dev, "Port %d: Failed to init core port\n",
-- 
2.20.1

