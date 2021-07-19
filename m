Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA2643CE24F
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 18:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347970AbhGSP36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 11:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347995AbhGSPYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 11:24:19 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1740C0613B6
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 08:12:33 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id a16so28411273ybt.8
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 08:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9tQMhZw2scfzhxrhiDTVnyME25oiNf/5HHCzgdvy1S8=;
        b=K1X8hxXxF/0aa5vQkiTSuiqDY+g9jnPbmCZxibsQKTpQnTYOetilazVXh4Z7XMU5su
         yk+aTixbh1I7Z/+d3Uhsc20++Xn67ovAC/ZKV6uwWmJDXGdeg6JMxqHshvBpzgZkw1Qe
         I3CQa5XpNfMQmatwujRoZmxSjFi0xLbb2F9yoIEccKLi+IrUrzrOP6fI6TrCPyKRtYaA
         5i5ze+ud6676440yHoYzv8XOkPfq9SIH3fJBtzzub7Bo4M0+rHe0li5EZymjfG+xcrGK
         AY/5kJUNoXzAB0m0QpgeT4eRKW36WZ4Y/BEXc5koDEDy/rmobG7hs7xf9P+cQt9wpk7P
         e+iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9tQMhZw2scfzhxrhiDTVnyME25oiNf/5HHCzgdvy1S8=;
        b=VnehGEd7e2J0hMakbeaJ0wZk5eGizCWxNso0R64vbTgBN5Pw8MmFG5gamEER+yaY7O
         23AOK8lB/X7rqmflgS97MSAeLEzAYu3c+JyiyeZw+BHDJ7aucLesB7IsiYV/Ok6mXT0h
         m/cerLskCP/5tEAHQ7e713pqwxwt5S1oXgZFEgIUiDMIAbbOW1fBd/Vz1DRIJQX8nULg
         5K2eKlE4Ksu7cTrziJhbQUEhQIX+3qNMYHwXcudMcjXZXnTbOgnsEA7A59M2Uvbx81Lz
         9176RXJ2lKCQXpgooGWCvzctiomh2kFHLurwLdRVq63H9F6V817pJ1OgTc4uWiLPEIdq
         OJSA==
X-Gm-Message-State: AOAM5329UW3WQl3H/Nr85ja4Y2LOp7Ihx33QYjSVtHrYxQSHLnHVk61c
        19eupx6YrkFjh86QrXfXSdkK5Go2knroXUoKs/N5aw==
X-Google-Smtp-Source: ABdhPJzw70OlS+kZZZSEK9bGKpK86JkIpTGv6FMHiLQX9C0z7ju4OgcoH3ZGjRBQipG8aMHR7W0x3J5PXqeU5QV8kNI=
X-Received: by 2002:a25:acde:: with SMTP id x30mr32904297ybd.123.1626709215763;
 Mon, 19 Jul 2021 08:40:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210719091218.2969611-1-eric.dumazet@gmail.com>
In-Reply-To: <20210719091218.2969611-1-eric.dumazet@gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Mon, 19 Jul 2021 08:40:04 -0700
Message-ID: <CAEA6p_BQz1TFiu9sQRit9L-roScxNBkmfMoyyR+vsRyj5BRuCw@mail.gmail.com>
Subject: Re: [PATCH net] net/tcp_fastopen: fix data races around tfo_active_disable_stamp
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 19, 2021 at 2:12 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> tfo_active_disable_stamp is read and written locklessly.
> We need to annotate these accesses appropriately.
>
> Then, we need to perform the atomic_inc(tfo_active_disable_times)
> after the timestamp has been updated, and thus add barriers
> to make sure tcp_fastopen_active_should_disable() wont read
> a stale timestamp.
>
> Fixes: cf1ef3f0719b ("net/tcp_fastopen: Disable active side TFO in certain scenarios")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Wei Wang <weiwan@google.com>
> Cc: Yuchung Cheng <ycheng@google.com>
> Cc: Neal Cardwell <ncardwell@google.com>
> ---

Thanks Eric!

Acked-by: Wei Wang <weiwan@google.com>

>  net/ipv4/tcp_fastopen.c | 19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
>
> diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
> index 47c32604d38fca960d2cd56f3588bfd2e390b789..b32af76e21325373126b51423496e3b8d47d97ff 100644
> --- a/net/ipv4/tcp_fastopen.c
> +++ b/net/ipv4/tcp_fastopen.c
> @@ -507,8 +507,15 @@ void tcp_fastopen_active_disable(struct sock *sk)
>  {
>         struct net *net = sock_net(sk);
>
> +       /* Paired with READ_ONCE() in tcp_fastopen_active_should_disable() */
> +       WRITE_ONCE(net->ipv4.tfo_active_disable_stamp, jiffies);
> +
> +       /* Paired with smp_rmb() in tcp_fastopen_active_should_disable().
> +        * We want net->ipv4.tfo_active_disable_stamp to be updated first.
> +        */
> +       smp_mb__before_atomic();
>         atomic_inc(&net->ipv4.tfo_active_disable_times);
> -       net->ipv4.tfo_active_disable_stamp = jiffies;
> +
>         NET_INC_STATS(net, LINUX_MIB_TCPFASTOPENBLACKHOLE);
>  }
>
> @@ -526,10 +533,16 @@ bool tcp_fastopen_active_should_disable(struct sock *sk)
>         if (!tfo_da_times)
>                 return false;
>
> +       /* Paired with smp_mb__before_atomic() in tcp_fastopen_active_disable() */
> +       smp_rmb();
> +
>         /* Limit timeout to max: 2^6 * initial timeout */
>         multiplier = 1 << min(tfo_da_times - 1, 6);
> -       timeout = multiplier * tfo_bh_timeout * HZ;
> -       if (time_before(jiffies, sock_net(sk)->ipv4.tfo_active_disable_stamp + timeout))
> +
> +       /* Paired with the WRITE_ONCE() in tcp_fastopen_active_disable(). */
> +       timeout = READ_ONCE(sock_net(sk)->ipv4.tfo_active_disable_stamp) +
> +                 multiplier * tfo_bh_timeout * HZ;
> +       if (time_before(jiffies, timeout))
>                 return true;
>
>         /* Mark check bit so we can check for successful active TFO
> --
> 2.32.0.402.g57bb445576-goog
>
