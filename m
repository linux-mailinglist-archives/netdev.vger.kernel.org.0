Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 029EF60BEB6
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 01:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbiJXXg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 19:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiJXXgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 19:36:22 -0400
X-Greylist: delayed 12567 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 24 Oct 2022 14:56:55 PDT
Received: from smtp120.iad3a.emailsrvr.com (smtp120.iad3a.emailsrvr.com [173.203.187.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB5B9278170
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 14:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=openvpn.net;
        s=20170822-45nk5nwl; t=1666627158;
        bh=btRk7swX7GdyOa27zjsvyKxH9I1WQ7w6KviW39ZTEjM=;
        h=Date:Subject:To:From:From;
        b=blXWXCXqvCfG2PGic4/7VMl3LwZfUC8IQYpr+XpvxgmdKQs0B45TKBoz5VnLiq7sz
         CWVCpj8G4h/KWDWnw8Kt/NygCmhEXmPQtb4XkwR6R4aI4A+V+ujXxXDTixzb6c1r6s
         Eqvxrr9WgHmu+1iG1wnMPfGxi9TwwJzx4y/Oe8Io=
X-Auth-ID: antonio@openvpn.net
Received: by smtp16.relay.iad3a.emailsrvr.com (Authenticated sender: antonio-AT-openvpn.net) with ESMTPSA id 8EF0B5C85;
        Mon, 24 Oct 2022 11:59:16 -0400 (EDT)
Message-ID: <cd51cf56-c729-87da-5e2e-03447c9a3d42@openvpn.net>
Date:   Mon, 24 Oct 2022 17:59:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [RFE net-next] net: tun: 1000x speed up
To:     nicolas.dichtel@6wind.com, Ilya Maximets <i.maximets@ovn.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
References: <20221021114921.3705550-1-i.maximets@ovn.org>
 <20221021090756.0ffa65ee@kernel.org>
 <eb6903b7-c0d9-cc70-246e-8dbde0412433@6wind.com>
 <ded477ea-08fa-b96d-c192-9640977b42e6@ovn.org>
 <5af190a8-ac35-82a6-b099-e9a817757676@6wind.com>
Content-Language: en-US
From:   Antonio Quartulli <antonio@openvpn.net>
In-Reply-To: <5af190a8-ac35-82a6-b099-e9a817757676@6wind.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Classification-ID: 0a266811-a982-4e0c-a42b-2cb7488dbf9b-1-1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 24/10/2022 14:27, Nicolas Dichtel wrote:
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
> 
> Setting an higher default speed seems to be a workaround to fix an incorrect
> configuration. And as you said, it will probably be wrong again in a few years ;-)
> 

What if the real throughput is in the order of 10Mbps?

The tun driver can be used for many purposes and the throughput will 
depend on the specific case.

Imagine an application using the reported speed for computing some kind 
of metric: having 10Gbps will corrupt the result entirely.

OTOH it is true that 10Mbps may corrupt the metric as well, but the 
latter is closer to reality IMHO (when using tun to process and send 
traffic over the network).

At the end I also agree that the speed should be set by whoever creates 
the interface. As they are the only one who knows what to expect for real.

(Note: tun is used also to implement userspace VPNs, with throughput 
ranging from 10Mbps to 1Gbps).

my 2 cents.

Cheers,

-- 
Antonio Quartulli
OpenVPN Inc.
