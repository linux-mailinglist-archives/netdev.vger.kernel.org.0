Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86BA55160FB
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 01:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237425AbiD3X1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 19:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235981AbiD3X1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 19:27:07 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2139.outbound.protection.outlook.com [40.107.94.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED835A5A9;
        Sat, 30 Apr 2022 16:23:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ChppgH1c6/aDTYosTI5BO8xYHm2+eQbd9dxrYyi45VhGfTZCci/gzrZJwjAK9X3QYx33jmRx8fflaik9m39Jhy7g5UM1PlTKSxLnDJJS9JFls8CIH+4jsM+REh1WKj2/Fds/P5RRpaihHxhtZOS95TlSF/2GIk6FVoUvLnuz2f9HU+vuZ4hFDvlXLnHMNpLzoAL4HTlIeMZ3zR1AareE1SFxCv9aSb2IoGAcRv5SZKemmugU7DDC3zBGTcQifKecYbyFebXmyF1V4bPp3F2DwDOEsgpiYQVG5Ol8+5i9U+fLeV4X9FMfrH5eyIvLZ9QgJ5jic/p68MOiB1FVgbyd4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rv6mp8Bc8j3OcCG1Vhav2ztXukXsNuqM+0Ixh2vapB8=;
 b=BaEUQg91Q6mw++AM7ytc2QKMvtFun4XPnGOTFC4dJxrs1ZmM31AU+zLDtswX+JHaCwpWdi4vm5AiLT0esSP0dIMpKeMVAQOs4f1l8/mfnw2ElF7XL0/qjSLBYiM+fuPd8CFzsKmI1JlOwvwlE/llOJ6W1DFVhkypU1h6EGG/8agr3x1/fsZHCpSyVR3Q4sCxNh2hQxRxNoJQ6d2b9EiRcpVj4e3/fn4rawjERiUZ/eszgjqJiL08u67X/uwXxs4Al7WMt6a/YpDCxNS9ymkpAomxJaePpfkCXKCjwIyNR9Fvqr8PG3+UqCf3DmQ2z2PhlCtKhSttNgyE1uPy3bbEoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rv6mp8Bc8j3OcCG1Vhav2ztXukXsNuqM+0Ixh2vapB8=;
 b=gAf/uvbYD3eGNqJuXliUnNefHfqmipM5QJVQiRq+5rybwmgQ+32kjY8ZjwVaw9t8cipS7ngZGwAsfKa9wirmk+U38MI5/RekMV/hTpjYBXsZOvL6962acG4CuyVA9gkad/0ySsjhexlEmTFh7FFMJSR5ex2c2NEL3BNNNmBLwAY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB4802.namprd10.prod.outlook.com
 (2603:10b6:303:94::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Sat, 30 Apr
 2022 23:23:43 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5186.028; Sat, 30 Apr 2022
 23:23:42 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v1 net-next 1/2] net: mscc: ocelot: remove unnecessary variable
Date:   Sat, 30 Apr 2022 16:23:26 -0700
Message-Id: <20220430232327.4091825-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220430232327.4091825-1-colin.foster@in-advantage.com>
References: <20220430232327.4091825-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0199.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::24) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1fffa59d-82c0-45f4-f77c-08da2b00770c
X-MS-TrafficTypeDiagnostic: CO1PR10MB4802:EE_
X-Microsoft-Antispam-PRVS: <CO1PR10MB4802468CEDFB2F2B0CE29844A4FF9@CO1PR10MB4802.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xTJTx/C55GW6yYiJVVWJXfWs3KPddgglyrNK2cZVdVUU42ypNqIOM/ZWFJYisSX/5c6MkT4I3qFAu87QJw+attJ0X6ewAL0u7BLV3MLkaKF619iCJcHNjq20ezRi9/DSTQX4MCQrz8ZZmCnmswl21jQoKOOAYydmKhxWw580ZFyq4OmeF9gHBkxsXZ7r4GDYoUPGqtDJLeLyd55KJkCEWT2eCNx5vha46l8aRWOM/bRCVB9wH9uHAtmjcTJaHHsWSCPk1wWD+sQek+GMkwwDYTyOqZhhOdtcDSrmuvGmGygQEJtz4bhlke4DXQmY2l2rnrxR6PuKS3KeAOD2p8tj0kQ9l+/yuJHKJVRGHiDH77WQaDtJmCM172Qxal12RPp+uQYfEil2LW04c1XPPTnw9cq1dqLHCqkuIh0fKAtudSwIhcRlR2/1zwqj06VgCAGV8daf9xKU/B+u2ntMvp2h6FNDHNFNgzqB4OOTvSl2QzCE1cdUb2G9V8gCvFLjAmsTi+pq+f1Oem5yvz4FYHmouhzVLCtWaHYeTmq8GfWtauypbbC7tvOuKI3xcejEebNCL3zY4JVKIYO/R8YojyEkUdQu7cKjPZXVAjt0G/PF9e9isvkFYE0EiWjsxMVhAU3hKAP2tU56Ng1cSZXJIECpZiAUb7gKlz5LlHpVJc48jP3WPTWCN0WcbIHMHB9+AATMrs8QkiIB7w1r4JTzPh3vYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(366004)(39830400003)(136003)(396003)(346002)(52116002)(6506007)(186003)(6512007)(6666004)(26005)(1076003)(2616005)(2906002)(83380400001)(5660300002)(44832011)(8936002)(54906003)(508600001)(6486002)(66946007)(316002)(66476007)(66556008)(8676002)(4326008)(38100700002)(38350700002)(36756003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z+znDWBthrPM3dXh7zg7TvICLIWnUq8hOETdE6dPMj8NutH58z+mXmXh7ABL?=
 =?us-ascii?Q?A/ungDm6jQ01AeTAY4c33fA6je2fjjG4MQ6lxQluDQYvFtCI363ceuDj2XAT?=
 =?us-ascii?Q?Q/6C5tcjRhNX4xRmo4fB+K/LiE6GbxN2E/eu4e8bnioA+VftK6gfKcgWuLEC?=
 =?us-ascii?Q?vtfOuvfZlk637fOQx365AyPGsCJneth0lT2b1b5oXmugEZDxrDXhZE97mnVS?=
 =?us-ascii?Q?Qq1zokq1rRFrcowNEj5gUOODtJtvMKq/GyVsV/VFgDnYab0eTTygZY2G1psq?=
 =?us-ascii?Q?cD7z3WaFtWSDIa2+83yvdOyrxVO+FBhxEbH0jrL3zK9NrN5RXHV2hVE6caMU?=
 =?us-ascii?Q?NbLezWiB/dKiGHESPnpcabVlUxZsz6E1+U1vhp/PS4Iv2uSkqxsCLJIrNuHS?=
 =?us-ascii?Q?E363gc9FMIiFIA1afdu7CKXS1i1hyKXCSKnngtG3vh65ez4M9VgZt19hQHfK?=
 =?us-ascii?Q?v1RqntfeGe3RO2uWu5GM3wFgrtkvGZ4o82Xz6+zruHjZqSWmk5R5muLZm/P8?=
 =?us-ascii?Q?R3fTRUW+MwvCnSt87XnB47AJfRP8LiFmMYf5mpXqOpjKH64iXuGrI98jrho/?=
 =?us-ascii?Q?OwH0q1mKYCrCp1SdPeEl2ptxayKi7Hl0Xpz1gPYEmQlK7OsBI023buLb2div?=
 =?us-ascii?Q?CVdxOtP07/684gGeK0dp6OKet13pTchwAKnqoycoZUUlv4MN24crLnzNvCAe?=
 =?us-ascii?Q?e8lR3NRq4ae+0a8IOqZyEU0P3hI79EYW1ItnOKfXskz7p/te4oiI1OgDpruS?=
 =?us-ascii?Q?b1nQdhxlkWbRg3/6gNFlLDtVSutWsQKNZ13UNx1Xs2upaknyRvDLJfwxpduc?=
 =?us-ascii?Q?JkbaC7bRitYrPYIsGtSsrNevvTMsas5ZzFz36RNC0tbBHBBWQG3xf76JUoHU?=
 =?us-ascii?Q?egwhQBnAwklc7cd06Je5yxrob3b2vUvUrtn0Vj9UV5q7t6KOKp92A//JwwSw?=
 =?us-ascii?Q?+YQTu2aqAUi2IzMoGUqlieqnTaG2GQ6UwrCaf+wJ/HO+VogduOVE1KeVKztI?=
 =?us-ascii?Q?h43h/k1lEwyjmd6Ch/4KW6OOQu0n6lg6FAdWD3KtPqkSj6DlsSw2OhumMuAt?=
 =?us-ascii?Q?QwdXW4wLuLrB6kqnLagfnM+NiiYER1PlMe0RGQmYqneghtIc/Ka7hEIK6uVR?=
 =?us-ascii?Q?cTzp5RHRmheSAP4w2g7fVrXtkp3/emQ7E0S4Pz79xmJpaF+unTMlWM9f6qjC?=
 =?us-ascii?Q?KOFLth1w46N2Tn8SKHepvL3qZvN3B1c4K/AidDH0aPub7e+XtNGslLZUwIuT?=
 =?us-ascii?Q?bNzCNH7NTFaPAiakClMzmTmQ03eKgWvthvjdGEokwvKVas7Tvb3Kw+vivL2c?=
 =?us-ascii?Q?fBgoQGjBJb8ujFiIaK9IZhh8iF8W/UPNWK+Kn0PBjsryvk1jE6vZxwui3Jyf?=
 =?us-ascii?Q?wm7+M4GqwfaByRBA2XpUfKyiMJ0ZUzDuMtRT9cIrfh8HCw+emd+Y+O11cPem?=
 =?us-ascii?Q?2aj1fN0Rj9CmyYpD7w+Z5mivqF0Slt7yMkcA357o8wNTdgfVis3aUMBZ/C8S?=
 =?us-ascii?Q?JZ/5jfrfhCmICOmtUgaS7NMBCa3ZtpW4fKj4aTmm1CwVvbBkoagpZs9+q5UQ?=
 =?us-ascii?Q?BJiqyDKNGZHRnHrT1KXUpt6nWdJMxJoIwRJ/4zVtx08TlXQr6AiwCXhStrV/?=
 =?us-ascii?Q?Uby+98cwDCFRNS8Unh0J0sBGYPb82RLbb2Zux2mtfrSqU2I+2GxXcz35yWzb?=
 =?us-ascii?Q?NxDFUKgjfljH4/fLKBLxRz7Pwk+zPBgJcL5iRkxn0fDm+Ly2xFg1pJKwl7KV?=
 =?us-ascii?Q?DLhnVUW+BlWJmOhtPm0WQIRxOCgPqs5tKTtQkIGnXJmqeItrEoBQ?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fffa59d-82c0-45f4-f77c-08da2b00770c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2022 23:23:42.5866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6Box67vcXGUiW3srEO9D3qjnzkHutK/hNg3eT2q7suviZWh2RJWMnPN5elEcpyhiRb19FORTQXCC7gTU/ahmens8NSDY4Zev3jJo6O2ShJ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4802
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 2f187bfa6f35 ("net: ethernet: ocelot: remove the need for num_stats
initializer") added a flags field to the ocelot stats structure. The same
behavior can be achieved without this additional field taking up extra
memory.

Remove this structure element to free up RAM

Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 include/soc/mscc/ocelot.h | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 5c4f57cfa785..75739766244b 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -105,11 +105,9 @@
 #define REG_RESERVED_ADDR		0xffffffff
 #define REG_RESERVED(reg)		REG(reg, REG_RESERVED_ADDR)
 
-#define OCELOT_STAT_FLAG_END		BIT(0)
-
 #define for_each_stat(ocelot, stat)				\
 	for ((stat) = ocelot->stats_layout;			\
-	     !((stat)->flags & OCELOT_STAT_FLAG_END);		\
+	     ((stat)->name[0] != '\0');				\
 	     (stat)++)
 
 enum ocelot_target {
@@ -542,11 +540,10 @@ enum ocelot_ptp_pins {
 
 struct ocelot_stat_layout {
 	u32 offset;
-	u32 flags;
 	char name[ETH_GSTRING_LEN];
 };
 
-#define OCELOT_STAT_END { .flags = OCELOT_STAT_FLAG_END }
+#define OCELOT_STAT_END { .name = "" }
 
 struct ocelot_stats_region {
 	struct list_head node;
-- 
2.25.1

