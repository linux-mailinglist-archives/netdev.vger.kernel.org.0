Return-Path: <netdev+bounces-11328-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A336D7329FC
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:37:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DCF831C209FB
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 08:37:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCF7A63BD;
	Fri, 16 Jun 2023 08:37:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13671FCB
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 08:37:30 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B96194
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 01:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686904649; x=1718440649;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TFjfmDfGyKVcsNmEnWJhlPPhJzj7rQFvm131Anc9tAM=;
  b=RQyQZOBqTiHpkAARgkt331+tIwgPdnLwmwoxBUT5LodhuYd273QlTiyM
   kmHJKHQcv5SsDKwXSh7jrYkacZPeEBExxgVzbwI2NeW79w1QVfNtR65Bz
   /PwWePa04/b1pMzn9MUhzfCBMpOgSbx0iT01fLwJbOvznEiSpAiJBRdKR
   opxjxkFSTaORwLHiK8kzZz2x++A1qEUnNruoMacZ6nrkmACpS4MEWtChk
   nRLUdgESYTxXW6rjpv6GEz/z5aJTUo1sBT27xbZaZW7JYDhfRwM/RpjXq
   g+ipFXOdulPbKmbT2FsNjjPLNUCb36lXXwuGuIRs0HhlqcZqJv1mv8EeQ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="361688831"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="361688831"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 01:37:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="715923831"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="715923831"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 01:37:26 -0700
Date: Fri, 16 Jun 2023 10:37:23 +0200
From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To: "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc: "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"Kitszel, Przemyslaw" <przemyslaw.kitszel@intel.com>
Subject: Re: [PATCH iwl-next v1 4/4] ice: manage VFs MSI-X using resource
 tracking
Message-ID: <ZIwfQ62nQFmr6RFZ@localhost.localdomain>
References: <20230615123830.155927-1-michal.swiatkowski@linux.intel.com>
 <20230615123830.155927-5-michal.swiatkowski@linux.intel.com>
 <CO1PR11MB5089B50AB69E2EA953E07FEFD65BA@CO1PR11MB5089.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB5089B50AB69E2EA953E07FEFD65BA@CO1PR11MB5089.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 15, 2023 at 03:57:37PM +0000, Keller, Jacob E wrote:
> 
> 
> > -----Original Message-----
> > From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> > Sent: Thursday, June 15, 2023 5:39 AM
> > To: intel-wired-lan@lists.osuosl.org
> > Cc: netdev@vger.kernel.org; Keller, Jacob E <jacob.e.keller@intel.com>; Kitszel,
> > Przemyslaw <przemyslaw.kitszel@intel.com>; Michal Swiatkowski
> > <michal.swiatkowski@linux.intel.com>
> > Subject: [PATCH iwl-next v1 4/4] ice: manage VFs MSI-X using resource tracking
> > 
> > Track MSI-X for VFs using bitmap, by setting and clearing bitmap during
> > allocation and freeing.
> > 
> > Try to linearize irqs usage for VFs, by freeing them and allocating once
> > again. Do it only for VFs that aren't currently running.
> > 
> > Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> > Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
> > ---
> >  drivers/net/ethernet/intel/ice/ice_sriov.c | 170 ++++++++++++++++++---
> >  1 file changed, 151 insertions(+), 19 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c
> > b/drivers/net/ethernet/intel/ice/ice_sriov.c
> > index e20ef1924fae..78a41163755b 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_sriov.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
> > @@ -246,22 +246,6 @@ static struct ice_vsi *ice_vf_vsi_setup(struct ice_vf *vf)
> >  	return vsi;
> >  }
> > 
> > -/**
> > - * ice_calc_vf_first_vector_idx - Calculate MSIX vector index in the PF space
> > - * @pf: pointer to PF structure
> > - * @vf: pointer to VF that the first MSIX vector index is being calculated for
> > - *
> > - * This returns the first MSIX vector index in PF space that is used by this VF.
> > - * This index is used when accessing PF relative registers such as
> > - * GLINT_VECT2FUNC and GLINT_DYN_CTL.
> > - * This will always be the OICR index in the AVF driver so any functionality
> > - * using vf->first_vector_idx for queue configuration will have to increment by
> > - * 1 to avoid meddling with the OICR index.
> > - */
> > -static int ice_calc_vf_first_vector_idx(struct ice_pf *pf, struct ice_vf *vf)
> > -{
> > -	return pf->sriov_base_vector + vf->vf_id * pf->vfs.num_msix_per;
> > -}
> > 
> >  /**
> >   * ice_ena_vf_msix_mappings - enable VF MSIX mappings in hardware
> > @@ -528,6 +512,52 @@ static int ice_set_per_vf_res(struct ice_pf *pf, u16
> > num_vfs)
> >  	return 0;
> >  }
> > 
> > +/**
> > + * ice_sriov_get_irqs - get irqs for SR-IOV usacase
> > + * @pf: pointer to PF structure
> > + * @needed: number of irqs to get
> > + *
> > + * This returns the first MSI-X vector index in PF space that is used by this
> > + * VF. This index is used when accessing PF relative registers such as
> > + * GLINT_VECT2FUNC and GLINT_DYN_CTL.
> > + * This will always be the OICR index in the AVF driver so any functionality
> > + * using vf->first_vector_idx for queue configuration_id: id of VF which will
> > + * use this irqs
> > + *
> > + * Only SRIOV specific vectors are tracked in sriov_irq_bm. SRIOV vectors are
> > + * allocated from the end of global irq index. First bit in sriov_irq_bm means
> > + * last irq index etc. It simplifies extension of SRIOV vectors.
> > + * They will be always located from sriov_base_vector to the last irq
> > + * index. While increasing/decreasing sriov_base_vector can be moved.
> > + */
> > +static int ice_sriov_get_irqs(struct ice_pf *pf, u16 needed)
> > +{
> > +	int res = bitmap_find_next_zero_area(pf->sriov_irq_bm,
> > +					     pf->sriov_irq_size, 0, needed, 0);
> > +	/* conversion from number in bitmap to global irq index */
> > +	int index = pf->sriov_irq_size - res - needed;
> > +
> > +	if (res >= pf->sriov_irq_size || index < pf->sriov_base_vector)
> > +		return -ENOENT;
> > +
> > +	bitmap_set(pf->sriov_irq_bm, res, needed);
> > +	return index;
> 
> Shouldn't it be possible to use the xarray that was recently done for dynamic IRQ allocation for this now? It might take a little more refactor work though, hmm. It feels weird to introduce yet another data structure for a nearly identical purpose...
> 

I used bitmap because it was easy to get linear irq indexes (it is need
for VF to have linear indexes). Do you know how to assume that with
xarray? I felt like solution with storing in xarray and searching for
linear space was more complicated than bitmap, but probably I don't know
useful xarray mechanism for that purpose. If you know please point me
and I will rewrite it to use xarray.

Thanks

[...]

