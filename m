Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA9F3DBD92
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 19:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbhG3RSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 13:18:50 -0400
Received: from mail-eopbgr130043.outbound.protection.outlook.com ([40.107.13.43]:45569
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229761AbhG3RSt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 13:18:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q0DyvMrHp1tUKOGva0OQrnf3niliT1okJg6N45FkMoQc4/DnB2MLJQk5yJZHe3Mgxm/4WySapIzG+y9rsqtqFraXBiNtXLrKiOukcIIvQrLXWvLqb0YOLS8OSxZzUUiM8WP/6M/txTgBEAxZbZwJaVbcS/r+WRodoJMf23ETECyrtsLVjeueGG2+DPew7snypZ8ReTN4yL6L8U7hetKcMVMawCzwe4evnZxn0ZoETXnjD8IeWBTvlmkWc3ZomleSluvX5AR2wAfxkjUBTeu0+rOHivP6Cp6kX0Py1wtIcqZqZcWpnByCzlon7CWENAcVCmKH2okqGpl5VyetGBGFGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kTibQbMSRsI/zPWPxecsbWv0EP4P/DIIyh5DleV8hUw=;
 b=kMVTxqBt+ZvbtGCtDZoL2Cm6mGX2bLo7fQ0IYccolEU1OLOns9BY6YrL/zGNy4s+q43k4Zo/3PuGPEWQgjID0V9Wb4KhXwAmbCmAUIkmW6Yqebw1ehPGCW+ELtLZ+/BsI15D+jd6/13qxC7WF2VXUD+ZY4Zu2mj2qQ9Il53xE9JXxtJO4Ghv/EMYMC387HKOKKrCRD2M3/2dI0nwsMUEOoUUuolwnVGW1OQeZadmuTNXENgbQASQV1n1SpOb8cfwd1ut10SnPN3TLC1hbIoVvxcvuLhLXXtr64OlKp0vPKAuXngk5+F7lOPgUKQrr3xlGzjL1YvybA8m0ZhNVle+SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kTibQbMSRsI/zPWPxecsbWv0EP4P/DIIyh5DleV8hUw=;
 b=Wk7ENBL5V0R5ASiAHPNwsqMkg6SmgFjrE13teydcJvhFMQAQtV8iANbW/gyLAHtmQulx7ZbKEnRaJTMHMgwjgcGplXTLhsQHBowhBtcjcBbYozfcpwzUys6tH/2u6tqmLYBeF8prUOvySHzzwt1I67rm9xJXSVlFl2ZUDf2y6wU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3967.eurprd04.prod.outlook.com (2603:10a6:803:4c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Fri, 30 Jul
 2021 17:18:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.025; Fri, 30 Jul 2021
 17:18:41 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net 1/6] net: dsa: sja1105: fix static FDB writes for SJA1110
Date:   Fri, 30 Jul 2021 20:18:10 +0300
Message-Id: <20210730171815.1773287-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210730171815.1773287-1-vladimir.oltean@nxp.com>
References: <20210730171815.1773287-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0202CA0008.eurprd02.prod.outlook.com
 (2603:10a6:200:89::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM4PR0202CA0008.eurprd02.prod.outlook.com (2603:10a6:200:89::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend Transport; Fri, 30 Jul 2021 17:18:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad3ce076-e237-4cd5-bdbf-08d9537e139a
X-MS-TrafficTypeDiagnostic: VI1PR04MB3967:
X-Microsoft-Antispam-PRVS: <VI1PR04MB39677649F481152A392815AAE0EC9@VI1PR04MB3967.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:327;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jrrZeH+USA3DRs43TGuvKFhAzM+wf1+exYb02OvAo8GHiNv2EpPs6RhinP9eVXBE1inEoiRzquVcFdzSnLJX0oCJ3DR3DY6frQVT7skGc3nutSahDWnx22eXLh3NtsgNCW+w1KkcExJR7FwPVwLWlAeCkADRWafJ+tldkMR3H0rOFQSiA65F+LT95AB1+QUf66cCu+ly/51YmPdwV55eD+3+rU3+jGubX6yoMn6nQ8d0lW4SC746vLA8n/b7O8q9YOH2p0Xu77tec7iQYS2nMSGSsZ35BbuBxV04yXqkiPbq4QbmKyHiIQVcoKwc33H/7s/LL1YccRIe9tCBSCOnKf+YdZIPvRCofkqAnki4/ULqAQMLWoC0dalIJeB7zJgU3ApsLHO5r6X6q3b+jELwXEgA0RKvuRlZBoIDEaWjqhW3bZUfmS7sy8MTlYiV+WMNV79U+ieeAKjfvpSvBeMqKOXzE8Qd7K53KhWKJcsc0tXEC9b0g9mcAuK/6gcN8J/wl+f15hz5lt31bhIPqBzWA7j7+/YZfqD79BG2lBzn4dhQWMcphmegViPQ6XxK53xsWWFsZL128F+Ca3yVYzHROj34dqeeZ3t/ZfbxuyF9MxaVmYWXwpec8TwFD9rkA2Qc/iMt9Tu5FapVYsLwmx0llJEe/d0lGocUp+pzKSgFm6xwWd1ozh13DN+6g8NA/fmGOQqH0sBXgBySj3Q8BancKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(396003)(376002)(39850400004)(366004)(2906002)(86362001)(6512007)(6506007)(478600001)(956004)(83380400001)(2616005)(316002)(38100700002)(36756003)(6666004)(38350700002)(6486002)(44832011)(52116002)(186003)(4326008)(26005)(66476007)(8936002)(66556008)(5660300002)(110136005)(1076003)(8676002)(54906003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nUJPdYq0tnghpV1X2REDGhI7rqu8Bc5g1+XTk/gse5MLeEliNKVRUVLxd1VF?=
 =?us-ascii?Q?M05ZPUF+dR7wu+HgCugW3ojkwHkEdq/7KxvH5xyg+cFTaKrFj/ydmeDU/zj4?=
 =?us-ascii?Q?xIan3WrdBtabZ+Ob8FxmiShz/E6z0WDcI/jn2MjL6VTOW1z41bC47zKaFFZe?=
 =?us-ascii?Q?Z0dqhjBDRbviiYrnF4DbHsL0erzUf8GEGM5IRYbTWcdpWhDKSgIBLhQP8lDC?=
 =?us-ascii?Q?zZNeDoxvq0XZ1fcCUk1jSoJhgU32eyrwyRqUa20CMWaPUi/jB8Lv4R4zj+7v?=
 =?us-ascii?Q?RmjQBi26Cjd4+Zo44W/5r3mRImwWleZtZ/Ha4Gg1NBPRYHx+LRgQBlbj2MPN?=
 =?us-ascii?Q?A+Zzt+8D8RyLEJUSqRjxDUiu1GcxSiSEBaE9KuLxbHMcWJH1A8fSBiESe2lm?=
 =?us-ascii?Q?3/JeFeqAw89x0YL61fgSUSgFz5WB1zD79tcKZTs4D9GOdx7BON/NXVzW00tf?=
 =?us-ascii?Q?plQ+YISzxMSEIriuPTwX60T6K6g4KDnjXdoMeDB3PXInFT4YDFPI4vMiIkhY?=
 =?us-ascii?Q?3DkvRcfJGjGkTx4nXD1t82fWB7JcpnCMnb1GmZhiz/YcMwaIHep+RrXQ+/xS?=
 =?us-ascii?Q?XRJaocjkhegcjRonfmf8l5QXjuCUDCvkqNUx28Q/C6RB5A8BFxqmYhFjMxqg?=
 =?us-ascii?Q?t5X4Ufupm7hNNrGp+iJyzZh3KL8IZVtGbsiIjLOcmv9gF4qHZ1kftRznxfMc?=
 =?us-ascii?Q?l/rKqXKHs+PcdG0/vf/a9CnpkoCk8VKsdsNrYgggLFIkKmvy84W+zNjZoLsf?=
 =?us-ascii?Q?Ye39iBAmFo9TSRzkFfRl1/7BD4AcscpZG5bsR69RloQqmpGVl3+qAmSoj55R?=
 =?us-ascii?Q?Tfj1ECJODY3oFB5wkibIMboPNH7qj1pafXVMCC6RsC2HQzKcSqczhZhrjJoV?=
 =?us-ascii?Q?z3A50IxLWVWxGlihVUX0E3kzOdy5ddBYmDq42nxXh1+kT9lkt0EfjyZfYSog?=
 =?us-ascii?Q?OcziWKduQTAhOBKC/aOoKrVRMkAgLkE/P3S9BXWJnurov4hbtzxHPiVO4JRD?=
 =?us-ascii?Q?J9bOeYL+k2G1OGkIo8WYgzN4+G4msarCpjIOKa64sLuPEc3rUwjnVOulT9W8?=
 =?us-ascii?Q?d9la0Jh6pSKFEkziYD2KcE/UDrDfNroyyMVUJ+o3/LC2Dvyf0pZUWYoJIiRy?=
 =?us-ascii?Q?+R50N+Oe8GIKH7cfo0RzwwNd1qzv08EpOw4NLEVsczooFHPBQc0cYrUb5qRQ?=
 =?us-ascii?Q?rCyQQwK0d4LP2VHA06rXsWvIPZutJBv0HajFLjRuzDklevF85916YH/fKclY?=
 =?us-ascii?Q?ANAEBetycyTZusUfZ1vNgnA9FJT38D/SDUOxvYJA5FAy5CS+Dl/rcBFTmcQ5?=
 =?us-ascii?Q?elPXtVms0URkiuhArcvMmhoQ?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad3ce076-e237-4cd5-bdbf-08d9537e139a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2021 17:18:41.1277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sEep7cJ5wQq32TDdbNhUdohIM8n+pQT0Le3hBm7Y+JAp78s+xl0XYnE+/R5RAc71tJXlvS+aZUsYAFpvW9OhYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3967
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The blamed commit made FDB access on SJA1110 functional only as far as
dumping the existing entries goes, but anything having to do with an
entry's index (adding, deleting) is still broken.

There are in fact 2 problems, all caused by improperly inheriting the
code from SJA1105P/Q/R/S:
- An entry size is SJA1110_SIZE_L2_LOOKUP_ENTRY (24) bytes and not
  SJA1105PQRS_SIZE_L2_LOOKUP_ENTRY (20) bytes
- The "index" field within an FDB entry is at bits 10:1 for SJA1110 and
  not 15:6 as in SJA1105P/Q/R/S

This patch moves the packing function for the cmd->index outside of
sja1105pqrs_common_l2_lookup_cmd_packing() and into the device specific
functions sja1105pqrs_l2_lookup_cmd_packing and
sja1110_l2_lookup_cmd_packing.

Fixes: 74e7feff0e22 ("net: dsa: sja1105: fix dynamic access to L2 Address Lookup table for SJA1110")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../net/dsa/sja1105/sja1105_dynamic_config.c  | 27 ++++++++++---------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
index 56fead68ea9f..147709131c13 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
@@ -304,6 +304,15 @@ sja1105pqrs_common_l2_lookup_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
 			hostcmd = SJA1105_HOSTCMD_INVALIDATE;
 	}
 	sja1105_packing(p, &hostcmd, 25, 23, size, op);
+}
+
+static void
+sja1105pqrs_l2_lookup_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
+				  enum packing_op op)
+{
+	int entry_size = SJA1105PQRS_SIZE_L2_LOOKUP_ENTRY;
+
+	sja1105pqrs_common_l2_lookup_cmd_packing(buf, cmd, op, entry_size);
 
 	/* Hack - The hardware takes the 'index' field within
 	 * struct sja1105_l2_lookup_entry as the index on which this command
@@ -313,26 +322,18 @@ sja1105pqrs_common_l2_lookup_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
 	 * such that our API doesn't need to ask for a full-blown entry
 	 * structure when e.g. a delete is requested.
 	 */
-	sja1105_packing(buf, &cmd->index, 15, 6,
-			SJA1105PQRS_SIZE_L2_LOOKUP_ENTRY, op);
-}
-
-static void
-sja1105pqrs_l2_lookup_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
-				  enum packing_op op)
-{
-	int size = SJA1105PQRS_SIZE_L2_LOOKUP_ENTRY;
-
-	return sja1105pqrs_common_l2_lookup_cmd_packing(buf, cmd, op, size);
+	sja1105_packing(buf, &cmd->index, 15, 6, entry_size, op);
 }
 
 static void
 sja1110_l2_lookup_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
 			      enum packing_op op)
 {
-	int size = SJA1110_SIZE_L2_LOOKUP_ENTRY;
+	int entry_size = SJA1110_SIZE_L2_LOOKUP_ENTRY;
+
+	sja1105pqrs_common_l2_lookup_cmd_packing(buf, cmd, op, entry_size);
 
-	return sja1105pqrs_common_l2_lookup_cmd_packing(buf, cmd, op, size);
+	sja1105_packing(buf, &cmd->index, 10, 1, entry_size, op);
 }
 
 /* The switch is so retarded that it makes our command/entry abstraction
-- 
2.25.1

