Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5E64CBF5D
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 15:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233892AbiCCOCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 09:02:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233893AbiCCOCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 09:02:36 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80058.outbound.protection.outlook.com [40.107.8.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5D1818C783
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 06:01:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RQLf9lOp2nmS+AZ3pIwIiDA9eq94qI2sR07irMR28es7aOSf/+p9Jqgza8LJ9w+fya00IQNfXUguUIHPvgHrWSLoSMMtR/V7ZbEb8eDzH/zQd7o5fjORpTzqoGrVS2mNNzC32Q6QN/rXcCbyxHiRz5YaaUAZGna4tEM9kcJhORAwb6frwC8iCKzNLgbqDGEkypmG6pn9FFn7UouW6DgB9FGHTZayk/3zxhkoOTU5Ibt4+7RvKsSFyUnkQKUA98Mqpl7VJLWUOEPk6VCLamoyCjI6nAV5Bzhlfnm+bdFDzSvq0fPtK4siO2mdgfvz3I+0XW+ixmjCjPlmJkUcBgZ3jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i25+YSSWQaYI6TBXSH5wiMTNxPBpa9t/HZuKNA6HhVw=;
 b=beReON8rt9lIB58b+sXitR/gli0b9Tc0u2+9WDtniXmT+tydgDgzxrwY7Rtme5sbOSqRFxAiCqgLWvTW9AudSTwk8+YQ70NKkeDKPwMWA4Lq+aJ6jdPgh2Eu++ebML01+qtvOZbLp0izojEp/OQsyxmuCFh6MES6K9D44i1xnLFYJeDMaIktjX6KfNejDRYP6LM6w7KEM4mSuG9RndrEfu7SkgYIYcLdjyiSHz4RxjBJq76OjR+kvJNNVtOcf2wlGXVL87clebftek3NyOC/7mwikgrIeofo1FzPa34MGcQq+zXFZi1cQ/rxFR6uQBJdo5iy403hq2p4V6R4+aq9NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i25+YSSWQaYI6TBXSH5wiMTNxPBpa9t/HZuKNA6HhVw=;
 b=l4PCMv47Wy5sUpZ4wDV1eyFYavR0FqVh5nOgxLRzwIULxcM6Piohtv5VugrgmaeVPvtHLvpa6THyFRE4DgVsCC3FCjVSPbW9dOQMOHeuMG+RsW2eJRV7z1r41A2lTuLDF0z24G6OW/k6zpD5fmTjcGDBn0iYuMnXgp7uhAkk5Ew=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8879.eurprd04.prod.outlook.com (2603:10a6:102:20e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Thu, 3 Mar
 2022 14:01:43 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%4]) with mapi id 15.20.5017.027; Thu, 3 Mar 2022
 14:01:43 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 2/7] net: mscc: ocelot: use pretty names for IPPROTO_UDP and IPPROTO_TCP
Date:   Thu,  3 Mar 2022 16:01:21 +0200
Message-Id: <20220303140126.1815356-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220303140126.1815356-1-vladimir.oltean@nxp.com>
References: <20220303140126.1815356-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0108.eurprd04.prod.outlook.com
 (2603:10a6:803:64::43) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 642c53c9-e0f2-4db8-808f-08d9fd1e5913
X-MS-TrafficTypeDiagnostic: PAXPR04MB8879:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB887916803FD3FB255E40CC1EE0049@PAXPR04MB8879.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZM+Tkvli/lFxyF9abaOP4HGDAysAy+JN+JKx7yyskv+Lbr6jwW8mU29kNSBQm2+m4ADoXH1dt1Xe6s8wSyL7IL19bUJJF5abZbOhXE3Ie5eE00HXkgpiT8j4yxXIWlyGcE2bacQ0qJ/eSsqepE634KlPJj6tRQgHOwE6qIWuiXxjKoXzgpILgI6O26pF14wY1QC1ZQEN7PfMlKMKlgRDUu/go8rkk4dNvjJelCoZ39rXxP1Y0gv3QVaMBd2jvUPHJmY35I/rgVocUJfw3v5mttXPihCKnUMS5T9UxTugDzZRuepCiF/3/wqPO6tTd9/iSqwEP1xSAfC8a+VeIQRL8gawDpyXoe9w2/nkpRSQbD39O3xT2WNJ/mQs+lIIkjSd5POvo74gtwVdNE4/5fi5hShU/w2J01gu4EK1XAnvuP39P3BWZEXZZGtBViBY4DuPU3+gpLSNSLseTa9fgc+0P/uPWSNsvkM9KGYS3OxHpwpWOgBr2WDM14br85mFXWUQUz8/aVyHv99vhtjiRoolF5m8mDBxBZ9iYDAeXqzTefP0c7eMaSWuQao6nVS9rOO11ffp8BxSSpEZg+Vhj+edNy0WI0OpC8JKuHYYOulNhN5e5eSakqMqsMWRMx3DZsI1TssILVGYbOTLBF8UAbRYWPLL/B3a9pBPyspJhtAEtRH4z3jhaT9ATfAEIm/iQOyt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(186003)(26005)(6916009)(316002)(54906003)(8936002)(2616005)(66556008)(52116002)(6666004)(6512007)(66946007)(66476007)(5660300002)(44832011)(4326008)(6506007)(8676002)(1076003)(508600001)(86362001)(6486002)(83380400001)(2906002)(38100700002)(38350700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R9WSwZFBvYa7xKWXFGfA9DQuH/FdgLGR95zrj+TYOaRfQt4e24C5hR8XmqRe?=
 =?us-ascii?Q?cu4C+kgkL68EFdynD+kiQ7RshOe4IGljGqmTqka3m4VrIUfgCADapREx+j3Y?=
 =?us-ascii?Q?/nwbIOP3QmnVjxd1w44gQAdK6/9akq6YDOix/PFsl9B2ZSCmOK/CFe5GC+jB?=
 =?us-ascii?Q?wlFOJh3+PyKqHHEQ2vru1iYBPtGfgheGsr93MoNB59K6/J9Z2UXTlDmijj0O?=
 =?us-ascii?Q?gfV2m4pVMMP6EAo0TI8q/xNrdvt87CTMOS61xZuld3K9kyez7eD9tlfwhW97?=
 =?us-ascii?Q?Gfbd6UUnjZHlchREJ6FDxEzviFhoZd8FportJJQTiLCejoFrXRHcETJIU0Oh?=
 =?us-ascii?Q?ZQddrXFTusF75LdPgCDi0jsikmizmxkax4TiZdGBraW9Cxx0MUOO1PgqxKXy?=
 =?us-ascii?Q?NaTNV8Bl1uxLfLTSBdBFmlun2aojIKbGCM0Vwh4/7KuOiH2HOAwy9ybJ+aQi?=
 =?us-ascii?Q?nbaY3OT+0b++F44nSY6jGkewlA4DSDFl0eewxLjziqX7ptfc0k3ooICqnLIq?=
 =?us-ascii?Q?PPm/YrhkqkiQ8TWp48X1bxIwhYYb8AuAWZead00i0ZJPjqseXMgdZQu9gMR6?=
 =?us-ascii?Q?WjVplq2qZC1po6/zd2d+vPCGUXDqUON6JXEVkilGWeswDkhOTvK5t/OyoSPk?=
 =?us-ascii?Q?jz30IDJ+Msk3nOBEH8DH8gyUw6tK5s+WNkySP/ReWE7Rc3uy798vqDqq+A2l?=
 =?us-ascii?Q?zJvug4XGrIv0iZw9HcitzgzHBDWrGk35OT2bjnp33okelBc05cjJxEG5Pf5G?=
 =?us-ascii?Q?jVKpSAqSUWzTChMc3nqyDlG8puhCg1o0P81heQ/pn/s24zkrQQEhNz2azDZp?=
 =?us-ascii?Q?63pN2yJZZA4MsRWUEGYKv9+Blj8EbwY2xCphh8csCmEqI03OwAy8rI6JQI7U?=
 =?us-ascii?Q?kHtVxd5Aq5xzqL4QhiCLWfH/gxLNf8m7lfZGYTmZVP4/GoccBz+3PzHVIhfi?=
 =?us-ascii?Q?rCSzva6D27YEB3wKcPcHUlUXZ1vSWcKCHFcUCvK13KoeAZh6GXuNLkk+ow30?=
 =?us-ascii?Q?BS7jJFCUAyxdBBtdzsphrET2guzvt3fNtCJSc+T4GTo6wgp9WtQlRq1EpTxH?=
 =?us-ascii?Q?uHwTEi+mIBmG7nL2DkxPoWPY1aJTuqnPsynI5bZn6CjVT7dQcb7CHtAGl890?=
 =?us-ascii?Q?RCpRcRj0Czs/vbn9gT0O5JSfC5wX7DCKrayG2vV+E2KHtHqZndpQyOvqdNJ2?=
 =?us-ascii?Q?l5qezS5PCpHK86pc7QxdrPui1uRgbxb96ZvbbMYI8ExRwnqT43IMfJZ9XY8V?=
 =?us-ascii?Q?925u63vqHxQFVzYhjoVVsL9LOBJ5CVBS28Z0SI3vhWijxX6j1b+yw42meQoU?=
 =?us-ascii?Q?U43CnHPjCV/+UYv8/9of+HivXLDIbOBOKzwFB+MrGJ45p6UbacigS8Ny0ylv?=
 =?us-ascii?Q?3meeaWYUmABUWxjvrVc+bHdvsP6HtRmN2NzSlbTHYja6nTWd0IZHK+86DhzH?=
 =?us-ascii?Q?2yLkGvzxlScFlli4tijoiKvUUEqvEpVCT04DivRmc6SOoAmYOlVdiy9Sel84?=
 =?us-ascii?Q?Ol4a1BRw9jqR2XxLGt5kSkcuzB/NgUyRxfKbpp9G/ePzGPllpTCx9NNSFoFY?=
 =?us-ascii?Q?kjjDCrJVDy3mhPJrT2sD8u7MpRk3rRFExck2RCFR0IuP2onmtCttmI3MOzOw?=
 =?us-ascii?Q?7gyqFmLlYG2zG4e370QYDW8=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 642c53c9-e0f2-4db8-808f-08d9fd1e5913
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 14:01:43.7119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qarw6RinH0nkhqB/c3lsGIJtgdsIhYv0T9x7aVXyYhEoWabqzKSdO9aB+mL3RBWReURNZ6JE8vq9ccKxMbWhjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8879
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hardcoding these IP protocol numbers in is2_entry_set() obscures the
purpose of the code, so replace the magic numbers with the definitions
from linux/in.h.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_vcap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index 0972c6d58c48..b976d480aeb3 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -564,9 +564,9 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 		val = proto.value[0];
 		msk = proto.mask[0];
 		type = IS2_TYPE_IP_UDP_TCP;
-		if (msk == 0xff && (val == 6 || val == 17)) {
+		if (msk == 0xff && (val == IPPROTO_TCP || val == IPPROTO_UDP)) {
 			/* UDP/TCP protocol match */
-			tcp = (val == 6 ?
+			tcp = (val == IPPROTO_TCP ?
 			       OCELOT_VCAP_BIT_1 : OCELOT_VCAP_BIT_0);
 			vcap_key_bit_set(vcap, &data, VCAP_IS2_HK_TCP, tcp);
 			vcap_key_l4_port_set(vcap, &data,
-- 
2.25.1

