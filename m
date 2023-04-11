Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEDBA6DE040
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 18:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjDKQAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 12:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbjDKQAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 12:00:47 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2091.outbound.protection.outlook.com [40.107.244.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD90E61B6
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 09:00:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B4BkRdRKThBnePHwQQ7YVQdiNCPh2Nsy8/qexoAg6wvL0W+i4qbOc0MVH31tAV3cGMY3VAC0cvnMTR1j/+63x5AggwWETmjet3QWdT9ibGdU7LFS2zarSpeGtWPeOSK87181vOZJ2Ho3YxLUTGwhSWC6as+d9HOb3oUOM918fuzWXpUDXgruG2ihCndLKc1rc9ZPVtH8FgbVyUkkcDuuhs8s7RXHsR2658KdRXC6AWZCpTeB2oFNgOYF/nDPYzAOziKGWLVzLDYjh8/E4OcjoYkow2O/VGWI/N+PmL+s+2jWdiqg+JU5k5OsCQbe5FELg7YDNbGQcg6pvH1QcYVhpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6lInp0EM48waaPGC6PaAsQu63uTPcNGmWhp/5q0hLmU=;
 b=VpsPHV2BZekVfuAQZtAIMmm8FVXg4tWD6ll4EHY4I91tHqwj6n4wakoT7xC8GqBCx/29Jkm5T98JP86z20e0ZubuiYNmsOg7yYg/rdlReWzxxoCeMFuWI4vKzGN2W3SzwppV0M3k+00nNV1lYHFFy6C3jIW/dbojpvo8uuUnGT8b0XPOSee3abdqCHWuC7Hqh7LIJaLZWcyn20KvW4hssrcSB5vtPUwEwZju3SPPkTUlteS5Yb713OQmW2WxaXwfEitrniCC9QERklogD7wiD4A44FMMRo39pRuSGjGhyw/e/r4n3UcNyo+jphmAVAONobgsnXfomQC1IIrPbAd4lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6lInp0EM48waaPGC6PaAsQu63uTPcNGmWhp/5q0hLmU=;
 b=hy5zlla0tndEkMPFVxU2XV/kzUl7xBjkGGNLaJXT1+fUDHSP6E2bFAUi9/W89QnfmrW2z6jMGYY8TH/eX6mPkyw5VGe4BBR09xMvBw17S6Oudhl084zQ5XnwUCE0oTRJGWxQByeNXu6ZyzerQ07/Vi7zZIrv/Kwv3EWCDs+GYVw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB4585.namprd13.prod.outlook.com (2603:10b6:610:cb::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 16:00:08 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 16:00:07 +0000
Date:   Tue, 11 Apr 2023 18:00:00 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>
Subject: Re: [PATCH net-next 04/10] net/mlx5e: Prepare IPsec packet reformat
 code for tunnel mode
Message-ID: <ZDWEACmSLgk83pIw@corigine.com>
References: <cover.1681106636.git.leonro@nvidia.com>
 <2f80bcfa0f7afdfa65848de9ddcba2c4c09cfe32.1681106636.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f80bcfa0f7afdfa65848de9ddcba2c4c09cfe32.1681106636.git.leonro@nvidia.com>
X-ClientProxiedBy: AM9P195CA0026.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB4585:EE_
X-MS-Office365-Filtering-Correlation-Id: ae43b4b0-1c6f-4acb-43f4-08db3aa5d23b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VTYg1ZDCl0k/SCDmtrMRwgXLhIAalzFpghbb7QncQRuMG5VEXAPHAMb4MnKmrJxwJ8eoyHs3swnJsDj6zGM2+TA8BVJLq8A657w3L9oQhK16sJsFMICHsGegkjmrhk79C6sop5cebTVmWyGw0NEJmixlXKQDd55jPPg3UesDFi/n9+DNc5et1bz0FJnpjGndpigfS4Xm09GOyY5e6XbL5P9iJQRimNT80kwinxHj6wmyJ0WuKqJ8Rp+qwAGvN5spXOQiW2jPi9wQ1sGbhHivHzuNnMvqD08L3oObmASYY/iePaXF6WIxFnZFcUYK3ff1ayJKN+1zAIBF3UjpMKa2aRaiHLPSxpkHzC2N/OCyMZ54JqFDffPoS1JYhnR9ELpzXrT7tLFpw9MW0ZANuYYUr91h/jHpjoeh8pQUq6u5mSELais0FB2S8US7UekhrwCwgFdLsSyEMw21ka/mMh+TFTTcwNiuB9yBWtZn2jYUoziTJ1s9hS62J8/tgEAlw7DXxnA8ygweC6B9vbxC0yRQ1YSDGnGiGZvupHzwURXU8Pv+ST2Y9re2S/Rbxll3FxBdyDrfC83D0TF54PiQmJ1KdfWoOGANENyATwVOniYjZ6U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(39850400004)(396003)(346002)(366004)(451199021)(54906003)(186003)(2616005)(478600001)(6486002)(6666004)(6506007)(6512007)(2906002)(44832011)(38100700002)(36756003)(5660300002)(7416002)(4326008)(6916009)(41300700001)(66556008)(8676002)(66476007)(66946007)(316002)(86362001)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G5djCCoYFB7Wrne1Rw8ml1EJqevoF4vweMA4TA637g2GzL4YIVbc2myDyjTY?=
 =?us-ascii?Q?FDJea4pa/CCYlETB6bgtP8KyuGXYQfKKAFGZxQ3bL7EuNMl6b5Zpog0efA1e?=
 =?us-ascii?Q?xLoYU30kWpwwbbGq3i9X1Q5ykbkNI+Yxq9JD+BCEL7XyNE5GRoRV1YGgaqes?=
 =?us-ascii?Q?65mcTQRTXPKLkljqnPpgJIhpiG8t0XE80JxzinN4y8IxBWErX2LK6zW4jFXD?=
 =?us-ascii?Q?fHKLiQEdCroh4Kxvl9iM/aM5AeLrUow7X1q962Em1Xb4fEoQwR763Z8qRG48?=
 =?us-ascii?Q?/DAHDmuNsjQ6F2vVwrlGRQqdblwWnRldpV0hw0csRkPWPgbJ0lm4N/o3JUby?=
 =?us-ascii?Q?T79Gry+renNKDZjWpbVbTy7mHZHpsXB1iwVkIXJ2KyAj1v0UQCptLUI9X10o?=
 =?us-ascii?Q?axFfl7rWetcxMgx9i8fCE3ccCADTCBEA0un1zezftwpvuoiP/k5YPKCiL0rG?=
 =?us-ascii?Q?J1haBLvfabZ+ONGj0DJ0UJZr5w72hSAzUFaqNCrrktadt2co36cPZuTT12Ti?=
 =?us-ascii?Q?U6acdLT4jWfYS64UMj7UWgkPrA3agvYs0ZY2LayEuyzkS9iFug3EG7n3jyL+?=
 =?us-ascii?Q?gfTWLAqV4G0AeSqFJl1xll59dBPBJ24obyKUKLJzrlmXxXzyDDZiSCMPECBx?=
 =?us-ascii?Q?Hfz9lWgk0Ts6hJz5fj8xyOzTk2lFgA9FSl2R2mgCuK0iDX4pvJRhItzdWji2?=
 =?us-ascii?Q?23ZO6nLWc8C9C27w+0I6HCqPUy1tVQoxv+Xa7wxx0U9PxfJdKx0pD7UQdxXc?=
 =?us-ascii?Q?SOf6OM5DBsGnAqX//h+i0GRzZW0lDuAgx/+U25Q5jTlJ7KsiUSIGXbV2xuGK?=
 =?us-ascii?Q?9S24naRauIbYSet0cqgrSwOcyFhnCcArBp6uXIhXzy+1UTjpXFxax+GE/XT/?=
 =?us-ascii?Q?+N4tLqj+N/0vWOaMRrNkAAQtkP8eMySDfig5xdZmSJu4IoEkShlcuwHSgkzI?=
 =?us-ascii?Q?25UreeYpTtGMLvRdZ3/ZepuxHR49+TQOM4W6U0GM9UuwmNXFohla30SctBr3?=
 =?us-ascii?Q?8cTW/TAbrLpRHsZs7x7jqf3Tp7EzMVrwJ86ZsEfifquHqzjDY16KZ7otWISa?=
 =?us-ascii?Q?PzzMCt5IBCfTWpmMXNK/b167y1PRbskitZgyXCOPUZCKD/kQE0IRhii+zkwG?=
 =?us-ascii?Q?R1qpcSitZpAcbFMd1llw8oFUu8XY+2qELPHYGBnFwUInQQS8i3DqE/CF94h1?=
 =?us-ascii?Q?qgamp7UhF5uiagGnIw0pMSS6CkozJqD9Z9gM7B2WFn10yUGGpkHTnb7bIrBt?=
 =?us-ascii?Q?AFLozsDpEUwVgJMD47n7SweMshbNzJx2nCIcDtQiYph3yaAWkqSpvnutjCCf?=
 =?us-ascii?Q?+2t+Yb6WR6Ob4VOTc17VSLryFQS481mQC650Fvx6CBSrGnszLEwkkBBu/aaK?=
 =?us-ascii?Q?6YDfASlpvOO/Ji+xjxK5AetVVZn3Nb6z5gLgv3gsVU94UjBlPX6tTUks+9kG?=
 =?us-ascii?Q?7U5nm9pAAwcxpPIhgvsnPy5AC6GBeQppxENvV4qabenO/Yso+y1KwajcYHU1?=
 =?us-ascii?Q?iuosQanUdHAmYAutokMHnSOVOxGaGAtMnLtY93R65hk7+i/i8Ym0y9zLG/Z/?=
 =?us-ascii?Q?mkAYE+ufgc5w1FbEfMknPUBJ63a4wDWMWgzfuY4Ct6G7s+PmLQ+UqSd7rwTP?=
 =?us-ascii?Q?6+ex3uhmaWrLt1iLnNT9z4rO5R5gfp4QxKXIp4sFyEwIcz2urCIhlG8CUT+2?=
 =?us-ascii?Q?foJsKw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae43b4b0-1c6f-4acb-43f4-08db3aa5d23b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 16:00:07.7912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CVGnBXBO4sylM+fxAEBfWUXntunZUPswyzZ9Px4A02ehWBSpp0zJklKq8P0blBeX0y+sqv3Zc9hTnhhfn4ZRZKIBL5m9Av8b3EmLm//I6XI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB4585
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 10, 2023 at 09:19:06AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Refactor setup_pkt_reformat() function to accommodate future extension
> to support tunnel mode.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

...

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> index 060be020ca64..980583fb1e52 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> @@ -836,40 +836,78 @@ static int setup_modify_header(struct mlx5_core_dev *mdev, u32 val, u8 dir,
>  	return 0;
>  }
>  
> +static int
> +setup_pkt_transport_reformat(struct mlx5_accel_esp_xfrm_attrs *attrs,
> +			     struct mlx5_pkt_reformat_params *reformat_params)
> +{
> +	u8 *reformatbf;
> +	__be32 spi;
> +
> +	switch (attrs->dir) {
> +	case XFRM_DEV_OFFLOAD_IN:
> +		reformat_params->type = MLX5_REFORMAT_TYPE_DEL_ESP_TRANSPORT;
> +		break;
> +	case XFRM_DEV_OFFLOAD_OUT:
> +		if (attrs->family == AF_INET)
> +			reformat_params->type =
> +				MLX5_REFORMAT_TYPE_ADD_ESP_TRANSPORT_OVER_IPV4;
> +		else
> +			reformat_params->type =
> +				MLX5_REFORMAT_TYPE_ADD_ESP_TRANSPORT_OVER_IPV6;

Maybe this is nicer? Maybe not.

		reformat_params->type = attrs->family == AF_INET ?
			MLX5_REFORMAT_TYPE_ADD_ESP_TRANSPORT_OVER_IPV4 :
			MLX5_REFORMAT_TYPE_ADD_ESP_TRANSPORT_OVER_IPV6;

> +
> +		reformatbf = kzalloc(16, GFP_KERNEL);

I know you are just moving code around.
But 16 is doing a lot of work in this function.
Could it be a #define ?

> +		if (!reformatbf)
> +			return -ENOMEM;
> +
> +		/* convert to network format */
> +		spi = htonl(attrs->spi);
> +		memcpy(reformatbf, &spi, 4);

This seems to be a lot of work to copy a word.
But anyway, maybe:

		memcpy(reformatbf, &spi, sizeof(spi));

> +
> +		reformat_params->param_0 = attrs->authsize;
> +		reformat_params->size = 16;
> +		reformat_params->data = reformatbf;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +

...
