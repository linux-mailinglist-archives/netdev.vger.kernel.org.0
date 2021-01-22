Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52DFE300AB1
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 19:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730066AbhAVR7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 12:59:40 -0500
Received: from mail-40133.protonmail.ch ([185.70.40.133]:59635 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729515AbhAVR1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 12:27:00 -0500
Date:   Fri, 22 Jan 2021 17:26:00 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1611336363; bh=OWEj+UUzudVAtPKMSxtAehJnNvnxisMiDR16nwccINk=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=Gx3eRU18LptWFF9fTZaqCjEom6e5bc/dfcPFCoiI/R91PGEOu0vaErTbMCPqDFljD
         tV1EaXU7Fu4iDqjeGRSo5l8rHNTj70oXh0LU7w7UwodKFoyrbduCOW69uirtG0EvmO
         bWIJd+McSOYu7KrV23Rb65kksDisLBm3Fttw7xqBIQqzCExTODvNwsEq4wnAhy8Zl9
         aisICLRDEXu0KvqSCW7hWLN16SHwCf8cdMcJw2odTE/nDG/Acw/pHJ9Ddgw78Uo4mR
         OBKVAoqVtnlMiIKi8O2oPYXiiR6rrYoxw0QoYJNnYok0oqc7o194L8iYu2U9nAOWS0
         36BWt2YkprKtw==
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bjorn Topel <bjorn@kernel.org>,
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
        virtualization@lists.linux-foundation.org,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH bpf-next v3 3/3] xsk: build skb by page
Message-ID: <20210122172534.9896-1-alobakin@pm.me>
In-Reply-To: <1611329955.4913929-2-xuanzhuo@linux.alibaba.com>
References: <1611329955.4913929-2-xuanzhuo@linux.alibaba.com>
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

From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Date: Fri, 22 Jan 2021 23:39:15 +0800

> On Fri, 22 Jan 2021 13:55:14 +0100, Magnus Karlsson <magnus.karlsson@gmai=
l.com> wrote:
> > On Fri, Jan 22, 2021 at 1:39 PM Alexander Lobakin <alobakin@pm.me> wrot=
e:
> > >
> > > From: Magnus Karlsson <magnus.karlsson@gmail.com>
> > > Date: Fri, 22 Jan 2021 13:18:47 +0100
> > >
> > > > On Fri, Jan 22, 2021 at 12:57 PM Alexander Lobakin <alobakin@pm.me>=
 wrote:
> > > > >
> > > > > From: Alexander Lobakin <alobakin@pm.me>
> > > > > Date: Fri, 22 Jan 2021 11:47:45 +0000
> > > > >
> > > > > > From: Eric Dumazet <eric.dumazet@gmail.com>
> > > > > > Date: Thu, 21 Jan 2021 16:41:33 +0100
> > > > > >
> > > > > > > On 1/21/21 2:47 PM, Xuan Zhuo wrote:
> > > > > > > > This patch is used to construct skb based on page to save m=
emory copy
> > > > > > > > overhead.
> > > > > > > >
> > > > > > > > This function is implemented based on IFF_TX_SKB_NO_LINEAR.=
 Only the
> > > > > > > > network card priv_flags supports IFF_TX_SKB_NO_LINEAR will =
use page to
> > > > > > > > directly construct skb. If this feature is not supported, i=
t is still
> > > > > > > > necessary to copy data to construct skb.
> > > > > > > >
> > > > > > > > ---------------- Performance Testing ------------
> > > > > > > >
> > > > > > > > The test environment is Aliyun ECS server.
> > > > > > > > Test cmd:
> > > > > > > > ```
> > > > > > > > xdpsock -i eth0 -t  -S -s <msg size>
> > > > > > > > ```
> > > > > > > >
> > > > > > > > Test result data:
> > > > > > > >
> > > > > > > > size    64      512     1024    1500
> > > > > > > > copy    1916747 1775988 1600203 1440054
> > > > > > > > page    1974058 1953655 1945463 1904478
> > > > > > > > percent 3.0%    10.0%   21.58%  32.3%
> > > > > > > >
> > > > > > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > > > > > Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
> > > > > > > > ---
> > > > > > > >  net/xdp/xsk.c | 104 ++++++++++++++++++++++++++++++++++++++=
++++++++++----------
> > > > > > > >  1 file changed, 86 insertions(+), 18 deletions(-)
> > > > > > > >
> > > > > > > > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > > > > > > > index 4a83117..38af7f1 100644
> > > > > > > > --- a/net/xdp/xsk.c
> > > > > > > > +++ b/net/xdp/xsk.c
> > > > > > > > @@ -430,6 +430,87 @@ static void xsk_destruct_skb(struct sk=
_buff *skb)
> > > > > > > >   sock_wfree(skb);
> > > > > > > >  }
> > > > > > > >
> > > > > > > > +static struct sk_buff *xsk_build_skb_zerocopy(struct xdp_s=
ock *xs,
> > > > > > > > +                                       struct xdp_desc *de=
sc)
> > > > > > > > +{
> > > > > > > > + u32 len, offset, copy, copied;
> > > > > > > > + struct sk_buff *skb;
> > > > > > > > + struct page *page;
> > > > > > > > + void *buffer;
> > > > > > > > + int err, i;
> > > > > > > > + u64 addr;
> > > > > > > > +
> > > > > > > > + skb =3D sock_alloc_send_skb(&xs->sk, 0, 1, &err);
> > > > > > > > + if (unlikely(!skb))
> > > > > > > > +         return ERR_PTR(err);
> > > > > > > > +
> > > > > > > > + addr =3D desc->addr;
> > > > > > > > + len =3D desc->len;
> > > > > > > > +
> > > > > > > > + buffer =3D xsk_buff_raw_get_data(xs->pool, addr);
> > > > > > > > + offset =3D offset_in_page(buffer);
> > > > > > > > + addr =3D buffer - xs->pool->addrs;
> > > > > > > > +
> > > > > > > > + for (copied =3D 0, i =3D 0; copied < len; i++) {
> > > > > > > > +         page =3D xs->pool->umem->pgs[addr >> PAGE_SHIFT];
> > > > > > > > +
> > > > > > > > +         get_page(page);
> > > > > > > > +
> > > > > > > > +         copy =3D min_t(u32, PAGE_SIZE - offset, len - cop=
ied);
> > > > > > > > +
> > > > > > > > +         skb_fill_page_desc(skb, i, page, offset, copy);
> > > > > > > > +
> > > > > > > > +         copied +=3D copy;
> > > > > > > > +         addr +=3D copy;
> > > > > > > > +         offset =3D 0;
> > > > > > > > + }
> > > > > > > > +
> > > > > > > > + skb->len +=3D len;
> > > > > > > > + skb->data_len +=3D len;
> > > > > > >
> > > > > > > > + skb->truesize +=3D len;
> > > > > > >
> > > > > > > This is not the truesize, unfortunately.
> > > > > > >
> > > > > > > We need to account for the number of pages, not number of byt=
es.
> > > > > >
> > > > > > The easiest solution is:
> > > > > >
> > > > > >       skb->truesize +=3D PAGE_SIZE * i;
> > > > > >
> > > > > > i would be equal to skb_shinfo(skb)->nr_frags after exiting the=
 loop.
> > > > >
> > > > > Oops, pls ignore this. I forgot that XSK buffers are not
> > > > > "one per page".
> > > > > We need to count the number of pages manually and then do
> > > > >
> > > > >         skb->truesize +=3D PAGE_SIZE * npages;
> > > > >
> > > > > Right.
> > > >
> > > > There are two possible packet buffer (chunks) sizes in a umem, 2K a=
nd
> > > > 4K on a system with a PAGE_SIZE of 4K. If I remember correctly, and
> > > > please correct me if wrong, truesize is used for memory accounting.
> > > > But in this code, no kernel memory has been allocated (apart from t=
he
> > > > skb). The page is just a part of the umem that has been already
> > > > allocated beforehand and by user-space in this case. So what should
> > > > truesize be in this case? Do we add 0, chunk_size * i, or the
> > > > complicated case of counting exactly how many 4K pages that are use=
d
> > > > when the chunk_size is 2K, as two chunks could occupy the same page=
,
> > > > or just the upper bound of PAGE_SIZE * i that is likely a good
> > > > approximation in most cases? Just note that there might be other us=
es
> > > > of truesize that I am unaware of that could impact this choice.
> > >
> > > Truesize is "what amount of memory does this skb occupy with all its
> > > fragments, linear space and struct sk_buff itself". The closest it
> > > will be to the actual value, the better.
> > > In this case, I think adding of chunk_size * i would be enough.
> >
> > Sounds like a good approximation to me.
> >
> > > (PAGE_SIZE * i can be overwhelming when chunk_size is 2K, especially
> > > for setups with PAGE_SIZE > SZ_4K)
> >
> > You are right. That would be quite horrible on a system with a page siz=
e of 64K.
>=20
> Thank you everyone, I learned it.
>=20
> I also think it is appropriate to add a chunk size here, and there is act=
ually
> only one chunk here, so it's very simple
>=20
> =09skb->truesize +=3D xs->pool->chunk_size;

umem chunks can't cross page boundaries. So if you're sure that
there could be only one chunk, you don't need the loop at all,
if I'm not missing anything.

> In addition, I actually borrowed from the tcp code:
>=20
>    tcp_build_frag:
>    --------------
>=20
> =09if (can_coalesce) {
> =09=09skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], copy);
> =09} else {
> =09=09get_page(page);
> =09=09skb_fill_page_desc(skb, i, page, offset, copy);
> =09}
>=20
> =09if (!(flags & MSG_NO_SHARED_FRAGS))
> =09=09skb_shinfo(skb)->flags |=3D SKBFL_SHARED_FRAG;
>=20
> =09skb->len +=3D copy;
> =09skb->data_len +=3D copy;
> =09skb->truesize +=3D copy;
>=20
> So, here is one bug?

skb_frag_t is an alias to struct bvec. It doesn't contain info about
real memory consumption, so there's no other option buf just to add
"copy" to truesize.
XSK is different in this term, as it operates with chunks of a known
size.

> Thanks.
>=20
> >
> > > > > > > > +
> > > > > > > > + refcount_add(len, &xs->sk.sk_wmem_alloc);
> > > > > > > > +
> > > > > > > > + return skb;
> > > > > > > > +}
> > > > > > > > +
> > > > > >
> > > > > > Al
> > > > >
> > > > > Thanks,
> > > > > Al
> > >
> > > Al

