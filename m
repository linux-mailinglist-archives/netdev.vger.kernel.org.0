Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6456E36FFCB
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 19:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbhD3RnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 13:43:19 -0400
Received: from mail.as397444.net ([69.59.18.99]:43802 "EHLO mail.as397444.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230387AbhD3RnQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Apr 2021 13:43:16 -0400
Received: by mail.as397444.net (Postfix) with UTF8SMTPSA id 99719560E56;
        Fri, 30 Apr 2021 17:42:26 +0000 (UTC)
X-DKIM-Note: Keys used to sign are likely public at https://as397444.net/dkim/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mattcorallo.com;
        s=1619803264; t=1619804546;
        bh=nEQgiO0eMVUXCuWCl/hXtBScnQ2Gv/kVFJx8R5WbdVY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=GXtvhTbMWwrLxW8DpaqvC1SUXWvuT3U7r8dz3OhZx55KHNybNPt6Ipy+SkL0dkjp7
         SGiiDIor6AItJH5NN3MmMo1k0nUR1/6n7InX5Q99CLmfu9ENcq/V1CVrojx3RjQdnO
         QP8xnWMPVSHKZQ++RZtHJRQcxOW4aCN1DbT4Mm830m8WZ8uymeP1AhSHZMxzIJsgcV
         0mFWEF7g7at4thnf0UhWzYQGsIxGklvoY1hQniD4LTyH7QgXToDcY2U11dKPxMYEMz
         pVwwAercrpc8LfJQefyQSlcp1b9DF8rT7zhurRhAav1M3cLFn3EuZ9sR1HkZ0HyOoT
         i/B+xJvPoWlAg==
Message-ID: <c8ad9235-5436-8418-69a9-6c525fd254a4@bluematt.me>
Date:   Fri, 30 Apr 2021 13:42:26 -0400
MIME-Version: 1.0
Subject: Re: [PATCH net-next] Reduce IP_FRAG_TIME fragment-reassembly timeout
 to 1s, from 30s
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     Willy Tarreau <w@1wt.eu>, "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Keyu Man <kman001@ucr.edu>
References: <d840ddcf-07a6-a838-abf8-b1d85446138e@bluematt.me>
 <CANn89i+L2DuD2+EMHzwZ=qYYKo1A9gw=nTTmh20GV_o9ADxe2Q@mail.gmail.com>
 <0cb19f7e-a9b3-58f8-6119-0736010f1326@bluematt.me>
 <20210428141319.GA7645@1wt.eu>
 <055d0512-216c-9661-9dd4-007c46049265@bluematt.me>
 <CANn89iKfGhNYJVpj4T2MLkomkwPsYWyOof+COVvNFsfVfb7CRQ@mail.gmail.com>
 <64829c98-e4eb-6725-0fee-dc3c6681506f@bluematt.me>
 <1baf048d-18e8-3e0c-feee-a01b381b0168@bluematt.me>
 <CANn89iKJDUQuXBueuZWdi17LgFW3yb4LUsH3hzY08+ytJ9QgeA@mail.gmail.com>
From:   Matt Corallo <netdev-list@mattcorallo.com>
In-Reply-To: <CANn89iKJDUQuXBueuZWdi17LgFW3yb4LUsH3hzY08+ytJ9QgeA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/30/21 13:09, Eric Dumazet wrote:
> On Fri, Apr 30, 2021 at 5:52 PM Matt Corallo
> <netdev-list@mattcorallo.com> wrote:
>>
>> Following up - is there a way forward here?
>>
> 
> Tune the sysctls to meet your goals ?
> 
> I did the needed work so that you can absolutely decide to use 256GB
> of ram per host for frags if you want.
> (Although I have not tested with crazy values like that, maybe some
> kind of bottleneck will be hit)

Again, this is not a solution universally because this issue appears when transiting a Linux router. This isn't only 
about end-hosts (or I wouldn't have even bothered with any of this). Sometimes packets flow over a Linux router that you 
don't have control over, which is true in my case.

>> I think the current ease of hitting the black-hole-ing behavior is unacceptable (and often not something that can be
>> changed even with the sysctl knobs due to intermediate hosts), and am happy to do some work to fix it.
>>
>> Someone mentioned in a previous thread randomly evicting fragments instead of dropping all new fragments when we reach
>> saturation, which may be an option. We could also do something in between 1s and 30s, preserving behavior for hosts
>> which see fragments delivered out-of-order by seconds while still reducing the ease of accidentally just black-holing
>> all fragments entirely in more standard internet access deployments.
>>
> 
> Give me one implementation, I will give you a DDOS program to defeat it.
> linux code is public, attackers will simply change their attacks.
> 
> There is no generic solution, they are all bad.
> 
> If you evict randomly, it will also fail. So why bother ?

This was never about DDoS attacks - as noted several times this is about it being trivial to have all your fragments 
blackholed for 30 seconds at a time just because you have some normal run-of-the-mill packet loss.

I agree with you wholeheartedly that there isn't a solution to the DDoS attack issue, I'm not trying to address it. On 
the other hand, in the face of no attacks or otherwise malicious behavior, I'd expect Linux to not exhibit the complete 
blackholing of fragments that it does today.

Matt
