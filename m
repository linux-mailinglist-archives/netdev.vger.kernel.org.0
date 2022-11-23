Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9C1363634C
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 16:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236897AbiKWPWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 10:22:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238802AbiKWPWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 10:22:09 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59444920B6
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 07:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669216928; x=1700752928;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=tLMSEJ2fh8YOQrVLJdBhmOV6ZlIYVIo1NOfap8xt6lo=;
  b=UpDeVuFkTha3ZFV3q1B+AhBXhFGxgAEhyBKK1/F1Z8AJnO3AVn2SrXNe
   vCHkU9V9/7jzmfC0t8LrnaSqA5e5Y8rrVejWac/4uFlyguYq9nGMNjp/s
   UTcO4u2dUfTQTT6tKkYb44xNIg+N8fYeIZP0t0/hc3Aee8EMnfasuCC9K
   itunCt22rDUAzuZjhUOrwj3+9CoDlqE6rEa1xcE93KKI80dKzxFQfItC3
   DIwILtazykCvTBeSUc0AMUWqQq0Fx73pmx2pQGeHb/EGAtB2i2ubGH6TF
   aujAb0enlsyZUTN5jtXF0D6AnyJXg1kQjVGIJdjXdOPsyLyf+MjE2BWLo
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="311718464"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="311718464"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 07:22:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="747829735"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="747829735"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga002.fm.intel.com with ESMTP; 23 Nov 2022 07:22:07 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 07:22:07 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 07:22:06 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 23 Nov 2022 07:22:06 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 23 Nov 2022 07:22:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L412/MDEisKaRYDOFcqHaRU0KyIdzRjdmmaX7NAte07fqgUzkC/MCXUhPc/QViTf5kzZ55A0Sfnatp7Y1PiTAJBS4DSemZKDWfExWub+RJmy1BDSCXL9v6IkA2KhFV5g7ebYROVgypPC8oMuo6F0dUrEjHVuvSNNrfCL1xHNrlvgv9qKCTW8gggy8H1D7rg3OYJyitP4XTGGUrZTjWxEI+jSO2Gqd95D77tHSHUNohA5R6gTbKGZBs7u+WmZjtJXB2A3ZCrnsdPhUbqn0bXQU95c2cBq4QiobT+kf2lE9xjAfcOrsHznEO2skAYSxgoDGrBYHtBQjP2zWLEEXPw6TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z85HYUkB73IP7HnFgeD9+HkQ/U7vXQEdmCWkQBoFTPs=;
 b=NYv25x/6rcXlWv4wyllePjchx3RDOZ9evFW3raDR8LyBkpMR9o7LgWIWAnF8fRkp0CTnj4vKT4ZS/zlrdjvuduALsD1N/dIiks5RH7NQT8kiNUkVxzb+wD5kXzc8/kw+xGRT4g9Ii1pRWhXRU6oJAH53U96r4yCaMVTPDMbB170/aVUdeIJ3GCb571Q7VAJNWFL1FtQkebLgsI9O1oXZxe8tk7XGI4aRDWiL1LPKSHeTDQTkHMX3F2YFq9ynXQOaKc/WUXaUqM9R0qcKLC1zBEwO0WFUEcv2N7Lhvx6/VLxUFIyCQKq0oPP1zniMUeCgQyN91Z28fcWG2DR7PPEDag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 CH0PR11MB5705.namprd11.prod.outlook.com (2603:10b6:610:ec::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.18; Wed, 23 Nov 2022 15:22:05 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%6]) with mapi id 15.20.5834.009; Wed, 23 Nov 2022
 15:22:05 +0000
Date:   Wed, 23 Nov 2022 16:21:50 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Saeed Mahameed <saeed@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>, Raed Salem <raeds@nvidia.com>
Subject: Re: [net 13/14] net/mlx5e: Fix MACsec update SecY
Message-ID: <Y346jo+YByPirHSm@boxer>
References: <20221122022559.89459-1-saeed@kernel.org>
 <20221122022559.89459-14-saeed@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221122022559.89459-14-saeed@kernel.org>
X-ClientProxiedBy: FR2P281CA0170.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:99::19) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|CH0PR11MB5705:EE_
X-MS-Office365-Filtering-Correlation-Id: ded1b519-3f6a-47d0-c9b2-08dacd667a5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aZCNR0B1dLSHddz2AQ4jluCI1nDyfe4wRN70mkTRdZbejfT3n+Ro/hxHaZ1OYlvKF+55vmkJRiPKRZzfHZ4K4MGK8lRKJsAb4LDrnUTtq/0Mb5zHBrb70Ka2x25WICTbDHQ1C4iRYUKfTl/2sF+oj8BSvUqumVoUepMp/CeLjXl7xZ8yIzrhMpq0PMwsBzDMB4bA1ji2cuc0KCJqtow7riFvGnPsjYgeq20Ivi5995vbilVc2azY31quMQlI78kH5Vjhauu/FIKjBfdnPzdN1//Bcps1I0JzBXf5e34mGxTdYkDkmTZijvUmK//bKHYtZg2sU4L2a0aOei3lhrTGpUdZCm8gAoxSv5+ZbXb4QcOenj5ubkGTCN/dgk82oRBH3lYYFcuJwcTirmenRqT7JkbnkErEY+vN5uhas6JHIl+NoQEIX+lqVcNREzYV5QIVGh2t891yuv3wuCRn24LBsdjlFyTSMJ7RbpVU861PD/skT/WMxOsUjantqRQ9Jhjw35JJy5Mn70yq1WhLfwpVT1owdfL9hJJ9MYOMUOATNTo8wWb/mfAsnXJwWEAvw2px1byuYG8hzw3mNkkaBjrBH56dPJYjKhSx8+ZeMlzg4Q1tYrONlwxBb6D8iCbL1W1MM+HoJjqVHIZA1Cmrr/g0m2acamvDqohBKXDcQoXw77irj3Eypu/IiR1xhSAhrnCh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39860400002)(366004)(396003)(136003)(346002)(376002)(451199015)(38100700002)(82960400001)(86362001)(33716001)(26005)(66946007)(4326008)(66556008)(8676002)(66476007)(6916009)(186003)(316002)(44832011)(7416002)(5660300002)(54906003)(2906002)(15650500001)(41300700001)(8936002)(83380400001)(6666004)(6506007)(478600001)(6486002)(9686003)(6512007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7My13ea2f0nPLZ3ZsfOv4lZngXeMfvmR8YBg88l8QyEB6WDkntLqDNA779MR?=
 =?us-ascii?Q?/mVQUh3NcO3ax1HdbR5SG2EASt8u6aRBbylZb2mi/tEgkeed+F2Bb8bhzokN?=
 =?us-ascii?Q?C0S6/EYp4yr7ezVKLKuXYZTwB7tyft6nXZpNRiBbVgpOumEnshALUw6vtA9s?=
 =?us-ascii?Q?hK2fiX0OJLDCMDxZ39kM6AKap85WClYqTTtu0lwjXzvEvyfj2IkVP7rgaFEK?=
 =?us-ascii?Q?i7Zgmb7a1or0+N79wo7KF7K4Fn1FwLO1G9bm8yyQ755QHePb9cKmj1CRKuQe?=
 =?us-ascii?Q?MHbXLSfyjP5uT5KFHbWWVB3pX609GSPYJjPLfhzwurZDRdqXs7GheL4VUSzS?=
 =?us-ascii?Q?jiCjedFXWNN515jpVVOno9+gh6cjJnMI5cZzkf+gjgHHrzWSfPgnp2q0l1WM?=
 =?us-ascii?Q?HpET8/JshMDfzZy7N0wkF8f/+EwOlCMYQRsDVX4194Q4OAY6nlvlajGPcRnA?=
 =?us-ascii?Q?7bnMlOsoVkOWlRbuXhtDeu4Z0yNiQV6eDTxsZOz8wNm7qehOhVE9iied/Ysr?=
 =?us-ascii?Q?VoE2NGPriBjdZiB2yh6klXSpSyOH7wB97aPWIZ2QUldmWAMDE5AKR1/XPxWd?=
 =?us-ascii?Q?gM1Moej/bZCVeTZ/p9fs6YSijgTJEXtLMPZTYfF+QktrdgtySrkI7UI2ncqC?=
 =?us-ascii?Q?qJiz8MrBKZ86yQrFeDJfkqA53rL3V2B42eFpraATd/eI/2h27QLFmaM7/tze?=
 =?us-ascii?Q?7wC4p+4L//YBBnmmEni90U1sNjj/klyfWiXNhcybp3VdoG299ZbiPnfjxjW+?=
 =?us-ascii?Q?MOAv+iqTP19uZU3AfOl0GLh8X+03/F/foqxLZmcluMAvvUZKxDKioO2uu/IZ?=
 =?us-ascii?Q?xSszW7ZZM+rnO1+C2Z91CgztjjCOYaavwCkVN0ry9ejsKBbCZeZegv0km09n?=
 =?us-ascii?Q?Nt4EY0L2fmVonlF7/81KILxJq/+BQfzC7aMpCiq/RvmB015dJNQ+ydLrt0KX?=
 =?us-ascii?Q?rm1Nlqar3GWWqwJNwvVC2PZwNWCiAdxvjK48AMHvPm7dgCjksfoFnJ6N+Wk/?=
 =?us-ascii?Q?tFyWlQkrdn/n7atemoSr9qbkdWkVF5N1PqBXX4Z6JcR8T5YkE+vKwAeC2Vcy?=
 =?us-ascii?Q?nfvYUTYIXOsii21nxunbwKZPil9tIk4hxmxOEcgKoPaKsHZai59WvrRSugmP?=
 =?us-ascii?Q?cGhT7ZCMV34xMaR5HiACgxadowVzTvwj4Zaykhxy30W4b1jvVCkoIHTyTAVa?=
 =?us-ascii?Q?pA/W0/5BD1SG/zGynoP2lcZjl4Ss8BuKtDA0j5Q1Le/0il79ZC7N2Uaj0hcl?=
 =?us-ascii?Q?BnyqgZbtJWiUGTVuXOD105vpBKgSXx4SRE9zMh0V12LVgob36RgqaXy0OnMC?=
 =?us-ascii?Q?3xGLp63ZOACx2jXVjp/bAC+qPcIZSNA3jlOKDeIh+KK41+cjt2I6CqMP1bIP?=
 =?us-ascii?Q?tAYkcHypd00p7Fyv1TNvSXhKsdzpnyoFTQZPJqI6d4agwwmAtEyOy15XhFZd?=
 =?us-ascii?Q?P/C/WZor/8RXoJ2RbeVdarcL6YPsjCjA2WHhfDSWVUuLgHDW2hgsHQQlciw1?=
 =?us-ascii?Q?u3UvWwzKt5DuyKneRYG5bmBYcO55TFOZgUcjoSE8lWLZTxqg6Gph1vnqKoDh?=
 =?us-ascii?Q?79rIbGUDpmRiF0XiiLYqGrmruoyECDjfAWotOhFskxPHg76md1kR7tZNWEZK?=
 =?us-ascii?Q?8w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ded1b519-3f6a-47d0-c9b2-08dacd667a5c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 15:22:05.1012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V++7BmYiujEpL08o72TcRrtUuGR+fk374d8UDy26lzXs4hUL9KKDK2J6gfW//51Si1HWBBFSVZdfRmc/ykLYClWd68FyTAFyS5XoWbjKFEA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5705
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 06:25:58PM -0800, Saeed Mahameed wrote:
> From: Emeel Hakim <ehakim@nvidia.com>
> 
> Currently updating SecY destroys and re-creates RX SA objects,
> the re-created RX SA objects are not identical to the destroyed
> objects and it disagree on the encryption enabled property which

nit: disagrees?

> holds the value false after recreation, this value is not
> supported with offload which leads to no traffic after an update.
> Fix by recreating an identical objects.
> 
> Fixes: 5a39816a75e5 ("net/mlx5e: Add MACsec offload SecY support")
> Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
> Reviewed-by: Raed Salem <raeds@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> index 8f8a735a4501..4f96c69c6cc4 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> @@ -1155,7 +1155,7 @@ static int macsec_upd_secy_hw_address(struct macsec_context *ctx,
>  				continue;
>  
>  			if (rx_sa->active) {
> -				err = mlx5e_macsec_init_sa(ctx, rx_sa, false, false);
> +				err = mlx5e_macsec_init_sa(ctx, rx_sa, true, false);
>  				if (err)
>  					goto out;
>  			}
> -- 
> 2.38.1
> 
