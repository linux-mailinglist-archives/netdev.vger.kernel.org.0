Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D036342584E
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 18:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242846AbhJGQtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 12:49:25 -0400
Received: from mail-eopbgr60061.outbound.protection.outlook.com ([40.107.6.61]:18693
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242838AbhJGQtX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 12:49:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AwN7Pdi2RRjcUy0RhjyxD7T1H0km9v+XMD/vR7U75VObSHLWBzdKVICt6o+v8hel2pX0LQktAbB/vb3gQxEh2Raf4s/MeXUKDTvs3zaaQy73E8qCTwYU9RclW8pET2g5s12xlNAOurRHfCyy5z6HhwlekbiAwN5PLrBvperxYpiWmmi6Dg1gI0uR8KNeSwUKepS5KMA8ApJl43Ee9QVMT/Dk8tgo5SmDN0d4/Y3s2QZDeOLTKG/hpWy6zu64ZvQHa0I1kTZH/80Tu2ip3tXp3eEZEM/eihR8VusKTKSZ8rCNMNThcuBWADA9G8lrfoq591jD68CnjnOUUe5amBUGkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pU1k5k3wxik+Y76Ucopg61R9ONXbMf+PQAVldhvUEK0=;
 b=LJjE9JujTH7Bk8Lc99FfkCtl+y1rkFRvH46JrGwduTapspIOTldHkMULJto+SdLMy9st/1n/8eu58j0ZEK4e9ghk+YJQ7t2cod6qoqtXyniloRpstQygBOEVluu4/uYC571DPFvBSECT/TPl2rWPKmP8C5NxRvCVK//E+3sp4PpCW2keM6cvAAK/zq4xJ0U4VDptg71HSEsyZIP8wndCyRh4thdlRJr4t3HE0UcVS9XWUkngkykcLrh2Z0nHRjpoOd9dflO/GuqHeRNSV1zp5DVOdzccp8OGCdr4AX59gYkcxlxoe8LzcpKqXlTCWi+N5MA3qsR7JjN47Nl5JFeXgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pU1k5k3wxik+Y76Ucopg61R9ONXbMf+PQAVldhvUEK0=;
 b=NGK6Wj14GdObKXqg8Cs1N38qwXGfD8QwNocN69gASpjjkrxyhfmz0FFfczqzk7BSIiR+YIsydf2PztVuAlzTTwUV7dnDeesj9dI0ubgGcoyc9gNjjvhl10rjM9mQg1q4HNfxz4K8WJAbWRTiN5Cw7KTkkkjgSt6Y2PWgkyKjb1c=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3549.eurprd04.prod.outlook.com (2603:10a6:803:8::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22; Thu, 7 Oct
 2021 16:47:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4566.023; Thu, 7 Oct 2021
 16:47:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH v3 net 2/4] net: dsa: tag_dsa: send packets with TX fwd offload from VLAN-unaware bridges using VID 0
Date:   Thu,  7 Oct 2021 19:47:09 +0300
Message-Id: <20211007164711.2897238-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211007164711.2897238-1-vladimir.oltean@nxp.com>
References: <20211007164711.2897238-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0105.eurprd08.prod.outlook.com
 (2603:10a6:800:d3::31) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by VI1PR08CA0105.eurprd08.prod.outlook.com (2603:10a6:800:d3::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Thu, 7 Oct 2021 16:47:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f7c8353-22ce-47b6-757d-08d989b22511
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3549:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3549F1259B80E0373A990403E0B19@VI1PR0402MB3549.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cw8OsJ2sX/CW/LL07O/knQUSregTxxXvBNIeoIDOIqciiQFXUVXLoqV7uY/8tUCaX1Lo3M8KjWQGjvquGKUB7GRPq6UCVz/lEEMhGn3HWctDhgYljaJZdf9tnH0Mda8C/36N7IVHOPxLaZmWw0fh9jJPEF3wiZdAbUzINwHZl1bSABmE1Sn3K+B66hd9tSc3Zg9J/pgzkLNC9P2GXh0j+4TKhHSI0AikMBpaaYVTO4UF2Xf7ztNeS9PfxephCVT1faGxj3Izkl4mF8YJgMm1bCgfLKpHbzCAFY8HCQvjKeE+bFjfPMWB7ceuDgCMeGDaUQFEj/V45xw+jZeDJFSpkbXR28yPfX+rh+xE26YJ6WotmPzHTrkqdn814w9dBA8dlaFCPuXCkbR2OTUYWkp89d06lnUXarjg2tIDWKsVjM+OhdiGBMzOOv0ZDwpUFE/05aMtHcTZLReSqUo0I0DQ1DvLY6isP5TtFbbsbwOW4mo7axvCc2FIKBIYZuZrkM1JKBYDuJecSA0FUSBPM07qT7bSh/apr4nHqsA0KffvmLgkDRFLEhRA5DTpz1LQWjP+OKQ+A0MXC9Cn/rYTXbDHJumZIcpSuKPSqLn5Vigr3+R+I3y2SDyUEt5YerqiOK6Wm0/lw5Uy53I9Cf3AMR5bXWufscqK1605qkxAKbcYUvm5soVG7pMpuVesIwrtzYyL54wB3K4jiDUaTZ9wsWo/4B89+tSrvTewTqaFt4IygYow8LfNL18h9BdXicXXjATCBRfr2V4H1O8zbWeYW4z3vmnt0qeSipKNjGrH3x4B98Pzha66Ycy1uHvj+sx7dU3k9JEK2+q2PbYSIB8XMzTyAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(36756003)(83380400001)(966005)(38350700002)(5660300002)(316002)(2906002)(110136005)(66946007)(1076003)(54906003)(6512007)(66556008)(66476007)(38100700002)(2616005)(6486002)(956004)(8676002)(52116002)(4326008)(6506007)(508600001)(26005)(44832011)(186003)(8936002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b6Yr/xgq/6+RGGNIGNWlHm/9NI4PfzDN2MSDZqINwrDlrgRMXKNUSf1pK9HG?=
 =?us-ascii?Q?BCJuN0slwSgpFuRzC+skSMGuk+yEJJf3DL8w+0yHum+bSUBpCO11Z0VGm46j?=
 =?us-ascii?Q?NLx47UbB9olHOklVSRrMIDQE+xR61cscNDg3CnDWokhUAEwzGsPnwNwXR3Ny?=
 =?us-ascii?Q?S1rxbCTWrZBoJODvgHuZZWu+A7AeeKXLRY/eT7R1ITQLueDC3Y5v7BRGm0kW?=
 =?us-ascii?Q?LSI1gcYmBi37cUj77spN3VZG2T7tktGodbxktkcwiDMAUAeFWvWTty69k7BR?=
 =?us-ascii?Q?sjkbeqspwa3bBngoM2r1wrkWdkGxLJnkCj4pPssKK/PQguT7fRm2VncRgVE7?=
 =?us-ascii?Q?0Xz1wLsV8BHyZpIOmaRnwGvWdBL86OwPxnDP+I+DXGh9vcgaf6DYEDZvKjYc?=
 =?us-ascii?Q?jJRwyUlywEQqcxOFZ9cVwGv4aICEsToVz7YY82Hhap1aPI2rG0MAD6e9A8tK?=
 =?us-ascii?Q?8whuPms3DTtSyTTcjxFaoF4BMm99bb5CxmhXJYkfZ3zrsqDxSP7fWpWx/HeU?=
 =?us-ascii?Q?7AHtlbeLK1oBUtVfioMWnT9cwB4Sypk+3FXz0JHfdJGEmtI7jdF/Qh+cT/x9?=
 =?us-ascii?Q?PMl7rEwZ2IVCae4EJNnQ7PQdJA3FL5NRUe3NSXSeMCT6USytOXWY+AyuOx9b?=
 =?us-ascii?Q?GXi5Xp+vzM1xMVrPBEoDp45RXB/hiDLw0qY54j1j9M0Cx8XYj9M9jWM4L2G/?=
 =?us-ascii?Q?SK8WFfUOhILNRin6sxC4SR6+xFtUpTv6cacuwHVX8KOpm7fVUQf8irshSH1h?=
 =?us-ascii?Q?/mcUm9whIV+xoHKKsaLWit1f3+wrewu04VkJgpLdrSYrdX2VNy9rMNJdHlxy?=
 =?us-ascii?Q?/tKYAoUkhRxk2mvfy1x3rlgAkqeEatsiHb783FslDqnWT1IAyFTD3tKgYQu6?=
 =?us-ascii?Q?ics7TspW2crrftiDyukies5v+t09OJfcE1S4keHjJLHULbg+YNaNRGYqmY3x?=
 =?us-ascii?Q?Tk3yZ0sJdWjKMO4CfmJIqTt5VDl0IuOQgRGGUe/ENkPaUtYr1QH0tUz1RjeA?=
 =?us-ascii?Q?Fmacjk3P5mGTn+vLy/ZWi57x77S4m4uU9ueddQfizLlIKrOYMxJ0+dFajJT5?=
 =?us-ascii?Q?o3h+YejDAyyhmu7K13ApLA1r8Aw8CWki56gIG1mSOlI1qSh+AwYxxArm0rDL?=
 =?us-ascii?Q?qgh/jCrDnsisRr5ADn1SXssYVXYmI8uIdAkj9syOFVOoS/Ynwsw/qNcqDaS3?=
 =?us-ascii?Q?rmEOYiyrcQVlG8Hg5vh2mitpiK+R2VJInZD2SyqlVLDyRI17qqgmO2WkO2jP?=
 =?us-ascii?Q?/Zu1AhNmGjGdXhi3jO74FHFbPGy9yBKg9PWOuXjvjr3JHqH2b0OgTv/6IihU?=
 =?us-ascii?Q?xjn/vlXoYEZzsTBkwLmOWE+K?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f7c8353-22ce-47b6-757d-08d989b22511
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2021 16:47:27.0560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XKouuurVL4FnymNtA7oAqdtIVogMSdC6jrLPf5nP/s4ovyjkR6WzTOaDoATfDA2OCzcv6Nvmn2oTERAhaeYm7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3549
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The present code is structured this way due to an incomplete thought
process. In Documentation/networking/switchdev.rst we document that if a
bridge is VLAN-unaware, then the presence or lack of a pvid on a bridge
port (or on the bridge itself, for that matter) should not affect the
ability to receive and transmit tagged or untagged packets.

If the bridge on behalf of which we are sending this packet is
VLAN-aware, then the TX forwarding offload API ensures that the skb will
be VLAN-tagged (if the packet was sent by user space as untagged, it
will get transmitted town to the driver as tagged with the bridge
device's pvid). But if the bridge is VLAN-unaware, it may or may not be
VLAN-tagged. In fact the logic to insert the bridge's PVID came from the
idea that we should emulate what is being done in the VLAN-aware case.
But we shouldn't.

It appears that injecting packets using a VLAN ID of 0 serves the
purpose of forwarding the packets to the egress port with no VLAN tag
added or stripped by the hardware, and no filtering being performed.
So we can simply remove the superfluous logic.

One reason why this logic is broken is that when CONFIG_BRIDGE_VLAN_FILTERING=n,
we call br_vlan_get_pvid_rcu() but that returns an error and we do error
out, dropping all packets on xmit. Not really smart. This is also an
issue when the user deletes the bridge pvid:

$ bridge vlan del dev br0 vid 1 self

As mentioned, in both cases, packets should still flow freely, and they
do just that on any net device where the bridge is not offloaded, but on
mv88e6xxx they don't.

Fixes: d82f8ab0d874 ("net: dsa: tag_dsa: offload the bridge forwarding process")
Reported-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patchwork.kernel.org/project/netdevbpf/patch/20211003155141.2241314-1-andrew@lunn.ch/
Link: https://patchwork.kernel.org/project/netdevbpf/patch/20210928233708.1246774-1-vladimir.oltean@nxp.com/
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v3: fix up commit message

 net/dsa/tag_dsa.c | 20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index e5127b7d1c6a..68d5ddc3ef35 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -129,12 +129,9 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 	u8 tag_dev, tag_port;
 	enum dsa_cmd cmd;
 	u8 *dsa_header;
-	u16 pvid = 0;
-	int err;
 
 	if (skb->offload_fwd_mark) {
 		struct dsa_switch_tree *dst = dp->ds->dst;
-		struct net_device *br = dp->bridge_dev;
 
 		cmd = DSA_CMD_FORWARD;
 
@@ -144,19 +141,6 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 		 */
 		tag_dev = dst->last_switch + 1 + dp->bridge_num;
 		tag_port = 0;
-
-		/* If we are offloading forwarding for a VLAN-unaware bridge,
-		 * inject packets to hardware using the bridge's pvid, since
-		 * that's where the packets ingressed from.
-		 */
-		if (!br_vlan_enabled(br)) {
-			/* Safe because __dev_queue_xmit() runs under
-			 * rcu_read_lock_bh()
-			 */
-			err = br_vlan_get_pvid_rcu(br, &pvid);
-			if (err)
-				return NULL;
-		}
 	} else {
 		cmd = DSA_CMD_FROM_CPU;
 		tag_dev = dp->ds->index;
@@ -188,8 +172,8 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 
 		dsa_header[0] = (cmd << 6) | tag_dev;
 		dsa_header[1] = tag_port << 3;
-		dsa_header[2] = pvid >> 8;
-		dsa_header[3] = pvid & 0xff;
+		dsa_header[2] = 0;
+		dsa_header[3] = 0;
 	}
 
 	return skb;
-- 
2.25.1

