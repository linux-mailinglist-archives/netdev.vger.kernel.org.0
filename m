Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBF96EBD2D
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 07:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbjDWF3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 01:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbjDWF3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 01:29:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 030161736
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 22:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682227700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g4+/LxDmpBQ0pUK+KoI7uHx6YYMFfdNIsiVOFUa1ydk=;
        b=AG/Act3VX4b/8qTFXfbAia+xXXF3Jo6dOKcd2p8cJgYw2ycwa1cmtVlfzb5gme0wQqlJoZ
        AT/he0i6YKizJIjvH2k+hUuU++EhmAHbqC/BhT6xxr+ZtTjxOqTk0HxpWAlOq1TMev5Sh3
        fp+CQ+3oR4U+ciAgn9mQ+Tlv8845rL4=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-474-oqQwtrPgN3eHfbpKOKtMhQ-1; Sun, 23 Apr 2023 01:28:19 -0400
X-MC-Unique: oqQwtrPgN3eHfbpKOKtMhQ-1
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-38e4f308c49so2416178b6e.1
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 22:28:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682227698; x=1684819698;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g4+/LxDmpBQ0pUK+KoI7uHx6YYMFfdNIsiVOFUa1ydk=;
        b=ekvGEU4byHZ8jE2gFlSTEIKaeMM4L9IH02Ja5DNrSFQyqI1+nmcmekkVH/cpmRrFzo
         pFdd4jqGFeeMecS+V1E3k9sx2u/dXj9EaugoNrL2BbeZzZ+48sMgiOMQ4dMK37Gpd+GD
         CURVa0sJ5K5ST2U7anDy8O9Xc9GJp/PrXeOMdyIe1u/Hn4TXLG2pFeTA3jgFq/ApvjNz
         /44aG5bm4kxe9cSflNs9i0K/fprlMCuXk5CZZ0OE9hCCNjy94Up7GFgjjdMEVBMjubhE
         JqE0jLv4wsaU1ZPIZE63Zl+YDFk50b5fyU68cVBfEhv9aGaKRqMxg9gi2d5Yjml+rloy
         Sgcg==
X-Gm-Message-State: AAQBX9fe02Mix6PDi47ILuKVmuW4q4ncY6ogRm0jD6gn3PQHRdd//MUt
        oh8lH5Hd4yXfQv9GWoBLXyaZ6TilgOCwiuT6LDj1s5eRxy9ABlYqNSH4s4LvQ/g0miGRyJ0MHWe
        Dym7UUjGBEB7cPypadYi/yKqpPZQYVpHZf97MdESfmivY0w==
X-Received: by 2002:a05:6808:151:b0:38e:46ed:7738 with SMTP id h17-20020a056808015100b0038e46ed7738mr5386373oie.0.1682227698616;
        Sat, 22 Apr 2023 22:28:18 -0700 (PDT)
X-Google-Smtp-Source: AKy350aPhNVA73PjfigKtvHV5ftX0Ze6uWwJu4CU2+VZckf4SiE7FpHbuum5CFDMlxXxdB+424F0ae0G3Ble9WPwOOk=
X-Received: by 2002:a05:6808:151:b0:38e:46ed:7738 with SMTP id
 h17-20020a056808015100b0038e46ed7738mr5386363oie.0.1682227698356; Sat, 22 Apr
 2023 22:28:18 -0700 (PDT)
MIME-Version: 1.0
References: <20230418065327.72281-1-xuanzhuo@linux.alibaba.com>
 <20230418065327.72281-6-xuanzhuo@linux.alibaba.com> <20230421025931-mutt-send-email-mst@kernel.org>
 <1682061840.4864874-1-xuanzhuo@linux.alibaba.com> <20230421075119-mutt-send-email-mst@kernel.org>
 <1682215068.3012342-2-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1682215068.3012342-2-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Sun, 23 Apr 2023 13:28:07 +0800
Message-ID: <CACGkMEs866j3pwWp6S-tJrMa0b0z5r7TmDO6iRKYO_n1FXTXGg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 05/14] virtio_net: introduce xdp res enums
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 23, 2023 at 10:05=E2=80=AFAM Xuan Zhuo <xuanzhuo@linux.alibaba.=
com> wrote:
>
> On Fri, 21 Apr 2023 07:54:11 -0400, "Michael S. Tsirkin" <mst@redhat.com>=
 wrote:
> > On Fri, Apr 21, 2023 at 03:24:00PM +0800, Xuan Zhuo wrote:
> > > On Fri, 21 Apr 2023 03:00:15 -0400, "Michael S. Tsirkin" <mst@redhat.=
com> wrote:
> > > > On Tue, Apr 18, 2023 at 02:53:18PM +0800, Xuan Zhuo wrote:
> > > > > virtnet_xdp_handler() is to process all the logic related to XDP.=
 The
> > > > > caller only needs to care about how to deal with the buf. So this=
 commit
> > > > > introduces new enums:
> > > > >
> > > > > 1. VIRTNET_XDP_RES_PASS: make skb by the buf
> > > > > 2. VIRTNET_XDP_RES_DROP: xdp return drop action or some error, ca=
ller
> > > > >    should release the buf
> > > > > 3. VIRTNET_XDP_RES_CONSUMED: xdp consumed the buf, the caller doe=
snot to
> > > > >    do anything
> > > > >
> > > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > >
> > > >
> > > > I am not excited about using virtio specific enums then translating
> > > > to standard ones.
> > >
> > >
> > > My fault, my expression is not very complete.
> > >
> > > This is not a replacement, but just want to say, there are only three=
 cases of
> > > virtnet_xdp_handler. Caller only needs to handle this three cases. In=
stead
> > > of paying attention to the detailed return results of XDP.
> > >
> > > In addition, virtnet_xdp_handler returns XDP_TX, but in fact, the wor=
k of XDP_TX
> > > is already done in Virtnet_xdp_handler. Caller does not need to do an=
ything for
> > > XDP_TX, giving people a feeling, XDP_TX does not need to be processed=
. I think
> > > it is not good.
> > >
> > > Thanks.
> >
> > I don't really get it, sorry. If it's possible to stick to
> > XDP return codes, that is preferable.
>
> Although, I still think that it would be better to use VIRTNET_XDP_RES_*,=
 and
> other drivers did the same thing. If you still insist, I can remove this =
commit.
>

I second for sticking to XDP return codes.

(Since I didn't really get what's wrong with that).

Thanks

> In addition, I think squashing this patch to the previous patch may be mo=
re
> suitable. Just like I done in last patchset. @Jason
>
> Because what I want to express is that virtnet_xdp_handler() has only thr=
ee
> kinds of returns, caller does not need to pay attention to the details of=
 XDP
> returns.
>
> Thanks.
>
>
> >
> > >
> > >
> > > >
> > > > > ---
> > > > >  drivers/net/virtio_net.c | 42 ++++++++++++++++++++++++++--------=
------
> > > > >  1 file changed, 27 insertions(+), 15 deletions(-)
> > > > >
> > > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > > index 0fa64c314ea7..4dfdc211d355 100644
> > > > > --- a/drivers/net/virtio_net.c
> > > > > +++ b/drivers/net/virtio_net.c
> > > > > @@ -301,6 +301,15 @@ struct padded_vnet_hdr {
> > > > >         char padding[12];
> > > > >  };
> > > > >
> > > > > +enum {
> > > > > +       /* xdp pass */
> > > > > +       VIRTNET_XDP_RES_PASS,
> > > > > +       /* drop packet. the caller needs to release the page. */
> > > > > +       VIRTNET_XDP_RES_DROP,
> > > > > +       /* packet is consumed by xdp. the caller needs to do noth=
ing. */
> > > > > +       VIRTNET_XDP_RES_CONSUMED,
> > > > > +};
> > > > > +
> > > > >  static void virtnet_rq_free_unused_buf(struct virtqueue *vq, voi=
d *buf);
> > > > >  static void virtnet_sq_free_unused_buf(struct virtqueue *vq, voi=
d *buf);
> > > > >
> > > > > @@ -803,14 +812,14 @@ static int virtnet_xdp_handler(struct bpf_p=
rog *xdp_prog, struct xdp_buff *xdp,
> > > > >
> > > > >         switch (act) {
> > > > >         case XDP_PASS:
> > > > > -               return act;
> > > > > +               return VIRTNET_XDP_RES_PASS;
> > > > >
> > > > >         case XDP_TX:
> > > > >                 stats->xdp_tx++;
> > > > >                 xdpf =3D xdp_convert_buff_to_frame(xdp);
> > > > >                 if (unlikely(!xdpf)) {
> > > > >                         netdev_dbg(dev, "convert buff to frame fa=
iled for xdp\n");
> > > > > -                       return XDP_DROP;
> > > > > +                       return VIRTNET_XDP_RES_DROP;
> > > > >                 }
> > > > >
> > > > >                 err =3D virtnet_xdp_xmit(dev, 1, &xdpf, 0);
> > > > > @@ -818,19 +827,20 @@ static int virtnet_xdp_handler(struct bpf_p=
rog *xdp_prog, struct xdp_buff *xdp,
> > > > >                         xdp_return_frame_rx_napi(xdpf);
> > > > >                 } else if (unlikely(err < 0)) {
> > > > >                         trace_xdp_exception(dev, xdp_prog, act);
> > > > > -                       return XDP_DROP;
> > > > > +                       return VIRTNET_XDP_RES_DROP;
> > > > >                 }
> > > > > +
> > > > >                 *xdp_xmit |=3D VIRTIO_XDP_TX;
> > > > > -               return act;
> > > > > +               return VIRTNET_XDP_RES_CONSUMED;
> > > > >
> > > > >         case XDP_REDIRECT:
> > > > >                 stats->xdp_redirects++;
> > > > >                 err =3D xdp_do_redirect(dev, xdp, xdp_prog);
> > > > >                 if (err)
> > > > > -                       return XDP_DROP;
> > > > > +                       return VIRTNET_XDP_RES_DROP;
> > > > >
> > > > >                 *xdp_xmit |=3D VIRTIO_XDP_REDIR;
> > > > > -               return act;
> > > > > +               return VIRTNET_XDP_RES_CONSUMED;
> > > > >
> > > > >         default:
> > > > >                 bpf_warn_invalid_xdp_action(dev, xdp_prog, act);
> > > > > @@ -839,7 +849,7 @@ static int virtnet_xdp_handler(struct bpf_pro=
g *xdp_prog, struct xdp_buff *xdp,
> > > > >                 trace_xdp_exception(dev, xdp_prog, act);
> > > > >                 fallthrough;
> > > > >         case XDP_DROP:
> > > > > -               return XDP_DROP;
> > > > > +               return VIRTNET_XDP_RES_DROP;
> > > > >         }
> > > > >  }
> > > > >
> > > > > @@ -987,17 +997,18 @@ static struct sk_buff *receive_small(struct=
 net_device *dev,
> > > > >                 act =3D virtnet_xdp_handler(xdp_prog, &xdp, dev, =
xdp_xmit, stats);
> > > > >
> > > > >                 switch (act) {
> > > > > -               case XDP_PASS:
> > > > > +               case VIRTNET_XDP_RES_PASS:
> > > > >                         /* Recalculate length in case bpf program=
 changed it */
> > > > >                         delta =3D orig_data - xdp.data;
> > > > >                         len =3D xdp.data_end - xdp.data;
> > > > >                         metasize =3D xdp.data - xdp.data_meta;
> > > > >                         break;
> > > > > -               case XDP_TX:
> > > > > -               case XDP_REDIRECT:
> > > > > +
> > > > > +               case VIRTNET_XDP_RES_CONSUMED:
> > > > >                         rcu_read_unlock();
> > > > >                         goto xdp_xmit;
> > > > > -               default:
> > > > > +
> > > > > +               case VIRTNET_XDP_RES_DROP:
> > > > >                         goto err_xdp;
> > > > >                 }
> > > > >         }
> > > > > @@ -1324,18 +1335,19 @@ static struct sk_buff *receive_mergeable(=
struct net_device *dev,
> > > > >                 act =3D virtnet_xdp_handler(xdp_prog, &xdp, dev, =
xdp_xmit, stats);
> > > > >
> > > > >                 switch (act) {
> > > > > -               case XDP_PASS:
> > > > > +               case VIRTNET_XDP_RES_PASS:
> > > > >                         head_skb =3D build_skb_from_xdp_buff(dev,=
 vi, &xdp, xdp_frags_truesz);
> > > > >                         if (unlikely(!head_skb))
> > > > >                                 goto err_xdp_frags;
> > > > >
> > > > >                         rcu_read_unlock();
> > > > >                         return head_skb;
> > > > > -               case XDP_TX:
> > > > > -               case XDP_REDIRECT:
> > > > > +
> > > > > +               case VIRTNET_XDP_RES_CONSUMED:
> > > > >                         rcu_read_unlock();
> > > > >                         goto xdp_xmit;
> > > > > -               default:
> > > > > +
> > > > > +               case VIRTNET_XDP_RES_DROP:
> > > > >                         break;
> > > > >                 }
> > > > >  err_xdp_frags:
> > > > > --
> > > > > 2.32.0.3.g01195cf9f
> > > >
> >
>

