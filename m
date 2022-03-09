Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A164D3028
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 14:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbiCINoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 08:44:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233278AbiCINoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 08:44:14 -0500
Received: from relay12.mail.gandi.net (relay12.mail.gandi.net [IPv6:2001:4b98:dc4:8::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0DCDEF090;
        Wed,  9 Mar 2022 05:43:14 -0800 (PST)
Received: (Authenticated sender: i.maximets@ovn.org)
        by mail.gandi.net (Postfix) with ESMTPSA id CF06D200003;
        Wed,  9 Mar 2022 13:43:07 +0000 (UTC)
Message-ID: <9b6e166e-fd10-4242-1ad9-a6ab1ddb0c95@ovn.org>
Date:   Wed, 9 Mar 2022 14:43:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Cc:     i.maximets@ovn.org, Johannes Berg <johannes@sipsolutions.net>,
        dev@openvswitch.org, Toms Atteka <cpp.code.lv@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, David Ahern <dsahern@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "pshelar@ovn.org" <pshelar@ovn.org>
Content-Language: en-US
To:     Roi Dayan <roid@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
References: <20220224005409.411626-1-cpp.code.lv@gmail.com>
 <164578561098.13834.14017896440355101001.git-patchwork-notify@kernel.org>
 <3adf00c7-fe65-3ef4-b6d7-6d8a0cad8a5f@nvidia.com>
 <50d6ce3d-14bb-205e-55da-5828b10224e8@nvidia.com>
 <57996C97-5845-425B-9B13-7F33EE05D704@redhat.com>
 <26b924fb-ed26-bb3f-8c6b-48edac825f73@nvidia.com>
 <20220307122638.215427b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3a96b606-c3aa-c39b-645e-a3af0c82e44b@ovn.org>
 <20220307144616.05317297@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <45aed9cd-ba65-e2e7-27d7-97e3f9de1fb8@ovn.org>
 <20220307214550.2d2c26a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <5bec02cb6a640cafd65c946e10ee4eda99eb4d9c.camel@sipsolutions.net>
 <e55b1963-14d8-63af-de8e-1b1a8f569a6e@ovn.org>
 <20220308081731.3588b495@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <6f0feae8-ecb4-ca1d-133e-1013ce9e8b4f@ovn.org>
 <20220308121617.3f638793@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <81250230-a845-b03f-6600-b716c02f5137@nvidia.com>
From:   Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [ovs-dev] [PATCH net-next v8] net: openvswitch: IPv6: Add IPv6
 extension header support
In-Reply-To: <81250230-a845-b03f-6600-b716c02f5137@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/9/22 08:49, Roi Dayan wrote:
> 
> 
> On 2022-03-08 10:16 PM, Jakub Kicinski wrote:
>> On Tue, 8 Mar 2022 20:33:12 +0100 Ilya Maximets wrote:
>>> On 3/8/22 17:17, Jakub Kicinski wrote:
>>>> On Tue, 8 Mar 2022 15:12:45 +0100 Ilya Maximets wrote:
>>>>> Yes, that is something that I had in mind too.  The only thing that makes
>>>>> me uncomfortable is OVS_KEY_ATTR_TUNNEL_INFO = 30 here.  Even though it
>>>>> doesn't make a lot of difference, I'd better keep the kernel-only attributes
>>>>> at the end of the enumeration.  Is there a better way to handle kernel-only
>>>>> attribute?
>>>>
>>>> My thought was to leave the kernel/userspace only types "behind" to
>>>> avoid perpetuating the same constructs.
>>>>
>>>> Johannes's point about userspace to userspace messages makes the whole
>>>> thing a little less of an aberration.
>>>>
>>>> Is there a reason for the types to be hidden under __KERNEL__?
>>>> Or someone did that in a misguided attempt to save space in attr arrays
>>>> when parsing?
>>>
>>> My impression is that OVS_KEY_ATTR_TUNNEL_INFO was hidden from the
>>> user space just because it's not supposed to ever be used by the
>>> user space application.  Pravin or Jesse should know for sure.
>>
>> Hard to make any assumptions about what user space that takes
>> the liberty of re-defining kernel uAPI types will or will not
>> do ;) The only way to be safe would be to actively reject the
>> attr ID on the kernel side. Unless user space uses the same
>> exact name for something else IMHO hiding the value doesn't
>> afford us any extra protection.
>>
>>>>> I agree with that.
>>>>
>>>> Should we add the user space types to the kernel header and remove the
>>>> ifdef __KERNEL__ around TUNNEL_INFO, then?
>>>
>>> I don't think we need to actually define them, but we may list them
>>> in the comment.  I'm OK with either option though.
>>>
>>> For the removal of ifdef __KERNEL__, that might be a good thing to do.
>>> I'm just not sure what are the best practices here.
>>> We'll need to make some code changes in user space to avoid warnings
>>> about not all the enum members being used in 'switch'es.  But that's
>>> not a problem.
>>
>> Presumably only as the headers are updated? IOW we would not break
>> the build for older sources?

Yep.  OVS doesn't use kernel header directly, so the change will be
needed only when the header in OVS repo is updated.  Current/older
sources will be fine.

>>
>>> If you think that having a flat enum without 'ifdef's is a viable
>>> option from a kernel's point of view, I'm all for it.
>>>
>>> Maybe something like this (only checked that this compiles; 29 and
>>> 30 are correct numbers of these userspace attributes):
>>
>> It's a bit of an uncharted territory, hard to say what's right.
>> It may be a little easier to code up the rejection if we have
>> the types defined (which I think we need to do in
>> __parse_flow_nlattrs()? seems OvS does its own nla parsing?)

Ack.  And, yes, __parse_flow_nlattrs() seems to be the right spot.
OVS has lots of nested attributes with some special treatment in a
few cases and dependency tracking, AFAICT, so it parses attributes
on it's own.  Is there a better way?

>>
>> Johannes, any preference?
>>
>>> diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
>>> index 9d1710f20505..86bc951be5bc 100644
>>> --- a/include/uapi/linux/openvswitch.h
>>> +++ b/include/uapi/linux/openvswitch.h
>>> @@ -351,11 +351,19 @@ enum ovs_key_attr {
>>>       OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV4,   /* struct ovs_key_ct_tuple_ipv4 */
>>>       OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV6,   /* struct ovs_key_ct_tuple_ipv6 */
>>>       OVS_KEY_ATTR_NSH,       /* Nested set of ovs_nsh_key_* */
>>> -    OVS_KEY_ATTR_IPV6_EXTHDRS,  /* struct ovs_key_ipv6_exthdr */
>>>   -#ifdef __KERNEL__
>>> -    OVS_KEY_ATTR_TUNNEL_INFO,  /* struct ip_tunnel_info */
>>> -#endif
>>> +    /* User space decided to squat on types 29 and 30.  They are listed
>>> +     * below, but should not be sent to the kernel:
>>> +     *
>>> +     * OVS_KEY_ATTR_PACKET_TYPE,   be32 packet type
>>> +     * OVS_KEY_ATTR_ND_EXTENSIONS, IPv6 Neighbor Discovery extensions
>>> +     *
>>> +     * WARNING: No new types should be added unless they are defined
>>> +     *          for both kernel and user space (no 'ifdef's).  It's hard
>>> +     *          to keep compatibility otherwise. */
>>> +    OVS_KEY_ATTR_TUNNEL_INFO = 31,  /* struct ip_tunnel_info.
>>> +                       For in-kernel use only. */
>>> +    OVS_KEY_ATTR_IPV6_EXTHDRS,  /* struct ovs_key_ipv6_exthdr */
>>>       __OVS_KEY_ATTR_MAX
>>>   };
> 
> so why not again just flat enum without ifdefs and without values
> commented out? even if we leave values in comments like above it doesn't
> mean the userspace won't use them by mistake and send to the kernel.
> but the kernel will probably ignore as not being used and at least
> there won't be a conflict again even if by mistake.. and it's easiest
> to read.

OK.  Seems like we have some votes and a reason (explicit reject) to have
them defined.  This will also make current user space and kernel definitions
equal.  Let me put together a patch and we'll continue the discussion there.

> 
>>>   diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
>>> index 8b4124820f7d..315064bada3e 100644
>>> --- a/net/openvswitch/flow_netlink.c
>>> +++ b/net/openvswitch/flow_netlink.c
>>> @@ -346,7 +346,7 @@ size_t ovs_key_attr_size(void)
>>>       /* Whenever adding new OVS_KEY_ FIELDS, we should consider
>>>        * updating this function.
>>>        */
>>> -    BUILD_BUG_ON(OVS_KEY_ATTR_TUNNEL_INFO != 30);
>>> +    BUILD_BUG_ON(OVS_KEY_ATTR_MAX != 32);
>>>         return    nla_total_size(4)   /* OVS_KEY_ATTR_PRIORITY */
>>>           + nla_total_size(0)   /* OVS_KEY_ATTR_TUNNEL */
>>> ---
>>>
>>> Thoughts?
>>>
>>> The same change can be ported to the user-space header, but with
>>> types actually defined and not part of the comment.  It may look
>>> like this: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fpastebin.com%2Fk8UWEZtR&amp;data=04%7C01%7Croid%40nvidia.com%7C3f34544168c14459f44608da01408358%7C43083d15727340c1b7db39efd9ccc17a%7C0%7C0%7C637823673860054963%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=HYfuir9d21MFFxPibJz%2FppfxsylDMLz0CZIOcSCLQQw%3D&amp;reserved=0  (without IPV6_EXTHDRS yet).
>>> For the future, we'll try to find a way to define them in a separate
>>> enum or will define them dynamically based on the policy dumped from
>>> the currently running kernel. In any case no new userspace-only types
>>> should be defined in that enum.
>>

