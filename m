Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E93413A6758
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 15:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233734AbhFNND6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 09:03:58 -0400
Received: from mail-eopbgr50111.outbound.protection.outlook.com ([40.107.5.111]:61697
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233501AbhFNNDt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 09:03:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FoRl2VCxFhyEfypNyo68j8I6QHfrf2g2ZjJEfZKaHX6Tzn9d7104GrPoXJ99vFblBYNq/apjSr0zHtLYBaHZlwY7R9F7ruLOjVy2RfcV3MRV9E3MpX/CJKJ7coAXVsDMpvOYfexL1OmXq49WIeQlLN0ckEVItMQVKGfeHnhm/2bBNQWbAu92O7SDoggGYw4/SN5EQkECMA3kaxaX43WvErX09Tg3ZjYY+x5Sm4xt0beTPB6MUPSo7WBgN/UzjWG89E2FpWKG6c62qozo4+NhzGo2DBX22GOB6soa0lpR3/57yebcEJ3X5yJfnKdP4WGoB85acfZ54giS1K4ewtJ6CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KSJHOTBPDy/9AmbJmiu1Nr85tksFTQHfJS2pHvSgnLY=;
 b=QusGgGTcRffwNcKXFDWzUDS5QmdVWe955MVZIFk1uXXhUk/WpGZJ/e0LbY9XOOEjxugshUxnkOUYnrbNS/NA+/f8qnBvFwiYYT6RZKY7d61urdx09THe6uu0PLAamN7Iws2IExcmVLOs3dJ8De2FPhwgIkvex6BVidGd3CH2D/ASr06r5BY79QEmo9iZ/2gbUaWwUt5rMzgYLisd0jXk+0Zr5VPReJTpkBxZiuf/cOWyAZ5wozAYZbau4BV/A5+ZKSVe04n+dhEl58+EM7Vv1U9ipsDE31VOEt9PRtk2xkXIZLBQ1nSW2T2eQ0gUKCKxUWN5W9dtFMaddmJTj+JUsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KSJHOTBPDy/9AmbJmiu1Nr85tksFTQHfJS2pHvSgnLY=;
 b=pLzAP1uQI5eJybjP3GDz9W1HaMu/TtmWQXT0Fe45SIv4PYXxkx2jo5OLT8L8inSd95Vu5eGjTK4+aTHWasz/VetsYCyhczLXMWNCL5yaTGqHITtFukbmIifdRnw24DakCSQad7mSy54TQU3TBn7gNa7xmX6E2Zm8czTlfRB8B+w=
Authentication-Results: plvision.eu; dkim=none (message not signed)
 header.d=none;plvision.eu; dmarc=none action=none header.from=plvision.eu;
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM9P190MB1396.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:3b6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Mon, 14 Jun
 2021 13:01:43 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe%9]) with mapi id 15.20.4219.025; Mon, 14 Jun 2021
 13:01:43 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     oleksandr.mazur@plvision.eu, jiri@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vadym Kochan <vadym.kochan@plvision.eu>, andrew@lunn.ch,
        nikolay@nvidia.com, idosch@idosch.org
Subject: [PATCH net-next v2 6/7] net: marvell: prestera: devlink: add traps with DROP action
Date:   Mon, 14 Jun 2021 16:01:17 +0300
Message-Id: <20210614130118.20395-7-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210614130118.20395-1-oleksandr.mazur@plvision.eu>
References: <20210614130118.20395-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM0PR06CA0140.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::45) To AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:19b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from omazur.x.ow.s (217.20.186.93) by AM0PR06CA0140.eurprd06.prod.outlook.com (2603:10a6:208:ab::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Mon, 14 Jun 2021 13:01:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bdf4ead9-07a7-4151-5382-08d92f348eac
X-MS-TrafficTypeDiagnostic: AM9P190MB1396:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9P190MB1396CF10D6EC26B297B33227E4319@AM9P190MB1396.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SqPZKtr2calodJZELcBuREbqEeDo+uVwCKUVHLNce5PglqF80p702Z2M93vEXhwA85ywHZjmSTxPlSVqWBLeVDhDDWL99BqQu6UVh+XS2+4Ma3hjEV3ixFbgcnpnsiRe6vSlsbq7MiTTbksXoCovCb/19kRhP6shxC8WXsUvTO5HnY2bC+TEnbtaljW205AD71Bu1Zp46YvyMBWNbMFdGfYBPvW216wwAEy3F+9fU403M4CkxFRZQKqeKxfmQUEvNThBR02z6/McBHoIP7vHCcD4+DG4HMzdA79Aomq5ebjGm11aUsrm6DrZ5nrouEI1/lXLq7mg6EHL/97/g9zTm6W5It+nX2QL3+5+vLZUMbUtaGkpFiuZEiRLrvxDykVdNG0igcU6Jkw7Q0IxT3TI0gkxIMExnLp7EgwmrLH38CCbOfHQE52TcMhk4WYe8ibyIyPuWgVs3yc+EX7AK2c6pbuDqishTgheXYwVHSH0SQnfykJLnqkE1TcuTqGxsVy+kBeJKptSIjDzOTDwgWL1odZQ52S3cfwF52LIGe6ZegA/qubHJgzYy/gYlThtFs35YvOVFN6t5JcEI+nky6DKwXBeufkHjHsEc4L9AJ088JV3g/U+uCJJHLHSDLavEP8WiBNTVC3ONHzJFwqtwqS7taEFxz+JOeQdAMn4IMCcN9Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(396003)(376002)(136003)(39830400003)(346002)(6486002)(110136005)(7416002)(66556008)(16526019)(186003)(66946007)(956004)(66476007)(2616005)(316002)(86362001)(26005)(8936002)(4326008)(8676002)(478600001)(2906002)(44832011)(38350700002)(36756003)(6512007)(5660300002)(52116002)(6666004)(6506007)(1076003)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hFPzTf4mzh1wRQAm1tMrGnzAtosVWUxjSyiSEYM1lzhi/9rArb35qq3+IiBN?=
 =?us-ascii?Q?Ck3Z945rNAnZT2fScpMzpzMQiTpZPGxi/BfAIhD5F4XkSz1yyQh4KhEL50LA?=
 =?us-ascii?Q?Nda3Y/JZcbE5w/M/hmL2OdIInthQZZ0HrhZ4v2JQlHHZ9X0srM0MWKBE+eet?=
 =?us-ascii?Q?fDWYiB+DsuqAaG/ipgbwufknmXC69n2OLlZo3g/Yl+iPsp+uir9laEqruEQ7?=
 =?us-ascii?Q?+usoRNmUmUBpAJBLCWm+oQEmTdbwTkoV9cg5fF6B3AK8G+f1Np+/rLu6G50W?=
 =?us-ascii?Q?K4Ms3+1klhjw42kJhTbqdIkzAZi+Xhky4QubnatK0RNpWALlSvBSl+/TiIy7?=
 =?us-ascii?Q?KSaf8Uxs8sFivirytRa0ifXU/kDKPkMbxXA6lXd9mQOYhZa1KU8cUql33MWS?=
 =?us-ascii?Q?Qlsduzc6+vbeZESpjq4ZBMUKbwNJpW6emqf55FOedqyspM9FKQYlmoY0/RQP?=
 =?us-ascii?Q?z90jqRp52qabaY5EwyesXyp6WbULiab1/aCwLG1MzQb4ct+TaD8pphE5+270?=
 =?us-ascii?Q?gGwJpuA0En7XC3rIK4Q2HPchcJC9mOohJId28B0rfyl2xTQtTnXNR7Rr94vy?=
 =?us-ascii?Q?l2eXJMhPs/nz8X8VuOsSSOhuRjqBfyk3Efup/p7FLfCUl2V3fi/V+N3klLHX?=
 =?us-ascii?Q?D34owVOojgqnfbLu3BUDC3Ak+B+cGZt37LcZ1O2yUpmwcArN3In8XVkwfhX9?=
 =?us-ascii?Q?zYS4aa/AwHMmPntKPPLQTG3ZoNmc5SZbjnyR04WpuDsAwsfcAgPWkrSrd71u?=
 =?us-ascii?Q?ymVSx065RVFTz772mGobmHnEKlJDlqMCOv4kxA02iY8GIZ9zGkf1VubqsVNj?=
 =?us-ascii?Q?OHcIXFHMOjGzjE5ZDPIYM4zz/KQjjyHiZZV5ajBN5KKZoc2zSOET5d7gw9vm?=
 =?us-ascii?Q?um1pEJB/jAa/PhpCysPrrvnzM0shP+xPlbjOq19r1iWU7wzRaBTVFRFgFlao?=
 =?us-ascii?Q?UlHXD6Awg+GzHt+1yI0d0oq3TZ6PCMA9YmSzOfty+qn3kfRHt3dRy4Xc3/PN?=
 =?us-ascii?Q?c+2H8JFy3TB7tkRtqfNKWrFLkUpeB3EqosbDXZs/MQXZhlyO7gGYBNuvi3G7?=
 =?us-ascii?Q?Q+CtSZXHhTGd+lCcQBzwLdM3FDGK4P1E1TzmXw3417TSdZwZrIjqiyaZYq4h?=
 =?us-ascii?Q?SF82lhedJSU2wmtiJjbn3iBTRWPHybNqXGBtkL3VKTVwrA5CxGdb27qv0vha?=
 =?us-ascii?Q?9JkP+0n8urlV6xDTCl1YquxS546Qgi7dABgqP6205HnxVx0D0fE+Gh9t+1e3?=
 =?us-ascii?Q?+Wz5Cy7PwJon8z9xR8JjpjYNiQQDvGy11eozNxSxpwi+U1zP66UbY43xB9l8?=
 =?us-ascii?Q?zNM/Bw9DFRqp27XzsrThvjoB?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: bdf4ead9-07a7-4151-5382-08d92f348eac
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 13:01:42.9433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J80Sjea1xAxVmRVYK+oHYnE+Oz6dllaUW1vVQWI1wOBQrLE0p83ejNpz0s4Hf3NPXlAOjhhU45XttKuCLToVlbcwt8R+MSHNHg4b0bJNPIA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1396
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
index 886ce251330e..a4e3dc8d3abe 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -47,6 +47,8 @@ enum prestera_cmd_type_t {
 
 	PRESTERA_CMD_TYPE_STP_PORT_SET = 0x1000,
 
+	PRESTERA_CMD_TYPE_CPU_CODE_COUNTERS_GET = 0x2000,
+
 	PRESTERA_CMD_TYPE_ACK = 0x10000,
 	PRESTERA_CMD_TYPE_MAX
 };
@@ -330,6 +332,17 @@ struct prestera_msg_lag_req {
 	u16 lag_id;
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
@@ -1451,6 +1464,28 @@ int prestera_hw_lag_member_enable(struct prestera_port *port, u16 lag_id,
 	return prestera_cmd(port->sw, cmd, &req.cmd, sizeof(req));
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
index 846bdc04e278..7f72d81cf918 100644
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
@@ -194,4 +199,10 @@ int prestera_hw_fdb_flush_lag(struct prestera_switch *sw, u16 lag_id,
 int prestera_hw_fdb_flush_lag_vlan(struct prestera_switch *sw,
 				   u16 lag_id, u16 vid, u32 mode);
 
+/* HW trap/drop counters API */
+int
+prestera_hw_cpu_code_counters_get(struct prestera_switch *sw, u8 code,
+				  enum prestera_hw_cpu_code_cnt_t counter_type,
+				  u64 *packet_count);
+
 #endif /* _PRESTERA_HW_H_ */
-- 
2.17.1

