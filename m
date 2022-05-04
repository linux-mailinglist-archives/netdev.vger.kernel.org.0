Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66D7551B453
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 02:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238137AbiEEADi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 20:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383716AbiEDX7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 19:59:45 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70048.outbound.protection.outlook.com [40.107.7.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F00522C7
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 16:56:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bR06tBbFMyP9xSj3D/HGduqM5IiK3hXr7/fWr7K5hwOzi60iEcHdaeLFCdRj7l4olOyhSclNtu++F9Bk3RCbUmNN7sSuW6YhXdGuT/PDgIwgiql4FuWoeiy19ppyS1otbparpQoBzAVRv8dL++d/v8+b2DTCJXTiU6/H8j2s/NMVSyNDkWViKNTKVTnm1cBIWAX5ZRteMWLXBstNc4IbJX6mZcwWf4oigoaTCYwZ6hPZjA52MvZzDqoCGR5Lf/W4mFL6Qj/AT3Edc1nDFjVmFoNL/7w/SFarnCdzbfv0weeP6RiVssUVh+/TDl263f4ese7RK1GxKp6tANbA1nWL4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UQVJFptU84H2kiiO49xW0LG2aatkH2eNOZ/3pi1ecBs=;
 b=WshmaDICQlwaBZQPjl5MG9ld5D9ANOvo83yAV5wLbzbtQT8roj3gHWGKeDfJAL8y6dORy7cATbWVHDSXJ2a/cgKrbxkeTVxZ0rsws0OlxZ4mCKc30IS7a6WMwmbC8GnVcoBtrn1ac6VeJrwBo9AMn0IhxAxD80ez7wuKbrBx/g8zVXK9zIQXIjKTqRSwEyvcC4aVjPcgv0ElqV9FCNE7YX1AqsSzbPWfzIjTrYRlJ8Rq3PTMY1bKHb7z2xNRDbF4oQDCF30Ys1zL/A2OtMoKKsoNQE26qBQd0oQJ9F4cGNIpTzQMAjuAZZQtKfLzTa5s4MxNhNk0KnHpL8UFdm5GHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UQVJFptU84H2kiiO49xW0LG2aatkH2eNOZ/3pi1ecBs=;
 b=sjADzHJ98misdpmzy6dZJBW34wFcDtnW687LfNoywozJjfOi2wp95UEcxCiVpd0V7c1Y0qFt3RdFuQUH+LRW/cTlosN/CtgPuXuYEeRHcLJ9qjwOotpTqbWF26iVm/a1Bkjr0b3cMxhQTXRmIcd1qH2BPtOBUJcBA82SC+lpUwk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB4683.eurprd04.prod.outlook.com (2603:10a6:5:37::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.25; Wed, 4 May
 2022 23:55:56 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4%6]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 23:55:56 +0000
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
Subject: [PATCH v2 net 4/5] net: mscc: ocelot: restrict tc-trap actions to VCAP IS2 lookup 0
Date:   Thu,  5 May 2022 02:55:02 +0300
Message-Id: <20220504235503.4161890-5-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 35773b93-8f32-4bd3-d50c-08da2e29a11a
X-MS-TrafficTypeDiagnostic: DB7PR04MB4683:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB468384DD806FF2B0BEE90D32E0C39@DB7PR04MB4683.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EiVlew0/rbmdoVNN/VqqKybJCjq7mdBK3mA0Q+ktEzQp/Ga/ZrhZeHqeP9CMnVpjYzOh9OaDzApPvJ/bZ579aFPf9Lz63ta5BhM/cDc+/9jaF+JJfgjCogsGy1RxsQnof1sUizZoAUiT2CMb55TeyBPIMcsK8kpCavPnCl3wkoT2Y7vs56A3a7vOiuBsH93lXyXUMUOItp05t6jBWnur2sbuDVp6BU9H/0YW1is3kfMBtepTfCtJNr45/xAc9IH0ENignUKVPUw1dhvhrApSgkDbbuIEC1yg+kxwP0sq8uDeHXU1DeLtO4tRRP7XDInAzth6JVYc65IGOoCVjbE1hlChiRDxw/K0kjLsLy2yXM8NFtqFXVL9hBUGi81O2/I6fkgPnmv2IsJiGrTAxjJiI7z/MCD/AVMoHj7YArNTHUCyQs4fx3PrZG88X6jvZnW+YNcoZ1/L9wYhynfsuHN2hUduOt7c3eJFtceU8wskeP4Xvkf2lDaj9icoEXK+qeJ0ybZMjy4Q0ILblmDBY6U4S84iSRRqkZhPnRWhs1Z4a1A+etanrJhkWdmBv6hevrd/Hs4kI8HPlooqI+CITeo91qYiZWAuLnA/gHLnZBTJIFUq4LaonKBhTl+piIztXzGGnKHo5y/7UT6EUz4YP8MbRpjch0PoIflVbAlPsTdv6IpPgtrEB61B1VohkWYcd1mF+8lgtfqGfE/8JDkVc6X/YQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(7416002)(6666004)(52116002)(6486002)(8936002)(508600001)(6506007)(86362001)(5660300002)(6512007)(26005)(44832011)(83380400001)(186003)(8676002)(66946007)(4326008)(36756003)(38350700002)(2616005)(66556008)(66476007)(6916009)(38100700002)(54906003)(316002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZLol3WVIphjXC/SprW+gs0cDP7Rofh7Es++FjM3jcfs7ZICIPNPV5lPkYBL/?=
 =?us-ascii?Q?6C3wDFAn4z8OaU67Qk3Bx2boRUQ0YXCeeyGv7kB0/gdVzBwy1cNfRRPRNhZD?=
 =?us-ascii?Q?KSH2XrPHKxvomqYv7blXFeVPkXOfzCsBWBF8qPLwkNBb6x0utuBx/R0i7qoU?=
 =?us-ascii?Q?hSFMu1sgCyiyem4GDxXNnsE23HSDZGy9mJpkU/kR8qQ44/Pt+YBIsac8q4Xl?=
 =?us-ascii?Q?OoiEVWavnIEEe5BDM8YoVpE5ZEFDgkyJRfOpcRogGpNI7umfUyGtMRZ9uYy0?=
 =?us-ascii?Q?GcBQcVXsJwy4tGJeo+WSUHtoobQG01c5wKvh9xVpqERL1VD/HXMveBTrC8Q4?=
 =?us-ascii?Q?q8CUplwk9R/Z6cb/hEobXU5tXRPxRqPZhZj12RlRvte+W1/bNsDHSvgxoXN6?=
 =?us-ascii?Q?Bk3dMqMZzxyNHz93/PuNaYxwX5yNhf8zz/iY02/fpVqcf6KI7NdTHg7TFsha?=
 =?us-ascii?Q?TGFALaO6JpcQIyv5gJu/QEnyy5in+pG67Mgd4Ez0WQODnaiYIWPlmYUtB+MR?=
 =?us-ascii?Q?IParuKVi/JFHL/Llhc4L+MiuQXEZB2dr7h1nO32vdnys32wSo50hyBGEc1xw?=
 =?us-ascii?Q?+VTneZauq1rksyfaxBMSiG5PETLKGEpfTeiuMXlWtf9ZxgfygI6d51nHJMjW?=
 =?us-ascii?Q?Ne0NgfnT6zgo9iXKvrjjUkfn82tzYcpNnvd7Gj2yt7xrRd7Tf8QhjNswkUIO?=
 =?us-ascii?Q?LKEJ+EoTbug49W2wngceW48HF4PoeK+7GJCVRA4KNbS9b+jEi6R06WqxjLL6?=
 =?us-ascii?Q?RZUcHTjM2ETcmD16LpsMyQDJA/mRSK7qXRwmCUeTwdmSFvqXh0xImWBKNGCE?=
 =?us-ascii?Q?iWhkpo2N2cMnD86f+4YxUrsoCCsHXbZz1Dw/6vce+Pf8+v+Oimy44eowVmjN?=
 =?us-ascii?Q?s6fYNUfoFp35KSFZd2qi/owS5C5ufXupBrWHqkU16fwpt+1+gtXbRwdO5bih?=
 =?us-ascii?Q?PwYhdlK0pEKVxGRbam5XGpUEmRsinZB+2a9hf30LUiAg2HkIMxFJjeSKUTik?=
 =?us-ascii?Q?GnUCyH4FfROCD5wIVq4sl9Z0aeYKUMG8kSqRC4SaP0MBjznW5A0TgscZ7QnX?=
 =?us-ascii?Q?vuItWMv4VkJNF1kq3o/IJGE3HgWwiOHR7SLXDZaL4iDuHCerMUJL8/kmcbRn?=
 =?us-ascii?Q?/s63+t+VMabArUvGleMT/7/zhW10oLGaJF3byvHPO5+BsSVZOfJva0vUpj4e?=
 =?us-ascii?Q?hPKb67YuodapqZJz0Awre014fK6SnvVB70rgn5ewBmrmxuyMQez5IL4UsOXG?=
 =?us-ascii?Q?8yDgUuVW6vc94l2MzQmtmDDuDhJ1SotjjH+344/jirAaeJKHtVbCoDWSppGa?=
 =?us-ascii?Q?Hex8mp4SWsLNmdKHa8pO/lYPgf6KWBFX9NMwhf4sLOtjb1/vk8lSR2yD+dvy?=
 =?us-ascii?Q?ePynM+hNC09GO8W4y11cNzJ3tjKhMlMVIYgfaksZfwr4l5t5n7M8jt3EET0B?=
 =?us-ascii?Q?BKVChvuq2OOd26wiTsJMUwtEFTQQmnfKSjEOX9iU0wjvZaWHZhveWfZVL+j7?=
 =?us-ascii?Q?OVF2PWWx8ej7fytNPEDEDMW1JHW5N0hL+OIonG5VxBK4KDEcss9fLnCt9YSv?=
 =?us-ascii?Q?SmTZCBQZ8aEnq3EYUBs+iD+HcSXQQCFLEDOkYzT2AuUzbjNb1/uYRY/QPZby?=
 =?us-ascii?Q?awGWba95fJwGQUpoJOKojNOD8jme6rOTkS3d1Gb1076GzbU3uVPJYA5rrYLM?=
 =?us-ascii?Q?v9BCyFQpBf5eiYsVSMasxP2cOCZm499ic062D8YMu+/kzr/Ezzu7YO/gzM/i?=
 =?us-ascii?Q?sicCB6ZowLlSGkKZgeqWgQ8yxSDDP4M=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35773b93-8f32-4bd3-d50c-08da2e29a11a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 23:55:55.9335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GjQzGRp9EkPAvEY8gVMGmx6rGv8a45zfd2ndaqqx9+JUvddR4iXYLAhhE35kkD/XlPeLTTFd9XZA89+OC8LlcQ==
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

Once the CPU port was added to the destination port mask of a packet, it
can never be cleared, so even packets marked as dropped by the MASK_MODE
of a VCAP IS2 filter will still reach it. This is why we need the
OCELOT_POLICER_DISCARD to "kill dropped packets dead" and make software
stop seeing them.

We disallow policer rules from being put on any other chain than the one
for the first lookup, but we don't do this for "drop" rules, although we
should. This change is merely ascertaining that the rules dont't
(completely) work and letting the user know.

The blamed commit is the one that introduced the multi-chain architecture
in ocelot. Prior to that, we should have always offloaded the filters to
VCAP IS2 lookup 0, where they did work.

Fixes: 1397a2eb52e2 ("net: mscc: ocelot: create TCAM skeleton from tc filter chains")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/ethernet/mscc/ocelot_flower.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index a9b26b3002be..51cf241ff7d0 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -280,9 +280,10 @@ static int ocelot_flower_parse_action(struct ocelot *ocelot, int port,
 			filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
 			break;
 		case FLOW_ACTION_TRAP:
-			if (filter->block_id != VCAP_IS2) {
+			if (filter->block_id != VCAP_IS2 ||
+			    filter->lookup != 0) {
 				NL_SET_ERR_MSG_MOD(extack,
-						   "Trap action can only be offloaded to VCAP IS2");
+						   "Trap action can only be offloaded to VCAP IS2 lookup 0");
 				return -EOPNOTSUPP;
 			}
 			if (filter->goto_target != -1) {
-- 
2.25.1

