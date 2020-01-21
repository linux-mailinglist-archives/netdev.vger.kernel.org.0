Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDA31436BA
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 06:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbgAUF3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 00:29:44 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:37214 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgAUF3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 00:29:43 -0500
Received: from [192.168.1.47] (unknown [50.34.171.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id C5B342F7539;
        Mon, 20 Jan 2020 21:29:42 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com C5B342F7539
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1579584583;
        bh=x4FWC1VwmcH4cHuFjD0zrAV26YOFnyCLCOFIObRLWwo=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=omaVG+VPoBCLec1ey0jVLeqY0O0X3WK/SChmHkf77CHO3FKqyWdJ/0v4+mZSVOnPS
         27wfeZngbDADlkMHUiWzvSUBNFKoGFQFizS623mR8W3mPDvfzYf7GLFOSOH0Lw6C7d
         RJ/VZvDb2OMJsow1jnFs/jDH26uvZCB0AIlttvEE=
Subject: Re: vrf and ipsec xfrm routing problem
To:     David Ahern <dsahern@gmail.com>, netdev <netdev@vger.kernel.org>
References: <1425d02c-de99-b708-e543-b7fe3f0ef07e@candelatech.com>
 <9893ae01-18a5-2afd-b485-459423b8adc0@candelatech.com>
 <ce3ba3f4-b0dd-b3b5-fbb7-095122ed75b3@gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Message-ID: <d6840ae9-bfce-7ea8-9d44-7f8ee99874ab@candelatech.com>
Date:   Mon, 20 Jan 2020 21:29:41 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <ce3ba3f4-b0dd-b3b5-fbb7-095122ed75b3@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 01/20/2020 07:21 PM, David Ahern wrote:
> On 1/17/20 2:52 PM, Ben Greear wrote:
>>> I tried adding a route to specify the x_frm as source, but that does
>>> not appear to work:
>>>
>>> [root@lf0313-63e7 lanforge]# ip route add 192.168.10.0/24 via
>>> 192.168.5.1 dev x_eth4 table 4
>>> [root@lf0313-63e7 lanforge]# ip route show vrf _vrf4
>>> default via 192.168.5.1 dev eth4
>>> 192.168.5.0/24 dev eth4 scope link src 192.168.5.4
>>> 192.168.10.0/24 via 192.168.5.1 dev eth4
>>>
>>> I also tried this, but no luck:
>>>
>>> [root@lf0313-63e7 lanforge]# ip route add 192.168.10.0/24 via
>>> 192.168.10.1 dev x_eth4 table 4
>>> Error: Nexthop has invalid gateway.
>>
>> I went looking for why this was failing.  The reason is that this code
>> is hitting the error case
>> in the code snippet below (from 5.2.21+ kernel).
>>
>> The oif is that of _vrf4, not the x_eth4 device.
>>
>> David:  Is this expected behaviour?  Do you know how to tell vrf to use
>> the x_eth4
>
> It is expected behavior for VRF. l3mdev_update_flow changes the oif to
> the VRF device if the passed in oif is enslaved to a VRF.
>
>> xfrm device as oif when routing output to certain destinations?
>>
>>     rcu_read_lock();
>>     {
>>         struct fib_table *tbl = NULL;
>>         struct flowi4 fl4 = {
>>             .daddr = nh->fib_nh_gw4,
>>             .flowi4_scope = scope + 1,
>>             .flowi4_oif = nh->fib_nh_oif,
>>             .flowi4_iif = LOOPBACK_IFINDEX,
>>         };
>>
>>         /* It is not necessary, but requires a bit of thinking */
>>         if (fl4.flowi4_scope < RT_SCOPE_LINK)
>>             fl4.flowi4_scope = RT_SCOPE_LINK;
>
> If you put your debug here, flowi4_oif should be fib_nh_oif per the
> above initialization. It gets changed by the call to fib_lookup.
>
> --
>
> Sabrina sent me a short script on using xfrm devices to help me get up
> to speed on that config (much simpler than using any of the *SWAN
> programs). I have incorporated the xfrm device setup into a script of
> other vrf + ipsec tests. A couple of tests are failing the basic setup.
> I have a fix for one of them (as well as the fix for the qdisc on a VRF
> device). I did notice trying to add routes with the xfrm device as the
> nexthop dev was failing but have not had time to dig into it. I have
> busy week but will try to spend some time on this use case this week.

I dug into the nexthop thing a bit earlier.  It fails because oif is always forced to
be the VRF device, and then the nexthop is considered unreachable for reasons that
escape me.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
