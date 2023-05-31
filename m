Return-Path: <netdev+bounces-6776-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8784E717DCD
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 13:14:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 15D841C208C8
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 11:14:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8828213AE1;
	Wed, 31 May 2023 11:14:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F5315B8
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 11:14:46 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 770C8185;
	Wed, 31 May 2023 04:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685531680; x=1717067680;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=xp6rPElvGDI9Tw84+MAQTMi2fYjjkcQe+ZyCsWHd7D8=;
  b=FtuWHhwqESSqIgqGTpwjeO7R8lPkmR/W3XkEHW8hB/YhFh0fKh9PMnGp
   MS4hCYEcNuRxhmYom6dNYIG12bnqfcYwzSMFGlGz9gnyT8zZlMlYhTm7J
   VcHppMjEOO2u0pgJ0dMZVQ3AsBjcXH306FmR+0hHUZv601uHZKpl8Rzp0
   y3eNU33LsWU21ryHUOSR+VUD0ZhukZ4emVg8t0RahmZKFEumwzjlk1SYY
   rflUCXbeR8g8OJ4ZVrHnrfwC7yjyIJbETJZCBd9AMm31m8AzYL3ldLK9V
   MmrH0F/DEVVwIeUjh9BwhRvFCWrGu/k/irmSELDfVWuZR65ijEghm7FPX
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="441562613"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="441562613"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 04:14:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="706844918"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="706844918"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 31 May 2023 04:14:38 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 31 May 2023 04:14:38 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 31 May 2023 04:14:38 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 31 May 2023 04:14:38 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 31 May 2023 04:14:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KUbQJ0rCJoScm1R8/yfMiI5gx/5hHIUWFVi2GpzgbmEDc46BXfrOtx2/2LxhuC/isc182qWvqJzG2mpb+A5UO4n2zu1RJqIenJrWdLI2fhcUTTDZZlBcxTRq6T/H+xFUCCQruUwXt4fLAzlzpNoyfEV0E7yxOhj+4AB7USIZjVwtVZ/LSflwPDCQ++0Qju6u127HwG6MAMCY7s4K7R1ZUpPhkjcj9q+wqtdl8Z1qsF+rkUMtgzMm4EpjBQB/+etYp6zE9AUqblrHcoG43DxApWSRAcLsgtDum+PhhTAuDJvOXg/vrAjwmIPrDu+9mjzSFdeq9QDfywJZtDSJCx8i2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i0h5VNxyYjRTd2K3R3dwCKnSsh5yzwHB23zXBfFyxXY=;
 b=bKx0H1yA6TWlwEZpr3DMAje1Hg4UbAOTKia2JfAR/oSyTOGnwds0zSjXRzwwZki0phfbuNSenjHBt31gkXt/CanPV0XpAikyBmIi32MAmFZxX/YcAF/0BbSk1iFHbnbNTf+fdDFIoTrJorP8/snopdiH0W8NjiVJkSXi7Q/X04FeppkOIQX5tQMpTdZu1uyXLGWH1nBPDMzKMBLPtnH3oig/iCQ6qRy9EFOEAWeq7REGcTSsT6vRi/tUehZTcwe7Uy3RA3jXIYLtJemFfx0cl443xAQPFyVYs1AiswcX3Rm3u3jK9l9ccO/qJ8dKw1o2ThrJqXgNpRXZr5+evtMMCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 SA1PR11MB6847.namprd11.prod.outlook.com (2603:10b6:806:29e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.22; Wed, 31 May 2023 11:14:35 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 11:14:34 +0000
Date: Wed, 31 May 2023 13:14:12 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Alexander H Duyck <alexander.duyck@gmail.com>
CC: Alexander Lobakin <aleksander.lobakin@intel.com>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Magnus Karlsson
	<magnus.karlsson@intel.com>, Michal Kubiak <michal.kubiak@intel.com>, "Larysa
 Zaremba" <larysa.zaremba@intel.com>, Jesper Dangaard Brouer
	<hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, "Christoph
 Hellwig" <hch@lst.de>, Paul Menzel <pmenzel@molgen.mpg.de>,
	<netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 03/12] iavf: optimize Rx buffer allocation a
 bunch
Message-ID: <ZHcsBPr0EXx6hkkd@boxer>
References: <20230525125746.553874-1-aleksander.lobakin@intel.com>
 <20230525125746.553874-4-aleksander.lobakin@intel.com>
 <8828262f1c238ab28be9ec87a7701acd791af926.camel@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8828262f1c238ab28be9ec87a7701acd791af926.camel@gmail.com>
X-ClientProxiedBy: FR2P281CA0058.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::9) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|SA1PR11MB6847:EE_
X-MS-Office365-Filtering-Correlation-Id: fea9e2e7-4c77-4a61-dc54-08db61c83699
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lbGHXF3Z/9qxA8YEMI08y4WIMmsjTiPsTHpeK5txlcCwlEMA+HayKD6GTsAG8mm3ri3RS5uAdXqCqO3Cmr66vqf6aGSwRCW7VAfvzWtpjAPEA51g92iiR0DQsw+JP/lfEzq95JaH/bZIv2LUf/6jTxMRz3c4wFvCuDb+FRWemiO5jWsHsWwAjrU9ZkTIRzQVM6AtqpE7T/H6ZS7rt9jvwThHLP04QOxTUUht4GpX5RwlGSkezmcrsegEF7b/9IABM5AG4IFV72iXmyQVE3G49WNgdZ0TH3j56qlsLBML0EYuIR5lOeVdrDkiB/RzGQb1A4vLTEM1VEWHLllQiSmXYL5j3r1Ej5rdUBIwyJaBkRAO/uvtGqSIJaZUPAkz77VbsBHJ6EH+hGWHLdZipC7D7AXy2t8/fgjiXHZvWtmM5/hP93wQd/szhM7lmaDnMpdmDN7lfe7m4Vtmb6Z9blHRchohHciZ7pZgcDCojacJ7RAT1JPkIJANnJIqzzPkhirnNofVcRRSG4CHOT+9LiZ1H1lkK2sPhVCucxPiLulMeLuhnkGvhHzoHf4tJihPjWWy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(366004)(136003)(346002)(376002)(396003)(39860400002)(451199021)(6486002)(26005)(6512007)(9686003)(6506007)(2906002)(186003)(316002)(5660300002)(41300700001)(7416002)(44832011)(8936002)(8676002)(6666004)(478600001)(38100700002)(82960400001)(66899021)(4326008)(6916009)(86362001)(66946007)(33716001)(54906003)(66476007)(83380400001)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8thI2iCDlGQ/dPYIu3gc5+wtn5a8z6SbqkQmWW/lGCJVtWJst4kQkH7uuiCT?=
 =?us-ascii?Q?IFgpKw0WvHx7rreud2UN+NpHCUQO2i384lgwMS8vQqfxPRdQYofAneQwONU0?=
 =?us-ascii?Q?SDJuLN6EjyRhZzHby8bncuyKquN+5F0G66Nlt5BrQe1ML64BCDBiHW7OmT19?=
 =?us-ascii?Q?9gIjjJA1p4usJoYgP0zd5ZCdC2ZqxTfGpTeej7CnV/9cZgdlRFaKXx1wsmI0?=
 =?us-ascii?Q?/ZwOYp4vE1PUZrzaDqVFFAI1eF7D48Wv2fh8EX6nQGPTry0LUxMxxgm7/40V?=
 =?us-ascii?Q?gN5XDgCGNlqpHE1mM+m+C6Z2DIsoADYRU+A8W1ZBWd8dzVUnMMzneXwvJ2Op?=
 =?us-ascii?Q?MHI3P8R3nozygtnsmwb6u9mVdDl3e0on/OvIuTrJ2o8gpv8Uq3Q8LtO945Hh?=
 =?us-ascii?Q?/gezwlAflpGi+6f4ABg9egRUJ/bCXV7gPF4LyWq9+tyW7sS3wAsPPrFIDflK?=
 =?us-ascii?Q?GOktA5iUk+4ryazWNrLYratfFyhxaIVRq+PE+c2Y4vGQGimyC5Z1zsdWtSji?=
 =?us-ascii?Q?C/0tH6iGqgtQzTeWt67NjHe9sXun29eWkZCsrMpZ/9jQ6DzXSwjRLMEuTIjG?=
 =?us-ascii?Q?vBmGoQXGzvSMSu/E/bZEc+WmLK+3XqGy23MPySRjhWE6TR6X/U2wKdP6WlFl?=
 =?us-ascii?Q?wSduNpGviQK8J31yGl3as52/d/xFi2akxyvHwfH35dyxfhjL4MBi5RKXJQrA?=
 =?us-ascii?Q?Tt28GfEXgTPYgy7/wjLHr76tEnGH6SexN7Dc5fuctpapAgSQ9LJTNSJn2h4B?=
 =?us-ascii?Q?+tjpUJfqUQaO8tp7xNP7T1DgqDz76JwaTrFOPbD0UkGDuZg/CcyOMpGTMCM3?=
 =?us-ascii?Q?hFpmDQySYRw0LTiPMZWkptumcIKN/WXH3EU/2SibJCOnmlBFA79ZED7I6pnY?=
 =?us-ascii?Q?znhBG29oFhKdF8T4uT7oCXuROyO/j+BcH3f3B/BvWzIm3ystgeHu0iV642tv?=
 =?us-ascii?Q?5lMwYfPI9Xr4HzVL4msOq59cZ2fkNDI6e9eJ1Eyxdk/h5KQEc4eVPNJ3mXqO?=
 =?us-ascii?Q?hlg997VZirUDRrkpudO6iw6oDOnRF0JfrpQMUUtOrhsHe+NH+SUYgk5QfKOB?=
 =?us-ascii?Q?QuDw6CUkFYjVJaMMsMVIhlm4KJLmKRkNjY1XYh60f9yeiEKrtk0/O50mpgt6?=
 =?us-ascii?Q?IHo2Cbvvhq1+dkTw2nYdggVwR2axa/cXruCqfVhH2oVC3B532sglHGUSm8Cj?=
 =?us-ascii?Q?Ksd0osPhmbLot3tCZ8KDFadbUkdPtrM8sT4gXzIYZ+0KOQD6Y00moaoMTprB?=
 =?us-ascii?Q?sNIlUf/EEXWO6n6DWsTxX8eFQI/il+Ap1jwIBQRhDzy9y3VZds5vdfaqUyvt?=
 =?us-ascii?Q?BOZE+ZkePadWayCnOE+ZY+woAfgcm+xZ0+OYqg8oUsVsVvJm2jzOaqLH4v6o?=
 =?us-ascii?Q?ndCEvIsUIHVCaM0UvN6Q69Ws4Rj5AbgYmAsmpryvGDWFBbg+I6qdoavJK+Mu?=
 =?us-ascii?Q?Z/AFUF+eequSYIzTUKVrUJzpF9jAUCGAgCZ6WkFscTKxdQwFnSKLhQ0N8ip2?=
 =?us-ascii?Q?YB98xIlHF3Ci54TmMrGUjWboetMMPWsg6FfVY4xzsV20wK8z18Vdmmmji4Nw?=
 =?us-ascii?Q?1WklAJUEmBZFu+zR4tjZ6KLOF+g354izhUCtUCKW699Dw85PN23pSXfFHiI+?=
 =?us-ascii?Q?8g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fea9e2e7-4c77-4a61-dc54-08db61c83699
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 11:14:34.4525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2S7GpB+JUFI8T0OUvbpFyTjVkCbKR2Zhm3moUBAGl6+AEjdhe6IRh+0QUy7/dbgajJh4putaLdtekJ2TNu1hjQF0es0IQXL1pyWzBxAGmuk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6847
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 09:18:40AM -0700, Alexander H Duyck wrote:

FWIW I agree with what Alex is saying over here.

> On Thu, 2023-05-25 at 14:57 +0200, Alexander Lobakin wrote:
> > The Rx hotpath code of IAVF is not well-optimized TBH. Before doing any
> > further buffer model changes, shake it up a bit. Notably:
> > 
> > 1. Cache more variables on the stack.
> >    DMA device, Rx page size, NTC -- these are the most common things
> >    used all throughout the hotpath, often in loops on each iteration.
> >    Instead of fetching (or even calculating, as with the page size) them
> >    from the ring all the time, cache them on the stack at the beginning
> >    of the NAPI polling callback. NTC will be written back at the end,
> >    the rest are used read-only, so no sync needed.
> 
> The advantage of this is going to vary based on the attribute. One of
> the reasons why I left most of this on the ring is because the section
> of the ring most of these variables were meant to be read-mostly and
> shouldn't have resulted in any additional overhead versus accessing
> them from the stack.

I believe it depends on ring struct layout which vary across our drivers,
no? On ice using making more usage of stack as described above improved
perf.

> 
> > 2. Don't move the recycled buffers around the ring.
> >    The idea of passing the page of the right-now-recycled-buffer to a
> >    different buffer, in this case, the first one that needs to be
> >    allocated, moreover, on each new frame, is fundamentally wrong. It
> >    involves a few o' fetches, branches and then writes (and one Rx
> >    buffer struct is at least 32 bytes) where they're completely unneeded,
> >    but gives no good -- the result is the same as if we'd recycle it
> >    inplace, at the same position where it was used. So drop this and let
> >    the main refilling function take care of all the buffers, which were
> >    processed and now need to be recycled/refilled.
> 
> The next_to_alloc logic was put in place to deal with systems that are
> experiencing memory issues. Specifically what can end up happening is
> that the ring can stall due to failing memory allocations and the
> memory can get stuck on the ring. For that reason we were essentially
> defragmenting the buffers when we started suffering memory pressure so
> that they could be reusued and/or freed following immediate use.
> 
> Basically what you are trading off is some exception handling for
> performance by removing it.

With all of the mix of the changes this patch carries, I find it hard to
follow from description which parts of diff I should be looking at.

> 
> > 3. Don't allocate with %GPF_ATOMIC on ifup.
> >    This involved introducing the @gfp parameter to a couple functions.
> >    Doesn't change anything for Rx -> softirq.
> 
> Any specific reason for this? Just wondering if this is meant to
> address some sort of memory pressure issue since it basically just
> means the allocation can go out and try to free other memory.
> 
> > 4. 1 budget unit == 1 descriptor, not skb.
> >    There could be underflow when receiving a lot of fragmented frames.
> >    If each of them would consist of 2 frags, it means that we'd process
> >    64 descriptors at the point where we pass the 32th skb to the stack.
> >    But the driver would count that only as a half, which could make NAPI
> >    re-enable interrupts prematurely and create unnecessary CPU load.
> 
> Not sure I agree with this. The problem is the overhead for an skb
> going up the stack versus a fragment are pretty signficant. Keep in
> mind that most of the overhead for a single buffer occurs w/
> napi_gro_receive and is not actually at the driver itself. The whole
> point of the budget is to meter out units of work, not to keep you in
> the busy loop. This starts looking like the old code where the Intel
> drivers were returning either budget or 0 instead of supporting the
> middle ground.
> 
> > 5. Shortcut !size case.
> >    It's super rare, but possible -- for example, if the last buffer of
> >    the fragmented frame contained only FCS, which was then stripped by
> >    the HW. Instead of checking for size several times when processing,
> >    quickly reuse the buffer and jump to the skb fields part.
> > 6. Refill the ring after finishing the polling loop.
> >    Previously, the loop wasn't starting a new iteration after the 64th
> >    desc, meaning that we were always leaving 16 buffers non-refilled
> >    until the next NAPI poll. It's better to refill them while they're
> >    still hot, so do that right after exiting the loop as well.
> >    For a full cycle of 64 descs, there will be 4 refills of 16 descs
> >    from now on.
> > 
> > Function: add/remove: 4/2 grow/shrink: 0/5 up/down: 473/-647 (-174)
> > 
> > + up to 2% performance.
> > 
> 
> What is the test you saw the 2% performance improvement in? Is it
> something XDP related or a full stack test?

+1, can you say more about that measurement?

> 
> > Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
> 
> Also one thing I am not a huge fan of is a patch that is really a
> patchset onto itself. With all 6 items called out here I would have
> preferred to see this as 6 patches as it would have been easier to
> review.

+1

> 
> > ---
> >  drivers/net/ethernet/intel/iavf/iavf_main.c |   2 +-
> >  drivers/net/ethernet/intel/iavf/iavf_txrx.c | 259 +++++++++-----------
> >  drivers/net/ethernet/intel/iavf/iavf_txrx.h |   3 +-
> >  3 files changed, 114 insertions(+), 150 deletions(-)
> > 

(...)

> >  }
> > @@ -1350,14 +1297,6 @@ static bool iavf_is_non_eop(struct iavf_ring *rx_ring,
> >  			    union iavf_rx_desc *rx_desc,
> >  			    struct sk_buff *skb)
> >  {
> > -	u32 ntc = rx_ring->next_to_clean + 1;
> > -
> > -	/* fetch, update, and store next to clean */
> > -	ntc = (ntc < rx_ring->count) ? ntc : 0;
> > -	rx_ring->next_to_clean = ntc;
> > -
> > -	prefetch(IAVF_RX_DESC(rx_ring, ntc));
> > -
> >  	/* if we are the last buffer then there is nothing else to do */
> >  #define IAVF_RXD_EOF BIT(IAVF_RX_DESC_STATUS_EOF_SHIFT)
> >  	if (likely(iavf_test_staterr(rx_desc, IAVF_RXD_EOF)))
> 
> You may want to see if you can get rid of this function entirely,
> perhaps you do in a later patch. This function was added for ixgbe back
> in the day to allow us to place the skb back in the ring for the RSC
> based workloads where we had to deal with interleaved frames in the Rx
> path.
> 
> For example, one question here would be why are we passing skb? It
> isn't used as far as I can tell.
> 
this was used back when skb was stored within the Rx buffer and now we
just store skb on Rx ring struct, so good catch, this arg is redundant.

I'll go and take a look at code on v3.

