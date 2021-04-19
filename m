Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675AA3648F5
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 19:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239897AbhDSRVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 13:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbhDSRVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 13:21:13 -0400
Received: from mail.as397444.net (mail.as397444.net [IPv6:2620:6e:a000:dead:beef:15:bad:f00d])
        by lindbergh.monkeyblade.net (Postfix) with UTF8SMTPS id 4F695C06174A;
        Mon, 19 Apr 2021 10:20:43 -0700 (PDT)
Received: by mail.as397444.net (Postfix) with UTF8SMTPSA id 9D6CA541F74;
        Mon, 19 Apr 2021 17:20:40 +0000 (UTC)
X-DKIM-Note: Keys used to sign are likely public at https://as397444.net/dkim/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mattcorallo.com;
        s=1618851664; t=1618852841;
        bh=FiEKzC7B1dsbH70Gn8HR+nV/qxAaawx52H3Ir599Os0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=RZ27MFuhsSTKFsjjBBKbde/EEN8bjbei5vdIdBWUtyWEBgwknOmq2Y4l2aNRCNa56
         V3IEu2uWnVlBjEstH3PFfu+fmnvnQzK7iHe+OYF1Lgkk9k9H+Myt79s49fcop6h9ur
         9SVV6hRc6J5MJxN7RbAABtf4c24mc/kENRw3UV4Nz8IBhRPQTRBJJ60Sb7JkqbQ/cL
         jSuvbCaZyzAFV9SWlmRXLNa+epoLX8sjo4P8fpBRzZK0fpWOfH1/cpbiwJJVYABL/1
         ohTY8bRT1VkcX6Q3z6+7sG2yTkXIVhGhp7GqWl9bZnjrC8i6lbYYwlF10H3wOiAeoo
         LFtw4hlj6B2JQ==
Message-ID: <5fffbce3-2722-97b9-c025-1ce3da5e5467@bluematt.me>
Date:   Mon, 19 Apr 2021 13:20:39 -0400
MIME-Version: 1.0
Subject: Re: PROBLEM: DoS Attack on Fragment Cache
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     Willy Tarreau <w@1wt.eu>, Keyu Man <kman001@ucr.edu>,
        David Ahern <dsahern@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Zhiyun Qian <zhiyunq@cs.ucr.edu>
References: <02917697-4CE2-4BBE-BF47-31F58BC89025@hxcore.ol>
 <52098fa9-2feb-08ae-c24f-1e696076c3b9@gmail.com>
 <CANn89iL_V0WbeA-Zr29cLSp9pCsthkX9ze4W46gx=8-UeK2qMg@mail.gmail.com>
 <20210417072744.GB14109@1wt.eu>
 <CAMqUL6bkp2Dy3AMFZeNLjE1f-sAwnuBWpXH_FSYTSh8=Ac3RKg@mail.gmail.com>
 <20210417075030.GA14265@1wt.eu>
 <c6467c1c-54f5-8681-6e7d-aa1d9fc2ff32@bluematt.me>
 <CAMqUL6bAVE9p=XEnH4HdBmBfThaY3FDosqyr8yrQo6N_9+Jf3w@mail.gmail.com>
 <78d776a9-4299-ff4e-8ca2-096ec5c02d05@bluematt.me>
 <20210418043933.GB18896@1wt.eu>
 <9e2966be-d210-edf9-4f3c-5681f0d07c5f@bluematt.me>
 <CANn89iKXYutm20oi-rCwch0eL1Oo9rq1W=ex6+NzvPitq_jX0Q@mail.gmail.com>
From:   Matt Corallo <netdev-list@mattcorallo.com>
In-Reply-To: <CANn89iKXYutm20oi-rCwch0eL1Oo9rq1W=ex6+NzvPitq_jX0Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Note that there are two completely separate sysctls here - the timeout on fragments, and the amount of memory available 
for fragment reassembly. You have to multiply them together to reach the "Mbps of lost or deliberately-lost fragments 
before we start dropping all future fragments". See the calculation in the description of the patch I mentioned above 
for exact details, but turning the time down to 1s already gives you 32Mbps, and you can tune the memory usage 
separately (eg 128MB, really 256 between v4 and v6, would give you 1Gbps of "lost" fragments).

Its true, an attacker can use a lot of memory in that case, but 128MiB isn't actually something that rises to the level 
of "trivial for an attacker to use all the memory you allowed" or "cause OOM".

I only chimed in on this thread to note that this isn't just a theoretical attack concern, however - this is a 
real-world non-attack-scenario issue that's pretty trivial to hit. Just losing 1Mbps of traffic on a modern residential 
internet connection is pretty doable, make that flow mostly frags and suddenly your VPN drops out for 30 seconds at a 
time just because.

I agree with others here that actually solving the DoS issue isn't trivial, but making it less absurdly trivial to have 
30 second dropouts of your VPN connection would also be a nice change.

Matt

On 4/19/21 05:43, Eric Dumazet wrote:
> On Sun, Apr 18, 2021 at 4:31 PM Matt Corallo
> <netdev-list@mattcorallo.com> wrote:
>>
>> Should the default, though, be so low? If someone is still using a old modem they can crank up the sysctl, it does seem
>> like such things are pretty rare these days :). Its rather trivial to, without any kind of attack, hit 1Mbps of lost
>> fragments in today's networks, at which point all fragments are dropped. After all, I submitted the patch to "scratch my
>> own itch" :).
> 
> Again, even if you increase the values by 1000x, it is trivial for an
> attacker to use all the memory you allowed.
> 
> And allowing a significant portion of memory to be eaten like that
> might cause OOM on hosts where jobs are consuming all physical memory.
> 
> It is a sysctl, I changed things so that one could really reserve/use
> 16GB of memory if she/he is desperate about frags.
> 
>>
>> Matt
>>
>> On 4/18/21 00:39, Willy Tarreau wrote:
>>> I do agree that we shouldn't keep them that long nowadays, we can't go
>>> too low without risking to break some slow transmission stacks (SLIP/PPP
>>> over modems for example).
