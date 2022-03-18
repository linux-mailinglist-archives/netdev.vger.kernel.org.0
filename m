Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2234D4DD590
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 08:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233296AbiCRHxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 03:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiCRHxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 03:53:09 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2139.outbound.protection.outlook.com [40.107.215.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0DE42C809B;
        Fri, 18 Mar 2022 00:51:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NY2cPV9+NJO4KUUuDDAcAZTDVU3Ws4mDxO8kdFdKTQ6Fi1uAWuJQLlvXJWH5f5KITfRKS4B5mF3hfzqZ4aBh/UTKCRLDVcLnu+liBaD5Y4mphmeyGbtW8tTFSxkziI6h/bcBLK/xhVQpv5QAxmb8Pqi1FL97TC/LteJZbM6gqfhcZzsm5rSrOJT7xAJx5uiOj+ocY08II94XQhpbReUxREky2kgvvIaukC+TVmMkTZu10GH6dz6E9nJuIZl+PUYIfdLEiHzonV8G1/xMAMQO/kviqjyzQspN6PzwDJVEveS/0mHPNr69dkHTslKS6bnAqFt6HwvTwIsSINBJLfeuGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r3suOggmh8vWhpKzX0q4hdAK+PiPcsVnABFhDdPd3NU=;
 b=D3mhdv48t/n6/1jzul9onSfA4FTQ+S+KbdV+dsHvMzyUm4jVJ1n+SeQKRG8jstXSMBXEGt2/pi2TtN/om/KUUhDxoBDIynqOEuzKzCvvhvEG6Dkda5rv9Dn+cd/tg4Cx7ZoI+wf5YJ5xtTmD1PiMEBV960EWKB/Bbxn6pNkxjb7MdepT2velF69LfqhhOHvrS9XwdZnHI7I59z3UcTdafb31KX0wmmq4H3h1hkdnuFdOHVf7pbPsNLqvmn3j+a4Qx7sGh4h3NY9IX9fe/WXYfodySQhyUJpi3vKkpeMiDb5pFkFUPf67LDl1jFT5uMIsgs8wq+znmMoWsafXEzrbdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r3suOggmh8vWhpKzX0q4hdAK+PiPcsVnABFhDdPd3NU=;
 b=RVMxYmSW7yGMiPS2pEt7WycTfF8okkNyHKLSOtrzjnV4qSA7Wfedr9+LUyGAF14mAyep4Y8FJqXec39qSCrrJIXpE+QK+Q1yo1N10TAO4Z0f5bOwZ4DHjpFbLUjJaHlHIDivVYVeY67oUjaXM8PmslL2fp2tyM/M/y+eeZzA3C4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com (2603:1096:202:2f::10)
 by HK0PR06MB2562.apcprd06.prod.outlook.com (2603:1096:203:67::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.16; Fri, 18 Mar
 2022 07:51:46 +0000
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::d924:a610:681d:6d59]) by HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::d924:a610:681d:6d59%5]) with mapi id 15.20.5081.018; Fri, 18 Mar 2022
 07:51:46 +0000
From:   Guo Zhengkui <guozhengkui@vivo.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK),
        linux-kernel@vger.kernel.org (open list)
Cc:     zhengkui_guo@outlook.com, Guo Zhengkui <guozhengkui@vivo.com>
Subject: [PATCH linux-next v2] selftests: net: change fprintf format specifiers
Date:   Fri, 18 Mar 2022 15:50:13 +0800
Message-Id: <20220318075013.48964-1-guozhengkui@vivo.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <1d21ee8a-837d-807d-14a4-4ee1af640089@vivo.com>
References: <1d21ee8a-837d-807d-14a4-4ee1af640089@vivo.com>
Content-Type: text/plain
X-ClientProxiedBy: HK0PR01CA0068.apcprd01.prod.exchangelabs.com
 (2603:1096:203:a6::32) To HK2PR06MB3492.apcprd06.prod.outlook.com
 (2603:1096:202:2f::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b29efe2-5598-4664-41c0-08da08b4267d
X-MS-TrafficTypeDiagnostic: HK0PR06MB2562:EE_
X-Microsoft-Antispam-PRVS: <HK0PR06MB2562C2513DB7450B73A58494C7139@HK0PR06MB2562.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4L13r9OtrtM+pcgTkmvw2pT1YM7LzfVAuLcf1k/tAe9s5kgGDjctELzfvjvhaBYQKbohMxoNWuM15kr7JvKc4M9zLdezwzloUIOivA7tsLruHB7AvbBwg5q607sdHBqnIK3uU1iHFOGtChzI+i3UtvM4gl18obbHrvxBjkwxnfKnrEdlknGp7D0n5Cm7lVpNebSikI4zN6yiH730OBD6Xq8Kwl9oUAAwy55tsLOeUyo1MDLszQo3PYsoYwDR2bpM2lYQjCAuIEcf8+CahbAjQvBWK6ULo6eeCdPDp2LNe/odS5wjEg9PB8wyB2nCS6BGmljVSW8DpMZs6ZWaRarKKMM/91+uku9jZCiYaUkV04NCbsfXKdBxir5obL86qGZOaTuOMaktNqAmqZwBKYI12baMyVXWhM/dCCdmaegvaAfDrGEks96puMPmqfcKZLeZasxZYohUQbZ4LfFzQZjxFIaKIR2FC/CmcO/x8RGvSHV7nT+w8S1naZhH6NSPvFHPsBs+tnOYt8uJjDgnPkA7WYQeAa8pGwr0OXxw3wBKBO992egTu6DjDI4nlu0wfYA2NJeRC08QxkOXCKr/93SNxyLtZijrsRXRawDuQ7fQtbnb5fSem45BLUQI3AFf8JfDRmvxlsphgh3JY9ht812dlKHynS0hynFdm2D7NNDJBxrROQd9mHJF8M6NRgFsInWk/EKN+oDbRHVejOkQb5Qe7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR06MB3492.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(5660300002)(6506007)(186003)(26005)(52116002)(6512007)(316002)(83380400001)(6666004)(36756003)(66476007)(66556008)(2906002)(8676002)(66946007)(4326008)(38350700002)(86362001)(1076003)(2616005)(107886003)(6486002)(38100700002)(508600001)(110136005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jp2WerYMIDoVOqe+pcSscgDErXnTGcRpbPgiznN4x+0/jID9N10c6b2DzkyY?=
 =?us-ascii?Q?fP8qUQm4W1/qLtETmjveONZXBvSxM4I6ZCq1Cd2L5kkvcMk3d70ZRS6P4PW9?=
 =?us-ascii?Q?jPDYvzGARzebWqcVtxw0/50+f11bveJ/Q668LQrBYsp+tzT8aVq35Nsie/NQ?=
 =?us-ascii?Q?sLgx2UNkGR7uz1aRnZDLutujoO+BHRPxFQzFqMNb7cFRWFpEmnRL7wf60StA?=
 =?us-ascii?Q?as6Q378ilLifQB09g9hGKgt+qgn5RQ0mF0cY/1RkANQFjpy4B0s/fPrJlQcR?=
 =?us-ascii?Q?QKDaIiEM3ZHxBVS3zATEEffLwXreO3+gRXRmGZN3EQ0u5pLMck20ijqQnNuk?=
 =?us-ascii?Q?KBc1qY645JDg+lzU1fBVmRZTqIkK90r8FJvv8gDLHEFbxd820cbUD4RUTwaC?=
 =?us-ascii?Q?7S610gvpcyRZ+ziKNASSohTVt1xGtdjPwNqwhkFCMgCR/wPQ/v+vWKxskLoY?=
 =?us-ascii?Q?veBISODNfqyXmH7nhwSZTxAMbpYT2WVmUBZSD/ClRqI6lAdPqfrUcE5SLgSV?=
 =?us-ascii?Q?gjiaZh/y1V0pUlKoSE3pmpV+XnM+Id+jamlyow4YkXTMKO3ci7G8WtpzSgeJ?=
 =?us-ascii?Q?rq0IBZBtZg9Q44SxEwfx9YYM4GATdC5UDk7grmpC5BU+JwDmID/yFFuw0RRf?=
 =?us-ascii?Q?dBmDguTy+sh6ZGlUABoMg5UnV2lwWzMH0R9mnXhanRYamP7pepyzwE4i6wga?=
 =?us-ascii?Q?L4E1KZTAmvED7k7JrgBvkxBTZ+jKo3MkKYPfs8zuDg5I39xblvEQWT81LJKP?=
 =?us-ascii?Q?zXBuedk7eEHyThZh6MU6hLqMovwaMIIvmTA0f96ds3VKgdnOtc/DQXdHjI4X?=
 =?us-ascii?Q?ESwCFfHuGhx+xR8luH7EBja4q0mm7WJIHvrhHgZRUPZSZJo7/x84YG7XrfmY?=
 =?us-ascii?Q?mHa7I0NHE0UkQCdJWiZQsjVTSs6qJo03zOUFCwwbs8Y7yMMEeBhtgVAtqNm2?=
 =?us-ascii?Q?bmp3xONYEuxg869bDRdTEfSiS1H3hP0M9TguT59sfQkih6HhVoAl/nZ26LVt?=
 =?us-ascii?Q?+Xwle4zWgAKTSK8smz6zo+lhXCRxgM1MYWCuD6Vij3ldhfjyhcrer04XIOV+?=
 =?us-ascii?Q?lE4tqAHgBKO/v3/LpXkXJki2Gg5AQmJs35uEYPfD+jbHJPI+TOEkOmutGRBe?=
 =?us-ascii?Q?KLfxZ7Ejrhdgeq8jBiwXA+8VfaGn0+FINZuyHdDPRBuYj2p7pscoV3pnCjSu?=
 =?us-ascii?Q?scz7w5supUZSeCIvqHeDzo0Ud8S8Sn5fLd2lUjB82eAiefyZrMK2VgR5//C+?=
 =?us-ascii?Q?t59mqzWrz+P85ccgNJr3Yg/SB/osbSnztQCF9x9ebb8kLN+jpTuE/F5eGsUA?=
 =?us-ascii?Q?CdQBu0hY6huqRt4Z78DDeq5YaYh+3Veb9W0yQRuYFjlChstu6OQGW4Za7VLf?=
 =?us-ascii?Q?qFlJ8oIh6yCbAq/b04f03QAf8hU03LCuQJ9FR5EAhTsxWTaTuVKk+3olApBm?=
 =?us-ascii?Q?/PTYnP+WtLGlBcH9jDp5jOBroSM2QiOX?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b29efe2-5598-4664-41c0-08da08b4267d
X-MS-Exchange-CrossTenant-AuthSource: HK2PR06MB3492.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 07:51:46.2193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TCMYkwqhu0U+CqfBL71nu9cvcPdqVS/5iJJA+l/3NYd7a0meudCKP/QjVmgdTmnv5wX69fAUmonPq7LT1jVzTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR06MB2562
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

`cur64`, `start64` and `ts_delta` are int64_t. Change
format specifiers in fprintf from '%lu' to '%ld'.

It has been tested with gcc (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0
on x86_64.

Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
---
 tools/testing/selftests/net/txtimestamp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/txtimestamp.c b/tools/testing/selftests/net/txtimestamp.c
index fabb1d555ee5..b8a52995a635 100644
--- a/tools/testing/selftests/net/txtimestamp.c
+++ b/tools/testing/selftests/net/txtimestamp.c
@@ -161,7 +161,7 @@ static void validate_timestamp(struct timespec *cur, int min_delay)
 	max_delay = min_delay + cfg_delay_tolerance_usec;
 
 	if (cur64 < start64 + min_delay || cur64 > start64 + max_delay) {
-		fprintf(stderr, "ERROR: %lu us expected between %d and %d\n",
+		fprintf(stderr, "ERROR: %ld us expected between %d and %d\n",
 				cur64 - start64, min_delay, max_delay);
 		test_failed = true;
 	}
@@ -170,9 +170,9 @@ static void validate_timestamp(struct timespec *cur, int min_delay)
 static void __print_ts_delta_formatted(int64_t ts_delta)
 {
 	if (cfg_print_nsec)
-		fprintf(stderr, "%lu ns", ts_delta);
+		fprintf(stderr, "%ld ns", ts_delta);
 	else
-		fprintf(stderr, "%lu us", ts_delta / NSEC_PER_USEC);
+		fprintf(stderr, "%ld us", ts_delta / NSEC_PER_USEC);
 }
 
 static void __print_timestamp(const char *name, struct timespec *cur,
-- 
2.17.1

