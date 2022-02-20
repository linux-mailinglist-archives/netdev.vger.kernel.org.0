Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF5014BCB6A
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 01:50:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234450AbiBTAuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 19:50:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbiBTAuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 19:50:23 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A75AF4704F;
        Sat, 19 Feb 2022 16:50:03 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id d19so1450816ioc.8;
        Sat, 19 Feb 2022 16:50:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OH4rp73xFGXlis0xCwWIn46+nuRPJj/iv3AazmDMQPs=;
        b=LOZsHZ+TaR7BS7x3SAX8VTJQFrR9mNyhk+U3YmEhLDw8+pKPavFpAvPx5MpLkSU5NQ
         BR04k46q4oK2YB1bv0SHOrTF7XRdv7y8LlTeIV6teHX4pPrDc3z0pyHyJ7PSlvxuw0Je
         XLOlVxFhrTVp3zvGlg96CqT1lrDWE1JlUEMyWf94AS01ZrLAEo0sBhN+75k1bWuzJ6nZ
         PNjGv6yhKiVoGv89/HSQORo+WMgKlu7y2MTY2rfbE6Vwu1IN71iVlDXtdmWlrVgR0jPm
         Ll20JzfekWIJXNf1xK9izK9GPhDbNAnhTCrTZGMHUNYEZL6xSwhiSSzqnVJvOBbBwim5
         ZMXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OH4rp73xFGXlis0xCwWIn46+nuRPJj/iv3AazmDMQPs=;
        b=zXRtnKxA799kqrmVsAWhYksgTpoCs/XHlsafaiZTVg22KxVsnwTnp0ZdHaxuR/WgVp
         kV4PKgoXwCQ2SgJtUHOORKDkJrEFlBuSkEikhJx50q2PuVJYwfKk5l2QhhtsRjUb3ihN
         7pGtPXyHwTmmIkRy/i6sBnYQtER+Gx4d2/tNmEGuBHWIEYo8nhVKOawwHHK0VCX1sX0n
         YGNl1apZCb7S7OzHpkmHUa8YMYWWFqM5rhkWM4amcsObF4BdwFux/Swm1bZKQXiyH6tm
         7HISfNNDp8am7ioRrodYRcE+rWqE1argEBE+JsAL3uH2pEUtKeD4q557+xCtSxnPTZRH
         bliQ==
X-Gm-Message-State: AOAM531U5QDimH7idmvtRktKyMoyXl603hN9PsWlcfg/twUamG55AG3a
        GIIVZZw/oKMjl2Y2boAZyRgak26FEaHHRPUIcS989H9Mr2c=
X-Google-Smtp-Source: ABdhPJy8kT+IIeEOefE7W+Y0hqUzNF5ZAnOKfakTbw4AnJhKFzzCUAv8BR0s9WSRENnjP/XmZSXb2Xx4SCDCC6HWaYM=
X-Received: by 2002:a05:6602:210c:b0:640:7616:d93a with SMTP id
 x12-20020a056602210c00b006407616d93amr7388327iox.154.1645318202985; Sat, 19
 Feb 2022 16:50:02 -0800 (PST)
MIME-Version: 1.0
References: <20220218203906.317687-1-mauricio@kinvolk.io> <0958851a-2ff7-d51c-0e90-1c3e04207529@iogearbox.net>
In-Reply-To: <0958851a-2ff7-d51c-0e90-1c3e04207529@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 19 Feb 2022 16:49:52 -0800
Message-ID: <CAEf4BzaxQ029c8ofsq7PLWJX8xXVO0xDrnF908+6kXF7yQnGow@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpftool: Remove usage of reallocarray()
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?UTF-8?Q?Mauricio_V=C3=A1squez?= <mauricio@kinvolk.io>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 18, 2022 at 3:30 PM Daniel Borkmann <daniel@iogearbox.net> wrot=
e:
>
> On 2/18/22 9:39 PM, Mauricio V=C3=A1squez wrote:
> > This commit fixes a compilation error on systems with glibc < 2.26 [0]:
> >
> > ```
> > In file included from main.h:14:0,
> >                   from gen.c:24:
> > linux/tools/include/tools/libc_compat.h:11:21: error: attempt to use po=
isoned "reallocarray"
> >   static inline void *reallocarray(void *ptr, size_t nmemb, size_t size=
)
> > ```
> >
> > This happens because gen.c pulls <bpf/libbpf_internal.h>, and then
> > <tools/libc_compat.h> (through main.h). When
> > COMPAT_NEED_REALLOCARRAY is set, libc_compat.h defines reallocarray()
> > which libbpf_internal.h poisons with a GCC pragma.
> >
> > This follows the same approach of libbpf in commit
> > 029258d7b228 ("libbpf: Remove any use of reallocarray() in libbpf").
> >
> > Reported-by: Quentin Monnet <quentin@isovalent.com>
> > Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> >
> > [0]: https://lore.kernel.org/bpf/3bf2bd49-9f2d-a2df-5536-bc0dde70a83b@i=
sovalent.com/
> [...]
> > + * Copied from tools/lib/bpf/libbpf_internal.h
> > + */
> > +static inline void *bpftool_reallocarray(void *ptr, size_t nmemb, size=
_t size)
> > +{
> > +     size_t total;
> > +
> > +#if __has_builtin(__builtin_mul_overflow)
> > +     if (unlikely(__builtin_mul_overflow(nmemb, size, &total)))
> > +             return NULL;
> > +#else
> > +     if (size =3D=3D 0 || nmemb > ULONG_MAX / size)
> > +             return NULL;
> > +     total =3D nmemb * size;
> > +#endif
> > +     return realloc(ptr, total);
> > +}
>
> Can't we just reuse libbpf_reallocarray() given we copy over libbpf_inter=
nal.h
> anyway via a9caaba399f9 ("bpftool: Implement "gen min_core_btf" logic")?
>

yep, no need to reimplement it

> Thanks,
> Daniel
