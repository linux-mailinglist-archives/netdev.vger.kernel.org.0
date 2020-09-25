Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3691C2782B8
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 10:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbgIYI0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 04:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727044AbgIYI0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 04:26:48 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12FBBC0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 01:26:48 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id n2so2003516oij.1
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 01:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DYuF32As8TEuwSp96iqdso+AMSbY1eS8TmRyDVsssfQ=;
        b=odGeJdyo8VawcIzx64n3bmu5JZIreCmQe67KU2sEh94GcrwSuwyFWe7AzJlpOKAURZ
         8jJJt5MLfZpMGFZS8QEGr3xeOsTL5UxHQ4XsAZ0A3lsdDbK3p712Gee7OxvNg40Wfuyd
         KOZpwxnkVKXLOcfViaLdW+H03ygnAQEN/BzNY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DYuF32As8TEuwSp96iqdso+AMSbY1eS8TmRyDVsssfQ=;
        b=jNKtyIdK04Mf/aiGc5/S9lk2XHwC2/wH4EQI9VnpPF4tnVRQA49RqkeQdRqcCtBFZ4
         9rt+1VPgXoSqenRoNS7Rj9vucBcBzAEwohSAyijVuZBFISG/05m72XijobP/qGUZ44vT
         mVE5iWeWC47GORFLyqoQBRCK+U3+Qh4vRaZJIXi+p8lmUHhfMPD5D+uH4hdt+DvTxfVd
         sf29H59pMJxOdi6QtnDLWCr1gnRTpx0MIzMVKOSJwmdzqBt3cp/TtHetNqAUG5zBG0Bq
         2kU1Kw8iTJlZwsNaE7vEy62hi4xw3ujfD0InzWPeEK9ukR04xDnU0WdGbiMRmwH7k7ZA
         sLvg==
X-Gm-Message-State: AOAM530Ak+yXSm8H+gtTPcORAFViQ9ofiYT412gPpN2VWIL6VuuI16Mk
        sh4MMvx4403PH7CTgM5vozgKgOHDehZgXvHPJ+KAAw==
X-Google-Smtp-Source: ABdhPJz03fc5rHGgsk3Dn0rJSpACNUx3YuAAEFNggJtPzGVEPN6L9Tx2PimglSmMmS9FdiKQ96dui0uHSEmXJ9dCCyI=
X-Received: by 2002:aca:3087:: with SMTP id w129mr852486oiw.102.1601022407249;
 Fri, 25 Sep 2020 01:26:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200925000337.3853598-1-kafai@fb.com> <20200925000350.3855720-1-kafai@fb.com>
In-Reply-To: <20200925000350.3855720-1-kafai@fb.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Fri, 25 Sep 2020 09:26:36 +0100
Message-ID: <CACAyw98fk6Vp3H_evke+-azatkz7eoqQaqy+37mMshkQf1Ri4Q@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 02/13] bpf: Enable bpf_skc_to_* sock casting
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

On Fri, 25 Sep 2020 at 01:04, Martin KaFai Lau <kafai@fb.com> wrote:
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
> types in filter.c. The bpf_skc_to_* helpers will be limited by
> perfmon cap.
>
> This patch adds a ARG_PTR_TO_BTF_ID_SOCK_COMMON.  The helper accepting
> this arg can accept a btf-id-ptr (PTR_TO_BTF_ID + &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON])
> or a legacy-ctx-convert-skc-ptr (PTR_TO_SOCK_COMMON).  The bpf_skc_to_*()
> helpers are changed to take ARG_PTR_TO_BTF_ID_SOCK_COMMON such that
> they will accept pointer obtained from skb->sk.
>
> Instead of specifying both arg_type and arg_btf_id in the same func_proto
> which is how the current ARG_PTR_TO_BTF_ID does, the arg_btf_id of
> the new ARG_PTR_TO_BTF_ID_SOCK_COMMON is specified in the
> compatible_reg_types[] in verifier.c.  The reason is the arg_btf_id is
> always the same.  Discussion in this thread:
> https://lore.kernel.org/bpf/20200922070422.1917351-1-kafai@fb.com/
>
> The ARG_PTR_TO_BTF_ID_ part gives a clear expectation that the helper is
> expecting a PTR_TO_BTF_ID which could be NULL.  This is the same
> behavior as the existing helper taking ARG_PTR_TO_BTF_ID.
>
> The _SOCK_COMMON part means the helper is also expecting the legacy
> SOCK_COMMON pointer.
>
> By excluding the _OR_NULL part, the bpf prog cannot call helper
> with a literal NULL which doesn't make sense in most cases.
> e.g. bpf_skc_to_tcp_sock(NULL) will be rejected.  All PTR_TO_*_OR_NULL
> reg has to do a NULL check first before passing into the helper or else
> the bpf prog will be rejected.  This behavior is nothing new and
> consistent with the current expectation during bpf-prog-load.
>
> [ ARG_PTR_TO_BTF_ID_SOCK_COMMON will be used to replace
>   ARG_PTR_TO_SOCK* of other existing helpers later such that
>   those existing helpers can take the PTR_TO_BTF_ID returned by
>   the bpf_skc_to_*() helpers.
>
>   The only special case is bpf_sk_lookup_assign() which can accept a
>   literal NULL ptr.  It has to be handled specially in another follow
>   up patch if there is a need (e.g. by renaming ARG_PTR_TO_SOCKET_OR_NULL
>   to ARG_PTR_TO_BTF_ID_SOCK_COMMON_OR_NULL). ]
>
> [ When converting the older helpers that take ARG_PTR_TO_SOCK* in
>   the later patch, if the kernel does not support BTF,
>   ARG_PTR_TO_BTF_ID_SOCK_COMMON will behave like ARG_PTR_TO_SOCK_COMMON
>   because no reg->type could have PTR_TO_BTF_ID in this case.
>
>   It is not a concern for the newer-btf-only helper like the bpf_skc_to_*()
>   here though because these helpers must require BTF vmlinux to begin
>   with. ]
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  include/linux/bpf.h   |  1 +
>  kernel/bpf/verifier.c | 34 +++++++++++++++++++--
>  net/core/filter.c     | 69 ++++++++++++++++++++++++++++++-------------
>  3 files changed, 82 insertions(+), 22 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index fc5c901c7542..d0937f1d2980 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -292,6 +292,7 @@ enum bpf_arg_type {
>         ARG_PTR_TO_ALLOC_MEM,   /* pointer to dynamically allocated memory */
>         ARG_PTR_TO_ALLOC_MEM_OR_NULL,   /* pointer to dynamically allocated memory or NULL */
>         ARG_CONST_ALLOC_SIZE_OR_ZERO,   /* number of allocated bytes requested */
> +       ARG_PTR_TO_BTF_ID_SOCK_COMMON,  /* pointer to in-kernel sock_common or bpf-mirrored bpf_sock */
>         __BPF_ARG_TYPE_MAX,
>  };
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 945fa2b4d096..d4ba29fb17a6 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -486,7 +486,12 @@ static bool is_acquire_function(enum bpf_func_id func_id,
>  static bool is_ptr_cast_function(enum bpf_func_id func_id)
>  {
>         return func_id == BPF_FUNC_tcp_sock ||
> -               func_id == BPF_FUNC_sk_fullsock;
> +               func_id == BPF_FUNC_sk_fullsock ||
> +               func_id == BPF_FUNC_skc_to_tcp_sock ||
> +               func_id == BPF_FUNC_skc_to_tcp6_sock ||
> +               func_id == BPF_FUNC_skc_to_udp6_sock ||
> +               func_id == BPF_FUNC_skc_to_tcp_timewait_sock ||
> +               func_id == BPF_FUNC_skc_to_tcp_request_sock;
>  }
>
>  /* string representation of 'enum bpf_reg_type' */
> @@ -3953,6 +3958,7 @@ static int resolve_map_arg_type(struct bpf_verifier_env *env,
>
>  struct bpf_reg_types {
>         const enum bpf_reg_type types[10];
> +       u32 *btf_id;
>  };
>
>  static const struct bpf_reg_types map_key_value_types = {
> @@ -3973,6 +3979,17 @@ static const struct bpf_reg_types sock_types = {
>         },
>  };
>
> +static const struct bpf_reg_types btf_id_sock_common_types = {
> +       .types = {
> +               PTR_TO_SOCK_COMMON,
> +               PTR_TO_SOCKET,
> +               PTR_TO_TCP_SOCK,
> +               PTR_TO_XDP_SOCK,
> +               PTR_TO_BTF_ID,
> +       },
> +       .btf_id = &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
> +};
> +
>  static const struct bpf_reg_types mem_types = {
>         .types = {
>                 PTR_TO_STACK,
> @@ -4014,6 +4031,7 @@ static const struct bpf_reg_types *compatible_reg_types[__BPF_ARG_TYPE_MAX] = {
>         [ARG_PTR_TO_CTX]                = &context_types,
>         [ARG_PTR_TO_CTX_OR_NULL]        = &context_types,
>         [ARG_PTR_TO_SOCK_COMMON]        = &sock_types,
> +       [ARG_PTR_TO_BTF_ID_SOCK_COMMON] = &btf_id_sock_common_types,
>         [ARG_PTR_TO_SOCKET]             = &fullsock_types,
>         [ARG_PTR_TO_SOCKET_OR_NULL]     = &fullsock_types,
>         [ARG_PTR_TO_BTF_ID]             = &btf_ptr_types,
> @@ -4059,6 +4077,14 @@ static int check_reg_type(struct bpf_verifier_env *env, u32 regno,
>
>  found:
>         if (type == PTR_TO_BTF_ID) {
> +               if (!arg_btf_id) {
> +                       if (!compatible->btf_id) {
> +                               verbose(env, "verifier internal error: missing arg compatible BTF ID\n");
> +                               return -EFAULT;
> +                       }
> +                       arg_btf_id = compatible->btf_id;
> +               }
> +
>                 if (!btf_struct_ids_match(&env->log, reg->off, reg->btf_id,
>                                           *arg_btf_id)) {
>                         verbose(env, "R%d is of type %s but %s is expected\n",
> @@ -4575,10 +4601,14 @@ static bool check_btf_id_ok(const struct bpf_func_proto *fn)
>  {
>         int i;
>
> -       for (i = 0; i < ARRAY_SIZE(fn->arg_type); i++)
> +       for (i = 0; i < ARRAY_SIZE(fn->arg_type); i++) {
>                 if (fn->arg_type[i] == ARG_PTR_TO_BTF_ID && !fn->arg_btf_id[i])
>                         return false;
>
> +               if (fn->arg_type[i] != ARG_PTR_TO_BTF_ID && fn->arg_btf_id[i])
> +                       return false;
> +       }
> +

This is a hold over from the previous patchset?

>         return true;
>  }
>
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 706f8db0ccf8..6d1864f2bd51 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -77,6 +77,9 @@
>  #include <net/transp_v6.h>
>  #include <linux/btf_ids.h>
>
> +static const struct bpf_func_proto *
> +bpf_sk_base_func_proto(enum bpf_func_id func_id);
> +
>  int copy_bpf_fprog_from_user(struct sock_fprog *dst, sockptr_t src, int len)
>  {
>         if (in_compat_syscall()) {
> @@ -6620,7 +6623,7 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>                         return NULL;
>                 }
>         default:
> -               return bpf_base_func_proto(func_id);
> +               return bpf_sk_base_func_proto(func_id);
>         }
>  }
>
> @@ -6639,7 +6642,7 @@ sk_filter_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>         case BPF_FUNC_perf_event_output:
>                 return &bpf_skb_event_output_proto;
>         default:
> -               return bpf_base_func_proto(func_id);
> +               return bpf_sk_base_func_proto(func_id);
>         }
>  }
>
> @@ -6800,7 +6803,7 @@ tc_cls_act_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>                 return &bpf_sk_assign_proto;
>  #endif
>         default:
> -               return bpf_base_func_proto(func_id);
> +               return bpf_sk_base_func_proto(func_id);
>         }
>  }
>
> @@ -6841,7 +6844,7 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>                 return &bpf_tcp_gen_syncookie_proto;
>  #endif
>         default:
> -               return bpf_base_func_proto(func_id);
> +               return bpf_sk_base_func_proto(func_id);
>         }
>  }
>
> @@ -6883,7 +6886,7 @@ sock_ops_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>                 return &bpf_tcp_sock_proto;
>  #endif /* CONFIG_INET */
>         default:
> -               return bpf_base_func_proto(func_id);
> +               return bpf_sk_base_func_proto(func_id);
>         }
>  }
>
> @@ -6929,7 +6932,7 @@ sk_msg_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>                 return &bpf_get_cgroup_classid_curr_proto;
>  #endif
>         default:
> -               return bpf_base_func_proto(func_id);
> +               return bpf_sk_base_func_proto(func_id);
>         }
>  }
>
> @@ -6971,7 +6974,7 @@ sk_skb_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>                 return &bpf_skc_lookup_tcp_proto;
>  #endif
>         default:
> -               return bpf_base_func_proto(func_id);
> +               return bpf_sk_base_func_proto(func_id);
>         }
>  }
>
> @@ -6982,7 +6985,7 @@ flow_dissector_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>         case BPF_FUNC_skb_load_bytes:
>                 return &bpf_flow_dissector_load_bytes_proto;
>         default:
> -               return bpf_base_func_proto(func_id);
> +               return bpf_sk_base_func_proto(func_id);
>         }
>  }
>
> @@ -7009,7 +7012,7 @@ lwt_out_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>         case BPF_FUNC_skb_under_cgroup:
>                 return &bpf_skb_under_cgroup_proto;
>         default:
> -               return bpf_base_func_proto(func_id);
> +               return bpf_sk_base_func_proto(func_id);
>         }
>  }
>
> @@ -9746,7 +9749,7 @@ sk_lookup_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>         case BPF_FUNC_sk_release:
>                 return &bpf_sk_release_proto;
>         default:
> -               return bpf_base_func_proto(func_id);
> +               return bpf_sk_base_func_proto(func_id);
>         }
>  }
>
> @@ -9913,8 +9916,7 @@ const struct bpf_func_proto bpf_skc_to_tcp6_sock_proto = {
>         .func                   = bpf_skc_to_tcp6_sock,
>         .gpl_only               = false,
>         .ret_type               = RET_PTR_TO_BTF_ID_OR_NULL,
> -       .arg1_type              = ARG_PTR_TO_BTF_ID,
> -       .arg1_btf_id            = &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
> +       .arg1_type              = ARG_PTR_TO_BTF_ID_SOCK_COMMON,
>         .ret_btf_id             = &btf_sock_ids[BTF_SOCK_TYPE_TCP6],
>  };
>
> @@ -9930,8 +9932,7 @@ const struct bpf_func_proto bpf_skc_to_tcp_sock_proto = {
>         .func                   = bpf_skc_to_tcp_sock,
>         .gpl_only               = false,
>         .ret_type               = RET_PTR_TO_BTF_ID_OR_NULL,
> -       .arg1_type              = ARG_PTR_TO_BTF_ID,
> -       .arg1_btf_id            = &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
> +       .arg1_type              = ARG_PTR_TO_BTF_ID_SOCK_COMMON,
>         .ret_btf_id             = &btf_sock_ids[BTF_SOCK_TYPE_TCP],
>  };
>
> @@ -9954,8 +9955,7 @@ const struct bpf_func_proto bpf_skc_to_tcp_timewait_sock_proto = {
>         .func                   = bpf_skc_to_tcp_timewait_sock,
>         .gpl_only               = false,
>         .ret_type               = RET_PTR_TO_BTF_ID_OR_NULL,
> -       .arg1_type              = ARG_PTR_TO_BTF_ID,
> -       .arg1_btf_id            = &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
> +       .arg1_type              = ARG_PTR_TO_BTF_ID_SOCK_COMMON,
>         .ret_btf_id             = &btf_sock_ids[BTF_SOCK_TYPE_TCP_TW],
>  };
>
> @@ -9978,8 +9978,7 @@ const struct bpf_func_proto bpf_skc_to_tcp_request_sock_proto = {
>         .func                   = bpf_skc_to_tcp_request_sock,
>         .gpl_only               = false,
>         .ret_type               = RET_PTR_TO_BTF_ID_OR_NULL,
> -       .arg1_type              = ARG_PTR_TO_BTF_ID,
> -       .arg1_btf_id            = &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
> +       .arg1_type              = ARG_PTR_TO_BTF_ID_SOCK_COMMON,
>         .ret_btf_id             = &btf_sock_ids[BTF_SOCK_TYPE_TCP_REQ],
>  };
>
> @@ -10000,7 +9999,37 @@ const struct bpf_func_proto bpf_skc_to_udp6_sock_proto = {
>         .func                   = bpf_skc_to_udp6_sock,
>         .gpl_only               = false,
>         .ret_type               = RET_PTR_TO_BTF_ID_OR_NULL,
> -       .arg1_type              = ARG_PTR_TO_BTF_ID,
> -       .arg1_btf_id            = &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
> +       .arg1_type              = ARG_PTR_TO_BTF_ID_SOCK_COMMON,
>         .ret_btf_id             = &btf_sock_ids[BTF_SOCK_TYPE_UDP6],
>  };
> +
> +static const struct bpf_func_proto *
> +bpf_sk_base_func_proto(enum bpf_func_id func_id)
> +{
> +       const struct bpf_func_proto *func;
> +
> +       switch (func_id) {
> +       case BPF_FUNC_skc_to_tcp6_sock:
> +               func = &bpf_skc_to_tcp6_sock_proto;
> +               break;
> +       case BPF_FUNC_skc_to_tcp_sock:
> +               func = &bpf_skc_to_tcp_sock_proto;
> +               break;
> +       case BPF_FUNC_skc_to_tcp_timewait_sock:
> +               func = &bpf_skc_to_tcp_timewait_sock_proto;
> +               break;
> +       case BPF_FUNC_skc_to_tcp_request_sock:
> +               func = &bpf_skc_to_tcp_request_sock_proto;
> +               break;
> +       case BPF_FUNC_skc_to_udp6_sock:
> +               func = &bpf_skc_to_udp6_sock_proto;
> +               break;
> +       default:
> +               return bpf_base_func_proto(func_id);
> +       }
> +
> +       if (!perfmon_capable())
> +               return NULL;
> +
> +       return func;
> +}
> --
> 2.24.1
>


-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
