Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4734D9B13
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 22:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388563AbfJPUJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 16:09:24 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:32881 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729175AbfJPUJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 16:09:24 -0400
Received: by mail-qt1-f194.google.com with SMTP id r5so38088666qtd.0;
        Wed, 16 Oct 2019 13:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=axDyeMHNOs8n9VJ6qSHCJll3Dt2OKehRDqeUlqAO/MU=;
        b=q0GsoJcU/89pTr0XopYbY2/IPlE+aV65lgIjW1JZ3Qgksrnf8V0+9IIQxDd6GXl4Fy
         LDlywO9BIIN1Sq7KZEwteyJf0xrB3rfneH0f91m+PosDtHj4m/Kkr9wyQHWIzvn7hk1v
         NmF3qlF6IgtpYTn7c0rzO5Zye9RE0/N918ZEnQdyoyb/TOtFbtXPa/6jWw41N8YWN9vB
         YFHLR59/o817wAJH6BOL5hjis0/wcYVpzVPsgcOZvscWBIdQKPPWPpKncZarAUSSEOYc
         XAXypiRGWuzmucLegePSQA+cba18uQVz3rNdX6uoQaPksGIP2z6ErUo5oYBL9+WFMMXa
         vHbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=axDyeMHNOs8n9VJ6qSHCJll3Dt2OKehRDqeUlqAO/MU=;
        b=lvV4oaDlafKcCavFmQ/TQ20DA4lH3DFVsoAwl62yjHdfLml7AXN8P5a/ipiyjimU/P
         qrt0RgV/QykmUPTpMgWquPoXPzIxiMfxGUUia88v6F2v0fd0sHtCAtpNxPTMMLQlTsF2
         /cE9G8LgWKPYSoYIlwh8b3q2EkixPlH8Xca70iNgo3oH1XwlbYBQB24Q4pjlkzQEaMRn
         96EhNCd3jfCDR5TydUHowKvCMQTHPH+Yr6Uio9J2fOk7sd3+z47ZRhf81gebn5LBBtoE
         /M7ZXAjyFyrSurZuMADe/mQ6TP6jlSO6OipTFJ4HzkfunaSawOuqG/n8OJmGV+RKVmQv
         NMRg==
X-Gm-Message-State: APjAAAXB2TdgXCR8LCq4ogHjOV6Z4yQm2UNQ6EOM0xHlgNx3rhzheAX1
        P3FrVKtAvGNtBdZ+RxsDHo+NhEHRGYT4dWhHVvv7NuWpiepJaA==
X-Google-Smtp-Source: APXvYqz5I0vTewkfI3CWOgHddJZCqowz+FT0hezXQZ/mzpqMIz7wAX2Lt66B3Bof3tJnJCe1RA4RejBPixXa2hpfjbY=
X-Received: by 2002:a05:6214:134d:: with SMTP id b13mr43000800qvw.228.1571256562381;
 Wed, 16 Oct 2019 13:09:22 -0700 (PDT)
MIME-Version: 1.0
References: <20191016032505.2089704-1-ast@kernel.org> <20191016032505.2089704-7-ast@kernel.org>
In-Reply-To: <20191016032505.2089704-7-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 16 Oct 2019 13:09:11 -0700
Message-ID: <CAEf4BzaPgVjPueC8X52k8J6huAi1aL-XZ-KHnbv6VPSmc2TXnA@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 06/11] bpf: implement accurate raw_tp context
 access via BTF
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>, x86@kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 4:16 AM Alexei Starovoitov <ast@kernel.org> wrote:
>
> libbpf analyzes bpf C program, searches in-kernel BTF for given type name
> and stores it into expected_attach_type.
> The kernel verifier expects this btf_id to point to something like:
> typedef void (*btf_trace_kfree_skb)(void *, struct sk_buff *skb, void *loc);
> which represents signature of raw_tracepoint "kfree_skb".
>
> Then btf_ctx_access() matches ctx+0 access in bpf program with 'skb'
> and 'ctx+8' access with 'loc' arguments of "kfree_skb" tracepoint.
> In first case it passes btf_id of 'struct sk_buff *' back to the verifier core
> and 'void *' in second case.
>
> Then the verifier tracks PTR_TO_BTF_ID as any other pointer type.
> Like PTR_TO_SOCKET points to 'struct bpf_sock',
> PTR_TO_TCP_SOCK points to 'struct bpf_tcp_sock', and so on.
> PTR_TO_BTF_ID points to in-kernel structs.
> If 1234 is btf_id of 'struct sk_buff' in vmlinux's BTF
> then PTR_TO_BTF_ID#1234 points to one of in kernel skbs.
>
> When PTR_TO_BTF_ID#1234 is dereferenced (like r2 = *(u64 *)r1 + 32)
> the btf_struct_access() checks which field of 'struct sk_buff' is
> at offset 32. Checks that size of access matches type definition
> of the field and continues to track the dereferenced type.
> If that field was a pointer to 'struct net_device' the r2's type
> will be PTR_TO_BTF_ID#456. Where 456 is btf_id of 'struct net_device'
> in vmlinux's BTF.
>
> Such verifier analysis prevents "cheating" in BPF C program.
> The program cannot cast arbitrary pointer to 'struct sk_buff *'
> and access it. C compiler would allow type cast, of course,
> but the verifier will notice type mismatch based on BPF assembly
> and in-kernel BTF.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  include/linux/bpf.h          |  17 +++-
>  include/linux/bpf_verifier.h |   4 +
>  kernel/bpf/btf.c             | 190 +++++++++++++++++++++++++++++++++++
>  kernel/bpf/verifier.c        |  88 +++++++++++++++-
>  kernel/trace/bpf_trace.c     |   2 +-
>  5 files changed, 296 insertions(+), 5 deletions(-)
>

Maybe it's just me reading this code for Nth time, but I find
btf_struct_access() much easier to follow now. Thanks!

Acked-by: Andrii Nakryiko <andriin@fb.com>

[...]

>  static void print_verifier_state(struct bpf_verifier_env *env,
>                                  const struct bpf_func_state *state)
>  {
> @@ -460,6 +480,8 @@ static void print_verifier_state(struct bpf_verifier_env *env,
>                         /* reg->off should be 0 for SCALAR_VALUE */
>                         verbose(env, "%lld", reg->var_off.value + reg->off);
>                 } else {
> +                       if (t == PTR_TO_BTF_ID)
> +                               verbose(env, "%s", kernel_type_name(reg->btf_id));
>                         verbose(env, "(id=%d", reg->id);

not related to specific changes in this patch set, just to bring this
up, but this extra id=%d part is quite confusing for register types
that shouldn't really have id associated with it. We should probably
add some filter here to print this only for ref-tracked register
types.

>                         if (reg_type_may_be_refcounted_or_null(t))
>                                 verbose(env, ",ref_obj_id=%d", reg->ref_obj_id);
> @@ -2337,10 +2359,12 @@ static int check_packet_access(struct bpf_verifier_env *env, u32 regno, int off,
>
>  /* check access to 'struct bpf_context' fields.  Supports fixed offsets only */
>  static int check_ctx_access(struct bpf_verifier_env *env, int insn_idx, int off, int size,

[...]
