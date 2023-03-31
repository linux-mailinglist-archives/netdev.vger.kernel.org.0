Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 271D96D2440
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 17:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233239AbjCaPoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 11:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232520AbjCaPoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 11:44:12 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2117.outbound.protection.outlook.com [40.107.243.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 249516A62;
        Fri, 31 Mar 2023 08:44:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XC7U5NvRYRdWAsAgIlTLy3BtNPW+j8vgpvVZk3ROTaTpsDsEa3nydFdwvdV9sQp3zofT09kgAZSwWk7FGqYlcQudqeElIpnwXwrwYmfYfl/riBfdUJF2FKMUHM1lOd1waKa6zJ3QLqZmyGjmOk9IDnY6kPSNhFiw4Etoy6R6germl1RLBgdGA6fJ/8xRz5Z4nqTj8zhrNO9fB29Zv89xWxAqKgL//EigavLZ8Eg5aDlY25LlUo2UmiZegEea++WuDs/No0XnXwxQBXnHwON6bTEsehyN5S56uE7zJHvMsXlD8M789qNty85Tbdeto8unmgsrUgJmaxda7ZusB/e0sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DiUlDLyBbY3j5gSEGGUbSxYFWAM+EVb0Q8mZcfckYfc=;
 b=lyBE+4+Vp8+0s5FAVveZgrUNWvFUah8ZmxhwvyM4DlAJ3L4u0k6/6oOnqyFoMRgLMQg8vTXEKRbfy9pUWXIbwLTDIVsOpWcIuGnMJ0AUyLhGkpsnRnnBcZRFlW8azSSG2VgrvBwVxPab1qG6a1kCU+vvcXwwT41djLtBiJ3hCoGiZDPdrDFcNfai16gfvuxMDQrvnpCO8a+omWMQAjcoUg2WeoP++Mm69LIeZOMEbQIPkq8XvVAQ1ZM+SUAHtE4AuJeCNPaEQ9e4wkjSP1JWKTRXn1yrYEt2i+l2o7NDw7pxx8P8WjMZ9448papzJ2ghbCCBCPXf/0KoN1fFJeScBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DiUlDLyBbY3j5gSEGGUbSxYFWAM+EVb0Q8mZcfckYfc=;
 b=F78Qk4VYdgAQRWTfLEccrH2deIx5+n0CL63sO9NHbjT2di6TlUOIa9T2uRWj2ZTFdFu2TlKhP0Bo1umMkj2Bb2zzNJjV4WLRGvDWvRVsBJ3IK69N/nUVIWxg426DtXFec6L4i2Y9kV+Bj4slXSHgK5Rwp4FFdBgd6iC3356Dxzo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5534.namprd13.prod.outlook.com (2603:10b6:303:195::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.24; Fri, 31 Mar
 2023 15:44:06 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.021; Fri, 31 Mar 2023
 15:44:06 +0000
Date:   Fri, 31 Mar 2023 17:44:00 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, saeedm@nvidia.com, leon@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH net-next] net/mlx5e: Remove NULL check before dev_{put,
 hold}
Message-ID: <ZCb/wM+2Bz7HvFxl@corigine.com>
References: <20230331005718.50060-1-yang.lee@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230331005718.50060-1-yang.lee@linux.alibaba.com>
Organisation: Horms Solutions BV
X-ClientProxiedBy: AM0PR01CA0173.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::42) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5534:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b136985-baac-48db-3673-08db31fec28f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6Va7jlkL+v+vQffQjxMtiYTdWLhgou0NLoUE/GnqfbeAnAuhpplZpDzCrVzn4H2Y1k7U+2H1yjXkG1KuSn10FXZUOu4b53pIk0PvoDRNFAPqGhpybU37mwgNcqerMtjXhPHDf7O/Ls4wcssv4V1/rYibkDssug7R/012UzPWmgAtvDblLZ7dTlu3paOSNgQCvzG23d4Yws0K9OpNjkK5tJqbEq+Jkc+bsjBKc3sJlkcayTT/rkaSeyVlKwOtU2ocSCcl2Km8Un6QYbatUkV4C7xDHM7Rq2Pxl6+YNS7pHkGI5ra6Zpa8D2v5Pu8fOlEELEMHv6gsEnrKVELpH5l3WpI+rCqWSetiN0Yw3IOWJukZ+d0FK01Dr2ZdFQ6VJA5j0eV3EEsNKkx2g+0Gm8OhUx0SyyZyOtHe3GQxDnU3P8ZrztGsz0g7KWL6flNEHwM42g3kizr/UGHM/R7MDPwNKzBHmbsblx6kCshPEN6zjleuGeIjhubJQv5zk7n7el4YP7VFa0IF5m8NRIAbHqtfyFtPlyKGXa3Sut1YpfFXe4g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(376002)(366004)(39840400004)(396003)(451199021)(6666004)(6916009)(8676002)(4326008)(316002)(6486002)(66946007)(966005)(66556008)(66476007)(36756003)(6512007)(2616005)(38100700002)(186003)(83380400001)(5660300002)(8936002)(41300700001)(478600001)(86362001)(2906002)(7416002)(6506007)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1Anta3QtgAGlhsdiUyT6MkIWMcoWE69+QtzPLzJnULWjMSf2gCNyTh3hY6BJ?=
 =?us-ascii?Q?ZOzPMDOTaWmczhcXv/G109XuLfyYdYHba9MW3EXLOkNMwkrRpzyfPent2iXN?=
 =?us-ascii?Q?Oxq4bCURsdheLyoy7U2r/1tDWcdT2nqPYYiEVJu0zII9W3VX3j83p1OaTOb2?=
 =?us-ascii?Q?kxGjr0GRAMZ4QI9mf4vJM35y+v+yMBT5wdZZXnorUB5dc/LIxnEIU4oyiHDq?=
 =?us-ascii?Q?Chm124tW9+pbJnb0mFwyyOiw0QJJ/5etz4IPCh1rYsoU3w1pH1ngVvfogLuo?=
 =?us-ascii?Q?/sj15l78Y3gGQjztGOVON+Ui7YfH0kwxfeNzFAhJh4yCGr3wyQA3jgCQuTRN?=
 =?us-ascii?Q?80AkYRNp1WMpbx0hBP9geUbmJPfB4+EQmFl64v074K6wgMf8GZA7X4+r/vI9?=
 =?us-ascii?Q?S1fUo+tr22NgGMnjvj9ZbsEgfBrpY0HWUQt7xsRqPTKkDO2AWAc9KJRceK48?=
 =?us-ascii?Q?hQnWSZUsPrS4xaMvKWiUjELixunkL8ZsJJY/Qb74l/XttVyfcnH9ZpKX9EyI?=
 =?us-ascii?Q?VKXQFtztTnqp2EAnPwREz9LDwo0uHllyIyFloHKu2ptcATUxuYWpKlHKFz0L?=
 =?us-ascii?Q?MTjW3KZ99HV/xE3i5lWg1eUhtFNSWNXX9f471Y8vCskGfMgX6ebZxCpsLu/+?=
 =?us-ascii?Q?VAoh13uGjsjbsvhcYjvTJKVrKCwbnr4b7N5HYi38D+1Gyf+NObg6471KQYNV?=
 =?us-ascii?Q?goIx6XRDovqc+g/trds1+D2qMUUirLLqE300z5WFoaB/IqiJKNNIMB9VecaZ?=
 =?us-ascii?Q?xN+a4F4dx2OYoDGaEeP71D51wp/K3cmDtFQV+gG5lrYXO1Na1cJminjqf/Uh?=
 =?us-ascii?Q?+oWboYLtEhUhg/x1/faeuvlhmsGGay6SpDf0ETwjnBfe1cgnXt+n8JuaJPfM?=
 =?us-ascii?Q?lfYsXBq7CRlHXl7BQ9Fbojm2xgfCWpKYfasY7GH1y0nk1WFAB1AeI48wSNMM?=
 =?us-ascii?Q?WGjiVrSBsJS3/P9SQchHzFPooTDQIDmhCRM+YhN/l9UGd5rJKAubkEu5TCFm?=
 =?us-ascii?Q?9kaXu0A/I13src4apdzMFybM2nAtl94E/oNtdovm+NE0MF222qLGyrH3141z?=
 =?us-ascii?Q?ktSlXG1eFjA561VZQhNIUZfAhLz2fuPlxo9Pbv1RZW31k2PubJkKAHM9ugDQ?=
 =?us-ascii?Q?7JfkSozgMvHLXLJGE9UHoM6lvgQ3MzMJgC/ScuY3JMQYT28Dku6fuF6P+EfU?=
 =?us-ascii?Q?037KRsj1cnqrLDmydrXyAq5aWuDcGNw70Rc0oJDTV2kTRWYY0d2flXhjN7bK?=
 =?us-ascii?Q?AOIARE2WnMrC3YucGmdT7buDLPk0K5RqnzfRGB6F34v5rmlIaVSRMoRm6mJv?=
 =?us-ascii?Q?X5MWsk46gGRmxRyxyRqmCw06VFe4k8/X6cEsGA5R77rQqf5JeN6WrZ9mWBTM?=
 =?us-ascii?Q?srpza7+OoXjRcP+O1f32jqw9npjez1G5nkgED9ocza52Lb7/EokjdhIKI0Sa?=
 =?us-ascii?Q?+ZQTKoi7W9ULo8iJPKR86ol2CB4+TD5daqkou9jwd0c/sOVf0Atk/++/uJCV?=
 =?us-ascii?Q?FNxrObr/Dz8+ir8Q8dkrV0w+p12hGZiUyY5C0eBuGFvsjYvrX4Ky3B4H830e?=
 =?us-ascii?Q?0lFTHY06Vwyy6842eda1+8uX25yUXcxtErQ+uHUcVL0SP9CgtvCAcK2u8BuN?=
 =?us-ascii?Q?mOVOmLlUp7RJFg4xc2Vl/XfQ/8Ek5Rcq5D7RtU/N7PtvlLon+54xOhd/YXBU?=
 =?us-ascii?Q?iEUsjg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b136985-baac-48db-3673-08db31fec28f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 15:44:06.0535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TJixN0IlO/46g46Xczv1c0CcgIc/d91qFvXZxftZWhYRZLeOhDs8x9qL73pD+EqCBJewKrDYA7Kwz6gg4/Fw3TD5FNzaMws/q4ifzvlZRkE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5534
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 08:57:18AM +0800, Yang Li wrote:
> The call netdev_{put, hold} of dev_{put, hold} will check NULL,
> so there is no need to check before using dev_{put, hold},
> remove it to silence the warnings:
> 
> ./drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:734:2-9: WARNING: NULL check before dev_{put, hold} functions is not needed.
> ./drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:769:2-9: WARNING: NULL check before dev_{put, hold} functions is not needed.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4667
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>

Looks good, but I think you missed the one in mlx5e_set_int_port_tunnel().

> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
> index 20c2d2ecaf93..69ac30a728f4 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
> @@ -730,8 +730,7 @@ static int mlx5e_set_vf_tunnel(struct mlx5_eswitch *esw,
>  	}
>  
>  out:
> -	if (route_dev)
> -		dev_put(route_dev);
> +	dev_put(route_dev);
>  	return err;
>  }
>  
> @@ -765,8 +764,7 @@ static int mlx5e_update_vf_tunnel(struct mlx5_eswitch *esw,
>  	mlx5e_tc_match_to_reg_mod_hdr_change(esw->dev, mod_hdr_acts, VPORT_TO_REG, act_id, data);
>  
>  out:
> -	if (route_dev)
> -		dev_put(route_dev);
> +	dev_put(route_dev);
>  	return err;
>  }
>  
> -- 
> 2.20.1.7.g153144c
> 
