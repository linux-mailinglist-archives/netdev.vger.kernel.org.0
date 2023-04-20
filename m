Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6316E89FF
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 08:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233844AbjDTGAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 02:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233777AbjDTGA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 02:00:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75ED040EF
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 22:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681970383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MOT/kX4gf+xT7Jpgl6i4GUFgvOJ6y//TH2KtWxwy3rM=;
        b=a+dnPUi6HfNrr2g0l3AejCYl6Hqh16qyTFGeUJe6yz4eBdTG7soQWAe5kpMCMbZmvmLf7t
        K7TqAmni2pjsQDwsB6rnCAkQGyTuh45p4HVDTWQpPS/Ke71vg8Y7MMTwgxS00QEYYo+svE
        AalTTD3u8NY8umFVyJg49rp8bqKtGZg=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-322-dLqS1kvbNBC0VpM-URenZw-1; Thu, 20 Apr 2023 01:59:42 -0400
X-MC-Unique: dLqS1kvbNBC0VpM-URenZw-1
Received: by mail-ot1-f69.google.com with SMTP id 31-20020a9d06a2000000b006a5d14c2dbcso36927otx.1
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 22:59:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681970381; x=1684562381;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MOT/kX4gf+xT7Jpgl6i4GUFgvOJ6y//TH2KtWxwy3rM=;
        b=YA3P3Oa3/OOlTOq79S/Zlb2dcsTTUo/AzFlnfsEt4hO8eKOWpsKajkZjsACdZJi3Yc
         MZJ6c7QmaOgudaBzvvNtyBK/Gv1L5GhTdIvQJL61tD4YxZLo7IN7aCL2o6csOiLJcb0f
         nZtEraJlCNegfeWCxO/z6c3Q3gX/fFR/HQ44T+f6BhmB3J1a8ssmgHeKd0Iy79fGXoHp
         PUnz8CidtF0SklMxk4S/+XLTdWqMJkj955YyeulD193yEXUWdyezaKs+SXwqAoMC01OK
         jmqHZWPtChpd3CtyXeI/ietqJuMQCA6/PaNw6XK1TOAs7GiGTps28w7XsDRqk+b7mBuk
         Eqtw==
X-Gm-Message-State: AAQBX9d5zd9FvhVbkCTCnrSGvWvzICw2d3I9w0iZTdX9K6YLJ/KEJ8AJ
        7yFwUcpmoDOWZ2iipNKjYuww6un1tiuVdx3FMe/CWKw/cDZlhkhjZYoSI4ty+nfV49HT7oyiwhj
        2VdD+heGmuKXgwRrb5EnHDJb72PiPXqbL
X-Received: by 2002:a4a:9568:0:b0:546:bf26:49c7 with SMTP id n37-20020a4a9568000000b00546bf2649c7mr282667ooi.8.1681970381688;
        Wed, 19 Apr 2023 22:59:41 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZAYMlIc/3+pmbc1QJgAczTJTKv7IFleZBke0nUWM4eoioQaqflifvfwcgxp+AH90EwVvJSeCdgT6Z6jiSv410=
X-Received: by 2002:a4a:9568:0:b0:546:bf26:49c7 with SMTP id
 n37-20020a4a9568000000b00546bf2649c7mr282648ooi.8.1681970381445; Wed, 19 Apr
 2023 22:59:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230418065327.72281-1-xuanzhuo@linux.alibaba.com> <20230418065327.72281-9-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20230418065327.72281-9-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 20 Apr 2023 13:59:30 +0800
Message-ID: <CACGkMEuNxh-YC6A=nyt682ReSbujbgepABgwX0Y+WW30XgFktA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 08/14] virtio_net: auto release xdp shinfo
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 2:53=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba.c=
om> wrote:
>
> virtnet_build_xdp_buff_mrg() and virtnet_xdp_handler() auto
> release xdp shinfo then the caller no need to careful the xdp shinfo.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  drivers/net/virtio_net.c | 29 +++++++++++++++++------------
>  1 file changed, 17 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index e2eade87d2d4..266c1670beda 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -834,7 +834,7 @@ static int virtnet_xdp_handler(struct bpf_prog *xdp_p=
rog, struct xdp_buff *xdp,
>                 xdpf =3D xdp_convert_buff_to_frame(xdp);
>                 if (unlikely(!xdpf)) {
>                         netdev_dbg(dev, "convert buff to frame failed for=
 xdp\n");
> -                       return VIRTNET_XDP_RES_DROP;
> +                       goto drop;
>                 }
>
>                 err =3D virtnet_xdp_xmit(dev, 1, &xdpf, 0);
> @@ -842,7 +842,7 @@ static int virtnet_xdp_handler(struct bpf_prog *xdp_p=
rog, struct xdp_buff *xdp,
>                         xdp_return_frame_rx_napi(xdpf);
>                 } else if (unlikely(err < 0)) {
>                         trace_xdp_exception(dev, xdp_prog, act);
> -                       return VIRTNET_XDP_RES_DROP;
> +                       goto drop;
>                 }
>
>                 *xdp_xmit |=3D VIRTIO_XDP_TX;
> @@ -852,7 +852,7 @@ static int virtnet_xdp_handler(struct bpf_prog *xdp_p=
rog, struct xdp_buff *xdp,
>                 stats->xdp_redirects++;
>                 err =3D xdp_do_redirect(dev, xdp, xdp_prog);
>                 if (err)
> -                       return VIRTNET_XDP_RES_DROP;
> +                       goto drop;
>
>                 *xdp_xmit |=3D VIRTIO_XDP_REDIR;
>                 return VIRTNET_XDP_RES_CONSUMED;
> @@ -864,8 +864,12 @@ static int virtnet_xdp_handler(struct bpf_prog *xdp_=
prog, struct xdp_buff *xdp,
>                 trace_xdp_exception(dev, xdp_prog, act);
>                 fallthrough;
>         case XDP_DROP:
> -               return VIRTNET_XDP_RES_DROP;
> +               break;
>         }
> +
> +drop:
> +       put_xdp_frags(xdp);
> +       return VIRTNET_XDP_RES_DROP;
>  }

Patch looks correct but we end up some inconsistency here.

frags are automatically released.

but the page still needs to be freed by the caller?

Thanks


>
>  static unsigned int virtnet_get_headroom(struct virtnet_info *vi)
> @@ -1201,7 +1205,7 @@ static int virtnet_build_xdp_buff_mrg(struct net_de=
vice *dev,
>                                  dev->name, *num_buf,
>                                  virtio16_to_cpu(vi->vdev, hdr->num_buffe=
rs));
>                         dev->stats.rx_length_errors++;
> -                       return -EINVAL;
> +                       goto err;
>                 }
>
>                 stats->bytes +=3D len;
> @@ -1220,7 +1224,7 @@ static int virtnet_build_xdp_buff_mrg(struct net_de=
vice *dev,
>                         pr_debug("%s: rx error: len %u exceeds truesize %=
lu\n",
>                                  dev->name, len, (unsigned long)(truesize=
 - room));
>                         dev->stats.rx_length_errors++;
> -                       return -EINVAL;
> +                       goto err;
>                 }
>
>                 frag =3D &shinfo->frags[shinfo->nr_frags++];
> @@ -1235,6 +1239,10 @@ static int virtnet_build_xdp_buff_mrg(struct net_d=
evice *dev,
>
>         *xdp_frags_truesize =3D xdp_frags_truesz;
>         return 0;
> +
> +err:
> +       put_xdp_frags(xdp);
> +       return -EINVAL;
>  }
>
>  static void *mergeable_xdp_prepare(struct virtnet_info *vi,
> @@ -1364,7 +1372,7 @@ static struct sk_buff *receive_mergeable(struct net=
_device *dev,
>                 err =3D virtnet_build_xdp_buff_mrg(dev, vi, rq, &xdp, dat=
a, len, frame_sz,
>                                                  &num_buf, &xdp_frags_tru=
esz, stats);
>                 if (unlikely(err))
> -                       goto err_xdp_frags;
> +                       goto err_xdp;
>
>                 act =3D virtnet_xdp_handler(xdp_prog, &xdp, dev, xdp_xmit=
, stats);
>
> @@ -1372,7 +1380,7 @@ static struct sk_buff *receive_mergeable(struct net=
_device *dev,
>                 case VIRTNET_XDP_RES_PASS:
>                         head_skb =3D build_skb_from_xdp_buff(dev, vi, &xd=
p, xdp_frags_truesz);
>                         if (unlikely(!head_skb))
> -                               goto err_xdp_frags;
> +                               goto err_xdp;
>
>                         rcu_read_unlock();
>                         return head_skb;
> @@ -1382,11 +1390,8 @@ static struct sk_buff *receive_mergeable(struct ne=
t_device *dev,
>                         goto xdp_xmit;
>
>                 case VIRTNET_XDP_RES_DROP:
> -                       break;
> +                       goto err_xdp;
>                 }
> -err_xdp_frags:
> -               put_xdp_frags(&xdp);
> -               goto err_xdp;
>         }
>         rcu_read_unlock();
>
> --
> 2.32.0.3.g01195cf9f
>

