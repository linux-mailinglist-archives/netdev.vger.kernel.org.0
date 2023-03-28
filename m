Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA746CC7B1
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 18:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbjC1QQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 12:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjC1QQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 12:16:31 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6599E3B6
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 09:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680020180; x=1711556180;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=mIE2adLsR2d2ev/wScC/N3cc0C7KHZYQuBEmbBoPlw4=;
  b=S18wHghW0qutxIO+XQ9ViSiCJMmOK5vvej4UHDArPFNmmrIxH8KObDzF
   WFTnzWPLKNpcVEEjS/08zwVz2hCCuMgFqJf9mZbfosaRUU/a/mtmQGdmG
   25mSORhpdIP6co7hvXFzHOJke+EkfkGH3RqLOphwpZ5cOubCnCpGt/00w
   oymh80745hBwI/pEAI2mKXtHDJxxR0PcsYz9rEnAKsuzxnSZK/3PEhFpB
   Sy0ZxkcGb91zzvbYedvTGwSJIEH0ew1x8AUzCiHwck7iADKgHTzofxRdN
   r//qgGPo8z/h68WyPcaxCoSeq/NXK3kqE/Uu8QImZo+r2rkhERfGZMp/v
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="340637600"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="340637600"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 09:16:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="929974056"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="929974056"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 28 Mar 2023 09:16:20 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 28 Mar 2023 09:16:20 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 28 Mar 2023 09:16:19 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 28 Mar 2023 09:16:19 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 28 Mar 2023 09:16:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UILa+stAnBo81fq1DuAxK3O859lIbd4VQ5quSISywrUqlSqTVr3qI3MRjIoUUZSGzA81ftSBnxeTGjVBSCZED5WTejIXiUtjCSpOp6wA7aToFWuJQSQ+kEUY+7chTBdIuN5KoYCiSRT0jqFG0UUReDGdMATf8FOa7WVqSbbHzC/q9hzCUp0zrfEW9sf/ZLFfxJC8bv0xNyb3K2aLPLsDxoprUWzES0pNuhpM87zDq2WVUAHDPp4bPuUUihKf7qNvMkoJA+2WzwMw7D13xLY618P0ofGw10IiNpWjOHPRoKjFmRPUdlSfVFTdjchuL1HUntDPuAlRqfAx3mVvFgoJ2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HhO6R3CpO4XGBSlwd4PF1xMbKmOtwpT6VWIlyGpaIPM=;
 b=W2ETFQwsJruQP57k82PNjADzoUsQXzIY5vx+65i6lZMpfNhbrHht4Z5ryUQDk9gckVz1YmKfY077KkdzBo6q+G5G3hE0lsxQ5AoU+2ZEdhMMwPLx8eF3BeoejVbRIBIj7blcqnAZlvxTuGjvPuCse83X2E/6ngR4QSqkxzRYOUhrMSuiFd+oIIsj81E0ODocIvX3ye5hiFj+daSKCD8uGFAE7exk8DoyHeOr5GbS9+3IPQtCapLwciI3jOU5ea49OXlz3VS9/kRMlswBGsTz5aN7qrynSWvekbQt82LTN2ifdaCBtJRaCIJmBlT7sxT1ZlmTSJHMIQIYHjCe3fwlmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
 by IA1PR11MB6194.namprd11.prod.outlook.com (2603:10b6:208:3ea::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Tue, 28 Mar
 2023 16:16:16 +0000
Received: from PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056]) by PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056%2]) with mapi id 15.20.6222.033; Tue, 28 Mar 2023
 16:16:16 +0000
Date:   Tue, 28 Mar 2023 18:16:15 +0200
From:   Piotr Raczynski <piotr.raczynski@intel.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <michal.swiatkowski@intel.com>, <shiraz.saleem@intel.com>,
        <jacob.e.keller@intel.com>, <sridhar.samudrala@intel.com>,
        <jesse.brandeburg@intel.com>, <aleksander.lobakin@intel.com>,
        <lukasz.czapnik@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Subject: Re: [PATCH net-next v3 6/8] ice: add individual interrupt allocation
Message-ID: <ZCMSzzw1MTIc9dZW@nimitz>
References: <20230323122440.3419214-1-piotr.raczynski@intel.com>
 <20230323122440.3419214-7-piotr.raczynski@intel.com>
 <ZCBGC47iYuMloMms@corigine.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZCBGC47iYuMloMms@corigine.com>
X-ClientProxiedBy: FRYP281CA0015.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::25)
 To PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7471:EE_|IA1PR11MB6194:EE_
X-MS-Office365-Filtering-Correlation-Id: 54fba35c-94cb-410c-c057-08db2fa7c1ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ou9TAd24hp7ORE4lIPm9zBTrDRz/ws/bMdup4EDDLbBahvRHu0haIO0v8xbUl+MZVJPdKmKnLLG1bMaoZPhcWKAUZ1Q5zhFGQL8zCVrlBkmPPZ7gmM6A1FivfOgYDd0UbhFFsEbaBsu8wcT9gQhlE/TMOFyP+pPTwUKWza/s40DYqXbOJc4tDIu+b6JccJc/P6Rkv3slVaGlcGhBzoAba+4H2Mdl49s7HcukUEoNu4o7ByxDh2g+EkOaG21YGUrAUIRRn80JhxCwI9OJMFySkGtRbBaMFi6JSC73dJV7gOmElaMGga0RXiyzKrxWTkHFnQhQ8aJza7lyz024Hy3rF2ionr7nTCU2ZyIoSLSIVrbWR/DpsMV6decD1AUH/Pf5Vmq6ebFYA9Ggh2+oHmTuvfx1H1kge9zC+/k/2mhNisdrrSLlPVTgwXF0nm9ynJyM/sBcp/yk0JIqqkXIAHO/0HrmrglDj52tLx5tSv1M0r2AYn2sJJya8zJgWszInT4eN7HQyhmUbJAFWYoxQK9sciIJRsjD/H1JnTS9fV/d3kV5SPyu6i+Wd+bU+eclpRUU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(376002)(396003)(366004)(39860400002)(136003)(451199021)(478600001)(44832011)(83380400001)(2906002)(38100700002)(6486002)(5660300002)(8936002)(6512007)(316002)(6506007)(86362001)(82960400001)(186003)(26005)(9686003)(33716001)(41300700001)(66946007)(6916009)(8676002)(4326008)(66476007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8RAQeCCzXkQHUm6A08dMwNLypaV4ocnERQgjtCFo83lvixnlZ/CYjyolprj8?=
 =?us-ascii?Q?WRcZbktFQYWNXGOQkc5no3qffRejuopSFjHZ0AGBonYf5XVTS4l89Wt+1yXh?=
 =?us-ascii?Q?gu2K9n/8Mn6oQs4pV0n6BtP+IG3cbiYcdOfkZ3mCjVuHafyIewl8Y1vescUh?=
 =?us-ascii?Q?PjhguL60jgdH1L4DxrO5JugpctuSvUTAO8ILVwyCBLAH6kU3JAaabQ9aUghk?=
 =?us-ascii?Q?v8Ze1qkOEqJTklDJ0jvMLxdBTg4maInwxoQ3Imt1KPmVHv3jfQQkqeMq0nPm?=
 =?us-ascii?Q?kk2DxXyoNJI83RUZ9shkzkjzA7rjJVrxsK0iKi4EEVIuR7Xwd3kjSK/3s7di?=
 =?us-ascii?Q?MuHQYJzCtXgy6GZlD+oYdkOeJrRMOqZ+2YxGz8n+neEEvj/QQfAebwb3jf1z?=
 =?us-ascii?Q?rgvfJws0IFrYYfFCK1tIMyBtZSHxzbpJxorKnX7zcQtXce8QjUi3eS62iPXw?=
 =?us-ascii?Q?yr7OKZWzUH7fUKajAaCLZZr30b+3eC2c93XWXgGj389B3dyWz1Cb3DgEHYPM?=
 =?us-ascii?Q?dD+P7FLG/tapmOtRPRwbvbl3A1kX1wWv6K32qFUjiSjTTBlA7R440RhUem2n?=
 =?us-ascii?Q?3mTJFe4Imw5oh/IjNYJ0q5xmJ3K9Cwa/E0o5GkBm9xPv14wNf09gaUHJI3po?=
 =?us-ascii?Q?gKMxKSNi5cb9lWb6DN5NbJUplRrWkN+OCb1q8KfwjGZzIDr1eIYJtRBRh93F?=
 =?us-ascii?Q?0F1HjaC2wa52KAN7n6WLTRiD44Rz4QrnYNu7BrZI0wRmLgXNHKkKa4WUuxqM?=
 =?us-ascii?Q?JZ59LkwjdlNcwWe4SptQS74V2SsiWc7KfZnmi/BM/MLpBrltxNMYkMjxmkvU?=
 =?us-ascii?Q?auBLOOaX6i/0VOFAnudR3p33IxPkfMzbnP741WnXDPXrcN+qGkFSU5jywqKH?=
 =?us-ascii?Q?juGT2Jnq3pya9i5fjE2UxF95BhTHLY5ngmIcHG96E07UJMseYjJhViLwXW34?=
 =?us-ascii?Q?jDDb2bWn0r/ZsC3Hb+p7wHPBaU5mq74l+2tkwICREZL9IEfQ4ACQcPk7yXRP?=
 =?us-ascii?Q?4pRfdkSsSLd/BQklaYW5Q9B1GidwhdX8cdapc3zz751YhrJKUKIJbpwIE9pT?=
 =?us-ascii?Q?Dklj2VgMvqM2fYkAyKmoH+2BRF8VxjYOjoOAoFdOJcgFGHJwbKXRxK7+UcK3?=
 =?us-ascii?Q?gTh47czTV+3W3soVGTU1R5cyqLfMM5ztBkKO5u0czne75DgHIR4gK73+A5YE?=
 =?us-ascii?Q?U7pIy4iyrd2WV+PNBBu1SjRhpoRR2YsoXDvfx3jIH5+46AaGD5VWlvjUdtCN?=
 =?us-ascii?Q?gUecAF9N81/E5szI1Dq+aUlahdzWgcTLO0f5jh9SQBjyQpE+1p87GTW2XKrS?=
 =?us-ascii?Q?jCldCEC1VHzU6bffIYod+u6hxv3tl1+0f5Ykx3ebyoWH9Aj3OB5OdP78KaMF?=
 =?us-ascii?Q?t8BUhdadv0D4vpVR2GQlrazoTK0G7ZHwFPlF6HAVbbFwSuxUCjDhpA2FiBiU?=
 =?us-ascii?Q?88zLlWto8BdiCCXaDfCi3DQ7bwSNhoUoKNF7JpsCRft/G3nfyFS7BaWAXcEW?=
 =?us-ascii?Q?0GqWyi5Csaoyr3CraIKHaJhpMqAvy6hv8PfSJuKwnzKiV5bMIFuQrRGPquXZ?=
 =?us-ascii?Q?CLJavrazVnKhy1EsQg43J2SHDhaxTyHY9vs0rjsKZ1AIFJJEQ/SRkS3flKDj?=
 =?us-ascii?Q?3A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 54fba35c-94cb-410c-c057-08db2fa7c1ed
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 16:16:16.4920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4ll4soe0E93yDtQZodaLGInsYQETFub+1cO35rcDEHmWOQKxVAz7/HYfeyewiCxusdyvA/4UmVwj6K9khowWr4s4FyDIAcehSF+5aX2rK14=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6194
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 26, 2023 at 03:18:03PM +0200, Simon Horman wrote:
> On Thu, Mar 23, 2023 at 01:24:38PM +0100, Piotr Raczynski wrote:
> > Currently interrupt allocations, depending on a feature are distributed
> > in batches. Also, after allocation there is a series of operations that
> > distributes per irq settings through that batch of interrupts.
> > 
> > Although driver does not yet support dynamic interrupt allocation, keep
> > allocated interrupts in a pool and add allocation abstraction logic to
> > make code more flexible. Keep per interrupt information in the
> > ice_q_vector structure, which yields ice_vsi::base_vector redundant.
> > Also, as a result there are a few functions that can be removed.
> > 
> > Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> > Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> > Signed-off-by: Piotr Raczynski <piotr.raczynski@intel.com>
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> 
> I've made a few minor observations inline.
> I don't think there is a need to respin for any of them.
> 
Thanks.
> > ---
> >  drivers/net/ethernet/intel/ice/ice.h         |  11 +-
> >  drivers/net/ethernet/intel/ice/ice_arfs.c    |   5 +-
> >  drivers/net/ethernet/intel/ice/ice_base.c    |  36 ++-
> >  drivers/net/ethernet/intel/ice/ice_ethtool.c |   2 +-
> >  drivers/net/ethernet/intel/ice/ice_idc.c     |  45 ++--
> >  drivers/net/ethernet/intel/ice/ice_irq.c     |  46 +++-
> >  drivers/net/ethernet/intel/ice/ice_irq.h     |   3 +
> >  drivers/net/ethernet/intel/ice/ice_lib.c     | 225 ++-----------------
> 
> Nice code removal from ice_lib.c :)
> 
> >  drivers/net/ethernet/intel/ice/ice_lib.h     |   4 +-
> >  drivers/net/ethernet/intel/ice/ice_main.c    |  44 ++--
> >  drivers/net/ethernet/intel/ice/ice_ptp.c     |   2 +-
> >  drivers/net/ethernet/intel/ice/ice_sriov.c   |   2 +-
> >  drivers/net/ethernet/intel/ice/ice_xsk.c     |   5 +-
> >  13 files changed, 154 insertions(+), 276 deletions(-)
> 
> ...
> 
> > diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
> > index 1911d644dfa8..e5db23eaa3f4 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_base.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_base.c
> > @@ -118,9 +118,31 @@ static int ice_vsi_alloc_q_vector(struct ice_vsi *vsi, u16 v_idx)
> >  	q_vector->rx.itr_mode = ITR_DYNAMIC;
> >  	q_vector->tx.type = ICE_TX_CONTAINER;
> >  	q_vector->rx.type = ICE_RX_CONTAINER;
> > +	q_vector->irq.index = -ENOENT;
> >  
> > -	if (vsi->type == ICE_VSI_VF)
> > +	if (vsi->type == ICE_VSI_VF) {
> > +		q_vector->reg_idx = ice_calc_vf_reg_idx(vsi->vf, q_vector);
> >  		goto out;
> > +	} else if (vsi->type == ICE_VSI_CTRL && vsi->vf) {
> > +		struct ice_vsi *ctrl_vsi = ice_get_vf_ctrl_vsi(pf, vsi);
> > +
> > +		if (ctrl_vsi) {
> > +			if (unlikely(!ctrl_vsi->q_vectors))
> > +				return -ENOENT;
> > +			q_vector->irq = ctrl_vsi->q_vectors[0]->irq;
> > +			goto skip_alloc;
> 
> nit: I think goto for error paths is very much the norm.
>      But, FWIIW, I would have avoided using goto here.

Thanks will take a look.

> 
> > +		}
> > +	}
> > +
> > +	q_vector->irq = ice_alloc_irq(pf);
> > +	if (q_vector->irq.index < 0) {
> > +		kfree(q_vector);
> > +		return -ENOMEM;
> > +	}
> > +
> > +skip_alloc:
> > +	q_vector->reg_idx = q_vector->irq.index;
> > +
> >  	/* only set affinity_mask if the CPU is online */
> >  	if (cpu_online(v_idx))
> >  		cpumask_set_cpu(v_idx, &q_vector->affinity_mask);
> > @@ -168,6 +190,18 @@ static void ice_free_q_vector(struct ice_vsi *vsi, int v_idx)
> >  	if (vsi->netdev)
> >  		netif_napi_del(&q_vector->napi);
> >  
> > +	/* release MSIX interrupt if q_vector had interrupt allocated */
> > +	if (q_vector->irq.index < 0)
> > +		goto free_q_vector;
> > +
> > +	/* only free last VF ctrl vsi interrupt */
> > +	if (vsi->type == ICE_VSI_CTRL && vsi->vf &&
> > +	    ice_get_vf_ctrl_vsi(pf, vsi))
> > +		goto free_q_vector;
> 
> Ditto (x2).
Will also take a look.
> 
> > +
> > +	ice_free_irq(pf, q_vector->irq);
> > +
> > +free_q_vector:
> >  	devm_kfree(dev, q_vector);
> >  	vsi->q_vectors[v_idx] = NULL;
> >  }
> 
> ...
> 
> > diff --git a/drivers/net/ethernet/intel/ice/ice_irq.c b/drivers/net/ethernet/intel/ice/ice_irq.c
> > index f61be5d76373..ca1a1de26766 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_irq.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_irq.c
> > @@ -194,9 +194,53 @@ int ice_init_interrupt_scheme(struct ice_pf *pf)
> >  	}
> >  
> >  	/* populate SW interrupts pool with number of OS granted IRQs. */
> > -	pf->num_avail_sw_msix = (u16)vectors;
> >  	pf->irq_tracker->num_entries = (u16)vectors;
> >  	pf->irq_tracker->end = pf->irq_tracker->num_entries;
> >  
> >  	return 0;
> >  }
> > +
> > +/**
> > + * ice_alloc_irq - Allocate new interrupt vector
> > + * @pf: board private structure
> > + *
> > + * Allocate new interrupt vector for a given owner id.
> > + * return struct msi_map with interrupt details and track
> > + * allocated interrupt appropriately.
> > + *
> > + * This function mimics individual interrupt allocation,
> > + * even interrupts are actually already allocated with
> > + * pci_alloc_irq_vectors. Individual allocation helps
> > + * to track interrupts and simplifies interrupt related
> > + * handling.
> > + *
> > + * On failure, return map with negative .index. The caller
> > + * is expected to check returned map index.
> > + *
> > + */
> > +struct msi_map ice_alloc_irq(struct ice_pf *pf)
> > +{
> > +	struct msi_map map = { .index = -ENOENT };
> > +	int entry;
> > +
> > +	entry = ice_get_res(pf, pf->irq_tracker);
> > +	if (entry < 0)
> 
> nit: map.index could be initialised here.
> 
> > +		return map;
> > +
> > +	map.index = entry;
> > +	map.virq = pci_irq_vector(pf->pdev, map.index);
> > +
> > +	return map;
> > +}
