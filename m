Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 329F32C0BD5
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 14:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730250AbgKWNbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 08:31:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731864AbgKWNb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 08:31:28 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1635C0613CF;
        Mon, 23 Nov 2020 05:31:27 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id r17so18655743wrw.1;
        Mon, 23 Nov 2020 05:31:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6VjVsILSsDd5SInux6/cPvrLq3EX5hfYBfnNEoH8afc=;
        b=p3hPzFrD8yTk9+Gx4YckDx35JRnq+e6c0hSMGloeC/toffjNM/LrzjXcNTcdTTPFUh
         UpENDkd8Cabeebm20HEr2p3HAfjLKzHjtWCw71w85vNXLp/v6TmQSXg6vMIqZ3hsjqgM
         cbXHXSyHvUUnJhL0DQQnMvvenDqPnO5LRqTbHADqUj2IlXtwe1bt6kwvZDeHzDUie5ne
         GiBxdItO6teTxK1KPCKTLzujQMKjR/sjfwb4LfTl0WSPan7YhkLrAsqgTsLemLlqLQz7
         4K/hEUkLxPoDBn6SCIZfmBFUpngYscaQQWSYKjftNF2pLBM6vJTHzfbDwTT9pRee3aQ/
         1W1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6VjVsILSsDd5SInux6/cPvrLq3EX5hfYBfnNEoH8afc=;
        b=gXtxHEGadMmCMpGFBUWwFA4P9nbzkrOXC/WDrUo/XgWISt0wY2DDnzEnLYx6q4nSS1
         CUbHzr2tCKptifFD2YsPhsQaIxCa5SMjVqwFG2eUSTPpPNhV2WJG/JkGxhOrfjhZVsgD
         6sAX3/r8g8Xd1Te1Ep49ajyoKrbfn04b/AVn+SU8WaOu/YnjRY83q06lwRKN5iOSxwqD
         CL8GVWSMBpdwtf1F9sIK70pipyjei84JSpYQLUitk0hW4JuWreBPPj7hkoqgc6UgLxY2
         4clNC32huc5/yIisYy5z3/5vB9U2Q0AksW6X9tV9LFOHWAszZh+VwZ+B6tg5lqQL+HR7
         cyrw==
X-Gm-Message-State: AOAM533pFIfK0epNNxQziOiKtH4P7ojz68Tms1sv+NQCmVoZ0Gop6IrK
        2OLmjm9/EBD86S5cznBhaWPPykDN70/Zztc5mHg=
X-Google-Smtp-Source: ABdhPJxHjYOYrucIemLufVB68BJFElUQ078uhX2AV6WAjHWd+fVmVZV/gI+EsM1L9UvKZOVEKQYr9iP1U/rL89E2NDk=
X-Received: by 2002:adf:f241:: with SMTP id b1mr30710060wrp.248.1606138286688;
 Mon, 23 Nov 2020 05:31:26 -0800 (PST)
MIME-Version: 1.0
References: <20201119083024.119566-1-bjorn.topel@gmail.com>
In-Reply-To: <20201119083024.119566-1-bjorn.topel@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 23 Nov 2020 14:31:14 +0100
Message-ID: <CAJ+HfNh4Kybjuzi1KOvJBUBvQWFDCZgt7zZNU=ZS8FLCsNKiRQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 00/10] Introduce preferred busy-polling
To:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Netdev <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Zhang, Qi Z" <qi.z.zhang@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>, maximmi@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Nov 2020 at 09:30, Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>=
 wrote:
>
> This series introduces three new features:
>
> 1. A new "heavy traffic" busy-polling variant that works in concert
>    with the existing napi_defer_hard_irqs and gro_flush_timeout knobs.
>
> 2. A new socket option that let a user change the busy-polling NAPI
>    budget.
>
> 3. Allow busy-polling to be performed on XDP sockets.
>
> The existing busy-polling mode, enabled by the SO_BUSY_POLL socket
> option or system-wide using the /proc/sys/net/core/busy_read knob, is
> an opportunistic. That means that if the NAPI context is not
> scheduled, it will poll it. If, after busy-polling, the budget is
> exceeded the busy-polling logic will schedule the NAPI onto the
> regular softirq handling.
>
> One implication of the behavior above is that a busy/heavy loaded NAPI
> context will never enter/allow for busy-polling. Some applications
> prefer that most NAPI processing would be done by busy-polling.
>
> This series adds a new socket option, SO_PREFER_BUSY_POLL, that works
> in concert with the napi_defer_hard_irqs and gro_flush_timeout
> knobs. The napi_defer_hard_irqs and gro_flush_timeout knobs were
> introduced in commit 6f8b12d661d0 ("net: napi: add hard irqs deferral
> feature"), and allows for a user to defer interrupts to be enabled and
> instead schedule the NAPI context from a watchdog timer. When a user
> enables the SO_PREFER_BUSY_POLL, again with the other knobs enabled,
> and the NAPI context is being processed by a softirq, the softirq NAPI
> processing will exit early to allow the busy-polling to be performed.
>
> If the application stops performing busy-polling via a system call,
> the watchdog timer defined by gro_flush_timeout will timeout, and
> regular softirq handling will resume.
>
> In summary; Heavy traffic applications that prefer busy-polling over
> softirq processing should use this option.
>

Eric/Jakub, any more thoughts/input? Tomatoes? :-P


Thank you,
Bj=C3=B6rn
