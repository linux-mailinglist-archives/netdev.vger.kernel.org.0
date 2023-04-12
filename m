Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9F46DF617
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 14:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbjDLMuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 08:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbjDLMtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 08:49:52 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2066.outbound.protection.outlook.com [40.107.22.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7827ABC;
        Wed, 12 Apr 2023 05:49:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mg/5Cw0OW97fxWn3q5KM34ttIuk75YEF+eJZiw+yIRY/wvut0I384ghrut7ayAyNHeYw+auomD6b5sSyrjd9bHOA2uU6cuQLXz1BT+lLd8I/L+1cYLSArw35OL3k3KbKpkGJ3lWKXVDQhttqCUyiUSJGWdrjh5fNqSi5RdYhCuSomzUjdJoyw53j/4RFawXucU/LWXyFu+wc80dGSFo+kkCf5mJBzV9LpYmQc4eGNknK8ISixWQtPDJ0fyNCMti4QnbBP9qYzoUzcgjBr3skQ/3Cz7e/+JDmfJ6947U0LyHTxRgJ+1YlnUbTTFlLeqPSjKquAt2oUWNV+H33Y4LgDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9AgmYtTYSgBMTncLhBRsN0OgZSSCzQeGJA13dHgv11c=;
 b=f90Y5Zgcaa0OQRfcrM32O1f10dea+vQqNGcvUB4bXar6ZCcP8vmx6VeyV2MKaSnTSLy9nHwQbeU7AnbuGdAY0uNEKhejcOck40bFwyhb7LhNSRVibxhP8jnfyo1hUwhgGckCen29/yJVUeAYUYfO6j2HGj5rbZGYdXIFBIPt4NH3vBzk9dT3IPREBf3lOocJ29GeEm+5BzSTVkjjv1CflqNIBtz+MjBSplKt9eEJtiBPRxnD2dXNo2JTIYvzx8fnNfbcVdJg1iEshPt7AMWDWPtw1L3ZkSJ5kocP74KgVdWRcZl4fMQNRb87gLJ3yCbVFwz34a/o65lx6Wh6Sdt7Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9AgmYtTYSgBMTncLhBRsN0OgZSSCzQeGJA13dHgv11c=;
 b=bBNTvobvBw6Rq3vKvE0Zm/iVaR+xDNJ9U5fd9xca/xPgQOx1EhJDVuRUV2WAe8qM4ho0SHzTbe1tLXkyDjhiZT9LuNR2Em+0HXw8xTtQfhxVxs1VnVcaRUF49mXh6OLY4BPnf2YU89+l4Oh39Rrasp7XoQZzTM3PCQ0MoIMc2/I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM7PR04MB6888.eurprd04.prod.outlook.com (2603:10a6:20b:107::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 12:47:54 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Wed, 12 Apr 2023
 12:47:54 +0000
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
Subject: [PATCH net-next 2/8] net: mscc: ocelot: refactor enum ocelot_reg decoding to helper
Date:   Wed, 12 Apr 2023 15:47:31 +0300
Message-Id: <20230412124737.2243527-3-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: b3041181-7461-4462-eac4-08db3b542227
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CPwosvh97F2fWPJOPzsZ5NvqsNE/muYefL56ei2bIhRVX2PPXMZSEG3GdkHkB3Mj1hg9LWmv4wNSOWCb89Z5vZYYpfAhxKS3vDlCg23NH+IoBA5Oq9YlwrGpiwN34ewz8sjs6CbcEhEb9hsYVS2wyL5JCZvMQe4WgVAtIw5lYXzBQj6I6zEA+0Yv9qaXHdkduaMaeFB9xq3WhYe+EtcyYg74uLZH+UfA8TwBeycAZjSsbVp2KPfaD9DSwtRA6IhXjEn2S2gZ1qEo6fIRAiBKfLy+pefTTr6bexlEifu/6qyOr8pSczDoEcyKxDS+utzdeIFVN/pfaTrWDzzpic9RDzVUJRhkF/lPyRFmOXYQQncYIzYjHCKVkHOI1uIFke7yB+0qjK4Ah0Ug3QeqGHyuHxwYMg2DLFHikZ30t5MNYhGgYD9N1jAVfXnJ3t++PJztSNVjnPOEbc/+9WCv0tmoNAPXw8wyEtkksPjKi+FJm4LyfAkKA8BV/IMogNGiiJsAwFbEh8xc2dgEMSZbl/AvQRQdtE+8HUgeSZvCzffcCmyrizfiDTQoClg6oHDR47aLWrHsjDiaut0hM39zzYwY6pge5De0Eat7J4NiFf0smTpqnnTz2R/FNNbattd7xtuA6K+Zm8yRSq2Pt59J++My9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(451199021)(478600001)(52116002)(86362001)(83380400001)(6512007)(36756003)(38350700002)(2616005)(38100700002)(316002)(2906002)(1076003)(6506007)(26005)(54906003)(44832011)(186003)(5660300002)(66476007)(6486002)(6666004)(6916009)(8936002)(66556008)(41300700001)(8676002)(7416002)(66946007)(4326008)(461764006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tXRUaxwndIu4IzyKPA+lWbRDKOpYFNW6pgjqD1wCehM6SYyynMsilF1iMpNl?=
 =?us-ascii?Q?t9L/jBeA8jotBB/OL6Z/mexQFfhgZYS5v9Otnhp1UFs6xgQxLsFTpDj45r02?=
 =?us-ascii?Q?NyCZgSgX3jm3gSuFqbgVp/8fETYeDg1i8U7kAAsC5xYmhJbI9143hHXEDmpo?=
 =?us-ascii?Q?VetJCQh7vl7A0Zcp1Zt69Kke3HutfQuYDITfIq26SIBsukYKsmkzhCCb4L6Z?=
 =?us-ascii?Q?l+BvgjJQ81wkujE/fsPgVLaDwXnh+0Mo51BWG+CQoK3BAfSVE1P2UcAgZg4m?=
 =?us-ascii?Q?PQgfVlARhNLxfxvVrBAYKe07UyymhkqjdD9XFdxIwvow8S9BsLcf11emA5BX?=
 =?us-ascii?Q?mFdFbc7C6aeg47JZXj+AF69lz6y4l/WwnoeK8YX2CpwVZAaq9VrInVkYvhz0?=
 =?us-ascii?Q?AI0UOQXYE771QZ4GKfMTljiZ0W7OXd28NxxxPXkbk7F6A73jyulOXUxwBcuP?=
 =?us-ascii?Q?WsehS3BRW2xC6+k6AgSe5mUQfxJNXyedIecLM/PQlaK3L6O7bVnikRqfshYf?=
 =?us-ascii?Q?ObxxCXUgqRaSN82tLDlFpL9SDLERwVlq0P/4XiHkaC7V8Ql9kukz2gZcvSsh?=
 =?us-ascii?Q?bwFdmEaHiKEOYam5buE7oMaNkGue147hG7brIBj5m0JdYhfMOfmSojVc7tIW?=
 =?us-ascii?Q?T6rWMeRTjPHczSObVBRpvPCzQSlNqu+EbSfzQVWD6RGAi9XN/Euer1ATPImV?=
 =?us-ascii?Q?rmZexYVw1l8EFEsc+6UCfKq6s/xhbCqCsTvpMh4iGQWidmuXYD0oFy/oCb9g?=
 =?us-ascii?Q?yjuWELz4WLgvtjPq0xjudAgBn4RA632FbIwzF/gPGMHfrne3RUVpShhLHUAx?=
 =?us-ascii?Q?6kxWl5+FFJrrjpk2nfvMjmlz/EL4z8N9OY60yycaOxCoRlPasuzkkerqrIVA?=
 =?us-ascii?Q?T9sC3O6TS8VigGFfrPwv+iv7o8fHgdc/5eafqmzM1A8OTp072D2ad3cQhgke?=
 =?us-ascii?Q?4yi7vzULqM0EXlVgmBqmMKGEJjQKgreJI8NM4jCGjsWd27vu57znZWSmF0Mp?=
 =?us-ascii?Q?jHSP+HokesDiYopKAxAqpggBmqLcd15uGv67b0yRUo1X60WW+1LdJw4xQwLL?=
 =?us-ascii?Q?Rku5bPqU5RPvEdYvqTEKvrooXaQE1uGuDJkgGPbRlKfwpdSz3SSE3jzYfJwe?=
 =?us-ascii?Q?Wp0Cqwh7SUvhgxLqyKi4k/THOd/2SpR3o7ndaC+e429UAS8l2tJ5McNtkXM5?=
 =?us-ascii?Q?hMSFXcN3LdxZUQnmOsVFjLzuHxhReBT7/AL1I+z0+6Ni2OA2tGdvZ4dYt+FU?=
 =?us-ascii?Q?dA4a2N+DxzELAzB4ZfoA1RnL1HUfTwP1OucDTsY5YI4yvZWc2CFkgViQ6TeU?=
 =?us-ascii?Q?co01tpg9CFqw2Oj5Aw6SQQma0/mHzEmL8c6asVTo9ka0o3zF1iDFrIwfJn0h?=
 =?us-ascii?Q?Ppnog1S+aSKgePEuI7hWbK5dWVK3otwcoWdQ+pnfynv4pvb9hfWvaFH2em7y?=
 =?us-ascii?Q?zRKugn8/g41uosnfuzdTIQ3ikJEKLM7xe63UEVVcul2BawBL0+qIwAytJUTB?=
 =?us-ascii?Q?jMVp1PqgHEXHJMU5H7/UYyDM8hnJ6Bg5tn9MHGpMC2yqdu12o2etVWYpvhzG?=
 =?us-ascii?Q?/lp5LrOj7kC5EQJ1aHNqP9X4sNXpohAhmep9UrktXRndkp7Cm0fTqi5AofEG?=
 =?us-ascii?Q?fQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3041181-7461-4462-eac4-08db3b542227
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 12:47:54.0838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Xr4Ezt1M76M2tvVZ3e2978xpP3uSViKXocGAwND0uU8mJ/jGpC/VsP0l91zm4yy5+gaepC5I9IRnlick4lKbQ==
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

ocelot_io.c duplicates the decoding of an enum ocelot_reg (which holds
an enum ocelot_target in the upper bits and an index into a regmap array
in the lower bits) 4 times.

We'd like to reuse that logic once more, from ocelot.c. In order to do
that, let's consolidate the existing 4 instances into a header
accessible both by ocelot.c as well as by ocelot_io.c.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.h    |  9 ++++++++
 drivers/net/ethernet/mscc/ocelot_io.c | 30 ++++++++++++++-------------
 2 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 9e0f2e4ed556..14440a3b04c3 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -74,6 +74,15 @@ struct ocelot_multicast {
 	struct ocelot_pgid *pgid;
 };
 
+static inline void ocelot_reg_to_target_addr(struct ocelot *ocelot,
+					     enum ocelot_reg reg,
+					     enum ocelot_target *target,
+					     u32 *addr)
+{
+	*target = reg >> TARGET_OFFSET;
+	*addr = ocelot->map[*target][reg & REG_MASK];
+}
+
 int ocelot_bridge_num_find(struct ocelot *ocelot,
 			   const struct net_device *bridge);
 
diff --git a/drivers/net/ethernet/mscc/ocelot_io.c b/drivers/net/ethernet/mscc/ocelot_io.c
index ddb96f32830d..3aa7dc29ebe1 100644
--- a/drivers/net/ethernet/mscc/ocelot_io.c
+++ b/drivers/net/ethernet/mscc/ocelot_io.c
@@ -13,25 +13,26 @@
 int __ocelot_bulk_read_ix(struct ocelot *ocelot, enum ocelot_reg reg,
 			  u32 offset, void *buf, int count)
 {
-	u16 target = reg >> TARGET_OFFSET;
+	enum ocelot_target target;
+	u32 addr;
 
+	ocelot_reg_to_target_addr(ocelot, reg, &target, &addr);
 	WARN_ON(!target);
 
-	return regmap_bulk_read(ocelot->targets[target],
-				ocelot->map[target][reg & REG_MASK] + offset,
+	return regmap_bulk_read(ocelot->targets[target], addr + offset,
 				buf, count);
 }
 EXPORT_SYMBOL_GPL(__ocelot_bulk_read_ix);
 
 u32 __ocelot_read_ix(struct ocelot *ocelot, enum ocelot_reg reg, u32 offset)
 {
-	u16 target = reg >> TARGET_OFFSET;
-	u32 val;
+	enum ocelot_target target;
+	u32 addr, val;
 
+	ocelot_reg_to_target_addr(ocelot, reg, &target, &addr);
 	WARN_ON(!target);
 
-	regmap_read(ocelot->targets[target],
-		    ocelot->map[target][reg & REG_MASK] + offset, &val);
+	regmap_read(ocelot->targets[target], addr + offset, &val);
 	return val;
 }
 EXPORT_SYMBOL_GPL(__ocelot_read_ix);
@@ -39,25 +40,26 @@ EXPORT_SYMBOL_GPL(__ocelot_read_ix);
 void __ocelot_write_ix(struct ocelot *ocelot, u32 val, enum ocelot_reg reg,
 		       u32 offset)
 {
-	u16 target = reg >> TARGET_OFFSET;
+	enum ocelot_target target;
+	u32 addr;
 
+	ocelot_reg_to_target_addr(ocelot, reg, &target, &addr);
 	WARN_ON(!target);
 
-	regmap_write(ocelot->targets[target],
-		     ocelot->map[target][reg & REG_MASK] + offset, val);
+	regmap_write(ocelot->targets[target], addr + offset, val);
 }
 EXPORT_SYMBOL_GPL(__ocelot_write_ix);
 
 void __ocelot_rmw_ix(struct ocelot *ocelot, u32 val, u32 mask,
 		     enum ocelot_reg reg, u32 offset)
 {
-	u16 target = reg >> TARGET_OFFSET;
+	enum ocelot_target target;
+	u32 addr;
 
+	ocelot_reg_to_target_addr(ocelot, reg, &target, &addr);
 	WARN_ON(!target);
 
-	regmap_update_bits(ocelot->targets[target],
-			   ocelot->map[target][reg & REG_MASK] + offset,
-			   mask, val);
+	regmap_update_bits(ocelot->targets[target], addr + offset, mask, val);
 }
 EXPORT_SYMBOL_GPL(__ocelot_rmw_ix);
 
-- 
2.34.1

