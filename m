Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 940774D0C68
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 01:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234827AbiCHAFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 19:05:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243159AbiCHAFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 19:05:04 -0500
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [217.70.178.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 371AF63B1;
        Mon,  7 Mar 2022 16:04:09 -0800 (PST)
Received: from relay3-d.mail.gandi.net (unknown [IPv6:2001:4b98:dc4:8::223])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id 671E0C4B3B;
        Tue,  8 Mar 2022 00:04:07 +0000 (UTC)
Received: (Authenticated sender: i.maximets@ovn.org)
        by mail.gandi.net (Postfix) with ESMTPSA id 14C9560006;
        Tue,  8 Mar 2022 00:04:00 +0000 (UTC)
Message-ID: <45aed9cd-ba65-e2e7-27d7-97e3f9de1fb8@ovn.org>
Date:   Tue, 8 Mar 2022 01:04:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Cc:     i.maximets@ovn.org, Roi Dayan <roid@nvidia.com>,
        dev@openvswitch.org, Toms Atteka <cpp.code.lv@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
References: <20220224005409.411626-1-cpp.code.lv@gmail.com>
 <164578561098.13834.14017896440355101001.git-patchwork-notify@kernel.org>
 <3adf00c7-fe65-3ef4-b6d7-6d8a0cad8a5f@nvidia.com>
 <50d6ce3d-14bb-205e-55da-5828b10224e8@nvidia.com>
 <57996C97-5845-425B-9B13-7F33EE05D704@redhat.com>
 <26b924fb-ed26-bb3f-8c6b-48edac825f73@nvidia.com>
 <20220307122638.215427b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3a96b606-c3aa-c39b-645e-a3af0c82e44b@ovn.org>
 <20220307144616.05317297@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [ovs-dev] [PATCH net-next v8] net: openvswitch: IPv6: Add IPv6
 extension header support
In-Reply-To: <20220307144616.05317297@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/7/22 23:46, Jakub Kicinski wrote:
> On Mon, 7 Mar 2022 23:14:13 +0100 Ilya Maximets wrote:
>> The main problem is that userspace uses the modified copy of the uapi header
>> which looks like this:
>>   https://github.com/openvswitch/ovs/blob/f77dbc1eb2da2523625cd36922c6fccfcb3f3eb7/datapath/linux/compat/include/linux/openvswitch.h#L357
>>
>> In short, the userspace view:
>>
>>   enum ovs_key_attr {
>>       <common attrs>
>>
>>   #ifdef __KERNEL__
>>       /* Only used within kernel data path. */
>>   #endif
>>
>>   #ifndef __KERNEL__
>>       /* Only used within userspace data path. */
>>   #endif
>>       __OVS_KEY_ATTR_MAX
>> };
>>
>> And the kernel view:
>>
>>   enum ovs_key_attr {
>>       <common attrs>
>>
>>   #ifdef __KERNEL__
>>       /* Only used within kernel data path. */
>>   #endif
>>
>>       __OVS_KEY_ATTR_MAX
>>   };
>>
>> This happened before my time, but the commit where userspace made a wrong
>> turn appears to be this one:
>>   https://github.com/openvswitch/ovs/commit/beb75a40fdc295bfd6521b0068b4cd12f6de507c
>> The attribute for userspace only was added to the common enum after the
>> OVS_KEY_ATTR_TUNNEL_INFO.   I'm not sure how things didn't fall apart when
>> OVS_KEY_ATTR_NSH was added later (no-one cared that NSH doesn't work, because
>> OVS didn't support it yet?).
>>
>> In general, any addition of a new attribute into that enumeration leads to
>> inevitable clash between userpsace-only attributes and new kernel attributes.
>>
>> After the kernel update, kernel provides new attributes to the userspace and
>> userspace tries to parse them as one of the userspace-only attributes and
>> fails.   In our current case userspace is trying to parse OVS_KEY_ATTR_IPV6_EXTHDR
>> as userspace-only OVS_KEY_ATTR_PACKET_TYPE, because they have the same value in the
>> enum, fails and discards the netlink message as malformed.  So, IPv6 is fully
>> broken, because OVS_KEY_ATTR_IPV6_EXTHDR is supplied now with every IPv6 packet
>> that goes to userspace.
>>
>> We need to unify the view of 'enum ovs_key_attr' between userspace and kernel
>> before we can add any new values to it.
>>
>> One way to do that should be addition of both userspace-only attributes to the
>> kernel header (and maybe exposing OVS_KEY_ATTR_TUNNEL_INFO too, just to keep
>> it flat and avoid any possible problems in the future).  Any other suggestions
>> are welcome.  But in any case this will require careful testing with existing
>> OVS userspace to avoid any unexpected issues.
>>
>> Moving forward, I think, userspace OVS should find a way to not have userpsace-only
>> attributes, or have them as a separate enumeration.  But I'm not sure how to do
>> that right now.  Or we'll have to add userspace-only attributes to the kernel
>> uapi before using them.
> 
> Thanks for the explanation, we can apply a revert if that'd help your
> CI / ongoing development but sounds like the fix really is in user
> space. Expecting netlink attribute lists not to grow is not fair.

I don't think it was intentional, just a careless mistake.  Unfortunately,
all OVS binaries built during the last 5 years rely on that unwanted
expectation (re-build will also not help as they are using a copy of the
uAPI header and the clash will be there anyway).  If we want to keep them
working, kernel uAPI has to be carefully updated with current userspace-only
attributes before we add any new ones.  That is not great, but I don't see
any other option right now that doesn't require code changes in userspace.

I'd say that we need to revert the current patch and re-introduce it
later when the uAPI problem is sorted out.  This way we will avoid blocking
the net-next testing and will also avoid problems in case the uAPI changes
are not ready at the moment of the new kernel release.

What do you think?

> 
> Since ovs uses genetlink you should be able to dump the policy from 
> the kernel and at least validate that it doesn't overlap.

That is interesting.  Indeed, this functionality can be used to detect
problems or to define userspace-only attributes in runtime based on the
kernel reply.  Thanks for the pointer!

Best regards, Ilya Maximets.
