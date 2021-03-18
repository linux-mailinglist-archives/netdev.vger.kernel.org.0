Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84AEB340534
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 13:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbhCRMJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 08:09:55 -0400
Received: from mail2.protonmail.ch ([185.70.40.22]:60922 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbhCRMJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 08:09:46 -0400
Date:   Thu, 18 Mar 2021 12:09:41 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1616069384; bh=Cqzm6aUxemSHfQsIMzY7DTM9gFwyQQWnShiAlTEIv6M=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=leflq7ZHE6gpWBNrmqUwUB7QW6ynZFbTKrgpVisl2LwAIJ3Juu0bmMUnYpx/tjPlh
         x/W3sVnw9PfGI+cK8Ze9/GAyEhAvvK2SHf57foruf6I+wIJzdjbtzCdCb30w6GeGwC
         8G+FW427DL7SkcyA0yEhpMN6pw276k6lDCjxQ/IGWlKvKyYGuJn9uvwf4upjpekKe9
         J/xB+67uTcXKgeFrvcSPBy3OHdNR7/aIgcvZpqnasBjZu7Uo7Pt1k5wSwDKWZZ0r7c
         39exqp5k58anmAJS+WHzuAnEO+91zJD+P3P/5f4Fa2OpYQzpgZphK4q1bbHx9QiegG
         6WsTtlfQvctRA==
To:     Cong Wang <xiyou.wangcong@gmail.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>, bpf@vger.kernel.org,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>, netdev@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [Patch bpf-next v5 06/11] sock: introduce sk->sk_prot->psock_update_sk_prot()
Message-ID: <20210318120930.5723-1-alobakin@pm.me>
In-Reply-To: <20210317022219.24934-7-xiyou.wangcong@gmail.com>
References: <20210317022219.24934-1-xiyou.wangcong@gmail.com> <20210317022219.24934-7-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Tue, 16 Mar 2021 19:22:14 -0700

Hi,

> From: Cong Wang <cong.wang@bytedance.com>
>
> Currently sockmap calls into each protocol to update the struct
> proto and replace it. This certainly won't work when the protocol
> is implemented as a module, for example, AF_UNIX.
>
> Introduce a new ops sk->sk_prot->psock_update_sk_prot(), so each
> protocol can implement its own way to replace the struct proto.
> This also helps get rid of symbol dependencies on CONFIG_INET.
>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  include/linux/skmsg.h | 18 +++---------------
>  include/net/sock.h    |  3 +++
>  include/net/tcp.h     |  1 +
>  include/net/udp.h     |  1 +
>  net/core/skmsg.c      |  5 -----
>  net/core/sock_map.c   | 24 ++++--------------------
>  net/ipv4/tcp_bpf.c    | 24 +++++++++++++++++++++---
>  net/ipv4/tcp_ipv4.c   |  3 +++
>  net/ipv4/udp.c        |  3 +++
>  net/ipv4/udp_bpf.c    | 15 +++++++++++++--
>  net/ipv6/tcp_ipv6.c   |  3 +++
>  net/ipv6/udp.c        |  3 +++
>  12 files changed, 58 insertions(+), 45 deletions(-)
>
> diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> index 77e5d890ec4b..eb2757c0295d 100644
> --- a/include/linux/skmsg.h
> +++ b/include/linux/skmsg.h
> @@ -99,6 +99,7 @@ struct sk_psock {
>  =09void (*saved_close)(struct sock *sk, long timeout);
>  =09void (*saved_write_space)(struct sock *sk);
>  =09void (*saved_data_ready)(struct sock *sk);
> +=09int  (*psock_update_sk_prot)(struct sock *sk, bool restore);
>  =09struct proto=09=09=09*sk_proto;
>  =09struct sk_psock_work_state=09work_state;
>  =09struct work_struct=09=09work;
> @@ -397,25 +398,12 @@ static inline void sk_psock_cork_free(struct sk_pso=
ck *psock)
>  =09}
>  }
>
> -static inline void sk_psock_update_proto(struct sock *sk,
> -=09=09=09=09=09 struct sk_psock *psock,
> -=09=09=09=09=09 struct proto *ops)
> -{
> -=09/* Pairs with lockless read in sk_clone_lock() */
> -=09WRITE_ONCE(sk->sk_prot, ops);
> -}
> -
>  static inline void sk_psock_restore_proto(struct sock *sk,
>  =09=09=09=09=09  struct sk_psock *psock)
>  {
>  =09sk->sk_prot->unhash =3D psock->saved_unhash;
> -=09if (inet_csk_has_ulp(sk)) {
> -=09=09tcp_update_ulp(sk, psock->sk_proto, psock->saved_write_space);
> -=09} else {
> -=09=09sk->sk_write_space =3D psock->saved_write_space;
> -=09=09/* Pairs with lockless read in sk_clone_lock() */
> -=09=09WRITE_ONCE(sk->sk_prot, psock->sk_proto);
> -=09}
> +=09if (psock->psock_update_sk_prot)
> +=09=09psock->psock_update_sk_prot(sk, true);
>  }
>
>  static inline void sk_psock_set_state(struct sk_psock *psock,
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 636810ddcd9b..eda64fbd5e3d 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -1184,6 +1184,9 @@ struct proto {
>  =09void=09=09=09(*unhash)(struct sock *sk);
>  =09void=09=09=09(*rehash)(struct sock *sk);
>  =09int=09=09=09(*get_port)(struct sock *sk, unsigned short snum);
> +#ifdef CONFIG_BPF_SYSCALL
> +=09int=09=09=09(*psock_update_sk_prot)(struct sock *sk, bool restore);
> +#endif
>
>  =09/* Keeping track of sockets in use */
>  #ifdef CONFIG_PROC_FS
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 075de26f449d..2efa4e5ea23d 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -2203,6 +2203,7 @@ struct sk_psock;
>
>  #ifdef CONFIG_BPF_SYSCALL
>  struct proto *tcp_bpf_get_proto(struct sock *sk, struct sk_psock *psock)=
;
> +int tcp_bpf_update_proto(struct sock *sk, bool restore);
>  void tcp_bpf_clone(const struct sock *sk, struct sock *newsk);
>  #endif /* CONFIG_BPF_SYSCALL */
>
> diff --git a/include/net/udp.h b/include/net/udp.h
> index d4d064c59232..df7cc1edc200 100644
> --- a/include/net/udp.h
> +++ b/include/net/udp.h
> @@ -518,6 +518,7 @@ static inline struct sk_buff *udp_rcv_segment(struct =
sock *sk,
>  #ifdef CONFIG_BPF_SYSCALL
>  struct sk_psock;
>  struct proto *udp_bpf_get_proto(struct sock *sk, struct sk_psock *psock)=
;
> +int udp_bpf_update_proto(struct sock *sk, bool restore);
>  #endif
>
>  #endif=09/* _UDP_H */
> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index 5cba52862334..e93683a287a0 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -559,11 +559,6 @@ struct sk_psock *sk_psock_init(struct sock *sk, int =
node)
>
>  =09write_lock_bh(&sk->sk_callback_lock);
>
> -=09if (inet_csk_has_ulp(sk)) {
> -=09=09psock =3D ERR_PTR(-EINVAL);
> -=09=09goto out;
> -=09}
> -
>  =09if (sk->sk_user_data) {
>  =09=09psock =3D ERR_PTR(-EBUSY);
>  =09=09goto out;
> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index 33f8c854db4f..596cbac24091 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -184,26 +184,10 @@ static void sock_map_unref(struct sock *sk, void *l=
ink_raw)
>
>  static int sock_map_init_proto(struct sock *sk, struct sk_psock *psock)
>  {
> -=09struct proto *prot;
> -
> -=09switch (sk->sk_type) {
> -=09case SOCK_STREAM:
> -=09=09prot =3D tcp_bpf_get_proto(sk, psock);
> -=09=09break;
> -
> -=09case SOCK_DGRAM:
> -=09=09prot =3D udp_bpf_get_proto(sk, psock);
> -=09=09break;
> -
> -=09default:
> +=09if (!sk->sk_prot->psock_update_sk_prot)
>  =09=09return -EINVAL;
> -=09}
> -
> -=09if (IS_ERR(prot))
> -=09=09return PTR_ERR(prot);
> -
> -=09sk_psock_update_proto(sk, psock, prot);
> -=09return 0;
> +=09psock->psock_update_sk_prot =3D sk->sk_prot->psock_update_sk_prot;
> +=09return sk->sk_prot->psock_update_sk_prot(sk, false);

Regarding that both {tcp,udp}_bpf_update_proto() is global and
for now they are the only two implemented callbacks, wouldn't it
be worthy to straighten the calls here? Like

=09return INDIRECT_CALL_2(sk->sk_prot->psock_update_sk_prot,
=09=09=09       tcp_bpf_update_proto,
=09=09=09       udp_bpf_update_proto,
=09=09=09       sk, false);

(the same in sk_psock_restore_proto() then)

Or this code path is not performance-critical?

>  }
>
>  static struct sk_psock *sock_map_psock_get_checked(struct sock *sk)
> @@ -570,7 +554,7 @@ static bool sock_map_redirect_allowed(const struct so=
ck *sk)
>
>  static bool sock_map_sk_is_suitable(const struct sock *sk)
>  {
> -=09return sk_is_tcp(sk) || sk_is_udp(sk);
> +=09return !!sk->sk_prot->psock_update_sk_prot;
>  }
>
>  static bool sock_map_sk_state_allowed(const struct sock *sk)
> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> index ae980716d896..ac8cfbaeacd2 100644
> --- a/net/ipv4/tcp_bpf.c
> +++ b/net/ipv4/tcp_bpf.c
> @@ -595,20 +595,38 @@ static int tcp_bpf_assert_proto_ops(struct proto *o=
ps)
>  =09       ops->sendpage =3D=3D tcp_sendpage ? 0 : -ENOTSUPP;
>  }
>
> -struct proto *tcp_bpf_get_proto(struct sock *sk, struct sk_psock *psock)
> +int tcp_bpf_update_proto(struct sock *sk, bool restore)
>  {
> +=09struct sk_psock *psock =3D sk_psock(sk);
>  =09int family =3D sk->sk_family =3D=3D AF_INET6 ? TCP_BPF_IPV6 : TCP_BPF=
_IPV4;
>  =09int config =3D psock->progs.msg_parser   ? TCP_BPF_TX   : TCP_BPF_BAS=
E;
>
> +=09if (restore) {
> +=09=09if (inet_csk_has_ulp(sk)) {
> +=09=09=09tcp_update_ulp(sk, psock->sk_proto, psock->saved_write_space);
> +=09=09} else {
> +=09=09=09sk->sk_write_space =3D psock->saved_write_space;
> +=09=09=09/* Pairs with lockless read in sk_clone_lock() */
> +=09=09=09WRITE_ONCE(sk->sk_prot, psock->sk_proto);
> +=09=09}
> +=09=09return 0;
> +=09}
> +
> +=09if (inet_csk_has_ulp(sk))
> +=09=09return -EINVAL;
> +
>  =09if (sk->sk_family =3D=3D AF_INET6) {
>  =09=09if (tcp_bpf_assert_proto_ops(psock->sk_proto))
> -=09=09=09return ERR_PTR(-EINVAL);
> +=09=09=09return -EINVAL;
>
>  =09=09tcp_bpf_check_v6_needs_rebuild(psock->sk_proto);
>  =09}
>
> -=09return &tcp_bpf_prots[family][config];
> +=09/* Pairs with lockless read in sk_clone_lock() */
> +=09WRITE_ONCE(sk->sk_prot, &tcp_bpf_prots[family][config]);
> +=09return 0;
>  }
> +EXPORT_SYMBOL_GPL(tcp_bpf_update_proto);
>
>  /* If a child got cloned from a listening socket that had tcp_bpf
>   * protocol callbacks installed, we need to restore the callbacks to
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index daad4f99db32..dfc6d1c0e710 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -2806,6 +2806,9 @@ struct proto tcp_prot =3D {
>  =09.hash=09=09=09=3D inet_hash,
>  =09.unhash=09=09=09=3D inet_unhash,
>  =09.get_port=09=09=3D inet_csk_get_port,
> +#ifdef CONFIG_BPF_SYSCALL
> +=09.psock_update_sk_prot=09=3D tcp_bpf_update_proto,
> +#endif
>  =09.enter_memory_pressure=09=3D tcp_enter_memory_pressure,
>  =09.leave_memory_pressure=09=3D tcp_leave_memory_pressure,
>  =09.stream_memory_free=09=3D tcp_stream_memory_free,
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 4a0478b17243..38952aaee3a1 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -2849,6 +2849,9 @@ struct proto udp_prot =3D {
>  =09.unhash=09=09=09=3D udp_lib_unhash,
>  =09.rehash=09=09=09=3D udp_v4_rehash,
>  =09.get_port=09=09=3D udp_v4_get_port,
> +#ifdef CONFIG_BPF_SYSCALL
> +=09.psock_update_sk_prot=09=3D udp_bpf_update_proto,
> +#endif
>  =09.memory_allocated=09=3D &udp_memory_allocated,
>  =09.sysctl_mem=09=09=3D sysctl_udp_mem,
>  =09.sysctl_wmem_offset=09=3D offsetof(struct net, ipv4.sysctl_udp_wmem_m=
in),
> diff --git a/net/ipv4/udp_bpf.c b/net/ipv4/udp_bpf.c
> index 7a94791efc1a..6001f93cd3a0 100644
> --- a/net/ipv4/udp_bpf.c
> +++ b/net/ipv4/udp_bpf.c
> @@ -41,12 +41,23 @@ static int __init udp_bpf_v4_build_proto(void)
>  }
>  core_initcall(udp_bpf_v4_build_proto);
>
> -struct proto *udp_bpf_get_proto(struct sock *sk, struct sk_psock *psock)
> +int udp_bpf_update_proto(struct sock *sk, bool restore)
>  {
>  =09int family =3D sk->sk_family =3D=3D AF_INET ? UDP_BPF_IPV4 : UDP_BPF_=
IPV6;
> +=09struct sk_psock *psock =3D sk_psock(sk);
> +
> +=09if (restore) {
> +=09=09sk->sk_write_space =3D psock->saved_write_space;
> +=09=09/* Pairs with lockless read in sk_clone_lock() */
> +=09=09WRITE_ONCE(sk->sk_prot, psock->sk_proto);
> +=09=09return 0;
> +=09}
>
>  =09if (sk->sk_family =3D=3D AF_INET6)
>  =09=09udp_bpf_check_v6_needs_rebuild(psock->sk_proto);
>
> -=09return &udp_bpf_prots[family];
> +=09/* Pairs with lockless read in sk_clone_lock() */
> +=09WRITE_ONCE(sk->sk_prot, &udp_bpf_prots[family]);
> +=09return 0;
>  }
> +EXPORT_SYMBOL_GPL(udp_bpf_update_proto);
> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> index bd44ded7e50c..4fdc58a9e19e 100644
> --- a/net/ipv6/tcp_ipv6.c
> +++ b/net/ipv6/tcp_ipv6.c
> @@ -2134,6 +2134,9 @@ struct proto tcpv6_prot =3D {
>  =09.hash=09=09=09=3D inet6_hash,
>  =09.unhash=09=09=09=3D inet_unhash,
>  =09.get_port=09=09=3D inet_csk_get_port,
> +#ifdef CONFIG_BPF_SYSCALL
> +=09.psock_update_sk_prot=09=3D tcp_bpf_update_proto,
> +#endif
>  =09.enter_memory_pressure=09=3D tcp_enter_memory_pressure,
>  =09.leave_memory_pressure=09=3D tcp_leave_memory_pressure,
>  =09.stream_memory_free=09=3D tcp_stream_memory_free,
> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> index d25e5a9252fd..ef2c75bb4771 100644
> --- a/net/ipv6/udp.c
> +++ b/net/ipv6/udp.c
> @@ -1713,6 +1713,9 @@ struct proto udpv6_prot =3D {
>  =09.unhash=09=09=09=3D udp_lib_unhash,
>  =09.rehash=09=09=09=3D udp_v6_rehash,
>  =09.get_port=09=09=3D udp_v6_get_port,
> +#ifdef CONFIG_BPF_SYSCALL
> +=09.psock_update_sk_prot=09=3D udp_bpf_update_proto,
> +#endif
>  =09.memory_allocated=09=3D &udp_memory_allocated,
>  =09.sysctl_mem=09=09=3D sysctl_udp_mem,
>  =09.sysctl_wmem_offset     =3D offsetof(struct net, ipv4.sysctl_udp_wmem=
_min),
> --
> 2.25.1

Thanks,
Al

