Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3EE646401
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 23:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbiLGWZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 17:25:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiLGWZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 17:25:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2845B716DB;
        Wed,  7 Dec 2022 14:25:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD46AB8218D;
        Wed,  7 Dec 2022 22:25:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ED95C433D6;
        Wed,  7 Dec 2022 22:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670451935;
        bh=48iQSIJuIBBdZX550S2c0XM0x7EocNFP+Bx01h+15Ss=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OzmLA5u1Jb8lGg0kGAv+c9KpTFPlfGUOEj4lcqSv6EZezCBYzLyGYjb95xe+iCkM7
         +QM01MBoDgOoGHG0Zs84kRnnQitnfHst8/zmw+Y/3q9/9Ja4jezSJhx/QP1K8/Fnzx
         /9Lr7SgXd9YjftYnCiJphcjL51+fImex87EsZbzqmPV5lpVbszGMkNtq/T2EuATdyx
         b6K3PhTSA/N2lpyXtqkQP4qKFor4Y9fDfDdsTLAzxq1anaHPH3ipuYL6mG73VTQxCc
         Fa4U0EOkF6WCk3DqLmtjlX5dvnicanzzDIooxktnhW54m2a7/DtlffiSBPwirg9o6U
         Y0Cd+i4Xjxq7g==
Date:   Wed, 7 Dec 2022 14:25:34 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, Dave Ertman <david.m.ertman@intel.com>,
        netdev@vger.kernel.org, shiraz.saleem@intel.com,
        mustafa.ismail@intel.com, jgg@nvidia.com, leonro@nvidia.com,
        linux-rdma@vger.kernel.org, Gurucharan G <gurucharanx.g@intel.com>
Subject: Re: [PATCH net 2/4] ice: Correctly handle aux device when num
 channels change
Message-ID: <Y5ES3kmYSINlAQhz@x130>
References: <20221207211040.1099708-1-anthony.l.nguyen@intel.com>
 <20221207211040.1099708-3-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221207211040.1099708-3-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07 Dec 13:10, Tony Nguyen wrote:
>From: Dave Ertman <david.m.ertman@intel.com>
>
>When the number of channels/queues changes on an interface, it is necessary
>to change how those resources are distributed to the auxiliary device for
>maintaining RDMA functionality.  To do this, the best way is to unplug, and

Can you please explain how an ethtool can affect RDMA functionality ?
don't you have full bifurcation between the two eth and rdma interfaces .. 

>then re-plug the auxiliary device.  This will cause all current resource
>allocation to be released, and then re-requested under the new state.
>

I find this really disruptive, changing number of netdev queues to cause
full aux devs restart !

>Since the set_channel command from ethtool comes in while holding the RTNL
>lock, it is necessary to offset the plugging and unplugging of auxiliary
>device to another context.  For this purpose, set the flags for UNPLUG and
>PLUG in the PF state, then respond to them in the service task.
>
>Also, since the auxiliary device will be unplugged/plugged at the end of
>the flow, it is better to not send the event for TCs changing in the
>middle of the flow.  This will prevent a timing issue between the events
>and the probe/release calls conflicting.
>
>Fixes: 348048e724a0 ("ice: Implement iidc operations")
>Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
>Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
>Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
>---
> drivers/net/ethernet/intel/ice/ice.h         | 2 ++
> drivers/net/ethernet/intel/ice/ice_ethtool.c | 6 ++++++
> drivers/net/ethernet/intel/ice/ice_idc.c     | 3 +++
> drivers/net/ethernet/intel/ice/ice_main.c    | 3 +++
> 4 files changed, 14 insertions(+)
>
>diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
>index 001500afc4a6..092e572768fe 100644
>--- a/drivers/net/ethernet/intel/ice/ice.h
>+++ b/drivers/net/ethernet/intel/ice/ice.h
>@@ -281,6 +281,7 @@ enum ice_pf_state {
> 	ICE_FLTR_OVERFLOW_PROMISC,
> 	ICE_VF_DIS,
> 	ICE_CFG_BUSY,
>+	ICE_SET_CHANNELS,
> 	ICE_SERVICE_SCHED,
> 	ICE_SERVICE_DIS,
> 	ICE_FD_FLUSH_REQ,
>@@ -485,6 +486,7 @@ enum ice_pf_flags {
> 	ICE_FLAG_VF_VLAN_PRUNING,
> 	ICE_FLAG_LINK_LENIENT_MODE_ENA,
> 	ICE_FLAG_PLUG_AUX_DEV,
>+	ICE_FLAG_UNPLUG_AUX_DEV,
> 	ICE_FLAG_MTU_CHANGED,
> 	ICE_FLAG_GNSS,			/* GNSS successfully initialized */
> 	ICE_PF_FLAGS_NBITS		/* must be last */
>diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
>index b7be84bbe72d..37e174a19860 100644
>--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
>+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
>@@ -3536,6 +3536,8 @@ static int ice_set_channels(struct net_device *dev, struct ethtool_channels *ch)
> 		return -EINVAL;
> 	}
>
>+	set_bit(ICE_SET_CHANNELS, pf->state);
>+
> 	ice_vsi_recfg_qs(vsi, new_rx, new_tx);
>
> 	if (!netif_is_rxfh_configured(dev))
>@@ -3543,6 +3545,10 @@ static int ice_set_channels(struct net_device *dev, struct ethtool_channels *ch)
>
> 	/* Update rss_size due to change in Rx queues */
> 	vsi->rss_size = ice_get_valid_rss_size(&pf->hw, new_rx);
>+	clear_bit(ICE_SET_CHANNELS, pf->state);
>+

you just set this new state a few lines ago, clearing the bit in the same
function few lines later seems to be an abuse of the pf state machine, 
couldn't you just pass a parameter to the functions which needed this
information ? 

>+	set_bit(ICE_FLAG_UNPLUG_AUX_DEV, pf->flags);
>+	set_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags);
>
> 	return 0;
> }
>diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
>index 895c32bcc8b5..9bf6fa5ed4c8 100644
>--- a/drivers/net/ethernet/intel/ice/ice_idc.c
>+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
>@@ -37,6 +37,9 @@ void ice_send_event_to_aux(struct ice_pf *pf, struct iidc_event *event)
> 	if (WARN_ON_ONCE(!in_task()))
> 		return;
>
>+	if (test_bit(ICE_SET_CHANNELS, pf->state))
>+		return;
>+
> 	mutex_lock(&pf->adev_mutex);
> 	if (!pf->adev)
> 		goto finish;
>diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
>index d0f14e73e8da..d58f55a72ab3 100644
>--- a/drivers/net/ethernet/intel/ice/ice_main.c
>+++ b/drivers/net/ethernet/intel/ice/ice_main.c
>@@ -2300,6 +2300,9 @@ static void ice_service_task(struct work_struct *work)
> 		}
> 	}
>
>+	if (test_and_clear_bit(ICE_FLAG_UNPLUG_AUX_DEV, pf->flags))
>+		ice_unplug_aux_dev(pf);
>+
> 	if (test_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags)) {
> 		/* Plug aux device per request */
> 		ice_plug_aux_dev(pf);
>-- 
>2.35.1
>
