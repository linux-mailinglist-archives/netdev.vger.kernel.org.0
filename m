Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA5556D453
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 21:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391052AbfGRTDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 15:03:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54276 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727685AbfGRTDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 15:03:03 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 659101527DCC1;
        Thu, 18 Jul 2019 12:03:02 -0700 (PDT)
Date:   Thu, 18 Jul 2019 12:03:01 -0700 (PDT)
Message-Id: <20190718.120301.1523874454003539281.davem@davemloft.net>
To:     dsahern@gmail.com
Cc:     idosch@idosch.org, netdev@vger.kernel.org, alexpe@mellanox.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net] ipv6: Unlink sibling route in case of failure
From:   David Miller <davem@davemloft.net>
In-Reply-To: <f6dacc3e-7b20-2441-dd7d-99d3983bddc3@gmail.com>
References: <20190717203933.3073-1-idosch@idosch.org>
        <f6dacc3e-7b20-2441-dd7d-99d3983bddc3@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jul 2019 12:03:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>
Date: Thu, 18 Jul 2019 08:21:01 -0600

> On 7/17/19 2:39 PM, Ido Schimmel wrote:
>> From: Ido Schimmel <idosch@mellanox.com>
>> 
>> When a route needs to be appended to an existing multipath route,
>> fib6_add_rt2node() first appends it to the siblings list and increments
>> the number of sibling routes on each sibling.
>> 
>> Later, the function notifies the route via call_fib6_entry_notifiers().
>> In case the notification is vetoed, the route is not unlinked from the
>> siblings list, which can result in a use-after-free.
>> 
>> Fix this by unlinking the route from the siblings list before returning
>> an error.
>> 
>> Audited the rest of the call sites from which the FIB notification chain
>> is called and could not find more problems.
>> 
>> Fixes: 2233000cba40 ("net/ipv6: Move call_fib6_entry_notifiers up for route adds")
>> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
>> Reported-by: Alexander Petrovskiy <alexpe@mellanox.com>
>> ---
>> Dave, this will not apply cleanly to stable trees due to recent changes
>> in net-next. I can prepare another patch for stable if needed.
>> ---
>>  net/ipv6/ip6_fib.c | 18 +++++++++++++++++-
>>  1 file changed, 17 insertions(+), 1 deletion(-)
>> 
> 
> Thanks for the fix, Ido. I can help with the ports as well.
> 
> Reviewed-by: David Ahern <dsahern@gmail.com>

Applied and queued up for -stable.

Since I've done a bunch of ipv6 routing fix backports through David's
refactoring and cleanups, I'll give this one a try too :-) If I run
into problems I'll ask for help.

Thanks.
