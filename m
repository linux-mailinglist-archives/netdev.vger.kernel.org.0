Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F360B524FBD
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 16:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355153AbiELORi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 10:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345728AbiELORc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 10:17:32 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2133.outbound.protection.outlook.com [40.107.117.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB10D6D3A0;
        Thu, 12 May 2022 07:17:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NugzCha+YNRm0AeYPv5YUJCKiqT2q6p+QMWGhIe04IcyQuj5mIzIl3JnX9A9T2Reuc1XAQhE/e2frRqt8NSdCseIC4Idmi1zEj0UKTnKiNMz2NGAjiJywDmHRr+Z7PPvDaHEEA49CYnWe03gFUSrp3a4tcuS5bV8ABGY0u9mP1ED/LIxO/K7DDqL/vFV9MRwKxyGMxHvH/6NoeEN6upj9RIl2hpg16//4Xd3sSZl0pa1WFKJrOjuPclpwx8LFwGDwuMXq9qkOwXM6/8fJiwqZr2lckcgafLNAOblCK8N/GLR0SdJgi6cndJrSUgaGNuoGltwPoU+AvWK71DmI6h8Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/8IS6FtOIXEJkMT1RStg3DCcQcP41eEVOrVpG2WUKJs=;
 b=I7lFuzX9TQWO5xWHZZcYQRGkdbiY8EfK1fibv7HI9S34y/w8zm5zXCk/hM0QvTnogqhYvFt82dTVbO3Z+Ml2Ow49juZEeqGtjiGMyuTfBu0t93l13QC0ahRFAxFJdIkD9UQ3sppLQBpKOr0aGlS5tksPVSldBP7RDZmuvbOdbA1jMyywMNf+xQyg75qcVsgNuWbY2w75l4nx8N2al6pSOfrWV8XL7jt0iBVlPRZ6zVLCMtSNwRlyYt2KLqpxZKspDx8ZaNc4G0h+EXTHOXMugwoaa3RvYwPq0Wx90yAxdc50lwqfQxQUbR/gwT1Wn3w18aPbQIDNQvTlCiYXM2KOPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/8IS6FtOIXEJkMT1RStg3DCcQcP41eEVOrVpG2WUKJs=;
 b=XPOvPpu6GIeMCIBOkWfB8UZxxcEl0MOivuBkibTL3Ock34xGPx2i2CXr54psBmwKOfaPN6lO4WmoJHh87sADuHMUU7j7Usu3e+fcF7ZjTyWZxuYomx5rQEFso8gnE6+TzUjBzKKye+YF/amS4dGBrfhzlKPsraUxwOnd7pwEV6s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com (2603:1096:4:78::19) by
 HK0PR06MB2819.apcprd06.prod.outlook.com (2603:1096:203:30::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5227.21; Thu, 12 May 2022 14:17:29 +0000
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::4591:4f3e:f951:6c8c]) by SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::4591:4f3e:f951:6c8c%7]) with mapi id 15.20.5227.022; Thu, 12 May 2022
 14:17:29 +0000
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH 1/3] bpf: use 'error_xxx' tags in bpf_kprobe_multi_link_attach
Date:   Thu, 12 May 2022 22:17:08 +0800
Message-Id: <20220512141710.116135-2-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220512141710.116135-1-wanjiabing@vivo.com>
References: <20220512141710.116135-1-wanjiabing@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0133.apcprd02.prod.outlook.com
 (2603:1096:202:16::17) To SG2PR06MB3367.apcprd06.prod.outlook.com
 (2603:1096:4:78::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf9f34b8-eca8-4f10-5b08-08da342225d2
X-MS-TrafficTypeDiagnostic: HK0PR06MB2819:EE_
X-Microsoft-Antispam-PRVS: <HK0PR06MB28194BA2B5263243C3560C4AABCB9@HK0PR06MB2819.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZvwXzbxNVGn4pfkaSOzeOgg5cs28T3007fbevJo1EgV0MTBETUz99JZ5c/wUdIGbBUc+JwgQtkDniYWYjvGBxk0WtYoadtzqa5wK5XslId2e+vyenVPVK4PZoJolkzlK6lwshziKix0e0gymYXI3dx2V0Kambm9Mn3xck6ViwS9cmAZxqHvQQLQWKtXN20kB3wxf/En3ac+637U768vsyFtfhq0X9I88ZWofDaid+sfdAfu7JGn5xTkPXpxEsZykV0WKUq28o9WMfW6pDMU0jIsZllIbL9c7BiugLFsVwG7l/KivitXrs4vmcAvehxkQ8/4wJChfiH97sJttnpwZefSHgzqUY/6sVsHyqBOO9t/rfJtoVftobDrxAmWh+nlf4yY6hIUyHAReZntf4CffeP7/zGOlzMJBc8TPvX4sYu+6Kj9+FPqDiVrZCueLL1CBcvdEOLTZVwU4DjHmqFC+k/MXGexsQiN743VaVkbEwU2ZVPyyr1I/59O7dRl2BfAWFS28BaLi7j2dVGCBD6Y0szb7rdKJFu8Bwpxl5yky2ZMyqf91cu7wN3pq/SoPVWcoeaYRhcoqfwOt8xtgc1tBAWi2sBwKFepsCYpM/QoqLhkVtQgqEpJNrEoSkSf+Z9EogUFreOdkuUjJ5ezsbeDyLyEa4Z6eFrs18jKUzgEYyT4jSHNZBszoGkqYVQVTW2geWEK5QRzmVZscq52nbIXyLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3367.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(921005)(36756003)(6512007)(38100700002)(38350700002)(2906002)(6486002)(26005)(6666004)(508600001)(7416002)(52116002)(5660300002)(6506007)(110136005)(86362001)(83380400001)(316002)(66946007)(66556008)(66476007)(8676002)(4326008)(2616005)(107886003)(1076003)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Hx5+i+pNA5VAqiA6INhAotZyTj/6roBPk5ohldhpwsuUyaXq5vli5M1whq/k?=
 =?us-ascii?Q?KcRzqK5h9IQ6x8Z25esfpkNa5QnHxxdewpDO5atm55o9Xm4bzTGOiseDi1pB?=
 =?us-ascii?Q?sdNe5QQ05lQ11i1j5An7z3fhMDiJ4GFj4ZgMDM8eBppAn5/j56Zmuw/swBVo?=
 =?us-ascii?Q?IFvlb1EWdhbiO+c7dPSS/ATfarld6TeSAevGtvbQyvBghZrsGjpvvQ7fG9oB?=
 =?us-ascii?Q?DmTFlKChnY24XrU5xTsrrIjjEX35TDPlxb4X2vugLtClOH7xVly6qUNzsBIA?=
 =?us-ascii?Q?WW7Jjj89thijikd/gX0tAhlp6wV5JwEiLmHtwLfWQhYIlVNDtFP95pOKwltJ?=
 =?us-ascii?Q?OCY129WiCNpL+K0bKN4wEUdl+3V8mM75vIFPDcP8iGZhpzFeAjJ1VRMd+oF/?=
 =?us-ascii?Q?xDjOZf72OoRIvwseuNpPTkUM3rOu9uHtjvJx+y6kzYRhgh22ajN0Xu5tQ/ia?=
 =?us-ascii?Q?Qx40TLtlpcLq7lHfZKO6phZrI9FRFrFvkRVYWl2uHhQg+21WxXcHNzXCuWg4?=
 =?us-ascii?Q?bvx28rq8QCb5tYgiYVL6qBpaAsIBi1gDGAOiY2tk6wN7pPeIv3gxDzk2PvPQ?=
 =?us-ascii?Q?SiSBhRMvrVcV0d6PlBh6Qb9wkrmNPcPzgMtP96yDJcj6xqLIcoYK0ICPB7oZ?=
 =?us-ascii?Q?3LfspzlekvdbNIjKQtvLknw21UMlSLty8bbAJubw0l9QtC12gq8lrUirzNsB?=
 =?us-ascii?Q?VvqcAuGnzRebBP+B2Ec6iFmcA2FPZgRuUJ3wQ+ZrTs/NskHYNJ1AYsyPWwr6?=
 =?us-ascii?Q?lNBXZbwV/WuDblyI00LhYgrfsFE1POZ4WPCoFlc6aPbatNuJHpcexntJBsPG?=
 =?us-ascii?Q?NJ9R5qWeaYXvtJoPskb5pjUj26M99aOWHdvuDXHsORxBBBSCXO5D4SIw6ZMw?=
 =?us-ascii?Q?wuSJjxM8ROoHEFjQZ10IZ6ey6dvqFpBsMCS4GsRxVos8oIemHnxrGj8s0Ek1?=
 =?us-ascii?Q?svtLAisGlRiVbIFE8Rpx7ZAib4aiUpSGyesCTMVibFi4ynxy+TsN9nGMmIcv?=
 =?us-ascii?Q?B9d410O0/rHfN/QM9mlVihbsHhNAv8EonuNyXj71Kymvqb3LmGE7uBjg4JiT?=
 =?us-ascii?Q?d8HcQTyyKxG/G0jhsfaZCMPiGS/lO4GTJBZzF/7e9KXp2RWsaQhgIMHLsYww?=
 =?us-ascii?Q?+dRiA9aRXEMNbWh3Ehj2SYpIiZJziL2/5/b1Et5ax8m4ovtSSBsd989wO6TS?=
 =?us-ascii?Q?QK3bfvOnPT7gx5PT8jvSZAtPUyjvyncSaxZztpkW6kLHH1rR0EJf+FcPQbJp?=
 =?us-ascii?Q?SKHbi2FDvYWRtMnIkCpdQsBIAVS/bg9k4QLnIi9CWdh0EKW4ej5Tw/0aqo5C?=
 =?us-ascii?Q?rKZ5lW54NJvO+YrrPXc3sLT3aVi16Nq8fWPjmueD5FJORFbhiAfiJLAalsvY?=
 =?us-ascii?Q?OT6XjTporPSEcG2ChgREkKdEqJtEUgM2KbaG7/4QNbQwEJpy+pBNPVPPPY0B?=
 =?us-ascii?Q?j8Tc26nmR7nkWZ4FuHNtzRnKB5ImmnZMQCC6y8aOJXd2kbzITszoKuyKfu6Q?=
 =?us-ascii?Q?P56BjZdWIRm3h35rrdGB7aMB0IZnE+WoGcKfQUAg6tu8ugqgjok+WC1Onl5q?=
 =?us-ascii?Q?9IEaB2C717SBKzImB+rRNiMQgobe27SXjtq9wjVgaSMcYFUfdYOdDDXV4vCF?=
 =?us-ascii?Q?WDRBvtc+SihpHH5zugrA0V+EMVdQ6y/ixXMHSzFaGIzdsLQbVrxrVxNorKQp?=
 =?us-ascii?Q?RmOztq4PUJRYOoTZtnhDa6u0Zjy6ktiG+++4inZSlE1TBn1gD01Ifsel0ybL?=
 =?us-ascii?Q?dv6EG/UDHQ=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf9f34b8-eca8-4f10-5b08-08da342225d2
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3367.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2022 14:17:29.5984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DP76C/1bx2FCxqOA7Ol47xYZnQyQtml+XvwAVJ1kupV46B1h7z7Kq9EO9ivn0AlXBqoXdqlD3zAyua3sUFpfjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR06MB2819
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use 'error_addrs', 'error_cookies' and 'error_link' tags to make error
handling more efficient.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 kernel/trace/bpf_trace.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 2eaac094caf8..3a8b69ef9a0d 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2467,20 +2467,20 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 	if (uaddrs) {
 		if (copy_from_user(addrs, uaddrs, size)) {
 			err = -EFAULT;
-			goto error;
+			goto error_addrs;
 		}
 	} else {
 		struct user_syms us;
 
 		err = copy_user_syms(&us, usyms, cnt);
 		if (err)
-			goto error;
+			goto error_addrs;
 
 		sort(us.syms, cnt, sizeof(*us.syms), symbols_cmp, NULL);
 		err = ftrace_lookup_symbols(us.syms, cnt, addrs);
 		free_user_syms(&us);
 		if (err)
-			goto error;
+			goto error_addrs;
 	}
 
 	ucookies = u64_to_user_ptr(attr->link_create.kprobe_multi.cookies);
@@ -2488,18 +2488,18 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 		cookies = kvmalloc(size, GFP_KERNEL);
 		if (!cookies) {
 			err = -ENOMEM;
-			goto error;
+			goto error_addrs;
 		}
 		if (copy_from_user(cookies, ucookies, size)) {
 			err = -EFAULT;
-			goto error;
+			goto error_cookies;
 		}
 	}
 
 	link = kzalloc(sizeof(*link), GFP_KERNEL);
 	if (!link) {
 		err = -ENOMEM;
-		goto error;
+		goto error_cookies;
 	}
 
 	bpf_link_init(&link->link, BPF_LINK_TYPE_KPROBE_MULTI,
@@ -2507,7 +2507,7 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 
 	err = bpf_link_prime(&link->link, &link_primer);
 	if (err)
-		goto error;
+		goto error_link;
 
 	if (flags & BPF_F_KPROBE_MULTI_RETURN)
 		link->fp.exit_handler = kprobe_multi_link_handler;
@@ -2539,10 +2539,12 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 
 	return bpf_link_settle(&link_primer);
 
-error:
+error_link:
 	kfree(link);
-	kvfree(addrs);
+error_cookies:
 	kvfree(cookies);
+error_addrs:
+	kvfree(addrs);
 	return err;
 }
 #else /* !CONFIG_FPROBE */
-- 
2.35.1

