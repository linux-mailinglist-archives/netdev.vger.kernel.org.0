Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE4F6E1C1E
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 07:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbjDNF7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 01:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbjDNF7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 01:59:46 -0400
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3712D1BC5;
        Thu, 13 Apr 2023 22:59:45 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0Vg2KYHN_1681451981;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0Vg2KYHN_1681451981)
          by smtp.aliyun-inc.com;
          Fri, 14 Apr 2023 13:59:41 +0800
Message-ID: <1681451962.2157283-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net] virtio_net: bugfix overflow inside xdp_linearize_page()
Date:   Fri, 14 Apr 2023 13:59:22 +0800
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
References: <20230413121937.46135-1-xuanzhuo@linux.alibaba.com>
 <CACGkMEsE8TosCxyf4GwmsBzo1Ot9FiLtsWt16oz0f0J99DGYCg@mail.gmail.com>
In-Reply-To: <CACGkMEsE8TosCxyf4GwmsBzo1Ot9FiLtsWt16oz0f0J99DGYCg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Apr 2023 13:40:32 +0800, Jason Wang <jasowang@redhat.com> wrote:
> On Thu, Apr 13, 2023 at 8:19=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba=
.com> wrote:
> >
> > Here we copy the data from the original buf to the new page. But we
> > not check that it may be overflow.
> >
> > As long as the size received(including vnethdr) is greater than 3840
> > (PAGE_SIZE -VIRTIO_XDP_HEADROOM). Then the memcpy will overflow.
> >
> > And this is completely possible, as long as the MTU is large, such
> > as 4096. In our test environment, this will cause crash. Since crash is
> > caused by the written memory, it is meaningless, so I do not include it.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>
> Missing fixes tag?
>
> Other than this,
>
> Acked-by: Jason Wang <jasowang@redhat.com>

Sorry, miss this.

Thanks.



>
> Thanks
>
> > ---
> >  drivers/net/virtio_net.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 2396c28c0122..ea1bd4bb326d 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -814,8 +814,13 @@ static struct page *xdp_linearize_page(struct rece=
ive_queue *rq,
> >                                        int page_off,
> >                                        unsigned int *len)
> >  {
> > -       struct page *page =3D alloc_page(GFP_ATOMIC);
> > +       int tailroom =3D SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> > +       struct page *page;
> > +
> > +       if (page_off + *len + tailroom > PAGE_SIZE)
> > +               return NULL;
> >
> > +       page =3D alloc_page(GFP_ATOMIC);
> >         if (!page)
> >                 return NULL;
> >
> > @@ -823,7 +828,6 @@ static struct page *xdp_linearize_page(struct recei=
ve_queue *rq,
> >         page_off +=3D *len;
> >
> >         while (--*num_buf) {
> > -               int tailroom =3D SKB_DATA_ALIGN(sizeof(struct skb_share=
d_info));
> >                 unsigned int buflen;
> >                 void *buf;
> >                 int off;
> > --
> > 2.32.0.3.g01195cf9f
> >
>
