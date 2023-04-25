Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7196EDD04
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 09:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbjDYHqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 03:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232274AbjDYHqc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 03:46:32 -0400
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6129F;
        Tue, 25 Apr 2023 00:46:30 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VgzJO0s_1682408786;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VgzJO0s_1682408786)
          by smtp.aliyun-inc.com;
          Tue, 25 Apr 2023 15:46:27 +0800
Message-ID: <1682408766.7832832-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net-next v3 07/15] virtio_net: auto release xdp shinfo
Date:   Tue, 25 Apr 2023 15:46:06 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Jason Wang <jasowang@redhat.com>
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
References: <20230423105736.56918-1-xuanzhuo@linux.alibaba.com>
 <20230423105736.56918-8-xuanzhuo@linux.alibaba.com>
 <CACGkMEsNLa9ETksZBi-fkni3c0FzpdNFr-y87Gt48-QKuLDPtg@mail.gmail.com>
In-Reply-To: <CACGkMEsNLa9ETksZBi-fkni3c0FzpdNFr-y87Gt48-QKuLDPtg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Apr 2023 15:41:28 +0800, Jason Wang <jasowang@redhat.com> wrote:
> On Sun, Apr 23, 2023 at 6:57=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba=
.com> wrote:
> >
> > virtnet_build_xdp_buff_mrg() and virtnet_xdp_handler() auto
> > release xdp shinfo then the caller no need to careful the xdp shinfo.
>
> Thinking of this, I think releasing frags in
> virtnet_build_xdp_buff_mrg() is fine. But for virtnet_xdp_handler(),
> it's better to be done by the caller, since the frags were prepared by
> the caller anyhow.


I agree this.

Thanks.


>
> Thanks
>
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >  drivers/net/virtio_net.c | 29 +++++++++++++++++------------
> >  1 file changed, 17 insertions(+), 12 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 5f37a1cef61e..c6bf425e8844 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -825,7 +825,7 @@ static int virtnet_xdp_handler(struct bpf_prog *xdp=
_prog, struct xdp_buff *xdp,
> >                 xdpf =3D xdp_convert_buff_to_frame(xdp);
> >                 if (unlikely(!xdpf)) {
> >                         netdev_dbg(dev, "convert buff to frame failed f=
or xdp\n");
> > -                       return XDP_DROP;
> > +                       goto drop;
> >                 }
> >
> >                 err =3D virtnet_xdp_xmit(dev, 1, &xdpf, 0);
> > @@ -833,7 +833,7 @@ static int virtnet_xdp_handler(struct bpf_prog *xdp=
_prog, struct xdp_buff *xdp,
> >                         xdp_return_frame_rx_napi(xdpf);
> >                 } else if (unlikely(err < 0)) {
> >                         trace_xdp_exception(dev, xdp_prog, act);
> > -                       return XDP_DROP;
> > +                       goto drop;
> >                 }
> >                 *xdp_xmit |=3D VIRTIO_XDP_TX;
> >                 return act;
> > @@ -842,7 +842,7 @@ static int virtnet_xdp_handler(struct bpf_prog *xdp=
_prog, struct xdp_buff *xdp,
> >                 stats->xdp_redirects++;
> >                 err =3D xdp_do_redirect(dev, xdp, xdp_prog);
> >                 if (err)
> > -                       return XDP_DROP;
> > +                       goto drop;
> >
> >                 *xdp_xmit |=3D VIRTIO_XDP_REDIR;
> >                 return act;
> > @@ -854,8 +854,12 @@ static int virtnet_xdp_handler(struct bpf_prog *xd=
p_prog, struct xdp_buff *xdp,
> >                 trace_xdp_exception(dev, xdp_prog, act);
> >                 fallthrough;
> >         case XDP_DROP:
> > -               return XDP_DROP;
> > +               break;
> >         }
> > +
> > +drop:
> > +       put_xdp_frags(xdp);
> > +       return XDP_DROP;
> >  }
> >
> >  static unsigned int virtnet_get_headroom(struct virtnet_info *vi)
> > @@ -1190,7 +1194,7 @@ static int virtnet_build_xdp_buff_mrg(struct net_=
device *dev,
> >                                  dev->name, *num_buf,
> >                                  virtio16_to_cpu(vi->vdev, hdr->num_buf=
fers));
> >                         dev->stats.rx_length_errors++;
> > -                       return -EINVAL;
> > +                       goto err;
> >                 }
> >
> >                 stats->bytes +=3D len;
> > @@ -1209,7 +1213,7 @@ static int virtnet_build_xdp_buff_mrg(struct net_=
device *dev,
> >                         pr_debug("%s: rx error: len %u exceeds truesize=
 %lu\n",
> >                                  dev->name, len, (unsigned long)(truesi=
ze - room));
> >                         dev->stats.rx_length_errors++;
> > -                       return -EINVAL;
> > +                       goto err;
> >                 }
> >
> >                 frag =3D &shinfo->frags[shinfo->nr_frags++];
> > @@ -1224,6 +1228,10 @@ static int virtnet_build_xdp_buff_mrg(struct net=
_device *dev,
> >
> >         *xdp_frags_truesize =3D xdp_frags_truesz;
> >         return 0;
> > +
> > +err:
> > +       put_xdp_frags(xdp);
> > +       return -EINVAL;
> >  }
> >
> >  static void *mergeable_xdp_get_buf(struct virtnet_info *vi,
> > @@ -1353,7 +1361,7 @@ static struct sk_buff *receive_mergeable(struct n=
et_device *dev,
> >                 err =3D virtnet_build_xdp_buff_mrg(dev, vi, rq, &xdp, d=
ata, len, frame_sz,
> >                                                  &num_buf, &xdp_frags_t=
ruesz, stats);
> >                 if (unlikely(err))
> > -                       goto err_xdp_frags;
> > +                       goto err_xdp;
> >
> >                 act =3D virtnet_xdp_handler(xdp_prog, &xdp, dev, xdp_xm=
it, stats);
> >
> > @@ -1361,7 +1369,7 @@ static struct sk_buff *receive_mergeable(struct n=
et_device *dev,
> >                 case XDP_PASS:
> >                         head_skb =3D build_skb_from_xdp_buff(dev, vi, &=
xdp, xdp_frags_truesz);
> >                         if (unlikely(!head_skb))
> > -                               goto err_xdp_frags;
> > +                               goto err_xdp;
> >
> >                         rcu_read_unlock();
> >                         return head_skb;
> > @@ -1370,11 +1378,8 @@ static struct sk_buff *receive_mergeable(struct =
net_device *dev,
> >                         rcu_read_unlock();
> >                         goto xdp_xmit;
> >                 default:
> > -                       break;
> > +                       goto err_xdp;
> >                 }
> > -err_xdp_frags:
> > -               put_xdp_frags(&xdp);
> > -               goto err_xdp;
> >         }
> >         rcu_read_unlock();
> >
> > --
> > 2.32.0.3.g01195cf9f
> >
>
