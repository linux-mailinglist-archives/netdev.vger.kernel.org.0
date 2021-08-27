Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9233F9546
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 09:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244460AbhH0HnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 03:43:18 -0400
Received: from mail-eopbgr1410100.outbound.protection.outlook.com ([40.107.141.100]:7545
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244395AbhH0HnQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 03:43:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mm0EeVS4zWyWd5EyC8X6/ln4i+8+H1u8TpzqcamcNgAR2XjghzxaBsbCaYAWlMcePFco3xq+iuki7hO5KbZALX973y5ZstK6khrHSNiOorCOSUmGKj7q8NUVe5gtN+jSjYSI1qZnSNsCEqKSbeH8iauQMG9PIByfAtP+4GjZ+4K9XZT3+6J7lrA2NH/xGNwOr2HXjgNAPblcsU8i/ckgZTnwFkCAgrnPqnp9NRIQwvcV6daWt2BAQiclieGYOct9iFtMKJ+MORBk5JonCzwG1NC3XJuYlKD2O61Z4IunJxlnZegIRoG0rr4Oi9mhYxiLR3POYnv9ZKYndk7+FAVdmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1XVaq4ETFPKEB0ksXZO3q8AQY7NFelcHJGgkTwnxylE=;
 b=acobFcTgerZ3M3B17NR5jQPXpBWNz7C52aobIC9Gfj9H5x5wi4AFAeBVczX4ZpsO1j/Ee47TzLlC5gd09p9kfsbhtK5A7xV7hwr0D0kyGt/6F0hE5jtagSTwcTG+ial0VPUUcrEjgcS1wluzONz1grrayKSWsKlnZe8bqIQIkSBYioeah+X5rTmqX44MXwk3W01wDGqTeEH7+PHXLaqPoFFecfbTU1iXYyeXkjEctX6DV/Whr/lvpIl1tLY2mMBBZD/F7aKIcSOm2drkk0KaJS8m4w/uSHGPU1aUJ6XtYuuXOg71SRWP9XCdftcS/55TuuXNl5GIwt4v/2a/dOLltw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=connect.ust.hk; dmarc=pass action=none
 header.from=connect.ust.hk; dkim=pass header.d=connect.ust.hk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=connect.ust.hk;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1XVaq4ETFPKEB0ksXZO3q8AQY7NFelcHJGgkTwnxylE=;
 b=JsfS8A6mcG4kLl+QRnsjllWbHiMeWdpkOCe6QQoTd1yO/MisTeKF4VTYdNGeq3vQVkB0eawY5FXA4cs6bpAqEGcWsc/VktagZjE/gsZekxrSIj6xNdRNBHF+Dfz6DeadbNyMTUbjqzgQOSsbEcx3dEQm3afajUvj8c0JNBQKfgA=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=connect.ust.hk;
Received: from TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:b7::8) by
 TYYP286MB1193.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:d0::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4436.22; Fri, 27 Aug 2021 07:42:25 +0000
Received: from TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM
 ([fe80::b9cf:11ff:5f5a:32c1]) by TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM
 ([fe80::b9cf:11ff:5f5a:32c1%6]) with mapi id 15.20.4436.027; Fri, 27 Aug 2021
 07:42:25 +0000
From:   Chengfeng Ye <cyeaa@connect.ust.hk>
To:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com
Cc:     andrii@kernel.org, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Chengfeng Ye <cyeaa@connect.ust.hk>
Subject: [PATCH] selftests/bpf: fix potential unreleased lock
Date:   Fri, 27 Aug 2021 00:41:40 -0700
Message-Id: <20210827074140.118671-1-cyeaa@connect.ust.hk>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: HK2PR06CA0004.apcprd06.prod.outlook.com
 (2603:1096:202:2e::16) To TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:b7::8)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ubuntu.localdomain (218.253.253.162) by HK2PR06CA0004.apcprd06.prod.outlook.com (2603:1096:202:2e::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.20 via Frontend Transport; Fri, 27 Aug 2021 07:42:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82048114-960b-4926-3259-08d9692e3698
X-MS-TrafficTypeDiagnostic: TYYP286MB1193:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <TYYP286MB119377863C1637AF044B1D2A8AC89@TYYP286MB1193.JPNP286.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: inyqNxCskgn4ZqBYT7bw2fyikG6VY3ucy6EHAsw3fn8pQ+uaRxyLA/A+4W7s6oNJpZHF3a/Uz11sd4RqHr4YqwuG5Yt3UjbczkWoXkA8P/b6XsyvZvi1iUIpDFm2sJlLWjX4Q1C1NPEi0fIxZwJ0nfDfX/JsXxL//EIap1QOOT6B9THkeY5c1h6ECc7wv/qbAcI62u8Z57x/ZvT44lfVwuoVSV4ZBY0Zk/pfg4As0546LndmnF+mrX6dj39kPTmBkPzv86QVin+gyggHUWa63JJYgl5uyv5h5lsQ0Gj9rS21sLYthT8rvpcihN/+DUoBUCNF/n4xwcj8yqFUASfHY3h2r5zg7pkQiJRmHujvEsiL17SJwymFEWSacFi3kH053ddJnkOdH0KFik/bvG9BEqa0lCCRkA8WbFeVBbxAzDSRrYhpWF87secCGowGoQM2HkIrjV9ugwZP0h3ygVSTXnI0X//AmNPi9+ESF/3I4JdaI+fJCR8maBQhU34IcBDZsctiu96Rje7ViZ+ndqChjuHcVBeJScqrjVcpvfmHwTtvYtnpe9pnBtZABZQwu7PJhu+T+F7UUrF4ZrF8gMex8cOivmpw0sbsFT37brjdJ4FMZTotSFGU7Um06+Sw+fdkEgns4zluIhfLt+reFWQFvx1vnA66QF1bccLViwllYV4DmbOD9/WPvhl3LGgEQim7Mvs5VLS3Ce6yDtYCooSkdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(39860400002)(366004)(136003)(66946007)(2906002)(1076003)(26005)(478600001)(66476007)(316002)(186003)(6486002)(36756003)(786003)(38350700002)(66556008)(83380400001)(107886003)(5660300002)(6666004)(52116002)(2616005)(8936002)(4326008)(6512007)(86362001)(4744005)(38100700002)(6506007)(956004)(7416002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IbaVlYcFYKoZZ+C8O2+IzXuGi9eiVuuJulbZ7MVzX2x57AEkYo3sujxDqnPd?=
 =?us-ascii?Q?AyhN44Qym99GcMy2mQB0Ra27UQ4cO31224s1uA5Jpq8RqidEI/Fa36/uLFJ9?=
 =?us-ascii?Q?/kSSz8mZjN8qAEZnmmToWgXNejli+//l6Sy3wF/XPvsA23N+Sy3ZTj/bRX7L?=
 =?us-ascii?Q?+n9qMiIwXr6CZa/1swdwrAgj2Tq3qKL/XTsztZ1J6i1gz1fTIw9D+PCUhrHE?=
 =?us-ascii?Q?YQLjs0GP6wTJyQSWwcFB9atszfLLwAfE9twFvmYgAIS1xTZV1KUYcG5XTxyA?=
 =?us-ascii?Q?pUxGtOxr607f5eUFYcQt5XPu+Ys2GKN9CLp57Xley9LIy9zgnruF3emWGy2m?=
 =?us-ascii?Q?BNxpFW8dfAz+l0p2n+RfWXWWTxCSn3frJxArr8vbJp03BBV4aUEyPrfbuaOI?=
 =?us-ascii?Q?RCJQrCnp8UhQUYOGelQ+bJVBs1xo7jWDpmORLk77xvot8zkQXHIe62xLKlLZ?=
 =?us-ascii?Q?LTVmmuQCNYjoSYul4QqWEu3umcrmdtvm1j2VV/3KrJbDpa096ovgK65A/juo?=
 =?us-ascii?Q?92FH10tKK60a1XVe7BDHcafLO5IvKbm+AKnxTH90v5V+Ih/GfKa46f4sV0bW?=
 =?us-ascii?Q?MqqY+SAWuD3FsGdRe62XCgVKksYp8SK6wQrZrSxnVRoImJxUnss1sx8TNiRQ?=
 =?us-ascii?Q?dFPmG/wl7BXyclw8J6jW02syLfEvzoVMRuYTwndIolsIHWnTitCCXUpY+W8Y?=
 =?us-ascii?Q?P6tkYAlKesM66DfY7tZIFVB1Q6ofCCboPyoIcdVVHjDyOGZd7VLRAcrL2Xyl?=
 =?us-ascii?Q?gBUoZFvs+HDMuGvfWoB4Zj51QsFaDAGoTAyegoePel11ZDu6AbQYaHGivuU2?=
 =?us-ascii?Q?diny5HnjEAzyO26dMcY3f1xcd2iuQO8Gta/AryYOGjdR6nNetN1XCB5DRz8Z?=
 =?us-ascii?Q?qKbv2FTei4KN8EzRlBd4i7yAGclgTL7ElB7vze4ooi6/vkP2ZAzuK4EecevC?=
 =?us-ascii?Q?1X7+s7wxCJ0lE2GtJYKbF4A6H+I+a9wppRZx30b+zCNzMlKhjiO1a/S2Z4bb?=
 =?us-ascii?Q?yuAy8msg5lva+0XPat+MUsxpk+YZqxUSH+JQtiMD8+27ZtSKiFvA7fxHeiCv?=
 =?us-ascii?Q?+D3b/QsQr2SJnaMOwuPV4ftFNVIsCeAeouwNfqsvxb1osexxXxmhhsCNOgEv?=
 =?us-ascii?Q?LWPsWtNcF11lfpUKDuvamXRIhC9JrtLjldkiwyFQ3DM2DmBL1XzB9KpWa3YK?=
 =?us-ascii?Q?eiHYU0rLwAagU0Ege7ufiZFhwran4bgaCTSFHrGQnhXFwfohkQy+Fxn7CgWB?=
 =?us-ascii?Q?KNnVzf91zlDy0uos/U7CrIjj109yuNr4yujX1SGmhqFbgr1p4LVOcn4L7LWs?=
 =?us-ascii?Q?pL1YdLP+/K1NDbkRDztMoock?=
X-OriginatorOrg: connect.ust.hk
X-MS-Exchange-CrossTenant-Network-Message-Id: 82048114-960b-4926-3259-08d9692e3698
X-MS-Exchange-CrossTenant-AuthSource: TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2021 07:42:25.6664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 6c1d4152-39d0-44ca-88d9-b8d6ddca0708
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4sKvt/i9PzLMbECNLsw7IGZcRcEnobnkeCzqbdfffIZY6O4a5mfvEoy0B0ZjJOfOh20vIQ37zqrOataGXky4OQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYYP286MB1193
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This lock is not released if the program
return at the patched branch.

Cc: cyeaa@connect.ust.hk
Signed-off-by: Chengfeng Ye <cyeaa@connect.ust.hk>
---
 tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c b/tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c
index ec281b0363b8..86f97681ad89 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c
@@ -195,8 +195,10 @@ static void run_test(int cgroup_fd)
 
 	pthread_mutex_lock(&server_started_mtx);
 	if (CHECK_FAIL(pthread_create(&tid, NULL, server_thread,
-				      (void *)&server_fd)))
+				      (void *)&server_fd))) {
+		pthread_mutex_unlock(&server_started_mtx);
 		goto close_server_fd;
+	}
 	pthread_cond_wait(&server_started, &server_started_mtx);
 	pthread_mutex_unlock(&server_started_mtx);
 
-- 
2.17.1

