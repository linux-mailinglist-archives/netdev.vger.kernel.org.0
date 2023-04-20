Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3803F6E8DB2
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 11:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234021AbjDTJM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 05:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234141AbjDTJMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 05:12:18 -0400
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D564C05;
        Thu, 20 Apr 2023 02:11:49 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VgYINEN_1681981870;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VgYINEN_1681981870)
          by smtp.aliyun-inc.com;
          Thu, 20 Apr 2023 17:11:11 +0800
Message-ID: <1681981800.3300662-2-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net-next v2 08/14] virtio_net: auto release xdp shinfo
Date:   Thu, 20 Apr 2023 17:10:00 +0800
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
References: <20230418065327.72281-1-xuanzhuo@linux.alibaba.com>
 <20230418065327.72281-9-xuanzhuo@linux.alibaba.com>
 <CACGkMEuNxh-YC6A=nyt682ReSbujbgepABgwX0Y+WW30XgFktA@mail.gmail.com>
In-Reply-To: <CACGkMEuNxh-YC6A=nyt682ReSbujbgepABgwX0Y+WW30XgFktA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Apr 2023 13:59:30 +0800, Jason Wang <jasowang@redhat.com> wrote:
> On Tue, Apr 18, 2023 at 2:53=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba=
.com> wrote:
> >
> > virtnet_build_xdp_buff_mrg() and virtnet_xdp_handler() auto
> > release xdp shinfo then the caller no need to careful the xdp shinfo.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >  drivers/net/virtio_net.c | 29 +++++++++++++++++------------
> >  1 file changed, 17 insertions(+), 12 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index e2eade87d2d4..266c1670beda 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -834,7 +834,7 @@ static int virtnet_xdp_handler(struct bpf_prog *xdp=
_prog, struct xdp_buff *xdp,
> >                 xdpf =3D xdp_convert_buff_to_frame(xdp);
> >                 if (unlikely(!xdpf)) {
> >                         netdev_dbg(dev, "convert buff to frame failed f=
or xdp\n");
> > -                       return VIRTNET_XDP_RES_DROP;
> > +                       goto drop;
> >                 }
> >
> >                 err =3D virtnet_xdp_xmit(dev, 1, &xdpf, 0);
> > @@ -842,7 +842,7 @@ static int virtnet_xdp_handler(struct bpf_prog *xdp=
_prog, struct xdp_buff *xdp,
> >                         xdp_return_frame_rx_napi(xdpf);
> >                 } else if (unlikely(err < 0)) {
> >                         trace_xdp_exception(dev, xdp_prog, act);
> > -                       return VIRTNET_XDP_RES_DROP;
> > +                       goto drop;
> >                 }
> >
> >                 *xdp_xmit |=3D VIRTIO_XDP_TX;
> > @@ -852,7 +852,7 @@ static int virtnet_xdp_handler(struct bpf_prog *xdp=
_prog, struct xdp_buff *xdp,
> >                 stats->xdp_redirects++;
> >                 err =3D xdp_do_redirect(dev, xdp, xdp_prog);
> >                 if (err)
> > -                       return VIRTNET_XDP_RES_DROP;
> > +                       goto drop;
> >
> >                 *xdp_xmit |=3D VIRTIO_XDP_REDIR;
> >                 return VIRTNET_XDP_RES_CONSUMED;
> > @@ -864,8 +864,12 @@ static int virtnet_xdp_handler(struct bpf_prog *xd=
p_prog, struct xdp_buff *xdp,
> >                 trace_xdp_exception(dev, xdp_prog, act);
> >                 fallthrough;
> >         case XDP_DROP:
> > -               return VIRTNET_XDP_RES_DROP;
> > +               break;
> >         }
> > +
> > +drop:
> > +       put_xdp_frags(xdp);
> > +       return VIRTNET_XDP_RES_DROP;
> >  }
>
> Patch looks correct but we end up some inconsistency here.
>
> frags are automatically released.
>
> but the page still needs to be freed by the caller?


Yes.

Do you want to auto free page?

Thanks.



>
> Thanks
>
>
> >
> >  static unsigned int virtnet_get_headroom(struct virtnet_info *vi)
> > @@ -1201,7 +1205,7 @@ static int virtnet_build_xdp_buff_mrg(struct net_=
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
> > @@ -1220,7 +1224,7 @@ static int virtnet_build_xdp_buff_mrg(struct net_=
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
> > @@ -1235,6 +1239,10 @@ static int virtnet_build_xdp_buff_mrg(struct net=
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
> >  static void *mergeable_xdp_prepare(struct virtnet_info *vi,
> > @@ -1364,7 +1372,7 @@ static struct sk_buff *receive_mergeable(struct n=
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
> > @@ -1372,7 +1380,7 @@ static struct sk_buff *receive_mergeable(struct n=
et_device *dev,
> >                 case VIRTNET_XDP_RES_PASS:
> >                         head_skb =3D build_skb_from_xdp_buff(dev, vi, &=
xdp, xdp_frags_truesz);
> >                         if (unlikely(!head_skb))
> > -                               goto err_xdp_frags;
> > +                               goto err_xdp;
> >
> >                         rcu_read_unlock();
> >                         return head_skb;
> > @@ -1382,11 +1390,8 @@ static struct sk_buff *receive_mergeable(struct =
net_device *dev,
> >                         goto xdp_xmit;
> >
> >                 case VIRTNET_XDP_RES_DROP:
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
