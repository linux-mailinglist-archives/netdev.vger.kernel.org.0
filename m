Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADABA1CB69B
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 20:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbgEHSEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 14:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726756AbgEHSEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 14:04:41 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39321C061A0C;
        Fri,  8 May 2020 11:04:41 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id z2so2655181iol.11;
        Fri, 08 May 2020 11:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6n7N9OP5xGlbdCY3wbnFvbe92wVnKtN4kGkgM+TDOk0=;
        b=V7+iqsCA8GIu6utgH2UMhByKaA2/FCf7MLe6adjxHlKp1CGufE5CkcjrPULjDhUhw7
         C1SLnkOu88d+kq7GTGEhYnndx2U218EuNKPCi15Iiw9YgiVEqobpg1xfBRNb565+4Dp3
         Iiv0OGfmbGMgvKl8dp8hg3QClDCHjoK/AFnzaxFngSlMIQlWZm8eFljIrCJRE/7Iq8K0
         HMUTpORzJaindByoGANqSJKIIRJvXnTjroQPEYkH81WLuEqy43XDfVcdpMmIGcTdpzrq
         +rtv6Ksf7hvlvzZ3bFK0I66nt123P7WSrgDRR7mDmyqiaVEKZwGriVhn0/jackUrHwl1
         IXFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6n7N9OP5xGlbdCY3wbnFvbe92wVnKtN4kGkgM+TDOk0=;
        b=LhrwEZqrpCH8wKGSqb9GllcoaQ/qCDlAe6RlGIJLjOWQG/5ewZdTaWuVk4kHvdwZ50
         CB3gc9t/Jogikce2+KY4H2WnJzHlOA58CW3hZeriJaKxJt7SZa/seCXSNRU4TH7NXtbj
         6gs9Z7ATzB6ls07S81LKySdnQJuWTt2tqs26PWqwJmZq1ri+Dw6abf4cEFNC7a+mcH4O
         qbpoyGztkL6Es7OO0hka5IufZWYbR76Og0gfH4018Fz93bzjaoP1qngqSIawdzQuU1tc
         gwZfvkgykaR3Z/HSWqTeD+4En2kmMhIaI69rmgC60uLWGYt/12jDI9nV8/dp5Gbp/xv5
         onyA==
X-Gm-Message-State: AGi0PubhBT9Ag+8O5xt51tmoWq1nHdhjWic+uW8FwRP2Xyabeff/AP6z
        dJYtn6Eh6abKkMg8QF6mLqFPl8xHjYEAK4Orwsg=
X-Google-Smtp-Source: APiQypLb5fZO4mkjqTLGPaD0VhNwGL/3AK5hbJeXdURVDlAJjd5J9F30z8u63HbQu6cSTn9Iu36jeUpzMGuIYDHUQ6I=
X-Received: by 2002:a5d:970e:: with SMTP id h14mr3769395iol.117.1588961080652;
 Fri, 08 May 2020 11:04:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200508063954.256593-1-irogers@google.com> <CAEf4BzYT5FfDt2oqctHC6dXNmwg5gaaNcFu1StObuYk-jKocLQ@mail.gmail.com>
 <CAP-5=fU-QxfdkQoHP=Ksqeb9gPTE4xYcgEcp9Ej6trZpkCDvPA@mail.gmail.com>
In-Reply-To: <CAP-5=fU-QxfdkQoHP=Ksqeb9gPTE4xYcgEcp9Ej6trZpkCDvPA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 May 2020 11:04:29 -0700
Message-ID: <CAEf4BzZFWsRKz+dUj6MHw2=qOpXpmna6ommRE9OxQZEoHH6UmA@mail.gmail.com>
Subject: Re: [PATCH] libbpf hashmap: fix undefined behavior in hash_bits
To:     Ian Rogers <irogers@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 8, 2020 at 12:21 AM Ian Rogers <irogers@google.com> wrote:
>
> On Fri, May 8, 2020 at 12:12 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Thu, May 7, 2020 at 11:40 PM Ian Rogers <irogers@google.com> wrote:
> > >
> > > If bits is 0, the case when the map is empty, then the >> is the size of
> > > the register which is undefined behavior - on x86 it is the same as a
> > > shift by 0. Fix by handling the 0 case explicitly.
> > >
> > > Signed-off-by: Ian Rogers <irogers@google.com>
> > > ---
> >
> > No need. The only case when bits can be 0 is when hashmap is
> > completely empty (no elements have ever been added yet). In that case,
> > it doesn't matter what value hash_bits() returns,
> > hashmap__for_each_key_entry/hashmap__for_each_key_entry_safe will
> > behave correctly, because map->buckets will be NULL.
>
> Agreed. Unfortunately the LLVM undefined behavior sanitizer (I've not
> tested with GCC to the same extent) will cause an exit when it sees >>
> 64 regardless of whether the value is used or not. It'd be possible to
> #ifdef this code on whether a sanitizer was present.

Yeah, let's do that rather than slowing down hashing function.

>
> Thanks,
> Ian
>
> > >  tools/lib/bpf/hashmap.h | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/tools/lib/bpf/hashmap.h b/tools/lib/bpf/hashmap.h
> > > index d5ef212a55ba..781db653d16c 100644
> > > --- a/tools/lib/bpf/hashmap.h
> > > +++ b/tools/lib/bpf/hashmap.h
> > > @@ -19,6 +19,8 @@
> > >  static inline size_t hash_bits(size_t h, int bits)
> > >  {
> > >         /* shuffle bits and return requested number of upper bits */
> > > +       if (bits == 0)
> > > +               return 0;
> > >         return (h * 11400714819323198485llu) >> (__WORDSIZE - bits);
> > >  }
> > >
> > > --
> > > 2.26.2.645.ge9eca65c58-goog
> > >
