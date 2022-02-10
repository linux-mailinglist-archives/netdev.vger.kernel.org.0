Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 774524B0DC5
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 13:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241717AbiBJMtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 07:49:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235587AbiBJMtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 07:49:24 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D7FA25C7
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 04:49:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644497365; x=1676033365;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/BRnoMrdiIX+2HQxsmAA+gxVOVwvF5NzYsJTXMYeU+w=;
  b=Dy7oPs1zegCFwXH4be4geqp5qyj6CcoNG5SyBKWvUj7aA8ZwmQDH5Q1K
   sUlJlpl3eedt35Un+3MTbfB/CkZAt6/7r9ad2GObt7hiHVfuLrVjXbeth
   uF1+8hNNPVLJgLcD88rQfyJC67VvX+/eiLWhbYFvLp6+xmMEkE1qYuEfP
   Q9TQhW+Hb9HULga6kDMnCv0SGGeN/YuIGJxJEPy98ILpEzK/nS3dYTz80
   vrZESIF9s+ELveBt/ffDHrZkWzOzda96k5WbHIBL4dHx+kdKqNiE7C0DX
   CGxnybRjY8DFN+Nss9pIxhunPK9V9VH0Vp2IYxMi34EPyBxJ8iWrGvr7M
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10253"; a="310220688"
X-IronPort-AV: E=Sophos;i="5.88,358,1635231600"; 
   d="scan'208";a="310220688"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 04:49:25 -0800
X-IronPort-AV: E=Sophos;i="5.88,358,1635231600"; 
   d="scan'208";a="541594855"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 04:49:22 -0800
Date:   Thu, 10 Feb 2022 04:50:30 -0500
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, tparkin@katalix.com, jhs@mojatatu.com,
        boris.sukholitko@broadcom.com, felipe@sipanda.io, tom@sipanda.io,
        sridhar.samudrala@intel.com, marcin.szycik@linux.intel.com,
        wojciech.drewek@intel.com, grzegorz.nitka@intel.com,
        michal.swiatkowski@intel.com
Subject: Re: hw offload for new protocols
Message-ID: <YgTf5n/I/kyuFV6c@localhost.localdomain>
References: <YgN/EiV/di4vtzdE@localhost.localdomain>
 <YgPLy1p4wBALvSGZ@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgPLy1p4wBALvSGZ@nanopsycho>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 09, 2022 at 03:12:27PM +0100, Jiri Pirko wrote:
> Wed, Feb 09, 2022 at 09:45:06AM CET, michal.swiatkowski@linux.intel.com wrote:
> >Hi,
> >
> >I would like to add matching on values from protocol that isn't yet
> >supported in kernel, but my hw has abilitty to offload it (session id
> >in pfcp for example).
> >What is a correct way to implement it in kernel? I was searching on ML
> >for threads about that but I didn't find answer to all my concerns.
> >
> >I assume that for hw offload we should reuse tc flower, which already
> >has great ability to offload bunch of widely used protocols. To match on
> >my session id value I will for sure have to add another field in tc
> >(user and kernel part). Something like this:
> >#tc filter add dev $DEV protocol ip parent ffff: flower dst_ip $IP
> >session_id 0102030405060708 action drop
> >
> >Should SW path be also supported? I think that yes, so, this will
> 
> Yes.
> 
> 
> >need adding handling this new field in flow_dissector. I have read
> 
> Correct.
> 
> 
> >thread with adding new field to it [1] and my feeling from it is: better
> >do not add new fields there :) . However, if it is fine to expand
> >flow_dissector, how to do it in this particular case? Can I check udp
> >port in flow dissector code and based on that dissect session id from
> >pfcp header? Won't this lead to a lot of new code for each different
> >protocols based on well known port numbers?
> 
> I don't think it is good idea to base the flow dissector branch decision
> on a well known UDP port.
> 
> 
Ok, will it be better to base it on next header like in VXLAN (and
other tunnels)? But this will need setting tunel info. PFCP isn't really
tunnel. Maybe it can be treat as tunnel without tunneled data?

> >
> >What about $DEV from tc command? In hw offload for example for VXLAN or
> >geneve based on this hw knows what type of flow should be offloaded. It
> >will be great to have the same ability for pfcp (in my case), to allow
> >adding rule without pfcp specific fileds:
> >#tc filter add dev $PFCP_DEV protocol ip parent ffff: flower dst_ip $IP
> >action drop
> 
> Yes, I agree.
> 
> 
> >Or maybe in this kind of flows we should always add in tc flower correct
> >port number which will tell hw that this flow is pfcp?
> >#tc filter add dev $DEV protocol ip parent ffff: flower dst_ip $IP
> >enc_dst_port $well_know_pfcp action drop
> >
> >If creating new netdev (pfcp in this case) is fine solution, how pfcp
> >driver should look like? Is code for receiving and xmit sufficient? Or
> >is there need to implement more pfcp features in the new driver? To not
> >have sth like dummy pfcp driver only to point to it in tc. There was
> >review with virtual netdev [2] - which drops every packet that returns from
> >classyfing (I assume not offloaded by hw). Maybe this solution is
> >better?
> 
> Not sure how it fits on PFCP.
> 
> 
> >
> >I have also seen panda (flower 2) [3]. It isn' available in kernel now.
> >Do we know timeline for this feature? From review discussion I don't
> >know if it allow offloading cases like my in hw which wasn't design to
> >support panda offload.
> >
> >I feel like I can solve all my concerns using u32 classifier (but I can
> >be wrong). I thought about creating user space app that will translate
> >human readable command to u32. Hw will try to offload u32 command if
> >given flow can be offloaded, if not software path will work as usally. I
> >have seen that few drivers support u32 offload, but it looks like the
> >code is from before creation of flower classifier. Do You know if
> >someone try this combination (user app + u32 + hw offload)?
> >
> >I am talking about pfcp, but there is few more protocols that hw can
> >offload, but lack of support in flow dissector is successfully
> >complicating hw offload.
> >
> >Thanks for any comments about this topic,
> >Michal
> >
> >
> >[1] https://lore.kernel.org/netdev/20210830080800.18591-1-boris.sukholitko@broadcom.com/
> >[2] https://lore.kernel.org/netdev/20210929094514.15048-1-tparkin@katalix.com/
> >[3] https://lore.kernel.org/netdev/20210916200041.810-1-felipe@expertise.dev/
