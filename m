Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A06AB503336
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 07:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiDPCHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 22:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiDPCGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 22:06:06 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86CB82DE4;
        Fri, 15 Apr 2022 18:55:43 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id r1so8270691vsi.12;
        Fri, 15 Apr 2022 18:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bxHqb8WimKEbeuMOXj7uS2B/33CXla8+s/0GV1tVsaY=;
        b=gIlvwt3xYpUb4e74b3w/piI2491YaM5CwPoLTITXU6+31o6AUkyajC8HIxUzbxri19
         NoeOC7/PcBXg0OEzqxc8gBA38orkG87RodLT/c5emfbt4/XbqEhfVZC/HjGYuRgKATwp
         d4NErbEscLWXZ8TzkgjKLtpT7jPimlsUIrcr8x/Fs97NwnSH4iEHVBCZ4kZX1e56hA2b
         EsgUUzyfUzTo9vQaXP8IZBHElsiihB8IO/RUZxWPon72kwGRLgJcXX35CWNFv/nSpLmG
         hWKWIa2EaWTkXFXEw8x3mIpVjqeYLlQQ5u2FOI4a+pZI0n12/1nIgjt3afYrC5FALlqZ
         v/dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bxHqb8WimKEbeuMOXj7uS2B/33CXla8+s/0GV1tVsaY=;
        b=R/Syw+O8/5Jwk26LXadwSGslycu4X+RP2IPt/bsnA9f5LzOTW/h5Da2T+BEbrzZ3bA
         PMoJ8mcPX9zCtfC66GqICK/fHkDaT+XYiQuQNScZlsVh242acLM85aOf5zSO4uURPLl8
         yT3DFE9/RqZMbN6Qj26kQWZE3ZYY4jG3w3fbeHUW8GUD4Tadqc5w8WNxuq66mTPL9TDu
         tr3Bf+JvyexjQ7p+tKNX67Ss8bFLIkBfmrXIABmQFOJpq9ONAj+Lp2BS0LE68OO2xYei
         vk9Jm2ahLMLP/Qf43IFFFFGUtag68oLMkY9b1fqCjW1Zg2Me3shJ7AnrbYUpEtJ6rNd6
         1YrA==
X-Gm-Message-State: AOAM5328Nq5HgrzFtPNSnYyNiwhmRb0KQzo2715hKFVkCIA01guWTds9
        9XFmgM+dRFFEAA00nLBMd6hU+W5Ye17MdlY+JNTufR4B
X-Google-Smtp-Source: ABdhPJw2rmlQZyvzdy/y2IWrJrzPSIFk0PKy/oNH5Hczd2zycxoi75ShkPXrHahpWHW21aNzXPvBKk7/NfKK8dR1JSQ=
X-Received: by 2002:a17:902:7209:b0:158:c67b:3915 with SMTP id
 ba9-20020a170902720900b00158c67b3915mr1621820plb.67.1650072496848; Fri, 15
 Apr 2022 18:28:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220414161233.170780-1-sdf@google.com>
In-Reply-To: <20220414161233.170780-1-sdf@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 16 Apr 2022 01:28:05 +0000
Message-ID: <CAADnVQJ-kiWJopu+VjLDXYb9ifjKyA2h8MO=CaQppNxbHqH=-Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] bpf: move rcu lock management out of
 BPF_PROG_RUN routines
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
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

On Thu, Apr 14, 2022 at 9:12 AM Stanislav Fomichev <sdf@google.com> wrote:
> +static int
> +bpf_prog_run_array_cg_flags(const struct cgroup_bpf *cgrp,
> +                           enum cgroup_bpf_attach_type atype,
> +                           const void *ctx, bpf_prog_run_fn run_prog,
> +                           int retval, u32 *ret_flags)
> +{
> +       const struct bpf_prog_array_item *item;
> +       const struct bpf_prog *prog;
> +       const struct bpf_prog_array *array;
> +       struct bpf_run_ctx *old_run_ctx;
> +       struct bpf_cg_run_ctx run_ctx;
> +       u32 func_ret;
> +
> +       run_ctx.retval = retval;
> +       migrate_disable();
> +       rcu_read_lock();
> +       array = rcu_dereference(cgrp->effective[atype]);
> +       item = &array->items[0];
> +       old_run_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
> +       while ((prog = READ_ONCE(item->prog))) {
> +               run_ctx.prog_item = item;
> +               func_ret = run_prog(prog, ctx);
...
> +       ret = bpf_prog_run_array_cg(&cgrp->bpf, CGROUP_GETSOCKOPT,
>                                     &ctx, bpf_prog_run, retval);

Did you check the asm that bpf_prog_run gets inlined
after being passed as a pointer to a function?
Crossing fingers... I suspect not every compiler can do that :(
De-virtualization optimization used to be tricky.
