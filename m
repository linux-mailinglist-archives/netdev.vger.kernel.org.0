Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C724D6488F8
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 20:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiLIT2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 14:28:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiLIT2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 14:28:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56ECAC6DA;
        Fri,  9 Dec 2022 11:28:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71BFA622F2;
        Fri,  9 Dec 2022 19:28:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4510C433EF;
        Fri,  9 Dec 2022 19:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670614109;
        bh=bpt0ryWMaMpNf9FgM6M8LIBPt9HeHabg8TDV8VXTT48=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hY7hbr5CKXyxVJe1QK9RVU2PYOkrtCAi4HxKhHL3plCyN0DeigimSiEsuzHJ4j5Fv
         Im2Z6UdHQEaI0wEaL2chU0mv0a9fe9YFZmjJTv2aH4FzwJH7zNPN+yEZaUz7XOndv8
         HgkhYbhX9q+LySwobZ8yBuIi+E7fhKm5niieHCYzHxjxi0WeTzIdmILYmb8E3/4tpr
         2QxG6miqJ6vdnoU6l2RV7Iv3lfx/XFIrqncffIb1vwCW/rkRRNEWXX4nWIacv39w0j
         0Dq5zOzaLbQVPdAebeLyNi9hgSfRLXo0wcImIEFQOsPWdMEWWo80gRY0AxD5Cv6yCZ
         AxQqGYKlU71Kg==
Date:   Fri, 9 Dec 2022 11:28:28 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     "Ertman, David M" <david.m.ertman@intel.com>
Cc:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "G, GurucharanX" <gurucharanx.g@intel.com>
Subject: Re: [PATCH net 2/4] ice: Correctly handle aux device when num
 channels change
Message-ID: <Y5OMXATsatvNGGS/@x130>
References: <20221207211040.1099708-1-anthony.l.nguyen@intel.com>
 <20221207211040.1099708-3-anthony.l.nguyen@intel.com>
 <Y5ES3kmYSINlAQhz@x130>
 <MW5PR11MB5811E652D63BC5CC934F256DDD1C9@MW5PR11MB5811.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <MW5PR11MB5811E652D63BC5CC934F256DDD1C9@MW5PR11MB5811.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09 Dec 17:21, Ertman, David M wrote:
>> -----Original Message-----
>> From: Saeed Mahameed <saeed@kernel.org>
>> Sent: Wednesday, December 7, 2022 2:26 PM
>> To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
>> Cc: davem@davemloft.net; kuba@kernel.org; pabeni@redhat.com;
>> edumazet@google.com; Ertman, David M <david.m.ertman@intel.com>;
>> netdev@vger.kernel.org; Saleem, Shiraz <shiraz.saleem@intel.com>; Ismail,
>> Mustafa <mustafa.ismail@intel.com>; jgg@nvidia.com; leonro@nvidia.com;
>> linux-rdma@vger.kernel.org; G, GurucharanX <gurucharanx.g@intel.com>
>> Subject: Re: [PATCH net 2/4] ice: Correctly handle aux device when num
>> channels change
>>
>> On 07 Dec 13:10, Tony Nguyen wrote:
>> >From: Dave Ertman <david.m.ertman@intel.com>
>> >
>> >When the number of channels/queues changes on an interface, it is
>> necessary
>> >to change how those resources are distributed to the auxiliary device for
>> >maintaining RDMA functionality.  To do this, the best way is to unplug, and
>>
>> Can you please explain how an ethtool can affect RDMA functionality ?
>> don't you have full bifurcation between the two eth and rdma interfaces ..
>>
>This patch is to address a bug where the number of queues for the interface was
>changed and the RDMA lost functionality due to queues being re-assigned.
>

sounds like an rdma or PF bug.

>The PF is managing and setting aside resources for the RDMA aux dev. Then the
>RDMA aux driver will request resources from the PF driver.  Changes in
>the total number of resources make it so that resources previously
>allocated to RDMA aux driver may not be available any more.  A re-allocation
>is necessary to ensure that RDMA has all of the queues that it thinks it does.
>

IMO it's wrong to re-initialize a parallel subsystems due to an ethtool, 
ethtool is meant to control the netdev interface, not rdma. Either
statically allocate these resources on boot or just store them in a free 
pool in PF until next time rdma reloads by an rdma user command outside of
netdev.

>> >then re-plug the auxiliary device.  This will cause all current resource
>> >allocation to be released, and then re-requested under the new state.
>> >
>>
>> I find this really disruptive, changing number of netdev queues to cause
>> full aux devs restart !
>>
>
>Changing the number of queues available to the interface *is* a disruptive action.

yes to the netdev, not to rdma or usb, or the pci bus, you get my point.

>The netdev  and VSI have to be re-configured for queues per TC and the RDMA aux
>driver has to re-allocate qsets to attach queue-pairs to.
>

sure for netdev, but it doesn't make sense to reload rdma, if rdma was
using X queues, it should continue using X queues.. if you can't support
dynamic netdev changes without disturbing rdma, then block ethtool until
user unloads rdma. 

>> >Since the set_channel command from ethtool comes in while holding the
>> RTNL
>> >lock, it is necessary to offset the plugging and unplugging of auxiliary
>> >device to another context.  For this purpose, set the flags for UNPLUG and
>> >PLUG in the PF state, then respond to them in the service task.
>> >
>> >Also, since the auxiliary device will be unplugged/plugged at the end of
>> >the flow, it is better to not send the event for TCs changing in the
>> >middle of the flow.  This will prevent a timing issue between the events
>> >and the probe/release calls conflicting.
>> >
>> >Fixes: 348048e724a0 ("ice: Implement iidc operations")
>> >Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
>> >Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent
>> worker at Intel)
>> >Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
>> >---
>> > drivers/net/ethernet/intel/ice/ice.h         | 2 ++
>> > drivers/net/ethernet/intel/ice/ice_ethtool.c | 6 ++++++
>> > drivers/net/ethernet/intel/ice/ice_idc.c     | 3 +++
>> > drivers/net/ethernet/intel/ice/ice_main.c    | 3 +++
>> > 4 files changed, 14 insertions(+)
>> >
>> >diff --git a/drivers/net/ethernet/intel/ice/ice.h
>> b/drivers/net/ethernet/intel/ice/ice.h
>> >index 001500afc4a6..092e572768fe 100644
>> >--- a/drivers/net/ethernet/intel/ice/ice.h
>> >+++ b/drivers/net/ethernet/intel/ice/ice.h
>> >@@ -281,6 +281,7 @@ enum ice_pf_state {
>> > 	ICE_FLTR_OVERFLOW_PROMISC,
>> > 	ICE_VF_DIS,
>> > 	ICE_CFG_BUSY,
>> >+	ICE_SET_CHANNELS,
>> > 	ICE_SERVICE_SCHED,
>> > 	ICE_SERVICE_DIS,
>> > 	ICE_FD_FLUSH_REQ,
>> >@@ -485,6 +486,7 @@ enum ice_pf_flags {
>> > 	ICE_FLAG_VF_VLAN_PRUNING,
>> > 	ICE_FLAG_LINK_LENIENT_MODE_ENA,
>> > 	ICE_FLAG_PLUG_AUX_DEV,
>> >+	ICE_FLAG_UNPLUG_AUX_DEV,
>> > 	ICE_FLAG_MTU_CHANGED,
>> > 	ICE_FLAG_GNSS,			/* GNSS successfully
>> initialized */
>> > 	ICE_PF_FLAGS_NBITS		/* must be last */
>> >diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c
>> b/drivers/net/ethernet/intel/ice/ice_ethtool.c
>> >index b7be84bbe72d..37e174a19860 100644
>> >--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
>> >+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
>> >@@ -3536,6 +3536,8 @@ static int ice_set_channels(struct net_device
>> *dev, struct ethtool_channels *ch)
>> > 		return -EINVAL;
>> > 	}
>> >
>> >+	set_bit(ICE_SET_CHANNELS, pf->state);
>> >+
>> > 	ice_vsi_recfg_qs(vsi, new_rx, new_tx);
>> >
>> > 	if (!netif_is_rxfh_configured(dev))
>> >@@ -3543,6 +3545,10 @@ static int ice_set_channels(struct net_device
>> *dev, struct ethtool_channels *ch)
>> >
>> > 	/* Update rss_size due to change in Rx queues */
>> > 	vsi->rss_size = ice_get_valid_rss_size(&pf->hw, new_rx);
>> >+	clear_bit(ICE_SET_CHANNELS, pf->state);
>> >+
>>
>> you just set this new state a few lines ago, clearing the bit in the same
>> function few lines later seems to be an abuse of the pf state machine,
>> couldn't you just pass a parameter to the functions which needed this
>> information ?
>>
>
>How is this abusing the PF state machine?  There is a 3 deep function call that needs
>the information that this is a set_channel context, and each of those functions is called
>from several locations - how is changing all of those functions to include a parameter

this is exactly the abuse i was talking about, setting a flag on a global
state field because the function call is too deep.

>(that will be false for all of them but this instance) be less abusive than setting and
>clearing a bit?

this is not future sustainable and not reviewer friendly, it's a local
parameter and shouldn't be a global flag.

Anyway this is your driver, i am not going to force you to do something you
don't like.

but for the reloading of rdma due to an ethtool is a no for me..
let's find a common place for all vendors to express such limitations,
e.g. devlink .. 

>
>> >+	set_bit(ICE_FLAG_UNPLUG_AUX_DEV, pf->flags);
>> >+	set_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags);
>> >
>> > 	return 0;
>> > }
>
