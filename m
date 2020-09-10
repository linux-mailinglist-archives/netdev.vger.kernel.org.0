Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDFAF264EC5
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbgIJTZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726588AbgIJTXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 15:23:25 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B74C061573;
        Thu, 10 Sep 2020 12:23:24 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id 195so4780388ybl.9;
        Thu, 10 Sep 2020 12:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hMiSKWvYJc47Rg0r6xcL9TNocO16hZIkQmMEZLc8nlc=;
        b=XNZTDMOFbutNE5bn9DSikUWFa3ob/6bpppLn+Ko6pMQ4Cbzupo1QUv1aERSSC3MjTV
         pTCnVjYUf+zGtveOpr9oF74UKnoMmm0QWzboQGLNjK/N0kE56AK0f7SzGpGGRkwsxkdl
         f+FTXHZYq38zUcmcDfn2wgB1Qb3oEvi6frh47cItxgug/V5jbQLjE18OivRg8qU563nN
         FmtwbaSRWjCHFO8MMVdsMTrOjZLDOADo29WTdFvdvP4fs7SOYXebNcI0JpST8W/eiye0
         W0tXyYaZKpJs4+dViNfUbjKiKgLUXjZobcuLJbtrfBOaaginkLwcGWMWZ1eFTHZ/ac10
         Vh0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hMiSKWvYJc47Rg0r6xcL9TNocO16hZIkQmMEZLc8nlc=;
        b=RLbJkjavJ683xx7EvUHwL039bSQz10Rn+wyO0HGUSfNc5aeyD5f6mRsQ1powfKNhEO
         ZfZHQOZkqGmfsy5QbvXrA3i+0dzLF0sILmlho28ktRlN9WRlohDCVMHXY5ETgTqY+mT7
         EfQJQOcivNs3R+QgLspbB1q1BOpqxGRM/Uom84U2QAEno9fmSwm932W+GcGUu9x00r14
         F+G/UJ/gX201SqoV+xJmK1LUggXaeAHVVZCCuZSx2YhSNO9ahxjIfnHVUOJV1HUq0dKL
         dls5uAemQJUJEhWKAyW1INaqVpYGIITHipg14fSk4hE+eJ6RB7kgsXgqFapr9h+d9XMC
         yopA==
X-Gm-Message-State: AOAM533VXHxeqPsCKXjoqgAck5Ppxl3EPWahk/BNEWyj4SfmXu26n8l8
        cdWoJEaul6MZ1D16+wJZScB0P93DKRpCJ3xYTDg=
X-Google-Smtp-Source: ABdhPJxIQ7gRCIAZYdGqVOgbtOfve+mM9qlKRq3tHJSxcp/CwphVpcAc55Jo0ykBsZu+EzcjHGIFeOj/rTFwxglTSmA=
X-Received: by 2002:a25:9d06:: with SMTP id i6mr13654112ybp.510.1599765803902;
 Thu, 10 Sep 2020 12:23:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200909182406.3147878-1-sdf@google.com> <20200909182406.3147878-2-sdf@google.com>
In-Reply-To: <20200909182406.3147878-2-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 10 Sep 2020 12:23:12 -0700
Message-ID: <CAEf4BzbQ-8=gg_64u0WTsncCj=3ovRyk_craSovttGohc0yZwA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 1/5] bpf: Mutex protect used_maps array and count
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        YiFei Zhu <zhuyifei@google.com>,
        YiFei Zhu <zhuyifei1999@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 9, 2020 at 11:25 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> From: YiFei Zhu <zhuyifei@google.com>
>
> To support modifying the used_maps array, we use a mutex to protect
> the use of the counter and the array. The mutex is initialized right
> after the prog aux is allocated, and destroyed right before prog
> aux is freed. This way we guarantee it's initialized for both cBPF
> and eBPF.
>
> Cc: YiFei Zhu <zhuyifei1999@gmail.com>
> Signed-off-by: YiFei Zhu <zhuyifei@google.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  .../net/ethernet/netronome/nfp/bpf/offload.c   | 18 ++++++++++++------
>  include/linux/bpf.h                            |  1 +
>  kernel/bpf/core.c                              | 15 +++++++++++----
>  kernel/bpf/syscall.c                           | 16 ++++++++++++----
>  net/core/dev.c                                 | 11 ++++++++---
>  5 files changed, 44 insertions(+), 17 deletions(-)
>

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>
