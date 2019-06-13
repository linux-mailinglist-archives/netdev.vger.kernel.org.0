Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F93744EFA
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 00:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbfFMWJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 18:09:37 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:36816 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbfFMWJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 18:09:37 -0400
Received: by mail-qt1-f195.google.com with SMTP id p15so275124qtl.3;
        Thu, 13 Jun 2019 15:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cnTi/u0P4e0aI3dtv2F71stnIMWYitOp9OEn8Ix+Sgg=;
        b=dFqdJnEKgPH9v0pD94Ig3v69N9qH2EzA4Tyq54Ct8MwBqTbrXLLA49bFC0a7jzUqYI
         uGkhnJ2/0jQiNMFGIfogufAGMOc0Z2VsGypybuBScmfDggTTvtN5AWuD+NpAD1Z1Bnz3
         b1MX1dUb3d+LUNLi3ESssndH1ScWJIVNDF8W8qgRBZ0vLlqpr/hsPWulivkfGyrYh9Bo
         oyjM2A7JKmMi1DStKxhuqDn/WPBeC1ddHjYhrkoInVRObWwDx7uuca38Nh7NT58E1BL6
         avJbTX0eP1yi6ofvDncpmzJMVdvJloKnZIevouubuPN/qUqfRKLtMSAVhTK0CmBA/YPb
         7/qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cnTi/u0P4e0aI3dtv2F71stnIMWYitOp9OEn8Ix+Sgg=;
        b=oZqZwBqLkiFLdAuKZpOkVw2W+w1CPFp4yDp+iLZX7DN25A/J+tEdQDDzm7YQv/KmXA
         bM/gEZMDXeKu2gcax4zm4gKGAO4m6o1NhPJExBqnf6rkEU9Mb/bm9StHCiKoOGONcaUL
         ljH+TrfbziPUMs2RbLNCv7VcFKuCNhSv4VnSgG9hxfolFJRlCd7xu9WhoQYEh9p1x/Px
         nneA4GGxpAtOFIPD5oh93Dzu6PFM2/IMYnuYLzOi3NxALWHkLCqwfrFnGq0gtND/JbV1
         WqLMrI3tYwIq9rTtLRoRNpkalfSmMwgeUEbv5Y4ohiSRFXOeTZR2wcZ7eSoXe83wBmsq
         1EiA==
X-Gm-Message-State: APjAAAVWK2U/HXcWHA9hGgtUGGm5bDJR+9KxGvuo0OuUITYeZQbwl4ZW
        UIhk3oJg8JaUFxTQPDL5Q1silavfGq2b7m1Wq0+ikxZ5
X-Google-Smtp-Source: APXvYqwjv2HCE1BpLrrIr4cch7Q+x+EifRQU8H0TDdFaX/EbZjjEFe8HpdSeLKwMD0vu1iiMWbALqymJq3ADWK4amQA=
X-Received: by 2002:ac8:2fb7:: with SMTP id l52mr54174069qta.93.1560463776148;
 Thu, 13 Jun 2019 15:09:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190613042003.3791852-1-ast@kernel.org> <20190613042003.3791852-3-ast@kernel.org>
In-Reply-To: <20190613042003.3791852-3-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 13 Jun 2019 15:09:24 -0700
Message-ID: <CAEf4BzZPt_HwFiECemTsgXsE7J418rNa554-RZoPowrEosoXQA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/9] selftests/bpf: fix tests due to const spill/fill
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Edward Cree <ecree@solarflare.com>,
        john fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, Jann Horn <jannh@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 9:50 AM Alexei Starovoitov <ast@kernel.org> wrote:
>
> fix tests that incorrectly assumed that the verifier
> cannot track constants through stack.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>


>  .../bpf/verifier/direct_packet_access.c       |  3 +-
>  .../bpf/verifier/helper_access_var_len.c      | 28 ++++++++++---------
>  2 files changed, 17 insertions(+), 14 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/verifier/direct_packet_access.c b/tools/testing/selftests/bpf/verifier/direct_packet_access.c
> index d5c596fdc4b9..2c5fbe7bcd27 100644
> --- a/tools/testing/selftests/bpf/verifier/direct_packet_access.c
> +++ b/tools/testing/selftests/bpf/verifier/direct_packet_access.c
> @@ -511,7 +511,8 @@
>                     offsetof(struct __sk_buff, data)),
>         BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
>                     offsetof(struct __sk_buff, data_end)),
> -       BPF_MOV64_IMM(BPF_REG_0, 0xffffffff),
> +       BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
> +                   offsetof(struct __sk_buff, mark)),
>         BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_0, -8),
>         BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_10, -8),
>         BPF_ALU64_IMM(BPF_AND, BPF_REG_0, 0xffff),
> diff --git a/tools/testing/selftests/bpf/verifier/helper_access_var_len.c b/tools/testing/selftests/bpf/verifier/helper_access_var_len.c
> index 1f39d845c64f..67ab12410050 100644
> --- a/tools/testing/selftests/bpf/verifier/helper_access_var_len.c
> +++ b/tools/testing/selftests/bpf/verifier/helper_access_var_len.c
> @@ -29,9 +29,9 @@
>  {
>         "helper access to variable memory: stack, bitwise AND, zero included",
>         .insns = {
> +       BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, 8),
>         BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
>         BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -64),
> -       BPF_MOV64_IMM(BPF_REG_2, 16),
>         BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_2, -128),
>         BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, -128),
>         BPF_ALU64_IMM(BPF_AND, BPF_REG_2, 64),
> @@ -46,9 +46,9 @@
>  {
>         "helper access to variable memory: stack, bitwise AND + JMP, wrong max",
>         .insns = {
> +       BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, 8),
>         BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
>         BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -64),
> -       BPF_MOV64_IMM(BPF_REG_2, 16),
>         BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_2, -128),
>         BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, -128),
>         BPF_ALU64_IMM(BPF_AND, BPF_REG_2, 65),
> @@ -122,9 +122,9 @@
>  {
>         "helper access to variable memory: stack, JMP, bounds + offset",
>         .insns = {
> +       BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, 8),
>         BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
>         BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -64),
> -       BPF_MOV64_IMM(BPF_REG_2, 16),
>         BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_2, -128),
>         BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, -128),
>         BPF_JMP_IMM(BPF_JGT, BPF_REG_2, 64, 5),
> @@ -143,9 +143,9 @@
>  {
>         "helper access to variable memory: stack, JMP, wrong max",
>         .insns = {
> +       BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, 8),
>         BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
>         BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -64),
> -       BPF_MOV64_IMM(BPF_REG_2, 16),
>         BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_2, -128),
>         BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, -128),
>         BPF_JMP_IMM(BPF_JGT, BPF_REG_2, 65, 4),
> @@ -163,9 +163,9 @@
>  {
>         "helper access to variable memory: stack, JMP, no max check",
>         .insns = {
> +       BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, 8),
>         BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
>         BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -64),
> -       BPF_MOV64_IMM(BPF_REG_2, 16),
>         BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_2, -128),
>         BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, -128),
>         BPF_MOV64_IMM(BPF_REG_4, 0),
> @@ -183,9 +183,9 @@
>  {
>         "helper access to variable memory: stack, JMP, no min check",
>         .insns = {
> +       BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, 8),
>         BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
>         BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -64),
> -       BPF_MOV64_IMM(BPF_REG_2, 16),
>         BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_2, -128),
>         BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, -128),
>         BPF_JMP_IMM(BPF_JGT, BPF_REG_2, 64, 3),
> @@ -201,9 +201,9 @@
>  {
>         "helper access to variable memory: stack, JMP (signed), no min check",
>         .insns = {
> +       BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, 8),
>         BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
>         BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -64),
> -       BPF_MOV64_IMM(BPF_REG_2, 16),
>         BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_2, -128),
>         BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, -128),
>         BPF_JMP_IMM(BPF_JSGT, BPF_REG_2, 64, 3),
> @@ -244,6 +244,7 @@
>  {
>         "helper access to variable memory: map, JMP, wrong max",
>         .insns = {
> +       BPF_LDX_MEM(BPF_DW, BPF_REG_6, BPF_REG_1, 8),
>         BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
>         BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
>         BPF_ST_MEM(BPF_DW, BPF_REG_2, 0, 0),
> @@ -251,7 +252,7 @@
>         BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
>         BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 10),
>         BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
> -       BPF_MOV64_IMM(BPF_REG_2, sizeof(struct test_val)),
> +       BPF_MOV64_REG(BPF_REG_2, BPF_REG_6),
>         BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_2, -128),
>         BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_10, -128),
>         BPF_JMP_IMM(BPF_JSGT, BPF_REG_2, sizeof(struct test_val) + 1, 4),
> @@ -262,7 +263,7 @@
>         BPF_MOV64_IMM(BPF_REG_0, 0),
>         BPF_EXIT_INSN(),
>         },
> -       .fixup_map_hash_48b = { 3 },
> +       .fixup_map_hash_48b = { 4 },
>         .errstr = "invalid access to map value, value_size=48 off=0 size=49",
>         .result = REJECT,
>         .prog_type = BPF_PROG_TYPE_TRACEPOINT,
> @@ -296,6 +297,7 @@
>  {
>         "helper access to variable memory: map adjusted, JMP, wrong max",
>         .insns = {
> +       BPF_LDX_MEM(BPF_DW, BPF_REG_6, BPF_REG_1, 8),
>         BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
>         BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
>         BPF_ST_MEM(BPF_DW, BPF_REG_2, 0, 0),
> @@ -304,7 +306,7 @@
>         BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 11),
>         BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
>         BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 20),
> -       BPF_MOV64_IMM(BPF_REG_2, sizeof(struct test_val)),
> +       BPF_MOV64_REG(BPF_REG_2, BPF_REG_6),
>         BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_2, -128),
>         BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_10, -128),
>         BPF_JMP_IMM(BPF_JSGT, BPF_REG_2, sizeof(struct test_val) - 19, 4),
> @@ -315,7 +317,7 @@
>         BPF_MOV64_IMM(BPF_REG_0, 0),
>         BPF_EXIT_INSN(),
>         },
> -       .fixup_map_hash_48b = { 3 },
> +       .fixup_map_hash_48b = { 4 },
>         .errstr = "R1 min value is outside of the array range",
>         .result = REJECT,
>         .prog_type = BPF_PROG_TYPE_TRACEPOINT,
> @@ -337,8 +339,8 @@
>  {
>         "helper access to variable memory: size > 0 not allowed on NULL (ARG_PTR_TO_MEM_OR_NULL)",
>         .insns = {
> +       BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, 0),
>         BPF_MOV64_IMM(BPF_REG_1, 0),
> -       BPF_MOV64_IMM(BPF_REG_2, 1),
>         BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_2, -128),
>         BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_10, -128),
>         BPF_ALU64_IMM(BPF_AND, BPF_REG_2, 64),
> @@ -562,6 +564,7 @@
>  {
>         "helper access to variable memory: 8 bytes leak",
>         .insns = {
> +       BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, 8),
>         BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
>         BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -64),
>         BPF_MOV64_IMM(BPF_REG_0, 0),
> @@ -572,7 +575,6 @@
>         BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_0, -24),
>         BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_0, -16),
>         BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_0, -8),
> -       BPF_MOV64_IMM(BPF_REG_2, 1),
>         BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_2, -128),
>         BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_10, -128),
>         BPF_ALU64_IMM(BPF_AND, BPF_REG_2, 63),
> --
> 2.20.0
>
