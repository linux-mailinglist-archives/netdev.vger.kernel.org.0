Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D62536BF924
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 10:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjCRJD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 05:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCRJD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 05:03:56 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2094.outbound.protection.outlook.com [40.107.101.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8B78A7A;
        Sat, 18 Mar 2023 02:03:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QLLMJpRNng5PHwCUEP0N9ZNJu5pmzfgQ5CJEhtzrQ1M9MiT+RbIJ+SCIgtehCiWQWl4nCVTY/yTx3kHkEu4KBAXBixClwN7myGivnIhaEmX0jjZCCYngbEGg2fbho97OYmmklwmF81TM9eIMppuLrxEA6ZVkLQAfjYftCcC6A9v2hHMFPpCdps4M+RIUFOa5irdwFtQDrkvwhYkUvi9fySxh5FUAvAJDb5gWl4BMV1GtdU4V0jzqOq7zVhTL5whMMNMQvlgzv4NhLUY338OHnn4CAPVuRu8XzLwFsA1F3ujLbjaZc8igrnmLVON298avzZerUttH7yNrQg9hwJYOsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ps7fVMFtYjj8ItgSO0ZlUtHnu0DGmGCM0hpiVODJ0zE=;
 b=i0xpgtjo2CSErNlJDtTEcYBn5XT0S74jrE2u7pUrXzwsQ3ZdJlinqZzfCl90IjPc185j00A0ER3J+bGHQSdyZLibEUlDaPmENSc7M8S6JrmveVRUELzWnN/ws3Ktk737WBA9miBxisDT1YLV0KWZZPwrPHcmFxd8BnMVMSQ1IkwOclQSuJ8G7NlDohQS2psTB8WaOq2+OoYfEurukT6IZv+IZcHCQEFGWmlFWLBhdSl5b5BHyCELtoiMhIxpd6/1G1X3leJKqmxrkkYvj3LD6pUF9wC1SsnrsX5bshxvb++cpwUwsxV2re2CNlWbtf4zODlUPjzEfaFx1Hds/oqwHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ps7fVMFtYjj8ItgSO0ZlUtHnu0DGmGCM0hpiVODJ0zE=;
 b=ML94jlZKBxJraPvTy47qy1232TMFkaHn2FQz6XOmUwbww+/jR3pNiTH26kq+5ohwq2Ml4sAJTJUPNVdbmrZdSXT2x9feF0rg9eNuSkCaFswrtDw3FsHAtIFPr47Lg+6QYUPP6dGz+1bOJXcbzH8MBlEnWLPRXZIxtU/Hy9F2MUA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4985.namprd13.prod.outlook.com (2603:10b6:510:96::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Sat, 18 Mar
 2023 09:03:50 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.036; Sat, 18 Mar 2023
 09:03:50 +0000
Date:   Sat, 18 Mar 2023 10:03:44 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 7/9] net: sunhme: Clean up mac address init
Message-ID: <ZBV+cK8YAXI15tsL@corigine.com>
References: <20230314003613.3874089-1-seanga2@gmail.com>
 <20230314003613.3874089-8-seanga2@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314003613.3874089-8-seanga2@gmail.com>
X-ClientProxiedBy: AM0PR06CA0099.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::40) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB4985:EE_
X-MS-Office365-Filtering-Correlation-Id: c83cf7df-3690-4a54-3bba-08db278fb0cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0LnwRLxC5u0yPJfQcG2la/XNTX1rFBmkzLFkm3XqametOk0ks36OHqTtIpg3boCNen7p8Y99V7bZSeh3JRTA4ZS0DIEnrgEud/FoKmXeV6EZRW71V58rmtZD0aLqRn5u3x8mM7vUbPtNlydqmSkUBw7jClpoYiVjUwh3zO127GQQKh55D9cQgpnrDXWjusfTnsURRwkOGEsEiBOMsiwr2egChutmWyeHZin50cjj55Lv40L6YfJnC2/9PC9GVvgTBV7/yg+9HOQzOmXcoiRsITB6Yf6bO9rupjW+r8tREghlgRGlQPzR7+P68+EezqLMdUCWvqwTpM+zi7qNlfuI8BCs+ds0s4VjPXnWtqefrzIus9OgDi5+0kx+BlD+DvZXKvI0ZQ1G+ntqesJmDU7dg/0NIDeEJOTAoJkqR3ymXek0yc8mCb7BK9beqzneKqKme8ls1WSdRUVd0/BjstKpEbKO1V6tj6p4XNF2SX/5+3iKhTcVbvWXGso4/tO74if5Pr9a3eLR5jOEHzzPf4vOJTjbG1wxhbt4JAV0fNatL97W4YrT1Jumpa97rMxblc2A54+lvGjrmVUI5GPzcfqu7p9GkFTJbPGRSO+DxafTBqaOoJXXgfMeEN2hdANdKTyfjw4pJPdUO2VlFEYkq72GPzRhFEoMqyoEFQg1jlsEqR8UaVg8kS2P/j/WLL2p5IUQGzlbbpeLnWcg3TvplV6bC3cVS9mXRZ8ykiK2meRvqfn2i1LeOgtx897849N3UgNQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39840400004)(366004)(376002)(396003)(346002)(451199018)(8936002)(44832011)(2616005)(5660300002)(6486002)(316002)(54906003)(83380400001)(6512007)(6506007)(86362001)(478600001)(38100700002)(2906002)(36756003)(6666004)(66556008)(66946007)(66476007)(6916009)(41300700001)(8676002)(4326008)(186003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7y4ftflrdXHkveTGHGDQnBTF+7rZqousWEug+QfULY3mjOR20Qqh9OQmQYvz?=
 =?us-ascii?Q?uDnV6svm4y1sX5BkPSC3+kCCd843KkFODcOScpUh7oKZ6aXdoMxfkBmAyd2W?=
 =?us-ascii?Q?wHyXCw0fgJtn2nhKHW1kPFvbtVgfFAF3epTelsfQYfFVGpXEXFMjjlJV5u8I?=
 =?us-ascii?Q?CpEkbSoD4n5Wvj8ykOV0QcVE+F/ZUX33pq3FgXHKilr94RRLURvV06HuAvhx?=
 =?us-ascii?Q?OX4Q1fok+Jbj1FCHW5lXCAKo1mG9jlwbmwjyJJxcyU4U8MN7TR7dzXmoxWVO?=
 =?us-ascii?Q?hEs5jwT8LwHlLUA/yrnwpCkxpKBXkEnMOrQQAVYB9IccK+eJJOEj3wWotpH0?=
 =?us-ascii?Q?WDRgOd9u0nTQOX781rWvjZ53rBnS2EvvmV4SNldkNJ4xmdnoS7ZAOE/6u89v?=
 =?us-ascii?Q?14JBlf2xwU2R2NTpdjzLifo7FuVqsTxijTwvhx+h8ATPeYgIphD1wZzSXmMM?=
 =?us-ascii?Q?owzkLVm7Zuk42dlZ23NRbGLBXweIXwFGZViJEyN1/ek+qi6fjTp8YTQoBFhE?=
 =?us-ascii?Q?jyMAQnC0NOK/bbfWlYuhQjq2IUAbi0tu1NI0QDGchHGAO+TKPAWmeCZXK9o/?=
 =?us-ascii?Q?bp28KMcaXA0FONBwAbd4ecR+Vszh5kXKWjNoQ3aokXUPyWXOZglZL/LSQ4Zr?=
 =?us-ascii?Q?zzTdyAnUfJWCEujuWS6N6StrQRiNTVWGTr1Ngb6LfkIbwGLKyu/IX2TQ6bVK?=
 =?us-ascii?Q?47XlY7oMoNi80fymiAqsMEUfwpU3DhVD/lazmThxepCn2VABL2ioBnuGKizD?=
 =?us-ascii?Q?H0vC/yhnkNdJ8Mae57P3c0YC9/20PGT9dAcouDO+Jq/0w2fG5gaMRRKkRnWV?=
 =?us-ascii?Q?bF6CtZYGazpaIFGPzmTrj7X6120k1t4/i3r7FNE5wt8t/6ueoiu4C7EV/xu4?=
 =?us-ascii?Q?WCKPFj9eEjpNDJBTKLdWSqvhhdVqMLPni/OR0Uu7CvlB73JNTcWOVOC3o86d?=
 =?us-ascii?Q?YG1hlV5u4ZGijeieUlYIJ6deWPktCgiN3Dyb5T4yCZkxbqavdguevp8SOELd?=
 =?us-ascii?Q?sxKMJvTBrbK+1tvFQ/XTh7ewWTl8e+9FLsXNf+mNiPxOM8H1lS1SIccFr5Vf?=
 =?us-ascii?Q?FwR+D/U5q+rLmpULmMMNbmciS2ZNM1xO/vuWppDbZE2a8MpEgwzF5FonQgpJ?=
 =?us-ascii?Q?AsqrGGpQ/fVhkTwC9kfxtSmnWV0E0eBw7Snd3z7OqoHle6IyIklWR0d0Tl12?=
 =?us-ascii?Q?O4N011qNO9CLezsMJ3qfaMNW1qM5CeXedr1xqnE7rCoKxysoiid9J5vd5tyW?=
 =?us-ascii?Q?EqCZ0/ai7qQjHls2wz9tiWPrO7eaQqPrimxjW0A9uLIKKx/SULArlA9sk1eZ?=
 =?us-ascii?Q?o/BOu7NhjaThSL1Vs4/lcs/CUS3ZpPoHGapDVfVTEDGzM+1y5hv6q+2bXQ0e?=
 =?us-ascii?Q?BQmzmaVpt2F+K4CDi+OKQ0IdKTEyp8CdCTIczeZ7aIHQqYPLUb2AVCnGB4Oo?=
 =?us-ascii?Q?AIajYZIm7fPl63NKhPXAgYw6FFCWAidIdk8xydk1NG+2UFvu8jgaxH+3FKly?=
 =?us-ascii?Q?lW1uHE1IqfiVntOP9k06hyZ74VtqJD5fwQARh0bJCZIcfj7vYf1oVXOi8INQ?=
 =?us-ascii?Q?KCNezWAWHLWIuw9YAUR/wfSiMftPq34P1TtGxxV138N/eOiNGMnS3bsUoIVF?=
 =?us-ascii?Q?b+UY0xwrVlcjf98HBxYlh210c9MuS20+ZkutHRc/Pgfr/RhQzEB2eiBHQYEn?=
 =?us-ascii?Q?50DMDg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c83cf7df-3690-4a54-3bba-08db278fb0cc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2023 09:03:50.4444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cMIm42XBbCzAlKn867IRrTy2r8hv2yGkout3YlKog1HKVw0XcIqzseUXpQIvmVID79zsTf7DB2Z7LvzvaAc5m6mkMONfWOzC58B9eOpP7ZQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4985
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 08:36:11PM -0400, Sean Anderson wrote:
> Clean up some oddities suggested during review.
> 
> Signed-off-by: Sean Anderson <seanga2@gmail.com>
> ---
> 
> (no changes since v2)
> 
> Changes in v2:
> - New
> 
>  drivers/net/ethernet/sun/sunhme.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
> index c2737f26afbe..1f27e99abf17 100644
> --- a/drivers/net/ethernet/sun/sunhme.c
> +++ b/drivers/net/ethernet/sun/sunhme.c
> @@ -2348,9 +2348,7 @@ static int find_eth_addr_in_vpd(void __iomem *rom_base, int len, int index, unsi
>  		p += 6;
>  
>  		if (index == 0) {
> -			int i;
> -
> -			for (i = 0; i < 6; i++)
> +			for (int i = 0; i < 6; i++)
>  				dev_addr[i] = readb(p + i);
>  			return 1;
>  		}
> @@ -2362,9 +2360,10 @@ static int find_eth_addr_in_vpd(void __iomem *rom_base, int len, int index, unsi
>  static void __maybe_unused get_hme_mac_nonsparc(struct pci_dev *pdev,
>  						unsigned char *dev_addr)
>  {
> +	void __iomem *p;
>  	size_t size;
> -	void __iomem *p = pci_map_rom(pdev, &size);
>  
> +	p = pci_map_rom(pdev, &size);
>  	if (p) {
>  		int index = 0;
>  		int found;
> @@ -2386,7 +2385,7 @@ static void __maybe_unused get_hme_mac_nonsparc(struct pci_dev *pdev,
>  	dev_addr[2] = 0x20;
>  	get_random_bytes(&dev_addr[3], 3);
>  }
> -#endif /* !(CONFIG_SPARC) */
> +#endif

Hi Sean,

I think this problem was added by patch 6/9,
so perhaps best to squash it into that patch.

Actually, I'd squash all these changes into 6/9.
But I don't feel strongly about it.

So in any case,

Reviewed-by: Simon Horman <simon.horman@corigine.com>

I will pause my review here (again!) because I need to go to a football match.
