Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA546273EC9
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 11:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgIVJqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 05:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbgIVJqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 05:46:53 -0400
Received: from mail-oo1-xc44.google.com (mail-oo1-xc44.google.com [IPv6:2607:f8b0:4864:20::c44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FAA6C061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 02:46:53 -0700 (PDT)
Received: by mail-oo1-xc44.google.com with SMTP id 4so3975996ooh.11
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 02:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J0fKPHQOq7nlQegaEc46x32IDCd4+rwSk8MOWrazdeE=;
        b=x1r8u5eMFLgm6eFdMyMif1ABwP1dPScFWX9SMPncFWRdWBtmilPSeN2dMDhNFyfyff
         k2rM1Pe+1UgcSM5CZHGMb90pAPP0BzS7WSYKLC///3x7b7an6v0cyx9BvmsIuEfo4Hdn
         rGY39nH4bqs2krkhJsBUYd09kNYGG/u4Onfbg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J0fKPHQOq7nlQegaEc46x32IDCd4+rwSk8MOWrazdeE=;
        b=ssuli8prrDZrPTlOUcTt51hqoflIkvmZVZFSTalu5Hi0yiaeCq1dN7g5t9n1GklGNL
         Cr0BKcrKJoVsfp2OhFIOrShGKABf9aXpIT6FJkSoDaDK/r8s9kwtloI/Z7EW8Z7/47Xz
         CF0574SKbBAoV9ZcJtlQYjoE85fALg8AkRPeMi34Kz5K45fxcZg661SLNtNvj83py/dj
         6+jmsgXXa1PEc55H4bTTxrTmN+RT3g3p6I/RRYc7BtotA9uKmEt0GBHHc2lA00hWwV1X
         pjNJ9sM3ksK6k3FobFJ7QgTxRIlyp0aOnTr3SVvTHmJK2P/L5JxAMjpkUW/d0yMRRBGN
         OOUg==
X-Gm-Message-State: AOAM531RCXTWv/CgelJv6sQFAikiaxloxlM6VwVGsMyKtFGKO/3CoaIV
        SyMb66EAd33RlMnDSAUhczDpaQD98m1jXtQBvlmqY3F/e10=
X-Google-Smtp-Source: ABdhPJyhzL3/w1TXiNT0Yr3c6AdYTZrhjvBtCXXisVcgysAOgbvs1wFQL7gibDq9NC0VzEJe7xxUaOxQa/sHacjS43c=
X-Received: by 2002:a4a:3516:: with SMTP id l22mr2387279ooa.6.1600768012836;
 Tue, 22 Sep 2020 02:46:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200922070409.1914988-1-kafai@fb.com> <20200922070422.1917351-1-kafai@fb.com>
In-Reply-To: <20200922070422.1917351-1-kafai@fb.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Tue, 22 Sep 2020 10:46:41 +0100
Message-ID: <CACAyw9-LoKFuYxaMODtacJM-rOR0P5Y=j_yEm9bsFZe_j_9rYQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 02/11] bpf: Enable bpf_skc_to_* sock casting
 helper to networking prog type
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Sep 2020 at 08:04, Martin KaFai Lau <kafai@fb.com> wrote:
>
> There is a constant need to add more fields into the bpf_tcp_sock
> for the bpf programs running at tc, sock_ops...etc.
>
> A current workaround could be to use bpf_probe_read_kernel().  However,
> other than making another helper call for reading each field and missing
> CO-RE, it is also not as intuitive to use as directly reading
> "tp->lsndtime" for example.  While already having perfmon cap to do
> bpf_probe_read_kernel(), it will be much easier if the bpf prog can
> directly read from the tcp_sock.
>
> This patch tries to do that by using the existing casting-helpers
> bpf_skc_to_*() whose func_proto returns a btf_id.  For example, the
> func_proto of bpf_skc_to_tcp_sock returns the btf_id of the
> kernel "struct tcp_sock".
>
> These helpers are also added to is_ptr_cast_function().
> It ensures the returning reg (BPF_REF_0) will also carries the ref_obj_id.
> That will keep the ref-tracking works properly.
>
> The bpf_skc_to_* helpers are made available to most of the bpf prog
> types in filter.c. They are limited by perfmon cap.
>
> This patch adds a ARG_PTR_TO_BTF_ID_SOCK_COMMON.  The helper accepting
> this arg can accept a btf-id-ptr (PTR_TO_BTF_ID + &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON])
> or a legacy-ctx-convert-skc-ptr (PTR_TO_SOCK_COMMON).  The bpf_skc_to_*()
> helpers are changed to take ARG_PTR_TO_BTF_ID_SOCK_COMMON such that
> they will accept pointer obtained from skb->sk.
>
> PTR_TO_*_OR_NULL is not accepted as an ARG_PTR_TO_BTF_ID_SOCK_COMMON
> at verification time.  All PTR_TO_*_OR_NULL reg has to do a NULL check
> first before passing into the helper or else the bpf prog will be
> rejected by the verifier.
>
> [ ARG_PTR_TO_SOCK_COMMON_OR_NULL was attempted earlier.  The _OR_NULL was
>   needed because the PTR_TO_BTF_ID could be NULL but note that a could be NULL
>   PTR_TO_BTF_ID is not a scalar NULL to the verifier.  "_OR_NULL" implicitly
>   gives an expectation that the helper can take a scalar NULL which does
>   not make sense in most (except one) helpers.  Passing scalar NULL
>   should be rejected at the verification time.

What is the benefit of requiring a !sk check from the user if all of
the helpers know how to deal with a NULL pointer?

>
>   Thus, this patch uses ARG_PTR_TO_BTF_ID_SOCK_COMMON to specify that the
>   helper can take both the btf-id ptr or the legacy PTR_TO_SOCK_COMMON but
>   not scalar NULL.  It requires the func_proto to explicitly specify the
>   arg_btf_id such that there is a very clear expectation that the helper
>   can handle a NULL PTR_TO_BTF_ID. ]

I think ARG_PTR_TO_BTF_ID_SOCK_COMMON is actually a misnomer, since
nothing enforces that arg_btf_id is actually an ID for sock common.
This is where ARG_PTR_TO_SOCK_COMMON_OR_NULL is much easier to
understand, even though it's more permissive than it has to be. It
communicates very clearly what values the argument can take.

If you're set on ARG_PTR_TO_BTF_ID_SOCK_COMMON I'd suggest forcing the
btf_id in struct bpf_reg_types. This avoids the weird case where the
btf_id doesn't actually point at sock_common, and it also makes my
life easier for sockmap update from iter, as mentioned in the other
email.

--
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
