Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958553BF29D
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 01:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbhGGXwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 19:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhGGXwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 19:52:19 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0187EC061574;
        Wed,  7 Jul 2021 16:49:38 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id r135so6053879ybc.0;
        Wed, 07 Jul 2021 16:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M62+xgW8tbtCkoE/qKRY/F/lq3oX6OU+lrgDIeeGUJI=;
        b=o81Nx/Y/DTY6FoB3IW6z6OqQpZil1gT/cBeR3xNdRkfiszkBgfH4ArUls8s4L6pEsj
         2W3Fg7Hxm/xuZvzQmRwEF3VnPrgSFwxeWBuAjErcUvrI03tMX01AJ5DxZXATnK+WJybD
         4EnJ5enwruhx7XUVlJz6rS7eA0M+WWo2NqVrznV/JNiTpUmdHM3AEXxqYeCaMupmzb0s
         bk77vQ1jyhZnKJSLutkaHsccf24BcVbgwkiIwiDgK5IePs0wlH2bcr/7i4tN0Cr1yMcR
         X2/lf+g+DcJfj3gqMYBz0GvUnYkYvL0imaOe/2sd2Vxk6Fy7ee0U9dPbf3gf08AQIaE1
         i0lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M62+xgW8tbtCkoE/qKRY/F/lq3oX6OU+lrgDIeeGUJI=;
        b=p/fNHF5ZuVG2sUNAvq1eTGvfN5sgICFLRqLCUMnnvcqoqWjWRQ1KhtIdwF0JMzKc2l
         /qzbF0UuNyXaANrGJUolHupKirFcYfcwWaOoGlF9bltkIBVzcJ17S6kseiTntj3B18PJ
         RGstBZxqVRVgmCpgHNfiGY9k38ehf4NzmVe+X4PTSO5rr3TmCSMoZvA+6YeVfrv3V/Yx
         DZz5Y98jZ/K9hKCvtdF0OcVoKS8b+ZiXoUAHv/l8bZSzh1Lo1mM8UaI4xXheGyQtlGxK
         t9gKSP9WPJrujnFmwOz7ehcXrnLzkiAkao8kMBNibJOW/bHEIx/p24+rB9Ddq+Z/nmVP
         feqw==
X-Gm-Message-State: AOAM532/Jwao1ieQn5m66wUxXGIcruKtomLpYGxPek4Awhq7Hkkh2SXn
        t+hfEILDiGxoy1ZeVN/WmNksplY7ehYgy1eK/gc=
X-Google-Smtp-Source: ABdhPJyfABX1O38vDqWzo/jHf5GAudd8qlqgCVCYhgmC/vW6hNu9bpBNpYY6VmvHX4HxolQrS4k1Z1MMLmw6BeZJWQQ=
X-Received: by 2002:a25:3787:: with SMTP id e129mr34722432yba.459.1625701777220;
 Wed, 07 Jul 2021 16:49:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210629095543.391ac606@oasis.local.home> <CAEf4BzZPb=cPf9V1Bz+USiq+b5opUTNkj4+CRjXdHcmExW3jVg@mail.gmail.com>
 <20210707184518.618ae497@rorschach.local.home>
In-Reply-To: <20210707184518.618ae497@rorschach.local.home>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 7 Jul 2021 16:49:26 -0700
Message-ID: <CAEf4BzZ=hFZw1RNx0Pw=kMNq2xRrqHYCQQ_TY_pt86Zg9HFJfA@mail.gmail.com>
Subject: Re: [PATCH] tracepoint: Add tracepoint_probe_register_may_exist() for
 BPF tracing
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        syzbot+721aa903751db87aa244@syzkaller.appspotmail.com,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 7, 2021 at 3:45 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 7 Jul 2021 15:12:28 -0700
> Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> > There doesn't seem to be anything conceptually wrong with attaching
> > the same BPF program twice to the same tracepoint. Is it a hard
> > requirement to have a unique tp+callback combination, or was it done
> > mostly to detect an API misuse? How hard is it to support such use
> > cases?
> >
> > I was surprised to discover this is not supported (though I never had
> > a use for this, had to construct a test to see the warning).
>
> The callback is identified by the function and its data combination. If
> there's two callbacks calling the same function with the same data on
> the same tracepoint, one question is, why? And the second is how do you
> differentiate the two?

For places where multiple BPF programs can be attached (kprobes,
cgroup programs, etc), we don't put a restriction that all programs
have to be unique. It's totally legal to have the same program
attached multiple times. So having this for tracepoints will be a
one-off behavior.

As for why the user might need that, it's up to the user and I don't
want to speculate because it will always sound contrived without a
specific production use case. But people are very creative and we try
not to dictate how and what can be done if it doesn't break any
fundamental assumption and safety.

>
> -- Steve
