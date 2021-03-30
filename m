Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E91234F2D7
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 23:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbhC3VMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 17:12:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49019 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232590AbhC3VLr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 17:11:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617138707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+d8bP069q3cX6KDAKElLY3IDtJwqKEIFpPeGaA7ygUI=;
        b=T2kYdlnupBMb0A0/DxP1f/yI5nIDXa/R7EUG4JMqS8SUMlTjtSUJIlse5wxI26bCOP3ldK
        7BVVJUwe6oGPGYa+JI5v3HtbhvN/ecusjKrGljpRt9g433FxItCMq9+dIEYXl3Yv8S2L0Q
        i9II7RymtzwzuZ/fLuW/jc2Id8yQw7k=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-ps3Ay-qWN56m92UtkVhB5w-1; Tue, 30 Mar 2021 17:11:43 -0400
X-MC-Unique: ps3Ay-qWN56m92UtkVhB5w-1
Received: by mail-ej1-f71.google.com with SMTP id bg7so7728910ejb.12
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 14:11:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=+d8bP069q3cX6KDAKElLY3IDtJwqKEIFpPeGaA7ygUI=;
        b=AKdyhy8qKDcgjUqjExuk3C8ufHiUj+r//ilFttv6mm85kSAGiPFM+WT2zdINqSKg2N
         pMd9U0mrSxA4y9JC9WV/pqm7fyG5BnfvkmdqFV0Ee6+/rmiYCroyIg26FekI7u9El83y
         NjPDAwqI6hCQJJNWB0gLpHo5dltf6O3La5oa76WqYbnSHJDzy4vBUrFymNeJwM1BtdSN
         dtqP1pLMD6ZwH9fpIPbxnx/lA28+O/F+xbUPu4eNCI3BkKvexRZLHcclcrWk3j/EVcgn
         cW89A1+RqT24NCPyDfckOr4VFg1dNTINZiQ0+cJPoYyBOnh0TIrn7mbJT0/IDlfysGxh
         P6dg==
X-Gm-Message-State: AOAM533ckrVzy6/37v0xkmdwhEcs8/HZpZ+Fe/E1YcP87Tb6Km5DFNGs
        7eJMZhFNRSc1cm7uFuiwSxAdHK3pYnsWZ12BADE8Ej6z3KBjLm0ERXPppv3xkID4Dy5J08AQnLu
        NSCKRlvYVba5fzPcA
X-Received: by 2002:aa7:dd99:: with SMTP id g25mr35237442edv.230.1617138701931;
        Tue, 30 Mar 2021 14:11:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxJpDvPkfF2JvU4Dnt65VbU0gbarBWnEYv0TRLdjJSqirTWJtcNED/HKPIR7ly4a5+Y12tJeA==
X-Received: by 2002:aa7:dd99:: with SMTP id g25mr35237420edv.230.1617138701731;
        Tue, 30 Mar 2021 14:11:41 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id r25sm129891edv.78.2021.03.30.14.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 14:11:41 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8EB42180292; Tue, 30 Mar 2021 23:11:40 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH bpf-next 3/5] libbpf: add low level TC-BPF API
In-Reply-To: <CAEf4BzaMsixmrrgGv6Qr68Ytq8k9W+WP6m4Vdb1wDhDFBKStgw@mail.gmail.com>
References: <20210325120020.236504-1-memxor@gmail.com>
 <20210325120020.236504-4-memxor@gmail.com>
 <CAEf4Bzbz9OQ_vfqyenurPV7XRVpK=zcvktwH2Dvj-9kUGL1e7w@mail.gmail.com>
 <20210328080648.oorx2no2j6zslejk@apollo>
 <CAEf4BzaMsixmrrgGv6Qr68Ytq8k9W+WP6m4Vdb1wDhDFBKStgw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 30 Mar 2021 23:11:40 +0200
Message-ID: <87czvgqrcj.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Sun, Mar 28, 2021 at 1:11 AM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
>>
>> On Sun, Mar 28, 2021 at 10:12:40AM IST, Andrii Nakryiko wrote:
>> > Is there some succinct but complete enough documentation/tutorial/etc
>> > that I can reasonably read to understand kernel APIs provided by TC
>> > (w.r.t. BPF, of course). I'm trying to wrap my head around this and
>> > whether API makes sense or not. Please share links, if you have some.
>> >
>>
>> Hi Andrii,
>>
>> Unfortunately for the kernel API part, I couldn't find any when I was working
>> on this. So I had to read the iproute2 tc code (tc_filter.c, f_bpf.c,
>> m_action.c, m_bpf.c) and the kernel side bits (cls_api.c, cls_bpf.c, act_api.c,
>> act_bpf.c) to grok anything I didn't understand. There's also similar code in
>> libnl (lib/route/{act,cls}.c).
>>
>> Other than that, these resources were useful (perhaps you already went through
>> some/all of them):
>>
>> https://docs.cilium.io/en/latest/bpf/#tc-traffic-control
>> https://qmonnet.github.io/whirl-offload/2020/04/11/tc-bpf-direct-action/
>> tc(8), and tc-bpf(8) man pages
>>
>> I hope this is helpful!
>
> Thanks! I'll take a look. Sorry, I'm a bit behind with all the stuff,
> trying to catch up.
>
> I was just wondering if it would be more natural instead of having
> _dev _block variants and having to specify __u32 ifindex, __u32
> parent_id, __u32 protocol, to have some struct specifying TC
> "destination"? Maybe not, but I thought I'd bring this up early. So
> you'd have just bpf_tc_cls_attach(), and you'd so something like
>
> bpf_tc_cls_attach(prog_fd, TC_DEV(ifindex, parent_id, protocol))
>
> or
>
> bpf_tc_cls_attach(prog_fd, TC_BLOCK(block_idx, protocol))
>
> ? Or it's taking it too far?

Hmm, that's not a bad idea, actually. An earlier version of the series
did have only a single set of functions, but with way too many
arguments, which is why we ended up agreeing to split them. But
encapsulating the destination in a separate struct and combining it with
some helper macros might just make this work! I like it! Kumar, WDYT?

-Toke

