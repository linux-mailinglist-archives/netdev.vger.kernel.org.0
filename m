Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 752C0143440
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 23:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgATWwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 17:52:38 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:40428 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbgATWwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 17:52:38 -0500
Received: by mail-qk1-f193.google.com with SMTP id c17so865662qkg.7;
        Mon, 20 Jan 2020 14:52:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=82G89UX1tTyY8Eu4dHcYzQK/e+NGEg0teejg+E25vhg=;
        b=bbAtsGpUueY3Co6cft5/wunnFbrVO3Nl4j8BXAH+I290I/H/ehHm/OaIIkYLcsPDX8
         tx4pIoUDShgAPhj9m5EQVt7/J+YNMxYCvrXG/sJELAxnEFz0Y4+j/bCD82I4BgnJ5wUa
         BEoO6uB2HDbv6wRlTW4ykKujnThM/lLuNQrUwsB6TwBejnlG47gHC4zGIpS8hkN1iCJ8
         ox4gEUP6w0Z8wBBkvSuZEXbQp0PUjZ2fHayvEprGbpKdACC/m4CBr3elOZNPD4DiST+A
         bNTXxX4MIX2bVMOPzzaTXrYeHDNH72nY0KXtp8EsujFcCpyHWK3RGpIfQw/vjsgOj3EQ
         +31A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=82G89UX1tTyY8Eu4dHcYzQK/e+NGEg0teejg+E25vhg=;
        b=kHHP6JJjftcdxhllRUJcagFJlsViLpOYsmWGqAGqC5uOSlR7eEvxo5nfEepKugsxR0
         G+YElrBtZE1CMF5npcV+/B4bEOSUmNdTwRRQCTRMP0DvlibL54u9uqGcKqRrKD4oUET1
         V0yOGzx+U44MVfZmJIeURzScsCPbAlyfyj1RZKgravgwULr9W3fz2+PgjYKIxDUXz5Zk
         e6DxxQB1NuyOn4lt6fO7rgPRPLmg78UAD5d76idCkaOn25G1bmM3XAhdGWKtXAXZ/k7X
         0G5CONlLDe1RLoJqOdNOsT0aOqV86we760aLsVS2j5rWtE4Psx3sDAtcO8vDhrX9jE43
         SGXA==
X-Gm-Message-State: APjAAAWQnqoc/psAi7Qal3XhkoYxPdNiOR+wTuZX98ZgNef9PZj/l6hc
        sAg9PPt+yEhCoNSyFxHVy8rUjmscx2mH5jzOubU=
X-Google-Smtp-Source: APXvYqzfiOALJy6cniPBbnHjskpMWSJ5AuXuz1tX1kd70MwpA6rcYaeB0xLxoPrBfV/WgGkz+fP4kb4hgIV9NbHIYOU=
X-Received: by 2002:a37:e408:: with SMTP id y8mr1829955qkf.39.1579560756871;
 Mon, 20 Jan 2020 14:52:36 -0800 (PST)
MIME-Version: 1.0
References: <20200118000657.2135859-1-ast@kernel.org> <20200118000657.2135859-2-ast@kernel.org>
In-Reply-To: <20200118000657.2135859-2-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 20 Jan 2020 14:52:25 -0800
Message-ID: <CAEf4BzZyOqgkFvuzJw7Rd007mL6_VCYHXb=uaFa2UgzQQOm1Dg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] bpf: Introduce dynamic program extensions
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

On Fri, Jan 17, 2020 at 4:07 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Introduce dynamic program extensions. The users can load additional BPF
> functions and replace global functions in previously loaded BPF programs while
> these programs are executing.
>
> Global functions are verified individually by the verifier based on their types only.
> Hence the global function in the new program which types match older function can
> safely replace that corresponding function.
>
> This new function/program is called 'an extension' of old program. At load time
> the verifier uses (attach_prog_fd, attach_btf_id) pair to identify the function
> to be replaced. The BPF program type is derived from the target program into
> extension program. Technically bpf_verifier_ops is copied from target program.
> The BPF_PROG_TYPE_EXT program type is a placeholder. It has empty verifier_ops.
> The extension program can call the same bpf helper functions as target program.
> Single BPF_PROG_TYPE_EXT type is used to extend XDP, SKB and all other program
> types. The verifier allows only one level of replacement. Meaning that the
> extension program cannot recursively extend an extension. That also means that
> the maximum stack size is increasing from 512 to 1024 bytes and maximum
> function nesting level from 8 to 16. The programs don't always consume that
> much. The stack usage is determined by the number of on-stack variables used by
> the program. The verifier could have enforced 512 limit for combined original
> plus extension program, but it makes for difficult user experience. The main
> use case for extensions is to provide generic mechanism to plug external
> programs into policy program or function call chaining.
>
> BPF trampoline is used to track both fentry/fexit and program extensions
> because both are using the same nop slot at the beginning of every BPF
> function. Attaching fentry/fexit to a function that was replaced is not
> allowed. The opposite is true as well. Replacing a function that currently
> being analyzed with fentry/fexit is not allowed. The executable page allocated
> by BPF trampoline is not used by program extensions. This inefficiency will be
> optimized in future patches.
>
> Function by function verification of global function supports scalars and
> pointer to context only. Hence program extensions are supported for such class
> of global functions only. In the future the verifier will be extended with
> support to pointers to structures, arrays with sizes, etc.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  include/linux/bpf.h       |  10 ++-
>  include/linux/bpf_types.h |   2 +
>  include/linux/btf.h       |   5 ++
>  include/uapi/linux/bpf.h  |   1 +
>  kernel/bpf/btf.c          | 152 +++++++++++++++++++++++++++++++++++++-
>  kernel/bpf/syscall.c      |  15 +++-
>  kernel/bpf/trampoline.c   |  38 +++++++++-
>  kernel/bpf/verifier.c     |  84 ++++++++++++++++-----
>  8 files changed, 281 insertions(+), 26 deletions(-)
>

[...]

> @@ -200,6 +208,26 @@ int bpf_trampoline_link_prog(struct bpf_prog *prog)
>         tr = prog->aux->trampoline;
>         kind = bpf_attach_type_to_tramp(prog->expected_attach_type);
>         mutex_lock(&tr->mutex);
> +       if (kind == BPF_TRAMP_REPLACE) {
> +               /* If this program already has an extension program
> +                * or it has fentry/fexit attached then return EBUSY.
> +                */
> +               if (tr->extension_prog ||
> +                   tr->progs_cnt[BPF_TRAMP_FENTRY] +
> +                   tr->progs_cnt[BPF_TRAMP_FEXIT]) {
> +                       err = -EBUSY;
> +                       goto out;
> +               }
> +               tr->extension_prog = prog;
> +               err = bpf_arch_text_poke(tr->func.addr, BPF_MOD_JUMP, NULL,
> +                                        prog->bpf_func);
> +               goto out;
> +       }
> +       if (tr->extension_prog) {
> +               /* cannot attach fentry/fexit if extension prog is attached */
> +               err = -EBUSY;
> +               goto out;
> +       }

move this check before BPF_TRAMP_REPLACE check and check additonally
for fentry+fexit for BPF_TRAMP_REPLACE? Nothing can replace
extension_prog, right?

>         if (tr->progs_cnt[BPF_TRAMP_FENTRY] + tr->progs_cnt[BPF_TRAMP_FEXIT]
>             >= BPF_MAX_TRAMP_PROGS) {
>                 err = -E2BIG;

[...]

> @@ -9788,8 +9789,58 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
>                         return -EINVAL;
>                 }
>                 conservative = aux->func_info_aux[subprog].unreliable;
> +               if (prog_extension) {
> +                       if (conservative) {
> +                               verbose(env,
> +                                       "Cannot replace static functions\n");
> +                               return -EINVAL;
> +                       }
> +                       if (!prog->jit_requested) {
> +                               verbose(env,
> +                                       "Extension programs should be JITed\n");
> +                               return -EINVAL;
> +                       }
> +                       env->ops = bpf_verifier_ops[tgt_prog->type];
> +               }
> +               if (!tgt_prog->jited) {
> +                       verbose(env, "Can attach to only JITed progs\n");
> +                       return -EINVAL;
> +               }
> +               if (tgt_prog->type == prog->type) {
> +                       /* Cannot fentry/fexit another fentry/fexit program.
> +                        * Cannot attach program extension to another extension.
> +                        * It's ok to attach fentry/fexit to extension program.
> +                        */
> +                       verbose(env, "Cannot recursively attach\n");
> +                       return -EINVAL;
> +               }
> +               if (tgt_prog->type == BPF_PROG_TYPE_TRACING &&
> +                   tgt_prog->expected_attach_type != BPF_TRACE_RAW_TP &&

if the intent is to prevent extending FENTRY/FEXIT, why not checking
explicitly for those two instead of making assumption that
expected_attach_type can be only one of RAW_TP/FENTRY/FEXIT, this can
easily change in the future. Besides, direct FENTRY/FEXIT comparison
is more self-documenting as well.

> +                   prog_extension) {
> +                       /* Program extensions can extend all program types
> +                        * except fentry/fexit. The reason is the following.
> +                        * The fentry/fexit programs are used for performance
> +                        * analysis, stats and can be attached to any program
> +                        * type except themselves. When extension program is
> +                        * replacing XDP function it is necessary to allow
> +                        * performance analysis of all functions. Both original
> +                        * XDP program and its program extension. Hence
> +                        * attaching fentry/fexit to BPF_PROG_TYPE_EXT is
> +                        * allowed. If extending of fentry/fexit was allowed it
> +                        * would be possible to create long call chain
> +                        * fentry->extension->fentry->extension beyond
> +                        * reasonable stack size. Hence extending fentry is not
> +                        * allowed.
> +                        */
> +                       verbose(env, "Cannot extend fentry/fexit\n");
> +                       return -EINVAL;
> +               }
>                 key = ((u64)aux->id) << 32 | btf_id;

[...]

> @@ -9834,6 +9889,9 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
>                                 btf_id);
>                         return -EINVAL;
>                 }
> +               if (prog_extension &&
> +                   btf_check_type_match(env, prog, btf, t))

this reads so weird... btf_check_type_match (and
btf_check_func_type_match as well) are boolean functions (i.e., either
matches or not, or some error), why not using a conventional
boolean+error return convention: 0 - false, 1 - true, <0 - error
(bug)?


> +                       return -EINVAL;
>                 t = btf_type_by_id(btf, t->type);
>                 if (!btf_type_is_func_proto(t))
>                         return -EINVAL;

[...]
