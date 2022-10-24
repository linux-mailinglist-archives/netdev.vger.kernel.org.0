Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C38260B70A
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 21:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiJXTP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 15:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233100AbiJXTO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 15:14:58 -0400
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [IPv6:2001:4b98:dc4:8::240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00FBF15A942;
        Mon, 24 Oct 2022 10:53:18 -0700 (PDT)
Received: from relay3-d.mail.gandi.net (unknown [217.70.183.195])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id 32703C5D48;
        Mon, 24 Oct 2022 17:49:59 +0000 (UTC)
Received: (Authenticated sender: i.maximets@ovn.org)
        by mail.gandi.net (Postfix) with ESMTPSA id DACCA6000C;
        Mon, 24 Oct 2022 17:48:35 +0000 (UTC)
Message-ID: <ed60523e-d94c-8a41-7322-c2da0ac6a097@ovn.org>
Date:   Mon, 24 Oct 2022 19:48:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Cc:     i.maximets@ovn.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Content-Language: en-US
To:     Antonio Quartulli <antonio@openvpn.net>, nicolas.dichtel@6wind.com,
        Jakub Kicinski <kuba@kernel.org>
References: <20221021114921.3705550-1-i.maximets@ovn.org>
 <20221021090756.0ffa65ee@kernel.org>
 <eb6903b7-c0d9-cc70-246e-8dbde0412433@6wind.com>
 <ded477ea-08fa-b96d-c192-9640977b42e6@ovn.org>
 <5af190a8-ac35-82a6-b099-e9a817757676@6wind.com>
 <cd51cf56-c729-87da-5e2e-03447c9a3d42@openvpn.net>
From:   Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [RFE net-next] net: tun: 1000x speed up
In-Reply-To: <cd51cf56-c729-87da-5e2e-03447c9a3d42@openvpn.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/24/22 17:59, Antonio Quartulli wrote:
> Hi,
> 
> On 24/10/2022 14:27, Nicolas Dichtel wrote:
>> Le 24/10/2022 à 13:56, Ilya Maximets a écrit :
>>> On 10/24/22 11:44, Nicolas Dichtel wrote:
>>>> Le 21/10/2022 à 18:07, Jakub Kicinski a écrit :
>>>>> On Fri, 21 Oct 2022 13:49:21 +0200 Ilya Maximets wrote:
>>>>>> Bump the advertised speed to at least match the veth.  10Gbps also
>>>>>> seems like a more or less fair assumption these days, even though
>>>>>> CPUs can do more.  Alternative might be to explicitly report UNKNOWN
>>>>>> and let the application/user decide on a right value for them.
>>>>>
>>>>> UNKOWN would seem more appropriate but at this point someone may depend
>>>>> on the speed being populated so it could cause regressions, I fear :S
>>>> If it is put in a bonding, it may cause some trouble. Maybe worth than
>>>> advertising 10M.
>>>
>>> My thoughts were that changing the number should have a minimal impact
>>> while changing it to not report any number may cause some issues in
>>> applications that doesn't expect that for some reason (not having a
>>> fallback in case reported speed is unknown isn't great, and the argument
>>> can be made that applications should check that, but it's hard to tell
>>> for every application if they actually do that today).
>>>
>>> Bonding is also a good point indeed, since it's even in-kernel user.
>>>
>>>
>>> The speed bump doesn't solve the problem per se.  It kind of postpones
>>> the decision, since we will run into the same issue eventually again.
>>> That's why I wanted to discuss that first.
>>>
>>> Though I think that at least unification across virtual devices (tun and
>>> veth) should be a step in a right direction.
>> Just to make it clear, I'm not against aligning speed with veth, I'm only
>> against reporting UNKNOWN.
>>
>>>
>>>>
>>>> Note that this value could be configured with ethtool:
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=4e24f2dd516ed
>>>
>>> This is interesting, but it's a bit hard to manage, because in order
>>> to make a decision to bump the speed, application should already know
>>> that this is a tun/tap device.  So, there has to be a special case
>> But this should be done by the application which creates this tun interface. Not
>> by the application that uses this information.
>>
>>> implemented in the code that detects the driver and changes the speed
>>> (this is about application that is using the interface, but didn't
>>> create it), but if we already know the driver, then it doesn't make
>>> sense to actually change the speed in many cases as application can
>>> already act accordingly.
>>>
>>> Also, the application may not have permissions to do that (I didn't
>>> check the requirements, but my guess would be at least CAP_NET_ADMIN?).
>> Sure, but the one who creates it, has the right to configure it correctly. It's
>> part of the configuration of the interface.
>>
>> Setting an higher default speed seems to be a workaround to fix an incorrect
>> configuration. And as you said, it will probably be wrong again in a few years ;-)
>>
> 
> What if the real throughput is in the order of 10Mbps?
> 
> The tun driver can be used for many purposes and the throughput will depend on the specific case.
> 
> Imagine an application using the reported speed for computing some kind of metric: having 10Gbps will corrupt the result entirely.
> 
> OTOH it is true that 10Mbps may corrupt the metric as well, but the latter is closer to reality IMHO (when using tun to process and send traffic over the network).
> 
> At the end I also agree that the speed should be set by whoever creates the interface. As they are the only one who knows what to expect for real.
> 
> (Note: tun is used also to implement userspace VPNs, with throughput ranging from 10Mbps to 1Gbps).

That's an interesting perspective, Antonio.  Thanks!

However, before we can answer your questions, I think we need to define
what the link speed of a tun/tap interface actually is.

IMHO, we should not mix up the link speed and the application performance.

I'm thinking about the link speed as a speed at which kernel driver can
make packets available to the userpsace application or the speed at which
kernel driver is able to send out packets received from the application.

The performance of the application itself is a bit orthogonal to
parameters of the device.

I think, as we do not blame a physical network card or the veth interface
for the processing speed of the application on the other side of the
network, the same way we should not blame the tun driver/interface for
the processing speed in the application that opened it.

In that sense the link speed of a tap interface is the speed at which
kernel can enqueue/dequeue packets to/from userspace.
On a modern CPU that speed will be relatively high.  If it's actually
10 Mbps, than it means that you're likely running on a very slow CPU and
will probably not be able to generate more traffic for it anyway.

For the calculation of some kind of metric based on the reported link
speed, I'm not sure I understand how that may corrupt the result.  The
reported 10 Mbps is not correct either way, so calculations make no
practical sense.  If the application expects the link speed to be 10 Mbps,
than I'm not sure why it is checking the link speed in the first place.

Do you have some examples of such metrics?


All in all, TUN/TAP is a transport, not an end user of the packets it
handles.  And it seems to be a work for transport layer protocols to
handle the mismatch between the wire speed and the application speed on
the other end.


Saying that, I agree that it makes sense to set the link speed in the
application that creates the interface if that application does actually
know what it is capable of.  But not all applications know what speed
they can handle, so it's not always easy, and will also depend on the
CPU speed in many cases.

Best regards, Ilya Maximets.
