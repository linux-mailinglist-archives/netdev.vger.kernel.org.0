Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6316DF610
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 14:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjDLMtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 08:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbjDLMt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 08:49:27 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2071.outbound.protection.outlook.com [40.107.22.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75504A247;
        Wed, 12 Apr 2023 05:48:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oZmHlne/1AMHZTzSZ3wWq/3WPWcBbEp7zqtMWt8gIu3UvP6i55TFU7z4Khc8pxvi/lX84kxlKThDR1LVGMSMflzBkIcDYGgCDnCiozTH0ZBciaeAN27gmjpBTkEAOc8SdinfSSgp9KODGifsY37lUkb9z56U7cngVfxFvudBeGy5lIsPIpDkFyTtWONjFuwTe4ZFL0dYZiuLP2A2PDolhS5IHE9GnW2S+eMoaYsEoURNcKQrIgN+92iuh83RPyljeZKDkjaWYyBYolWqK8ddkBpwfWdGYXOhvCvxO/P3N5FmT/d9Qc+2mSu8qPjaZiOB+19T1VFJf06FgHoh8/Xcaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TS/rSogzg/Yo2bKWcqE9w9nBxu5/lORMaffud/S49gM=;
 b=E5/V+MZukHaiimv7oH7gmK6a/s0E17NlGcEl64kv/Oc/tzgITWIFn4f0Z29zegRJDV2i38TBS4v3urVWS6sMR/miTv5HcLbKapj3ryhdFT9gvxaAhmAz/HG8enrwuf7sfnyy43KP/0I+PgwlCvbBlpRgXD9pcx57OcWysM7HlpuOV7UIaUEVSQ29XxuMS6ibRyyl8Sz5jdqR7W98YxxLBsqvQ/o0Gik9R9Mve67ImhfJlPLKUJ59mLGp5rde5aJFUU+QFfDb/ilX03QV8nBbPOvji9MM/E8DbAaqdsGItcaPYO8Un+95Ozif8jRZ11Q+ygnq/Lk916CYUJkCz+jpbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TS/rSogzg/Yo2bKWcqE9w9nBxu5/lORMaffud/S49gM=;
 b=Xo3gjmJbB5JaPV02+o2AHV3fTddDh2iRkxd57m10cMBKDzCZ81xseP0ICG11sKj4u4ioTqhlMJuY3h0wVSssayzeSOejgUrWJYJjDJmTC4UIjZA1la9zFukuv9jBgnaoxXlZlMiKbgfS2rybtBPYyQIjY7B7gi/T5vEoRyveCbM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM7PR04MB6888.eurprd04.prod.outlook.com (2603:10a6:20b:107::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 12:47:53 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Wed, 12 Apr 2023
 12:47:53 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/8] net: mscc: ocelot: strengthen type of "u32 reg" in I/O accessors
Date:   Wed, 12 Apr 2023 15:47:30 +0300
Message-Id: <20230412124737.2243527-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230412124737.2243527-1-vladimir.oltean@nxp.com>
References: <20230412124737.2243527-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0056.eurprd07.prod.outlook.com
 (2603:10a6:800:5f::18) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM7PR04MB6888:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f545d4f-2964-4339-9159-08db3b54218a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QcHQw5o2+uT+Jtm13MuvVHyurbhGED/+yTtSo/zrOTYmua6HZW1dNPLGfsCvzerby/pQrKZ0UsgYlp2eFfSr7WNS2io2Y63DFhjyzd8jC4aNufaECm7GNZUH4zvffdbQnNYe65Kgl0GRvGYewcY9nwHRRAE4WK4FP9ZRYixtsfi9up87BQh34IIJJg6YUSuZgiW/qFzfdYgtDgx0fr6fMorYX72yZC4nNT3OVI8i01v/fy47X0/tl7uZf2hC3gSXISKT/A/RzAysKOk1Ki/gG2JDSkmjAe69Yo6gv8d2hJu6n9csnzL1WTa2Rg4yE/qRtkyrWqbAK3CkSK5sNRDTjqOH/UQNXpKcIX2xIVCnrUIEGs14ZXxZ3G/PbIzgIVrFr5+5JJR2WgDItEltocBhJvoJtJTwPpLycMrcPBXjicIZXfc/ztmyBnp+Nc/EzsCi9LOk7lfmVCILbRaXUuLDRFkFge0REIav1NWVl9cZ/oVi4EWBpgp4NEQPheDX+2xVafI6byXg7CxHZdjLPSCkSsuH0LnAD+58tg7NkKeSeUpqOd4kfJmGH1AK0bvgtKVr1UOAyCCcB2OC80UTqgtwwWRpBrVCcgXVYuuBZhpLGyzJBA3vORohssAMjoOGRT1Ja5f9kVjkHb8lmh3Vt+vOjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(451199021)(478600001)(52116002)(86362001)(83380400001)(6512007)(36756003)(38350700002)(2616005)(38100700002)(316002)(2906002)(1076003)(6506007)(26005)(54906003)(44832011)(186003)(5660300002)(66476007)(6486002)(6666004)(6916009)(8936002)(66556008)(41300700001)(8676002)(7416002)(66946007)(4326008)(461764006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?USUQaetkCJgbivOyoInY1K5sK05tmLp++lKE9xREVPxUUw/6hQCRNUvksmpn?=
 =?us-ascii?Q?MYWaWSYVnkwCG37cbnuDVeuzK1Sclwh37oWhLF2Wmw5Z4LFc9oNlrxXK+OoN?=
 =?us-ascii?Q?dwKK2R//84ChXJNXC5NMH5NO90VDS7oGaEZVCCwwsUUe5Ed+dyd3hHaQXrxM?=
 =?us-ascii?Q?M9LsF9ZMqSNDrYLCWQ6jkXKNEybn2D60zVBUQuhGEY5Yn2htCDeG2NHJaIqF?=
 =?us-ascii?Q?q/ipw73FEkPisRil1DMsOjDDdu9uWp1KBizfBXi1dNayNUWcke8W+TtwJiVl?=
 =?us-ascii?Q?DfHaFhhWv3/Uf+T479c2Kh1z5s5iYS4VdmtInPJAh8ecJZwoekyIMP2fC+0D?=
 =?us-ascii?Q?MXsynZWfUSBOimBuTwfPErR6HVNaUDl0s5FOQZVDJ+4S2oGL2M6Z1TCgDvJg?=
 =?us-ascii?Q?XhB3Zx65HLGhKQZyI+lB5MoMCEOH5VAqW87XTNp2+qePCg6PmxSyhVj8kSXd?=
 =?us-ascii?Q?nVGj+85JoBXd71neRyXVHJq1s7F0lDVyHu0s8dHjhfaXpUzskPbpHU6mK8Ty?=
 =?us-ascii?Q?pZcRpgKfjALiLLkywNPIJ9nadl4f9DwttbEHzF07Hxd8aG0MFzVWPjfJSI1N?=
 =?us-ascii?Q?40SEaKgbHJQ4sJBDAWLbjHuYJBhcfaPmcchnMCA2LhsP5H584zpOssRb9kIU?=
 =?us-ascii?Q?KZGu8BH96OYqF09mOBNxJlye3yI8dYlena3WHlE4AIRp4n3saUfxHM0fX6g0?=
 =?us-ascii?Q?ebpZFdHttobFqDeBar4nhV5s/PL+QtmOJ3kJ9xJsVRNIXq2WRB2954lRqQXz?=
 =?us-ascii?Q?5YjtCiiG2aThahmYWnmyR1J7OGkV/MMJwRk3ZTwwEQHF6GZDcc3ten9n3mTj?=
 =?us-ascii?Q?R5H1eRGlHrU6Z0EpyrjNf5j5yEoYYVRDJpum5a7X6KXiyjS8pYuESllils6/?=
 =?us-ascii?Q?y3XyN9V7gu2CQ1C3li09rzBEiql8EEcUcyiLlwjoL03xIWP2Vl8u8tLg/kSB?=
 =?us-ascii?Q?4CKBVUcV7KVtWHyjci+GOtuNnvqZxfvT+guTLIsOpetqxBgIg9TGIeGX5cK/?=
 =?us-ascii?Q?eMeXeOedW2iVTgsxDbwM+pc8FvPl9LhiIJEZxx2+9E6RoYTh6P3Cl/JcX9HC?=
 =?us-ascii?Q?wdrZs3R5RHy3C9AUxGkfBTKYtYCqdBkCUgW4LQI0GChy1IpdGXd9aaSoi0MT?=
 =?us-ascii?Q?78UvmWhcNFIKWjzd834J5gXwBVO4eSIIvpLgmCX7N359adnW/eFt6XgJPjSa?=
 =?us-ascii?Q?jZDZtJ/DIYkKYBadRfrUuq4MCRaQdAa5JCw60RhfB4Ey67ghOfkJivjoOpUg?=
 =?us-ascii?Q?mxHKBlL/n6kOh/pYEE/TjpIUKQkFLq6Cdeb6A2yrYSpb11bhcBqjrWy5b6y9?=
 =?us-ascii?Q?+urLYycZXJ8vvQpb9OsTmN1xX0uNaeCZDyvRRSQW7ZJ+MvBDEioXCsqYFkbj?=
 =?us-ascii?Q?r2puFyE4Xwvqal6MrTIJrLUYU5Wf+dklXw70TqA6lA0RIaoR/NUjB2Ej3Bu8?=
 =?us-ascii?Q?UFEZNaDVThhk/kO5I3Os1MjsYJFB8FWcTJ8MBfhMaqyXumcWsSiGWE8sLUsC?=
 =?us-ascii?Q?kR4lE3Lj1FyjaMf7clIxxilPf7m9y8NSM6N94t3yvLhZgi64gyQSEihMQWH4?=
 =?us-ascii?Q?GygLAThuZ2pxBxAAVGjTGWGKCM6DFM6+EJrRsuSGSg+uHSyesNTKwRDkV+eM?=
 =?us-ascii?Q?iA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f545d4f-2964-4339-9159-08db3b54218a
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 12:47:53.1569
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uEm4a/peCv2KgroxUafTczSrn5DTXOeOvB+xd/nTw4UwjJZtNEGXIYYo9LlY6DkxSpom6YuQfwtSVBlKbF9/Cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6888
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "u32 reg" argument that is passed to these functions is not a plain
address, but rather a driver-specific encoding of another enum
ocelot_target target in the upper bits, and an index into the
u32 ocelot->map[target][] array in the lower bits. That encoded value
takes the type "enum ocelot_reg" and is what is passed to these I/O
functions, so let's actually use that to prevent type confusion.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_io.c | 20 +++++++++++---------
 include/soc/mscc/ocelot.h             | 20 +++++++++++---------
 2 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_io.c b/drivers/net/ethernet/mscc/ocelot_io.c
index 2067382d0ee1..ddb96f32830d 100644
--- a/drivers/net/ethernet/mscc/ocelot_io.c
+++ b/drivers/net/ethernet/mscc/ocelot_io.c
@@ -10,8 +10,8 @@
 
 #include "ocelot.h"
 
-int __ocelot_bulk_read_ix(struct ocelot *ocelot, u32 reg, u32 offset, void *buf,
-			  int count)
+int __ocelot_bulk_read_ix(struct ocelot *ocelot, enum ocelot_reg reg,
+			  u32 offset, void *buf, int count)
 {
 	u16 target = reg >> TARGET_OFFSET;
 
@@ -23,7 +23,7 @@ int __ocelot_bulk_read_ix(struct ocelot *ocelot, u32 reg, u32 offset, void *buf,
 }
 EXPORT_SYMBOL_GPL(__ocelot_bulk_read_ix);
 
-u32 __ocelot_read_ix(struct ocelot *ocelot, u32 reg, u32 offset)
+u32 __ocelot_read_ix(struct ocelot *ocelot, enum ocelot_reg reg, u32 offset)
 {
 	u16 target = reg >> TARGET_OFFSET;
 	u32 val;
@@ -36,7 +36,8 @@ u32 __ocelot_read_ix(struct ocelot *ocelot, u32 reg, u32 offset)
 }
 EXPORT_SYMBOL_GPL(__ocelot_read_ix);
 
-void __ocelot_write_ix(struct ocelot *ocelot, u32 val, u32 reg, u32 offset)
+void __ocelot_write_ix(struct ocelot *ocelot, u32 val, enum ocelot_reg reg,
+		       u32 offset)
 {
 	u16 target = reg >> TARGET_OFFSET;
 
@@ -47,8 +48,8 @@ void __ocelot_write_ix(struct ocelot *ocelot, u32 val, u32 reg, u32 offset)
 }
 EXPORT_SYMBOL_GPL(__ocelot_write_ix);
 
-void __ocelot_rmw_ix(struct ocelot *ocelot, u32 val, u32 mask, u32 reg,
-		     u32 offset)
+void __ocelot_rmw_ix(struct ocelot *ocelot, u32 val, u32 mask,
+		     enum ocelot_reg reg, u32 offset)
 {
 	u16 target = reg >> TARGET_OFFSET;
 
@@ -60,7 +61,7 @@ void __ocelot_rmw_ix(struct ocelot *ocelot, u32 val, u32 mask, u32 reg,
 }
 EXPORT_SYMBOL_GPL(__ocelot_rmw_ix);
 
-u32 ocelot_port_readl(struct ocelot_port *port, u32 reg)
+u32 ocelot_port_readl(struct ocelot_port *port, enum ocelot_reg reg)
 {
 	struct ocelot *ocelot = port->ocelot;
 	u16 target = reg >> TARGET_OFFSET;
@@ -73,7 +74,7 @@ u32 ocelot_port_readl(struct ocelot_port *port, u32 reg)
 }
 EXPORT_SYMBOL_GPL(ocelot_port_readl);
 
-void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg)
+void ocelot_port_writel(struct ocelot_port *port, u32 val, enum ocelot_reg reg)
 {
 	struct ocelot *ocelot = port->ocelot;
 	u16 target = reg >> TARGET_OFFSET;
@@ -84,7 +85,8 @@ void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg)
 }
 EXPORT_SYMBOL_GPL(ocelot_port_writel);
 
-void ocelot_port_rmwl(struct ocelot_port *port, u32 val, u32 mask, u32 reg)
+void ocelot_port_rmwl(struct ocelot_port *port, u32 val, u32 mask,
+		      enum ocelot_reg reg)
 {
 	u32 cur = ocelot_port_readl(port, reg);
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index c0e40ceba50c..85505ac5e63e 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -943,15 +943,17 @@ struct ocelot_policer {
 	__ocelot_target_write_ix(ocelot, target, val, reg, 0)
 
 /* I/O */
-u32 ocelot_port_readl(struct ocelot_port *port, u32 reg);
-void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg);
-void ocelot_port_rmwl(struct ocelot_port *port, u32 val, u32 mask, u32 reg);
-int __ocelot_bulk_read_ix(struct ocelot *ocelot, u32 reg, u32 offset, void *buf,
-			  int count);
-u32 __ocelot_read_ix(struct ocelot *ocelot, u32 reg, u32 offset);
-void __ocelot_write_ix(struct ocelot *ocelot, u32 val, u32 reg, u32 offset);
-void __ocelot_rmw_ix(struct ocelot *ocelot, u32 val, u32 mask, u32 reg,
-		     u32 offset);
+u32 ocelot_port_readl(struct ocelot_port *port, enum ocelot_reg reg);
+void ocelot_port_writel(struct ocelot_port *port, u32 val, enum ocelot_reg reg);
+void ocelot_port_rmwl(struct ocelot_port *port, u32 val, u32 mask,
+		      enum ocelot_reg reg);
+int __ocelot_bulk_read_ix(struct ocelot *ocelot, enum ocelot_reg reg,
+			  u32 offset, void *buf, int count);
+u32 __ocelot_read_ix(struct ocelot *ocelot, enum ocelot_reg reg, u32 offset);
+void __ocelot_write_ix(struct ocelot *ocelot, u32 val, enum ocelot_reg reg,
+		       u32 offset);
+void __ocelot_rmw_ix(struct ocelot *ocelot, u32 val, u32 mask,
+		     enum ocelot_reg reg, u32 offset);
 u32 __ocelot_target_read_ix(struct ocelot *ocelot, enum ocelot_target target,
 			    u32 reg, u32 offset);
 void __ocelot_target_write_ix(struct ocelot *ocelot, enum ocelot_target target,
-- 
2.34.1

