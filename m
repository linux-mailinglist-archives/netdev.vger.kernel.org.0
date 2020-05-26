Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00AE71E2F04
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 21:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389722AbgEZS4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 14:56:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:33088 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389716AbgEZS4F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 14:56:05 -0400
IronPort-SDR: tD8NyE+PbRtH1YSPlpiJ5yDbOvAxj9EZTAaEQN0SwlRZEmZ3ui8x4OFYVwV8UMlJaf8Nb+tW60
 AwT/ywjFHBVA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2020 11:56:04 -0700
IronPort-SDR: MzdCeHkdVMgMBimDENZlcd+/zit7KYuu0VESQWkRVNAEnrDpf+FxtWMJmncJUgT+aD1SRPYCAE
 z9zOWDWUPT4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,437,1583222400"; 
   d="scan'208";a="468454053"
Received: from dspatli-mobl.amr.corp.intel.com (HELO ellie) ([10.212.21.42])
  by fmsmga006.fm.intel.com with ESMTP; 26 May 2020 11:56:03 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Murali Karicheri <m-karicheri2@ti.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        nsekhar@ti.com, grygorii.strashko@ti.com
Subject: Re: [net-next RFC PATCH 00/13] net: hsr: Add PRP driver
In-Reply-To: <5feae5ae-af46-f4b6-fe91-91a19036112b@ti.com>
References: <20200506163033.3843-1-m-karicheri2@ti.com> <87r1vdkxes.fsf@intel.com> <5feae5ae-af46-f4b6-fe91-91a19036112b@ti.com>
Date:   Tue, 26 May 2020 11:56:03 -0700
Message-ID: <87a71ule4c.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Murali Karicheri <m-karicheri2@ti.com> writes:

> Hi Vinicius,
>
> On 5/21/20 1:31 PM, Vinicius Costa Gomes wrote:
>> Murali Karicheri <m-karicheri2@ti.com> writes:
>> 
> ------------ Snip-------------
>
>>>    - prefix all common code with hsr_prp
>>>    - net/hsr -> renamed to net/hsr-prp
>>>    - All common struct types, constants, functions renamed with
>>>      hsr{HSR}_prp{PRP} prefix.
>> 
>> I don't really like these prefixes, I am thinking of when support for
>> IEEE 802.1CB is added, do we rename this to "hsr_prp_frer"?
>> 
>> And it gets even more complicated, and using 802.1CB you can configure
>> the tagging method and the stream identification function so a system
>> can interoperate in a HSR or PRP network.
>> 
>> So, I see this as different methods of achieving the same result, which
>> makes me think that the different "methods/types" (HSR and PRP in your
>> case) should be basically different implementations of a "struct
>> hsr_ops" interface. With this hsr_ops something like this:
>> 
>>     struct hsr_ops {
>>            int (*handle_frame)()
>>            int (*add_port)()
>>            int (*remove_port)()
>>            int (*setup)()
>>            void (*teardown)()
>>     };
>> 
>
> Thanks for your response!
>
> I agree with you that the prefix renaming is ugly. However I wasn't
> sure if it is okay to use a hsr prefixed code to handle PRP as
> well as it may not be intuitive to anyone investigating the code. For
> the same reason, handling 802.1CB specifc functions using the hsr_
> prefixed code. If that is okay, then patch 1-6 are unnecessary. We could
> also add some documentation at the top of the file to indicate that
> both hsr and prp are implemented in the code or something like that.
> BTW, I need to investigate more into 802.1CB and this was not known
> when I developed this code few years ago.

I think for now it's better to make it clear how similar PRP and HSR
are.

As for the renaming, I am afraid that this boat has sailed, as the
netlink API already uses HSR_ and it's better to reuse that than create
a new family for, at least conceptually, the same thing (PRP and
802.1CB). And this is important bit, the userspace API.

And even for 802.1CB using name "High-availability Seamless Redudancy"
is as good as any, if very pompous.

>
> Main difference between HSR and PRP is how they handle the protocol tag
> or rct and create or handle the protocol specific part in the frame.
> For that part, we should be able to define ops() like you have
> suggested, instead of doing if check throughout the code. Hope that
> is what you meant by hsr_ops() for this. Again shouldn't we use some 
> generic name like proto_ops or red_ops instead of hsr_ops() and assign
> protocol specific implementaion to them? i.e hsr_ or prp_
> or 802.1CB specific functions assigned to the function pointers. For
> now I see handle_frame(), handle_sv_frame, create_frame(), 
> create_sv_frame() etc implemented differently (This is currently part of
> patch 11 & 12). So something like
>
>     struct proto_ops {
> 	int (*handle_frame)();
> 	int (*create_frame)();
> 	int (*handle_sv_frame)();
> 	int (*create_sv_frame)();
>     };

That's it. That was the idea I was trying to communicate :-)

>
> and call dev->proto_ops->handle_frame() to process a frame from the
> main hook. proto_ops gets initialized to of the set if implementation
> at device or interface creation in hsr_dev_finalize().
>
>>>
>>> Please review this and provide me feedback so that I can work to
>>> incorporate them and send a formal patch series for this. As this
>>> series impacts user space, I am not sure if this is the right
>>> approach to introduce a new definitions and obsolete the old
>>> API definitions for HSR. The current approach is choosen
>>> to avoid redundant code in iproute2 and in the netlink driver
>>> code (hsr_netlink.c). Other approach we discussed internally was
>>> to Keep the HSR prefix in the user space and kernel code, but
>>> live with the redundant code in the iproute2 and hsr netlink
>>> code. Would like to hear from you what is the best way to add
>>> this feature to networking core. If there is any other
>>> alternative approach possible, I would like to hear about the
>>> same.
>> 
>> Why redudant code is needed in the netlink parts and in iproute2 when
>> keeping the hsr prefix?
>
> May be this is due to the specific implementation that I chose.
> Currently I have separate netlink socket for HSR and PRP which may
> be an overkill since bith are similar protocol.
>
> Currently hsr inteface is created as
>
> ip link add name hsr0 type hsr slave1 eth0 slave2 eth1 supervision 0
>
> So I have implemented similar command for prp
>
> ip link add name prp0 type prp slave1 eth0 slave2 eth1 supervision 0
>
> In patch 7/13 I renamed existing HSR netlink socket attributes that
> defines the hsr interface with the assumption that we can obsolete
> the old definitions in favor of new common definitions with the
> HSR_PRP prefix. Then I have separate code for creating prp
> interface and related functions, even though they are similar.
> So using common definitions, I re-use the code in netlink and
> iproute2 (see patch 8 and 9 to re-use the code). PRP netlink
> socket code in patch 10 which register prp_genl_family similar
> to HSR.

Deprecating an userspace API is hard and takes a long time. So let's
avoid that if it makes sense.

>
> +static struct genl_family prp_genl_family __ro_after_init = {
> +	.hdrsize = 0,
> +	.name = "PRP",
> +	.version = 1,
> +	.maxattr = HSR_PRP_A_MAX,
> +	.policy = prp_genl_policy,
> +	.module = THIS_MODULE,
> +	.ops = prp_ops,
> +	.n_ops = ARRAY_SIZE(prp_ops),
> +	.mcgrps = prp_mcgrps,
> +	.n_mcgrps = ARRAY_SIZE(prp_mcgrps),
> +};
> +
> +int __init prp_netlink_init(void)
> +{
> +	int rc;
> +
> +	rc = rtnl_link_register(&prp_link_ops);
> +	if (rc)
> +		goto fail_rtnl_link_register;
> +
> +	rc = genl_register_family(&prp_genl_family);
> +	if (rc)
> +		goto fail_genl_register_family;
>
>
> If we choose to re-use the existing HSR_ uapi defines, then should we
> re-use the hsr netlink socket interface for PRP as well and
> add additional attribute for differentiating the protocol specific
> part?

Yes, that seems the way to go.

>
> i.e introduce protocol attribute to existing HSR uapi defines for
> netlink socket to handle creation of prp interface.
>
> enum {
> 	HSR_A_UNSPEC,
> 	HSR_A_NODE_ADDR,
> 	HSR_A_IFINDEX,
> 	HSR_A_IF1_AGE,
> 	HSR_A_IF2_AGE,
> 	HSR_A_NODE_ADDR_B,
> 	HSR_A_IF1_SEQ,
> 	HSR_A_IF2_SEQ,
> 	HSR_A_IF1_IFINDEX,
> 	HSR_A_IF2_IFINDEX,
> 	HSR_A_ADDR_B_IFINDEX,
> +       HSR_A_PROTOCOL  <====if missing it is HSR (backward 	
> 			     compatibility)
>                               defines HSR or PRP or 802.1CB in future.
> 	__HSR_A_MAX,
> };
>
> So if ip link command is
>
> ip link add name <if name> type <proto> slave1 eth0 slave2 eth1 
> supervision 0
>
> Add HSR_A_PROTOCOL attribute with HSR/PRP specific value.
>
> This way, the iprout2 code mostly remain the same as hsr, but will
> change a bit to introduced this new attribute if user choose proto as
> 'prp' vs 'hsr'

Sounds good, I think.

>
> BTW, I have posted the existing iproute2 code also to the mailing list
> with title 'iproute2: Add PRP support'.
>
> If re-using hsr code with existing prefix is fine for PRP or any future
> protocol such as 801.1B, then I will drop patch 1-6 that are essentially
> doing some renaming and re-use existing hsr netlink code for PRP with
> added attribute to differentiate the protocol at the driver as described
> above along with proto_ops and re-spin the series.

If I forget that HSR is also the name of a protocol, what the acronym
means makes sense for 802.1CB, so it's not too bad, I think.

>
> Let me know.
>
> Regards,
>
> Murali


Cheers,
-- 
Vinicius
