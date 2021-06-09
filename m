Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0593A1900
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 17:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238987AbhFIPSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 11:18:35 -0400
Received: from mail-am6eur05on2097.outbound.protection.outlook.com ([40.107.22.97]:56865
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233624AbhFIPS3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 11:18:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OqIUcTgc3mcQjB/QfsGt9BsZHA3cJbYkrx4kSamtycD+bHlHdSf2m1PMDlGfc+hQlLM/Gy6UHMYu1U7S08dgn+6kDHnacvvagUDt8Gsrerq3/ZFZ6jLv0JDTNFYbe3Slu4Lie2NAi0x14KthV9z/m0MLaLPa+g5DKdi/2RUS/e1e/5vrSF2MSSTfXW1idTgjsjQKZhwK1qpsowKgzb3FY5EHe0dbPUIO6fwnPQE93lzkxFvCrAUNMKPLtE6OxPPrudpt/DeTg/XM4zpP8OHt39mwrAdk2hAEj2uEwCMoaxnbz5y4sOAbfurgHj7dZEXa8SPvWRSkoynFPlpGUNNVUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VmbGEzBxatlasqDW5owM4tDfPSTDw4I7Yow5rSO0m1s=;
 b=WtEE16JRWG94+XMvaqIqUsrkP12BQwywKtQFG05MhDocVuUUtG4nDLXpbU8GRRWgSlREC4VITGueeTEX6i1Ipbq9y/nz3SZVC1pmhGl4IdmCQcO+n2jPW5SLe520Bz7Pz5eFhjPvkBj2owsFolhxsFSbR7y3dvIWrxuwHAcKT4t4J3y76jatEKK3/JiomLJX++AUTBgO3mpypg6dJJWYIm9JV8pZq5E4ov9r7CxzaDUuli0PET14HFkaY0DGV2QxrbCLUhIhr/UchAxXD2/xRQeV18y7bq0aH0a7WQAAUXywzPvGov5S0rzFxtdqkinHC0m4DKvZdlBUOySN+m11cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VmbGEzBxatlasqDW5owM4tDfPSTDw4I7Yow5rSO0m1s=;
 b=oUnzZTi42qL+XPg/3N7gtlmAxcgKf3Us7XGvqTVlNQCRC6lFPks6sF/t+/4T5wq3LLj3YVG1bPUoghYsxqjeM4dS5v7DEVffvkSTipabHZGreAFLYL5dkTeYAYwE7v09+GSBB5jAPbCA9brGnxeZYbtjfJqgB1HFB/GY9UJSv+Y=
Authentication-Results: plvision.eu; dkim=none (message not signed)
 header.d=none;plvision.eu; dmarc=none action=none header.from=plvision.eu;
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM9P190MB1427.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:3ea::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Wed, 9 Jun
 2021 15:16:29 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe%9]) with mapi id 15.20.4219.021; Wed, 9 Jun 2021
 15:16:29 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     oleksandr.mazur@plvision.eu, jiri@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, Shuah Khan <shuah@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net-next 04/11] testing: selftests: net: forwarding: add devlink-required functionality to test (hard) dropped stats field
Date:   Wed,  9 Jun 2021 18:15:54 +0300
Message-Id: <20210609151602.29004-5-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210609151602.29004-1-oleksandr.mazur@plvision.eu>
References: <20210609151602.29004-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM0PR06CA0092.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::33) To AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:19b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from omazur.x.ow.s (217.20.186.93) by AM0PR06CA0092.eurprd06.prod.outlook.com (2603:10a6:208:fa::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Wed, 9 Jun 2021 15:16:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92106e35-3649-4ddb-3dbe-08d92b598e59
X-MS-TrafficTypeDiagnostic: AM9P190MB1427:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9P190MB1427DC0C08F117A4864668E8E4369@AM9P190MB1427.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:431;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vxX9xZGtS0xCafhFp7n0ECOJdYMsqphsJLUrpUgkAAsW6O/Xf585FWi0MKLuLi1K9x/73chQC+5dtF/JL3K/dHJxIbUl+H0y5UB/deogWOQmCVMk+riOtNyqt4cm3d9ZQFKDRsIFLhSz5jjjJnJI7LeEFjVxCfn+f4qIAILZ16CHsIF185+nrf8uWACjotM51Qnavb+Jr2l0h66VD2xneItgBAkYC1f6k6b1wNEmn9sE8r2avgmcsPyz93BwnRPohxnMISASoQZhpscmNlYosnFvUtJMm9Q9pNf1d9T5jSlggFPpLjl37Za0I2Y4TM17lPj8CXyQwQlBZadC2z9IFZfSWugHVyYnOB/ZQ7pGZzCglVJt6fDszjeFWy96CuXEnQjE3JR4vJxGDtAkoroarUv1yScF2KLh6xKtSvGmiNefiBQkY7fdd0Wzb1KKNaBAfrUmlhvZWQxkMjBU/zCMmoniUy2djunkzsnrylpBBHQn50JxA0b0OmTOs8dbEBR6WwK8pS/pP7tX+vBYx/B33Skp2yBjJhCsqyY2GQj1ACxRzDXbvsppHbnbnnH5DCCA+5a9uKwwkUn/YG4Q8HG8chiLwsIdq9U2+JittwUyaK0iocpvK0JhKVWfLSEZ2zLhovdK9DOdAW7OAkX3RoDEFRdsqidTRbzPV5RVN8CK2yo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(136003)(39830400003)(366004)(83380400001)(956004)(52116002)(2906002)(1076003)(186003)(66556008)(66946007)(16526019)(6506007)(2616005)(6486002)(6666004)(26005)(66476007)(38350700002)(8676002)(36756003)(86362001)(4326008)(6916009)(5660300002)(478600001)(44832011)(6512007)(38100700002)(316002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?zHpvveKkWxNzgz/zD1pXMKFumLdWRilktgdnqTFCiXZeFT8LCl/yjWXjTWGX?=
 =?us-ascii?Q?EimhiL7w0BSCS7GX/3wuF/7vCJGqbkwNbSCkID5NngveTvwpJnNli3gWt+P1?=
 =?us-ascii?Q?kSGVpxoRC1taL8Dbh9upwczlbJqhOzr55oMTtBOnUHTwQIPbyxeJD5UpeKWo?=
 =?us-ascii?Q?BjB3wkOvlKuLsLvU12jcX6PszswW/QxfFCg2r6IbJvLW6oleg5cVjTZ8+pI/?=
 =?us-ascii?Q?/Q/R7Y/upbTFlrq9ZgfxIbr2Gzp43YrJOZ9MP3X1GsatFbzEA5T/d+Sc4yCU?=
 =?us-ascii?Q?s8ExZt5UBCe5uwB+rU6snk7VXebgX6mC8w56EZI1SBnqbgmX5bvRgMAfoCX0?=
 =?us-ascii?Q?y9RPdKIthypKX7bQP5b2CE2UGvjzOE6oDzdBGwxUlB4+ruqeGMU1kqvds1uQ?=
 =?us-ascii?Q?DUL3aBl1V09LsujJWP09SM6Pwrus9OejWo8158nKCowTqtjt61E0TeulCfw7?=
 =?us-ascii?Q?+nishcyGZsh9Qre9GQh0NGGPUqH5ls+pjVjWuoouGYcwUsMnRBH1sktmDNT7?=
 =?us-ascii?Q?BU/tY2qqsinaDSh06UDU9+Z0YVj10pXLut04nYGx8EC/QZk4/VJ0OMcHsLye?=
 =?us-ascii?Q?G39jWyM/RhRJrmM8d5vrUSPlCfcO7PCbQK0VeFDM/UMW8s2j2mQiMlsBdWLM?=
 =?us-ascii?Q?PyX1VwCKGiCLQ57XYRYtW0TAQsB9sdGQT3u+zB8wBvzzg2PA5/bB2WaRy8lt?=
 =?us-ascii?Q?1eFCEqi2YNuXwRhCk+kCNQbnEmxlRp2+zlXRKtoW8f+y6gGm0XsSAA3fnIDh?=
 =?us-ascii?Q?Y4FbqcojEhtMRD7nL5Up5HPJC6P2rqAEfKdCfiP/CkpqRAt/QwQAnOE/eBx5?=
 =?us-ascii?Q?o7RnixSfbqG2QQu8XWfyt9IHuLm95lHvY8pwODv0Yb3keS6p9Oqtq810MUMw?=
 =?us-ascii?Q?nb6Ckh5Ozm/2+DmMCvLeAuzVb75QU2SYKQXai7+luSqfvC/aRQ3jRJA34KxS?=
 =?us-ascii?Q?sjNwgFybUKw6TbxjvLfF8N8REOHW0Z5URjgpYi33/FMkCocMBg4jWBjYGj/+?=
 =?us-ascii?Q?nq1Tvq043jQV0A5p/Rz36kVay3g0G8QAHpLwxg/cyd2fBseGJmC9VO5LCqGU?=
 =?us-ascii?Q?cut/DF69WZoFw6omxErLHEfsdxkKMFb3uhYfCdZSfMyJ60yAqNqizlEV3BPG?=
 =?us-ascii?Q?QFDuVhSewuxHi27elVhKvS0eyZQR41kJcYPRDRoNpGxnMDgR7EyF2tYBXjCh?=
 =?us-ascii?Q?Dvo0e7eLZSI2nWBJkO3/3pWnn/lFpdWgjrJ0ezR3INwWPG2gdG7hznZ+QVk3?=
 =?us-ascii?Q?Y6ySHxsIQu5oYpnhLHdjiEQ1uBN8iIou6UiyNuJVMR6Rn0z2hKWiWVg9g9NA?=
 =?us-ascii?Q?wvyry/1pAO16WYI0bISD85X8?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 92106e35-3649-4ddb-3dbe-08d92b598e59
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 15:16:29.1008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nUdJi1c1iIkuHyxzBzSGCW+Z/MBKYo4iMxHB0i7dJv2OXtyrimN/lpbDFK4kS2x8WuiILnfkaLPDPkkSo5uPrBcQMrrQO/nDm9eKfaA4rR4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1427
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add devlink_trap_drop_packets_get function, as well as test that are
used to verify devlink (hard) dropped stats functionality works.

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 .../selftests/net/forwarding/devlink_lib.sh   | 26 +++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/devlink_lib.sh b/tools/testing/selftests/net/forwarding/devlink_lib.sh
index c19e001f138b..22931dcfa182 100644
--- a/tools/testing/selftests/net/forwarding/devlink_lib.sh
+++ b/tools/testing/selftests/net/forwarding/devlink_lib.sh
@@ -324,6 +324,14 @@ devlink_trap_rx_bytes_get()
 		| jq '.[][][]["stats"]["rx"]["bytes"]'
 }
 
+devlink_trap_drop_packets_get()
+{
+	local trap_name=$1; shift
+
+	devlink -js trap show $DEVLINK_DEV trap $trap_name \
+		| jq '.[][][]["stats"]["rx"]["dropped"]'
+}
+
 devlink_trap_stats_idle_test()
 {
 	local trap_name=$1; shift
@@ -345,6 +353,24 @@ devlink_trap_stats_idle_test()
 	fi
 }
 
+devlink_trap_drop_stats_idle_test()
+{
+	local trap_name=$1; shift
+	local t0_packets t0_bytes
+
+	t0_packets=$(devlink_trap_drop_packets_get $trap_name)
+
+	sleep 1
+
+	t1_packets=$(devlink_trap_drop_packets_get $trap_name)
+
+	if [[ $t0_packets -eq $t1_packets ]]; then
+		return 0
+	else
+		return 1
+	fi
+}
+
 devlink_traps_enable_all()
 {
 	local trap_name
-- 
2.17.1

