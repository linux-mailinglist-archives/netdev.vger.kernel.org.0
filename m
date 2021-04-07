Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 627D435688D
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 11:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350433AbhDGJ5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 05:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346426AbhDGJ5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 05:57:13 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D324C061756;
        Wed,  7 Apr 2021 02:57:03 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id g15so12537910pfq.3;
        Wed, 07 Apr 2021 02:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DDwy88lKL90j/yU0Sd9HPGxDv86aLgS4Tqux4KqcdnE=;
        b=Y/R/9SjByJ+0xqpTL8g0nUTqacnfSyykojnWT2Cr3fzI801sUpPCbKl9rGEoBZBSqd
         sRjJRV0dn65dvfF2zEk6rvxSrB/n20RloCY6JLMagGLxdGpf3pULxB5TvsCY0fJsctQi
         oqaxDhXXEM920dp12hC6Khk9Rp6JqMCWKnYNZvhn5LUK1TVbmjwU0AtOsPeOMiiGOQT/
         eqdIEm6bd9pEK10QXZg76lO/klcYfcVqp3ipMJkXwuhgHhl4rwzbovv02WdygFDgIOPE
         OO5Z5HMZNnKv+x3bc/P0zBXKQgPo1qxQn9vQySzxCMvlHGD2ioBuJBSZLp57Jl6UswSJ
         yp2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DDwy88lKL90j/yU0Sd9HPGxDv86aLgS4Tqux4KqcdnE=;
        b=qW6mnfeWP2jr+9SPndC7GKdHtBfuc3lrQe1L4hxZXoOweaikLX9jDrkngNEnbM5bDk
         leabsLN2HTCIVRDURZJ4jQtyU6KdPik64GSjoyxWfXN9EPc9Um9mbjtCMlzF3n67HnYI
         sbfrI2Szv6jqINDdUwqjZYHwkrqFTgEDzywYQrvosoPRoUqUzToMIiJYxawK7wmmdGrJ
         3WgAum+f7L2Hz42W7s9npd5UPwtO0gFKGiFfy8WarDZQLKrf8lui6TLOn2lMtyztt4QS
         gfaPWwZh/E+6rQaPKZbpmE7yIQ/ywxqFmuwAe5mItulPu5QarSLM1o72sick1JdjZEIx
         Dpxw==
X-Gm-Message-State: AOAM531aOW6/dQrmMYYrf5IMRLgXLRiY0kDPAp9IBGMaspzwy/niA0Sz
        AVLLml/9iOcEX0HeuHF8GzcvkeJGegzmA/R8kVw=
X-Google-Smtp-Source: ABdhPJzezRN9jvp+TWWc/RCJHjNUuln+K4jW+EK/SB0WBqSm6eg3XJOQjxeaxhJgSeREhlC63UQ1Z+JJm87mrn7q0bY=
X-Received: by 2002:a05:6a00:b54:b029:207:2a04:7b05 with SMTP id
 p20-20020a056a000b54b02902072a047b05mr2155398pfo.12.1617789422854; Wed, 07
 Apr 2021 02:57:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210331071139.15473-1-xuanzhuo@linux.alibaba.com>
 <20210331071139.15473-5-xuanzhuo@linux.alibaba.com> <3d54007e-71b0-bf91-3904-815653860cf3@redhat.com>
In-Reply-To: <3d54007e-71b0-bf91-3904-815653860cf3@redhat.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 7 Apr 2021 11:56:51 +0200
Message-ID: <CAJ8uoz1Dc2sm55hFZ1aQ8O3JCaeLdDtm6Yipht2J6kU0qsQFHA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 4/8] virtio-net: xsk zero copy xmit implement
 wakeup and xmit
To:     Jason Wang <jasowang@redhat.com>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Network Development <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        virtualization@lists.linux-foundation.org,
        bpf <bpf@vger.kernel.org>, Dust Li <dust.li@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 6, 2021 at 3:33 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/3/31 =E4=B8=8B=E5=8D=883:11, Xuan Zhuo =E5=86=99=E9=81=93:
> > When the user calls sendto to consume the data in the xsk tx queue,
> > virtnet_xsk_wakeup will be called.
> >
> > In wakeup, it will try to send a part of the data directly, the quantit=
y
> > is operated by the module parameter xsk_budget.
>
>
> Any reason that we can't use NAPI budget?

I think we should use NAPI budget here and skip this module parameter.
If a user would like to control the number of packets processed, then
the preferred busy_poll mode [1] can be used. In that patch series, a
new setsockopt option was introduced called SO_BUSY_POLL_BUDGET. With
it you can set the napi budget value without the need of a module
parameter.

[1]: https://lore.kernel.org/bpf/20201119083024.119566-1-bjorn.topel@gmail.=
com/T/

>
> >   There are two purposes
> > for this realization:
> >
> > 1. Send part of the data quickly to reduce the transmission delay of th=
e
> >     first packet
> > 2. Trigger tx interrupt, start napi to consume xsk tx data
> >
> > All sent xsk packets share the virtio-net header of xsk_hdr. If xsk
> > needs to support csum and other functions later, consider assigning xsk
> > hdr separately for each sent packet.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
> > ---
> >   drivers/net/virtio_net.c | 183 ++++++++++++++++++++++++++++++++++++++=
+
> >   1 file changed, 183 insertions(+)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 4e25408a2b37..c8a317a93ef7 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -28,9 +28,11 @@ static int napi_weight =3D NAPI_POLL_WEIGHT;
> >   module_param(napi_weight, int, 0444);
> >
> >   static bool csum =3D true, gso =3D true, napi_tx =3D true;
> > +static int xsk_budget =3D 32;
> >   module_param(csum, bool, 0444);
> >   module_param(gso, bool, 0444);
> >   module_param(napi_tx, bool, 0644);
> > +module_param(xsk_budget, int, 0644);
> >
> >   /* FIXME: MTU in config. */
> >   #define GOOD_PACKET_LEN (ETH_HLEN + VLAN_HLEN + ETH_DATA_LEN)
> > @@ -47,6 +49,8 @@ module_param(napi_tx, bool, 0644);
> >
> >   #define VIRTIO_XDP_FLAG     BIT(0)
> >
> > +static struct virtio_net_hdr_mrg_rxbuf xsk_hdr;
> > +
> >   /* RX packet size EWMA. The average packet size is used to determine =
the packet
> >    * buffer size when refilling RX rings. As the entire RX ring may be =
refilled
> >    * at once, the weight is chosen so that the EWMA will be insensitive=
 to short-
> > @@ -138,6 +142,9 @@ struct send_queue {
> >       struct {
> >               /* xsk pool */
> >               struct xsk_buff_pool __rcu *pool;
> > +
> > +             /* save the desc for next xmit, when xmit fail. */
> > +             struct xdp_desc last_desc;
> >       } xsk;
> >   };
> >
> > @@ -2532,6 +2539,179 @@ static int virtnet_xdp_set(struct net_device *d=
ev, struct bpf_prog *prog,
> >       return err;
> >   }
> >
> > +static void virtnet_xsk_check_space(struct send_queue *sq)
> > +{
>
>
> The name is confusing, the function does more than just checking the
> space, it may stop the queue as well.
>
>
> > +     struct virtnet_info *vi =3D sq->vq->vdev->priv;
> > +     struct net_device *dev =3D vi->dev;
> > +     int qnum =3D sq - vi->sq;
> > +
> > +     /* If this sq is not the exclusive queue of the current cpu,
> > +      * then it may be called by start_xmit, so check it running out
> > +      * of space.
> > +      */
>
>
> So the code can explain itself. We need a better comment to explain why
> we need to differ the case of the raw buffer queue.
>
>
> > +     if (is_xdp_raw_buffer_queue(vi, qnum))
> > +             return;
> > +
> > +     /* Stop the queue to avoid getting packets that we are
> > +      * then unable to transmit. Then wait the tx interrupt.
> > +      */
> > +     if (sq->vq->num_free < 2 + MAX_SKB_FRAGS)
> > +             netif_stop_subqueue(dev, qnum);
> > +}
> > +
> > +static int virtnet_xsk_xmit(struct send_queue *sq, struct xsk_buff_poo=
l *pool,
> > +                         struct xdp_desc *desc)
> > +{
> > +     struct virtnet_info *vi;
> > +     struct page *page;
> > +     void *data;
> > +     u32 offset;
> > +     u64 addr;
> > +     int err;
> > +
> > +     vi =3D sq->vq->vdev->priv;
> > +     addr =3D desc->addr;
> > +     data =3D xsk_buff_raw_get_data(pool, addr);
> > +     offset =3D offset_in_page(data);
> > +
> > +     sg_init_table(sq->sg, 2);
> > +     sg_set_buf(sq->sg, &xsk_hdr, vi->hdr_len);
> > +     page =3D xsk_buff_xdp_get_page(pool, addr);
> > +     sg_set_page(sq->sg + 1, page, desc->len, offset);
> > +
> > +     err =3D virtqueue_add_outbuf(sq->vq, sq->sg, 2, NULL, GFP_ATOMIC)=
;
> > +     if (unlikely(err))
> > +             sq->xsk.last_desc =3D *desc;
>
>
> So I think it's better to make sure we had at least 2 slots to avoid
> handling errors like this? (Especially consider the queue size is not
> necessarily the power of 2 when packed virtqueue is used).
>
>
> > +
> > +     return err;
> > +}
> > +
> > +static int virtnet_xsk_xmit_batch(struct send_queue *sq,
> > +                               struct xsk_buff_pool *pool,
> > +                               unsigned int budget,
> > +                               bool in_napi, int *done)
> > +{
> > +     struct xdp_desc desc;
> > +     int err, packet =3D 0;
> > +     int ret =3D -EAGAIN;
> > +
> > +     if (sq->xsk.last_desc.addr) {
>
>
> Any reason that num_free is not checked here?
>
>
> > +             err =3D virtnet_xsk_xmit(sq, pool, &sq->xsk.last_desc);
> > +             if (unlikely(err))
> > +                     return -EBUSY;
> > +
> > +             ++packet;
> > +             --budget;
> > +             sq->xsk.last_desc.addr =3D 0;
> > +     }
> > +
> > +     while (budget-- > 0) {
> > +             if (sq->vq->num_free < 2 + MAX_SKB_FRAGS) {
> > +                     ret =3D -EBUSY;
> > +                     break;
> > +             }
> > +
> > +             if (!xsk_tx_peek_desc(pool, &desc)) {
> > +                     /* done */
> > +                     ret =3D 0;
> > +                     break;
> > +             }
> > +
> > +             err =3D virtnet_xsk_xmit(sq, pool, &desc);
> > +             if (unlikely(err)) {
> > +                     ret =3D -EBUSY;
> > +                     break;
> > +             }
> > +
> > +             ++packet;
> > +     }
> > +
> > +     if (packet) {
> > +             if (virtqueue_kick_prepare(sq->vq) &&
> > +                 virtqueue_notify(sq->vq)) {
> > +                     u64_stats_update_begin(&sq->stats.syncp);
> > +                     sq->stats.kicks +=3D 1;
> > +                     u64_stats_update_end(&sq->stats.syncp);
> > +             }
> > +
> > +             *done =3D packet;
> > +
> > +             xsk_tx_release(pool);
> > +     }
> > +
> > +     return ret;
> > +}
> > +
> > +static int virtnet_xsk_run(struct send_queue *sq, struct xsk_buff_pool=
 *pool,
> > +                        int budget, bool in_napi)
> > +{
> > +     int done =3D 0;
> > +     int err;
> > +
> > +     free_old_xmit_skbs(sq, in_napi);
> > +
> > +     err =3D virtnet_xsk_xmit_batch(sq, pool, budget, in_napi, &done);
> > +     /* -EAGAIN: done =3D=3D budget
> > +      * -EBUSY: done < budget
> > +      *  0    : done < budget
> > +      */
>
>
> Please move them to the comment above virtnet_xsk_xmit_batch().
>
> And it looks to me there's no care for -EAGAIN, any reason for sticking
> a dedicated variable like that?
>
>
> > +     if (err =3D=3D -EBUSY) {
> > +             free_old_xmit_skbs(sq, in_napi);
> > +
> > +             /* If the space is enough, let napi run again. */
> > +             if (sq->vq->num_free >=3D 2 + MAX_SKB_FRAGS)
> > +                     done =3D budget;
>
>
> So I don't see how this can work in the case of event index where the
> notification needs to be enabled explicitly.
>
>
> > +     }
> > +
> > +     virtnet_xsk_check_space(sq);
> > +
> > +     return done;
> > +}
> > +
> > +static int virtnet_xsk_wakeup(struct net_device *dev, u32 qid, u32 fla=
g)
> > +{
> > +     struct virtnet_info *vi =3D netdev_priv(dev);
> > +     struct xsk_buff_pool *pool;
> > +     struct netdev_queue *txq;
> > +     struct send_queue *sq;
> > +
> > +     if (!netif_running(dev))
> > +             return -ENETDOWN;
> > +
> > +     if (qid >=3D vi->curr_queue_pairs)
> > +             return -EINVAL;
> > +
> > +     sq =3D &vi->sq[qid];
> > +
> > +     rcu_read_lock();
> > +
> > +     pool =3D rcu_dereference(sq->xsk.pool);
> > +     if (!pool)
> > +             goto end;
> > +
> > +     if (napi_if_scheduled_mark_missed(&sq->napi))
> > +             goto end;
> > +
> > +     txq =3D netdev_get_tx_queue(dev, qid);
> > +
> > +     __netif_tx_lock_bh(txq);
> > +
> > +     /* Send part of the packet directly to reduce the delay in sendin=
g the
> > +      * packet, and this can actively trigger the tx interrupts.
> > +      *
> > +      * If no packet is sent out, the ring of the device is full. In t=
his
> > +      * case, we will still get a tx interrupt response. Then we will =
deal
> > +      * with the subsequent packet sending work.
> > +      */
> > +     virtnet_xsk_run(sq, pool, xsk_budget, false);
>
>
> So the return value is ignored, this means there's no way to report we
> exhaust the budget. Is this intended?
>
> Thanks
>
>
> > +
> > +     __netif_tx_unlock_bh(txq);
> > +
> > +end:
> > +     rcu_read_unlock();
> > +     return 0;
> > +}
> > +
> >   static int virtnet_xsk_pool_enable(struct net_device *dev,
> >                                  struct xsk_buff_pool *pool,
> >                                  u16 qid)
> > @@ -2553,6 +2733,8 @@ static int virtnet_xsk_pool_enable(struct net_dev=
ice *dev,
> >       if (rcu_dereference(sq->xsk.pool))
> >               goto end;
> >
> > +     memset(&sq->xsk, 0, sizeof(sq->xsk));
> > +
> >       /* Here is already protected by rtnl_lock, so rcu_assign_pointer =
is
> >        * safe.
> >        */
> > @@ -2656,6 +2838,7 @@ static const struct net_device_ops virtnet_netdev=
 =3D {
> >       .ndo_vlan_rx_kill_vid =3D virtnet_vlan_rx_kill_vid,
> >       .ndo_bpf                =3D virtnet_xdp,
> >       .ndo_xdp_xmit           =3D virtnet_xdp_xmit,
> > +     .ndo_xsk_wakeup         =3D virtnet_xsk_wakeup,
> >       .ndo_features_check     =3D passthru_features_check,
> >       .ndo_get_phys_port_name =3D virtnet_get_phys_port_name,
> >       .ndo_set_features       =3D virtnet_set_features,
>
