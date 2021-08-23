Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03D1C3F52D0
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 23:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232814AbhHWVYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 17:24:02 -0400
Received: from mail-eopbgr80085.outbound.protection.outlook.com ([40.107.8.85]:59364
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232503AbhHWVX7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 17:23:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a59RRfBQC9Mge9h0wm8SEeOEfUxO6Hed0lqz+ZrKLpxnfkQ/Fhq6eFAOwq4BFPqovvUbY1/vl2MNuhLIRfcJdYdi6y+MReyRmntY33SrKsgRBWBKTPcQ65OJsf57XKtWcg6r9OyDswbLmCthtLyFkPWgrPnX9VTr0iboHl/HKkMsfvan3X0phf4nCeqV0R5+S6PeshG+PZIEHeRm8ivHF2h5lvmfPLIC/NZpB2qF1wUS0aXBceCDq9mSliqAGSQ1Ne62mnAfdflGC3xO6BApiFZAdteqj2lK4+/mZLG6YOqm4H36xLEiwhKWCZ8jXbchAwMpg6hm0+gp+dC/UWeC9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lS08ksLDTATGQViWBzuBerZpUIvmHgME3NCskVLaIdg=;
 b=cUiGXkKYRFI+TXlggAH6cVV1lyFYImu97CFCXqb/73GypSxEJuRPH7/pDXctk0BpYBeXQy1PV1BipiadAHdboEuD8fhukjxoqWibFDP/nKnJ1fYt+zenA8G3mbK1YSJ8OZ0L0gKYEoUcNpdkbqItFMLeoP5nCRQ2PlDCzVT9E4PHfQBJpOeWtXhWD/KZgYujA+RNRfMjsF/gLeKJ32vEYbvIDUF9n1I/HtVEcrECgGYK72A+wUr40deLvpNA5uf/7otlOjKmnBQGLtl8O+FcHfMb40Ujcm0vfNqJxpqzNYN6tjAwC43CX14TlQav1FN5nf2f22Q8/NFw4MiL3ZSykg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lS08ksLDTATGQViWBzuBerZpUIvmHgME3NCskVLaIdg=;
 b=PIwMy57HkiS8wDwKh3c+Z8WGeSVjtd3mZkb1wJ1jOUK4C+SvIUf5yxvj3BQLx/ANxmI3gIFjvgis+rNbPvQdEqdRK1pwMwF1MnNSVmxQL5UmLOzeZ7N96lZpHwjkkkdzMdsUEI8zvp4Y22Yl7eiUASzybuL9P6oH6zt3InZ041c=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4221.eurprd04.prod.outlook.com (2603:10a6:803:3e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Mon, 23 Aug
 2021 21:23:14 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.025; Mon, 23 Aug 2021
 21:23:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH v2 net-next 1/4] net: dsa: don't call switchdev_bridge_port_unoffload for unoffloaded bridge ports
Date:   Tue, 24 Aug 2021 00:22:55 +0300
Message-Id: <20210823212258.3190699-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210823212258.3190699-1-vladimir.oltean@nxp.com>
References: <20210823212258.3190699-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0150.eurprd05.prod.outlook.com
 (2603:10a6:207:3::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM3PR05CA0150.eurprd05.prod.outlook.com (2603:10a6:207:3::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Mon, 23 Aug 2021 21:23:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c5fe2bcd-f8ef-4d46-aa32-08d9667c3748
X-MS-TrafficTypeDiagnostic: VI1PR04MB4221:
X-Microsoft-Antispam-PRVS: <VI1PR04MB4221ABA8EB3DE532BFFD5D2DE0C49@VI1PR04MB4221.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NCgjZTxE35h/f/qmGDLym4gigTnx4giE9nbOeKAr6Q33Ktas9rsrpogQ6Pczix5n7hPiJOlDuIKOsKMrM6r+Rh+ikVaey1wVZpO95FVvYcYUxnmUoKQPQuy55EmccU+jGe6phtOMJS+WynGcbN+VRNpe5/gnieuQ2KmyZRTZwUXw0OgwQgVJCx6alMREWJOvr2QXGnTozM2CkcXHtuSER9855pVwF5lUon5iRHTsglxQNUMCmBo6EzjC+lQ+F8WLPK3TsMwciATI9nV09HN5innhTBZ2UsVWHki+CmPVLvnIwRDOplFAcgrRfgTEHqfGiw9W+/CW+o58d3wVquKYXJvClV/UNB6Xa4dlMldQHcF1MqOPjot3Frpro7RaAZEACZJ5MORf3P/tSgEd9x534A0DP9We7K6FcpEIKSdKG0WsaUvpT6dOCoPcnCFxsBTGctEzuWEgmlaIeBm9QP56JnUQteVsScwvUOJ/xWkfYdzB+cMw2V4csAvzPToKpHxCIHuS0vH9+u4lCYeQr5p70YiA0dbVbK9pA/s3bMEVrLh8f3VyWPNa9a2WGBU6tbwOjWPgoypNyhGu1NPgwlLMZ0Uagw93w5fAo98LNl0S8YOa8j99tUGQo+J0k/0reYBzS0j0PrQraoyBL2cdUWDpHDwLFIefiudbHiMQcdx28Iw7cm9jrI7eWOjwUg5vL+D9SuB4yvkhUxIdT8V4ooG9Zg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39850400004)(366004)(396003)(83380400001)(66476007)(66556008)(6506007)(26005)(4326008)(8676002)(66946007)(8936002)(6512007)(186003)(6486002)(86362001)(6666004)(38350700002)(6916009)(38100700002)(52116002)(5660300002)(316002)(44832011)(36756003)(54906003)(1076003)(2616005)(2906002)(478600001)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SHrja/h1kzhrFiERkXUQlu+OOcDGzu+GOlQCY458GzM6fFMD6K3LxdUWSToc?=
 =?us-ascii?Q?MuZ/lrLM7Hf69uy/Tj6IIrO2ObBLHB8ofVJsH04Ib8tFZ+j2TajKDy9HOP4T?=
 =?us-ascii?Q?+6RFAzQSQLzf7G+ON19hecGJJfzxWSzsEHxbiWwuTrqkYFZilckwqY5QbOLk?=
 =?us-ascii?Q?9MPbN4Uuifj8SR1b0hqYEcwl/bBuhgCkEd1nlPJh+ab+gIPjPb8neCQsBozt?=
 =?us-ascii?Q?989vd3aO1TxxcOpUAkg6NhGnzBLp3tF+CflVio5r7mDavb5H0Bupo+VFfv2Z?=
 =?us-ascii?Q?rcwBVin83N5Ibd1oBAIavuuYwsw6sr6uBuN6utviFkJujm/ImsntK27PwmQn?=
 =?us-ascii?Q?HfPZ3UxXG7MiakQk8OoOJZdsbvUDskjaCmhgPtIPGeJtbg4fLCR541kuKuvL?=
 =?us-ascii?Q?ZServI699y+8Uelfv/ukDEYUWsYsle+euE2Bg9I1/wZhRS8IY1OCaraTCeZF?=
 =?us-ascii?Q?oGAJBtpkkB4oBADbsYcsbQ4FWfL9VcZ2lhVzC2r/X8M8NDbHQjtYR3haqZv3?=
 =?us-ascii?Q?SKN+giH+fn5Ayy92rdTJXXIWNmp/OgFGxieq3PzIyMSB64CyxVVreDkmyTsN?=
 =?us-ascii?Q?LETqW0uwoQnSLBjmm2EeijJvNw9PERunHAM4yFGmJkMJxaFwX7R0aaae6KD2?=
 =?us-ascii?Q?vUZ1WDGvacPqvYEnI7VmoL4uTubREiSEpMdRLoEDtUq6I8f+ISw0w0szfPFS?=
 =?us-ascii?Q?q1d8z8TuUVBziNfL9SIPTxv7wJKcRltJRdkAarN2lzMWKy0Fneo0yz5bly9I?=
 =?us-ascii?Q?2v7WA13WzxP9tdsEAHsZTdvInW/CKwbW2MpffIYDiyCaQT4ZlvO1nzi8bxLl?=
 =?us-ascii?Q?UNua4NdTancLYPX+bo2rE05MyaQbO2Rm2Cmn+DHJsAw8FW8RCitwKXPQLjrY?=
 =?us-ascii?Q?Tc0HQtPKKnmHA+FN7plMCu+Ow8GjuABWoOhY3wdW8MkXQxVVOh/Xqclm6xaf?=
 =?us-ascii?Q?7v8a1D0teP40EdRX3s99SZj7Zno6QOmy2Rpi6seNjnmKP0Mr9loBhr4y8CwU?=
 =?us-ascii?Q?qUGlzb4Aby5xHmcPL1l3/lnIWv+GUztBkV2//peMRsTDpC/0R3fVQBVUAXUi?=
 =?us-ascii?Q?5JGr6iWjJf1+YlA2FnIiE25fCwDr2ndRdla8C74SErtf/tYLtz6hsbbkUS2W?=
 =?us-ascii?Q?JJGSk1ewBitVvRf5o0Lui+uKWxXN2atdwUE/LxzAAnKRsfJBMtYh2bT8fwyu?=
 =?us-ascii?Q?UWbeySQ75r67PdYxi9WS0nCAU9kWKOepIYaSaCfbcvZczjkxakGOJFZbIXOA?=
 =?us-ascii?Q?ZwFiDeEI0crBajdV3AXIUUvxOzmUl54DC0bov7nMRGUQlWP7YoLF4YVtDf9B?=
 =?us-ascii?Q?dHDHCr0FAn5i+g7/Wa6HXGbR?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5fe2bcd-f8ef-4d46-aa32-08d9667c3748
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2021 21:23:14.1141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NkQAgSG9WqfcuqU/xtl+EomIQR/pnTRTA69nk1iyvf2SYmlatDtbI4U9yaR6pVYF8ZMQolVxyBJJ8dy56rHVsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4221
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For ports that have a NULL dp->bridge_dev, dsa_port_to_bridge_port()
also returns NULL as expected.

Issue #1 is that we are performing a NULL pointer dereference on brport_dev.

Issue #2 is that these are ports on which switchdev_bridge_port_offload
has not been called, so we should not call switchdev_bridge_port_unoffload
on them either.

Both issues are addressed by checking against a NULL brport_dev in
dsa_port_pre_bridge_leave and exiting early.

Fixes: 2f5dc00f7a3e ("net: bridge: switchdev: let drivers inform which bridge ports are offloaded")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: Patch is new

 net/dsa/port.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 4fbe81ffb1ce..3b775d7adee2 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -373,6 +373,10 @@ void dsa_port_pre_bridge_leave(struct dsa_port *dp, struct net_device *br)
 {
 	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
 
+	/* Don't try to unoffload something that is not offloaded */
+	if (!brport_dev)
+		return;
+
 	switchdev_bridge_port_unoffload(brport_dev, dp,
 					&dsa_slave_switchdev_notifier,
 					&dsa_slave_switchdev_blocking_notifier);
-- 
2.25.1

