Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14742447AB3
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 08:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237738AbhKHHLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 02:11:25 -0500
Received: from mail-eopbgr1320123.outbound.protection.outlook.com ([40.107.132.123]:25568
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237311AbhKHHLV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 02:11:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mx67hJpE0fxsTPKSC8vn3cB0o+Ox9xQ/YhO/sQzoBOVFpSsmAGJKTK06X6qYda+2xcyhRX9ufGeLbIM/ZYICtE0EsSAqgjQxE7OLXVots5xmwYp7NVALMwiPwhYFMe0pJcO8zl5FjWMH6uM8N5q4R+NMqqMZ7ngQCVVVjB5inyBfWj80W8jEt4Q0FkiVN1mEOqa3JicN3/bBi1ZoFcEdMIZEWPL46+6J9pEOqO28FbZ5iuiIAm5DSXVogGyrs0mpVSNl1iJGKKQqYBgjmdQiGkgLSs6mjFxakYg6eKsPFS2JdSQtt7Ttuim3Ogj4Gqe10Bfcv9GR3Ig5PgQCAx8MNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZNo6Q874dE8hfBij1hGfPr6RNpozKtulCvOS9ly5C4E=;
 b=kqnHEtjm78aW6yul9xEsEMnTYrEhs4DMTnTRHMgvJOCOYFlfPf9K8VIvpUV32sdF9oWagOrQIuW3+PnZ530SqEt+4YZPWVjxTG1tECG1fOV0eyoiqi6NzqayWadM41O9Yg1D38LahXq9a0vQdL/5CK4qBvG/Hytc7jrEIScUcBWagEWITKTiH3Jkth9Ra+2Kjfg9E3uIlS62oMNqhqMqe5ipLAXA9CZnS/2qIiANNwt55CbAJZ+vzerMyEwJB8kETf4j4Dcfxp1T7Oz/KmQ6OFnBb4mz652MBusjlJaBRNvMwq8bRipyACzSXvFSx0JhRXOGOhwn4SLLDZiRrKAiew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZNo6Q874dE8hfBij1hGfPr6RNpozKtulCvOS9ly5C4E=;
 b=nTPJ3yZuUV4nDACU7jYj4o3u7pbnHguhZao2NN85j2fivGp8BHvgb6f8AI5EE/BBI2iF4Oye4L8S7hiHlPdCR0fw9VH+0GzpUQTf+NTgykEOGD9rXUvtJsW5Q3ujKK/Kid+WePZCx0pdH+KwQ8HEjuWLQl7NdtQcwPwy7laScJA=
Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=vivo.com;
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com (2603:1096:202:2f::10)
 by HK0PR06MB2259.apcprd06.prod.outlook.com (2603:1096:203:48::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Mon, 8 Nov
 2021 07:08:31 +0000
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::814a:4668:a3bd:768]) by HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::814a:4668:a3bd:768%7]) with mapi id 15.20.4669.016; Mon, 8 Nov 2021
 07:08:31 +0000
From:   Guo Zhengkui <guozhengkui@vivo.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Ian Rogers <irogers@google.com>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Riccardo Mancini <rickyman7@gmail.com>,
        Michael Petlan <mpetlan@redhat.com>,
        Guo Zhengkui <guozhengkui@vivo.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     kernel@vivo.com
Subject: [PATCH] perf tests: fix array_size.cocci warning
Date:   Mon,  8 Nov 2021 15:07:52 +0800
Message-Id: <20211108070801.5540-1-guozhengkui@vivo.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK0PR03CA0099.apcprd03.prod.outlook.com
 (2603:1096:203:b0::15) To HK2PR06MB3492.apcprd06.prod.outlook.com
 (2603:1096:202:2f::10)
MIME-Version: 1.0
Received: from localhost.localdomain (203.90.234.87) by HK0PR03CA0099.apcprd03.prod.outlook.com (2603:1096:203:b0::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13 via Frontend Transport; Mon, 8 Nov 2021 07:08:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cbd00d87-6e7a-45c0-f975-08d9a2869204
X-MS-TrafficTypeDiagnostic: HK0PR06MB2259:
X-Microsoft-Antispam-PRVS: <HK0PR06MB2259FE3B5DF89D688B0DA597C7919@HK0PR06MB2259.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:390;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9brBcNErFhZ0RWFhnFNilz9Gn3yYPF05XXNfzYpwIPkB/Kz3PGJ9hdw2KazGknq7n0Ka1hYlpKN0QXo5s1wn8mNw8eb662irA5tjPHL1OxSXncjvwphfCFDaCqgJ51e7SXhWao2WaSgWckSA2U7mUv8jPR0+q+2zwwqhFIZCROGgTso3FGlGB4ghqPUtfNNPR6CaEtZON4t4mVsrkwdSOqwF9Q/OK3YJqS35KncWh0OmZJhV/YA6DLsVlpJR1N4qCTDqez9jURoFyzQFsjjjIJiQlN5LEb/TvUZXisnNXNEvVIBJsWS2LZkA18lx4vdu6WX5D4glWH5wZY2PDSYgbfMl2JbcaIrzxvhJJR4UvMBQYKXtBjKmxK3nuWfDkz9YJdyAK7lCZDD7xK/CWMEaRDhcOzHY0a0eL6E5guCccMxeKf/TembF1xacG2/13C3B8DHtMtrU9jafOEDXblolmZ1UNZCnLEsctGoL7tOsRUzeuo/wnYxOxJETl69giVuSf7PU2nyFiZ9E3N7n/WRPWQWjFgJIcW4qE91RZ6p833anBlzavau6LE8Bbv0t4APB0mXTf49M9yNZdJihfVxQmi0viSMh0RtqfzPw7ON6OJCtyN/OfsUZFZ+lTmqQbRPKujuy5ukzW+3aGCAzII/udWW1Mo0YgvtSKJkWP4z2uRKjZbyrdqaXmgYNrhQAe60NiLDn+9YXWEjGg2/dJANlR36HiFAxlmQYNgiIuR/Z8Mg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR06MB3492.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(66946007)(66556008)(66476007)(6486002)(26005)(1076003)(4744005)(6666004)(921005)(38100700002)(36756003)(52116002)(83380400001)(508600001)(7416002)(2906002)(5660300002)(38350700002)(186003)(107886003)(6506007)(956004)(4326008)(8936002)(8676002)(110136005)(316002)(6512007)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mGjyN9nCbxQRQlomKh0SF+y37Kwm/3Sb7j7BoYX7s+bbpZH0NEJu/No1+kfV?=
 =?us-ascii?Q?jQMS94dxkqw35jp9sO1G5ah+N+OiT6pbyRlNcuuNcHz/+wZcCdeDzOUfRoDP?=
 =?us-ascii?Q?raT5T/EYLE0I08LkZNfVRUBvb/5RmattLP15T0fcoz9l8f4K71E114yUE6ZM?=
 =?us-ascii?Q?kcktwrZHdI0L+E19MPZY6GzZROwSyop8aYUTmUXRIobDP5eWW13ygPa3ICC5?=
 =?us-ascii?Q?NM9/vbFWFi0SIb5eQlRPPUBbUaiKYHBblUbwBVdJLrxveX7x/gD1hijpyJk0?=
 =?us-ascii?Q?ppckTtOGQoVe0fcW4b+wN4cjKqEkEf44GQp/ZJBAM1RQL7laGjUlT8zYEcIZ?=
 =?us-ascii?Q?6aahms9THdFlsXt7ouXMLdbdmA48s5CArQ3GAMuaTDRVn1jCC+r6oMPRRt7d?=
 =?us-ascii?Q?yLOc3VcSdg93j7d/y/9mwDv1BKpvv9mzVkbam81Vtvrw+GgxL9PlW3Vz7y93?=
 =?us-ascii?Q?+Z7XcTyKPlfK63vYrmMzlYgisJC/XPqH5nRGa8riVyZX6amGFStCDrW7FlDJ?=
 =?us-ascii?Q?Q2xRV1h58uzo3hipYEnm5/H+2GeIWWMQak7MWZ78n6eNaxdFISQNlDzhl2bQ?=
 =?us-ascii?Q?7THJzabAC/wuw6jW7cdDO+Tl4lMkgIDhjUNoKrk/PA6+/Kqgx16qRTEMW3oF?=
 =?us-ascii?Q?dWouj0pRl4rlrBXvxvEjN1o7fN90IrxWOBQrMCCnABY9qEbCFfpF/HUY5MBv?=
 =?us-ascii?Q?cUXXG6YrGwEWG+8RuFG3hUjbJhEuLfzrvpLHRLz736XzBxGgpKHkZLxJJ1IR?=
 =?us-ascii?Q?9MmCIUo6scsPMMiL9WO/PEe8f8gVM3uV71v0JwXlBg/IZ+U3RyYJXjUsbgKJ?=
 =?us-ascii?Q?ngxwfJVrrge4uLvFWlucQ1cihuLiQFw9bpKIG7LhtbGRwU5mN01I0oVMA7Oc?=
 =?us-ascii?Q?YnO7JiqTqqEDJ1xdKinJ4eP1Zq6ZU6ADUeqUZY4Lse10q6g31Uv3knqr09dL?=
 =?us-ascii?Q?XCC1gwFjX6r06JV49DZU07wQ3sBjB8Ze2oK5wef0rnLHSQJ/MXQ2bYrPifIW?=
 =?us-ascii?Q?AiGYRpLyOZtK11vfnkgnpaqYsoi3vbOFWncN2/ziJ6vbV2BY5e5b8a0gfFxf?=
 =?us-ascii?Q?Krz4paAOTbO8L8T/fN3iLrUbJyyE/ZLp7gJoIoruYFhf86xsetfPkXZAIo4k?=
 =?us-ascii?Q?4Tyt5IOLWZ7wib3sUJ2ZqGwfkEfBWfXPzrGeq/3Dt01lCf4jc7qD31cpzI9M?=
 =?us-ascii?Q?V/dWNDPyBKhl8PJ6lgR78mgTFb2rjOJBlfomHRrN7iiEfIYO530waYsE8Ash?=
 =?us-ascii?Q?TUW6W2GZfxVrKYKjNVGUgd18BKvqZWvixoZ41npj+SNQsu0/NgLetm+9kmNz?=
 =?us-ascii?Q?OaMdFlTyCUltb6kr3/+Onfqga8D68+y2b6+cLxwCL009Iql1ne6UhCwqxbF1?=
 =?us-ascii?Q?4v8YcOg6NqcU2Xv98NgvrIH7y5nGKEqfnndXYo544Do5PkBZSUBWYF+UnWLd?=
 =?us-ascii?Q?ujYRszr3xjv7uv/B4OwfHQH2hG707Yqq2+yZwDWAolk5F2cOSGvQigYkGCSV?=
 =?us-ascii?Q?myoIlAp64Ln56jW7cW+hQFWLAQxHqd03QsiyTeVFzffRiNxN2wXZlxwX6NpA?=
 =?us-ascii?Q?/t7RM1QTDSsefEOIoPNUVnT3CynwN3zA7Pc1JVIjXpYN+NIcxTd6klBokprl?=
 =?us-ascii?Q?MZHvfuNQRzGLQqaljkNFbJY=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbd00d87-6e7a-45c0-f975-08d9a2869204
X-MS-Exchange-CrossTenant-AuthSource: HK2PR06MB3492.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2021 07:08:31.1281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DE/JUhLFVqAP0w5NoI9NvRy5r5L16a3oaLKgbRa3X1ycLwF8Jmd4I6/SUTqBAeFdRVKh1raewe9eWZMLXWfAdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR06MB2259
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix following coccicheck warnings:
./tools/perf/tests/bpf.c:316:22-23: WARNING: Use ARRAY_SIZE.

Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
---
 tools/perf/tests/bpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/tests/bpf.c b/tools/perf/tests/bpf.c
index 2bf146e49ce8..369e963eeec1 100644
--- a/tools/perf/tests/bpf.c
+++ b/tools/perf/tests/bpf.c
@@ -313,7 +313,7 @@ static int check_env(void)
 	}
 
 	err = bpf_load_program(BPF_PROG_TYPE_KPROBE, insns,
-			       sizeof(insns) / sizeof(insns[0]),
+			       ARRAY_SIZE(insns),
 			       license, kver_int, NULL, 0);
 	if (err < 0) {
 		pr_err("Missing basic BPF support, skip this test: %s\n",
-- 
2.20.1

