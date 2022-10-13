Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 198445FDD7D
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 17:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiJMPsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 11:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiJMPsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 11:48:09 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E56DD891;
        Thu, 13 Oct 2022 08:48:08 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id g27so3189277edf.11;
        Thu, 13 Oct 2022 08:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xq3Ft5Gy3bihgDg2eQnRZLaoZCm4mqPLSgf5VDy0lNI=;
        b=mWZ/ksuUPM4lAAfUgZN9Ei9Qn5R6eTz98BlE0YRWEKbT8KjDvV+GttlngcBAXOlw1a
         dWBIbzCSALWQ3kLNVFtfXjaeXpCUK8H3J84bXuigFqOwCPKWJ9ojfayGPsGC1h/ylqvZ
         hPjDiezMO+Rv32d1PyxrJg5+Ik4eDnPKBNCc6NCCZs8urNc8pNC/JC+BpApOdh4nO2JE
         fgrkOFW04lTpt09mKwLQomX+NOiguziVPgmyplYyqFCziWNDrwL4J2TJ2lBHKtlF7ckh
         4uej2hGj5TBvGE4Keu7svY7Y5YT8fOoTwkl4hk1KZvGmviMYGN7bnk6Tlj3HWUlk0qGG
         ySwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xq3Ft5Gy3bihgDg2eQnRZLaoZCm4mqPLSgf5VDy0lNI=;
        b=63Flw57J3TGjcDhA2EbB9q4k/bU09QGShN6kFm6UneWuoTsjr36uWbs4OYw1/VQsXH
         FmN++ou6534sDZ5vMcfVMIfCWExVejvwSfsCaYS04Vjzm83ZZWcHr/OdFy2EBCp0f1eq
         vBUg30IuARkanRhiYsglmSGR7Us736cltc54/ts6fRyw4HeKDKtgP18BWykOT2Fs7U5Y
         ZXPcPQkguUwwnT3WYWFo5pQ4s94TEIOcFjxlWl1tfPWV1+8IpMhzA/JqcPiJoHko1vuE
         q1zrOWCjTRSeZED8YUODB+q8NkV1Jgrc0dhIC5uSqOylC+Rmoxev0UVqoDBO7GuGibH3
         dTdw==
X-Gm-Message-State: ACrzQf1PvH+Qq/xZEJt8L/9QpgSO5JkxWsDUQUczb6r5ZaO2XMP/Il7b
        6iv/EO9ySsIM9Wp6jX2b6WufDKx1Mf8V8aAJmVk=
X-Google-Smtp-Source: AMsMyM5vOqLU9l0cOuSy0hzikA++us8/4quTmIviD9PS0gOoS/7XEE+/biGikZTxaSTkgR9eF47jawNrEvm9Fkm2Ni4=
X-Received: by 2002:a05:6402:22ed:b0:458:bcd1:69cf with SMTP id
 dn13-20020a05640222ed00b00458bcd169cfmr381307edb.260.1665676087173; Thu, 13
 Oct 2022 08:48:07 -0700 (PDT)
MIME-Version: 1.0
References: <20221011120108.782373-1-xukuohai@huaweicloud.com> <20221011120108.782373-3-xukuohai@huaweicloud.com>
In-Reply-To: <20221011120108.782373-3-xukuohai@huaweicloud.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 13 Oct 2022 08:47:55 -0700
Message-ID: <CAEf4BzZVYO42kDcmNqorLfwJcMcN7fyTLdp2GWbGfV5akP12GQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/6] libbpf: Fix memory leak in parse_usdt_arg()
To:     Xu Kuohai <xukuohai@huaweicloud.com>
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

On Tue, Oct 11, 2022 at 4:43 AM Xu Kuohai <xukuohai@huaweicloud.com> wrote:
>
> From: Xu Kuohai <xukuohai@huawei.com>
>
> In the arm64 version of parse_usdt_arg(), when sscanf returns 2, reg_name
> is allocated but not freed. Fix it.
>
> Fixes: 0f8619929c57 ("libbpf: Usdt aarch64 arg parsing support")
> Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
> ---
>  tools/lib/bpf/usdt.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
>
> diff --git a/tools/lib/bpf/usdt.c b/tools/lib/bpf/usdt.c
> index e83b497c2245..49f3c3b7f609 100644
> --- a/tools/lib/bpf/usdt.c
> +++ b/tools/lib/bpf/usdt.c
> @@ -1348,25 +1348,23 @@ static int calc_pt_regs_off(const char *reg_name)
>
>  static int parse_usdt_arg(const char *arg_str, int arg_num, struct usdt_arg_spec *arg)
>  {
> -       char *reg_name = NULL;
> +       char reg_name[16];
>         int arg_sz, len, reg_off;
>         long off;
>
> -       if (sscanf(arg_str, " %d @ \[ %m[a-z0-9], %ld ] %n", &arg_sz, &reg_name, &off, &len) == 3) {
> +       if (sscanf(arg_str, " %d @ \[ %15[a-z0-9], %ld ] %n", &arg_sz, reg_name, &off, &len) == 3) {

It would be nice to do the same change for other architectures where
it makes sense and avoid having to deal with unnecessary memory
allocations. Please send follow up patches with similar changes for
other implementations of parse_usdt_arg. Thanks.


>                 /* Memory dereference case, e.g., -4@[sp, 96] */
>                 arg->arg_type = USDT_ARG_REG_DEREF;
>                 arg->val_off = off;
>                 reg_off = calc_pt_regs_off(reg_name);
> -               free(reg_name);
>                 if (reg_off < 0)
>                         return reg_off;
>                 arg->reg_off = reg_off;
> -       } else if (sscanf(arg_str, " %d @ \[ %m[a-z0-9] ] %n", &arg_sz, &reg_name, &len) == 2) {
> +       } else if (sscanf(arg_str, " %d @ \[ %15[a-z0-9] ] %n", &arg_sz, reg_name, &len) == 2) {
>                 /* Memory dereference case, e.g., -4@[sp] */
>                 arg->arg_type = USDT_ARG_REG_DEREF;
>                 arg->val_off = 0;
>                 reg_off = calc_pt_regs_off(reg_name);
> -               free(reg_name);
>                 if (reg_off < 0)
>                         return reg_off;
>                 arg->reg_off = reg_off;
> @@ -1375,12 +1373,11 @@ static int parse_usdt_arg(const char *arg_str, int arg_num, struct usdt_arg_spec
>                 arg->arg_type = USDT_ARG_CONST;
>                 arg->val_off = off;
>                 arg->reg_off = 0;
> -       } else if (sscanf(arg_str, " %d @ %m[a-z0-9] %n", &arg_sz, &reg_name, &len) == 2) {
> +       } else if (sscanf(arg_str, " %d @ %15[a-z0-9] %n", &arg_sz, reg_name, &len) == 2) {
>                 /* Register read case, e.g., -8@x4 */
>                 arg->arg_type = USDT_ARG_REG;
>                 arg->val_off = 0;
>                 reg_off = calc_pt_regs_off(reg_name);
> -               free(reg_name);
>                 if (reg_off < 0)
>                         return reg_off;
>                 arg->reg_off = reg_off;
> --
> 2.30.2
>
