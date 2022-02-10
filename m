Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61EB64B0F08
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 14:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242359AbiBJNpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 08:45:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242365AbiBJNpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 08:45:13 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70053.outbound.protection.outlook.com [40.107.7.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2749DC2
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 05:45:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MyFkXP3QlaFm+t/lFv9jlsTj1tJH4r4SJF/LryyNDTebvb2aDbWbLgReYmuzkTtJ6k9XmojEXDyrLlBjl9CTsxTC1G0KRKoHWvsAxo1sNRuBxbOfzul+c2eNDLk7wtndIIxz3MlZ84g8CMLkxI0hq5hLXIgZd3Nn8aDzjm2KRyhAFA3FoI6bFW4RG+MmyRmuK3jxp1G8q6AyT09Xo9SDv/yb27CrjkgrZ6x4Q8X4mMqq/RWYt0Bpp4j9W3w+HFCNmSJUSDkWfoDOxgIHRmeoBY2R/J2xV1/RuuuOLyTPlq+5ei7zshs9wiewiGmWtxjLQSoNAl4CGv0OoeLPPrXTLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TzS+Y5BmehtPzo2YJRnsf0KxJvC8JMBG+tw9TnHrqwQ=;
 b=IUmwa9+sx1dya5zDJgKTlPiRK2Dd0D4eRPPttjGnjCWrwGuRsyznS+aLQr7XuxGThqRlCrFmZUNklPPmYWt/LljOxQ8Xw16Jfu7fqcfzb4KlKaE9onLQ7XzWjfNyMSEbfl6mXDmdbTdq3BSSrLsls2/I7GrACjaDAOdGdQTIoracAqd2soDOIEYKO4DSxpQY2hRbA9DkcKfcBBC7d60TvjBkmaUWJdoJysycS7uKSWsEVsHbD+QlWL2y8kk9pP0RQluE5yCgIpVqpFcL8DcXhtCBe19fAHRHvSfsBQ3ZlQ7KXaZVy1tugPO7Qz5MyuEvG7bUwqM9fyM3TzmKunKPxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TzS+Y5BmehtPzo2YJRnsf0KxJvC8JMBG+tw9TnHrqwQ=;
 b=ZiELUEYfw2GSp35UrMtjRzDdpjPM5MfUrnP5tfNB046CRtVyYe1vjrfyCaDtc3znbBCbwX0/THYmowu24tDFt2Y7o0E+h0CjIy7qORC8c127QG7rW7porF6qojGrzdkQ54RqSltG4wtK66xQbejyh1EfvKdoVLpud9LoVOt6I/c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2493.eurprd04.prod.outlook.com (2603:10a6:800:58::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Thu, 10 Feb
 2022 13:45:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Thu, 10 Feb 2022
 13:45:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: [PATCH v2 net-next 2/3] net: dsa: remove lockdep class for DSA master address list
Date:   Thu, 10 Feb 2022 15:44:59 +0200
Message-Id: <20220210134500.2949119-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220210134500.2949119-1-vladimir.oltean@nxp.com>
References: <20220210134500.2949119-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0097.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db89576d-e985-42ec-9888-08d9ec9b8f2a
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2493:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2493A3FC766FC034252C83B8E02F9@VI1PR0401MB2493.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:176;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xIIfcE8fDI4eNvZtoK907SLVSRzFOX23BJX/krFHDacn9D2sygdIHT3X9o6JjByfNZ3mdKOOY0SEBk9fCrOFzsAAgSGYgp3kMPSM+sfHM95HMrWsY2cvOqAHZO5wBbivKDV47zOGbqrLZqqGdtIO1H4rHPRlVpVCtmV1yrTNbOt12/ZBtTBB3dbHbXdvWAgAEvT/QHls411gCoVH+J4/eLYcEx25XS+v2x6g3LKD/CPDZkFjs7Y90tzVsrnmpuIj6ykEGy9ehXjV5j3/21IWAHCNKeWHX2YWzObrRlhW9hjvZkAGMTy15DYCvIOBg+3cSX/RRmSZ9/zhcXnG0cBy62QA2bBdvUfkduvyLmI+Fx3PN51e8W03mkfvzt+yLsX7mwMwXewd4FiKEnsdZgwwEeZODZQHFwrlM3r+Rm2wkjc2GQh05sjRy4hjVzfAvXhn0/2c8h48wShlLQjUwo5tFUyJ4fSUqj+BbDEgc09Bz5raK3PghDcwF2ccoHZ3QRwRxZPGQwCsa4VewkwRnk/rlnprcE+XUsqZhlHgHoG5E9qkSf8Kija26t4EtvDxWiG8uL98QW7ULN70ZAIdOCnWby73E4/SOH2StnCTjqhEQCAY1PIQrymNA0clV0fMH2l74uTam3XfI0rnGpsE3t6SXGvZUemEbE7xurV6GdryriXqgfV49ExL6iFBNZ2zSgRDZc3RFBKQhhiVjA+PcXGmjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(316002)(8936002)(52116002)(36756003)(6512007)(2616005)(54906003)(6506007)(6486002)(6916009)(1076003)(508600001)(2906002)(86362001)(83380400001)(26005)(186003)(66476007)(66946007)(4326008)(66556008)(44832011)(8676002)(5660300002)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p5No+nKPi3TYKFRVy30j3XiU3cRGNT4wyrnUbdjc1vFUCaj5JmlHuO2Zh6rH?=
 =?us-ascii?Q?3Rx5cRToc2Da7j+HHdzo4qIMuYEJ12u7hKU9NelG6CmPurdK8BJsoqAgKMPK?=
 =?us-ascii?Q?Ks9Hh0EAhlNfWt/2+65S0F2B103UlMLLGzXnlUBiiH0jVafwI5t5LYdcXSAI?=
 =?us-ascii?Q?j569AkfMUWgGHNvIfF569xfLDPHTpyZHbDXpnKwWQ0AipYNw1MgR2bAnrz6F?=
 =?us-ascii?Q?LADB1YSGNajTvNeGF6nt5p4DxxR9raxiU4rSQ4l2eUkupwEd/zTWSdjP0U0n?=
 =?us-ascii?Q?NMpEOyN44WsiZJ+XvsvKFGK1u43fIgPDpViNPcZrzIvRIUV7NucwoX4VgS+1?=
 =?us-ascii?Q?ejwsjuck0+BwVtVFq4UVqvzPdSmj0ixodhqM4iXCvJ718eSkaoL4ZYmkkvbE?=
 =?us-ascii?Q?6jBSJre63rLyrJm6uQ6VoMpOYqscyokrxFcpthkMOMSuCxENzBTWOCZS3BYr?=
 =?us-ascii?Q?dy007Ifv9qhJzkOY7okGYGUgEsLJW93zMdEeYK6KsL2V5YmFpfexRTCY6rzF?=
 =?us-ascii?Q?qVyBDpwWWh60y4sI7hDXSmSuLQFmgteHDKBn+QSr5dBqh4HcF7D/pTBdYKB3?=
 =?us-ascii?Q?bun9ljgQ5EZ9QxBdk1GB6TeWDbiSDh4JOs7zWgDq1E2Vz+i2Krx0JlxjvIFO?=
 =?us-ascii?Q?UZHIMMe2e/QTP1aIj8MToKbiISBYyNYmkGrzF3MF43S3IQhyo5OiZzh0R1RQ?=
 =?us-ascii?Q?ggwCrlJbgaFLpcqn5FNyGuVDkTzCmXhNbwAFejEfGuXh44zh9Wq0oPqYOofQ?=
 =?us-ascii?Q?j7fMSaEWar5Kwkc2SyNL+Txe6hamjb0T9WKq0R7GABXO1z1BBX7Ljb46ilSu?=
 =?us-ascii?Q?B383Ylreeqs8Uonxlz9h1i3vJG49eN6aSKstGKgTqhMzev56zGlcF4rET1NK?=
 =?us-ascii?Q?4pveXd/w7TP1a2BWU72DEvLp/Vh4Jo8ooRI58xFhv7MrB1lpNPBvvx+L3+O8?=
 =?us-ascii?Q?9TbB09BU3TJ4Qa44j/Ytr8RBlfKDOxbvkqroybMcDoOElUjH3GIh/vkIji/k?=
 =?us-ascii?Q?3pKyg99DG2jropuyvbyodSEoWKqN7qhuu3HAph+9jOHAzkxSWJ5WFcXJCtRE?=
 =?us-ascii?Q?DMHdw2kNvPLxvUcmjy2behXuzHB+KMA6DmXvxoqqGXY6PhdpIlR8p2yaZG5P?=
 =?us-ascii?Q?FQ+RCM82gVEV1u7vS8kGEaVd1xiF6WgWz0bvulSy0Qn7bFZi9wu67oN57pvP?=
 =?us-ascii?Q?5FiziLeSGlONlq/Ls4Wlnbnhd6VCO01fjkk/qzMzwkLNfznwC+snk+Hk/oMl?=
 =?us-ascii?Q?fscX0gt+N3KlbEREK7pqlbbQCoUxIdvsse9DcPygZh4yP997wql973ove93L?=
 =?us-ascii?Q?UPhF+alES3Qa56c366Tt0Xo36DS1YcAalxcX98cYr5tuDgWqqrn440bWQy7u?=
 =?us-ascii?Q?nPGKnVQhzrfh6aRwm5sipgli/msjTltWjdelq4gjBDigJaQK0akcBhi27a6e?=
 =?us-ascii?Q?+7LG5PybBKr4Ml7XxFkB8VvKYkFuDJvuO437wWzhbRScXo2bkVGWV8oFKtD9?=
 =?us-ascii?Q?ZgFEyGIk6qjGTVZ4WQDe4F8ZWmmJ7HBccUKR0eBJ2V1cQeaPxJTNcuS7YFar?=
 =?us-ascii?Q?94Rl+5tWNw92Gvuz+tY+u4bh1wsRnF32kZhNKe3xScsc6nbSXwYP125ABNcp?=
 =?us-ascii?Q?pPDcmHhFIKw217XlpcowJzc=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db89576d-e985-42ec-9888-08d9ec9b8f2a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 13:45:11.8155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k9uCUky2tliKupKh7pX7dKtoztzzj3YiDx+4Ii7MaxJy2cmBaGM/fR1ZTsqA1tDwnf8EvHuF+kfpt5DoLl+zlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2493
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 2f1e8ea726e9 ("net: dsa: link interfaces with the DSA
master to get rid of lockdep warnings"), suggested by Cong Wang, the
DSA interfaces and their master have different dev->nested_level, which
makes netif_addr_lock() stop complaining about potentially recursive
locking on the same lock class.

So we no longer need DSA masters to have their own lockdep class.

Cc: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/master.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/dsa/master.c b/net/dsa/master.c
index 2199104ca7df..6ac393cc6ea7 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -330,8 +330,6 @@ static const struct attribute_group dsa_group = {
 	.attrs	= dsa_slave_attrs,
 };
 
-static struct lock_class_key dsa_master_addr_list_lock_key;
-
 int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 {
 	struct dsa_switch *ds = cpu_dp->ds;
@@ -353,8 +351,6 @@ int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 	wmb();
 
 	dev->dsa_ptr = cpu_dp;
-	lockdep_set_class(&dev->addr_list_lock,
-			  &dsa_master_addr_list_lock_key);
 
 	dsa_master_set_promiscuity(dev, 1);
 
-- 
2.25.1

