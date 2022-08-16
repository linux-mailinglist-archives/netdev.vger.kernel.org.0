Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8A15953AA
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 09:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbiHPHYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 03:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbiHPHYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 03:24:31 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35FFA2D1926;
        Mon, 15 Aug 2022 20:32:13 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id x21so11871720edd.3;
        Mon, 15 Aug 2022 20:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Aem/z9aqHZ+Pbear+KWhYtrK3FMpnJWq34QZfvb9h84=;
        b=TfmeNVIDyi3piN4zfCe+exG/6dlIOf9lLiQ8weiz8LQkXTN5w4GgXtmI/xMUaZqTtx
         N5hgPm4ntMFpazvZtoDVjL3tJ+Noayr5npQ1Bw9BEt6rFEsDM9pRml83tXUfu/jh86jE
         xTfWwlEwf/hH+IWl2nG+FF/GedB0evO8JU0m1p86anZXxJjq5R7m2/yOcJ70KsTNJiy7
         jo/5qo82BuR4B6pgl3Mm4YFT0WCwzvPzUJY59TNpVmZsozpoQ++GWJx476He/oS/VK1N
         3qK79YCNGKn1BRBlXygZRb51WreFkN40dXAMB8M7nwabrPHjxMGqkNPJi8xdmO/1V2Hw
         bgTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Aem/z9aqHZ+Pbear+KWhYtrK3FMpnJWq34QZfvb9h84=;
        b=eJQW/o4DUA2tYc3+L9eFxohe9qXPYQAWU8Y0ood1yTmPJewzPPMEJLA5KImqe/sxo6
         f0+C791UoRVAcF0pneNK8h6M1Y0N7qlub0W5zmna8WOPxxNLEu1xVkTdsdC4l7Txsm/V
         5wb1jeDOZK1pzNFZ/+80eI6heGfZbCeuQmS6QxZIIU6zxHHFndI4NmQShwI6XpSL1clC
         xEMhPGpRKzwaxtr3yt8UTXfvyCL5IVFhYMGmRV0DK+Usbd2hRg+iyHuYuMtakI79TnQn
         9HHRgbcNE1GJR2l2z8W9UcOAgwUgNokN5Fd+HXR3I4tartdXSdMKUocamQA2TnSbPTEu
         x16A==
X-Gm-Message-State: ACgBeo31XRq0N2jTJwi5tBayze7f14l6BNLj1u1Fi/ErJWhYcoESRBwb
        Qca5/85t7MV3aqZgAaXwegMqC89kGRII96FBUHt89R9dD+w=
X-Google-Smtp-Source: AA6agR5lU3u7oG3igOwSW36uGz+FtIrQVpWZjDsWx6ey01gaWUrJltuBHKsNncl7qkdpuB1qdt/laJcnflTHn0dTzP0=
X-Received: by 2002:a05:6402:110a:b0:443:225c:6822 with SMTP id
 u10-20020a056402110a00b00443225c6822mr16505227edv.81.1660620731547; Mon, 15
 Aug 2022 20:32:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220810190724.2692127-1-kafai@fb.com> <20220810190736.2693150-1-kafai@fb.com>
In-Reply-To: <20220810190736.2693150-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 15 Aug 2022 20:32:00 -0700
Message-ID: <CAEf4BzbW222vbGvDBiSk5y93wp2d_P=NK2yzJ1bOy8=8KGX7Qw@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 02/15] bpf: net: Avoid sk_setsockopt() taking
 sk lock when called from bpf
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        Paolo Abeni <pabeni@redhat.com>,
        Stanislav Fomichev <sdf@google.com>
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

On Wed, Aug 10, 2022 at 12:10 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> Most of the code in bpf_setsockopt(SOL_SOCKET) are duplicated from
> the sk_setsockopt().  The number of supported optnames are
> increasing ever and so as the duplicated code.
>
> One issue in reusing sk_setsockopt() is that the bpf prog
> has already acquired the sk lock.  This patch adds a
> has_current_bpf_ctx() to tell if the sk_setsockopt() is called from
> a bpf prog.  The bpf prog calling bpf_setsockopt() is either running
> in_task() or in_serving_softirq().  Both cases have the current->bpf_ctx
> initialized.  Thus, the has_current_bpf_ctx() only needs to
> test !!current->bpf_ctx.
>
> This patch also adds sockopt_{lock,release}_sock() helpers
> for sk_setsockopt() to use.  These helpers will test
> has_current_bpf_ctx() before acquiring/releasing the lock.  They are
> in EXPORT_SYMBOL for the ipv6 module to use in a latter patch.
>
> Note on the change in sock_setbindtodevice().  sockopt_lock_sock()
> is done in sock_setbindtodevice() instead of doing the lock_sock
> in sock_bindtoindex(..., lock_sk = true).
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  include/linux/bpf.h | 14 ++++++++++++++
>  include/net/sock.h  |  3 +++
>  net/core/sock.c     | 30 +++++++++++++++++++++++++++---
>  3 files changed, 44 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index a627a02cf8ab..0a600b2013cc 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1966,6 +1966,16 @@ static inline bool unprivileged_ebpf_enabled(void)
>         return !sysctl_unprivileged_bpf_disabled;
>  }
>
> +/* Not all bpf prog type has the bpf_ctx.
> + * Only trampoline and cgroup-bpf have it.

this is not true already (perf_event and kprobe/uprobe/tp progs have
bpf_ctx as well) and can easily get out of sync in the future, so I'd
drop the list of types that support bpf_ctx.

> + * For the bpf prog type that has initialized the bpf_ctx,
> + * this function can be used to decide if a kernel function
> + * is called by a bpf program.
> + */
> +static inline bool has_current_bpf_ctx(void)
> +{
> +       return !!current->bpf_ctx;
> +}
>  #else /* !CONFIG_BPF_SYSCALL */

[...]
