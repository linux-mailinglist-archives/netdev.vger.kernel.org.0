Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7F6E51B3E7
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 02:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240977AbiEEADl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 20:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348151AbiEDX7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 19:59:43 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70048.outbound.protection.outlook.com [40.107.7.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02668522C2
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 16:56:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JzMfl0VffcvTxTLfWPqDBNJk6VpvuNyj/XLD29K3nYpLmB+EUtZnfosYdb+u9mikdoQW1CsmgpQXFyECb4vdRc25V90d0cqIoIiYcBXcJRSvlYono2c4GJHNyOTGJ090h41TYoCAJlv3KgTGL1hTrjaoIHioYpHnR0Af5kZ5huFhGn3U/zTOqaf0+cEGaLzuExh0/lG91+FLhjBfJPP7S4NFUi1Bw6n2m3cFLudwDzb46+J0WIXqZkIuCMu/eDD5gozZoT16wjoU1Zm8YWxDgfQdV/NcgFC3PjMyfw1m2c8HndSnryY938WKfc2LErQpl6iSaP0XJKGnFcfpwpP0jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HtZSfR9V928Od1WrKSrXKZW0/3j9Nkr/iwE9MyhRYYg=;
 b=MrgMF0MQrzFdnpgmUkIpYzYWPZXLYSCIIyzkIXViJGf7dHLalbTJRNuXIG5bGiazgPOcUE2u3yUtuUmurnIHGhurOgGDLjVHxpTntQJzFQn0gP/0gGIzh4u67JepPL8a0E6E2q3kvTVczhdvkCA1wDqjCw1VOp0YAkaOavysN2SeIwUIp6+50uFvQKmbZQkgZXdaTmOayBLwxDtN1HHeefOq6OnfaafifUgbTZ5aShNNbPHY65n+RmtvTyNPIbcAMn2h/93P39iQnk4auJLuX5tuMPiTxqh6gWozu8KkiItLu76obQ81aC6rrm9jgyA7Yb5jSLhdyTO+814WSVU+1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HtZSfR9V928Od1WrKSrXKZW0/3j9Nkr/iwE9MyhRYYg=;
 b=evPwnCaxGIOz7mexXtHnZeTB4DTU21R95nMVh7jAfKyMud1v+qoo+/cRgkYxs8ifzPEPStTK3rZ6j5DGWsaQGntM8X89wimFSYwGomUI4vQyLCfO64Jc6TIpYTJRnTfoSvsR7trZheSEb/CJ161j8aBI46fmoK1CpDmfxYXYOm4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB4683.eurprd04.prod.outlook.com (2603:10a6:5:37::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.25; Wed, 4 May
 2022 23:55:53 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4%6]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 23:55:52 +0000
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
Subject: [PATCH v2 net 2/5] net: mscc: ocelot: fix last VCAP IS1/IS2 filter persisting in hardware when deleted
Date:   Thu,  5 May 2022 02:55:00 +0300
Message-Id: <20220504235503.4161890-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220504235503.4161890-1-vladimir.oltean@nxp.com>
References: <20220504235503.4161890-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0227.eurprd06.prod.outlook.com
 (2603:10a6:20b:45e::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ec1dccb5-29e7-4854-556a-08da2e299f4c
X-MS-TrafficTypeDiagnostic: DB7PR04MB4683:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB4683F20968AD54A2B5D3CC3AE0C39@DB7PR04MB4683.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hvLmq7+Ff1J8VcpSJC2zZYNKl5hGoA+Y3utJEJK5lWUyeYRO3tPNjz/vNxWc6ufAbLq7G9LmAJYmnAYal6hYe22oNN4TQJvz2waRTcHXSfAGy3wjmO7uSliN7H6KewMaGaoMNGtuPa7zm3zjYmrAAxCkiy2tz3qG+7kZlEBdtQK1uIma5pQdxbQkZCVsRYyXlQ/Z/k/3znzDckej4NbgUG+YZ5YZQiL6HTP7yCmPYlj51/96cDbaazTx2zzsG51a8BbLGsSnv1Nx460oJUajQKvEwq/pcWwBBnGqTqHy0oEgfZPHhC/EwIC8MapgOyXcKibaCAJbS051ep8MO0XM8jY5KMYL1Et2pJxo+99QDglM4dw0KuRZWH9tKN0OnnBP8+FnaVNvdqU8RGUeig9mIhCEkYWaLpMZVGfIiZDMNq/9qJXUsjeUqtyO28EZ/B+kqOHugnBiNbxKSuuiNjVl/vRTG6raiKu4wl1aLxBPZ3YHmtcJhiwV+tmiPIF2W0b6G4WLAYTjrwLNb77mVErPyPiVdZSJbQuGg8vZe4O7/TfgOMJI0YCq33xzS7ZOc/Pow/u0KROZxdLBbM7CBjNb4WolN7789Nst8leq9bNCsDji+3KNA8BBOrTVPlyuGY1DtAiftN8d/DuxrYfwWKxAMwGaThmMSC08HiFjM4P4K8wkeUP/x924k5vtVVhudvKIIyX4c4v1u4awczebLRd6LA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(7416002)(6666004)(52116002)(6486002)(8936002)(508600001)(6506007)(86362001)(5660300002)(6512007)(26005)(44832011)(83380400001)(186003)(8676002)(66946007)(4326008)(36756003)(38350700002)(2616005)(66556008)(66476007)(6916009)(38100700002)(54906003)(316002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q+gyInrXLd3+p7gZMgQeNF0/9lASQukOBpCiKV/UmL5nEa+XgLtKkVTMTgkW?=
 =?us-ascii?Q?V8RAdah/iImxshuvlmDXpZ7JW/W8YU3SL+IUQ6dHJI0geuuM5bZBspYO1BHW?=
 =?us-ascii?Q?FbMM5zGiXFtEzlCs7cb5hBx2weSnT7ktMOYkVWZr8Dby/Tfc5SPZITaEzSmj?=
 =?us-ascii?Q?EPTuT6qvUqR3fC2HL6fGL9WMkuFzY43T6mTTVcLSX4MkO6ye2hz2nATZyOXQ?=
 =?us-ascii?Q?MIpbtsGLFE749p7vZAvN+145Uf8FeSPd8XTElQs2B6SsFRh3pdgcTIWfCHhS?=
 =?us-ascii?Q?SeTeGkGnIZOWHCqKOYI9u8z1myMIA44TABIlVDmNR3tdcmz4rubcULuSPz/V?=
 =?us-ascii?Q?wECmrWj9NuWmg8eQEqpES/8OOk4lSEpeivKt2ptwWJRD5FgECLmQ7dwz//qX?=
 =?us-ascii?Q?22Qw6N/5uIGh5goHAc7E39gx/5sIAFiFD5BpjKUy0sB1JdTNbWWGcH95WHHn?=
 =?us-ascii?Q?+SaODw5r0VoLHJaWURwPdn2Scd+2ekWhlEOCW8y6JZJMavnIkDnzhczhPJp4?=
 =?us-ascii?Q?7SH3w0fAep1VWqd6m9H1bmInugh6cwvQl+cVwqEG6ofYq7Pu81mSFiknFh0k?=
 =?us-ascii?Q?962d8muTgqZlk5GAxLdqVxASsMnYAVyslESlae63/+MbUKEmGqvtE6Gq7YMQ?=
 =?us-ascii?Q?c3nuWGoAR1mzUx9mQ1z1u5O2HQ45bjcXktx6IEe9TCwyVY2zTQK5Uw+hm+KJ?=
 =?us-ascii?Q?Zoc/pYbJX0fsFVbm/IfdyC3ximekH1509TNGF4EwJLxngelsSp7Tkwfh0e+A?=
 =?us-ascii?Q?RRCKIpDnZrpBhxKzzYlLCZvGeavG17U/o5yISveRPvuHn6rHg1nmKOUZaVMy?=
 =?us-ascii?Q?P5oUnwTqkIY3AvlZG+OtgmzrUmN6yKhwqqkq4VQcYvb0oqLNQxILuWwZVIIl?=
 =?us-ascii?Q?Nrl+9lbaUMAXH1xiZgVS9gB05lzZnTtcY8Jg3AJRZSmvTtRbosyVtmV2r40x?=
 =?us-ascii?Q?IU4WXIt1PZ1seKjEUZ7XTkaaiBs+G/s2AFdCTdraelO5a4B+OSpCtvfwyrd7?=
 =?us-ascii?Q?n8lCP5x/1G9GicSkDGpEsj0SPXwjUQiwCWdftj1Pw+6ype7+dtf8f8RI+YVH?=
 =?us-ascii?Q?TRpBklnSxPXFZ25XOOgqttR0OKLvvILYxTd0spCpAnW4dB1ef8Q7yDVgOW+O?=
 =?us-ascii?Q?bAtSBaMHqWY2H/2cUo+mgkX63K+xn8l39TpjXBRwphLUJhjAjJpPigFnCUoJ?=
 =?us-ascii?Q?b6Qy72qk6igHTTlebvs4R/X1tKSRVNrQZMfiBHvzfHciGZt9B59XX6qeG9tD?=
 =?us-ascii?Q?ol2cFEIf3eoW1nrttjkh4yfrEKudSrha4+fhidyoOvoE9a/skbj4lITdJqxi?=
 =?us-ascii?Q?k4wNNCNyE6Q9jhkTvspgnT/1vkG6jdCZM4MERNHY7MldVXodnokOyQ0H64Tk?=
 =?us-ascii?Q?TBg3V8xZD/PlVVOThYb1i4UN64N9zCvPSN9sFF8LQN8tj3o+d+aSotk70lnM?=
 =?us-ascii?Q?DDbUTFrgOKQqkPdEXoL8Hv+bnSlDljEJ+yW1Kp03Y2Q2W83v8Geryw12akcy?=
 =?us-ascii?Q?OW+aOyqUHGfVA2jHYBneL7hhxFB9ILfRZE/V2bWlBe6W2lFYGu7VdhQKXCHd?=
 =?us-ascii?Q?tHt3eSxxzUor3FJB7jvTBgeQw2Oay07XBSr8VVR4mENQBZi76kitj0KcA/0Z?=
 =?us-ascii?Q?gRM0CbRGvAl+JUV9zz3i2LOQDV1Ger6iXifTOnL4KATHJ1h+9A/4hvynMkV9?=
 =?us-ascii?Q?e7+W43HdhyYhIUctGIEQofPhnTtck4oc//hIm6Upmv9sOW8AsWvvgFrLcP4g?=
 =?us-ascii?Q?/OELYMgEU0/z52go4Dqcze0MM0OBt9E=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec1dccb5-29e7-4854-556a-08da2e299f4c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 23:55:52.9025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6FKAW0Zsth0tGxHdiOZEjYIc1qksS07WsTCzdnTz0DLrdjlRDLNmxtHbWLX7G6fPqueHMuuGQlZLc9InKLlfEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4683
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ocelot_vcap_filter_del() works by moving the next filters over the
current one, and then deleting the last filter by calling vcap_entry_set()
with a del_filter which was specially created by memsetting its memory
to zeroes. vcap_entry_set() then programs this to the TCAM and action
RAM via the cache registers.

The problem is that vcap_entry_set() is a dispatch function which looks
at del_filter->block_id. But since del_filter is zeroized memory, the
block_id is 0, or otherwise said, VCAP_ES0. So practically, what we do
is delete the entry at the same TCAM index from VCAP ES0 instead of IS1
or IS2.

The code was not always like this. vcap_entry_set() used to simply be
is2_entry_set(), and then, the logic used to work.

Restore the functionality by populating the block_id of the del_filter
based on the VCAP block of the filter that we're deleting. This makes
vcap_entry_set() know what to do.

Fixes: 1397a2eb52e2 ("net: mscc: ocelot: create TCAM skeleton from tc filter chains")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/ethernet/mscc/ocelot_vcap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index 1e74bdb215ec..c08cfcf4c2a2 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -1246,7 +1246,11 @@ int ocelot_vcap_filter_del(struct ocelot *ocelot,
 	struct ocelot_vcap_filter del_filter;
 	int i, index;
 
+	/* Need to inherit the block_id so that vcap_entry_set()
+	 * does not get confused and knows where to install it.
+	 */
 	memset(&del_filter, 0, sizeof(del_filter));
+	del_filter.block_id = filter->block_id;
 
 	/* Gets index of the filter */
 	index = ocelot_vcap_block_get_filter_index(block, filter);
-- 
2.25.1

