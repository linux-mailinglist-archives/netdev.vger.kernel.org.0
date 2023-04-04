Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF66F6D58CE
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 08:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233273AbjDDGgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 02:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233249AbjDDGgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 02:36:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA791722
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 23:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680590118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CUX74SgqHChWU1+Vc5/47wMgpih/X2QF6nAAh+toOCI=;
        b=W/Zyw2jPa5qF9biBYfjMic4YZ4r8I6DJ7rX1WOxBlIn8PyD8sxraYm8qMDIj0+lL2+T4Lg
        /swTTOMppQwp4dx/TqGftxpBR0ifuXBCXd09f0comgKBIXAFW5v3LlZVC/VkFihei6W5RA
        R3TYrKDuD+QdQygZLU/FamyfqbXh8Us=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-187-RRslg3S1M8qLV0nmZoll1w-1; Tue, 04 Apr 2023 02:35:17 -0400
X-MC-Unique: RRslg3S1M8qLV0nmZoll1w-1
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-177c9cc7db5so17017783fac.15
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 23:35:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680590117; x=1683182117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CUX74SgqHChWU1+Vc5/47wMgpih/X2QF6nAAh+toOCI=;
        b=2aNoIVdtkjrDXA6HRegnvsXSPMzhZCC0YnLpgm1oTCMpzamQDqLSq3mLeowX20W+0P
         9CJFb0mlst0K94RFl5+jpoyu3Nqy2PT31ppC3nflHN/Ub8eARm0c5ldrOofo9Hj0fbKv
         Mfx7r8mw4d4OZ49unw5/pyECK95JmRF0afGw3T0nn4Jf3FJjZCIV+puoWR3B+BE2QnZx
         4IPp25QtjRqOap/J4r/vXzGKTyzQEEGSj6VxQjncwJbe58GOpXbPbWpfzPF2su34Bi7Y
         DZL2T19QgYgSJJaduDdHWZXlMmlfumaEkggiTUQ0yP1CcQZR71Va5vENBXTz82NLHhRj
         Ywgw==
X-Gm-Message-State: AAQBX9efROkVgqUmeJw/ZyO+PG9rBNrWZN+fyThffKCtjwOib+ES05a4
        kyDjgNN0Lg5VwCZInYhkk48cyUduO4M0KNO+94kfNjyARmMcspYETSpdhyD5KEf2Mu1kQ9ZUUxf
        CFF6cyLxQi0+C3z3u0DqHnprj06ZJuJI7
X-Received: by 2002:a9d:6a5a:0:b0:69f:8fa8:1a4f with SMTP id h26-20020a9d6a5a000000b0069f8fa81a4fmr553935otn.2.1680590116957;
        Mon, 03 Apr 2023 23:35:16 -0700 (PDT)
X-Google-Smtp-Source: AKy350Y++WC9gOaPYM92sK4/+TiZBLTDwDmLqb4W8fKF399Z4Ob+lrXW39jbxqfM/XTS7eNOHz/bhxMjNkRQ3jw8WHY=
X-Received: by 2002:a9d:6a5a:0:b0:69f:8fa8:1a4f with SMTP id
 h26-20020a9d6a5a000000b0069f8fa81a4fmr553925otn.2.1680590116640; Mon, 03 Apr
 2023 23:35:16 -0700 (PDT)
MIME-Version: 1.0
References: <20230328120412.110114-1-xuanzhuo@linux.alibaba.com>
 <20230328120412.110114-4-xuanzhuo@linux.alibaba.com> <CACGkMEvZ=-G4QVTDnoSa1N0UspW8u_oz-7xosrXV0f1YcytVXw@mail.gmail.com>
 <1680495148.1559556-3-xuanzhuo@linux.alibaba.com> <CACGkMEvfTE1F7Wa3P2do1o+149kSdGkjyVYt6e4r2r5UQZ6ocA@mail.gmail.com>
 <1680588670.6153247-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1680588670.6153247-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 4 Apr 2023 14:35:05 +0800
Message-ID: <CACGkMEtTFk40ShdgyAJeBrUphZnMgk-RE0RpcHyc1uvSNoXAOA@mail.gmail.com>
Subject: Re: [PATCH net-next 3/8] virtio_net: introduce virtnet_xdp_handler()
 to seprate the logic of run xdp
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
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
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 4, 2023 at 2:22=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba.co=
m> wrote:
>
> On Tue, 4 Apr 2023 13:04:02 +0800, Jason Wang <jasowang@redhat.com> wrote=
:
> > On Mon, Apr 3, 2023 at 12:17=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.aliba=
ba.com> wrote:
> > >
> > > On Mon, 3 Apr 2023 10:43:03 +0800, Jason Wang <jasowang@redhat.com> w=
rote:
> > > > On Tue, Mar 28, 2023 at 8:04=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.a=
libaba.com> wrote:
> > > > >
> > > > > At present, we have two similar logic to perform the XDP prog.
> > > > >
> > > > > Therefore, this PATCH separates the code of executing XDP, which =
is
> > > > > conducive to later maintenance.
> > > > >
> > > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > > ---
> > > > >  drivers/net/virtio_net.c | 142 +++++++++++++++++++++------------=
------
> > > > >  1 file changed, 75 insertions(+), 67 deletions(-)
> > > > >
> > > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > > index bb426958cdd4..72b9d6ee4024 100644
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
> > > >
> > > > I'd prefer this to be done on top unless it is a must. But I don't =
see
> > > > any advantage of introducing this, it's partial mapping of XDP acti=
on
> > > > and it needs to be extended when XDP action is extended. (And we've
> > > > already had: VIRTIO_XDP_REDIR and VIRTIO_XDP_TX ...)
> > >
> > > No, these are the three states of buffer after XDP processing.
> > >
> > > * PASS: goto make skb
> >
> > XDP_PASS goes for this.
> >
> > > * DROP: we should release buffer
> >
> > XDP_DROP and error conditions go with this.
> >
> > > * CUNSUMED: xdp prog used the buffer, we do nothing
> >
> > XDP_TX/XDP_REDIRECTION goes for this.
> >
> > So t virtnet_xdp_handler() just maps XDP ACTION plus the error
> > conditions to the above three states.
> >
> > We can simply map error to XDP_DROP like:
> >
> >        case XDP_TX:
> >               stats->xdp_tx++;
> >                xdpf =3D xdp_convert_buff_to_frame(xdp);
> >                if (unlikely(!xdpf))
> >                        return XDP_DROP;
> >
> > A good side effect is to avoid the xdp_xmit pointer to be passed to
> > the function.
>
>
> So, I guess you mean this:
>
>         switch (act) {
>         case XDP_PASS:
>                 /* handle pass */
>                 return skb;
>
>         case XDP_TX:
>                 *xdp_xmit |=3D VIRTIO_XDP_TX;
>                 goto xmit;
>
>         case XDP_REDIRECT:
>                 *xdp_xmit |=3D VIRTIO_XDP_REDIR;
>                 goto xmit;
>
>         case XDP_DROP:
>         default:
>                 goto err_xdp;
>         }
>
> I have to say there is no problem from the perspective of code implementa=
tion.

Note that this is the current logic where it is determined in
receive_small() and receive_mergeable().

>
> But if the a new ACTION liking XDP_TX,XDP_REDIRECT is added in the future=
, then
> we must modify all the callers.

This is fine since we only use a single type for XDP action.

> This is the benefit of using CUNSUMED.

It's very hard to say, e.g if we want to support cloning in the future.

>
> I think it is a good advantage to put xdp_xmit in virtnet_xdp_handler(),
> which makes the caller not care too much about these details.

This part I don't understand, having xdp_xmit means the caller need to
know whether it is xmited or redirected. The point of the enum is to
hide the XDP actions, but it's conflict with what xdp_xmit who want to
expose (part of) the XDP actions.

> If you take into
> account the problem of increasing the number of parameters, I advise to p=
ut it
> in rq.

I don't have strong opinion to introduce the enum, what I want to say
is, use a separated patch to do that.

Thanks

>
> Thanks.
>
>
>
> >
> > >
> > > The latter two are not particularly related to XDP ACTION. And it doe=
s not need
> > > to extend when XDP action is extended. At least I have not thought of=
 this
> > > situation.
> >
> > What's the advantages of such indirection compared to using XDP action =
directly?
> >
> > Thanks
> >
> > >
> > >
> > > >
> > > > > +
> > > > >  static void virtnet_rq_free_unused_buf(struct virtqueue *vq, voi=
d *buf);
> > > > >  static void virtnet_sq_free_unused_buf(struct virtqueue *vq, voi=
d *buf);
> > > > >
> > > > > @@ -789,6 +798,59 @@ static int virtnet_xdp_xmit(struct net_devic=
e *dev,
> > > > >         return ret;
> > > > >  }
> > > > >
> > > > > +static int virtnet_xdp_handler(struct bpf_prog *xdp_prog, struct=
 xdp_buff *xdp,
> > > > > +                              struct net_device *dev,
> > > > > +                              unsigned int *xdp_xmit,
> > > > > +                              struct virtnet_rq_stats *stats)
> > > > > +{
> > > > > +       struct xdp_frame *xdpf;
> > > > > +       int err;
> > > > > +       u32 act;
> > > > > +
> > > > > +       act =3D bpf_prog_run_xdp(xdp_prog, xdp);
> > > > > +       stats->xdp_packets++;
> > > > > +
> > > > > +       switch (act) {
> > > > > +       case XDP_PASS:
> > > > > +               return VIRTNET_XDP_RES_PASS;
> > > > > +
> > > > > +       case XDP_TX:
> > > > > +               stats->xdp_tx++;
> > > > > +               xdpf =3D xdp_convert_buff_to_frame(xdp);
> > > > > +               if (unlikely(!xdpf))
> > > > > +                       return VIRTNET_XDP_RES_DROP;
> > > > > +
> > > > > +               err =3D virtnet_xdp_xmit(dev, 1, &xdpf, 0);
> > > > > +               if (unlikely(!err)) {
> > > > > +                       xdp_return_frame_rx_napi(xdpf);
> > > > > +               } else if (unlikely(err < 0)) {
> > > > > +                       trace_xdp_exception(dev, xdp_prog, act);
> > > > > +                       return VIRTNET_XDP_RES_DROP;
> > > > > +               }
> > > > > +
> > > > > +               *xdp_xmit |=3D VIRTIO_XDP_TX;
> > > > > +               return VIRTNET_XDP_RES_CONSUMED;
> > > > > +
> > > > > +       case XDP_REDIRECT:
> > > > > +               stats->xdp_redirects++;
> > > > > +               err =3D xdp_do_redirect(dev, xdp, xdp_prog);
> > > > > +               if (err)
> > > > > +                       return VIRTNET_XDP_RES_DROP;
> > > > > +
> > > > > +               *xdp_xmit |=3D VIRTIO_XDP_REDIR;
> > > > > +               return VIRTNET_XDP_RES_CONSUMED;
> > > > > +
> > > > > +       default:
> > > > > +               bpf_warn_invalid_xdp_action(dev, xdp_prog, act);
> > > > > +               fallthrough;
> > > > > +       case XDP_ABORTED:
> > > > > +               trace_xdp_exception(dev, xdp_prog, act);
> > > > > +               fallthrough;
> > > > > +       case XDP_DROP:
> > > > > +               return VIRTNET_XDP_RES_DROP;
> > > > > +       }
> > > > > +}
> > > > > +
> > > > >  static unsigned int virtnet_get_headroom(struct virtnet_info *vi=
)
> > > > >  {
> > > > >         return vi->xdp_enabled ? VIRTIO_XDP_HEADROOM : 0;
> > > > > @@ -876,7 +938,6 @@ static struct sk_buff *receive_small(struct n=
et_device *dev,
> > > > >         struct page *page =3D virt_to_head_page(buf);
> > > > >         unsigned int delta =3D 0;
> > > > >         struct page *xdp_page;
> > > > > -       int err;
> > > > >         unsigned int metasize =3D 0;
> > > > >
> > > > >         len -=3D vi->hdr_len;
> > > > > @@ -898,7 +959,6 @@ static struct sk_buff *receive_small(struct n=
et_device *dev,
> > > > >         xdp_prog =3D rcu_dereference(rq->xdp_prog);
> > > > >         if (xdp_prog) {
> > > > >                 struct virtio_net_hdr_mrg_rxbuf *hdr =3D buf + he=
ader_offset;
> > > > > -               struct xdp_frame *xdpf;
> > > > >                 struct xdp_buff xdp;
> > > > >                 void *orig_data;
> > > > >                 u32 act;
> > > > > @@ -931,46 +991,22 @@ static struct sk_buff *receive_small(struct=
 net_device *dev,
> > > > >                 xdp_prepare_buff(&xdp, buf + VIRTNET_RX_PAD + vi-=
>hdr_len,
> > > > >                                  xdp_headroom, len, true);
> > > > >                 orig_data =3D xdp.data;
> > > > > -               act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
> > > > > -               stats->xdp_packets++;
> > > > > +
> > > > > +               act =3D virtnet_xdp_handler(xdp_prog, &xdp, dev, =
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
> > > > > -                       stats->xdp_tx++;
> > > > > -                       xdpf =3D xdp_convert_buff_to_frame(&xdp);
> > > > > -                       if (unlikely(!xdpf))
> > > > > -                               goto err_xdp;
> > > > > -                       err =3D virtnet_xdp_xmit(dev, 1, &xdpf, 0=
);
> > > > > -                       if (unlikely(!err)) {
> > > > > -                               xdp_return_frame_rx_napi(xdpf);
> > > > > -                       } else if (unlikely(err < 0)) {
> > > > > -                               trace_xdp_exception(vi->dev, xdp_=
prog, act);
> > > > > -                               goto err_xdp;
> > > > > -                       }
> > > > > -                       *xdp_xmit |=3D VIRTIO_XDP_TX;
> > > > > -                       rcu_read_unlock();
> > > > > -                       goto xdp_xmit;
> > > > > -               case XDP_REDIRECT:
> > > > > -                       stats->xdp_redirects++;
> > > > > -                       err =3D xdp_do_redirect(dev, &xdp, xdp_pr=
og);
> > > > > -                       if (err)
> > > > > -                               goto err_xdp;
> > > > > -                       *xdp_xmit |=3D VIRTIO_XDP_REDIR;
> > > > > +
> > > > > +               case VIRTNET_XDP_RES_CONSUMED:
> > > > >                         rcu_read_unlock();
> > > > >                         goto xdp_xmit;
> > > > > -               default:
> > > > > -                       bpf_warn_invalid_xdp_action(vi->dev, xdp_=
prog, act);
> > > > > -                       fallthrough;
> > > > > -               case XDP_ABORTED:
> > > > > -                       trace_xdp_exception(vi->dev, xdp_prog, ac=
t);
> > > > > -                       goto err_xdp;
> > > > > -               case XDP_DROP:
> > > > > +
> > > > > +               case VIRTNET_XDP_RES_DROP:
> > > > >                         goto err_xdp;
> > > > >                 }
> > > > >         }
> > > > > @@ -1277,7 +1313,6 @@ static struct sk_buff *receive_mergeable(st=
ruct net_device *dev,
> > > > >         if (xdp_prog) {
> > > > >                 unsigned int xdp_frags_truesz =3D 0;
> > > > >                 struct skb_shared_info *shinfo;
> > > > > -               struct xdp_frame *xdpf;
> > > > >                 struct page *xdp_page;
> > > > >                 struct xdp_buff xdp;
> > > > >                 void *data;
> > > > > @@ -1294,49 +1329,22 @@ static struct sk_buff *receive_mergeable(=
struct net_device *dev,
> > > > >                 if (unlikely(err))
> > > > >                         goto err_xdp_frags;
> > > > >
> > > > > -               act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
> > > > > -               stats->xdp_packets++;
> > > > > +               act =3D virtnet_xdp_handler(xdp_prog, &xdp, dev, =
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
> > > > > -                       stats->xdp_tx++;
> > > > > -                       xdpf =3D xdp_convert_buff_to_frame(&xdp);
> > > > > -                       if (unlikely(!xdpf)) {
> > > > > -                               netdev_dbg(dev, "convert buff to =
frame failed for xdp\n");
> > > >
> > > > Nit: This debug is lost after the conversion.
> > >
> > > Will fix.
> > >
> > > Thanks.
> > >
> > > >
> > > > Thanks
> > > >
> > > > > -                               goto err_xdp_frags;
> > > > > -                       }
> > > > > -                       err =3D virtnet_xdp_xmit(dev, 1, &xdpf, 0=
);
> > > > > -                       if (unlikely(!err)) {
> > > > > -                               xdp_return_frame_rx_napi(xdpf);
> > > > > -                       } else if (unlikely(err < 0)) {
> > > > > -                               trace_xdp_exception(vi->dev, xdp_=
prog, act);
> > > > > -                               goto err_xdp_frags;
> > > > > -                       }
> > > > > -                       *xdp_xmit |=3D VIRTIO_XDP_TX;
> > > > > -                       rcu_read_unlock();
> > > > > -                       goto xdp_xmit;
> > > > > -               case XDP_REDIRECT:
> > > > > -                       stats->xdp_redirects++;
> > > > > -                       err =3D xdp_do_redirect(dev, &xdp, xdp_pr=
og);
> > > > > -                       if (err)
> > > > > -                               goto err_xdp_frags;
> > > > > -                       *xdp_xmit |=3D VIRTIO_XDP_REDIR;
> > > > > +
> > > > > +               case VIRTNET_XDP_RES_CONSUMED:
> > > > >                         rcu_read_unlock();
> > > > >                         goto xdp_xmit;
> > > > > -               default:
> > > > > -                       bpf_warn_invalid_xdp_action(vi->dev, xdp_=
prog, act);
> > > > > -                       fallthrough;
> > > > > -               case XDP_ABORTED:
> > > > > -                       trace_xdp_exception(vi->dev, xdp_prog, ac=
t);
> > > > > -                       fallthrough;
> > > > > -               case XDP_DROP:
> > > > > +
> > > > > +               case VIRTNET_XDP_RES_DROP:
> > > > >                         goto err_xdp_frags;
> > > > >                 }
> > > > >  err_xdp_frags:
> > > > > --
> > > > > 2.32.0.3.g01195cf9f
> > > > >
> > > >
> > >
> >
>

