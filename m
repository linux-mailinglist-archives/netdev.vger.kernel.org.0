Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2C3413B640
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 00:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728824AbgANX4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 18:56:37 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:38197 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728757AbgANX4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 18:56:36 -0500
Received: by mail-qk1-f194.google.com with SMTP id k6so14043823qki.5;
        Tue, 14 Jan 2020 15:56:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sBoLbsrAcJX5Rm20aXcvi5zOzlyubVt1ro5/8XU6Ufw=;
        b=mTehY0Pz+FkijsJZlgNzhJe108rkEBKwT/hfEBrQ8purILrJ5wok6VqSoandP4GlaL
         xPOc9+3RWqYPMkXVixt2vlfJCOE730m9plkmPHdKBxvjb4CS20tr+lKoZT3cExzc/a4q
         dKMsaT8riRxi3g45zvrjMbOB+C2AHxVWAr8bZTbXVr+ClO0+BJ/4exPQ9uUyBAfrTulD
         lZQhItz0KbJuBeqdeZ+CfszUjcUNuPixTDHuRaTtuPk/kETv4I85v6qjVjhSDYW48Dlg
         ilgOtS2ELbDIKMplipD6yrvNY0kcnJkGeKs4RanYD1jYXh87McJgetQadAlOtv9uBsos
         ptlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sBoLbsrAcJX5Rm20aXcvi5zOzlyubVt1ro5/8XU6Ufw=;
        b=Fg+EMOusLIACv6M9I1G6wEfbHcjXCdgZN4Am6RmUIS/kGtp0uNEdkXbTQcu44LL4mo
         k5i3LDXMUe8ugWAslytam3au4C6FrQ4/+nVpVQkY8W+LJd6pOVdDdymarkySfCt+cuTX
         KnSPRv5BpOMoWbso/WOunhW+HARh9gUSLw8rwIihToGh9IcUTdsMV7uwzP9Lt/6bedqa
         7WzelvR0iWi1fSqehIXpyeen13a5Z/VWLKxOAguGCMAWBwwJxF/OA5Jo2vYFfG1qhUVp
         TcXFvIeC4vqPYzl4faGwPf7mndGtPyAN7AduaE6oF4vMmmRX0NxJEzCe7us9iH8O5aj4
         vH7Q==
X-Gm-Message-State: APjAAAVBGuz8kFNvxC+dV8OpVzY2A9UDMZ3zruSjJ1/lasoFNB/PG4Hw
        COjXHqYokB+kgFVOhjQrKWiSh5lBSRq4DcXMjdw=
X-Google-Smtp-Source: APXvYqwoGLMpkAxVfcRdU4EWEJf7PqNURqhJDulANv6FlPgvKCAv60pR3cquP4H/EH2LFAG5PL5cg1ITv6cS798/SDU=
X-Received: by 2002:a37:e408:: with SMTP id y8mr24477194qkf.39.1579046195610;
 Tue, 14 Jan 2020 15:56:35 -0800 (PST)
MIME-Version: 1.0
References: <20200108072538.3359838-1-ast@kernel.org> <20200108072538.3359838-4-ast@kernel.org>
 <20200114233904.GA2308546@mini-arch>
In-Reply-To: <20200114233904.GA2308546@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 14 Jan 2020 15:56:24 -0800
Message-ID: <CAEf4BzZUNKAT87UUQ9DKe8TvGG54PPDV-jPuK-J+Jx46Tm1oUA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/6] bpf: Introduce function-by-function verification
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 14, 2020 at 3:39 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 01/07, Alexei Starovoitov wrote:
> > New llvm and old llvm with libbpf help produce BTF that distinguish global and
> > static functions. Unlike arguments of static function the arguments of global
> > functions cannot be removed or optimized away by llvm. The compiler has to use
> > exactly the arguments specified in a function prototype. The argument type
> > information allows the verifier validate each global function independently.
> > For now only supported argument types are pointer to context and scalars. In
> > the future pointers to structures, sizes, pointer to packet data can be
> > supported as well. Consider the following example:
> > --- a/kernel/bpf/btf.c
> > +++ b/kernel/bpf/btf.c
> > @@ -2621,8 +2621,8 @@ static s32 btf_func_check_meta(struct btf_verifier_env *env,
> >               return -EINVAL;
> >       }
> >
> > -     if (btf_type_vlen(t)) {
> > -             btf_verifier_log_type(env, t, "vlen != 0");
> > +     if (btf_type_vlen(t) > BTF_FUNC_EXTERN) {
> > +             btf_verifier_log_type(env, t, "invalid func linkage");
> >               return -EINVAL;
> Sorry for bringing it up after the review:
>
> This effectively teaches kernel about BTF_KIND_FUNC scope argument,
> right? Which means, if I take clang from the tip
> (https://github.com/llvm/llvm-project/commit/fbb64aa69835c8e3e9efe0afc8a73058b5a0fb3c#diff-f191c05d1eb0a6ca0e89d7e7938d73d4)
> and take 5.4 kernel, it will reject BTF because it now has a
> BTF_KIND_FUNC with global scope (any 'main' function is global and has
> non-zero vlen).
>
> What's the general guidance on the situation where clang starts
> spitting out some BTF and released kernels reject it? Is there some list of
> flags I can pass to clang to not emit some of the BTF features?
> Or am I missing something?

Isn't that the issue that 2d3eb67f64ec ("libbpf: Sanitize global
functions") addresses by sanitizing those BTF_KIND_FUNC as static
functions (with vlen=0)?

The general guidance is to have libbpf sanitize such BTF to make it
compatible with old kernels.
