Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32B1F29F576
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 20:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbgJ2The (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 15:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbgJ2The (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 15:37:34 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7EBCC0613D3
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 12:37:33 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id k18so915819wmj.5
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 12:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ycvfKMJ76qGv5R2aegMpcihPW70X6nt59v8Mw9I2ugw=;
        b=izTyanEop1UPDUUQ5udPdWIFWKImCXKqGh4jRR9NHkUR7PJacQNPUnl107nqevZDDf
         2ls5/MMnk0Cs59BTsoHhZgvmrt+5lvXOEh+0Z05+kpxfOO2IlaY+ZcjHt0JUr3S7Tb7C
         ZY/iiHgbbpAHv1LHoDTG1m/cM4A9ebvnpfS9xQ8Mm8NyQqJG9F8u2WZwjpKR5YmzSIz2
         z0HaHtRxECijdT8h4xCRvj02t+j3uDLKnAp0uORBAw9n96mXNst5yyc+KqNcx1YCPXNc
         S751K42TeaDjXArM7ON+oRlPltHjzv6KuSJPaaEfpTQ/UomfhENUe5VSR5dgOUJBCOcJ
         CtIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ycvfKMJ76qGv5R2aegMpcihPW70X6nt59v8Mw9I2ugw=;
        b=h+TLVhOuHEz6m/o+ayEAh1pS2tzOGbzJFWpZP8Eb72P26R5LA7Qw5yetu7LwvFIBII
         K961scCqRhOzslU98xu5SuYoItZKMh7KFS7aFyJDZfOQGCutlsK7tua14xtiiBHkq8eF
         1hv+ZFcUhkMVI4/swMJfYOoj8Y0oBSe8IMcFOHvQh1T0rt2xOdacR2vQWtsRhGcsGOYu
         Y2OAWW7dEQCJUA+KKya4BtQynjXz/QUptbymKYbR+JLucO2tU+UQaUyjqfjTyNeGoy9v
         rtmH3yUPx8nTuosEw7u3zUbDYF4xU+2Pya06igqTpBPjli+8zx+kLEajXhTgy9gu44Ee
         0l4Q==
X-Gm-Message-State: AOAM532yqCd3eAIUr7mkx6zZcgKNF57Mc8ynRQQKFLYtgw4midjLGWak
        iQSqeXmN5Hu6HN0lSkyw7Ojm4UIE1AbYKM34K8wf9w==
X-Google-Smtp-Source: ABdhPJyVpzE7KT8MnoBChtMjsxPysFTIYugPdHKYIVgeLeT9jDcYSt4tL4SZalOlRCDg4zanRghQrvAprEqP4asPtzE=
X-Received: by 2002:a1c:9cd8:: with SMTP id f207mr816563wme.76.1604000252387;
 Thu, 29 Oct 2020 12:37:32 -0700 (PDT)
MIME-Version: 1.0
References: <20201029160938.154084-1-irogers@google.com> <497F86C5-BD00-4C38-BD87-C6EFB92D1088@fb.com>
In-Reply-To: <497F86C5-BD00-4C38-BD87-C6EFB92D1088@fb.com>
From:   Ian Rogers <irogers@google.com>
Date:   Thu, 29 Oct 2020 12:37:20 -0700
Message-ID: <CAP-5=fUVSSWEYWWswi19nQHY-b5Vn8-oi7uvtXWnmo1usLOzNw@mail.gmail.com>
Subject: Re: [PATCH] libbpf hashmap: Fix undefined behavior in hash_bits
To:     Song Liu <songliubraving@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 10:45 AM Song Liu <songliubraving@fb.com> wrote:
>
> > On Oct 29, 2020, at 9:09 AM, Ian Rogers <irogers@google.com> wrote:
> >
> > If bits is 0, the case when the map is empty, then the >> is the size of
> > the register which is undefined behavior - on x86 it is the same as a
> > shift by 0. Fix by handling the 0 case explicitly when running with
> > address sanitizer.
> >
> > A variant of this patch was posted previously as:
> > https://lore.kernel.org/lkml/20200508063954.256593-1-irogers@google.com/
> >
> > Signed-off-by: Ian Rogers <irogers@google.com>
> > ---
> > tools/lib/bpf/hashmap.h | 14 ++++++++++++++
> > 1 file changed, 14 insertions(+)
> >
> > diff --git a/tools/lib/bpf/hashmap.h b/tools/lib/bpf/hashmap.h
> > index d9b385fe808c..27d0556527d3 100644
> > --- a/tools/lib/bpf/hashmap.h
> > +++ b/tools/lib/bpf/hashmap.h
> > @@ -12,9 +12,23 @@
> > #include <stddef.h>
> > #include <limits.h>
> >
> > +#ifdef __has_feature
> > +#define HAVE_FEATURE(f) __has_feature(f)
> > +#else
> > +#define HAVE_FEATURE(f) 0
> > +#endif
> > +
> > static inline size_t hash_bits(size_t h, int bits)
> > {
> >       /* shuffle bits and return requested number of upper bits */
> > +#if defined(ADDRESS_SANITIZER) || HAVE_FEATURE(address_sanitizer)
>
> I am not very familiar with these features. Is address sanitizer same
> as undefined behavior sanitizer (mentioned in previous version)?

My preference would be to special case bits == 0 without the feature
guards as per the original change, this is the most correct. There is
some feature support for detecting ubsan:
https://github.com/google/sanitizers/issues/765
In my case I see this with address sanitizer and older versions of
clang don't expose ubsan as a feature.

> > +     /*
> > +      * If the requested bits == 0 avoid undefined behavior from a
> > +      * greater-than bit width shift right (aka invalid-shift-exponent).
> > +      */
> > +     if (bits == 0)
> > +             return -1;
>
> Shall we return 0 or -1 (0xffffffff) here?

The value isn't used and so doesn't matter. -1 seemed less likely to
silently succeed.

> Also, we have HASHMAP_MIN_CAP_BITS == 2. Shall we just make sure we
> never feed bits == 0 into hash_bits()?

I think that'd be a different change. I'd be happy to see it.

Thanks,
Ian

> Thanks,
> Song
>
>
> > +#endif
> > #if (__SIZEOF_SIZE_T__ == __SIZEOF_LONG_LONG__)
> >       /* LP64 case */
> >       return (h * 11400714819323198485llu) >> (__SIZEOF_LONG_LONG__ * 8 - bits);
> > --
> > 2.29.1.341.ge80a0c044ae-goog
> >
>
