Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DADC539A07
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 01:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348666AbiEaXYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 19:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237601AbiEaXYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 19:24:35 -0400
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5D5D986FF;
        Tue, 31 May 2022 16:24:34 -0700 (PDT)
Received: by mail-vs1-xe2f.google.com with SMTP id m2so15132839vsr.8;
        Tue, 31 May 2022 16:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X8NQSLGpMgyeSzyTFR/eiSJaBDGqCzZaUfnmBuIPtvI=;
        b=TKBarPqKZeLxaOsjJs9mfLFKLotX63kAeKGsd29GV07y5Rxsxnw468xyi/RDJP1a8P
         2gGSIKApmoFC+0RbJx75E/yHwdK3zswSHRIVkbbXvOtE4yJpkZtWKTJUNCAOZHGAFQXf
         5PUoKlro4OGa5MzFXQbFu8W7TfW5kGSRv3elOP65G6FX5qXmUdtLhq/YFropYSn3cxwX
         w4uoNencWQsCECl1HcthagOS0gNU9X7zSSG/5nPRp/gn9wI+hgbVkDNpYKUzuziq6EGh
         FzS6l7lQSNPbrqqi5jaJuVt1PvjZpH2qhebf7rc8FQnOAB7LsDKzcAkKx6eHY22JZfCQ
         ZHcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X8NQSLGpMgyeSzyTFR/eiSJaBDGqCzZaUfnmBuIPtvI=;
        b=idJ/8C38T9r8vq+pl34LTu33bzC4n2emTjq1PIQCGsLzsQM1jTrTjPSnPp2z0a13V4
         5FqpolahRa0g5gVp/mFlfU5SmXi6gvY0zhHv3fhsAAjHtSpQFpOuolYwRkqSSL70g17+
         xCgVTBdz26bD82Tjhslt/jiYlDV9GpS6xY0LvW4dBaYMMhTWjBkXML0biu6gij18VOSa
         9HUIODS15/9jtTi5xDBeElKCkWQPIrHrU62jRrGavzhle0nOoE1noUrq+7/WwO3Q74JC
         6usdAnDeIvddjEa1NQtEUROT5cggR8JXhfEYzSWSe7EFO36m5AXuQ1tTbnSv44jCCuFw
         fjZA==
X-Gm-Message-State: AOAM533Z7yD0ZFwR6TCCoRyjdp+e8Jjr5b7Qz6IF8xpODqibv4wcELRv
        EZMauIH8YCdslpjqKugqsgecOJnDcKE42MRNBkM=
X-Google-Smtp-Source: ABdhPJwA+MfxhHBX6PXf8Sr0uX8Ec2jl81Nz3Y4jrSvjLyNMZHWYu0ocV4XGip8N4J944FM/DVglQAGx0JWRjxjgC8E=
X-Received: by 2002:a67:e0d5:0:b0:337:b2f4:afe0 with SMTP id
 m21-20020a67e0d5000000b00337b2f4afe0mr19014822vsl.11.1654039473897; Tue, 31
 May 2022 16:24:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220525114003.61890-1-jolsa@kernel.org>
In-Reply-To: <20220525114003.61890-1-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 31 May 2022 16:24:22 -0700
Message-ID: <CAEf4BzZ-xe-zSjbBpKLHfQKPnTRTBMA2Eg382+_4kQoTLnj4eQ@mail.gmail.com>
Subject: Re: [RFC bpf-next] bpf: Use prog->active instead of bpf_prog_active
 for kprobe_multi
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
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

On Wed, May 25, 2022 at 4:40 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> hi,
> Alexei suggested to use prog->active instead global bpf_prog_active
> for programs attached with kprobe multi [1].
>
> AFAICS this will bypass bpf_disable_instrumentation, which seems to be
> ok for some places like hash map update, but I'm not sure about other
> places, hence this is RFC post.
>
> I'm not sure how are kprobes different to trampolines in this regard,
> because trampolines use prog->active and it's not a problem.
>
> thoughts?
>

Let's say we have two kernel functions A and B? B can be called from
BPF program though some BPF helper, ok? Now let's say I have two BPF
programs kprobeX and kretprobeX, both are attached to A and B. With
using prog->active instead of per-cpu bpf_prog_active, what would be
the behavior when A is called somewhere in the kernel.

1. A is called
2. kprobeX is activated for A, calls some helper which eventually calls B
  3. kprobeX is attempted to be called for B, but is skipped due to prog->active
  4. B runs
  5. kretprobeX is activated for B, calls some helper which eventually calls B
    6. kprobeX is ignored (prog->active > 0)
    7. B runs
    8. kretprobeX is ignored (prog->active > 0)
9. kretprobeX is activated for A, calls helper which calls B
  10. kprobeX is activated for B
    11. kprobeX is ignored (prog->active > 0)
    12. B runs
    13. kretprobeX is ignored (prog->active > 0)
  14. B runs
  15. kretprobeX is ignored (prog->active > 0)


If that's correct, we get:

1. kprobeX for A
2. kretprobeX for B
3. kretprobeX for A
4. kprobeX for B

It's quite mind-boggling and annoying in practice. I'd very much
prefer just kprobeX for A followed by kretprobeX for A. That's it.

I'm trying to protect against this in retsnoop with custom per-cpu
logic in each program, but I so much more prefer bpf_prog_active,
which basically says "no nested kprobe calls while kprobe program is
running", which makes a lot of sense in practice.

Given kprobe already used global bpf_prog_active I'd say multi-kprobe
should stick to bpf_prog_active as well.


> thanks,
> jirka
>
>
> [1] https://lore.kernel.org/bpf/20220316185333.ytyh5irdftjcklk6@ast-mbp.dhcp.thefacebook.com/
> ---
>  kernel/trace/bpf_trace.c | 31 +++++++++++++++++++------------
>  1 file changed, 19 insertions(+), 12 deletions(-)
>

[...]
