Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A18A6D9552
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 13:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237929AbjDFLdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 07:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237943AbjDFLcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 07:32:39 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1207A9740
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 04:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680780737; x=1712316737;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iek0YMET6BA2WBV/5OtxKMjiMxedxx7tDo0er7rQnM0=;
  b=XjD4E4d17Tq2Eu9FEKoomPk4ONjHc9Le0vKrhEssZ9iumtoskh5Wii1A
   L1Xj7H/uqW9HIu1bLH5oINWYbjug7Qc++ByqidXVzJ/bh+4/wm2HTPVyn
   ym4kEk7OMDhzm9uiCzFYl9XzSpkF6engn7cy6PR1GzfVUZFejtILYZMUO
   8/mXk1Hrj/dVMuRO4SMnHYbpWWEJoLTsF8dwbKzcIBGvpsw4voCoNBtqX
   Utl6pfFs1LbUNrhh1s6Wyb1qjutJ1SH4G7h6hNoWbjmdM7cduZ9NzVR1V
   S8E1eFdyEbdnJS/CdCjM1kZ8O7W7LUE4kueGKEzJcuvAJ4Gc6uosMqPNH
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="331323668"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="331323668"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2023 04:32:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="717417206"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="717417206"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2023 04:32:07 -0700
Date:   Thu, 6 Apr 2023 13:32:04 +0200
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        wojciech.drewek@intel.com, piotr.raczynski@intel.com,
        pmenzel@molgen.mpg.de
Subject: Re: [PATCH net-next v3 3/5] ice: allow matching on meta data
Message-ID: <ZC6ttC+qX/Z0UZb2@localhost.localdomain>
References: <20230405075113.455662-1-michal.swiatkowski@linux.intel.com>
 <20230405075113.455662-4-michal.swiatkowski@linux.intel.com>
 <8559d4df-71a8-8d4f-b2f6-91f69281f2d9@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8559d4df-71a8-8d4f-b2f6-91f69281f2d9@intel.com>
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 03:31:01PM +0200, Alexander Lobakin wrote:
> From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Date: Wed, 5 Apr 2023 09:51:11 +0200
> 
> > Add meta data matching criteria in the same place as protocol matching
> > criteria. There is no need to add meta data as special words after
> > parsing all lookups. Trade meta data in the same why as other lookups.
> > 
> > The one difference between meta data lookups and protocol lookups is
> > that meta data doesn't impact how the packets looks like. Because of that
> > ignore it when filling testing packet.
> 
> [...]
> 
> > --- a/drivers/net/ethernet/intel/ice/ice_switch.h
> > +++ b/drivers/net/ethernet/intel/ice/ice_switch.h
> > @@ -186,12 +186,14 @@ struct ice_adv_rule_flags_info {
> >  };
> >  
> >  struct ice_adv_rule_info {
> > +	/* Store metadata values in rule info */
> >  	enum ice_sw_tunnel_type tun_type;
> >  	u16 vlan_type;
> >  	u16 fltr_rule_id;
> >  	u32 priority;
> >  	struct ice_sw_act_ctrl sw_act;
> >  	struct ice_adv_rule_flags_info flags_info;
> > +	u16 src_vsi;
> 
> Minor: since these 2 bytes will introduce 2-byte hole or padding either
> way, I think it's okay to put this field somewhere around rule ID or
> priority, i.e. other primitives. So that when someone is adding new
> short field, he'll see there is a hole and use it. u16 after 2 big
> structures looks a bit off to me, sorry for the initial confusion with
> this "please no holes at all!11" -- it's highly desired, but not by
> sacrificing logical grouping :D
> 

Good point, it looks a little strange, I will move it :)

Thanks,
Michal

> >  };
> >  
> >  /* A collection of one or more four word recipe */
> [...]
> 
> Thanks,
> Olek
