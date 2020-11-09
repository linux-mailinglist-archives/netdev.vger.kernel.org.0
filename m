Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 549682AC0E1
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 17:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730219AbgKIQ3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 11:29:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726796AbgKIQ3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 11:29:45 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E44C0613CF
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 08:29:45 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id g15so8842766ilc.9
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 08:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xWumfhF+4cyjGgATytRWJ7/lhYkpBLx8iwpCjuaDTdc=;
        b=XmcAmTDSM6cmvtBIgljy8h0/ZJXlrDXbLlLnm1ta7C+6kuNrmKyn5uddT6zLD1NPYW
         6opR9dbnnkxhGgjJWzw+Oow3d4v5RLT0eYCRzw6OmHvMSFrk+Ya0V0Xv64HYgg/h13qm
         uUul12xO+UaqI6PTjj45FOIEOsFSj+M0SHsKjYUghoo87GxSvVc+YiCAXN+WSAn0coyJ
         YeIERDvuamNtQeyFwwqglk7hU2tyKjaR8sVnJ8InuXm07Ief1Cdnw5wwAEeUUOblLCNw
         TFTt7Tko82Jjx97rvgZTsakzAMrRioxQVZyR+K/JexDtmMKyn4Vr2mS7Iudhs+bNLM+I
         lQ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xWumfhF+4cyjGgATytRWJ7/lhYkpBLx8iwpCjuaDTdc=;
        b=ri2TSBeNNVUs/nmxkrFsesunr+KO33DO2VpQujKfUuIxI4Utj4FQm+5KJTFFVlZZRO
         5S4rasDsxY91fRdqdtH7GIFxHLdI0rkcyf6XS3GxdbZJ71Xn8zpunntZcCoVkJGhQMpz
         /MpSDQmnT5cPdjmj370R/Tz5FmRoPzsWS5asgFoxJKiONTtyQ/HtgRyGoeGS9RriiuIf
         hmiDA0FTi9p6u/aCDKH2mficgOB+wxB9MnDIq5PGBKA0jKenHpPBHkzsxfI7ooGN8v1L
         iSNTw4PSWyk7FF7WIMgYZVpGNmurNLm2X1DtwkUZ4TMBN2feJxyWQMtl6JtjMBzG2UWX
         BuHA==
X-Gm-Message-State: AOAM532RFP/9ddWyUPrg6X8Ik3QumOzv+5KtprOJMH1vNfUVckkWGvnF
        /DFUCj1+ccSbANSodDsAT3hQGRMYxRIS3dFrn6Kn6Q==
X-Google-Smtp-Source: ABdhPJzEDRZyUg1Hw2cX1mj9+gxqFQ7sXpt1BQHgXvVImOE2nS7i87DjiyhNT+Sg9GntjbCEoeTgdDsLOgArq02QrA8=
X-Received: by 2002:a92:6f11:: with SMTP id k17mr10807878ilc.69.1604939384629;
 Mon, 09 Nov 2020 08:29:44 -0800 (PST)
MIME-Version: 1.0
References: <20201109161146.GA629827@rdias-suse-pc.lan>
In-Reply-To: <20201109161146.GA629827@rdias-suse-pc.lan>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 9 Nov 2020 17:29:33 +0100
Message-ID: <CANn89iL2ADYh9n95ZMntGZ8vFmU2OzVJ0YKTpq8J+3A1Mh1Asw@mail.gmail.com>
Subject: Re: [PATCH v2] tcp: fix race condition when creating child sockets
 from syncookies
To:     Ricardo Dias <rdias@singlestore.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 9, 2020 at 5:11 PM Ricardo Dias <rdias@singlestore.com> wrote:
>
> When the TCP stack is in SYN flood mode, the server child socket is
> created from the SYN cookie received in a TCP packet with the ACK flag
> set.
>
> The child socket is created when the server receives the first TCP
> packet with a valid SYN cookie from the client. Usually, this packet
> corresponds to the final step of the TCP 3-way handshake, the ACK
> packet. But is also possible to receive a valid SYN cookie from the
> first TCP data packet sent by the client, and thus create a child socket
> from that SYN cookie.
>
> Since a client socket is ready to send data as soon as it receives the
> SYN+ACK packet from the server, the client can send the ACK packet (sent
> by the TCP stack code), and the first data packet (sent by the userspace
> program) almost at the same time, and thus the server will equally
> receive the two TCP packets with valid SYN cookies almost at the same
> instant.
>
> When such event happens, the TCP stack code has a race condition that
> occurs between the momement a lookup is done to the established
> connections hashtable to check for the existence of a connection for the
> same client, and the moment that the child socket is added to the
> established connections hashtable. As a consequence, this race condition
> can lead to a situation where we add two child sockets to the
> established connections hashtable and deliver two sockets to the
> userspace program to the same client.
>
> This patch fixes the race condition by checking if an existing child
> socket exists for the same client when we are adding the second child
> socket to the established connections socket. If an existing child
> socket exists, we return that socket and use it to process the TCP
> packet received, and discard the second child socket to the same client.
>
> Signed-off-by: Ricardo Dias <rdias@memsql.com>
> Reported-by: kernel test robot <lkp@intel.com>

The kernel test robot reported a bug on your v1, you do not have to
claim the bot found this issue.

> ---
> v2 (2020-11-09):
> * Changed the author's email domain.
> * Removed the helper function inet_ehash_insert_chk_dup and moved the
>   logic to the existing inet_ehash_insert.
> * Updated the callers of iner_ehash_nolisten to deal with the new
>   logic.
>
>
>  include/net/inet_hashtables.h |  6 ++--
>  net/dccp/ipv4.c               |  4 ++-
>  net/dccp/ipv6.c               |  4 ++-
>  net/ipv4/inet_hashtables.c    | 63 +++++++++++++++++++++++++++++------
>  net/ipv4/syncookies.c         |  5 ++-
>  net/ipv4/tcp_ipv4.c           | 12 ++++++-
>  net/ipv6/tcp_ipv6.c           | 19 ++++++++++-
>  7 files changed, 94 insertions(+), 19 deletions(-)
>
> diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
> index 92560974ea67..dffa345d52a7 100644
> --- a/include/net/inet_hashtables.h
> +++ b/include/net/inet_hashtables.h
> @@ -247,9 +247,9 @@ void inet_hashinfo2_init(struct inet_hashinfo *h, const char *name,
>                          unsigned long high_limit);
>  int inet_hashinfo2_init_mod(struct inet_hashinfo *h);
>
> -bool inet_ehash_insert(struct sock *sk, struct sock *osk);
> -bool inet_ehash_nolisten(struct sock *sk, struct sock *osk);
> -int __inet_hash(struct sock *sk, struct sock *osk);
> +bool inet_ehash_insert(struct sock *sk, struct sock **osk);
> +bool inet_ehash_nolisten(struct sock *sk, struct sock **osk);
> +int __inet_hash(struct sock *sk, struct sock **osk);
>  int inet_hash(struct sock *sk);
>  void inet_unhash(struct sock *sk);
>
> diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
> index 9c28c8251125..99bbba478991 100644
> --- a/net/dccp/ipv4.c
> +++ b/net/dccp/ipv4.c
> @@ -400,6 +400,7 @@ struct sock *dccp_v4_request_recv_sock(const struct sock *sk,
>         struct inet_request_sock *ireq;
>         struct inet_sock *newinet;
>         struct sock *newsk;
> +       struct sock *osk;
>
>         if (sk_acceptq_is_full(sk))
>                 goto exit_overflow;
> @@ -427,7 +428,8 @@ struct sock *dccp_v4_request_recv_sock(const struct sock *sk,
>
>         if (__inet_inherit_port(sk, newsk) < 0)
>                 goto put_and_exit;
> -       *own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash));
> +       osk = req_to_sk(req_unhash);
> +       *own_req = inet_ehash_nolisten(newsk, &osk);
>         if (*own_req)
>                 ireq->ireq_opt = NULL;
>         else
> diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
> index ef4ab28cfde0..91a825c00a97 100644
> --- a/net/dccp/ipv6.c
> +++ b/net/dccp/ipv6.c
> @@ -407,6 +407,7 @@ static struct sock *dccp_v6_request_recv_sock(const struct sock *sk,
>         struct inet_sock *newinet;
>         struct dccp6_sock *newdp6;
>         struct sock *newsk;
> +       struct sock *osk;
>
>         if (skb->protocol == htons(ETH_P_IP)) {
>                 /*
> @@ -533,7 +534,8 @@ static struct sock *dccp_v6_request_recv_sock(const struct sock *sk,
>                 dccp_done(newsk);
>                 goto out;
>         }
> -       *own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash));
> +       osk = req_to_sk(req_unhash);
> +       *own_req = inet_ehash_nolisten(newsk, &osk);
>         /* Clone pktoptions received with SYN, if we own the req */
>         if (*own_req && ireq->pktopts) {
>                 newnp->pktoptions = skb_clone(ireq->pktopts, GFP_ATOMIC);
> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> index 239e54474b65..8d62b22b9a95 100644
> --- a/net/ipv4/inet_hashtables.c
> +++ b/net/ipv4/inet_hashtables.c
> @@ -510,17 +510,27 @@ static u32 inet_sk_port_offset(const struct sock *sk)
>                                           inet->inet_dport);
>  }
>
> -/* insert a socket into ehash, and eventually remove another one
> - * (The another one can be a SYN_RECV or TIMEWAIT
> +/* Insert a socket into ehash, and eventually remove another one
> + * (The another one can be a SYN_RECV or TIMEWAIT)
> + * If an existing socket already exists, it returns that socket
> + * through the osk parameter.
>   */
> -bool inet_ehash_insert(struct sock *sk, struct sock *osk)
> +bool inet_ehash_insert(struct sock *sk, struct sock **osk)
>  {
>         struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
>         struct hlist_nulls_head *list;
>         struct inet_ehash_bucket *head;
> -       spinlock_t *lock;
> +       const struct hlist_nulls_node *node;
> +       struct sock *esk;
> +       spinlock_t *lock; /* protects hashinfo socket entry */
> +       struct net *net = sock_net(sk);
> +       const int dif = sk->sk_bound_dev_if;
> +       const int sdif = sk->sk_bound_dev_if;
>         bool ret = true;
>
> +       INET_ADDR_COOKIE(acookie, sk->sk_daddr, sk->sk_rcv_saddr);
> +       const __portpair ports = INET_COMBINED_PORTS(sk->sk_dport, sk->sk_num);
> +

This does not work for IPv6.
This function is used both for IPv4 and IPv6

Please test your changes for IPv6, thank you !

>         WARN_ON_ONCE(!sk_unhashed(sk));
>
>         sk->sk_hash = sk_ehashfn(sk);
> @@ -529,17 +539,48 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk)
>         lock = inet_ehash_lockp(hashinfo, sk->sk_hash);
>
>         spin_lock(lock);
> -       if (osk) {
> -               WARN_ON_ONCE(sk->sk_hash != osk->sk_hash);
> -               ret = sk_nulls_del_node_init_rcu(osk);
> +       if (osk && *osk) {
> +               WARN_ON_ONCE(sk->sk_hash != (*osk)->sk_hash);
> +               ret = sk_nulls_del_node_init_rcu(*osk);
> +       } else if (osk && !*osk) {
> +begin:
> +               sk_nulls_for_each_rcu(esk, node, list) {
> +                       if (esk->sk_hash != sk->sk_hash)
> +                               continue;
> +                       if (likely(INET_MATCH(esk, net, acookie,
> +                                             sk->sk_daddr,
> +                                             sk->sk_rcv_saddr, ports,
> +                                             dif, sdif))) {
> +                               if (unlikely(!refcount_inc_not_zero(&esk->sk_refcnt)))
> +                                       goto out;
> +                               if (unlikely(!INET_MATCH(esk, net, acookie,
> +                                                        sk->sk_daddr,
> +                                                        sk->sk_rcv_saddr,
> +                                                        ports,
> +                                                        dif, sdif))) {

This can not happen, since you own the spinlock protecting the hash bucket.
