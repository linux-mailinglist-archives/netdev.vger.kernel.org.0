Return-Path: <netdev+bounces-6805-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D1CC718359
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 15:50:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 861CE1C20E55
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 13:50:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C376C14AB6;
	Wed, 31 May 2023 13:50:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA81214A95
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 13:50:43 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C0871BE4
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 06:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685541023; x=1717077023;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=wKwgu2QYq2azhulY4Pb1xLoPWzZTBGRJL/CUkYCHj2U=;
  b=jokZmJsxEDV5NiDahYOL7CWSegEU19NtNDMPPMi5+5gv4rj8pfQKmhRY
   zDbxS5vkHq2STPhpUx3bs1gltcJKrxeWG91CgpG6Ps+XYc2izDlMB2se1
   xNd4z6ZkLEQDlo/r8hE9rLvT8qM1q3KF0XgOoUGask4uBZAiJZ3OUzNub
   hZdE/uJFBbJhmVa1tBwDBpor/y/QxJhS3v77Rz8AXsDJEw8nBb4C/19CO
   jyO5p3Jv6vTJAlB2BdRGGr3tWLrOrujxEcnBGuKYVsqS861zimzYFBrw5
   cJTwTrXo/hsYrPEv3kzAIi4ERTI12PfqV2r985VIOynD0cSOx2ssOpYWe
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="441596926"
X-IronPort-AV: E=Sophos;i="6.00,207,1681196400"; 
   d="scan'208";a="441596926"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 06:47:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="1037051649"
X-IronPort-AV: E=Sophos;i="6.00,207,1681196400"; 
   d="scan'208";a="1037051649"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga005.fm.intel.com with ESMTP; 31 May 2023 06:47:00 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 31 May 2023 06:46:59 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 31 May 2023 06:46:59 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 31 May 2023 06:46:59 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 31 May 2023 06:46:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N+h1wFyThz5MXhu3Ap91ew0bPesyoEV2F7LFyWvH8heRxcoP/X4Thn1kGLzjjA8xAgSxNJaepJbDOrlMrbka09RGrcHhkccYc/BRTTvJ1v9pki2WhFTI807m1Lh/7Yv9hVTB8+9BKYZkh9w/ZqJ+LBR2/i7PE8lV2PsXrOPQ5cpBdMSMqkETyCYGiwGd2XU7jxdGFLI8k48na4FewIhJmC4U3avIahLJNtGxQl9slVXlISYG0UMOXGKZgXmnZLyekogKwQhMF37Xis8BqYpiZZ/eAp9R6oNHUCNSh/f/qbHvIVTc2o/cxJz7ijLF5EVMgtKHjkfbSsDz27uBEshy5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gYmGzbe8LB9MMO/KPN90/nensm9eZ/RcG0yWD7eQswE=;
 b=irl9PGgJ1CfZgH0cHxvIH2iIJjVL17KweHolIjg2QKCYRlU2BlJ6xSxYl0SPwJTw5eiXghVyC+SGfiaJPYBmcxn4lb5sV2Fv8d0iOB8bfuIwrqzb2ypBPTtM23AqvJWiiTzWKp168hOBmya8DCA6Bfl6rv43uxOUptxwU3pCSs5rUI/MnekfjYm57qgw9TLkmorWuU//JWao2dViKEhoFMOqH1m+Ek6tS58Z0IlgGlh7eyc2kPEjQ5LeEOFiSFRg5jhh2A2Lm0dA0wNKLTC3lR8/bti23OFapDOmxXADYglXz3BAADtUf18N3lfejD9FiEjsy2CjF5ayP4RW54KD8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 CH3PR11MB8344.namprd11.prod.outlook.com (2603:10b6:610:17f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Wed, 31 May
 2023 13:46:57 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 13:46:57 +0000
Date: Wed, 31 May 2023 15:46:50 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Przemek Kitszel <przemyslaw.kitszel@intel.com>
CC: <intel-wired-lan@lists.osuosl.org>, Jesse Brandeburg
	<jesse.brandeburg@intel.com>, Tony Nguyen <anthony.l.nguyen@intel.com>,
	Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>, Victor Raj
	<victor.raj@intel.com>, Michal Swiatkowski
	<michal.swiatkowski@linux.intel.com>, Jacob Keller
	<jacob.e.keller@intel.com>, Martyna Szapar-Mudlaw
	<martyna.szapar-mudlaw@linux.intel.com>, Michal Wilczynski
	<michal.wilczynski@intel.com>, <netdev@vger.kernel.org>, Simon Horman
	<simon.horman@corigine.com>
Subject: Re: [PATCH iwl-next v2] ice: remove null checks before devm_kfree()
 calls
Message-ID: <ZHdPymD0+9JbqlCp@boxer>
References: <20230531123840.20346-1-przemyslaw.kitszel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230531123840.20346-1-przemyslaw.kitszel@intel.com>
X-ClientProxiedBy: FRYP281CA0007.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::17)
 To DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|CH3PR11MB8344:EE_
X-MS-Office365-Filtering-Correlation-Id: f9dc2e67-8913-4a58-1ead-08db61dd803b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YLboOzFRkeMMr1tk92Veu640VYsebwpJDF7rREjzGDoViFlct1+t/LVs837SqYflSRHeZDpLU69EAK+mrb/J5fyJ4/h7LMPHD3+A+XdKZut2LALgze46I+G2dh2+ORVNPScwB2DRL33yJwHzlZFj66INdOfJNPoulzBHElQxv2qxA/X4RZRLP/TJJkkdkevhOH4W8JNsUQqg4gAq0+cMFH+DJx4nfxzApXCKgPq10+vV2/N4GHYZRaYxNgCXOiSJYWanvU9eieC7dIvDX4Qn9/+LI5ZMEukucP7ey4s+BUtfeGQSc+iWI5n0fuVrMAmMhaLXrWsCHRPkE/sLJHHe5zFXkwbGlbIBlVRgZyS5w+C77Skb0YjjkyZ5eyVWVXg0Dffvl+f0J7kj2fuVv0ZFW1G1ZR+3wS1pE7z20eMfgamMGzVPSp5+2KCJzmZXyTpw78ycWFh5AS66DcUW6EpkHyAnezsLnilfAA2x0MjBscL3azZRcyT7rFFStAXvvE2waUoRI3pNBMmxyYWHjov2qSVI/SNDzXCs17xCOBDc8MBk8XMcn5ZbYx/C2EXUqYAmn/IXuMjUcjuwBqgOYelFme+8nu5/VpMCoZN3liowKU0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(39860400002)(136003)(366004)(376002)(396003)(451199021)(6636002)(66556008)(66476007)(66946007)(4326008)(5660300002)(86362001)(478600001)(6486002)(41300700001)(8936002)(8676002)(6862004)(44832011)(54906003)(6666004)(6506007)(316002)(6512007)(26005)(9686003)(66899021)(33716001)(186003)(83380400001)(2906002)(38100700002)(82960400001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QxHa2jbAlVrkV9bo4msYRrza9P16FxfBYO5m/EdaqvRkfuq9RtGXQoy7s6d1?=
 =?us-ascii?Q?EFIWYbU1sGcWLWb45whTSkVia5RyaYUJFLoxP/TDzvMR8jnQU0Oqm+a0s9GY?=
 =?us-ascii?Q?8Ej+v9dKuZA1/ptXuI7BsCm21cDkwWzIe9fu7TqUmAahX4+uLtwm+z0dPGma?=
 =?us-ascii?Q?mppIyWQ5YMar5t82tiwb4rtOt0J+tG5EN5fRwVN+nZZXLnQpkyw61AldT8wp?=
 =?us-ascii?Q?ubyAHTRQujrM6ZFeovW1VN7KRgIST5ZpqdIgAEat0y8mWj2wfAolU79Q5iGZ?=
 =?us-ascii?Q?HWQo51whbOTJ3lVOEKGQX6gxIADhWonXi2XZf/tlXdoj/tLfue+5awUxQAUt?=
 =?us-ascii?Q?TCk90ROij5aa5eUzVMfPR4b3CM84ts2LPou4Wnb2L1wa9ooSIpitMfmLXg9s?=
 =?us-ascii?Q?xKX5VHzIGG66gGYk36JVohBxraDa5On43Ehdq5HXP/L2eKsjFdFAi87IEBmA?=
 =?us-ascii?Q?5JlNLrqBoxy1UQ+OASZaIUpkOOK1G0iJ46IWQZ/hkxOVuZq09KtK9HxH2nsF?=
 =?us-ascii?Q?c5fyaxAXe9uh+1p8K2e0mqCSYInYFG38WlwQ3+q/Xoj1SVkNLv4GNX94mV9n?=
 =?us-ascii?Q?a1wUKHwD1dvi+DZM6r7j7ma4zea0oaoYzzKFxmXrC+CoVU5pLOSkCiY7Fhl/?=
 =?us-ascii?Q?bCCzOOh6E1CtPu06dbGBbZrntiGZgRtptx0K3zpyHwcMsxzIpXpohoiW1E5W?=
 =?us-ascii?Q?+iIjb211arLhSIRV5EgaK2ZBjuviqna2uPTTX5Jt4aVwZ0qZIYVuubgPnD/k?=
 =?us-ascii?Q?i9+Vab5ZjP0c9GdpXr/T3SKO6gxv2M2YUEJEZl81deA57ANDZKidBNbfi/iD?=
 =?us-ascii?Q?nIUJdQYU9BZgx6loB0V70wPowm7dkpSeFKJlywr/w6/s9JVzjWDdnR/ZswHG?=
 =?us-ascii?Q?j4SV5foxPbqCcdjYzrTaBl/qG3Bk+byFFZfTHkAFR0sQhnYew7ajuBpO32gb?=
 =?us-ascii?Q?IcXz9r7LEsfjDNdN9qOB/P+KErVLZOZIlQVQjeApvZAmIGGVit0eW9wAdiLS?=
 =?us-ascii?Q?j8SJYFvFsVpzf2qsZ6HmKSh5QCZ++BgySpK4lXiWNkoTQyzbJWex9DmcAYIu?=
 =?us-ascii?Q?UmEMu4kabUswsPQNLnWYim5E7o3jepjWqeJ/Hi3xxkKNH2qQDeZG1HXhqksO?=
 =?us-ascii?Q?/inLyR3Z+DBF2CJAqEuxswfDtHd2m8ngJvJgBZ5oz+hs+yO7CXDcDFoDhNah?=
 =?us-ascii?Q?bhV8AIqdvIhiMxX4sOX/QMss6RG1Ym+PVvFm6rD2kHZi2I3TJ6xWbR9CMzbY?=
 =?us-ascii?Q?ygz9OMjxDnU1xXm2dn8nCz5JYmRNUTJQwXI+BgpHL4ukqNnlALdXL+c5j4T0?=
 =?us-ascii?Q?8NvYh16rQXgI60KlS9BZ32BK5EzAdsj+3mol4Txx2SwYqJsI/1xBbIEY+Rbp?=
 =?us-ascii?Q?wACDgwCI0az2HJUUCl9o8tYX5jwz83dCyd8Mfhg3a9Hm1G4yS93lEcCqTEeJ?=
 =?us-ascii?Q?4f3wbwgXAU/HfdcFJ08ntJJUYo2ckwVOhZdncNaOrzh8gfKSunCfcz2TRPyQ?=
 =?us-ascii?Q?86rnV09s2+1fS1fdtksAyUCpF3YyDg8u/9pa2e6GKC7ZOCKA1Ki9e1PiuLBs?=
 =?us-ascii?Q?1+ZyPuAUoj7zutNbpaOvTl5NHtIObJVYlog8oRYHEvepwhCcHAY5hm63wGBY?=
 =?us-ascii?Q?MQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f9dc2e67-8913-4a58-1ead-08db61dd803b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 13:46:57.1583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qLc1w/es1WgpiDxmS/EGp42vIXTFAtrgDL0mrr95RvXEW42GTO0jYeT2NRXvmfuhO0hsGcG+EMQLS78PEgy6v//eoWg33PJHHbJKCuoDiv4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8344
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 02:38:40PM +0200, Przemek Kitszel wrote:
> We all know they are redundant.
> 
> v2: sending to proper IWL address

such versioning should go below '---' so that will be stripped after patch
got applied. This would look weird to have that later in the tree.

> 
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Reviewed-by: Michal Wilczynski <michal.wilczynski@intel.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_common.c   |  6 +--
>  drivers/net/ethernet/intel/ice/ice_controlq.c |  3 +-
>  drivers/net/ethernet/intel/ice/ice_flow.c     | 23 ++--------
>  drivers/net/ethernet/intel/ice/ice_lib.c      | 42 +++++++------------
>  drivers/net/ethernet/intel/ice/ice_sched.c    | 11 ++---
>  drivers/net/ethernet/intel/ice/ice_switch.c   | 19 +++------
>  6 files changed, 29 insertions(+), 75 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
> index eb2dc0983776..6acb40f3c202 100644
> --- a/drivers/net/ethernet/intel/ice/ice_common.c
> +++ b/drivers/net/ethernet/intel/ice/ice_common.c
> @@ -814,8 +814,7 @@ static void ice_cleanup_fltr_mgmt_struct(struct ice_hw *hw)
>  				devm_kfree(ice_hw_to_dev(hw), lst_itr);
>  			}
>  		}
> -		if (recps[i].root_buf)
> -			devm_kfree(ice_hw_to_dev(hw), recps[i].root_buf);
> +		devm_kfree(ice_hw_to_dev(hw), recps[i].root_buf);
>  	}
>  	ice_rm_all_sw_replay_rule_info(hw);
>  	devm_kfree(ice_hw_to_dev(hw), sw->recp_list);
> @@ -1011,8 +1010,7 @@ static int ice_cfg_fw_log(struct ice_hw *hw, bool enable)
>  	}
>  
>  out:
> -	if (data)
> -		devm_kfree(ice_hw_to_dev(hw), data);
> +	devm_kfree(ice_hw_to_dev(hw), data);
>  
>  	return status;
>  }
> diff --git a/drivers/net/ethernet/intel/ice/ice_controlq.c b/drivers/net/ethernet/intel/ice/ice_controlq.c
> index d2faf1baad2f..e4cb5055b999 100644
> --- a/drivers/net/ethernet/intel/ice/ice_controlq.c
> +++ b/drivers/net/ethernet/intel/ice/ice_controlq.c
> @@ -339,8 +339,7 @@ do {									\
>  		}							\
>  	}								\
>  	/* free the buffer info list */					\
> -	if ((qi)->ring.cmd_buf)						\
> -		devm_kfree(ice_hw_to_dev(hw), (qi)->ring.cmd_buf);	\
> +	devm_kfree(ice_hw_to_dev(hw), (qi)->ring.cmd_buf);		\
>  	/* free DMA head */						\
>  	devm_kfree(ice_hw_to_dev(hw), (qi)->ring.dma_head);		\
>  } while (0)
> diff --git a/drivers/net/ethernet/intel/ice/ice_flow.c b/drivers/net/ethernet/intel/ice/ice_flow.c
> index ef103e47a8dc..85cca572c22a 100644
> --- a/drivers/net/ethernet/intel/ice/ice_flow.c
> +++ b/drivers/net/ethernet/intel/ice/ice_flow.c
> @@ -1303,23 +1303,6 @@ ice_flow_find_prof_id(struct ice_hw *hw, enum ice_block blk, u64 prof_id)
>  	return NULL;
>  }
>  
> -/**
> - * ice_dealloc_flow_entry - Deallocate flow entry memory
> - * @hw: pointer to the HW struct
> - * @entry: flow entry to be removed
> - */
> -static void
> -ice_dealloc_flow_entry(struct ice_hw *hw, struct ice_flow_entry *entry)
> -{
> -	if (!entry)
> -		return;
> -
> -	if (entry->entry)
> -		devm_kfree(ice_hw_to_dev(hw), entry->entry);
> -
> -	devm_kfree(ice_hw_to_dev(hw), entry);
> -}
> -
>  /**
>   * ice_flow_rem_entry_sync - Remove a flow entry
>   * @hw: pointer to the HW struct
> @@ -1335,7 +1318,8 @@ ice_flow_rem_entry_sync(struct ice_hw *hw, enum ice_block __always_unused blk,
>  
>  	list_del(&entry->l_entry);
>  
> -	ice_dealloc_flow_entry(hw, entry);
> +	devm_kfree(ice_hw_to_dev(hw), entry->entry);
> +	devm_kfree(ice_hw_to_dev(hw), entry);
>  
>  	return 0;
>  }
> @@ -1662,8 +1646,7 @@ ice_flow_add_entry(struct ice_hw *hw, enum ice_block blk, u64 prof_id,
>  
>  out:
>  	if (status && e) {
> -		if (e->entry)
> -			devm_kfree(ice_hw_to_dev(hw), e->entry);
> +		devm_kfree(ice_hw_to_dev(hw), e->entry);
>  		devm_kfree(ice_hw_to_dev(hw), e);
>  	}
>  
> diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
> index e8142bea2eb2..c3722c68af99 100644
> --- a/drivers/net/ethernet/intel/ice/ice_lib.c
> +++ b/drivers/net/ethernet/intel/ice/ice_lib.c
> @@ -321,31 +321,19 @@ static void ice_vsi_free_arrays(struct ice_vsi *vsi)
>  
>  	dev = ice_pf_to_dev(pf);
>  
> -	if (vsi->af_xdp_zc_qps) {
> -		bitmap_free(vsi->af_xdp_zc_qps);
> -		vsi->af_xdp_zc_qps = NULL;
> -	}
> +	bitmap_free(vsi->af_xdp_zc_qps);
> +	vsi->af_xdp_zc_qps = NULL;
>  	/* free the ring and vector containers */
> -	if (vsi->q_vectors) {
> -		devm_kfree(dev, vsi->q_vectors);
> -		vsi->q_vectors = NULL;
> -	}
> -	if (vsi->tx_rings) {
> -		devm_kfree(dev, vsi->tx_rings);
> -		vsi->tx_rings = NULL;
> -	}
> -	if (vsi->rx_rings) {
> -		devm_kfree(dev, vsi->rx_rings);
> -		vsi->rx_rings = NULL;
> -	}
> -	if (vsi->txq_map) {
> -		devm_kfree(dev, vsi->txq_map);
> -		vsi->txq_map = NULL;
> -	}
> -	if (vsi->rxq_map) {
> -		devm_kfree(dev, vsi->rxq_map);
> -		vsi->rxq_map = NULL;
> -	}
> +	devm_kfree(dev, vsi->q_vectors);
> +	vsi->q_vectors = NULL;
> +	devm_kfree(dev, vsi->tx_rings);
> +	vsi->tx_rings = NULL;
> +	devm_kfree(dev, vsi->rx_rings);
> +	vsi->rx_rings = NULL;
> +	devm_kfree(dev, vsi->txq_map);
> +	vsi->txq_map = NULL;
> +	devm_kfree(dev, vsi->rxq_map);
> +	vsi->rxq_map = NULL;
>  }
>  
>  /**
> @@ -902,10 +890,8 @@ static void ice_rss_clean(struct ice_vsi *vsi)
>  
>  	dev = ice_pf_to_dev(pf);
>  
> -	if (vsi->rss_hkey_user)
> -		devm_kfree(dev, vsi->rss_hkey_user);
> -	if (vsi->rss_lut_user)
> -		devm_kfree(dev, vsi->rss_lut_user);
> +	devm_kfree(dev, vsi->rss_hkey_user);
> +	devm_kfree(dev, vsi->rss_lut_user);
>  
>  	ice_vsi_clean_rss_flow_fld(vsi);
>  	/* remove RSS replay list */
> diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
> index b7682de0ae05..b664d60fd037 100644
> --- a/drivers/net/ethernet/intel/ice/ice_sched.c
> +++ b/drivers/net/ethernet/intel/ice/ice_sched.c
> @@ -358,10 +358,7 @@ void ice_free_sched_node(struct ice_port_info *pi, struct ice_sched_node *node)
>  				node->sibling;
>  	}
>  
> -	/* leaf nodes have no children */
> -	if (node->children)
> -		devm_kfree(ice_hw_to_dev(hw), node->children);
> -
> +	devm_kfree(ice_hw_to_dev(hw), node->children);
>  	kfree(node->name);
>  	xa_erase(&pi->sched_node_ids, node->id);
>  	devm_kfree(ice_hw_to_dev(hw), node);
> @@ -859,10 +856,8 @@ void ice_sched_cleanup_all(struct ice_hw *hw)
>  	if (!hw)
>  		return;
>  
> -	if (hw->layer_info) {
> -		devm_kfree(ice_hw_to_dev(hw), hw->layer_info);
> -		hw->layer_info = NULL;
> -	}
> +	devm_kfree(ice_hw_to_dev(hw), hw->layer_info);
> +	hw->layer_info = NULL;
>  
>  	ice_sched_clear_port(hw->port_info);
>  
> diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
> index d69efd33beee..49be0d2532eb 100644
> --- a/drivers/net/ethernet/intel/ice/ice_switch.c
> +++ b/drivers/net/ethernet/intel/ice/ice_switch.c
> @@ -1636,21 +1636,16 @@ ice_save_vsi_ctx(struct ice_hw *hw, u16 vsi_handle, struct ice_vsi_ctx *vsi)
>   */
>  static void ice_clear_vsi_q_ctx(struct ice_hw *hw, u16 vsi_handle)
>  {
> -	struct ice_vsi_ctx *vsi;
> +	struct ice_vsi_ctx *vsi = ice_get_vsi_ctx(hw, vsi_handle);
>  	u8 i;
>  
> -	vsi = ice_get_vsi_ctx(hw, vsi_handle);
>  	if (!vsi)
>  		return;
>  	ice_for_each_traffic_class(i) {
> -		if (vsi->lan_q_ctx[i]) {
> -			devm_kfree(ice_hw_to_dev(hw), vsi->lan_q_ctx[i]);
> -			vsi->lan_q_ctx[i] = NULL;
> -		}
> -		if (vsi->rdma_q_ctx[i]) {
> -			devm_kfree(ice_hw_to_dev(hw), vsi->rdma_q_ctx[i]);
> -			vsi->rdma_q_ctx[i] = NULL;
> -		}
> +		devm_kfree(ice_hw_to_dev(hw), vsi->lan_q_ctx[i]);
> +		vsi->lan_q_ctx[i] = NULL;
> +		devm_kfree(ice_hw_to_dev(hw), vsi->rdma_q_ctx[i]);
> +		vsi->rdma_q_ctx[i] = NULL;
>  	}
>  }
>  
> @@ -5486,9 +5481,7 @@ ice_add_adv_recipe(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
>  		devm_kfree(ice_hw_to_dev(hw), fvit);
>  	}
>  
> -	if (rm->root_buf)
> -		devm_kfree(ice_hw_to_dev(hw), rm->root_buf);
> -
> +	devm_kfree(ice_hw_to_dev(hw), rm->root_buf);
>  	kfree(rm);
>  
>  err_free_lkup_exts:
> -- 
> 2.38.1
> 
> 

