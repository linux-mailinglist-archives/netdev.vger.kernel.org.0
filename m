Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 621F646DCAF
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 21:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240036AbhLHUJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 15:09:48 -0500
Received: from mail-eopbgr70087.outbound.protection.outlook.com ([40.107.7.87]:55236
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240004AbhLHUJl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 15:09:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RCqlGxbnx7AG2c5ewk+loulh+7KP3yaIhi0VRKIuv4x+pUEz2vXF7zeiHKR8CkvVU7QvTdtQbESx+bN4tIckseb4irqzFTa+wOA3RfIRiADjiHxcqPlwJVr1vn0qlGNt8PV+Ms6Uo1sWyz30Nd4KpUXWmNa+g0ifNw8RbGXM7a27QajpKZtyKTz0sCxrhm9jX6Plt1y6L+xqHyn5w3zzdzsxyZHyTz16yN578SUrSa7g8DAy3zxkGm7VCnaL6vM8bTVMGP78C6OipIQVO7AnfJ359GYBdBWzxV3PLHe6ETvTIGK7//faK9Mnwca0Si4b/+RqZCWktn1Ht92tk6qi6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+RkG/X5v0iRoolPQoX6IEAtfiLOFgo781iOq9T4ddok=;
 b=jqet0weAR+c6VIifwjSZUliwdG0T9uiWldr1r+QASr3/dAYbURsDahgNwlAb8vsLXS8hjNgILongnEvB7pIBX9uwjsXAcO1V9mrBGaV70B3LCObSp4H5uUw9dCtGAYMktpuE0SVoEqzVfj4308XGBbWukWi617leiQ0QZhG4F+/O2jXCuFgTKuhcyx7rWTmLJiQmWI2DASVLz/xZ2Pn5Jo2vvRu91tMB5sYzT6Ax+TTaV7Xwo26rIbvnJ0hWS/JXgCKvCyfmGxkCCHmNHGhaVzGwWGKeifBLtwa8JbF8XdfS9VpB9WROHLhv/oEx50ljRBff5NJUov/Go1o/+pKjtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+RkG/X5v0iRoolPQoX6IEAtfiLOFgo781iOq9T4ddok=;
 b=OLETpcdNaStw4EDl/B4f8o3Z8XsSAjSBB1Jw75i1BBAmTphjQSMKl7eXOL6p0fIS2rrV08GjqsdUysOOrax4qzGXmU2kPgRWXxFXAHPh68QfgrkyuLfyD2nc+18YXUK6AhCO6uRQqBOzriqfQnoa/TGOwHQztwPWBnQSb/RgCyc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4223.eurprd04.prod.outlook.com (2603:10a6:803:41::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22; Wed, 8 Dec
 2021 20:05:59 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.024; Wed, 8 Dec 2021
 20:05:59 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Martin Kaistra <martin.kaistra@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH net-next 11/11] net: dsa: remove dp->priv
Date:   Wed,  8 Dec 2021 22:05:04 +0200
Message-Id: <20211208200504.3136642-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211208200504.3136642-1-vladimir.oltean@nxp.com>
References: <20211208200504.3136642-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P189CA0011.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM8P189CA0011.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:218::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Wed, 8 Dec 2021 20:05:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33b75380-737d-46c4-ff41-08d9ba8626f7
X-MS-TrafficTypeDiagnostic: VI1PR04MB4223:EE_
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR04MB422302F0F681DDBDECCB5866E06F9@VI1PR04MB4223.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5Mm9zQBhfubnGsBHXBChSF6//ETNlyjyy43M/FQ/yWVeBGHnSYY0YrxMWPgDSdgChQYu4BAa+N76gFzbcY8NzsAjhXf2H+4N2EJh9sNv1A4CaAYCDRo+7KolHCJ6n6kl7XglDTSJGpJVP6CPaTO4Jj60zpswrELqmrNZlwN7NwMQsZoBImiAdkPOy/DTJMOEhldozqRCIrDj5omSReZd6dIVc9MyGKKbdYqjWZWRR2CXvWr4CWSTLGwJZc6eQ1HBQulHQTy/YakZGeOeFuZrwHxHtcP0Xz5mY+DbngQFnYK9OqlP6b+0mCwrWdN/8h5R6y3VN6bB7CzeUqSOW8R2dakKEjRZGKj8P620fwwiaL9TOj/2IsKydsGocuK+JUmakjN1Vw8OTOloYLZ4FxgdcJOyC9nVtjT5PyAQ+dZa6XbPal2UW/t8y9VdSyDtrCGfzitdOeBXFLKbBtYRZL10WoT2TGjMN/RWjdkRpWrPQUIsK51vdp+0QmNng7fTiDBf6UUMfjg9NacUbz2rfV02Lqvqk/72Xz7SXYynLkl/GkkW2Y9dhm+FqimlU4UaCDJRFlbu2LDdKSPlBKdc3vVGJ6/Hyk/Yjzc6HF8cLT6MEtnMCwKciv8QL4dUOxixtLCt53sVk8pUmr+a1+PtpOjvKwTd7wrOahxcLbvobf3ilyZ6xvACityyb5kAjyxpsmlcdwwIzoW1hvRrr8npCuVAJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(2906002)(6506007)(66946007)(86362001)(52116002)(66476007)(66556008)(26005)(186003)(6512007)(8676002)(4326008)(2616005)(44832011)(956004)(508600001)(8936002)(6916009)(316002)(54906003)(1076003)(5660300002)(4744005)(6666004)(83380400001)(7416002)(38350700002)(38100700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1X0sgE0XLft+4qqMCWcfePk1eSQ2GxPeA7fqrdumsuCP6rPG8cimQ6bdBW29?=
 =?us-ascii?Q?21qswfmUqB5TcBJDqNFtuMirFA7tjq/XJkAhkGhChqzTSPrPUDoJ1mr3QI6m?=
 =?us-ascii?Q?piiwuT+NQZ4WMrDlrkr+pR7d0ZUuMW5lZJBSezjxe+T/AkM/YMB5qsYxvICc?=
 =?us-ascii?Q?Mksgl44uAIk3im0Lu/mj+aIK6ECMZsrt7rWwpK8LgOhMoHIKDFv7R0gQxS83?=
 =?us-ascii?Q?WDgDTvIgx2kWNbS7W0bQQaf3zvjPccdB4GClkte7hc2jkw7tfUl4CJBTCbKE?=
 =?us-ascii?Q?as4J1kH86M/dwv6jfYwwceORz9h+Tvt4qZc/HLWzxChljR9OCODH7f/ar85z?=
 =?us-ascii?Q?orSbbW1lhLlcrgc49qfU7MBOjZzEswqxYb/wfja9v89SRcU0TOmf5sINiQQ3?=
 =?us-ascii?Q?N4lChKgK/UF5bWQNxkkKqNK5QmYOMZgwWUSsRO7yZCQ5Qcg3RdgONIOPn2hu?=
 =?us-ascii?Q?cqQ32SDrmIiCX1xAJhiihl+6uqBOTWXm8BmIRMV8cqoSZRxOWxyWn85H7orn?=
 =?us-ascii?Q?r6o7bIUUQzeG7lRvTW7hmNVcyiprJR90tddXgEAih3pZ57QP7ykAqbMK5KO4?=
 =?us-ascii?Q?asYMRZtXB9jr1pAj4ROCsP795tn2yaIA+JUB6QIX2n+SfU8tib76O3fxIuTo?=
 =?us-ascii?Q?8AfCGazGtdPClnVVZz2Tq+Mn1opSuCUxyFlHAvwp+LOH2RcRJNQqwC4552DG?=
 =?us-ascii?Q?STAh860jAwcP31zRmMtIh6J4IR/Jyemx7p4T3cw3fvt2IUrNnwylpwjHEM+H?=
 =?us-ascii?Q?tWK267ppaNcsCzooPi3E/A6XIYwyAzZyo9ebA3JRlqxU08VAljnA8uTwP7MA?=
 =?us-ascii?Q?WDF87BDXgT5AJJAWNDjrxOs3J7jasbKX2bJx1p05KQs3ydnpzN5TiZNnkdBB?=
 =?us-ascii?Q?+wAg6Vf/SKiTKPIUN5nW3cpa7CcPTwtyZsdkLuqw8KuQXTXJgtVxdlJcNdbQ?=
 =?us-ascii?Q?EM109ebtqO9vOtKay2SxV5GCnNmT/eMB541ELNUvRVq99pOYH4Z1zNbNmieh?=
 =?us-ascii?Q?Ii6wCZG4p+7l37OClroQ4dN4t9MRyoTVgO26xWsW+g222waCckvnfKSmqyYx?=
 =?us-ascii?Q?COy2QbJ81MmuvBPVcX6Dc/V+OpLWrRFT0SRWNxUMfoL3iYnMJaCufUGUHELR?=
 =?us-ascii?Q?86DNj/OG27WB7n6ERtCy5RnLRYLniyftVXQBIvUIJ9Xe85Dp06INuEFUTh5V?=
 =?us-ascii?Q?X5oHXHlPDOjUE/FpiLaEtDxXhaa5vXK29f4QDcfX3nMRYTFOL/aHOT8/B67U?=
 =?us-ascii?Q?ljsY3KPukz9JvTXHxEXpZbixYueSl6kHIb0AdROyxGs3YtqEK60Yzv4LptdR?=
 =?us-ascii?Q?PodkMiilChABC2VV56pty8Di43zEPIOH4x2IuaGSpF+qMZxodcpyqIbZmBQL?=
 =?us-ascii?Q?IWAgW1Sf8hWg/ybYhaJF+IjG6Cd1Ko1hYvkrLxukbb9Dv1nC0TgZXMYCLMsw?=
 =?us-ascii?Q?7eqFdnVSZUVXwKMHZdGrv0V3oOkCHuDf7+Myue8Yj8HCgd7QPjjBEbuTYSMb?=
 =?us-ascii?Q?u2jJRONldRRnd6ZZaaFq6VW1MPD5XRVCNhTGdMt+v+QQfMEB344aD0jZGeOD?=
 =?us-ascii?Q?HLQdL7jcx/roXeOz1WdP3XiBN6zciofmQowAZdVdzX6Lte/b0kqiXX04MFPs?=
 =?us-ascii?Q?YQmbN4I8JHiRxEOhob2mlyk=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33b75380-737d-46c4-ff41-08d9ba8626f7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 20:05:59.3369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IE9uA+48RdKycvtgoGHtY+Oy1AcDhdtMUf2xitekR4SJINhgrrNvk1+Yb1HhColwHxcPRzTJ4291NcB9eODn3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4223
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All current in-tree uses of dp->priv have been replaced with
ds->tagger_data, which provides for a safer API especially when the
connection isn't the regular 1:1 link between one switch driver and one
tagging protocol driver, but could be either one switch to many taggers,
or many switches to one tagger.

Therefore, we can remove this unused pointer.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 8b496c7e62ef..64d71968aa91 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -276,12 +276,6 @@ struct dsa_port {
 
 	struct list_head list;
 
-	/*
-	 * Give the switch driver somewhere to hang its per-port private data
-	 * structures (accessible from the tagger).
-	 */
-	void *priv;
-
 	/*
 	 * Original copy of the master netdev ethtool_ops
 	 */
-- 
2.25.1

