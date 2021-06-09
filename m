Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 000893A190C
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 17:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239177AbhFIPSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 11:18:53 -0400
Received: from mail-eopbgr80090.outbound.protection.outlook.com ([40.107.8.90]:23438
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239162AbhFIPSu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 11:18:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bir8F7cfSMK8VtvvkbivVHTLrVLt2LIKbZ5Q3ogtgq+TlmiP7dquFb1efUtweL6OybytgOssz3qk9KCUm0zzdAvaFyD6V4/C0HWgCmNyLfsmrvsrKVEKR6IauQb6DlrQcKvBAur6KhGmFmCAWf2OKUu1xV76YNFee7w8nGq6hAj2nVVI3n7gTVGnZZm/AA3cWLp1WnlyItBM03AhTF/3c1E+ARAeZzSlNeP19HIStCyY/6I8IIG/mKoAHyad0czJ/6xBmcufkLuU2fePZCoTWQNvWccinM9sHiQHqpbXUqw7EMQUtXHlShMqDQ/SkLeojKL9DfAUOwa18323ZeeyRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Qk3NsaokKMhNVfRwOlR1LecjFPqaGPOWYjvNfSa/9c=;
 b=J27RtnIyyQO/5Ou+2janFvm0IqDoMHH2zlpbyFMrY0xngTK6cRJrNV4lkZTtReoCeACfD5y6q3SrEzcAPF99dVQGwi6uwy9sifMn80+dYBDoDa9bdkqjQORdSlBKDgVLwcf6uF5J1rAI12nRtXsbl+qhglXaTGyQcLRoaPWiPDodljBZ732UegB0OoMq6Q32wqPzzVLPU2D2JeP+y+kq3Q/W/w7SmY7uP5GSA1FSiQChCWLCeAtSNNAQENlUveiroYCL8kyZ0tdItqSn9Ci0fJz2EmTNrcsFKD+n3jgjaBVt+71TF5HB4G1Mvwyz9e6kT6oYAhEEioicn8s9Mghehg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Qk3NsaokKMhNVfRwOlR1LecjFPqaGPOWYjvNfSa/9c=;
 b=t/kddqTFi8sLnUSXeFBAFcvoMaJ5t/6TJKi4b+Z1Kx7Nkzt4xwUVkHnfiPj6utenr/pFISRLD59MJxbRpwo1rg9mV7BxRw7R5Dm5RALmbVGX9Q02jxoIfoVFGhciMoFMnC4P+K8txchRWSlupvV4K7z5MFW0dmqm8FOeytglx9c=
Authentication-Results: plvision.eu; dkim=none (message not signed)
 header.d=none;plvision.eu; dmarc=none action=none header.from=plvision.eu;
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM9P190MB1427.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:3ea::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Wed, 9 Jun
 2021 15:16:52 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe%9]) with mapi id 15.20.4219.021; Wed, 9 Jun 2021
 15:16:52 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     oleksandr.mazur@plvision.eu, jiri@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 10/11] net: marvell: prestera: add storm control (rate limiter) implementation
Date:   Wed,  9 Jun 2021 18:16:00 +0300
Message-Id: <20210609151602.29004-11-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210609151602.29004-1-oleksandr.mazur@plvision.eu>
References: <20210609151602.29004-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM0PR06CA0092.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::33) To AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:19b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from omazur.x.ow.s (217.20.186.93) by AM0PR06CA0092.eurprd06.prod.outlook.com (2603:10a6:208:fa::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Wed, 9 Jun 2021 15:16:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 526c133a-6ef5-4a9d-3fdf-08d92b599bf5
X-MS-TrafficTypeDiagnostic: AM9P190MB1427:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9P190MB14274AEE81377E528AA2C484E4369@AM9P190MB1427.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:1051;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZKx1SIIqnajHcJLqt4rKFydWo+496THIerDk4oXdzj65flO10KS5vxBAzFyUEjL7A7XC1SiG5sNTU7fEKMSb8zkAK1Qt7K3GUH98W+qWf370EMEYVoENaMqH4w0U0Z5Fs5FNOfK98psblL05k/YcjjNUoE8qgIbGomgSh4vA5kU/c9WRrhvXDmzmYz/bJqM+JxfljWs4dN8KrlaYPVnoQr6i6pFnDUTpw3CYV3dpsY4KaNKJCzAAR9xHdC8R1Wg7BPtwRCu73YLT6bUBBNbVzFqT8/ybtOLYHx3c01xs2D82y5SJHIqkoX2gFs3XllOrJEIY6mOwLUsYdBS8lyCBtlm5vmeLxxgYXB+11ztrm7qEwyhMGnwESVQgXuMTHuPeGfhcyqRoXwwHQHUS2CGNawyts4yCbN7/2hBRAXCGScuqG2sUqp4YmFP9PxmNTJal4I8+cBwMEOMI59ohr3DBY8uo5U1D2ODoVTajBuRDMujhteErDgSPPxmG3q21wqdZdFzB/fIHZBoAjvKYrAyD6O/GhsZyybn+V02QT7CD2avjIwyROwoRfVY8F8CZQ1WHKKm2bkyFYIVUCDblaB1IEr6suJbVIOKURL8frfBHrvTjsQIqCGfRgdsxAfCA5/20FNUJsOnTrdPFM+Z+QHQII6a8kA6U1EOus/W2Is9drgs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(136003)(39830400003)(366004)(83380400001)(956004)(52116002)(2906002)(1076003)(186003)(66556008)(66946007)(16526019)(6506007)(2616005)(6486002)(6666004)(26005)(66476007)(38350700002)(8676002)(36756003)(86362001)(4326008)(30864003)(110136005)(5660300002)(478600001)(44832011)(6512007)(38100700002)(316002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?oy80KUBCI8n5Oii9r/XLknvyZ7K2HK2DGqjTgH6xTDWTNbcEAqCEd2nXhkuS?=
 =?us-ascii?Q?JlNyNKGx22EGiThX1Zy13/crbDoO9ungdtHbuOXDomIgRX++f9N3GjcUDb3k?=
 =?us-ascii?Q?ycdTW8DRp4prowYhbaOYsYTUoiyOHFYGJ1J1sVzefBZbYxtMvkmopA9Sn94O?=
 =?us-ascii?Q?9Hkia4mnatBRuqZAgTz0ZQI47gx8nhrqSz7HG7EUF84UU1kgiJBbX6aTh2hJ?=
 =?us-ascii?Q?uQ2uV3vevO2BLQzW49ZoVnU9Ju+sqX6HewVhD+bMYk763DL2Xlr7fjxwZUfG?=
 =?us-ascii?Q?+UaRW8ukM946R1gJiX/6cGDE9OQ/yOoaeX5mf/ecWI7uUU24TT2BPpc6fjvK?=
 =?us-ascii?Q?8L8PycPntB0p2LBf/f+8ArRjjVHL+B9cy6vX33mF6SqqDbq31xbsEpzEwqoY?=
 =?us-ascii?Q?jILlCQUazOrX645S+n3g0OI0u1VFcsjzvpLn9p5cA/Ww4TAv37vZ5cy2TlJh?=
 =?us-ascii?Q?2NPLG1aKvqPKSmMjxf756LNe9YToQaBobxPrHjZTwZSJxkVjJL1MVzscolQd?=
 =?us-ascii?Q?hPacE5FwGYd75Hd3QAI3T2GUq4WAMabBuan9SFWRaZfZwhX4HzUmvjWmDOle?=
 =?us-ascii?Q?p23oTWiTNJzcoejiQ5HZbLTgrk98RMVy6MmuTpHDn0lMpf89mifYWWC1BpPW?=
 =?us-ascii?Q?2x2edQr86rieEI98qQKaCc603CweiFIGXlncuQMjWFK+OasW78vU8jvUwFgM?=
 =?us-ascii?Q?CV7relv2b0C0v7/jKxf43zufrsfYCGI4XX/1oYYwewSJzJQ/FTaNibUr/zYj?=
 =?us-ascii?Q?p6WzB8S3JEHw5cSM+KMB6SXr8f6kwFlukHONVtsbDm4u3C3Vi4ekpJSY2s1i?=
 =?us-ascii?Q?oHLKFn+BayCwbZa1TtPBCyTFisWU/7eyjMQU3DBoUdbxR/9jkSCNpA2+22RP?=
 =?us-ascii?Q?+JwakDQNAIJ/59ZsPMW/B8FEfHFI/wHupBhpj1e/jUdBYvXQsI/st5+vkVkZ?=
 =?us-ascii?Q?LLQEAXLIBTMKUdaUF2cL02rf1TWudu4bzvTfIE40bgg6o3jPxlO9qOGeazeq?=
 =?us-ascii?Q?ct7dpX9Zvm5e4hwAb74XjeFLIzrBSG7zEGJ+Wk9f2kjZfottlbwyeQcnOvOr?=
 =?us-ascii?Q?boKSn8Yj34Nmz1lavBWUNS0Hgq8DiouiCaaPd/Tj2sob0vK9RDw9X4+B2kjo?=
 =?us-ascii?Q?MpsiyR8Xh4oHVkANeT0EliNpK+V9kzbxOtWkatolZzTERSkecOTiB9/+u1z/?=
 =?us-ascii?Q?ZyfW3mg5LaHxnIS3ozSCrWPxLQnbYcGjKHqPY7ni7d9/aejGL1CRd/+f1CoT?=
 =?us-ascii?Q?hakHpeKcr0LWpJPC5tdKJZlJSYEO/RO5Uc+tk2B6XmyGGR0n8WJFcjs2JFq0?=
 =?us-ascii?Q?m/+uzCnYka3OC21+3FKvH7PS?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 526c133a-6ef5-4a9d-3fdf-08d92b599bf5
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 15:16:51.9306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FC3zfmGdmapekZd2Mv+8Hb7ivgQA/DDu2zVtrx8APc21J5MfhoLZPUVc85FuklYP1ox6dshH080QFZuQfPLZ4Y6TV245V09YM8LQGzExucs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1427
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Storm control (BUM) provides a mechanism to limit rate of ingress
port traffic (matched by type). Devlink port parameter API is used:
driver registers a set of per-port parameters that can be accessed to both
get/set per-port per-type rate limit.
Add new FW command - RATE_LIMIT_MODE_SET.

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 .../net/ethernet/marvell/prestera/prestera.h  |   7 +
 .../marvell/prestera/prestera_devlink.c       | 134 +++++++++++++++++-
 .../ethernet/marvell/prestera/prestera_hw.c   |  25 ++++
 .../ethernet/marvell/prestera/prestera_hw.h   |   9 ++
 4 files changed, 174 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index 2c94bdec84b1..4b99a7421452 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -60,6 +60,12 @@ struct prestera_port_caps {
 	u8 transceiver;
 };
 
+struct prestera_strom_control_cfg {
+	u32 bc_kbyte_per_sec_rate;
+	u32 unk_uc_kbyte_per_sec_rate;
+	u32 unreg_mc_kbyte_per_sec_rate;
+};
+
 struct prestera_port {
 	struct net_device *dev;
 	struct prestera_switch *sw;
@@ -79,6 +85,7 @@ struct prestera_port {
 		struct prestera_port_stats stats;
 		struct delayed_work caching_dw;
 	} cached_hw_stats;
+	struct prestera_strom_control_cfg storm_control;
 };
 
 struct prestera_device {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_devlink.c b/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
index d12e21db9fd6..0786fbb09f71 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
@@ -2,6 +2,8 @@
 /* Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved */
 
 #include <net/devlink.h>
+#include <linux/bitops.h>
+#include <linux/bitfield.h>
 
 #include "prestera_devlink.h"
 #include "prestera_hw.h"
@@ -159,6 +161,34 @@ struct prestera_trap_data {
 			    DEVLINK_TRAP_GROUP_GENERIC_ID_##_group_id,	      \
 			    PRESTERA_TRAP_METADATA)
 
+#define PRESTERA_PORT_PARAM_DRIVER_RUNTIME(_id, _name, _type)		      \
+	DEVLINK_PARAM_DRIVER(PRESTERA_DEVLINK_PORT_PARAM_ID_##_id, _name,     \
+			     _type, BIT(DEVLINK_PARAM_CMODE_RUNTIME), NULL,   \
+			     NULL, NULL)
+
+struct prestera_storm_control {
+	struct prestera_switch *sw;
+	struct prestera_strom_control_cfg *cfg;
+};
+
+enum prestera_devlink_port_param_id {
+	PRESTERA_DEVLINK_PORT_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX + 1,
+	PRESTERA_DEVLINK_PORT_PARAM_ID_BC_RATE,
+	PRESTERA_DEVLINK_PORT_PARAM_ID_UC_UNK_RATE,
+	PRESTERA_DEVLINK_PORT_PARAM_ID_MC_RATE,
+};
+
+struct devlink_param prestera_devlink_port_params[] = {
+	PRESTERA_PORT_PARAM_DRIVER_RUNTIME(BC_RATE, "bc_kbyte_per_sec_rate",
+					   DEVLINK_PARAM_TYPE_U32),
+	PRESTERA_PORT_PARAM_DRIVER_RUNTIME(UC_UNK_RATE,
+					   "unk_uc_kbyte_per_sec_rate",
+					   DEVLINK_PARAM_TYPE_U32),
+	PRESTERA_PORT_PARAM_DRIVER_RUNTIME(MC_RATE,
+					   "unreg_mc_kbyte_per_sec_rate",
+					   DEVLINK_PARAM_TYPE_U32),
+};
+
 static const struct devlink_trap_group prestera_trap_groups_arr[] = {
 	/* No policer is associated with following groups (policerid == 0)*/
 	DEVLINK_TRAP_GROUP_GENERIC(L2_DROPS, 0),
@@ -350,6 +380,10 @@ static void prestera_devlink_traps_fini(struct prestera_switch *sw);
 static int prestera_drop_counter_get(struct devlink *devlink,
 				     const struct devlink_trap *trap,
 				     u64 *p_drops);
+static int prestera_devlink_port_param_set(struct devlink_port *dl_port, u32 id,
+					   struct devlink_param_gset_ctx *ctx);
+static int prestera_devlink_port_param_get(struct devlink_port *dl_port, u32 id,
+					   struct devlink_param_gset_ctx *ctx);
 
 static int prestera_dl_info_get(struct devlink *dl,
 				struct devlink_info_req *req,
@@ -383,11 +417,17 @@ static int prestera_trap_action_set(struct devlink *devlink,
 
 static int prestera_devlink_traps_register(struct prestera_switch *sw);
 
+static const struct devlink_port_param_ops prestera_devlink_port_param_ops = {
+	.get = prestera_devlink_port_param_get,
+	.set = prestera_devlink_port_param_set,
+};
+
 static const struct devlink_ops prestera_dl_ops = {
 	.info_get = prestera_dl_info_get,
 	.trap_init = prestera_trap_init,
 	.trap_action_set = prestera_trap_action_set,
 	.trap_drop_counter_get = prestera_drop_counter_get,
+	.port_param_ops = &prestera_devlink_port_param_ops,
 };
 
 struct prestera_switch *prestera_devlink_alloc(void)
@@ -443,10 +483,12 @@ void prestera_devlink_unregister(struct prestera_switch *sw)
 int prestera_devlink_port_register(struct prestera_port *port)
 {
 	struct prestera_switch *sw = port->sw;
-	struct devlink *dl = priv_to_devlink(sw);
 	struct devlink_port_attrs attrs = {};
+	struct devlink *dl;
 	int err;
 
+	dl = priv_to_devlink(sw);
+
 	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
 	attrs.phys.port_number = port->fp_id;
 	attrs.switch_id.id_len = sizeof(sw->id);
@@ -460,12 +502,32 @@ int prestera_devlink_port_register(struct prestera_port *port)
 		return err;
 	}
 
+	err = devlink_port_params_register(
+			&port->dl_port,
+			prestera_devlink_port_params,
+			ARRAY_SIZE(prestera_devlink_port_params));
+	if (err) {
+		devlink_port_unregister(&port->dl_port);
+		dev_err(sw->dev->dev, "devlink_port_params_register failed\n");
+		return err;
+	}
+
+	devlink_port_params_publish(&port->dl_port);
+
 	return 0;
 }
 
 void prestera_devlink_port_unregister(struct prestera_port *port)
 {
+	devlink_port_params_unpublish(&port->dl_port);
+
+	devlink_port_params_unregister(
+			&port->dl_port,
+			prestera_devlink_port_params,
+			ARRAY_SIZE(prestera_devlink_port_params));
+
 	devlink_port_unregister(&port->dl_port);
+
 }
 
 void prestera_devlink_port_set(struct prestera_port *port)
@@ -622,6 +684,76 @@ static int prestera_drop_counter_get(struct devlink *devlink,
 						 cpu_code_type, p_drops);
 }
 
+static int prestera_devlink_port_param_set(struct devlink_port *dl_port, u32 id,
+					   struct devlink_param_gset_ctx *ctx)
+{
+	struct prestera_strom_control_cfg *cfg;
+	u32 kbyte_per_sec_rate = ctx->val.vu32;
+	struct prestera_port *port;
+	struct prestera_switch *sw;
+	u32 *param_to_set;
+	u32 storm_type;
+	int ret;
+
+	port = container_of(dl_port, struct prestera_port, dl_port);
+	sw = devlink_priv(dl_port->devlink);
+	cfg = &port->storm_control;
+
+	switch (id) {
+	case PRESTERA_DEVLINK_PORT_PARAM_ID_BC_RATE:
+		param_to_set = &cfg->bc_kbyte_per_sec_rate;
+		storm_type = PRESTERA_PORT_STORM_CTL_TYPE_BC;
+		break;
+	case PRESTERA_DEVLINK_PORT_PARAM_ID_UC_UNK_RATE:
+		param_to_set = &cfg->unk_uc_kbyte_per_sec_rate;
+		storm_type = PRESTERA_PORT_STORM_CTL_TYPE_UC_UNK;
+		break;
+	case PRESTERA_DEVLINK_PORT_PARAM_ID_MC_RATE:
+		param_to_set = &cfg->unreg_mc_kbyte_per_sec_rate;
+		storm_type = PRESTERA_PORT_STORM_CTL_TYPE_MC;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (kbyte_per_sec_rate != *param_to_set) {
+		ret = prestera_hw_port_storm_control_cfg_set(port, storm_type,
+							     kbyte_per_sec_rate);
+		if (ret)
+			return ret;
+
+		*param_to_set = kbyte_per_sec_rate;
+	}
+
+	return 0;
+}
+
+static int prestera_devlink_port_param_get(struct devlink_port *dl_port, u32 id,
+					   struct devlink_param_gset_ctx *ctx)
+{
+	struct prestera_strom_control_cfg *cfg;
+	struct prestera_port *port;
+	struct prestera_switch *sw;
+
+	port = container_of(dl_port, struct prestera_port, dl_port);
+	sw = devlink_priv(dl_port->devlink);
+	cfg = &port->storm_control;
+
+	switch (id) {
+	case PRESTERA_DEVLINK_PORT_PARAM_ID_BC_RATE:
+		ctx->val.vu32 = cfg->bc_kbyte_per_sec_rate;
+		return 0;
+	case PRESTERA_DEVLINK_PORT_PARAM_ID_UC_UNK_RATE:
+		ctx->val.vu32 = cfg->unk_uc_kbyte_per_sec_rate;
+		return 0;
+	case PRESTERA_DEVLINK_PORT_PARAM_ID_MC_RATE:
+		ctx->val.vu32 = cfg->unreg_mc_kbyte_per_sec_rate;
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
 static void prestera_devlink_traps_fini(struct prestera_switch *sw)
 {
 	struct devlink *dl = priv_to_devlink(sw);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index 0e5b3f8e7dc7..85a1a15717df 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -20,6 +20,7 @@ enum prestera_cmd_type_t {
 	PRESTERA_CMD_TYPE_PORT_ATTR_SET = 0x100,
 	PRESTERA_CMD_TYPE_PORT_ATTR_GET = 0x101,
 	PRESTERA_CMD_TYPE_PORT_INFO_GET = 0x110,
+	PRESTERA_CMD_TYPE_PORT_RATE_LIMIT_MODE_SET = 0x111,
 
 	PRESTERA_CMD_TYPE_VLAN_CREATE = 0x200,
 	PRESTERA_CMD_TYPE_VLAN_DELETE = 0x201,
@@ -251,6 +252,14 @@ struct prestera_msg_port_info_resp {
 	u16 fp_id;
 };
 
+struct prestera_msg_port_storm_control_cfg_set_req {
+	struct prestera_msg_cmd cmd;
+	u32 port;
+	u32 dev;
+	u32 storm_type;
+	u32 kbyte_per_sec_rate;
+};
+
 struct prestera_msg_vlan_req {
 	struct prestera_msg_cmd cmd;
 	u32 port;
@@ -639,6 +648,22 @@ int prestera_hw_port_accept_frm_type(struct prestera_port *port,
 			    &req.cmd, sizeof(req));
 }
 
+int prestera_hw_port_storm_control_cfg_set(const struct prestera_port *port,
+					   u32 storm_type,
+					   u32 kbyte_per_sec_rate)
+{
+	struct prestera_msg_port_storm_control_cfg_set_req req = {
+		.port = port->hw_id,
+		.dev = port->dev_id,
+		.storm_type = storm_type,
+		.kbyte_per_sec_rate = kbyte_per_sec_rate
+	};
+
+	return prestera_cmd(port->sw,
+			    PRESTERA_CMD_TYPE_PORT_RATE_LIMIT_MODE_SET,
+			    &req.cmd, sizeof(req));
+}
+
 int prestera_hw_port_cap_get(const struct prestera_port *port,
 			     struct prestera_port_caps *caps)
 {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
index aafecf0ecd16..85373f1d3971 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -89,6 +89,12 @@ enum {
 	PRESTERA_STP_FORWARD,
 };
 
+enum {
+	PRESTERA_PORT_STORM_CTL_TYPE_BC = 0,
+	PRESTERA_PORT_STORM_CTL_TYPE_UC_UNK = 1,
+	PRESTERA_PORT_STORM_CTL_TYPE_MC = 2
+};
+
 enum prestera_hw_cpu_code_cnt_t {
 	PRESTERA_HW_CPU_CODE_CNT_TYPE_DROP = 0,
 	PRESTERA_HW_CPU_CODE_CNT_TYPE_TRAP = 1,
@@ -123,6 +129,9 @@ int prestera_hw_port_mac_set(const struct prestera_port *port, const char *mac);
 int prestera_hw_port_mac_get(const struct prestera_port *port, char *mac);
 int prestera_hw_port_cap_get(const struct prestera_port *port,
 			     struct prestera_port_caps *caps);
+int prestera_hw_port_storm_control_cfg_set(const struct prestera_port *port,
+					   u32 storm_type,
+					   u32 kbyte_per_sec_rate);
 int prestera_hw_port_remote_cap_get(const struct prestera_port *port,
 				    u64 *link_mode_bitmap);
 int prestera_hw_port_remote_fc_get(const struct prestera_port *port,
-- 
2.17.1

