Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57BF14D1A1E
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 15:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347347AbiCHON5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 09:13:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346716AbiCHON4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 09:13:56 -0500
X-Greylist: delayed 50929 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Mar 2022 06:12:54 PST
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE8128E23;
        Tue,  8 Mar 2022 06:12:53 -0800 (PST)
Received: (Authenticated sender: i.maximets@ovn.org)
        by mail.gandi.net (Postfix) with ESMTPSA id B1998C000C;
        Tue,  8 Mar 2022 14:12:46 +0000 (UTC)
Message-ID: <e55b1963-14d8-63af-de8e-1b1a8f569a6e@ovn.org>
Date:   Tue, 8 Mar 2022 15:12:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Cc:     i.maximets@ovn.org, Roi Dayan <roid@nvidia.com>,
        dev@openvswitch.org, Toms Atteka <cpp.code.lv@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, David Ahern <dsahern@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Content-Language: en-US
To:     Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>
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
From:   Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [ovs-dev] [PATCH net-next v8] net: openvswitch: IPv6: Add IPv6
 extension header support
In-Reply-To: <5bec02cb6a640cafd65c946e10ee4eda99eb4d9c.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/8/22 09:21, Johannes Berg wrote:
> On Mon, 2022-03-07 at 21:45 -0800, Jakub Kicinski wrote:
>>
>> Let me add some people I associate with genetlink work in my head
>> (fairly or not) to keep me fair here.
> 
> :)
> 
>> It's highly unacceptable for user space to straight up rewrite kernel
>> uAPI types
>>
> 
> Agree.

I 100% agree with that and will work on the userspace part to make sure
we're not adding anything to the kernel uAPI types.

FWIW, the quick grep over usespace code shows similar problem with a few
other types, but they are less severe, because they are provided as part
of OVS actions and kernel doesn't send anything that wasn't previously
set by userspace in that case.  There still might be a problem during the
downgrade of the userspace while kernel configuration remains intact,
but that is not a common scenario.  Will work on fixing that in userspace.
No need to change the kernel uAPI for these, IMO.

> 
>> but if it already happened the only fix is something like:
>>
>> diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
>> index 9d1710f20505..ab6755621e02 100644
>> --- a/include/uapi/linux/openvswitch.h
>> +++ b/include/uapi/linux/openvswitch.h
>> @@ -351,11 +351,16 @@ enum ovs_key_attr {
>>         OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV4,   /* struct ovs_key_ct_tuple_ipv4 */
>>         OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV6,   /* struct ovs_key_ct_tuple_ipv6 */
>>         OVS_KEY_ATTR_NSH,       /* Nested set of ovs_nsh_key_* */
>> -       OVS_KEY_ATTR_IPV6_EXTHDRS,  /* struct ovs_key_ipv6_exthdr */
>>  
>>  #ifdef __KERNEL__
>>         OVS_KEY_ATTR_TUNNEL_INFO,  /* struct ip_tunnel_info */
>>  #endif
>> +       /* User space decided to squat on types 30 and 31 */
>> +       OVS_KEY_ATTR_IPV6_EXTHDRS = 32, /* struct ovs_key_ipv6_exthdr */
>> +       /* WARNING: <scary warning to avoid the problem coming back> */

Yes, that is something that I had in mind too.  The only thing that makes
me uncomfortable is OVS_KEY_ATTR_TUNNEL_INFO = 30 here.  Even though it
doesn't make a lot of difference, I'd better keep the kernel-only attributes
at the end of the enumeration.  Is there a better way to handle kernel-only
attribute?

Also, the OVS_KEY_ATTR_ND_EXTENSIONS (31) attribute used to store IPv6 Neighbor
Discovery extensions is currently implemented only for userspace, but nothing
actually prevents us having the kernel implementation.  So, we need a way to
make it usable by the kernel in the future.

> 
> It might be nicer to actually document here in what's at least supposed
> to be the canonical documentation of the API what those types were used
> for.

I agree with that.

> Note that with strict validation at least they're rejected by the
> kernel, but of course I have no idea what kind of contortions userspace
> does to make it even think about defining its own types (netlink
> normally sits at the kernel/userspace boundary, so where does it make
> sense for userspace to have its own types?)
> 
> (Though note that technically netlink supports userspace<->userspace
> communication, but that's not used much)

OVS has a common high-level interface+logic and several different
implementations of a "datapath".  One of datapaths is inside the Linux
kernel which we're discussing here, another is completely in userspace
(to make use of DPDK or AF_XDP), there is also an implementation for the
Windows kernel.  Since the way to talk with the Linux kernel is netlink,
OVS is using netlink-based communication to communicate between high-level
parts and all types of datapaths.  Some features might be supported by
one datapath and not supported by others, hence some way to extend the
communication is needed.  E.g. kernel currently doesn't parse ND extensions,
but userspace datapath does.

But yes, the current implementation is awful and OVS need to have a
different way of managing datapath-specific attributes and not touch
kernel-defined types.  We'll work on that.

> 
>>>> Since ovs uses genetlink you should be able to dump the policy from 
>>>> the kernel and at least validate that it doesn't overlap.  
>>>
>>> That is interesting.  Indeed, this functionality can be used to detect
>>> problems or to define userspace-only attributes in runtime based on the
>>> kernel reply.  Thanks for the pointer!
> 
> As you note, you'd have to do that at runtime since it can change, even
> the policy. And things not in the policy probably should never be sent
> to the kernel even if strict validation isn't used.

Agree.  AFAICT, OVS currently doesn't send to the kernel things that kernel
doesn't support.

> 
> johannes

