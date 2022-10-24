Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC31360BBFC
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 23:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbiJXVTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 17:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235412AbiJXVTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 17:19:34 -0400
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [IPv6:2001:4b98:dc4:8::240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D121C96CD;
        Mon, 24 Oct 2022 12:25:46 -0700 (PDT)
Received: from relay2-d.mail.gandi.net (unknown [IPv6:2001:4b98:dc4:8::222])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id 08002C16B0;
        Mon, 24 Oct 2022 15:40:51 +0000 (UTC)
Received: (Authenticated sender: i.maximets@ovn.org)
        by mail.gandi.net (Postfix) with ESMTPSA id 9001540008;
        Mon, 24 Oct 2022 15:39:14 +0000 (UTC)
Message-ID: <1ac55929-4399-484c-e3ee-1a04f8e90046@ovn.org>
Date:   Mon, 24 Oct 2022 17:39:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Cc:     i.maximets@ovn.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Content-Language: en-US
To:     nicolas.dichtel@6wind.com, Jakub Kicinski <kuba@kernel.org>
References: <20221021114921.3705550-1-i.maximets@ovn.org>
 <20221021090756.0ffa65ee@kernel.org>
 <eb6903b7-c0d9-cc70-246e-8dbde0412433@6wind.com>
 <ded477ea-08fa-b96d-c192-9640977b42e6@ovn.org>
 <5af190a8-ac35-82a6-b099-e9a817757676@6wind.com>
From:   Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [RFE net-next] net: tun: 1000x speed up
In-Reply-To: <5af190a8-ac35-82a6-b099-e9a817757676@6wind.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/24/22 14:27, Nicolas Dichtel wrote:
> Le 24/10/2022 à 13:56, Ilya Maximets a écrit :
>> On 10/24/22 11:44, Nicolas Dichtel wrote:
>>> Le 21/10/2022 à 18:07, Jakub Kicinski a écrit :
>>>> On Fri, 21 Oct 2022 13:49:21 +0200 Ilya Maximets wrote:
>>>>> Bump the advertised speed to at least match the veth.  10Gbps also
>>>>> seems like a more or less fair assumption these days, even though
>>>>> CPUs can do more.  Alternative might be to explicitly report UNKNOWN
>>>>> and let the application/user decide on a right value for them.
>>>>
>>>> UNKOWN would seem more appropriate but at this point someone may depend
>>>> on the speed being populated so it could cause regressions, I fear :S
>>> If it is put in a bonding, it may cause some trouble. Maybe worth than
>>> advertising 10M.
>>
>> My thoughts were that changing the number should have a minimal impact
>> while changing it to not report any number may cause some issues in
>> applications that doesn't expect that for some reason (not having a
>> fallback in case reported speed is unknown isn't great, and the argument
>> can be made that applications should check that, but it's hard to tell
>> for every application if they actually do that today).
>>
>> Bonding is also a good point indeed, since it's even in-kernel user.
>>
>>
>> The speed bump doesn't solve the problem per se.  It kind of postpones
>> the decision, since we will run into the same issue eventually again.
>> That's why I wanted to discuss that first.
>>
>> Though I think that at least unification across virtual devices (tun and
>> veth) should be a step in a right direction.
> Just to make it clear, I'm not against aligning speed with veth, I'm only
> against reporting UNKNOWN.

Ack.  Thanks for the clarification!

> 
>>
>>>
>>> Note that this value could be configured with ethtool:
>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=4e24f2dd516ed
>>
>> This is interesting, but it's a bit hard to manage, because in order
>> to make a decision to bump the speed, application should already know
>> that this is a tun/tap device.  So, there has to be a special case
> But this should be done by the application which creates this tun interface. Not
> by the application that uses this information.
> 
>> implemented in the code that detects the driver and changes the speed
>> (this is about application that is using the interface, but didn't
>> create it), but if we already know the driver, then it doesn't make
>> sense to actually change the speed in many cases as application can
>> already act accordingly.
>>
>> Also, the application may not have permissions to do that (I didn't
>> check the requirements, but my guess would be at least CAP_NET_ADMIN?).
> Sure, but the one who creates it, has the right to configure it correctly. It's
> part of the configuration of the interface.
I mostly agree with that, but that still means changing userspace
applications.  I'm pretty sure very little number of applications,
if any at all, do that today.

> 
> Setting an higher default speed seems to be a workaround to fix an incorrect
> configuration. And as you said, it will probably be wrong again in a few years ;-)

Yep.

Workarounds do exist today.  For example, if you specify max-rate
in QoS configuration for OVS, it will not use the link speed as a
reference at all.  I'm just not sure if replacing one workaround
with another workaround is a good option.  Especially because that
will require changing userspace applications and the problem itself
is kind of artificial.

> 
>>
>> For the human user it's still one extra configuration step that they
>> need to remember to perform.
> I don't buy this argument. There are already several steps: creating and
> configuring an interface requires more than one command.

Muscle memory, I guess. :)
But yes, might not be a huge deal for human users, I agree.

It's more of a concern for multi-layer systems where actual interfaces
are created somewhere deep inside the software stack and actual humans
don't really perform these commands by hands.

Best regards, Ilya Maximets.
