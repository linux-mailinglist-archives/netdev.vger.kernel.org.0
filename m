Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 585D711FF74
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 09:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbfLPIKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 03:10:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:56116 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726772AbfLPIKd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 03:10:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A01E1B21A;
        Mon, 16 Dec 2019 08:10:30 +0000 (UTC)
Subject: Re: [Xen-devel] [PATCH net-next] xen-netback: get rid of old udev
 related code
To:     "Durrant, Paul" <pdurrant@amazon.com>,
        David Miller <davem@davemloft.net>
Cc:     "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20191212135406.26229-1-pdurrant@amazon.com>
 <20191212.110513.1770889236741616001.davem@davemloft.net>
 <cefcf3a4-fc10-d62a-cac9-81f0e47710a8@suse.com>
 <9f6d296e94744ce48d3f72fe4d3fd136@EX13D32EUC003.ant.amazon.com>
 <39762aba-7c47-6b79-b931-771bc16195a2@suse.com>
 <9c943511cb6b483f8f0da6ce05a614cb@EX13D32EUC003.ant.amazon.com>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <169af9ff-9f2a-0fd5-82b5-05e75450445e@suse.com>
Date:   Mon, 16 Dec 2019 09:10:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <9c943511cb6b483f8f0da6ce05a614cb@EX13D32EUC003.ant.amazon.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.12.19 11:12, Durrant, Paul wrote:
>> -----Original Message-----
>> From: Jürgen Groß <jgross@suse.com>
>> Sent: 13 December 2019 10:02
>> To: Durrant, Paul <pdurrant@amazon.com>; David Miller
>> <davem@davemloft.net>
>> Cc: xen-devel@lists.xenproject.org; wei.liu@kernel.org; linux-
>> kernel@vger.kernel.org; netdev@vger.kernel.org
>> Subject: Re: [Xen-devel] [PATCH net-next] xen-netback: get rid of old udev
>> related code
>>
>> On 13.12.19 10:24, Durrant, Paul wrote:
>>>> -----Original Message-----
>>>> From: Jürgen Groß <jgross@suse.com>
>>>> Sent: 13 December 2019 05:41
>>>> To: David Miller <davem@davemloft.net>; Durrant, Paul
>>>> <pdurrant@amazon.com>
>>>> Cc: xen-devel@lists.xenproject.org; wei.liu@kernel.org; linux-
>>>> kernel@vger.kernel.org; netdev@vger.kernel.org
>>>> Subject: Re: [Xen-devel] [PATCH net-next] xen-netback: get rid of old
>> udev
>>>> related code
>>>>
>>>> On 12.12.19 20:05, David Miller wrote:
>>>>> From: Paul Durrant <pdurrant@amazon.com>
>>>>> Date: Thu, 12 Dec 2019 13:54:06 +0000
>>>>>
>>>>>> In the past it used to be the case that the Xen toolstack relied upon
>>>>>> udev to execute backend hotplug scripts. However this has not been
>> the
>>>>>> case for many releases now and removal of the associated code in
>>>>>> xen-netback shortens the source by more than 100 lines, and removes
>>>> much
>>>>>> complexity in the interaction with the xenstore backend state.
>>>>>>
>>>>>> NOTE: xen-netback is the only xenbus driver to have a functional
>>>> uevent()
>>>>>>          method. The only other driver to have a method at all is
>>>>>>          pvcalls-back, and currently pvcalls_back_uevent() simply
>> returns
>>>> 0.
>>>>>>          Hence this patch also facilitates further cleanup.
>>>>>>
>>>>>> Signed-off-by: Paul Durrant <pdurrant@amazon.com>
>>>>>
>>>>> If userspace ever used this stuff, I seriously doubt you can remove
>> this
>>>>> even if it hasn't been used in 5+ years.
>>>>
>>>> Hmm, depends.
>>>>
>>>> This has been used by Xen tools in dom0 only. If the last usage has
>> been
>>>> in a Xen version which is no longer able to run with current Linux in
>>>> dom0 it could be removed. But I guess this would have to be a rather
>> old
>>>> version of Xen (like 3.x?).
>>>>
>>>> Paul, can you give a hint since which Xen version the toolstack no
>>>> longer relies on udev to start the hotplug scripts?
>>>>
>>>
>>> The udev rules were in a file called tools/hotplug/Linux/xen-
>> backend.rules (in xen.git), and a commit from Roger removed the NIC rules
>> in 2012:
>>>
>>> commit 57ad6afe2a08a03c40bcd336bfb27e008e1d3e53
>>
>> Xen 4.2
>>
>>> The last commit I could find to that file modified its name to xen-
>> backend.rules.in, and this was finally removed by George in 2015:
>>>
>>> commit 2ba368d13893402b2f1fb3c283ddcc714659dd9b
>>
>> Xen 4.6
>>
>>> So, I think this means anyone using a version of the Xen tools within
>> recent memory will be having their hotplug scripts called directly by
>> libxl (and having udev rules present would actually be counter-productive,
>> as George's commit states and as I discovered the hard way when the change
>> was originally made).
>>
>> The problem are systems with either old Xen versions (before Xen 4.2) or
>> with other toolstacks (e.g. Xen 4.4 with xend) which want to use a new
>> dom0 kernel.
>>
>> And I'm not sure there aren't such systems (especially in case someone
>> wants to stick with xend).
>>
> 
> But would someone sticking with such an old toolstack expect to run on an unmodified upstream dom0? There has to be some way in which we can retire old code.

As long as there are no hypervisor interface related issues
prohibiting running dom0 unmodified I think the expectation to be
able to use the kernel in that environment is fine.

Another question coming up would be: how is this handled in a driver
domain running netback? Which component is starting the hotplug script
there? I don't think we can assume a standard Xen toolset in this case.
So I'd rather leave this code as it is instead of breaking some rare
but valid use cases.

> 
> Aside from the udev kicks though, I still think the hotplug-status/ring state interaction is just bogus anyway. As I said in a previous thread, the hotplug-status ought to be indicated as carrier status, if at all, so I still think all that code ought to go.

I agree regarding the future interface, but with the carrier state just
being in the plans to be added now, it is clearly too early to remove
the code with that reasoning.


Juergen
