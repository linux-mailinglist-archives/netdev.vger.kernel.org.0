Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C32D524FC1
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 16:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355176AbiELORr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 10:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355162AbiELORn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 10:17:43 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2132.outbound.protection.outlook.com [40.107.117.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE176EB32;
        Thu, 12 May 2022 07:17:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fQVzCPYIRWQNsjipQsCiGc80u7I9erP/D8Tjt+HwM10jyortP+Y9ODiS2V6rmysfMbIi2muHu15yW+5xENPUq11TLfZr+uWCXVBSayo+VeZlgXsgMcd09Nkx0I4HPyonrlIThglwP9etXHJpluJaJvmuTbCeWhMTSVlkDVUCBNnrNzK883f/Cw2zpymWrYkFKURm6i6VE1/cnDrRncynWRmeuk8xn6eMey5/xVUhpMOFkujfD6NnrXN5saFE0x/bZY7c20SJk39kKp5Yan+2an9lBNeNquuDYGvqcuueYONpHhZ80AgS1x0zCZBXTcRIe5Cht1TPGrHKYPMVQA6UEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NuBxTX+btyBuKgDD17JBm6YZ6h+fq6v63KPqrl+KnUo=;
 b=R3fX98xuWN0/Gj2KiEbv9VzNAEiq/xeqqaP2UhPUg1GzBm5t/y2KLDZC6AekN68XvnalON/DEgM0PS5YIej5g8/ZjZmka8FPv3DdGHuVo06AuNm4OEtEYmMKjM3KjXfUF/kLE+y5OG7k6//le6J6jgacTjIxHlXDOoRLUv9O7t3FLzoZ6bcX/THxrihyPeRPd6x8TVMlw1r8Cc3qc6eqlFruj19QJUtB6An+A/biy5k59aEVq29LlmskMzIn69QcrAo/OjUjZhRmN/wCuEmzpROwy+n+fpUFw5eEoEWDNtOdVn9+gWBg1Li/ROdR16rZYxuvqVCAAedMKAa/QUvO5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NuBxTX+btyBuKgDD17JBm6YZ6h+fq6v63KPqrl+KnUo=;
 b=dbcXmHqAnjEe185uhEx//ZkVm2TTZ1Oth44D+zsCoXsL9Hab5rf8vrQqq4WnDOeLg1amdVPCYb7jXKe1+gQnI5LZJvtiRfTn2kCOJHhA/k5+FBgmex5kiy78gGUV+xvvSI+HEEa/xFYr1+JcVjKRb/PzXI9+8sMK2U/s8NyyhtM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com (2603:1096:4:78::19) by
 HK0PR06MB2819.apcprd06.prod.outlook.com (2603:1096:203:30::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5227.21; Thu, 12 May 2022 14:17:38 +0000
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::4591:4f3e:f951:6c8c]) by SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::4591:4f3e:f951:6c8c%7]) with mapi id 15.20.5227.022; Thu, 12 May 2022
 14:17:38 +0000
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
Subject: [PATCH 3/3] bpf: use vmemdup_user instead of kvmalloc and copy_from_user
Date:   Thu, 12 May 2022 22:17:10 +0800
Message-Id: <20220512141710.116135-4-wanjiabing@vivo.com>
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
X-MS-Office365-Filtering-Correlation-Id: 2d5689af-9fb6-4678-a71a-08da34222ac6
X-MS-TrafficTypeDiagnostic: HK0PR06MB2819:EE_
X-Microsoft-Antispam-PRVS: <HK0PR06MB2819811F1EABEC6C2AF331CFABCB9@HK0PR06MB2819.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l9z2mGNknD/ulheEmDer58qOPqkKe7GS2uHcZaWeYXD7QmCjZFSL59wiLPaDX/4xNhfLzRzf9aU0ix8u/GavUkJqo2BpOwxVkQEze1lQV+Fos3NFJJMAZrFayBSjqHOFFTjjuYP+rh7gD0nHcrcVsMsDJm1vsFB7KwM4Dv13MxdeZdM/kgbWIVjQYLPKD8I9PqsqZXQkdCJBujMc8Nl0AcJWIit7Z+RD4k1zuTBz4vVW19LXuaENvri+AHUMIb6EWkZfcvlgywYxB8K7EY5fUtwnW4q8UTKY2ayak/IVVBUJu2Qz/DFSDjJbYFGepYIAGWpxz94qVZgglClt8xenDe6OGEbYOzcvGjmYQb1maMu0rczWgaLshTMekr8504wXjRZ7Tq0whbRJcdnBTz41iuEfG9cN8LjK0jZsYKEhQVDgQHAQmZB45ap+cvKioZmJapc5FBI27YvO7hdN/HW1Tuzbx+27nF4OXuGS1ikMHxYoaCAPSGjPJqxC4YkPEQqq3LPXvMkQxiQY4jyFnczg2SJvEtkMOQutcUuPoFSW87Bh1NVyqlCC0RmUtLqdE76sXltOm2QrmGrBXirwXv4S58v4k52PaMsaH1U3GWVjtuErIr3EzDGTDVD/7j2IxVjqpK1HfE+bUhBQGQkP7fflsJejSrjH7WVVd0cD79y6UicK59dL/3gpebFslUCnpveYtFcoQT4tkH2PyrZ4IO+F/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3367.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(921005)(36756003)(6512007)(38100700002)(38350700002)(2906002)(6486002)(26005)(6666004)(508600001)(7416002)(4744005)(52116002)(5660300002)(6506007)(110136005)(86362001)(83380400001)(316002)(66946007)(66556008)(66476007)(8676002)(4326008)(2616005)(107886003)(1076003)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?laURUt3C5jaDqjV7egzj+8RKnd2xc6P4oXcuoohCxg10PmvLFb+nbf/LzyZr?=
 =?us-ascii?Q?umD+vbn13QJjJKvm+EyjCb0BZxO+3g7YdVRJHl3LBjIRjt47hqHPSP5iPx7P?=
 =?us-ascii?Q?/3Noy5/E+WyyVywQqxobO/nWgetI+1TCB/M1d82DPX3fo8WVL97yKDziNeSp?=
 =?us-ascii?Q?13rjoWKkYcWpjdJUYpGWa08wmRN+kvaE4yrA+7wimV8gHR2UCPHNr1joc/CY?=
 =?us-ascii?Q?+6kDkKVN0tIxFutontscuv4gKKEI9OmA3nVdoK1WsPpuubU+aAzWZx+sfwWl?=
 =?us-ascii?Q?P48MczMBQHcJb/HSMIzM3h/S37mOSG1CQ0NvUe1ZZ1/VzeoDfA3vSXKK6eFW?=
 =?us-ascii?Q?sNf87h02VkoNvbv3RTdw7/pDLzUQ6f1JQBiU/vr04QT6NWRdVEohMWooaHQb?=
 =?us-ascii?Q?7Wr6UIpOXC7w2bbbNsN4WER9HgpdSxp2gFSEgNsJGrEwno3iBKyDuHp7DYK4?=
 =?us-ascii?Q?5ljJyhLCs+qEtsC8toJvQcd0t3RDPNKAKN/CVRGPMbmvPvyslRu4cuS8CYhL?=
 =?us-ascii?Q?ECpsjcDX4EoihRIQkq2+3ixggDJw2PcfIZIVy8fEp6LdxEvFhLIPuI7zgKIb?=
 =?us-ascii?Q?GET7KgxHtTy7/LX4S7PO6Q9tJrSmtNkxsifHC9mVO51wmyXVnYxIB7YbihqK?=
 =?us-ascii?Q?27p5fhFLVzZlWLIFA1HsSF7mbH9FFgK3joteg6MA6KIj/CQikTzRkuv6WgY0?=
 =?us-ascii?Q?CwNAMQxyB2m+dlMGSWw1QYDsQmLZ3kDWNWFogpdSqzEsYsB5YWgl/OhQn3pG?=
 =?us-ascii?Q?5e2kkd67Vk82cacpKAKkDLQL/iU7wrhWkGP23jFEVbY9F2AmTmcHnZW2ntOl?=
 =?us-ascii?Q?ROY/PXV+glZz5wdkKevkphSPFQ7Sp6h9DZaDnBvMRxXBDhU+COzC8GJBh1+f?=
 =?us-ascii?Q?LxK/ob1+lr7ytFK5agxzubyK9L2LnwPJJPF1iC0r1IeY0xhUt6jLTPfouIl+?=
 =?us-ascii?Q?138sd2qboaLMsAOF27sJd3Jtx4gjq+xJoGAj22QRjXqOT7dQGDw227izJg/G?=
 =?us-ascii?Q?HsTLM5K9lhe1qH3RmU8rokybwpoMtBSeEIcWvTQJRYUC5/aGPO+C+AAlw45S?=
 =?us-ascii?Q?WI36DrjM/OHAaZ9jhH8ltU9qktQzw3Tf71eNQRBoBD9JTjttgvtjkJjGTcBy?=
 =?us-ascii?Q?Vi0OnANPL/8jkjSrg75rZcQLDPsfU31QEI+cWr4aUvIdq831t9UAn2i0Q+r5?=
 =?us-ascii?Q?RgZwJRbSGtoWSJxH1ebgmAK/+NCJccHzJjrcttRrp+1PzAR8JpNUfsmW9d2M?=
 =?us-ascii?Q?p90jpEIwsR+5aQ2jW3yulDPj8COV5jbS5CenI0Ap1RUR8fn1pg9FLMF9L8Mv?=
 =?us-ascii?Q?avXvk60Tu7HtaNNWnnzSW0Bj8iHzG1sqAhlV+v0WThiwGBEdPgBJJAkWaj7v?=
 =?us-ascii?Q?W+T4l5HsOWE9eoLRK8e7VfOH/uDaf0tupC+Xz6cGwzLHEqbnlY6W4enezJ/7?=
 =?us-ascii?Q?y4cb12n0JxVK3s2xgnZCuAI6BaxW8skGzgnEhbrBSD8gNv4Zs7CR8OAAa3uY?=
 =?us-ascii?Q?5mN8dszKzNFw2/OjzpniOXN0bRkrixeGjaPX8PwSB7kKzlI8Z/zW8rmxQ3Nt?=
 =?us-ascii?Q?9AHSQ3yl2vdxnkx+z6ycU6BBlEQm/mYzG0C3UaaMg7I3yNjM+Wl/bwCPEypQ?=
 =?us-ascii?Q?7fo45uH64yp5ynTAhflFJFhKAn5SAoO4UX2KLjTLCicytzpKYH3oLZp69Lva?=
 =?us-ascii?Q?2ufKtmSJSBiOCIkLnx3klcx7yS60bj29CH5qevqbKNxqItOyavkVe54KPxrL?=
 =?us-ascii?Q?7CLM9fMuag=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d5689af-9fb6-4678-a71a-08da34222ac6
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3367.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2022 14:17:38.0509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oKYp8sPUlrPOkjUjPTFjmpDaJOtxwljiX9zpzC8vJh6Ahqb8v4m52S7UnPvGbywIycSnDOyAN/1ukTduZ72aqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR06MB2819
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix following coccicheck warning:
./kernel/trace/bpf_trace.c:2488:12-20: WARNING opportunity for vmemdup_user

Use vmemdup_user instead of kvmalloc and copy_from_user.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 kernel/trace/bpf_trace.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 1b0db8f78dc8..48fc97a6db50 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2483,15 +2483,11 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 
 	ucookies = u64_to_user_ptr(attr->link_create.kprobe_multi.cookies);
 	if (ucookies) {
-		cookies = kvmalloc(size, GFP_KERNEL);
-		if (!cookies) {
-			err = -ENOMEM;
+		cookies = vmemdup_user(ucookies, size);
+		if (IS_ERR(cookies)) {
+			err = PTR_ERR(cookies);
 			goto error_addrs;
 		}
-		if (copy_from_user(cookies, ucookies, size)) {
-			err = -EFAULT;
-			goto error_cookies;
-		}
 	}
 
 	link = kzalloc(sizeof(*link), GFP_KERNEL);
-- 
2.35.1

