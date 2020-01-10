Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72682137A02
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 00:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbgAJXQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 18:16:19 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48949 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727324AbgAJXQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 18:16:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578698177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BDYSZvcxplbrm/hl6PFrbxqi7+nmX07S7UZy05z2BNU=;
        b=T2TXs9nr+GZpRcMZfkCbS7Q92WYZlLZuQg6pCD4H6N2Nsn3pidDd15tdu9eWZ8njYTsAyU
        wnUROWeGQQfx8iQ/jgs3iYJIVYtEUaSgLs49ocJgzLIvYChW1NClQJTXtuyXGC2S7u+5A0
        iRBKoDsc/NmMtZJTXtGK87aUzPcGx9g=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-GsAh8KxvMV2jS2GQ4UT6hw-1; Fri, 10 Jan 2020 18:16:15 -0500
X-MC-Unique: GsAh8KxvMV2jS2GQ4UT6hw-1
Received: by mail-wr1-f70.google.com with SMTP id 90so1564379wrq.6
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 15:16:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=BDYSZvcxplbrm/hl6PFrbxqi7+nmX07S7UZy05z2BNU=;
        b=LkBXfDXDmeRtznfgBkyRYWlNLe5HHKuCsfUILFx748luMwBeIj73F/27pl9WnwokAY
         4tLmwCCVZ690XlZElseXgj9lgFLy64SqA7RlcXT9PT0yz9Fdzs7oy1SO/t/2pjckxsnl
         G/KVooLIT1dTNE65ikPRsP0cT/3K3PFs6Dq6nVu/LyF2ux3speSOng4ChlszZWzBIpcy
         J6YMm0pW3uxfkT/IcoRhIjMdNNMojWRkQkXELs4cpZGeCYFuFrYJWCLOyn78vGK2XwAQ
         67LIy5E3QVAkQ6NrtOENDn4m5F61qANaFz93BPUz/ZdAfl6L9vLeXb0jzTUIwyB458gq
         pGLQ==
X-Gm-Message-State: APjAAAWTiTQpFyRHYwBaYDzeIuwrbEhUgMySRhHMQ+6AuLMk3IzuN1AQ
        JpnS0mLLzO9BmGApbYovOdJb22vi64PFPCBLPgNX/6/PrOgc1fwq1DIiERmMBRtDdxOHrHbP7S9
        RBdxnvGxAO6zlhpEX
X-Received: by 2002:adf:fd43:: with SMTP id h3mr5542552wrs.169.1578698174374;
        Fri, 10 Jan 2020 15:16:14 -0800 (PST)
X-Google-Smtp-Source: APXvYqz8fTNkmSN6BSViNXxU/x5V/ooLYXrYK884Z2B1m+hNPFpaxrYoWQ70Ex7WI3CLzUxZ0/vqrA==
X-Received: by 2002:adf:fd43:: with SMTP id h3mr5542534wrs.169.1578698174125;
        Fri, 10 Jan 2020 15:16:14 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id t1sm3998418wma.43.2020.01.10.15.16.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 15:16:12 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 58C751804D6; Sat, 11 Jan 2020 00:16:12 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH bpf-next 1/2] xdp: Move devmap bulk queue into struct net_device
In-Reply-To: <968491aa-01c7-ae8d-4e7f-8ec58f1750b1@gmail.com>
References: <157866612174.432695.5077671447287539053.stgit@toke.dk> <157866612285.432695.6722430952732620313.stgit@toke.dk> <20200110170824.7379adbf@carbon> <871rs7x7nc.fsf@toke.dk> <968491aa-01c7-ae8d-4e7f-8ec58f1750b1@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 11 Jan 2020 00:16:12 +0100
Message-ID: <87y2uex5qb.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> writes:

> On 1/10/20 2:34 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Jesper Dangaard Brouer <brouer@redhat.com> writes:
>>=20
>>> On Fri, 10 Jan 2020 15:22:02 +0100
>>> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
>>>
>>>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>>>> index 2741aa35bec6..1b2bc2a7522e 100644
>>>> --- a/include/linux/netdevice.h
>>>> +++ b/include/linux/netdevice.h
>>> [...]
>>>> @@ -1993,6 +1994,8 @@ struct net_device {
>>>>  	spinlock_t		tx_global_lock;
>>>>  	int			watchdog_timeo;
>>>>=20=20
>>>> +	struct xdp_dev_bulk_queue __percpu *xdp_bulkq;
>>>> +
>>>>  #ifdef CONFIG_XPS
>>>>  	struct xps_dev_maps __rcu *xps_cpus_map;
>>>>  	struct xps_dev_maps __rcu *xps_rxqs_map;
>>>
>>> We need to check that the cache-line for this location in struct
>>> net_device is not getting updated (write operation) from different CPUs.
>>>
>>> The test you ran was a single queue single CPU test, which will not
>>> show any regression for that case.
>>=20
>> Well, pahole says:
>>=20
>> 	/* --- cacheline 14 boundary (896 bytes) --- */
>> 	struct netdev_queue *      _tx __attribute__((__aligned__(64))); /*   8=
96     8 */
>> 	unsigned int               num_tx_queues;        /*   904     4 */
>> 	unsigned int               real_num_tx_queues;   /*   908     4 */
>> 	struct Qdisc *             qdisc;                /*   912     8 */
>> 	struct hlist_head  qdisc_hash[16];               /*   920   128 */
>> 	/* --- cacheline 16 boundary (1024 bytes) was 24 bytes ago --- */
>> 	unsigned int               tx_queue_len;         /*  1048     4 */
>> 	spinlock_t                 tx_global_lock;       /*  1052     4 */
>> 	int                        watchdog_timeo;       /*  1056     4 */
>>=20
>> 	/* XXX 4 bytes hole, try to pack */
>>=20
>> 	struct xdp_dev_bulk_queue * xdp_bulkq;           /*  1064     8 */
>> 	struct xps_dev_maps *      xps_cpus_map;         /*  1072     8 */
>> 	struct xps_dev_maps *      xps_rxqs_map;         /*  1080     8 */
>> 	/* --- cacheline 17 boundary (1088 bytes) --- */
>>=20
>>=20
>> of those, tx_queue_len is the max queue len (so only set on init),
>> tx_global_lock is not used by multi-queue devices, watchdog_timeo also
>> seems to be a static value thats set on init, and the xps* pointers also
>> only seems to be set once on init. So I think we're fine?
>>=20
>> I can run a multi-CPU test just to be sure, but I really don't see which
>> of those fields might be updated on TX...
>>=20
>
> Note that another interesting field is miniq_egress, your patch
> moves it to another cache line.

Hmm, since there's that 4-byte hole, I gust we could just move
watchdog_timeo down to fix that. Any reason that's a bad idea?

> We probably should move qdisc_hash array elsewhere.

You certainly won't hear me object to that :)

-Toke

