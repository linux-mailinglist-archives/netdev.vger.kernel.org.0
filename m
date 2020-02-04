Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD82151704
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 09:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbgBDIZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 03:25:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47481 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727119AbgBDIZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 03:25:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580804754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+cv0iF+0H7Pigj2tNEIXGEzBnJQuDpwFFoAut7P08Ik=;
        b=dPH2EgJx6EJBMC42vipI7qbHUMTDqTvVhr5IZL3nLlMJvCkauXQnZYCAEZUxXsrju4BnIZ
        zNh2E6jlUZOpwBvvilLLzA+FV8qxUmEHW/+Y6SO5NFHYy0EaKZ+/lTZG9awOcDheRo2F4H
        BElqwcYgMiqvs91fvoX05wvb2GjhhCY=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-3D3dssg1P0KM3aH8cgX_NQ-1; Tue, 04 Feb 2020 03:25:51 -0500
X-MC-Unique: 3D3dssg1P0KM3aH8cgX_NQ-1
Received: by mail-lj1-f197.google.com with SMTP id z17so4991442ljz.2
        for <netdev@vger.kernel.org>; Tue, 04 Feb 2020 00:25:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=+cv0iF+0H7Pigj2tNEIXGEzBnJQuDpwFFoAut7P08Ik=;
        b=pWeQewtm/p8ekdYP/z0g7rMufi9eDlEHE4Zl4YT/Dpu090TClvm7WxLbzeesHMtPj0
         BzvFzr0PHQZ9G4V6w92VVGbarv17UjSBm6wnFT2wEUSe68GT1m6En8wyR/izc0pVy/m0
         XazVKu2BAT4OMpOBr6ZoIQ0J7fcO2+426mWjU8UkgG9vAth4rbuv3OHvwN7YYP7dgWQx
         VCSMXGGUIAut+SD6u0HDUJBRYU7uEvHdCshEKQr23VtpVxBBudO3VSk4K8PgZBvMitLh
         4t5TJzremwB4ux8+XvyHEfbU6mxbOZgyhh9olHxM8ubLxeS1IHRcwvgPcr38ksqLsqjf
         TEXw==
X-Gm-Message-State: APjAAAVM0Cm1lj/0UJC5A6vzOO8q8YxlJAoPx2DGR7iLSgQL8iWFNuCk
        rjzjOJvuf7taGeqvPxyk18XgKbN1ahC6Qr55CC0CtE3qy59Y2l2+ugcLCAZS77eoC2VLGzMRPNh
        B91hAMNcEYC4gYogG
X-Received: by 2002:a19:8b89:: with SMTP id n131mr14329725lfd.14.1580804749602;
        Tue, 04 Feb 2020 00:25:49 -0800 (PST)
X-Google-Smtp-Source: APXvYqzw5LKNwpDeykmN26/MhP+JVwDAcWl5YcJizUE2gM92ULT/ajB61KUKFyxVqnEEMNZ9Oz8paA==
X-Received: by 2002:a19:8b89:: with SMTP id n131mr14329709lfd.14.1580804749298;
        Tue, 04 Feb 2020 00:25:49 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id 135sm10169663lfb.28.2020.02.04.00.25.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 00:25:48 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 767E61802CA; Tue,  4 Feb 2020 09:25:45 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Ahern <dsahern@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [RFC bpf-next 0/5] Convert iproute2 to use libbpf (WIP)
In-Reply-To: <CAEf4Bzb1fXdGFz7BkrQF7uMhBD1F-K_kudhLR5wC-+kA7PMqnA@mail.gmail.com>
References: <20190820114706.18546-1-toke@redhat.com> <CAEf4BzZxb7qZabw6aDVaTqnhr3AGtwEo+DbuBR9U9tJr+qVuyg@mail.gmail.com> <87blwiqlc8.fsf@toke.dk> <CAEf4BzYMKPbfOu4a4UDEfJVcNW1-KvRwJ7PVo+Mf_1YUJgE4Qw@mail.gmail.com> <43e8c177-cc9c-ca0b-1622-e30a7a1281b7@iogearbox.net> <CAEf4Bzab_w0AXy5P9mG14mcyJVgUCzuuNda5FpU5wSEwUciGfg@mail.gmail.com> <87tva8m85t.fsf@toke.dk> <CAEf4BzbzQwLn87G046ZbkLtTbY6WF6o8JkygcPLPGUSezgs9Tw@mail.gmail.com> <CAEf4BzZOAukJZzo4J5q3F2v4MswQ6nJh6G1_c0H0fOJCdc7t0A@mail.gmail.com> <87blqfcvnf.fsf@toke.dk> <CAEf4Bza4bSAzjFp2WDiPAM7hbKcKgAX4A8_TUN8V38gXV9GbTg@mail.gmail.com> <0bf50b22-a8e2-e3b3-aa53-7bd5dd5d4399@gmail.com> <CAEf4Bzbzz3s0bSF_CkP56NTDd+WBLAy0QrMvreShubetahuH0g@mail.gmail.com> <2cf136a4-7f0e-f4b7-1ecb-6cbf6cb6c8ff@gmail.com> <CAEf4Bzb1fXdGFz7BkrQF7uMhBD1F-K_kudhLR5wC-+kA7PMqnA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 04 Feb 2020 09:25:45 +0100
Message-ID: <87h80669o6.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Mon, Feb 3, 2020 at 8:53 PM David Ahern <dsahern@gmail.com> wrote:
>>
>> On 2/3/20 8:41 PM, Andrii Nakryiko wrote:
>> > On Mon, Feb 3, 2020 at 5:46 PM David Ahern <dsahern@gmail.com> wrote:
>> >>
>> >> On 2/3/20 5:56 PM, Andrii Nakryiko wrote:
>> >>> Great! Just to disambiguate and make sure we are in agreement, my hope
>> >>> here is that iproute2 can completely delegate to libbpf all the ELF
>> >>>
>> >>
>> >> iproute2 needs to compile and continue working as is when libbpf is not
>> >> available. e.g., add check in configure to define HAVE_LIBBPF and move
>> >> the existing code and move under else branch.
>> >
>> > Wouldn't it be better to statically compile against libbpf in this
>> > case and get rid a lot of BPF-related code and simplify the rest of
>> > it? This can be easily done by using libbpf through submodule, the
>> > same way as BCC and pahole do it.
>> >
>>
>> iproute2 compiles today and runs on older distributions and older
>> distributions with newer kernels. That needs to hold true after the move
>> to libbpf.
>
> And by statically compiling against libbpf, checked out as a
> submodule, that will still hold true, wouldn't it? Or there is some
> complications I'm missing? Libbpf is designed to handle old kernels
> with no problems.

My plan was to use the same configure test I'm using for xdp-tools
(where I in turn copied the structure of the configure script from
iproute2):

https://github.com/xdp-project/xdp-tools/blob/master/configure#L59

This will look for a system libbpf install and compile against it if it
is compatible, and otherwise fall back to a statically linking against a
git submodule.

We'll need to double-check that this will work on everything currently
supported by iproute2, and fix libbpf if there are any issues with that.
Not that I foresee any, but you never know :)

-Toke

