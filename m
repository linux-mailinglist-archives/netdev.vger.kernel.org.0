Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2701C6D3C60
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 06:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbjDCESb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 00:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbjDCESa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 00:18:30 -0400
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C951FC8;
        Sun,  2 Apr 2023 21:18:28 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R651e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VfBvNta_1680495504;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VfBvNta_1680495504)
          by smtp.aliyun-inc.com;
          Mon, 03 Apr 2023 12:18:24 +0800
Message-ID: <1680495473.7526932-4-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net-next 6/8] virtio_net: auto release xdp shinfo
Date:   Mon, 3 Apr 2023 12:17:53 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
References: <20230328120412.110114-1-xuanzhuo@linux.alibaba.com>
 <20230328120412.110114-7-xuanzhuo@linux.alibaba.com>
 <5f48c497-1831-40cf-a4b5-5d283204d7a6@redhat.com>
In-Reply-To: <5f48c497-1831-40cf-a4b5-5d283204d7a6@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Apr 2023 11:18:02 +0800, Jason Wang <jasowang@redhat.com> wrote:
>
> =E5=9C=A8 2023/3/28 20:04, Xuan Zhuo =E5=86=99=E9=81=93:
> > virtnet_build_xdp_buff_mrg() and virtnet_xdp_handler() auto
>
>
> I think you meant virtnet_xdp_handler() actually?
>
>
> > release xdp shinfo then the caller no need to careful the xdp shinfo.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >   drivers/net/virtio_net.c | 29 +++++++++++++++++------------
> >   1 file changed, 17 insertions(+), 12 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index a3f2bcb3db27..136131a7868a 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -833,14 +833,14 @@ static int virtnet_xdp_handler(struct bpf_prog *x=
dp_prog, struct xdp_buff *xdp,
> >   		stats->xdp_tx++;
> >   		xdpf =3D xdp_convert_buff_to_frame(xdp);
> >   		if (unlikely(!xdpf))
> > -			return VIRTNET_XDP_RES_DROP;
> > +			goto drop;
> >
> >   		err =3D virtnet_xdp_xmit(dev, 1, &xdpf, 0);
> >   		if (unlikely(!err)) {
> >   			xdp_return_frame_rx_napi(xdpf);
> >   		} else if (unlikely(err < 0)) {
> >   			trace_xdp_exception(dev, xdp_prog, act);
> > -			return VIRTNET_XDP_RES_DROP;
> > +			goto drop;
> >   		}
> >
> >   		*xdp_xmit |=3D VIRTIO_XDP_TX;
> > @@ -850,7 +850,7 @@ static int virtnet_xdp_handler(struct bpf_prog *xdp=
_prog, struct xdp_buff *xdp,
> >   		stats->xdp_redirects++;
> >   		err =3D xdp_do_redirect(dev, xdp, xdp_prog);
> >   		if (err)
> > -			return VIRTNET_XDP_RES_DROP;
> > +			goto drop;
> >
> >   		*xdp_xmit |=3D VIRTIO_XDP_REDIR;
> >   		return VIRTNET_XDP_RES_CONSUMED;
> > @@ -862,8 +862,12 @@ static int virtnet_xdp_handler(struct bpf_prog *xd=
p_prog, struct xdp_buff *xdp,
> >   		trace_xdp_exception(dev, xdp_prog, act);
> >   		fallthrough;
> >   	case XDP_DROP:
> > -		return VIRTNET_XDP_RES_DROP;
> > +		goto drop;
>
>
> This goto is kind of meaningless.

Will fix.

Thanks.


>
> Thanks
>
>
> >   	}
> > +
> > +drop:
> > +	put_xdp_frags(xdp);
> > +	return VIRTNET_XDP_RES_DROP;
> >   }
> >
> >   static unsigned int virtnet_get_headroom(struct virtnet_info *vi)
> > @@ -1199,7 +1203,7 @@ static int virtnet_build_xdp_buff_mrg(struct net_=
device *dev,
> >   				 dev->name, *num_buf,
> >   				 virtio16_to_cpu(vi->vdev, hdr->num_buffers));
> >   			dev->stats.rx_length_errors++;
> > -			return -EINVAL;
> > +			goto err;
> >   		}
> >
> >   		stats->bytes +=3D len;
> > @@ -1218,7 +1222,7 @@ static int virtnet_build_xdp_buff_mrg(struct net_=
device *dev,
> >   			pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
> >   				 dev->name, len, (unsigned long)(truesize - room));
> >   			dev->stats.rx_length_errors++;
> > -			return -EINVAL;
> > +			goto err;
> >   		}
> >
> >   		frag =3D &shinfo->frags[shinfo->nr_frags++];
> > @@ -1233,6 +1237,10 @@ static int virtnet_build_xdp_buff_mrg(struct net=
_device *dev,
> >
> >   	*xdp_frags_truesize =3D xdp_frags_truesz;
> >   	return 0;
> > +
> > +err:
> > +	put_xdp_frags(xdp);
> > +	return -EINVAL;
> >   }
> >
> >   static void *mergeable_xdp_prepare(struct virtnet_info *vi,
> > @@ -1361,7 +1369,7 @@ static struct sk_buff *receive_mergeable(struct n=
et_device *dev,
> >   		err =3D virtnet_build_xdp_buff_mrg(dev, vi, rq, &xdp, data, len, fr=
ame_sz,
> >   						 &num_buf, &xdp_frags_truesz, stats);
> >   		if (unlikely(err))
> > -			goto err_xdp_frags;
> > +			goto err_xdp;
> >
> >   		act =3D virtnet_xdp_handler(xdp_prog, &xdp, dev, xdp_xmit, stats);
> >
> > @@ -1369,7 +1377,7 @@ static struct sk_buff *receive_mergeable(struct n=
et_device *dev,
> >   		case VIRTNET_XDP_RES_PASS:
> >   			head_skb =3D build_skb_from_xdp_buff(dev, vi, &xdp, xdp_frags_true=
sz);
> >   			if (unlikely(!head_skb))
> > -				goto err_xdp_frags;
> > +				goto err_xdp;
> >
> >   			rcu_read_unlock();
> >   			return head_skb;
> > @@ -1379,11 +1387,8 @@ static struct sk_buff *receive_mergeable(struct =
net_device *dev,
> >   			goto xdp_xmit;
> >
> >   		case VIRTNET_XDP_RES_DROP:
> > -			goto err_xdp_frags;
> > +			goto err_xdp;
> >   		}
> > -err_xdp_frags:
> > -		put_xdp_frags(&xdp);
> > -		goto err_xdp;
> >   	}
> >   	rcu_read_unlock();
> >
>
