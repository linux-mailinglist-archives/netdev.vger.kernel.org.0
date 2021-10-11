Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6DEF4298D6
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 23:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235272AbhJKV2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 17:28:36 -0400
Received: from mail-eopbgr40088.outbound.protection.outlook.com ([40.107.4.88]:16861
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235263AbhJKV2g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 17:28:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i80uWKXGsZYUTEp7hOWl811rHIT2OKs4E9yGfx73mFO05M+UkQizpK0QvE41V7a38MGI+Qeff5QCBL9lDlGKZ9oAj26TORQzzrUYFSlXOE7bOuBJ0q7SV/JHFihp4Pyvq4vx33MeUf3nwriinq5TikHR1JAr2Zit7VDv6aJ8dj61FQRtbUeVIDjXDDAQltlqBXbA3A5cXcPPMZss3NcOg5Xe87dUNF3A9X8ggidbYZkvRnoe+X0vG5Qwst4ey8wPG4Tk5W15KcdPH4qDtAfR6lRFbt4S+DaQZfAi943mZnKnUOceuuo5MMEjr73PTnLsAWFj//PyQcp/fJlkJU1lqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=85r03rmH6fif+jI4lifJpRAeE91kVsFq2IEcSnymQv0=;
 b=fPCOocHhepbcwDBwm2hPuQZ8vReK3mDN8FgkhUQwh1vQBPxD7VqNVYvFG1jT8Bnx5rIjTqWi9R0RkHqpDpTz6BhSSp9qfwDcpllJSvcPgMS/Fc4AI0sldic3TUz4+x5877Qp5AwKX3aJIvd3Jd9XFmDCGIB64bw0AlI+KMOaV1JNxJ0st5zuVaR9Pou9tMDROhGnUzG16QcXaAr39q6RvJAp2qq1KkkZZd7QIZC96IcY+nuziu1EpQyWexDddmv/iHnpxbydvhuoFnJucoBZFc26Xx8d/DKwTuDIEq9OLP6mTtvTkjx1oZmAzmJS5SdUfTaohvD7GRnDJIXpsCYAlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=85r03rmH6fif+jI4lifJpRAeE91kVsFq2IEcSnymQv0=;
 b=DLVjpnCndhJIgl0+eK/omZ8x1J/t10RvNrc1PQ6A23mvhVaT72p4k/vwYlZhk+Q52ejUdLH2HGsYmEl8eq9GcoR31zdHo2GwET1BnOUWTyb4BETQ0VkI2z7tYohFuVJvYxzxOfRjzFdD2HMu5OEhWkv8IgxqDLk3iXLxiTe/gPw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (20.177.49.83) by
 VE1PR04MB6703.eurprd04.prod.outlook.com (10.255.118.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.25; Mon, 11 Oct 2021 21:26:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4587.026; Mon, 11 Oct 2021
 21:26:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Po Liu <po.liu@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Rui Sousa <rui.sousa@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net 01/10] net: mscc: ocelot: make use of all 63 PTP timestamp identifiers
Date:   Tue, 12 Oct 2021 00:26:07 +0300
Message-Id: <20211011212616.2160588-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211011212616.2160588-1-vladimir.oltean@nxp.com>
References: <20211011212616.2160588-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0260.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by VI1PR07CA0260.eurprd07.prod.outlook.com (2603:10a6:803:b4::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.4 via Frontend Transport; Mon, 11 Oct 2021 21:26:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e02187da-227a-4d7f-69c6-08d98cfdcb80
X-MS-TrafficTypeDiagnostic: VE1PR04MB6703:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6703E7EC1726CD3DF134B022E0B59@VE1PR04MB6703.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TFTspE+1ILs9ag1OYR5YKPqjlVgq4lEo8CLUNFoTsip6qoUJVnYUg0egvQ16MSUw3AbmLKP1Lu5yIv58aHxUTPRabkrpPRdPWx3svH7wwXXi/ncRc+lZIYHPmHalCAXWBFkARn4F8gpXLnLzxD79+F/aM91RyxPl4/duvL+NGofm8jiVvpTylNVufGJ0+L8ISpwXGut70WYsGDzKQ4/s3R6AOvivVroPcgzx/M2PgcfXZHjNbHK8m1GmJEVh26PFUT7jmQPrkoR0sZhlCd8Ikc9sf0IdQeUAtgYnzOnQY4MTzQOOoxXMsAwrGWapv9UaGz6bvvOqDrFcPnOY1ZccWf/ZKifS4/+GGn8Fcz46KM/uw/VDlghjiAXiRMITXULRdV3lxzVCtr9v/1hy56PKqGh2IWf9Rw0CIdnrxsIV+MmwmLYMI/zExgJsfDBUSvFY24nq1WeZSSmCso+AG6UrSUJDZ6YwC2l4qk5Jvdu0DPgknK7oUkzFTZlxUD102OCsLc385nHA35wuDesR13niu6O/XLPat7W1ibDw3h40y3JX1C37gZK6ucVyVf3BlK07C7PvszOWS8nNqAbPBdfno82uf9rN5Sq+1Kf6d2VEhqZm7CBpAAO6BPy6DE5piFQJw/8XeCcSvtniHIP29TU9XMPyTdLgQXWkiAAO6VVUWn+hIy8OySFj8ulk8nH0JITFwpwiWMZ5+qF3DsPJJIvOGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(52116002)(36756003)(1076003)(2906002)(6636002)(86362001)(66476007)(66556008)(8936002)(7416002)(6506007)(6486002)(66946007)(6512007)(508600001)(6666004)(2616005)(8676002)(5660300002)(38100700002)(38350700002)(4326008)(316002)(956004)(26005)(54906003)(110136005)(44832011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?58gJLV9GFcz6Udhvk8Ty774yFC7neoLSMSGw5YokEuC0fNPzwQ+pti+SJYcr?=
 =?us-ascii?Q?3Xq6BHuOUCTILXcwvp0ouwfdxPdeNcIsKycJ8JxBg9buOdtTZPzv+NkFYIee?=
 =?us-ascii?Q?hMqaBgkXcQjftGVTzYRJNkKQ0MOE8gD8R4s9/I6+o/YqRuEiyILf0Xpfr6u1?=
 =?us-ascii?Q?OuLtxDTQ4SglIg9Vs6YKauKWhHs4ymCVy+2BLq5k7pvsjiSx9rMNsJsYAaJK?=
 =?us-ascii?Q?cCSMEdiD26enEGFeYA/chVyXvzzGygp8zSicDU92RkmOUJ2USqNjGcUZKIwB?=
 =?us-ascii?Q?de1qxoD2W/2+boY2ro/vGe61P7uH1TCf6yjgGZSSpsrCCZJ9g7+QynO8lgTF?=
 =?us-ascii?Q?9EsnP788tISxfodDVWcL7rdQqWNoFbWuAUp5gzZhrD+kfnuV4ks9rocRk+h4?=
 =?us-ascii?Q?lFo1/S6rT5gU6vq74I16aiGMg94dGGLk42dyszVMy+hp//yb+AtdNn/iCR8b?=
 =?us-ascii?Q?za/1AfR5MD9TVbJU1hpThrmRcXw9iB90bvLxhuGeri7y5Gh6oPjUsOn53xzf?=
 =?us-ascii?Q?zjfsNC3tj9XDXveDVbLtYUhTLVn+o50lejjt+kRZCFouh+llDCKOBtV/ueiy?=
 =?us-ascii?Q?op4wxeT9hI8g9a6qrnfVedPIOmL/ivn9nsKMauf1dg/u4SfUttdwqhFVx9Qj?=
 =?us-ascii?Q?IKofz5Ue6Ss1ZeqiDpCZLH1mYLfDN/a0mdGFFFWVSJDTye9vGZnJRgMgUBcp?=
 =?us-ascii?Q?5mWDouvZ3aNk3U0miS76EK4aE8/LQqwKR1XAxjOe478xN43Z6DKnAzqtbbfs?=
 =?us-ascii?Q?pbVamFVQzL33uUcA7ixfC51G16BFnQDjbIRy4/HW+fFURs5fBafjxLbtl6YB?=
 =?us-ascii?Q?qP2I3mhT03LezufbTsNHJw9t9m7M/Sa6BAOpAToogNOt1947SVwIK5C+029I?=
 =?us-ascii?Q?B+077hzcNVHBY3IykpiA+4CJBJFgV0ORWhMYzegV9FIZj4n6LrDprE1RFSoH?=
 =?us-ascii?Q?YYVvyZLIS1L5YhrVZGnDUR9insbwZEYLARHD5lsYgBm56r1RNEJuZxvGZDsu?=
 =?us-ascii?Q?Pm5iJJLDNhgs1ky0PoQh7iq/XQLMPEr3ogrXye8p78jHq1Phq45cUt4l2Hn5?=
 =?us-ascii?Q?Pq3tOM2/E1lVrKBDdJ5tz9Mc1qAlGjPQH30Noxotr+KDSnLKkUcdVdAmU2N6?=
 =?us-ascii?Q?lbzM+dRMnjQH9nSXUHD4gZVevuEnwBCOdxQIGEFi1NMhgjeD6FtGWCV4Z3L4?=
 =?us-ascii?Q?u+PskOfQVQg14vXu+DyFU0KzRgE6fd1mf23Uw+QEhQF7mdMhBWy1nIReZzdT?=
 =?us-ascii?Q?9xJPEyByVBdj6rELQhozoq9DHT1qHMzdWTGjn4DEI7LaxNKVY+0PthPb45ry?=
 =?us-ascii?Q?Q/6VZjWgZqcKKdb9BllrzSty?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e02187da-227a-4d7f-69c6-08d98cfdcb80
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2021 21:26:32.0579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dkCVjm3blo1DDHh3DDWrB6XbpPnLah/PJTVckfKUsV869nHHL76UplboYVmYu0AtwmHriiTrGd9FOFtv9d1V3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6703
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At present, there is a problem when user space bombards a port with PTP
event frames which have TX timestamping requests (or when a tc-taprio
offload is installed on a port, which delays the TX timestamps by a
significant amount of time). The driver will happily roll over the 2-bit
timestamp ID and this will cause incorrect matches between an skb and
the TX timestamp collected from the FIFO.

The Ocelot switches have a 6-bit PTP timestamp identifier, and the value
63 is reserved, so that leaves identifiers 0-62 to be used.

The timestamp identifiers are selected by the REW_OP packet field, and
are actually shared between CPU-injected frames and frames which match a
VCAP IS2 rule that modifies the REW_OP. The hardware supports
partitioning between the two uses of the REW_OP field through the
PTP_ID_LOW and PTP_ID_HIGH registers, and by default reserves the PTP
IDs 0-3 for CPU-injected traffic and the rest for VCAP IS2.

The driver does not use VCAP IS2 to set REW_OP for 2-step timestamping,
and it also writes 0xffffffff to both PTP_ID_HIGH and PTP_ID_LOW in
ocelot_init_timestamp().

Therefore, we can make use of all 63 timestamp identifiers, which should
allow more timestampable packets to be in flight on each port. This is
only part of the solution, more issues will be addressed in future changes.

Fixes: 4e3b0468e6d7 ("net: mscc: PTP Hardware Clock (PHC) support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 4 +++-
 include/soc/mscc/ocelot_ptp.h      | 2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 559177e6ded4..a65e80827a09 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -579,7 +579,9 @@ static void ocelot_port_add_txtstamp_skb(struct ocelot *ocelot, int port,
 	skb_shinfo(clone)->tx_flags |= SKBTX_IN_PROGRESS;
 	/* Store timestamp ID in OCELOT_SKB_CB(clone)->ts_id */
 	OCELOT_SKB_CB(clone)->ts_id = ocelot_port->ts_id;
-	ocelot_port->ts_id = (ocelot_port->ts_id + 1) % 4;
+	ocelot_port->ts_id++;
+	if (ocelot_port->ts_id == OCELOT_MAX_PTP_ID)
+		ocelot_port->ts_id = 0;
 	skb_queue_tail(&ocelot_port->tx_skbs, clone);
 
 	spin_unlock(&ocelot_port->ts_id_lock);
diff --git a/include/soc/mscc/ocelot_ptp.h b/include/soc/mscc/ocelot_ptp.h
index ded497d72bdb..6e54442b49ad 100644
--- a/include/soc/mscc/ocelot_ptp.h
+++ b/include/soc/mscc/ocelot_ptp.h
@@ -13,6 +13,8 @@
 #include <linux/ptp_clock_kernel.h>
 #include <soc/mscc/ocelot.h>
 
+#define OCELOT_MAX_PTP_ID		63
+
 #define PTP_PIN_CFG_RSZ			0x20
 #define PTP_PIN_TOD_SEC_MSB_RSZ		PTP_PIN_CFG_RSZ
 #define PTP_PIN_TOD_SEC_LSB_RSZ		PTP_PIN_CFG_RSZ
-- 
2.25.1

