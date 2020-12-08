Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9202D3480
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 21:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729838AbgLHUrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 15:47:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbgLHUrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 15:47:16 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F98C0613CF
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 12:46:29 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id r7so6369470wrc.5
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 12:46:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+1ZVqecGz0wOFZN4RC+eb9I3pSj+STpuNZl0QBHhAIg=;
        b=pdavAJHs04IAGauMEk3829Ux4+t93GInpAn/rRMXQAa7ca6XtyNGSMX5yTCZ1bM9oX
         tnPQOPgseutTABUjMr01cvJDVeWA8G2VbH8R3kGEAthXMv4z5GITA6IwFnBklgCXJ84C
         g3gipyI5oM2q/4zMynUJXzUQPyrwsoFDv95iGpHLghC4hX7YQDAx/p7vWlBdUFbg3TBi
         YKazbSzU+hbT3nMzS2c1WXOdUHeWzA5aWWk6KMo71fdN/tm7+aHEZ5r8LEg5XkR52soh
         cZiURa4di3aDlwwwy6mQjMbY2a36W8Wqe+LnQ/zBSZcqfhywXj/eFNdKQEpP8S0ndG8a
         S0Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+1ZVqecGz0wOFZN4RC+eb9I3pSj+STpuNZl0QBHhAIg=;
        b=TeqFeNCEKxVd9mz6T/PJ/3CTUJ3nxl5Ot9Ypbdb/M0DOLmPJ+JT971M4HFaPfKFh9I
         vMMemhkDf19gyr9+Xsnh2uyxarj+jTASNc1g5pr9z2JsJ974HB00HbdPCJ0BscSO8ODy
         2B6puq2xTKc0ZemJBWN9b0kQdJDQadoQehrDG1tCWxl7dgiE2lFI3yOp6IKvnFNcUOPf
         bobg0+MgUIwnQsd7Vb5WODbkGLKeS2lrpJnDENzE1tR87vSaVOY57N2trKiUk64yHmTa
         n4LPVw3WdKMp27+xqy7xpeGnlGuKKP+poki6fpTy3uLYuvmutm5+YCtqJ/HgqtK3qMXa
         PaIA==
X-Gm-Message-State: AOAM530LfJcwkE3d+apXSE+B/7oKpi/S2tzvgickyKzkUhl1Afdzt/Pu
        X2YhGHrPFjIdIGvLUz8x5xNafz5MB3lFMPLVhQ+ZTA==
X-Google-Smtp-Source: ABdhPJyBBx8xxAe1u5ynRJuW/Y0MRvgV6pPsNMqdT/Yd00m2KBmjTpCfmBGOkWUzu0OX1kViXREmrvpknY0uT+VD6vw=
X-Received: by 2002:adf:e512:: with SMTP id j18mr11832427wrm.52.1607460388345;
 Tue, 08 Dec 2020 12:46:28 -0800 (PST)
MIME-Version: 1.0
References: <20201208162131.313635-1-eric.dumazet@gmail.com>
In-Reply-To: <20201208162131.313635-1-eric.dumazet@gmail.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Tue, 8 Dec 2020 15:45:52 -0500
Message-ID: <CACSApvZe-iCvasMc7tF5f7uWSo_=sQyN7JCErwM2RgGXce-XaQ@mail.gmail.com>
Subject: Re: [PATCH net] tcp: select sane initial rcvq_space.space for big MSS
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 8, 2020 at 11:21 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> Before commit a337531b942b ("tcp: up initial rmem to 128KB and SYN rwin to around 64KB")
> small tcp_rmem[1] values were overridden by tcp_fixup_rcvbuf() to accommodate various MSS.
>
> This is no longer the case, and Hazem Mohamed Abuelfotoh reported
> that DRS would not work for MTU 9000 endpoints receiving regular (1500 bytes) frames.
>
> Root cause is that tcp_init_buffer_space() uses tp->rcv_wnd for upper limit
> of rcvq_space.space computation, while it can select later a smaller
> value for tp->rcv_ssthresh and tp->window_clamp.
>
> ss -temoi on receiver would show :
>
> skmem:(r0,rb131072,t0,tb46080,f0,w0,o0,bl0,d0) rcv_space:62496 rcv_ssthresh:56596
>
> This means that TCP can not increase its window in tcp_grow_window(),
> and that DRS can never kick.
>
> Fix this by making sure that rcvq_space.space is not bigger than number of bytes
> that can be held in TCP receive queue.
>
> People unable/unwilling to change their kernel can work around this issue by
> selecting a bigger tcp_rmem[1] value as in :
>
> echo "4096 196608 6291456" >/proc/sys/net/ipv4/tcp_rmem
>
> Based on an initial report and patch from Hazem Mohamed Abuelfotoh
>  https://lore.kernel.org/netdev/20201204180622.14285-1-abuehaze@amazon.com/
>
> Fixes: a337531b942b ("tcp: up initial rmem to 128KB and SYN rwin to around 64KB")
> Fixes: 041a14d26715 ("tcp: start receiver buffer autotuning sooner")
> Reported-by: Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Nice catch and fix!  Thanks Eric!


> ---
>  net/ipv4/tcp_input.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 389d1b34024854a9bdcbe861d4820d1bfb495e24..ef4bdb038a4bbbd949868a01dc855bba0e90b9ca 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -510,7 +510,6 @@ static void tcp_init_buffer_space(struct sock *sk)
>         if (!(sk->sk_userlocks & SOCK_SNDBUF_LOCK))
>                 tcp_sndbuf_expand(sk);
>
> -       tp->rcvq_space.space = min_t(u32, tp->rcv_wnd, TCP_INIT_CWND * tp->advmss);
>         tcp_mstamp_refresh(tp);
>         tp->rcvq_space.time = tp->tcp_mstamp;
>         tp->rcvq_space.seq = tp->copied_seq;
> @@ -534,6 +533,8 @@ static void tcp_init_buffer_space(struct sock *sk)
>
>         tp->rcv_ssthresh = min(tp->rcv_ssthresh, tp->window_clamp);
>         tp->snd_cwnd_stamp = tcp_jiffies32;
> +       tp->rcvq_space.space = min3(tp->rcv_ssthresh, tp->rcv_wnd,
> +                                   (u32)TCP_INIT_CWND * tp->advmss);
>  }
>
>  /* 4. Recalculate window clamp after socket hit its memory bounds. */
> --
> 2.29.2.576.ga3fc446d84-goog
>
