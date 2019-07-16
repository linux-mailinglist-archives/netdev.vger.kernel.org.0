Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60EE96A781
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 13:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387617AbfGPLfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 07:35:05 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:40067 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387536AbfGPLfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 07:35:05 -0400
Received: by mail-ot1-f66.google.com with SMTP id y20so4720760otk.7
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 04:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1ZCpMbVDKwjQxtAJhuw96baeUJqx+eJCjRWxL6AT2Ek=;
        b=VrDWXQ11OMSgyXajvroKGJ1TEO2e9EkYEswE1f9c+WM1VZbeJ0ZbaTdd96sptxfMV3
         gEg0M3CdhibZx8lKrFpdhWG0BCqb/N6+URPsvrTDbC5JFi/QbYAME+IlybdeZsTKHFtm
         ord/LwZv3sTEs9J2cEwYaup4jkbS6CgIORXNM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1ZCpMbVDKwjQxtAJhuw96baeUJqx+eJCjRWxL6AT2Ek=;
        b=gQg3DxRSL28nPlxUKernVXoZSiGd+u3If5pXsjALF3+Z7gwBVi/fSCOc1eO+w5FogC
         jyb0TvYTYf7qKvgD0vuUXFTVSzkDOpml7hOCph4Ha2G+T/y5Nmk3pnMPsZNq8SWGMFXi
         Df6MrIMd43iNCB/hzvnZgVjhkoh1bwaVCwkC3DB++fEkSqL30WX0gy6tOOmL+ujUjyqw
         ZgblUT5dC6pQfBcnzOh06oEMm+aJ2GykmroU2Z2Xt2p4BTBd2xjOJMYkEpLAJBxKbJaj
         qtJiu69sw1KjCw/WD/8EQ/UJ27qzYjgKmPnplmPUsMKG2kvQWhFV+rH5fh9TYhX9EQOl
         TfXQ==
X-Gm-Message-State: APjAAAUQvQZhucNrqOxCgYdSfem1D3miLIlINtNfRVbdRZMxny0TDFCQ
        AGrXt9noD+4jZm9janW/MaL0Qjj+hditPafq4RDzPolr
X-Google-Smtp-Source: APXvYqwF8r7ktjEaOBhNWYU4Tt0iHudeQxO9ZD9aLMFkBHOXWG9xzpQ6fALxnMk2E0Jurozwi1HyenF+d/F0yWV5T/s=
X-Received: by 2002:a9d:65ca:: with SMTP id z10mr24864459oth.334.1563276903776;
 Tue, 16 Jul 2019 04:35:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190716002650.154729-1-ppenkov.kernel@gmail.com> <20190716002650.154729-3-ppenkov.kernel@gmail.com>
In-Reply-To: <20190716002650.154729-3-ppenkov.kernel@gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Tue, 16 Jul 2019 12:34:52 +0100
Message-ID: <CACAyw99Umy6gaAu1DFTgemRXpZWmxeTSeCZDwdHWzLWeG8Ur3Q@mail.gmail.com>
Subject: Re: [bpf-next RFC 2/6] tcp: add skb-less helpers to retrieve SYN cookie
To:     Petar Penkov <ppenkov.kernel@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        davem@davemloft.net, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, sdf@google.com,
        Petar Penkov <ppenkov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Jul 2019 at 01:27, Petar Penkov <ppenkov.kernel@gmail.com> wrote:
>
> From: Petar Penkov <ppenkov@google.com>
>
> This patch allows generation of a SYN cookie before an SKB has been
> allocated, as is the case at XDP.
>
> Signed-off-by: Petar Penkov <ppenkov@google.com>
> ---
>  include/net/tcp.h    | 11 ++++++
>  net/ipv4/tcp_input.c | 79 ++++++++++++++++++++++++++++++++++++++++++++
>  net/ipv4/tcp_ipv4.c  |  8 +++++
>  net/ipv6/tcp_ipv6.c  |  8 +++++
>  4 files changed, 106 insertions(+)
>
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index cca3c59b98bf..a128e22c0d5d 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -414,6 +414,17 @@ void tcp_parse_options(const struct net *net, const struct sk_buff *skb,
>                        int estab, struct tcp_fastopen_cookie *foc);
>  const u8 *tcp_parse_md5sig_option(const struct tcphdr *th);
>
> +/*
> + *     BPF SKB-less helpers
> + */
> +u16 tcp_v4_get_syncookie(struct sock *sk, struct iphdr *iph,
> +                        struct tcphdr *tch, u32 *cookie);
> +u16 tcp_v6_get_syncookie(struct sock *sk, struct ipv6hdr *iph,
> +                        struct tcphdr *tch, u32 *cookie);
> +u16 tcp_get_syncookie(struct request_sock_ops *rsk_ops,
> +                     const struct tcp_request_sock_ops *af_ops,
> +                     struct sock *sk, void *iph, struct tcphdr *tch,
> +                     u32 *cookie);
>  /*
>   *     TCP v4 functions exported for the inet6 API
>   */
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 8892df6de1d4..1406d7e0953c 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -3782,6 +3782,52 @@ static void smc_parse_options(const struct tcphdr *th,
>  #endif
>  }
>
> +/* Try to parse the MSS option from the TCP header. Return 0 on failure, clamped
> + * value on success.
> + *
> + * Invoked for BPF SYN cookie generation, so th should be a SYN.
> + */
> +static u16 tcp_parse_mss_option(const struct net *net, const struct tcphdr *th,
> +                               u16 user_mss)

net seems unused?

> +{
> +       const unsigned char *ptr = (const unsigned char *)(th + 1);
> +       int length = (th->doff * 4) - sizeof(struct tcphdr);
> +       u16 mss = 0;
> +
> +       while (length > 0) {
> +               int opcode = *ptr++;
> +               int opsize;
> +
> +               switch (opcode) {
> +               case TCPOPT_EOL:
> +                       return mss;
> +               case TCPOPT_NOP:        /* Ref: RFC 793 section 3.1 */
> +                       length--;
> +                       continue;
> +               default:
> +                       if (length < 2)
> +                               return mss;
> +                       opsize = *ptr++;
> +                       if (opsize < 2) /* "silly options" */
> +                               return mss;
> +                       if (opsize > length)
> +                               return mss;     /* fail on partial options */
> +                       if (opcode == TCPOPT_MSS && opsize == TCPOLEN_MSS) {
> +                               u16 in_mss = get_unaligned_be16(ptr);
> +
> +                               if (in_mss) {
> +                                       if (user_mss && user_mss < in_mss)
> +                                               in_mss = user_mss;
> +                                       mss = in_mss;
> +                               }
> +                       }
> +                       ptr += opsize - 2;
> +                       length -= opsize;
> +               }
> +       }
> +       return mss;
> +}
> +
>  /* Look for tcp options. Normally only called on SYN and SYNACK packets.
>   * But, this can also be called on packets in the established flow when
>   * the fast version below fails.
> @@ -6464,6 +6510,39 @@ static void tcp_reqsk_record_syn(const struct sock *sk,
>         }
>  }
>
> +u16 tcp_get_syncookie(struct request_sock_ops *rsk_ops,
> +                     const struct tcp_request_sock_ops *af_ops,
> +                     struct sock *sk, void *iph, struct tcphdr *th,
> +                     u32 *cookie)
> +{
> +       u16 mss = 0;
> +#ifdef CONFIG_SYN_COOKIES
> +       bool is_v4 = rsk_ops->family == AF_INET;
> +       struct tcp_sock *tp = tcp_sk(sk);
> +
> +       if (sock_net(sk)->ipv4.sysctl_tcp_syncookies != 2 &&
> +           !inet_csk_reqsk_queue_is_full(sk))
> +               return 0;
> +
> +       if (!tcp_syn_flood_action(sk, rsk_ops->slab_name))
> +               return 0;
> +
> +       if (sk_acceptq_is_full(sk)) {
> +               NET_INC_STATS(sock_net(sk), LINUX_MIB_LISTENOVERFLOWS);
> +               return 0;
> +       }
> +
> +       mss = tcp_parse_mss_option(sock_net(sk), th, tp->rx_opt.user_mss);
> +       if (!mss)
> +               mss = af_ops->mss_clamp;
> +
> +       tcp_synq_overflow(sk);
> +       *cookie = is_v4 ? __cookie_v4_init_sequence(iph, th, &mss)
> +                       : __cookie_v6_init_sequence(iph, th, &mss);
> +#endif
> +       return mss;
> +}
> +
>  int tcp_conn_request(struct request_sock_ops *rsk_ops,
>                      const struct tcp_request_sock_ops *af_ops,
>                      struct sock *sk, struct sk_buff *skb)
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index d57641cb3477..0e06e59784bd 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -1515,6 +1515,14 @@ static struct sock *tcp_v4_cookie_check(struct sock *sk, struct sk_buff *skb)
>         return sk;
>  }
>
> +u16 tcp_v4_get_syncookie(struct sock *sk, struct iphdr *iph,
> +                        struct tcphdr *tch, u32 *cookie)
> +{
> +       return tcp_get_syncookie(&tcp_request_sock_ops,
> +                                &tcp_request_sock_ipv4_ops, sk, iph, tch,
> +                                cookie);
> +}
> +
>  /* The socket must have it's spinlock held when we get
>   * here, unless it is a TCP_LISTEN socket.
>   *
> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> index d56a9019a0fe..ce46cdba54bc 100644
> --- a/net/ipv6/tcp_ipv6.c
> +++ b/net/ipv6/tcp_ipv6.c
> @@ -1058,6 +1058,14 @@ static struct sock *tcp_v6_cookie_check(struct sock *sk, struct sk_buff *skb)
>         return sk;
>  }
>
> +u16 tcp_v6_get_syncookie(struct sock *sk, struct ipv6hdr *iph,
> +                        struct tcphdr *tch, u32 *cookie)
> +{
> +       return tcp_get_syncookie(&tcp6_request_sock_ops,
> +                                &tcp_request_sock_ipv6_ops, sk, iph, tch,
> +                                cookie);
> +}
> +
>  static int tcp_v6_conn_request(struct sock *sk, struct sk_buff *skb)
>  {
>         if (skb->protocol == htons(ETH_P_IP))
> --
> 2.22.0.510.g264f2c817a-goog
>


-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
