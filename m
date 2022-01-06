Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC934860C4
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 07:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234805AbiAFG4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 01:56:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234429AbiAFG4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 01:56:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB30C061245;
        Wed,  5 Jan 2022 22:56:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5108B81E58;
        Thu,  6 Jan 2022 06:56:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42AC7C36AE0;
        Thu,  6 Jan 2022 06:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641452188;
        bh=OT4lI4T6FzaaOZDI9lJEOy2kOsmIKxZLyxEul5kLoVQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k7SurF3Riwel3JQLN72+JhhUi4mFawATfXNNNcfN0T2xRmFZ63fI83f58cqVTyh2a
         KwM772GLDMyrjio3ygDfMpDTuEZbMKoHQpnkrpTp5lhZDmWd94y4Wnhli0oVp8+wut
         acfgGjTMVCgYYQ3f6CC4rdXwTcOOyHuQ6cMiqACT3t6/jYj+4q5rphgtPIvSk8hcg0
         1YJZpNM28e2rE6V6Rtqg5L70OZKY47rktfbfY8acTsvFzJ7VLZ0JJOP57hdWfRTcb7
         SgsqYtqDj+sz8Ms1gkqEwXymHPiRE4tiiDz5xWu9ZGuUFrrjdw6TnGCMQ6+CL7KCMT
         /VxKcU63es8kw==
Date:   Thu, 6 Jan 2022 08:56:17 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     "Ertman, David M" <david.m.ertman@intel.com>
Cc:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "Kaliszczuk, Leszek" <leszek.kaliszczuk@intel.com>
Subject: Re: [PATCH net-next 1/1] ice: Simplify tracking status of RDMA
 support
Message-ID: <YdaSkbEVhscGXQe3@unreal>
References: <20220105000456.2510590-1-anthony.l.nguyen@intel.com>
 <YdVGaK1uMUv7frZ1@unreal>
 <MW5PR11MB5811D45DEC5BEC61CD2411B6DD4B9@MW5PR11MB5811.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW5PR11MB5811D45DEC5BEC61CD2411B6DD4B9@MW5PR11MB5811.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 07:10:24PM +0000, Ertman, David M wrote:
> > -----Original Message-----
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Tuesday, January 4, 2022 11:19 PM
> > To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
> > Cc: davem@davemloft.net; kuba@kernel.org; Ertman, David M
> > <david.m.ertman@intel.com>; netdev@vger.kernel.org; linux-
> > rdma@vger.kernel.org; Saleem, Shiraz <shiraz.saleem@intel.com>; Ismail,
> > Mustafa <mustafa.ismail@intel.com>; Kaliszczuk, Leszek
> > <leszek.kaliszczuk@intel.com>
> > Subject: Re: [PATCH net-next 1/1] ice: Simplify tracking status of RDMA
> > support
> > 
> > On Tue, Jan 04, 2022 at 04:04:56PM -0800, Tony Nguyen wrote:
> > > From: Dave Ertman <david.m.ertman@intel.com>
> > >
> > > The status of support for RDMA is currently being tracked with two
> > > separate status flags.  This is unnecessary with the current state of
> > > the driver.
> > >
> > > Simplify status tracking down to a single flag.
> > >
> > > Rename the helper function to denote the RDMA specific status and
> > > universally use the helper function to test the status bit.
> > >
> > > Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> > > Tested-by: Leszek Kaliszczuk <leszek.kaliszczuk@intel.com>
> > > Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> > > ---
> > >  drivers/net/ethernet/intel/ice/ice.h      |  3 ---
> > >  drivers/net/ethernet/intel/ice/ice_idc.c  |  6 +++---
> > >  drivers/net/ethernet/intel/ice/ice_lib.c  |  8 ++++----
> > >  drivers/net/ethernet/intel/ice/ice_lib.h  |  2 +-
> > >  drivers/net/ethernet/intel/ice/ice_main.c | 13 +++++--------
> > >  5 files changed, 13 insertions(+), 19 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/intel/ice/ice.h
> > b/drivers/net/ethernet/intel/ice/ice.h
> > > index 4e16d185077d..6f445cc3390f 100644
> > > --- a/drivers/net/ethernet/intel/ice/ice.h
> > > +++ b/drivers/net/ethernet/intel/ice/ice.h
> > > @@ -468,7 +468,6 @@ enum ice_pf_flags {
> > >  	ICE_FLAG_FD_ENA,
> > >  	ICE_FLAG_PTP_SUPPORTED,		/* PTP is supported by NVM
> > */
> > >  	ICE_FLAG_PTP,			/* PTP is enabled by software */
> > > -	ICE_FLAG_AUX_ENA,
> > >  	ICE_FLAG_ADV_FEATURES,
> > >  	ICE_FLAG_TC_MQPRIO,		/* support for Multi queue TC
> > */
> > >  	ICE_FLAG_CLS_FLOWER,
> > > @@ -886,7 +885,6 @@ static inline void ice_set_rdma_cap(struct ice_pf
> > *pf)
> > >  {
> > >  	if (pf->hw.func_caps.common_cap.rdma && pf->num_rdma_msix) {
> > >  		set_bit(ICE_FLAG_RDMA_ENA, pf->flags);
> > > -		set_bit(ICE_FLAG_AUX_ENA, pf->flags);
> > >  		ice_plug_aux_dev(pf);
> > >  	}
> > >  }
> > > @@ -899,6 +897,5 @@ static inline void ice_clear_rdma_cap(struct ice_pf
> > *pf)
> > >  {
> > >  	ice_unplug_aux_dev(pf);
> > >  	clear_bit(ICE_FLAG_RDMA_ENA, pf->flags);
> > > -	clear_bit(ICE_FLAG_AUX_ENA, pf->flags);
> > >  }
> > >  #endif /* _ICE_H_ */
> > > diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c
> > b/drivers/net/ethernet/intel/ice/ice_idc.c
> > > index fc3580167e7b..9493a38182f5 100644
> > > --- a/drivers/net/ethernet/intel/ice/ice_idc.c
> > > +++ b/drivers/net/ethernet/intel/ice/ice_idc.c
> > > @@ -79,7 +79,7 @@ int ice_add_rdma_qset(struct ice_pf *pf, struct
> > iidc_rdma_qset_params *qset)
> > >
> > >  	dev = ice_pf_to_dev(pf);
> > >
> > > -	if (!test_bit(ICE_FLAG_RDMA_ENA, pf->flags))
> > > +	if (!ice_is_rdma_ena(pf))
> > >  		return -EINVAL;
> > >
> > >  	vsi = ice_get_main_vsi(pf);
> > > @@ -236,7 +236,7 @@ EXPORT_SYMBOL_GPL(ice_get_qos_params);
> > >   */
> > >  static int ice_reserve_rdma_qvector(struct ice_pf *pf)
> > >  {
> > > -	if (test_bit(ICE_FLAG_RDMA_ENA, pf->flags)) {
> > > +	if (ice_is_rdma_ena(pf)) {
> > >  		int index;
> > >
> > >  		index = ice_get_res(pf, pf->irq_tracker, pf-
> > >num_rdma_msix,
> > > @@ -274,7 +274,7 @@ int ice_plug_aux_dev(struct ice_pf *pf)
> > >  	/* if this PF doesn't support a technology that requires auxiliary
> > >  	 * devices, then gracefully exit
> > >  	 */
> > > -	if (!ice_is_aux_ena(pf))
> > > +	if (!ice_is_rdma_ena(pf))
> > >  		return 0;
> > 
> > This check is redundant, you already checked it in ice_probe.
> > 
> 
> This function is called from other places besides ice_probe (after a reset for instance).

Right, and arguably the ice_rebuild() should have same check as in
ice_probe(). Other places shouldn't call to this ice_plug_aux_dev() if
RDMA is not supported. For example, you shouldn't present to the user
roce_en/iwarp_en devlink knobs if your device missing RDMA capability
bit. Maybe you did it, maybe not, I didn't check.

It is much easier to review if the function foo() is called only when it
is supported. It is also common kernel practice is that caller should check
and meet function requirements before such call.

> 
> This central check stops the creation of the auxiliary device if it has been determined if
> RDMA functionality should not be allowed whenever ice_plug_aux_dev is called.  The first
> check in ice_probe stops even allocating the memory for the device if RDMA is not supported
> at all.

I know.

> 
> > >
> > >  	iadev = kzalloc(sizeof(*iadev), GFP_KERNEL);
> > > diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c
> > b/drivers/net/ethernet/intel/ice/ice_lib.c
> > > index 0c187cf04fcf..b1c164b8066c 100644
> > > --- a/drivers/net/ethernet/intel/ice/ice_lib.c
> > > +++ b/drivers/net/ethernet/intel/ice/ice_lib.c
> > > @@ -732,14 +732,14 @@ bool ice_is_safe_mode(struct ice_pf *pf)
> > >  }
> > >
> > >  /**
> > > - * ice_is_aux_ena
> > > + * ice_is_rdma_ena
> > >   * @pf: pointer to the PF struct
> > >   *
> > > - * returns true if AUX devices/drivers are supported, false otherwise
> > > + * returns true if RDMA is currently supported, false otherwise
> > >   */
> > > -bool ice_is_aux_ena(struct ice_pf *pf)
> > > +bool ice_is_rdma_ena(struct ice_pf *pf)
> > >  {
> > > -	return test_bit(ICE_FLAG_AUX_ENA, pf->flags);
> > > +	return test_bit(ICE_FLAG_RDMA_ENA, pf->flags);
> > >  }
> > >
> > >  /**
> > > diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h
> > b/drivers/net/ethernet/intel/ice/ice_lib.h
> > > index b2ed189527d6..a2f54fbdc170 100644
> > > --- a/drivers/net/ethernet/intel/ice/ice_lib.h
> > > +++ b/drivers/net/ethernet/intel/ice/ice_lib.h
> > > @@ -110,7 +110,7 @@ void ice_set_q_vector_intrl(struct ice_q_vector
> > *q_vector);
> > >  int ice_vsi_cfg_mac_fltr(struct ice_vsi *vsi, const u8 *macaddr, bool set);
> > >
> > >  bool ice_is_safe_mode(struct ice_pf *pf);
> > > -bool ice_is_aux_ena(struct ice_pf *pf);
> > > +bool ice_is_rdma_ena(struct ice_pf *pf);
> > >  bool ice_is_dflt_vsi_in_use(struct ice_sw *sw);
> > >
> > >  bool ice_is_vsi_dflt_vsi(struct ice_sw *sw, struct ice_vsi *vsi);
> > > diff --git a/drivers/net/ethernet/intel/ice/ice_main.c
> > b/drivers/net/ethernet/intel/ice/ice_main.c
> > > index e29176889c23..078eb588f41e 100644
> > > --- a/drivers/net/ethernet/intel/ice/ice_main.c
> > > +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> > > @@ -3653,11 +3653,8 @@ static void ice_set_pf_caps(struct ice_pf *pf)
> > >  	struct ice_hw_func_caps *func_caps = &pf->hw.func_caps;
> > >
> > >  	clear_bit(ICE_FLAG_RDMA_ENA, pf->flags);
> > > -	clear_bit(ICE_FLAG_AUX_ENA, pf->flags);
> > > -	if (func_caps->common_cap.rdma) {
> > > +	if (func_caps->common_cap.rdma)
> > >  		set_bit(ICE_FLAG_RDMA_ENA, pf->flags);
> > > -		set_bit(ICE_FLAG_AUX_ENA, pf->flags);
> > > -	}
> > >  	clear_bit(ICE_FLAG_DCB_CAPABLE, pf->flags);
> > >  	if (func_caps->common_cap.dcb)
> > >  		set_bit(ICE_FLAG_DCB_CAPABLE, pf->flags);
> > > @@ -3785,7 +3782,7 @@ static int ice_ena_msix_range(struct ice_pf *pf)
> > >  	v_left -= needed;
> > >
> > >  	/* reserve vectors for RDMA auxiliary driver */
> > > -	if (test_bit(ICE_FLAG_RDMA_ENA, pf->flags)) {
> > > +	if (ice_is_rdma_ena(pf)) {
> > >  		needed = num_cpus + ICE_RDMA_NUM_AEQ_MSIX;
> > >  		if (v_left < needed)
> > >  			goto no_hw_vecs_left_err;
> > > @@ -3826,7 +3823,7 @@ static int ice_ena_msix_range(struct ice_pf *pf)
> > >  			int v_remain = v_actual - v_other;
> > >  			int v_rdma = 0, v_min_rdma = 0;
> > >
> > > -			if (test_bit(ICE_FLAG_RDMA_ENA, pf->flags)) {
> > > +			if (ice_is_rdma_ena(pf)) {
> > >  				/* Need at least 1 interrupt in addition to
> > >  				 * AEQ MSIX
> > >  				 */
> > > @@ -3860,7 +3857,7 @@ static int ice_ena_msix_range(struct ice_pf *pf)
> > >  			dev_notice(dev, "Enabled %d MSI-X vectors for LAN
> > traffic.\n",
> > >  				   pf->num_lan_msix);
> > >
> > > -			if (test_bit(ICE_FLAG_RDMA_ENA, pf->flags))
> > > +			if (ice_is_rdma_ena(pf))
> > >  				dev_notice(dev, "Enabled %d MSI-X vectors
> > for RDMA.\n",
> > >  					   pf->num_rdma_msix);
> > >  		}
> > > @@ -4688,7 +4685,7 @@ ice_probe(struct pci_dev *pdev, const struct
> > pci_device_id __always_unused *ent)
> > >
> > >  	/* ready to go, so clear down state bit */
> > >  	clear_bit(ICE_DOWN, pf->state);
> > 
> > Why don't you clear this bit after RDMA initialization?
> 
> We want the interface to be completely ready before we initialize RDMA
> communication.  Also, this bit is not relevant to the RDMA queues, so before
> or after RDMA initialization doesn't matter since RDMA traffic doesn't go through
> the LAN netdev anyway.

There is a difference between fully configured and enabled as this bbit
represents. 

Anyway,

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
