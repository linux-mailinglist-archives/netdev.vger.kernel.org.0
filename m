Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B23534A768D
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 18:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346146AbiBBRK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 12:10:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346137AbiBBRKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 12:10:24 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD59DC061744
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 09:10:23 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id 23so580178ybf.7
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 09:10:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XG1X/wZ/ZoYyPeMpStw8R5fokE+if4S4Pzc2vn8XhRo=;
        b=bDITXQEANoH7aJoCTHhl0ysn6MuN4qfypa6ie2Vzk5+fc2H/mWcHbi9efUgVRr9QLc
         RAmzF0ofW7JSONT5E8NZxcap7YisZt/XZgDce6xVLh3RVw9TcPRkYXJwEhiMtaF1bqSS
         /x+wPiCOAVrNmWiyHwnVLR9QY87dyX758aiSaTyZ5QC5YDw2XIU6gdW7Kw+2zkOPZUSh
         Z7KTObw6/02tAZnjr4HyxXTmjKPhkbFb0W836l5d3W6O724LmHWOnZDXw9wI4Ctx26NB
         ek6AMJL0N95DWSlvziNSuk4HHyQRwfZ3iJ/zd15ws2Wo1D7gXtxH7LuvGq+Eqt33wA4Z
         Eycg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XG1X/wZ/ZoYyPeMpStw8R5fokE+if4S4Pzc2vn8XhRo=;
        b=TjTzMAmgSBimRdR3P2b7SEomOqeBibACfxNBtjFOTpqDbCFmmnNGxOmBqD0VuRAvRi
         IYXrsMWy7nfTzZTdwIhja6EeIrKqVVNjrBtq7+11BwFNAp9UiajrqLDvjzXfxa0S8Ef+
         2OmvjWxpKQRr/muRo3U8ij0enAnmZwYhBMkjgUrm03U35mzcxAtr5xN9YjdZ2wpxgd2E
         bUvpduhEeJsuREVXcETdTVV6PIn+PPWA6ktQpXygY46+7e8LaxZyh8oSYDQ8xkfikCo+
         Vv9YA+Gt6Nn2veRM66SHbicUhqCuKQzZFFB2ttGXkCnSNXC1Ry9kXYBJ/knZFie+/XtP
         Xkcw==
X-Gm-Message-State: AOAM532YDvm/x+f29HlmDUvfZiJ/nMYOgKw3S7of/iul2aiIQOpbxnzY
        Osu0haWBa7DF9DlOP5H5MZ0tqBTII2wv0efuRmEoSO4QhXZNr/+BL/M=
X-Google-Smtp-Source: ABdhPJw3FW5dSG3KUKjK9dVdB7rA8e9KF51jk+u0RrjQdLBkXz/F6yo0VBJ5raK5KXoJVT96cJI1cuJYD+uB56ZqSZo=
X-Received: by 2002:a25:8885:: with SMTP id d5mr23524887ybl.383.1643821822452;
 Wed, 02 Feb 2022 09:10:22 -0800 (PST)
MIME-Version: 1.0
References: <20220202122848.647635-1-bigeasy@linutronix.de> <20220202122848.647635-2-bigeasy@linutronix.de>
In-Reply-To: <20220202122848.647635-2-bigeasy@linutronix.de>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 2 Feb 2022 09:10:10 -0800
Message-ID: <CANn89iJm9krQ-kjVBxFzxh0nG46O5RWDg=QyXhiq1nA3Erf9KQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/4] net: dev: Remove the preempt_disable() in netif_rx_internal().
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 2, 2022 at 4:28 AM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> The preempt_disable() and rcu_disable() section was introduced in commit
>    bbbe211c295ff ("net: rcu lock and preempt disable missing around generic xdp")
>
> The backtrace shows that bottom halves were disabled and so the usage of
> smp_processor_id() would not trigger a warning.
> The "suspicious RCU usage" warning was triggered because
> rcu_dereference() was not used in rcu_read_lock() section (only
> rcu_read_lock_bh()). A rcu_read_lock() is sufficient.
>
> Remove the preempt_disable() statement which is not needed.

I am confused by this changelog/analysis of yours.

According to git blame, you are reverting this patch.

commit cece1945bffcf1a823cdfa36669beae118419351
Author: Changli Gao <xiaosuo@gmail.com>
Date:   Sat Aug 7 20:35:43 2010 -0700

    net: disable preemption before call smp_processor_id()

    Although netif_rx() isn't expected to be called in process context with
    preemption enabled, it'd better handle this case. And this is why get_cpu()
    is used in the non-RPS #ifdef branch. If tree RCU is selected,
    rcu_read_lock() won't disable preemption, so preempt_disable() should be
    called explictly.

    Signed-off-by: Changli Gao <xiaosuo@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>


But I am not sure we can.

Here is the code in larger context:

#ifdef CONFIG_RPS
    if (static_branch_unlikely(&rps_needed)) {
        struct rps_dev_flow voidflow, *rflow = &voidflow;
        int cpu;

        preempt_disable();
        rcu_read_lock();

        cpu = get_rps_cpu(skb->dev, skb, &rflow);
        if (cpu < 0)
            cpu = smp_processor_id();

        ret = enqueue_to_backlog(skb, cpu, &rflow->last_qtail);

        rcu_read_unlock();
        preempt_enable();
    } else
#endif

This code needs the preempt_disable().


>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  net/core/dev.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 1baab07820f65..325b70074f4ae 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4796,7 +4796,6 @@ static int netif_rx_internal(struct sk_buff *skb)
>                 struct rps_dev_flow voidflow, *rflow = &voidflow;
>                 int cpu;
>
> -               preempt_disable();
>                 rcu_read_lock();
>
>                 cpu = get_rps_cpu(skb->dev, skb, &rflow);
> @@ -4806,7 +4805,6 @@ static int netif_rx_internal(struct sk_buff *skb)
>                 ret = enqueue_to_backlog(skb, cpu, &rflow->last_qtail);
>
>                 rcu_read_unlock();
> -               preempt_enable();
>         } else
>  #endif
>         {
> --
> 2.34.1
>
