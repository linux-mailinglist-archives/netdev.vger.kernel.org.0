Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 930155E7FDF
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 18:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbiIWQeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 12:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbiIWQdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 12:33:41 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60047.outbound.protection.outlook.com [40.107.6.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF05142E33;
        Fri, 23 Sep 2022 09:33:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WRZ72itl8pjv1Nte98BMc6J75wZ9PbPh3T+rx2BsA8c/+sut/ltd0qC3hC+og3RlkOsZEeAunL6+ySpciECGg+wdK6OriM2I573TAdsH5tsfxkwKr2f201gd7R6XhvKVjST0CbOl449VrdSorw3l2yT+6M/qY5nFlR0/94sLdo0G3w9MK3amz1vqMZGJ27kC/vsNgEwLYSVgGVOUgUq0Py0G+yJRaNjKVgfcF0h1MrLtQ1WsjS+UAkZfmSbQ4ayPaZkjZALeKDCwc1YnFtoHfGog2/1bjtkGD1tyvqkMWUh/ttdzqeBnGAptqEqXrIXqtSxGMRuq09GZL4IwSZraZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lLmnC85YIDZ5DOEopMRA98qQ2hxjkAF0WvLR56REzdw=;
 b=ADaL9W6OXbs5IH/s2j8+oUFp3viCgFEcwy7oMpbF4ygJw26Ej0dhctNhBPX7D6btPa3YbkwFN1/An/ut6FVxCBV5TxPeR/3l9EzL8HZi2vjbBT05xGGOP6Uz+eWuzGRRUn44nBJyDFLJD+bxSKLX9ybzo3DXeHSc8uTKMJMo4IPysbxSuqTKalCfuIHjT7/c3DgH3pPJlb8V2CtyEEdA/LOrFaRKzffgq76sNqHIZs/1RKD4iW0o3foC9x6EV1tMiDjYot7jRarY2r+JAcH2PlEHxXhJXa3fO85WffRiQSOc1TgEhCk/RG1Aey+/f62+05HROW2ESFq/yNOCDejq8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lLmnC85YIDZ5DOEopMRA98qQ2hxjkAF0WvLR56REzdw=;
 b=RNN2sBV2TIRVocQxbCnQn4xw/Aj26bPEhxE9/DFY1kroX45e0hgeXq9yiu+aWWj43EC050Uim6l2MNmDd6jWqYJRH8zwxpxLLnWPZM6fIGTmwsCsg6ZS2CxOCSQ57Y4IHPk3wRkge7KMKPm9JXluHoUw4s4nvAbLIXW65+GAnX4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7023.eurprd04.prod.outlook.com (2603:10a6:800:12f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Fri, 23 Sep
 2022 16:33:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Fri, 23 Sep 2022
 16:33:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 05/12] net: am65-cpsw: deny tc-taprio changes to per-tc max SDU
Date:   Fri, 23 Sep 2022 19:33:03 +0300
Message-Id: <20220923163310.3192733-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220923163310.3192733-1-vladimir.oltean@nxp.com>
References: <20220923163310.3192733-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0029.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::39) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|VI1PR04MB7023:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d2de802-912e-43f4-e1dc-08da9d815d53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ek0LdsXlS8PoDpC+cM63LQ1qnCV6heY46b7xtMS63jrB14uzc0pGzdYZXqjkWVNJmTcHWgDPajEnKi62na5QF6jd8hjQ5G2DaCXJ15+uGLGMa2/WVHTa4k0Rok9h8mdxNQyqSmIZsEDVCiBKzfjO2slc9w4nnRT25KeynEZyaRKx3wXmu+6eUpb+dtMPLFVFNA1uVwM+BMZRQRQU3p49gVabvVwJha1L36ag9Fsrm4PhmW37codDP3t8MVv5kjRolgzAduBw/zVlmMlt0xDEWgTXNX5i6PfAbIP+g+kE5dC7F+IcRy08V18qk1esn5tHtKw1oFdmQ8YZX23w0HF4LDofnzecB8sIgKZ1bzQUOtRORe5PyXy43Ywhtt0zqgI7YGB3oir/5mZuVtefMgwbIS6hdjr/nz4osETwP+80eRkvlxxK+Toz8yBJD61+5gEL2e5B7udtV8vx237pUBRvTNp0VfCDiW5it7+F2NdtJT8XFxyALLc6udfFWYnhD0TopSlJZWZqYYlI8/WYctiRv3uhPXwiSLCAdeV92rJew3KycHZ6H6VfvQrle82XLjXrXEEBbIB8ctAFT0AJl1Rnl5kOPJT3+YjRzN7MIa7oonfSIHjzdr6ifY3kjUvH/AePr89OK+bfdXlWhtIwDlKaUhBVjsCszqY/K/nCnEBrjxcj8EOEHTP+rxvdlvrHQLgNun5924QzwhjeXu0BwjgZAsPkqPjPDuUrSHr+MaGrSznry1PJSeKMZx059DNwHjvdfY5XEs9rAVK443mq451Q3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199015)(478600001)(6486002)(54906003)(4326008)(66556008)(66946007)(6512007)(6506007)(8936002)(66476007)(41300700001)(6666004)(26005)(7416002)(44832011)(8676002)(316002)(5660300002)(36756003)(6916009)(186003)(2906002)(2616005)(86362001)(52116002)(83380400001)(38350700002)(38100700002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xPMjtmkQRi/8Y478ngt2lAWnSO3A1yrchPK4ZrMHtMVXmsvtuU4aZ0MLrGEH?=
 =?us-ascii?Q?J/v+8qoQgSKXzv4DlEVFNnP9zdHpqhjpD5Q8ZLvjvT2UVVoD+TNouZkzR3lA?=
 =?us-ascii?Q?wu1Cj1o4lBk9YzVnfUEkMDYfEhMDbfXPey77Prl8n6GCDzm5dJkIuDIiviGR?=
 =?us-ascii?Q?nJX2xNd62bol/+hWZ19axfngf15TXhyFCzY1AlVC3pGjzC0M0PNDM5tv4gns?=
 =?us-ascii?Q?vHzL+AlG8h4s778KrO1rXg6p/fAcaMn0lFtuDQXYTRFuFz1KOK+gJ/c4TcgZ?=
 =?us-ascii?Q?I0nJugKstr1UFizt0qQp5eAyRPGiUOS06EWkrINpVQRrbWVKh9ZWwxKpV25s?=
 =?us-ascii?Q?ADl80GBZu7pGHhXtphNhGpp6mYaDbcJHyOGRNgrlNIGuvE2lB0ehzX/DLtSW?=
 =?us-ascii?Q?4HK7w+AcQ+jb/fHLBw0J86OYW9hQ5mYog29Vv1A7JQ4LbqMXsQU2Vdcna4Lj?=
 =?us-ascii?Q?VcY/ohNeSK5p3j/sRs7vHBCwL/KiuX7AzFxRbnoZyfeyeGVmWrc/mASsBh6q?=
 =?us-ascii?Q?n8etoRx7DctY0ooE4QzF5nwoNsuVCEcn83d0qOkh6AkOhnzHhXPqVPthOUG6?=
 =?us-ascii?Q?TGA5LwY988SoSDbBbTSdEyEEmN8G0tqA5gq+ON5zPu/LpaX6mhKgnSfD5sdA?=
 =?us-ascii?Q?ZGeGwQZrvPZ0pgGP2e+ldR6K4ECVnyFz8BveX1OfMhQurGMPODokuUQinsC0?=
 =?us-ascii?Q?u5rhdogeCH05cZ7z5czPgcw9LO+ytnvvhTXxAT8q3kz6Rf0gRZwaDkNCL4gW?=
 =?us-ascii?Q?RsoMmAIOwIvCosr+aXSa5svR8tpE/NlU3ElXJJ5WqL6Wu8cUA/Jo0Na0k0+u?=
 =?us-ascii?Q?rT+VdioXKxPdhmrIqK98ImzbNSJgE3mM5qyzUgtqfvffuiWQNyht6hT3Em5s?=
 =?us-ascii?Q?Univdrikt/IIWF9zWXq872IbCYIhISkR4wivIqMf24CRGlrL7QsAQ+ZZOfVq?=
 =?us-ascii?Q?4heKQHx61K82/lagnZpVxREw6Phf/F0/Hu2LAudPjzI+0Twk/IBJZqB2d9rk?=
 =?us-ascii?Q?Hgt3lM6KxSe8mwyp2bwr7tw7GUSS3Aei9GHiE7Sf23a5t3lYgLh/i4OAF/Mc?=
 =?us-ascii?Q?VuaCGzAJO1OthdiAkCf6WtkkaelNpSytIsalXRIQFigdARP9LCEy00cQk/4F?=
 =?us-ascii?Q?7L4hba+kUFW/RB+EHHf90Wd+9WwtM1fHsbGHwi+3VYfxahfgVmYpCEWWSTlP?=
 =?us-ascii?Q?YdyebcapEkqbGC0D29/5TPOHoCKJD1e/ldBfAY2E1xCAQzQeEAXPxNo8nQ+D?=
 =?us-ascii?Q?ydtCDIVKDmDbJ2NpQ3+GneQyPXa3TfGrP2vRexd2HvIgqXq9EOW7mzzsZAWX?=
 =?us-ascii?Q?rI61tn1dGXOfkkhb8RKk9aQPYNWKS7NnAcW9bL21VVEmWlWtafoZ5Dbhtia9?=
 =?us-ascii?Q?UMTFVA6uMPqkr0yFMzbXuQEWiAOLYerNCWXgTcnXiAcx3t0zhLCkbrRE8evY?=
 =?us-ascii?Q?4vTQIT9F4gBKohHHZZ8/N1KSd5K6IFkPDYdzW1+1CkLfeIk4vy19Hry+TCg7?=
 =?us-ascii?Q?zfm34PrD2VJvcQkVDpDZfPyeM+Haojhy4EPUMa7HLjQH6ntyuB6+Z8dVlt1w?=
 =?us-ascii?Q?/+KzLdSKisLLBKn5M5GPTpoJgEVqvYn4G9ls4awMaQHIMrDiEBrzS+xRO8Ni?=
 =?us-ascii?Q?hA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d2de802-912e-43f4-e1dc-08da9d815d53
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 16:33:37.0341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7DgbH6OV8L+dkJHdQTlBK31b41l05p7d27wBqyH6gdN21nYsjQ/8ykHySH4QKSyz44vbCMcmaH+p/2lhZ3ktmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7023
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the driver does not act upon the max_sdu argument, deny any other
values except the default all-zeroes, which means that all traffic
classes should use the same MTU as the port itself.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/ethernet/ti/am65-cpsw-qos.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-qos.c b/drivers/net/ethernet/ti/am65-cpsw-qos.c
index e162771893af..bd3b425083aa 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-qos.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-qos.c
@@ -503,7 +503,11 @@ static int am65_cpsw_set_taprio(struct net_device *ndev, void *type_data)
 	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
 	struct tc_taprio_qopt_offload *taprio = type_data;
 	struct am65_cpsw_est *est_new;
-	int ret = 0;
+	int tc, ret = 0;
+
+	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
+		if (taprio->max_sdu[tc])
+			return -EOPNOTSUPP;
 
 	if (taprio->cycle_time_extension) {
 		dev_err(&ndev->dev, "Failed to set cycle time extension");
-- 
2.34.1

