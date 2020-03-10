Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5983918057E
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 18:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgCJRwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 13:52:42 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:50604 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbgCJRwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 13:52:41 -0400
Received: by mail-pj1-f68.google.com with SMTP id u10so742384pjy.0
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 10:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fs1saCg9VnPICibi4OXQDh8C2gAFp/mccxX9TkPhTXM=;
        b=sVysoqz1ftToVrYjmrkwMhJgawIkQ187vOeZsCcHzcr5jyC3k9RiFeUkHgGWHh79jq
         dhQ1Xm8QKW1D3fK0cMfdbNya7EdqoVWONqhJFHttr4Hywvj9DycQ4GrTJqO7lCMta5bN
         Sb2B5gAkBFClVuY1JzX/XgAZ6QBYG8uIlfoI/GSqAtQOuYdoqNB9kUSTX9IFy7QPXmBF
         Jf0prRNQ8eWajRGCe3dOVZPCUK48/LT3KBf7ZnGMI0zZF5qLby9NJ81TStCPfiRAOFQQ
         UQQyTjyTNphpqqGQ5Y2H8g0G7JVuM+9j4qcfSHmy+uyc0LiNvVilpesxG7883StVRzLD
         GXrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fs1saCg9VnPICibi4OXQDh8C2gAFp/mccxX9TkPhTXM=;
        b=DWg0pkFGcY4y7FyhRRyFjp0NgE0VImf1h0EXBXyDcpAfrB2P9F+oownToHYN9JIv5i
         Eo1+AKJ6W87mwpjNd4vjTzVti2b2FX9D7x3OKmFsElCHOLOaNe6M4WqcHGQaP1Yhza5+
         9fsvZE7lZ+WQ3X8uvVosUee2ctfwPcgSq8QubdQj3YoR3bvH2+HtsQH0TPmQP3PZhCxF
         EQhOX7SpUAULeO8GSdoJvSb/xZqnpexMCxIAOIv+F3JMaj7lEJQLSlUut6Xm2N8TCxIW
         Zl549nhOw9GEUiskTzodmc5zfHRs8px7HtaY6WXkIUglum1bEobxTN0uZGDJ9DJNRobq
         aImQ==
X-Gm-Message-State: ANhLgQ0ZN7FEmLpMQLXPwE5WL4j6IS0usfZSYAtTEOSH6MfVAeiPljXH
        p/mRry0qy/yi524aU3BcYbo=
X-Google-Smtp-Source: ADFU+vsQcvPqOJlIMKU/n9m0Nsm0GuBCqLo0MFKON5ppcPjOFSpCjJlUJYIz+WlbBVKRaMwPnecThw==
X-Received: by 2002:a17:90a:f317:: with SMTP id ca23mr2864989pjb.153.1583862760061;
        Tue, 10 Mar 2020 10:52:40 -0700 (PDT)
Received: from [100.108.80.166] ([2620:10d:c090:400::5:e428])
        by smtp.gmail.com with ESMTPSA id j15sm16106869pfn.86.2020.03.10.10.52.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Mar 2020 10:52:39 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Jesper Dangaard Brouer" <brouer@redhat.com>
Cc:     "Saeed Mahameed" <saeedm@mellanox.com>, davem@davemloft.net,
        kernel-team@fb.com, netdev@vger.kernel.org,
        ilias.apalodimas@linaro.org, "Li RongQing" <lirongqing@baidu.com>
Subject: Re: [PATCH] page_pool: use irqsave/irqrestore to protect ring access.
Date:   Tue, 10 Mar 2020 10:52:37 -0700
X-Mailer: MailMate (1.13.1r5671)
Message-ID: <67CA3793-636E-4F73-AC80-44D05A6BDB6F@gmail.com>
In-Reply-To: <20200310110412.66b60677@carbon>
References: <20200309194929.3889255-1-jonathan.lemon@gmail.com>
 <20200309.175534.1029399234531592179.davem@davemloft.net>
 <9b09170da05fb59bde7b003be282dfa63edd969e.camel@mellanox.com>
 <20200310110412.66b60677@carbon>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10 Mar 2020, at 3:04, Jesper Dangaard Brouer wrote:

> On Tue, 10 Mar 2020 02:30:34 +0000
> Saeed Mahameed <saeedm@mellanox.com> wrote:
>
>> On Mon, 2020-03-09 at 17:55 -0700, David Miller wrote:
>>> From: Jonathan Lemon <jonathan.lemon@gmail.com>
>>> Date: Mon, 9 Mar 2020 12:49:29 -0700
>>>
>>>> netpoll may be called from IRQ context, which may access the
>>>> page pool ring.  The current _bh variants do not provide sufficient
>>>> protection, so use irqsave/restore instead.
>>>>
>>>> Error observed on a modified mlx4 driver, but the code path exists
>>>> for any driver which calls page_pool_recycle from napi poll.
>
> Netpoll calls into drivers are problematic, nasty and annoying. =

> Drivers
> usually catch netpoll calls via seeing NAPI budget is zero, and handle
> the situation inside the driver e.g.[1][2]. (even napi_consume_skb
> catch it this way).
>
> [1] =

> https://github.com/torvalds/linux/blob/master/drivers/net/ethernet/inte=
l/ixgbe/ixgbe_main.c#L3179
> [2] =

> https://github.com/torvalds/linux/blob/master/drivers/net/ethernet/inte=
l/ixgbe/ixgbe_main.c#L1110

This still doesn't seem safe.

netpoll calls napi poll in IRQ context.
Consider the following path:

  ixgbe_poll()
   ixgbe_for_each_ring()
    ixgbe_clean_tx_irq()    /* before the L3179 check above */
     xdp_return_frame()
      page_pool_put_page( .. napi=3D0 )

Which bypasses the cache and tries to return the page to the ring.
Since in_serving_softirq() is false, it uses the _bh variant, which
blows up.



>>>> WARNING: CPU: 34 PID: 550248 at /ro/source/kernel/softirq.c:161
>>> __local_bh_enable_ip+0x35/0x50
>>>  ...
>>>> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
>>>
>>> The netpoll stuff always makes the locking more complicated than it
>>> needs to be.  I wonder if there is another way around this issue?
>>>
>>> Because IRQ save/restore is a high cost to pay in this critical =

>>> path.
>
> Yes, huge NACK from me, this would kill performance. We need to find
> another way.

Sure - checking in_irq() in the free path is another solution.


>> a printk inside irq context lead to this, so maybe it can be avoided =

>> ..
>>
>> or instead of checking in_serving_softirq()  change page_pool to
>> check in_interrupt() which is more powerful, to avoid ptr_ring =

>> locking
>> and the complication with netpoll altogether.
>>
>> I wonder why Jesper picked in_serving_softirq() in first place, was
>> there a specific reason ? or he just wanted it to be as less strict =

>> as
>> possible ?
>
> I wanted to make it specific that this is optimized for softirq.
>
> I actually think this is a regression we have introduced recently in
> combined patches:
>
>  304db6cb7610 ("page_pool: refill page when alloc.count of pool is =

> zero")
>  44768decb7c0 ("page_pool: handle page recycle for NUMA_NO_NODE =

> condition")
>
> I forgot that the in_serving_softirq() check was also protecting us
> when getting called from netpoll.  The general idea before was that if
> the in_serving_softirq() check failed, then we falled-through to
> slow-path calling normal alloc_pages_node (regular page allocator).

I don't think it ever did that - in all cases, the in_serving_softirq()
check guards access to the cache, otherwise it falls through to the =

ring.

Here, it seems we need  a tristate:
    in_irq:  fall through to system page allocator
    napi?    use cache
    else     ring


However, looking at those two patches again, while it doesn't address
this current issue, I do agree that they are regressions:

   1) Under stress, the system allocator may return pages with
       a different node id.

   2) Since the check is now removed from page_pool_reusable(), the
      foreign page is placed in the cache and persists there until
      it is moved to the ring.

   3) on refill from ring, if this page is found, processing stops,
      regardless of the other pages in the ring.

The above regression(s) are introduced by trying to avoid checking
the page node_id at free time.  Are there any metrics showing that
this is a performance issue?  Drivers which do page biasing still
have to perform this check in the driver (e.g.: mlx4, i40e) regardless.
-- =

Jonathan
