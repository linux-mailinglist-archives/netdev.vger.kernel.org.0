Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC04743BBC5
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 22:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239266AbhJZUqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 16:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233075AbhJZUpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 16:45:54 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39CBBC061570;
        Tue, 26 Oct 2021 13:43:30 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id f5so654323pgc.12;
        Tue, 26 Oct 2021 13:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gwwDVGZF81Mhz8j8IQvQEBwY8y1hsM9S1VyeSDH2pHo=;
        b=LrfBNtRuWYKT2MOaI4TlljRmB4l0tEOD7mjqXymnqcgMVPrCuzfwtHvwu6rgjkUWsV
         t2cbyzo2nnN6leygKq1742yvjWcnmhB4LXKpzNpxThKh/TMooexnyZMYMjCbrlzTcO7Q
         7HjClDSZj1I6kg2qJ7t3oapYaGASsHijO5/ROk+c6FGPBYMPshmB8lnCEwYRnIttVOZ9
         ZMnygXNvNEREtysEbel+Z+l1UTy/2QOMxOihyxHO0iO23bBcFqtnU+frP+hfb/wnyjVl
         DBqLyR0El5s0NjCaS2tsDABcfDUhGJZrFGrFCjNPNo3gzcnI9fs9CVo2pY9nXq+FBqft
         zWvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gwwDVGZF81Mhz8j8IQvQEBwY8y1hsM9S1VyeSDH2pHo=;
        b=fzfJlBYVoMAJj6hQvSUz3gUUEdq+eJsMB76e89JG2IHAw/z/YLtG3bDtvWPfI1YUEg
         Wq2sNuW/VRSYx29uH9u//P53CYtHeGisTIlhhOya8EZDKHq4hLxn3pWhIDuqLxP/t6//
         EoqICKNg7uiQgtRYOQ/S3wZvtWPkqUEINZQaRH0/hQJ9390xA5AmKtrlr4EawQ8YHV0P
         XkOnY7lX29qqYSJ9JJKWxt+v7w5UU0ISIwPP+h+CrK0ULX+Hv3AM6xy09wERgrwDNAfH
         PGgO5c1bLD4VFeihqofrwVjpIx72WOSdScGOMkNVi+3CMh9qROYanGL0Hnjack0namuQ
         M8vQ==
X-Gm-Message-State: AOAM530mM8Gw8wAcmIta1PN3wo7h0sN0/b0o/9rPBtB3apohKtrKCFfp
        4lCmmOu8ASW1L3sTxHTL/acwuqvBHJ0wPXU2XO0=
X-Google-Smtp-Source: ABdhPJyxo4s1BgwU5Y+216l5EIsoOFP7sN62+j7NJnhyqaSpXlY0xsr65vgHGI+DFEsqj/JLnTznSp69I6YZC3ABccE=
X-Received: by 2002:a05:6a00:179c:b0:47c:2092:c28c with SMTP id
 s28-20020a056a00179c00b0047c2092c28cmr2015958pfg.59.1635281009525; Tue, 26
 Oct 2021 13:43:29 -0700 (PDT)
MIME-Version: 1.0
References: <20211026203825.2720459-1-eric.dumazet@gmail.com> <20211026203825.2720459-2-eric.dumazet@gmail.com>
In-Reply-To: <20211026203825.2720459-2-eric.dumazet@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 26 Oct 2021 13:43:18 -0700
Message-ID: <CAADnVQKOXXf4vSKYF2+One8PLfva06d4USdTjQj72S7+czhd_Q@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] bpf: avoid races in __bpf_prog_run() for 32bit arches
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 1:38 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> __bpf_prog_run() can run from non IRQ contexts, meaning
> it could be re entered if interrupted.
>
> This calls for the irq safe variant of u64_stats_update_{begin|end},
> or risk a deadlock.
>
> This patch is a nop on 64bit arches, fortunately.

u64_stats_update_begin_irqsave is a nop. Good!
We just sent the last bpf tree PR for this cycle.
We'll probably take it into bpf-next after CI has a chance to run it.
