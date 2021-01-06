Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80D0C2EBE56
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 14:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbhAFNLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 08:11:45 -0500
Received: from mail-am6eur05on2048.outbound.protection.outlook.com ([40.107.22.48]:48736
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726884AbhAFNLm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 08:11:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vt3ZmF59XlkNsYZ9taYc75vLt0LuEBYRHPHtdKb3Fyk19ujFy42ZqRmkPYlef4lcP4aby2M5dOorGafnovDqNXWCCj/gO4mi/zF59nqhzDvSEpN4LbBTrnX7v2LaDdacXjBoGzziPgYjyr9+YjKjtddVb6EnjK3/fbUtdx1kHMXwTo4ImIDVeelADfk7iZYn7W5GQCSL1+04edo9M/rpwJYULrIpA63jvAVXpnEC2nB1vuq87p+wHUF+thP6vGaYptK8ZRWDk/bWy10V74k43n9CUv+hVxLHzQldCbwnBJ4KOMjthGrx+9wXunsqOjmB1x3V+a8vLnTF7fflYNFgYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R8mp9zlcJSBBOZIgKzvbZxmMVKS1zaSvOR1lh/ptF+A=;
 b=HCVpD6WZXg0ZNBeAd5X5QgDtULZdexLixzVfI3cdHZDlwpIgejm009VXMV2swtUU7Tp651ySPErC0VR3OITnMB7rMpu0OLskirZzVwiINteAFY5SQRrvvkuXoG5Qo1UROPR4gCLqaTbS7rqtKThUvMX0XvPSH158G0jcfrPiTbYvvJgQGVuBXu5cuJ0J9NIeP15vwJHCoLdtYaCEt1vUEgvjjBUecBW3hgzspCZIPd3B3oUnD/1XTqasBWYqCfNx1/ZdsZR2fjvwRrZylsgGIRW0qmcXhikesBGvDE/kakRTnA5GnrgYexXOZrqjYnbTDzBs33sB0CGhPB7U0Is7fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R8mp9zlcJSBBOZIgKzvbZxmMVKS1zaSvOR1lh/ptF+A=;
 b=KvVQRKXl/CZUPJrEkM2xcgjeG/br0+8LaQRb87mkjVKJo8UuO50gheGgcsz9yTAVW0OasMM5MiuCwKqMYtjKvzqhKdve87XNcttPU9/cgzu+9eO/dheZBJ7ctrAPVMO9S6obQg818iEZnaIyeUTPyDN0/jJTW+0+bczV6kHpZOc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
 by AM0PR05MB6418.eurprd05.prod.outlook.com (2603:10a6:208:13e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Wed, 6 Jan
 2021 13:10:23 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::f463:9a6:abe8:afec]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::f463:9a6:abe8:afec%5]) with mapi id 15.20.3742.006; Wed, 6 Jan 2021
 13:10:23 +0000
From:   Danielle Ratson <danieller@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, f.fainelli@gmail.com, kuba@kernel.org,
        andrew@lunn.ch, mlxsw@nvidia.com,
        Danielle Ratson <danieller@mellanox.com>
Subject: [PATCH ethtool 1/5] ethtool: Extend ethtool link modes settings uAPI with lanes
Date:   Wed,  6 Jan 2021 15:10:02 +0200
Message-Id: <20210106131006.2110613-2-danieller@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210106131006.2110613-1-danieller@mellanox.com>
References: <20210106131006.2110613-1-danieller@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [37.142.13.130]
X-ClientProxiedBy: VI1PR06CA0138.eurprd06.prod.outlook.com
 (2603:10a6:803:a0::31) To AM0PR05MB5010.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by VI1PR06CA0138.eurprd06.prod.outlook.com (2603:10a6:803:a0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Wed, 6 Jan 2021 13:10:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8b05839c-517a-4160-c854-08d8b2446d34
X-MS-TrafficTypeDiagnostic: AM0PR05MB6418:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB6418965A53CD42FF7BF0AAD6D5D00@AM0PR05MB6418.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:549;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mgBd1KrjPpMYsbfbJa363vT7jutDxKPOkpbEHY3+25LhfSDZ/p/WkqFnVUoXq+iQB0FQfmnZJZdKwCdDfoZfRMTY0jbOJsCICmchg+uAqpELfURTJY1JDSPtj6iIpzSraZrRn0Oez0Zq6jWSU0YsVVjPR3MA5Ck76w6gKRhRXAnxeLocTYWSZgpX7JM2swErJPVn0ggIUYmd8hSU2Hpl29Rjn4SXh/6HGLwdSbHKIIB4Z2d+ls/Cf5525Q48LxNXeq2FwrgvKCUE4IQINVqmNsfJLfarRPwdt8iY1t2iRHCAXYRXbjo6XZhNh5Az+6+Pu2zkbH37h6y1ybX5lfi5GFabCi9ZgZ0M1uY51cA2VLSCUVOOMhYVY2TZd05SHOHxSuYsi1QQ6V8lgv1B30W2ug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5010.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(39860400002)(136003)(366004)(26005)(8936002)(16526019)(186003)(107886003)(6486002)(6512007)(316002)(6916009)(5660300002)(6666004)(4326008)(2906002)(6506007)(956004)(2616005)(86362001)(1076003)(8676002)(66946007)(478600001)(66556008)(66476007)(36756003)(52116002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?kAQgVe0aMkyhh7DX+fdtSH6cPrFJN6OHyDIzFHSfQBYp4ga+04LJ5CMmAu6k?=
 =?us-ascii?Q?ZLD+H7aJYlkflKjtp6wrBAIBMqsmjeb+0FfVrf1LrU1LVnSjpSXbYdfRc0ed?=
 =?us-ascii?Q?/m6ksN3o2ntbxZ2mpgfesmZPvIRtrttyUo8hbto5nO3vBHoyxJmo+tHxPjY4?=
 =?us-ascii?Q?NVSSsnAe5KgXZE6yLERBp0o/TC+0rjQHnN/1TVKl/89xl1YEfbDe/fCSEJ62?=
 =?us-ascii?Q?KJJ74Il+/7pW9qpWaCy+Da6mawOJldwtJ4eCn3z/g7dDdNvUPaIdUPw9UrUs?=
 =?us-ascii?Q?t/nkJaexJSEPDjOo82HykccR+xV2nsNm2HwGFQ9f0SKSyX1cmC9QJUwSeJ+D?=
 =?us-ascii?Q?duKPNUWoVVB+DB2Wn0vaBR4atmfHR/J6GcgOeqKML7Y7xqP0wnY1iIhRhpgB?=
 =?us-ascii?Q?Ty27/+mkB9l4hgbpR58r9O9M0RHP5wJYzmu4oGMro+MLK+bpR0WfGu9vl7Sa?=
 =?us-ascii?Q?h/NKbk1fotsONjrxJ9HQRzNeyNd0V12oI3k65dq4dff61D4Zzo/HmjEIVFy2?=
 =?us-ascii?Q?HjF4YPeqM5PZBKlAkA3PA3JnRIf/Bemm4wkYOpauG19RIxtOePv0LhKGrMe2?=
 =?us-ascii?Q?JjAm+kqnFrP2oZ0Tk4oRp4EMXptQD91HRgHpcosLMMq8WOnv4Z5HtPCsPa/T?=
 =?us-ascii?Q?OlyRfhgd9Q4jZAud4OqsjgTxCXE79Z34LKWg8taHbXAdJ5cfKeq/9oBlkYG8?=
 =?us-ascii?Q?h5W4iopZLQb/bIr/eq2Or7kOLjBUG1IR0dJfihpqXxS87zIcNhnwgHOFD5a+?=
 =?us-ascii?Q?QLU+5ipttrhdBV+x7ock1XzkShiFOdeY7FvkxhKMZDt6p8MguFEN1TcYSDDS?=
 =?us-ascii?Q?RI5W9WVDe5rwHq18ET1dk7Wrl0Cn1AD22l2r5H+LbNxQXcB+/s4jKJgSAARu?=
 =?us-ascii?Q?9JC9uMCQNZaDeB3Av1X7C8QwFSIsHH0riDxSTmDbVi6Dxkw4SYBfqL1RDJ+S?=
 =?us-ascii?Q?r2dnDwj2FHrdy66U6cDlsqDUEyMAJezP1rfWP4icIiIT3/ZWmrxF4w8bvray?=
 =?us-ascii?Q?Ms97?=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB5010.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2021 13:10:23.2091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b05839c-517a-4160-c854-08d8b2446d34
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xeEROej8L/fR3eNDTI5o/HbPysrNA04HQbL2GWm6B0zI6Z/2EnnOioRRLfx5/6eKnADNixpwz3xYqf6uVLpYWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6418
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ETHTOOL_A_LINKMODES_LANES, expand ethtool_link_settings with
lanes attribute and define valid lanes in order to support a new
lanes-selector.

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 netlink/desc-ethtool.c       | 1 +
 uapi/linux/ethtool.h         | 8 ++++++++
 uapi/linux/ethtool_netlink.h | 1 +
 3 files changed, 10 insertions(+)

diff --git a/netlink/desc-ethtool.c b/netlink/desc-ethtool.c
index 96291b9..fe5d7ba 100644
--- a/netlink/desc-ethtool.c
+++ b/netlink/desc-ethtool.c
@@ -87,6 +87,7 @@ static const struct pretty_nla_desc __linkmodes_desc[] = {
 	NLATTR_DESC_U8(ETHTOOL_A_LINKMODES_DUPLEX),
 	NLATTR_DESC_U8(ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG),
 	NLATTR_DESC_U8(ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE),
+	NLATTR_DESC_U32(ETHTOOL_A_LINKMODES_LANES),
 };
 
 static const struct pretty_nla_desc __linkstate_desc[] = {
diff --git a/uapi/linux/ethtool.h b/uapi/linux/ethtool.h
index 052689b..85ec9c8 100644
--- a/uapi/linux/ethtool.h
+++ b/uapi/linux/ethtool.h
@@ -1736,6 +1736,14 @@ static __inline__ int ethtool_validate_speed(__u32 speed)
 	return speed <= INT_MAX || speed == (__u32)SPEED_UNKNOWN;
 }
 
+/* Lanes, 1, 2, 4 or 8. */
+#define ETHTOOL_LANES_1			1
+#define ETHTOOL_LANES_2			2
+#define ETHTOOL_LANES_4			4
+#define ETHTOOL_LANES_8			8
+
+#define ETHTOOL_LANES_UNKNOWN		0
+
 /* Duplex, half or full. */
 #define DUPLEX_HALF		0x00
 #define DUPLEX_FULL		0x01
diff --git a/uapi/linux/ethtool_netlink.h b/uapi/linux/ethtool_netlink.h
index c022883..0cd6906 100644
--- a/uapi/linux/ethtool_netlink.h
+++ b/uapi/linux/ethtool_netlink.h
@@ -227,6 +227,7 @@ enum {
 	ETHTOOL_A_LINKMODES_DUPLEX,		/* u8 */
 	ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG,	/* u8 */
 	ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE,	/* u8 */
+	ETHTOOL_A_LINKMODES_LANES,		/* u32 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_LINKMODES_CNT,
-- 
2.26.2

