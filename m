Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA5D24DE6C7
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 08:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242386AbiCSHjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 03:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234551AbiCSHjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 03:39:11 -0400
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2110.outbound.protection.outlook.com [40.107.255.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D902D1FEB;
        Sat, 19 Mar 2022 00:37:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O7dm2uK016EXYLGc8B46++Qwbr5CyH+423vP/YrNGVmx0O9ZUnRBJ47Eu2omySNRCyjOtnGa/Ub4nctRJE6b4B1Z7RLdiRd1oCVHV+fuv8Gp+s+XQbdCzzs1I1YUjT1JueL6ri1l3CfrnOuk1ifqXbu4VXQbJ9Gv0n3hwjW9QN3iA7kiD6RMvsX622XpFKPIW2MtKofEaUfjdI6UTyzBX5js48xdiTkKHTHZ+ZaTvZM9oSMm9tv8WYOa3AifHObyHOwFCOol9JTZpUPRJr3sxP53gRcSsEuNmQ+gf1kiF/0zeMX5zV6hgfTTzLqDrGiHwWKzMbDWV8qgvos5SDji4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v3m5VZU/3q5Yy/XIHqlCbbESLAaoC3UyoL+79tdJB/c=;
 b=lSY5cL20Lt2Fzc8iMTQRBRT3Kz6GMCQK7Go8InCAjfV+5twdmSSIVB/PNUgGNP7qoabwhDUsdJdJwBd5YnlCN6rSP1O+ubuWd33FqM89Z6OiIqLhpMQzoZRMDR5vOmsnZipSJrfuVuYPMASbdiXut6qTSTRnJmAJuiYYD5mH3pcU0JWMWcZMDpJsZPykmUOYeYNXPBNWyf7DYC3uzC0tl4xRwe1AO3vQfMjHZGP45D238Zd7Ef9xVd4U6e/T6H7y5HEr+8nyPQJfRlw6XVJ+JkD5pshMtKD1t4/Su8+S/pe44kPKUSRHWCrubciznIV+1IZxchaEmOTncNpMKRyk5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v3m5VZU/3q5Yy/XIHqlCbbESLAaoC3UyoL+79tdJB/c=;
 b=R3cJsgwgPGQckq/cPUBAfPgl4W6m0ZdKx6kS1+2LQS4MQT5J4i36RPw9Nkeor5uOXK1ZdQEWX5LMaFbB6TOmTi+WUTiF9XRDc/e5dK+rnLKgMBnBUlbv3ut2M2cLxXFSLFX3IhS9gRAw7ppV93wSHqMWVqkOFOJHRnq2xer600w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com (2603:1096:202:2f::10)
 by SG2PR06MB2966.apcprd06.prod.outlook.com (2603:1096:4:70::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.19; Sat, 19 Mar
 2022 07:37:44 +0000
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::d924:a610:681d:6d59]) by HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::d924:a610:681d:6d59%5]) with mapi id 15.20.5081.018; Sat, 19 Mar 2022
 07:37:44 +0000
From:   Guo Zhengkui <guozhengkui@vivo.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK),
        linux-kernel@vger.kernel.org (open list)
Cc:     zhengkui_guo@outlook.com, Guo Zhengkui <guozhengkui@vivo.com>
Subject: [PATCH linux-next v3] selftests: net: change fprintf format specifiers
Date:   Sat, 19 Mar 2022 15:37:30 +0800
Message-Id: <20220319073730.5235-1-guozhengkui@vivo.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220318093300.2938e068@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220318093300.2938e068@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2P15301CA0001.APCP153.PROD.OUTLOOK.COM
 (2603:1096:202:1::11) To HK2PR06MB3492.apcprd06.prod.outlook.com
 (2603:1096:202:2f::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a6473590-241f-4d4e-ce04-08da097b5b35
X-MS-TrafficTypeDiagnostic: SG2PR06MB2966:EE_
X-Microsoft-Antispam-PRVS: <SG2PR06MB2966BCF24CA67E76FD030F11C7149@SG2PR06MB2966.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CiGC3REQeZGCs0Q/PDlyD0wZ9fHLIW2+Dpv+H34Ei2fUl9V6jg4EumAxcP/9zl1Z+/W3bhQruA3Y7aZOfy9av2uStyNompFOxs7c2uqKiaUnvIzbmbf98zf3ZEliM4OJu/DjwdEtLfcmZxRzfCFA8O9rMWeebihExdh9yV/9s4/jqX2NphYYLuysZUTqI6gtYHfrOY+qyqgDzIKuvbypL0Il97VnZF56bLDF9R6Apnu9eK0IWQRzesLpUfRVZl6a24pHCVLbj+QoaKV/m6pcT8nJPZjsXNmTUB5Z+TXMwTUbZI/OLT/01mBpRh/yawisgGQ8L+2b5TM/5KMAuhEZWIAJn0m/7BcETfwupsTQ/xSfSwNAlKWvEt8fBt1V4W6y3greAeefoEv5Andz5yY/szGSBijTQ7/mDzSY8Z6EISiEy2HF0O4zZnNGcDqnIUeOmN/n13A5xr3vSlyvr348xCys1pdjLaKC6UvPMwo+xBmfJkeQT5nkMIJ1BniYotc6SW1RFQeqY+CH28WZvo6Hhiua1GRjp9oHpas2HkPK8bL3WuAU0xqHSxLiNgY59PR8gU8VBNOCH+bA4n927gXBP69YBb6zS/v1AeQVRXqj7YsmrTZig5/tm0DHYTq8eeWLRtgokZ9j24Ls/SLY979GQAnuhIeSsW32Jk9m/kOcrFlUG7xW0b2sHNOqEEFGLer/JOL9rC1dypVSmJsqgT+fGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR06MB3492.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(110136005)(36756003)(316002)(38350700002)(38100700002)(5660300002)(6506007)(52116002)(6512007)(4326008)(8676002)(66556008)(66946007)(8936002)(6486002)(1076003)(107886003)(86362001)(66476007)(26005)(186003)(83380400001)(2616005)(508600001)(6666004)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y36UZxgvDacG/AlYyEpBX/exeU82uCvNtZ/vFcVSy/EABeJ6A8xLjoRTxKMc?=
 =?us-ascii?Q?A0798hChmAa4OpiKBEIcfRbfboBO45gjUDKbexlHOSLe5o1BY+BwxHPZ8gQJ?=
 =?us-ascii?Q?4GD4l0xbYnTdDY1gRaGQ707d1X8feSFOs4G/twSOpmzBF0HWRl/9cwgj8xtB?=
 =?us-ascii?Q?gfBFdt9MNR3rsL6DBoQhDWfnQ2HW7zCg0VtitaS+C9wdHgfTcie4oNUPtQHk?=
 =?us-ascii?Q?QLg29GSE4afsKFQlHpfLcJVEj/zGpvJOgt6CSHLK45OoYKmsB7BrBl03/5EM?=
 =?us-ascii?Q?/GLU15+A22AJNJAjqqTMRSqwk/1tZhbcgmLq88C4Az6o+7as7BHEo9Q+n5Nu?=
 =?us-ascii?Q?bTF5I4I8vcjoiQrkDdMc+ELz4Y/Vvb90zAjuQ50B8t28kz3syVNMAlZQ0Za/?=
 =?us-ascii?Q?GTuyPIA0vLAaVA0aBd9yPDpFjqFxK3hXkVq8W86Exam7GfTnA17B3JBCQYlK?=
 =?us-ascii?Q?edx2t1oXBfyjj6qvk7xm+Zu529vVOxiS302cdYcUabvb0ciLbrQU6OpZVaM9?=
 =?us-ascii?Q?hrFhFTEK+c+kJfiJCzOOmkgpyRWgmnJf5gzFXQxjNLIoZMJMCcgEyVZ7LO92?=
 =?us-ascii?Q?9SK3tqoma0PtgwT7vYyUhagANvr1n8QnHFnD+HYDCFueEPB1QItaqnUc81oE?=
 =?us-ascii?Q?G3I6xYk7avOTNBKyiM5ctFqLtXB6UyPumVRACj4q/TmU+8djuMuTCFwVpZ19?=
 =?us-ascii?Q?1CPO7TSCYaV/LQf1fhU5t1o8S9/UAPkZJMrhCbb0qbEZqjydr1SQ+6lsW2W2?=
 =?us-ascii?Q?vuvR0DNBJRc5wbdLWRdVtyRYTNhtdMm1BmJuT0Xd1zl97Jfk1eH0QDZ2YLSf?=
 =?us-ascii?Q?GnI5S1Adwj87tHwx7pKRgKqomLi9oTQLlcMpPMgMyjRmVHnpy/ZrQ9XSVNWK?=
 =?us-ascii?Q?obQwP1gFQYEl3W/BVhwFGXXKpxrvvzUdQe1COIbvjEK5fSx2ycm3BBW1HyI8?=
 =?us-ascii?Q?/6NJGUwbI6Ycbh8xkFHoQx0nyYUXyLNg/LTNrPAgAVmSNAgXcTAI+GSO+kto?=
 =?us-ascii?Q?mGFvN/fVPfFC3fWe14w0Z0innkp7zzpxGpg5bOHyQaZaW9NKNqXr8Pm8F6ID?=
 =?us-ascii?Q?Vp2bP8hQ1yx5tOlIBWiXY0zrmpGV4X2AEx2JjN33XaUiOv9Mrexbg6uegKg9?=
 =?us-ascii?Q?1hZmBB7IUlWVaeUHAVp0tC6j1Fg67AzpENBGezjaPl+GMoFbNBcQsc+SGTpo?=
 =?us-ascii?Q?Xj03gd5iyYDjeaO5NEisjLxSXeO28TqOMqy9/wIoPXI7MAMff/OtcfcErEKA?=
 =?us-ascii?Q?Wzcc5vTwEX4Xgl2YL8oOQ68uIaxF45ujKZb5TAoE8J/jcYp0g5MN2SyAqnqM?=
 =?us-ascii?Q?0lz5rUQFwPAwrf9LW3e19u/eBapDv+a+PCdBm2okMg2PEkWvly/P8iqhRBa6?=
 =?us-ascii?Q?cK2sxHNWhuXjZ/an6LG32q5CZGy8VjNVih9eMzuVSNzjaa9IDx1zaRIKc9Hs?=
 =?us-ascii?Q?ClwyNvBJfoVyzKtbFlPpjoiMWlLObyfl?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6473590-241f-4d4e-ce04-08da097b5b35
X-MS-Exchange-CrossTenant-AuthSource: HK2PR06MB3492.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2022 07:37:44.4414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IqxG8OlwigYOlvznNNX3DFe99BQtDjPhLUUPNp+2hJUjadRoxNDzNRmZcOW6hlK3VRESZFI/PJaYocIRFyIWHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR06MB2966
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

`cur64`, `start64` and `ts_delta` are int64_t. Change format
specifiers in fprintf from `"%lu"` to `"%" PRId64` to adapt
to 32-bit and 64-bit systems.

Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
---
 tools/testing/selftests/net/txtimestamp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/txtimestamp.c b/tools/testing/selftests/net/txtimestamp.c
index fabb1d555ee5..10f2fde3686b 100644
--- a/tools/testing/selftests/net/txtimestamp.c
+++ b/tools/testing/selftests/net/txtimestamp.c
@@ -161,7 +161,7 @@ static void validate_timestamp(struct timespec *cur, int min_delay)
 	max_delay = min_delay + cfg_delay_tolerance_usec;
 
 	if (cur64 < start64 + min_delay || cur64 > start64 + max_delay) {
-		fprintf(stderr, "ERROR: %lu us expected between %d and %d\n",
+		fprintf(stderr, "ERROR: %" PRId64 " us expected between %d and %d\n",
 				cur64 - start64, min_delay, max_delay);
 		test_failed = true;
 	}
@@ -170,9 +170,9 @@ static void validate_timestamp(struct timespec *cur, int min_delay)
 static void __print_ts_delta_formatted(int64_t ts_delta)
 {
 	if (cfg_print_nsec)
-		fprintf(stderr, "%lu ns", ts_delta);
+		fprintf(stderr, "%" PRId64 " ns", ts_delta);
 	else
-		fprintf(stderr, "%lu us", ts_delta / NSEC_PER_USEC);
+		fprintf(stderr, "%" PRId64 " us", ts_delta / NSEC_PER_USEC);
 }
 
 static void __print_timestamp(const char *name, struct timespec *cur,
-- 
2.20.1

