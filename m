Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E511E3181
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 23:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389646AbgEZVvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 17:51:48 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:54358 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389257AbgEZVvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 17:51:47 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04QLpf3S005788;
        Tue, 26 May 2020 16:51:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1590529901;
        bh=KZTgKofeUP3ViFlXayQntAbve2ERt8ij2ItI5SzJ6mA=;
        h=Subject:To:References:From:Date:In-Reply-To;
        b=B7O93FiXTW+l+LdDwUVfigyDkylpuCNnHgcX6fsFbY7QUQknVrW3/o9u0nLVDDW0H
         Z7NeDldVk7ZiyMr9kAPdZwpDtCVfKMBnhs6vr9Sywt3BejVPFqwUjlkQ0KMja3zYfZ
         gQbM2/BvUkV11kCFBU1G7aqtyUuIS9R1WVw9jNLE=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04QLpfWw024741;
        Tue, 26 May 2020 16:51:41 -0500
Received: from DLEE115.ent.ti.com (157.170.170.26) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 26
 May 2020 16:51:41 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 26 May 2020 16:51:41 -0500
Received: from [10.250.74.234] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04QLpewK026207;
        Tue, 26 May 2020 16:51:41 -0500
Subject: Re: [net-next RFC PATCH 00/13] net: hsr: Add PRP driver
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <grygorii.strashko@ti.com>
References: <20200506163033.3843-1-m-karicheri2@ti.com>
 <87r1vdkxes.fsf@intel.com> <5feae5ae-af46-f4b6-fe91-91a19036112b@ti.com>
 <87a71ule4c.fsf@intel.com>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <5cfc4fd1-887c-7cb8-4313-24f1c53d566d@ti.com>
Date:   Tue, 26 May 2020 17:51:40 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <87a71ule4c.fsf@intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinicius,

On 5/26/20 2:56 PM, Vinicius Costa Gomes wrote:
> Murali Karicheri <m-karicheri2@ti.com> writes:
> 
>> Hi Vinicius,
>>
>> On 5/21/20 1:31 PM, Vinicius Costa Gomes wrote:
>>> Murali Karicheri <m-karicheri2@ti.com> writes:
>>>
>> ------------ Snip-------------

>>> So, I see this as different methods of achieving the same result, which
>>> makes me think that the different "methods/types" (HSR and PRP in your
>>> case) should be basically different implementations of a "struct
>>> hsr_ops" interface. With this hsr_ops something like this:
>>>
>>>      struct hsr_ops {
>>>             int (*handle_frame)()
>>>             int (*add_port)()
>>>             int (*remove_port)()
>>>             int (*setup)()
>>>             void (*teardown)()
>>>      };
>>>
>>
>> Thanks for your response!
>>
>> I agree with you that the prefix renaming is ugly. However I wasn't
>> sure if it is okay to use a hsr prefixed code to handle PRP as
>> well as it may not be intuitive to anyone investigating the code. For
>> the same reason, handling 802.1CB specifc functions using the hsr_
>> prefixed code. If that is okay, then patch 1-6 are unnecessary. We could
>> also add some documentation at the top of the file to indicate that
>> both hsr and prp are implemented in the code or something like that.
>> BTW, I need to investigate more into 802.1CB and this was not known
>> when I developed this code few years ago.
> 
> I think for now it's better to make it clear how similar PRP and HSR
> are.
> 
> As for the renaming, I am afraid that this boat has sailed, as the
> netlink API already uses HSR_ and it's better to reuse that than create
> a new family for, at least conceptually, the same thing (PRP and
> 802.1CB). And this is important bit, the userspace API.
> 
> And even for 802.1CB using name "High-availability Seamless Redudancy"
> is as good as any, if very pompous.
> I have reviewed the 802.1CB at a high level. The idea of 802.1CB is
also high availability and redundancy similar to HSR and PRP but at
stream level. So now I feel more comfortable to re-use the hsr prefix
until we find a better name. I can document this in all file headers to
make this explicit when I spin the formal patch for this. I will wait
for a couple of weeks before start the work on a formal patch
series so that others have a chance to respond as well.

>>
>> Main difference between HSR and PRP is how they handle the protocol tag
>> or rct and create or handle the protocol specific part in the frame.
>> For that part, we should be able to define ops() like you have
>> suggested, instead of doing if check throughout the code. Hope that
>> is what you meant by hsr_ops() for this. Again shouldn't we use some
>> generic name like proto_ops or red_ops instead of hsr_ops() and assign
>> protocol specific implementaion to them? i.e hsr_ or prp_
>> or 802.1CB specific functions assigned to the function pointers. For
>> now I see handle_frame(), handle_sv_frame, create_frame(),
>> create_sv_frame() etc implemented differently (This is currently part of
>> patch 11 & 12). So something like
>>
>>      struct proto_ops {
>> 	int (*handle_frame)();
>> 	int (*create_frame)();
>> 	int (*handle_sv_frame)();
>> 	int (*create_sv_frame)();
>>      };
> 
> That's it. That was the idea I was trying to communicate :-)
> 
Ok
>>
>> and call dev->proto_ops->handle_frame() to process a frame from the
>> main hook. proto_ops gets initialized to of the set if implementation
>> at device or interface creation in hsr_dev_finalize().
>>
>>>>
>>>> Please review this and provide me feedback so that I can work to
>>>> incorporate them and send a formal patch series for this. As this
>>>> series impacts user space, I am not sure if this is the right
>>>> approach to introduce a new definitions and obsolete the old
>>>> API definitions for HSR. The current approach is choosen
>>>> to avoid redundant code in iproute2 and in the netlink driver
>>>> code (hsr_netlink.c). Other approach we discussed internally was
>>>> to Keep the HSR prefix in the user space and kernel code, but
>>>> live with the redundant code in the iproute2 and hsr netlink
>>>> code. Would like to hear from you what is the best way to add
>>>> this feature to networking core. If there is any other
>>>> alternative approach possible, I would like to hear about the
>>>> same.
>>>
>>> Why redudant code is needed in the netlink parts and in iproute2 when
>>> keeping the hsr prefix?
>>
>> May be this is due to the specific implementation that I chose.
>> Currently I have separate netlink socket for HSR and PRP which may
>> be an overkill since bith are similar protocol.
>>
>> Currently hsr inteface is created as
>>
>> ip link add name hsr0 type hsr slave1 eth0 slave2 eth1 supervision 0
>>
>> So I have implemented similar command for prp
>>
>> ip link add name prp0 type prp slave1 eth0 slave2 eth1 supervision 0
>>
>> In patch 7/13 I renamed existing HSR netlink socket attributes that
>> defines the hsr interface with the assumption that we can obsolete
>> the old definitions in favor of new common definitions with the
>> HSR_PRP prefix. Then I have separate code for creating prp
>> interface and related functions, even though they are similar.
>> So using common definitions, I re-use the code in netlink and
>> iproute2 (see patch 8 and 9 to re-use the code). PRP netlink
>> socket code in patch 10 which register prp_genl_family similar
>> to HSR.
> 
> Deprecating an userspace API is hard and takes a long time. So let's
> avoid that if it makes sense.
> 

Ok, make sense.

>>
>> +static struct genl_family prp_genl_family __ro_after_init = {
>> +	.hdrsize = 0,
>> +	.name = "PRP",
>> +	.version = 1,
>> +	.maxattr = HSR_PRP_A_MAX,
>> +	.policy = prp_genl_policy,
>> +	.module = THIS_MODULE,
>> +	.ops = prp_ops,
>> +	.n_ops = ARRAY_SIZE(prp_ops),
>> +	.mcgrps = prp_mcgrps,
>> +	.n_mcgrps = ARRAY_SIZE(prp_mcgrps),
>> +};
>> +
>> +int __init prp_netlink_init(void)
>> +{
>> +	int rc;
>> +
>> +	rc = rtnl_link_register(&prp_link_ops);
>> +	if (rc)
>> +		goto fail_rtnl_link_register;
>> +
>> +	rc = genl_register_family(&prp_genl_family);
>> +	if (rc)
>> +		goto fail_genl_register_family;
>>
>>
>> If we choose to re-use the existing HSR_ uapi defines, then should we
>> re-use the hsr netlink socket interface for PRP as well and
>> add additional attribute for differentiating the protocol specific
>> part?
> 
> Yes, that seems the way to go.
> 
Ok.

>>
>> i.e introduce protocol attribute to existing HSR uapi defines for
>> netlink socket to handle creation of prp interface.
>>
>> enum {
>> 	HSR_A_UNSPEC,
>> 	HSR_A_NODE_ADDR,
>> 	HSR_A_IFINDEX,
>> 	HSR_A_IF1_AGE,
>> 	HSR_A_IF2_AGE,
>> 	HSR_A_NODE_ADDR_B,
>> 	HSR_A_IF1_SEQ,
>> 	HSR_A_IF2_SEQ,
>> 	HSR_A_IF1_IFINDEX,
>> 	HSR_A_IF2_IFINDEX,
>> 	HSR_A_ADDR_B_IFINDEX,
>> +       HSR_A_PROTOCOL  <====if missing it is HSR (backward 	
>> 			     compatibility)
>>                                defines HSR or PRP or 802.1CB in future.
>> 	__HSR_A_MAX,
>> };
>>
>> So if ip link command is
>>
>> ip link add name <if name> type <proto> slave1 eth0 slave2 eth1
>> supervision 0
>>
>> Add HSR_A_PROTOCOL attribute with HSR/PRP specific value.
>>
>> This way, the iprout2 code mostly remain the same as hsr, but will
>> change a bit to introduced this new attribute if user choose proto as
>> 'prp' vs 'hsr'
> 
> Sounds good, I think.

Ok. If we want to add 802.1CB later, specific value used can be
extended to use 802.1CB.

> 
>>
>> BTW, I have posted the existing iproute2 code also to the mailing list
>> with title 'iproute2: Add PRP support'.
>>
>> If re-using hsr code with existing prefix is fine for PRP or any future
>> protocol such as 801.1B, then I will drop patch 1-6 that are essentially
>> doing some renaming and re-use existing hsr netlink code for PRP with
>> added attribute to differentiate the protocol at the driver as described
>> above along with proto_ops and re-spin the series.
> 
> If I forget that HSR is also the name of a protocol, what the acronym
> means makes sense for 802.1CB, so it's not too bad, I think.
> 

Agree.

>>
>> Let me know.
>>
>> Regards,
>>
>> Murali
> 
> 
> Cheers,
> 

-- 
Murali Karicheri
Texas Instruments
