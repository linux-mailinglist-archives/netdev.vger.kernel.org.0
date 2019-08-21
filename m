Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 691C998576
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 22:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728998AbfHUUUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 16:20:04 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:59004 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727685AbfHUUUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 16:20:04 -0400
Received: from [172.31.98.117] (unknown [4.30.140.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 81F7B65937;
        Wed, 21 Aug 2019 13:20:03 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 81F7B65937
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1566418803;
        bh=Eu97Kys10jTPoksJ0inbkOY3y1jtDXfYMq9UoxO1vjM=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=Sv5VmAb+fytmGqP3vwO06Upc9BJZPoPkCalxYSdRxGxQB38OBlmVri1X8dmRLx4Hw
         5STHJp3+DgDTyofOgQCVau6WzEccLO1LqQjFlQoY/YSpDQugPaHDr4cVg6NZl3AEYT
         wUxfNj/g9CePjxvUw7qi5AR9sxiuiv0wZNYF2Z4w=
Message-ID: <5D5DA773.6000100@candelatech.com>
Date:   Wed, 21 Aug 2019 13:20:03 -0700
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To:     David Ahern <dsahern@gmail.com>, netdev <netdev@vger.kernel.org>
Subject: Re: VRF notes when using ipv6 and flushing tables.
References: <8977a25e-29c1-5375-cc97-950dc7c2eb0f@candelatech.com> <2a8914bb-56ec-e585-bd76-36b77ca2517d@gmail.com>
In-Reply-To: <2a8914bb-56ec-e585-bd76-36b77ca2517d@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/20/2019 08:02 PM, David Ahern wrote:
> On 8/20/19 2:27 PM, Ben Greear wrote:
>> I recently spend a few days debugging what in the end was user error on
>> my part.
>>
>> Here are my notes in hope they help someone else.
>>
>> First, 'ip -6 route show vrf vrfX' will not show some of the
>> routes (like local routes) that will show up with
>> 'ip -6 route show table X', where X == vrfX's table-id
>>
>> If you run 'ip -6 route flush table X', then you will loose all of the auto
>> generated routes, including anycast, ff00::/8, and local routes.
>>
>> ff00::/8 is needed for neigh discovery to work (probably among other
>> things)
>>
>> local route is needed or packets won't actually be accepted up the stack
>> (I think that is the symptom at least)
>>
>> Not sure exactly what anycast does, but I'm guessing it is required for
>> something useful.
>>
>> You must manually re-add those to the table unless you for certain know
>> that
>> you do not need them for whatever reason.
>>
>
> sorry you went through such a long and painful debugging session.

No problem.  I learned some details of IPv6 I never realized before,
sure to come in useful some day!

Thanks,
Ben

> yes, the kernel doc for VRF needs to be updated that 'ip route show vrf
> X' and 'ip route show table X' are different ('show vrf' mimics the main
> table in not showing local, broadcast, anycast; 'table vrf' shows all).
>
> A suggestion for others: the documentation and selftests directory have
> a lot of VRF examples now. If something basic is not working (e.g., arp
> or neigh discovery), see if it works there and if so compare the outputs
> of the route table along the way.



-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

