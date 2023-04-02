Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC6C66D37E0
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 14:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbjDBMiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 08:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjDBMiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 08:38:20 -0400
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2071.outbound.protection.outlook.com [40.107.247.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C8889740
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 05:38:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NiffzvOWmTy5DKF3ezNoFTuToIV3du2urA+fg2ZbNh9ytp/U/JThJr7nuaeDMDCNyO3vRutvq+Ta7SDg19vkcB0iO6yEyTXGD/tLTZKcYMHzag3XNIu3zhL8RacXDCE26Yu9MxSFQSXgNAW5tCjzpdr4rzG4cqWW3I5sKFTHkISYfi41D12o5yrimhOYGN5wAp+C4YJ4fFYWim5mFcyLpXQE9sJXb2F6iYsHSCtvjNlaHwsDPoKIhv6ojUN0oPlCAlFaLy1Vii6ieq1CTGrBui3p2ukEarU+APbdl7uaPg5guzx7QcDnQtqwpMp4aMthkgOGXFEHuQ+of3jf2j2dnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yAtuOgQZ8gP2z4Snp06w4GyQSc6lSb0Hyo7pkzukcEc=;
 b=I/2VYBhbyiodnZ3GBAUm1Is5e6bAXuvU7T+VwJT+BiYNuZtETmAvc5YyCNkx/689T0qxnyvXOrr5ajW2GBHOjtKL8we1G5q7RIHWPHo2eorq6w+0MPKw/9wR5mRZa0vx0EOR+cS3lTw3qRh4rCK21STeOyEA2kJ2xA04jl79x/zJjMPzYWEr0lViWEdswRFYh+Jw36WATzYTNrLE6gaLTL59zbPh1Nd04wK20x93frESuP6c2JN1twAy8eB6Sf7JErZhMNZQf25mEPf7eeMEXK3CN9FQcL4LpdmosGHQl9StvO7z8OJOfCx7WXcBsAAiZx3sFuhk7MqrutMrXThBAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yAtuOgQZ8gP2z4Snp06w4GyQSc6lSb0Hyo7pkzukcEc=;
 b=n0PQg6OdSe6wWzW6g/WBLgEqieh6tNwc88SE4KGBjFmT90zE0YFjc9r75VwXMrd08IvPOW0LNTkpSZZe3wPi5Sb47P9a+u7TUIXITiimgT/XBepagjKXLj8rjgFb7EpaCIlQ2aeYuMdRI0C5NfKKKY8UK0S017yRXpDYvjJbLR0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VI1PR04MB10052.eurprd04.prod.outlook.com (2603:10a6:800:1db::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.28; Sun, 2 Apr
 2023 12:38:13 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Sun, 2 Apr 2023
 12:38:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxim Georgiev <glipus@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        =?UTF-8?q?K=C3=B6ry=20Maincent?= <kory.maincent@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: [PATCH net-next 4/7] net: move copy_from_user() out of net_hwtstamp_validate()
Date:   Sun,  2 Apr 2023 15:37:52 +0300
Message-Id: <20230402123755.2592507-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230402123755.2592507-1-vladimir.oltean@nxp.com>
References: <20230402123755.2592507-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0018.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::28) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VI1PR04MB10052:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d8f6762-e374-4162-cb1d-08db33771f6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EhgejxNzoFA1Yb3cUzH2hWIZ5USznIsjwdKlsYznX3rNS4M2yEhZMA6R++8Ps47YFsgsTkb1J9U9R39ZPTL3hUMwwnSofc+VhdV2WOydbmi1VzcKkKXzs08QcMORDV/6SM9MTz6xgHpqafCqTJEu9zPhvF7RbVuMP1EnJ1mu9Fz4+leDGVIUprkkCG6+UBbaWwe2FVolrtntMy6yWsFzkLbEV4BIBa4TtpszdWQOzQNLmynNmTm25pH80FkHLgZwUbZDo+5YxOCPx4GGjjcijIdTT4wHpc6oI3SAjMhw4ilUK8AKc1/+/C9k6AmAxkZ14TMWWsczAoM+3EnRKrnwHQygRydvFVn1S/LPVVAmBtjPi0WhfRoRSHwMJHGPsbhcYxjq3H7GoLiwSmmq9y66+RLNjm/MF5CN9FMPmKPTVC7gCQXSh6t41FrvV44uG4vEQeBN5DzZqcZTZO/TNe+dFHlrAXuuoKEXel1tMA9b/KD4thlkFaciuuE+wCDcSCU2xv/s+Z4dnaYVbDetBDrIhr5hOgX9YF3rZqfZ1W02dOqX22dQFcD+VQRMvDrNeTjAjmOJuIFEJmnUSUpF8qjBkgncuqJP4sw+FkNmuZ5a/dURgK+o7/XXYyhPSi47iVEr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39850400004)(396003)(136003)(376002)(366004)(346002)(451199021)(66476007)(86362001)(36756003)(83380400001)(52116002)(41300700001)(316002)(66946007)(54906003)(6486002)(4326008)(66556008)(6916009)(8676002)(478600001)(7416002)(5660300002)(44832011)(2906002)(38100700002)(38350700002)(186003)(6506007)(6666004)(1076003)(26005)(6512007)(2616005)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jTFk0so2920Af9cOx3rKwA/AFI+nkfv4jnv5kz29HG39S2Vl7lC8dUI9D3Er?=
 =?us-ascii?Q?wpPJUH22D5n9v3YrRMxAHDnHSgNL17lDLlTxl4xO66iyYYY53SBmRnm+uwrg?=
 =?us-ascii?Q?Nhzm39wbvxEuKeQ2D7ufWBc5feZ7kpKxFvFSdxeWxzivn9NzI9hpC+yaKuH0?=
 =?us-ascii?Q?twWGlOnWSLflj6sKObB9Y5YFqy3r7ktcD/4tspYpuKA5giiWRzIEzvrlBwtG?=
 =?us-ascii?Q?mulAXuqa8uTXjy0Rqpj73FNy09XXbY4sX1/dYkMGH7OYJCLVMVJgXywaq+1F?=
 =?us-ascii?Q?BfKB/YzoQqcEhiBp7NpaPiY+sqzDAqb/iiqBp+s2a+FxMvkIHxbyLamaIOzp?=
 =?us-ascii?Q?8XIBzMu00nnB73cwRxO+vXA0q0BJTEyqkKrSTB+ETUhSL++11xB0Py7uoTZ/?=
 =?us-ascii?Q?hjZcpmjUwYz2xYcIx3+WZ+5xJ394VqDqUJiE2bCD588SFIDUvamX6V7D73fP?=
 =?us-ascii?Q?Ra1fRexlbp122YPQBuxGDbmwUEQPN2s0KDqh/4h9B6XtQiWTJekv209Rf0Xf?=
 =?us-ascii?Q?2bz2jAq/JEmpFan0gpzYso9f6h67qtWYJNaa7mXMJueN8CVtLeWQ4khuPNrH?=
 =?us-ascii?Q?qQmOuJnSVBv0PkGl93ZEnmVCX7BbsGZ7/FlEq+8A5+Y/180fvC4kxCWOczxf?=
 =?us-ascii?Q?KHCz56enFplxS1Y0PNgga3gaNZYwdXewAYI/7H931CoDDvoZ0Ko3AqMh3slH?=
 =?us-ascii?Q?TjG257mDcu3SP2DrYN8PRkopfSDcX5A/nANijB3iqZr92E+bIwyhe1bZ1MDy?=
 =?us-ascii?Q?q9Fmqxhw/1jamGoIyou4zqugfWTFp4KylXO7rn5azV0S/WKieIJJvQYyVq/x?=
 =?us-ascii?Q?bOcvGXN3awR9pQEOukebz/0F40LVCu0VDORhZxMpJM7BlYWgkDAjyodHU+fs?=
 =?us-ascii?Q?VoQnaiFrkCLTjGTj3/xaExKI7fvd3skwaP0GrmNwMTu1hztMnzN+WWI0UxCJ?=
 =?us-ascii?Q?qzYfRKMe5PRdjaCBzbUn2ZRaCZzDBDrcG2Gm+w8yqrPMv/ih3tSwsS3McCUg?=
 =?us-ascii?Q?8RpKiwy43ieDRUu3gg3HuygD6b9wiuzmJZ+BcK4k08sOD7GLQZqmOoey/iiu?=
 =?us-ascii?Q?MK7e0Dbheg8i+fBehfeqOC8yBHEgHh1vq3bIHpOl4yMrlFQ6D1VXInjWA60X?=
 =?us-ascii?Q?I9HTdPL3cvBaDbc2ZI0cWE0kp1Pq48fXBgGleM/GggOmoiepcsAf2WbbodjF?=
 =?us-ascii?Q?TdpyDLZrlYmLhprWpucOug2xfbKjYfai9QA4E8FlhSBaNWaHZG/ciwP+9nKG?=
 =?us-ascii?Q?gTzUeaJne6qbsqVW/kqp/MdMju/QuQC8h8kc20xJQI2fBkgOde1lnWyAOSHs?=
 =?us-ascii?Q?BIjwE8pbloz7AT+JfyZ5Kn5HDJ1BvItWOUGOLD+bPyubpfw/sT+YzqPZsI6+?=
 =?us-ascii?Q?leneQsWAw/+wqFUXnYWw8ljF09aBTCvKQ/eug5EMeWixPwhfCjc9eNtflRfu?=
 =?us-ascii?Q?YBAmhHdypuyPlSSo8gaI67YZUCyG6U0QPYWqhcIruNTqClG4JscXQLw59Xts?=
 =?us-ascii?Q?e9gNxe0H74CRaoKbI5TC1Ml0aKARysl90JMDKMM3rZqPcgvSmXrG3XYmfl3v?=
 =?us-ascii?Q?hpHhGhKk1S3gYwY8J528Y0xt/Zgtaya2Ub4j+4WJPaQhohRNxZfDOX/nOeJF?=
 =?us-ascii?Q?7A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d8f6762-e374-4162-cb1d-08db33771f6b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2023 12:38:12.5978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dF1zFcNgi3uHWNK05O0eBTeC5QQGvYpuABqHL47BAkmaYmV8pJtzRhAIVZ0C8+zNSX9mjGs/6UY/lw32slMh3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB10052
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel will want to start using the more meaningful struct
hwtstamp_config pointer in more places, so move the copy_from_user() at
the beginning of dev_set_hwtstamp() in order to get to that, and pass
this argument to net_hwtstamp_validate().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/core/dev_ioctl.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 3b1402f6897c..34a0da5fbcfc 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -183,22 +183,18 @@ static int dev_ifsioc_locked(struct net *net, struct ifreq *ifr, unsigned int cm
 	return err;
 }
 
-static int net_hwtstamp_validate(struct ifreq *ifr)
+static int net_hwtstamp_validate(const struct hwtstamp_config *cfg)
 {
-	struct hwtstamp_config cfg;
 	enum hwtstamp_tx_types tx_type;
 	enum hwtstamp_rx_filters rx_filter;
 	int tx_type_valid = 0;
 	int rx_filter_valid = 0;
 
-	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
-		return -EFAULT;
-
-	if (cfg.flags & ~HWTSTAMP_FLAG_MASK)
+	if (cfg->flags & ~HWTSTAMP_FLAG_MASK)
 		return -EINVAL;
 
-	tx_type = cfg.tx_type;
-	rx_filter = cfg.rx_filter;
+	tx_type = cfg->tx_type;
+	rx_filter = cfg->rx_filter;
 
 	switch (tx_type) {
 	case HWTSTAMP_TX_OFF:
@@ -263,9 +259,13 @@ static int dev_get_hwtstamp(struct net_device *dev, struct ifreq *ifr)
 
 static int dev_set_hwtstamp(struct net_device *dev, struct ifreq *ifr)
 {
+	struct hwtstamp_config cfg;
 	int err;
 
-	err = net_hwtstamp_validate(ifr);
+	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
+		return -EFAULT;
+
+	err = net_hwtstamp_validate(&cfg);
 	if (err)
 		return err;
 
-- 
2.34.1

