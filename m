Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 154551CA519
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 09:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727886AbgEHHVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 03:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727860AbgEHHV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 03:21:28 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51FB1C05BD09
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 00:21:28 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id b8so460573ybn.0
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 00:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ghSLWmPTjJa1N7MEynHoO3xq1duNAQVUBZp+ZfGFuUE=;
        b=PvpvLe2fjNxojvQSID9SqgyPUOOpkTHnRBJ4bKWtgUvCTb1sqFaHRGvTkaAOfucQjA
         ybn2zA/+aGvjSF4YEBRK4zlBdZgfmQkmyM4ZU3TyWAaRapPBD0eDc56ti633wmr/mj9K
         MuJ8LzN2rwCYRWSQKAMPomnzvvD7JgBZXstlRUzd8Vzszd7okoFqLSk8KypFJqtizd88
         dG9jgLNAVqgfGbfG+eUDUgSJWFovkUxrMBRo9lw9N7zehkqs0JGQ6XZzqlwx5oEVT1VG
         YxfnyfGAt/Rv+yVKMWjChUJJrrJtJzv9ZNfbjBdMrTI0JuN5jnfKCG7M4Hx84OXWOG60
         m1qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ghSLWmPTjJa1N7MEynHoO3xq1duNAQVUBZp+ZfGFuUE=;
        b=FT3YmLkTdE+PJ0QrmWXx9VCMRv1tJWUx76f4hIk9f0JcAy+jGtjMnEYBocPf22iF6c
         +w2dkupz6PqoxXRpSgtpcc8CqkXDvWpVp1s00vrGboEZaAMhjrKxmFNtH4zoqFMoxraS
         +b5uEgGghamGWECqMAYe7yaEvGOhHyljJH2AHDHhHbWPKlazkKjH1n2IwFS7SY+MX/1W
         mEoJtNdjhVM5oWZWJt1UWC4BFp0o16pfVCQyMIaWCFaJTShEH9qF1Hc+jy1Z/wEwxrs1
         aSAIKmxamOgJ5QH8ZWEd4kqGi0TFfN1zd3sozAaZ0WXdpAxFWi+OOsZ+8qVmNitpYkSn
         K6Ew==
X-Gm-Message-State: AGi0PuY0mf+kXHvCn3M9YP+u3INvKDmeRsEI4lbQQ2iIbKrbqpNNppZa
        1fEM5zrwps7Pb/5+DX/Ya7hua5NB/4xOI5jL9rAXjg==
X-Google-Smtp-Source: APiQypJ4LfbqVmL56J7m3SlKiNGelvh5pQdV/+Uielt+V3/tJezOCmC5ry3w7km1U2msTfPMA+0Jm8HumNdz8jGZrS4=
X-Received: by 2002:a05:6902:4ee:: with SMTP id w14mr1110079ybs.383.1588922487266;
 Fri, 08 May 2020 00:21:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200508063954.256593-1-irogers@google.com> <CAEf4BzYT5FfDt2oqctHC6dXNmwg5gaaNcFu1StObuYk-jKocLQ@mail.gmail.com>
In-Reply-To: <CAEf4BzYT5FfDt2oqctHC6dXNmwg5gaaNcFu1StObuYk-jKocLQ@mail.gmail.com>
From:   Ian Rogers <irogers@google.com>
Date:   Fri, 8 May 2020 00:21:16 -0700
Message-ID: <CAP-5=fU-QxfdkQoHP=Ksqeb9gPTE4xYcgEcp9Ej6trZpkCDvPA@mail.gmail.com>
Subject: Re: [PATCH] libbpf hashmap: fix undefined behavior in hash_bits
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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

On Fri, May 8, 2020 at 12:12 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, May 7, 2020 at 11:40 PM Ian Rogers <irogers@google.com> wrote:
> >
> > If bits is 0, the case when the map is empty, then the >> is the size of
> > the register which is undefined behavior - on x86 it is the same as a
> > shift by 0. Fix by handling the 0 case explicitly.
> >
> > Signed-off-by: Ian Rogers <irogers@google.com>
> > ---
>
> No need. The only case when bits can be 0 is when hashmap is
> completely empty (no elements have ever been added yet). In that case,
> it doesn't matter what value hash_bits() returns,
> hashmap__for_each_key_entry/hashmap__for_each_key_entry_safe will
> behave correctly, because map->buckets will be NULL.

Agreed. Unfortunately the LLVM undefined behavior sanitizer (I've not
tested with GCC to the same extent) will cause an exit when it sees >>
64 regardless of whether the value is used or not. It'd be possible to
#ifdef this code on whether a sanitizer was present.

Thanks,
Ian

> >  tools/lib/bpf/hashmap.h | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/tools/lib/bpf/hashmap.h b/tools/lib/bpf/hashmap.h
> > index d5ef212a55ba..781db653d16c 100644
> > --- a/tools/lib/bpf/hashmap.h
> > +++ b/tools/lib/bpf/hashmap.h
> > @@ -19,6 +19,8 @@
> >  static inline size_t hash_bits(size_t h, int bits)
> >  {
> >         /* shuffle bits and return requested number of upper bits */
> > +       if (bits == 0)
> > +               return 0;
> >         return (h * 11400714819323198485llu) >> (__WORDSIZE - bits);
> >  }
> >
> > --
> > 2.26.2.645.ge9eca65c58-goog
> >
