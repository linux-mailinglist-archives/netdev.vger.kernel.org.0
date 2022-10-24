Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB5760B968
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 22:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbiJXUKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 16:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234324AbiJXUJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 16:09:43 -0400
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [IPv6:2001:4b98:dc4:8::240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2A1B28;
        Mon, 24 Oct 2022 11:29:29 -0700 (PDT)
Received: from relay10.mail.gandi.net (unknown [IPv6:2001:4b98:dc4:8::230])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id CF241CF059;
        Mon, 24 Oct 2022 11:57:32 +0000 (UTC)
Received: (Authenticated sender: i.maximets@ovn.org)
        by mail.gandi.net (Postfix) with ESMTPSA id 62719240007;
        Mon, 24 Oct 2022 11:56:50 +0000 (UTC)
Message-ID: <ded477ea-08fa-b96d-c192-9640977b42e6@ovn.org>
Date:   Mon, 24 Oct 2022 13:56:49 +0200
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
From:   Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [RFE net-next] net: tun: 1000x speed up
In-Reply-To: <eb6903b7-c0d9-cc70-246e-8dbde0412433@6wind.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/24/22 11:44, Nicolas Dichtel wrote:
> Le 21/10/2022 à 18:07, Jakub Kicinski a écrit :
>> On Fri, 21 Oct 2022 13:49:21 +0200 Ilya Maximets wrote:
>>> Bump the advertised speed to at least match the veth.  10Gbps also
>>> seems like a more or less fair assumption these days, even though
>>> CPUs can do more.  Alternative might be to explicitly report UNKNOWN
>>> and let the application/user decide on a right value for them.
>>
>> UNKOWN would seem more appropriate but at this point someone may depend
>> on the speed being populated so it could cause regressions, I fear :S
> If it is put in a bonding, it may cause some trouble. Maybe worth than
> advertising 10M.

My thoughts were that changing the number should have a minimal impact
while changing it to not report any number may cause some issues in
applications that doesn't expect that for some reason (not having a
fallback in case reported speed is unknown isn't great, and the argument
can be made that applications should check that, but it's hard to tell
for every application if they actually do that today).

Bonding is also a good point indeed, since it's even in-kernel user.


The speed bump doesn't solve the problem per se.  It kind of postpones
the decision, since we will run into the same issue eventually again.
That's why I wanted to discuss that first.

Though I think that at least unification across virtual devices (tun and
veth) should be a step in a right direction.

> 
> Note that this value could be configured with ethtool:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=4e24f2dd516ed

This is interesting, but it's a bit hard to manage, because in order
to make a decision to bump the speed, application should already know
that this is a tun/tap device.  So, there has to be a special case
implemented in the code that detects the driver and changes the speed
(this is about application that is using the interface, but didn't
create it), but if we already know the driver, then it doesn't make
sense to actually change the speed in many cases as application can
already act accordingly.

Also, the application may not have permissions to do that (I didn't
check the requirements, but my guess would be at least CAP_NET_ADMIN?).

For the human user it's still one extra configuration step that they
need to remember to perform.

Very useful for testing purposes though.  Thanks for pointing out!

> 
>>
>>> Sorry for the clickbait subject line.
>>
>> Nicely done, worked on me :)
> Works for me also :D

Sorry again.  :):

Best regards, Ilya Maximets.
