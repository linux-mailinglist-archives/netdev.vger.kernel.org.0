Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 786D66C26C4
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 02:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjCUBFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 21:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjCUBFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 21:05:40 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on0626.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0e::626])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71DC93C2B;
        Mon, 20 Mar 2023 18:04:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TPU0E9MRctG3Ixm10rEeUE9Di4Acqom6Lnc95NIOCQdp2TBOG87TMLlaVrN/XQWv07dkCuYC6GrVtA5bDYFbtut4cNt8pX5kD5MmUWjU+5aZt1+5MjmAaDmx/uUGJvfo6W2HsN+iQkw12uS+U8x8Ax8vw0AlzxL5jTy+rgTW/KTp6TGt8eUxsvxYAhVCDoqaDz9ya7DFc2KC9WD/43jYfDnZII+nexipKskjTJK4tsq2TSgE2u0sKzueuIiqjSuOyEfJ359Dbo95/7MGdrWYPEkPnoOJxGG6WeUCaLj5CB90qtwSn+xaxvDurgqZs6l1J/JBUq1jA5yuZjEb2p+iyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IcEL3GL2BMQBCPaP9oG2Togwh6+JpaKxBwCtn2r4xxE=;
 b=aBiqxVdQTYXl6NAYB2EZ72RcNs/e4BNJIUMoaEdAELnBl9en615nud04F7TYiub2MkntYW4z+asdf1IAG9C8JVnpGmv6i/Bk476aGZb1dK0vsflNC7jj1WGLk18hVZ/2gSeBpBn2UITihPdbFkE6zNiU/Sj5HpZdp718WVdTSMn/r2jxW4eFFT7YN7Z/AMyx9L0K1CrUVWtgC55qRwQkMA1Gbf6VXpNsxScOOFmDicSy5qmXas22ovHZzgsmA5QnAxl2ubmgjg0/z5JM9gczbx3GuUHj4U1OER3k2aSVL5sVBbpQF7CbkYfPAsn3/7aJaR9wdBKXNEzOd45MBLvsnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IcEL3GL2BMQBCPaP9oG2Togwh6+JpaKxBwCtn2r4xxE=;
 b=RZGPKscdl+TmTuGjkpSkvXp4zKwDzeYJEtFvqWl7jSvgHYz6hSSWhCk8xJ+D2DW6fNgoBxkggvN6JAXW47g7yyKR0juJmljLlZR3pMiQBOO4bD331la4HKtcFtE/3brJrIAUXGeCV7CjMn6tYR/59q2mBH5ssP+TzSjYzaCXK2k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB7911.eurprd04.prod.outlook.com (2603:10a6:20b:28b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 01:03:39 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 01:03:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 1/3] net: mscc: ocelot: fix stats region batching
Date:   Tue, 21 Mar 2023 03:03:23 +0200
Message-Id: <20230321010325.897817-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230321010325.897817-1-vladimir.oltean@nxp.com>
References: <20230321010325.897817-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P195CA0046.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:65a::27) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB7911:EE_
X-MS-Office365-Filtering-Correlation-Id: e9765d7b-5e18-43c3-1927-08db29a81b68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d2qih/IWI9WDO8x5XxiAxYwMSY6DMDFDr1a8ELNQqoRlYjRMcFAUCGhTOpBKlP1Fr+L1Muo+HoAGLr3nrXLUxr50keIg75P8Tq9PLU5t7C7iTKen5vZ6UxP7Hno2ogUxFJpyQqgxMIyRXyTj9X4KiJ8Fb+OL7j427uXcpqmvu3Zp1ILzltJ2cU9G6k2SLBe8ndef131vMCHF0MGHPgnBsYBum3es7ypMud40SqGnCuMdo5Qaz/88NeKKjQFys3N3Yde3t13tWOHxP/DmiXg60rYpBXLZPdWgEcmOGCRItGnyh5HLTs2XBymrSmayp7/uGzGNn9EwzwM8T9a6jbSW/yNvt5gr/KzNC7TB27QXjeD10L0L4/G4q2e1qQ6egl+CgzhdSnNL6lKdtHFgkFWv6ip2aMQhJr7EVT1AL9wg4Hd2V6Q08/YofylJetrn02BlxKcDghRLn7fKCGY+X/cpbwkNuSPb3xzTGJ9V6Z6iLxrZKVRNZYs4c6M6gWgmJg1mrHxHoCldKJUPeblxYCPCK3Mgy1VUyRDr5kZIhBOfjBZrt2Un3QbcTyT76r0RGBhN6rWDrufu7N0VA6hBKagavDMtnvm3jG0uSzFkrdctQAVA8vkXcQwUFZaNExx4RlOUAsK21DIaNPaHubXIlVWWymu3DOgciDO8EmTZIbF5xD4+X6Dd4i0WcjtYNoXgT0EvIoHzgSlt2U8FXCmCnxWRLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(136003)(39860400002)(396003)(376002)(451199018)(2616005)(83380400001)(54906003)(86362001)(38100700002)(38350700002)(8936002)(4326008)(8676002)(66476007)(66556008)(36756003)(6916009)(66946007)(2906002)(44832011)(41300700001)(5660300002)(186003)(1076003)(26005)(52116002)(6486002)(6506007)(478600001)(6512007)(316002)(7416002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MzhNYJ8B+37rwF62F0ehJZouSujbuNK3Iq5INRtOWMQBIU86wfT6pX9v4hdY?=
 =?us-ascii?Q?zCViCPmhEo4YuAFfclgndfApTt49v8oBz23AhVtVlpCf4mSV4+R94rZgg6Cf?=
 =?us-ascii?Q?d0oa6AyLx021qqBt8lsuh7kajjvDSQbXuvJbarQu8mMke3B4+D2YiHFbCmXV?=
 =?us-ascii?Q?D5xdu2AQ/TCyTv6DzWiIjyvOyfPrYL/0OjGa2vZNHFKtAtVQqKbHjNvyeOuR?=
 =?us-ascii?Q?XcLYvqMvIyG7wlV3OLdT4r/RNzNJoVe/RDUi5rh0SNs7NseqkhurucbhmRlj?=
 =?us-ascii?Q?syz1wlfPz2rLsbMPlVRQsgKzeydH3QZaPjC7KciTKmdUFngrWqIAeutt9MzJ?=
 =?us-ascii?Q?Jt3s+Hp1WmloZyzkGHYmS5Yt0B8DvIUwqsOFpEqDHeQmjo0XEAFe9HmOpCQq?=
 =?us-ascii?Q?+RABvkoFGj3tzh+gAc5tBs77Qo0A50dfq/LjFRwT85aou4cvA2mZJirBU8Px?=
 =?us-ascii?Q?g2t+igx9uniNxl6GnZfDzUuCBsCqnHw9jz3WNFHy59iEM1Q+nfcDoEzVXBKt?=
 =?us-ascii?Q?sNb19ndVu5oEjj5fu/ReaJU4uFPgLafamUvYvLZhroEkFo/6tp/0BkmpWubh?=
 =?us-ascii?Q?4DkVb7LazPOSehkR+JQspvOH2JgBj9jfLTy+D70PTkIHJlPcHNYwkV8iJXT7?=
 =?us-ascii?Q?uzypKEQf3oFfV90qJNta+kudbqv4ZvaiiKPVFOlKH1FdzRQ31+/p6WVD6lVC?=
 =?us-ascii?Q?IuBzDThnHImrnGiycOOfBr3XJ5EmfrYzGWtvAchNJkPgmaKnwUgVFlvu71CN?=
 =?us-ascii?Q?EdNuOHpZTVdMruOlxvJMZkIYpo2z4N+afHvdsFG2dblgsynvL8UPu7fwvJdh?=
 =?us-ascii?Q?gpdVigcEc3qNt0Zy+Zz1TyhfEi7FOTFzB+vAoGCMaqBJmpQ3NA2Ow6Mt3Xr2?=
 =?us-ascii?Q?uWdWUd2il8JJcT5tBqMKhOzn0e1EInou9ORbRdUMfeSRehNguU13ALuFm/GD?=
 =?us-ascii?Q?QHNNfQbkzkdIUBPS/fD253K/wz55CJ08ChROJt89MF6VqTH2YxTJ4u7aTeKT?=
 =?us-ascii?Q?0MRCE/wDg8ewWcbNwd/XdqOmksrdajblWx3GK34qnNGuU+2B4fR8GtBHAO+G?=
 =?us-ascii?Q?PsVsCeD8Atw84gVbxYlLBH4SUBjxXi59X1fDF8KX30MuI9bXVXFfDmewbAJD?=
 =?us-ascii?Q?aopk3tlbxMyj+VTs6hbkMGP+5LEkJWnGLCnBAc8BaC/n+1KPz3x71y517NCp?=
 =?us-ascii?Q?KNpcB+E0NomQtD3ywdymiMn6nG1qVQ9UjIJUebojv2UThqcH7uTT17P3q9Lq?=
 =?us-ascii?Q?H9L1kZovF+axVKzYJsxGtxQ/JE9QIQGyUyerR4RYMoDO34zEp7+LKuWn6BB4?=
 =?us-ascii?Q?7ZQLsOGACOkJMuW+dJgSEfl9qe9haqF0O8Zr6FFBiePTtfutl1yN4wo4uJQ/?=
 =?us-ascii?Q?cXYYDozFIVxKs9ehj9p+at3EPSDRrj2fKTOtilwRmrX68Iu8IDOmFpBhmjCX?=
 =?us-ascii?Q?cvw+joy+ZRBbzSb3WrL8KTbaTbbKqkvUN25GHVuweQizRsqP7Tx1GVZDNKxl?=
 =?us-ascii?Q?VgkJfndlZCfsZ5+aVJhX1da9t/zTRx22SHGAYwAQbTm/N+xReFKguxVl/79a?=
 =?us-ascii?Q?z4V2pQwlFMz660Z9BoXUkiKbulla117bRsnkgqwSx2i/2LgpykxglvtJKmr9?=
 =?us-ascii?Q?IA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9765d7b-5e18-43c3-1927-08db29a81b68
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 01:03:39.6296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cfWLYgNm/KSxP+v7RNJeSuKedCCT+NPwWesSJUAV4EbTui+oa/eqG+1MtJPX3AGZdMZUSwXVfFU1RTItuXAuTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7911
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SPF_PERMERROR,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The blamed commit changed struct ocelot_stat_layout :: "u32 offset" to
"u32 reg".

However, "u32 reg" is not quite a register address, but an enum
ocelot_reg, which in itself encodes an enum ocelot_target target in the
upper bits, and an index into the ocelot->map[target][] array in the
lower bits.

So, whereas the previous code comparison between stats_layout[i].offset
and last + 1 was correct (because those "offsets" at the time were
32-bit relative addresses), the new code, comparing layout[i].reg to
last + 4 is not correct, because the "reg" here is an enum/index, not an
actual register address.

What we want to compare are indeed register addresses, but to do that,
we need to actually go through the same motions as
__ocelot_bulk_read_ix() itself.

With this bug, all statistics counters are deemed by
ocelot_prepare_stats_regions() as constituting their own region.
(Truncated) log on VSC9959 (Felix) below (prints added by me):

Before:

region of 1 contiguous counters starting with SYS:STAT:CNT[0x000]
region of 1 contiguous counters starting with SYS:STAT:CNT[0x001]
region of 1 contiguous counters starting with SYS:STAT:CNT[0x002]
...
region of 1 contiguous counters starting with SYS:STAT:CNT[0x041]
region of 1 contiguous counters starting with SYS:STAT:CNT[0x042]
region of 1 contiguous counters starting with SYS:STAT:CNT[0x080]
region of 1 contiguous counters starting with SYS:STAT:CNT[0x081]
...
region of 1 contiguous counters starting with SYS:STAT:CNT[0x0ac]
region of 1 contiguous counters starting with SYS:STAT:CNT[0x100]
region of 1 contiguous counters starting with SYS:STAT:CNT[0x101]
...
region of 1 contiguous counters starting with SYS:STAT:CNT[0x111]

After:

region of 67 contiguous counters starting with SYS:STAT:CNT[0x000]
region of 45 contiguous counters starting with SYS:STAT:CNT[0x080]
region of 18 contiguous counters starting with SYS:STAT:CNT[0x100]

Since commit d87b1c08f38a ("net: mscc: ocelot: use bulk reads for
stats") intended bulking as a performance improvement, and since now,
with trivial-sized regions, performance is even worse than without
bulking at all, this could easily qualify as a performance regression.

Fixes: d4c367650704 ("net: mscc: ocelot: keep ocelot_stat_layout by reg address, not offset")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_stats.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_stats.c b/drivers/net/ethernet/mscc/ocelot_stats.c
index bdb893476832..096c81ec9dd6 100644
--- a/drivers/net/ethernet/mscc/ocelot_stats.c
+++ b/drivers/net/ethernet/mscc/ocelot_stats.c
@@ -899,7 +899,8 @@ static int ocelot_prepare_stats_regions(struct ocelot *ocelot)
 		if (!layout[i].reg)
 			continue;
 
-		if (region && layout[i].reg == last + 4) {
+		if (region && ocelot->map[SYS][layout[i].reg & REG_MASK] ==
+		    ocelot->map[SYS][last & REG_MASK] + 4) {
 			region->count++;
 		} else {
 			region = devm_kzalloc(ocelot->dev, sizeof(*region),
-- 
2.34.1

