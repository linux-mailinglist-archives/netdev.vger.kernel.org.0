Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA762EF2DD
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 14:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726745AbhAHNH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 08:07:59 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:41386 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbhAHNH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 08:07:58 -0500
Received: from [192.168.254.6] (unknown [50.46.152.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 26D3613C2B0;
        Fri,  8 Jan 2021 05:07:16 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 26D3613C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1610111238;
        bh=219cdLg/Ji0/571lkM/bMGIlP+NbKULrbbwakcntH9M=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=pfNQ3Dyk8BAZfPdhf7E7/AguVbbQcWXBfXbrGm+LDQGaEws4fLJAsXYlL3CtQjlwf
         /yn9AMLzMVUB+g9Y9dnc8pQJAEmH6vvY3mGqC0nWBH01cZhtjSuE22zhUGLkEW6hkC
         /5OEi9e/VotoxgGC8rfp340C+wG11gxfp0CgRc8I=
Subject: Re: 5.10.4+ hang with 'rmmod nf_conntrack'
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev <netdev@vger.kernel.org>
References: <41dbfc93-0d57-6d78-f6fa-529dd5e0685c@candelatech.com>
 <20210108061653.GB19605@breakpoint.cc>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <0fa45356-7c63-bb01-19c8-9447cf2cad39@candelatech.com>
Date:   Fri, 8 Jan 2021 05:07:12 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20210108061653.GB19605@breakpoint.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/7/21 10:16 PM, Florian Westphal wrote:
> Ben Greear <greearb@candelatech.com> wrote:
>> I noticed my system has a hung process trying to 'rmmod nf_conntrack'.
>>
>> I've generally been doing the script that calls rmmod forever,
>> but only extensively tested on 5.4 kernel and earlier.
>>
>> If anyone has any ideas, please let me know.  This is from 'sysrq t'.  I don't see
>> any hung-task splats in dmesg.
> 
> rmmod on conntrack loops forever until the active conntrack object count reaches 0.
> (plus a walk of the conntrack table to evict/put all entries).
> 
>> I'll see if it is reproducible and if so will try
>> with lockdep enabled...
> 
> No idea, there was a regression in 5.6, but that was fixed by the time
> 5.7 was released.
> 
> Can't reproduce hangs with a script that injects a few dummy entries
> and then removes the module:
> 
> added=0
> 
> add_and_rmmod()
> {
>          while [ $added -lt 1000 ]; do
>                  conntrack -I -s $(($RANDOM%256)).$(($RANDOM%256)).$(($RANDOM%256)).$(($RANDOM%255+1)) \
>                          -d $(($RANDOM%256)).$(($RANDOM%256)).$(($RANDOM%256)).$(($RANDOM%255+1)) \
>                           --protonum 6 --timeout $(((RANDOM%120) + 240)) --state ESTABLISHED --sport $RANDOM --dport $RANDOM 2> /dev/null || break
> 
>                  added=$((added + 1))
>                  if [ $((added % 1000)) -eq 0 ];then
>                          echo $added
>                  fi
>          done
> 
>          echo rmmod after adding $added entries
>          conntrack -C
>          rmmod nf_conntrack_netlink
>          rmmod nf_conntrack
> }
> 
> add_and_rmmod
> 
> I don't see how it would make a difference, but do you have any special conntrack features enabled
> at run time, e.g. reliable netlink events? (If you don't know what I mean the answer is no).

Not that I know of, but I am using lots of VRF devices, each with their own routing table, as well
as some wifi stations and AP netdevs.

I'll let you know if I can reproduce it again..

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
