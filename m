Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E283568B3
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 12:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350546AbhDGKD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 06:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350475AbhDGKC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 06:02:58 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341D6C061762;
        Wed,  7 Apr 2021 03:02:49 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id nh5so7278214pjb.5;
        Wed, 07 Apr 2021 03:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EqEr2DsyMD23EeqfaBUVzH8Dhr2p1mkCG2jf83LkeAE=;
        b=SeK8NMvEG13x4bnDe4OeRXJgGNmO4yxslWRFfzrGnylrmZg5rAPA8Hi/t++jon30jI
         1QSqqBnc+IToX+151G/EzZVF4drQAoxPMGQAfaLw9mj+XM12aCtwzDELA1w0mkqsPwtn
         cOtWee5OaNWVv2CHhsFkRIhqbSRY5pYyU/t7qGatjJZXV9KFfusERTo+zWR/7miP8cXy
         mYQYk/0P8Xv+ich/raPnzpSclRxQnjDg8fp/wHeDq+1ic9XeJZYe+xaDjms8tVE5yQ7p
         Vd+SbTMijamUA1vDt3kFCHWft2MNdeOvZLf2j66cLl1n12rrQpPLphSyNnbuO4uUeH07
         c0dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EqEr2DsyMD23EeqfaBUVzH8Dhr2p1mkCG2jf83LkeAE=;
        b=rYG25ANJFPGrYi7R/nMin3ArvoJHLnw+sMbVYlcNx4lslzWVGjTiJuLYAhnhm8KqUJ
         Nv4FA/b4J5zWGPPZbaMOA1jG0bb7DSv34BWNizgqK3pVVLMWQkHtT87Hi28he/4lybS2
         lzdJRpSsxDNngg3zBZjmbsFWDpfp1bndsRHPpsHnLBpl5FP4dq/i1gsUMhGvZ8iv9Gip
         +H7xtG9EnYm5kPdwL/bP674QHDaunTPz8Y010Rkc1801CYa+9iToZAiUMInFBXyk+zxJ
         gcQH95F+UydV8KHGJ7hLyGJzhjDBuz4Y9Ecms5Sc1xUDw4EU4SLNACtWT6nZQMazD4hF
         cuBw==
X-Gm-Message-State: AOAM531JTum7pjwf2RUDc+FgzXfTSeQE8GL4wQfFkH6q/ZTQMtCj6M1s
        at9RDfh0lfukSQFIZNKmfRxVp4Ik0ImK/1BxPqU=
X-Google-Smtp-Source: ABdhPJzEsbj5zFxiBQ4mztuu8KHwTwIXnOVUlQbT74PHrpM/Hr7u2hzEh3TdqznBvNnkQtitUQdByeO/QhwLAWnqjoc=
X-Received: by 2002:a17:90a:7144:: with SMTP id g4mr2527247pjs.117.1617789768526;
 Wed, 07 Apr 2021 03:02:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210331071139.15473-1-xuanzhuo@linux.alibaba.com>
 <20210331071139.15473-4-xuanzhuo@linux.alibaba.com> <97a147bc-f9b8-ce95-889d-274893fd0444@redhat.com>
In-Reply-To: <97a147bc-f9b8-ce95-889d-274893fd0444@redhat.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 7 Apr 2021 12:02:37 +0200
Message-ID: <CAJ8uoz3Li9XrFQ=WH5u22EBFkK97RKqDcGGoX6W963w=RsQ9Pw@mail.gmail.com>
Subject: Re: [PATCH net-next v3 3/8] virtio-net: xsk zero copy xmit setup
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

On Tue, Apr 6, 2021 at 3:13 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/3/31 =E4=B8=8B=E5=8D=883:11, Xuan Zhuo =E5=86=99=E9=81=93:
> > xsk is a high-performance packet receiving and sending technology.
> >
> > This patch implements the binding and unbinding operations of xsk and
> > the virtio-net queue for xsk zero copy xmit.
> >
> > The xsk zero copy xmit depends on tx napi. So if tx napi is not opened,
> > an error will be reported. And the entire operation is under the
> > protection of rtnl_lock
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
> > ---
> >   drivers/net/virtio_net.c | 66 +++++++++++++++++++++++++++++++++++++++=
+
> >   1 file changed, 66 insertions(+)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index bb4ea9dbc16b..4e25408a2b37 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -22,6 +22,7 @@
> >   #include <net/route.h>
> >   #include <net/xdp.h>
> >   #include <net/net_failover.h>
> > +#include <net/xdp_sock_drv.h>
> >
> >   static int napi_weight =3D NAPI_POLL_WEIGHT;
> >   module_param(napi_weight, int, 0444);
> > @@ -133,6 +134,11 @@ struct send_queue {
> >       struct virtnet_sq_stats stats;
> >
> >       struct napi_struct napi;
> > +
> > +     struct {
> > +             /* xsk pool */
> > +             struct xsk_buff_pool __rcu *pool;
> > +     } xsk;
> >   };
> >
> >   /* Internal representation of a receive virtqueue */
> > @@ -2526,11 +2532,71 @@ static int virtnet_xdp_set(struct net_device *d=
ev, struct bpf_prog *prog,
> >       return err;
> >   }
> >
> > +static int virtnet_xsk_pool_enable(struct net_device *dev,
> > +                                struct xsk_buff_pool *pool,
> > +                                u16 qid)
> > +{
> > +     struct virtnet_info *vi =3D netdev_priv(dev);
> > +     struct send_queue *sq;
> > +     int ret =3D -EBUSY;
>
>
> I'd rather move this under the check of xsk.pool.
>
>
> > +
> > +     if (qid >=3D vi->curr_queue_pairs)
> > +             return -EINVAL;
> > +
> > +     sq =3D &vi->sq[qid];
> > +
> > +     /* xsk zerocopy depend on the tx napi */
>
>
> Need more comments to explain why tx NAPI is required here.
>
> And what's more important, tx NAPI could be enabled/disable via ethtool,
> what if the NAPI is disabled after xsk is enabled?
>
>
> > +     if (!sq->napi.weight)
> > +             return -EPERM;
> > +
> > +     rcu_read_lock();
> > +     if (rcu_dereference(sq->xsk.pool))
> > +             goto end;
>
>
> Under what condition can we reach here?

There is already code in the common xsk part that tests for binding
multiple sockets to the same netdev and queue id (in an illegal way
that is). Does this code not work for you? If so, we should fix that
and not introduce a separate check down in the driver. Or maybe I
misunderstand your problem.

The code is here:

struct xsk_buff_pool *xsk_get_pool_from_qid(struct net_device *dev,
                                            u16 queue_id)
{
        if (queue_id < dev->real_num_rx_queues)
                return dev->_rx[queue_id].pool;
        if (queue_id < dev->real_num_tx_queues)
                return dev->_tx[queue_id].pool;

        return NULL;
}

int xp_assign_dev(struct xsk_buff_pool *pool,
                  struct net_device *netdev, u16 queue_id, u16 flags)
{
        :
        :
        if (xsk_get_pool_from_qid(netdev, queue_id))
                return -EBUSY;


>
> > +
> > +     /* Here is already protected by rtnl_lock, so rcu_assign_pointer =
is
> > +      * safe.
> > +      */
> > +     rcu_assign_pointer(sq->xsk.pool, pool);
> > +     ret =3D 0;
> > +end:
> > +     rcu_read_unlock();
> > +
> > +     return ret;
> > +}
> > +
> > +static int virtnet_xsk_pool_disable(struct net_device *dev, u16 qid)
> > +{
> > +     struct virtnet_info *vi =3D netdev_priv(dev);
> > +     struct send_queue *sq;
> > +
> > +     if (qid >=3D vi->curr_queue_pairs)
> > +             return -EINVAL;
> > +
> > +     sq =3D &vi->sq[qid];
> > +
> > +     /* Here is already protected by rtnl_lock, so rcu_assign_pointer =
is
> > +      * safe.
> > +      */
> > +     rcu_assign_pointer(sq->xsk.pool, NULL);
> > +
> > +     synchronize_rcu(); /* Sync with the XSK wakeup and with NAPI. */
>
>
> Since rtnl is held here, I guess it's better to use synchornize_net().
>
>
> > +
> > +     return 0;
> > +}
> > +
> >   static int virtnet_xdp(struct net_device *dev, struct netdev_bpf *xdp=
)
> >   {
> >       switch (xdp->command) {
> >       case XDP_SETUP_PROG:
> >               return virtnet_xdp_set(dev, xdp->prog, xdp->extack);
> > +     case XDP_SETUP_XSK_POOL:
> > +             /* virtio net not use dma before call vring api */
> > +             xdp->xsk.check_dma =3D false;
>
>
> I think it's better not open code things like this. How about introduce
> new parameters in xp_assign_dev()?
>
>
> > +             if (xdp->xsk.pool)
> > +                     return virtnet_xsk_pool_enable(dev, xdp->xsk.pool=
,
> > +                                                    xdp->xsk.queue_id)=
;
> > +             else
> > +                     return virtnet_xsk_pool_disable(dev, xdp->xsk.que=
ue_id);
> >       default:
> >               return -EINVAL;
> >       }
>
>
> Thanks
>
