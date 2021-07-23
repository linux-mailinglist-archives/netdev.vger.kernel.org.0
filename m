Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3083D3BEF
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 16:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235458AbhGWOBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 10:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235442AbhGWOBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 10:01:05 -0400
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF6AC061760
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 07:41:38 -0700 (PDT)
Received: by mail-vs1-xe2e.google.com with SMTP id 5so1144238vsd.11
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 07:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QYvY+XhdaONmNJqIdtIWP2uZhDH4cq0nyTKOr5KXpcA=;
        b=MDxBtakUlOTGgvrQ2utW1Vr5Nqd33Y1wJXMCCoGL+WbciqW9/W1+ZLRS9Qd3hGNvdQ
         uAL+CNDhdzw1yzrJq9Ls2NW4vOFAPdWJkRJyeOPsR7ewj35HjsaDbUmoqmMaHfb7HjMr
         OwLprACYBVA7ap4iG7ebj69If6wkp3S6C8yvFsKPXyYRQoK6kqxBFdpGKZ43tv5e2dkc
         1wOYElrlJhiM3nvxDKiCUAE3/TMuQx15qj7qPfX2/Tgm9sgArQsXB7OhLJtIKB1jgJfZ
         rGzoH09q7IevDycjwWZSQk9IS7DL3hI2guwn4fWDiyLklJP/DLbBge34uxK95BTP9kUc
         jPNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QYvY+XhdaONmNJqIdtIWP2uZhDH4cq0nyTKOr5KXpcA=;
        b=JcuKxWV5j0lYhjXsUFld3OMMKupy/9g7YIYlTrUTu6IfjCSc5eJCNpJ5zN+OkPmOTc
         zMo2qXu9uqWoprfr28TOixtyq/vuJmR1MggFKIcwU/EYhx2c4JvF3CFuOK71Wwewnhj1
         748eACGXHzg8zzQ+Cr8RMMDuBRQgAycp/sBhUM4kk9KrtrbjF2s1TAIhCRh+K2dIYV5B
         /mijjp3r2whV6spqpjkENTRDw/C+jyZ/8ysb8WgoyMwDgl7wb0XwJghUzkEGdF0yubxn
         WR6toQIdHrrRtuXJQVoR8XpTxBgXYmrNC4Dfg3e8OUgy9pCH0o+4hJqZ/Q6RnpF5dSiA
         B54A==
X-Gm-Message-State: AOAM532BZ5N6hBiIn3yEFTKwJWD412gm/iQdwgGeeUvJRE6QwCfeevPe
        5Kk0+kzMImX6XoOhZoIPezY2H8WibjNuig7xtNSFSQ==
X-Google-Smtp-Source: ABdhPJwYaqcoBml1n53zNZii+AbHYg7H0TgkoHSLYeBbNWfSodyiWl9Q9RhE9OE0SJ2fE5yRIcnl1/iVijveMoU+ACQ=
X-Received: by 2002:a05:6102:232f:: with SMTP id b15mr4209490vsa.44.1627051297024;
 Fri, 23 Jul 2021 07:41:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210723093938.49354-1-zeil@yandex-team.ru>
In-Reply-To: <20210723093938.49354-1-zeil@yandex-team.ru>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Fri, 23 Jul 2021 10:41:20 -0400
Message-ID: <CADVnQykVQhT_4f2CV6cAqx_oFvQ-vvq-S0Pnw0a6cnXFuJnPpg@mail.gmail.com>
Subject: Re: [PATCH] tcp: use rto_min value from socket in retransmits timeout
To:     Dmitry Yakunin <zeil@yandex-team.ru>
Cc:     kafai@fb.com, edumazet@google.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, dmtrmonakhov@yandex-team.ru,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

.(On Fri, Jul 23, 2021 at 5:41 AM Dmitry Yakunin <zeil@yandex-team.ru> wrote:
>
> Commit ca584ba07086 ("tcp: bpf: Add TCP_BPF_RTO_MIN for bpf_setsockopt")
> adds ability to set rto_min value on socket less then default TCP_RTO_MIN.
> But retransmits_timed_out() function still uses TCP_RTO_MIN and
> tcp_retries{1,2} sysctls don't work properly for tuned socket values.
>
> Fixes: ca584ba07086 ("tcp: bpf: Add TCP_BPF_RTO_MIN for bpf_setsockopt")
> Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
> Acked-by: Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
> ---
>  net/ipv4/tcp_timer.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
> index 20cf4a9..66c4b97 100644
> --- a/net/ipv4/tcp_timer.c
> +++ b/net/ipv4/tcp_timer.c
> @@ -199,12 +199,13 @@ static unsigned int tcp_model_timeout(struct sock *sk,
>   *  @boundary: max number of retransmissions
>   *  @timeout:  A custom timeout value.
>   *             If set to 0 the default timeout is calculated and used.
> - *             Using TCP_RTO_MIN and the number of unsuccessful retransmits.
> + *             Using icsk_rto_min value from socket or RTAX_RTO_MIN from route
> + *             and the number of unsuccessful retransmits.
>   *
>   * The default "timeout" value this function can calculate and use
>   * is equivalent to the timeout of a TCP Connection
>   * after "boundary" unsuccessful, exponentially backed-off
> - * retransmissions with an initial RTO of TCP_RTO_MIN.
> + * retransmissions with an initial RTO of icsk_rto_min or RTAX_RTO_MIN.
>   */
>  static bool retransmits_timed_out(struct sock *sk,
>                                   unsigned int boundary,
> @@ -217,7 +218,7 @@ static bool retransmits_timed_out(struct sock *sk,
>
>         start_ts = tcp_sk(sk)->retrans_stamp;
>         if (likely(timeout == 0)) {
> -               unsigned int rto_base = TCP_RTO_MIN;
> +               unsigned int rto_base = tcp_rto_min(sk);
>
>                 if ((1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV))
>                         rto_base = tcp_timeout_init(sk);
> --

I would argue strenuously against this. We tried the approach in this
patch at Google years ago, but we had to revert that approach and go
back to using TCP_RTO_MIN as the baseline for the computation, because
using the custom tcp_rto_min(sk) caused serious reliability problems.

The behavior in this patch causes various serious reliability problems
because the retransmits_timed_out() computation is used for various
timeout decisions that determine how long a connection tries to
retransmit something before deciding the path is bad and/or giving up
and closing the connection. Here are a few of the problems this
causes:

(1) The biggest one is probably orphan retries. By default
tcp_orphan_retries() uses a retry count of 8. But if your min_rto is
5ms (used at Google for many years), then the 8 retries means an
orphaned connection (whose fd is no longer held by a process, but is
still established) only lasts for 1.275 seconds before giving up and
closing. This means that connectivity problems longer than 1.275
seconds (extremely common with cellular links) are not tolerated for
such connections; the connections often do not receive the data they
were supposed to receive.

(2) TCP_RETR1 /sysctl_tcp_retries1, used for __dst_negative_advice(),
also has big problems. Even with a min_rto as big as 20ms, on a route
with 150ms RTT, the approach in this patch will cause
retransmits_timed_out() to return true upon the 1st RTO timer firing,
even though TCP_RETR1 is 3.

(3) TCP_RETR2 /sysctl_tcp_retries2, with a default of 15, used for
regular connection retry lifetimes, also has a massive decrease in
robustness, due to falling from  109 minutes with a 200ms RTO, to
about 2.7 minutes with a min_rto of 5ms.

neal
