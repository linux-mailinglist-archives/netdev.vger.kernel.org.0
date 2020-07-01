Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 869CA2100F6
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 02:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbgGAA1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 20:27:23 -0400
Received: from mail.efficios.com ([167.114.26.124]:34080 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgGAA1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 20:27:22 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 54A062C8C82;
        Tue, 30 Jun 2020 20:27:21 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id AkEKSxZNKh0R; Tue, 30 Jun 2020 20:27:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 18C8C2C8B71;
        Tue, 30 Jun 2020 20:27:21 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 18C8C2C8B71
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1593563241;
        bh=IMTI0wkiG/j0ZpPO48LK9BFXx5TNcoplPyJQl/R+kD0=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=gCzKKXD5UXtlY4u4P0q0QkPqRg/mh5+uW/x3GraDgv/UaKUr/4PnwOZkcQ+r88VRw
         Ca62yfj3VV260Lneruf2EBsaUazAMhiW9qH3YDVL/bRKp/jFoC7HrwZsw/S8VcjPK6
         wJ+0ALQojD/5YQYNEnxq1+SqY8unT18t8k0T2lckM9bAvJdGyV/7eq1oSqUxQ9Xoy3
         hbyJLGmFL+TJMG+ZNQaHZnYwi+qK3T851JqMApxfZSIl8AqHT9BTu7lqFbcHQfTsbZ
         ANqgknXon7VfdRzDFzjdDm/06cwjclMAcnYRFrcZKMMC6e1iAiF3Wik8HFCBbNeSuu
         dFITlIOnKllGQ==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id luGrLc-KdN3k; Tue, 30 Jun 2020 20:27:21 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 089D42C8B70;
        Tue, 30 Jun 2020 20:27:21 -0400 (EDT)
Date:   Tue, 30 Jun 2020 20:27:20 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <731827688.18225.1593563240917.JavaMail.zimbra@efficios.com>
In-Reply-To: <CANn89iKHBkTbT9fZ3qbfZKE25MuS=av+frnRerGvP+_gUHPSAA@mail.gmail.com>
References: <20200630234101.3259179-1-edumazet@google.com> <1359584061.18162.1593560822147.JavaMail.zimbra@efficios.com> <CANn89iKHBkTbT9fZ3qbfZKE25MuS=av+frnRerGvP+_gUHPSAA@mail.gmail.com>
Subject: Re: [PATCH net] tcp: md5: add missing memory barriers in
 tcp_md5_do_add()/tcp_md5_hash_key()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3945 (ZimbraWebClient - FF77 (Linux)/8.8.15_GA_3928)
Thread-Topic: md5: add missing memory barriers in tcp_md5_do_add()/tcp_md5_hash_key()
Thread-Index: uHn2Lnt5MD8CCOnOgyHOzq0aJVWrCg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Jun 30, 2020, at 7:50 PM, Eric Dumazet edumazet@google.com wrote:

> On Tue, Jun 30, 2020 at 4:47 PM Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
>>
>> ----- On Jun 30, 2020, at 7:41 PM, Eric Dumazet edumazet@google.com wrote:
>>
>> > MD5 keys are read with RCU protection, and tcp_md5_do_add()
>> > might update in-place a prior key.
>> >
>> > Normally, typical RCU updates would allocate a new piece
>> > of memory. In this case only key->key and key->keylen might
>> > be updated, and we do not care if an incoming packet could
>> > see the old key, the new one, or some intermediate value,
>> > since changing the key on a live flow is known to be problematic
>> > anyway.
>>
>> What makes it acceptable to observe an intermediate bogus key during the
>> transition ?
> 
> If you change a key while packets are in flight, the result is that :
> 
> 1) Either your packet has the correct key and is handled
> 
> 2) Or the key do not match, packet is dropped.
> 
> Sender will retransmit eventually.

This train of thoughts seem to apply to incoming traffic, what about outgoing ?

> 
> If this was not the case, then we could not revert the patch you are
> complaining about :)

Please let me know where I'm incorrect with the following scenario:

- Local peer is a Linux host, which supports only a single MD5 key
  per socket at any given time.
- Remote peer is a Ericsson/Redback device allowing 2 passwords (old/new)
  to co-exist until both sides are OK with the new password.

The local peer updates the MD5 password for a socket in parallel with
packets flow. If we guarantee that no intermediate bogus key state is
observable, the flow going out of the Linux peer should always be seen as
valid, with either the old or the new key.

Allowing an intermediate bogus key to be observable means this introduces
a race condition during which the remote peer can observe a corrupted key.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
