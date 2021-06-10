Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66D6B3A371C
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 00:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbhFJW3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 18:29:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44996 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230001AbhFJW3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 18:29:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623364076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IF5wbm9XqVBGzIYcxugb/26YEZipTwS/Jt7VVR3EcJQ=;
        b=ZGbDUMIqcOjPyd+XWj41m8dGwIPgKdF7YoxOlYKqqRMTZLYczJMCzmVzcm+BI5IWlGrQXB
        azWyEOoX/QlFxCeXXGxMRETGj9amUpp5IrZhM+4jh9bUXd8WayhZibWJaugOKX43eW4uI7
        FmCDi28b7hMIMyk28q7Tn+SOOXcC0so=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-201-iTHEauVnNKCYd8cj1RWyfw-1; Thu, 10 Jun 2021 18:27:54 -0400
X-MC-Unique: iTHEauVnNKCYd8cj1RWyfw-1
Received: by mail-ed1-f72.google.com with SMTP id z16-20020aa7d4100000b029038feb83da57so14946939edq.4
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 15:27:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=IF5wbm9XqVBGzIYcxugb/26YEZipTwS/Jt7VVR3EcJQ=;
        b=Fmc7Vjqb5Rv1urfN9L0T0ouLgfjPJp8//yA2Bq+EBbZEZARAvPDrOkQcsZHaCT9vST
         F1QGA4Gl3scaKwHeU1LbYrJSi0vxgRVE5unkOwvqUaApoaYcMEvZazaGDKhfmgpRTC97
         nDoXFVovtdpO8wx78LVDrkj7ZkV+y3TyP0tOkFx+3uru663O25fKSJOOavveBekV2V/w
         VDTorJ7Tp2FXg+Dd4s4vAe3vCvZUwi6D1QgeJ6eKaCcHP6Dnvb3cWRsvEgwcPQYwv+yc
         nzmKCDBCUUVil9BIEB1eHD7tSzFAi4zQSn7vcuiJhlzm/Z84RcZa6SZDgtaG65UU5TGs
         ScRA==
X-Gm-Message-State: AOAM530B11ucwRl+H9rR9X6JqHpyACECBGhqHGAadN0YAhihTDZBRw9X
        8dzPrI4flmNJEaiGgKFF/krHuKc1tS5+kpAHIp0fPhNk25aKC5a4lOPZZnZE/naF0nyaebDfElb
        vgPVUKTLY2rGwlZBM
X-Received: by 2002:a05:6402:885:: with SMTP id e5mr691304edy.248.1623364073760;
        Thu, 10 Jun 2021 15:27:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwl/acrlBsVAf9oBWLj9CquBE14VTjBxVpStedLAQ1ucZQW/B1MwrK3iKY8PXJhJU54vZl5nw==
X-Received: by 2002:a05:6402:885:: with SMTP id e5mr691289edy.248.1623364073599;
        Thu, 10 Jun 2021 15:27:53 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id e22sm1957905edu.35.2021.06.10.15.27.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 15:27:52 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 4F1BF18071E; Fri, 11 Jun 2021 00:27:52 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH bpf-next 02/17] bpf: allow RCU-protected lookups to
 happen from bh context
In-Reply-To: <c5192ab3-1c05-8679-79f2-59d98299095b@iogearbox.net>
References: <20210609103326.278782-1-toke@redhat.com>
 <20210609103326.278782-3-toke@redhat.com>
 <CAADnVQJrETg1NsqBv2HE06tra=q5K8f1US8tGuHqc_FDMKR6XQ@mail.gmail.com>
 <c5192ab3-1c05-8679-79f2-59d98299095b@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 11 Jun 2021 00:27:52 +0200
Message-ID: <874ke5we1j.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> Hi Paul,
>
> On 6/10/21 8:38 PM, Alexei Starovoitov wrote:
>> On Wed, Jun 9, 2021 at 7:24 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>>
>>> XDP programs are called from a NAPI poll context, which means the RCU
>>> reference liveness is ensured by local_bh_disable(). Add
>>> rcu_read_lock_bh_held() as a condition to the RCU checks for map lookup=
s so
>>> lockdep understands that the dereferences are safe from inside *either*=
 an
>>> rcu_read_lock() section *or* a local_bh_disable() section. This is done=
 in
>>> preparation for removing the redundant rcu_read_lock()s from the driver=
s.
>>>
>>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>> ---
>>>   kernel/bpf/hashtab.c  | 21 ++++++++++++++-------
>>>   kernel/bpf/helpers.c  |  6 +++---
>>>   kernel/bpf/lpm_trie.c |  6 ++++--
>>>   3 files changed, 21 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
>>> index 6f6681b07364..72c58cc516a3 100644
>>> --- a/kernel/bpf/hashtab.c
>>> +++ b/kernel/bpf/hashtab.c
>>> @@ -596,7 +596,8 @@ static void *__htab_map_lookup_elem(struct bpf_map =
*map, void *key)
>>>          struct htab_elem *l;
>>>          u32 hash, key_size;
>>>
>>> -       WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held=
());
>>> +       WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held=
() &&
>>> +                    !rcu_read_lock_bh_held());
>>=20
>> It's not clear to me whether rcu_read_lock_held() is still needed.
>> All comments sound like rcu_read_lock_bh_held() is a superset of rcu
>> that includes bh.
>> But reading rcu source code it looks like RCU_BH is its own rcu flavor...
>> which is confusing.
>
> The series is a bit confusing to me as well. I recall we had a discussion=
 with
> Paul, but it was back in 2016 aka very early days of XDP to get some clar=
ifications
> about RCU vs RCU-bh flavour on this. Paul, given the series in here, I as=
sume the
> below is not true anymore, and in this case (since we're removing rcu_rea=
d_lock()
> from drivers), the RCU-bh acts as a real superset?
>
> Back then from your clarifications this was not the case:
>
>    On Mon, Jul 25, 2016 at 11:26:02AM -0700, Alexei Starovoitov wrote:
>    > On Mon, Jul 25, 2016 at 11:03 AM, Paul E. McKenney
>    > <paulmck@linux.vnet.ibm.com> wrote:
>    [...]
>    >>> The crux of the question is whether a particular driver rx handler=
, when
>    >>> called from __do_softirq, needs to add an additional rcu_read_lock=
 or
>    >>> whether it can rely on the mechanics of softirq.
>    >>
>    >> If it was rcu_read_lock_bh(), you could.
>    >>
>    >> But you didn't say rcu_read_lock_bh(), you instead said rcu_read_lo=
ck(),
>    >> which means that you absolutely cannot rely on softirq semantics.
>    >>
>    >> In particular, in CONFIG_PREEMPT=3Dy kernels, rcu_preempt_check_cal=
lbacks()
>    >> will notice that there is no rcu_read_lock() in effect and report
>    >> a quiescent state for that CPU.  Because rcu_preempt_check_callback=
s()
>    >> is invoked from the scheduling-clock interrupt, it absolutely can
>    >> execute during do_softirq(), and therefore being in softirq context
>    >> in no way provides rcu_read_lock()-style protection.
>    >>
>    >> Now, Alexei's question was for CONFIG_PREEMPT=3Dn kernels.  However=
, in
>    >> that case, rcu_read_lock() and rcu_read_unlock() generate no code
>    >> in recent production kernels, so there is no performance penalty for
>    >> using them.  (In older kernels, they implied a barrier().)
>    >>
>    >> So either way, with or without CONFIG_PREEMPT, you should use
>    >> rcu_read_lock() to get RCU protection.
>    >>
>    >> One alternative might be to switch to rcu_read_lock_bh(), but that
>    >> will add local_disable_bh() overhead to your read paths.
>    >>
>    >> Does that help, or am I missing the point of the question?
>    >
>    > thanks a lot for explanation.
>
>    Glad you liked it!
>
>    > I mistakenly assumed that _bh variants are 'stronger' and
>    > act as inclusive, but sounds like they're completely orthogonal
>    > especially with preempt_rcu=3Dy.
>
>    Yes, they are pretty much orthogonal.
>
>    > With preempt_rcu=3Dn and preempt=3Dy, it would be the case, since
>    > bh disables preemption and rcu_read_lock does the same as well,
>    > right? Of course, the code shouldn't be relying on that, so we
>    > have to fix our stuff.
>
>    Indeed, especially given that the kernel currently won't allow you
>    to configure CONFIG_PREEMPT_RCU=3Dn and CONFIG_PREEMPT=3Dy.  If it doe=
s,
>    please let me know, as that would be a bug that needs to be fixed.
>    (For one thing, I do not test that combination.)
>
> 							Thanx, Paul
>
> And now, fast-forward again to 2021 ... :)

We covered this in the thread I linked from the cover letter.
Specifically, this seems to have been a change from v4.20, see Paul's
reply here:
https://lore.kernel.org/bpf/20210417002301.GO4212@paulmck-ThinkPad-P17-Gen-=
1/

and the follow-up covering -rt here:
https://lore.kernel.org/bpf/20210419165837.GA975577@paulmck-ThinkPad-P17-Ge=
n-1/

-Toke

