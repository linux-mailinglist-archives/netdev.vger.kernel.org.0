Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4406E96EF
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 16:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbjDTOWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 10:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231611AbjDTOWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 10:22:19 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2134.outbound.protection.outlook.com [40.107.243.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F4236E85;
        Thu, 20 Apr 2023 07:22:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HsCmlycP1MvRV/BO76AcV+I/nRR+tNCdiDFLxTjTJVGpw+PbPUnIf3enWnOoRZCWHSiJDsIv1RQmR15XQJgjuOTQjb9ZIrVfiaSxTi3qWRANVhDyi1P8rSzkzlBiARVJoiRsch2sPf2fshvJvRSXMRCnCqYbGTtEKDBNr4GnvEH/VkFeSNhPdCt9n1clsZ5SFtFgzN2beVsS1cS+gtu95vXUsIoLNUwPd+8j3TqmSkTuRYZRVYukrZAnUvVMH/IAESPSHElFeIriXT52E+yDUZDGJK6DqekpeuR63xuExbK2vtF0DTBuWNLWwznSzClkQDhUQOk6jGqXzO8nJsS+0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BgqWZG+BmwJFGn5gIY3b38YI+L5/T4tJ+w7VejOFtz8=;
 b=a5EntRxAfUu2OlGVZsMAHCAB9b4z0o04DUCxmrFMXzxqJufXSwJTq3nsGy7HYWh9IBenBUAf6HzG64eRjZWLvmSH+MzXHiuYoq0fxOpgGlhgoOOWzw7odZCJfD8ouUmbgv6CAiFZq1fKWdx+F27EQHOYL8X7fH9mDMRBaZ3ejVpzn2y+5Qkie4XmJLUHpx2BQVPLr0TFeLHZOrhC/7Lkj5IHvAxc1ymX6gA2OhIMzFFlBeTJcftdIbOVdc4ibquWiRWf1ikyNZH7buyCGDd1IuXC2sT9Vf9XlABlZoU0sHRjz4FXRmB5Kl9WJDkRHkIql+Olh8VFjUSxX8CHXwwukQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BgqWZG+BmwJFGn5gIY3b38YI+L5/T4tJ+w7VejOFtz8=;
 b=DxtiKK6ompLqJOVnSg/iWKEj+3wR/LquoYCocpQrUlaRcv08iQFXeAsammdQIW5VvTxoSMNnl/Kj3jDt0Eg3rUZe/kKk4HdFwPmmNxlR6wDwWO6gyPdyMB7Ut8KovzY96vG8Wzm62jN1QIUplq2XUtOi9fsZO37bEzuwIBhJDrE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA0PR13MB4013.namprd13.prod.outlook.com (2603:10b6:806:97::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 14:22:13 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 14:22:12 +0000
Date:   Thu, 20 Apr 2023 16:22:04 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Petr Machata <petrm@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Aaron Conole <aconole@redhat.com>,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/9] net: enetc: fix MAC Merge layer
 remaining enabled until a link down event
Message-ID: <ZEFKjPR/VL6llxDm@corigine.com>
References: <20230418111459.811553-1-vladimir.oltean@nxp.com>
 <20230418111459.811553-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418111459.811553-2-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AS4P251CA0006.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d2::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA0PR13MB4013:EE_
X-MS-Office365-Filtering-Correlation-Id: 45db850b-b8c6-48bd-06b7-08db41aaa21f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6MUeSKXbJuHEgGWZz9RTkXtY37MEeJq/bmLikNKgbFI9J8nOaLlEiKuUhTmIgnIJ0HUpP6GNgljAjgtY2Ehm2EQzY1U6QXb3R/L7iTiGRLa/Q5DuyROy/+c0UlpY1yBZuWLGQchEGpGAOmjSoo9DL9cNVz6EV4cV+PpT8KV/JG+mKLD4Cv0NF37tmjSQKY1xthpyyUlxYrR7zP4LS96LTjDQOixWbk8GhVQqQfibGLQ7aRPhzpBqYItIzSbClInsQue9nvLdVPhPU73he/feQ60YWXIo0pT6G2Cp2hi3rHXxXE0AGju1ScZMGBiB3BSCmGLUof5//F0baxkY86b04lbyRA5ydkK3FIzZ++ZBX7DPgQ3ipDGNR6byOXsSSwRAA8Dr5VrGOeeWkJpgKVwUMlpii0x1TeCizXTYEi4m1GzKqSgwvFDPq7TPBTIiWOv1yaF124oT4amlFUErHX5l0ujzvvYebhSrqgFsJgH942AawQwsNaXDf3NiVN2Un0rk37HsSkwlvVmo2pyax3pampIQxNh0/0ryFUW3wtJmPEcxxEa+hKAoQKin2ju3szRl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(396003)(346002)(376002)(39840400004)(451199021)(8936002)(8676002)(5660300002)(316002)(41300700001)(6916009)(4326008)(66476007)(38100700002)(86362001)(44832011)(7416002)(2906002)(6512007)(6506007)(6486002)(2616005)(83380400001)(186003)(36756003)(66946007)(66556008)(478600001)(6666004)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3SyoeeVYJI1ZhIE8+ZVjcaEN6sF40pILaIUE7hImTR9xCOJ5BMJ3bey2/MtH?=
 =?us-ascii?Q?71s9h41T0tY4PxuOAyfCattkO9znvYVhvD+YHZxHvdoOooelT10FYkfyU7fG?=
 =?us-ascii?Q?JTtrJipEbWoUfcUeuSQfrLKvlSvlaVnEmEgOcIZzWRh5wW/9IEQoTzBWAqvX?=
 =?us-ascii?Q?AKSlW7lfrBvEfbKDbJWTVSsxytJMC8vn2cKwSWyS7mvfeADKClDXI2qMyNpq?=
 =?us-ascii?Q?tOG2hTOA56WipGeNbwbyu0ehhf1cj6TmHG/qXCju/P3Z4tEoJXq9JwjsBYnG?=
 =?us-ascii?Q?EawLXnHs+4r1hMOl+KNM8CULIqQN6SNFXwSbFJNSC5Ep5tUKgH/d6Q77aVkU?=
 =?us-ascii?Q?slhCbAbBBEWsCqqqutkVNu5Ea/toZTun9SC/EBhs9WHKDuklpnKthuer+C0M?=
 =?us-ascii?Q?2/ZVHI8Ht/11B95IInBQ5y2T28hWip8A2uqtby0y5/LZBB6Px4YYvbFCaGHD?=
 =?us-ascii?Q?4L8RhrZnN2mMFfgY24bIyOcNW0+KHyILIpDi1pA6zry0OZj6IVLSZ+qPE7kA?=
 =?us-ascii?Q?AINepPwvaPcEUMeuDvaHpaSquBR/jBB4t+yE74q+etfvf/85efsZUjrdf7rh?=
 =?us-ascii?Q?5WikouVl0jZiTK+SeDxJcb7IRvXln8RN86kPzV0ZHbNAMKlKB+vH7BoluDbY?=
 =?us-ascii?Q?gZoxoGBmEflVqyFaIHBxI0b1M2CF78PlJ9aZNCVVvTZ/gmop/c+0bTxCNlzS?=
 =?us-ascii?Q?pboASWKAroapiX2lVopLZu/gEkjuG8l63Nmw+0HQoikLcqcgVAyM9txNEHi0?=
 =?us-ascii?Q?DfDAL7ZVmIz1SkkWJ9MoXUQtBnjn7JvRyKJ/YtXp90GtTe4cAB3+do6XEAmf?=
 =?us-ascii?Q?SzVXEq2S1I5JjIU0qIxf7mu5o6VJvZ/yVz0QD7Nr5IMBlpCWrhX6GF/+ZyRH?=
 =?us-ascii?Q?6KMQAEo/FVCxUnaS5ABbWsq/fvh7737GC4BGclRrOL1IJB/G3Fpo8rrVUbFK?=
 =?us-ascii?Q?3ZTsudO+gNxa0B6SwhFwnMu2RPBsmqloCFpi2TC20BhjdQxtN/V5kKz0q2wU?=
 =?us-ascii?Q?HH7ADYeyEFGP3yyydK+VqtAtN4sWFYNP6sEl28DDn8ln+/3et7UVmOjK7YwI?=
 =?us-ascii?Q?I3NCk9aBv47Y7Co3KmuQL26zMRI9hI9cjcgOuYBow6CxYymdwJU9e8fh/b2e?=
 =?us-ascii?Q?Z4UlISkPpO391k1Tut4aFFavcbiv9vEYVsE19S+656pnA409gDPiGfxOpNBA?=
 =?us-ascii?Q?U0PeBQj2d+MmtqhRoVXbc+TCadM02P66ZKDKapzAj8TSXPWv4uP8mcPyTktl?=
 =?us-ascii?Q?W+VEa+K0TUucpldpsceSrkOYjHOfBLMKS/REGD855nNVYLupHnMngtgSK/iA?=
 =?us-ascii?Q?iF7+RUTM4CO9UsZYApjKD67CBfaCXOWZ8/JU1U/hW8tRC+/VgOA40rdoicwP?=
 =?us-ascii?Q?hODX9alE4wuOuFYbBcdl0tHWtk0sBueDG0zIl5Xhq/5Kd2KA80GlOvyil8yW?=
 =?us-ascii?Q?QJubfFX5T+1Cja2Ngcf1+iiJKycRK0qWkIqBTgTNL2QBFVPp/B/XvBpVVwqM?=
 =?us-ascii?Q?w5sNghUZAmbIZfjIyLmI6wq6Sr7oUH+JbaO8dCz5bb4GAxsI1Z2RJtyKUevH?=
 =?us-ascii?Q?OYUlvhnjMW7QCGVnp4ymtmQBUSz3fByDGCyfToNAxer+MysBmP/PnwlpowXk?=
 =?us-ascii?Q?0aqLvevE+8U7rYDPlknWqeVolU+03cBHefqmrwh6LtXQ0Wz6VMNN85NsSZSk?=
 =?us-ascii?Q?BVfo5A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45db850b-b8c6-48bd-06b7-08db41aaa21f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 14:22:12.6047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aKUOkmStlFC5czVABmkXY0z2UIgwOa0imQ5+xfm3co8BqzZRSlLgkUlLhi/jHYZpl99qie3AEcDkocurZ29lBQY9oD14SgiNBFN43AkdjKY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR13MB4013
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 02:14:51PM +0300, Vladimir Oltean wrote:
> Current enetc_set_mm() is designed to set the priv->active_offloads bit
> ENETC_F_QBU for enetc_mm_link_state_update() to act on, but if the link
> is already up, it modifies the ENETC_MMCSR_ME ("Merge Enable") bit
> directly.
> 
> The problem is that it only *sets* ENETC_MMCSR_ME if the link is up, it
> doesn't *clear* it if needed. So subsequent enetc_get_mm() calls still
> see tx-enabled as true, up until a link down event, which is when
> enetc_mm_link_state_update() will get called.
> 
> This is not a functional issue as far as I can assess. It has only come
> up because I'd like to uphold a simple API rule in core ethtool code:
> the pMAC cannot be disabled if TX is going to be enabled. Currently,
> the fact that TX remains enabled for longer than expected (after the
> enetc_set_mm() call that disables it) is going to violate that rule,
> which is how it was caught.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
> v1->v2: none
> 
>  drivers/net/ethernet/freescale/enetc/enetc_ethtool.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
> index 838750a03cf6..ee1ea71fe79e 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
> @@ -1041,10 +1041,13 @@ static int enetc_set_mm(struct net_device *ndev, struct ethtool_mm_cfg *cfg,
>  	else
>  		priv->active_offloads &= ~ENETC_F_QBU;
>  
> -	/* If link is up, enable MAC Merge right away */
> -	if (!!(priv->active_offloads & ENETC_F_QBU) &&
> -	    !(val & ENETC_MMCSR_LINK_FAIL))
> -		val |= ENETC_MMCSR_ME;
> +	/* If link is up, enable/disable MAC Merge right away */
> +	if (!(val & ENETC_MMCSR_LINK_FAIL)) {
> +		if (!!(priv->active_offloads & ENETC_F_QBU))

nit: The !!() seems unnecessary,
     I wonder if it can be written in a simpler way as:

		if (priv->active_offloads & ENETC_F_QBU)

> +			val |= ENETC_MMCSR_ME;
> +		else
> +			val &= ~ENETC_MMCSR_ME;
> +	}
>  
>  	val &= ~ENETC_MMCSR_VT_MASK;
>  	val |= ENETC_MMCSR_VT(cfg->verify_time);
> -- 
> 2.34.1
> 
