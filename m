Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A09A3BC2E3
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 20:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbhGESzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 14:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbhGESzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 14:55:20 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D74B5C06175F
        for <netdev@vger.kernel.org>; Mon,  5 Jul 2021 11:52:41 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id o7so10594717vss.5
        for <netdev@vger.kernel.org>; Mon, 05 Jul 2021 11:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CsKdkHbuBPD2Gcdm0gZ0pxBBsvN9q/irczUpL7TbVnY=;
        b=s6NbtxjP8I9FIBgeUHiGzKWBeDfHtboUVcxG6y7xNCM9n5TMHRghpBkPNGMmBwW12B
         kGHI/yAkoiQl1PLnHvaxMDmccT3Y1m5cJm9PpOV98O90UzqBqjTOkb6ZnqdEVa4W+xNh
         Vp4JZ6nygBZG7A6lEvBrTDpsg3e4gpZASz6u8WDxIaWsS/dv4/ZCvKfPwpRZpn8+Q/we
         K0R3FtrUQeq6/BpXvMVXlft3pE/C1i9dEykhwTSHFKX9bfjoaUYp7l5LL2zP3ZIKmVdm
         LuJ+LyjC8pFHm3fMYf5dg4LrZZBc5ztnSx0UtIZZyASSbGPAltfVUaQtcgn45vn+U0fW
         9Fww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CsKdkHbuBPD2Gcdm0gZ0pxBBsvN9q/irczUpL7TbVnY=;
        b=JeZ1BTBihiJ972t6qOgwFA36BNsRoGk7NbsEbEsLboZ/4dKsL6LmfzdvkJmxrVix5j
         iYYaW/Akmi1YIqM8HzSpRdHyu9jNEqToD7GzYfHIrNNii5X14JYSK+qM+D9VfGgkdd+3
         qnybP80iwpeJuO5CNhJwGNkObhjfdxLqgZZQRboE+CharEGAeaC6LXAEeOkrQq8y90TB
         MSOsd2SZCUa4QXFM/T41iG0bDdBMqKqvf4tCYnqLoCkdzc58Y7hzSgrDqbd41LsHZQ/1
         e4Jq+m7Z+YKvNV90L/52AjXVzDM6Mh/TvUJCR1z21ChvSJwZnnG7YrtCFxuxEyFCy7OT
         y2PA==
X-Gm-Message-State: AOAM533O6hZW/Vxaw9lPybEK5RCMorhc/dlRiajQA4fmcub7nQ/caJdf
        Uc647V2ZSnhe8XkmYMc/NrBQPnuntwP5lhRvcVZL3w==
X-Google-Smtp-Source: ABdhPJwLm8mKpOQUltOsVP1fdOymZXdXyoMOgOViH4N34T5gMl2NCQhyeRjsXINy7mBVKAtCCYNbbjI4KYLHcwGaIKQ=
X-Received: by 2002:a67:f7c8:: with SMTP id a8mr5129788vsp.16.1625511160510;
 Mon, 05 Jul 2021 11:52:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210705171823.524171-1-phind.uet@gmail.com>
In-Reply-To: <20210705171823.524171-1-phind.uet@gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Mon, 5 Jul 2021 14:52:23 -0400
Message-ID: <CADVnQymo8xmN44zwvrpMLs0pxGt3XTT_vosR-1TJJURgVWO1ZA@mail.gmail.com>
Subject: Re: [PATCH v5] tcp: fix tcp_init_transfer() to not reset icsk_ca_initialized
To:     Nguyen Dinh Phi <phind.uet@gmail.com>
Cc:     yhs@fb.com, edumazet@google.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, ycheng@google.com, yyd@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+f1e24a0594d4e3a895d3@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 5, 2021 at 1:18 PM Nguyen Dinh Phi <phind.uet@gmail.com> wrote:
>
> This commit fixes a bug (found by syzkaller) that could cause spurious
> double-initializations for congestion control modules, which could cause
> memory leaks orother problems for congestion control modules (like CDG)

nit: typo: "orother" -> "or other"

> that allocate memory in their init functions.
>
> The buggy scenario constructed by syzkaller was something like:
>
> (1) create a TCP socket
> (2) initiate a TFO connect via sendto()
> (3) while socket is in TCP_SYN_SENT, call setsockopt(TCP_CONGESTION),
>     which calls:
>        tcp_set_congestion_control() ->
>          tcp_reinit_congestion_control() ->
>            tcp_init_congestion_control()
> (4) receive ACK, connection is established, call tcp_init_transfer(),
>     set icsk_ca_initialized=0 (without first calling cc->release()),
>     call tcp_init_congestion_control() again.
>
> Note that in this sequence tcp_init_congestion_control() is called
> twice without a cc->release() call in between. Thus, for CC modules
> that allocate memory in their init() function, e.g, CDG, a memory leak
> may occur. The syzkaller tool managed to find a reproducer that
> triggered such a leak in CDG.
>
> The bug was introduced when that commit 8919a9b31eb4 ("tcp: Only init
> congestion control if not initialized already")
> introduced icsk_ca_initialized and set icsk_ca_initialized to 0 in
> tcp_init_transfer(), missing the possibility for a sequence like the
> one above, where a process could call setsockopt(TCP_CONGESTION) in
> state TCP_SYN_SENT (i.e. after the connect() or TFO open sendmsg()),
> which would call tcp_init_congestion_control(). It did not intend to
> reset any initialization that the user had already explicitly made;
> it just missed the possibility of that particular sequence (which
> syzkaller managed to find).
>
> Fixes: 8919a9b31eb4 (tcp: Only init congestion control if not initialized already)

Style nit: I believe this Fixes line should have double quotes around
the commit title, like:

  Fixes: 8919a9b31eb4 ("tcp: Only init congestion control if not
initialized already")

Otherwise, this looks good to me, and it passes our internal packetdrill tests.

thanks,
neal
