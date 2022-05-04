Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A931751B3E3
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 02:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358125AbiEEAD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 20:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383721AbiEDX7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 19:59:47 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70048.outbound.protection.outlook.com [40.107.7.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011EF522CD
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 16:56:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WTWsZox9531C+8Rg/JFEBQVWOJGmkIv38qVlU3PS/k38RR/Jky7G9MpMMSBIPaxeL7EWaGt9EnZq6hRawgFh0qTKQvywljpReyNpC1ukyju+36RRjeRZYkr2nbcsoEvtLx8lt/Em4VAyMOKj94ZE9g2xl+/3dAoC0ULKl9YvgMIp/5IhvkXIp6L6xKo8krnuGE5mr8o26YWgCa8JhMAhzxQ9+vf9o3biIS2q3fWqVWdaGGvDM0+X56RBpIFgXTaMVrdAVbjz8f3jc2Yipk2MTEsTWVyGRgcmmy6yPXQlwyuPExmsh5ipHKT65i1TUIx3tsGlgBENmvWrHckrjyJwiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HQH0uq+0n42Eza8GHOPzX1voVKFx9OmXoH58D3KOtc4=;
 b=bAVXcMAr4eIe4TOAXorV1KZvR1f0O+HKxISiwUFg5/jkNnzTKvn5iJGFpTxd/KLcyI+EytRJpu7se/qqzlkbISQPglmmS0TJRiKyuhwOxkz2GL4zACU69anI3GJ/gzgETEG1hoy6DdtwT65z7qGmiNCbLoDrjc29e8HBu8Yg8xzMtooJjn/ALiduNMs1S3HFgib6x9la0MuPAEX32JcHZRXeXj3ko8Z8MGw2gg9fYfaW3GPDL4MWbKPQKGFEkyHH4Gf/klp5CnQYCuIt4W9GkD/lB0T8+WNsIqWsLaU/+9yQfNaMpRLaoLmplq3jJNbPxFHeP3e2AWE9imlemOmALw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HQH0uq+0n42Eza8GHOPzX1voVKFx9OmXoH58D3KOtc4=;
 b=QuynBMFDAVehzyeRmCcT/MRa4WyKncyRE3pqZD8jm/CHbA36T4RMhLJCY8At8W7Wo9SJK0KFwFkzcLxRWFs1MIXkky5j3DDNmwLgcc7jJPBv/PDp2coddYXyu9dFd8SERQM7191i/eUhd9zGq+NxtuJ0sogMjDv0nf58dv6NK5w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB4683.eurprd04.prod.outlook.com (2603:10a6:5:37::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.25; Wed, 4 May
 2022 23:55:57 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4%6]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 23:55:57 +0000
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
Subject: [PATCH v2 net 5/5] net: mscc: ocelot: avoid corrupting hardware counters when moving VCAP filters
Date:   Thu,  5 May 2022 02:55:03 +0300
Message-Id: <20220504235503.4161890-6-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 96105a7d-7765-468f-b2a4-08da2e29a1ff
X-MS-TrafficTypeDiagnostic: DB7PR04MB4683:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB4683FF624A10D153ECEDB6B2E0C39@DB7PR04MB4683.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QLACUy+cFLxA/20hqmhwCvwD92ksiMAnpgyDGtX4yLkyFdJebpXcrBpBnUrj9NmN5plwTqEIp1YHjvVKOJ/ntP2yZEe1QBYVX9j/HEYksuhFvgPdW1yEiJtbbAWFs23V7IASOvbX81anOVrff5E0rXZUakQJNfeHaOYN+0eJXJ26ZAOSWPk4uNyXHpRwi8SHuRjnN0XJ4kUNH6t0WmTRxDTIvpxlOfspGRv9ru3gHz7rPYiD1LuDFGHZtREpVp/sUt0I55ILd99OUtnc1/sQT20kQyzi69rzbUqQPAt34KSv7491RWzFAWpSaiTWjdSqOWYl24s+0eV/RBHkZFSemTk2yTzKEJeCVqRVOdj/d7tw/1IIVFa4E0Wrbie6zySoLCdb6hIVvYHQk79pbwA/IEmJedsDP1xcSLzJfCerODw9M38aZlDHw2CgmwC3KHGVPrKFeTHIssL3Hs+rFLmPF6VRkhI2wnlXab1L5zpSf99xURewgS8K1+QcA6Ctet+Cfh8t2IQDte1tNy9M1EF1wmwCe6SJF8nZkza7y8jp+i6u67f+b/koijyiHYBfqL8LABSLmVfTp524Bp8GFuubRnpHWmZqF1W90NucTOf471WCIwwbGT/J5f2mx7DYoVUTMiqPqQlwtMZuWvvFQEVlm7+YuX3opV+/xcBJ1tgH7tR+soA/R04WG6Q4Di4mTUVGr3w8YY67s4jomqOxWmcYsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(7416002)(6666004)(52116002)(6486002)(8936002)(508600001)(6506007)(86362001)(5660300002)(6512007)(26005)(44832011)(83380400001)(186003)(8676002)(66946007)(4326008)(36756003)(38350700002)(2616005)(66556008)(66476007)(6916009)(38100700002)(54906003)(316002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xCX/GMr1VT51To3yqPe3MygjYWFJkx43PbNSG0YAJ4kQ+r/3uLGD9LPkMz3t?=
 =?us-ascii?Q?dJ1u9elcBUIOS5T0hqQHLtKBnCgS2Eu3PqM9GejosdwdWJy6n48iOMuRWzJ+?=
 =?us-ascii?Q?Bt5TZPBGu4VV1OPBuzF2PrubnfFV+1nK/BAJTBCCiEK8bTxKvX8VLrB7TxKU?=
 =?us-ascii?Q?Sh419dSkqAj8Zfk8sS7Meu8yPQisLE0rdSiKOktGbe3FvrzuSxfpnAEZG9ir?=
 =?us-ascii?Q?mwvK8s13XxLCECIcOgEJIVZD7expRcpAbc5sWENuxXHnAGrcCBSX2bCZx/Tx?=
 =?us-ascii?Q?QeZGfV1Vry6S3J8IIJe8JbaTcP1PBbH9Y0hpOZYxy4pLzEA3uA9rk/G16PbT?=
 =?us-ascii?Q?8TPd2uOTVMCMvt5ILIwQH6dsWKjcKPvHyymJ4xzbD/LEtrXeeislsMPCAkQF?=
 =?us-ascii?Q?9Cdm3NXtRWE2uTIfLs2P5/XSvPlqXt2mh+0VYw97adRcihrxLzfbGO5zkbCR?=
 =?us-ascii?Q?DLezyfpm8IlzaQZmvE0QFD0FWQi3cgSiOGWvK2VXi+yKGOBnlCnR2lXf8vps?=
 =?us-ascii?Q?FgayHe0mcFyt80+KcO5uHmVQdSICF60XpFsvHmcQBivw3rUtNGTwJ+TEZBVp?=
 =?us-ascii?Q?RX6pecaM7Kp4K1B93pMBD7OvDCrg+jo1M8LqzWT6QcaAnkq6TIUK7DrOFu+I?=
 =?us-ascii?Q?Isp1SD9tUwgcsRGIbQdgpPlkMU7a3XDNWgXbmSi5GHPhdQ+fHMN/ywvK4D07?=
 =?us-ascii?Q?yQKO3nSBLe/VEACLLCdYGjuV1GKUnIxikd1mzbM0CM7LxOjknIhcJ0wNsVJO?=
 =?us-ascii?Q?nnATVLQsRTTW1V+SRSUP7T1RQBUKyxOMRIfI17OJbdGoefmz7b8/TK2dKwLr?=
 =?us-ascii?Q?B+FxG7YGOXa32p+mog7pgH7NZc5Ns3e9yiMk/hzu57PggV37ysS6JQ4j8y4S?=
 =?us-ascii?Q?OFaw7YAg1OVp3q8LGNmLRs7Oe2cTgfMvgQz3l22cAePOFWQBmSS2eIg2iGos?=
 =?us-ascii?Q?1gjZwjv34FryimgCcSQ2rTHa0EeB4BtWopiX+mDENwd8nCRDctju7UBxOr0t?=
 =?us-ascii?Q?9/e0FboSfL2zieOn9kWkPhainMEOHRDMtaGFfEBFt3FmanieobJFtc/PyTvS?=
 =?us-ascii?Q?nih3CMcCWvJvaOUYAJsFTnCL9RWZkzhM3bgrS4KSOY2oVkAXIny36lsg+lys?=
 =?us-ascii?Q?cCNfAPsoViTCJTBX6bjF5gCXBqWtwWtrVTrNS3V8L26qFa9Gk5EaWgC4mmtk?=
 =?us-ascii?Q?nA+Ao3ftveKjXaFvotlavQJGDBG+ok9OJZASMxy/43cijYJMtF8JiiQEAkBJ?=
 =?us-ascii?Q?g0Oq5Q3RP5gxORMHqxR10ql9pIw3TnaoBks+3VHFxT6QQHyJHzpmivFL1HyD?=
 =?us-ascii?Q?ZZjaP4yr8LdUzFBmifXVYdajqMbD0tAfTuWf3GVa4z9KphIPFMqDpcuF4sxT?=
 =?us-ascii?Q?/l6N+vHg3PNon9xhCoLZcAd+o6A7X2b79FQ/DLTbwjOU1w8WJ7PDxjPdAZMg?=
 =?us-ascii?Q?kMrigUl09lDZrtBJ/7mA5Dy01KnX31ECiTZcUAhPdrkHQzzaWOSe+CUx27me?=
 =?us-ascii?Q?aD3q7ROTFB4sr18+39fBALCwHqgxuyKw0B0d8W05IiC0AiWbayCBbGDcaSOZ?=
 =?us-ascii?Q?dixRamTtlpg3qFbpCWzWDAQeJysuYvQ0hVgHYLMZeyleFzD1fcffmBDt4r/c?=
 =?us-ascii?Q?k1A/cRchiDn4fDFnNl7J5m3OLbDfkbyJd3fYFDxlv+LnqxPkVs/d7hlPNTdc?=
 =?us-ascii?Q?3AdDRMZMc/G383bw+AbQX0c8Wlp8p1UHKORcVUmA0bEQvQSlnxNC61n7Wd4G?=
 =?us-ascii?Q?hV45UEDIA6CUqRqOtEy/y6V+7VkigXs=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96105a7d-7765-468f-b2a4-08da2e29a1ff
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 23:55:57.4334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ELo4fW+Jq8yv4xTrDCmUFN+VpBhVzz1vm6ecYl38uggZn0tIT2Tt/GzrXoL2l/V/tluFnwzT3PIwH2Wpg71CIw==
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

Given the following order of operations:

(1) we add filter A using tc-flower
(2) we send a packet that matches it
(3) we read the filter's statistics to find a hit count of 1
(4) we add a second filter B with a higher preference than A, and A
    moves one position to the right to make room in the TCAM for it
(5) we send another packet, and this matches the second filter B
(6) we read the filter statistics again.

When this happens, the hit count of filter A is 2 and of filter B is 1,
despite a single packet having matched each filter.

Furthermore, in an alternate history, reading the filter stats a second
time between steps (3) and (4) makes the hit count of filter A remain at
1 after step (6), as expected.

The reason why this happens has to do with the filter->stats.pkts field,
which is written to hardware through the call path below:

               vcap_entry_set
               /      |      \
              /       |       \
             /        |        \
            /         |         \
es0_entry_set   is1_entry_set   is2_entry_set
            \         |         /
             \        |        /
              \       |       /
        vcap_data_set(data.counter, ...)

The primary role of filter->stats.pkts is to transport the filter hit
counters from the last readout all the way from vcap_entry_get() ->
ocelot_vcap_filter_stats_update() -> ocelot_cls_flower_stats().
The reason why vcap_entry_set() writes it to hardware is so that the
counters (saturating and having a limited bit width) are cleared
after each user space readout.

The writing of filter->stats.pkts to hardware during the TCAM entry
movement procedure is an unintentional consequence of the code design,
because the hit count isn't up to date at this point.

So at step (4), when filter A is moved by ocelot_vcap_filter_add() to
make room for filter B, the hardware hit count is 0 (no packet matched
on it in the meantime), but filter->stats.pkts is 1, because the last
readout saw the earlier packet. The movement procedure programs the old
hit count back to hardware, so this creates the impression to user space
that more packets have been matched than they really were.

The bug can be seen when running the gact_drop_and_ok_test() from the
tc_actions.sh selftest.

Fix the issue by reading back the hit count to tmp->stats.pkts before
migrating the VCAP filter. Sure, this is a best-effort technique, since
the packets that hit the rule between vcap_entry_get() and
vcap_entry_set() won't be counted, but at least it allows the counters
to be reliably used for selftests where the traffic is under control.

The vcap_entry_get() name is a bit unintuitive, but it only reads back
the counter portion of the TCAM entry, not the entire entry.

The index from which we retrieve the counter is also a bit unintuitive
(i - 1 during add, i + 1 during del), but this is the way in which TCAM
entry movement works. The "entry index" isn't a stored integer for a
TCAM filter, instead it is dynamically computed by
ocelot_vcap_block_get_filter_index() based on the entry's position in
the &block->rules list. That position (as well as block->count) is
automatically updated by ocelot_vcap_filter_add_to_block() on add, and
by ocelot_vcap_block_remove_filter() on del. So "i" is the new filter
index, and "i - 1" or "i + 1" respectively are the old addresses of that
TCAM entry (we only support installing/deleting one filter at a time).

Fixes: b596229448dd ("net: mscc: ocelot: Add support for tcam")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/ethernet/mscc/ocelot_vcap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index 6de0df1815b7..f766471f40dc 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -1212,6 +1212,8 @@ int ocelot_vcap_filter_add(struct ocelot *ocelot,
 		struct ocelot_vcap_filter *tmp;
 
 		tmp = ocelot_vcap_block_find_filter_by_index(block, i);
+		/* Read back the filter's counters before moving it */
+		vcap_entry_get(ocelot, i - 1, tmp);
 		vcap_entry_set(ocelot, i, tmp);
 	}
 
@@ -1264,6 +1266,8 @@ int ocelot_vcap_filter_del(struct ocelot *ocelot,
 		struct ocelot_vcap_filter *tmp;
 
 		tmp = ocelot_vcap_block_find_filter_by_index(block, i);
+		/* Read back the filter's counters before moving it */
+		vcap_entry_get(ocelot, i + 1, tmp);
 		vcap_entry_set(ocelot, i, tmp);
 	}
 
-- 
2.25.1

