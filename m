Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C23FF3A1908
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 17:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233624AbhFIPSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 11:18:48 -0400
Received: from mail-eopbgr80090.outbound.protection.outlook.com ([40.107.8.90]:23438
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239114AbhFIPSn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 11:18:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BDf1do3G/nHX+US5r2v1v80epJfWaf4G72yG9RmdtsfNppSxYyC6u9ZfqDnpfZDWZtvnIwwTaRe69H+yy6iNSqzeLsHfFg42TqD/xBPpAAE5XfT25DpJ8M2rmw/EOx5mNmsQbR7g01xQ73Aa0Cyp9U6zNvYgxpYvop//id+WQk9IXJq5AqkXm3TpJFWecrue4Da9sz2K3OzctvuL5Hi3monrFOo6YCYoGxY7mWxgmS1EQqb6brETLwomdJ8eV6oLINZRT0p6YUa5M3tbeDdvOUYAcxtzgJUh/90C2DwNbUIQ8BxG6O/c4R78c5RXa80jKeoHyHQOhtNo1RaTV5d8mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KXJTtDZeQJcovM5MFX8u5Vgl+7cFCe5AOUL9aSn96O4=;
 b=PmECzPfkXJyjGI1mU1PkYJ3YjC1pujRon08RBa4FRH4YrVOmoN+4PGFKvxUOKt4J8ysc4HH29us0DeAsvZOEJ8NQ3IFXDhWrq7s/Q+aZneznSRoumsrBi8fuaL/K/4YFVcySzSWOkzttaeoVCpEoAfad63MBM3XdukepqRjo8Gz3xYtuep76aGc9oVqPqjWQxpyNqMF8s9bJ0xH1TfDZ5tZhg6NrGQXhzzISn0DGnL1rKM/2SJpRIG8clM6CnrJqMvoqhFVj/cehWteURIpbgCs/1GIXD0teagBn08AVfOvVanwYRdT4V9mJXCLMP8rfXK20uSUQsZsTOJB5UOYCyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KXJTtDZeQJcovM5MFX8u5Vgl+7cFCe5AOUL9aSn96O4=;
 b=ay2W0SRMk6QSIsdmRc0skINbrs4oH8sWopbSN2Yvg8XrYDvMENFh7SIn4keQI7mSyXFnOacBWxd1S1t1XP02onl4XnkrqvrMfqKukGFK8FHIXHZoK8d1pOTJUoYiwP9urmyU//xfItCYpXfbh4mQgp8Kc7IRG+vkX0k7Wfbo8eo=
Authentication-Results: plvision.eu; dkim=none (message not signed)
 header.d=none;plvision.eu; dmarc=none action=none header.from=plvision.eu;
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM9P190MB1427.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:3ea::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Wed, 9 Jun
 2021 15:16:46 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe%9]) with mapi id 15.20.4219.021; Wed, 9 Jun 2021
 15:16:46 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     oleksandr.mazur@plvision.eu, jiri@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 08/11] net: marvell: prestera: devlink: add traps/groups implementation
Date:   Wed,  9 Jun 2021 18:15:58 +0300
Message-Id: <20210609151602.29004-9-oleksandr.mazur@plvision.eu>
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
Received: from omazur.x.ow.s (217.20.186.93) by AM0PR06CA0092.eurprd06.prod.outlook.com (2603:10a6:208:fa::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Wed, 9 Jun 2021 15:16:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f0c4f1e-8f47-457f-65ea-08d92b5998da
X-MS-TrafficTypeDiagnostic: AM9P190MB1427:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9P190MB14276CBEB7E3899625341A3CE4369@AM9P190MB1427.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UinDwA+Q6ERtpoVv2dZP74kE79Pr/IteYjaTLAzJIN4S5L9B0zSNvuyKZr9ohNV7+4yj54vzuxIf4REqfyVX1Mv6uAXjsaq3tlMTiuUZmIGu8HbdYWtnysLXUFe2WV41Gyv9BZN+QGM9pDkQqdtc1d42zWKk9gaR93nMc4s17604EehBbu+NrXuqhVFKrykB1wsENHEmQzO1f6gqq5lpjJx70UehXXT5wEFT/ZEFqxdrn3p9rMJVY8/pXlP7ZdNjlxessjzUS+5XF7ws9Wb0OrlHmzW94F2hpkV0n3xL2CYKyRQtOXSfAnAUQnxt091peOi5liOgAq/4AVl7sZ0R60cA2b8iP/s36Bd2R9VQbO23bzZ9WMb0UJ7y8uo50ro686532yJ1a6kqWvDZ9oeXAa74/+8EF2/gaag/FBh3O2x93cike/ZMbASSLPpHYKihlGjpSQycvk8Je+vDPyFkhdZhOtc9dV8eMhteMzYyWyFnkOHKGkEjvcvaWKPIcQLck1zvaCdXm8bmMXz/uFHiqpITx8ynvvkrPnmeTpfkWFfwFpSFGehUxW6umEyga9Oi3ox6WEg7+2WAN0sx/S4ha6YvMbOBfAUCcHE1OYxDjRcPBsUpla86ba8mcT0oH7zFxaP9hTSd6ixrND0WKFryXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(136003)(39830400003)(366004)(83380400001)(956004)(52116002)(2906002)(1076003)(186003)(66556008)(66946007)(16526019)(6506007)(2616005)(6486002)(6666004)(26005)(66476007)(38350700002)(8676002)(36756003)(86362001)(4326008)(30864003)(66574015)(110136005)(5660300002)(478600001)(44832011)(6512007)(38100700002)(316002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?8twF1HtYNqJm2GDVBqrh6j7QEx6mWU8W5+6j+l67jQE6mP4PqBJ6ygX4mxGM?=
 =?us-ascii?Q?WH/WVZNa9OaNXi7Y9BaXUf03I0um7NRNhExbrvu5rIIdZBvBcncl5sDPAczS?=
 =?us-ascii?Q?utFeyQiHkE0U8z9sy3pLTyf+5l9KOQCiB0OC5ORKXm/80YMxEPOn67cZpNsp?=
 =?us-ascii?Q?tk1FmSqFGjqjfnPk/lYeWUl//oini375eRTDm3ljY3VxDi+kNH6a7A8aI8/L?=
 =?us-ascii?Q?86ee0a6UBEC4zgjQcllyCcxfcNVh/xnzWdVT3xY1gDFthEQu20uIRiihZpe8?=
 =?us-ascii?Q?asfYZ7DwlDqadXwanY1EXzyMZTU+Z3cLlRCMAH0WhFNyzBYpgZHTqRAT1wCg?=
 =?us-ascii?Q?1Hf+cn+leWgPvN1zI7KZwuFQuju5pr+2Nuc8w6nghe/O0tiZH/5Ov6EWB2Zd?=
 =?us-ascii?Q?w9lpUtwvG5KZBJvXR7YTLUEdgxGA6WFYw5AisnEvbsut8ZdaXPW3AnUtLWkb?=
 =?us-ascii?Q?cAubjne7sdHkXhnts/aI7DNyfbdFULTN+uH6LAuQeB9jB9uVoFeO7GnF/qPR?=
 =?us-ascii?Q?EGsMTthKpEyCLcqfUme/1cr7Zf28zYQNSutHYbfYusnsuubMIp1jJD/qqCA6?=
 =?us-ascii?Q?SwQ0L4Yu/E2CJxN9xfaHxv5xfxIsdDO68jhDVwqSwSn0Nqya0+IrWCTSEJUm?=
 =?us-ascii?Q?XS/iIKGxi87NdvrVDk3HSl1E0cesOrV2dA/2ECm0StulFI1iYR7XOdR5llcs?=
 =?us-ascii?Q?5hFLs3s82EpUHq7TqW9oGivvXo6EbTz2drGzci6PFIKSSBiKvJp+/Up2W01W?=
 =?us-ascii?Q?8Lkwl2BwOwxT+tM7qt0a5eBv1vUUdiQmasGk3rh2t1z8I/Y6WbmNhm7Rshzl?=
 =?us-ascii?Q?pLAKfrV8WyxHJMga2To6JGfsOwh/c0PSCOwoLyqEBZwCkrAja4kwDZaArcnx?=
 =?us-ascii?Q?oQFDPZc3LNtDp+dTtbn4eoCTzF3scki4Wd5wZXwG0in9/3Q1OlX7CuhSjHs7?=
 =?us-ascii?Q?GrCqgqMuiSFokhjS898aGp5rSAo7K7oE2QLyOMSaDuSj7OB0/9G94BiNR0r2?=
 =?us-ascii?Q?ZTaC1Z/wQrT9Vc8dFAbgNh90ujtUMS6m53Z9GWtAIP1cRSbQuHo0gavhYc4+?=
 =?us-ascii?Q?tBF2+g80r+W37JqAe8g+9QC4lK1PYGB5RsFBsQOkgpeznMcxcbMORp8kwaTE?=
 =?us-ascii?Q?bWH81ptULGYsH0mLln4/Sf+PJ+sqednShtJ8/Iv2wDJ4P8zSjVAVoUeuTcav?=
 =?us-ascii?Q?kIH//9bYB8kk4vAdM45sThLercV7mvpPwW4LQnZPX5K7OS0BXIJ7pOeM6Vto?=
 =?us-ascii?Q?VStIMWrnQvJdHn6JVcz1B1s4DTnoaroEz2awgBxFNiZrvToTmB+iFG8vA5Cf?=
 =?us-ascii?Q?L5BPMLyN3MGCxmMT9XrFfdES?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f0c4f1e-8f47-457f-65ea-08d92b5998da
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 15:16:46.7851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EXypXZfVbNs7jIbcMfyX13s6Y4byZrF9jREwAQMhD+R3+oKuB/g0rQ772No47WLvCDR2U5aQ+EZLYAgrLyphn8rjSk429mhqq0ywBQBWo+k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1427
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
index 55aa4bf8a27c..2c94bdec84b1 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -151,6 +151,7 @@ struct prestera_event {
 
 struct prestera_switchdev;
 struct prestera_rxtx;
+struct prestera_trap_data;
 
 struct prestera_switch {
 	struct prestera_device *dev;
@@ -158,6 +159,7 @@ struct prestera_switch {
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

