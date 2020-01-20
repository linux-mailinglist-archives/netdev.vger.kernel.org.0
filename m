Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 691E914343C
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 23:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbgATWvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 17:51:54 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:45160 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbgATWvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 17:51:54 -0500
Received: by mail-qk1-f193.google.com with SMTP id x1so831760qkl.12;
        Mon, 20 Jan 2020 14:51:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ajmJCdZ7vt+VPZfBmrgIG/mA7QlDp5yLMqlTnnsVq9E=;
        b=EiiNKi1nvvPTzNyaaXRtc2ehPV2mDNpabVjHDtoY+cPoH/8TWnCKvyAjjpgKdryDeW
         6LFTFLQa1joYMWmkjnrjo1ACVLevEZg86oyBe37jvXO4QSHSJQaaSI5mwRDaBPOPq8Lb
         EGen7xKj3vqv/zSaAXQzBaVRdP50Sq/8+CGkxTaILronnkDJDCPmKEN9QFUJQgadujQ3
         ka0B5PMTiFhQ7vSvLiwRciNqWI35TOiAUZ8Czot1YtX/ndxxbkyh4y93fFUH4MEld82e
         9omb3zUkYyxzAJ9UUK69qq8McwpphUDt7ujIKuM9mLbWakEiRtb+uYiXqvhQaafcaWUG
         AdKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ajmJCdZ7vt+VPZfBmrgIG/mA7QlDp5yLMqlTnnsVq9E=;
        b=oiYHAaloExMnkZ6PLhZZfQzI9LnhPoP/C38DKRRyHX9XRqBo3kB5ziKmlJimiBvlWg
         f3bersMoCQT+k1uRwuzJBFSYAehsZeLS+4mLNpa6l+blDVTE7Q7lm4AZQ+7dsbOHvYBB
         ABRt0NeQUIz7h/FkXNStTM55rtVUjgJx6M/n/YMD9fwXLGnxRuanYEgUNmzYf9ahMYNg
         g7A7tP5JQkBuhcuSMCu1um1L0RpEiZxMHV103UIgPH9ob6ZqV1+eUu6VNfqRReVB9x/Z
         CSX0Lwm8Hpcm9hvISU2pYpETaWvolgfNzkbDPg1T6VYk0a0vX/D5GmNk9BHBW/YCda9L
         VIcw==
X-Gm-Message-State: APjAAAU1hd7N83KjwPxQXsQYT2ZIrY8mCOyCOYqs7KZOKp3nbEtEpd1H
        CZJvTa/QepL+Y7age+RFQP4M4FerUOjrL1wma9o=
X-Google-Smtp-Source: APXvYqxD18ueFvVuZ2bvvxXYgWPW6De71zMBkm10ufJscKWn0NX9aBOiME5ZPt2eFgdewmGG/7fMGuKJ+V2coVDb3Uw=
X-Received: by 2002:a05:620a:5ae:: with SMTP id q14mr1854964qkq.437.1579560713004;
 Mon, 20 Jan 2020 14:51:53 -0800 (PST)
MIME-Version: 1.0
References: <20200118000657.2135859-1-ast@kernel.org> <20200118000657.2135859-3-ast@kernel.org>
In-Reply-To: <20200118000657.2135859-3-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 20 Jan 2020 14:51:42 -0800
Message-ID: <CAEf4BzaOhCqYbznPsnuScJx1qbnLJu+2SQfhMwfdq-tJx9k7gA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/3] libbpf: Add support for program extensions
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 17, 2020 at 4:47 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Add minimal support for program extensions. bpf_object_open_opts() needs to be
> called with attach_prog_fd = target_prog_fd and BPF program extension needs to
> have in .c file section definition like SEC("replace/func_to_be_replaced").
> libbpf will search for "func_to_be_replaced" in the target_prog_fd's BTF and
> will pass it in attach_btf_id to the kernel. This approach works for tests, but
> more compex use case may need to request function name (and attach_btf_id that
> kernel sees) to be more dynamic. Such API will be added in future patches.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  tools/include/uapi/linux/bpf.h |  1 +
>  tools/lib/bpf/bpf.c            |  3 ++-
>  tools/lib/bpf/libbpf.c         | 14 +++++++++++---
>  tools/lib/bpf/libbpf.h         |  2 ++
>  tools/lib/bpf/libbpf.map       |  2 ++
>  tools/lib/bpf/libbpf_probes.c  |  1 +
>  6 files changed, 19 insertions(+), 4 deletions(-)
>

[...]

>  enum bpf_attach_type
>  bpf_program__get_expected_attach_type(struct bpf_program *prog)
> @@ -6265,6 +6269,10 @@ static const struct bpf_sec_def section_defs[] = {
>                 .expected_attach_type = BPF_TRACE_FEXIT,
>                 .is_attach_btf = true,
>                 .attach_fn = attach_trace),
> +       SEC_DEF("replace/", EXT,

how about freplace/, similar to fentry/fexit?

> +               .expected_attach_type = 0,

no need, it will be zero, if not specified here

> +               .is_attach_btf = true,
> +               .attach_fn = attach_trace),
>         BPF_PROG_SEC("xdp",                     BPF_PROG_TYPE_XDP),
>         BPF_PROG_SEC("perf_event",              BPF_PROG_TYPE_PERF_EVENT),
>         BPF_PROG_SEC("lwt_in",                  BPF_PROG_TYPE_LWT_IN),

[...]
