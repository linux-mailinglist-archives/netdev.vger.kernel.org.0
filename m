Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 763CB2625DA
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 05:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgIIDYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 23:24:36 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:39584 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725997AbgIIDYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 23:24:35 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0U8N.XOp_1599621873;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0U8N.XOp_1599621873)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 09 Sep 2020 11:24:33 +0800
Date:   Wed, 9 Sep 2020 11:24:33 +0800
From:   "dust.li" <dust.li@linux.alibaba.com>
To:     Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] net/sock: don't drop udp packets if udp_mem[2] not
 reached
Message-ID: <20200909032433.GA5512@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20200907144435.43165-1-dust.li@linux.alibaba.com>
 <428dae2552915c42b9144d7489fd912493433c1e.camel@redhat.com>
 <20200908031506.GC56680@linux.alibaba.com>
 <f13eaa33c4f73bce9bdcf08b072aeaf23b0551d5.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f13eaa33c4f73bce9bdcf08b072aeaf23b0551d5.camel@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 08, 2020 at 10:46:13AM +0200, Paolo Abeni wrote:
>Hi,
>
>On Tue, 2020-09-08 at 11:15 +0800, dust.li wrote:
>> Actually, with more udp sockets, I can always make it large
>> enough to exceed udp_mem[0], and drop packets before udp_mem[1]
>> and udp_mem[2].
>
>Sure, but with enough sockets you can also exceeeds any limits ;).
>
>> diff --git a/net/core/sock.c b/net/core/sock.c
>> index 6c5c6b18eff4..fed8211d8dbe 100644
>> --- a/net/core/sock.c
>> +++ b/net/core/sock.c
>> @@ -2648,6 +2648,12 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
>>                                  atomic_read(&sk->sk_rmem_alloc) +
>>                                  sk->sk_forward_alloc))
>>                         return 1;
>> +       } else {
>> +               /* for prots without memory_pressure callbacks, we should not
>> +                * drop until hard limit reached
>> +                */
>> +               if (allocated <= sk_prot_mem_limits(sk, 2))
>> +                       return 1;
>
>At this point, the above condition is always true, due to an earlier
>check. Additionally, accepting any value below udp_mem[2] would make
>the previous checks to allow a minimum per socket memory useless.

Thanks for your reply !

Yeah, this is wrong :O

>
>You can obtain the same result setting udp_mem[0] = udp_mem[2], without
>any kernel change.
>
>But with this change applied you can't guarantee anymore a minimum per
>socket amount of memory.

Yeah, understood.


>
>I think you are possibly mislead by your own comment: the point is that
>we should never allow allocation above the hard limit, but the protocol
>is allowed to drop as soon as the memory allocated raises above the
>lower limit.

Agree.


>
>Note that the current behavior is correctly documented
>in Documentation/networking/ip-sysctl.rst.
>
>Your problem must be solved in another way e.g. raising udp_mem[0] -
>and keeping udp_mem[2] above that value.

I think it's somehow not quite fit what Documentation/networking/ip-sysctl.rst
says:

    min: Below this number of pages UDP is not bothered about its
    memory appetite. When amount of memory allocated by UDP exceeds
    this number, UDP starts to moderate memory usage.

It says UDP starts to moderate memory usage when exceeds min, but here
it is actually dropping all the packets unless the socket is under minimum
, which means udp_mem[0] is almost equal to the hard limit, and
udp_mem[1]/udp_mem[2] is useless.


Do you think it's usefull if we move the per socket memory check to the
common path for both with and without memory_pressure protocols ? So
only those sockets who comsume most of the memory will got dropped before
hard limit. Something like this:

  if (sk_has_memory_pressure(sk)) {

          if (!sk_under_memory_pressure(sk))
                  return 1;
  }
  alloc = sk_sockets_allocated_read_positive(sk);
  if (sk_prot_mem_limits(sk, 2) > alloc *
      sk_mem_pages(sk->sk_wmem_queued +
                   atomic_read(&sk->sk_rmem_alloc) +
                   sk->sk_forward_alloc))
          return 1;


Sorry for bothering again :)

>
>Cheers,
>
>Paolo
