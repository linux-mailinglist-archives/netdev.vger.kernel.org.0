Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 901A06EEDEB
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 08:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239481AbjDZGBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 02:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjDZGBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 02:01:02 -0400
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 450722684;
        Tue, 25 Apr 2023 23:01:01 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R391e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0Vh1odsN_1682488857;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0Vh1odsN_1682488857)
          by smtp.aliyun-inc.com;
          Wed, 26 Apr 2023 14:00:57 +0800
Message-ID: <1682488831.2667048-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net-next v3 12/15] virtio_net: small: optimize code
Date:   Wed, 26 Apr 2023 14:00:31 +0800
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
 <20230423105736.56918-13-xuanzhuo@linux.alibaba.com>
 <CACGkMEtC8WECH054KRs-uPeZiCv_PMUX4++9eUNffrB0Pboycw@mail.gmail.com>
In-Reply-To: <CACGkMEtC8WECH054KRs-uPeZiCv_PMUX4++9eUNffrB0Pboycw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Apr 2023 11:08:52 +0800, Jason Wang <jasowang@redhat.com> wrote:
> On Sun, Apr 23, 2023 at 6:58=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba=
.com> wrote:
> >
> > Avoid the problem that some variables(headroom and so on) will repeat
> > the calculation when process xdp.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>
> Nit: I think we need to tweak the title, it's better to say what is
> optimized. (And it would be better to tweak the title of patch 11 as
> well)

Yes, I agree this.

Thanks.

>
> Acked-by: Jason Wang <jasowang@redhat.com>
>
> > ---
> >  drivers/net/virtio_net.c | 12 ++++++++----
> >  1 file changed, 8 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 5bc3dca0f60c..601c0e7fc32b 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -1031,11 +1031,10 @@ static struct sk_buff *receive_small(struct net=
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
> > @@ -1063,6 +1062,11 @@ static struct sk_buff *receive_small(struct net_=
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
