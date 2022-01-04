Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45045483F3A
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 10:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbiADJd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 04:33:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiADJd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 04:33:29 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D67D8C061784
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 01:33:28 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id p15so56007451ybk.10
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 01:33:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sV4yHznO3WoCUk8Xbzjv/jkThMB/Iipt7YNLs0Fsplc=;
        b=o3tLBRivZrLM/ca1quFZtAs0AGmlI6EW6iwli679v6RIn5gcQh7OlQv5rroykJ+mQU
         6GZeLIyZOxvqa5sNaaXkSMRa3Mn+hYZt+GtEn/+nPAuc7hPT/QT5ivgCCx5N2h948m2A
         LGHuxy/ddqZMjgdLWBJjOVGnfnBZcckizyUnRamY+YPCH3butSwqcPVxWmn9ZOnAXrbx
         f+KSiDXA5vQ1A07icfVV6oRFoAPw4zHlbwpRsBuhh8djHPz59Wy+WPnqzCOlV1BiiPBp
         eAXrgcfwzfbZMXPmI03q6GjSkalClakctYHDpZzmKtemYTnJNbLoQPIvJ2WGOjne3HNk
         0Wyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sV4yHznO3WoCUk8Xbzjv/jkThMB/Iipt7YNLs0Fsplc=;
        b=ys4A9GK7vUtBhv/18dYq80v/7as8toqW0iFzRhnGLRFd1A5OGmeD4dw/xCZci7Wwqk
         /wpuAhGPkniOzuYg8sKmcAimkE6Y0/viiDoCT7VAVlby6B5ct5U4f3J4fN4Fw9uIsEiC
         rmQLHCbESwEJN3U4fNAWNYLGItgESa+/nzBaoT2yavKkjo3Hs84VdMUHSTDSynfAownl
         MLp4W2AJ0FqcZw9c0xsdDCfidyh3hANJeP/CpdiIggVmfReTHTRQnPFeVZpnS5l9hsUm
         tFaouNGG4yVkvQJNKSfN23JMuHuVAJ+s/7SdN3iqSWB1LRAw7a5jmixkilte8DRTQztQ
         uawg==
X-Gm-Message-State: AOAM5337wKSHgdQmMh/BXJB6lZuPRWB8ik8K5ED4vbojSiI2/ZB88X9E
        Obvosm39ZkmoMbB3ZX2KwD57WDPe8obIiqcliVBrcA==
X-Google-Smtp-Source: ABdhPJzQLS3HM1kLOJGvHhbWiUFa7BQuO/yFMUD6/cRWb+qIhY5lROtxNxSJNjO2nqAFybodjaJvissYteZpAg/FPaY=
X-Received: by 2002:a25:d195:: with SMTP id i143mr48217059ybg.711.1641288807546;
 Tue, 04 Jan 2022 01:33:27 -0800 (PST)
MIME-Version: 1.0
References: <20220104090130.3121751-1-eric.dumazet@gmail.com> <d5776f5d-3416-4e3b-8751-8a5a9e6a0d4d@iogearbox.net>
In-Reply-To: <d5776f5d-3416-4e3b-8751-8a5a9e6a0d4d@iogearbox.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 4 Jan 2022 01:33:16 -0800
Message-ID: <CANn89iKkTb0=6_uGj7dnvGm6=yjet8AhXG2nEC49A6dE7DfwaQ@mail.gmail.com>
Subject: Re: [PATCH net] bpf: Add missing map_get_next_key method to bloom
 filter map
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>, Yonghong Song <yhs@fb.com>,
        Joanne Koong <joannekoong@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 4, 2022 at 1:21 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Hi Eric, [ +Joanne, ]
>
> On 1/4/22 10:01 AM, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > It appears map_get_next_key() method is mandatory,
> > as syzbot is able to trigger a NULL deref in map_get_next_key().
> >
> > Fixes: 9330986c0300 ("bpf: Add bloom filter map implementation")
> > Reported-by: syzbot <syzkaller@googlegroups.com>
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Alexei Starovoitov <ast@kernel.org>
> > Cc: Yonghong Song <yhs@fb.com>
>
> Thanks for your patch, this has recently been fixed:
>
>    https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=3ccdcee28415c4226de05438b4d89eb5514edf73
>
> I'm not quite sure why it was applied to bpf-next instead of bpf (maybe assumption was
> that there would be no rc8 anymore), but I'd expect it to land in Linus' tree once merge
> window opens up on 9th Jan. In that case stable team would have to pick it up for 5.16.
>

Ah, this is why I could not find the fix in bpf or net tree, thanks.


> Thanks,
> Daniel
