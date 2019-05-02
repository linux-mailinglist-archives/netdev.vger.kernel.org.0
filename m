Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73A3B119EB
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 15:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbfEBNR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 09:17:58 -0400
Received: from w1.tutanota.de ([81.3.6.162]:25988 "EHLO w1.tutanota.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbfEBNR5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 09:17:57 -0400
Received: from w2.tutanota.de (unknown [192.168.1.163])
        by w1.tutanota.de (Postfix) with ESMTP id B9D23FA0158;
        Thu,  2 May 2019 13:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tutanota.com;
        s=20161216; t=1556803075;
        bh=Q8EjxTHMmCzzB4wuLJ/pun1j1gtByqZ6bbrrm2x+nF4=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
        b=IQvMZSh0C/hnykAijH4pSdd0AKfIx3kzDgB+6tx5hbfK6HzC00KepL+Mc5rtIY/3p
         m6bSVeyvt/+hx+24QfB+1tQXymB4QkOOtZfGE8O/hfJwS0h1rbG6BdZpmlNHHO0Fom
         Ug9EXr7YRpyl/YGUsh4iKbN+Paqn0jSrFhtoWbSnMnPYxENUfL67M00tc8bZ27UOM9
         /gZ4h2pBcPLyvnynwBtKNVu4vTQCKbNNm8cpyM4y7H43bfYWn4na6JndIIiDTHckzS
         yHObIP9DDlj80Q3Ql99zD7Bv6/2z41UwWclJSpprxYR/O0fJNwe86PSaZ7Bq5JLxzb
         1rTHzfwN2ZFMQ==
Date:   Thu, 2 May 2019 15:17:55 +0200 (CEST)
From:   <emersonbernier@tutanota.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Michal Kubecek <mkubecek@suse.cz>, Netdev <netdev@vger.kernel.org>,
        Stephen <stephen@networkplumber.org>,
        Kuznet <kuznet@ms2.inr.ac.ru>, Jason <jason@zx2c4.com>,
        Davem <davem@davemloft.net>
Message-ID: <LdsgQO---3-1@tutanota.com>
In-Reply-To: <26689b18-e0f1-c490-7802-4256f12aa5e2@gmail.com>
References: <LaeckvP--3-1@tutanota.com> <f60d6632-2f3c-c371-08c1-30bcb6a25344@gmail.com> <LakduwN--3-1@tutanota.com> <0e008631-e6f6-3c08-f76a-8069052f19ef@gmail.com> <20190324182908.GA26076@unicorn.suse.cz> <20190324183618.GB26076@unicorn.suse.cz> <26689b18-e0f1-c490-7802-4256f12aa5e2@gmail.com>
Subject: Re: [BUG][iproute2][5.0] ip route show table default: "Error: ipv4:
 FIB table does not exist."
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mar 24, 2019, 10:09 PM by dsahern@gmail.com:

> On 3/24/19 12:36 PM, Michal Kubecek wrote:
>
>> On Sun, Mar 24, 2019 at 07:29:08PM +0100, Michal Kubecek wrote:
>>
>>> On Sun, Mar 24, 2019 at 11:20:33AM -0600, David Ahern wrote:
>>>
>>>> On 3/24/19 11:02 AM, >>>> emersonbernier@tutanota.com <mailto:emersonbernier@tutanota.com>>>>>  wrote:
>>>>
>>>>> Ok but previous versions of iproute2 didn't treat this as error and didn't exited with non-zero status. Is non existing default route a system error which needs fixing?
>>>>>
>>>>
>>>> The kernel is returning that error, not iproute2.
>>>>
>>>> It is the default *table*, not a default route.
>>>>
>>>
>>> Something did change on iproute2 side between 4.20 and 5.0, though:
>>>
>>> lion:~ # rpm -q iproute2
>>> iproute2-4.20-0.x86_64
>>> lion:~ # ip route show table default ; echo $?
>>> 0
>>> lion:~ # ip route show table 123 ; echo $?
>>> 0
>>> ...
>>> lion:~ # rpm -q iproute2
>>> iproute2-5.0.0-0.x86_64
>>> lion:~ # ip route show table default ; echo $?
>>> Error: ipv4: FIB table does not exist.
>>> Dump terminated
>>> 2
>>> lion:~ # ip route show table 123 ; echo $?
>>> Error: ipv4: FIB table does not exist.
>>> Dump terminated
>>> 2
>>>
>>> All I did was updating iproute2 package, the same kernel was running for
>>> both (I tried 5.0.3 and 5.1-rc1).
>>>
>>
>> Commit c7e6371bc4af ("ip route: Add protocol, table id and device to
>> dump request") seems to be an obvious candidate. Before it, no matching
>> rules in the dump used to be presented as an empty table but now ip gets
>> a kernel error which it displays to the user.
>>
>
> It's the commit that enables strict checking. Kernel side has been
> changed to better inform the user of what happens on a request when
> strict checking is enabled. iproute2 has been updated to use this.
>
> Essentially, ip asks for a dump of table 253. In the past there is no
> data, so nothing to return. The strict checking tells you explicitly
> "that table does not exist" versus the old method where nothing is
> returned and the user has to guess "the table exists but is empty or
> there is a bug dumping the table?"
>
> Given the legacy of table 253/default, iproute2 can easily catch this
> error and just do nothing for backwards compatibility.
>
Hi, 

are those changes planned then? I don't see anything in repo
https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/log/
