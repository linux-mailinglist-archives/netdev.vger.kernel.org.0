Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71AEC51D6A5
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 13:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391343AbiEFLbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 07:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391342AbiEFLbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 07:31:34 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2134.outbound.protection.outlook.com [40.107.93.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B6E1CFFA
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 04:27:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QhiGgvq8JPvukqCdA2jxOcJJj19pSAC0xprOGpbq2HcTj5yP+dtiay3ZpfDR5SLSbt0tzcylAVjcWmfJnwS4vmHcQ7UzrNl06yFC4RsFHxPmkEipT3Yo46y8eu6ovuQ/dyxFSlo/ACLlKZbHHTUuUOMgvqb1q0ngydJv726z7Dt3ShLnvqn/ir1X+jVJLHDyJ/kcKOP2vR1Uc+CzWz7TsH1UdYjt+xD+/p7JS8ANhYp32YvIuq925YWyCj1ApHkWrxrAmp57Lkk55bZgCYoYR2o6ys6QPOKtnRFlz4iUzNIfdsPz6qHCI0al2eesgv5HMioMCZ2iAUz9NoxE0HDH4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TehFEHxeCF+vME3dMCpwjYwdXGY84EyH4A5XhHqecPU=;
 b=EQmasGyyhOkD4tvTv+VttKjHM6p+MggvW8e/AB/dxMaUZw++J9MkWcry1CCOSoRSL9EmkWg367m6t4TgBNBHXoN2t/32xJcd5gYvXepdL16FTlZfmWrmFBjYccP5XWW6b0cixQAlOZysEyGg9K9AY/zz99irLUyFjCcwzTuvsAu1ljCBZc2Xv1zc3vkrc41uze4xF4bhrqJWZsP9Ic8ZDimwBuu+YXrVhtEA8BLl2a3CzoFM8UhXPhRYwr4vrB9qjqTGBo4l/CDZ55omRfq6Pp8/zkEQCtU5jtIEmE8UJSO2LMO8cDMzEi6NbCmsCiExj9BHjLl1Mw41OO8wl2tyrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TehFEHxeCF+vME3dMCpwjYwdXGY84EyH4A5XhHqecPU=;
 b=UYexdVIKJgySFGUocRWA6V5oYilYe5ek/PVQhATRFif47uXoDbf8y7Ox7dnCZBsrn0ewfnbbvllhAkd1bU5d5FRe80etXghR5HP2fnnMXIyinso4MoNHyBmpVBu8yQt/u/MlHBfVOZQCJhnDAyNj8mhybRxbbmvJH3WmHeSCpCw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN6PR13MB1201.namprd13.prod.outlook.com (2603:10b6:404:1f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.18; Fri, 6 May
 2022 11:27:46 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94%3]) with mapi id 15.20.5227.006; Fri, 6 May 2022
 11:27:46 +0000
Date:   Fri, 6 May 2022 20:27:38 +0900
From:   Simon Horman <simon.horman@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, alexander.duyck@gmail.com,
        stephen@networkplumber.org, gustavoars@kernel.org,
        roopa@nvidia.com, keescook@chromium.org,
        william.xuanziyang@huawei.com, lucien.xin@gmail.com,
        oss-drivers@corigine.com
Subject: Re: [PATCH net-next 1/4] net: add netif_inherit_tso_max()
Message-ID: <YnUGKkx0cCi9c06M@corigine.com>
References: <20220506025134.794537-1-kuba@kernel.org>
 <20220506025134.794537-2-kuba@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506025134.794537-2-kuba@kernel.org>
X-ClientProxiedBy: OS2PR01CA0130.jpnprd01.prod.outlook.com (2603:1096:602::24)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ab7847f1-b267-4195-88d0-08da2f5371ae
X-MS-TrafficTypeDiagnostic: BN6PR13MB1201:EE_
X-Microsoft-Antispam-PRVS: <BN6PR13MB1201E71AE9D78A5A1D197CD9E8C59@BN6PR13MB1201.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b8kVowuvv4FpaR5as8LQV0zfXMLdTgEdWzd0UshR47Zl9hBUVBPt5nDLHEeC3cA8EAKITee4bNBO0eg3xz68XDXHxUPYc5nMiHN5Qz3ElnKowlEg+QE6/PcOv2XwV+TwQgDsH6biuAuU0ktN2gjXk2qpz7UNwRJLvTRlWmP9xAXB9o6amq74L+5awxxv8t5yJFPacSGDDR7oFTm4H5Ue4QxBqJcY+ox64Q4foHQMvoNvO/v+18xVfpEbz4x7t3pkoFsa9A6vcbAdrhoby2em2RSsg0r/4ulI5+vWtnGiEPbM7Zi/BDMEXca6Z5s/FOorp10qHMF/QS34wqj8j2r2YJR+lrEpM0zMVBNaR+CsyshZFRaJWHlYywdvauUBmtUe9K8YoZvcF9C07aGRtkm2Da8pKGCDgb9MM72PE4IoyiYW/JVg7wiP/CtNH6lJbrPBZr3ZbEmnrsFtxx0VpsuJU4miiuggu1erB+dn9+KlkLb+XFpMj2ThrhqIzAde58V7GgfRI8FrEjbr6u4jgmSsZuRyRwrWkzEtE1bD2vhwmwpJMNPQNX/UQim6AEa4SizryPSPL/SeJ6p3YTdt27Ehht1hzL+kGa1HHswDFF76iJxqRTZyLj3t6zpctr6gq3u+NBUXb8//8KWzLlt5qIG9BTUnBA7oN4dLXOZuhSHOfMWcBjJ8CDpcQA80QweL/yk2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(366004)(346002)(39830400003)(396003)(376002)(86362001)(2616005)(5660300002)(6512007)(38100700002)(8936002)(6666004)(52116002)(44832011)(7416002)(2906002)(6486002)(6506007)(508600001)(316002)(36756003)(107886003)(186003)(83380400001)(66946007)(6916009)(8676002)(66556008)(66476007)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?v9iOb7HcQM6LhaUIPC7HpfUs2nbkCyOWyF+YOzl7y4gdLGKVzrCJbnE4sC0g?=
 =?us-ascii?Q?MUckVBr+IETCEBjbk6dUtl4zvpovVNd8LlBPvMXkMNIeYN+Lj3BQMaNSoFP3?=
 =?us-ascii?Q?s+NHYq1O4NAdHPF/2jM0oEZfZk4SFFbTpUjlO1ggsiHqLMksS+LcNm1rgEfE?=
 =?us-ascii?Q?wOsmn5dwV/fMkTfhcu+t4M5Jm2TWxyTX+eGryFEmDCvFm50GRY2kZGNEEbHc?=
 =?us-ascii?Q?Ok9xti2g/UD23Vv1UnPIWBMp4f6/Gu+Ov3vBh4dWMqXk8waFnG/SzxwOvMoP?=
 =?us-ascii?Q?OE/A2saYCzHjo93CE1XUYS2zybZo7TGTVg5Q4xqxu/hKnVayp91PvQ7zfny8?=
 =?us-ascii?Q?6ymCQHbeuheqLZd8I4iD7MVxCSTQVEc5sQBDtmzUdFl1cHAQ6Iudmhv3abaW?=
 =?us-ascii?Q?B/m4LunRwH4BKeWu1da6oiZ3jmWQPwXPctGGoF6VD1X3rJOykd8NfAG8kWH8?=
 =?us-ascii?Q?U/TZRfdlmZ5nn85QWvO0qP70BWU99pI8W/jJEQasYI1z4Oh19PV0yiKwOwHX?=
 =?us-ascii?Q?RzN4bZFZyk09kt59b9cEifNEFZkUOjT1elbvEkYBwWxUyRSBBVlMWWP45QdS?=
 =?us-ascii?Q?i83VkXt6GJzQ99kz42hYrKW6rFtE3NxgiXifYnOVkdGk2vbtMhASkFpQZHEw?=
 =?us-ascii?Q?4yOvpqxGUc6iGQIGJHrW7yRJ77vwt6YFsBVCaMJ/hFs/72kozQSgy3iT4+wn?=
 =?us-ascii?Q?lkz5o/s+LDxYMEcXm2uFFJXPjAUaXEfrBXAo8H9/YrM3YmvLIz3HNc+vpoJm?=
 =?us-ascii?Q?F7fncphWAxfxCqq0g9t+vvaLoSYh/faIs1fjlM+Y/8q9iZqqkJqTbPEgTpgo?=
 =?us-ascii?Q?QN+wbd7qOGe8e8GCEIgbx8zBh6cbXLZZnvvQV4rDHmNlcbiBk/s68z8IvCLY?=
 =?us-ascii?Q?1l4nxtCwPvr8UFizJPCiSlMQWpNhr1DwT0Nx9et6LOG0/FY0aDdDcO5Z6p0g?=
 =?us-ascii?Q?u4WHazEltF4aquNaO8ViSQ6a5iHilSWnA1IQCfllf7NzcVESRXSJUyePWmd4?=
 =?us-ascii?Q?Ud8V3vYBNyUOuZDr6VmGc18pSIOMYro47wHDJarCG0exyLarpNnpToX1qOus?=
 =?us-ascii?Q?0NxMxZOSQ46qFqpcpGx34SNtODNxf9RS0kh1DPL5nGVkLhheCDKbAIrDtHsM?=
 =?us-ascii?Q?dhIg9PL7bi+OxWAiZlbMiECE5M2EVYELhf8gAYbuOtqkkiCwkNGibQi5jkPS?=
 =?us-ascii?Q?O+MeejTjZkJm0fGILNApJvnIx4nu52f4DobyElFuAMuvgfSLdBeFID36N11F?=
 =?us-ascii?Q?6/eAXV4sBCd0UZqiFIUk0BoxxHfd7GAISrNCWjWc5iI2hDBn8sy3frYulCrN?=
 =?us-ascii?Q?QVRMpEhXuKEOlGeFywbx/+/jtTNh7AyMzlbdR7kOu+euDRY0CFqK80v7ZXPX?=
 =?us-ascii?Q?mPwIj9CjC5fGXO5Tl1kLTip3P4jbQdW8tt3uB7R+CNi4UxYvY+uBoW5yd0Wm?=
 =?us-ascii?Q?GlGyim4Au4MLSRLqdy/dyClo++1nht2kFPP52j3bktEh1+70GMVK/Q6JvzK9?=
 =?us-ascii?Q?ntirv8TuGKuOa3myt9SnO8M2uDFZ1c9CSPJY5kkB46CCDEp0+ZsG9lTWJRUN?=
 =?us-ascii?Q?LUYDTEaAJApRXmrfsLbAJ47zVGL9vaypSJEDLn6e0b7c/EPq1EH+9zTK2Ubd?=
 =?us-ascii?Q?n+YNutj7mR8cXGaV8VNt3dVz7ODUceFcc9Gn0KQCxJtmViOots2YYCgyNCxG?=
 =?us-ascii?Q?J6Z36YaVJEbpXX3TwR+lNLiwHQG1jxASYy19IZKR94sSUmoTjUynVfl7xkyx?=
 =?us-ascii?Q?dHSd0Zq7wvdMaqcL5EUpiw8iF1+Y67oLg6eocoaSjTYk5QEWpPAim3cfGPpV?=
X-MS-Exchange-AntiSpam-MessageData-1: DSzWAbWX9vRpsQnPEk9/iHFJOIK4GYbqscs=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab7847f1-b267-4195-88d0-08da2f5371ae
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2022 11:27:46.4119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w9n76/FBGK+RJS/FIiIl5XIBstk+VZqZz2AFBbD1z5aB2OxkTszuOsyFF5KgRYduXqY1w+IdO5nP8NkvApxRr3gIEnipO0uh+vsltgnigBM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR13MB1201
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 05, 2022 at 07:51:31PM -0700, Jakub Kicinski wrote:
> To make later patches smaller create a helper for inheriting
> the TSO limitations of a lower device. The TSO in the name
> is not an accident, subsequent patches will replace GSO
> with TSO in more names.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: simon.horman@corigine.com
> CC: gustavoars@kernel.org
> CC: roopa@nvidia.com
> CC: keescook@chromium.org
> CC: william.xuanziyang@huawei.com
> CC: lucien.xin@gmail.com
> CC: oss-drivers@corigine.com
> ---
>  drivers/net/ethernet/netronome/nfp/nfp_net_repr.c |  3 +--
>  drivers/net/ipvlan/ipvlan_main.c                  |  6 ++----
>  drivers/net/macvlan.c                             |  6 ++----
>  drivers/net/veth.c                                |  3 +--
>  drivers/net/vxlan/vxlan_core.c                    |  3 +--
>  include/linux/netdevice.h                         |  3 +++
>  net/8021q/vlan.c                                  |  3 +--
>  net/8021q/vlan_dev.c                              |  3 +--
>  net/core/dev.c                                    | 12 ++++++++++++
>  9 files changed, 24 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
> index ba3fa7eac98d..790e1d5e4b4a 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
> @@ -286,8 +286,7 @@ nfp_repr_transfer_features(struct net_device *netdev, struct net_device *lower)
>  	if (repr->dst->u.port_info.lower_dev != lower)
>  		return;
>  
> -	netif_set_gso_max_size(netdev, lower->gso_max_size);
> -	netif_set_gso_max_segs(netdev, lower->gso_max_segs);
> +	netif_inherit_tso_max(netdev, lower);
>  
>  	netdev_update_features(netdev);
>  }

NFP portion:

Reviewed-by: Simon Horman <simon.horman@corigine.com>

...
