Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC2937A74A
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 15:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbhEKNFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 09:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231490AbhEKNFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 09:05:49 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B52FFC061574
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 06:04:41 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id r8so26200050ybb.9
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 06:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5aR8QQOVNPWCle+nwaw3waQL+0kGFxP3298nYeCkWyU=;
        b=oxf40yDPqrdjbYOF4ZNB4Zd/rWvSfXHAaB9qyIjMQOuBj3oPhv1JxC922eNbolWmTl
         4zTVLPAjt02IhBiRvUk9E3UVVw/d20odTay7jX2bQEc0cFDG2yzfF6FmQ9B4N/zewoU1
         N5n1SHMKpewgGIBrYl1GZi9Y7AQNBbViW9dfPYRacHCmS0mnPd4laDJGap5zPBkx4t6T
         UZ+virWT3s4kbh9al+5C8cVqWBGMfkkFRjSj5Fc6OQaKBORNIAMtyWo8XC9jGDld4tZi
         uO72M0Wk8tAILhQpumfPmxMTnEkeJuhnQ3i7f0QU4cn6a1TWgvdy5OP2kw8rBVLKwnp1
         H0tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5aR8QQOVNPWCle+nwaw3waQL+0kGFxP3298nYeCkWyU=;
        b=l9KUbGakvCwZPGV13I3xRD7vY8SaHNEIzfQ14++rwfONSzM88HPM1XwZJA2edBqW/+
         m7R4jbvF0hUSmTdeM2r03zDdR7mOCzvmYFbYG4/Kr8HwHYoTtHpFVcU8c2NVS/b/X/04
         /chAX53YB2nTq1gGK+tcWsyRE/FnqUDahIv+0m942N+x4oDpUBQleu+DL5Mrufxi0yhk
         EhhBzNEVLhnlz1c9uqsq81uzTgjshvygym2K6kK537qPIV5E0VbDYjMYtocyQbYeYsXH
         csBLPukdtP5TObHODxGbfNHU96NFJ8UZz9iVvEBrI8icxZJoMEEGHhqvlF1kU8hXxpxe
         8sVw==
X-Gm-Message-State: AOAM530Ps2AelnTUd2/UySHGj/xp/9AkeU8ouKFIesgqHqCT20Rz3QhF
        4S12ds+tKYOMJljs0jCW4zd146gk7K4koVPooZ/6/A==
X-Google-Smtp-Source: ABdhPJzPwKEeOfu7A6llo2mmE8CnJLaDiSVE5vvzqVeUKjRvGQS0+3EjXaQ+ZwVMRJX12VPBYvhclVh5ZeCve2fecII=
X-Received: by 2002:a25:850b:: with SMTP id w11mr38863537ybk.518.1620738279637;
 Tue, 11 May 2021 06:04:39 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1620733594.git.cdleonard@gmail.com> <52e63f5b41c9604b909badb7fbc593fe1fe77413.1620733594.git.cdleonard@gmail.com>
In-Reply-To: <52e63f5b41c9604b909badb7fbc593fe1fe77413.1620733594.git.cdleonard@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 11 May 2021 15:04:28 +0200
Message-ID: <CANn89i+4x+YLVmPNSSiOEB4isQYussWSLqFb5x+0hQ5hyS4j_A@mail.gmail.com>
Subject: Re: [RFC 1/3] tcp: Consider mtu probing for tcp_xmit_size_goal
To:     Leonard Crestez <cdleonard@gmail.com>
Cc:     Neal Cardwell <ncardwell@google.com>,
        Matt Mathis <mattmathis@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        John Heffner <johnwheffner@gmail.com>,
        Leonard Crestez <lcrestez@drivenets.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 2:04 PM Leonard Crestez <cdleonard@gmail.com> wrote:
>
> According to RFC4821 Section 7.4 "Protocols MAY delay sending non-probes
> in order to accumulate enough data" but linux almost never does that.
>
> Linux checks for (probe_size + (1 + reorder) * mss_cache) bytes to be
> available in the send buffer and if that condition is not met it will
> send anyway using the current MSS. The feature can be made to work by
> sending very large chunks of data from userspace (for example 128k) but
> for small writes on fast links tcp mtu probes almost never happen.

Why should they happen ?

I am not sure the kernel should perform extra checks just because
applications are not properly written.

>
> This patch tries to take mtu probe into account in tcp_xmit_size_goal, a
> function which otherwise attempts to accumulate a packet suitable for
> TSO. No delays are introduced beyond existing autocork heuristics.


MTU probing should not be attempted for every write().
This belongs to some kind of slow path, once in a while.

>
> Suggested-by: Matt Mathis <mattmathis@google.com>
> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
> ---
>  Documentation/networking/ip-sysctl.rst |  5 ++++
>  include/net/inet_connection_sock.h     |  4 ++-
>  include/net/netns/ipv4.h               |  1 +
>  include/net/tcp.h                      |  1 +
>  net/ipv4/sysctl_net_ipv4.c             |  7 ++++++
>  net/ipv4/tcp.c                         | 11 +++++++-
>  net/ipv4/tcp_ipv4.c                    |  1 +
>  net/ipv4/tcp_output.c                  | 35 +++++++++++++++++++++++---
>  8 files changed, 59 insertions(+), 6 deletions(-)
>
> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> index c2ecc9894fd0..108a5ee227d3 100644
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -320,10 +320,15 @@ tcp_mtu_probe_floor - INTEGER
>         If MTU probing is enabled this caps the minimum MSS used for search_low
>         for the connection.
>
>         Default : 48
>
> +tcp_mtu_probe_autocork - BOOLEAN
> +       Take into account mtu probe size when accumulating data via autocorking.
> +
> +       Default: 1
> +
>  tcp_min_snd_mss - INTEGER
>         TCP SYN and SYNACK messages usually advertise an ADVMSS option,
>         as described in RFC 1122 and RFC 6691.
>
>         If this ADVMSS option is smaller than tcp_min_snd_mss,
> diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
> index 3c8c59471bc1..9a53d698c2e6 100644
> --- a/include/net/inet_connection_sock.h
> +++ b/include/net/inet_connection_sock.h
> @@ -123,11 +123,13 @@ struct inet_connection_sock {
>                 /* Range of MTUs to search */
>                 int               search_high;
>                 int               search_low;
>
>                 /* Information on the current probe. */
> -               u32               probe_size:31,
> +               u32               probe_size:30,
> +               /* Are we actively accumulating data for an mtu probe? */
> +                                 wait_data:1,
>                 /* Is the MTUP feature enabled for this connection? */
>                                   enabled:1;
>
>                 u32               probe_timestamp;
>         } icsk_mtup;
> diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
> index f6af8d96d3c6..3a2d8bf2b20a 100644
> --- a/include/net/netns/ipv4.h
> +++ b/include/net/netns/ipv4.h
> @@ -112,10 +112,11 @@ struct netns_ipv4 {
>  #ifdef CONFIG_NET_L3_MASTER_DEV
>         u8 sysctl_tcp_l3mdev_accept;
>  #endif
>         u8 sysctl_tcp_mtu_probing;
>         int sysctl_tcp_mtu_probe_floor;
> +       int sysctl_tcp_mtu_probe_autocork;
>         int sysctl_tcp_base_mss;
>         int sysctl_tcp_min_snd_mss;
>         int sysctl_tcp_probe_threshold;
>         u32 sysctl_tcp_probe_interval;
>
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index d05193cb0d99..fb656490c901 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -666,10 +666,11 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
>  void tcp_initialize_rcv_mss(struct sock *sk);
>
>  int tcp_mtu_to_mss(struct sock *sk, int pmtu);
>  int tcp_mss_to_mtu(struct sock *sk, int mss);
>  void tcp_mtup_init(struct sock *sk);
> +int tcp_mtu_probe_size_needed(struct sock *sk, int *probe_size);
>
>  static inline void tcp_bound_rto(const struct sock *sk)
>  {
>         if (inet_csk(sk)->icsk_rto > TCP_RTO_MAX)
>                 inet_csk(sk)->icsk_rto = TCP_RTO_MAX;
> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> index a62934b9f15a..e19176c17973 100644
> --- a/net/ipv4/sysctl_net_ipv4.c
> +++ b/net/ipv4/sysctl_net_ipv4.c
> @@ -827,10 +827,17 @@ static struct ctl_table ipv4_net_table[] = {
>                 .mode           = 0644,
>                 .proc_handler   = proc_dointvec_minmax,
>                 .extra1         = &tcp_min_snd_mss_min,
>                 .extra2         = &tcp_min_snd_mss_max,
>         },
> +       {
> +               .procname       = "tcp_mtu_probe_autocork",
> +               .data           = &init_net.ipv4.sysctl_tcp_mtu_probe_autocork,
> +               .maxlen         = sizeof(int),
> +               .mode           = 0644,
> +               .proc_handler   = proc_dointvec,
> +       },
>         {
>                 .procname       = "tcp_probe_threshold",
>                 .data           = &init_net.ipv4.sysctl_tcp_probe_threshold,
>                 .maxlen         = sizeof(int),
>                 .mode           = 0644,
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index f1c1f9e3de72..23cfb2db28b4 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -913,10 +913,11 @@ struct sk_buff *sk_stream_alloc_skb(struct sock *sk, int size, gfp_t gfp,
>  }
>
>  static unsigned int tcp_xmit_size_goal(struct sock *sk, u32 mss_now,
>                                        int large_allowed)
>  {
> +       struct inet_connection_sock *icsk = inet_csk(sk);
>         struct tcp_sock *tp = tcp_sk(sk);
>         u32 new_size_goal, size_goal;
>
>         if (!large_allowed)
>                 return mss_now;
> @@ -932,11 +933,19 @@ static unsigned int tcp_xmit_size_goal(struct sock *sk, u32 mss_now,
>                 tp->gso_segs = min_t(u16, new_size_goal / mss_now,
>                                      sk->sk_gso_max_segs);
>                 size_goal = tp->gso_segs * mss_now;
>         }
>
> -       return max(size_goal, mss_now);
> +       size_goal = max(size_goal, mss_now);
> +
> +       if (unlikely(icsk->icsk_mtup.wait_data)) {
> +               int mtu_probe_size_needed = tcp_mtu_probe_size_needed(sk, NULL);
> +               if (mtu_probe_size_needed > 0)
> +                       size_goal = max(size_goal, (u32)mtu_probe_size_needed);
> +       }


I think you are mistaken.

This function usually returns 64KB depending on MSS.
 Have you really tested this part ?

Also adding in TCP fast path some tweaks for MTU probing while
applications are performing small writes
is not acceptable.


> +
> +       return size_goal;
>  }
>
>  int tcp_send_mss(struct sock *sk, int *size_goal, int flags)
>  {
>         int mss_now;
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index 312184cead57..7e75423c08c9 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -2889,10 +2889,11 @@ static int __net_init tcp_sk_init(struct net *net)
>         net->ipv4.sysctl_tcp_base_mss = TCP_BASE_MSS;
>         net->ipv4.sysctl_tcp_min_snd_mss = TCP_MIN_SND_MSS;
>         net->ipv4.sysctl_tcp_probe_threshold = TCP_PROBE_THRESHOLD;
>         net->ipv4.sysctl_tcp_probe_interval = TCP_PROBE_INTERVAL;
>         net->ipv4.sysctl_tcp_mtu_probe_floor = TCP_MIN_SND_MSS;
> +       net->ipv4.sysctl_tcp_mtu_probe_autocork = 1;
>
>         net->ipv4.sysctl_tcp_keepalive_time = TCP_KEEPALIVE_TIME;
>         net->ipv4.sysctl_tcp_keepalive_probes = TCP_KEEPALIVE_PROBES;
>         net->ipv4.sysctl_tcp_keepalive_intvl = TCP_KEEPALIVE_INTVL;
>
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index bde781f46b41..5a320d792ec4 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -2311,10 +2311,31 @@ static bool tcp_can_coalesce_send_queue_head(struct sock *sk, int len)
>         }
>
>         return true;
>  }
>
> +/* Calculate the size of an MTU probe
> + * Probing the MTU requires one packets which is larger that current MSS as well
> + * as enough following mtu-sized packets to ensure that a probe loss can be
> + * detected without a full Retransmit Time out.
> + */
> +int tcp_mtu_probe_size_needed(struct sock *sk, int *probe_size)
> +{
> +       struct inet_connection_sock *icsk = inet_csk(sk);
> +       struct tcp_sock *tp = tcp_sk(sk);
> +       int probe_size_val;
> +       int size_needed;
> +
> +       /* This might be a little slow: */
> +       probe_size_val = tcp_mtu_to_mss(sk, (icsk->icsk_mtup.search_high + icsk->icsk_mtup.search_low) >> 1);
> +       if (probe_size)
> +               *probe_size = probe_size_val;
> +       size_needed = probe_size_val + (tp->reordering + 1) * tp->mss_cache;
> +
> +       return size_needed;
> +}
> +
>  /* Create a new MTU probe if we are ready.
>   * MTU probe is regularly attempting to increase the path MTU by
>   * deliberately sending larger packets.  This discovers routing
>   * changes resulting in larger path MTUs.
>   *
> @@ -2349,13 +2370,12 @@ static int tcp_mtu_probe(struct sock *sk)
>         /* Use binary search for probe_size between tcp_mss_base,
>          * and current mss_clamp. if (search_high - search_low)
>          * smaller than a threshold, backoff from probing.
>          */
>         mss_now = tcp_current_mss(sk);
> -       probe_size = tcp_mtu_to_mss(sk, (icsk->icsk_mtup.search_high +
> -                                   icsk->icsk_mtup.search_low) >> 1);
> -       size_needed = probe_size + (tp->reordering + 1) * tp->mss_cache;
> +       size_needed = tcp_mtu_probe_size_needed(sk, &probe_size);
> +
>         interval = icsk->icsk_mtup.search_high - icsk->icsk_mtup.search_low;
>         /* When misfortune happens, we are reprobing actively,
>          * and then reprobe timer has expired. We stick with current
>          * probing process by not resetting search range to its orignal.
>          */
> @@ -2368,11 +2388,11 @@ static int tcp_mtu_probe(struct sock *sk)
>                 return -1;
>         }
>
>         /* Have enough data in the send queue to probe? */
>         if (tp->write_seq - tp->snd_nxt < size_needed)
> -               return -1;
> +               return net->ipv4.sysctl_tcp_mtu_probe_autocork ? 0 : -1;
>
>         if (tp->snd_wnd < size_needed)
>                 return -1;
>         if (after(tp->snd_nxt + size_needed, tcp_wnd_end(tp)))
>                 return 0;
> @@ -2596,11 +2616,13 @@ void tcp_chrono_stop(struct sock *sk, const enum tcp_chrono type)
>   * but cannot send anything now because of SWS or another problem.
>   */
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
> @@ -2611,13 +2633,18 @@ static bool tcp_write_xmit(struct sock *sk, unsigned int mss_now, int nonagle,
>         tcp_mstamp_refresh(tp);
>         if (!push_one) {
>                 /* Do MTU probing. */
>                 result = tcp_mtu_probe(sk);
>                 if (!result) {
> +                       if (net->ipv4.sysctl_tcp_mtu_probe_autocork)
> +                               icsk->icsk_mtup.wait_data = true;
>                         return false;
>                 } else if (result > 0) {
> +                       icsk->icsk_mtup.wait_data = false;
>                         sent_pkts = 1;
> +               } else {
> +                       icsk->icsk_mtup.wait_data = false;
>                 }
>         }
>
>         max_segs = tcp_tso_segs(sk, mss_now);
>         while ((skb = tcp_send_head(sk))) {
> --
> 2.25.1
>
