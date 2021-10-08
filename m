Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60AE9427142
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 21:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241341AbhJHTPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 15:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241419AbhJHTPW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 15:15:22 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40187C061755;
        Fri,  8 Oct 2021 12:13:27 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id s4so23259633ybs.8;
        Fri, 08 Oct 2021 12:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=azE89RLfRukcom0ZQIwpheBmmB3Xm5sAb5WllB2UjYs=;
        b=FYjZ+7nDYSG040XR3QxbpYuUVjgZXmqHxdzswTN2OOP9D2E9iyXI1iXGD10gx9ax4+
         ya5Euqx37jMom1frPl/oK7bnMcV3xTSw4y3JeLC0yLNwU9YRroTaOdKd2WfF8h9sVcw0
         UgfnOed97wl68y4QE7BDW6WEk6TU08iUMaLyFynaUvlR3M/3QfH8qirAJ0gqaq2gFmUw
         vzFQ+HbeI5Z7WaKRVI7AGyLWpqm5gS7C9+J5nr9COzZPVyM9S44OVChI3QFvM6pKHvvn
         qFBjHMTtLdVynsZuwWQeSfXVKrnORRAbMsJhT3731nVe88iWMkDdd6ULXLMuHyNRFnzw
         YpCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=azE89RLfRukcom0ZQIwpheBmmB3Xm5sAb5WllB2UjYs=;
        b=HqHRmcv1LPazIy8C0w/0obiXN8af3al7UeLpvO2dmmIMC1qH5OBQDA2wQZkg+BUlDT
         /OLbY6VM+lvllXSZ72BEulp2iLpkoVHgMSt94EKRE2BQuU6qRNkT71i74pA6iO4hCgwk
         5Xah7XqUuLDDcehfpN8PM7oi0wwjjKmQCpJFjG2Y1YQLj9WM2yjGPHXO76KU2up+e79a
         Erm0rjWcUy2qRXq4Yk97e57wM41Kg+P9TXn9FtlZ21x83kvXSM/NIiIWpD9Fb03/7K4c
         Ayv4UZXRq+BqQEXDF8nD7kDZdlGYEykvry96VoqB4SDKA3OQQn7VCoI31ex+8SME/Aec
         1cYw==
X-Gm-Message-State: AOAM532zQn7m3cfUIJzyQhTyEZm0MAVaE+yBTSGnSIgP4pGnhlp3HngN
        XDUIJ2QJql1yjQyJ1irzD+LkP5FqZJ1pkPYmELmmGn6MzS0=
X-Google-Smtp-Source: ABdhPJz+Fo16rAB1Hy3soSHxYwt+HIjLM8Iz+HZgTmIsZWwH79PuyC6uCmQl294FNrjhuFVx/JIj+LR1/EYWE+GBVVY=
X-Received: by 2002:a25:1884:: with SMTP id 126mr5413591yby.114.1633720406428;
 Fri, 08 Oct 2021 12:13:26 -0700 (PDT)
MIME-Version: 1.0
References: <20211007194438.34443-1-quentin@isovalent.com> <20211007194438.34443-2-quentin@isovalent.com>
In-Reply-To: <20211007194438.34443-2-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 Oct 2021 12:13:15 -0700
Message-ID: <CAEf4BzY7BF=5jHDPBj=Z7tpsPd5YbK=n4SfgfuCwh_JZfyZCDA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 01/12] libbpf: skip re-installing headers file
 if source is older than target
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 7, 2021 at 12:44 PM Quentin Monnet <quentin@isovalent.com> wrote:
>
> The "install_headers" target in libbpf's Makefile would unconditionally
> export all API headers to the target directory. When those headers are
> installed to compile another application, this means that make always
> finds newer dependencies for the source files relying on those headers,
> and deduces that the targets should be rebuilt.
>
> Avoid that by making "install_headers" depend on the source header
> files, and (re-)install them only when necessary.
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>  tools/lib/bpf/Makefile | 24 ++++++++++++++++--------
>  1 file changed, 16 insertions(+), 8 deletions(-)
>
> diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> index 41e4f78dbad5..a92d3b9692a8 100644
> --- a/tools/lib/bpf/Makefile
> +++ b/tools/lib/bpf/Makefile
> @@ -241,15 +241,23 @@ install_lib: all_cmd
>                 $(call do_install_mkdir,$(libdir_SQ)); \
>                 cp -fpR $(LIB_FILE) $(DESTDIR)$(libdir_SQ)
>
> -INSTALL_HEADERS = bpf.h libbpf.h btf.h libbpf_common.h libbpf_legacy.h xsk.h \
> -                 bpf_helpers.h $(BPF_GENERATED) bpf_tracing.h               \
> -                 bpf_endian.h bpf_core_read.h skel_internal.h               \
> -                 libbpf_version.h
> +SRC_HDRS := bpf.h libbpf.h btf.h libbpf_common.h libbpf_legacy.h xsk.h        \
> +           bpf_helpers.h bpf_tracing.h bpf_endian.h bpf_core_read.h           \
> +           skel_internal.h libbpf_version.h
> +GEN_HDRS := $(BPF_GENERATED)
> +INSTALL_SRC_HDRS := $(addprefix $(DESTDIR)$(prefix)/include/bpf/,$(SRC_HDRS))
> +INSTALL_GEN_HDRS := $(addprefix $(DESTDIR)$(prefix)/include/bpf/, \
> +                               $(notdir $(GEN_HDRS)))

I've added INSTALL_PFX := $(DESTDIR)$(prefix)/include/bpf and used it
where possible

> +$(INSTALL_SRC_HDRS): $(DESTDIR)$(prefix)/include/bpf/%.h: %.h
> +       $(call QUIET_INSTALL, $@) \
> +               $(call do_install,$<,$(prefix)/include/bpf,644)
> +$(INSTALL_GEN_HDRS): $(DESTDIR)$(prefix)/include/bpf/%.h: $(OUTPUT)%.h
> +       $(call QUIET_INSTALL, $@) \
> +               $(call do_install,$<,$(prefix)/include/bpf,644)
>
> -install_headers: $(BPF_GENERATED)
> -       $(call QUIET_INSTALL, headers)                                       \
> -               $(foreach hdr,$(INSTALL_HEADERS),                            \
> -                       $(call do_install,$(hdr),$(prefix)/include/bpf,644);)
> +INSTALL_HEADERS := $(INSTALL_SRC_HDRS) $(INSTALL_GEN_HDRS)

I felt like INSTALL_HEADERS just adds one more indirection and
otherwise is not useful, so I dropped it and inlined
$(INSTALL_SRC_HDRS) $(INSTALL_GEN_HDRS) below


> +
> +install_headers: $(BPF_GENERATED) $(INSTALL_HEADERS)
>
>  install_pkgconfig: $(PC_FILE)
>         $(call QUIET_INSTALL, $(PC_FILE)) \
> --
> 2.30.2
>
