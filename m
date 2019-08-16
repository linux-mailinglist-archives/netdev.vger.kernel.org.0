Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D34788FA68
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 07:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbfHPF3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 01:29:22 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40234 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbfHPF3W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 01:29:22 -0400
Received: by mail-wm1-f65.google.com with SMTP id v19so3058796wmj.5
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 22:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ope7w50SlIuNWWorWClkMokp+GHiBVuI/NRX3t+tDHQ=;
        b=ewoDZ6AWxnGrjsi9T7AVupUJnPGYAoOAtxrRaF2OiBzIdccjjLBRhJI+WmzVlYdU8/
         98oA55XKrgJxAbfoeDgYqYXOVois4baaa86zT3h4U/4A0RF9JxhEIQXp/jQi/XNtHV+L
         spYaFhXXfCNANEDhyMV4X6DZklEwteG4vgQfm3YoGFrCfo05u6fgoHl1C2rVzdEkyy9c
         4j/CET/SdeTh9oUc7OCbatduCpz6WcOjISTgahRi4vffo8g4vy6Z0ClmPW3VK9Bp7LoD
         lvse9S85ttFlqNo1XtykRenAzFqWUfC7D7sL/TGzi2xzTc8HYNPxK55xKAaL3dDOwRjK
         mXxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ope7w50SlIuNWWorWClkMokp+GHiBVuI/NRX3t+tDHQ=;
        b=c/y6kcsMK4KT1nBh0Pb2+zM7754Eh85JCj+EABg0RU8oMXnH/XXQ1HU7ReixuCQOY7
         eEideCCfav9HYYkykwiRtgLB3Z+D+kySuuWdnCQbEMU0m/IMgxujSe2q5KM4pt8zPXAH
         Gl0E3Lx2ei4erECsVfYjNYld2cync89h7mSmVWNQf5nRzRnczEO8AIjh1aHfQERGuIfh
         YG79ZDFGi7ZV2LW8DnUz0FJJNBHTGPD5geRH7rzA9UlL9LqlRwCbObyS5vc/Rz+v5s3V
         XYd1qoC6XX3WElNpAPZLkRZ7uIn3HGsodm+0+wxVicNVwcNi9ZT4Kq1G9ceBC4UX6v2c
         XMnw==
X-Gm-Message-State: APjAAAUYvbCw3fpDytozmDIkWv3rry4WCjEIx+vVMvZ1moBFsAB2ibG5
        Nuh7VeYvsAUNW5gNBkWxgAjvp09sT2WaXKDinSM=
X-Google-Smtp-Source: APXvYqyKG67SPqwdzSTsrZQDWAZThk6jJFxzt1bf/J/OifacX3dpJ8Y76raJWaGiOCebwauTXcgGQE66bhNhY+S3hXY=
X-Received: by 2002:a1c:1bd7:: with SMTP id b206mr5035504wmb.85.1565933358617;
 Thu, 15 Aug 2019 22:29:18 -0700 (PDT)
MIME-Version: 1.0
References: <1565880170-19548-1-git-send-email-jon.maloy@ericsson.com>
In-Reply-To: <1565880170-19548-1-git-send-email-jon.maloy@ericsson.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 16 Aug 2019 13:29:07 +0800
Message-ID: <CADvbK_dtsS5hxn1RLvG9hpB974tDsx_dAU394baSp2OgHubLJg@mail.gmail.com>
Subject: Re: [net-next v2 1/1] tipc: clean up skb list lock handling on send path
To:     Jon Maloy <jon.maloy@ericsson.com>
Cc:     davem <davem@davemloft.net>, network dev <netdev@vger.kernel.org>,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        Long Xin <lxin@redhat.com>, shuali@redhat.com,
        Ying Xue <ying.xue@windriver.com>,
        Eric Dumazet <edumazet@google.com>,
        tipc-discussion@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 15, 2019 at 11:36 PM Jon Maloy <jon.maloy@ericsson.com> wrote:
>
> The policy for handling the skb list locks on the send and receive paths
> is simple.
>
> - On the send path we never need to grab the lock on the 'xmitq' list
>   when the destination is an exernal node.
>
> - On the receive path we always need to grab the lock on the 'inputq'
>   list, irrespective of source node.
>
> However, when transmitting node local messages those will eventually
> end up on the receive path of a local socket, meaning that the argument
> 'xmitq' in tipc_node_xmit() will become the '=C3=ADnputq' argument in  th=
e
> function tipc_sk_rcv(). This has been handled by always initializing
> the spinlock of the 'xmitq' list at message creation, just in case it
> may end up on the receive path later, and despite knowing that the lock
> in most cases never will be used.
>
> This approach is inaccurate and confusing, and has also concealed the
> fact that the stated 'no lock grabbing' policy for the send path is
> violated in some cases.
>
> We now clean up this by never initializing the lock at message creation,
> instead doing this at the moment we find that the message actually will
> enter the receive path. At the same time we fix the four locations
> where we incorrectly access the spinlock on the send/error path.
>
> This patch also reverts commit d12cffe9329f ("tipc: ensure head->lock
> is initialised") which has now become redundant.
>
> CC: Eric Dumazet <edumazet@google.com>
> Reported-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
> Acked-by: Ying Xue <ying.xue@windriver.com>
> Signed-off-by: Jon Maloy <jon.maloy@ericsson.com>
>
> ---
> v2: removed more unnecessary lock initializations after feedback
>     from Xin Long.
> ---
>  net/tipc/bcast.c      | 10 +++++-----
>  net/tipc/group.c      |  4 ++--
>  net/tipc/link.c       | 14 +++++++-------
>  net/tipc/name_distr.c |  2 +-
>  net/tipc/node.c       |  7 ++++---
>  net/tipc/socket.c     | 14 +++++++-------
>  6 files changed, 26 insertions(+), 25 deletions(-)
>
> diff --git a/net/tipc/bcast.c b/net/tipc/bcast.c
> index 34f3e56..6ef1abd 100644
> --- a/net/tipc/bcast.c
> +++ b/net/tipc/bcast.c
> @@ -185,7 +185,7 @@ static void tipc_bcbase_xmit(struct net *net, struct =
sk_buff_head *xmitq)
>         }
>
>         /* We have to transmit across all bearers */
> -       skb_queue_head_init(&_xmitq);
> +       __skb_queue_head_init(&_xmitq);
>         for (bearer_id =3D 0; bearer_id < MAX_BEARERS; bearer_id++) {
>                 if (!bb->dests[bearer_id])
>                         continue;
> @@ -256,7 +256,7 @@ static int tipc_bcast_xmit(struct net *net, struct sk=
_buff_head *pkts,
>         struct sk_buff_head xmitq;
>         int rc =3D 0;
>
> -       skb_queue_head_init(&xmitq);
> +       __skb_queue_head_init(&xmitq);
>         tipc_bcast_lock(net);
>         if (tipc_link_bc_peers(l))
>                 rc =3D tipc_link_xmit(l, pkts, &xmitq);
> @@ -286,7 +286,7 @@ static int tipc_rcast_xmit(struct net *net, struct sk=
_buff_head *pkts,
>         u32 dnode, selector;
>
>         selector =3D msg_link_selector(buf_msg(skb_peek(pkts)));
> -       skb_queue_head_init(&_pkts);
> +       __skb_queue_head_init(&_pkts);
>
>         list_for_each_entry_safe(dst, tmp, &dests->list, list) {
>                 dnode =3D dst->node;
> @@ -344,7 +344,7 @@ static int tipc_mcast_send_sync(struct net *net, stru=
ct sk_buff *skb,
>         msg_set_size(_hdr, MCAST_H_SIZE);
>         msg_set_is_rcast(_hdr, !msg_is_rcast(hdr));
>
> -       skb_queue_head_init(&tmpq);
> +       __skb_queue_head_init(&tmpq);
>         __skb_queue_tail(&tmpq, _skb);
>         if (method->rcast)
>                 tipc_bcast_xmit(net, &tmpq, cong_link_cnt);
> @@ -378,7 +378,7 @@ int tipc_mcast_xmit(struct net *net, struct sk_buff_h=
ead *pkts,
>         int rc =3D 0;
>
>         skb_queue_head_init(&inputq);
> -       skb_queue_head_init(&localq);
> +       __skb_queue_head_init(&localq);
>
>         /* Clone packets before they are consumed by next call */
>         if (dests->local && !tipc_msg_reassemble(pkts, &localq)) {
> diff --git a/net/tipc/group.c b/net/tipc/group.c
> index 5f98d38..89257e2 100644
> --- a/net/tipc/group.c
> +++ b/net/tipc/group.c
> @@ -199,7 +199,7 @@ void tipc_group_join(struct net *net, struct tipc_gro=
up *grp, int *sk_rcvbuf)
>         struct tipc_member *m, *tmp;
>         struct sk_buff_head xmitq;
>
> -       skb_queue_head_init(&xmitq);
> +       __skb_queue_head_init(&xmitq);
>         rbtree_postorder_for_each_entry_safe(m, tmp, tree, tree_node) {
>                 tipc_group_proto_xmit(grp, m, GRP_JOIN_MSG, &xmitq);
>                 tipc_group_update_member(m, 0);
> @@ -435,7 +435,7 @@ bool tipc_group_cong(struct tipc_group *grp, u32 dnod=
e, u32 dport,
>                 return true;
>         if (state =3D=3D MBR_PENDING && adv =3D=3D ADV_IDLE)
>                 return true;
> -       skb_queue_head_init(&xmitq);
> +       __skb_queue_head_init(&xmitq);
>         tipc_group_proto_xmit(grp, m, GRP_ADV_MSG, &xmitq);
>         tipc_node_distr_xmit(grp->net, &xmitq);
>         return true;
> diff --git a/net/tipc/link.c b/net/tipc/link.c
> index dd3155b..289e848 100644
> --- a/net/tipc/link.c
> +++ b/net/tipc/link.c
> @@ -959,7 +959,7 @@ int tipc_link_xmit(struct tipc_link *l, struct sk_buf=
f_head *list,
>                 pr_warn("Too large msg, purging xmit list %d %d %d %d %d!=
\n",
>                         skb_queue_len(list), msg_user(hdr),
>                         msg_type(hdr), msg_size(hdr), mtu);
> -               skb_queue_purge(list);
> +               __skb_queue_purge(list);
>                 return -EMSGSIZE;
>         }
>
> @@ -988,7 +988,7 @@ int tipc_link_xmit(struct tipc_link *l, struct sk_buf=
f_head *list,
>                 if (likely(skb_queue_len(transmq) < maxwin)) {
>                         _skb =3D skb_clone(skb, GFP_ATOMIC);
>                         if (!_skb) {
> -                               skb_queue_purge(list);
> +                               __skb_queue_purge(list);
>                                 return -ENOBUFS;
>                         }
>                         __skb_dequeue(list);
> @@ -1668,7 +1668,7 @@ void tipc_link_create_dummy_tnl_msg(struct tipc_lin=
k *l,
>         struct sk_buff *skb;
>         u32 dnode =3D l->addr;
>
> -       skb_queue_head_init(&tnlq);
> +       __skb_queue_head_init(&tnlq);
>         skb =3D tipc_msg_create(TUNNEL_PROTOCOL, FAILOVER_MSG,
>                               INT_H_SIZE, BASIC_H_SIZE,
>                               dnode, onode, 0, 0, 0);
> @@ -1708,9 +1708,9 @@ void tipc_link_tnl_prepare(struct tipc_link *l, str=
uct tipc_link *tnl,
>         if (!tnl)
>                 return;
>
> -       skb_queue_head_init(&tnlq);
> -       skb_queue_head_init(&tmpxq);
> -       skb_queue_head_init(&frags);
> +       __skb_queue_head_init(&tnlq);
> +       __skb_queue_head_init(&tmpxq);
> +       __skb_queue_head_init(&frags);
>
>         /* At least one packet required for safe algorithm =3D> add dummy=
 */
>         skb =3D tipc_msg_create(TIPC_LOW_IMPORTANCE, TIPC_DIRECT_MSG,
> @@ -1720,7 +1720,7 @@ void tipc_link_tnl_prepare(struct tipc_link *l, str=
uct tipc_link *tnl,
>                 pr_warn("%sunable to create tunnel packet\n", link_co_err=
);
>                 return;
>         }
> -       skb_queue_tail(&tnlq, skb);
> +       __skb_queue_tail(&tnlq, skb);
>         tipc_link_xmit(l, &tnlq, &tmpxq);
>         __skb_queue_purge(&tmpxq);
>
> diff --git a/net/tipc/name_distr.c b/net/tipc/name_distr.c
> index 44abc8e..61219f0 100644
> --- a/net/tipc/name_distr.c
> +++ b/net/tipc/name_distr.c
> @@ -190,7 +190,7 @@ void tipc_named_node_up(struct net *net, u32 dnode)
>         struct name_table *nt =3D tipc_name_table(net);
>         struct sk_buff_head head;
>
> -       skb_queue_head_init(&head);
> +       __skb_queue_head_init(&head);
>
>         read_lock_bh(&nt->cluster_scope_lock);
>         named_distribute(net, &head, dnode, &nt->cluster_scope);
> diff --git a/net/tipc/node.c b/net/tipc/node.c
> index 1bdcf0f..c8f6177 100644
> --- a/net/tipc/node.c
> +++ b/net/tipc/node.c
> @@ -1444,13 +1444,14 @@ int tipc_node_xmit(struct net *net, struct sk_buf=
f_head *list,
>
>         if (in_own_node(net, dnode)) {
>                 tipc_loopback_trace(net, list);
> +               spin_lock_init(&list->lock);
>                 tipc_sk_rcv(net, list);
>                 return 0;
>         }
>
>         n =3D tipc_node_find(net, dnode);
>         if (unlikely(!n)) {
> -               skb_queue_purge(list);
> +               __skb_queue_purge(list);
>                 return -EHOSTUNREACH;
>         }
>
> @@ -1459,7 +1460,7 @@ int tipc_node_xmit(struct net *net, struct sk_buff_=
head *list,
>         if (unlikely(bearer_id =3D=3D INVALID_BEARER_ID)) {
>                 tipc_node_read_unlock(n);
>                 tipc_node_put(n);
> -               skb_queue_purge(list);
> +               __skb_queue_purge(list);
>                 return -EHOSTUNREACH;
>         }
>
> @@ -1491,7 +1492,7 @@ int tipc_node_xmit_skb(struct net *net, struct sk_b=
uff *skb, u32 dnode,
>  {
>         struct sk_buff_head head;
>
> -       skb_queue_head_init(&head);
> +       __skb_queue_head_init(&head);
>         __skb_queue_tail(&head, skb);
>         tipc_node_xmit(net, &head, dnode, selector);
>         return 0;
> diff --git a/net/tipc/socket.c b/net/tipc/socket.c
> index 83ae41d..3b9f8cc 100644
> --- a/net/tipc/socket.c
> +++ b/net/tipc/socket.c
> @@ -809,7 +809,7 @@ static int tipc_sendmcast(struct  socket *sock, struc=
t tipc_name_seq *seq,
>         msg_set_nameupper(hdr, seq->upper);
>
>         /* Build message as chain of buffers */
> -       skb_queue_head_init(&pkts);
> +       __skb_queue_head_init(&pkts);
>         rc =3D tipc_msg_build(hdr, msg, 0, dlen, mtu, &pkts);
>
>         /* Send message if build was successful */
> @@ -853,7 +853,7 @@ static int tipc_send_group_msg(struct net *net, struc=
t tipc_sock *tsk,
>         msg_set_grp_bc_seqno(hdr, bc_snd_nxt);
>
>         /* Build message as chain of buffers */
> -       skb_queue_head_init(&pkts);
> +       __skb_queue_head_init(&pkts);
>         mtu =3D tipc_node_get_mtu(net, dnode, tsk->portid);
>         rc =3D tipc_msg_build(hdr, m, 0, dlen, mtu, &pkts);
>         if (unlikely(rc !=3D dlen))
> @@ -1058,7 +1058,7 @@ static int tipc_send_group_bcast(struct socket *soc=
k, struct msghdr *m,
>         msg_set_grp_bc_ack_req(hdr, ack);
>
>         /* Build message as chain of buffers */
> -       skb_queue_head_init(&pkts);
> +       __skb_queue_head_init(&pkts);
>         rc =3D tipc_msg_build(hdr, m, 0, dlen, mtu, &pkts);
>         if (unlikely(rc !=3D dlen))
>                 return rc;
> @@ -1387,7 +1387,7 @@ static int __tipc_sendmsg(struct socket *sock, stru=
ct msghdr *m, size_t dlen)
>         if (unlikely(rc))
>                 return rc;
>
> -       skb_queue_head_init(&pkts);
> +       __skb_queue_head_init(&pkts);
>         mtu =3D tipc_node_get_mtu(net, dnode, tsk->portid);
>         rc =3D tipc_msg_build(hdr, m, 0, dlen, mtu, &pkts);
>         if (unlikely(rc !=3D dlen))
> @@ -1445,7 +1445,7 @@ static int __tipc_sendstream(struct socket *sock, s=
truct msghdr *m, size_t dlen)
>         int send, sent =3D 0;
>         int rc =3D 0;
>
> -       skb_queue_head_init(&pkts);
> +       __skb_queue_head_init(&pkts);
>
>         if (unlikely(dlen > INT_MAX))
>                 return -EMSGSIZE;
> @@ -1805,7 +1805,7 @@ static int tipc_recvmsg(struct socket *sock, struct=
 msghdr *m,
>
>         /* Send group flow control advertisement when applicable */
>         if (tsk->group && msg_in_group(hdr) && !grp_evt) {
> -               skb_queue_head_init(&xmitq);
> +               __skb_queue_head_init(&xmitq);
>                 tipc_group_update_rcv_win(tsk->group, tsk_blocks(hlen + d=
len),
>                                           msg_orignode(hdr), msg_origport=
(hdr),
>                                           &xmitq);
> @@ -2674,7 +2674,7 @@ static void tipc_sk_timeout(struct timer_list *t)
>         struct sk_buff_head list;
>         int rc =3D 0;
>
> -       skb_queue_head_init(&list);
> +       __skb_queue_head_init(&list);
>         bh_lock_sock(sk);
>
>         /* Try again later if socket is busy */
> --
> 2.1.4
>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
