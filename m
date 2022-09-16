Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B30A95BB2AF
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 21:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbiIPTOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 15:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiIPTOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 15:14:07 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2131.outbound.protection.outlook.com [40.107.92.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B15B69E8;
        Fri, 16 Sep 2022 12:14:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TYFWIIkGnLv7eF1ReXqoBJZLurZd/TC5I+LZyKZjbxeONU5B/0cUZZbehAypGn9x/D/mUZcQlKb4gtVxD5CIBQGtk/0pQLSwFX617CuVt+RYnehrPo8cD1cRQqE+N75Z1hz+1hr9VDoB0EjAc4dY9f6fZYmTkactqlmcduYXjyIkP4WLyZmrbvmRfNSpb52x4mBH8tC1bv7xgmAz1p7V6IIeBn+NaUVlOsbkLgfHUJZnnwpYLLAhB4ssPVh7KRiE4qieqyvYAq8Y5ugXUERnso1OSWl8GwrINyGi3kk9kQQ3psR7MOCc59gBowkvTZZ72DlbKphPXJfZMJnM24cVuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QQJtY92j5G31CJOHMSXKNG3/wl4hoIXt7ILl9pSfxLs=;
 b=kfBrqdhpB4Axig2gS//x+Bpaah5vkFv1qe1JFznX12w8j2qBpZxJ2b9YrHDRHlEBLZVQK9P/eMimIfpYtkWzYoXe2Vv3jEA6fYaEm00+IZdllWTJP8/fuPFp0f1hQ2zE6fanl4z1qHeHo7yzsZLeAvAgQaE0STgdfZ1S+l0Qv4w+pNbAUkbCc68V1qSQ0WOH/kditP2Ty//fbG3XTOHjeLuuhEOdBWhTWH7ZoCvZapVFMVqXxiwSBEHVO//ORURR6H2arEWBW7Or2HBDys4QWCSyv8hKfoi6vBv4aGkYmajMsgJcnZj0bXdunBvHG0+FS6VjU9rxa6f+RP89Rxg9lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QQJtY92j5G31CJOHMSXKNG3/wl4hoIXt7ILl9pSfxLs=;
 b=FgTD8B9BGRIZZVC5Y+JcJUiBzYi1U3E0TpXIQUpCuOktpU8Ds4xgPr1d0YgRlZD57mdyTR9wEK9HwEURxHJolnJxm3x7RsFySLUp75Ff+xInZMhCFYlFyKIr0g2MA375U7ff8/1QfWb7LCbi0PwEYkFtwJylLt9wLzxwtmIHtwk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA2PR10MB4492.namprd10.prod.outlook.com
 (2603:10b6:806:11f::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.17; Fri, 16 Sep
 2022 19:14:04 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::dcf2:ddbd:b18d:bb49]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::dcf2:ddbd:b18d:bb49%3]) with mapi id 15.20.5632.015; Fri, 16 Sep 2022
 19:14:04 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v1 net-next 2/2] net: mscc: ocelot: check return values of writes during reset
Date:   Fri, 16 Sep 2022 12:13:49 -0700
Message-Id: <20220916191349.1659269-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220916191349.1659269-1-colin.foster@in-advantage.com>
References: <20220916191349.1659269-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0015.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::25) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SA2PR10MB4492:EE_
X-MS-Office365-Filtering-Correlation-Id: 43b3784a-0cb2-4339-d24a-08da98179d92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: byg+NZKnIrwPcz6Gt3gpuOlv3HXpQatHB9h2i49ItldO9m9gNmB/FJWuq5+FMff6MOng4PplcsUdnQxB/PAKZaR26eR6KsxumMKCCBFr97TGsQG8bwa3ogbGKwogHiSAbCzc8CW1JAWuGG1ZrjhvS5y2oNKe2QFLDLN13ir21tEdu9kJajd7Z6qYhV12x67oN69BOZ/bLIRCoj5C1BP7ldaUeul/Cr0Vwuqzv4X92DOiSLkklarrL3RPVc5JuUiXzS+1KZYrXLoEfHrjl59KWB75UXMIZ5AUTU2QtbE11bBchHtWdzpFF9bLTh+bKWZ9TPmha+kDUhy1MtL0gniV9W9w6pyizv0YYdXQBWuN3CM0gTLo+1hWyccTEx71qJ9/zX0N90RN/qmBuVzoKVGmWhZ+42yzN57oU3SES4JHSKMjDkB/3pDSuq6jJZJK61ucqYbwkWjVCJUT88+cwiZ5lm709TTByzT+Di7vNbNHqfLm3KDWVkSBS34bIQLeF+z02bshBjMiFNykyVm7QdtFws3cZNVNebpFZzi8vv2eTCKNBVMgZzMcCW2GEDBJbfRw5+NgHz2Za/mImETEzVP2y6KTJRyahQyBRUiiz2hkda7TZpnt8i/5ArMhivHdmcrcijJfCtjouU4Vhccp+dQ1b5SytlZ8G/tyD+9Il6Ck5WwNvDEgj7iwOGtd4+MmMMAAwATB6rTqe/XEXiB8hYTEVx/9eaZ20YieX5C/baLVIYgIaLO2d9R980MzNrr0WXkXIh1X7V8WJlR3qx6qmjVZmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39830400003)(396003)(376002)(136003)(346002)(451199015)(38350700002)(38100700002)(86362001)(36756003)(83380400001)(44832011)(6512007)(26005)(2906002)(478600001)(41300700001)(186003)(6486002)(6506007)(2616005)(1076003)(6666004)(52116002)(4326008)(66556008)(316002)(54906003)(66946007)(5660300002)(8676002)(7416002)(8936002)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9Yx6qox14nM3SHaY4zGUxs/CdvGeTuO0APyxAvIdx+o3Hv8hVOJl8EVFSGr8?=
 =?us-ascii?Q?Qdm2JMK/pex7QGUhTEyuqmPpU9V1iciC4C6KFduj0DFU2ai//97igx/yCEhp?=
 =?us-ascii?Q?QpczCeQk3OKQlqW3BViJgDZcH97f0kkHnPiiMR4/lmFVd0JqvNbhIV7EYmJU?=
 =?us-ascii?Q?cp2/5ZbU7CWMlDvLQJt7pqRmBgcNSmUFUibQJdKgo3bjiZCp0Di4o9tTl4zj?=
 =?us-ascii?Q?kSdVuo1H//LKpMpzjA6Ja50PlYm07tB9YFjkYQwk1NKFosTQkLJrDEAkdcA6?=
 =?us-ascii?Q?L8Jr92vwn8cZ2/mq2E3jlx+iW5afWdb0NaCODAAkJHFAdseqoDRpqmS+7sPL?=
 =?us-ascii?Q?CrXFQUH6hsyWBB50bwq9wps/gA/YIlIgj7l/B4Xml5f0QbrMn+SXKyLoyLnZ?=
 =?us-ascii?Q?4DGVPctU67gTaWpYDoKuuoWrSKcl9E8EFCnRdJac49DvK9wp+kwxvB3FZUNf?=
 =?us-ascii?Q?4J8N3SuDA19YF0I4RQ8jxX5kmiqqaPcafYiTd2PAM6PFwAYndINEnk4KTfKa?=
 =?us-ascii?Q?SOTdSZXAvVN+iHHXXswJZtfB3Ks3uSthsbrEtL74ERJim6D95BH/Ae0LaHVi?=
 =?us-ascii?Q?gpUafM+3mVmQSLOHZoIkaJV0SqeIGrIy0FliLvDpdEA3x9qgLlJedSjGxKsI?=
 =?us-ascii?Q?QkHJvthJftqMSx8osu39kjL3D00IEk6QCjbNysCxm6UPSnurceOCWw8PLgRN?=
 =?us-ascii?Q?CEIr1izFnhrxmvXCEbijCDeJLO8eRoRAFw+KqP7GJEeTnMNEYDi4Ht0nfLGe?=
 =?us-ascii?Q?BBKlreeiGx+7qnsv0XPoxSOG5SD0IoVBHuqpYS4fpmlQP+GqLM0ROPW4T1L3?=
 =?us-ascii?Q?sL3ZuCBElSdcIG9c2NoCyoEYIeooPg5JbW/8T8VyqBv2VEJzKPfUW7SSLp6j?=
 =?us-ascii?Q?tNDAsSknYbdDEKsjbUefHtLa/NQobEWZ52EMs8Vu++JLac+E+55oV8APHppV?=
 =?us-ascii?Q?Jl+P3F2rNz7ksli8dhboIBUOwQZoLtcgrjsark/RMbsTCk41q1yy8Iu3bGs1?=
 =?us-ascii?Q?pLaAPOH883TBgkkyDKELJ9AMxoS5Hv0A1eViFnt2dIuUclQ4GgOS0vYqBWq5?=
 =?us-ascii?Q?ao9crRopVQhGRlVZPNUvugPp+lH3+osnBcUVgtZwfKVaJr0Y+Vd5nUXSTGnl?=
 =?us-ascii?Q?LzhD5LtU5f5+DjOklFXLFFFxfTCsl3GhugPpCJTyLZ6/G1Hd2RB16NJ8FJCp?=
 =?us-ascii?Q?mw5fAUvCulosaa0SqWVlnBBUSvhYsMj0BkAcZG3vB4I1zsJXAnLY+DZTu7kj?=
 =?us-ascii?Q?2oKF+l9nM/c1Au/jE8bfsxruMVBqCUH+H6WCx8oCgZjbPaA4lrIV01EJ/fRh?=
 =?us-ascii?Q?NzK9mDl3qAGj6n+7GtLS9anB4hBHDf1zxGbFjDzOWk1kxf7S7fpkRQYu4caA?=
 =?us-ascii?Q?RYFE2uUlCQxxObLynIC+Lp/jNSiLtnZ/fscno+zOWJR8QIUYDcI9XPJ0ovJM?=
 =?us-ascii?Q?ccTJDmzIdEME4zf/XkzYcy3yrU1H6qf8UyFUi3PG+5MSR3te1O1uezA1yMl0?=
 =?us-ascii?Q?PInsXuNQ1NYJ8KYL0X/mshJmQRBbG55HyvvvbZ7sKtgBsUJMXnICkpe+HUJk?=
 =?us-ascii?Q?DXqmWKTZ20biV1xbguoWqufshCHmFhMb6m0spA6sihyIb3rlFKbBh+VyebY+?=
 =?us-ascii?Q?AiqYv3wSicu71/KeankyzV8=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43b3784a-0cb2-4339-d24a-08da98179d92
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2022 19:14:02.3067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BqRCQtjYr3cNJ4xQJKvTwcV57aeQtQAWbc9sujK044fOEO7KFykAmtQXKm5AWkeUx7I3wpCnMsmpz5muuxjaDqcJy0s6jpCB0TXsA2hCc2I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4492
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ocelot_reset() function utilizes regmap_field_write() but wasn't
checking return values. While this won't cause issues for the current MMIO
regmaps, it could be an issue for externally controlled interfaces.

Add checks for these return values.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 79b7af36b4f4..415b7f4c7277 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -211,8 +211,13 @@ static int ocelot_reset(struct ocelot *ocelot)
 	int err;
 	u32 val;
 
-	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_INIT], 1);
-	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
+	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_INIT], 1);
+	if (err)
+		return err;
+
+	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
+	if (err)
+		return err;
 
 	/* MEM_INIT is a self-clearing bit. Wait for it to be cleared (should be
 	 * 100us) before enabling the switch core.
@@ -222,10 +227,13 @@ static int ocelot_reset(struct ocelot *ocelot)
 	if (IS_ERR_VALUE(err))
 		return err;
 
-	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
-	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA], 1);
+	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
+	if (err)
+		return err;
 
-	return 0;
+	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA], 1);
+
+	return err;
 }
 
 /* Watermark encode
-- 
2.25.1

