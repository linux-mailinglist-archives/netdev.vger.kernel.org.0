Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB86242172D
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 21:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238913AbhJDTST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 15:18:19 -0400
Received: from mail-eopbgr50077.outbound.protection.outlook.com ([40.107.5.77]:3542
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238724AbhJDTRq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 15:17:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XxjqSql4yruz6A5gAaKOZUZRExm+cXJNCLk1a96tOnI74IiwgdCYu6NCVjZxw5Qqj+INo/OWVfw9gXw0yCp7GVdtk9VPTa6WkQF4tqIYOF3h3nfQloEIpmL8fF2DLs3qLE+VSIALaDxnendH2LW1jNPHmELetzkfaJXiwMvQHw+A/i2mK/x8qkmbZ0RnzvOJ+lmXRuOy4m5lobVQHIqkLmVtM1u0EivDLzbBFZMvBV4mhXzNqhdJfoMQgxDPE1M+Kr1RdEv96DgM1OgOkLhBA6UTkFD0zDg4+9F8Y2d2UIQYuccMD2jqjgXA7SZNpB+jJyq4zu3CSrL1PBGgwEpyKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LKZqJ0sgev5MsfQyJguFFctJotHX/1i6njJFjmv6XtI=;
 b=AKVRSdM/XLz1oL/lFV76A5a38yZeiOuxhxDX2ZVhR5w/AAtxFuhjd8jpbrhkHudqKBMxXiFVZWbIH4MX8O58WvXgZiNjRWyOwFSFp02LNYWZd+x5R1lRHttuesMrMHLs2UciS/R8CN72MfYiF7CXw1XHRsgXbz/407M5leXCAfpWMEI3IZQsrNYuwPgR6Z76K7RvdSOLh7w7+sERAVVTZGiZAPQNkQGMcIOdiN5+NxkhkebXqfQTRO4Z+V9YnTpZyDSLEL8W3MAlM7URu/D0s+ics8uxyK2HBGqJBb8hT29UMpx10okevrt++H2syCB7afQqEQZtzU4ZRJTcHXiYbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LKZqJ0sgev5MsfQyJguFFctJotHX/1i6njJFjmv6XtI=;
 b=lw9tS1A6VNRRorLUU95VJvLPCo+/sEjpbUCJmClm0v8emlVoZy3+eGttkwO5a8wjluBNiFoAID1qZoFV1UbV5dTjEqnpOzJjSXukiHLvd5D2pgjSMi6GjItgu/hFSFI18ZoGFnuM5cQVAoSmbMXumCLQMwWXyrHik/slMeOhJE0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB9PR03MB7434.eurprd03.prod.outlook.com (2603:10a6:10:22c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Mon, 4 Oct
 2021 19:15:53 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 19:15:53 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [RFC net-next PATCH 04/16] net: phylink: Move phylink_set_pcs before phylink_create
Date:   Mon,  4 Oct 2021 15:15:15 -0400
Message-Id: <20211004191527.1610759-5-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211004191527.1610759-1-sean.anderson@seco.com>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0023.namprd08.prod.outlook.com
 (2603:10b6:208:239::28) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from plantagenet.inhand.com (50.195.82.171) by MN2PR08CA0023.namprd08.prod.outlook.com (2603:10b6:208:239::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17 via Frontend Transport; Mon, 4 Oct 2021 19:15:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15c1e49f-3457-40fe-5aca-08d9876b6256
X-MS-TrafficTypeDiagnostic: DB9PR03MB7434:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB9PR03MB7434C46203CB57B06B7F9CC596AE9@DB9PR03MB7434.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: elTd1vd9awL3MupVhmSjZWxwKB7Tte1VlBW3RvagR4s5FEbOGra5gHwvyL1wxQIhZ7hCWNT6yKmaNP2urI3TkMQMCqWOI5lUEZFTmhIEQl076+SlHjeOq0dRX50AXCipgjnn2Nu9Fw6rHL/JcKGGcNKPxqzOGag6aZ4/B6Gm+OxB8k3BFvdljkz7epklt2sQAj/BJHRpKAfGfT01aIVwMAAhXc/mtM3AHjM+dO8Yx77h2KJWT5YnYOYeAdmslLWxIJI+nB0tDXDALlVfo3JVXJa/UHmT9tj+aga5wIkin/6bKTA6TZvChKMMRUg4MVNLQZs6OmUN8J6SrOO9woW1Z5L6YgtWcEqJAhYZuc4t3KJpgyC5pBubfWBTrsPM8GdmyDDjONR7MZMHRZEUuZaw6+R+KcRoz+wn2uO8G5SQvJDJyWzNZuEnP8i0kqmza9O08JAweaUTt2dGz9IYIbcpNTAPn8FOKE2qCbxFnrmGVbIrShFuUP9agl7Ohzs2JRbo3WpSwPbFSoFZE/iwOPjXoiyRpziZnQxd43YG30crJNyZs+b2IibpJm6jJfYWHCFWJsyPEoEb5Jt2AQCjgeaYmy86Y3yeeWBLMNJN2I2qGL9rO5EQ6Kbt+3fFGfZkfZHjy7j/ZvGmt4zUFeK9gXuqRCL5WczR32ZrfB704d7uok4w46puvnKR7WhLwopOQ6nxlUKyWmIxXoSZTteVAqEIPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(1076003)(86362001)(4326008)(44832011)(6486002)(5660300002)(66946007)(508600001)(38350700002)(83380400001)(52116002)(956004)(66556008)(66476007)(38100700002)(110136005)(6506007)(2906002)(186003)(8936002)(316002)(8676002)(2616005)(54906003)(26005)(6666004)(107886003)(36756003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wXsRBc9Sp2ejMue515ioy5MiSm8SRtp3zrowYzgAtIX7gkTHNsG+xiv6vFUN?=
 =?us-ascii?Q?7Bs/79TfINnBEvJiFTB3hcr/nQmrvOimZjrczudMG5IKj5XbmFWNF1zeGR3D?=
 =?us-ascii?Q?8ORzxQJYxH1RXB2DH8ck0NhsJEUFk9BTDG98YXbBGX8HLMlwqM+WavgQu3yv?=
 =?us-ascii?Q?VX7PxHGWSszn31wvIm+WEjhmRWj7yFvLRtSq0ZmGWyj62kMSSMFqR090iGlv?=
 =?us-ascii?Q?u/giLrS/F655MDGmklj/pM9vzLcRy/yy3LeNa2Yklji6NIICoH82Mr5uUOIW?=
 =?us-ascii?Q?PeiloyDzcdSJl2noGDOLmYCxuW8UtWklRaAvm4putJ9AwydMlAo2rDmWvZaN?=
 =?us-ascii?Q?DKqp9zt573kT0goZEVnDXaa4ItNEMfWbJI21f1UNuUIm87Tyo/ixKtwnCec9?=
 =?us-ascii?Q?DHsGokVFZAKvuEBD/n/huTwXdl79JKyods6PQbFZ9LxH9QMQNa6N88H9h7/6?=
 =?us-ascii?Q?UlF72rEfIbDWubFee33PyyaCOQ624MMkiUOtSgiqtgp8WsonOQUGYkGHLFUT?=
 =?us-ascii?Q?WetTRrmm0L49Az2NCsRMcOfRSISz5KSNVbGqCOmJiIh66umtmUXsVNcR31/8?=
 =?us-ascii?Q?59CXlbeNxhVQvuwB/P36b/yAJen66Mn4h+Wg76ABwZ3u/pmzM39h0kao41+X?=
 =?us-ascii?Q?DKukApMhVIvQIpmJnnsGxcqnIfbpjLavip9uiJY2S72KBpoyxLb9G8ZAGazX?=
 =?us-ascii?Q?4+aeE9MN2poNHYM0XmB5t3Yw8bLMkXg5pi2XovWjXohvc4WXC9b7OkVNAUi5?=
 =?us-ascii?Q?OES9kwdp0tuJPJUZ70t2U5NLTVGAoGguzbYelHlqcMfGrcffR+a4OR6BqEMv?=
 =?us-ascii?Q?dR04kXfTOBDsB//u+xShedO9BAAH532r0RiSzmQf2S99i/h5xs08HJ+xBAbR?=
 =?us-ascii?Q?Jhi4OZd8QF8m4N3TmdYY+zeMWz7+gr7IhIHgS2QKgnS6pdOYWSxXUhAOUu40?=
 =?us-ascii?Q?UlDhbmxHFGGBzOSPOXfy5zTdUfCwMfE1MHL5ypQUqh+WbvuncYOZuC7LQ5V7?=
 =?us-ascii?Q?vCZvgYiRCWo3P5G5UwjVSLaekenmVYzEbLRUvVUpndi5AGmVoEYP3WnNTV7a?=
 =?us-ascii?Q?IpE965PbzWamIvXQYCQsEgp8EKIK+la5wQzoyeh/9Nn3jcOD/M8kZwu9sRey?=
 =?us-ascii?Q?WgArqrxVkpQPZYA6YE4CDwDODJL3AuW70LmvnLYEN0TB6kZn8odbyMeFXP4a?=
 =?us-ascii?Q?2sKFPtJKKnk9PX89ZsI9adqNpj0wT2uytft756hKE2BDytuPhCBHqNvQAqsP?=
 =?us-ascii?Q?/BTD7oHDrtkqG92iSbRs6e6AmeElu18HYqowufg4U5f2k6eBucqemKl/g0NM?=
 =?us-ascii?Q?uObYw4L0EYs7Qm771tE+G1dQ?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15c1e49f-3457-40fe-5aca-08d9876b6256
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2021 19:15:53.1561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pXQhCOUowEt3YVCFJRmHCYzJgIUl2XH/fjkvoidt895hZaOgR4bon2LzTpTRPJUpKdlfidpHYN7zhWy5ahXykw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7434
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new pcs-related functions in the next few commits fit better before
phylink_create, so move phylink_set_pcs in preparation. No functional
change intended.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 drivers/net/phy/phylink.c | 42 +++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 5a58c77d0002..6387c40c5592 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -795,6 +795,27 @@ static int phylink_register_sfp(struct phylink *pl,
 	return ret;
 }
 
+/**
+ * phylink_set_pcs() - set the current PCS for phylink to use
+ * @pl: a pointer to a &struct phylink returned from phylink_create()
+ * @pcs: a pointer to the &struct phylink_pcs
+ *
+ * Bind the MAC PCS to phylink.  This may be called after phylink_create(),
+ * in mac_prepare() or mac_config() methods if it is desired to dynamically
+ * change the PCS.
+ *
+ * Please note that there are behavioural changes with the mac_config()
+ * callback if a PCS is present (denoting a newer setup) so removing a PCS
+ * is not supported, and if a PCS is going to be used, it must be registered
+ * by calling phylink_set_pcs() at the latest in the first mac_config() call.
+ */
+void phylink_set_pcs(struct phylink *pl, struct phylink_pcs *pcs)
+{
+	pl->pcs = pcs;
+	pl->pcs_ops = pcs->ops;
+}
+EXPORT_SYMBOL_GPL(phylink_set_pcs);
+
 /**
  * phylink_create() - create a phylink instance
  * @config: a pointer to the target &struct phylink_config
@@ -881,27 +902,6 @@ struct phylink *phylink_create(struct phylink_config *config,
 }
 EXPORT_SYMBOL_GPL(phylink_create);
 
-/**
- * phylink_set_pcs() - set the current PCS for phylink to use
- * @pl: a pointer to a &struct phylink returned from phylink_create()
- * @pcs: a pointer to the &struct phylink_pcs
- *
- * Bind the MAC PCS to phylink.  This may be called after phylink_create(),
- * in mac_prepare() or mac_config() methods if it is desired to dynamically
- * change the PCS.
- *
- * Please note that there are behavioural changes with the mac_config()
- * callback if a PCS is present (denoting a newer setup) so removing a PCS
- * is not supported, and if a PCS is going to be used, it must be registered
- * by calling phylink_set_pcs() at the latest in the first mac_config() call.
- */
-void phylink_set_pcs(struct phylink *pl, struct phylink_pcs *pcs)
-{
-	pl->pcs = pcs;
-	pl->pcs_ops = pcs->ops;
-}
-EXPORT_SYMBOL_GPL(phylink_set_pcs);
-
 /**
  * phylink_destroy() - cleanup and destroy the phylink instance
  * @pl: a pointer to a &struct phylink returned from phylink_create()
-- 
2.25.1

