Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 139EF4F7CA2
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 12:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244199AbiDGKYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 06:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244189AbiDGKY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 06:24:29 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9078127FD9;
        Thu,  7 Apr 2022 03:22:26 -0700 (PDT)
Received: (Authenticated sender: i.maximets@ovn.org)
        by mail.gandi.net (Postfix) with ESMTPSA id 736FE100003;
        Thu,  7 Apr 2022 10:22:16 +0000 (UTC)
Message-ID: <9cc34fbc-3fd6-b529-7a05-554224510452@ovn.org>
Date:   Thu, 7 Apr 2022 12:22:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Cc:     i.maximets@ovn.org, Roi Dayan <roid@nvidia.com>,
        Aaron Conole <aconole@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pravin B Shelar <pshelar@ovn.org>,
        Toms Atteka <cpp.code.lv@gmail.com>, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        Maor Dickman <maord@nvidia.com>
Content-Language: en-US
To:     Vlad Buslov <vladbu@nvidia.com>
References: <20220309222033.3018976-1-i.maximets@ovn.org>
 <f7ty21hir5v.fsf@redhat.com>
 <44eeb550-3310-d579-91cc-ec18b59966d2@nvidia.com>
 <1a185332-3693-2750-fef2-f6938bbc8500@ovn.org> <87k0c171ml.fsf@nvidia.com>
From:   Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [PATCH net-next v2] net: openvswitch: fix uAPI incompatibility
 with existing user space
In-Reply-To: <87k0c171ml.fsf@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/7/22 10:02, Vlad Buslov wrote:
> On Mon 14 Mar 2022 at 20:40, Ilya Maximets <i.maximets@ovn.org> wrote:
>> On 3/14/22 19:33, Roi Dayan wrote:
>>>
>>>
>>> On 2022-03-10 8:44 PM, Aaron Conole wrote:
>>>> Ilya Maximets <i.maximets@ovn.org> writes:
>>>>
>>>>> Few years ago OVS user space made a strange choice in the commit [1]
>>>>> to define types only valid for the user space inside the copy of a
>>>>> kernel uAPI header.  '#ifndef __KERNEL__' and another attribute was
>>>>> added later.
>>>>>
>>>>> This leads to the inevitable clash between user space and kernel types
>>>>> when the kernel uAPI is extended.  The issue was unveiled with the
>>>>> addition of a new type for IPv6 extension header in kernel uAPI.
>>>>>
>>>>> When kernel provides the OVS_KEY_ATTR_IPV6_EXTHDRS attribute to the
>>>>> older user space application, application tries to parse it as
>>>>> OVS_KEY_ATTR_PACKET_TYPE and discards the whole netlink message as
>>>>> malformed.  Since OVS_KEY_ATTR_IPV6_EXTHDRS is supplied along with
>>>>> every IPv6 packet that goes to the user space, IPv6 support is fully
>>>>> broken.
>>>>>
>>>>> Fixing that by bringing these user space attributes to the kernel
>>>>> uAPI to avoid the clash.  Strictly speaking this is not the problem
>>>>> of the kernel uAPI, but changing it is the only way to avoid breakage
>>>>> of the older user space applications at this point.
>>>>>
>>>>> These 2 types are explicitly rejected now since they should not be
>>>>> passed to the kernel.  Additionally, OVS_KEY_ATTR_TUNNEL_INFO moved
>>>>> out from the '#ifdef __KERNEL__' as there is no good reason to hide
>>>>> it from the userspace.  And it's also explicitly rejected now, because
>>>>> it's for in-kernel use only.
>>>>>
>>>>> Comments with warnings were added to avoid the problem coming back.
>>>>>
>>>>> (1 << type) converted to (1ULL << type) to avoid integer overflow on
>>>>> OVS_KEY_ATTR_IPV6_EXTHDRS, since it equals 32 now.
>>>>>
>>>>>   [1] beb75a40fdc2 ("userspace: Switching of L3 packets in L2 pipeline")
>>>>>
>>>>> Fixes: 28a3f0601727 ("net: openvswitch: IPv6: Add IPv6 extension header support")
>>>>> Link: https://lore.kernel.org/netdev/3adf00c7-fe65-3ef4-b6d7-6d8a0cad8a5f@nvidia.com
>>>>> Link: https://github.com/openvswitch/ovs/commit/beb75a40fdc295bfd6521b0068b4cd12f6de507c
>>>>> Reported-by: Roi Dayan <roid@nvidia.com>
>>>>> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
>>>>> ---
>>>>
>>>> Acked-by: Aaron Conole <aconole@redhat.com>
>>>>
>>>
>>>
>>>
>>> I got to check traffic with the fix and I do get some traffic
>>> but something is broken. I didn't investigate much but the quick
>>> test shows me rules are not offloaded and dumping ovs rules gives
>>> error like this
>>>
>>> recirc_id(0),in_port(enp8s0f0_1),ct_state(-trk),eth(),eth_type(0x86dd),ipv6(frag=no)(bad
>>> key length 2, expected -1)(00 00/(bad mask length 2, expected -1)(00 00),
>>> packets:2453, bytes:211594, used:0.004s, flags:S., actions:ct,recirc(0x2)
>>
>> Such a dump is expected, because kernel parses fields that current
>> userspace doesn't understand, and at the same time OVS by design is
>> using kernel provided key/mask while installing datapath rules, IIRC.
>> It should be possible to make these dumps a bit more friendly though.
>>
>> For the offloading not working, see my comment in the v2 patch email
>> I sent (top email of this thread).  In short, it's a problem in user
>> space and it can not be fixed from the kernel side, unless we revert
>> IPv6 extension header support and never add any new types, which is
>> unreasonable.  I didn't test any actual offloading, but I had a
>> successful run of 'make check-offloads' with my quick'n'dirty fix from
>> the top email.
> 
> Hi Ilya,
> 
> I can confirm that with latest OvS master IPv6 rules offload still fails
> without your pastebin code applied.
> 
>>
>> Since we're here:
>>
>> Toms, do you plan to submit user space patches for this feature?
> 
> I see there is a patch from you that is supposed to fix compatibility
> issues caused by this change in OvS d96d14b14733 ("openvswitch.h: Align
> uAPI definition with the kernel."), but it doesn't fix offload for me
> without pastebin patch.

Yes.  OVS commit d96d14b14733 is intended to only fix the uAPI.
Issue with offload is an OVS bug that should be fixed separately.
The fix will also need to be backported to OVS stable branches.

> Do you plan to merge that code into OvS or you
> require some help from our side?

I could do that, but I don't really have enough time.  So, if you
can work on that fix, it would be great.  Note that comments inside
the OVS's lib/odp-util.c:parse_key_and_mask_to_match() was blindly
copied from the userspace datapath and are incorrect for the general
case, so has to be fixed alongside the logic of that function.

Best regards, Ilya Maximets.
