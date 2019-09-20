Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92F11B94AD
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 17:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404803AbfITP5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 11:57:23 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:47804 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404456AbfITP5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 11:57:22 -0400
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 33FD513C2BA
        for <netdev@vger.kernel.org>; Fri, 20 Sep 2019 08:57:22 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 33FD513C2BA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1568995042;
        bh=vygwi+t+J8mPPiuvFf/wdtVQBGXCqERQLErn0RKtENs=;
        h=Subject:From:To:References:Date:In-Reply-To:From;
        b=bWtq/9sABlPbAyLFyUKbOwdQqhMURQgNlEgnPj76nMHji9iFc5ILclvvxmHTBze4B
         p+4oNyoD7E1AGkEkP1gxJIo3eTr595VBK563TwOyB29EFGUyFRKu/PeSa2chKeYlnB
         Dssv17SU2SGkHZTnwt5rFQfXrGLip5S+WNFtiq3g=
Subject: Re: Strange routing with VRF and 5.2.7+
From:   Ben Greear <greearb@candelatech.com>
To:     netdev <netdev@vger.kernel.org>
References: <91749b17-7800-44c0-d137-5242b8ceb819@candelatech.com>
 <51aae991-a320-43be-bf73-8b8c0ffcba60@candelatech.com>
Organization: Candela Technologies
Message-ID: <7d1de949-5cf0-cb74-6ca3-52315c34a340@candelatech.com>
Date:   Fri, 20 Sep 2019 08:57:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <51aae991-a320-43be-bf73-8b8c0ffcba60@candelatech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/10/19 6:08 PM, Ben Greear wrote:
> On 9/10/19 3:17 PM, Ben Greear wrote:
>> Today we were testing creating 200 virtual station vdevs on ath9k, and using
>> VRF for the routing.
> 
> Looks like the same issue happens w/out VRF, but there I have oodles of routing
> rules, so it is an area ripe for failure.
> 
> Will upgrade to 5.2.14+ and retest, and try 4.20 as well....

Turns out, this was ipsec (strongswan) inserting a rule that pointed to a table
that we then used for a vrf w/out realizing the rule was added.

Stopping strongswan and/or reconfiguring how routing tables are assigned
resolved the issue.

Thanks,
Ben

> 
> Thanks,
> Ben
> 
>>
>> This really slows down the machine in question.
>>
>> During the minutes that it takes to bring these up and configure them,
>> we loose network connectivity on the management port.
>>
>> If I do 'ip route show', it just shows the default route out of eth0, and
>> the subnet route.  But, if I try to ping the gateway, I get an ICMP error
>> coming back from the gateway of one of the virtual stations (which should be
>> safely using VRFs and so not in use when I do a plain 'ping' from the shell).
>>
>> I tried running tshark on eth0 in the background and running ping, and it captures
>> no packets leaving eth0.
>>
>> After some time (and during this time, my various scripts will be (re)configuring
>> vrfs and stations and related vrf routing tables and such,
>> but should *not* be messing with the main routing table, then suddenly
>> things start working again.
>>
>> I am curious if anyone has seen anything similar or has suggestions for more
>> ways to debug this.  It seems reproducible, but it is a pain to
>> debug.
>>
>> Thanks,
>> Ben
>>
> 
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

