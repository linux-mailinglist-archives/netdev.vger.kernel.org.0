Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7ACA36B5F8
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 17:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234123AbhDZPlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 11:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233674AbhDZPlm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 11:41:42 -0400
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAAE9C061756
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 08:40:59 -0700 (PDT)
Received: by mail-ua1-x931.google.com with SMTP id g24so6641008uak.11
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 08:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/LEh820Xvs2zEbfipOPRKzWCaKh4YLTGF1yympdnSp0=;
        b=NMzegHAfeXW7vlkxXWNzHIC8KqvGXHsZGietHL13mJmVrgYXlBQBhF2HQFEKrHMnh2
         51Sj4WmEIsf/UJx/c3SMEpCCSzt6ONmMwLv2S8fK/prmdi9sOB2wJR6kqUeUkTAMFfQ1
         EB7rWLtp3IWHYF5oHQ0Gl2085uQJ34HomfD8ETJOxaUnvQ9/C0Ckc3u7Bau6j8gNAGJ0
         N6nSbzAFd6cTDbIdgLqhWg2wKXP+SlkfPeM7CRFg7f8XYtjr14DCDS4pnORarAZMyGX3
         ecSs2KGlOAKa7Fx17xO4dE5oOgb1rEIkYvBWhmxgWffDyWXrWpB4SZasUauCX9aN2mM+
         Op6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/LEh820Xvs2zEbfipOPRKzWCaKh4YLTGF1yympdnSp0=;
        b=jxYmoKOUmK7MDysRFu0YR0rET5ZKxZuQEWN2Lfg+XG7tFwJKyHUF00OTi5g4DF6/SW
         7c4TaFQ5IoVP38kvYrPslXPLPG9zwjH7sY1UH25KZ6K/zzvsyUcGwq4E7uDDLVtYD7Zi
         ipUd6UBl1gg6PfUmAQoWdRjyX1VrdcLhBwgNLMm90eFbfZQ4617f5QI/DFM50Qqzmm0k
         QmlWCY97Ms1O1yH56ChbqZJ6+R6klPXommVu4htxtT8jrbmytO/hF+Dof7FT3HcXJy5s
         v31Imq23WZJDS+kqFSVzl/JOotg13gYCc9FLAKJCkPQOMluStQO6Nqn8tKlZtUq/me5i
         rmLQ==
X-Gm-Message-State: AOAM530m1ufeHtenmT57dh29P+Pep6+iotJXpAv/HAXRaC2Y46hM8L9Y
        zSgngl6Ov0oLGNjgPYLx2Uj180gj0gTq/NvIRs5c4w==
X-Google-Smtp-Source: ABdhPJwqGiZaXVLaDxKrD1FSLh5EHaFy47gvWE6KvSEhmYzhLcrfvLMm3vjnNkTVZQWQCZG18UNNBE8xqCpoH78q1OY=
X-Received: by 2002:ab0:2a84:: with SMTP id h4mr13463575uar.46.1619451658693;
 Mon, 26 Apr 2021 08:40:58 -0700 (PDT)
MIME-Version: 1.0
References: <c575e693788233edeb399d8f9b6d9217b3daed9b.1619403511.git.lcrestez@drivenets.com>
In-Reply-To: <c575e693788233edeb399d8f9b6d9217b3daed9b.1619403511.git.lcrestez@drivenets.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Mon, 26 Apr 2021 11:40:41 -0400
Message-ID: <CADVnQykCbF9jcFS6xE9fmaVnimSvY+0yOgGf=THA0-tnnyYPDQ@mail.gmail.com>
Subject: Re: [RFC] tcp: Consider mtu probing for tcp_xmit_size_goal
To:     Leonard Crestez <lcrestez@drivenets.com>
Cc:     Matt Mathis <mattmathis@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        John Heffner <johnwheffner@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Leonard Crestez <cdleonard@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the patch. Some thoughts, in-line below:

On Sun, Apr 25, 2021 at 10:22 PM Leonard Crestez <lcrestez@drivenets.com> wrote:
>
> According to RFC4821 Section 7.4 "Protocols MAY delay sending non-probes
> in order to accumulate enough data" but linux almost never does that.
>
> Linux checks for probe_size + (1 + retries) * mss_cache to be available

I think this means to say "reordering" rather than "retries"?

> in the send buffer and if that condition is not met it will send anyway
> using the current MSS. The feature can be made to work by sending very
> large chunks of data from userspace (for example 128k) but for small
> writes on fast links tcp mtu probes almost never happen.
>
> This patch tries to take mtu probe into account in tcp_xmit_size_goal, a
> function which otherwise attempts to accumulate a packet suitable for
> TSO. No delays are introduced beyond existing autocork heuristics.

I would suggest phrasing this paragraph as something like:

  This patch generalizes tcp_xmit_size_goal(), a
  function which is used in autocorking in order to attempt to
  accumulate suitable transmit sizes, so that it takes into account
  not only TSO and receive window, but now also transmit
  sizes needed for efficient PMTU discovery (when a flow is
  eligible for PMTU discovery).

>
> Suggested-by: Matt Mathis <mattmathis@google.com>
> Signed-off-by: Leonard Crestez <lcrestez@drivenets.com>
> ---
...
> +
> +               /* Timer for wait_data */
> +               struct    timer_list    wait_data_timer;

This timer_list seems left over from a previous patch version, and no
longer used?

> @@ -1375,10 +1376,12 @@ static inline void tcp_slow_start_after_idle_check(struct sock *sk)
>         s32 delta;
>
>         if (!sock_net(sk)->ipv4.sysctl_tcp_slow_start_after_idle || tp->packets_out ||
>             ca_ops->cong_control)
>                 return;
> +       if (inet_csk(sk)->icsk_mtup.wait_data)
> +               return;
>         delta = tcp_jiffies32 - tp->lsndtime;
>         if (delta > inet_csk(sk)->icsk_rto)
>                 tcp_cwnd_restart(sk, delta);
>  }

I would argue that the MTU probing heuristics should not override
congestion control. If congestion control thinks it's proper to reset
the cwnd to a lower value due to the connection being idle, then this
should happen irrespective of MTU probing activity.

>
>  int tcp_send_mss(struct sock *sk, int *size_goal, int flags)
>  {
>         int mss_now;
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index bde781f46b41..c15ed548a48a 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -2311,10 +2311,23 @@ static bool tcp_can_coalesce_send_queue_head(struct sock *sk, int len)
>         }
>
>         return true;
>  }
>
> +int tcp_mtu_probe_size_needed(struct sock *sk)
> +{
> +       struct inet_connection_sock *icsk = inet_csk(sk);
> +       struct tcp_sock *tp = tcp_sk(sk);
> +       int probe_size;
> +       int size_needed;
> +
> +       probe_size = tcp_mtu_to_mss(sk, (icsk->icsk_mtup.search_high + icsk->icsk_mtup.search_low) >> 1);
> +       size_needed = probe_size + (tp->reordering + 1) * tp->mss_cache;

Adding this helper without refactoring tcp_mtu_probe() to use this
helper would leave some significant unnecessary code duplication. To
avoid duplication, AFAICT your tcp_mtu_probe() should call your new
helper.

You may also want to make this little helper static inline, since
AFAICT it is called in some hot paths.

>  static bool tcp_write_xmit(struct sock *sk, unsigned int mss_now, int nonagle,
>                            int push_one, gfp_t gfp)
>  {
> +       struct inet_connection_sock *icsk = inet_csk(sk);
>         struct tcp_sock *tp = tcp_sk(sk);
> +       struct net *net = sock_net(sk);
>         struct sk_buff *skb;
>         unsigned int tso_segs, sent_pkts;
>         int cwnd_quota;
>         int result;
>         bool is_cwnd_limited = false, is_rwnd_limited = false;
>         u32 max_segs;
>
>         sent_pkts = 0;
>
>         tcp_mstamp_refresh(tp);
> +       /*
> +        * Waiting for tcp probe data also applies when push_one=1
> +        * If user does many small writes we hold them until we have have enough
> +        * for a probe.
> +        */

This comment seems incomplete; with this patch AFAICT small writes are
not simply always held unconditionally until there is enough data for
a full-sized MTU probe. Rather the autocorking mechanism is used, so
that if the flow if a flow is eligible for MTU probes, autocorking
attempts to wait for a full amount of data with which to probe (and as
is the case with autocorking, if this does not become available then
when the local send queues are empty then the flow sends out whatever
it has).

Also I think it would be better to place this comment where you add
new code to tcp_xmit_size_goal(), so that the comment is located near
the corresponding key code, rather than in the very general
tcp_write_xmit() function.

best,
neal
