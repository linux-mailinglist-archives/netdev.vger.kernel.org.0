Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6530C488DE9
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 02:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbiAJBGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 20:06:44 -0500
Received: from mail-mw2nam12on2111.outbound.protection.outlook.com ([40.107.244.111]:13017
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229912AbiAJBGf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 Jan 2022 20:06:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l89Gk8dADY16jZUccRm4Q7ZM+XCAsP7GaWkfM+F1gjLpaV1AinT05WLeblvAF+B+xrlKL6VzDCJhq3OkLra/U3dplav05mhCvHpLYm9hEcPoy1FP9MlOj95+rP4XC+5TYJvY6Y/sGcQ8poqlxp6QG1WAzTGJ94VWf7i9JIR5WaOkRp2DO7NRfF54I3AfWPTknHqPnrcN18bwoGoEG62eyhZOdFPPjO0MwrdNxUrs7iSNi9N47OTxM0WaATBGedgDz38/nxcIYZ5eUVzaa403cIQapnxwkkqKGTpAGTD9O3ep2UUaoy3iYT4GHcj0QY2bCADaBCczexbCamJZJiMpGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RnHjyCKmUH/u7QqENc4Go7GbTjg8ZWLtyTVsew3LLSs=;
 b=CWCFNhqonvFo9XIco45CiOzrvSgCiOEcZ9IR2a0MzDEz/xmxkveCPaGbwBA9pthFmX5GRUVA5mSA2eKVws3NcJkokg5Szt5BTEUYvqIhup2fHPbeLzFN1NXWREsqbB3S4Uoxxku2pDNtD4YN5y0Pl8aghnk9rbckwPXUS0b6ER8DJb5gNYhx+PYCspvR5vF7kbnrlN1qD0ywpQwVDRNn+ahF7sJQziGOvneNm75DWS/GI9GjK6q5OAvtvy1xK7WDXURMLbH5fUDt5gdFlGKWhg/1lNYTfyVhnRxzujzAhJi09rzSOrG9/MdHUej3MbJ1Rrl+JzjidxV+Ia2aPhkEaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RnHjyCKmUH/u7QqENc4Go7GbTjg8ZWLtyTVsew3LLSs=;
 b=VoZIJWVx7FQSHiyAqpWm0Ty86JwO7PCDsay4/mA9jXsKGM9yryoR6y6DCfR6wDRz+tspb+lQe50FkjfOKHXbl+gYoT/E85eMnejGtTOyhBcwLiT7JNrTEYJhMeOxnokGcNbf48G10d0R8+tAAQsLZzGRKknMoUgPolTukAGkkNg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MW4PR10MB5810.namprd10.prod.outlook.com
 (2603:10b6:303:186::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.16; Mon, 10 Jan
 2022 01:06:32 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4867.011; Mon, 10 Jan 2022
 01:06:32 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v1 net-next 1/2] net: mscc: ocelot: add ability to perform bulk reads
Date:   Sun,  9 Jan 2022 17:06:17 -0800
Message-Id: <20220110010618.428927-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220110010618.428927-1-colin.foster@in-advantage.com>
References: <20220110010618.428927-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4P223CA0027.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::32) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0ba4832-f2fe-4a9c-f7cc-08d9d3d5706b
X-MS-TrafficTypeDiagnostic: MW4PR10MB5810:EE_
X-Microsoft-Antispam-PRVS: <MW4PR10MB58100A7B51CBE0FA227DA8C3A4509@MW4PR10MB5810.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: adO4u4PcR2FXEbG/QRfqAsG6PVDITkyQkDyyjBzEyQWtsJzl/tX5pInegdUEEYVx3KmFlPeLE+DGOYRSquq4/176NcYRcxbw4GwtDLS+5Jt84K/R5S20+bp1OR+1Yuo5ngi1VdqtiIziaTIgi90i7v6tAXugxMDhJ0RkpQmqE83V4DF/536d0rr5fVvYVqEU/qNaR+pAsyatHVgv3SWWyghgXt7bXX1DKJ4d8k0ZoxJaq8B2k54gv5aYp24b9KlxGCDcmc6HmJ/z3/1cI21izE8IS2TPODJg38qpSTCFC9O44qhz9EXklisofFK3z2jv0bpqsFPFK/9z1rPkh1yGkUtbhIJrmq5ihsToyazPzVqAIhc3XQrzoSQJI477JQNUYJgbxt4cF0j0CNXeUNF51VcvlmoyTSrRKz4VwhLvsaSxFRGoRz/nwe8zVY9A/fuO/pYjaxTtYztpPxadXpWAUQflHwHMVefsm+6xx6PY3S1ruPiQmgDvn/sUZLdgRqKQC8yeb7O+c8NcmUadROb4nFIjrB8hvQ3QVcgCfEgErju9QqaGjzMHSePPbVhAzVSujEDKv5wso4zfoRKOshRq0GWZegYo5NT9zTCS7ZxVd78sSLjZTytemESBTAjD0WU2CPxRfSh1nFMbEVrPTL0cXjtB15H/6GHXiJvgcpfLPBUg3xOkpXX6nWcdm26v0/vjbWNOfTz+MY0D1gDGV5BoVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(136003)(396003)(39830400003)(42606007)(376002)(83380400001)(52116002)(54906003)(8936002)(6506007)(5660300002)(316002)(2616005)(6486002)(66476007)(6666004)(44832011)(2906002)(508600001)(26005)(4326008)(66556008)(66946007)(1076003)(186003)(38350700002)(86362001)(6512007)(38100700002)(8676002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uMqnhqUOz9GQ/GLEWLv5qk8FUbwFX4AJBiEp1fLw062LX7LifORqPUU29NHk?=
 =?us-ascii?Q?8GE0eh9Y9pd5Q3e5tR3mYDiKUb5JzPO+s2OvPhJ0wu+yQWGucAmHy07VPP4/?=
 =?us-ascii?Q?hhzjfYNPoGONhybDhXwJkHNjMVJ+wJokjmmYjQABrnk9ParBWae7zVAHmnOz?=
 =?us-ascii?Q?1N0Msur+0Imaps6+Hlz14zI7d4nYNgwFF5w4jYvGN67c1H+zzxXRrFzEpL1K?=
 =?us-ascii?Q?I6Kz11x5Y5oc4ymx5NcvesWWcpPAyqE/oM6ApBeKHfuS5bMsMQrPcnqXPptF?=
 =?us-ascii?Q?Ht/lz2TCQG9a9JfUIyX0KZfWwxcohv9Nze1yTgLmpssW3amHoRqaecgs9A2V?=
 =?us-ascii?Q?aQl80zPCKPJdEbA8MFOeKPlEsPRWrA9svVLePI/EPDiX7JkEAnnIm88wp381?=
 =?us-ascii?Q?jj3KGvr0e4W3fM0WEYnIbvnGHyHCdeRzbig0ddUiXYiYYwHoOXvUsSPX9Lfg?=
 =?us-ascii?Q?FqZ34LdKXyZG0WSkK/vTtgZD5Cud0YlxtU1kJWWF9Gm/Nn2+1Ow9oZLjo8B1?=
 =?us-ascii?Q?/SsArvxXiiBzom4XBwtOvd7OLusZPSklfEKZA8f4sEuyRPmBZGhLJczQSd+l?=
 =?us-ascii?Q?L6+ukg2u/tlMCuVuZ6Kx7+CfO/MV1hmcJLPGSEfPmgbmDuYrECrzCsgt/Pc8?=
 =?us-ascii?Q?mBOJ2a9orjxLwSwUa1lE4zoTEpAE9DrayuG+CjggbZxGyv6jgIQGKvcPldkX?=
 =?us-ascii?Q?Nprc0qQFAw9jpsDGjDHU6wKur3E6EAVpqIy97+EPuU5qAxXHvZvkwyTk9e44?=
 =?us-ascii?Q?mLiPMn2osGvlG5+CCFVB8w9FgtxyTBWtBJwIWU3FqbO4CT40mXLYHnqBnXtP?=
 =?us-ascii?Q?c66GaqJ1cPEEDZHBg2PZQNrQabQLUQBX76VruSAEapgXCwH8AHcDxxkwKWel?=
 =?us-ascii?Q?PF4UPqOI2FUUXbFBivOrnqbvNbCjAUXSPgM0g3DMKdCcM/QYQaC5UnqF4cPa?=
 =?us-ascii?Q?3241PN61f9WQSqojeTIP5C5pfLy6mcxS595Kk+GSiGQRdnotyh6ybHVH2BG3?=
 =?us-ascii?Q?uiHcSsZvGdek7lDHa6tHQpdWX4TeWxsNQombWB+HV0JM/+Qt2IGUFGrX3yeJ?=
 =?us-ascii?Q?Nm2Gd+7GFvBBT0qPt6lMmVXnUzABphWFdpghl2hkEvtJGRk5uFAsTjVjc4RX?=
 =?us-ascii?Q?0OG9hf5V+LFV2ziPv8OPRm296A94PPPQP+EtNk/UB1pta/V4fGVZ1zdLz8GH?=
 =?us-ascii?Q?QXID4ZnwbTLsrQzCTnxg9m4uea7lrZ9dtyFU/Krr/ZkUa10jVIe5Y+D1L6Ca?=
 =?us-ascii?Q?kkybXgVDFXNvcGz1SWU8+T62nYmV9R8daRe9kd4uLuAsNqEvWcWijU6Ty2YC?=
 =?us-ascii?Q?F/Pv+HnfZtSeSeish6a1tV7OKAbQuhPKVyk98BWpV2U56sjdXEGSHJCrqhCI?=
 =?us-ascii?Q?eYKCWhg3cx0Iy4Sj/CiT48B2cScDVtyzQIAADhvTBEaeL4LfomtE1vIW/i0p?=
 =?us-ascii?Q?IThhDFKrn5WgykqOieg7JNNxKxDNPKJozSK8ElqWdF8zeOTWeXDRq8qGrvFl?=
 =?us-ascii?Q?/cFMzCOPoMj7nX0P/PZquGBvOltwPQSaKsGnTlPIarGDCiwWbGLwSf0Ecq8K?=
 =?us-ascii?Q?+LvzGBthS+FQaMN/dLIp8wxAofxLlfNva9YfW27vdHedIap8N2Z3HSVW/zB1?=
 =?us-ascii?Q?/L7yNDlu21YDReAPL0f7bjp569eMdNhcHlfw0LZcFcXdFroFKggNqZz15xJd?=
 =?us-ascii?Q?XMIprQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0ba4832-f2fe-4a9c-f7cc-08d9d3d5706b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2022 01:06:31.8348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1msxV4mwdwvRxrZ34bLHwgitpBDimbpWJvnZRicoNmUPTEIsuPdoAIJECPkcumOt/YhAWt11WAvfsvlyRubzFop9v98CNbeNXPc3XkYPcgM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5810
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Regmap supports bulk register reads. Ocelot does not. This patch adds
support for Ocelot to invoke bulk regmap reads.

ocelot_update_stats loops over continguous memory regions. Performing bulk
reads over these regions will allow drivers to optimize bulk optimizations
to thrive.

Specifically, SPI operations for Ocelot chips will be improved drastically.
The process of transitioning from subsequent register reads removes the
need to de-assert CS, re-assert CS, send 3 address bytes, and send N
paddings bytes. With one padding byte, that is an overhead of 100% for the
protocol alone. This overhead will no longer need to be incurred.

This patch should have minimal effect on existing systems. There is a small
memory hit (maybe 1KB) and linked-list navigation runtime performance. The
runtime penalty is probably offset by lower-level lock cleanup, so it is
entirely possible that this patch actually improves runtime performance of
existing systems.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/ethernet/mscc/ocelot_io.c | 13 +++++++++++++
 include/soc/mscc/ocelot.h             |  4 ++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_io.c b/drivers/net/ethernet/mscc/ocelot_io.c
index 7390fa3980ec..2067382d0ee1 100644
--- a/drivers/net/ethernet/mscc/ocelot_io.c
+++ b/drivers/net/ethernet/mscc/ocelot_io.c
@@ -10,6 +10,19 @@
 
 #include "ocelot.h"
 
+int __ocelot_bulk_read_ix(struct ocelot *ocelot, u32 reg, u32 offset, void *buf,
+			  int count)
+{
+	u16 target = reg >> TARGET_OFFSET;
+
+	WARN_ON(!target);
+
+	return regmap_bulk_read(ocelot->targets[target],
+				ocelot->map[target][reg & REG_MASK] + offset,
+				buf, count);
+}
+EXPORT_SYMBOL_GPL(__ocelot_bulk_read_ix);
+
 u32 __ocelot_read_ix(struct ocelot *ocelot, u32 reg, u32 offset)
 {
 	u16 target = reg >> TARGET_OFFSET;
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 5e6b9d6c4c1b..6f74015032fc 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -744,6 +744,8 @@ struct ocelot_policer {
 	u32 burst; /* bytes */
 };
 
+#define ocelot_bulk_read_rix(ocelot, reg, ri, buf, count) __ocelot_bulk_read_ix(ocelot, reg, reg##_RSZ * (ri), buf, count)
+
 #define ocelot_read_ix(ocelot, reg, gi, ri) __ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
 #define ocelot_read_gix(ocelot, reg, gi) __ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi))
 #define ocelot_read_rix(ocelot, reg, ri) __ocelot_read_ix(ocelot, reg, reg##_RSZ * (ri))
@@ -786,6 +788,8 @@ struct ocelot_policer {
 u32 ocelot_port_readl(struct ocelot_port *port, u32 reg);
 void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg);
 void ocelot_port_rmwl(struct ocelot_port *port, u32 val, u32 mask, u32 reg);
+int __ocelot_bulk_read_ix(struct ocelot *ocelot, u32 reg, u32 offset, void *buf,
+			  int count);
 u32 __ocelot_read_ix(struct ocelot *ocelot, u32 reg, u32 offset);
 void __ocelot_write_ix(struct ocelot *ocelot, u32 val, u32 reg, u32 offset);
 void __ocelot_rmw_ix(struct ocelot *ocelot, u32 val, u32 mask, u32 reg,
-- 
2.25.1

