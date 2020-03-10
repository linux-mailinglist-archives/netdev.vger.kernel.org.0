Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC87618045A
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 18:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgCJRHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 13:07:10 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40851 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbgCJRHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 13:07:09 -0400
Received: by mail-pg1-f196.google.com with SMTP id t24so6587618pgj.7
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 10:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=O2PtOOhyKcp034y8vmBpjZePfOAR5cN4Kk1zoUdw3VA=;
        b=rwB/m8e0k3gTAWMg81kcv907LtI+x46qwGqyUVg0wNceDvIBDYPmMRJAda1mBJkPlf
         vjSK00y8Mgr85rgCB2EyImJ20Jo3xY6areiYtq2cVWNRzQayoGBmcn8UcsdOGDCq4sDR
         Fgt308INUHfEyy0VJA4EfxhnZExXhqus9nGTsHXtSCv1VlTLKK94EJOHQPBJi8BEfWM4
         aSaAT0ptrXjomES53WnWT9aiTQeQDo//kvbXSW4G9/caiW+qmF0PyfGH1KlJpzacSxBz
         rnkF3DMZa5OUGhs+KIdfi+dHH4Z7wN+1L83lYSxgilJrLKKM09SPE2NeMNdgwNgagL+B
         pPMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=O2PtOOhyKcp034y8vmBpjZePfOAR5cN4Kk1zoUdw3VA=;
        b=XaXhnfuNKfCrxlyr3UarOMou9yPcDCZgUWg4b8D0t8eVmp9EDvgEgQVtwXb1WNsycN
         2+PADCTgsbUmg/LSVEF0JrIxAQj9jSe51cIDSFJrkyPErvklPZkLpH+3dshFErYLRBY6
         T99Ycl+K1IYrrDRZVsUi1ZFev6SA16rB9Q6Gy4ZwDDDc6cYJlmEdL10RQqIY3vU13m8s
         tylE9NdyFGu3z/tHAD7KOedmSN49qfuhPU2mU/niOY+f22p28l10uqbRFty0M8JeIDtb
         JDkyLihWWDFvKEhDAfMUy00sQ5OB4KI81dee78UytORHvD9fiClpteZSejl0EOzHpOM8
         divA==
X-Gm-Message-State: ANhLgQ0Qu26QSIXj+Rp07U3xKrNRkD7Q41z2c5tZHIFKLUZaR2Zw+sbl
        bsMEfCYnXYLvLJ4JAAIHND8=
X-Google-Smtp-Source: ADFU+vsB4nUbDvct0Di6rNqmvxk3x7XBvuKkuz2FUG7BTKqM8glkvP2hknEvFsNh4jffv/I0ghAi8Q==
X-Received: by 2002:a63:3c59:: with SMTP id i25mr21156169pgn.387.1583860028368;
        Tue, 10 Mar 2020 10:07:08 -0700 (PDT)
Received: from [100.108.80.166] ([2620:10d:c090:400::5:e428])
        by smtp.gmail.com with ESMTPSA id d1sm23379408pfn.51.2020.03.10.10.07.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Mar 2020 10:07:07 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Saeed Mahameed" <saeedm@mellanox.com>
Cc:     davem@davemloft.net, kernel-team@fb.com, netdev@vger.kernel.org,
        ilias.apalodimas@linaro.org, brouer@redhat.com
Subject: Re: [PATCH] page_pool: use irqsave/irqrestore to protect ring access.
Date:   Tue, 10 Mar 2020 10:07:06 -0700
X-Mailer: MailMate (1.13.1r5671)
Message-ID: <D6B9A0EF-61FA-40A9-AED3-4B4927FD9115@gmail.com>
In-Reply-To: <9b09170da05fb59bde7b003be282dfa63edd969e.camel@mellanox.com>
References: <20200309194929.3889255-1-jonathan.lemon@gmail.com>
 <20200309.175534.1029399234531592179.davem@davemloft.net>
 <9b09170da05fb59bde7b003be282dfa63edd969e.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9 Mar 2020, at 19:30, Saeed Mahameed wrote:

> On Mon, 2020-03-09 at 17:55 -0700, David Miller wrote:
>> From: Jonathan Lemon <jonathan.lemon@gmail.com>
>> Date: Mon, 9 Mar 2020 12:49:29 -0700
>>
>>> netpoll may be called from IRQ context, which may access the
>>> page pool ring.  The current _bh variants do not provide sufficient
>>> protection, so use irqsave/restore instead.
>>>
>>> Error observed on a modified mlx4 driver, but the code path exists
>>> for any driver which calls page_pool_recycle from napi poll.
>>>
>>> WARNING: CPU: 34 PID: 550248 at /ro/source/kernel/softirq.c:161
>> __local_bh_enable_ip+0x35/0x50
>>  ...
>>> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
>>
>> The netpoll stuff always makes the locking more complicated than it
>> needs
>> to be.  I wonder if there is another way around this issue?
>>
>> Because IRQ save/restore is a high cost to pay in this critical path.
>
> a printk inside irq context lead to this, so maybe it can be avoided ..

This was caused by a printk in hpet_rtc_timer_reinit() complaining about
RTC interrupts being lost.  I'm not sure it's practical trying to locate
all the printk cases like this.


> or instead of checking in_serving_softirq()  change page_pool to
> check in_interrupt() which is more powerful, to avoid ptr_ring locking
> and the complication with netpoll altogether.

That's another approach:

    ret = 1;
    if (!in_irq()) {
        if (in_serving_softirq())
            ret = ptr_ring_produce(....
        else
            ret = ptr_ring_produce_bh(....
    }

which would return failure and release the page from the page pool.
This doesn't address the allocation or the bulk release path.


>
> I wonder why Jesper picked in_serving_softirq() in first place, was
> there a specific reason ? or he just wanted it to be as less strict as
> possible ?

From the code, it looks like he was optimizing to avoid the _bh variant
if possible.
-- 
Jonathan
