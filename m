Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 160956EC169
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 19:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjDWRlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 13:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjDWRlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 13:41:35 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2121.outbound.protection.outlook.com [40.107.220.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D55F1A7
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 10:41:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AqaKdLFrRKamMs2kZku0O28tKGom0yXcbbSL2n1FwVhBTCA6LyiO85gHvatxkh19cipS13kTqdThOKRyDOO26DShTNAUFZMyJ4FK8lMlz/eoC/doJzDMOFtisgTErn9rGFdshJzuGzQwvj2Yfdpnt0MA175xtgKjFxc8N+HZeuIyGr8wEoT4JOPtw6GY/0tlgb8RfPWwvW66lVV8wWpMPhkAQNFCDSN1kxZU4AdHrSafUjHBymOPcE97kTlt9/3+c57jBH2Nny7eD2v0FO2f8UEeZBXRd6UgYA8ez4CMbcE0+LwMMJxfW85pjpsAlR8tNzTe0JeCJ1X3U6VN3gtsOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mal3jVYgawGwkJW1IAr2Y7PEQ0OBTW4CIiwH8FwHyn4=;
 b=aaMDcZV2CSr3XXZZDjD7jYSv+jmMUaVC8zgOKGp7vex7+irQjcRVDGyiZriRhHq7f8cLlFupy7R3NB7hN0/DDp04nfVJ1xCmlKJPbSFeKsemybqr3h4myj4xV5DbtXG0zR5DIukeJk9yiYklcwG97Ql2S0fKXimCjMsm4cbal2RoGaicbc6Jo9vyew4kwQDXHWaR6Wx76Jffvcw8gd/CSRvVUbdpie2LN10iTV9UnvRkrxvcdqbSOezQ8u3j+7YTcwsPp2WxmnAd611x/2nssDVpVqL8AOn4CofovIU7hU+k1eqHTecM8Rqha16n1NmwpdnFiy9y0wIoKYX60oNx9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mal3jVYgawGwkJW1IAr2Y7PEQ0OBTW4CIiwH8FwHyn4=;
 b=evOYO5hEJR9yaDqF0YEp8DfS8ugregEyuhAcU5vT8fmLtJIlOQiDmzk941Y940tPKPae6fq9131z3buvJ+8KaV4pvtKXaMP1XkK1gICy9BXQQoLmQQSdMM9qg9rGVm4xcyXdjFK9h9O31N98acW9S/y1VlLzK3A+hgC0dvRPrKI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4869.namprd13.prod.outlook.com (2603:10b6:303:f2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Sun, 23 Apr
 2023 17:41:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6319.033; Sun, 23 Apr 2023
 17:41:26 +0000
Date:   Sun, 23 Apr 2023 19:41:20 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Dima Chumak <dchumak@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>,
        Leon Romanovsky <leon@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net-next V2 2/4] net/mlx5: Implement devlink port
 function cmds to control ipsec_crypto
Message-ID: <ZEVtwNsM+/VLWp6G@corigine.com>
References: <20230421104901.897946-1-dchumak@nvidia.com>
 <20230421104901.897946-3-dchumak@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421104901.897946-3-dchumak@nvidia.com>
X-ClientProxiedBy: AM0P190CA0018.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::28) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4869:EE_
X-MS-Office365-Filtering-Correlation-Id: d90a418f-87f9-42ef-e9fb-08db4421f670
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QMeM8IyZ4nPCFuOeQYYaOcw4CwmYpeUGpJBrmqVlSMjaYCNcYSbJFRk6+Pp/GZjX0HCXnx0hpyg6O53a2NQAB5NyomL0Ck02GV5/4bl90JJcGUBaEUCpEj5/TjT/90P3tmkGYC0J8RqXLqI2VuEwt93SfRNsYnZSQ1TTcBkp0ygde3mn5H6co6+glrow4AifqpkIQA82sMZTvDdtOi/d9LhKZsJjuYDRXDC/nY/rk/9x3N3zpMnf6+MgEisX+cqQWEZNeTFSqxe7EfB9iTyFVxaVxhzamOE7XBbS0EfNg9CnPKm55wJKPXbcxEUJM3dWKbK9n1INTE8+5vFUGE00dOVvwXMF/C84nQ1WRN6rugVrrJv8b0LYoi7QDs1vBEqraT8N/9lA7oqhbjRf4iL+YYrEzAL+JS/BgAMzwxL6qd7f6bFB8kQbDRMbJf0JWcpFXs2mw1hOBeTqx0e68txVtdp7YvrXcvQEj6+62jCcGwyuJ3fUzkXzC64wop03nFnkVVV3xax51mkUZj6eDF4gYOYOffhjv5qErCqZZaj5MxSPI/COojD4n73y9kXiqZ1C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(376002)(346002)(39830400003)(396003)(451199021)(2906002)(66476007)(66556008)(66946007)(6916009)(316002)(4326008)(44832011)(8676002)(8936002)(5660300002)(41300700001)(36756003)(86362001)(6512007)(186003)(38100700002)(478600001)(6486002)(6666004)(83380400001)(2616005)(6506007)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H0/ccC26eBLQNm1bQk5qxPUQwDfBRARpYqckBKLocezKg/OklRRw+dQ7J3ox?=
 =?us-ascii?Q?1ZEcLWpUBeLMkMSVO8L6YhQOuVjdGF8I4NaMAdEJiOE9UB36OBP6Kzi3uhgl?=
 =?us-ascii?Q?TVHjTCo/xdExsplu3n6nQ+DDqDS/fVWCB1Ma5J7YizV0gDTaH3z2WS955xKY?=
 =?us-ascii?Q?kEbD+1hN9TmecsfFvBC5MAmOchOPsNSjsT6EZSEyCk0bPjWMsyDPnKM+i7bh?=
 =?us-ascii?Q?Anr6S7BgOzWl3iemTYRGzrGn+lSvibLmA9V5HUR2ePAEkaIpZt7YSHtmnDeG?=
 =?us-ascii?Q?II6xLO6rAjo/ExtW/Sf7eCSi2XMcBGIAei62JPTrv2vhrcffKXm39lueiu3/?=
 =?us-ascii?Q?mUHvsZ64+YBGXwd8hGNSGRFRH8X+jDIi4oGnn2xmbSzbGDv/WsdV+WgA4Uju?=
 =?us-ascii?Q?9PbTmDeLCwZSWPIeco3aMSLUgQHHkdNqsDRF+NOMkei8KCc99SbzwMPVAZbJ?=
 =?us-ascii?Q?fFTT8kyYehhsWX6WOO4wt15gdr978+YaQdYAcmNf5Dbs5qrfltep4NA6jI2d?=
 =?us-ascii?Q?/slayK5BZkBm2Qi7Kv9XwiYdORDnxZkA2fGJpq1uT/m6eMrDu6PFqB9yzRWY?=
 =?us-ascii?Q?q0bxwvUViN91a9agFlDXcm+6TFnMQ7iMBKXH8MgSeq/Ph7Tq+2dUWSdJ0sFO?=
 =?us-ascii?Q?EsaVVjdzjTYwzNfEE8s8tNwIBZK7PSZy2euOH1TOEhbB+3s1jD25S2xMcg8C?=
 =?us-ascii?Q?4Js6ZG8P95VPU3RXvwaLeliMJpuoh3io68TB9rltfNLg228q9FqUUyrY0cbA?=
 =?us-ascii?Q?LuWjHYTLsDFJGOzmQM4LKx7TPVmCraFSpL8J6VPNP9nH13gcxZXtmHz1ULdQ?=
 =?us-ascii?Q?8ZwnpZv+ByJjKYneh42+8/43qQfCtYADaZlrIdiS7V9TyKI8hnZDowCoPbbY?=
 =?us-ascii?Q?HduDO1jIr9WSBdkBe7jzidmKBgTogH5ObG3MOb9jcM/WffbtQ0AfiXufhZgy?=
 =?us-ascii?Q?Bbc4dg8M1rH55F+5NjTC+sSIRRsvY09cDKBxe9nNa4qiniqJBQHv6tR4hTIe?=
 =?us-ascii?Q?rzcHTGyot79ECxbdt5VMpoO3FvxNVmraTR6U1uX6LTE+0HQ3BFTdf1IoeBrp?=
 =?us-ascii?Q?18PcbRxYNXou8Cjzk76NnBv5mckl4CE/bGGypwJvsONZwQRM0fKR0b7YZaGe?=
 =?us-ascii?Q?UFOCGRXgNCVStoPsCSuSvR0V3mjXgwGADLjVfjjVVD84LG6rIu76knqBAu3q?=
 =?us-ascii?Q?4ISaeKY4+KFMAnyL4SiHEEoj6NuEuRRNu6jWsNi7Cyrpp3NX5uEHqIr5kOWy?=
 =?us-ascii?Q?MGITv7kNOCa6a/DldHZx1bSHf3lm1OTC/9F3BscvMsGYBhe6loS2bBAZoidQ?=
 =?us-ascii?Q?2CK93BMrLwCzmQzuevPcrR/GvAkieL6lQus866pd/bWqK4imJI3HwMfeC10b?=
 =?us-ascii?Q?bSXrJ5OeDFoyUdEeh8R0k7EdpsSh13FhXA18YC+lvHH2fhqUdY6ChxoukGHT?=
 =?us-ascii?Q?ZVB2SO6yazn6Yw7Z/jKJIM7Rec82jt2MVoNmbdF/mZyzHp1SZQHZI5dy0oCr?=
 =?us-ascii?Q?VRu6OnVpGL2MWghYg3YyNhsjbZUj2TvBCD92FOOO95M2WitsYQ0TnPOZBExz?=
 =?us-ascii?Q?/n+DKK2NynaXzPUu2wbRGFyjuU+Sdd4VBsHX2s2RTdGwIh4X0hG/Wy4X54Zl?=
 =?us-ascii?Q?xAT+Hq1V2TyRJIdmThbH4asQ+DJyCFcecX4bXV2UfqAPR3FVno0TtW2Ad8Wt?=
 =?us-ascii?Q?7cV9XQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d90a418f-87f9-42ef-e9fb-08db4421f670
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2023 17:41:26.4881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uL9JZvYbX3s4dF3ZbiN9GLEpo0Z+Rx+Fj0GEH0kux6mVqep1KBGDyvyCj/c0uFqSVj8NmW9X2VInyyVpZATMW0tPQH9XGaV2apTIFzeU2Rs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4869
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 21, 2023 at 01:48:59PM +0300, Dima Chumak wrote:
> Implement devlink port function commands to enable / disable IPsec
> crypto offloads.  This is used to control the IPsec capability of the
> device.
> 
> When ipsec_crypto is enabled for a VF, it prevents adding IPsec crypto
> offloads on the PF, because the two cannot be active simultaneously due
> to HW constraints. Conversely, if there are any active IPsec crypto
> offloads on the PF, it's not allowed to enable ipsec_crypto on a VF,
> until PF IPsec offloads are cleared.
> 
> Signed-off-by: Dima Chumak <dchumak@nvidia.com>

Hi Dima,

I noticed a few issues in error handling, mostly flagged by smatch.

> @@ -622,6 +624,7 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x,
>  	struct mlx5e_ipsec_sa_entry *sa_entry = NULL;
>  	struct net_device *netdev = x->xso.real_dev;
>  	struct mlx5e_ipsec *ipsec;
> +	struct mlx5_eswitch *esw;
>  	struct mlx5e_priv *priv;
>  	gfp_t gfp;
>  	int err;
> @@ -646,6 +649,11 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x,
>  	if (err)
>  		goto err_xfrm;

goto err_xfrm will now result in a call to
mlx5_eswitch_ipsec_offloads_count_dec().
But mlx5_eswitch_ipsec_offloads_count_inc is not called
until a few lines below.
This seems inconsistent to me.


>  
> +	esw = priv->mdev->priv.eswitch;
> +	if (esw && mlx5_esw_vport_ipsec_offload_enabled(esw))
> +		return -EBUSY;

I think a goto is needed here in order to unwind correctly.

> +	mlx5_eswitch_ipsec_offloads_count_inc(priv->mdev);
> +
>  	/* check esn */
>  	if (x->props.flags & XFRM_STATE_ESN)
>  		mlx5e_ipsec_update_esn_state(sa_entry);
> @@ -711,6 +719,7 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x,
>  	kfree(sa_entry->work->data);
>  	kfree(sa_entry->work);
>  err_xfrm:
> +	mlx5_eswitch_ipsec_offloads_count_dec(priv->mdev);
>  	kfree(sa_entry);
>  	NL_SET_ERR_MSG_MOD(extack, "Device failed to offload this policy");
>  	return err;
> @@ -734,6 +743,7 @@ static void mlx5e_xfrm_del_state(struct xfrm_state *x)
>  		/* Make sure that no ARP requests are running in parallel */
>  		flush_workqueue(ipsec->wq);
>  
> +	mlx5_eswitch_ipsec_offloads_count_dec(ipsec->mdev);
>  }
>  
>  static void mlx5e_xfrm_free_state(struct xfrm_state *x)
> @@ -1007,6 +1017,7 @@ static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
>  {
>  	struct net_device *netdev = x->xdo.real_dev;
>  	struct mlx5e_ipsec_pol_entry *pol_entry;
> +	struct mlx5_eswitch *esw;
>  	struct mlx5e_priv *priv;
>  	int err;
>  
> @@ -1027,6 +1038,11 @@ static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
>  	pol_entry->x = x;
>  	pol_entry->ipsec = priv->ipsec;
>  
> +	esw = priv->mdev->priv.eswitch;
> +	if (esw && mlx5_esw_vport_ipsec_offload_enabled(esw))
> +		return -EBUSY;

I think this leaks pol_entry.

> +	mlx5_eswitch_ipsec_offloads_count_inc(priv->mdev);
> +
>  	mlx5e_ipsec_build_accel_pol_attrs(pol_entry, &pol_entry->attrs);
>  	err = mlx5e_accel_ipsec_fs_add_pol(pol_entry);
>  	if (err)

...
