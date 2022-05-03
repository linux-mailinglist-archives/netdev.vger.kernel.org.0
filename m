Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4A025183CC
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 14:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235068AbiECMFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 08:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235057AbiECMFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 08:05:39 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80084.outbound.protection.outlook.com [40.107.8.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E213230F50
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 05:02:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MBm70J4lrgUwpkyH/GZzAeb7iBNE1v4t5Dp+UhuEoeSFALc/fGuZI8nZX9UD85yl9yhcDb4RVaMsihOWe5FNbnv/uK/a1/f10RHWnwuh1tps0teXOCekahXfU/80jp9G2KMd6m+BsR0gvybHUiC9BZgWk8W2R2OibIpa9ZacPFJcORfteuO4XKIkXEleOoeEGJIGQtCGefGEODmqe0GRdO86d98O4Y4lI6n0/Hq2vGUIPQPw4i4/Hj+Jd97OE376GMDpYHg3l6dfMXz6WxYTDXujMXcpJyr3XYY1bpf2bZG59F8pEB0q+N4qjcPyJ5id4tNCmmbpQ037pf9DU2YWnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+BjgkX1jTEPtuGWDtWUD53EKLD5TvJxAROzJMQ/fOWo=;
 b=Z15cmvef2E2abPN30JRMfQ9tpBaLDOL3l9GDE+4Ise/GBResnGUjQx21ZffKhDlPtTJQnY/xX0jV49p2917V5X1wFjmCwSrOdMgIdaBJqdS+1f1HD9fSxkCfOs6XrAx7g5aYCjVGruIDmp4pB/qjKz50z7P2a2iyXuYFP7XgZPWxsqHU1G4/O8VrrPmfpqMf7UUpxiWztoRLe7A3QovAW4dXciOFYohwqY/Rgx2mTIhcEjHpeoueWlIo5JS21Tj+4JokqgSs9Jbj20JKIsM++R/Ey5BfnKjPx560rdYDLvKQONkbuaD4Oe1XL85NO9HepX98QPTSbJNAOhCN9XjCJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+BjgkX1jTEPtuGWDtWUD53EKLD5TvJxAROzJMQ/fOWo=;
 b=MOhkbjZD/UWoeGhOl75Z6MLLd2jRMmM4vKTqzPShgnwDJSifI8ARUfRfQ0Ygp5itLyjJbOd0Q1948Qu63dM3XdTX5PPFQ49t3jYIFo9KNMKZplGYvdmFl2zKg8+/OQ9H2bcjW36jqrcOuvhUmebrcYYesVHzbFqQyIrmo+wNH2U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AS1PR04MB9480.eurprd04.prod.outlook.com (2603:10a6:20b:4d6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Tue, 3 May
 2022 12:02:05 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 12:02:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Colin Foster <colin.foster@in-advantage.com>
Subject: [PATCH net-next 2/5] net: mscc: ocelot: add to tail of empty list in ocelot_vcap_filter_add_to_block
Date:   Tue,  3 May 2022 15:01:47 +0300
Message-Id: <20220503120150.837233-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220503120150.837233-1-vladimir.oltean@nxp.com>
References: <20220503120150.837233-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0067.eurprd04.prod.outlook.com
 (2603:10a6:802:2::38) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c67a2b8b-f1a2-4ff0-2ec8-08da2cfcbda8
X-MS-TrafficTypeDiagnostic: AS1PR04MB9480:EE_
X-Microsoft-Antispam-PRVS: <AS1PR04MB948059FAA110B705BAED664EE0C09@AS1PR04MB9480.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tKgl1+NaZXvUyCp7aSet5rbbU2xykPQ36Y+wLgjucCoyb3byyT/c462hO60C+pQjMfu8kvqBMWssvLYzLDJYlc46wmek0VjyNpQmoietfsg5vy+dw742ttJ1m28UltWfBk+YAuNtjj5qKUWcmT/bJ8QHtP3y0ziOYIQk+3uKhECAe0PI5myQYL67TBl+jaKPGQXE4ViBszBOzoUr9pD2WD1OhiFINvJGhuzO/8aDY5q36dmVSzOzTejMlH7mJ1nSnjirfNSlxdfuIZ4jYmKAewWaA6WvgpsYHGGo0yjC0RQuYqy1rpDVfM9RNw1utGICBBJ+p9VJEIVxxl64gQlgzXt9wpPEmAmb6QHM2HTwnEIj3lHl/AyHJQ1V/Ov1rm3/x+0ZKOJVtjmECvwYt/n+CtG3wdGOgzb1okDsZagYvvkh8KjRqd37B8hUT+nn7NnTUME2LRnAvvR/FpZ8pbd8S2twh5Swft9evs2XqAnvTL06gACCx85l5HhcKGweh++DkWn0VTyGZbvIIXDT/bcdtjj0ymLkz/kiiW5Z965smm3k7X4obzX5Nif6Xqn/vwQZrLai9nLWXGMqM04FAPvZbehURF1v7At74nko2/tqFETrpl2YyKY6FsBBKXBcQgOnh+CKsHB8KPsM3bokN6CYFCKy+wow0yU5CfXQlCbUXOvs4xvwVJNdIN8PvsXLyY1lAYJ33CtzW02XoFwWFHBugg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(66946007)(83380400001)(8936002)(7416002)(8676002)(66476007)(4744005)(44832011)(5660300002)(38350700002)(4326008)(508600001)(86362001)(6666004)(186003)(54906003)(2616005)(1076003)(38100700002)(6916009)(6506007)(26005)(316002)(2906002)(6512007)(52116002)(36756003)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XOIwzojgreKjHsMo1y76XAQcBQLmTgTfXH5PGOpsRntZKr3oQUdBOszFob0I?=
 =?us-ascii?Q?QfV0jWBNm9ZAxS1XJZloXRmscIyyBdc3mbeXtuJQZ6i+9tVcgVBvzBkoXc1X?=
 =?us-ascii?Q?m8vc72ThWmg05SqgCriOqkhOHV109AdQR4mlYgWyCTASuhnmj5H03IROILFg?=
 =?us-ascii?Q?aKxBvopcF6IYhhhyuiSlvc6WG3o/bA0LhMOfb6cK+a/malLgfEA4ysjKFDM3?=
 =?us-ascii?Q?Pq5zQFwDA2DvW2j9rn//Lv6/iV3nOfe9UeS3iHGdIOiIuwTWOdiFiq4XYl2p?=
 =?us-ascii?Q?14oQl1BuudfcfaFVPshJUdAtPzILFR3qFHWEzA2xzc4UuhafTfyvjWAiNl4x?=
 =?us-ascii?Q?EqdzRCKEHdVhEDqsjB4kgllLKn93Le1KzBKdv7CIUS4062Sv9NdQLeEn3Ous?=
 =?us-ascii?Q?PSLArHHARQdRjKfWxCo0K2hvvu+5BhXSjpzPJzarztdd7QEE3AdWGYnGY16Q?=
 =?us-ascii?Q?7duc80slLSIkHeeyBlC6qYcd3mmK5wzW0TIbk5Ai63IxdXPVcDhya5q1R12V?=
 =?us-ascii?Q?gBcEs9darooJU8wSXYe5X8EgDwIRY7EXSO8POR5fxgHfU9ubo/BC6OEhwnF9?=
 =?us-ascii?Q?Kt+cn1f+131H7Kl/lETgq+13FsQg6Fg/SdJ1oPNlrIOSlwYDs98Bl9mZr2n4?=
 =?us-ascii?Q?5FFUtqbKhN1/4Gbqo+xGx25+ViM2Lm262pIN4HBm7E59/+7kpaI125B4o7Ec?=
 =?us-ascii?Q?u4oV2RrLB728pCv5dTDuAq3dGDNkT+9BqTGfTNGoMhH969DJnqTOmEyhpWYK?=
 =?us-ascii?Q?TNEXkg5z69Q4sCZU8qpeiXj0cWmPsnYbZl5l5H/3nvLBwXNEuuYWsdOKxBnq?=
 =?us-ascii?Q?DXzBJJxtG3e+4/qu/VHJKJfK0ihhruoXtFCN05oN3zjic5mf5WxBFdxbV1Kr?=
 =?us-ascii?Q?Y9bYQ4+in0XkU53W8cUVtXFpLP0gL/KhTtvoKvsSKp2s1X7Tn3hjesVlElP2?=
 =?us-ascii?Q?wJj/0u63akZjNyjHr2AM1fWuPWfv9CGPi5ri9Zy8ZVb48yfSWbyp4pLG4EWB?=
 =?us-ascii?Q?ecdKUS4xt6JhcBSW5zuqV/e0aBW/KFy9gBC9tPTf4z42Nb2aJG5R8SvkxsX7?=
 =?us-ascii?Q?5GzKvVgisu/bqlehVl/nBMNV2LnJCruH2VojaWvJw1A0RVcSnKy+Dy64bswF?=
 =?us-ascii?Q?1xSCur1lcLBFyexDkJnm1+bx8yLKTdYVjR8C5bU0jNdGrK/6924VqH9RRBcS?=
 =?us-ascii?Q?7wV0dXljqpAzmPFJItprecDeEgYhwiFdQqmatJS41mNkptiJpWKDbUdus6BZ?=
 =?us-ascii?Q?7ubZKdaZJTHgulJkrXmThbyWWn6+DArkhYVGcZuwuCnDsJrtWdVfjOV7RNHK?=
 =?us-ascii?Q?fyQ0HLezqp8ATMeurN7wgqWg9RImEVsu8VEZPMJxnxveMSI+fhpljK0ZAeRV?=
 =?us-ascii?Q?8N7A4WTj/35YxfcncqWk01RFhu966hp/68Mho9eFvimwunDnQOVGejKk+FFz?=
 =?us-ascii?Q?kdDKm+WDhOulXA3y6Azo4BiJZRcJLh3Ffrykcvqxojo7uTttSdKas5v9181t?=
 =?us-ascii?Q?Z1Q2/5Ci2i/3Qg2INs8Ge+1aYqA9RRFZjFSaw26naM6ZGPE9i56qm+jueaI2?=
 =?us-ascii?Q?VxkaJUMbiZ0a8En9XKoivywPIZRC+k5thQLPpkiF+yfFiy+lnOuJM1EIN4ue?=
 =?us-ascii?Q?rIhCx14WLzRi8L30PmsTJf7l9L7ehJG7ZwjYzvB9g9FezN/rZdzcqDFf7YQK?=
 =?us-ascii?Q?wgdj1vmkWY8nBLzfuZbIkSsauxxv7y+B2yxYLLw8TRR+jasy7LeDg7JekEpk?=
 =?us-ascii?Q?afz1ltxi+x44XjK6M5TOzt8BNg5TIuU=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c67a2b8b-f1a2-4ff0-2ec8-08da2cfcbda8
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 12:02:05.8673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GlqXUSgxYJv2W2nhYOWqHVJr2ZzGM8RlZfj1jSZZRIDks1wgcjIEADzpM0VdX5lw1tB8LSWowDgfvauRcA5jDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9480
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This makes no functional difference but helps in minimizing the delta
for a future change.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_vcap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index cba42566edc3..3f73d4790532 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -1003,7 +1003,7 @@ static int ocelot_vcap_filter_add_to_block(struct ocelot *ocelot,
 	block->count++;
 
 	if (list_empty(&block->rules)) {
-		list_add(&filter->list, &block->rules);
+		list_add_tail(&filter->list, &block->rules);
 		return 0;
 	}
 
-- 
2.25.1

