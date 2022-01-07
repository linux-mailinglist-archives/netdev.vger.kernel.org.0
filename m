Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 720BD4870D8
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 04:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345634AbiAGDCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 22:02:32 -0500
Received: from mail-eopbgr60103.outbound.protection.outlook.com ([40.107.6.103]:16641
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345629AbiAGDCb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 22:02:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ubj6sLLrDaICeyrFAgmwhY90JKKItEU2rI+JevG8d0OClW/S5nZ4O5uts1wZIzcd3cMFzPaRrWfBk4eNAfoNuYqUU0PsPa5O85E3SW/mIbGvt768Amyu/O6NTVMLxSSgwsG462VNzPS6fkLQE2E6w9PeG8KltuYd8OOen8VWSAmMAJfs7boxwhpeohJyy8mEJFl3VyOWkwGUPcHyQWg+GEO0qD7DP5IwGp3awWB+Q2u3KVSwwJL6FbX3GuLtqovp/M3TeQFca/6mnV3+g9JEwB8Ntyb7YeVTkE6g4DfV25LIihBDmzM+ZkRQybq+Hz0hvK58XhQZDCxnDLiynmo4iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HEO/fUpc7sHgGDf0F8bQDE/b8NDqvLzJyjwmmKFBOg4=;
 b=FsYddxKftVr4wh+4aNDznGWNjin1RoDEwHQPBGtwVQvoWVo+ya6wmJ6bM3Uhzwl9fJuyxYaA5FFR0xvrNg9oWupoifJhvqXc82AoG8FvwER2FrM3NjVUtQBD0jTxgswx4VA7hSOsv7HF7xejK6LSJ7ShfsRYq65NyKubyJjmVoGSgfFEWNzQFAK/RCUgrRvqrCkKiK37NECoBFXNztXRMz7r5rqrX8AzGlKd/eB5fSwmm4irLKm9wqvqI7J0xv+B1/fJdYVEpR6Lmysi1e/6v8+gfWEITmJUSd+iY2BPoxRvSXOhkqM4g6YRSr8EKdAIlrUHq6llqLaQ5kMBO6QPvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HEO/fUpc7sHgGDf0F8bQDE/b8NDqvLzJyjwmmKFBOg4=;
 b=vggmYjxiur2vGhoDcu11YrCqaFA8BWUodLc4ANKFCb2YUIEu6mqE/+AnpQW8FKotYtRh0PjpEnJIFn4ipW2ChXNvmC2WHwroi6ju6kyYIeQI79YglJPJmJhZxUxAaXyi1a3DisQF8XeQXzSUvsYlxgD6hP9zhLtbRy/1hYNkhXE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:262::24)
 by AM9P190MB1316.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:26f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Fri, 7 Jan
 2022 03:02:29 +0000
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256]) by AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256%8]) with mapi id 15.20.4867.011; Fri, 7 Jan 2022
 03:02:29 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org, stephen@networkplumber.org, andrew@lunn.ch,
        idosch@idosch.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 2/6] net: marvell: prestera: Add router interface ABI
Date:   Fri,  7 Jan 2022 05:01:32 +0200
Message-Id: <20220107030139.8486-3-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220107030139.8486-1-yevhen.orlov@plvision.eu>
References: <20220107030139.8486-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0001.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::10) To AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:262::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 97ba770a-63b2-4ae3-6e63-08d9d18a23ef
X-MS-TrafficTypeDiagnostic: AM9P190MB1316:EE_
X-Microsoft-Antispam-PRVS: <AM9P190MB1316C119E48ED7C593A7808F934D9@AM9P190MB1316.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u+IZZ7V0FHiiwQ04VT61xZO17EFWkFSqCrzZphKyHMWmxhD5wzl1RDoWFoI6tHYKo545ZyppUX7i75lAvLA4pR/yMBMe8wBQNePYS2vOwEc6jUpji9vAT9cVmvgqc22tSIT8GrwN3g1MDGjUGgAwHbzLrahVULSP99lFlNa56GOqTbzkyHLIissbzhXVo6Jt5nN6khK5r7vGeNvbRx4cqNXoJfJ6sl5OjF0C747Evgb8dDdbeuoDNlua3D0JkeNCqfqcwM2Rji8zq00GBITGQ1yjXLC9nUqk1AaBRiIXn3DM1O54iyorM3S6EV01BeBVd5jylidZpRvQfpB3WyhHj1v1kndRIBiEIAhogPYulBp78x9B9dHtk0lJnXPUXVRgIsk/la6lplQBUrAwvY1HGjGQqnY8ucvEThilzJOFRc/HmSJFWQoRbZomTKlVF9SsxW+igjOxImi7WtFHwOo8ekT+qAPksFqauRfd+aj9KjRRB6fMZ2VpFexMN43FNHk70R0tWo8VaAyXwBYEXeps2f0Z8rqEuA9LtGnt9mr6A/0O3wOTqcH52X4X5TdXoBXV3BCaQwKjH2W/k5W1xVYYbKjxff62UT8udR1+Nz2OuXWsYJ0IFVC0lza1XDB2VNckMHViS4IR7HJBI5xpDSrqx5AY0R0H9W/PuD9C7IenkEw4sUzWz/CQai8D7ybugtDJwRtOuIVcMXe3zC3LDe1Q6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P190MB1122.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(366004)(396003)(39830400003)(38350700002)(38100700002)(52116002)(508600001)(316002)(66946007)(66476007)(66556008)(2616005)(6512007)(186003)(6506007)(26005)(4326008)(44832011)(2906002)(5660300002)(6486002)(6666004)(8676002)(36756003)(8936002)(54906003)(86362001)(66574015)(83380400001)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KVUlGOGowWZ2IB982DVKzRhRx6rCEUWZMJ2xWggk8YBpzemx+8WtQpaZsjgq?=
 =?us-ascii?Q?2Am+p8eQ5NZbXmrhbYR1lxXTglU0o5LrZnspUlIQIOrjt893EA2uFGlYLTOi?=
 =?us-ascii?Q?4D+wb3CPB0xmPhFg4yxdtf2r71JKQN6dNLw+6PZ0wa0HHY0Rp3u8aTtijWtB?=
 =?us-ascii?Q?IJTN/hWAgcwo4xgZTu+ZLviqm5ZbJzSz7woRHDqn+21fDd7dU03e2y1Vdf7b?=
 =?us-ascii?Q?OtYNvrP37UshMcjoncFBgPPTscAyx8qUa8pPqty3ehELQrOpsYjblZXLdiZx?=
 =?us-ascii?Q?uRAw6omgRHGw+hMIWHs95I7Dv6z7JHGO5WRxHxHxDm9utZLOdseznTWGO2Pz?=
 =?us-ascii?Q?SgJHmCFqXisyFwSRRd3miUm07pROR7MQXPLyuVXC1Cq9nbgQygD8gBy+CtqT?=
 =?us-ascii?Q?FPhAxk53tdO5x8b4/y7I6JQkQtbmigiUgitrVJ1ImJs8EGC4UywOodwhqTCM?=
 =?us-ascii?Q?qtnH3eNTC11IZnPn67sKM+PRLHrlRZqEeP7TOxjU+moGNR4BEBRwWJ5Axvsg?=
 =?us-ascii?Q?15HpQ1yXCZ55ar9UPEx4aJ2RanBBesjPD7THMVCBlJw14MY6L1pDaNI4MPAv?=
 =?us-ascii?Q?D3FqF4YaJf3iqqKAf8mCGd1KegnEaibIYIQBZFQwYGIYKJ5MBNYzFYQJz2xw?=
 =?us-ascii?Q?1lCj0R4Y/4YerD7sJxm81GMDcB6f3YcuUnjLK5Yib5fnq2CE24vOue51heXm?=
 =?us-ascii?Q?gAw7Ou/MjnMjnOUYq/AxY78sekUiwR4hYOk7Jx3+XXda3QV9uY4PubRsfvu8?=
 =?us-ascii?Q?CmC5540J7ZVlR9gqcGpuOWQwVZ2fOsQhM6h7oOznqQLdhUaccqL8a4AYCRsc?=
 =?us-ascii?Q?ML1WVk+Ie21WDypkiR/nPKhmic/xpgg0OCSTAZZpuvxS3CumVsDbSbfJYycT?=
 =?us-ascii?Q?eTdKlBXZEoMeN0p65K80G+S+I7YKbxcZZFky9ebR35Kg1AmvNmU/OgB0oAmP?=
 =?us-ascii?Q?ZsTU2KumvRyd/fQyWCF7wYYvkFteYEXmg1swutJECGxQINi1ye+Hs+wo3yy6?=
 =?us-ascii?Q?mirimXzXr1PW4xiyJlPhwJzOk+RWKiSYyHlW7yMRAtgMlIrMoi38WQW84EfW?=
 =?us-ascii?Q?x7uDdcQ1ZMP0FFwRCrKOW41ewB4yi6C2xfX9YJWEZQVMRESqzKJGNxW3xAoe?=
 =?us-ascii?Q?NT8LH/emD9Cc1QVjYgmL9PizgW5uxuOhVqkbB9mtCvmGvPUeXQgr64BIot0T?=
 =?us-ascii?Q?av9DSTQm/XfMZBEHZdDirBpbON7zuEU4cfcUibyXyPkQLO5pWherItF0SvjR?=
 =?us-ascii?Q?3ghM08lrfOD5zNVc34oErBw7KIFZNhkmh0JT429/QUMw/+Gzs2rRi2kDnIyW?=
 =?us-ascii?Q?yzWVx7goyk9Pa6Ja04xVAIF5jBY5NEQpuYq7tWCFdXAtS7F//CPD/itE4h8L?=
 =?us-ascii?Q?w3wAm9cf+2Ql1UYHckbGfgNTg156SiLJe/2rmtHf9tRU6a6LMyNj1F+TO865?=
 =?us-ascii?Q?6ZJUZxM+7h1CyzvBd/gTARM81zYiwC+CzCW3SxhuZHPuH3ZVHacWde4RFA1Y?=
 =?us-ascii?Q?OvgKynI5hiUSWI7bP2+A6EMkejblzxo8d3/xjd5khuHWajIsTZoW9/kiQsUm?=
 =?us-ascii?Q?Ca1JCHX+hAj4Yxbwh3vqiHo2gOvvFgnnnqFLT/Dta9Jc+xWf2hiwzlp6r6tb?=
 =?us-ascii?Q?RFg9VEYJDJ2aicp9/iqiPgiL2zEbCBEkInCd9+GlQ74UMWVdSg1RFT4Y7cIS?=
 =?us-ascii?Q?6GrbBw=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 97ba770a-63b2-4ae3-6e63-08d9d18a23ef
X-MS-Exchange-CrossTenant-AuthSource: AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 03:02:28.9627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZlZ81rce3g7oJmlFpDDQtzwSL8ArowFIvHz+vbLnxZFv4sexV2vqsZFN5Tv/D1arZleCUkmvvEUf0emp7Ba5bdAflrhJlIoW9evkP0kgNUU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1316
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add functions to enable routing on port,
which is not in vlan (there are no upper devices).

Also we can enable routing on vlan (there is upper device).
This feature will be used later.

prestera_hw_rif_create() takes index of allocated virtual router.

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>

Change-Id: I4756a6e92cc1f17a3ee727bb0653060431989c77
---
 .../net/ethernet/marvell/prestera/prestera.h  | 23 +++++
 .../ethernet/marvell/prestera/prestera_hw.c   | 97 +++++++++++++++++++
 .../ethernet/marvell/prestera/prestera_hw.h   |  7 ++
 3 files changed, 127 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index 797b2e4d3551..636caf492531 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -225,6 +225,29 @@ struct prestera_event {
 	};
 };
 
+enum prestera_if_type {
+	/* the interface is of port type (dev,port) */
+	PRESTERA_IF_PORT_E = 0,
+
+	/* the interface is of lag type (lag-id) */
+	PRESTERA_IF_LAG_E = 1,
+
+	/* the interface is of Vid type (vlan-id) */
+	PRESTERA_IF_VID_E = 3,
+};
+
+struct prestera_iface {
+	enum prestera_if_type type;
+	struct {
+		u32 hw_dev_num;
+		u32 port_num;
+	} dev_port;
+	u32 hw_dev_num;
+	u16 vr_id;
+	u16 lag_id;
+	u16 vlan_id;
+};
+
 struct prestera_switchdev;
 struct prestera_span;
 struct prestera_rxtx;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index 9dbd3d99175e..e6bfadc874c5 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -53,6 +53,8 @@ enum prestera_cmd_type_t {
 	PRESTERA_CMD_TYPE_VTCAM_IFACE_BIND = 0x560,
 	PRESTERA_CMD_TYPE_VTCAM_IFACE_UNBIND = 0x561,
 
+	PRESTERA_CMD_TYPE_ROUTER_RIF_CREATE = 0x600,
+	PRESTERA_CMD_TYPE_ROUTER_RIF_DELETE = 0x601,
 	PRESTERA_CMD_TYPE_ROUTER_VR_CREATE = 0x630,
 	PRESTERA_CMD_TYPE_ROUTER_VR_DELETE = 0x631,
 
@@ -483,6 +485,36 @@ struct prestera_msg_rxtx_resp {
 	__le32 map_addr;
 };
 
+struct prestera_msg_iface {
+	union {
+		struct {
+			__le32 dev;
+			__le32 port;
+		};
+		__le16 lag_id;
+	};
+	__le16 vr_id;
+	__le16 vid;
+	u8 type;
+	u8 __pad[3];
+};
+
+struct prestera_msg_rif_req {
+	struct prestera_msg_cmd cmd;
+	struct prestera_msg_iface iif;
+	__le32 mtu;
+	__le16 rif_id;
+	__le16 __reserved;
+	u8 mac[ETH_ALEN];
+	u8 __pad[2];
+};
+
+struct prestera_msg_rif_resp {
+	struct prestera_msg_ret ret;
+	__le16 rif_id;
+	u8 __pad[2];
+};
+
 struct prestera_msg_vr_req {
 	struct prestera_msg_cmd cmd;
 	__le16 vr_id;
@@ -564,8 +596,12 @@ static void prestera_hw_build_tests(void)
 	BUILD_BUG_ON(sizeof(struct prestera_msg_acl_action) != 32);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_counter_req) != 16);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_counter_stats) != 16);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_rif_req) != 36);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_vr_req) != 8);
 
+	/*  structure that are part of req/resp fw messages */
+	BUILD_BUG_ON(sizeof(struct prestera_msg_iface) != 16);
+
 	/* check responses */
 	BUILD_BUG_ON(sizeof(struct prestera_msg_common_resp) != 8);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_switch_init_resp) != 24);
@@ -577,6 +613,7 @@ static void prestera_hw_build_tests(void)
 	BUILD_BUG_ON(sizeof(struct prestera_msg_rxtx_resp) != 12);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_vtcam_resp) != 16);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_counter_resp) != 24);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_rif_resp) != 12);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_vr_resp) != 12);
 
 	/* check events */
@@ -1769,6 +1806,66 @@ int prestera_hw_bridge_port_delete(struct prestera_port *port, u16 bridge_id)
 			    &req.cmd, sizeof(req));
 }
 
+static int prestera_iface_to_msg(struct prestera_iface *iface,
+				 struct prestera_msg_iface *msg_if)
+{
+	switch (iface->type) {
+	case PRESTERA_IF_PORT_E:
+	case PRESTERA_IF_VID_E:
+		msg_if->port = __cpu_to_le32(iface->dev_port.port_num);
+		msg_if->dev = __cpu_to_le32(iface->dev_port.hw_dev_num);
+		break;
+	case PRESTERA_IF_LAG_E:
+		msg_if->lag_id = __cpu_to_le16(iface->lag_id);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	msg_if->vr_id = __cpu_to_le16(iface->vr_id);
+	msg_if->vid = __cpu_to_le16(iface->vlan_id);
+	msg_if->type = iface->type;
+	return 0;
+}
+
+int prestera_hw_rif_create(struct prestera_switch *sw,
+			   struct prestera_iface *iif, u8 *mac, u16 *rif_id)
+{
+	struct prestera_msg_rif_resp resp;
+	struct prestera_msg_rif_req req;
+	int err;
+
+	memcpy(req.mac, mac, ETH_ALEN);
+
+	err = prestera_iface_to_msg(iif, &req.iif);
+	if (err)
+		return err;
+
+	err = prestera_cmd_ret(sw, PRESTERA_CMD_TYPE_ROUTER_RIF_CREATE,
+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
+	if (err)
+		return err;
+
+	*rif_id = __le16_to_cpu(resp.rif_id);
+	return err;
+}
+
+int prestera_hw_rif_delete(struct prestera_switch *sw, u16 rif_id,
+			   struct prestera_iface *iif)
+{
+	struct prestera_msg_rif_req req = {
+		.rif_id = __cpu_to_le16(rif_id),
+	};
+	int err;
+
+	err = prestera_iface_to_msg(iif, &req.iif);
+	if (err)
+		return err;
+
+	return prestera_cmd(sw, PRESTERA_CMD_TYPE_ROUTER_RIF_DELETE, &req.cmd,
+			    sizeof(req));
+}
+
 int prestera_hw_vr_create(struct prestera_switch *sw, u16 *vr_id)
 {
 	struct prestera_msg_vr_resp resp;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
index 6d9fafad451d..3ff12bae5909 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -137,6 +137,7 @@ struct prestera_rxtx_params;
 struct prestera_acl_hw_action_info;
 struct prestera_acl_iface;
 struct prestera_counter_stats;
+struct prestera_iface;
 
 /* Switch API */
 int prestera_hw_switch_init(struct prestera_switch *sw);
@@ -238,6 +239,12 @@ int prestera_hw_span_bind(const struct prestera_port *port, u8 span_id);
 int prestera_hw_span_unbind(const struct prestera_port *port);
 int prestera_hw_span_release(struct prestera_switch *sw, u8 span_id);
 
+/* Router API */
+int prestera_hw_rif_create(struct prestera_switch *sw,
+			   struct prestera_iface *iif, u8 *mac, u16 *rif_id);
+int prestera_hw_rif_delete(struct prestera_switch *sw, u16 rif_id,
+			   struct prestera_iface *iif);
+
 /* Virtual Router API */
 int prestera_hw_vr_create(struct prestera_switch *sw, u16 *vr_id);
 int prestera_hw_vr_delete(struct prestera_switch *sw, u16 vr_id);
-- 
2.17.1

