Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44C7E6DE116
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 18:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjDKQhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 12:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjDKQhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 12:37:15 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20710.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::710])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFDB5527A
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 09:37:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lBuOhPOTEhtclRDSI4j2JvwQ9kyRP0AWbsNcLKK60ntcZoYlOTLs4w9w4oaFMNIMyQj32QE/dnyoTgpIYJGpV+Lutn1vyoiFlfp9xqGYi52sWmRM3oYn4ZaaPNDvwLKtolah4B746C87PLF32Jq+iwXeaP/v5BUM31eQNctFnrAI0g9YkTRCntbwwkyjEZHWtMKvXQ0RRMdg/e57g0qjAlO9LvkvTSg9brAbIqcsPN/brkaSMeiK1SJUtkfs+Fu5y2RXnaR1bdnA6BnB+od0EjkJNcWoe1DjRzlTj49uIQ+RvnWkgPXSJHFK2cVAisV+RY/pCh1x6B9Vz9VSJhbvuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mp5cgB7Of4GUyi4W+qQjXEhMyN5zSJyybhmC1NpGWnc=;
 b=AmRel92dG0UHNuV3jAs3zf+2UhybW2mMdDelEs7e4RF332Z1xpWtLjfxTKs0sER0vu0qam4265MhQI4mCPPcH7+5ZYE2h3OYL0Ca2pe4mudvbxyAT/mOTLbkhR0iS1hoH6l7FQj5qgiofs1Z5WwUmMK1la1trT9yP4PlJpEKugJgou1bTR5TAOgCgtiJDd4ZgQX/5UEqLea2KwmrSOW8So8oWwVX4PBt1Xs252DBtAV6XxekIxkQj49e0mTl6NYedFVZ3EpvO3fbinTGzLO7FYMxxggTlBoU6SRfCmLT97U5otgHNcKLe8jMw+j0YCeiWn+pCVbJ9Ylx1Aup9Ws4Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mp5cgB7Of4GUyi4W+qQjXEhMyN5zSJyybhmC1NpGWnc=;
 b=USImLYM5A4u1RACZ3iesvivmBK7dw/BHWSOkJpAknQFpfdtP+QnqDymKtRk0vdRNCV6DA4QK0Ydw/pNk5DDH2Z92vT9jlGJ8rz2OQyFN1UqW36b59Qb8XqbiIIK4I9PjQ8L75WRL9W52h0zxw3ULdh+pUjBoNPq60EQ6A5GoJNU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5019.namprd13.prod.outlook.com (2603:10b6:510:7a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Tue, 11 Apr
 2023 16:37:11 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 16:37:11 +0000
Date:   Tue, 11 Apr 2023 18:37:03 +0200
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
Subject: Re: [PATCH net-next 05/10] net/mlx5e: Support IPsec RX packet
 offload in tunnel mode
Message-ID: <ZDWMr/CTs5kqzcNV@corigine.com>
References: <cover.1681106636.git.leonro@nvidia.com>
 <255b601d3652bb8c770571ed3e683f695614923f.1681106636.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <255b601d3652bb8c770571ed3e683f695614923f.1681106636.git.leonro@nvidia.com>
X-ClientProxiedBy: AS4P195CA0016.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d6::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5019:EE_
X-MS-Office365-Filtering-Correlation-Id: cdfce299-221e-403d-2fb3-08db3aaaff65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n4Q33fGy2pWD/6gGPl+JYz6APSj97klxrE5qavpB/B67GQuwCrqi43R/HjqGcmk0f96UrajbKdAxEUQeZp0RpejPQQFmvGSQR0rlWsufY9ZTAGrwz8fIWgFVRjalEXAWZiJMgs7wr4AoQYAsR5pHkauLmg0XG+PM1yPq1OXGIJ0pFoAHsOKophjD7nmUDcc5JfRAXVrPJU5s/Us/3D7vWh+h/TR/+1HpQZBazaCYt96t/f/NFU5CI48jCQQmf2ElTuX+FC3eZn+YX9mpbWHxk3riiZMST+8bZyA58m7wasbzGd1NHfplJU12SjckPYhOl5CNCff6l6PHmi2yjLOxJwgp+iUg5EZ58MO1ryWNMH8QDL0q9ZsFYudhWQhnf//ruvD79PPJtbH4y+WlQq113mkMemZMZNqcbiOO22qpXzOu9R1EHIJNJuNWaB9aykjv2SuCKDqoM2tcBW7eN52sVFeBmZPx2sOFQSmuRblsmWJCqFPQbgeO7YS29c+9w/r9qQc6wgC0iTBsKIoNTeEqerBsMkedlnO5yjLuDbQSZbd3et9qa2DNfmTSneKIcBC2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(366004)(39850400004)(136003)(451199021)(478600001)(6512007)(86362001)(36756003)(2616005)(38100700002)(2906002)(316002)(54906003)(6506007)(44832011)(186003)(66476007)(6486002)(8676002)(6666004)(6916009)(66556008)(8936002)(41300700001)(7416002)(4326008)(5660300002)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Kt2YdD5lR5rmwWGnDQAKlKlLa+8D83WdL3msDfXUN0WPJ7FsmKHSvOfcrphC?=
 =?us-ascii?Q?Prr1+kF2CfHgsUhjoy7hKDflbxzddzUoMEaFsfVLFggWpegynMUvt9WC4BDf?=
 =?us-ascii?Q?H5OEWFnc7nIeOpg1UTWAnMe/ic5UV0MAIy+krqHggDd9DjdknDQp58Nh0Xyi?=
 =?us-ascii?Q?q2uyFugiYr69K/lb732MPLTDWnMQJtZVnJhZIXXxrxgLxaqAxRX0toqQ8kmo?=
 =?us-ascii?Q?jw+HACDOs7Xgqp26T+1aiY7XOu1xC3kT8vg/iNUC59bskIG+DzPK7BXG0Xjm?=
 =?us-ascii?Q?/Ex/46Y8z/6AMy6FrHWIQpDbExhgurbAoTrXi/PPaMitKLKfrkafzCrj0mn1?=
 =?us-ascii?Q?ldtQDwXmHi7/kq4NQFoNaUEljhzdVJ6d4M4qw/FQXnUUc9ta7qKXA4DQ/WUk?=
 =?us-ascii?Q?iO7NM1dh+cwxkyehJ5NtaQKYqMTIChGr9dgxdx4WCY6/Y8UUaUXN/LzKjoHR?=
 =?us-ascii?Q?hnkwEPCwMIgwiRBPyhhpHw6m0Z1t05n+MEQflGusgp99GQTrlbGIG0t1BWf5?=
 =?us-ascii?Q?1/OCBvWAz0Bw+xOOu5//keHgZJH25P92Cn7RzjeW8+9UavsJ0rEgD68T8ACV?=
 =?us-ascii?Q?oLGVBLhCvd4ZcF7zSkXSZyhTbHSi80O5HgmknB2MEREVLlG9wAEbZf9c5Fb7?=
 =?us-ascii?Q?2GLqNpUVJEv4BByunw3VltgebprT+k0F9IU/IaaB3sdbTZW6enxxLN1sspWj?=
 =?us-ascii?Q?3J7v11CkTQWgqkj0GmGcY3Cx/vjBASRHegIkrKOT5Mcx4AscB/shAm262B3P?=
 =?us-ascii?Q?D11pMEuVk4CAR+1YhC0UJed6+9aC643cYSTTDWgpYgXPrCHkYUrtaVvanp4h?=
 =?us-ascii?Q?ZbWbrg2VMFnw37YWXCgiUMOS8xG36grUY/m0ieriC/zowzfYIySVK6UostKk?=
 =?us-ascii?Q?TvusR2Wryxsd5n1iurdn0m/zgQ2igOO/XYIBt0awWo0RANw0PhGmoCWStKdQ?=
 =?us-ascii?Q?CHOHN7C7JziGFI0N+gNYzt5XvedlvmgWBY+Kx4XV4+vXFgqczSgFcpupD1kO?=
 =?us-ascii?Q?esoaC7GFzMJiAYGhnKDFYtCpO2bVHuz3Kp1Th202UcOKZhn8JqsccJEaBcah?=
 =?us-ascii?Q?Xo3/Wa1aL8+bYy92Fa237ov/Eb0zBF+lrXP5aBEmLY1/jnKfWP3QkkioYKfB?=
 =?us-ascii?Q?i1mffV7uC/WfZ72dnbx6n0Z6EcgydFITyvD6Wt3P+q2S1PN1ZA9a6dM64N72?=
 =?us-ascii?Q?S6tW2pT/Q+YJjR33edB4ij3dmjnTAYx41lBXtc0AFzMsf+NHAMVb4nU3CTxp?=
 =?us-ascii?Q?K+Iq5gTVgeceIj2VCFygW8KcBLBIu9ptCylinr54pT+Dgutj6hVg8DaA22ef?=
 =?us-ascii?Q?aIg0qbDQhUIGjAdaKvhGXy1lpnSAFiV1o4mlg9ToQsTy5Nb/IKhV/0TqBSQC?=
 =?us-ascii?Q?eyBAzYs7QRJzj8pgm2Lc/dythT5EKVpbE2ANpIs70EsLoarqPhWO1fGa3gt+?=
 =?us-ascii?Q?ghD5b50HnPmrtRYRZNqKsbbA9LV0s/j1oeIFaHVMMFxuhHzCMa0qwdUErZBh?=
 =?us-ascii?Q?ZKnshbcYxIj1fvi0r+fxCqOSW/je7bt7ZjQ2vXHG3SMfinqQi7O+QxwSj5g4?=
 =?us-ascii?Q?UwCqE3zYtAk5Re2wt4lqsJ+gWIzyZbDCTKdlRGXa+gFTnIk0mK9NL7Q66tfT?=
 =?us-ascii?Q?CWx88vJhEfDYfICYT3/JS7SFhZCV1rlwEFrjVZzrinM9u9Mnm5is1xfh0wsd?=
 =?us-ascii?Q?UalGtQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdfce299-221e-403d-2fb3-08db3aaaff65
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 16:37:10.9014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /bc+S8j/N1Kier0IaUAEX3JMdTng3aME6oTmSCit2ooOpBwWZRBfuBja7lCnczQPCwTnE+rlYTzy/FwLsgW/iJoQYuXrlCMwV63rj0ANGJs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5019
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 10, 2023 at 09:19:07AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Extend mlx5 driver with logic to support IPsec RX packet offload
> in tunnel mode.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

...

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> index 980583fb1e52..8ecaf4100b9c 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> @@ -836,6 +836,60 @@ static int setup_modify_header(struct mlx5_core_dev *mdev, u32 val, u8 dir,
>  	return 0;
>  }
>  
> +static int
> +setup_pkt_tunnel_reformat(struct mlx5_core_dev *mdev,
> +			  struct mlx5_accel_esp_xfrm_attrs *attrs,
> +			  struct mlx5_pkt_reformat_params *reformat_params)
> +{
> +	union {
> +		struct {
> +			u8 dmac[6];
> +			u8 smac[6];
> +			__be16 ethertype;
> +		} __packed;
> +		u8 raw[ETH_HLEN];
> +	} __packed *mac_hdr;

Can struct ethhrd be used here?
I think it has the same layout as the fields of the inner structure above.
And I don't think the union is giving us much: the raw field seems unused.

> +	char *reformatbf;
> +	size_t bfflen;
> +
> +	bfflen = sizeof(*mac_hdr);
> +
> +	reformatbf = kzalloc(bfflen, GFP_KERNEL);

I'm not sure that reformatbf is providing much value.
Perhaps:

	mac_hdr = kzalloc(bfflen, GFP_KERNEL);

> +	if (!reformatbf)
> +		return -ENOMEM;
> +
> +	mac_hdr = (void *)reformatbf;

If you must cast, perhaps to the type of mac_hdr, which is not void *.

> +	switch (attrs->family) {
> +	case AF_INET:
> +		mac_hdr->ethertype = htons(ETH_P_IP);
> +		break;
> +	case AF_INET6:
> +		mac_hdr->ethertype = htons(ETH_P_IPV6);
> +		break;
> +	default:
> +		goto free_reformatbf;
> +	}
> +
> +	ether_addr_copy(mac_hdr->dmac, attrs->dmac);
> +	ether_addr_copy(mac_hdr->smac, attrs->smac);
> +
> +	switch (attrs->dir) {
> +	case XFRM_DEV_OFFLOAD_IN:
> +		reformat_params->type = MLX5_REFORMAT_TYPE_L3_ESP_TUNNEL_TO_L2;
> +		break;
> +	default:
> +		goto free_reformatbf;
> +	}
> +
> +	reformat_params->size = bfflen;
> +	reformat_params->data = reformatbf;
> +	return 0;
> +
> +free_reformatbf:
> +	kfree(reformatbf);
> +	return -EINVAL;
> +}

...
