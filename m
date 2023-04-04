Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC736D5F64
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 13:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234859AbjDDLpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 07:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234434AbjDDLpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 07:45:06 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B084FFF
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 04:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680608701; x=1712144701;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=vm1lwowvPFkAxTBEwsrasNh7c7SDr0vvVpU7N24XPVk=;
  b=Re/O6sTWs6RAfwiEHitfwKMM/a0jvxMLP5Ad1MgDpjXNqGIOOk8EF1aG
   U9onWFnMJcJTCE/vbTpWPEF2aXrJSvBSa2RDec0a2AE2HumPyCobAqwMm
   SHatNH+Ie1nlTfGqgb0sSKJX8ojFFBfmG6uJUNj2iBSLeJPuM99ltv76B
   xVVqR+tkeIHoc26qBzTaiL64AkSAlIAnNDkNg6CEN95o9JkhVqMDNO+IZ
   pM9/XXLOnc3OFi9HWbmUJRtPQ9x5AL/uWEEpq972tyXuDRc0gNQIBJQgE
   Ru3wPbUsth3L32E2XtOckHDmOD3rdxYNs+vJWkY1QXft39uWj/z8kskyN
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="339645422"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="339645422"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 04:45:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="663567401"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="663567401"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 04:44:59 -0700
Date:   Tue, 4 Apr 2023 13:44:56 +0200
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>
Subject: Re: [Intel-wired-lan] [PATCH net-next v2 4/4] ice: use src VSI
 instead of src MAC in slow-path
Message-ID: <ZCwNuAOy7Okk66C0@localhost.localdomain>
References: <20230404072833.3676891-1-michal.swiatkowski@linux.intel.com>
 <20230404072833.3676891-5-michal.swiatkowski@linux.intel.com>
 <43a33d1a-3b04-86a1-b538-d906b517b7d0@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <43a33d1a-3b04-86a1-b538-d906b517b7d0@intel.com>
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 12:30:42PM +0200, Alexander Lobakin wrote:
> From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Date: Tue,  4 Apr 2023 09:28:33 +0200
> 
> > The use of a source  MAC to direct packets from the VF to the
> > corresponding port representor is only ok if there is only one
> > MAC on a VF. To support this functionality when the number
> > of MACs on a VF is greater, it is necessary to match a source
> > VSI instead of a source MAC.
> 
> [...]
> 
> > @@ -32,11 +31,9 @@
> >  	if·(!list)
> >  		return·-ENOMEM;
> >
> > -	list[0].type·=·ICE_MAC_OFOS;
> > -	ether_addr_copy(list[0].h_u.eth_hdr.src_addr,·mac);
> > -	eth_broadcast_addr(list[0].m_u.eth_hdr.src_addr);
> > +	ice_rule_add_src_vsi_metadata(&list[0]);
> 
> &list[0] == list.
> 

Will do

> > -	rule_info.sw_act.flag·|=·ICE_FLTR_TX;
> > +	rule_info.sw_act.flag·=·ICE_FLTR_TX;
> >  	rule_info.sw_act.vsi_handle·=·ctrl_vsi->idx;
> 
> [...]
> 
> > @@ -269,10 +235,18 @@ static int ice_eswitch_setup_reprs(struct ice_pf *pf)
> >  			goto err;
> >  		}
> >  
> > +		if (ice_eswitch_add_vf_sp_rule(pf, vf)) {
> > +			ice_fltr_add_mac_and_broadcast(vsi,
> > +						       vf->hw_lan_addr,
> 
> Fits into the previous line :p
>

Yeah, will move it.

> > +						       ICE_FWD_TO_VSI);
> > +			goto err;
> > +		}
> > +
> 
> [...]
> 
> > diff --git a/drivers/net/ethernet/intel/ice/ice_protocol_type.h b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
> > index ed0ab8177c61..664e2f45e249 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_protocol_type.h
> > +++ b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
> > @@ -256,7 +256,9 @@ struct ice_nvgre_hdr {
> >   * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >   *
> >   * Source VSI = Source VSI of packet loopbacked in switch (for egress) (10b).
> > - *
> > + */
> > +#define ICE_MDID_SOURCE_VSI_MASK 0x3ff
> 
> GENMASK()?
>

Sorry, it should be there (Simon pointed it), but I forgot about
amending :( . Thanks for catching it.

> > +/*
> 
> A newline before this line maybe to improve readability a bit?
>

Will add

> >   * MDID 20
> >   * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >   * |A|B|C|D|E|F|R|R|G|H|I|J|K|L|M|N|
> 
> [...]
> 
> > --- a/drivers/net/ethernet/intel/ice/ice_repr.h
> > +++ b/drivers/net/ethernet/intel/ice/ice_repr.h
> > @@ -13,9 +13,8 @@ struct ice_repr {
> >  	struct net_device *netdev;
> >  	struct metadata_dst *dst;
> >  #ifdef CONFIG_ICE_SWITCHDEV
> > -	/* info about slow path MAC rule  */
> > -	struct ice_rule_query_data *mac_rule;
> > -	u8 rule_added;
> > +	/* info about slow path rule  */
> 
> Two spaces after 'rule' here :s
>

Will fix

> > +	struct ice_rule_query_data sp_rule;
> >  #endif
> >  };
> [...]
> 
> Thanks,
> Olek

Thanks for the review
Michal
