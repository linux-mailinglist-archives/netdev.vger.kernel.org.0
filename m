Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B781524FBE
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 16:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355174AbiELORo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 10:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355152AbiELORh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 10:17:37 -0400
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2102.outbound.protection.outlook.com [40.107.255.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A8D6D962;
        Thu, 12 May 2022 07:17:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UUOw9eyKG6OxkxcVzzO8Vj1bK3Mvpq/5RXUEApWxOs6povefQ02mUvYgj520WLN9xEBHhZuJdM/NVUsLBPeGo7EyXEF4+ycny74d4srACQKqVSQ6LKLq99soY2nM5oWdpFqx3klWbl1ov15f11xzbyBX12QEmzwSB89D3ByQZqAN7bXvZbP4GQpeJ9tJ02CPbkg2qldTkkGE7hrquEDM8NLlbFkCJP6xr95M6qMllKCtBzE8AVVd8tdXXwQD1kleyZdIloQuDRKU8E04HonzwpJwMH7rrS7IbLZo6vfyCI9qV6aucWqTdBSwxsvPo9IOY1IKu8kCmGv2E3ulril4Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1brYZdW9vRKek9R7Lm2RCTYnER1gZyRWOb0URYrLWR0=;
 b=c7Rtr/fWV/KM9nJFfxo3WYPGRQuHA/NMkH6z01iv2XF8Ky2nnhzogoreGofOEZkwaMNUZFmqftByQT7e1CwItIa9/7wtsOEMf+IV8qtzMgm//K0gH101d9l5y1erri7YIcLv2g/Byqg+SUiHjZghVJbmlTIbqKefXn2qs3snWUwGBEH7/dizHxxwSZwvon6woLHdVVQA5+/WFubWV8LUSQ9TjUZVMwFPPECzFgO5fBdeIPaJsralYlTgCQgN/geZ1CAo4ZHf+NqJTwQ6SXBOLYGx6eAJOqElocqKdBJvBky0+BoRJcvrrL8PuzFMua398uhSqqS3TB8sQ0QR4NveKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1brYZdW9vRKek9R7Lm2RCTYnER1gZyRWOb0URYrLWR0=;
 b=Amg5xwfhhm98Z5Mv5WiaMIUOYqHHkHpT6MWPW7ymwmK9e8uNMf9raQDKypvURBoOwz/OTiGYjYFT8AJ2djgIL6SXEbSR2duB4MdeFx90wd7fEc5sOQjG/bWifyDT37nq2of/DMJo/YHWW/ZzyyKiJ2wwrmT8pp09boTsbdWGTeU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com (2603:1096:4:78::19) by
 HK0PR06MB2819.apcprd06.prod.outlook.com (2603:1096:203:30::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5227.21; Thu, 12 May 2022 14:17:34 +0000
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::4591:4f3e:f951:6c8c]) by SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::4591:4f3e:f951:6c8c%7]) with mapi id 15.20.5227.022; Thu, 12 May 2022
 14:17:33 +0000
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
Subject: [PATCH 2/3] bpf: simplify if-if to if in bpf_kprobe_multi_link_attach
Date:   Thu, 12 May 2022 22:17:09 +0800
Message-Id: <20220512141710.116135-3-wanjiabing@vivo.com>
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
X-MS-Office365-Filtering-Correlation-Id: 31679fe5-4473-4bef-8116-08da3422284c
X-MS-TrafficTypeDiagnostic: HK0PR06MB2819:EE_
X-Microsoft-Antispam-PRVS: <HK0PR06MB281924F3CD0E36FEAAA96E62ABCB9@HK0PR06MB2819.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NRJyFWTFb5IuS8343xkKZw0IaCZvGownE/uoHDwXoUixFTYW+kYR1i5y88R3M1sID/0uK5F2eVN0PzFbarQsUcWqY/buMFj1Nna59+/fgaJfzvRdkKpdd2FG/Kc+biqgQccQqxwJ+FyGk5WXbozOhyFZBbAU3OLdxVJ4K9gdrPkgvOyBUeTydL2te5s/Nzh7TjVQiiVi1RRK31jEoqRreyeHonxhxhIYn6n9niAtSdr0hxPxtdwIICUOltI5traWw8vRdghu//b1xnPDZsvgx98K1NLYM3bEDu17LfEA0fwNTXDlLhu5mbZ7WH0DRvHGImWaNV0WCBQ7Cy4GJ8IDexRUXtDqwZgLCuXNCullXFh8tT/+mqsRsoqOQlHqkL37wGchzSTZMqCbR6/SgjkpuOpZN+klO5bG9MtfzSqqKO9G7N8lBWy7ygvvnLGL1JvKvNXEL6SG0aasuow5rQRqNCJ0nzbive9qejTazv44nuZglI7fl9wikzupp8rri8eXzYfscTEG/36kJc4KkbjcdNd2ZeyzF8PdjMVp0gdiPuu/zI6yxxsa3M8rV0CFyua3Pm7lLfP9w1A2+OoGGnM/sUqYOQuL8OfbKuYuRWGcJZCcTKb3RvOVLhWXUoOFHUbF2pLLVQJmElMPw+8JjSVwt94VxxFjip6TiR/K323sABZbMpu27dMaqHyMZWVe1uRSISfkFh1Yxqwj15WDVTMg6d65T1FFq/OfmOnJsry3yCw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3367.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(921005)(36756003)(6512007)(38100700002)(38350700002)(2906002)(6486002)(26005)(6666004)(508600001)(7416002)(4744005)(52116002)(5660300002)(6506007)(110136005)(86362001)(83380400001)(316002)(66946007)(66556008)(66476007)(8676002)(4326008)(2616005)(107886003)(1076003)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XUt2FrTbyrRodKozN+0KhN5kcCddQQN0f2Q+75uSnKS1D3Y+uj7D7a8XLrni?=
 =?us-ascii?Q?UHhoyJwYGQQmML0wILQes/L+ZocBx15LX0xkcnFr/Twt+/bon5wneFq6ImnJ?=
 =?us-ascii?Q?KHowaB6Y3Yv541/2WDPcyT7KrjJsadtmIyUCHDf1eWQXvP54oOkL46WRzVII?=
 =?us-ascii?Q?OmD1FZj2l56GOnOBAyHJveBYIXK4T+LqrxpE5O3il2/DDk9HBrsPMK1YEuAo?=
 =?us-ascii?Q?53slqHJNhWSPgQ/loOrthMD/6xFyLXu6d2RZbzf+Kqu9w+TyYfz4LDoircaf?=
 =?us-ascii?Q?CSVgRnt8f4i7Hin3RH/Fs4lg8dKpfaD3SMsc7HhuoiPIILJctNw31DNQY/CV?=
 =?us-ascii?Q?9EHo/tkrGPICV30JnQpAVoq3oWsCSgKT0Lj5ELKnJdIGTl26fjNDGzERNj6o?=
 =?us-ascii?Q?77FWY86qVyIPD7z4aZ9wWIXxlEu7IcGRkPBWmbKP80Csw44S/RI3T4o02WXQ?=
 =?us-ascii?Q?q6c/7oP3fo1I2d9iOHSnJfqMDziT/nxdHDeVfOJ+zPjFqzS7QMFPtMbrdTLY?=
 =?us-ascii?Q?4ykEsAZvC17uQ+cvncvtLoEYldTVAhzxTZt8MNHoon53YmIta+qUffw7MTn2?=
 =?us-ascii?Q?hskUkfEowy/V4tJMg16GzLa9wCZf2i8eM0eMAjO0EXfpH0x++gLIu09aBGps?=
 =?us-ascii?Q?pu/xpLfLWJTOoHNBs1C22fBZUSS59vZBR6+M/VnloXP2F847GzgH83mjG2x9?=
 =?us-ascii?Q?XYNlDeAU3xSyg9QDsz8ijrAfT30DUwpTuE1vphQg9wo7O3a7yWE5k2gDbuh2?=
 =?us-ascii?Q?3k1TlgZiCd3CMhDJUaxs1YWsxiUzqW367eIZDXG002Oc1WOIZChlUfcII1kN?=
 =?us-ascii?Q?D6PJhnv4eE0S00rKhbsb00i2+/zsLuT/y18Qm9pOUIMPe4pd+tL9kAg6P/7l?=
 =?us-ascii?Q?Y4xrR8E3fakScS0U3OG/6GMzumD7nCjAHGTFvgfXJoZQIElbKfV/F7GQ/Eah?=
 =?us-ascii?Q?iGKx9/Vvb0U0/VDqBF7JP8qNkDCdyB4ZNouKDXtpsLDYGREfBUQb8zex7u6J?=
 =?us-ascii?Q?D1k25NJ6LD3aaiWp2Dy+ue2U6+7ngRjvhsC/RPD+mI0BJ0U0BBg0dv89uBcH?=
 =?us-ascii?Q?84GlCp1kjKpZqzTAxyDAYVu/KWhxs4gdfcTauCM5qq6904qC3zZgHuvBgj0J?=
 =?us-ascii?Q?j6dtjTaiBsy3NgWmKKB5pzFPN3+8QacP2Y0v9iHK6lultOfN6oFdgq9whD4R?=
 =?us-ascii?Q?zyHr+MPheiVFclNyvnQ23uWgtv6NgHzwhCO/BnYpFCVVt5PfCADGiJl/4QxI?=
 =?us-ascii?Q?B4s5CJuvPULTsEbLfb/qrH1wdxOvRy/3wSY/DSY9ETlej37LYyhuCaVu3Q+n?=
 =?us-ascii?Q?kdJaZxyS+6SqGxnQgnUe3Hi04Wx+js5y8aYqAcElNB/CL67y1cOe5Nx4AZuA?=
 =?us-ascii?Q?yv+2yqllE/ZBCAFlCVNLLRMddH5bablaEzYWvrDKZI6dctHJa9f596JOCssu?=
 =?us-ascii?Q?8RdBWl+yFNbUkUOXou8lpmXuIe4eeFxW4b1UZj0ZAB0OY7oHr3mNXx2Np2a5?=
 =?us-ascii?Q?P4XKZ5QM23Wh5GQMH5mMgMGc+qOUPYMOVF4IptvhHm1HbrO+qIt+aeFnSvmV?=
 =?us-ascii?Q?wITDXuQUEdTF7ZpVw5Br9LzvPfJSvC06UuE3VyoryJbZ5H1fUrBOT6G9tmgD?=
 =?us-ascii?Q?DMEGkSkUQAdl0g+4PQWGnhfKewzgIOLHf0kc9/nujdoF/DRft5npKQB+HJxQ?=
 =?us-ascii?Q?hiYHeOLhuO6CeKHb2QizlwL/tD8VQLdnRPy1FrueX5HTy3p1HKgBFs9Uk5tS?=
 =?us-ascii?Q?QlAdfqcOsA=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31679fe5-4473-4bef-8116-08da3422284c
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3367.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2022 14:17:33.8324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vRwJ31OEYcShQrPXj03dQeZa9Cjjtao9pyo7KR8yEAnvER1qHKvIeeOx2FDjkTmB2VSfOfd5MqY/hgCARfOgkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR06MB2819
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify double 'if' statements to one 'if' statement.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 kernel/trace/bpf_trace.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 3a8b69ef9a0d..1b0db8f78dc8 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2464,11 +2464,9 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 	if (!addrs)
 		return -ENOMEM;
 
-	if (uaddrs) {
-		if (copy_from_user(addrs, uaddrs, size)) {
-			err = -EFAULT;
-			goto error_addrs;
-		}
+	if (uaddrs && copy_from_user(addrs, uaddrs, size)) {
+		err = -EFAULT;
+		goto error_addrs;
 	} else {
 		struct user_syms us;
 
-- 
2.35.1

