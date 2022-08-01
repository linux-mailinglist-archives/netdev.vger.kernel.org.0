Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8BA586613
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 10:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiHAIOF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 1 Aug 2022 04:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbiHAIOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 04:14:04 -0400
X-Greylist: delayed 433 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 01 Aug 2022 01:14:03 PDT
Received: from einhorn-mail-out.in-berlin.de (einhorn.in-berlin.de [192.109.42.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C712B271
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 01:14:03 -0700 (PDT)
X-Envelope-From: thomas@osterried.de
Received: from x-berg.in-berlin.de (x-change.in-berlin.de [217.197.86.40])
        by einhorn.in-berlin.de  with ESMTPS id 27186gHH3963284
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Mon, 1 Aug 2022 10:06:42 +0200
Received: from x-berg.in-berlin.de ([217.197.86.42] helo=smtpclient.apple)
        by x-berg.in-berlin.de with esmtpa (Exim 4.94.2)
        (envelope-from <thomas@osterried.de>)
        id 1oIQRl-0004jA-QK; Mon, 01 Aug 2022 10:06:41 +0200
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: rose timer t error displayed in /proc/net/rose
From:   Thomas Osterried <thomas@osterried.de>
In-Reply-To: <YucgpeXpqwZuievg@electric-eye.fr.zoreil.com>
Date:   Mon, 1 Aug 2022 10:06:40 +0200
Cc:     Bernard f6bvp <f6bvp@free.fr>, Eric Dumazet <edumazet@google.com>,
        linux-hams@vger.kernel.org,
        Thomas Osterried DL9SAU <thomas@x-berg.in-berlin.de>,
        netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <A9A8A0B7-5009-4FB0-9317-5033DE17E701@osterried.de>
References: <d5e93cc7-a91f-13d3-49a1-b50c11f0f811@free.fr>
 <YucgpeXpqwZuievg@electric-eye.fr.zoreil.com>
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

Hello,

> Am 01.08.2022 um 02:39 schrieb Francois Romieu <romieu@fr.zoreil.com>:
> 
> Bernard f6bvp <f6bvp@free.fr> :
>> Rose proc timer t error
>> 
>> Timer t is decremented one by one during normal operations.
>> 
>> When decreasing from 1 to 0 it displays a very large number until next clock
>> tic as demonstrated below.
>> 
>> t1, t2 and t3 are correctly handled.
> 
> "t" is ax25_display_timer(&rose->timer) / HZ whereas "tX" are rose->tX / HZ.
> 
> ax25_display_timer() does not like jiffies > timer->expires (and it should
> probably return plain seconds btw).
> 
> You may try the hack below.
> 
> diff --git a/net/ax25/ax25_timer.c b/net/ax25/ax25_timer.c
> index 85865ebfdfa2..b77433fff0c9 100644
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
> +	return jiffies_delta_to_clock_t(delta) * HZ;
> }
> 
> EXPORT_SYMBOL(ax25_display_timer);


1. why do you check for pending timer anymore?

2. I'm not really sure what value jiffies_delta_to_clock_t() returns. jiffies / HZ?
   jiffies_delta_to_clock_t() returns clock_t.

ax25_display_timer() is used in ax25, netrom and rose, mostly for displaying states in /proc.

In ax25_subr.c, ax25_calculate_rtt() it is used for rtt calculation. Is it proven that the the values that ax25_display_timer returns are still as expected?
I ask, because we see there a substraction ax25_display_timer(&ax25->t1timer) from ax25->t1, and we need to be sure, that your change will not break he ax.25 stack.

# grep ax25_display_timer ../*/*c|cut -d/ -f2-
ax25/af_ax25.c:         ax25_info.t1timer   = ax25_display_timer(&ax25->t1timer)   / HZ;
ax25/af_ax25.c:         ax25_info.t2timer   = ax25_display_timer(&ax25->t2timer)   / HZ;
ax25/af_ax25.c:         ax25_info.t3timer   = ax25_display_timer(&ax25->t3timer)   / HZ;
ax25/af_ax25.c:         ax25_info.idletimer = ax25_display_timer(&ax25->idletimer) / (60 * HZ);
ax25/af_ax25.c:            ax25_display_timer(&ax25->t1timer) / HZ, ax25->t1 / HZ,
ax25/af_ax25.c:            ax25_display_timer(&ax25->t2timer) / HZ, ax25->t2 / HZ,
ax25/af_ax25.c:            ax25_display_timer(&ax25->t3timer) / HZ, ax25->t3 / HZ,
ax25/af_ax25.c:            ax25_display_timer(&ax25->idletimer) / (60 * HZ),
ax25/ax25.mod.c:SYMBOL_CRC(ax25_display_timer, 0x14cecd59, "");
ax25/ax25_subr.c:               ax25->rtt = (9 * ax25->rtt + ax25->t1 - ax25_display_timer(&ax25->t1timer)) / 10;
ax25/ax25_timer.c:unsigned long ax25_display_timer(struct timer_list *timer)
ax25/ax25_timer.c:EXPORT_SYMBOL(ax25_display_timer);
netrom/af_netrom.c:                     ax25_display_timer(&nr->t1timer) / HZ,
netrom/af_netrom.c:                     ax25_display_timer(&nr->t2timer) / HZ,
netrom/af_netrom.c:                     ax25_display_timer(&nr->t4timer) / HZ,
netrom/af_netrom.c:                     ax25_display_timer(&nr->idletimer) / (60 * HZ),
netrom/netrom.mod.c:    { 0x14cecd59, "ax25_display_timer" },
rose/af_rose.c:                 ax25_display_timer(&rose->timer) / HZ,
rose/af_rose.c:                 ax25_display_timer(&rose->idletimer) / (60 * HZ),
rose/rose.mod.c:        { 0x14cecd59, "ax25_display_timer" },
rose/rose_route.c:                         ax25_display_timer(&rose_neigh->t0timer) / HZ,
rose/rose_route.c:                         ax25_display_timer(&rose_neigh->ftimer)  / HZ);


3. Back to the initial problem:

>> When decreasing from 1 to 0 it displays a very large number until next clock
>> tic as demonstrated below.

I assume it's the information when timer for rose expired.
If it has been expired 1s ago, the computed time diff diff becomes negative ->  -(jiffies).
We are unsigned long (and imho need to b), but the "underflow" result is something like (2**64)-1-jiffies -- a very large positive number that represents a small negative number.

=> If my assumptions for rose behavior are correct:
1. I expect rose->timer to be restarted soon. If it does not happen, is there a bug?
2. The time window with that large value is large.
3. Are negative numbers (-> timer expired) are of interest? Else, 0 should be enough to indicate that the timer has expired.
   linux/jiffies.h:
     extern clock_t jiffies_to_clock_t(unsigned long x);
    static inline clock_t jiffies_delta_to_clock_t(long delta)
    {
            return jiffies_to_clock_t(max(0L, delta));
    }

   => Negative may be handled due to Francois' patch now correctly. delta as signed long may be negative. max(0L, -nnnn) sould result to 0L.
   This would result to 0. Perhaps proven by Francois, because he used this function and achieved a correct display of that idle value. Francois, am I correct, is "0" really displayed?




