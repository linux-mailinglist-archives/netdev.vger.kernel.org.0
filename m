Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67EDC3AF89B
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 00:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbhFUWh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 18:37:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34983 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231669AbhFUWh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 18:37:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624314913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ihXJi4HMh047x0hCl00Zj7QoD6DY53BRtvvAlN0erqU=;
        b=guBnxwHMLaJcPJxmgwStPBhHwW5jSAqH46TPKWIJYTOUe8KCPwqlKUtpcA9uZgJuhW8oWf
        bCiNI74qKS3tGKXN/x1g4VtxMeGoahulhzF4fKwrBkiQ6Kfe9QSuPTUdQ03TH3h31SYZCT
        e2e+19rpUEmeASZOckprjnNjPLiVEpM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-pEGthbIXMBOSinxbrkuTzg-1; Mon, 21 Jun 2021 18:35:11 -0400
X-MC-Unique: pEGthbIXMBOSinxbrkuTzg-1
Received: by mail-ed1-f70.google.com with SMTP id g13-20020a056402090db02903935a4cb74fso8507106edz.1
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 15:35:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=ihXJi4HMh047x0hCl00Zj7QoD6DY53BRtvvAlN0erqU=;
        b=rtTr6IFYdL/odNlctfx8wGkCYXYAleGqgRh6h0Y830yctjo3CjbzLWmEsA4+TbTpJF
         s6i/6F0dC84lYMbTXwHovrdn27XYsIFq4SNH3Q39Ud4suD3JuadzPFBilFQpw86AF/f1
         m728H2MVdwniUxEfocNz18dNZM8wAt9FjfiPZQIT6eyEUgY61RoXoPIupiMsX6wvBrZv
         mK+9Tuf0yx69CYZZnbPamZoxNYCmJRnYwrfZg3L2gi8XFp+qQNrtbMXqAG983Ji78H3+
         gt/M+7tCjbQng5pO52I6Ciz55OiO/Equ0wtNKBWtcqEq1mk5j/uwl2Ez+TwmHlBzYtOO
         lEbA==
X-Gm-Message-State: AOAM532fZf3CFQhQk94svSGmoq4OgMp1MStIxw97Ke/9Z0Uoqpp/v2KU
        NzmC134arGpIpDvHVjRaRSsEb46aK3wpAC8JeBQr6pZO3CtS3jv1LcYP9Mxt+KO7V6JL23o4u54
        EU4RUjZiy07Xa3o0V
X-Received: by 2002:aa7:c6d4:: with SMTP id b20mr782950eds.341.1624314909835;
        Mon, 21 Jun 2021 15:35:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxDHghY5lWbI8jG3o/ItrVzoGyw4SFy2CF1QMklYlHDWdtXJy5T3BkzrrcrFun18Ddy76zWpQ==
X-Received: by 2002:aa7:c6d4:: with SMTP id b20mr782910eds.341.1624314909461;
        Mon, 21 Jun 2021 15:35:09 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id o4sm10897848edc.94.2021.06.21.15.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 15:35:08 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 4533E18071E; Tue, 22 Jun 2021 00:35:08 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH bpf-next v3 03/16] xdp: add proper __rcu annotations to
 redirect map entries
In-Reply-To: <96117b3f-8041-b524-ef70-d5afc97e32f9@iogearbox.net>
References: <20210617212748.32456-1-toke@redhat.com>
 <20210617212748.32456-4-toke@redhat.com>
 <1881ecbe-06ec-6b0a-836c-033c31fabef4@iogearbox.net>
 <87zgvirj6g.fsf@toke.dk>
 <96117b3f-8041-b524-ef70-d5afc97e32f9@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 22 Jun 2021 00:35:08 +0200
Message-ID: <87r1gurgmb.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 6/21/21 11:39 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Daniel Borkmann <daniel@iogearbox.net> writes:
>>> On 6/17/21 11:27 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>>> XDP_REDIRECT works by a three-step process: the bpf_redirect() and
>>>> bpf_redirect_map() helpers will lookup the target of the redirect and =
store
>>>> it (along with some other metadata) in a per-CPU struct bpf_redirect_i=
nfo.
>>>> Next, when the program returns the XDP_REDIRECT return code, the driver
>>>> will call xdp_do_redirect() which will use the information thus stored=
 to
>>>> actually enqueue the frame into a bulk queue structure (that differs
>>>> slightly by map type, but shares the same principle). Finally, before
>>>> exiting its NAPI poll loop, the driver will call xdp_do_flush(), which=
 will
>>>> flush all the different bulk queues, thus completing the redirect.
>>>>
>>>> Pointers to the map entries will be kept around for this whole sequenc=
e of
>>>> steps, protected by RCU. However, there is no top-level rcu_read_lock(=
) in
>>>> the core code; instead drivers add their own rcu_read_lock() around th=
e XDP
>>>> portions of the code, but somewhat inconsistently as Martin discovered=
[0].
>>>> However, things still work because everything happens inside a single =
NAPI
>>>> poll sequence, which means it's between a pair of calls to
>>>> local_bh_disable()/local_bh_enable(). So Paul suggested[1] that we cou=
ld
>>>> document this intention by using rcu_dereference_check() with
>>>> rcu_read_lock_bh_held() as a second parameter, thus allowing sparse and
>>>> lockdep to verify that everything is done correctly.
>>>>
>>>> This patch does just that: we add an __rcu annotation to the map entry
>>>> pointers and remove the various comments explaining the NAPI poll assu=
rance
>>>> strewn through devmap.c in favour of a longer explanation in filter.c.=
 The
>>>> goal is to have one coherent documentation of the entire flow, and rel=
y on
>>>> the RCU annotations as a "standard" way of communicating the flow in t=
he
>>>> map code (which can additionally be understood by sparse and lockdep).
>>>>
>>>> The RCU annotation replacements result in a fairly straight-forward
>>>> replacement where READ_ONCE() becomes rcu_dereference_check(), WRITE_O=
NCE()
>>>> becomes rcu_assign_pointer() and xchg() and cmpxchg() gets wrapped in =
the
>>>> proper constructs to cast the pointer back and forth between __rcu and
>>>> __kernel address space (for the benefit of sparse). The one complicati=
on is
>>>> that xskmap has a few constructions where double-pointers are passed b=
ack
>>>> and forth; these simply all gain __rcu annotations, and only the final
>>>> reference/dereference to the inner-most pointer gets changed.
>>>>
>>>> With this, everything can be run through sparse without eliciting
>>>> complaints, and lockdep can verify correctness even without the use of
>>>> rcu_read_lock() in the drivers. Subsequent patches will clean these up=
 from
>>>> the drivers.
>>>>
>>>> [0] https://lore.kernel.org/bpf/20210415173551.7ma4slcbqeyiba2r@kafai-=
mbp.dhcp.thefacebook.com/
>>>> [1] https://lore.kernel.org/bpf/20210419165837.GA975577@paulmck-ThinkP=
ad-P17-Gen-1/
>>>>
>>>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>>> ---
>>>>    include/net/xdp_sock.h |  2 +-
>>>>    kernel/bpf/cpumap.c    | 13 +++++++----
>>>>    kernel/bpf/devmap.c    | 49 ++++++++++++++++++---------------------=
---
>>>>    net/core/filter.c      | 28 ++++++++++++++++++++++++
>>>>    net/xdp/xsk.c          |  4 ++--
>>>>    net/xdp/xsk.h          |  4 ++--
>>>>    net/xdp/xskmap.c       | 29 ++++++++++++++-----------
>>>>    7 files changed, 80 insertions(+), 49 deletions(-)
>>> [...]
>>>>    						 __dev_map_entry_free);
>>>> diff --git a/net/core/filter.c b/net/core/filter.c
>>>> index caa88955562e..0b7db5c70385 100644
>>>> --- a/net/core/filter.c
>>>> +++ b/net/core/filter.c
>>>> @@ -3922,6 +3922,34 @@ static const struct bpf_func_proto bpf_xdp_adju=
st_meta_proto =3D {
>>>>    	.arg2_type	=3D ARG_ANYTHING,
>>>>    };
>>>>=20=20=20=20
>>>> +/* XDP_REDIRECT works by a three-step process, implemented in the fun=
ctions
>>>> + * below:
>>>> + *
>>>> + * 1. The bpf_redirect() and bpf_redirect_map() helpers will lookup t=
he target
>>>> + *    of the redirect and store it (along with some other metadata) i=
n a per-CPU
>>>> + *    struct bpf_redirect_info.
>>>> + *
>>>> + * 2. When the program returns the XDP_REDIRECT return code, the driv=
er will
>>>> + *    call xdp_do_redirect() which will use the information in struct
>>>> + *    bpf_redirect_info to actually enqueue the frame into a map type=
-specific
>>>> + *    bulk queue structure.
>>>> + *
>>>> + * 3. Before exiting its NAPI poll loop, the driver will call xdp_do_=
flush(),
>>>> + *    which will flush all the different bulk queues, thus completing=
 the
>>>> + *    redirect.
>>>> + *
>>>> + * Pointers to the map entries will be kept around for this whole seq=
uence of
>>>> + * steps, protected by RCU. However, there is no top-level rcu_read_l=
ock() in
>>>> + * the core code; instead, the RCU protection relies on everything ha=
ppening
>>>> + * inside a single NAPI poll sequence, which means it's between a pai=
r of calls
>>>> + * to local_bh_disable()/local_bh_enable().
>>>> + *
>>>> + * The map entries are marked as __rcu and the map code makes sure to
>>>> + * dereference those pointers with rcu_dereference_check() in a way t=
hat works
>>>> + * for both sections that to hold an rcu_read_lock() and sections tha=
t are
>>>> + * called from NAPI without a separate rcu_read_lock(). The code belo=
w does not
>>>> + * use RCU annotations, but relies on those in the map code.
>>>
>>> One more follow-up question related to tc BPF: given we do use rcu_read=
_lock_bh()
>>> in case of sch_handle_egress(), could we also remove the rcu_read_lock(=
) pair
>>> from cls_bpf_classify() then?
>>=20
>> I believe so, yeah. Patch 2 in this series should even make lockdep stop
>> complaining about it :)
>
> Btw, I was wondering whether we should just get rid of all the WARN_ON_ON=
CE()s
> from those map helpers given in most situations these are not triggered a=
nyway
> due to retpoline avoidance where verifier rewrites the calls to jump to t=
he map
> backend implementation directly. One alternative could be to have an exte=
nsion
> to the bpf prologue generation under CONFIG_DEBUG_LOCK_ALLOC and call the=
 lockdep
> checks from there, but it's probably not worth the effort. (In the trampo=
line
> case we have those __bpf_prog_enter()/__bpf_prog_enter_sleepable() where =
the
> latter in particular has asserts like might_fault(), fwiw.)

I agree that it's probably overkill to amend the prologue. No strong
opinion on whether removing the checks entirely is a good idea; I guess
they at least serve as documentation even if they're not actually called
that often?

>> I can add a patch removing the rcu_read_lock() from cls_bpf in the next
>> version.
>>=20
>>> It would also be great if this scenario in general could be placed
>>> under the Documentation/RCU/whatisRCU.rst as an example, so we could
>>> refer to the official doc on this, too, if Paul is good with this.
>>=20
>> I'll take a look and see if I can find a way to fit it in there...
>>=20
>>> Could you also update the RCU comment in bpf_prog_run_xdp()? Or
>>> alternatively move all the below driver comments in there as a single
>>> location?
>>>
>>>     /* This code is invoked within a single NAPI poll cycle and thus un=
der
>>>      * local_bh_disable(), which provides the needed RCU protection.
>>>      */
>>=20
>> Sure, can do. And yeah, I do agree that moving the comment in there
>> makes more sense than scattering it over all the drivers, even if that
>> means I have to go back and edit all the drivers again :P
>
> Yeap, all of the above sounds good, thanks!

Cool :)

