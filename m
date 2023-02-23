Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE2996A0A52
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 14:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234290AbjBWNQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 08:16:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233733AbjBWNQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 08:16:49 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2110.outbound.protection.outlook.com [40.107.237.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 232AF1710;
        Thu, 23 Feb 2023 05:16:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q1r8FXP2N5c1zg8hI02g/7sx14X8l7WURQorRsVyhqZY+owzPAk9pJpdRlQSMEqvzPs0jEoFpWjpTNmBDlqFAnMPPtBtvih+Jjtc49zO+Hi3aScQR9ko6fAOzBIZTrvW8QXkLxbGLKbO0esNfZCI8g4vxfc5CHbaWWefnwxcpewCYeevSEobYpOJcuATZEeDgwYlkYFZ2vpdLxAFUcnyeRbivO+Fq8lZ2PHHMA7eH+PUHfFgj/UEX7xxcYJqPUPNE09SZXxgrM2cNkUKisodJWIjhiF6jChdTn+DmBHqtUaQKUm+sYddJ9H43Qy9cYjmP7D+9/1Ze93V8HW/VdiUGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=twW9RvXosqYPLpGNfadMwHm/iic6YNT5Mt5N9lPrZ6g=;
 b=hDLCvnfmr0gXH3g/8GPKS9EzTW1mI9fxNVXwRFNchFS5EbCqLGrpjGGrbM9cL6lgcu7WpHOVWBpdQc1ovf3hatBBzPx2EF6K6Ksgidy/53lTNo6gEKdyJ5w40JPVowFb4+cmsInaaaPQ4E3eC8XdOwMSNpEKgymP8vjtVD3Kqsxf9WUZliuGVsVi6UUtsM1ZwUcqq62iIhRUMW89h+SbmYxNisyDVsDp4QLtZZOSb7dVUN4MuveTxFwXLDhXZsWtdJarrlcTmlu+g6B+agvn9jbW/MZJJgyGZFP1/iHRsWD4vuGx3z1wqbLFZo+diqVn2KDUjHe5tcuSRBZiQA9NuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=twW9RvXosqYPLpGNfadMwHm/iic6YNT5Mt5N9lPrZ6g=;
 b=HsNaaOm750T300zrnH+Cz6qFxDxB+iieEtwWyU1BAyAD8MlxjllfqWMSY74JaE8DFa8/KZm2OnMUU6nvuHnss0N9fQyBd/QVEQTB6bvjmCquxzrRea4B5pz6PX+p/a4iOmFwkp1AXgWz3Gz4rye6StKEMAkHJ6JVYWNB1YkXDj0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3637.namprd13.prod.outlook.com (2603:10b6:610:90::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Thu, 23 Feb
 2023 13:16:43 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6134.019; Thu, 23 Feb 2023
 13:16:43 +0000
Date:   Thu, 23 Feb 2023 14:16:37 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Sai Krishna <saikrishnag@marvell.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgoutham@marvell.com,
        sumang@marvell.com
Subject: Re: [net PATCH v2] octeontx2-af: Unlock contexts in the queue
 context cache in case of fault detection
Message-ID: <Y/dnNRD4Gpl0n2GQ@corigine.com>
References: <20230223110125.2172509-1-saikrishnag@marvell.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230223110125.2172509-1-saikrishnag@marvell.com>
X-ClientProxiedBy: AM0PR02CA0151.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3637:EE_
X-MS-Office365-Filtering-Correlation-Id: 48d34099-b75f-4bc0-19ce-08db15a0350b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: StYRcUdYXLA1XNqs2ewOStZMEKSjo6bWoe/ep5RyPNxMpXdh3E8+jdtwjOlvMSBWNm+dNov89XfPJE7L7rFiu1CLPrLUUsPykcaJpzMfJX/JoGS56h20RxpH69ewf/qi4GuxrSEsp4ItgPFPJjMq9eAuGtNABQEtBNJaiCvpDAqBUbTYLg3Cwb6Q3ZR38fa3QRRn2kXDTsOGF5Ra366KCE+bdCUKBdcUCX2788rHjIt3+eyHLPzH1m3KGFJn5tXet43bKbh5uCa+veTPdnNa70B9wWHxiHJyN5O7Bc2P8TIWAmjj+Bb/G3U6gRVPc9svkYjVhMsnTvUI7m/Hi3MQwGjBz3MlGkxUrW9xcwH/q/RZIiUkPRdHOgmL+UBg5E6SfX/6xPK8r6PVPysL++cToZzUysRX7yp0hNYLznhxu5Sd5h9vVlVOK8VjgrWNkqtPidRJWHr1/yLy2yDLgY6IOvihKK71WPiIv5d6aTG8f2hqp+uMzgObVuPu3kVHo45Bvl1VE2kTCamB/FwwdXous1f77HtqUTomJcOTihHOKvQwW2yNgrEinvkCfWmv3pAytBkKLNV9I8850e8cp3EKZGs0JN5FfudYniQKOxR0dD54In85Xju/A+uTx6WGFzcdc3KjRo5ttH5i6424+JpIjoOZy7AmP6n98/WwRtFe0OiQmEmlNMJFP0ek+SlTMvSx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(346002)(39840400004)(136003)(366004)(451199018)(44832011)(316002)(41300700001)(6512007)(186003)(8936002)(2616005)(5660300002)(6486002)(478600001)(6916009)(6506007)(66476007)(66946007)(66556008)(8676002)(83380400001)(36756003)(4326008)(38100700002)(86362001)(6666004)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?17YubtIXPVFB6HfbYKfih+WF3y8P705wQe+qerhIsyOLOxXv4UVotinj9mHY?=
 =?us-ascii?Q?ZuWQT6aG0XlkMebJAY5ypEa67ZCDQ8/MUEPK6UYuSALG+kmwZ6Upm6at0qGj?=
 =?us-ascii?Q?sW248tC5jOFo0WUSMBRdUgfYjVtmNm6pmfb+RqPosI18zLP6j5lZfthrznIr?=
 =?us-ascii?Q?WUJ8hsfLHZNQXRkSLke9ZMB1TZA7TjmRA8pPydIJe5RXZv9jbGMPkdLJZOXD?=
 =?us-ascii?Q?jCdL4ZnX2ZxJjqI3xQJeJNYvfpE4jU1PFtJiz+5fsID6YCC2PtR2ZpkqAzHr?=
 =?us-ascii?Q?5sT6pcgoVzItSObnGH660R+R582eFLCMxKCYk3i5QIutXkmY+Qk/3A10WSNE?=
 =?us-ascii?Q?SLyyFtLSJa9FTvFH79gvifgHGgQXs0jJa6BrkcvPxWSRih7avOTjupwCx0vJ?=
 =?us-ascii?Q?ZosEF2uuJdBrbRWxJ6z9unXbI6GoKbvLD1tL+a95CT6XvT0NWI4R11THTkYp?=
 =?us-ascii?Q?4aX1nsn30rr1SzGj9oHn+43hIRcfBNI5qccn40FoyM3aR5VHPFYxIQwEwubT?=
 =?us-ascii?Q?8uaWGaMqzSj3df/Bau8wTV4xyS6X0YlyanCLbrea6JfOOqMXVESCaAfy0bSD?=
 =?us-ascii?Q?X371YUb4j2b9JdyZUPBj98eO8bN64heX7zs/56dM/PQNzr7GfJTtG/orLj7B?=
 =?us-ascii?Q?a8xNG9uf14Xle0sQUA15L1eWp5I/1//T0gx0eqDCB9JD6iqLExoZzEiJRWqD?=
 =?us-ascii?Q?42iUIHGrCB57dyWm8XhzJwEvHpmOTlM1UMv7iwZYPIbBnaMy0dObwplbFJ4p?=
 =?us-ascii?Q?huPAT1G0enmBz7gq1h+MH+Eg4TWd6k6xKSt+cwTVmjal5iE+tJHsyR9Xfw6m?=
 =?us-ascii?Q?+wJJPbvBK1ndUQR8z7glJh4FBA5XsDZiqS+MnqyQPBY2G2rkjQfXMkW8gCDB?=
 =?us-ascii?Q?DrbaPP58Yh2YeNJBPcjJmcqiacIYc2M1tdCLvHDKaiXqumlyx2UT5NoX6aoV?=
 =?us-ascii?Q?trnxBgyXxyJZlls6o3YiBjHy43n/7DCR6HK4VQDG9KOL9Q6pbsqkidym5zgx?=
 =?us-ascii?Q?TXRyvzCkaGTx9pE84ZZv6lUVf/xXto7IeSczNq4rhnSIEfpZzKNwg2DFxkB6?=
 =?us-ascii?Q?rNs+iGwyDH7LK8/UeW/4bqY3FxjLHzWLPw18RiAHBYDaqKW7zEkX+ddDDCwE?=
 =?us-ascii?Q?SgncF0hu1cuBF0lVV0vPUF+9tmN1+4tY+PF394Xl0a0YSH8kgAYoe7DMcr82?=
 =?us-ascii?Q?V5Jt8K7fo+GRYMnH3694ZHS9WM7PTdopcKKkuG6hx96uxvMxR4bFXrWrb9yC?=
 =?us-ascii?Q?rK6dEhDaYSp35L/7zyB30ZMHSwP6c4bwk4Xra3iwEpKaHqzys/SWG2beshy6?=
 =?us-ascii?Q?MaEUHUjPAWuLexEgnuA8vXMBBEO4YyK5oLAsbZ6hX+FF/zYiEQzZ2gvj86hY?=
 =?us-ascii?Q?YW58bvNRuig7tIZiyyZp4TaPli65afDEq4pDvjXiFl4rVH9FbuXUydLzddx3?=
 =?us-ascii?Q?z5UXasvj1KmY/FRSXTNKqg0qvOKYgGawVFKdNpqVAK1FoZ3gVSbPuMEFceqS?=
 =?us-ascii?Q?Bs57WVG/8EFoiCpeV/vYyFfe7PTNHIYlDqIC28ealYbPCFRrqaeqd3eT7FkJ?=
 =?us-ascii?Q?MGS2K8TNHd74x/G/+7Bm4QxxEbOTpzWnjgalOoZfsjySKr2fJehlnMyCT/6/?=
 =?us-ascii?Q?LTDG5uedv1s9gCRk78LfX5qtUFKopxc/0WDi80AZEsuas521Dt9DxnD2xCbr?=
 =?us-ascii?Q?o3JMWQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48d34099-b75f-4bc0-19ce-08db15a0350b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2023 13:16:43.4283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SVnPTkWKpFtL7hoi6CEcZyfoiypQXgVHlWZfOR9Cs0AO/9ncZxzNo5wwhP99aqG+u7K0n5QAOD4ngE6/CuKAAA9OkY/zFePemYeehbQVOzk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3637
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 23, 2023 at 04:31:25PM +0530, Sai Krishna wrote:
> From: Suman Ghosh <sumang@marvell.com>
> 
> NDC caches contexts of frequently used queue's (Rx and Tx queues)
> contexts. Due to a HW errata when NDC detects fault/poision while
> accessing contexts it could go into an illegal state where a cache
> line could get locked forever. To makesure all cache lines in NDC
> are available for optimum performance upon fault/lockerror/posion
> errors scan through all cache lines in NDC and clear the lock bit.
> 
> Fixes: 4a3581cd5995 ("octeontx2-af: NPA AQ instruction enqueue support")
> Signed-off-by: Suman Ghosh <sumang@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Signed-off-by: Sai Krishna <saikrishnag@marvell.com>

...

> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> index 389663a13d1d..6508f25b2b37 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> @@ -884,6 +884,12 @@ int rvu_cpt_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int lf,
>  int rvu_cpt_ctx_flush(struct rvu *rvu, u16 pcifunc);
>  int rvu_cpt_init(struct rvu *rvu);
>  
> +/* NDC APIs */
> +#define NDC_MAX_BANK(rvu, blk_addr) (rvu_read64(rvu, \
> +					blk_addr, NDC_AF_CONST) & 0xFF)
> +#define NDC_MAX_LINE_PER_BANK(rvu, blk_addr) ((rvu_read64(rvu, \
> +					blk_addr, NDC_AF_CONST) & 0xFFFF0000) >> 16)

Perhaps not appropriate to include as part of a fix,
as NDC_MAX_BANK is being moved from elsewhere,
but I wonder if this might be more cleanly implemented
using FIELD_GET().

...

> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
> index 1729b22580ce..bc6ca5ccc1ff 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
> @@ -694,6 +694,7 @@
>  #define NDC_AF_INTR_ENA_W1S		(0x00068)
>  #define NDC_AF_INTR_ENA_W1C		(0x00070)
>  #define NDC_AF_ACTIVE_PC		(0x00078)
> +#define NDC_AF_CAMS_RD_INTERVAL		(0x00080)
>  #define NDC_AF_BP_TEST_ENABLE		(0x001F8)
>  #define NDC_AF_BP_TEST(a)		(0x00200 | (a) << 3)
>  #define NDC_AF_BLK_RST			(0x002F0)
> @@ -709,6 +710,8 @@
>  		(0x00F00 | (a) << 5 | (b) << 4)
>  #define NDC_AF_BANKX_HIT_PC(a)		(0x01000 | (a) << 3)
>  #define NDC_AF_BANKX_MISS_PC(a)		(0x01100 | (a) << 3)
> +#define NDC_AF_BANKX_LINEX_METADATA(a, b) \
> +		(0x10000 | (a) << 3 | (b) << 3)

It looks a little odd that both a and b are shifted by 3 bits.
If it's intended then perhaps it would be clearer to write this as:

#define NDC_AF_BANKX_LINEX_METADATA(a, b) \
		(0x10000 | ((a) | (b)) << 3)

>  
>  /* LBK */
>  #define LBK_CONST			(0x10ull)
> -- 
> 2.25.1
> 
