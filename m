Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B433A6755
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 15:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233663AbhFNNDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 09:03:55 -0400
Received: from mail-eopbgr50111.outbound.protection.outlook.com ([40.107.5.111]:61697
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233454AbhFNNDs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 09:03:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g5TqV9yCv85BaAnQTuA9r3X087uUvnagrlZKkI4uTCQvrkyslcy7sjCHOrJQvLaM92Im5TX6f2chmEuwAWDsfs4keMdvAIohgqV8JhqC7OUldV8jdRmkVoqzlGkNxpUxvbrmMPm+EJdx7NclO0K3lsoGN/8a0SZBDi7zmOAuRHstuem3ZQFBHldloTjdOxUlV9rAafvhSupnQghhCLBICbJV/J4bcqBe0K/WhiX/1JACJ/tPMCrJnfSob8uSrfLUcsybW+UoZBlQyWOItJ08tZDprhLWYy45YrrfsZWSf5NWBvxdPEkiJ8Q2EXl9obIBixWB2N40hbNu+GZB+2/zqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sXJf3pYIi1qt++GFznyEDYAr9IkcDwx86dcQzUYgd2g=;
 b=gVXicEwTX+DReIdN4HUTtkbapfWLM8w34XgrYLNssfM/KIsTJDcDO8A7JJQdnteDkUfHSXiX24i0K+kk7PPF+BTobeEydeAD56hvaQ9dyV3BM3XL8aM5ooeQLMuIzyG/SrzxYms/dc0itNT6cpDke1nF+d/uLBhrwKiB/d2/ugRbXlbNFUQyWhwdEKy1sHoMaQVAHq9cetD4no24aJquxbD/vZ42Sg8WUynJS+k1cJne7uZKlodt12/d1vB5p7jYpeRb7HGiWzAXDyxY1YlNJg1qvq4vYKqAYQ1ePVymMrDiyC4TOWVs4WOIy6HdXiuSy7MQgE6012/PG06YTr0YSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sXJf3pYIi1qt++GFznyEDYAr9IkcDwx86dcQzUYgd2g=;
 b=p2kIstwafdjVku4P2atyMdjQgyBflOrEyrcC0WCXv7ityvkao/BnPY2rEc5mrWmDl887BQ+Rskk23XG3C2rwMtR2IctOpsN1lsqlFdzdh5YHC9v5bkQMpjPYGyNw5+/AJS+9Th+AKis0tnx53+5issO5CW/+nT21Xxg2CB3MQbM=
Authentication-Results: plvision.eu; dkim=none (message not signed)
 header.d=none;plvision.eu; dmarc=none action=none header.from=plvision.eu;
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM9P190MB1396.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:3b6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Mon, 14 Jun
 2021 13:01:41 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe%9]) with mapi id 15.20.4219.025; Mon, 14 Jun 2021
 13:01:41 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     oleksandr.mazur@plvision.eu, jiri@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vadym Kochan <vadym.kochan@plvision.eu>, andrew@lunn.ch,
        nikolay@nvidia.com, idosch@idosch.org
Subject: [PATCH net-next v2 5/7] net: marvell: prestera: devlink: add traps/groups implementation
Date:   Mon, 14 Jun 2021 16:01:16 +0300
Message-Id: <20210614130118.20395-6-oleksandr.mazur@plvision.eu>
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
Received: from omazur.x.ow.s (217.20.186.93) by AM0PR06CA0140.eurprd06.prod.outlook.com (2603:10a6:208:ab::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Mon, 14 Jun 2021 13:01:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4bfe3af3-7e1f-463e-deb6-08d92f348e01
X-MS-TrafficTypeDiagnostic: AM9P190MB1396:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9P190MB1396DFA85F2492FE6B1910E7E4319@AM9P190MB1396.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WE67Ents13CoNWDL/2fANa5Zzek41xpxcdXVKamp8Z5qhIjdrSq6yzMpMV9FywTuRQ6Aa73/4Nw6zdMd1HAl9AUrxgCEzRp463MV7N9OoMH9dkPfyl2Bld3nP7AnWQzoH7X6LBV9gJR1Yel/HyhxWTw1NEFYb36/YkoY19iPEpqUF/nLP9C1ehtcC8U3XYg2FNRSSOEjfJZ7YblcqQ6OIo7h8YmyV2BbI5K1WjUBn+LUtPPvSWDHVNVKKiPPgCV++LcsOwXOnTvfnH1onB3elYvtTIUXygjA/skm/zBiC0/jnoGsLJAnt209fWTqVrQnch2Y0tevvSMcFTGjSRFIbqrXxGKIWR1SBwFD372nWNRu4FFWRVMX6hieGQV5g80Qqx3dIg4qB1jDsagLaS8bfa6NP8ya6D10G6Gp9agfI+sKDUNzHXY8FmyzZVkV3nv1thpGz8uOZ/lbvs+CzEYHYfUDO90flSCwZ6kCJUD7qpucDD8Kml9pWXF1Q8+N80VYNBnlfHao+A9XK72cKPDatS7m5VSm7vasyI7l6qzfQESshx8LpSWDEwRvqWigUB0zVSFIDpumlE1/DBkRgAIh+P+uRLwfkqa3uQV0vOgtZFEtKrIVfbO99WG4ciwvpCxYicc58r0vkqimLfz6EBg/FA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(396003)(376002)(136003)(39830400003)(346002)(6486002)(110136005)(7416002)(66556008)(16526019)(186003)(83380400001)(66946007)(956004)(66476007)(2616005)(316002)(86362001)(26005)(8936002)(4326008)(8676002)(478600001)(2906002)(44832011)(66574015)(38350700002)(36756003)(6512007)(5660300002)(52116002)(6666004)(6506007)(30864003)(1076003)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BT1KpqXtXzyirHiWpzc/1AAjX10a7i71chr7lvuV+eOtiN41gODfh5JiCP94?=
 =?us-ascii?Q?5LkD5WwxWlUNA4oOk/fCpNuJDzsiKuQib1cjCA4wRtS8ZYUPBIqxRxcMENcA?=
 =?us-ascii?Q?/TurX7x4g3sXODMleWuIk4nZJpWY83OZYbOogjt/+PNa4FYvNdnhvYRxsjx1?=
 =?us-ascii?Q?NtL6uN70MUhNQR431OeRal8XDOaO19s3AMCNqGbCwBSSRkuiqdBwj0Ya4wpH?=
 =?us-ascii?Q?GgArp5h1gyvKqDdpvfi4obIk2RhaHmAU/68I8GFjNxOnfJtVwvOnKg3kiaEP?=
 =?us-ascii?Q?Gqd5CajQ1LauDZjv6xAYapECcTmVi8KZO/PP/+ynzxriAmV2W7Q57KSzyCei?=
 =?us-ascii?Q?uSOkEQ8Xl7GS2Qurj4Q8IPqY5h68kez1xZPqTA2pydyjie1g7VYoOREa3YFl?=
 =?us-ascii?Q?5IrLN4eYAa5x0gSYIwS/HNqRrpCNzVsOZBLJ94/4W/aOsMEegG1zRAIGuYHn?=
 =?us-ascii?Q?P8PTxFzLfajesXEsEdz75nrJ7x3vsMyVxbUGvpRvb89wHJdZWQsUih1/zu1o?=
 =?us-ascii?Q?dssCtXWVmD9lnoug17J5QQTsg1I+XfmwTb79SV6Qi0eQH4ibC+5fxRNtXQf8?=
 =?us-ascii?Q?zFQeExsYps+yFNzhwasYNBsqodH4vT+btc1cSKWI0/G3K19JfOe0YLhc+s9o?=
 =?us-ascii?Q?Uo/oTXa9JcepHcwEoQB9n+ke1DeEgMVX1xHGSu/nKDBs7aFDD2QKPVhjn+yj?=
 =?us-ascii?Q?/EsazVtk0UKT3JQqf6ss8D9GpKIajW8tR/Tjf6O5e0N1WG5AEAo5H4NVJOfx?=
 =?us-ascii?Q?Erc6U/0g+LbhV8ah9pZQUiZx6tpWXtuEjwWApFuT+PbZ/4DIKt3LYqNVI2TD?=
 =?us-ascii?Q?DTDM921cjFJnCQJnpW26U2Ywlzson3DSmE+e2YtESEMVSwwxBNU81j1UPrU8?=
 =?us-ascii?Q?idSmRX7vux7G5qTwKXjjr3cf9DFevGolFBVyRkTzJedxtGzzRUQ1KtXlTapO?=
 =?us-ascii?Q?UVpctd+vEXGV/tIw6Cbx2jxb2a492ng23pjeV2sebQf+NbXRXBYrhm1jgvtz?=
 =?us-ascii?Q?ca92DIllxe32JadcvlgKNT1pymRpfOMNKIMGJV6iUfJMphcK9LdbloYs9Oi5?=
 =?us-ascii?Q?iKBJ3uLtkM7kqM8rJy4aYWEJMZoImp8K6NHklYFGCvzMgbeBLhwZDz34bIWI?=
 =?us-ascii?Q?r8wVNjiVyfRu3iE2as7/S+REKVc65TJdLy708F0zr62P80cLokD60FV1Pbm2?=
 =?us-ascii?Q?Olb/At74N4qaBoaOeYmoXyQNtLdvqWOgYXn7FzPM7Og4ctFSKjSBk1FuLfG4?=
 =?us-ascii?Q?nYIyZmNAQa0TKZprhQGvEyWQiOfmbug1onsQqEfBBQcElbjPTdOOj9ZYxQrT?=
 =?us-ascii?Q?Ms+9EKopTIypHN0SEGCv+o+U?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bfe3af3-7e1f-463e-deb6-08d92f348e01
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 13:01:41.8331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lb4pxqapqRZbC55k0IS2jQYdNr07SKQmktV5T0PcoyvCTpbv17Lr3WnHgx0d5dJqlCEzdvUTZYC9ohz9RB7hqD4r+YWQrfIzLTsHFp0dzM4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1396
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add devlink traps registration (with corresponding groups) for
all the traffic types that driver traps to the CPU;
prestera_rxtx: report each packet trapped to the CPU (RX) to the
prestera_devlink;

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 .../net/ethernet/marvell/prestera/prestera.h  |   2 +
 .../marvell/prestera/prestera_devlink.c       | 439 +++++++++++++++++-
 .../marvell/prestera/prestera_devlink.h       |   3 +
 .../ethernet/marvell/prestera/prestera_dsa.c  |   3 +
 .../ethernet/marvell/prestera/prestera_dsa.h  |   1 +
 .../ethernet/marvell/prestera/prestera_rxtx.c |   7 +-
 6 files changed, 452 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index ad0f33a7e517..6353f1c67638 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -170,6 +170,7 @@ struct prestera_event {
 
 struct prestera_switchdev;
 struct prestera_rxtx;
+struct prestera_trap_data;
 
 struct prestera_switch {
 	struct prestera_device *dev;
@@ -177,6 +178,7 @@ struct prestera_switch {
 	struct prestera_rxtx *rxtx;
 	struct list_head event_handlers;
 	struct notifier_block netdev_nb;
+	struct prestera_trap_data *trap_data;
 	char base_mac[ETH_ALEN];
 	struct list_head port_list;
 	rwlock_t port_list_lock;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_devlink.c b/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
index 94c185a0e2b8..f59727f050ba 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
@@ -5,6 +5,276 @@
 
 #include "prestera_devlink.h"
 
+/* All driver-specific traps must be documented in
+ * Documentation/networking/devlink/prestera.rst
+ */
+enum {
+	DEVLINK_PRESTERA_TRAP_ID_BASE = DEVLINK_TRAP_GENERIC_ID_MAX,
+	DEVLINK_PRESTERA_TRAP_ID_ARP_BC,
+	DEVLINK_PRESTERA_TRAP_ID_IS_IS,
+	DEVLINK_PRESTERA_TRAP_ID_OSPF,
+	DEVLINK_PRESTERA_TRAP_ID_IP_BC_MAC,
+	DEVLINK_PRESTERA_TRAP_ID_ROUTER_MC,
+	DEVLINK_PRESTERA_TRAP_ID_VRRP,
+	DEVLINK_PRESTERA_TRAP_ID_DHCP,
+	DEVLINK_PRESTERA_TRAP_ID_MAC_TO_ME,
+	DEVLINK_PRESTERA_TRAP_ID_IPV4_OPTIONS,
+	DEVLINK_PRESTERA_TRAP_ID_IP_DEFAULT_ROUTE,
+	DEVLINK_PRESTERA_TRAP_ID_IP_TO_ME,
+	DEVLINK_PRESTERA_TRAP_ID_IPV4_ICMP_REDIRECT,
+	DEVLINK_PRESTERA_TRAP_ID_ACL_CODE_0,
+	DEVLINK_PRESTERA_TRAP_ID_ACL_CODE_1,
+	DEVLINK_PRESTERA_TRAP_ID_ACL_CODE_2,
+	DEVLINK_PRESTERA_TRAP_ID_ACL_CODE_3,
+	DEVLINK_PRESTERA_TRAP_ID_ACL_CODE_4,
+	DEVLINK_PRESTERA_TRAP_ID_ACL_CODE_5,
+	DEVLINK_PRESTERA_TRAP_ID_ACL_CODE_6,
+	DEVLINK_PRESTERA_TRAP_ID_ACL_CODE_7,
+	DEVLINK_PRESTERA_TRAP_ID_BGP,
+	DEVLINK_PRESTERA_TRAP_ID_SSH,
+	DEVLINK_PRESTERA_TRAP_ID_TELNET,
+	DEVLINK_PRESTERA_TRAP_ID_ICMP,
+};
+
+#define DEVLINK_PRESTERA_TRAP_NAME_ARP_BC \
+	"arp_bc"
+#define DEVLINK_PRESTERA_TRAP_NAME_IS_IS \
+	"is_is"
+#define DEVLINK_PRESTERA_TRAP_NAME_OSPF \
+	"ospf"
+#define DEVLINK_PRESTERA_TRAP_NAME_IP_BC_MAC \
+	"ip_bc_mac"
+#define DEVLINK_PRESTERA_TRAP_NAME_ROUTER_MC \
+	"router_mc"
+#define DEVLINK_PRESTERA_TRAP_NAME_VRRP \
+	"vrrp"
+#define DEVLINK_PRESTERA_TRAP_NAME_DHCP \
+	"dhcp"
+#define DEVLINK_PRESTERA_TRAP_NAME_MAC_TO_ME \
+	"mac_to_me"
+#define DEVLINK_PRESTERA_TRAP_NAME_IPV4_OPTIONS \
+	"ipv4_options"
+#define DEVLINK_PRESTERA_TRAP_NAME_IP_DEFAULT_ROUTE \
+	"ip_default_route"
+#define DEVLINK_PRESTERA_TRAP_NAME_IP_TO_ME \
+	"ip_to_me"
+#define DEVLINK_PRESTERA_TRAP_NAME_IPV4_ICMP_REDIRECT \
+	"ipv4_icmp_redirect"
+#define DEVLINK_PRESTERA_TRAP_NAME_ACL_CODE_0 \
+	"acl_code_0"
+#define DEVLINK_PRESTERA_TRAP_NAME_ACL_CODE_1 \
+	"acl_code_1"
+#define DEVLINK_PRESTERA_TRAP_NAME_ACL_CODE_2 \
+	"acl_code_2"
+#define DEVLINK_PRESTERA_TRAP_NAME_ACL_CODE_3 \
+	"acl_code_3"
+#define DEVLINK_PRESTERA_TRAP_NAME_ACL_CODE_4 \
+	"acl_code_4"
+#define DEVLINK_PRESTERA_TRAP_NAME_ACL_CODE_5 \
+	"acl_code_5"
+#define DEVLINK_PRESTERA_TRAP_NAME_ACL_CODE_6 \
+	"acl_code_6"
+#define DEVLINK_PRESTERA_TRAP_NAME_ACL_CODE_7 \
+	"acl_code_7"
+#define DEVLINK_PRESTERA_TRAP_NAME_BGP \
+	"bgp"
+#define DEVLINK_PRESTERA_TRAP_NAME_SSH \
+	"ssh"
+#define DEVLINK_PRESTERA_TRAP_NAME_TELNET \
+	"telnet"
+#define DEVLINK_PRESTERA_TRAP_NAME_ICMP \
+	"icmp"
+
+struct prestera_trap {
+	struct devlink_trap trap;
+	u8 cpu_code;
+};
+
+struct prestera_trap_item {
+	enum devlink_trap_action action;
+	void *trap_ctx;
+};
+
+struct prestera_trap_data {
+	struct prestera_switch *sw;
+	struct prestera_trap_item *trap_items_arr;
+	u32 traps_count;
+};
+
+#define PRESTERA_TRAP_METADATA DEVLINK_TRAP_METADATA_TYPE_F_IN_PORT
+
+#define PRESTERA_TRAP_CONTROL(_id, _group_id, _action)			      \
+	DEVLINK_TRAP_GENERIC(CONTROL, _action, _id,			      \
+			     DEVLINK_TRAP_GROUP_GENERIC_ID_##_group_id,	      \
+			     PRESTERA_TRAP_METADATA)
+
+#define PRESTERA_TRAP_DRIVER_CONTROL(_id, _group_id)			      \
+	DEVLINK_TRAP_DRIVER(CONTROL, TRAP, DEVLINK_PRESTERA_TRAP_ID_##_id,    \
+			    DEVLINK_PRESTERA_TRAP_NAME_##_id,		      \
+			    DEVLINK_TRAP_GROUP_GENERIC_ID_##_group_id,	      \
+			    PRESTERA_TRAP_METADATA)
+
+#define PRESTERA_TRAP_EXCEPTION(_id, _group_id)				      \
+	DEVLINK_TRAP_GENERIC(EXCEPTION, TRAP, _id,			      \
+			     DEVLINK_TRAP_GROUP_GENERIC_ID_##_group_id,	      \
+			     PRESTERA_TRAP_METADATA)
+
+#define PRESTERA_TRAP_DRIVER_EXCEPTION(_id, _group_id)			      \
+	DEVLINK_TRAP_DRIVER(EXCEPTION, TRAP, DEVLINK_PRESTERA_TRAP_ID_##_id,  \
+			    DEVLINK_PRESTERA_TRAP_NAME_##_id,		      \
+			    DEVLINK_TRAP_GROUP_GENERIC_ID_##_group_id,	      \
+			    PRESTERA_TRAP_METADATA)
+
+static const struct devlink_trap_group prestera_trap_groups_arr[] = {
+	/* No policer is associated with following groups (policerid == 0)*/
+	DEVLINK_TRAP_GROUP_GENERIC(L2_DROPS, 0),
+	DEVLINK_TRAP_GROUP_GENERIC(L3_DROPS, 0),
+	DEVLINK_TRAP_GROUP_GENERIC(L3_EXCEPTIONS, 0),
+	DEVLINK_TRAP_GROUP_GENERIC(NEIGH_DISCOVERY, 0),
+	DEVLINK_TRAP_GROUP_GENERIC(ACL_TRAP, 0),
+	DEVLINK_TRAP_GROUP_GENERIC(ACL_DROPS, 0),
+	DEVLINK_TRAP_GROUP_GENERIC(ACL_SAMPLE, 0),
+	DEVLINK_TRAP_GROUP_GENERIC(OSPF, 0),
+	DEVLINK_TRAP_GROUP_GENERIC(STP, 0),
+	DEVLINK_TRAP_GROUP_GENERIC(LACP, 0),
+	DEVLINK_TRAP_GROUP_GENERIC(LLDP, 0),
+	DEVLINK_TRAP_GROUP_GENERIC(VRRP, 0),
+	DEVLINK_TRAP_GROUP_GENERIC(DHCP, 0),
+	DEVLINK_TRAP_GROUP_GENERIC(BGP, 0),
+	DEVLINK_TRAP_GROUP_GENERIC(LOCAL_DELIVERY, 0),
+};
+
+/* Initialize trap list, as well as associate CPU code with them. */
+static struct prestera_trap prestera_trap_items_arr[] = {
+	{
+		.trap = PRESTERA_TRAP_DRIVER_CONTROL(ARP_BC, NEIGH_DISCOVERY),
+		.cpu_code = 5,
+	},
+	{
+		.trap = PRESTERA_TRAP_DRIVER_CONTROL(IS_IS, LOCAL_DELIVERY),
+		.cpu_code = 13,
+	},
+	{
+		.trap = PRESTERA_TRAP_DRIVER_CONTROL(OSPF, OSPF),
+		.cpu_code = 16,
+	},
+	{
+		.trap = PRESTERA_TRAP_DRIVER_CONTROL(IP_BC_MAC, LOCAL_DELIVERY),
+		.cpu_code = 19,
+	},
+	{
+		.trap = PRESTERA_TRAP_CONTROL(STP, STP, TRAP),
+		.cpu_code = 26,
+	},
+	{
+		.trap = PRESTERA_TRAP_CONTROL(LACP, LACP, TRAP),
+		.cpu_code = 27,
+	},
+	{
+		.trap = PRESTERA_TRAP_CONTROL(LLDP, LLDP, TRAP),
+		.cpu_code = 28,
+	},
+	{
+		.trap = PRESTERA_TRAP_DRIVER_CONTROL(ROUTER_MC, LOCAL_DELIVERY),
+		.cpu_code = 29,
+	},
+	{
+		.trap = PRESTERA_TRAP_DRIVER_CONTROL(VRRP, VRRP),
+		.cpu_code = 30,
+	},
+	{
+		.trap = PRESTERA_TRAP_DRIVER_CONTROL(DHCP, DHCP),
+		.cpu_code = 33,
+	},
+	{
+		.trap = PRESTERA_TRAP_EXCEPTION(MTU_ERROR, L3_EXCEPTIONS),
+		.cpu_code = 63,
+	},
+	{
+		.trap = PRESTERA_TRAP_DRIVER_CONTROL(MAC_TO_ME, LOCAL_DELIVERY),
+		.cpu_code = 65,
+	},
+	{
+		.trap = PRESTERA_TRAP_EXCEPTION(TTL_ERROR, L3_EXCEPTIONS),
+		.cpu_code = 133,
+	},
+	{
+		.trap = PRESTERA_TRAP_DRIVER_EXCEPTION(IPV4_OPTIONS,
+						       L3_EXCEPTIONS),
+		.cpu_code = 141,
+	},
+	{
+		.trap = PRESTERA_TRAP_DRIVER_CONTROL(IP_DEFAULT_ROUTE,
+						     LOCAL_DELIVERY),
+		.cpu_code = 160,
+	},
+	{
+		.trap = PRESTERA_TRAP_CONTROL(LOCAL_ROUTE, LOCAL_DELIVERY,
+					      TRAP),
+		.cpu_code = 161,
+	},
+	{
+		.trap = PRESTERA_TRAP_DRIVER_EXCEPTION(IPV4_ICMP_REDIRECT,
+						       L3_EXCEPTIONS),
+		.cpu_code = 180,
+	},
+	{
+		.trap = PRESTERA_TRAP_CONTROL(ARP_RESPONSE, NEIGH_DISCOVERY,
+					      TRAP),
+		.cpu_code = 188,
+	},
+	{
+		.trap = PRESTERA_TRAP_DRIVER_CONTROL(ACL_CODE_0, ACL_TRAP),
+		.cpu_code = 192,
+	},
+	{
+		.trap = PRESTERA_TRAP_DRIVER_CONTROL(ACL_CODE_1, ACL_TRAP),
+		.cpu_code = 193,
+	},
+	{
+		.trap = PRESTERA_TRAP_DRIVER_CONTROL(ACL_CODE_2, ACL_TRAP),
+		.cpu_code = 194,
+	},
+	{
+		.trap = PRESTERA_TRAP_DRIVER_CONTROL(ACL_CODE_3, ACL_TRAP),
+		.cpu_code = 195,
+	},
+	{
+		.trap = PRESTERA_TRAP_DRIVER_CONTROL(ACL_CODE_4, ACL_TRAP),
+		.cpu_code = 196,
+	},
+	{
+		.trap = PRESTERA_TRAP_DRIVER_CONTROL(ACL_CODE_5, ACL_TRAP),
+		.cpu_code = 197,
+	},
+	{
+		.trap = PRESTERA_TRAP_DRIVER_CONTROL(ACL_CODE_6, ACL_TRAP),
+		.cpu_code = 198,
+	},
+	{
+		.trap = PRESTERA_TRAP_DRIVER_CONTROL(ACL_CODE_7, ACL_TRAP),
+		.cpu_code = 199,
+	},
+	{
+		.trap = PRESTERA_TRAP_DRIVER_CONTROL(BGP, BGP),
+		.cpu_code = 206,
+	},
+	{
+		.trap = PRESTERA_TRAP_DRIVER_CONTROL(SSH, LOCAL_DELIVERY),
+		.cpu_code = 207,
+	},
+	{
+		.trap = PRESTERA_TRAP_DRIVER_CONTROL(TELNET, LOCAL_DELIVERY),
+		.cpu_code = 208,
+	},
+	{
+		.trap = PRESTERA_TRAP_DRIVER_CONTROL(ICMP, LOCAL_DELIVERY),
+		.cpu_code = 209,
+	},
+};
+
+static void prestera_devlink_traps_fini(struct prestera_switch *sw);
+
 static int prestera_dl_info_get(struct devlink *dl,
 				struct devlink_info_req *req,
 				struct netlink_ext_ack *extack)
@@ -27,8 +297,20 @@ static int prestera_dl_info_get(struct devlink *dl,
 					       buf);
 }
 
+static int prestera_trap_init(struct devlink *devlink,
+			      const struct devlink_trap *trap, void *trap_ctx);
+
+static int prestera_trap_action_set(struct devlink *devlink,
+				    const struct devlink_trap *trap,
+				    enum devlink_trap_action action,
+				    struct netlink_ext_ack *extack);
+
+static int prestera_devlink_traps_register(struct prestera_switch *sw);
+
 static const struct devlink_ops prestera_dl_ops = {
 	.info_get = prestera_dl_info_get,
+	.trap_init = prestera_trap_init,
+	.trap_action_set = prestera_trap_action_set,
 };
 
 struct prestera_switch *prestera_devlink_alloc(void)
@@ -53,17 +335,32 @@ int prestera_devlink_register(struct prestera_switch *sw)
 	int err;
 
 	err = devlink_register(dl, sw->dev->dev);
-	if (err)
+	if (err) {
 		dev_err(prestera_dev(sw), "devlink_register failed: %d\n", err);
+		return err;
+	}
 
-	return err;
+	err = prestera_devlink_traps_register(sw);
+	if (err) {
+		devlink_unregister(dl);
+		dev_err(sw->dev->dev, "devlink_traps_register failed: %d\n",
+			err);
+		return err;
+	}
+
+	return 0;
 }
 
 void prestera_devlink_unregister(struct prestera_switch *sw)
 {
+	struct prestera_trap_data *trap_data = sw->trap_data;
 	struct devlink *dl = priv_to_devlink(sw);
 
+	prestera_devlink_traps_fini(sw);
 	devlink_unregister(dl);
+
+	kfree(trap_data->trap_items_arr);
+	kfree(trap_data);
 }
 
 int prestera_devlink_port_register(struct prestera_port *port)
@@ -110,3 +407,141 @@ struct devlink_port *prestera_devlink_get_port(struct net_device *dev)
 
 	return &port->dl_port;
 }
+
+static int prestera_devlink_traps_register(struct prestera_switch *sw)
+{
+	const u32 groups_count = ARRAY_SIZE(prestera_trap_groups_arr);
+	const u32 traps_count = ARRAY_SIZE(prestera_trap_items_arr);
+	struct devlink *devlink = priv_to_devlink(sw);
+	struct prestera_trap_data *trap_data;
+	struct prestera_trap *prestera_trap;
+	int err, i;
+
+	trap_data = kzalloc(sizeof(*trap_data), GFP_KERNEL);
+	if (!trap_data)
+		return -ENOMEM;
+
+	trap_data->trap_items_arr = kcalloc(traps_count,
+					    sizeof(struct prestera_trap_item),
+					    GFP_KERNEL);
+	if (!trap_data->trap_items_arr) {
+		err = -ENOMEM;
+		goto err_trap_items_alloc;
+	}
+
+	trap_data->sw = sw;
+	trap_data->traps_count = traps_count;
+	sw->trap_data = trap_data;
+
+	err = devlink_trap_groups_register(devlink, prestera_trap_groups_arr,
+					   groups_count);
+	if (err)
+		goto err_groups_register;
+
+	for (i = 0; i < traps_count; i++) {
+		prestera_trap = &prestera_trap_items_arr[i];
+		err = devlink_traps_register(devlink, &prestera_trap->trap, 1,
+					     sw);
+		if (err)
+			goto err_trap_register;
+	}
+
+	return 0;
+
+err_trap_register:
+	for (i--; i >= 0; i--) {
+		prestera_trap = &prestera_trap_items_arr[i];
+		devlink_traps_unregister(devlink, &prestera_trap->trap, 1);
+	}
+err_groups_register:
+	kfree(trap_data->trap_items_arr);
+err_trap_items_alloc:
+	kfree(trap_data);
+	return err;
+}
+
+static struct prestera_trap_item *
+prestera_get_trap_item_by_cpu_code(struct prestera_switch *sw, u8 cpu_code)
+{
+	struct prestera_trap_data *trap_data = sw->trap_data;
+	struct prestera_trap *prestera_trap;
+	int i;
+
+	for (i = 0; i < trap_data->traps_count; i++) {
+		prestera_trap = &prestera_trap_items_arr[i];
+		if (cpu_code == prestera_trap->cpu_code)
+			return &trap_data->trap_items_arr[i];
+	}
+
+	return NULL;
+}
+
+void prestera_devlink_trap_report(struct prestera_port *port,
+				  struct sk_buff *skb, u8 cpu_code)
+{
+	struct prestera_trap_item *trap_item;
+	struct devlink *devlink;
+
+	devlink = port->dl_port.devlink;
+
+	trap_item = prestera_get_trap_item_by_cpu_code(port->sw, cpu_code);
+	if (unlikely(!trap_item))
+		return;
+
+	devlink_trap_report(devlink, skb, trap_item->trap_ctx,
+			    &port->dl_port, NULL);
+}
+
+static struct prestera_trap_item *
+prestera_devlink_trap_item_lookup(struct prestera_switch *sw, u16 trap_id)
+{
+	struct prestera_trap_data *trap_data = sw->trap_data;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(prestera_trap_items_arr); i++) {
+		if (prestera_trap_items_arr[i].trap.id == trap_id)
+			return &trap_data->trap_items_arr[i];
+	}
+
+	return NULL;
+}
+
+static int prestera_trap_init(struct devlink *devlink,
+			      const struct devlink_trap *trap, void *trap_ctx)
+{
+	struct prestera_switch *sw = devlink_priv(devlink);
+	struct prestera_trap_item *trap_item;
+
+	trap_item = prestera_devlink_trap_item_lookup(sw, trap->id);
+	if (WARN_ON(!trap_item))
+		return -EINVAL;
+
+	trap_item->trap_ctx = trap_ctx;
+	trap_item->action = trap->init_action;
+
+	return 0;
+}
+
+static int prestera_trap_action_set(struct devlink *devlink,
+				    const struct devlink_trap *trap,
+				    enum devlink_trap_action action,
+				    struct netlink_ext_ack *extack)
+{
+	/* Currently, driver does not support trap action altering */
+	return -EOPNOTSUPP;
+}
+
+static void prestera_devlink_traps_fini(struct prestera_switch *sw)
+{
+	struct devlink *dl = priv_to_devlink(sw);
+	const struct devlink_trap *trap;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(prestera_trap_items_arr); ++i) {
+		trap = &prestera_trap_items_arr[i].trap;
+		devlink_traps_unregister(dl, trap, 1);
+	}
+
+	devlink_trap_groups_unregister(dl, prestera_trap_groups_arr,
+				       ARRAY_SIZE(prestera_trap_groups_arr));
+}
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_devlink.h b/drivers/net/ethernet/marvell/prestera/prestera_devlink.h
index 51bee9f75415..5d73aa9db897 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_devlink.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_devlink.h
@@ -20,4 +20,7 @@ void prestera_devlink_port_clear(struct prestera_port *port);
 
 struct devlink_port *prestera_devlink_get_port(struct net_device *dev);
 
+void prestera_devlink_trap_report(struct prestera_port *port,
+				  struct sk_buff *skb, u8 cpu_code);
+
 #endif /* _PRESTERA_DEVLINK_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_dsa.c b/drivers/net/ethernet/marvell/prestera/prestera_dsa.c
index a5e01c7a307b..b7e89c0ca5c0 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_dsa.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_dsa.c
@@ -19,6 +19,7 @@
 #define PRESTERA_DSA_W1_EXT_BIT		BIT(31)
 #define PRESTERA_DSA_W1_CFI_BIT		BIT(30)
 #define PRESTERA_DSA_W1_PORT_NUM	GENMASK(11, 10)
+#define PRESTERA_DSA_W1_MASK_CPU_CODE	GENMASK(7, 0)
 
 #define PRESTERA_DSA_W2_EXT_BIT		BIT(31)
 #define PRESTERA_DSA_W2_PORT_NUM	BIT(20)
@@ -74,6 +75,8 @@ int prestera_dsa_parse(struct prestera_dsa *dsa, const u8 *dsa_buf)
 			(FIELD_GET(PRESTERA_DSA_W1_PORT_NUM, words[1]) << 5) |
 			(FIELD_GET(PRESTERA_DSA_W2_PORT_NUM, words[2]) << 7);
 
+	dsa->cpu_code = FIELD_GET(PRESTERA_DSA_W1_MASK_CPU_CODE, words[1]);
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_dsa.h b/drivers/net/ethernet/marvell/prestera/prestera_dsa.h
index 67018629bdd2..c99342f475cf 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_dsa.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_dsa.h
@@ -27,6 +27,7 @@ struct prestera_dsa {
 	struct prestera_dsa_vlan vlan;
 	u32 hw_dev_num;
 	u32 port_num;
+	u8 cpu_code;
 };
 
 int prestera_dsa_parse(struct prestera_dsa *dsa, const u8 *dsa_buf);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
index 2a13c318048c..73d2eba5262f 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
@@ -14,6 +14,7 @@
 #include "prestera.h"
 #include "prestera_hw.h"
 #include "prestera_rxtx.h"
+#include "prestera_devlink.h"
 
 #define PRESTERA_SDMA_WAIT_MUL		10
 
@@ -214,9 +215,10 @@ static struct sk_buff *prestera_sdma_rx_skb_get(struct prestera_sdma *sdma,
 static int prestera_rxtx_process_skb(struct prestera_sdma *sdma,
 				     struct sk_buff *skb)
 {
-	const struct prestera_port *port;
+	struct prestera_port *port;
 	struct prestera_dsa dsa;
 	u32 hw_port, dev_id;
+	u8 cpu_code;
 	int err;
 
 	skb_pull(skb, ETH_HLEN);
@@ -259,6 +261,9 @@ static int prestera_rxtx_process_skb(struct prestera_sdma *sdma,
 		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), tci);
 	}
 
+	cpu_code = dsa.cpu_code;
+	prestera_devlink_trap_report(port, skb, cpu_code);
+
 	return 0;
 }
 
-- 
2.17.1

