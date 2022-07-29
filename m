Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB62584B49
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 07:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234015AbiG2FtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 01:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiG2FtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 01:49:16 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 390C620BEA;
        Thu, 28 Jul 2022 22:49:14 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id E42631E80D77;
        Fri, 29 Jul 2022 13:49:06 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id TcvvCQeC8H69; Fri, 29 Jul 2022 13:49:04 +0800 (CST)
Received: from [172.30.18.178] (unknown [180.167.10.98])
        (Authenticated sender: yuzhe@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id A59E21E80CF9;
        Fri, 29 Jul 2022 13:49:03 +0800 (CST)
Subject: Re: [PATCH] dn_route: use time_is_before_jiffies(a) to replace
 "jiffies - a > 0"
To:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        liqiong@nfschina.com
References: <20220727024600.18413-1-yuzhe@nfschina.com>
 <e63e6fc511d9d515fcb8501f48f218192f36afd3.camel@redhat.com>
From:   Yu Zhe <yuzhe@nfschina.com>
Message-ID: <98b5da7e-74d2-0350-e0fc-a98ca3cb944c@nfschina.com>
Date:   Fri, 29 Jul 2022 13:49:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <e63e6fc511d9d515fcb8501f48f218192f36afd3.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RDNS_NONE,SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2022年07月28日 21:11, Paolo Abeni 写道:

> On Wed, 2022-07-27 at 10:46 +0800, Yu Zhe wrote:
>> time_is_before_jiffies deals with timer wrapping correctly.
>>
>> Signed-off-by: Yu Zhe <yuzhe@nfschina.com>
>> ---
>>   net/decnet/dn_route.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/decnet/dn_route.c b/net/decnet/dn_route.c
>> index 552a53f1d5d0..0a4bed0bc2e3 100644
>> --- a/net/decnet/dn_route.c
>> +++ b/net/decnet/dn_route.c
>> @@ -201,7 +201,7 @@ static void dn_dst_check_expire(struct timer_list *unused)
>>   		}
>>   		spin_unlock(&dn_rt_hash_table[i].lock);
>>   
>> -		if ((jiffies - now) > 0)
>> +		if (time_is_before_jiffies(now))
> Uhmm... it looks like the wrap-around condition can happen only in
> theory: 'now' is initialized just before entering this loop, and we
> will break as soon as jiffies increment. The wrap-around could happen
> only if a single iteration of the loop takes more than LONG_MAX
> jiffies.
>
> If that happens, we have a completely different kind of much more
> serious problem, I think ;)
>
> So this change is mostly for core readability's sake. I personally find
> more readable:
>
> 		if (jiffies != now)

I agree and I will send a v2 patch later.

>
> Cheers,
>
> Paolo
>
> p.s. given the above I guess this is for the net-next tree, right?
>
yes

>
