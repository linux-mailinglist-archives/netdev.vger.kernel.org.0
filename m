Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B87308F70
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 22:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233473AbhA2V23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 16:28:29 -0500
Received: from mga11.intel.com ([192.55.52.93]:29829 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233318AbhA2V21 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 16:28:27 -0500
IronPort-SDR: SERjRbNDL7PsRq16uTt7lURHC1VTB82ElItYKx2vYV/zrWk1R12Pox0PX4ilubHplw0Rfwu5tt
 yyjR2lJOnXmw==
X-IronPort-AV: E=McAfee;i="6000,8403,9879"; a="176978839"
X-IronPort-AV: E=Sophos;i="5.79,386,1602572400"; 
   d="scan'208";a="176978839"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2021 13:27:42 -0800
IronPort-SDR: EHnBB3E3HR89MCE+UOB9IAuwByLYhXtbemwdwONUzHdzEF3ILqAK3EKDGAxPJNNiUHx4X82G2L
 WFA9YXmOFa+g==
X-IronPort-AV: E=Sophos;i="5.79,386,1602572400"; 
   d="scan'208";a="431174255"
Received: from ndatiri-mobl.amr.corp.intel.com (HELO vcostago-mobl2.amr.corp.intel.com) ([10.212.145.249])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2021 13:27:41 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        Po Liu <po.liu@nxp.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>
Subject: Re: [PATCH net-next v3 6/8] igc: Add support for tuning frame
 preemption via ethtool
In-Reply-To: <20210126003243.x3c44pmxmieqsa6e@skbuf>
References: <20210122224453.4161729-1-vinicius.gomes@intel.com>
 <20210122224453.4161729-7-vinicius.gomes@intel.com>
 <20210126003243.x3c44pmxmieqsa6e@skbuf>
Date:   Fri, 29 Jan 2021 13:27:28 -0800
Message-ID: <87pn1nsabj.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <vladimir.oltean@nxp.com> writes:

> On Fri, Jan 22, 2021 at 02:44:51PM -0800, Vinicius Costa Gomes wrote:
>> The tc subsystem sets which queues are marked as preemptible, it's the
>> role of ethtool to control more hardware specific parameters. These
>> parameters include:
>> 
>>  - enabling the frame preemption hardware: As enabling frame
>>  preemption may have other requirements before it can be enabled, it's
>>  exposed via the ethtool API;
>> 
>>  - mininum fragment size multiplier: expressed in usually in the form
>>  of (1 + N)*64, this number indicates what's the size of the minimum
>>  fragment that can be preempted.
>
> And not one word has been said about the patch...

If I am undertanding this right. Will fix the commit message.

>
>> 
>> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
>> ---
>>  drivers/net/ethernet/intel/igc/igc.h         | 12 +++++
>>  drivers/net/ethernet/intel/igc/igc_defines.h |  4 ++
>>  drivers/net/ethernet/intel/igc/igc_ethtool.c | 53 ++++++++++++++++++++
>>  drivers/net/ethernet/intel/igc/igc_tsn.c     | 25 +++++++--
>>  4 files changed, 91 insertions(+), 3 deletions(-)
>> 
>> diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
>> index 35baae900c1f..1067c46e0bc2 100644
>> --- a/drivers/net/ethernet/intel/igc/igc.h
>> +++ b/drivers/net/ethernet/intel/igc/igc.h
>> @@ -87,6 +87,7 @@ struct igc_ring {
>>  	u8 queue_index;                 /* logical index of the ring*/
>>  	u8 reg_idx;                     /* physical index of the ring */
>>  	bool launchtime_enable;         /* true if LaunchTime is enabled */
>> +	bool preemptible;		/* true if not express */
>
> Mixing tabs and spaces?

Ugh. Will fix. Thanks.

>
>> +static int igc_ethtool_set_preempt(struct net_device *netdev,
>> +				   struct ethtool_fp *fpcmd,
>> +				   struct netlink_ext_ack *extack)
>> +{
>> +	struct igc_adapter *adapter = netdev_priv(netdev);
>> +	int i;
>> +
>> +	if (fpcmd->add_frag_size < 68 || fpcmd->add_frag_size > 260) {
>> +		NL_SET_ERR_MSG_MOD(extack, "Invalid value for add-frag-size");
>> +		return -EINVAL;
>> +	}
>
> This check should belong in ethtool, since there's nothing unusual about
> this supported range.
>
> Also, I believe that Jakub requested the min-frag-size to be passed as
> 0, 1, 2, 3 as the standard specifies it, and not its multiplied
> version?

Later, Michal Kubechek suggested using the multiplied value, to be
future proof and less dependent on some specific standard version.

>
>> +
>> +	adapter->frame_preemption_active = fpcmd->enabled;
>> +	adapter->add_frag_size = fpcmd->add_frag_size;
>> +
>> +	if (!adapter->frame_preemption_active)
>> +		goto done;
>> +
>> +	/* Enabling frame preemption requires TSN mode to be enabled,
>> +	 * which requires a schedule to be active. So, if there isn't
>> +	 * a schedule already configured, configure a simple one, with
>> +	 * all queues open, with 1ms cycle time.
>> +	 */
>> +	if (adapter->base_time)
>> +		goto done;
>
> Unless I'm missing something, you are interpreting an adapter->base_time
> value of zero as "no Qbv schedule on port", as if it was invalid to have
> a base-time of zero, which it isn't.

This HW has specific limitations, it doesn't allow a base_time in the
past. So a base_time of zero can be used to signify "No Qbv".

>
>> @@ -115,6 +130,9 @@ static int igc_tsn_enable_offload(struct igc_adapter *adapter)
>>  		if (ring->launchtime_enable)
>>  			txqctl |= IGC_TXQCTL_QUEUE_MODE_LAUNCHT;
>>  
>> +		if (ring->preemptible)
>> +			txqctl |= IGC_TXQCTL_PREEMPTABLE;
>
> I think this is the only place in the series where you use PREEMPTABLE
> instead of PREEMPTIBLE.

Yeah, on the datasheet it's written PREEMPTABLE, I chose to use this
spelling to make it easier to search for this bit in the datasheet.

>
>> +
>>  		wr32(IGC_TXQCTL(i), txqctl);
>>  	}
>
> Out of curiosity, where is the ring to traffic class mapping configured
> in the igc driver? I suppose that you have more rings than traffic classes.

The driver follows the default behaviour, that netdev->queue[0] maps to
ring[0], queue[1] to ring[1], and so on. And by default ring[0] has
higher priority than ring[1], ring[1] higher than ring[2], and so on.

The HW only has 4 rings/queues.


Cheers,
-- 
Vinicius
