Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCA14675C3
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 11:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380213AbhLCK7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 05:59:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380219AbhLCK7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 05:59:34 -0500
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4CAC061758
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 02:56:10 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id i9so2935523qki.3
        for <netdev@vger.kernel.org>; Fri, 03 Dec 2021 02:56:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KU/4+vec4PfFRLvNJt5usixqqSu9YCVKYmOnDpq342E=;
        b=QEGsi+Wc6FeCFQ1JRYOly0p2whah410SG35npnJhShLVuYdJ7QlAkEZfwIMcVrMPEX
         0H5gb/OoHhVfkRHgNBY+VHAQVJnSswy7bTzJtmXiaivxy3BHAr179CYIt6qcEfTQIeiE
         ZkpCG9hAUjvoMyTVAfwQRWQUlHEkutUWZ4A9c9p1fXPca4X8iinniBI55x5RJchmdicF
         iNc8Lmw/8G9H44NvF1YHLMr/Dm6HvXWDU6NqCDmntNu/7DDkCwY01NvCQOL9r5ih26/n
         iAjPTrG24H2chtIIDfsBLfUohi5hBZg3DzOIlPDtPz83HTw0/pGHqIIwHOrhJiY7yMq8
         GEWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KU/4+vec4PfFRLvNJt5usixqqSu9YCVKYmOnDpq342E=;
        b=8IDqpqYS6Vli4o1OZG2clEP7wD0jNE5z9lJCRbmDIpEo/uu22nGU6xIpEbJNGadqOf
         5G7lwRC1UTCzh4XYKrLk1TyQvcUd5GLgqktKlUabga3dyDWEP2+n+w8sfNuQuW7nJgjr
         YUmFINYACSpKpm4ZQ7zq6mpWX0YZQjIXcBX6wbX1Hi/1L3bwQtvzrycL+qJGAatbawAn
         dYary/jG8S37y0/Tj2aJ2u1Bww6ERFqHbOdjj2I/ClQVIq8z6yPlePOtno3FEBTWu2+6
         pgnukvMrJ1cRJNbbjKJrU0YpD5diNE8o2+15Y7u1U7l+XGY42uXLbpZVDpFS+M1mWGcI
         dxdw==
X-Gm-Message-State: AOAM531+2yGA8xQ3ULenL24EatVVOpe2HZmmRghU+aPMMz1uSMr0tIly
        FOeAyyQcIgz3WNoqnvv/9QROZyi5JJ5Nd+W5O4Hfqg==
X-Google-Smtp-Source: ABdhPJwQjZL3xE8UXjbkI2EogPehzdKFRO1gr/uqFZ70be73kbs4QqHqdW0xPlT4E+5X/nsEylcq4e/DxysdJOLaPRU=
X-Received: by 2002:a05:620a:2202:: with SMTP id m2mr16568265qkh.355.1638528968946;
 Fri, 03 Dec 2021 02:56:08 -0800 (PST)
MIME-Version: 1.0
References: <20211202233724.325226-1-eric.dumazet@gmail.com>
In-Reply-To: <20211202233724.325226-1-eric.dumazet@gmail.com>
From:   Alexander Potapenko <glider@google.com>
Date:   Fri, 3 Dec 2021 11:55:32 +0100
Message-ID: <CAG_fn=VB3odZa65gNLwn_PjVJ7hh8TVebx2rnSva1h-N24RA8g@mail.gmail.com>
Subject: Re: [PATCH net] tcp: fix another uninit-value (sk_rx_queue_mapping)
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 3, 2021 at 12:37 AM Eric Dumazet <eric.dumazet@gmail.com> wrote=
:
>
> From: Eric Dumazet <edumazet@google.com>
>
> KMSAN is still not happy [1].
>
> I missed that passive connections do not inherit their
> sk_rx_queue_mapping values from the request socket,
> but instead tcp_child_process() is calling
> sk_mark_napi_id(child, skb)
>
> We have many sk_mark_napi_id() callers, so I am providing
> a new helper, forcing the setting sk_rx_queue_mapping
> and sk_napi_id.
>
> Note that we had no KMSAN report for sk_napi_id because
> passive connections got a copy of this field from the listener.
> sk_rx_queue_mapping in the other hand is inside the
> sk_dontcopy_begin/sk_dontcopy_end so sk_clone_lock()
> leaves this field uninitialized.
>
> We might remove dead code populating req->sk_rx_queue_mapping
> in the future.
>
> [1]
>
> BUG: KMSAN: uninit-value in __sk_rx_queue_set include/net/sock.h:1924 [in=
line]
> BUG: KMSAN: uninit-value in sk_rx_queue_update include/net/sock.h:1938 [i=
nline]
> BUG: KMSAN: uninit-value in sk_mark_napi_id include/net/busy_poll.h:136 [=
inline]
> BUG: KMSAN: uninit-value in tcp_child_process+0xb42/0x1050 net/ipv4/tcp_m=
inisocks.c:833
>  __sk_rx_queue_set include/net/sock.h:1924 [inline]
>  sk_rx_queue_update include/net/sock.h:1938 [inline]
>  sk_mark_napi_id include/net/busy_poll.h:136 [inline]
>  tcp_child_process+0xb42/0x1050 net/ipv4/tcp_minisocks.c:833
>  tcp_v4_rcv+0x3d83/0x4ed0 net/ipv4/tcp_ipv4.c:2066
>  ip_protocol_deliver_rcu+0x760/0x10b0 net/ipv4/ip_input.c:204
>  ip_local_deliver_finish net/ipv4/ip_input.c:231 [inline]
>  NF_HOOK include/linux/netfilter.h:307 [inline]
>  ip_local_deliver+0x584/0x8c0 net/ipv4/ip_input.c:252
>  dst_input include/net/dst.h:460 [inline]
>  ip_sublist_rcv_finish net/ipv4/ip_input.c:551 [inline]
>  ip_list_rcv_finish net/ipv4/ip_input.c:601 [inline]
>  ip_sublist_rcv+0x11fd/0x1520 net/ipv4/ip_input.c:609
>  ip_list_rcv+0x95f/0x9a0 net/ipv4/ip_input.c:644
>  __netif_receive_skb_list_ptype net/core/dev.c:5505 [inline]
>  __netif_receive_skb_list_core+0xe34/0x1240 net/core/dev.c:5553
>  __netif_receive_skb_list+0x7fc/0x960 net/core/dev.c:5605
>  netif_receive_skb_list_internal+0x868/0xde0 net/core/dev.c:5696
>  gro_normal_list net/core/dev.c:5850 [inline]
>  napi_complete_done+0x579/0xdd0 net/core/dev.c:6587
>  virtqueue_napi_complete drivers/net/virtio_net.c:339 [inline]
>  virtnet_poll+0x17b6/0x2350 drivers/net/virtio_net.c:1557
>  __napi_poll+0x14e/0xbc0 net/core/dev.c:7020
>  napi_poll net/core/dev.c:7087 [inline]
>  net_rx_action+0x824/0x1880 net/core/dev.c:7174
>  __do_softirq+0x1fe/0x7eb kernel/softirq.c:558
>  run_ksoftirqd+0x33/0x50 kernel/softirq.c:920
>  smpboot_thread_fn+0x616/0xbf0 kernel/smpboot.c:164
>  kthread+0x721/0x850 kernel/kthread.c:327
>  ret_from_fork+0x1f/0x30
>
> Uninit was created at:
>  __alloc_pages+0xbc7/0x10a0 mm/page_alloc.c:5409
>  alloc_pages+0x8a5/0xb80
>  alloc_slab_page mm/slub.c:1810 [inline]
>  allocate_slab+0x287/0x1c20 mm/slub.c:1947
>  new_slab mm/slub.c:2010 [inline]
>  ___slab_alloc+0xbdf/0x1e90 mm/slub.c:3039
>  __slab_alloc mm/slub.c:3126 [inline]
>  slab_alloc_node mm/slub.c:3217 [inline]
>  slab_alloc mm/slub.c:3259 [inline]
>  kmem_cache_alloc+0xbb3/0x11c0 mm/slub.c:3264
>  sk_prot_alloc+0xeb/0x570 net/core/sock.c:1914
>  sk_clone_lock+0xd6/0x1940 net/core/sock.c:2118
>  inet_csk_clone_lock+0x8d/0x6a0 net/ipv4/inet_connection_sock.c:956
>  tcp_create_openreq_child+0xb1/0x1ef0 net/ipv4/tcp_minisocks.c:453
>  tcp_v4_syn_recv_sock+0x268/0x2710 net/ipv4/tcp_ipv4.c:1563
>  tcp_check_req+0x207c/0x2a30 net/ipv4/tcp_minisocks.c:765
>  tcp_v4_rcv+0x36f5/0x4ed0 net/ipv4/tcp_ipv4.c:2047
>  ip_protocol_deliver_rcu+0x760/0x10b0 net/ipv4/ip_input.c:204
>  ip_local_deliver_finish net/ipv4/ip_input.c:231 [inline]
>  NF_HOOK include/linux/netfilter.h:307 [inline]
>  ip_local_deliver+0x584/0x8c0 net/ipv4/ip_input.c:252
>  dst_input include/net/dst.h:460 [inline]
>  ip_sublist_rcv_finish net/ipv4/ip_input.c:551 [inline]
>  ip_list_rcv_finish net/ipv4/ip_input.c:601 [inline]
>  ip_sublist_rcv+0x11fd/0x1520 net/ipv4/ip_input.c:609
>  ip_list_rcv+0x95f/0x9a0 net/ipv4/ip_input.c:644
>  __netif_receive_skb_list_ptype net/core/dev.c:5505 [inline]
>  __netif_receive_skb_list_core+0xe34/0x1240 net/core/dev.c:5553
>  __netif_receive_skb_list+0x7fc/0x960 net/core/dev.c:5605
>  netif_receive_skb_list_internal+0x868/0xde0 net/core/dev.c:5696
>  gro_normal_list net/core/dev.c:5850 [inline]
>  napi_complete_done+0x579/0xdd0 net/core/dev.c:6587
>  virtqueue_napi_complete drivers/net/virtio_net.c:339 [inline]
>  virtnet_poll+0x17b6/0x2350 drivers/net/virtio_net.c:1557
>  __napi_poll+0x14e/0xbc0 net/core/dev.c:7020
>  napi_poll net/core/dev.c:7087 [inline]
>  net_rx_action+0x824/0x1880 net/core/dev.c:7174
>  __do_softirq+0x1fe/0x7eb kernel/softirq.c:558
>
> Fixes: 342159ee394d ("net: avoid dirtying sk->sk_rx_queue_mapping")
> Fixes: a37a0ee4d25c ("net: avoid uninit-value from tcp_conn_request")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Tested-by: Alexander Potapenko <glider@google.com>

syzbot is happy now.

> ---
>  include/net/busy_poll.h  | 13 +++++++++++++
>  net/ipv4/tcp_minisocks.c |  4 ++--
>  2 files changed, 15 insertions(+), 2 deletions(-)
>
> diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
> index 7994455ec714610fbcb563d8c7a1411b02201e05..c4898fcbf923bf01f14c6bcc6=
94eb036d75d7195 100644
> --- a/include/net/busy_poll.h
> +++ b/include/net/busy_poll.h
> @@ -136,6 +136,19 @@ static inline void sk_mark_napi_id(struct sock *sk, =
const struct sk_buff *skb)
>         sk_rx_queue_update(sk, skb);
>  }
>
> +/* Variant of sk_mark_napi_id() for passive flow setup,
> + * as sk->sk_napi_id and sk->sk_rx_queue_mapping content
> + * needs to be set.
> + */
> +static inline void sk_mark_napi_id_set(struct sock *sk,
> +                                      const struct sk_buff *skb)
> +{
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +       WRITE_ONCE(sk->sk_napi_id, skb->napi_id);
> +#endif
> +       sk_rx_queue_set(sk, skb);
> +}
> +
>  static inline void __sk_mark_napi_id_once(struct sock *sk, unsigned int =
napi_id)
>  {
>  #ifdef CONFIG_NET_RX_BUSY_POLL
> diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
> index cf913a66df17023bbab8b42e313ce646858c268a..7c2d3ac2363acebcfd92d7a48=
86c052c8aa120b9 100644
> --- a/net/ipv4/tcp_minisocks.c
> +++ b/net/ipv4/tcp_minisocks.c
> @@ -829,8 +829,8 @@ int tcp_child_process(struct sock *parent, struct soc=
k *child,
>         int ret =3D 0;
>         int state =3D child->sk_state;
>
> -       /* record NAPI ID of child */
> -       sk_mark_napi_id(child, skb);
> +       /* record sk_napi_id and sk_rx_queue_mapping of child. */
> +       sk_mark_napi_id_set(child, skb);
>
>         tcp_segs_in(tcp_sk(child), skb);
>         if (!sock_owned_by_user(child)) {
> --
> 2.34.1.400.ga245620fadb-goog
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgi=
d/syzkaller/20211202233724.325226-1-eric.dumazet%40gmail.com.



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
