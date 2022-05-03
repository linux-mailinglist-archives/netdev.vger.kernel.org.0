Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E34551839F
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 13:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234976AbiECMB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 08:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234966AbiECMB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 08:01:26 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2058.outbound.protection.outlook.com [40.107.20.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F204C2D1DB
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 04:57:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EqkmYwd+3bOUPYtwvKgvTSZZvWs/MXsK2/KV7ZvhX1KBq53kfXtcOj1ROCcSTdREpQdjhltVVM9cwKNNy9ZwYIyGVUnA0qNb5nYzCVN0Uk9y1LBhi4JempA1PYQ+sxlwEzNIlPLLqxAn0YJTqMLoqVGPG8uVb0pFV1Wgec3z75rAxEkfLc/R2pS+gpvfy0w2oS1TW2ry+DjR+1W/Ii1SVQBfqjs4YMtk/Ag3uf4tiqiCPji5p5nDSB5UE/NY5pfutPuokt9SHu3yAhlrTqzHLTboXrBIWp6UZ+7AWdSxdcUe+jlFKaoYH3+Nkoga8TYOdBZr16RYJsQGBaEUaWTEeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qSivyKgznuAPLMFF+PoseqMqbwW8eejLxAG6O7GhnkM=;
 b=fkm9vHwSQ3lD9HH5EaRtwCDM3cI2lOw7BF+7TIYoYBBb8kIxZrdfwVqIwF8MBYmwOdqz1CbmObAzZDAdBydj/0N5GGDXCsXwn1dyXXq84KobhrL4rOrr2hwB1keKiRRmLdmWhvwObvc0Oy4aH6BoCOCD3zzJGbCVFnbRv8Sfae2cYzu72VUiTaI9VnJ166iQmqUjA98ito4dPt0hPBLPu62O3+2ymvEawtz8zhOXwiMTcGcNMiF9FbhDFSpknnvPik489SopB37WPI4GxWroJ4x9w03s9gqXghtsjxOjmDXIzpHLsVMCoeR4O2vO2sREh3pTpbkSHVvsrBxwckTpig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qSivyKgznuAPLMFF+PoseqMqbwW8eejLxAG6O7GhnkM=;
 b=q7TFj4PR0bDm/yk2NyycqYu87x/ElvN/q9AjKAdJ5N8IRwwZ7vokGUqoIwd5xtXMI2KgGHdrf85tQCWv/KUNfrZOpDNuTm0FGigbcGg9HAbgR3PIBei5a9qUM6nGogQ/Va7BOXMYsYYAzsLf/Sgw6X/1SPkJlIaRZ+X50ZWqRJk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by VI1PR04MB4813.eurprd04.prod.outlook.com (2603:10a6:803:51::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 11:57:50 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 11:57:50 +0000
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
Subject: [PATCH net 1/6] net: mscc: ocelot: don't use list_empty() on non-initialized list element
Date:   Tue,  3 May 2022 14:57:23 +0300
Message-Id: <20220503115728.834457-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220503115728.834457-1-vladimir.oltean@nxp.com>
References: <20220503115728.834457-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0009.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::22) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ed3d2f3-30ce-4f62-165e-08da2cfc25a6
X-MS-TrafficTypeDiagnostic: VI1PR04MB4813:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB481301BC128CD123F87B5983E0C09@VI1PR04MB4813.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KXbYIx00qeBjT25phtlsxdQA48PGmbylHhGKPnHTakLMtjf5ccCcFe0V/OICeMl17ILl4RMmzcxn8NI7q9kvzIBqjPF4JGOBsKtIHPqoXoHsfhRCh2jl+f/+4oV71aIXEkmeHJLNRFodnG6a5tYJjpfvwExBVA5ZyeLCd7yh7P3r956TF3IxU/baIwrbYKRoYylZemSLeoO0q17tR7j6RcxNprb962krli8wfI0kSwcgNIn+aB9tVj/iX/n3dypNySTl7uWralNTthAejMKTl2GMPyZfFyvzvAAwxboZSe0/va/xwzpYUamRU+skU9x2UMOv5dFe0NtqzW6v3DBYcdAFJnmXaFwIj7u23K5I2y9NjxJWwaC1WgtrpZxVfshIGGsG1xIT3Z5yUmglt5Zgvu0Ophx2aRcQrrr909S2iFB04BMgFgtiNHMuX25OcUjJ6yADrj/FgyJX/2rA5JpiIFVyxdB6z6BSvm3M4Ae+Gc5KxaT+AoeOdOSs7QuXBbFgfREZLjzSIfOZzRCg/zXAWi6ighKDT6lJWhQ4N4sGTMzWYnSS1LkoOs7eQlFfbnhtdnvyUFVDCPZ1Tfk1NMqsz0/0igV0wqW+n50EpKLCxvfvThRJYx4a7VYXiRn3RmhNbtwKZvkD7uRTOTWyoFRZesR7NiwSyb/5k5OrAugalVU1IJk8eP9hiW06RW3udj8B9rtg3P3zyJIVQ6VDjH7VFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(44832011)(8936002)(2906002)(8676002)(66476007)(4326008)(1076003)(2616005)(186003)(508600001)(5660300002)(66556008)(7416002)(6506007)(6512007)(6666004)(36756003)(86362001)(52116002)(83380400001)(26005)(38350700002)(38100700002)(6916009)(54906003)(6486002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z8XDmSdlFVcFZ5p/Zh2cRmjRgKYQwsBYtz6pREXWh0jgdh1qhx8pXzWpQbgd?=
 =?us-ascii?Q?FQFnxwA/vYeO5CSf2iZ6CCmwBVN+XmU/RIhdGX2qAyrNYi0QmHWNpScKtzJk?=
 =?us-ascii?Q?1SFGSkYQS94YuTNZFfW1ZCWHOjNp2BefDPJ3bjyora37Ye1bNTcQJwR35F3i?=
 =?us-ascii?Q?QznqIR4drFWwiQ0cYDisoVsX4vfPu5vfR+RwIG36N8O2fX+tOn+S/W3CE4JY?=
 =?us-ascii?Q?dbGX4Cy8ARcPFGbifNFwWXpPx9p3ARgaUMnhTALppwTlkqQ2tuDbSNWZugdO?=
 =?us-ascii?Q?L/pTCqTgjhGmLMbgrjamhojYIT+otMw9l3if1NVg5gDbeihCRpDqV5xbG2Mr?=
 =?us-ascii?Q?At5+DfquL/Q7Zlx6cBB78GQLMLHBtmpnzPr/McSq3kYQyi4+2TBirnWSiYwU?=
 =?us-ascii?Q?i3p+BucGN/w5CEooXhBScJw/XBHqpdQXvkAhAYR0Fj+GcYUGrkf+zgQvEXnU?=
 =?us-ascii?Q?FrFKSnmmZ0W80C4IgrFmOS4xkCXTmPSEV7p8N83YQFmXNzzpj72VEdOIutM0?=
 =?us-ascii?Q?nYKqvrsG7YnhqSVSeaib3HmgurAzqEuoc0IbyhboveKd07o5+/2p6Ravxi7I?=
 =?us-ascii?Q?x+BdRoJNHlTxPOvfpOviuHnNZY+UCPHkp5/bmwa4pMq9PoNmPZo4kDS0Pk/s?=
 =?us-ascii?Q?dQ/FL48PK8lY/6shjIbFCJ9rF/tIBXlOpQbVxVtQheJQb6GUn/3gP0H46XW9?=
 =?us-ascii?Q?EXTePyCZ7SDSXxYD8y141fAjXeod4/6HkVBl2O0v7lfDlctjmLdYWPiTzrLD?=
 =?us-ascii?Q?ebkCqHDWWTYGpt4JAMhPe+IhYCWSkp97rRo5T6640D3SwmORsiEjC7nVAmla?=
 =?us-ascii?Q?PehsPXtDi5qy1iPhLcqX2qU40uz4WYNtAknWjWH+IwfLNE5g45V4CafXNuhH?=
 =?us-ascii?Q?x5hX9wm3ihYl25lexQN+wxap82iyi994m7ugtl10NWVF/RLns2j7V4/1WEoV?=
 =?us-ascii?Q?JVbCm9UNJXA/ukbv+tAQCBzbmcpE7KCJ2KmfUcSnKVnqOLvWVZBXIH/mjVAN?=
 =?us-ascii?Q?DeOfELkDBYZe/cIdaYH+WZWl6tMj33Br14xWGCZY6JAU1x9eB0Ste4V1TldO?=
 =?us-ascii?Q?bBEUTNy5f08FQC8YaHZ9imAKDZbUgpWKqsvma/dgOYAttSqeNLSGUpLCV8FF?=
 =?us-ascii?Q?tf6NrM7KT8CJSaZiKGalacDYl4KJq2pSC/gJbPgmfl7lYXq7rpCi/2AEmFqz?=
 =?us-ascii?Q?llU6SA1y6LWLrC1vgqmNvqTkN8BvpOS/Z6PHNDzUMWiSbu2LXRtk8O4NCcLD?=
 =?us-ascii?Q?GSmUB9DgX4guKRvAYeLrPsFVxGSVwDsHhJl0mkqlUKwfSYYOSEbwu6mcp5b7?=
 =?us-ascii?Q?AP2WRcV5BKHsSzpygtH1wy13d0f+E2yoiu1VBlfPQvbwN0+piwJxykD2ZLoj?=
 =?us-ascii?Q?7cKkZ4GupsLA4yzEaQWonGwCK+DuTkEGlwMvdkdNd6RrkN1Fmv/ezvw3+dyA?=
 =?us-ascii?Q?7bK3fNxrCVv+3YBmP9BqnYmmfuSL/oSmV5UrhBKTBjPVUxZGSnT/dlJkgLf9?=
 =?us-ascii?Q?R2PyS0JluQo9RXgrJGXmDhYFqrIT8HHP42RGnml3+b8eSUebiPCXW0TtwAni?=
 =?us-ascii?Q?W0CU5n5CPvn3ihANaVHUwLoFNxyTlcAiR4YjiNoHtFUPZVx4xC5NdZocxlju?=
 =?us-ascii?Q?DB/5lduly6FuJvKTUSJfwj+S4RTTgSnPr0exEXeEHWmPCjqhjN6UptUpV6VG?=
 =?us-ascii?Q?aoFje/vIu29ByW/X3x+Ddr1+EUUEbwZ9W3zRzhvl0QYFks0x7LqIArpJI2BH?=
 =?us-ascii?Q?F+zj4XW2M6QNd01zMgytxG70ZsM7OcU=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ed3d2f3-30ce-4f62-165e-08da2cfc25a6
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 11:57:50.4806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EAjBxL104L71n502KdLFiRB63KPq3YA+rrJfrOX2lL+cHyTaXYi0xYVRFpJOqTWwyYxDJi1+BvDxpKJzG+RnBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4813
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the blamed commit, VCAP filters can appear on more than one list.
If their action is "trap", they are chained on ocelot->traps via
filter->trap_list.

Consequently, when we free a VCAP filter, we must remove it from all
lists it is a member of, including ocelot->traps.

Normally, conditionally removing an element from a list (depending on
whether it is present or not) involves traversing the list, but we
already have a reference to the element, so that isn't really necessary.
Moreover, the operation "list_del(&filter->trap_list)" operation is
fundamentally the same regardless of whether we've iterated through the
list or just happened to have the element. So I thought it would be ok
to check whether the element has been added to a list by calling
list_empty().

However, this does not do the correct thing. list_empty() checks whether
"head->next == head", but in our case, head->next == head->prev == NULL,
and head != NULL. This makes us proceed to call list_del(), which
modifies the prev pointer of the next element, and the next pointer of
the prev element. But the next and prev elements are NULL, so we
dereference those pointers and die.

It would appear that list_empty() is not the function to use to detect
that condition. But if we had previously called INIT_LIST_HEAD() on
&filter->trap_list, then we could use list_empty() to denote whether we
are members of a list (any list).

Although the more "natural" thing seems to be to iterate through
ocelot->traps and only remove the filter from the list if it was a
member of it, it seems pointless to do that.

So fix the bug by calling INIT_LIST_HEAD() on the non-head element.

Fixes: e42bd4ed09aa ("net: mscc: ocelot: keep traps in a list")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_flower.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 03b5e59d033e..b8617e940063 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -793,6 +793,11 @@ static struct ocelot_vcap_filter
 		filter->egress_port.mask = GENMASK(key_length - 1, 0);
 	}
 
+	/* Allow the filter to be removed from ocelot->traps
+	 * without traversing the list
+	 */
+	INIT_LIST_HEAD(&filter->trap_list);
+
 	return filter;
 }
 
-- 
2.25.1

