Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20A26586DFF
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 17:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbiHAPow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 11:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232546AbiHAPot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 11:44:49 -0400
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CCF23D5B5;
        Mon,  1 Aug 2022 08:44:47 -0700 (PDT)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 271FiXAN2353929;
        Mon, 1 Aug 2022 17:44:33 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 271FiXAN2353929
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1659368673;
        bh=PRWX368Kf6DywUXyxukmEOsbYM3ev6XbpRNXp2kBMMQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eTpumtsTRugOQ8J82wX9jhNiKFQdBdg4ZMiT3qA9HhutgeohL2m3RWwzHx6G8GUsk
         We294K08SFJSpfoBwqkPIxD8OGv2Q4sZyH0vUUwuCmGxB1pwNHLPPv8m/quRpnWUyo
         MOWvnwm8brUjuO0V1A713OwX4SPV91izJu/WnupY=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 271FiXLN2353928;
        Mon, 1 Aug 2022 17:44:33 +0200
Date:   Mon, 1 Aug 2022 17:44:33 +0200
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     Thomas Osterried <thomas@osterried.de>
Cc:     Bernard f6bvp <f6bvp@free.fr>, Eric Dumazet <edumazet@google.com>,
        linux-hams@vger.kernel.org,
        Thomas Osterried DL9SAU <thomas@x-berg.in-berlin.de>,
        netdev@vger.kernel.org
Subject: Re: rose timer t error displayed in /proc/net/rose
Message-ID: <Yuf04XIsXrQMJuUy@electric-eye.fr.zoreil.com>
References: <d5e93cc7-a91f-13d3-49a1-b50c11f0f811@free.fr>
 <YucgpeXpqwZuievg@electric-eye.fr.zoreil.com>
 <A9A8A0B7-5009-4FB0-9317-5033DE17E701@osterried.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xDaaSbkW7JCFv+Sj"
Content-Disposition: inline
In-Reply-To: <A9A8A0B7-5009-4FB0-9317-5033DE17E701@osterried.de>
X-Organisation: Land of Sunshine Inc.
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--xDaaSbkW7JCFv+Sj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Thomas Osterried <thomas@osterried.de> :
[...]
> 1. why do you check for pending timer anymore?

s/do/don't/ ?

I don't check for pending timer because:
- the check is racy
- jiffies_delta_to_clock_t maxes negative delta to zero

> 2. I'm not really sure what value jiffies_delta_to_clock_t() returns. jiffies / HZ?
>    jiffies_delta_to_clock_t() returns clock_t.

I completely messed this part :o/

clock_t relates to USER_HZ like jiffies does to HZ.

[don't break the ax25]

Sure, we are in violent agreement here.

[...]
> 1. I expect rose->timer to be restarted soon. If it does not happen, is there a bug?

The relevant rose state in Bernard's sample was ROSE_STATE_2.

net/rose/rose_timer.c::rose_timer_expiry would had called
rose_disconnect(sk, ETIMEDOUT, -1, -1) so there should not
be any timer restart (afaiu, etc.).

[...]
>    => Negative may be handled due to Francois' patch now correctly.
> delta as signed long may be negative. max(0L, -nnnn) sould result to 0L.
>    This would result to 0. Perhaps proven by Francois, because he used this function and achieved a correct display of that idle value. Francois, am I correct, is "0" really displayed?

I must confess that I was not terribly professional this morning past 2AM.

The attached snippet illustrates the behavior wrt negative values
(make; insmod foo.ko ; sleep 1; rmmod foo.ko; dmesg | tail -n 2).
It also illustrates that I got the unit wrong.

This should be better:

diff --git a/net/ax25/ax25_timer.c b/net/ax25/ax25_timer.c
index 85865ebfdfa2..3c94e5a2d098 100644
--- a/net/ax25/ax25_timer.c
+++ b/net/ax25/ax25_timer.c
@@ -108,10 +108,9 @@ int ax25_t1timer_running(ax25_cb *ax25)
 
 unsigned long ax25_display_timer(struct timer_list *timer)
 {
-	if (!timer_pending(timer))
-		return 0;
+	long delta = timer->expires - jiffies;
 
-	return timer->expires - jiffies;
+	return max(0L, delta);
 }
 
 EXPORT_SYMBOL(ax25_display_timer);


--xDaaSbkW7JCFv+Sj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=Makefile

obj-m := foo.o

KDIR := /lib/modules/$(shell uname -r)/build
PWD  := $(shell pwd)

default:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

--xDaaSbkW7JCFv+Sj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="foo.c"

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>

#include <linux/jiffies.h>

static unsigned long expires;

static void bar(void)
{
	long delta = expires - jiffies;

	printk(KERN_INFO "%lu %lu %lx\n", jiffies_delta_to_clock_t(delta),
	       jiffies_delta_to_clock_t(jiffies), delta);
}

static int __init foo_start(void)
{
	expires = jiffies;

	bar();

	return 0;
}

static void __exit foo_end(void)
{
	bar();
}

module_init(foo_start);
module_exit(foo_end);

MODULE_LICENSE("GPL");

--xDaaSbkW7JCFv+Sj--
