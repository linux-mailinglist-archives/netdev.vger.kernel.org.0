Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBF5AD470E
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 19:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbfJKR7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 13:59:10 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:39356 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728472AbfJKR7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 13:59:10 -0400
Received: by mail-qk1-f195.google.com with SMTP id 4so9677585qki.6;
        Fri, 11 Oct 2019 10:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=asyUShBe9hrWPwsEaTFIAAL62QLdWBJhjs7rcStqxG0=;
        b=fj4Am7uGUF0ksXh1u48ubPvwU+BkGgkKf7jojTrTszzFabLYX/hUSm9lwrVYae1lfe
         xlXjK0f8/9I9onhCIC204rjgLB3cDsBOoE89cZV7fU3lh4ELonjbtORHb6i1I2UXX3Xs
         +2g1sNuqBT7mOxrqkQeGoB0YnqjUZX4BfRnSErhkD5anB9sAADEBKdsFGTrue80Ia/rL
         88EEgZ6lO5eGw7Xh/oFb+FV2LmKjjqPn/y7GnkJf01y05HXKZ44/od8ZJxs7Yw//Kw8B
         QqlCFniTVM7mLAkaZbcWqqsfkp6wX7pevmnJlBDYxYJU35lMylerEl5grHii0fuRLaRf
         Uavg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=asyUShBe9hrWPwsEaTFIAAL62QLdWBJhjs7rcStqxG0=;
        b=LCG0EXJenPaX+T04ePO4McbvZxqrk7vzhUSBWdSYUGoRMnZXSuugvIAe3BQYOeLMU1
         UOwMDL/TWh3vr9zWoVA5ZsHA3JSodvMilAgAobauOIClgT+y5Ymw8XWAPVJO+OUhEaXy
         36JWZlby6Ua4hPeqg354EcPuDDGs7+v2AEXrf/noyiC769uQcHdeLEEnvsgsFOeqcfmI
         z9U0raqQ/9/Bw08OLo+KvioPYJG3/MoEZ1xfVh7TLcOy0pu5xzmISSNLtT63Lc6/9Cxc
         tTpORlxMKIqXtGajXVzhU3YR17cOtGr4xFxtrR75yYsw0POtlLP7vmG2V9WmHgOMBSLh
         EWNA==
X-Gm-Message-State: APjAAAUr3VnkF9pd92hHkTcw8VH1A8pNLZeJLvHZ7gqNetXS9yFihnKP
        kUaoXpJ0TkUaD9FVQrjyN34VyuEFal4jLrGNpYc=
X-Google-Smtp-Source: APXvYqyyLTqZy6qVF80L4pQGhcB7EX1Rz7Ssi1KW4RZ+Yjwao5oMfjrKJXcuuoOs3/RrzU1JWqiAKmHvluWuW6qNYA8=
X-Received: by 2002:a37:6d04:: with SMTP id i4mr17408293qkc.36.1570816749534;
 Fri, 11 Oct 2019 10:59:09 -0700 (PDT)
MIME-Version: 1.0
References: <20191010041503.2526303-1-ast@kernel.org> <20191010041503.2526303-5-ast@kernel.org>
In-Reply-To: <20191010041503.2526303-5-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 11 Oct 2019 10:58:57 -0700
Message-ID: <CAEf4BzaUOY3YnULr3JX6d+f0q4Hh5_RrK+cGgib=jfpofvd4jw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 04/12] bpf: add attach_btf_id attribute to
 program load
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>, x86@kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 9, 2019 at 9:16 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Add attach_btf_id attribute to prog_load command.
> It's similar to existing expected_attach_type attribute which is
> used in several cgroup based program types.
> Unfortunately expected_attach_type is ignored for
> tracing programs and cannot be reused for new purpose.
> Hence introduce attach_btf_id to verify bpf programs against
> given in-kernel BTF type id at load time.
> It is strictly checked to be valid for raw_tp programs only.
> In a later patches it will become:
> btf_id == 0 semantics of existing raw_tp progs.
> btd_id > 0 raw_tp with BTF and additional type safety.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

Looks good!

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  include/linux/bpf.h            |  1 +
>  include/uapi/linux/bpf.h       |  1 +
>  kernel/bpf/syscall.c           | 18 ++++++++++++++----
>  tools/include/uapi/linux/bpf.h |  1 +
>  4 files changed, 17 insertions(+), 4 deletions(-)
>

[...]
