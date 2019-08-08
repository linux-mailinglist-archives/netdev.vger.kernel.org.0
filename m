Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69B5986868
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 20:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733200AbfHHSED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 14:04:03 -0400
Received: from smtp1.emailarray.com ([65.39.216.14]:44921 "EHLO
        smtp1.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730170AbfHHSED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 14:04:03 -0400
Received: (qmail 63725 invoked by uid 89); 8 Aug 2019 18:04:02 -0000
Received: from unknown (HELO ?172.20.41.143?) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTk5LjIwMS42NC4xMzc=) (POLARISLOCAL)  
  by smtp1.emailarray.com with (AES256-GCM-SHA384 encrypted) SMTP; 8 Aug 2019 18:04:02 -0000
From:   "Jonathan Lemon" <jlemon@flugsvamp.com>
To:     "Andrew Lunn" <andrew@lunn.ch>
Cc:     "Jakub Kicinski" <jakub.kicinski@netronome.com>,
        "Jiri Pirko" <jiri@resnulli.us>, dsahern@gmail.com,
        netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, mkubecek@suse.cz,
        stephen@networkplumber.org, daniel@iogearbox.net,
        brouer@redhat.com, eric.dumazet@gmail.com
Subject: Re: [RFC] implicit per-namespace devlink instance to set kernel
 resource limitations
Date:   Thu, 08 Aug 2019 11:03:55 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <1FA58865-9B77-47C9-BC27-78DBA9C9C3D4@flugsvamp.com>
In-Reply-To: <20190806190637.GE17072@lunn.ch>
References: <20190806164036.GA2332@nanopsycho.orion>
 <20190806112717.3b070d07@cakuba.netronome.com>
 <20190806183841.GD2332@nanopsycho.orion>
 <20190806115449.5b3a9d97@cakuba.netronome.com>
 <20190806190637.GE17072@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6 Aug 2019, at 12:06, Andrew Lunn wrote:

> On Tue, Aug 06, 2019 at 11:54:49AM -0700, Jakub Kicinski wrote:
>> On Tue, 6 Aug 2019 20:38:41 +0200, Jiri Pirko wrote:
>>>>> So the proposal is to have some new device, say "kernelnet", that
>>>>> would implicitly create per-namespace devlink instance. This 
>>>>> devlink
>>>>> instance would be used to setup resource limits. Like:
>>>>>
>>>>> devlink resource set kernelnet path /IPv4/fib size 96
>>>>> devlink -N ns1name resource set kernelnet path /IPv6/fib size 100
>>>>> devlink -N ns2name resource set kernelnet path /IPv4/fib-rules 
>>>>> size 8
>>>>>
>>>>> To me it sounds a bit odd for kernel namespace to act as a device, 
>>>>> but
>>>>> thinking about it more, it makes sense. Probably better than to 
>>>>> define
>>>>> a new api. User would use the same tool to work with kernel and 
>>>>> hw.
>>>>>
>>>>> Also we can implement other devlink functionality, like dpipe.
>>>>> User would then have visibility of network pipeline, tables,
>>>>> utilization, etc. It is related to the resources too.
>>>>>
>>>>> What do you think?
>>>>
>>>> I'm no expert here but seems counter intuitive that device tables 
>>>> would
>>>> be aware of namespaces in the first place. Are we not reinventing
>>>> cgroup controllers based on a device API? IMHO from a perspective 
>>>> of
>>>> someone unfamiliar with routing offload this seems backwards :)
>>>
>>> Can we use cgroup for fib and other limitations instead?
>>
>> Not sure the question is to me, I don't feel particularly qualified,
>> I've never worked with VDCs or wrote a switch driver.. But I'd see
>> cgroups as a natural fit, and if I read Andrew's reply right so does
>> he..
>
> Hi Jakub
>
> I think there needs to be a clearly reasoned argument why cgroups is
> the wrong answer to this problem. I myself don't know enough to give
> that answer, but i can pose the question.
>
>      Andrew

For the example above, the first question would be why is the 
restriction
based on the number of entries instead of their memory footprint?  The 
resource
being consumed is memory, so I'd think that should be what is monitored.

Quickly scanning the cgroups documentation, it seems there is a device 
controller,
so this isn't just process based.  ISTR that Larry Brakmo was working on 
a network
bandwidth limiter, which is controlled by cgroups.
-- 
Jonathan



