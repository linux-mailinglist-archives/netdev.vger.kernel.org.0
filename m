Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29DF92608EF
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 05:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728372AbgIHDPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 23:15:11 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:39209 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726586AbgIHDPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 23:15:09 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0U8GxKGr_1599534906;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0U8GxKGr_1599534906)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 08 Sep 2020 11:15:06 +0800
Date:   Tue, 8 Sep 2020 11:15:06 +0800
From:   "dust.li" <dust.li@linux.alibaba.com>
To:     Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] net/sock: don't drop udp packets if udp_mem[2] not
 reached
Message-ID: <20200908031506.GC56680@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20200907144435.43165-1-dust.li@linux.alibaba.com>
 <428dae2552915c42b9144d7489fd912493433c1e.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <428dae2552915c42b9144d7489fd912493433c1e.camel@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 07, 2020 at 07:18:48PM +0200, Paolo Abeni wrote:
>Hi,
>
>On Mon, 2020-09-07 at 22:44 +0800, Dust Li wrote:
>> We encoutered udp packets drop under a pretty low pressure
>> with net.ipv4.udp_mem[0] set to a small value (4096).
>> 
>> After some tracing and debugging, we found that for udp
>> protocol, __sk_mem_raise_allocated() will possiblly drop
>> packets if:
>>   udp_mem[0] < udp_prot.memory_allocated < udp_mem[2]
>> 
>> That's because __sk_mem_raise_allocated() didn't handle
>> the above condition for protocols like udp who doesn't
>> have sk_has_memory_pressure()
>> 
>> We can reproduce this with the following condition
>> 1. udp_mem[0] is relateive small,
>> 2. net.core.rmem_default/max > udp_mem[0] * 4K
>
>This looks like something that could/should be addressed at
>configuration level ?!?
Thanks a lot for the review !

Sorry, maybe I haven't make it clear enough

The real problem is the scability with the sockets number.
Since the udp_mem is for all UDP sockets, with the number of udp
sockets grows, soon or later, udp_prot.memory_allocated will
exceed udp_mem[0], and __sk_mem_raise_allocated() will cause
the packets drop here. But the total udp memory allocated
may still far under udp_mem[1] or udp_mem[2]

>
>udp_mem[0] should accomodate confortably at least a socket.

Yeah, I agree udp_mem[0] should be large enough for at least a
socket.

Here I use 4096 just for simple and reproduce what we met before.

I changed my test program a bit:
 - with 16 server sockets
 - with 1 client sending 3000 messages(size: 4096bytes) to each
   of those 8 server sockets
 - set net.core.rmem_default/max to (2*4096*4096)
 - and keep udp_mem unset, which by default on my 4GB VM is
   'net.ipv4.udp_mem = 91944        122592  183888'

https://github.com/dust-li/kernel-test/blob/master/exceed_udp_mem_min_drop/multi_sockets_test.sh


Actually, with more udp sockets, I can always make it large
enough to exceed udp_mem[0], and drop packets before udp_mem[1]
and udp_mem[2].

>
>Cheers,
>
>Paolo
