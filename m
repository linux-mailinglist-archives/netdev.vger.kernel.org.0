Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95EC5107BFE
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 01:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbfKWAXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 19:23:53 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:47016 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfKWAXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 19:23:53 -0500
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 2021413C359;
        Fri, 22 Nov 2019 16:23:52 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 2021413C359
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1574468632;
        bh=evRZFRdmo5aOfwYNdCueRwUGApUqSnZjRbB4TfTm+ZE=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=mHc0rQdeD9mdC8R5SK8iRCFU2QnhUlRm8NKIqQcZH475ayRcgUxPfpwXiNVNKOkli
         xwWXn0sOF5BXEZWL/lg2LZBnwcEyRiF3TdUYhPthDdzGH78jTAZTr+YiyPvX/p3UVS
         957bZ2lvskLpof0XbixRbrJJc3vv1fV0snalfl4I=
Subject: Re: VRF and/or cgroups problem on Fedora-30, 5.2.21+ kernel
To:     David Ahern <dsahern@gmail.com>, netdev <netdev@vger.kernel.org>
References: <05276b67-406b-2744-dd7c-9bda845a5bb1@candelatech.com>
 <850a6d4e-3a67-a389-04a0-87032e0683d8@gmail.com>
 <213aa1d3-5df9-0337-c583-34f3de5f1582@candelatech.com>
 <8ae551e1-5c2e-6a95-b4d1-3301c5173171@gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <ffbeb74f-09d5-e854-190e-5362cc703a10@candelatech.com>
Date:   Fri, 22 Nov 2019 16:23:51 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <8ae551e1-5c2e-6a95-b4d1-3301c5173171@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/22/19 4:17 PM, David Ahern wrote:
> On 11/22/19 5:14 PM, Ben Greear wrote:
>> On 11/22/19 4:06 PM, David Ahern wrote:
>>> On 11/22/19 5:03 PM, Ben Greear wrote:
>>>> Hello,
>>>>
>>>> We see a problem on a particular system when trying to run 'ip vrf exec
>>>> _vrf1 ping 1.1.1.1'.
>>>> This system reproduces the problem all the time, but other systems with
>>>> exact same (as far as
>>>> we can tell) software may fail occasionally, but then it will work
>>>> again.
>>>>
>>>> Here is an strace output.  I changed to the
>>>> "/sys/fs/cgroup/unified/user.slice/user-1000.slice/session-2.scope/vrf/_vrf1"
>>>>
>>>>
>>>> directory as root user, and could view the files in that directory, so
>>>> I'm not sure why the strace shows error 5.
>>>>
>>>> Any idea what could be the problem and/or how to fix it or debug
>>>> further?
>>>>
>>>>
>>>> This command was run as root user.
>>>
>>> check 'ulimit -l'. BPF is used to set the VRF and it requires locked
>>> memory.
>>
>> It is set to '64'.  What is a good value to use?
>>
> 
> This is a pain point in using BPF for this. It's really use case
> dependent. 128kB, 256kB.
> 

Setting:  ulimit -l 1024

'fixed' the problem.

I'd rather waste a bit of memory and not have any of my users hit such an esoteric
bug, so I'll set it to at least 1024 going forward.

Would large numbers of vrf and/or network devices mean you need more locked memory?

And surely 'ip' could output a better error than just 'permission denied' for
this error case?  Or even something that would show up in dmesg to give a clue?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

