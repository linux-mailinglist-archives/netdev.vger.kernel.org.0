Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C95B6ECC72
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 15:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbjDXNBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 09:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjDXNB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 09:01:28 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2129.outbound.protection.outlook.com [40.107.220.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64113A93;
        Mon, 24 Apr 2023 06:01:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kEXjhPXBL+KP0VKM7TWjdD14c0NyIlTPUDZDyuyJpwGuSBfdo1H7as5yJQyVAlTrrL+M6Ees+Mrur5gA65CRq+af4NHzpC5KdzClNOdP0DORzRsswTuDqmGh0iac2Q7GrSG9wFfWTQIkWeZcZodqzN41y5c5LRvWtFHyua1e79YajqI/BwxhNJsRHOyIo/gm4lv7uB2TSdAs6XdzT7hpdp5E9MZ9XRGwlZ0aXedTSXUNDS1Qju4yHwKgJSlMFAqlPvnNR1Bypl1wUfd/nCyo3AEYwP2H0G7A2TeY6OjK7RlRmrpH9KsIkgPyM5Ri4zZf+MS19dd67zGnIWpOhJT95Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5PfgxoQHSujAIb4/eMtoedgS9OUlbEFxT5jc++9hQ0s=;
 b=TgibQGcceX5mdcs/gfWHI9vwYLeablyOIKCu6zymzARPyEsmxiHIfRH0YgVJtgSmX6PB5iybgW2xbKMHVOZmhJpd7i4QXFNgRQ3qgiJmvYkjFUdvszZmwynaVZ+hxyotQQk95Wgbvg8qgR16lW/5lzimUCTl8ibdQGkIQDODFQ4r8NaR2dsq6HG1Q5qW/Syt46cGpSPasVjjIC0YLGEAKAx+rKe70j98wmCBfd+xtfhpHlHZLBDkWLkbelc4FYxNB+s1T/muknGm//5FdsZwE7zJH7icVnoqbhQLKxMSVn4kmkMcXnmT/P9tOF+2+uoG4Bvs3ODddBLzfp34ffIDUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5PfgxoQHSujAIb4/eMtoedgS9OUlbEFxT5jc++9hQ0s=;
 b=FMjP7TffKnhsfvrYi248luYzsbrLlVCdDp5xeHO7et/ThAdvqyZnpU7eLgwitOPQEGZvARk28JqRrMVPG7ETmQN6Y+7Xj8ekFZvmSWoKEI0gioOhTe7JJpvzrUVOH71wiS+j2hLyY95mLUOngTIBCWXyveWx5Ll27VP8SF8lF7M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5753.namprd13.prod.outlook.com (2603:10b6:a03:40c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Mon, 24 Apr
 2023 13:01:22 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6319.033; Mon, 24 Apr 2023
 13:01:22 +0000
Date:   Mon, 24 Apr 2023 15:01:15 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Gencen Gan <gangecen@hust.edu.cn>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        hust-os-kernel-patches@googlegroups.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] net: amd: Fix link leak when verifying config failed
Message-ID: <ZEZ9m4Q7qO0UTx1B@corigine.com>
References: <20230424104643.182296-1-gangecen@hust.edu.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424104643.182296-1-gangecen@hust.edu.cn>
X-ClientProxiedBy: AM0PR04CA0047.eurprd04.prod.outlook.com
 (2603:10a6:208:1::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5753:EE_
X-MS-Office365-Filtering-Correlation-Id: 609d9b2f-2785-4e77-9137-08db44c40087
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jWNtR/X+zqynv3Xgbq2NesoJRbh1m/kTzUoyOs0j2sG3AlPhFBMxTmNxJsFYzfm9Tz6GMaxGMQurhZBWul9KCTPT2EaG4EppWrDcqBNXBiRdTBOC7WsPMqPbYDbA7iDcQOv0gaJXZoNaN0SO/Fpy10ZDvnZq/rk5R2HmMdoZj9yNe8zkJw1LyCj+Gs03NtstHL6XTuq/WUhO3NMrt1oSi4jFk52SFW9jSv4iNUPr1PZ4rue1eP5+nH4sEEifgNDEv2ssjYVQp4/5LoxjAuJ+weRExblboiJ1UyBO+c7eRMzm2g/5tfZjNj7Fr9mQX+eokIDh3XF8Bqndw0UUulB2RSgtdikhDF1mmaum4wHliUOUnyR3mo9k+r7i50ueUToYLfKvAJynRvivo/s6nMagd9mQRBGTwnxgSiY538n1/md+fm0GuKbWDaDT9XK1/8YOtviUp8IMFoYSXeorCut3BOdnRTsvnrE6JeZX//xDMB8LILgETLF/A/KDQczG+2O4jOkvJxW/6BvQqzn8ZMhERODtrRul5tMAtVCE2kqcDRCmtAhx5qEVGusPLlhBFsCLWsbdZ4sazGtEmD36Uj+JeKrvTw8GRVAEtJDC3G1U4Rs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(366004)(346002)(39840400004)(396003)(451199021)(6486002)(6666004)(54906003)(8936002)(8676002)(5660300002)(44832011)(2906002)(86362001)(36756003)(15650500001)(66556008)(66946007)(66476007)(6916009)(4326008)(478600001)(38100700002)(41300700001)(316002)(83380400001)(2616005)(6506007)(6512007)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bc5bGmE7b9SNdqZxZeJHoWbD9WiACUi5VLmxcMyakPmOMHVcdkPoUQ0sbLog?=
 =?us-ascii?Q?U+3CGOyjjQ6KS6woOiwWWhrsXd1i+Z5iZNIp/2ZneE1JVyit9+RaaDHE/qTl?=
 =?us-ascii?Q?tNifAKcTo8mkoOsrSsgHUdprfzF0OLZboEYnX+bPahk2YAJKaNj8YPjSGi3w?=
 =?us-ascii?Q?DXvPmxsii6GTnOZ30xP0AaTUJNr2dZdFs/KEjW2W+we+hp0v44ANZ8uiEJQ1?=
 =?us-ascii?Q?AUVh1Qik/JheFdvbwopnY026QM/s/or1HJY9IlPRistXH5OAB51QdMApifyb?=
 =?us-ascii?Q?9bwPM0Qv/RSz9K6Qq2vRagYOfELXRKBsM3CIqp7IUmdZH/XQFFCBn5R4r+aE?=
 =?us-ascii?Q?xu2zSrXsD+qR+HW3PM2C9TJdq3X5Eh5JMEq1U+BCTCgeO/3wRmAw80SLnfON?=
 =?us-ascii?Q?DvFZPjTsVFlg4B1gJrqWHCdw5BaSyTw551tS9ZzdOkzf6h7CRhaDyerYK8Un?=
 =?us-ascii?Q?1FfbYBGQNTVADTrpjiqve5ytW3VlgN50gXy7dpkkVhuNeHIZEjBFatVOLcOL?=
 =?us-ascii?Q?8EVJhGOVSnaSu6alam42SAOtCvTF/LoHkYsTszMxzOsImQXLp1nWHGGmzz+8?=
 =?us-ascii?Q?njHXFk7UUYDXeFzGFH7Nt3S+kOfBxdKuvXoKtWy+Vev1lZ5iuJhXisvS2rfl?=
 =?us-ascii?Q?PnwLp9BdChWU1NR6ucbxTA/BZczIie90wRcyO3DpKsvYFd8wUQ/agHhrE4Wc?=
 =?us-ascii?Q?cKNzJCzqx1bWEMgT/F1T+mB3p/IQsG4aqivxg4y0D/rseFLqG61fe2666eb9?=
 =?us-ascii?Q?VWOXbxzE8PUfxWCsGJ1B1h+UvZuRNHIL5EZnj5VGyuimuCN5AbE80+mV3T0y?=
 =?us-ascii?Q?bxRK0RqJ91WsD4vtSiTJrDi89GJhXNqeiYYYwB1UTIDmajNJSKTaGKgor2ar?=
 =?us-ascii?Q?t1WynTbDjK8Tc/1veNGcwIX/3dCWIWbElI88w7zNdPt6vd5rFhUx0r/83RFi?=
 =?us-ascii?Q?Z7myjIfRZwM0WPyAcYMRubaaa/byCutZWBojx+2RmxZaRGGA+xufA0cmzmIy?=
 =?us-ascii?Q?LGvw9VRacTCnD7KNnrSOCc43iQEqNjyGNbyF1C2e8YCY9xGHhJXexci6uUhC?=
 =?us-ascii?Q?iSuZznlwMrf94ijUoWf3z/qq1kkSBVSP8bcyNKUn2OB8i6dImtm0sD9Z7vbA?=
 =?us-ascii?Q?C3/E79VPGah9YmKjnZEj8j6Ks4jdbnI6wxBJcQfS5+8P0NxBrlsaxDI9PyE7?=
 =?us-ascii?Q?H5Ds8U8xjoMRG5HSRYIsR/REaT8U0UXV3zuFhbhG/iKTy+FU2MjpFQgRd5Sn?=
 =?us-ascii?Q?rat4jMZYuvE+/zjjLD5AjNG1m3Isk1JaIS4gvlcwcQb4TU1fzayua2B/IkAi?=
 =?us-ascii?Q?RHOzecSGyi4gZwHPa6kwYwXoKYgsVlv96OI0gfeiudnzHNGCExxpbNez8/7M?=
 =?us-ascii?Q?XPVZ00W/s19588r28r3n48R8BuzPHs8X+bOl1mx5R5l1jVCL14KaX1aCXUeX?=
 =?us-ascii?Q?EsnTgmdUZ1RQMkWtkKW+CR8Qlj79RukA1+fKPR/PkRZNg7TImUXrGkVu+6Bf?=
 =?us-ascii?Q?aLRBFdV/mMVHMhljc4l2gMwMKbqVlPxWj4u6BO4mdDJNdLpNil0jOy9khOOC?=
 =?us-ascii?Q?yfcH/tmLl5fsdxg+yvF1UczUKQUG8PaUgzUgDnvbGoNoGh2XG/f7VPXQ2HoV?=
 =?us-ascii?Q?+ZyfHQMtO7Ysqqf+oySPxFVwLp4rrXWmFx1X54N2kSRviHheSp9i1+2lzgwU?=
 =?us-ascii?Q?/2SNNw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 609d9b2f-2785-4e77-9137-08db44c40087
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 13:01:21.9302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2gkRpOWGruNR5EbHJRW/J/Cp6zBUaHxssoXzR2c4zIwJwp4F3BHgcppg1yjOOAvsieR47ptSu7CMa8cwmhTF7XATeyekneSMhSYtDaKptfE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5753
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 06:46:43PM +0800, Gencen Gan wrote:
> After failing to verify configuration, it returns directly without
> releasing link, which may cause memory leak.
> 
> Paolo Abeni thinks that the whole code of this driver is quite 
> "suboptimal" and looks unmainatained since at least ~15y, so he 
> suggests that we could simply remove the whole driver, please 
> take it into consideration.
> 
> Simon Horman suggests that the fix label should be set to 
> "Linux-2.6.12-rc2" considering that the problem has existed
> since the driver was introduced and the commit above doesn't
> seem to exist in net/net-next.
> 
> Fixes: 99c3b0265649 ("Linux-2.6.12-rc2")

Unless I'm mistaken, this should be:

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

> Signed-off-by: Gan Gecen <gangecen@hust.edu.cn>
> Reviewed-by: Paolo Abeni <pabeni@redhat.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

I think that tags such as Reviewed-by need to be given explicitly.
And as the above two Reviewed-by tags were not, so it is a bit
odd for them to appear above.

> ---
> v3->v4: modify the 'Fixes:' tag to make it more accurate.
>  drivers/net/ethernet/amd/nmclan_cs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/amd/nmclan_cs.c b/drivers/net/ethernet/amd/nmclan_cs.c
> index 823a329a921f..0dd391c84c13 100644
> --- a/drivers/net/ethernet/amd/nmclan_cs.c
> +++ b/drivers/net/ethernet/amd/nmclan_cs.c
> @@ -651,7 +651,7 @@ static int nmclan_config(struct pcmcia_device *link)
>      } else {
>        pr_notice("mace id not found: %x %x should be 0x40 0x?9\n",
>  		sig[0], sig[1]);
> -      return -ENODEV;
> +      goto failed;
>      }
>    }
>  
> -- 
> 2.34.1
> 
