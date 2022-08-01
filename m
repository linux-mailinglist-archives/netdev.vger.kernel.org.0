Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D50CF587128
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 21:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233010AbiHATLM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 1 Aug 2022 15:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234727AbiHATKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 15:10:19 -0400
Received: from einhorn-mail-out.in-berlin.de (einhorn.in-berlin.de [192.109.42.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 411414AD6B
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 12:06:22 -0700 (PDT)
X-Envelope-From: thomas@osterried.de
Received: from x-berg.in-berlin.de (x-change.in-berlin.de [217.197.86.40])
        by einhorn.in-berlin.de  with ESMTPS id 271J6B0e048652
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Mon, 1 Aug 2022 21:06:11 +0200
Received: from x-berg.in-berlin.de ([217.197.86.42] helo=smtpclient.apple)
        by x-berg.in-berlin.de with esmtpa (Exim 4.94.2)
        (envelope-from <thomas@osterried.de>)
        id 1oIajy-00083v-93; Mon, 01 Aug 2022 21:06:10 +0200
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: rose timer t error displayed in /proc/net/rose
From:   Thomas Osterried <thomas@osterried.de>
In-Reply-To: <Yuf04XIsXrQMJuUy@electric-eye.fr.zoreil.com>
Date:   Mon, 1 Aug 2022 21:06:09 +0200
Cc:     Bernard f6bvp <f6bvp@free.fr>, Eric Dumazet <edumazet@google.com>,
        linux-hams@vger.kernel.org,
        Thomas Osterried DL9SAU <thomas@x-berg.in-berlin.de>,
        netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <299F663F-8A8A-4C0B-9A95-DD664451B125@osterried.de>
References: <d5e93cc7-a91f-13d3-49a1-b50c11f0f811@free.fr>
 <YucgpeXpqwZuievg@electric-eye.fr.zoreil.com>
 <A9A8A0B7-5009-4FB0-9317-5033DE17E701@osterried.de>
 <Yuf04XIsXrQMJuUy@electric-eye.fr.zoreil.com>
To:     Francois Romieu <romieu@fr.zoreil.com>
X-Mailer: Apple Mail (2.3696.100.31)
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> Am 01.08.2022 um 17:44 schrieb Francois Romieu <romieu@fr.zoreil.com>:
> 
> Thomas Osterried <thomas@osterried.de> :
> [...]
>> 1. why do you check for pending timer anymore?
> 
> s/do/don't/ ?

Yes, don't; sorry ;)

> I don't check for pending timer because:
> - the check is racy

Just arguing:

If no timer is running, we previously returned 0:
if (!timer_pending(timer))
  return 0;

If we omit this check, timer->expires is the jiffies of last timer expiration.

What if jiffies overflows due to long uptime?

Example:
if jiffies is at "maxvalue - 100" and timer is set to i.e. jiffies+10000, timer->expires is set to 9900  (overflow of the unsigned long).

Original code:
   return timer->expires - jiffies;
== return 9900-(maxvalue - 100)
-> large negative value, but our small positive difference, because we are in unsigned long.

But original code bugs (just found it out) if expires is i.e. 100 and jiffies i.E. 150: then we get a large unsigned result.
=> This always will happen if you cat /proc and timer has just expired and the new timer timerhas not started.
if (!timer_pending(timer)) prevented that false value.

Your patch makes this good.

Prove:

include <stdio.h>

int main()
{
  unsigned long foo = 0;
  foo = foo -100;
  unsigned long bar = foo + 10000;
  unsigned long foo2 = foo+50;
  printf("jifffiessWhenTimerSet %lu; timerExpires(jifffiessWhenTimerSet+10000) %lu; jifffiessWhenTimerSet+50 %lu, diff to expiry %lu\n", foo, bar, foo2, bar-foo2);

  long delta = bar-foo2;

  printf("with signed long delta:\n");
  printf("jifffiessWhenTimerSet %lu; timerExpires(jifffiessWhenTimerSet+10000) %lu; jifffiessWhenTimerSet+50 %lu, diff to expiry %ld\n", foo, bar, foo2, delta);

  foo2 = foo2 + 10000;
  printf("jiffies += 10000 = %lu:\n", foo2);
  printf("jifffiessWhenTimerSet %lu; timerExpires(jifffiessWhenTimerSet+10000) %lu; jifffiessWhenTimerSet+50+10000 %lu, diff to expiry %lu\n", foo, bar, foo2, bar-foo2);
  delta = bar-foo2;
  printf("with signed long delta:\n");
  printf("jifffiessWhenTimerSet %lu; timerExpires(jifffiessWhenTimerSet+10000) %lu; jifffiessWhenTimerSet+50+10000 %lu, diff to expiry %ld\n", foo, bar, foo2, delta);
}


jifffiessWhenTimerSet 18446744073709551516; timerExpires(jifffiessWhenTimerSet+10000) 9900; jifffiessWhenTimerSet+50 18446744073709551566, diff to expiry 9950
with signed long delta:
jifffiessWhenTimerSet 18446744073709551516; timerExpires(jifffiessWhenTimerSet+10000) 9900; jifffiessWhenTimerSet+50 18446744073709551566, diff to expiry 9950
jiffies += 10000 = 9950:
jifffiessWhenTimerSet 18446744073709551516; timerExpires(jifffiessWhenTimerSet+10000) 9900; jifffiessWhenTimerSet+50+10000 9950, diff to expiry 18446744073709551566
with signed long delta:
jifffiessWhenTimerSet 18446744073709551516; timerExpires(jifffiessWhenTimerSet+10000) 9900; jifffiessWhenTimerSet+50+10000 9950, diff to expiry -50


=> ;))


Nevertheless, I feel better to return 0 if no timer is running, than computing on a timer with an ancient timer->expiry. Because in some time gap, we might get a positive result and display that - but since timer is not running the result should be 0.



You argued on timer_pending(timer): "the check is racy".
Perhaps. But the time window is small:
you do a cat /proc/... while timer is stopped.
you check timer_pending(timer) -> false.
other cpu starts the timer.
you'll returrn 0 instead of maxtimervalue.
If you'd issued the command a few microseconds before or after, the value would be correct.
This is, imho, absolutely ok.

But if timer is stopped at jiffies = maxvalue-100, and we now are at jffies == 100, then we
get with maxvalue-100-100 a very large number (instead of 0 - timer is not running. And this will happen the next 49 days (on 64bit).

I hope I've not overseen / misinterpreted something. But as far as I can see, a propably racy timer_pending(timer) is better than the risk of returning numbers
- where user thinks it's a running timer, but it's from a previously stopped one
- that may become very high


> - jiffies_delta_to_clock_t maxes negative delta to zero

I also came to this opinion for jiffies_delta_to_clock_t; but Bernard posted this morning he tested, and still got negative values.

> 
>> 2. I'm not really sure what value jiffies_delta_to_clock_t() returns. jiffies / HZ?
>>   jiffies_delta_to_clock_t() returns clock_t.
> 
> I completely messed this part :o/
> 
> clock_t relates to USER_HZ like jiffies does to HZ.
> 
> [don't break the ax25]
> 
> Sure, we are in violent agreement here.
> 
> [...]
>> 1. I expect rose->timer to be restarted soon. If it does not happen, is there a bug?
> 
> The relevant rose state in Bernard's sample was ROSE_STATE_2.
> 
> net/rose/rose_timer.c::rose_timer_expiry would had called
> rose_disconnect(sk, ETIMEDOUT, -1, -1) so there should not
> be any timer restart (afaiu, etc.).
> 
> [...]
>>   => Negative may be handled due to Francois' patch now correctly.
>> delta as signed long may be negative. max(0L, -nnnn) sould result to 0L.
>>   This would result to 0. Perhaps proven by Francois, because he used this function and achieved a correct display of that idle value. Francois, am I correct, is "0" really displayed?
> 
> I must confess that I was not terribly professional this morning past 2AM.
> 
> The attached snippet illustrates the behavior wrt negative values
> (make; insmod foo.ko ; sleep 1; rmmod foo.ko; dmesg | tail -n 2).
> It also illustrates that I got the unit wrong.

;)tnx

> 
> This should be better:
> 
> diff --git a/net/ax25/ax25_timer.c b/net/ax25/ax25_timer.c
> index 85865ebfdfa2..3c94e5a2d098 100644
> --- a/net/ax25/ax25_timer.c
> +++ b/net/ax25/ax25_timer.c
> @@ -108,10 +108,9 @@ int ax25_t1timer_running(ax25_cb *ax25)
> 
> unsigned long ax25_display_timer(struct timer_list *timer)
> {
> -	if (!timer_pending(timer))
> -		return 0;
> +	long delta = timer->expires - jiffies;
> 
> -	return timer->expires - jiffies;
> +	return max(0L, delta);
> }
> 
> EXPORT_SYMBOL(ax25_display_timer);

I'd prefere to keep the !timer_pending(timer)) check.

Anyone else on the list has an opinion about this?

vy 73,
	- Thomas  dl9sau

> 
> <Makefile.txt><foo.c>


