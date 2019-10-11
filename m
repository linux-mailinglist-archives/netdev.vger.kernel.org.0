Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52EF8D4730
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 20:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728684AbfJKSHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 14:07:16 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:40617 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728470AbfJKSHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 14:07:16 -0400
Received: by mail-qt1-f195.google.com with SMTP id m61so15121126qte.7;
        Fri, 11 Oct 2019 11:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=grPvILjjTSts3F2ebsanHMEOleQNYWgAjVhWVmyJzyU=;
        b=Cv2O0McuBCvrCbRnZQ3K0aE1V2LyIQSVUMpOPrqJm5GVv6Wwtc8JKDSMzrU/g6qg3R
         HfeJxD5EFycVs4SYSrO8uZtPcnGvm/ruaURT58gkdfgOkO4XUcmoUzaV0yTCxGNe3pFw
         CWEdZHUqGUIIYuQ10wGbF7SFCAIoYBMjCnU3j9KGpewYIxkO6+hFcenRLnYiKWkFCHgF
         XCFG4PoHedXquubsqFLr186BprJ8GRG1RPF21PvY4Ngwk0cdOCGlkfG751iN2kzLROPf
         TQx/8M6i6NLlxY3JtR2bLv3/NFwGx38G3oCcA5mZybfrelKOOqI1mX8ZsOneu6pAbcTH
         t+BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=grPvILjjTSts3F2ebsanHMEOleQNYWgAjVhWVmyJzyU=;
        b=J0YXtWyqdLkCIfChpUvOLndSMx0/0bGcK3o3+09FBH78zgqe1/d1yHUzMjc8tgIQQK
         AbZQyDgoL/MJGGjRQDeYCzIJqPGF2fm0m5uaCJplKwQUM6GLRMWQ5Ic22d2/XObw1P+r
         /6JcsEgxYIlCgUbr5xO21UFjghgQB2RScWjn50l3OWjAczz7v40EwmEoDTKuL9dSbqSC
         cHXAxIhDRV93YFxVh9Kqm/v7mvPYN6fNrOtvqVvTdJjN+2CLYVMEf+vIu4nFuN31QkRm
         cfOCQJRuDMAjlq+FraVA0BdcwlPF+Ul2O+CEiWox+eBy7sAdKTONasqcmN6FEdm36Tnb
         ULSQ==
X-Gm-Message-State: APjAAAVyTpvJ4/WiTCnMo8BYonOr5TPCXQEkxffyFb99VDV2JsgJKw9i
        iameD2S6clFN69srS8xd7176qr+fT5Bm1BFE4to=
X-Google-Smtp-Source: APXvYqzpkIJspHj13aQUuBs4RJCXFPqOc07lwNxbH75XdS+KSyaPtev47Zc7dbZzu7kCw2/J5DVBctbGXO+IVKDp728=
X-Received: by 2002:ac8:1242:: with SMTP id g2mr18049452qtj.141.1570817235045;
 Fri, 11 Oct 2019 11:07:15 -0700 (PDT)
MIME-Version: 1.0
References: <20191010041503.2526303-1-ast@kernel.org> <20191010041503.2526303-6-ast@kernel.org>
In-Reply-To: <20191010041503.2526303-6-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 11 Oct 2019 11:07:03 -0700
Message-ID: <CAEf4BzZxQDUzYYjF091135d+O_fwZVdK9Dqw5H4_z=5QBqueYg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 05/12] libbpf: auto-detect btf_id of raw_tracepoint
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

On Wed, Oct 9, 2019 at 9:17 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> For raw tracepoint program types libbpf will try to find
> btf_id of raw tracepoint in vmlinux's BTF.
> It's a responsiblity of bpf program author to annotate the program
> with SEC("raw_tracepoint/name") where "name" is a valid raw tracepoint.
> If "name" is indeed a valid raw tracepoint then in-kernel BTF
> will have "btf_trace_##name" typedef that points to function
> prototype of that raw tracepoint. BTF description captures
> exact argument the kernel C code is passing into raw tracepoint.
> The kernel verifier will check the types while loading bpf program.
>
> libbpf keeps BTF type id in expected_attach_type, but since
> kernel ignores this attribute for tracing programs copy it
> into attach_btf_id attribute before loading.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  tools/lib/bpf/bpf.c    |  3 +++
>  tools/lib/bpf/libbpf.c | 17 +++++++++++++++++
>  2 files changed, 20 insertions(+)
>
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index cbb933532981..79046067720f 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -228,6 +228,9 @@ int bpf_load_program_xattr(const struct bpf_load_program_attr *load_attr,
>         memset(&attr, 0, sizeof(attr));
>         attr.prog_type = load_attr->prog_type;
>         attr.expected_attach_type = load_attr->expected_attach_type;
> +       if (attr.prog_type == BPF_PROG_TYPE_RAW_TRACEPOINT)
> +               /* expected_attach_type is ignored for tracing progs */
> +               attr.attach_btf_id = attr.expected_attach_type;
>         attr.insn_cnt = (__u32)load_attr->insns_cnt;
>         attr.insns = ptr_to_u64(load_attr->insns);
>         attr.license = ptr_to_u64(load_attr->license);
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index a02cdedc4e3f..8bf30a67428c 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -4586,6 +4586,23 @@ int libbpf_prog_type_by_name(const char *name, enum bpf_prog_type *prog_type,
>                         continue;
>                 *prog_type = section_names[i].prog_type;
>                 *expected_attach_type = section_names[i].expected_attach_type;
> +               if (*prog_type == BPF_PROG_TYPE_RAW_TRACEPOINT) {
> +                       struct btf *btf = bpf_core_find_kernel_btf();
> +                       char raw_tp_btf_name[128] = "btf_trace_";
> +                       char *dst = raw_tp_btf_name + sizeof("btf_trace_") - 1;
> +                       int ret;
> +
> +                       if (IS_ERR(btf))
> +                               /* lack of kernel BTF is not a failure */
> +                               return 0;
> +                       /* prepend "btf_trace_" prefix per kernel convention */
> +                       strncat(dst, name + section_names[i].len,
> +                               sizeof(raw_tp_btf_name) - (dst - raw_tp_btf_name));
> +                       ret = btf__find_by_name(btf, raw_tp_btf_name);
> +                       if (ret > 0)
> +                               *expected_attach_type = ret;

Well, actually, I realized after I gave Acked-by, so not yet :)

This needs kernel feature probe of whether kernel supports specifying
attach_btf_id, otherwise on older kernels we'll stop successfully
loading valid program.

But even if kernel supports attach_btf_id, I think users still need to
opt in into specifying attach_btf_id by libbpf. Think about existing
raw_tp programs that are using bpf_probe_read() because they were not
created with this kernel feature in mind. They will suddenly stop
working without any of user's fault.

One way to do this would be another section prefix for raw tracepoint
w/ BTF. E.g., "raw_tp_typed" or something along those lines? I'll say
it upfront, I don't think "raw_tp_btf" is great name, because we rely
on BTF for a lot of other stuff already, so just adding _btf prefix
doesn't mean specifically BTF type tracking in kernel ;)

> +                       btf__free(btf);
> +               }
>                 return 0;
>         }
>         pr_warning("failed to guess program type based on ELF section name '%s'\n", name);
> --
> 2.23.0
>
