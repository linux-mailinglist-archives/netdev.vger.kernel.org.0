Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 035AF5A1E1E
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 03:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244258AbiHZBZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 21:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231750AbiHZBZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 21:25:15 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9AB01D0C6;
        Thu, 25 Aug 2022 18:25:13 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id p187so128419iod.8;
        Thu, 25 Aug 2022 18:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=J5snBVTDlWBFu801/ywde1pPm00Eyyw3yMLWbRdtRFQ=;
        b=Ex1tXuuT1qkRrdHQJdEwKN8pBVE5IGGrbZROLG/2VjcLX/gM6oaE6/E5c6j9phsSZa
         MUFOU9IRnYNlCNutvBjkjQQZaWhz4bUobD13vwZjcYb7AZgYfwcIkvUaVYHoE8n3GZIL
         Ag0hzmCR0iu3bZt47wsgC8lkXAp1LJOPVZ8L5Uv4RKgVcGvbrk9Wk38yfYj5TSxXzvDa
         O7Ptz/IKMhoRYxz5srL3oTv3WFNSfhkGlAF7/aV22LkoDVvxzsqsf2wt3Yq9Tfebl0dw
         MjNSc1M5F1HhaFmtxZjD+gTJYpQXPV+P7Zw2tN3uoglHFXGn7AI0zr0txqU/4vKiYd26
         XaPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=J5snBVTDlWBFu801/ywde1pPm00Eyyw3yMLWbRdtRFQ=;
        b=Rp1kcYUaRgtBWDnzc0l5YRI75fP8tiqTVGw5/fXBu462M5HM5LlWYXTmlz81SDFQ2o
         RV5gl7dbG9/dSxpC0ENEIG6KWujkL+oZKrDwD76qyQj046kkP4mhGr/cvbiZoVuKCqVb
         Qz4MeLG3FsMkJ8cGO3pnl+kZvZPSoIKpQhoNNbAZIu0W4Z9ujdmDuxqmqY3KtpVATr2W
         nKGh3G2pH/DqE/16Rqfs06T0maqau3FAeuYFtyQABwHdkZ/0gI/6tQSjqbP7JizBEatS
         am6w/EjKok39ZEMkd4phXekO6MAn9p7gyg6d9lzZD3+9Z9uBGixjaLitiftS8zri3STY
         1xqA==
X-Gm-Message-State: ACgBeo0Y/K6UZ1AowOmGYifersenyiSVy+ldLAA0HgErtyL3GMtWBkTg
        0chKNI1rWZSDqXP/qT6NpvctirK9Tk4ME0pix5E=
X-Google-Smtp-Source: AA6agR5OoRAsYmkKWzn7x8LBM1xeXfEXZP3NcBAmEHhFG5PrKOCKqxwbhXKIm69DDl2rYhZCc3tzxzRN4htkc0G8UEM=
X-Received: by 2002:a05:6638:3828:b0:349:e863:f16c with SMTP id
 i40-20020a056638382800b00349e863f16cmr3153987jav.206.1661477112952; Thu, 25
 Aug 2022 18:25:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220824134055.1328882-1-benjamin.tissoires@redhat.com> <20220824134055.1328882-5-benjamin.tissoires@redhat.com>
In-Reply-To: <20220824134055.1328882-5-benjamin.tissoires@redhat.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Fri, 26 Aug 2022 03:24:37 +0200
Message-ID: <CAP01T74ZmvoYtG=8wiDm0_X3hrMN8s55CkSzurphDrZ3b86UZQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v9 04/23] bpf/verifier: allow kfunc to return an
 allocated mem
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Aug 2022 at 15:41, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> For drivers (outside of network), the incoming data is not statically
> defined in a struct. Most of the time the data buffer is kzalloc-ed
> and thus we can not rely on eBPF and BTF to explore the data.
>
> This commit allows to return an arbitrary memory, previously allocated by
> the driver.
> An interesting extra point is that the kfunc can mark the exported
> memory region as read only or read/write.
>
> So, when a kfunc is not returning a pointer to a struct but to a plain
> type, we can consider it is a valid allocated memory assuming that:
> - one of the arguments is either called rdonly_buf_size or
>   rdwr_buf_size
> - and this argument is a const from the caller point of view
>
> We can then use this parameter as the size of the allocated memory.
>
> The memory is either read-only or read-write based on the name
> of the size parameter.
>
> Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>
> ---
>
> changes in v9:
> - updated to match upstream (replaced kfunc_flag by a field in
>   kfunc_meta)
>
> no changes in v8
>
> changes in v7:
> - ensures btf_type_is_struct_ptr() checks for a ptr first
>   (squashed from next commit)
> - remove multiple_ref_obj_id need
> - use btf_type_skip_modifiers instead of manually doing it in
>   btf_type_is_struct_ptr()
> - s/strncmp/strcmp/ in btf_is_kfunc_arg_mem_size()
> - check for tnum_is_const when retrieving the size value
> - have only one check for "Ensure only one argument is referenced
>   PTR_TO_BTF_ID"
> - add some more context to the commit message
>
> changes in v6:
> - code review from Kartikeya:
>   - remove comment change that had no reasons to be
>   - remove handling of PTR_TO_MEM with kfunc releases
>   - introduce struct bpf_kfunc_arg_meta
>   - do rdonly/rdwr_buf_size check in btf_check_kfunc_arg_match
>   - reverted most of the changes in verifier.c
>   - make sure kfunc acquire is using a struct pointer, not just a plain
>     pointer
>   - also forward ref_obj_id to PTR_TO_MEM in kfunc to not use after free
>     the allocated memory
>
> changes in v5:
> - updated PTR_TO_MEM comment in btf.c to match upstream
> - make it read-only or read-write based on the name of size
>
> new in v4
>
> change btf.h
>
> fix allow kfunc to return an allocated mem
> ---
>  include/linux/bpf.h   |  9 +++-
>  include/linux/btf.h   | 10 +++++
>  kernel/bpf/btf.c      | 98 ++++++++++++++++++++++++++++++++++---------
>  kernel/bpf/verifier.c | 43 +++++++++++++------
>  4 files changed, 128 insertions(+), 32 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 39bd36359c1e..90dd218e0199 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1932,13 +1932,20 @@ int btf_distill_func_proto(struct bpf_verifier_log *log,
>                            const char *func_name,
>                            struct btf_func_model *m);
> [...]
> +
>  static int btf_check_func_arg_match(struct bpf_verifier_env *env,
>                                     const struct btf *btf, u32 func_id,
>                                     struct bpf_reg_state *regs,
>                                     bool ptr_to_mem_ok,
> -                                   u32 kfunc_flags)
> +                                   struct bpf_kfunc_arg_meta *kfunc_meta)
>  {
>         enum bpf_prog_type prog_type = resolve_prog_type(env->prog);
>         bool rel = false, kptr_get = false, trusted_arg = false;
> @@ -6207,12 +6232,12 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
>                 return -EINVAL;
>         }
>
> -       if (is_kfunc) {
> +       if (is_kfunc && kfunc_meta) {
>                 /* Only kfunc can be release func */
> -               rel = kfunc_flags & KF_RELEASE;
> -               kptr_get = kfunc_flags & KF_KPTR_GET;
> -               trusted_arg = kfunc_flags & KF_TRUSTED_ARGS;
> -               sleepable = kfunc_flags & KF_SLEEPABLE;
> +               rel = kfunc_meta->flags & KF_RELEASE;
> +               kptr_get = kfunc_meta->flags & KF_KPTR_GET;
> +               trusted_arg = kfunc_meta->flags & KF_TRUSTED_ARGS;
> +               sleepable = kfunc_meta->flags & KF_SLEEPABLE;
>         }
>
>         /* check that BTF function arguments match actual types that the
> @@ -6225,6 +6250,35 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
>
>                 t = btf_type_skip_modifiers(btf, args[i].type, NULL);
>                 if (btf_type_is_scalar(t)) {
> +                       if (is_kfunc && kfunc_meta) {
> +                               bool is_buf_size = false;
> +
> +                               /* check for any const scalar parameter of name "rdonly_buf_size"
> +                                * or "rdwr_buf_size"
> +                                */
> +                               if (btf_is_kfunc_arg_mem_size(btf, &args[i], reg,
> +                                                             "rdonly_buf_size")) {
> +                                       kfunc_meta->r0_rdonly = true;
> +                                       is_buf_size = true;
> +                               } else if (btf_is_kfunc_arg_mem_size(btf, &args[i], reg,
> +                                                                    "rdwr_buf_size"))
> +                                       is_buf_size = true;
> +
> +                               if (is_buf_size) {
> +                                       if (kfunc_meta->r0_size) {
> +                                               bpf_log(log, "2 or more rdonly/rdwr_buf_size parameters for kfunc");
> +                                               return -EINVAL;
> +                                       }
> +
> +                                       if (!tnum_is_const(reg->var_off)) {
> +                                               bpf_log(log, "R%d is not a const\n", regno);
> +                                               return -EINVAL;
> +                                       }
> +
> +                                       kfunc_meta->r0_size = reg->var_off.value;

Sorry for not pointing it out before, but you will need a call to
mark_chain_precision here after this, since the value of the scalar is
being used to decide the size of the returned pointer.

> +                               }
> +                       }
> +
>                         if (reg->type == SCALAR_VALUE)
>                                 continue;
>                         bpf_log(log, "R%d is not a scalar\n", regno);
> @@ -6255,6 +6309,19 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
>                 if (ret < 0)
>                         return ret;
>
> +               if (is_kfunc && reg->type == PTR_TO_BTF_ID) {

I think you can drop this extra check 'reg->type == PTR_TO_BTF_ID),
this condition of only one ref_obj_id should hold regardless of the
type.

> [...]
