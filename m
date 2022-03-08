Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D56FB4D2035
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 19:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349676AbiCHS0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 13:26:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349652AbiCHS0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 13:26:45 -0500
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A99725C75;
        Tue,  8 Mar 2022 10:25:39 -0800 (PST)
Received: (Authenticated sender: i.maximets@ovn.org)
        by mail.gandi.net (Postfix) with ESMTPSA id 45EF160008;
        Tue,  8 Mar 2022 18:25:33 +0000 (UTC)
Message-ID: <1eca594f-ec8c-b54a-92f3-e561fa049015@ovn.org>
Date:   Tue, 8 Mar 2022 19:25:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Cc:     i.maximets@ovn.org, dev@openvswitch.org,
        Toms Atteka <cpp.code.lv@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        David Ahern <dsahern@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Content-Language: en-US
To:     Roi Dayan <roid@nvidia.com>,
        Johannes Berg <johannes@sipsolutions.net>,
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
 <e55b1963-14d8-63af-de8e-1b1a8f569a6e@ovn.org>
 <c9f43e92-8a32-cf0e-78d7-1ab36950021c@nvidia.com>
From:   Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [ovs-dev] [PATCH net-next v8] net: openvswitch: IPv6: Add IPv6
 extension header support
In-Reply-To: <c9f43e92-8a32-cf0e-78d7-1ab36950021c@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/8/22 15:39, Roi Dayan wrote:
> 
> 
> On 2022-03-08 4:12 PM, Ilya Maximets wrote:
>> On 3/8/22 09:21, Johannes Berg wrote:
>>> On Mon, 2022-03-07 at 21:45 -0800, Jakub Kicinski wrote:
>>>>
>>>> Let me add some people I associate with genetlink work in my head
>>>> (fairly or not) to keep me fair here.
>>>
>>> :)
>>>
>>>> It's highly unacceptable for user space to straight up rewrite kernel
>>>> uAPI types
>>>>
>>>
>>> Agree.
>>
>> I 100% agree with that and will work on the userspace part to make sure
>> we're not adding anything to the kernel uAPI types.
>>
>> FWIW, the quick grep over usespace code shows similar problem with a few
>> other types, but they are less severe, because they are provided as part
>> of OVS actions and kernel doesn't send anything that wasn't previously
>> set by userspace in that case.  There still might be a problem during the
>> downgrade of the userspace while kernel configuration remains intact,
>> but that is not a common scenario.  Will work on fixing that in userspace.
>> No need to change the kernel uAPI for these, IMO.
>>
> 
> since its rc7 we end up with kernel and ovs broken with each other.
> can we revert the kernel patches anyway and introduce them again later
> when ovs userspace is also updated?

I don't think this patch is part of 5-17-rc7.  AFAICT, it's a candidate
for 5.18, so we should still have a bit of time.  Am I missing something?

Best regards, Ilya Maximets.
