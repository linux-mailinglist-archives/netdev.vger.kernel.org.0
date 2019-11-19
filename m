Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8A8101958
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 07:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbfKSG0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 01:26:20 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:36281 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbfKSG0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 01:26:19 -0500
Received: by mail-qt1-f195.google.com with SMTP id y10so23388098qto.3;
        Mon, 18 Nov 2019 22:26:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hfdNB6sn43NQko5mnZDhGuXbjUSr6tLeQ+sk79fPkQ4=;
        b=EdJckZsUT2nJIMhjUu0rk/uiIuQ6oYAtTsZtukRCJsgA+95fZyQ94VbP/qH/+LxRlg
         GDhnmlqk/as1d/nh2IFDFUpVdgFhB8sDzCx7Hxo/wA0Y1VnU11gsjht9sraan0UHkvPU
         MWQpy5NoYf4H1tyDfxujtYs84SdCa6xww5J9vB3q1f/+ZE8l35tCH9ud1cY2POTeY5/P
         OYquA9LpDogQUVO2sVlIDBJp8nJfEH3bOVDuaBctcr7K/YN3mAnmXkSpqjoh53LR0bP2
         NDeNdpbTjO7puoKQGMuacRk0i7sOJPlySdl0m8TqPSJeapnNZXtmZvq1z9wZb12/3gl5
         SWNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hfdNB6sn43NQko5mnZDhGuXbjUSr6tLeQ+sk79fPkQ4=;
        b=iGVmabgeTuQs3COQFGWc/xSMfegkMnir+tvrBtIIc4hKZmlb25CwxldiIHCJNX1ACF
         35MC8fieDIo4IbCfojtkIOyB2mTtjEjL3qzmf/K+ZMf0lQ1JePU4lN+stbBGbGTY56ZX
         rzojiUfJFfbkO806VAJKaMOd9i6V8g/5/mYzkd0K9e8azfyhwz50vk3LTaA/FrrFqpgq
         RUnFm6hKxrUPZgH11zNZNfLXhlnizdmkoVxbycgio94SPsAtrsZ0i0bX/a2529A6L4LI
         4dbN+0aVUW3nyTyaeLPBNPcqk+a6PqLCwFyKl/Zlp+ySyAOhn4DQb3T84+j2dNGzh6jX
         yu4g==
X-Gm-Message-State: APjAAAWi3U1LPrkHhKU1n6lucJe/efhLGWqjYyCWTeJFG5VlDXub5aZC
        YNgwVqGvKf4QSBz4PoHkyCHoAQl0lNAUZBowobQ=
X-Google-Smtp-Source: APXvYqzKHPdo2rcwI6UiD8diySovXma8SHi5uiopRCKmGsAXF0voWXGLLscK0rsdPH1R+FTEaRO2/QaFRyiWDFVNs1U=
X-Received: by 2002:ac8:7a83:: with SMTP id x3mr30800698qtr.141.1574144777952;
 Mon, 18 Nov 2019 22:26:17 -0800 (PST)
MIME-Version: 1.0
References: <20191119062151.777260-1-andriin@fb.com>
In-Reply-To: <20191119062151.777260-1-andriin@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 18 Nov 2019 22:26:07 -0800
Message-ID: <CAEf4Bza+bvRHqQ=NTgP_W4W3dscZ9VqLbxYZwns4YB+85KRqwA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: fix call relocation offset calculation bug
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 18, 2019 at 10:21 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> When relocating subprogram call, libbpf doesn't take into account
> relo->text_off, which comes from symbol's value. This generally works fine for
> subprograms implemented as static functions, but breaks for global functions.
>
> Taking a simplified test_pkt_access.c as an example:
>
> __attribute__ ((noinline))
> static int test_pkt_access_subprog1(volatile struct __sk_buff *skb)
> {
>         return skb->len * 2;
> }
>
> __attribute__ ((noinline))
> static int test_pkt_access_subprog2(int val, volatile struct __sk_buff *skb)
> {
>         return skb->len + val;
> }
>
> SEC("classifier/test_pkt_access")
> int test_pkt_access(struct __sk_buff *skb)
> {
>         if (test_pkt_access_subprog1(skb) != skb->len * 2)
>                 return TC_ACT_SHOT;
>         if (test_pkt_access_subprog2(2, skb) != skb->len + 2)
>                 return TC_ACT_SHOT;
>         return TC_ACT_UNSPEC;
> }
>
> When compiled, we get two relocations, pointing to '.text' symbol. .text has
> st_value set to 0 (it points to the beginning of .text section):
>
> 0000000000000008  000000050000000a R_BPF_64_32            0000000000000000 .text
> 0000000000000040  000000050000000a R_BPF_64_32            0000000000000000 .text
>
> test_pkt_access_subprog1 and test_pkt_access_subprog2 offsets (targets of two
> calls) are encoded within call instruction's imm32 part as -1 and 2,
> respectively:
>
> 0000000000000000 test_pkt_access_subprog1:
>        0:       61 10 00 00 00 00 00 00 r0 = *(u32 *)(r1 + 0)
>        1:       64 00 00 00 01 00 00 00 w0 <<= 1
>        2:       95 00 00 00 00 00 00 00 exit
>
> 0000000000000018 test_pkt_access_subprog2:
>        3:       61 10 00 00 00 00 00 00 r0 = *(u32 *)(r1 + 0)
>        4:       04 00 00 00 02 00 00 00 w0 += 2
>        5:       95 00 00 00 00 00 00 00 exit
>
> 0000000000000000 test_pkt_access:
>        0:       bf 16 00 00 00 00 00 00 r6 = r1
> ===>   1:       85 10 00 00 ff ff ff ff call -1
>        2:       bc 01 00 00 00 00 00 00 w1 = w0
>        3:       b4 00 00 00 02 00 00 00 w0 = 2
>        4:       61 62 00 00 00 00 00 00 r2 = *(u32 *)(r6 + 0)
>        5:       64 02 00 00 01 00 00 00 w2 <<= 1
>        6:       5e 21 08 00 00 00 00 00 if w1 != w2 goto +8 <LBB0_3>
>        7:       bf 61 00 00 00 00 00 00 r1 = r6
> ===>   8:       85 10 00 00 02 00 00 00 call 2
>        9:       bc 01 00 00 00 00 00 00 w1 = w0
>       10:       61 62 00 00 00 00 00 00 r2 = *(u32 *)(r6 + 0)
>       11:       04 02 00 00 02 00 00 00 w2 += 2
>       12:       b4 00 00 00 ff ff ff ff w0 = -1
>       13:       1e 21 01 00 00 00 00 00 if w1 == w2 goto +1 <LBB0_3>
>       14:       b4 00 00 00 02 00 00 00 w0 = 2
> 0000000000000078 LBB0_3:
>       15:       95 00 00 00 00 00 00 00 exit
>
> Now, if we compile example with global functions, the setup changes.
> Relocations are now against specifically test_pkt_access_subprog1 and
> test_pkt_access_subprog2 symbols, with test_pkt_access_subprog2 pointing 24
> bytes into its respective section (.text), i.e., 3 instructions in:
>
> 0000000000000008  000000070000000a R_BPF_64_32            0000000000000000 test_pkt_access_subprog1
> 0000000000000048  000000080000000a R_BPF_64_32            0000000000000018 test_pkt_access_subprog2
>
> Calls instructions now encode offsets relative to function symbols and are both
> set ot -1:
>
> 0000000000000000 test_pkt_access_subprog1:
>        0:       61 10 00 00 00 00 00 00 r0 = *(u32 *)(r1 + 0)
>        1:       64 00 00 00 01 00 00 00 w0 <<= 1
>        2:       95 00 00 00 00 00 00 00 exit
>
> 0000000000000018 test_pkt_access_subprog2:
>        3:       61 20 00 00 00 00 00 00 r0 = *(u32 *)(r2 + 0)
>        4:       0c 10 00 00 00 00 00 00 w0 += w1
>        5:       95 00 00 00 00 00 00 00 exit
>
> 0000000000000000 test_pkt_access:
>        0:       bf 16 00 00 00 00 00 00 r6 = r1
> ===>   1:       85 10 00 00 ff ff ff ff call -1
>        2:       bc 01 00 00 00 00 00 00 w1 = w0
>        3:       b4 00 00 00 02 00 00 00 w0 = 2
>        4:       61 62 00 00 00 00 00 00 r2 = *(u32 *)(r6 + 0)
>        5:       64 02 00 00 01 00 00 00 w2 <<= 1
>        6:       5e 21 09 00 00 00 00 00 if w1 != w2 goto +9 <LBB2_3>
>        7:       b4 01 00 00 02 00 00 00 w1 = 2
>        8:       bf 62 00 00 00 00 00 00 r2 = r6
> ===>   9:       85 10 00 00 ff ff ff ff call -1
>       10:       bc 01 00 00 00 00 00 00 w1 = w0
>       11:       61 62 00 00 00 00 00 00 r2 = *(u32 *)(r6 + 0)
>       12:       04 02 00 00 02 00 00 00 w2 += 2
>       13:       b4 00 00 00 ff ff ff ff w0 = -1
>       14:       1e 21 01 00 00 00 00 00 if w1 == w2 goto +1 <LBB2_3>
>       15:       b4 00 00 00 02 00 00 00 w0 = 2
> 0000000000000080 LBB2_3:
>       16:       95 00 00 00 00 00 00 00 exit
>
> Thus the right formula to calculate target call offset after relocation should
> take into account relocation's target symbol value (offset within section),
> call instruction's imm32 offset, and (subtracting, to get relative instruction
> offset) instruction index of call instruction itself. All that is shifted by
> number of instructions in main program, given all sub-programs are copied over
> after main program.
>
> Convert test_pkt_access.c to global functions to verify this works.
>
> Reported-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---

Forgot to include Fixes: tag, please let me know if I should post v2
with it added.

Fixes: 48cca7e44f9f ("libbpf: add support for bpf_call")

>  tools/lib/bpf/libbpf.c                              | 8 ++++++--
>  tools/testing/selftests/bpf/progs/test_pkt_access.c | 8 ++++----
>  2 files changed, 10 insertions(+), 6 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 15e91a1d6c11..a7d183f7ac72 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -1870,9 +1870,13 @@ bpf_program__collect_reloc(struct bpf_program *prog, GElf_Shdr *shdr,
>                                 pr_warn("incorrect bpf_call opcode\n");
>                                 return -LIBBPF_ERRNO__RELOC;
>                         }
> +                       if (sym.st_value % 8) {
> +                               pr_warn("bad call relo offset: %lu\n", sym.st_value);
> +                               return -LIBBPF_ERRNO__RELOC;
> +                       }
>                         prog->reloc_desc[i].type = RELO_CALL;
>                         prog->reloc_desc[i].insn_idx = insn_idx;
> -                       prog->reloc_desc[i].text_off = sym.st_value;
> +                       prog->reloc_desc[i].text_off = sym.st_value / 8;
>                         obj->has_pseudo_calls = true;
>                         continue;
>                 }
> @@ -3573,7 +3577,7 @@ bpf_program__reloc_text(struct bpf_program *prog, struct bpf_object *obj,
>                          prog->section_name);
>         }
>         insn = &prog->insns[relo->insn_idx];
> -       insn->imm += prog->main_prog_cnt - relo->insn_idx;
> +       insn->imm += relo->text_off + prog->main_prog_cnt - relo->insn_idx;
>         return 0;
>  }
>
> diff --git a/tools/testing/selftests/bpf/progs/test_pkt_access.c b/tools/testing/selftests/bpf/progs/test_pkt_access.c
> index 3a7b4b607ed3..dd0d2dfe55d8 100644
> --- a/tools/testing/selftests/bpf/progs/test_pkt_access.c
> +++ b/tools/testing/selftests/bpf/progs/test_pkt_access.c
> @@ -35,14 +35,14 @@ int _version SEC("version") = 1;
>   *
>   * Which makes it an interesting test for BTF-enabled verifier.
>   */
> -static __attribute__ ((noinline))
> -int test_pkt_access_subprog1(volatile struct __sk_buff *skb)
> +__attribute__ ((noinline))
> +int test_pkt_access_subprog1(struct __sk_buff *skb)
>  {
>         return skb->len * 2;
>  }
>
> -static __attribute__ ((noinline))
> -int test_pkt_access_subprog2(int val, volatile struct __sk_buff *skb)
> +__attribute__ ((noinline))
> +int test_pkt_access_subprog2(int val, struct __sk_buff *skb)
>  {
>         return skb->len * val;
>  }
> --
> 2.17.1
>
