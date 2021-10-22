Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF5D0437B04
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 18:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbhJVQiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 12:38:24 -0400
Received: from mail-eopbgr140042.outbound.protection.outlook.com ([40.107.14.42]:5957
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233286AbhJVQiW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 12:38:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=befMDD5MgoyG+sj1gvXenQzJPq5rUK1jvFn0zqBpGaaip+NgzjFefpM9RyGwUeTUL3ixHPrQcePnee3tmje0SB2Hx9IVwikEGNFTe4s4x2vNSfgeJLQCYidI/YDYwvgI8AHZAvSGRfg4NpbfNbxveU97Yi/fq9MMgEp1dsQQjBkzsAEICWUgOPQ9c/vRlmYdDN9WI9Z336lkc32ADtlibbIKA0P1RzcyKukBDEDCLGVvRbmFth3trpblmqESO9Mpfm1+VbQaerMhynClEFlQeuipl4ZLZ6DuxI5eOTGuMDTVoKFcM+fLdxh6v6P4jikzF1ualCnZER3w3iQXOhvxyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cs6u1U73+C620clvNsnEjmWMLA92QYcErv3CdrhFQ8M=;
 b=FGjkJIW4hpcp3OCU2a+IErTvgVInGk+u5DBWZ4gu0WdBb226mQI5uHHYO4i5GaXVYBH/ipglmMRRIUuzbgZvcrsCYTE/nzIJPjzeRYYZ754kqKBCJD+6QfdQcGiSzh+7xmHvphOAmEIthf/sMGMt5FeaWrh4jpPU5y4TymcLT9/a7Dt7+WxRdVpkdPNqQVPS2bKKHQBfB4Wg81e5u3XS2na87X86yoy6VJ3ucb7zmiW598/NNFbioB6MRnlGngb9pGkATTMsTYTxAgyDdHYydqImk1S2K3e3HdYCKBmLzCMyzKU6iFoU9R4UtWAHjY9VuIA4d65MOYUn9QiIRUI1lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cs6u1U73+C620clvNsnEjmWMLA92QYcErv3CdrhFQ8M=;
 b=M0Ui6dIq/bWsjPHTIhwITYyIMeeSujqAmRloe4qlwMsdYXcQyxQVJiOo/aY1yOBmhTXLuW7DPi42Kf/vKiGopVVwzCOMIJJerq2aMUBdDtEYcx3hmlYJbB8oToTUUEf/xWjsHBbBcfIM82OABKhKHGgxivXCCVYb/HF3fuT/fVs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB9PR03MB7418.eurprd03.prod.outlook.com (2603:10a6:10:22e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Fri, 22 Oct
 2021 16:36:01 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4608.018; Fri, 22 Oct 2021
 16:36:01 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [net-next PATCH 2/2] net: macb: Use mdio child node for MDIO bus if it exists
Date:   Fri, 22 Oct 2021 12:35:48 -0400
Message-Id: <20211022163548.3380625-2-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022163548.3380625-1-sean.anderson@seco.com>
References: <20211022163548.3380625-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR13CA0017.namprd13.prod.outlook.com
 (2603:10b6:208:160::30) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from plantagenet.inhand.com (50.195.82.171) by MN2PR13CA0017.namprd13.prod.outlook.com (2603:10b6:208:160::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.11 via Frontend Transport; Fri, 22 Oct 2021 16:36:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 79c56583-e3fc-49eb-e250-08d9957a086a
X-MS-TrafficTypeDiagnostic: DB9PR03MB7418:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB9PR03MB741860EA7A5E8BD6E4E4A2FA96809@DB9PR03MB7418.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1751;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wg4fqpkA+YeCp7j4sMLplJDMTfS9+4FjlTvJBEczUS6fbK22k0ieaOkOmSCn59EjRLu1tTmFPosWXJbD4xxhOe3IXtOBdHMUewmtkXVXGkSHOhsqqDFIg01J8MxnLNKpD2zJllMpJGNs7ozhrKxPxxmYe4I/i+T2+PjFtimWvf9hVhBbsySh9vpO8ODI7HZuJPRzxx3LYk+FZxRE4UNTtUSkrEsC9UaFswZc6dt9o4JCyHHPNIMPZ7cEcENnGGKt+2m4MyR4EtDd4kVejqNYH2r0UpOKbdOKCTxruxxBItUajOlAiydNc+1mfUTjb/3wW8dpmCGZj3uUguQlgLYg8Vr2YtJG0wl40TcFAmD2W22sKr+fS/XMNiHfFpODcOQ5eqP8xGPPtTqv+eJp9dRMREGZ7LLtUVkAWHDofCRPTqoEFlULMd2nBtXHqAR9yi3QzcLPNkW1zTD2TBhFPSH+kOjmTi0goDmjIlVhuhsa27TeopPqybxgyUsvqVgsxhJg4ZhMw+ncCp5jd6IJJvIl7+vTNUoRdyV9sS/MxFc8JTMlyBm6vw/5L+KseD1UMNzFVUU5ILL2/3UC7/OmWC4s7evG3EoC/3gscWoMX+MISaf7pek8KAwfjAVAbr8giNsNPqY48jDGzyUQEBs7iU3fL6j76bjxEK3zmBOyeFU1agxWDGAwDeuvzl4hd5zu1ujEZxWEorieCnHyyPWWEaoLzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(956004)(8936002)(508600001)(66476007)(66556008)(38100700002)(38350700002)(2616005)(4326008)(6666004)(1076003)(6512007)(5660300002)(4744005)(110136005)(54906003)(36756003)(66946007)(86362001)(44832011)(26005)(52116002)(186003)(316002)(107886003)(2906002)(8676002)(6486002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?24MCXtyDyiktnqrIEHVxdneFPlS8VM9bL+QWmpKaV+oRvW3Inf1eBh/Sgj/Q?=
 =?us-ascii?Q?sOmyBWvCBjke4trkCxHXSA/k7xc7ybX3XKbJ/mGfFgLJI7+NZugUUne7wQ3C?=
 =?us-ascii?Q?ktJ5IvkmyqLN1RiCjaOOPa642rFzaXtpG7QxzGHE8AuyA6yzQ4eTsbNWXNBZ?=
 =?us-ascii?Q?D/0yj7AjP9kTEXrkooWhKoCFTjny6dsB0DEbKTp+3rmTtwlBjTDecO2FmpOb?=
 =?us-ascii?Q?QoKIDK1HhQNGM++zkvKd08IaV7AHRkD8tYrRBTsX2MoYPdOgUvYB1EKWBuTZ?=
 =?us-ascii?Q?urInqxPYh0dShoNmzdOYV6H8Wn9oa+LSeJFAUjCT/NhwdL9jvkVuU58d+XXN?=
 =?us-ascii?Q?OYstb5Y1TsFIe2CBtp31hp4bDUSlU0YCM/DOVbeFbHqPTK50ZpfsFNeFNqP3?=
 =?us-ascii?Q?0NJPHLGdnOWqnluExnIQB4P31rcEigYq3pJFJ3CdkV1ZTSBewi3G2hOmt7gG?=
 =?us-ascii?Q?Z17a9VMoEoQbV2SPR3VVTOk7Y9Itbg4PgiDO+qM9RflXxve/kor5lk8Z+3UT?=
 =?us-ascii?Q?EVMT1VDUyc67hnjqCqL5zhOCd5taNH9euksv59d0+EnbZ72sm/JAZ95pruME?=
 =?us-ascii?Q?cY1SdbUz9egWOnAmSeM7cXlmQFnYwBSUZUKQFlSHHIyTmJFvFvsJMwXazs8c?=
 =?us-ascii?Q?IsuaFD4C7J4dqbsszf2jtRjIqtD8mM4yI+3GG3RQo0DaoAaLNWxWTiyRf9Pe?=
 =?us-ascii?Q?dtAkhvQVi1ZzBhEm2RyEEX83kUeDJ9m/gyYG48KZxoeV8sa2HAYVFxOhqOxW?=
 =?us-ascii?Q?9XvQZRRPFlJmHFP2JSq+jVT8qlZmETw8D1ljkWKFo8OS8UX5ZDa33qsZA2Re?=
 =?us-ascii?Q?QGuYqQ5Na1AANVEox33/liaJR+CoAQPe7WwmBv1ZxK6HRHVjvzPXZM+tpesJ?=
 =?us-ascii?Q?3SiHa/rOFtvctj5pdXm5jQvKnGQDKeqEpUvx7CoCXvGdSnYtV8PK6cCWAVmr?=
 =?us-ascii?Q?fwUxI0xkks6fqQeScrRKGMwOkfw29amiXp3PTkVZLodyE6mhOsY7dk0588P0?=
 =?us-ascii?Q?/YKxN11ElZNvPUlQ8HIrLUY07Gn5qPJUhQ+UA25WbSc1c5qV78PSY7ecLUww?=
 =?us-ascii?Q?9OhDBj26qKzjkJNfrMy0J7o4N70kLgZ6YOT30ItFR2kADECArUmhxpQVR3wO?=
 =?us-ascii?Q?8VCJdQY/QHI50fg+dZeF1GrJgS/eBu+ME2dhhpxuWhkYFDjxLeIHMhnDTQPM?=
 =?us-ascii?Q?pDH7Ql1LJMjA47aS/qWSMEyiW5dWXb88r8UkUV6Z7fqqFOCm6L/puVIxxOVt?=
 =?us-ascii?Q?e3DgELnS8sSyeve142fjWDrihgwoHWGqpyx/C0WWmPrlEbbFdjfFX+/VgJ5r?=
 =?us-ascii?Q?ixu0AYIHOOH5HqhgDlnbcqDq?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79c56583-e3fc-49eb-e250-08d9957a086a
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 16:36:01.1385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sean.anderson@seco.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7418
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows explicitly specifying which children are present on the mdio
bus. Additionally, it allows for non-phy MDIO devices on the bus.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 drivers/net/ethernet/cadence/macb_main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 029dea2873e3..30a65cac9e87 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -898,6 +898,17 @@ static int macb_mdiobus_register(struct macb *bp)
 {
 	struct device_node *child, *np = bp->pdev->dev.of_node;
 
+	/* If we have a child named mdio, probe it instead of looking for PHYs
+	 * directly under the MAC node
+	 */
+	child = of_get_child_by_name(np, "mdio");
+	if (np) {
+		int ret = of_mdiobus_register(bp->mii_bus, child);
+
+		of_node_put(child);
+		return ret;
+	}
+
 	if (of_phy_is_fixed_link(np))
 		return mdiobus_register(bp->mii_bus);
 
-- 
2.25.1

