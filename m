Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39B606E8DAC
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 11:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233907AbjDTJLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 05:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234081AbjDTJL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 05:11:29 -0400
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B353C0F;
        Thu, 20 Apr 2023 02:10:46 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VgYMQcc_1681981746;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VgYMQcc_1681981746)
          by smtp.aliyun-inc.com;
          Thu, 20 Apr 2023 17:09:07 +0800
Message-ID: <1681980971.1167793-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net-next v2 13/14] virtio_net: small: optimize code
Date:   Thu, 20 Apr 2023 16:56:11 +0800
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
 <20230418065327.72281-14-xuanzhuo@linux.alibaba.com>
 <CACGkMEtubJ8ND01J+Arpa4TB5kfdap7t6f9D5qc7-XkeFZYRKQ@mail.gmail.com>
In-Reply-To: <CACGkMEtubJ8ND01J+Arpa4TB5kfdap7t6f9D5qc7-XkeFZYRKQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Apr 2023 14:32:37 +0800, Jason Wang <jasowang@redhat.com> wrote:
> On Tue, Apr 18, 2023 at 2:53=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba=
.com> wrote:
> >
> > Avoid the problem that some variables(headroom and so on) will repeat
> > the calculation when process xdp.
>
> While at it, if we agree to use separate code paths for building skbs.
>
> It would be better to have a helper for building skb for non XDP
> cases, then we can hide those calculation there.


Yes, we can introduce one helper, then receive_small will be more simple.
But these calculation can not shared with xdp case, because xdp case needs =
to
get these vars before running xdp.

Then the code "copy vnet hdr" and "set metadata" should stay in their own
function.

Only the virtnet_build_skb()[build_skb, skb_reserve, skb_put] can be shared.

static struct sk_buff *virtnet_build_skb(void *buf, unsigned int buflen,
					 unsigned int headroom,
					 unsigned int len)
{
	struct sk_buff *skb;

	skb =3D build_skb(buf, buflen);
	if (!skb)
		return NULL;

	skb_reserve(skb, headroom);
	skb_put(skb, len);

	return skb;
}

static struct sk_buff *receive_small_build_skb(struct virtnet_info *vi,
					       unsigned int xdp_headroom,
					       void *buf,
					       unsigned int len)
{
	unsigned int header_offset;
	unsigned int headroom;
	unsigned int buflen;
	struct sk_buff *skb;

	header_offset =3D VIRTNET_RX_PAD + xdp_headroom;
	headroom =3D vi->hdr_len + header_offset;
	buflen =3D SKB_DATA_ALIGN(GOOD_PACKET_LEN + headroom) +
		SKB_DATA_ALIGN(sizeof(struct skb_shared_info));

	skb =3D virtnet_build_skb(buf, buflen, headroom, len);
	if (unlikely(!skb))
		return NULL;

	buf +=3D header_offset;
	memcpy(skb_vnet_hdr(skb), buf, vi->hdr_len);

	return skb;
}

Thanks

>
> Thanks
>
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >  drivers/net/virtio_net.c | 12 ++++++++----
> >  1 file changed, 8 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index f6f5903face2..5a5636178bd3 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -1040,11 +1040,10 @@ static struct sk_buff *receive_small(struct net=
_device *dev,
> >         struct sk_buff *skb;
> >         struct bpf_prog *xdp_prog;
> >         unsigned int xdp_headroom =3D (unsigned long)ctx;
> > -       unsigned int header_offset =3D VIRTNET_RX_PAD + xdp_headroom;
> > -       unsigned int headroom =3D vi->hdr_len + header_offset;
> > -       unsigned int buflen =3D SKB_DATA_ALIGN(GOOD_PACKET_LEN + headro=
om) +
> > -                             SKB_DATA_ALIGN(sizeof(struct skb_shared_i=
nfo));
> >         struct page *page =3D virt_to_head_page(buf);
> > +       unsigned int header_offset;
> > +       unsigned int headroom;
> > +       unsigned int buflen;
> >
> >         len -=3D vi->hdr_len;
> >         stats->bytes +=3D len;
> > @@ -1072,6 +1071,11 @@ static struct sk_buff *receive_small(struct net_=
device *dev,
> >         rcu_read_unlock();
> >
> >  skip_xdp:
> > +       header_offset =3D VIRTNET_RX_PAD + xdp_headroom;
> > +       headroom =3D vi->hdr_len + header_offset;
> > +       buflen =3D SKB_DATA_ALIGN(GOOD_PACKET_LEN + headroom) +
> > +               SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> > +
> >         skb =3D build_skb(buf, buflen);
> >         if (!skb)
> >                 goto err;
> > --
> > 2.32.0.3.g01195cf9f
> >
>
