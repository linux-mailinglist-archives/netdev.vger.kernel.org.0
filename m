Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5A72B748C
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 04:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgKRDJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 22:09:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbgKRDJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 22:09:38 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C0DC0613D4
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 19:09:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=jCpBKmNvhkAdHALFrY2UpRl5LAxAwmhWF5B97vcw/qM=; b=aP5pEKOMOcaUSeGME2n0EpPbQx
        z4id5n+DQzHkxsuAimpUD/7w4HBMp2S5e0A8ng9Zi5znuBI0pn34a3cqRBsPoYThixWV52m1+SBzi
        vscZdu+WgWjSa9QI6EU4xQJGXeip1BTonQeacLj7MpBQKvjs7M1UykNhlsQUdRNLKZZ7rqwTOKrL6
        9FcYqfc1EZPUDfNwoOEcIXfFyq79iRaoNs6000C+z2u81E3dbkczCXK2ftIAeHm4eYAypFZhhO3zr
        rJFCQqGFyMpaYyV9e44IZOkf3LLrOciq2EgQzCeoO9OrTkmWL7u2LpuDD+Tn0rwqpTVcaYIGAmZYR
        omeDBpdw==;
Received: from [2601:1c0:6280:3f0::bcc4]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kfDqT-0005Ji-3s; Wed, 18 Nov 2020 03:09:22 +0000
Subject: Re: [PATCH] ipv4: use IS_ENABLED instead of ifdef
To:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@gmail.com>
Cc:     Florian Klink <flokli@flokli.de>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Kim Phillips <kim.phillips@arm.com>
References: <20201115224509.2020651-1-flokli@flokli.de>
 <20201117160110.42aa3b72@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <5cbc79c3-0a66-8cfb-64f4-399aab525d09@gmail.com>
 <20201117170712.0e5a8b23@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <0c2869ad-1176-9554-0c47-1f514981c6b4@infradead.org>
Date:   Tue, 17 Nov 2020 19:09:16 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201117170712.0e5a8b23@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/17/20 5:07 PM, Jakub Kicinski wrote:
> On Tue, 17 Nov 2020 17:55:54 -0700 David Ahern wrote:
>> On 11/17/20 5:01 PM, Jakub Kicinski wrote:
>>> On Sun, 15 Nov 2020 23:45:09 +0100 Florian Klink wrote:  
>>>> Checking for ifdef CONFIG_x fails if CONFIG_x=m.
>>>>
>>>> Use IS_ENABLED instead, which is true for both built-ins and modules.
>>>>
>>>> Otherwise, a  
>>>>> ip -4 route add 1.2.3.4/32 via inet6 fe80::2 dev eth1    
>>>> fails with the message "Error: IPv6 support not enabled in kernel." if
>>>> CONFIG_IPV6 is `m`.
>>>>
>>>> In the spirit of b8127113d01e53adba15b41aefd37b90ed83d631.
>>>>
>>>> Cc: Kim Phillips <kim.phillips@arm.com>
>>>> Signed-off-by: Florian Klink <flokli@flokli.de>  
>>>
>>> LGTM, this is the fixes tag right?
>>>
>>> Fixes: d15662682db2 ("ipv4: Allow ipv6 gateway with ipv4 routes")  
>>
>> yep.
>>
>>>
>>> CCing David to give him a chance to ack.  
>>
>> Reviewed-by: David Ahern <dsahern@kernel.org>
> 
> Great, applied, thanks!
> 
>> I looked at this yesterday and got distracted diving into the generated
>> file to see the difference:
>>
>> #define CONFIG_IPV6 1
>>
>> vs
>>
>> #define CONFIG_IPV6_MODULE 1

Digging up ancient history. ;)

> Interesting.
> 
> drivers/net/ethernet/netronome/nfp/flower/action.c:#ifdef CONFIG_IPV6
> 
> Oops.

Notify the maintainer!

-- 
~Randy

