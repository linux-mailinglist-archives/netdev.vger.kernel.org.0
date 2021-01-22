Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 354943002F6
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 13:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728007AbhAVMaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 07:30:05 -0500
Received: from mail2.protonmail.ch ([185.70.40.22]:13422 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727999AbhAVMJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 07:09:02 -0500
Date:   Fri, 22 Jan 2021 12:08:00 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1611317289; bh=LxHX459fz95IKnWnMss4jlo7OKseIL+7KUGL4C4wHkc=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=nsASNQ58V/Gi13soh8Ii4nJ3nLxojereRGSAJ2+kykJoKuMHzeN+86pvewPJhEQxc
         giNlkzt14L5E+V/cRD15C1VhxBiJRaJk4lEEfCJSlQzWFyxIEvcPlvp8nYzztUrON7
         lwMCxf19u+SN1mk+SY31Umn4s+I/UADRGEUmRr27OnXHFDP+kOQkwLR3zpFhLVMmAI
         VKsHTnTq87uhrdLnEoBWWXnvS9RFW0OMJkxecNG0XszRAYOU0KU0ebRw9okA43itpa
         l+LSt2ojA9rIfWlecPCIjUyw89N6oj4fH2I2o66fmw16a1ANKcP0y2tOVQ97v+udSD
         ZxCvkkbuHvbNA==
To:     Eric Dumazet <eric.dumazet@gmail.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, bjorn@kernel.org,
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
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH bpf-next v3 3/3] xsk: build skb by page
Message-ID: <20210122120743.2642-1-alobakin@pm.me>
In-Reply-To: <20210122115519.2183-1-alobakin@pm.me>
References: <cover.1611236588.git.xuanzhuo@linux.alibaba.com> <340f1dfa40416dd966a56e08507daba82d633088.1611236588.git.xuanzhuo@linux.alibaba.com> <dcee4592-9fa9-adbb-55ca-58a962076e7a@gmail.com> <20210122114729.1758-1-alobakin@pm.me> <20210122115519.2183-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alobakin@pm.me>
Date: Fri, 22 Jan 2021 11:55:35 +0000

> From: Alexander Lobakin <alobakin@pm.me>
> Date: Fri, 22 Jan 2021 11:47:45 +0000
>=20
> > From: Eric Dumazet <eric.dumazet@gmail.com>
> > Date: Thu, 21 Jan 2021 16:41:33 +0100
> >=20
> > > On 1/21/21 2:47 PM, Xuan Zhuo wrote:
> > > > This patch is used to construct skb based on page to save memory co=
py
> > > > overhead.
> > > >=20
> > > > This function is implemented based on IFF_TX_SKB_NO_LINEAR. Only th=
e
> > > > network card priv_flags supports IFF_TX_SKB_NO_LINEAR will use page=
 to
> > > > directly construct skb. If this feature is not supported, it is sti=
ll
> > > > necessary to copy data to construct skb.
> > > >=20
> > > > ---------------- Performance Testing ------------
> > > >=20
> > > > The test environment is Aliyun ECS server.
> > > > Test cmd:
> > > > ```
> > > > xdpsock -i eth0 -t  -S -s <msg size>
> > > > ```
> > > >=20
> > > > Test result data:
> > > >=20
> > > > size    64      512     1024    1500
> > > > copy    1916747 1775988 1600203 1440054
> > > > page    1974058 1953655 1945463 1904478
> > > > percent 3.0%    10.0%   21.58%  32.3%
> > > >=20
> > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
> > > > ---
> > > >  net/xdp/xsk.c | 104 ++++++++++++++++++++++++++++++++++++++++++++++=
++----------
> > > >  1 file changed, 86 insertions(+), 18 deletions(-)
> > > >=20
> > > > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > > > index 4a83117..38af7f1 100644
> > > > --- a/net/xdp/xsk.c
> > > > +++ b/net/xdp/xsk.c
> > > > @@ -430,6 +430,87 @@ static void xsk_destruct_skb(struct sk_buff *s=
kb)
> > > >  =09sock_wfree(skb);
> > > >  }
> > > > =20
> > > > +static struct sk_buff *xsk_build_skb_zerocopy(struct xdp_sock *xs,
> > > > +=09=09=09=09=09      struct xdp_desc *desc)
> > > > +{
> > > > +=09u32 len, offset, copy, copied;
> > > > +=09struct sk_buff *skb;
> > > > +=09struct page *page;
> > > > +=09void *buffer;
> > > > +=09int err, i;
> > > > +=09u64 addr;
> > > > +
> > > > +=09skb =3D sock_alloc_send_skb(&xs->sk, 0, 1, &err);

Also,
maybe we should allocate it with NET_SKB_PAD so NIC drivers could
use some reserved space?

=09=09skb =3D sock_alloc_send_skb(&xs->sk, NET_SKB_PAD, 1, &err);
=09=09...
=09=09skb_reserve(skb, NET_SKB_PAD);

Eric, what do you think?

> > > > +=09if (unlikely(!skb))
> > > > +=09=09return ERR_PTR(err);
> > > > +
> > > > +=09addr =3D desc->addr;
> > > > +=09len =3D desc->len;
> > > > +
> > > > +=09buffer =3D xsk_buff_raw_get_data(xs->pool, addr);
> > > > +=09offset =3D offset_in_page(buffer);
> > > > +=09addr =3D buffer - xs->pool->addrs;
> > > > +
> > > > +=09for (copied =3D 0, i =3D 0; copied < len; i++) {
> > > > +=09=09page =3D xs->pool->umem->pgs[addr >> PAGE_SHIFT];
> > > > +
> > > > +=09=09get_page(page);
> > > > +
> > > > +=09=09copy =3D min_t(u32, PAGE_SIZE - offset, len - copied);
> > > > +
> > > > +=09=09skb_fill_page_desc(skb, i, page, offset, copy);
> > > > +
> > > > +=09=09copied +=3D copy;
> > > > +=09=09addr +=3D copy;
> > > > +=09=09offset =3D 0;
> > > > +=09}
> > > > +
> > > > +=09skb->len +=3D len;
> > > > +=09skb->data_len +=3D len;
> > >=20
> > > > +=09skb->truesize +=3D len;
> > >=20
> > > This is not the truesize, unfortunately.
> > >=20
> > > We need to account for the number of pages, not number of bytes.
> >=20
> > The easiest solution is:
> >=20
> > =09skb->truesize +=3D PAGE_SIZE * i;
> >=20
> > i would be equal to skb_shinfo(skb)->nr_frags after exiting the loop.
>=20
> Oops, pls ignore this. I forgot that XSK buffers are not
> "one per page".
> We need to count the number of pages manually and then do
>=20
> =09skb->truesize +=3D PAGE_SIZE * npages;
>=20
> Right.
>=20
> > > > +
> > > > +=09refcount_add(len, &xs->sk.sk_wmem_alloc);
> > > > +
> > > > +=09return skb;
> > > > +}
> > > > +
> >=20
> > Al
>=20
> Thanks,
> Al

Al

