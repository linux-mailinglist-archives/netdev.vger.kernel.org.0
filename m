Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5722D64ECDF
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 15:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbiLPObW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 09:31:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiLPObV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 09:31:21 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2104.outbound.protection.outlook.com [40.107.95.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E2C13E09
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 06:31:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FuWjH5Erc3YqWy1O7MOJxJBMIhOTPiHiPRahFYmJSbIcRlBpxcBZ/jQvhv+UKITl6qyu+Vs59zo/tNWuw4y8vD01iRm/mwsz5v5Od4NX/V/I/4WJrB7fiRFH5YHUpqGLdHlXk4+hmkeADKFCpJa++IBbHHcMtnnyqwR0Ifp4Ok9Np4UofDyEuuSXVVBNz7Ri2i/k33PawlYgWrx6x0MaSpeDdbRYUD33yVSamU4tSWC+qzmmjXyt/4atjp4l74jLR6qKFk5wmOZEN98Dj0gPMtAY3dBfDa3sTIzbkZizNQ9syVKH8/5anxRE48Agir0NPSWILXa3Z2D9zVkR/Kt4Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jatVO05oLDRSmVPYbfW8Sl0oUDB9qTK2U2sof3SlRTg=;
 b=gU01euUAYTg/4X6gafgdIn/0YQTJmF0tHR//QIqyP9nLPZM8s5LvQq1fj6s29yce31vFyHKE3f1WkzwvN3d26ULY5Yt2SSx5MHTksCuiiZ5hz+ztQfKm1jHHQ82nkhy4ahFspIJprf8l5ruPUaecM5k4O8mh1CRfrLvVV6bSzx1cUuiawE2ZjcrD7q678l8qjaz+ZIjpfAntbX4O8crjxlCJkr8KtsZ4Gjnwmlu5cQTgEaudJA/Tpjgkll9Eg2eFq256n7ehPDVmW0PQ45knaVcS5R6DRz9jqihwXU+HiF5xfgNCXGw44FCSIarcMjTQuB6p3DOr2FEKQy5ymQ/M9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jatVO05oLDRSmVPYbfW8Sl0oUDB9qTK2U2sof3SlRTg=;
 b=DCnyi8jqGu4EqDEXbd88IQz36oh57Q02ZWX55LYcdVehMAQz1uhGNQJGoqdXg5AxhVNYxJ3FamWJ38IdVr3EmDj5EspbXw77WrzlExA6VKSkA6Vn3OGw7KBpWzvEI1G2LK1PiaPN/oLysXehUwKBGDJ99xTwjHsOfqcwLRKA10E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB4801.namprd13.prod.outlook.com (2603:10b6:a03:369::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.15; Fri, 16 Dec
 2022 14:31:16 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%9]) with mapi id 15.20.5880.021; Fri, 16 Dec 2022
 14:31:16 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Huanhuan Wang <huanhuan.wang@corigine.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net] nfp: fix unaligned io read of capabilities word
Date:   Fri, 16 Dec 2022 15:31:01 +0100
Message-Id: <20221216143101.976739-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P190CA0017.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d0::7) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB4801:EE_
X-MS-Office365-Filtering-Correlation-Id: e2dead4b-0ee1-4c6a-acd2-08dadf72305a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 458xSHHezvSb3xCQ1b2fRocc5lhmA/v04KDIjQUTNqo5dxc1RM0MzG6oBxnUBV5RZrGkC3jl7Bu7/QBBxyLFoLX1hy9HmZQcxQ+EUNIDgc+dFJCc9pSEJ9ZO15SZ/7ppndSEy4axDCbI+nEOKpE72K+3JnECTH6pPrJseGmLdBsqDfDQDWTn9Zfroz9Wxsab5Ws+COIs47JKxJ/tOlbuTKwAcQia6g4ariDMwJPRsUseaorl93k9RiST+1cP8RuRxzzAroye4O254AVYT+rNu7gRg57dg6+m4G6Zm5Be9JhDRdo7278Q+No4oZ4RmVKL/93s4G4R7Q45Ic2p3k6gfNtX+h3ylGShkdAaKEONjtQm1ySMaQmy+3dIGH+xI9wKESsJ9qn0lR7YN12OhogCgAWQKqATvHl2An6RStx7HuEqrzATThLDBw93/x0lOieXSGGGjv51LOCQEEzf6ve36ut7ExZj6zZMDlGF6n66jC9KVlnT4hCrdNKfra/kJRTdTXtMinn0foQMIM/Xk5PtdsA9HJgbw5p1pjcC1rOXDD+CTa7BmRk9oXOoSyvkbt7eG4jM9KsDKt8SjMe0w1inM3Z0TTrc9UNFpunIK/61F4G9TzF+ki/YOqkYb0FmlSVwDgj3lJ1md+9b0bO9UXspXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(396003)(136003)(39840400004)(376002)(451199015)(36756003)(38100700002)(86362001)(2906002)(66476007)(66556008)(66946007)(8676002)(4326008)(5660300002)(44832011)(83380400001)(478600001)(6486002)(1076003)(110136005)(316002)(54906003)(52116002)(41300700001)(8936002)(6506007)(2616005)(6666004)(66574015)(107886003)(6512007)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bzRyVkhWckdSbm9rUU1OcDMyOWtrT2ZWZlQ3MnpDYnR5NlZTWjVaTTMyNlBw?=
 =?utf-8?B?ZGpxeXIyOHRieEhRY3VqemJMeEg4ZlVweERuaFMvVXlvcitGaG1FSVRpRXBY?=
 =?utf-8?B?QUNoeVdXM2ZPTEZnNDRmQmUzNmtsNzJQNVBrY3JuQ0U2aTlpM0ZOengvVHU1?=
 =?utf-8?B?ZjVxN2hibUkvUXFiVEFYWVlWb3lCbTdTUm4zanBocFNJam5hQis4S0drZlVj?=
 =?utf-8?B?Smp2MFlDalJ2Qk1zZGRZbjV5aTJnRUhYdWZMVWY3eElHcHo2dmdNblRZUVRh?=
 =?utf-8?B?TTlQZ0hqTnBlRStZK2ZtQ2t2ajVxZ3AyMkRrVnhacUpDUElZYjBublB6WWNs?=
 =?utf-8?B?cHh2VkhMVEpiWWFtYnBQakdSUzltTGZ5am1WRVZWajBISS9kaHZKazFLM2Ri?=
 =?utf-8?B?ekoyOWxXcVowYkVVOUNkK2pkb2x1OVAwVm5yOWdJeEhpd3BqSituUEg4Z2hJ?=
 =?utf-8?B?Tno0T1k2MUN0NFZ1MmZGYUNEMGl5MnBTK3VhSk02VjZHRkhJNHlQT09aT1Bx?=
 =?utf-8?B?N1pmVGRTTm9ENm1JUElUT2hJSzA1UXF6OEw0eW5WOUYremtoOHp5SWIzN2Z6?=
 =?utf-8?B?Y05rNVg5dkZEMkRVWTJNN212MnF4ZFRlbm1KU2w1dGJERVhUZXhQcUlzcTRx?=
 =?utf-8?B?SC8zWnl3TXN1RDdWalpQcFpEaWxDWXJ0U1A1d2dxT3RjV3R6RHp4anVyVWt4?=
 =?utf-8?B?SWR1bFdrNnpXc3FYc1k3U2RCOWNhSW1xNm1qWnhYYW9kQWljWW9lSVFHZ21Y?=
 =?utf-8?B?ZUxxYVFYR3VEQ2ZuUWlCdTBtci9jMS9XdmxJMytSbTZaN3dHVFlVRUkwZ2o2?=
 =?utf-8?B?ZmFqTXRIdUtydTQyOFZURzE4TEJVUmF5MytBVjQ2RFhZNnk3blhPTllocTFJ?=
 =?utf-8?B?VWpSMUk3bDhaVndiRE1RMDRVZ1R5cTlobTZUV2kwcHVoTzFmYmcvempaQ2xE?=
 =?utf-8?B?bHRFWUQwL3hDTFZ4b0ZXL2RUaDJiNHh1WE9PN1lxR3dHcEtxb09rU3huOTRM?=
 =?utf-8?B?dTJlR1dqZ3pOcUlRT0JpWTZrRjJBZ0k2YnZmZWFZT0UwRHFPT2ZlMWpNb3pX?=
 =?utf-8?B?YTRUeUw0T1Z1MEJ4aGpOd2lxTXdiV0tCVmlGbkY5K1dMNzJ4ZG5HcGtvSDcv?=
 =?utf-8?B?RGE0RzVPT1l1VERadk5vUGNHc25LR0JjRmpIdWh2V3RTU3E2b3U1ZDAxNmFz?=
 =?utf-8?B?V1lORmU0V3gzTHJ0MnF1Y082dk1vVjFGNnVHRHozNG5Oc1hpOWlnVkVGdHJ0?=
 =?utf-8?B?OVBBbXJPVTNZU0hjMVkwWVdqOE10OEpMbEFjbnVKK2hPVWNuVWlQQXRIUFAy?=
 =?utf-8?B?OHB0UndzT05EM3J5MFpyUTdHS0RFV01Zai9qSW02a2hrR2l1SkRRd0dOUzNx?=
 =?utf-8?B?RTd6T2RHYTE4WG1CSUxVY1BYQWxrU08vMnJpRXk5dmc4OVp5QmFCZVMzSmt1?=
 =?utf-8?B?bU5ybTcwNmhHZDlQQi9QSzdQRDJ1OEdTek11U1dYT0hSa0RjQ05GaTNEa2U2?=
 =?utf-8?B?dVlqZnJzanRtS2RJM0dHZVZjVTZiK2RmT1lPNEdzbmIyQ3ZJUS9zdUt2Wmwv?=
 =?utf-8?B?VmRUNTlHNENITWIyVndBQWU0RVZheTZNekVrN0R0QkZ1K0NuV2RiWFdOQS9S?=
 =?utf-8?B?dHZTM2lxU1dOVnFhTE1YQlRtUkZBcGZjRFB4MWpMd2JZVTI0Yy9vaWRGWjJx?=
 =?utf-8?B?RE9BbzlIYlFGN2hJSTZjM3QxZjI5MGdlb1Nldnl1MURKT3FHeTFhWFZxbzdj?=
 =?utf-8?B?YUt5eis1bGJtTGJURkxEaVZPeHV4aGN5MkxOcG1GQVQrSE9PYXAwNitVd0ZO?=
 =?utf-8?B?QXEyREpBWHI3blI1RCtjeCtjZkFvR0FKalM3WlAyNmJRQzJRN2NDWDZqbUpB?=
 =?utf-8?B?WTg0YWVILzhEQ1hlcElBZU9oZHdxclRvem9oaXArcHB0WHlwem9RTFdDOEVi?=
 =?utf-8?B?SzZjVFRQVVpGTmsyelI0RHdGOUIvTFFMeFZmWDFmM0E0R1RxbnRTQVZBOVZw?=
 =?utf-8?B?dmczTm9NREQvS3pwUnkvaS9qN2dTTVRwcmFhNlM5S1JZeGZaTzdtVUxxYU53?=
 =?utf-8?B?M3VDN1hpaUlCV21zZkFOME5RYkVCWGFWYWFSNXhwVjlHWnZycGhFSGNNYmk5?=
 =?utf-8?B?ZlphdEtHQmdNUThlMlNYakNLMGFWUkVXWldWREU4QnVLQU90QWlxWks0aGdR?=
 =?utf-8?B?NUxTck9GeTVnb3pwdFlZcllEVldvYzdTNE11Mk5jN2FyNnpTRkNVcGl1TVZh?=
 =?utf-8?B?Z1NDWkJsUFVHTFQ3bjEzZDFkdXl3PT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2dead4b-0ee1-4c6a-acd2-08dadf72305a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2022 14:31:16.0298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZgVzVvyjc6K07R0Bv6gpazRZmpB9Q6aM6eygzkICIgAMO8r1wqbkYYnK1m6WA3ldhZ+Bq2EaRhri8h2cUEusBJMoGiFQ2TS1lU0UWGyuVKs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4801
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huanhuan Wang <huanhuan.wang@corigine.com>

The address of 32-bit extend capability is not qword aligned,
and may cause exception in some arch.

Fixes: 484963ce9f1e ("nfp: extend capability and control words")
Signed-off-by: Huanhuan Wang <huanhuan.wang@corigine.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 2314cf55e821..09053373288f 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2509,7 +2509,7 @@ static int nfp_net_read_caps(struct nfp_net *nn)
 {
 	/* Get some of the read-only fields from the BAR */
 	nn->cap = nn_readl(nn, NFP_NET_CFG_CAP);
-	nn->cap_w1 = nn_readq(nn, NFP_NET_CFG_CAP_WORD1);
+	nn->cap_w1 = nn_readl(nn, NFP_NET_CFG_CAP_WORD1);
 	nn->max_mtu = nn_readl(nn, NFP_NET_CFG_MAX_MTU);
 
 	/* ABI 4.x and ctrl vNIC always use chained metadata, in other cases
-- 
2.30.2

