Return-Path: <netdev+bounces-10093-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 390A672C2E1
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 13:35:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E8AB1C20B13
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:35:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32CD91800C;
	Mon, 12 Jun 2023 11:35:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD9B11C99
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 11:35:07 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3663C2B
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 04:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686569702; x=1718105702;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=evGF+ITgE6OUkzapl2ZT+ozzQzhmP/sr/PBhIzB13sM=;
  b=XtMDcUs/KU79C9uW62zIjAIn/E7UOHBvqm+m3p9TjdODVvmJzjfblK1h
   JdryBTKKzSoRoZ3rXZPH0BV56jG+0Z5hk0z8uYZxC30Kx+LnayUrcHh4y
   SwnSVRVORdsW63CTvSTu1DrLVHWQbRkkgOf0WnkpiMhycLup7AcHb2vYF
   Zk+18wvyay17YowCmtGKxKuoqkbVpanI96Mk94H5cYqFr1im3wWT1EIr+
   Z3RIYm43oi+UrxlP9RcaErq3on+wXGUOK0ETS4I94o+R0uy9MbvTE9h6v
   aP7WXLqh9A7UG3oNUTTbG7AWfPXuXzHpaozroRzUduAPPcEehRtGM8C5j
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="355513455"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="355513455"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 04:35:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="711161144"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="711161144"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 12 Jun 2023 04:35:01 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 04:35:01 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 04:35:00 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 12 Jun 2023 04:35:00 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 12 Jun 2023 04:35:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IA+sb7rYBkcQP2KczJGzPLhiLfTw4cc3vrHCuowoVnGBah6LVP6DOiDW4RUMuvSL33AF54ZqPkJiDs40vQRG6vs99DpAqsk6o/V+IlDXjPAkN8IQ/c+j4rs8+V+jXYBCbnHvtj2jEQd9FGl5dazu9NjU9L//Q+B2e+N+CEnO7X5kRcMx0Qu3iOOjIqQEAg/lGjRdnaawyuE3yASlVqW4EWFPZFB8kV6RrN/vTU/vrZeP7tPD21i7XrEmQDjzQflncnU0BnQyLY3NPZBsfNoAkQ6MDgzlpymAwdHwififSHmqU4DPoU1TxFf/vFG12Ghhl4DPcMxGYEPvMluQEOvBnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CkYXUGR5MnG8/AT+uqyiseQGhFQ8YJGHxBtXCq+rucs=;
 b=Ur9wDB8u4yb58u+SchNf1L3ic7L193HoKBr2ccMuzfuIx9Z+9WlgTliStin9gYSPp6S9R14CQtcFKleXaWkOC+Ppx/s1z+heYxhj+JtcNhf6wvZqfjS42E1/lezmwtZ3/wm43ByBxbzv52Z6UZd+n1ewyosWKrgGme4x4GwLptMJZEblJKxK8rQ3U2g+tI0AV8TglSS3nt9QvGi80g7IkfSEetOnUbYOJAk2LqwC0c3LyKKSXtAau/toTU8qPSBHTp3AjzvJrXaLeHmLNNUAfGIr17ywHaKuMPTyHHsW5MFgDOyGiz9fIoRPt+rlXdeLPskq+2cAwLWUQ69o3g4Aew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 BN9PR11MB5531.namprd11.prod.outlook.com (2603:10b6:408:104::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.46; Mon, 12 Jun
 2023 11:34:58 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6477.028; Mon, 12 Jun 2023
 11:34:57 +0000
Date: Mon, 12 Jun 2023 13:34:49 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Leon Romanovsky <leon@kernel.org>
CC: Asmaa Mnebhi <asmaa@nvidia.com>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<netdev@vger.kernel.org>, <cai.huoqing@linux.dev>, <brgl@bgdev.pl>,
	<chenhao288@hisilicon.com>, <huangguangbin2@huawei.com>, David Thompson
	<davthompson@nvidia.com>
Subject: Re: [PATCH net v2 1/1] mlxbf_gige: Fix kernel panic at shutdown
Message-ID: <ZIcC2Y+HHHR+7QYq@boxer>
References: <20230607140335.1512-1-asmaa@nvidia.com>
 <20230611181125.GJ12152@unreal>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230611181125.GJ12152@unreal>
X-ClientProxiedBy: FR3P281CA0119.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a3::19) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|BN9PR11MB5531:EE_
X-MS-Office365-Filtering-Correlation-Id: c3c6fccc-7ca2-4de9-c1c5-08db6b390c8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qxi1J9XKAj41SO+2Kd7yObge/cFAFLoXQF/FBieZwIW5aKxWjGRdsziJ4Fx13OiZmVbnMGp18bhL6gxCzIJcmMRwvwkk1sBVDB/wuxBR4iTZNZ4+/Rqi4Ltu0ZVKmOHzVxm+PfuUN2FHh1jUXMFJCps+k+I7MBlX8i60biGgkPYYBnLupx7Z8VdXghXZHmrCa3NFCGJfyeGRwhZ6v2yV2U81U4B2aiJJPJO0uabs3IPmZvPJi56uDPNESre29EIs1UPYRXbtIZNbiulR2yoBWMUMJREqp+9BYvG0i3Lwg/Y0UjzFnxB8JDsLivRf7JsOSLiB5pC3xZarcqSeiMhRxMu/DDrc5WJZtpSQ664UgSO3BxJmJLSyYS/NGvax5Ie+r5dY6rF7iFpNlNksoMVy/cERxTzE+3eQ5H02UJ3PVQKVZ14mYUz/UwPfQawn3BlwvTNmNHlET7cBG9sBOyO1DRWlLf7+W00AzH6szb920qnveakLrrmAOnv6y/bOeZUxZK2sVjdYU484dGjdEDbM1NLJs93mEuujBd0GG9O5gtk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(376002)(39860400002)(366004)(346002)(136003)(451199021)(5660300002)(7416002)(8936002)(8676002)(2906002)(66556008)(66946007)(66476007)(44832011)(54906003)(45080400002)(6666004)(6486002)(966005)(4326008)(9686003)(26005)(6506007)(6512007)(316002)(6916009)(41300700001)(186003)(82960400001)(83380400001)(33716001)(478600001)(38100700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nB+Ym7n1Dt6B2ktsD9mXdbl7N6k/n+47yldl5dxe3g1rcbgntysZCFLZJzZ4?=
 =?us-ascii?Q?dYCxRGvzuPjm82Wg4QB1L96aERm31UlHi9gHjHftbATCDWNjcmHor4NbTmvr?=
 =?us-ascii?Q?rfhjIRqkix1EBwkx90BmBRw2YwFhJzj8pwiLFyJ01zNtuxFyMP1zRcf8/YkN?=
 =?us-ascii?Q?QugQHEpnoE9O7POajfF2Hr+BaAsMsChk2eD5+cdqY/a0LLOydSMsi0jivHwT?=
 =?us-ascii?Q?sV2MNFMK8cjGuvWNRPiOUiiFzRWKOS1SzcMwjE4FHmEJqrQ4XZJ/+/sPQIAV?=
 =?us-ascii?Q?nTwR5qKDucxEfF5RjubwGB8q0UsDQRCJXxghNOzhx+hCLTLGYQ4gWglYgOxB?=
 =?us-ascii?Q?UiIfmN/TRe2qcGCzNMT6Jkg3R2iTy2fQYKU+0DpebpSEd5NVkEndfba7W7aa?=
 =?us-ascii?Q?gIau82EE2Kw8fqHroeUPhCYN3MdqAF2X4V2XIbyvPK95lvgpID6ebO2+GQ50?=
 =?us-ascii?Q?qOcmBywaBy1zt69slSJGDWbCJsAg7xh9V+P2d59CDUZHDW2WN03D0PQBGKdz?=
 =?us-ascii?Q?f+Oq8pfZtL5WWBJT6O+OMgUnRxFPQmZS003EoSfqq6xNE5ezjFYE34ELeya4?=
 =?us-ascii?Q?F1cGuxC8QmcrNbTCLCFHH98gY+wZTAfwqDbKzkRCOVYYZX5tysBd55nH5E8X?=
 =?us-ascii?Q?DaW4JNCrxhmj+2+T+Ix9NEg/tojjSyeYtBLLe6gEO3huv3Yc9m0OisNTlDAI?=
 =?us-ascii?Q?gT+CRcvOeNi0LRl15cMs26p7dbs38GofcImVWQMICJqk+xwZuh22rM345lWl?=
 =?us-ascii?Q?RZ4lyym/ZQtUA66/AH61kbbyjh5IKghZPPn9KcEix+p0w8P5UKk0XyuteFg4?=
 =?us-ascii?Q?OBsZC7Yf37/Q5Y6rYFujUQtfMphpyexuEIp5yOgGSc//c48n7UrNZ7V6/Ed9?=
 =?us-ascii?Q?LnaanVgTvYoD62S1+EEb1nEMq98YZ/Buxp39SV0xuQcqmzW2jyU8P/fvUPhh?=
 =?us-ascii?Q?pZNBRN+XXN6TkeIFby5T9JpTzXwynjyWedwez4ecWc4Q0ZjF+2gUi6MLsV1S?=
 =?us-ascii?Q?YG8nYyPR7gn78Bcw0/C9fJNmC3T71h344UcV8I5XCwH8YRvgVJ7kF8VCx6hw?=
 =?us-ascii?Q?IdAb9j7pRazHz30PhRIfPZQZ8R8zDJuak35qwQGcPafXDopY3q6lHu+J5WIq?=
 =?us-ascii?Q?MpL4I2D3r0O2mCJr9iUJ/tzglYSrsX4O9ef/kdIByAgvO1C8O5d3P377aHSn?=
 =?us-ascii?Q?44n9JpvwQAoKE99gN7EJE57RZCH2fG7pdEELdw7Cz++j6X0mPkLsdLDwYDfg?=
 =?us-ascii?Q?aw6KT2pfbCTn6nnkLTVOmmXKpOvAa+EVPyhOskQJat0uX4IYfE1qIiygQLwj?=
 =?us-ascii?Q?Z+p+ZADd1DJW+E9RjdxqDZTn0MHIr4GEIRby8pjUZyzDtmKqPAFa30i4TmuR?=
 =?us-ascii?Q?GAO4cAQFqsL7Q2tGmZlveNuBVx89NDWsTS06zPImkgTJVwHnInqIxxUKaDSC?=
 =?us-ascii?Q?Z/ARYRAQ6KyFyJhlBgMLxZh7PZYkTQ0S1jAlY+0x1pYJeOU9u4cz/uNxya9u?=
 =?us-ascii?Q?qPCJTrlPB2FypGv6mI92omqqhhsLVrIfWwmA3ku42xo4cntsdPGwddqboUey?=
 =?us-ascii?Q?DiMFE7BnQ2H11vJqYm1zyvZWAsRkJkE7JCBxWyqMjJ41ScS+XQbZCC67//cs?=
 =?us-ascii?Q?Kw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c3c6fccc-7ca2-4de9-c1c5-08db6b390c8b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 11:34:57.2172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yrkzIzlEA/4GUpGi8a9JPanaygW9WcGccU48wvECYy7Igbak6AHfAshGOb+a5ZusQFaJoKFTwy/L1mvncqhJ3YVF4OTfxp5S8Y2JOF50sco=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5531
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 11, 2023 at 09:11:25PM +0300, Leon Romanovsky wrote:
> On Wed, Jun 07, 2023 at 10:03:35AM -0400, Asmaa Mnebhi wrote:
> > There is a race condition happening during shutdown due to pending napi transactions.
> > Since mlxbf_gige_poll is still running, it tries to access a NULL pointer and as a
> > result causes a kernel panic.
> > To fix this during shutdown, invoke mlxbf_gige_remove to disable and dequeue napi.
> > 
> > Fixes: f92e1869d74e ("Add Mellanox BlueField Gigabit Ethernet driver")
> > Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>
> > ---
> >  .../net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c    | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
> > index 694de9513b9f..609d038b034e 100644
> > --- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
> > +++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
> > @@ -475,6 +475,9 @@ static int mlxbf_gige_remove(struct platform_device *pdev)
> >  {
> >  	struct mlxbf_gige *priv = platform_get_drvdata(pdev);
> >  
> > +	if (!priv)
> > +		return 0;
> > +
> 
> How can this check be correct? You are removing mlxbf_gige driver, priv
> should be always exist here.

Asmaa please include v1->v2 diff next time.

Leon, look at v1 discussion:
https://lore.kernel.org/netdev/CH2PR12MB3895172507E1D42BBD5D4AB9D753A@CH2PR12MB3895.namprd12.prod.outlook.com/

> 
> >  	unregister_netdev(priv->netdev);
> >  	phy_disconnect(priv->netdev->phydev);
> >  	mlxbf_gige_mdio_remove(priv);
> > @@ -485,10 +488,7 @@ static int mlxbf_gige_remove(struct platform_device *pdev)
> >  
> >  static void mlxbf_gige_shutdown(struct platform_device *pdev)
> >  {
> > -	struct mlxbf_gige *priv = platform_get_drvdata(pdev);
> > -
> > -	writeq(0, priv->base + MLXBF_GIGE_INT_EN);
> > -	mlxbf_gige_clean_port(priv);
> > +	mlxbf_gige_remove(pdev);
> >  }
> >  
> >  static const struct acpi_device_id __maybe_unused mlxbf_gige_acpi_match[] = {
> > -- 
> > 2.30.1
> > 
> > 
> 

