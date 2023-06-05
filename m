Return-Path: <netdev+bounces-8047-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3633F7228F8
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 16:38:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5988A1C20C43
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:38:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B82857474;
	Mon,  5 Jun 2023 14:38:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F8A10FB
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 14:38:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FEB9C433EF;
	Mon,  5 Jun 2023 14:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685975893;
	bh=2W1OIXFOehQuE7sIncf0YqQLrZtVV+bUfZCrMZp1XbA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iZJpfTYyp3nYNYjiccPDUUSjuKyNoSLmzB46Py3FeclpS9wo9FmX765nCkwbxeHtB
	 PCZnCGSmA13qMUCwrtp3jYFVFkpczoIYQITQ55Fx+cWjyZCqkpQJ8UcGhuIPtaZiWN
	 kmmLTssNfELEX90Y3ElZzTNgHGjh5Tj/aqobKVDBAUj3ll8jIpjo5IuXHkkm9lejjJ
	 D9DMbr5uHNPaqGX0lVOYl0sKnFucgi/evTEPWzBCOVYSlkCMCiCmhycfj9U/bfH9l2
	 l2WpcFYcL0L6kKFT2TMUzDGMxOdbgRwjPkJaTC5sC8ES6lUHjiPn3GSQ2tO2Hie31k
	 nh1YoJdPQleJg==
Date: Mon, 5 Jun 2023 16:38:09 +0200
From: Simon Horman <horms@kernel.org>
To: Eelco Chaudron <echaudro@redhat.com>
Cc: Simon Horman <simon.horman@corigine.com>, dev@openvswitch.org,
	netdev@vger.kernel.org, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, davem@davemloft.net
Subject: Re: [ovs-dev] [PATCH net] net: openvswitch: fix upcall counter
 access before allocation
Message-ID: <ZH3zUdkxvxgaYjxf@kernel.org>
References: <168595558535.1618839.4634246126873842766.stgit@ebuild>
 <ZH3X/lLNwfAIZfdq@corigine.com>
 <FD16AC44-E1DA-4E6A-AE3E-905D55AB1A7D@redhat.com>
 <ZH3eCENbZeSJ3MZS@corigine.com>
 <69E863E6-89C0-4AC7-85F1-022451CAD41A@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <69E863E6-89C0-4AC7-85F1-022451CAD41A@redhat.com>

On Mon, Jun 05, 2023 at 03:53:59PM +0200, Eelco Chaudron wrote:
> 
> 
> On 5 Jun 2023, at 15:07, Simon Horman wrote:
> 
> > On Mon, Jun 05, 2023 at 02:54:35PM +0200, Eelco Chaudron wrote:
> >>
> >>
> >> On 5 Jun 2023, at 14:41, Simon Horman wrote:
> >>
> >>> On Mon, Jun 05, 2023 at 10:59:50AM +0200, Eelco Chaudron wrote:
> >>>> Currently, the per cpu upcall counters are allocated after the vport is
> >>>> created and inserted into the system. This could lead to the datapath
> >>>> accessing the counters before they are allocated resulting in a kernel
> >>>> Oops.
> >>>>
> >>>> Here is an example:
> >>>>
> >>>>   PID: 59693    TASK: ffff0005f4f51500  CPU: 0    COMMAND: "ovs-vswitchd"
> >>>>    #0 [ffff80000a39b5b0] __switch_to at ffffb70f0629f2f4
> >>>>    #1 [ffff80000a39b5d0] __schedule at ffffb70f0629f5cc
> >>>>    #2 [ffff80000a39b650] preempt_schedule_common at ffffb70f0629fa60
> >>>>    #3 [ffff80000a39b670] dynamic_might_resched at ffffb70f0629fb58
> >>>>    #4 [ffff80000a39b680] mutex_lock_killable at ffffb70f062a1388
> >>>>    #5 [ffff80000a39b6a0] pcpu_alloc at ffffb70f0594460c
> >>>>    #6 [ffff80000a39b750] __alloc_percpu_gfp at ffffb70f05944e68
> >>>>    #7 [ffff80000a39b760] ovs_vport_cmd_new at ffffb70ee6961b90 [openvswitch]
> >>>>    ...
> >>>>
> >>>>   PID: 58682    TASK: ffff0005b2f0bf00  CPU: 0    COMMAND: "kworker/0:3"
> >>>>    #0 [ffff80000a5d2f40] machine_kexec at ffffb70f056a0758
> >>>>    #1 [ffff80000a5d2f70] __crash_kexec at ffffb70f057e2994
> >>>>    #2 [ffff80000a5d3100] crash_kexec at ffffb70f057e2ad8
> >>>>    #3 [ffff80000a5d3120] die at ffffb70f0628234c
> >>>>    #4 [ffff80000a5d31e0] die_kernel_fault at ffffb70f062828a8
> >>>>    #5 [ffff80000a5d3210] __do_kernel_fault at ffffb70f056a31f4
> >>>>    #6 [ffff80000a5d3240] do_bad_area at ffffb70f056a32a4
> >>>>    #7 [ffff80000a5d3260] do_translation_fault at ffffb70f062a9710
> >>>>    #8 [ffff80000a5d3270] do_mem_abort at ffffb70f056a2f74
> >>>>    #9 [ffff80000a5d32a0] el1_abort at ffffb70f06297dac
> >>>>   #10 [ffff80000a5d32d0] el1h_64_sync_handler at ffffb70f06299b24
> >>>>   #11 [ffff80000a5d3410] el1h_64_sync at ffffb70f056812dc
> >>>>   #12 [ffff80000a5d3430] ovs_dp_upcall at ffffb70ee6963c84 [openvswitch]
> >>>>   #13 [ffff80000a5d3470] ovs_dp_process_packet at ffffb70ee6963fdc [openvswitch]
> >>>>   #14 [ffff80000a5d34f0] ovs_vport_receive at ffffb70ee6972c78 [openvswitch]
> >>>>   #15 [ffff80000a5d36f0] netdev_port_receive at ffffb70ee6973948 [openvswitch]
> >>>>   #16 [ffff80000a5d3720] netdev_frame_hook at ffffb70ee6973a28 [openvswitch]
> >>>>   #17 [ffff80000a5d3730] __netif_receive_skb_core.constprop.0 at ffffb70f06079f90
> >>>>
> >>>> We moved the per cpu upcall counter allocation to the existing vport
> >>>> alloc and free functions to solve this.
> >>>>
> >>>> Fixes: 95637d91fefd ("net: openvswitch: release vport resources on failure")
> >>>> Fixes: 1933ea365aa7 ("net: openvswitch: Add support to count upcall packets")
> >>>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> >>>> ---
> >>>>  net/openvswitch/datapath.c |   19 -------------------
> >>>>  net/openvswitch/vport.c    |    8 ++++++++
> >>>>  2 files changed, 8 insertions(+), 19 deletions(-)
> >>>>
> >>>> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> >>>> index fcee6012293b..58f530f60172 100644
> >>>> --- a/net/openvswitch/datapath.c
> >>>> +++ b/net/openvswitch/datapath.c
> >>>> @@ -236,9 +236,6 @@ void ovs_dp_detach_port(struct vport *p)
> >>>>  	/* First drop references to device. */
> >>>>  	hlist_del_rcu(&p->dp_hash_node);
> >>>>
> >>>> -	/* Free percpu memory */
> >>>> -	free_percpu(p->upcall_stats);
> >>>> -
> >>>>  	/* Then destroy it. */
> >>>>  	ovs_vport_del(p);
> >>>>  }
> >>>> @@ -1858,12 +1855,6 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
> >>>>  		goto err_destroy_portids;
> >>>>  	}
> >>>>
> >>>> -	vport->upcall_stats = netdev_alloc_pcpu_stats(struct vport_upcall_stats_percpu);
> >>>> -	if (!vport->upcall_stats) {
> >>>> -		err = -ENOMEM;
> >>>> -		goto err_destroy_vport;
> >>>> -	}
> >>>> -
> >>>>  	err = ovs_dp_cmd_fill_info(dp, reply, info->snd_portid,
> >>>>  				   info->snd_seq, 0, OVS_DP_CMD_NEW);
> >>>>  	BUG_ON(err < 0);
> >>>> @@ -1876,8 +1867,6 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
> >>>>  	ovs_notify(&dp_datapath_genl_family, reply, info);
> >>>>  	return 0;
> >>>>
> >>>> -err_destroy_vport:
> >>>> -	ovs_dp_detach_port(vport);
> >>>>  err_destroy_portids:
> >>>>  	kfree(rcu_dereference_raw(dp->upcall_portids));
> >>>>  err_unlock_and_destroy_meters:
> >>>> @@ -2322,12 +2311,6 @@ static int ovs_vport_cmd_new(struct sk_buff *skb, struct genl_info *info)
> >>>>  		goto exit_unlock_free;
> >>>>  	}
> >>>>
> >>>> -	vport->upcall_stats = netdev_alloc_pcpu_stats(struct vport_upcall_stats_percpu);
> >>>> -	if (!vport->upcall_stats) {
> >>>> -		err = -ENOMEM;
> >>>> -		goto exit_unlock_free_vport;
> >>>> -	}
> >>>> -
> >>>>  	err = ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
> >>>>  				      info->snd_portid, info->snd_seq, 0,
> >>>>  				      OVS_VPORT_CMD_NEW, GFP_KERNEL);
> >>>> @@ -2345,8 +2328,6 @@ static int ovs_vport_cmd_new(struct sk_buff *skb, struct genl_info *info)
> >>>>  	ovs_notify(&dp_vport_genl_family, reply, info);
> >>>>  	return 0;
> >>>>
> >>>> -exit_unlock_free_vport:
> >>>> -	ovs_dp_detach_port(vport);
> >>>>  exit_unlock_free:
> >>>>  	ovs_unlock();
> >>>>  	kfree_skb(reply);
> >>>> diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
> >>>> index 7e0f5c45b512..e91ae5dd7d22 100644
> >>>> --- a/net/openvswitch/vport.c
> >>>> +++ b/net/openvswitch/vport.c
> >>>
> >>> Hi Eelco,
> >>>
> >>> could we move to a more idiomatic implementation
> >>> of the error path in ovs_vport_alloc() ?
> >>>
> >>> I know it's not strictly related to this change, but OTOH, it is.
> >>
> >> Thanks Simon for the review…
> >>
> >> I decided to stick to fixing the issue, not trying to do cleanup stuff while at it :) But if there are no further comments by tomorrow, I can send a v2 including this change.
> >
> > Yeah, I see that. And I might have done the same thing.
> > But, OTOH, this change is making the error path more complex
> > (or at least more prone to error).
> >
> > In any case, the fix looks good.
> 
> Thanks, just to clarify if we get no further feedback on this patch, do you prefer a v2 with the error path changes?

Thanks Eelco,

Yes, that is my preference.

