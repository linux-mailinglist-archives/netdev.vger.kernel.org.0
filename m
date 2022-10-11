Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB5F5FAA2D
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 03:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiJKBfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 21:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbiJKBew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 21:34:52 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E2712758;
        Mon, 10 Oct 2022 18:34:48 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id u21so18057538edi.9;
        Mon, 10 Oct 2022 18:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1Fv19S1DLKIgqqsmiVnPJY4HJvgD8CE1Y91e7AI9oX4=;
        b=KgPu8tyjwjuLCpaXchl5dVuKQ2S5LPvirWOZsXRTXcZH26IU3IqEAx/8CyoLtJFcrT
         qPLO0IIuiNg8kJQGFaQXJD9y8+61Cq3aR82o4Yfd2sV0Bp0UMmBZKNRwAonC61VF/cVF
         /AmsG6T7yHLQg3OunpLZ7eL/EffwqVAQIHo+VBb7KKi4MjYGgtf24/MKT1qAQVB0DuSr
         sPuReO0OjX8oQV8lU5Vt2gxgwBhbKSx57ZVrn/aR8Ih+m4DjW+8sSgNwM50buXPlFFLB
         +PbLIp5yN0fpnyOj28uitO3gOsvTBtfZt9LVEl3NApB8OyFP7m2sYhT2EJAKvZ21eMEy
         Yp5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1Fv19S1DLKIgqqsmiVnPJY4HJvgD8CE1Y91e7AI9oX4=;
        b=uYI+4HFDgndx8rojc5bBw2Arg/v09CnnOybolVdwgj2r9UWqg6XiCITFkWyoLQIhhp
         SOcavvkDKIEFwmucocX47tL+mQ/GAy0qNfnvpXjZzld01y7BCoDRGaFJr1TS3lHsTUhN
         arKOz0systPNwd9LmeTvTQKL+Bv562tUHUxjq7LgJiGxKCh+2AkiB35mAno3l38zpSAJ
         dfjsYjKV4MDLzs+W9fda7mopFUuPWKjk4kcCdWJtMU4x1DKQOUjaXUEY/LD7PyjK7Jzb
         6Jfwp7/stY5wkMIpPjmUBQcSGktysyxlTht93ADnS0Qo9bdPMvrGeJy5NoNX1TUjYCtN
         BJxg==
X-Gm-Message-State: ACrzQf3lOLAkTYr5JP8vXiUqLrVZZYJftqXSP5Mxp60O393eCWJxw5nx
        vGmJw3VtrjhoAS+Wmj16y7BQCyjwiR5OQt1eoF8=
X-Google-Smtp-Source: AMsMyM58aCSYr3PDzNxrW3qwXijXj77Ubk5rvN4iEPz2Izkcuj/3h+zaNKmUrpEsnpyTV3yrgCcV0v9AyLorIe0JCGU=
X-Received: by 2002:a05:6402:1856:b0:458:db1e:20ec with SMTP id
 v22-20020a056402185600b00458db1e20ecmr20845890edy.14.1665452085736; Mon, 10
 Oct 2022 18:34:45 -0700 (PDT)
MIME-Version: 1.0
References: <20221010142553.776550-1-xukuohai@huawei.com> <20221010142553.776550-3-xukuohai@huawei.com>
In-Reply-To: <20221010142553.776550-3-xukuohai@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 10 Oct 2022 18:34:33 -0700
Message-ID: <CAEf4BzbJ8LW1Q_hBc-eB25f=F+jdQ5aPucEv_oDNrbjB=GGR+g@mail.gmail.com>
Subject: Re: [PATCH bpf v3 2/6] libbpf: Fix memory leak in parse_usdt_arg()
To:     Xu Kuohai <xukuohai@huawei.com>
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Delyan Kratunov <delyank@fb.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 10, 2022 at 7:08 AM Xu Kuohai <xukuohai@huawei.com> wrote:
>
> In the arm64 version of parse_usdt_arg(), when sscanf returns 2, reg_name
> is allocated but not freed. Fix it.
>
> Fixes: 0f8619929c57 ("libbpf: Usdt aarch64 arg parsing support")
> Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
> ---
>  tools/lib/bpf/usdt.c | 59 +++++++++++++++++++++++++-------------------
>  1 file changed, 33 insertions(+), 26 deletions(-)
>
> diff --git a/tools/lib/bpf/usdt.c b/tools/lib/bpf/usdt.c
> index e83b497c2245..f3b5be7415b5 100644
> --- a/tools/lib/bpf/usdt.c
> +++ b/tools/lib/bpf/usdt.c
> @@ -1351,8 +1351,10 @@ static int parse_usdt_arg(const char *arg_str, int arg_num, struct usdt_arg_spec
>         char *reg_name = NULL;
>         int arg_sz, len, reg_off;
>         long off;
> +       int ret;
>
> -       if (sscanf(arg_str, " %d @ \[ %m[a-z0-9], %ld ] %n", &arg_sz, &reg_name, &off, &len) == 3) {
> +       ret = sscanf(arg_str, " %d @ \[ %m[a-z0-9], %ld ] %n", &arg_sz, &reg_name, &off, &len);
> +       if (ret == 3) {
>                 /* Memory dereference case, e.g., -4@[sp, 96] */
>                 arg->arg_type = USDT_ARG_REG_DEREF;
>                 arg->val_off = off;
> @@ -1361,32 +1363,37 @@ static int parse_usdt_arg(const char *arg_str, int arg_num, struct usdt_arg_spec
>                 if (reg_off < 0)
>                         return reg_off;
>                 arg->reg_off = reg_off;
> -       } else if (sscanf(arg_str, " %d @ \[ %m[a-z0-9] ] %n", &arg_sz, &reg_name, &len) == 2) {
> -               /* Memory dereference case, e.g., -4@[sp] */
> -               arg->arg_type = USDT_ARG_REG_DEREF;
> -               arg->val_off = 0;
> -               reg_off = calc_pt_regs_off(reg_name);
> -               free(reg_name);
> -               if (reg_off < 0)
> -                       return reg_off;
> -               arg->reg_off = reg_off;
> -       } else if (sscanf(arg_str, " %d @ %ld %n", &arg_sz, &off, &len) == 2) {
> -               /* Constant value case, e.g., 4@5 */
> -               arg->arg_type = USDT_ARG_CONST;
> -               arg->val_off = off;
> -               arg->reg_off = 0;
> -       } else if (sscanf(arg_str, " %d @ %m[a-z0-9] %n", &arg_sz, &reg_name, &len) == 2) {
> -               /* Register read case, e.g., -8@x4 */
> -               arg->arg_type = USDT_ARG_REG;
> -               arg->val_off = 0;
> -               reg_off = calc_pt_regs_off(reg_name);
> -               free(reg_name);
> -               if (reg_off < 0)
> -                       return reg_off;
> -               arg->reg_off = reg_off;
>         } else {
> -               pr_warn("usdt: unrecognized arg #%d spec '%s'\n", arg_num, arg_str);
> -               return -EINVAL;
> +               if (ret == 2)
> +                       free(reg_name);
> +
> +               if (sscanf(arg_str, " %d @ \[ %m[a-z0-9] ] %n", &arg_sz, &reg_name, &len) == 2) {
> +                       /* Memory dereference case, e.g., -4@[sp] */
> +                       arg->arg_type = USDT_ARG_REG_DEREF;
> +                       arg->val_off = 0;
> +                       reg_off = calc_pt_regs_off(reg_name);
> +                       free(reg_name);
> +                       if (reg_off < 0)
> +                               return reg_off;
> +                       arg->reg_off = reg_off;
> +               } else if (sscanf(arg_str, " %d @ %ld %n", &arg_sz, &off, &len) == 2) {
> +                       /* Constant value case, e.g., 4@5 */
> +                       arg->arg_type = USDT_ARG_CONST;
> +                       arg->val_off = off;
> +                       arg->reg_off = 0;
> +               } else if (sscanf(arg_str, " %d @ %m[a-z0-9] %n", &arg_sz, &reg_name, &len) == 2) {
> +                       /* Register read case, e.g., -8@x4 */
> +                       arg->arg_type = USDT_ARG_REG;
> +                       arg->val_off = 0;
> +                       reg_off = calc_pt_regs_off(reg_name);
> +                       free(reg_name);
> +                       if (reg_off < 0)
> +                               return reg_off;
> +                       arg->reg_off = reg_off;
> +               } else {
> +                       pr_warn("usdt: unrecognized arg #%d spec '%s'\n", arg_num, arg_str);
> +                       return -EINVAL;
> +               }
>         }
>

I think all this is more complicated than it has to be. How big  can
register names be? Few characters? Let's get rid of %m[a-z0-9] and
instead use fixed-max-length strings, e.g., %5s. And read register
names into such local char buffers. It will simplify everything
tremendously. Let's use 16-byte buffers and use %15s to match it?
Would that be enough?

>         arg->arg_signed = arg_sz < 0;
> --
> 2.30.2
>
