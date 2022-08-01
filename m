Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31A275866C8
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 11:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbiHAJTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 05:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbiHAJTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 05:19:15 -0400
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [IPv6:2a01:e0c:1:1599::12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A45E11A04E;
        Mon,  1 Aug 2022 02:19:13 -0700 (PDT)
Received: from [44.168.19.21] (unknown [86.242.59.24])
        (Authenticated sender: f6bvp@free.fr)
        by smtp3-g21.free.fr (Postfix) with ESMTPSA id DD5A613F86F;
        Mon,  1 Aug 2022 11:19:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=free.fr;
        s=smtp-20201208; t=1659345552;
        bh=PnVG/7HzZeLRSJDu/J2dCfsf3pDau6mzdymr73G8beQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=nGO4qmtXenRamQwcAhKmb5OBJNgGz8OthuCgtsf8CXO8Wk5kTzUir6h1UQKNiwoM6
         bTFOFbGmCydq/GUzZ2mVvtp716vg2V06kMJACa0fsrC7iDqUrbrHzmnNOpHShi+Pbj
         1lR9Uo/9bPAWJnw+Pn2WkVIjPU5I8zYfaAA0q4j1EPKMN/7VHiHqVlf6mwcYu5F9lE
         7APBX5lUDEi/bwaUDf96QaM/Y5qdmwAEck3x3n4occvyohH47WmWo04DTJrd7l+CsU
         EZT5NlriF+siaZZ9KOuUgtgBCXXu9ncMF9CixcS6Q9fT5+bYJ56Pq3vIi5Ma4sE6Tk
         kptE2zfqRByyQ==
Message-ID: <3cf6f319-4153-fd20-fef0-f445cbf66c3e@free.fr>
Date:   Mon, 1 Aug 2022 11:19:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: rose timer t error displayed in /proc/net/rose
Content-Language: en-US
To:     Thomas Osterried <thomas@osterried.de>,
        Francois Romieu <romieu@fr.zoreil.com>
Cc:     Eric Dumazet <edumazet@google.com>, linux-hams@vger.kernel.org,
        Thomas Osterried DL9SAU <thomas@x-berg.in-berlin.de>,
        netdev@vger.kernel.org
References: <d5e93cc7-a91f-13d3-49a1-b50c11f0f811@free.fr>
 <YucgpeXpqwZuievg@electric-eye.fr.zoreil.com>
 <A9A8A0B7-5009-4FB0-9317-5033DE17E701@osterried.de>
From:   Bernard f6bvp <f6bvp@free.fr>
Organization: Dimension Parabole
In-Reply-To: <A9A8A0B7-5009-4FB0-9317-5033DE17E701@osterried.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The reason I am looking at /proc/net/rose is for I want to check if a 
rose connect request is pending.

I am investigating a bug in rose socket connect that was ok until kernel 
5.4.79 and occured with kernel 5.4.83.

All ROSE network client applications I am playing with (fpad, fpacwpd, 
wplist, wpedit...) need connect rose socket and are failing since that 
kernel bug.

The connect request triggers rose->timer from 200 until it counts down 
to 0 and fails due to timeout.

This let me think that there is a bug somewhere in library that handles 
rose socket ?

I have been told to perform a kernel git bisect from 5.4.79 (good) to 
5.4.83 (bad) but I am facing difficulties rebooting after kernel is 
compiled on my Ubuntu machine.

The reason is that with Ubuntu boot is very complex to me.

I can see that new vmlinuz is present in /boot but boot process is 
rather using /boot/efi/EFI/ that I don't know how to manage...

  rw-r--r--  1 root root   173964 Jul 29 19:04 config-5.18.11-F6BVP-4
-rw-r--r--  1 root root   176329 Aug  1 10:44 
config-5.19.0-rc8-next-20220728-F6BVP-next-patchs+
drwx------  3 root root     4096 Jan  1  1970 efi/
drwxr-xr-x  5 root root     4096 Aug  1 10:44 grub/
lrwxrwxrwx  1 root root       54 Jul 30 10:46 initrd.img -> 
initrd.img-5.19.0-rc8-next-20220728-F6BVP-next-patchs+
-rw-r--r--  1 root root 62359030 Jul 26 17:38 initrd.img-5.15.0-41-generic
-rw-r--r--  1 root root 17810668 Jul 29 19:04 initrd.img-5.18.11-F6BVP-4
-rw-r--r--  1 root root 18144144 Aug  1 10:44 
initrd.img-5.19.0-rc8-next-20220728-F6BVP-next-patchs+
-rw-r--r--  1 root root   182800 Feb  6 21:35 memtest86+.bin
-rw-r--r--  1 root root   184476 Feb  6 21:35 memtest86+.elf
-rw-r--r--  1 root root   184980 Feb  6 21:35 memtest86+_multiboot.bin
lrwxrwxrwx  1 root root       51 Aug  1 10:44 vmlinuz -> 
vmlinuz-5.19.0-rc8-next-20220728-F6BVP-next-patchs+
-rw-------  1 root root 11086240 Jun 22 15:24 vmlinuz-5.15.0-41-generic
-rw-r--r--  1 root root  9686976 Jul 29 19:04 vmlinuz-5.18.11-F6BVP-4
-rw-r--r--  1 root root 10211648 Aug  1 10:44 
vmlinuz-5.19.0-rc8-next-20220728-F6BVP-next-patchs+
-rw-r--r--  1 root root 10211648 Jul 30 10:46 
vmlinuz-5.19.0-rc8-next-20220728-F6BVP-next-patchs+.old
lrwxrwxrwx  1 root root       55 Aug  1 10:44 vmlinuz.old -> 
vmlinuz-5.19.0-rc8-next-20220728-F6BVP-next-patchs+.old

Le 01/08/2022 à 10:06, Thomas Osterried a écrit :
> Hello,
>
> 1. why do you check for pending timer anymore?
> 2. I'm not really sure what value jiffies_delta_to_clock_t() returns. jiffies / HZ?
>     jiffies_delta_to_clock_t() returns clock_t.
>
> ax25_display_timer() is used in ax25, netrom and rose, mostly for displaying states in /proc.
>
> In ax25_subr.c, ax25_calculate_rtt() it is used for rtt calculation. Is it proven that the the values that ax25_display_timer returns are still as expected?
> I ask, because we see there a substraction ax25_display_timer(&ax25->t1timer) from ax25->t1, and we need to be sure, that your change will not break he ax.25 stack.
>
> # grep ax25_display_timer ../*/*c|cut -d/ -f2-
> ax25/af_ax25.c:         ax25_info.t1timer   = ax25_display_timer(&ax25->t1timer)   / HZ;
> ax25/af_ax25.c:         ax25_info.t2timer   = ax25_display_timer(&ax25->t2timer)   / HZ;
> ax25/af_ax25.c:         ax25_info.t3timer   = ax25_display_timer(&ax25->t3timer)   / HZ;
> ax25/af_ax25.c:         ax25_info.idletimer = ax25_display_timer(&ax25->idletimer) / (60 * HZ);
> ax25/af_ax25.c:            ax25_display_timer(&ax25->t1timer) / HZ, ax25->t1 / HZ,
> ax25/af_ax25.c:            ax25_display_timer(&ax25->t2timer) / HZ, ax25->t2 / HZ,
> ax25/af_ax25.c:            ax25_display_timer(&ax25->t3timer) / HZ, ax25->t3 / HZ,
> ax25/af_ax25.c:            ax25_display_timer(&ax25->idletimer) / (60 * HZ),
> ax25/ax25.mod.c:SYMBOL_CRC(ax25_display_timer, 0x14cecd59, "");
> ax25/ax25_subr.c:               ax25->rtt = (9 * ax25->rtt + ax25->t1 - ax25_display_timer(&ax25->t1timer)) / 10;
> ax25/ax25_timer.c:unsigned long ax25_display_timer(struct timer_list *timer)
> ax25/ax25_timer.c:EXPORT_SYMBOL(ax25_display_timer);
> netrom/af_netrom.c:                     ax25_display_timer(&nr->t1timer) / HZ,
> netrom/af_netrom.c:                     ax25_display_timer(&nr->t2timer) / HZ,
> netrom/af_netrom.c:                     ax25_display_timer(&nr->t4timer) / HZ,
> netrom/af_netrom.c:                     ax25_display_timer(&nr->idletimer) / (60 * HZ),
> netrom/netrom.mod.c:    { 0x14cecd59, "ax25_display_timer" },
> rose/af_rose.c:                 ax25_display_timer(&rose->timer) / HZ,
> rose/af_rose.c:                 ax25_display_timer(&rose->idletimer) / (60 * HZ),
> rose/rose.mod.c:        { 0x14cecd59, "ax25_display_timer" },
> rose/rose_route.c:                         ax25_display_timer(&rose_neigh->t0timer) / HZ,
> rose/rose_route.c:                         ax25_display_timer(&rose_neigh->ftimer)  / HZ);
>
>
> 3. Back to the initial problem:
>
>>> When decreasing from 1 to 0 it displays a very large number until next clock
>>> tic as demonstrated below.
> I assume it's the information when timer for rose expired.
> If it has been expired 1s ago, the computed time diff diff becomes negative ->  -(jiffies).
> We are unsigned long (and imho need to b), but the "underflow" result is something like (2**64)-1-jiffies -- a very large positive number that represents a small negative number.
>
> => If my assumptions for rose behavior are correct:
> 1. I expect rose->timer to be restarted soon. If it does not happen, is there a bug?
> 2. The time window with that large value is large.
> 3. Are negative numbers (-> timer expired) are of interest? Else, 0 should be enough to indicate that the timer has expired.
>     linux/jiffies.h:
>       extern clock_t jiffies_to_clock_t(unsigned long x);
>      static inline clock_t jiffies_delta_to_clock_t(long delta)
>      {
>              return jiffies_to_clock_t(max(0L, delta));
>      }
>
>     => Negative may be handled due to Francois' patch now correctly. delta as signed long may be negative. max(0L, -nnnn) sould result to 0L.
>     This would result to 0. Perhaps proven by Francois, because he used this function and achieved a correct display of that idle value. Francois, am I correct, is "0" really displayed?
>
>
>
