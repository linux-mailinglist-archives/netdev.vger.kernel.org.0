Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33071416228
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 17:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242066AbhIWPhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 11:37:39 -0400
Received: from mail-eopbgr150050.outbound.protection.outlook.com ([40.107.15.50]:23684
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241982AbhIWPh2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 11:37:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K3gw89GTyhV5/KWrPcUYfr9YdwFLhb6o5FgJFns7JMuHKttaLHwcitZvaNQCR9PCoc44cTrBOHpfrjB/fadzpbVsH1eKP8Mnglckc7ZRkFhQhl+S2Bzo5Iu5Ys6p7xndSS9C3ten273t5Jl1BDx1zUZI3pVSsYUECDby/6CKx6QvPyGOgqJCsRBlB99npO6RWdGRmAiYiJCy07Y81J2VbNiQTOnDhx9t4MEPQsx44JDVKsoSMOxGZOx1l7RD09SAbzUGfYschGedgseJLKnFATgVLob4F2JPKEzJ2krrBJP84p5SNckqjheIfwvLoxgofSdiT7t8yFdhkXCxA6I3Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=lmv8GkQO7o5YuvCojzXpm99+9B2arscsopWSoFmzATQ=;
 b=LG5Z6uVlYtmDdYO3n0vHBc1ewz3mJjKpG05j7BrF+EYSkcKw+weJwBKfUBto34Rl8RVtx1aKq6pGwb1XMvC61Yb/DI9hpzgBLbrKgAH1l6kZ2Y5ZbDpZRTeMiuDBFv1i42J+rHfxckJJ8N84fYRvAhYRpGvvx2b8mYIpB/MMFlySzgeTT0mkA4/Y6XF9XtyjKXBxPX9Xo362WOZXOcIrhrRpBUGSd+dhy7NUF4fp2D4W2rJjetY/iEtGubqh6H311Y4D5kAeVnHc+1hwm7G1hFOdjBY/C0cEcJ0ZX04EQw00AHYqixzzNE2ZXbDtnILEVY1a8wnx1N9BaJ8GBbeIvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lmv8GkQO7o5YuvCojzXpm99+9B2arscsopWSoFmzATQ=;
 b=SyRekQb33rAymvsIOV/Yu5im2d8aF3AognZoZ0XeGvbrMIp7ULGDcu9V6as1vlu1GaedeP51T0BG6ppV7myfS5HK7UUWr/COJ+OyCt5yb4x9/5GTzmD2yg8ti0CKIufkukmOfVb7leejNHgHGm2+cEkWmN4CI0BG/KPME90KFSc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7471.eurprd04.prod.outlook.com (2603:10a6:800:1a7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Thu, 23 Sep
 2021 15:35:54 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4523.021; Thu, 23 Sep 2021
 15:35:53 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: dsa: felix: accept "ethernet-ports" OF node name
Date:   Thu, 23 Sep 2021 18:35:41 +0300
Message-Id: <20210923153541.2953384-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0150.eurprd05.prod.outlook.com
 (2603:10a6:207:3::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.53.217) by AM3PR05CA0150.eurprd05.prod.outlook.com (2603:10a6:207:3::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Thu, 23 Sep 2021 15:35:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ac8beba-b5ee-4318-fa30-08d97ea7d43a
X-MS-TrafficTypeDiagnostic: VE1PR04MB7471:
X-Microsoft-Antispam-PRVS: <VE1PR04MB7471BB73994A0CD38D3BEAF4E0A39@VE1PR04MB7471.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:758;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xkCq4FOvGxh3xsmGBZVOd5zR+fKB8X7EABkmazk/z7jb3mzAJxMmyOi5odhkBeqkUTDRriEj94CtTNHUtSdN5MNnBTMYbQ1N7FkAsb8Ggz2JInCdglRoMgSR9Y0PPgFhAtFXTx6H9RlI+LMCbtffSvt1is4lIlbZLilD1bmZr9HuSbzRyIOH43iarPDViBYKk6HIVDoHN/Tg/2rrTsfoxjW00wPdnXtmJSebGWIgo4h/W4vB63Pd2A4JtZ+zMvfWT6h4wmNLCsJPW4ZR8Fqv0WuwWldpGuafIta5JyZyw2onFjGQLWbS5szZZDJdL2NieZmmVzz6OC1/BFvjVk199+WreGo4cTJAKg7LUrsGacFrcg2mwbfQ3GxplGJL1Y0gbQvRSmWjhZSqHjnd0qRQR44GcYJWmoHiFSrP/CPzT74QA0G/DidZcZjNSNiC42qtW09ykp8rh3UA97E32GZ2eAl0AX5832Fl7LH3rQII2go+8YnDOT61yeEAF+I29q6JE9lc1r96PRd0nmoxVG5bNyz6qVpGiSnk/4kNWPEbEBjqCGpTDs0BeSAIl5fp7KlPpRaDVq8z7unHZOB7UeEeaM0UAaKOFAAKqSvHsGfi3YTLS2FusMLF6jg+TeathBWpUvyi8t3dCJ2f7jC4GS3J57JJ02LhVFZl63ego5VSLAqMdvJR0C605/lwVw1+3/d5OnH4ISSC+WbmBDFam0/NLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(4744005)(316002)(44832011)(6506007)(2906002)(52116002)(6512007)(36756003)(5660300002)(1076003)(6486002)(8676002)(54906003)(66556008)(956004)(38100700002)(66946007)(86362001)(38350700002)(4326008)(186003)(83380400001)(508600001)(66476007)(26005)(8936002)(2616005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1PS039pjfQeeq+yb0VGXTnxdTNWzLODdhXlChUrQBRnN9T/uONGsJUvKaYW+?=
 =?us-ascii?Q?q+waqrLm/5Q+ASwUUMhagNChIum5lCa9vbS/iXwtbI7WI+POPrIEVdMyq4a4?=
 =?us-ascii?Q?FwJaOJGuSFdk4omPKcMPznNlZ2YVThDYTh24vp7lHrwTVQYtHG1/8g7Y35es?=
 =?us-ascii?Q?nVAd2e6fVJtBiqMH9SFP6MJPpfPxfu054cZVLgwbQVb//Yk/1FWrLd/Fku9L?=
 =?us-ascii?Q?bFTXzV2oz8ozOmIJrmSx1uauvZT9tXCaHYpKwqGQNdSA450jI9bkaGooNal6?=
 =?us-ascii?Q?EEEnCwbdvHFtJaSxlfYiP83KFFX7RAboc2VOqykVszEoqoGyYF3Ku2mbO/dD?=
 =?us-ascii?Q?W03G5iXLdIDogtEbnQzCAx7G8d7ZIgUO/b6gHkiu2ny9xLxTscvjY1iThEKA?=
 =?us-ascii?Q?WCdcCryNWEMYou5W7uM0bSAG7SKOi6xrHtvL3CKY42S70z3Bn53U7O8G/OOE?=
 =?us-ascii?Q?MlOm5G2se9o+5aoMOnjTRWKXHzTkFk7ER2TKEW5Lq2pKE7Vn/mnx5tJ+v6FL?=
 =?us-ascii?Q?f9NgKzxJzrFgGaoMsdzpAObWjcEtfxQGpBDLUMrjkH0WgV0Nnu1h956sOVQs?=
 =?us-ascii?Q?t8ZmreDZrC8ahFQQFcFqG0hga24JkXbkqXZ12mMaa5n/WAqqFml+N4+GlvFn?=
 =?us-ascii?Q?rRUScgyGaIwqnUCjCvJdcRjI5OvaeAKqQo6hNkpmqYnmq3WGEUZMe3HhHRRt?=
 =?us-ascii?Q?mzW508tPpxtV5nlCtQTuE+fwsReTdvkDfkLJz79V6ekSVTEbEEllDO9DDaPq?=
 =?us-ascii?Q?Z7xWOn63tRcd2rdaMXBu4f8PXBYKwJWZdsW+x9PHn4JuevEBNVLELbdENYOv?=
 =?us-ascii?Q?iITITlC4KwvQKffzfHFqvx3XdRNGv0Xo+jpa2WUIZYdnxCQM54wDt/bIhHOh?=
 =?us-ascii?Q?JBFqH9sv4NW9YcPnG58m3QdJ+whgBH95tpvmKNUGjjsBwkNtaD426ZTo0aIG?=
 =?us-ascii?Q?gQSvzS9YG+bNZzd8SUx3GHSLIoBQD9hH5u/BgejIToKasMHrXI4WgE9PPWwi?=
 =?us-ascii?Q?HhcD8HUmQuN4lYPOIZOPvikGsxucephyL2iIp7UZzh0dCfLQzlvt6vhl85uc?=
 =?us-ascii?Q?xHkgHPz+aZ43hmNMeGdXIRcPp0hzi9tVJLzZuReK/7/gMOUYKHl+Cn9q+fRV?=
 =?us-ascii?Q?bJBneDGd6wWD82KgiPAUOCFIkbfZeM90AvPbfdPQsdAu3bEjnRfRyRkZ7c3a?=
 =?us-ascii?Q?CIiZfb/EvExJ4RkNb50g1SV0mYOVEfmgQNDPe3po9IC+90RcwUgDdtV9o/0v?=
 =?us-ascii?Q?Nuwm220MVjcF+DmAdyCiJMZeG8ckDrkRplaRGUNmb7LliKe2uSzkBpcARcaq?=
 =?us-ascii?Q?94Erg1Jn4xSNtnsaSQAS8lUu?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ac8beba-b5ee-4318-fa30-08d97ea7d43a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2021 15:35:53.7167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tuvI4wC5WLB0nqZDK2l9w5PFeGlOcPQYG+VKedjbwpRSNlsdBxCwaVlPTsCNetd6TevDxY6xkgKy9V2lkecjrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7471
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since both forms are accepted, let's search for both when we
pre-validate the PHY modes.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 0b1218a519fc..75db37eb5fe2 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -941,8 +941,10 @@ static int felix_parse_dt(struct felix *felix, phy_interface_t *port_phy_modes)
 	switch_node = dev->of_node;
 
 	ports_node = of_get_child_by_name(switch_node, "ports");
+	if (!ports_node)
+		ports_node = of_get_child_by_name(switch_node, "ethernet-ports");
 	if (!ports_node) {
-		dev_err(dev, "Incorrect bindings: absent \"ports\" node\n");
+		dev_err(dev, "Incorrect bindings: absent \"ports\" or \"ethernet-ports\" node\n");
 		return -ENODEV;
 	}
 
-- 
2.25.1

