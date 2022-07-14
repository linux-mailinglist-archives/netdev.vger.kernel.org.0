Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 299EA5744A8
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 07:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234972AbiGNFlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 01:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234007AbiGNFlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 01:41:23 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 225C229813;
        Wed, 13 Jul 2022 22:41:22 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id w12so978579edd.13;
        Wed, 13 Jul 2022 22:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=c1kF/TTLzT5LzCmiBcnfEvMrM2UU9ioJZbXOtvw7Ngc=;
        b=PLVg4YJD4D3tHJ5fpq7tNukiI0osz7Qe72gSm1urdtnVpYTXQbLqn6a6CP1FKwQ7hQ
         clmYmMd4X805VfVyMj+Y4cIsH5dVpH5a2872kIFLpiUe072ybNvCJTjJWc4+zpfLqoro
         jhFaoYOzmNxHdlJnXiuhrqvMYp/NRvQWYWCz5D8II9HRA9wKR1Y8LuT5MPbSlD6BQeym
         GneSRY4R0KiZpK9A5RM0U2D/AbcJfyg3TPuZs0t16vrV+/sEipZEIF1wPqDLAxJnWDUm
         nQvW8X4fBnDqv7fi5mcxzOmhzAdIK+AkvDjRRgcMv+k+GKwMrXzVpkIw9LjzfTuvkPC2
         B7Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=c1kF/TTLzT5LzCmiBcnfEvMrM2UU9ioJZbXOtvw7Ngc=;
        b=CpgwEQ/9B5U1r/5TO0AECK0H4Ate5PlUc/4O5P6EaV2SJYeLKpiclin5K/VL7YBGaQ
         OSx1iFBjBFILJtDIyHqeiDJnP9CRZu+3wUU130SergAgGAJlBDSPAtCP1Bj4ZM0Leobf
         CwfR2RdGSNG5IVlMDVMdyT1RM03JVJCrOkaqD5e3qn4fkjjkJeiVgLq3xfLWzOPscYj0
         qlECoqsOcXjoMPAIjCcuZ8tArm63gXUXUDauAVCuNnsKA+rHbtXamNCohYgQ4vDhe7+3
         82db9SMTVSuJFesPbplyoq2Jhl4fmsUisaTjh7CSJmkyv1pwZBgG4yGszuVUFdAvcR35
         qAyQ==
X-Gm-Message-State: AJIora9HYbAkkBLRmfjY761s8bJkjVUbLhEb0HtJ3AzgeH1IwuoDVieo
        88BHj7d5f/jlnmnxnj86aCfKASgL5drP3v+lt3E=
X-Google-Smtp-Source: AGRyM1vAXDdKvjb8sJp1xa5mxGIfmd6G+L6cSYpLMyv8twxQwRlGTzBfjkqgfwpKajjeemX4LL/LlY2lz6Nu8BjDvSA=
X-Received: by 2002:aa7:c784:0:b0:43a:caa8:75b9 with SMTP id
 n4-20020aa7c784000000b0043acaa875b9mr9750703eds.311.1657777280737; Wed, 13
 Jul 2022 22:41:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220713111430.134810-1-toke@redhat.com> <20220713111430.134810-17-toke@redhat.com>
In-Reply-To: <20220713111430.134810-17-toke@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 13 Jul 2022 22:41:09 -0700
Message-ID: <CAEf4BzaZL=fQrvPDGg+VVoWqRRLD0g-3jfeAbAb6M_zEa4nFMg@mail.gmail.com>
Subject: Re: [RFC PATCH 16/17] selftests/bpf: Add test for XDP queueing
 through PIFO maps
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Freysteinn Alfredsson <freysteinn.alfredsson@kau.se>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>
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

On Wed, Jul 13, 2022 at 4:15 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> This adds selftests for both variants of the generic PIFO map type, and f=
or
> the dequeue program type. The XDP test uses bpf_prog_run() to run an XDP
> program that puts packets into a PIFO map, and then adds tests that pull
> them back out again through bpf_prog_run() of a dequeue program, as well =
as
> by attaching a dequeue program to a veth device and scheduling transmissi=
on
> there.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  .../selftests/bpf/prog_tests/pifo_map.c       | 125 ++++++++++++++
>  .../bpf/prog_tests/xdp_pifo_test_run.c        | 154 ++++++++++++++++++
>  tools/testing/selftests/bpf/progs/pifo_map.c  |  54 ++++++
>  .../selftests/bpf/progs/test_xdp_pifo.c       | 110 +++++++++++++
>  4 files changed, 443 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/pifo_map.c
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_pifo_test_=
run.c
>  create mode 100644 tools/testing/selftests/bpf/progs/pifo_map.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_pifo.c
>

[...]

> +__u16 pkt_count =3D 0;
> +__u16 drop_above =3D 2;
> +
> +SEC("dequeue")

"dequeue" seems like a way too generic term, why not "xdp_dequeue" or
something like that? Isn't this XDP specific program?

> +void *dequeue_pifo(struct dequeue_ctx *ctx)
> +{
> +       __u64 prio =3D 0, pkt_prio =3D 0;
> +       void *data, *data_end;
> +       struct xdp_md *pkt;
> +       struct ethhdr *eth;
> +

[...]
