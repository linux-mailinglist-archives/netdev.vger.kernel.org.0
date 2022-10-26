Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37F9760E148
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 14:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233806AbiJZM44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 08:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233938AbiJZM4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 08:56:53 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE07B8B2D6;
        Wed, 26 Oct 2022 05:56:50 -0700 (PDT)
Received: (Authenticated sender: i.maximets@ovn.org)
        by mail.gandi.net (Postfix) with ESMTPSA id 3BDAB40004;
        Wed, 26 Oct 2022 12:56:47 +0000 (UTC)
Message-ID: <a55ef4dd-36b6-bc7b-16e8-92a74c5ac689@ovn.org>
Date:   Wed, 26 Oct 2022 14:56:46 +0200
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
 <ed60523e-d94c-8a41-7322-c2da0ac6a097@ovn.org>
 <b60779d3-cb7e-922d-2915-099ad03dcf54@openvpn.net>
From:   Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [RFE net-next] net: tun: 1000x speed up
In-Reply-To: <b60779d3-cb7e-922d-2915-099ad03dcf54@openvpn.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/26/22 00:16, Antonio Quartulli wrote:
> On 24/10/2022 19:48, Ilya Maximets wrote:
>> On 10/24/22 17:59, Antonio Quartulli wrote:
>>> Hi,
>>>
>>> On 24/10/2022 14:27, Nicolas Dichtel wrote:
>>>> Le 24/10/2022 à 13:56, Ilya Maximets a écrit :
>>>>> On 10/24/22 11:44, Nicolas Dichtel wrote:
>>>>>> Le 21/10/2022 à 18:07, Jakub Kicinski a écrit :
>>>>>>> On Fri, 21 Oct 2022 13:49:21 +0200 Ilya Maximets wrote:
>>>>>>>> Bump the advertised speed to at least match the veth.  10Gbps also
>>>>>>>> seems like a more or less fair assumption these days, even though
>>>>>>>> CPUs can do more.  Alternative might be to explicitly report UNKNOWN
>>>>>>>> and let the application/user decide on a right value for them.
>>>>>>>
>>>>>>> UNKOWN would seem more appropriate but at this point someone may depend
>>>>>>> on the speed being populated so it could cause regressions, I fear :S
>>>>>> If it is put in a bonding, it may cause some trouble. Maybe worth than
>>>>>> advertising 10M.
>>>>>
>>>>> My thoughts were that changing the number should have a minimal impact
>>>>> while changing it to not report any number may cause some issues in
>>>>> applications that doesn't expect that for some reason (not having a
>>>>> fallback in case reported speed is unknown isn't great, and the argument
>>>>> can be made that applications should check that, but it's hard to tell
>>>>> for every application if they actually do that today).
>>>>>
>>>>> Bonding is also a good point indeed, since it's even in-kernel user.
>>>>>
>>>>>
>>>>> The speed bump doesn't solve the problem per se.  It kind of postpones
>>>>> the decision, since we will run into the same issue eventually again.
>>>>> That's why I wanted to discuss that first.
>>>>>
>>>>> Though I think that at least unification across virtual devices (tun and
>>>>> veth) should be a step in a right direction.
>>>> Just to make it clear, I'm not against aligning speed with veth, I'm only
>>>> against reporting UNKNOWN.
>>>>
>>>>>
>>>>>>
>>>>>> Note that this value could be configured with ethtool:
>>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=4e24f2dd516ed
>>>>>
>>>>> This is interesting, but it's a bit hard to manage, because in order
>>>>> to make a decision to bump the speed, application should already know
>>>>> that this is a tun/tap device.  So, there has to be a special case
>>>> But this should be done by the application which creates this tun interface. Not
>>>> by the application that uses this information.
>>>>
>>>>> implemented in the code that detects the driver and changes the speed
>>>>> (this is about application that is using the interface, but didn't
>>>>> create it), but if we already know the driver, then it doesn't make
>>>>> sense to actually change the speed in many cases as application can
>>>>> already act accordingly.
>>>>>
>>>>> Also, the application may not have permissions to do that (I didn't
>>>>> check the requirements, but my guess would be at least CAP_NET_ADMIN?).
>>>> Sure, but the one who creates it, has the right to configure it correctly. It's
>>>> part of the configuration of the interface.
>>>>
>>>> Setting an higher default speed seems to be a workaround to fix an incorrect
>>>> configuration. And as you said, it will probably be wrong again in a few years ;-)
>>>>
>>>
>>> What if the real throughput is in the order of 10Mbps?
>>>
>>> The tun driver can be used for many purposes and the throughput will depend on the specific case.
>>>
>>> Imagine an application using the reported speed for computing some kind of metric: having 10Gbps will corrupt the result entirely.
>>>
>>> OTOH it is true that 10Mbps may corrupt the metric as well, but the latter is closer to reality IMHO (when using tun to process and send traffic over the network).
>>>
>>> At the end I also agree that the speed should be set by whoever creates the interface. As they are the only one who knows what to expect for real.
>>>
>>> (Note: tun is used also to implement userspace VPNs, with throughput ranging from 10Mbps to 1Gbps).
>>
>> That's an interesting perspective, Antonio.  Thanks!
>>
>> However, before we can answer your questions, I think we need to define
>> what the link speed of a tun/tap interface actually is.
> 
> good point
> 
>>
>> IMHO, we should not mix up the link speed and the application performance.
>>
>> I'm thinking about the link speed as a speed at which kernel driver can
>> make packets available to the userpsace application or the speed at which
>> kernel driver is able to send out packets received from the application.
> 
> Mh I understand your perspective, however, if you think about the value reported by Ethernet devices, they will give you the hypothetical/nominal speed they can reach on link - they don't give you the speed of the kernel driver.

Sorry, I used the word 'driver' here just because we don't really
have an actual device.  So, to clarify what I meant is:

                        TUN/TAP              PHY NIC

the driver+device is   tun driver         physical NIC + its driver

the link is            file descriptor    Actual NIC link
                       or a queue         (transceiver/cord)

the remote host is     application        Actual remote host

So, the link speed in these terms for a tun driver is a speed
at which packets can be queued towards the application.
In case of a physical NIC it is the possible transmission speed.

These do not depend on the processing speed on the remote host
which is an application or the actual remote host.

There is a link negotiation process that can be performed, of course.
That will be application setting the actual speed it wants on a tun/tap
device or the actual link speed negotiation in the physical world.

I hope that explains my analogy better.

> 
>>
>> The performance of the application itself is a bit orthogonal to
>> parameters of the device.
>>
>> I think, as we do not blame a physical network card or the veth interface
>> for the processing speed of the application on the other side of the
>> network, the same way we should not blame the tun driver/interface for
>> the processing speed in the application that opened it.
> 
> Well, but in the case of the tun driver the application can be considered as the "userspace driver" of that device.

I'm considering application as a remote host here, not part of the
driver or a virtual NIC.

> 
> It's different from an application listening on an interface and processing packets as they arrive from the network.

I'm not sure if that is very different.  It's virtual and a bit different,
but it's still a network.  Application is receiving packets by calling
recv()/read() on a file descriptor.  TUN driver is emulating a NIC
and a link medium.

> 
>>
>> In that sense the link speed of a tap interface is the speed at which
>> kernel can enqueue/dequeue packets to/from userspace.
> 
> But like I said above, other drivers don't give you that speed: they return the speed at which they expect to be able to send packets out.

Yes, sorry again for not being clear.  I was using a term 'driver'
here only in respect to the tun driver, because we don't have any
real NIC here.  TUN driver represents both the driver and a hardware
component in my analogy. 

> 
>> On a modern CPU that speed will be relatively high.  If it's actually
>> 10 Mbps, than it means that you're likely running on a very slow CPU and
>> will probably not be able to generate more traffic for it anyway.
>>
> 
>> For the calculation of some kind of metric based on the reported link
>> speed, I'm not sure I understand how that may corrupt the result.  The
>> reported 10 Mbps is not correct either way, so calculations make no
>> practical sense.  If the application expects the link speed to be 10 Mbps,
>> than I'm not sure why it is checking the link speed in the first place.
> 
> You are right. If the returned value is far from the real throughput, the metric will be bogus anyway.
> 
> However, I believe 10Gbps is going to be quite far from the real performance in most of the cases. Probably 100Mbps or 1Gbps might be more appropriate, IMHO.

In case of modern virtualization environment where QEMU is creating
a tap interface to provide a network connectivity for a guest OS,
I'm afraid, 10 Gbps is actually far from real performance but in
the opposite direction.  Much higher speeds can actually be achieved
in practice.

> 
>>
>> Do you have some examples of such metrics?
> 
> BATMAN-Advanced (net/batman-adv/bat_v_elp.c:129) uses the speed returned by the ethtool API to compute its throughput based metric, when the provided interface is not a wireless device.
> 
> Some people liked to throw tap devices at batman-adv.

Yeah, the metric value will be some arbitrary number anyway, since
the reported speed doesn't reflect reality in any way.
The 'throughput * 10' part is also interesting.
IIUC, the metric is used to spot sudden changes in the network,
so the actual value doesn't really matter, right?

> 
> Of course, best would again be that whoever created the interface also set the expected speed (based on the application driving the tap device).
> 
> Hence I liked the suggestion of setting UNKNOWN as default and then forcing the application to take action.

I agree that it is a right thing to do, but the general consensus
seems to be that this will break a lot of stuff.

> 
>>
>>
>> All in all, TUN/TAP is a transport, not an end user of the packets it
>> handles.  And it seems to be a work for transport layer protocols to
>> handle the mismatch between the wire speed and the application speed on
>> the other end.
>>
>>
>> Saying that, I agree that it makes sense to set the link speed in the
>> application that creates the interface if that application does actually
>> know what it is capable of.  But not all applications know what speed
>> they can handle, so it's not always easy, and will also depend on the
>> CPU speed in many cases.
> 
> Totally agree!
> 
> And exactly for these reasons you just mentioned, don't you think it is a bit unsafe to just set 10Gbps by default (knowing that there are consumers for this value)?

There will be corner cases, for sure.  Though replacing one arbitrary
number with another arbitrary number, I believe, should not cause any
unrecoverable issues, while providing a more sensible default for some
other users.

I'm not sure if VPNs do actually care about the link speed value tap
interfaces report.  It seems to be outside of their scope of interest.
I know for sure that applications like libvirt and OVS do care because
they need to configure QoS on such ports in automated fashion without
user intervention on a low level.  Same problem will eventually appear
on veth interfaces someday in the future.

> 
> 
> In any case, I only wanted to express my perplexity at throwing such a high number at tun.

If it is a high number or not depends on a point of view, I guess.
See my analogy explanation above.

> But since we agree that this number will likely be wrong in most of the cases, I don't really have a strong opinion either.

Thanks for sharing your thoughts!

Best regards, Ilya Maximets.
