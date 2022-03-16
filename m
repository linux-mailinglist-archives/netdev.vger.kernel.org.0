Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 935514DAF20
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 12:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355434AbiCPLwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 07:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355413AbiCPLwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 07:52:14 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2093.outbound.protection.outlook.com [40.107.215.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C065C356;
        Wed, 16 Mar 2022 04:51:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mJ4XCrtrh19hWphlO/1xY2mgrBDeILntMg00FrLoKOf+/JKE1Xx6EEsFtkxj0HzW2YmCoNIZ7WQSESLbU1MY70Et05DgnNEZksOKPlG59wzNoTAbbEiP+2zTN2JEa2ZPv8qSyuyGGIYDBBayazoiEiH+w2nQK1oHFR5Q+3kA4kaeDaSN5VFZBz2YSZuhme6o9lbb8dJzYvFU2Q3lcVfi0LeQp5iitaw8jtqhC+gzat64rQHpKofJhv9uRiz83/fOgm7LJZ9tXr6vTT6x0VHiJgmx+RlWHcjb5h8FaMc3CXRY02PRFPrf3R0MidSShjViOUKFsxxDChZzwYW7g7SFTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uiVx27Mvex4dhqzT/VAOCzcwI1rN6yG1kQOWCrjkS04=;
 b=l6/bHPm0OwQJ11iXhEWUE0oYdssFmJZ2KPYGeIIrG+HzWhbionn7hClXk0LaQJXdX6vV/wAvYOZlWnVHcxpMwEKTVy3ba+5PqCzFYDELdpiyMRjiH4eX8JcYNdRLJBFuLp9a820FoiLn+Uqq09SfP9n41mMMmVm3CXQf35hGxE98qGPc2VHw5Ckot/6pkhZ3LUgZqVFl9+i73ooTRLgESqT2foRgKpvyxLXl0n+5Qe4ZDLOsnP/Qry36+A5Xvlw4y8C29QOoskQKbQA/WzaVD6T4gN8KU8jiBi0k9Fz3okHCtZpf6x41iOyxWC1mjBITUpqtvoDdX+tghDpIBKJvCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uiVx27Mvex4dhqzT/VAOCzcwI1rN6yG1kQOWCrjkS04=;
 b=NcaSu6XjuiYf42c1c7Zsl4YNuz5Zz2EIjIQPNmwAOsE1k3PBxFAsPnlYb6g7ghDFAlAS2CAoSboOC/v97k728P8epaslTkw9XAgCkkCG4v46ZwJiZpMnuomqo9vgF/ilxCwtx0DYDJfEeAfXEgvx5vJNr7C//K/eZ4xzMY5QZIU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com (2603:1096:202:2f::10)
 by PS1PR06MB2888.apcprd06.prod.outlook.com (2603:1096:803:46::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.26; Wed, 16 Mar
 2022 11:50:54 +0000
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::d924:a610:681d:6d59]) by HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::d924:a610:681d:6d59%5]) with mapi id 15.20.5061.029; Wed, 16 Mar 2022
 11:50:54 +0000
From:   Guo Zhengkui <guozhengkui@vivo.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK),
        linux-kernel@vger.kernel.org (open list)
Cc:     zhengkui_guo@outlook.com, Guo Zhengkui <guozhengkui@vivo.com>
Subject: [PATCH] selftests: net: fix warning when compiling selftest/net
Date:   Wed, 16 Mar 2022 19:50:40 +0800
Message-Id: <20220316115040.10876-1-guozhengkui@vivo.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0143.apcprd02.prod.outlook.com
 (2603:1096:202:16::27) To HK2PR06MB3492.apcprd06.prod.outlook.com
 (2603:1096:202:2f::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 63fb3f39-4d1b-4206-2e3d-08da07433a03
X-MS-TrafficTypeDiagnostic: PS1PR06MB2888:EE_
X-Microsoft-Antispam-PRVS: <PS1PR06MB2888010014E9E4F46F3BB75CC7119@PS1PR06MB2888.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bKW+VZRmbJnpU31yk/wAJfuyL7E9FFhmXPJpcnFM0SJZ6lwOBC/QV02o4iZbWgWdsWwAtzrZFVlqjM58/BKi5zzF9N1nepr5k2GAUhdVOAPD82Sfys6NywrlUARHTSs3gVbTZLSV78LfLBiQyEMytFFUKxl2lRRzdgDScM1mKRFFiap45dVTVp2yRTRbaffupB6yTdj5B/XCS1A+skxSgJr1DhYoUpduLcTcTVMq3Jzi1SXRAihKFlEHH7GgriUmu6zRI8A5TnUiSGVb8MHxSaR99YN2a+2nJuOTmQJyqzH2TNIMKWTzkwJ0/hrA9c9RWKjuVXbVKsg0+6WW0v8UhoSjPywB9BOsvKHKt2JZTBUrxhEES5Lkaqs9WWXowybvUBeNgm8WfG8a6I0uKJRneZpY0v8GHMiE8a71eBqtgvSpr2PBx6jhb87YY6J4DZGwchlyea4fnVVCHbIR8dRH7NBY1T82ULzbdQubMGu8w2TrU8wrOnwmVEDzrr69hJqv0qlDYNImCZcZrLbuOi2Sd48m0v+edwx53H95xIrPEnG0atWOAk9CuOMif0smeQ09VZmr9Q2HnxTyndmxR661byT5ifFpVdrRzDsERaqsJ/Zcz2dvl2rgISC+xag1wTNWNMFR7GOsQ9iJcFNKCXzmZhD6XKNfLhD1NAx3WWbBCSlPpG92hhmNW9jcLwlZtKi/05k3K7WhD8jcnQPAo4mNiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR06MB3492.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(83380400001)(38100700002)(36756003)(38350700002)(110136005)(186003)(2616005)(1076003)(26005)(6486002)(5660300002)(107886003)(508600001)(8676002)(6506007)(6666004)(6512007)(2906002)(52116002)(66476007)(4326008)(66556008)(66946007)(8936002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z7zVBlQvE3Mks9Sp7jddl4/mmW1jTv4X0/vgCp6aqGpB2d1PEwmzqc9OQ3tl?=
 =?us-ascii?Q?lAxQOYcpqb/kzmVhwEWW0ZwIznNK/tqGKvbQPQ3SYVkYqluWRcy6xIlS0cIL?=
 =?us-ascii?Q?46djxL0fHqI0VUwTcjcZqdyguTh48kLPHcmNIefiDpDBoaI8aeOoww/AqkpB?=
 =?us-ascii?Q?z3jhNL2wM4CrjdmCMdNhSKIJLEePY1mjNJNa2clV6IiL2igCUx0bnUvoIFg0?=
 =?us-ascii?Q?oOhQkWTdgjVjcQ7pqjkw60vTdphfuqqUB4Vz5cQjD8QCuOtl0mLphytQe6Mr?=
 =?us-ascii?Q?4F4+E3q0sVN6/F38KyIPvOs1MCiKFOShXx8ndyQmuRUa+VA0YY0L+PGenjvF?=
 =?us-ascii?Q?DtPLJyS7f0jkPDBIAy0eMPo4O43irieE5dtvmsHynpQ/FdjPJqQTq4SNMK+u?=
 =?us-ascii?Q?B7ZkaiRLtzdyXRYYTMbG1cNmKACbZ3WFMy2XbmK13HzadZXSBtGZOxgWgiQ4?=
 =?us-ascii?Q?sXonBqrx9TD1VwRfyqpIVDUfUrVH6V5nYCPTDt7VWwFw7lWoGKJqUNZzwV62?=
 =?us-ascii?Q?Vp+lADM+X8lW5//qfPWinoXncAlr/S9Nfox9wo1rReRAe+xpmgk3eNWrpYd9?=
 =?us-ascii?Q?un1Z05/CUTb4i7K75jtvRIHyJR0aiMhSF+cpgCI8zKxJGSjMuZSObDgC2ZO8?=
 =?us-ascii?Q?swCqi1LTiZv/HjeBMha8kZHIuUdCX829MpsHveHyAfcsrYbIs6HGrp0T1zFa?=
 =?us-ascii?Q?SO8BV2HkZNXe6Ls57fb0jLhLe0y2Si3+lCexrKC9TjHXG7tn8sCsJpZESw0j?=
 =?us-ascii?Q?38LcuT0i06RbCvljx351L7TIg+RqZRA+oJs86Y44FoYvkwTT7fZn6NB0HZKt?=
 =?us-ascii?Q?i0w2p7WWJ6+hrKHqPnp7Pb/4s5Xxsd/N5DqXQDopj8ECeV4uDYkJyw7Xd4Ky?=
 =?us-ascii?Q?6ZPTIaQxjzCU+EVfwMxxkM7H5dSCbTYRA/WbyYBpFPFV40knZLN5KJvU9saw?=
 =?us-ascii?Q?jjb/sNzo74Qb0T8gkT5rno2mVnUDDxC3fD8XfRx2PsgpfV+VnUcFWloDeDh/?=
 =?us-ascii?Q?QpTCnmpZOPUJd4izjItdgzZdzoUP4ufrfURbFq2S0Vpcf3Zqc3C9PHNets8I?=
 =?us-ascii?Q?iYIPPZ8c55ckpszMwoCasNDAnBdHuQw7fReEvbtLh7FOe+y8kP/aU5JxImZ1?=
 =?us-ascii?Q?PnU7m0CSX0/VsVczQYHjn0nhIHHSfzGYOjWp775E0qSfqJAkT40IPSfxVLCX?=
 =?us-ascii?Q?HaNTaLpWAFkZK56/ivfv8X1mEVtuzG0pJlUa8eohRL4Wclks/L8KzyMqx8GS?=
 =?us-ascii?Q?bb4RsCW+Cmvladk2uGZVz/+GH3CZl8wAY90OOX8qAY1cT54GEBs4wHGmmK/T?=
 =?us-ascii?Q?lS6ovea9D8OkTZ4SnQLgNP5md+Ib7+y8lJs/FURnPTxnpvnYgT8/oBP4ZXo7?=
 =?us-ascii?Q?OlEgm11YH/ZeQZaAjyuhSBRs8MvqiLTCfaO+oM1y0MLzSSJaZKwAMSrqWkMU?=
 =?us-ascii?Q?geHnrerkKmOQ7ikdhWs3P4IlETpf9BQV?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63fb3f39-4d1b-4206-2e3d-08da07433a03
X-MS-Exchange-CrossTenant-AuthSource: HK2PR06MB3492.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2022 11:50:54.5242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JUdgfkhdDGomhi62PnIVtzWczGjQePc3yzaKRz6AJZjhGhh6JdF0McxXTJACsGL8SHIaBP97ohEOYbAQUMP4Yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PS1PR06MB2888
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When I compile tools/testing/selftests/net/ by
`make -C tools/testing/selftests/net` with gcc (Debian 8.3.0-6) 8.3.0,
it reports the following warnings:

txtimestamp.c: In function 'validate_timestamp':
txtimestamp.c:164:29: warning: format '%lu' expects argument of type
'long unsigned int', but argument 3 has type 'int64_t'
{aka 'long long int'} [-Wformat=]
   fprintf(stderr, "ERROR: %lu us expected between %d and %d\n",
                           ~~^
                           %llu
     cur64 - start64, min_delay, max_delay);
     ~~~~~~~~~~~~~~~
txtimestamp.c: In function '__print_ts_delta_formatted':
txtimestamp.c:173:22: warning: format '%lu' expects argument of type
'long unsigned int', but argument 3 has type 'int64_t'
{aka 'long long int'} [-Wformat=]
   fprintf(stderr, "%lu ns", ts_delta);
                    ~~^      ~~~~~~~~
                    %llu
txtimestamp.c:175:22: warning: format '%lu' expects argument of type
'long unsigned int', but argument 3 has type 'int64_t'
{aka 'long long int'} [-Wformat=]
   fprintf(stderr, "%lu us", ts_delta / NSEC_PER_USEC);
                    ~~^
                    %llu

`int64_t` is the alias for `long long int`. '%lld' is more suitable.

Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
---
 tools/testing/selftests/net/txtimestamp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/txtimestamp.c b/tools/testing/selftests/net/txtimestamp.c
index fabb1d555ee5..ab8d0181218f 100644
--- a/tools/testing/selftests/net/txtimestamp.c
+++ b/tools/testing/selftests/net/txtimestamp.c
@@ -161,7 +161,7 @@ static void validate_timestamp(struct timespec *cur, int min_delay)
 	max_delay = min_delay + cfg_delay_tolerance_usec;
 
 	if (cur64 < start64 + min_delay || cur64 > start64 + max_delay) {
-		fprintf(stderr, "ERROR: %lu us expected between %d and %d\n",
+		fprintf(stderr, "ERROR: %lld us expected between %d and %d\n",
 				cur64 - start64, min_delay, max_delay);
 		test_failed = true;
 	}
@@ -170,9 +170,9 @@ static void validate_timestamp(struct timespec *cur, int min_delay)
 static void __print_ts_delta_formatted(int64_t ts_delta)
 {
 	if (cfg_print_nsec)
-		fprintf(stderr, "%lu ns", ts_delta);
+		fprintf(stderr, "%lld ns", ts_delta);
 	else
-		fprintf(stderr, "%lu us", ts_delta / NSEC_PER_USEC);
+		fprintf(stderr, "%lld us", ts_delta / NSEC_PER_USEC);
 }
 
 static void __print_timestamp(const char *name, struct timespec *cur,
-- 
2.20.1

