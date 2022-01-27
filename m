Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E547A49E7C2
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 17:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238521AbiA0QlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 11:41:04 -0500
Received: from trinity.trinnet.net ([96.78.144.185]:1186 "EHLO
        trinity3.trinnet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiA0QlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 11:41:04 -0500
X-Greylist: delayed 2611 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Jan 2022 11:41:03 EST
Received: from trinity4.trinnet.net (trinity4.trinnet.net [192.168.0.11])
        by trinity3.trinnet.net (TrinityOS Hardened/TrinityOS Hardened) with ESMTP id 20RFweo8016690;
        Thu, 27 Jan 2022 07:58:40 -0800
From:   David Ranch <linux-hams@trinnet.net>
Subject: Re: [PATCH net-next 06/15] net: ax25: remove route refcount
To:     Thomas Osterried <thomas@osterried.de>,
        Jakub Kicinski <kuba@kernel.org>
References: <20220126191109.2822706-1-kuba@kernel.org>
 <20220126191109.2822706-7-kuba@kernel.org>
 <20220127091858.GF18529@x-berg.in-berlin.de>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, ralf@linux-mips.org,
        linux-hams@vger.kernel.org
Message-ID: <f6749b58-ab8a-094c-5e07-c5a7ca5200c9@trinnet.net>
Date:   Thu, 27 Jan 2022 07:58:40 -0800
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <20220127091858.GF18529@x-berg.in-berlin.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (trinity3.trinnet.net [192.168.0.1]); Thu, 27 Jan 2022 07:58:40 -0800 (GMT+8)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Curious, has this change been tested with an actual testbed to confirm 
it doesn't break anything?  We *have* to stop allowing good intentioned 
but naive developers from submitting patches when they've never tested 
the resulting change.

--David
KI6ZHD


On 01/27/2022 01:18 AM, Thomas Osterried wrote:
> Hello,
>
>   think it's absolutely correct to state
>    "Nothing takes the refcount since v4.9."
> because in ax25_rt_add(),
>    refcount_set(&ax25_rt->refcount, 1);
> is used (for every new ax25_rt entry).
>
> But nothing does an increment.
> There's one function in include/net/ax25.h ,
>    ax25_hold_route() which would refcount_inc(&ax25_rt->refcount)
> but it's not called from anywhere.
>
> => It's value is always 1, and the deleting function ax25_put_route() decrements it again before freeing.
>     I also see no sense in this (anymore).
>
>
> Every struct ax25_route_list operation is assured with either
>    write_lock_bh(&ax25_route_lock);
>    write_unlock_bh(&ax25_route_lock);
> or
>    the struct ax25_route returned from functions is assured by calling read_lock(&ax25_route_lock).
>
> -> No refcount is needed.
>
>
> => It's good to tidy up stuff that's needed anymore.
>
> But keep in mind:
> The code has strong similarities with include/net/x25.h and x25/x25_route.c ,
> especially in the parts of ax25_hold_route() and ax25_rt_add().
> This will get lost.
>
>
> But there a things a bot does not know: human readable senteces.
> ax25_get_route() is introduced with:
>
>    /*
>     *      Find AX.25 route
>     *
>     *      Only routes with a reference count of zero can be destroyed.
>     *      Must be called with ax25_route_lock read locked.
>     */
>
> The first sentence informs: ax25_rt entries may be freed during the ax25_route_list operation.
> It mentiones reference count (which will exist anymore).
> The conclusion of the first sentence is "Must be called with ax25_route_lock read locked.". This is still true and assured.
> I don't think it has to explain why the read lock is necessary (it's obvious, that routes could be deleted or added to the list). ->
>
>    /*
>     *      Find AX.25 route
>     *
>     *      Must be called with ax25_route_lock read locked.
>     */
>
> should be enough.
>
> ff-topic:
> =========
>
> About read_lock)(): Inconsistent use.
> It's
>    directly called,
> and by
>    ax25_route_lock_use(), which calls read_lock():
>    {
>            read_lock(&ax25_route_lock);
>    }
>
> This makes the code harder to read.
> There's also a function ax25_rt_seq_stop() that calls read_unlock() instead of calling ax25_route_lock_unuse(), which does the same.
>
>
> vy 73,
> 	- Thomas  dl9sau
>
> On Wed, Jan 26, 2022 at 11:11:00AM -0800, Jakub Kicinski wrote:
>> Nothing takes the refcount since v4.9.
>>
>> Signed-off-by: Jakub Kicinski<kuba@kernel.org>
>> ---
>> CC:ralf@linux-mips.org
>> CC:linux-hams@vger.kernel.org
>> ---
>>   include/net/ax25.h    | 12 ------------
>>   net/ax25/ax25_route.c |  5 ++---
>>   2 files changed, 2 insertions(+), 15 deletions(-)
>>
>> diff --git a/include/net/ax25.h b/include/net/ax25.h
>> index 526e49589197..cb628c5d7c5b 100644
>> --- a/include/net/ax25.h
>> +++ b/include/net/ax25.h
>> @@ -187,18 +187,12 @@ typedef struct {
>>   
>>   typedef struct ax25_route {
>>   	struct ax25_route	*next;
>> -	refcount_t		refcount;
>>   	ax25_address		callsign;
>>   	struct net_device	*dev;
>>   	ax25_digi		*digipeat;
>>   	char			ip_mode;
>>   } ax25_route;
>>   
>> -static inline void ax25_hold_route(ax25_route *ax25_rt)
>> -{
>> -	refcount_inc(&ax25_rt->refcount);
>> -}
>> -
>>   void __ax25_put_route(ax25_route *ax25_rt);
>>   
>>   extern rwlock_t ax25_route_lock;
>> @@ -213,12 +207,6 @@ static inline void ax25_route_lock_unuse(void)
>>   	read_unlock(&ax25_route_lock);
>>   }
>>   
>> -static inline void ax25_put_route(ax25_route *ax25_rt)
>> -{
>> -	if (refcount_dec_and_test(&ax25_rt->refcount))
>> -		__ax25_put_route(ax25_rt);
>> -}
>> -
>>   typedef struct {
>>   	char			slave;			/* slave_mode?   */
>>   	struct timer_list	slave_timer;		/* timeout timer */
>> diff --git a/net/ax25/ax25_route.c b/net/ax25/ax25_route.c
>> index d0b2e094bd55..be97dc6a53cb 100644
>> --- a/net/ax25/ax25_route.c
>> +++ b/net/ax25/ax25_route.c
>> @@ -111,7 +111,6 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
>>   		return -ENOMEM;
>>   	}
>>   
>> -	refcount_set(&ax25_rt->refcount, 1);
>>   	ax25_rt->callsign     = route->dest_addr;
>>   	ax25_rt->dev          = ax25_dev->dev;
>>   	ax25_rt->digipeat     = NULL;
>> @@ -160,12 +159,12 @@ static int ax25_rt_del(struct ax25_routes_struct *route)
>>   		    ax25cmp(&route->dest_addr, &s->callsign) == 0) {
>>   			if (ax25_route_list == s) {
>>   				ax25_route_list = s->next;
>> -				ax25_put_route(s);
>> +				__ax25_put_route(s);
>>   			} else {
>>   				for (t = ax25_route_list; t != NULL; t = t->next) {
>>   					if (t->next == s) {
>>   						t->next = s->next;
>> -						ax25_put_route(s);
>> +						__ax25_put_route(s);
>>   						break;
>>   					}
>>   				}
>> -- 
>> 2.34.1
>>

