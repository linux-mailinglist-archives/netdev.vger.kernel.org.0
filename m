Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6323D3A190A
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 17:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239195AbhFIPSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 11:18:49 -0400
Received: from mail-eopbgr80090.outbound.protection.outlook.com ([40.107.8.90]:23438
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235373AbhFIPSp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 11:18:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fn8N9kyY8SQu8O4vz7l2diTBdfZ+Q0rMxoepEWXsLkF+poMfDZF852J8FXnA3cEInjvj9HElxIaG+/P+0ltcz7sIJYSqj/+n/NgOSZWhenPoXfi+HSkk7QrMVtQSRNHLi8d5/582tdui1atIz4BfthBzJi7qXp5tXacp5tvsP/myUJQE/N7BYWAV1RoV8aQX9jVXeMd7HnS6tcfpwfPGqlyBfp8dYqgYN5XtyNGuYsVyM4wfRSROGQTCOPtdXmulDiCL1u8ddkDlsxbkwoo1IJhOuD7B6inrOF17LdihqIBTXm0zHEX8RwaNxS5+vZB5PTY+oLfYFlLo0P+gkkBDng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fKAkV/OPpzpSQKXKJfSfJxIoQpc+PhchYElk4pIUACk=;
 b=KgSW9SbNBATUXWMvMhpjBI0wa7Tj2SxSVfMzY2hKCytX4EFk56MAmPK1PgCgaBJ84Xs9g7V3nMl4G1VDMQFxK56WiJM6Zz4BSABU8FVwMiQH7p9yC5lLSyZRypE35xAQWmmE4GstBxrjKFSs0zn0sfarDS+HKKReiNs5+bTvSBmF98p+10FhapYKLmKR1JSBKeJkjamrjVQTtiN3Iizb4f4M1+sy7emW+z/8cORfvypmfjrOEiE95mWye42ZioGX2V2LQdfI8EGHzzy4qRP5j9SfvPqGhU2DphxO/I2er8FdXSu28QHs8LDUJiBofe/lRs8UqdeYk4frV7UASsyWQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fKAkV/OPpzpSQKXKJfSfJxIoQpc+PhchYElk4pIUACk=;
 b=vOUEYNjJ5otP2kVOxJjmA3prIJPOEmvlFD8SUXicsJn5QUpojOD3X9fIbgB5Cnn+gxHOIu7EV+tDQXv60YwkRzDRpsFJ+OeDZYsF2qS6J5/k+t9luv14PQTfzCBK9zgz88kmxAOeg+VzJI0VJmqkNE6sR4+pCKKdWiHUsEXlDEU=
Authentication-Results: plvision.eu; dkim=none (message not signed)
 header.d=none;plvision.eu; dmarc=none action=none header.from=plvision.eu;
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM9P190MB1427.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:3ea::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Wed, 9 Jun
 2021 15:16:49 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe%9]) with mapi id 15.20.4219.021; Wed, 9 Jun 2021
 15:16:49 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     oleksandr.mazur@plvision.eu, jiri@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 09/11] net: marvell: prestera: devlink: add traps with DROP action
Date:   Wed,  9 Jun 2021 18:15:59 +0300
Message-Id: <20210609151602.29004-10-oleksandr.mazur@plvision.eu>
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
Received: from omazur.x.ow.s (217.20.186.93) by AM0PR06CA0092.eurprd06.prod.outlook.com (2603:10a6:208:fa::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Wed, 9 Jun 2021 15:16:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: baa9b42f-edc4-400e-de5b-08d92b599a3f
X-MS-TrafficTypeDiagnostic: AM9P190MB1427:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9P190MB14276AAA04F6CCCF563C7E07E4369@AM9P190MB1427.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cHgD97P41tisIMoGCPokhd7h9TJv/XrMM7WYOaOlIFRJbvw39Dx92Ut0M1TqozO2DBELs9wDTkPkU48rgkdlff4lq/u1G8xF9mULKBqacjBlQwnT+gGYDieWpZcehKFKkZXN2YebsWShzlxn4dHq9bq22fNe8eZjZi8nOPCcUSSdtll95Ge/SYfvuJQR3I8wIRZLKmrHMwihuePEv8x0l0c+bqBjO8fjAsItR+yibZsCwE3Kc/r8uaFz+ZVa+xTHKFtzstFAQD8NTCIfPLwNhvSEjibB4Vfrwf2COrZdCeSdO64xwQIw1foRiz7EQy78pXU5o0XjiHa9Wjb67NDSKVcINVTpHl0we8/1vpI1OOeqkABjl4FEvvqli6S6wQKtChk+siX9naWYWSPk9y6xwcYJ+uVKzkK6U29/owBoshbL7hVKtvaT+6eS+YNG0JNfE5Rk3Tr4gOCWomHZH1L9uliJiE0nsKRfrBsH058Os/OX8G3XJbvFt+tfTf+D7zzcUZ/hZ2fR46JT9iwmWFGPrEXRQUbRnQgP/w2wdpe3U8wkilBhTJWoSJmsCWcHWTVvdAjx0ZBLmVBg44u3c8BA+DeUTXS29GwNAdr4yBHjm931ySh8JMbb40laxm9fq2ftuOLkGktmW931dZ2dR9ag0ruqSUVbjeIu6mSmHynmLCc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(136003)(39830400003)(366004)(956004)(52116002)(2906002)(1076003)(186003)(66556008)(66946007)(16526019)(6506007)(2616005)(6486002)(6666004)(26005)(66476007)(38350700002)(8676002)(36756003)(86362001)(4326008)(110136005)(5660300002)(478600001)(44832011)(6512007)(38100700002)(316002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4VB8/RDIjtZ4FKHzQ9AOeyu7idFzGXlodtuJq9jJ0VuF0TANQAXYyHsDdiNy?=
 =?us-ascii?Q?C1QBBBslM3HpJH6Glum+IqwKmaarDP4kjLj6BPjoj2xc4XOfC9iusS3U/8PD?=
 =?us-ascii?Q?3J5rmTMBqo4/CbwpQGfVhBrx6GyedhZwsRP1ARoCtQbX+p//w+UhJZDkeJCI?=
 =?us-ascii?Q?OWsw3nOb9GG+vT1bkGQ73eyHvNFWgUMpLBSmdK2dY1HlE3UoNiWjJv2Zuw7p?=
 =?us-ascii?Q?ScQwRy4XkOVNP+lg7F9HUD5DThUClbeOT5dktQxy6SWxW6jzaCDkiu7uUbwA?=
 =?us-ascii?Q?G9sxzubj265TGdlNd3GLJ8WhIke52o/GnzmWdVx4nWjtzrtILeqH0skokFmh?=
 =?us-ascii?Q?ok04nhi0qx7bsuWjJxS7WJqEVGdOs9VCQb1WIF2g53ySHCpIJ57sizbKG3Sj?=
 =?us-ascii?Q?SWuUKTl/8KrQquBX3zLLyI46oK+nh1NFHu7ViGCUOk+DSnBknggPs3nEKAeB?=
 =?us-ascii?Q?YL93sCzaMZVxQT0AoIGm3PSMBrU6VIoskmAhGGSZ3WthoJ06zGz43mj0C+Eb?=
 =?us-ascii?Q?RQs47nUanLtXlE8zXjEahXe2p9UOB2EBKmr6/j0a73sHXuya90yLhFwg8Wq+?=
 =?us-ascii?Q?zJaBgfthkV8U0xNhJc3gmwuFEEjzcTFICTmMmiUy67INNMS6Yqr6/HDvL8xA?=
 =?us-ascii?Q?5w7D3QYvitjAF9iRkW7Jx0v9xgd/6+3Y3EbTjI6RASWqwLZksF6UaxIZoNYJ?=
 =?us-ascii?Q?3eTLwLFwdkuCS3R4bo0ETk8GfUcwrF4hC6QED5SeDFOq+PW/DO+MdQGqxsuw?=
 =?us-ascii?Q?ENaUc1P6mLOdaC538hV9T8VofquV68TdXHPKuW+A+rEd0caBsMSbdGGOriul?=
 =?us-ascii?Q?2h3Nk89svCRte0QnBqjATGJypg85FjmYxwr8XBiDNnib1MgTtHjLtcg3u/nD?=
 =?us-ascii?Q?2o3r9cHDDZ6bJOj4kEIp9tTxpz89E8zNEQdGDlNYxoJ9bYDKqWFw5CZqAlPQ?=
 =?us-ascii?Q?saCKM2wshyoSUEwrvwEl9WkME9v+QQ2zQ4dpUXPMlJz2ABxpsB9CGcyvqrG5?=
 =?us-ascii?Q?4uMz6QzZ13RVLiQ17Rgykk4dWWBA13soE1zck/T/v5juOrbISSr9DOD6SkIQ?=
 =?us-ascii?Q?FUF+VVW/O6LOV5qxaPDwKi6UW7ne3ui+TWLOHCJ1/AJHJegEe5xa94iWP0Xw?=
 =?us-ascii?Q?oXvq6Lf5ezErcIAxJhoqcLvKHwQrApliNvgz2rYFc+tg0EhaHoFlCT7SJE8e?=
 =?us-ascii?Q?NY4YVSofLa5Hligj4hm+sYTF8l7jBy0sLurArGgMujJFdvp024vWkf8HreC8?=
 =?us-ascii?Q?tl6AeeERqHq+y4S9MpuqSWp8rRXvbYHVW7AHve//tWoZDKPzGqTX/lhqj+i/?=
 =?us-ascii?Q?X7M5zDp3h05vFZiX/cPlskcg?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: baa9b42f-edc4-400e-de5b-08d92b599a3f
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 15:16:49.1458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Xwv+2H8kHpfBSMRw7RBPSUGdYreMPf4Km1G1Mmn0XfuX53Os/4UEiqKk/HcqktvlGHdlPxYvroqPZbong4kMv7dq7jDZaPfKuSrJ06gR38=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1427
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add traps that have init_action being set to DROP.
Add 'trap_drop_counter_get' (devlink API) callback implementation,
that is used to get number of packets that have been dropped by the HW
(traps with action 'DROP').
Add new FW command CPU_CODE_COUNTERS_GET.

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 .../marvell/prestera/prestera_devlink.c       | 91 +++++++++++++++++++
 .../ethernet/marvell/prestera/prestera_hw.c   | 35 +++++++
 .../ethernet/marvell/prestera/prestera_hw.h   | 11 +++
 3 files changed, 137 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_devlink.c b/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
index f59727f050ba..d12e21db9fd6 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
@@ -4,6 +4,7 @@
 #include <net/devlink.h>
 
 #include "prestera_devlink.h"
+#include "prestera_hw.h"
 
 /* All driver-specific traps must be documented in
  * Documentation/networking/devlink/prestera.rst
@@ -34,6 +35,15 @@ enum {
 	DEVLINK_PRESTERA_TRAP_ID_SSH,
 	DEVLINK_PRESTERA_TRAP_ID_TELNET,
 	DEVLINK_PRESTERA_TRAP_ID_ICMP,
+	DEVLINK_PRESTERA_TRAP_ID_MET_RED,
+	DEVLINK_PRESTERA_TRAP_ID_IP_SIP_IS_ZERO,
+	DEVLINK_PRESTERA_TRAP_ID_IP_UC_DIP_DA_MISMATCH,
+	DEVLINK_PRESTERA_TRAP_ID_ILLEGAL_IPV4_HDR,
+	DEVLINK_PRESTERA_TRAP_ID_ILLEGAL_IP_ADDR,
+	DEVLINK_PRESTERA_TRAP_ID_INVALID_SA,
+	DEVLINK_PRESTERA_TRAP_ID_LOCAL_PORT,
+	DEVLINK_PRESTERA_TRAP_ID_PORT_NO_VLAN,
+	DEVLINK_PRESTERA_TRAP_ID_RXDMA_DROP,
 };
 
 #define DEVLINK_PRESTERA_TRAP_NAME_ARP_BC \
@@ -84,6 +94,24 @@ enum {
 	"telnet"
 #define DEVLINK_PRESTERA_TRAP_NAME_ICMP \
 	"icmp"
+#define DEVLINK_PRESTERA_TRAP_NAME_RXDMA_DROP \
+	"rxdma_drop"
+#define DEVLINK_PRESTERA_TRAP_NAME_PORT_NO_VLAN \
+	"port_no_vlan"
+#define DEVLINK_PRESTERA_TRAP_NAME_LOCAL_PORT \
+	"local_port"
+#define DEVLINK_PRESTERA_TRAP_NAME_INVALID_SA \
+	"invalid_sa"
+#define DEVLINK_PRESTERA_TRAP_NAME_ILLEGAL_IP_ADDR \
+	"illegal_ip_addr"
+#define DEVLINK_PRESTERA_TRAP_NAME_ILLEGAL_IPV4_HDR \
+	"illegal_ipv4_hdr"
+#define DEVLINK_PRESTERA_TRAP_NAME_IP_UC_DIP_DA_MISMATCH \
+	"ip_uc_dip_da_mismatch"
+#define DEVLINK_PRESTERA_TRAP_NAME_IP_SIP_IS_ZERO \
+	"ip_sip_is_zero"
+#define DEVLINK_PRESTERA_TRAP_NAME_MET_RED \
+	"met_red"
 
 struct prestera_trap {
 	struct devlink_trap trap;
@@ -125,6 +153,12 @@ struct prestera_trap_data {
 			    DEVLINK_TRAP_GROUP_GENERIC_ID_##_group_id,	      \
 			    PRESTERA_TRAP_METADATA)
 
+#define PRESTERA_TRAP_DRIVER_DROP(_id, _group_id)			      \
+	DEVLINK_TRAP_DRIVER(DROP, DROP, DEVLINK_PRESTERA_TRAP_ID_##_id,	      \
+			    DEVLINK_PRESTERA_TRAP_NAME_##_id,		      \
+			    DEVLINK_TRAP_GROUP_GENERIC_ID_##_group_id,	      \
+			    PRESTERA_TRAP_METADATA)
+
 static const struct devlink_trap_group prestera_trap_groups_arr[] = {
 	/* No policer is associated with following groups (policerid == 0)*/
 	DEVLINK_TRAP_GROUP_GENERIC(L2_DROPS, 0),
@@ -142,6 +176,7 @@ static const struct devlink_trap_group prestera_trap_groups_arr[] = {
 	DEVLINK_TRAP_GROUP_GENERIC(DHCP, 0),
 	DEVLINK_TRAP_GROUP_GENERIC(BGP, 0),
 	DEVLINK_TRAP_GROUP_GENERIC(LOCAL_DELIVERY, 0),
+	DEVLINK_TRAP_GROUP_GENERIC(BUFFER_DROPS, 0),
 };
 
 /* Initialize trap list, as well as associate CPU code with them. */
@@ -271,10 +306,51 @@ static struct prestera_trap prestera_trap_items_arr[] = {
 		.trap = PRESTERA_TRAP_DRIVER_CONTROL(ICMP, LOCAL_DELIVERY),
 		.cpu_code = 209,
 	},
+	{
+		.trap = PRESTERA_TRAP_DRIVER_DROP(RXDMA_DROP, BUFFER_DROPS),
+		.cpu_code = 37,
+	},
+	{
+		.trap = PRESTERA_TRAP_DRIVER_DROP(PORT_NO_VLAN, L2_DROPS),
+		.cpu_code = 39,
+	},
+	{
+		.trap = PRESTERA_TRAP_DRIVER_DROP(LOCAL_PORT, L2_DROPS),
+		.cpu_code = 56,
+	},
+	{
+		.trap = PRESTERA_TRAP_DRIVER_DROP(INVALID_SA, L2_DROPS),
+		.cpu_code = 60,
+	},
+	{
+		.trap = PRESTERA_TRAP_DRIVER_DROP(ILLEGAL_IP_ADDR, L3_DROPS),
+		.cpu_code = 136,
+	},
+	{
+		.trap = PRESTERA_TRAP_DRIVER_DROP(ILLEGAL_IPV4_HDR, L3_DROPS),
+		.cpu_code = 137,
+	},
+	{
+		.trap = PRESTERA_TRAP_DRIVER_DROP(IP_UC_DIP_DA_MISMATCH,
+						  L3_DROPS),
+		.cpu_code = 138,
+	},
+	{
+		.trap = PRESTERA_TRAP_DRIVER_DROP(IP_SIP_IS_ZERO, L3_DROPS),
+		.cpu_code = 145,
+	},
+	{
+		.trap = PRESTERA_TRAP_DRIVER_DROP(MET_RED, BUFFER_DROPS),
+		.cpu_code = 185,
+	},
 };
 
 static void prestera_devlink_traps_fini(struct prestera_switch *sw);
 
+static int prestera_drop_counter_get(struct devlink *devlink,
+				     const struct devlink_trap *trap,
+				     u64 *p_drops);
+
 static int prestera_dl_info_get(struct devlink *dl,
 				struct devlink_info_req *req,
 				struct netlink_ext_ack *extack)
@@ -311,6 +387,7 @@ static const struct devlink_ops prestera_dl_ops = {
 	.info_get = prestera_dl_info_get,
 	.trap_init = prestera_trap_init,
 	.trap_action_set = prestera_trap_action_set,
+	.trap_drop_counter_get = prestera_drop_counter_get,
 };
 
 struct prestera_switch *prestera_devlink_alloc(void)
@@ -531,6 +608,20 @@ static int prestera_trap_action_set(struct devlink *devlink,
 	return -EOPNOTSUPP;
 }
 
+static int prestera_drop_counter_get(struct devlink *devlink,
+				     const struct devlink_trap *trap,
+				     u64 *p_drops)
+{
+	struct prestera_switch *sw = devlink_priv(devlink);
+	enum prestera_hw_cpu_code_cnt_t cpu_code_type =
+		PRESTERA_HW_CPU_CODE_CNT_TYPE_DROP;
+	struct prestera_trap *prestera_trap =
+		container_of(trap, struct prestera_trap, trap);
+
+	return prestera_hw_cpu_code_counters_get(sw, prestera_trap->cpu_code,
+						 cpu_code_type, p_drops);
+}
+
 static void prestera_devlink_traps_fini(struct prestera_switch *sw)
 {
 	struct devlink *dl = priv_to_devlink(sw);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index 96ce73b50fec..0e5b3f8e7dc7 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -42,6 +42,8 @@ enum prestera_cmd_type_t {
 
 	PRESTERA_CMD_TYPE_STP_PORT_SET = 0x1000,
 
+	PRESTERA_CMD_TYPE_CPU_CODE_COUNTERS_GET = 0x2000,
+
 	PRESTERA_CMD_TYPE_ACK = 0x10000,
 	PRESTERA_CMD_TYPE_MAX
 };
@@ -305,6 +307,17 @@ struct prestera_msg_rxtx_port_req {
 	u32 dev;
 };
 
+struct prestera_msg_cpu_code_counter_req {
+	struct prestera_msg_cmd cmd;
+	u8 counter_type;
+	u8 code;
+};
+
+struct mvsw_msg_cpu_code_counter_ret {
+	struct prestera_msg_ret ret;
+	u64 packet_count;
+};
+
 struct prestera_msg_event {
 	u16 type;
 	u16 id;
@@ -1295,6 +1308,28 @@ int prestera_hw_rxtx_port_init(struct prestera_port *port)
 			    &req.cmd, sizeof(req));
 }
 
+int
+prestera_hw_cpu_code_counters_get(struct prestera_switch *sw, u8 code,
+				  enum prestera_hw_cpu_code_cnt_t counter_type,
+				  u64 *packet_count)
+{
+	struct prestera_msg_cpu_code_counter_req req = {
+		.counter_type = counter_type,
+		.code = code,
+	};
+	struct mvsw_msg_cpu_code_counter_ret resp;
+	int err;
+
+	err = prestera_cmd_ret(sw, PRESTERA_CMD_TYPE_CPU_CODE_COUNTERS_GET,
+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
+	if (err)
+		return err;
+
+	*packet_count = resp.packet_count;
+
+	return 0;
+}
+
 int prestera_hw_event_handler_register(struct prestera_switch *sw,
 				       enum prestera_event_type type,
 				       prestera_event_cb_t fn,
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
index e8dd0e2b81d2..aafecf0ecd16 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -89,6 +89,11 @@ enum {
 	PRESTERA_STP_FORWARD,
 };
 
+enum prestera_hw_cpu_code_cnt_t {
+	PRESTERA_HW_CPU_CODE_CNT_TYPE_DROP = 0,
+	PRESTERA_HW_CPU_CODE_CNT_TYPE_TRAP = 1,
+};
+
 struct prestera_switch;
 struct prestera_port;
 struct prestera_port_stats;
@@ -180,4 +185,10 @@ int prestera_hw_rxtx_init(struct prestera_switch *sw,
 			  struct prestera_rxtx_params *params);
 int prestera_hw_rxtx_port_init(struct prestera_port *port);
 
+/* HW trap/drop counters API */
+int
+prestera_hw_cpu_code_counters_get(struct prestera_switch *sw, u8 code,
+				  enum prestera_hw_cpu_code_cnt_t counter_type,
+				  u64 *packet_count);
+
 #endif /* _PRESTERA_HW_H_ */
-- 
2.17.1

