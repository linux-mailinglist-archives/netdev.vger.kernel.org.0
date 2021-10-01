Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CACF41F819
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 01:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbhJAXP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 19:15:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230009AbhJAXP2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 19:15:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A19161A3A;
        Fri,  1 Oct 2021 23:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633130023;
        bh=us9r4OlZBEJcDwfaANwYYNPzbpNqIU8fPZetJ2SbwPo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=kYctJxWrK1yIZOy8v6fWE/apKZ8jDAO+5g7ImYppbJCBLWHP+XZN1A9rrqqCKfZzA
         9+B79Uedm9cs02IgF8l7bNCPRuYstGMJ0zcVPj3NLIPTgX0zSOeAZa7Ir2z/UFJjvU
         zu3kmaqc7KdpwX7dtGp2PRS8sBIxtkVaRFll8czX+PFZjOgBjzHJMfHbjvj9C48ciG
         ah9r/XaYpLtZJa2bHPCngo3Cdt29WlcAtcfSJL+zlvTDG80Es3unONMe96H5+pd6vx
         DrI9BWg23wulYdATaN31YfEYHcxMKZRrDRJQ9CDD7nni4AtZP6tg1KLfIvzgWIaHQY
         7bYxzZ9XkeGHQ==
Received: by mail-lf1-f50.google.com with SMTP id m3so43906718lfu.2;
        Fri, 01 Oct 2021 16:13:43 -0700 (PDT)
X-Gm-Message-State: AOAM533wAWf1UMLQceQxRx4XvyrsFbCn/xyTt3KzwPMnAFIoG6bfBsV9
        Bl3kYWZVkJcKSSP7xmYT4yFdXaB40dYSkv7r/fI=
X-Google-Smtp-Source: ABdhPJxrvh8lT1hZBYaSDwk3Fs4OiYqTlXecGnWlRBnC/M+EKv+4c5a44c+eHQwZPwjbcdwAIpv7UbYQt08wnZSjLv4=
X-Received: by 2002:ac2:5617:: with SMTP id v23mr768187lfd.114.1633130021799;
 Fri, 01 Oct 2021 16:13:41 -0700 (PDT)
MIME-Version: 1.0
References: <20211001215858.1132715-1-joannekoong@fb.com> <20211001215858.1132715-4-joannekoong@fb.com>
In-Reply-To: <20211001215858.1132715-4-joannekoong@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 1 Oct 2021 16:13:30 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6CU+1qbt+dvT2m_Ys+3517e0DQ1wWCcJfgAWf6oRzGxA@mail.gmail.com>
Message-ID: <CAPhsuW6CU+1qbt+dvT2m_Ys+3517e0DQ1wWCcJfgAWf6oRzGxA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 3/3] bpf/selftests: Add xdp
 bpf_load_tcp_hdr_options tests
To:     Joanne Koong <joannekoong@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 1, 2021 at 3:04 PM Joanne Koong <joannekoong@fb.com> wrote:
>
> This patch adds tests for bpf_load_tcp_hdr_options used by xdp
> programs.
>
> test_xdp_tcp_hdr_options.c:
> - Tests ipv4 and ipv6 packets with TCPOPT_EXP and non-TCPOPT_EXP
> tcp options set. Verify that options can be parsed and loaded
> successfully.
> - Tests error paths: TCPOPT_EXP with invalid magic, option with
> invalid kind_len, non-existent option, invalid flags, option size
> smaller than kind_len, invalid packet
>
> Signed-off-by: Joanne Koong <joannekoong@fb.com>
> ---
>  .../bpf/prog_tests/xdp_tcp_hdr_options.c      | 158 ++++++++++++++
>  .../bpf/progs/test_xdp_tcp_hdr_options.c      | 198 ++++++++++++++++++
>  2 files changed, 356 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_tcp_hdr_options.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_tcp_hdr_options.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_tcp_hdr_options.c b/tools/testing/selftests/bpf/prog_tests/xdp_tcp_hdr_options.c
> new file mode 100644
> index 000000000000..bd77593fb2dd
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_tcp_hdr_options.c
> @@ -0,0 +1,158 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2021 Facebook */
> +
> +#include "test_progs.h"
> +#include "network_helpers.h"
> +#include "test_tcp_hdr_options.h"
> +#include "test_xdp_tcp_hdr_options.skel.h"
> +
> +struct xdp_exprm_opt {
> +       __u8 kind;
> +       __u8 len;
> +       __u16 magic;
> +       struct bpf_test_option data;
> +} __packed;
> +
> +struct xdp_regular_opt {
> +       __u8 kind;
> +       __u8 len;
> +       struct bpf_test_option data;
> +} __packed;
> +
> +struct xdp_test_opt {
> +       struct xdp_exprm_opt exprm_opt;
> +       struct xdp_regular_opt regular_opt;
> +} __packed;
> +
> +struct xdp_ipv4_packet {
> +       struct ipv4_packet pkt_v4;
> +       struct xdp_test_opt test_opt;
> +} __packed;
> +
> +struct xdp_ipv6_packet {
> +       struct ipv6_packet pkt_v6;
> +       struct xdp_test_opt test_opt;
> +} __packed;
> +
> +static __u8 opt_flags = OPTION_MAX_DELACK_MS | OPTION_RAND;
> +static __u8 exprm_max_delack_ms = 12;
> +static __u8 regular_max_delack_ms = 21;
> +static __u8 exprm_rand = 0xfa;
> +static __u8 regular_rand = 0xce;
> +
> +static void init_test_opt(struct xdp_test_opt *test_opt,
> +                         struct test_xdp_tcp_hdr_options *skel)
> +{
> +       test_opt->exprm_opt.kind = TCPOPT_EXP;
> +       /* +1 for kind, +1 for kind-len, +2 for magic, +1 for flags, +1 for
> +        * OPTION_MAX_DELACK_MAX, +1 FOR OPTION_RAND
> +        */
> +       test_opt->exprm_opt.len = 3 + TCP_BPF_EXPOPT_BASE_LEN;
> +       test_opt->exprm_opt.magic = __bpf_htons(skel->rodata->test_magic);
> +       test_opt->exprm_opt.data.flags = opt_flags;
> +       test_opt->exprm_opt.data.max_delack_ms = exprm_max_delack_ms;
> +       test_opt->exprm_opt.data.rand = exprm_rand;
> +
> +       test_opt->regular_opt.kind = skel->rodata->test_kind;
> +       /* +1 for kind, +1 for kind-len, +1 for flags, +1 FOR
> +        * OPTION_MAX_DELACK_MS, +1 FOR OPTION_RAND
> +        */
> +       test_opt->regular_opt.len = 5;
> +       test_opt->regular_opt.data.flags = opt_flags;
> +       test_opt->regular_opt.data.max_delack_ms = regular_max_delack_ms;
> +       test_opt->regular_opt.data.rand = regular_rand;
> +}
> +
> +static void check_opt_out(struct test_xdp_tcp_hdr_options *skel)
> +{
> +       struct bpf_test_option *opt_out;
> +       __u32 duration = 0;
> +
> +       opt_out = &skel->bss->exprm_opt_out;
> +       CHECK(opt_out->flags != opt_flags, "exprm flags",
> +             "flags = 0x%x", opt_out->flags);
> +       CHECK(opt_out->max_delack_ms != exprm_max_delack_ms, "exprm max_delack_ms",
> +             "max_delack_ms = 0x%x", opt_out->max_delack_ms);
> +       CHECK(opt_out->rand != exprm_rand, "exprm rand",
> +             "rand = 0x%x", opt_out->rand);
> +
> +       opt_out = &skel->bss->regular_opt_out;
> +       CHECK(opt_out->flags != opt_flags, "regular flags",
> +             "flags = 0x%x", opt_out->flags);
> +       CHECK(opt_out->max_delack_ms != regular_max_delack_ms, "regular max_delack_ms",
> +             "max_delack_ms = 0x%x", opt_out->max_delack_ms);
> +       CHECK(opt_out->rand != regular_rand, "regular rand",
> +             "rand = 0x%x", opt_out->rand);
> +}
> +
> +void test_xdp_tcp_hdr_options(void)
> +{
> +       int err, prog_fd, prog_err_path_fd, prog_invalid_pkt_fd;
> +       struct xdp_ipv6_packet ipv6_pkt, invalid_pkt;
> +       struct test_xdp_tcp_hdr_options *skel;
> +       struct xdp_ipv4_packet ipv4_pkt;
> +       struct xdp_test_opt test_opt;
> +       __u32 duration, retval, size;
> +       char buf[128];
> +
> +       /* Load XDP program to introspect */
> +       skel = test_xdp_tcp_hdr_options__open_and_load();
> +       if (CHECK(!skel, "skel open and load",
> +                 "%s skeleton failed\n", __func__))
> +               return;
> +
> +       prog_fd = bpf_program__fd(skel->progs._xdp_load_hdr_opt);
> +
> +       init_test_opt(&test_opt, skel);
> +
> +       /* Init the packets */
> +       ipv4_pkt.pkt_v4 = pkt_v4;
> +       ipv4_pkt.pkt_v4.tcp.doff += 3;
> +       ipv4_pkt.test_opt = test_opt;
> +
> +       ipv6_pkt.pkt_v6 = pkt_v6;
> +       ipv6_pkt.pkt_v6.tcp.doff += 3;
> +       ipv6_pkt.test_opt = test_opt;
> +
> +       invalid_pkt.pkt_v6 = pkt_v6;
> +       /* Set to an offset that will exceed the xdp data_end */
> +       invalid_pkt.pkt_v6.tcp.doff += 4;
> +       invalid_pkt.test_opt = test_opt;
> +
> +       /* Test on ipv4 packet */
> +       err = bpf_prog_test_run(prog_fd, 1, &ipv4_pkt, sizeof(ipv4_pkt),
> +                               buf, &size, &retval, &duration);
> +       CHECK(err || retval != XDP_PASS,
> +             "xdp_tcp_hdr_options ipv4", "err val %d, retval %d\n",
> +             skel->bss->err_val, retval);

Shall we skip the following checks if the test_run fails?

> +       check_opt_out(skel);
> +
> +       /* Test on ipv6 packet */
> +       err = bpf_prog_test_run(prog_fd, 1, &ipv6_pkt, sizeof(ipv6_pkt),
> +                               buf, &size, &retval, &duration);
> +       CHECK(err || retval != XDP_PASS,
> +             "xdp_tcp_hdr_options ipv6", "err val %d, retval %d\n",
> +             skel->bss->err_val, retval);
> +       check_opt_out(skel);
> +
> +       /* Test error paths */
> +       prog_err_path_fd =
> +               bpf_program__fd(skel->progs._xdp_load_hdr_opt_err_paths);
> +       err = bpf_prog_test_run(prog_err_path_fd, 1, &ipv6_pkt, sizeof(ipv6_pkt),
> +                               buf, &size, &retval, &duration);
> +       CHECK(err || retval != XDP_PASS,
> +             "xdp_tcp_hdr_options err_path", "err val %d, retval %d\n",
> +             skel->bss->err_val, retval);

Ditto.

> +
> +       /* Test invalid packet */
> +       prog_invalid_pkt_fd =
> +               bpf_program__fd(skel->progs._xdp_load_hdr_opt_invalid_pkt);
> +       err = bpf_prog_test_run(prog_invalid_pkt_fd, 1, &invalid_pkt,
> +                               sizeof(invalid_pkt), buf, &size, &retval,
> +                               &duration);
> +       CHECK(err || retval != XDP_PASS,
> +             "xdp_tcp_hdr_options invalid_pkt", "err val %d, retval %d\n",
> +             skel->bss->err_val, retval);
> +
> +       test_xdp_tcp_hdr_options__destroy(skel);
> +}

[...]
