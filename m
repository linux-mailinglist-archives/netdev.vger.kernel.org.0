Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7801A524FBA
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 16:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355141AbiELORe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 10:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355137AbiELORc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 10:17:32 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2133.outbound.protection.outlook.com [40.107.117.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA6826D18B;
        Thu, 12 May 2022 07:17:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VA7qHG3mjHTpXMeCCVgbWGtcSj3cAkRu/Hg/1RDX+RxC/UUH4iF0W3mkO5i0HiqO1gldzpKyLadEYyD7zxWuwuedhKQg0OA6+vCnexjlokpDsmSydvLiTFEI2RS6Vz0yjYAy5k+jM5MsNxeqjKsYZ1+d7Xv3EZmGtNzeQK+RxLW32/xHqyg1jQJikkK10yfR6hk1hSw0EWDMQvl/hvO9Wom2+IJvOdzMlnum5txEVfsU0HrUA5nFu/leMIH+pJVzzA91I8AbUvLoZFDrk5Ov+dK3a94s+EmrG5f6TCpnOZ0ZDjKYuYi8MpSQOnfY3GqKNsvvukC3wLMgbEfDItGcfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3QtFBEqW/y4ETycRPZVO5c1a4DCagIa9eabyA/nIRN4=;
 b=NxAZucuuwNrxMqAqt3hl8V8gQbxtcZ8lSXytdrMaiVlAtm1OlIvh+KT+AM1pOP1hh5zzGyiO0mRapKAsUsCyn3IPhzydY7wyXF1qhqbzF2gHZrMFCD2baEJWQSi5OZlMj1OQScxOmjLZNKvjhsqUGPabSSIidei0bNJDY559ndSPi0KD5YS1F6HMGLS6IcI1/lCEqiTmVc/IIqU7GNpmfPDOGYX3MialCWV+oMNhDDEPYdHeh6MXEpB8jmC+poWfrJyTj5YNRoWEWlynat3pkEnkAnFalIwkWl032IXy15yGHailkkHjanSxmOwCGrM63eKynba6gHKPAmsD1catGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3QtFBEqW/y4ETycRPZVO5c1a4DCagIa9eabyA/nIRN4=;
 b=ek5cRvqAnWxp/+GPuS32TVUS7wxaQX8gpVAQaJFyyRcf8D1Iz3EBuyS13OissxLHy4W53+PhFl+7LjYQgpmqsozcAbAnpbqgYQatYsjHOD/XkLLXv8pq3AkDL+1nKprJ/8GYb2A+nhj2vcQSkVQMRSwpSRh4er0YkkDqe/9GT3Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com (2603:1096:4:78::19) by
 HK0PR06MB2819.apcprd06.prod.outlook.com (2603:1096:203:30::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5227.21; Thu, 12 May 2022 14:17:24 +0000
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::4591:4f3e:f951:6c8c]) by SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::4591:4f3e:f951:6c8c%7]) with mapi id 15.20.5227.022; Thu, 12 May 2022
 14:17:24 +0000
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
Subject: [PATCH 0/3] bpf: optimize the bpf_kprobe_multi_link_attach function
Date:   Thu, 12 May 2022 22:17:07 +0800
Message-Id: <20220512141710.116135-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0133.apcprd02.prod.outlook.com
 (2603:1096:202:16::17) To SG2PR06MB3367.apcprd06.prod.outlook.com
 (2603:1096:4:78::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0967f460-abbe-4d73-69f0-08da34222286
X-MS-TrafficTypeDiagnostic: HK0PR06MB2819:EE_
X-Microsoft-Antispam-PRVS: <HK0PR06MB2819C7197C06F6CBB278A76DABCB9@HK0PR06MB2819.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pEC8fk1YFnzPjgs99vjpNfwsvDuDkPrzCMoatHsjZjNfG5+6zNytl1b3IMjuhmIdy0X9fGse6UyVSjyiCBPymTz1QPkuSjI3aa2HPN9O2DBnv+we3JULmYcZLBaCvWxS4o45MotxBsWtEHJ5zs1eWH+ke9xeOR3Yoh1i/TIxpw7iXBIirOdEH/Sd6Dih4RWcKxMU+phjPlJBT5MprztQjSTxW3nGLFpECyipYxZDcpvsGfzPsoRn2nQtHiz5WN8F2DN7EuqS10nyz4uaq55P04O2BJPT0shYGTmk4DYN3lcpD+VctXuQslMYzZZX5eRoLLYKlQps0naCt9utuO6fHifYoHtN++fVWBxH1VL74OHRBvjIbYUZgyh3X+sKkUriQOzcgOlXejSQtPUNp+ABuCpNvq5nnUGhYAbfb9Pac7ONb0Nr8KtEm4RyU3kwqtInBDOSKBNgIamyFdt58NS1peLg7PGajxHIiEC8Lwnc/Lh3Mb4EO7+/IG8jl7SuZORW+qapmZ5WpFSfPWERmr744I6xL8o6MetRTtabxwWB2ScoPSDkl4vSudzPVQVeKGWVEZNMVW3vCbFMFKK01TvBYXAYlGJmWkAXszZIOAtFc/bKU6XsHUvQJIF5+BGWJk7zZjsJWZQkJAgZVIBS8kUskeFBjpSoezJNWAySGSyZi0ejN/DXVCsVA+RQXDoXxMq0QmQ2mt+9Ji3ZFvuOQQMJGBoBExgZmfZ/1AXhVMrm2+nll475muNeM/rHagnlY1jC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3367.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(921005)(36756003)(6512007)(38100700002)(38350700002)(2906002)(6486002)(26005)(6666004)(508600001)(7416002)(4744005)(52116002)(5660300002)(6506007)(110136005)(86362001)(83380400001)(316002)(66946007)(66556008)(66476007)(8676002)(4326008)(2616005)(107886003)(1076003)(186003)(21314003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BLJASHxLHegHUO1hzR/oUw+O88npuXAXKot2YkS5HG/P8CLHXk86ACJ7Up9h?=
 =?us-ascii?Q?A5J0EoPbIUeOW1TT2NW1an2pzjmO9ecWCWi0OTZap6kfPvM2hgiKReA3oIUc?=
 =?us-ascii?Q?uL3NdGO0nTbX6m1gybEoVaH6NXzKJG73AdL0oTl9wdXWSv2xPKIK5P1q/Sqw?=
 =?us-ascii?Q?iNjWeRveZ7URAS5DF89ZUhZbboN/UBuGNktOMD33dQYTtaev6WTnvTwxJjBB?=
 =?us-ascii?Q?GZPHCnjt+TDmQTCzmjzic7yxoxa5pzQU8w5GZA/K65f+TMTRpULxhjlIIds6?=
 =?us-ascii?Q?G3opvbjajjNERvZS5ZVlZ6UHjevAvToFo3gsz7rMFltgw5OHBuW4MN6SkA6s?=
 =?us-ascii?Q?H3crsxSXHXadDMF2o9eyEhoBI6XN5tHesNP8ci2bBjjftSJsmzv8yX/C+we+?=
 =?us-ascii?Q?0DanmRdRhvf4BTTLGN++grM/N6K1F07BW63hsrHkGxov4I4SO6lZ/9skPJis?=
 =?us-ascii?Q?4X0n9Q/aaedVkL/7UTZhv1A2nvSkj7HzbyeeM03oh/IOpFs1KXVzezAvYwQf?=
 =?us-ascii?Q?01KLmi0lARBtwbj94cOmg5r6tD0hm2vFMXIqKwO5KrdXK29isiTwoRMxuy0F?=
 =?us-ascii?Q?DVOaXsMvYelVUcgYdP02ZJCuaL2q8y4MxC0kzeFe7X/2R9WAN+W2D/BkoTv6?=
 =?us-ascii?Q?CdvZ/msWfHICw859w4lhs3YPbiYa1f+AuqIMDTN1d+Wj3BTHAcgKNaKoJsn6?=
 =?us-ascii?Q?CoJH3qZVU8fuyydZgkT70YVwCNDyJpbwPuzFomewLtGzdQRz7fPICMIEgruf?=
 =?us-ascii?Q?hdiaJbO5EvkXCISTXDXLRF3Sven+132ARvYitmjeaXbaWjR8eLqe0H0dSFMd?=
 =?us-ascii?Q?s1PvQvyQYOzFCjiu7TSEEgrJKJQPTr/EODhMTiMxooBAk2s3U5+cqxheCPj1?=
 =?us-ascii?Q?++PUOMQuxUZwShrhA4QP/OJnLilU1h0Zi7OzPCH4w/juhYaBmmyDnx5OrJr7?=
 =?us-ascii?Q?eyY4RMxew2sSt5QTAhhaqj91NSKAbS30ldGFLKngH5A6qHRCNzH/Tx0MPrwz?=
 =?us-ascii?Q?qmdrdXlUxQojkgXCkGBzHTwVnhdXMznnImn6Iym+3ckAhDstu7lmcVfZ+qkq?=
 =?us-ascii?Q?TQtqU89GF/kAmgtcS9A+LdfBaHErdHHxVKLxPcKEX9qDWiHksybZzjlTJFx2?=
 =?us-ascii?Q?bkYGlc8Iyf6EYCZRM8gymm+R3F/BLK9m4dcFvI7FXQ5RMVxTrVzCILMT8RpJ?=
 =?us-ascii?Q?x3e1kpGiJVBWUNZOGqinVkowr5aMGbbmhI8yXBb7bweRgDiRo27Nf8gxZ5tM?=
 =?us-ascii?Q?Rx5uiC9s0tpiw7QWm+zdV+wxfV9X1mAU8baLcz20xzB+ShCAxE5MJXeWPuJW?=
 =?us-ascii?Q?p3WKRukJ1PL8luUVklZZu8HGQysAMBWZ5aLVqNgkmKr9igwftNpa9ZMA8OF1?=
 =?us-ascii?Q?54FKCgrTYe7XYhYraC7JwMo+gPhqE8ZqNZ3J49eAre9+I6g/LgRb88npZTvA?=
 =?us-ascii?Q?hadNhZOrKFG4TdmQfhc45qwXNsFw2AFQwTb84ZQGj77K+dWbgWWC1xx7riAy?=
 =?us-ascii?Q?HwiTWqtD/frSh3ACl8X4LBPhXTWXaISwaVI5FX0KRZGIKmNE4ylZ7eE8mURh?=
 =?us-ascii?Q?eDWMvMl5RHl6goqL4O2HuPw6Rg96yU7Dv4KsBb7FWGPctFPPvh+QSi7jyMvj?=
 =?us-ascii?Q?FDFkqCSjJQt/Tv4RoGQCjviVlNh5K5sHWuKSrudRa/rVBF7K9IZR8GaQKQwt?=
 =?us-ascii?Q?e6OniG4FsIJRObUMCbd7gA1jf3QLedjjq5Uk9E2ECxtCB9XwSQJ/tkXyginl?=
 =?us-ascii?Q?f3puRbm3VA=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0967f460-abbe-4d73-69f0-08da34222286
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3367.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2022 14:17:24.2394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L/MqicdulRiUb9HvmeBWoTVOjJoT/Ir11E0LJTfIi5f/kFgIRwyMQGk/spLxXoKp3blc1vcw3nTW1Pf86iAhtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR06MB2819
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series tries to optimize the bpf_kporbe_multi_link_attach
in bpf_trace.c

Firstly, there is only one 'error' tag to handle error code. But in one
'error' tag, there are three 'free' functions which is not efficient. So
I split this one tag to three tags to make it clear.

Secondly, I simplify double 'if' statements to one statement.

Finally, coccicheck reports an opportunity for vmemdup_user. So I use
vmemdup_user to make code cleaner.

Wan Jiabing (3):
  bpf: use 'error_xxx' tags in bpf_kprobe_multi_link_attach
  bpf: simplify if-if to if in bpf_kprobe_multi_link_attach
  bpf: use vmemdup_user instead of kvmalloc and copy_from_user

 kernel/trace/bpf_trace.c | 34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

-- 
2.35.1

