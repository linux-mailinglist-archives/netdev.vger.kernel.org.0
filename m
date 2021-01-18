Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDE2D2FA377
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 15:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405169AbhAROpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 09:45:17 -0500
Received: from mail-40131.protonmail.ch ([185.70.40.131]:23230 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404919AbhAROlk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 09:41:40 -0500
Date:   Mon, 18 Jan 2021 14:40:41 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610980853; bh=sT4qH+o/dm1Su+f+vO2M5l0wLdLF5/1KpnEkQpaAXs4=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=BFjNJjDca831d3Ck1vHWE5jVuQfjnDTbBT/RA+vhBrKMYJ4fQYede/It+coyIxFuk
         aVognhgUoOHEXnwNtLXK3IMDFVNWlLRwRdh9NcHCHdsN+dILQkTmrZ7sWuVudA77x+
         pc6rsrz8NhD5e8DZQhwijzvXzR2WngdWH8VWkZYeZLNBIff+BzCjThXpuwXtWhyGo6
         ACpoByB7GmR+Ps9quChQ8ChqNN7AvPfuI7wNP8sylv9kqbY9PuecJooLkBMGu67Ys9
         mZKBZ9pA/bJHMrkvmShNaHCvBflmT0+aZEGQ2VYXMSGaU8vad7LW+OH7oyEeMiptRZ
         HG7J3Q9yfTU0w==
To:     Yunsheng Lin <linyunsheng@huawei.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, bjorn.topel@intel.com,
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
        Willem de Bruijn <willemb@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Meir Lichtinger <meirl@mellanox.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH bpf-next] xsk: build skb by page
Message-ID: <20210118143948.8706-1-alobakin@pm.me>
In-Reply-To: <20210118125937.4088-1-alobakin@pm.me>
References: <579fa463bba42ac71591540a1811dca41d725350.1610764948.git.xuanzhuo@linux.alibaba.com> <4a4b475b-0e79-6cf6-44f5-44d45b5d85b5@huawei.com> <20210118125937.4088-1-alobakin@pm.me>
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
Date: Mon, 18 Jan 2021 13:00:17 +0000

> From: Yunsheng Lin <linyunsheng@huawei.com>
> Date: Mon, 18 Jan 2021 20:40:52 +0800
>
>> On 2021/1/16 10:44, Xuan Zhuo wrote:
>>> This patch is used to construct skb based on page to save memory copy
>>> overhead.
>>>
>>> This has one problem:
>>>
>>> We construct the skb by fill the data page as a frag into the skb. In
>>> this way, the linear space is empty, and the header information is also
>>> in the frag, not in the linear space, which is not allowed for some
>>> network cards. For example, Mellanox Technologies MT27710 Family
>>> [ConnectX-4 Lx] will get the following error message:
>>>
>>>     mlx5_core 0000:3b:00.1 eth1: Error cqe on cqn 0x817, ci 0x8, qn 0x1=
dbb, opcode 0xd, syndrome 0x1, vendor syndrome 0x68
>>>     00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>>     00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>>     00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>>     00000030: 00 00 00 00 60 10 68 01 0a 00 1d bb 00 0f 9f d2
>>>     WQE DUMP: WQ size 1024 WQ cur size 0, WQE index 0xf, len: 64
>>>     00000000: 00 00 0f 0a 00 1d bb 03 00 00 00 08 00 00 00 00
>>>     00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>>     00000020: 00 00 00 2b 00 08 00 00 00 00 00 05 9e e3 08 00
>>>     00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>>     mlx5_core 0000:3b:00.1 eth1: ERR CQE on SQ: 0x1dbb
>>>
>>> I also tried to use build_skb to construct skb, but because of the
>>> existence of skb_shinfo, it must be behind the linear space, so this
>>> method is not working. We can't put skb_shinfo on desc->addr, it will b=
e
>>> exposed to users, this is not safe.
>>>
>>> Finally, I added a feature NETIF_F_SKB_NO_LINEAR to identify whether th=
e
>>
>> Does it make sense to use ETHTOOL_TX_COPYBREAK tunable in ethtool to
>> configure if the data is copied or not?
>
> As far as I can grep, only mlx4 supports this, and it has a different
> meaning in that driver.
> So I guess a new netdev_feature would be a better solution.
>
>>> network card supports the header information of the packet in the frag
>>> and not in the linear space.
>>>
>>> ---------------- Performance Testing ------------
>>>
>>> The test environment is Aliyun ECS server.
>>> Test cmd:
>>> ```
>>> xdpsock -i eth0 -t  -S -s <msg size>
>>> ```
>>>
>>> Test result data:
>>>
>>> size    64      512     1024    1500
>>> copy    1916747 1775988 1600203 1440054
>>> page    1974058 1953655 1945463 1904478
>>> percent 3.0%    10.0%   21.58%  32.3%
>>>
>>> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>>> Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
>>> ---
>>>  drivers/net/virtio_net.c        |   2 +-
>>>  include/linux/netdev_features.h |   5 +-
>>>  net/ethtool/common.c            |   1 +
>>>  net/xdp/xsk.c                   | 108 ++++++++++++++++++++++++++++++++=
+-------
>>>  4 files changed, 97 insertions(+), 19 deletions(-)
>>>=20
>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>> index 4ecccb8..841a331 100644
>>> --- a/drivers/net/virtio_net.c
>>> +++ b/drivers/net/virtio_net.c
>>> @@ -2985,7 +2985,7 @@ static int virtnet_probe(struct virtio_device *vd=
ev)
>>>  =09/* Set up network device as normal. */
>>>  =09dev->priv_flags |=3D IFF_UNICAST_FLT | IFF_LIVE_ADDR_CHANGE;
>>>  =09dev->netdev_ops =3D &virtnet_netdev;
>>> -=09dev->features =3D NETIF_F_HIGHDMA;
>>> +=09dev->features =3D NETIF_F_HIGHDMA | NETIF_F_SKB_NO_LINEAR;
>>> =20
>>>  =09dev->ethtool_ops =3D &virtnet_ethtool_ops;
>>>  =09SET_NETDEV_DEV(dev, &vdev->dev);
>>> diff --git a/include/linux/netdev_features.h b/include/linux/netdev_fea=
tures.h
>>> index 934de56..8dd28e2 100644
>>> --- a/include/linux/netdev_features.h
>>> +++ b/include/linux/netdev_features.h
>>> @@ -85,9 +85,11 @@ enum {
>>> =20
>>>  =09NETIF_F_HW_MACSEC_BIT,=09=09/* Offload MACsec operations */
>>> =20
>>> +=09NETIF_F_SKB_NO_LINEAR_BIT,=09/* Allow skb linear is empty */
>>> +
>>>  =09/*
>>>  =09 * Add your fresh new feature above and remember to update
>>> -=09 * netdev_features_strings[] in net/core/ethtool.c and maybe
>>> +=09 * netdev_features_strings[] in net/ethtool/common.c and maybe
>>>  =09 * some feature mask #defines below. Please also describe it
>>>  =09 * in Documentation/networking/netdev-features.rst.
>>>  =09 */
>>> @@ -157,6 +159,7 @@ enum {
>>>  #define NETIF_F_GRO_FRAGLIST=09__NETIF_F(GRO_FRAGLIST)
>>>  #define NETIF_F_GSO_FRAGLIST=09__NETIF_F(GSO_FRAGLIST)
>>>  #define NETIF_F_HW_MACSEC=09__NETIF_F(HW_MACSEC)
>>> +#define NETIF_F_SKB_NO_LINEAR=09__NETIF_F(SKB_NO_LINEAR)
>>> =20
>>>  /* Finds the next feature with the highest number of the range of star=
t till 0.
>>>   */
>>> diff --git a/net/ethtool/common.c b/net/ethtool/common.c
>>> index 24036e3..2f3d309 100644
>>> --- a/net/ethtool/common.c
>>> +++ b/net/ethtool/common.c
>>> @@ -68,6 +68,7 @@
>>>  =09[NETIF_F_HW_TLS_RX_BIT] =3D=09 "tls-hw-rx-offload",
>>>  =09[NETIF_F_GRO_FRAGLIST_BIT] =3D=09 "rx-gro-list",
>>>  =09[NETIF_F_HW_MACSEC_BIT] =3D=09 "macsec-hw-offload",
>>> +=09[NETIF_F_SKB_NO_LINEAR_BIT] =3D=09 "skb-no-linear",
>
> I completely forgot to add that you'd better to mention in both
> enumeration/feature and its Ethtool string that the feature applies
> to Tx path.
> Smth like:
>
> NETIF_F_SKB_TX_NO_LINEAR{,_BIT}, "skb-tx-no-linear"
> or
> NETIF_F_TX_SKB_NO_LINEAR{,_BIT}, "tx-skb-no-linear"
>
> Otherwise, it may be confusing for users and developers.

OR, I think we may tight the feature with the new approach to build
skbs by page as it makes no sense for anything else.
So, if we define something like:

NETIF_F_XSK_TX_GENERIC_ZC{,_BIT}, "xsk-tx-generic-zerocopy",

then user can toggle your new XSK Tx path on/off via Ethtool for
drivers that will support it (don't forget to add it to hw_features
for virtio_net then).

>>>  };
>>> =20
>>>  const char
>>> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
>>> index 8037b04..94d17dc 100644
>>> --- a/net/xdp/xsk.c
>>> +++ b/net/xdp/xsk.c
>>> @@ -430,6 +430,95 @@ static void xsk_destruct_skb(struct sk_buff *skb)
>>>  =09sock_wfree(skb);
>>>  }
>>> =20
>>> +static struct sk_buff *xsk_build_skb_zerocopy(struct xdp_sock *xs,
>>> +=09=09=09=09=09      struct xdp_desc *desc)
>>> +{
>>> +=09u32 len, offset, copy, copied;
>>> +=09struct sk_buff *skb;
>>> +=09struct page *page;
>>> +=09char *buffer;
>>> +=09int err, i;
>>> +=09u64 addr;
>>> +
>>> +=09skb =3D sock_alloc_send_skb(&xs->sk, 0, 1, &err);
>>> +=09if (unlikely(!skb))
>>> +=09=09return NULL;
>>> +
>>> +=09addr =3D desc->addr;
>>> +=09len =3D desc->len;
>>> +
>>> +=09buffer =3D xsk_buff_raw_get_data(xs->pool, addr);
>>> +=09offset =3D offset_in_page(buffer);
>>> +=09addr =3D buffer - (char *)xs->pool->addrs;
>>> +
>>> +=09for (copied =3D 0, i =3D 0; copied < len; ++i) {
>>> +=09=09page =3D xs->pool->umem->pgs[addr >> PAGE_SHIFT];
>>> +
>>> +=09=09get_page(page);
>>> +
>>> +=09=09copy =3D min((u32)(PAGE_SIZE - offset), len - copied);
>>> +
>>> +=09=09skb_fill_page_desc(skb, i, page, offset, copy);
>>> +
>>> +=09=09copied +=3D copy;
>>> +=09=09addr +=3D copy;
>>> +=09=09offset =3D 0;
>>> +=09}
>>> +
>>> +=09skb->len +=3D len;
>>> +=09skb->data_len +=3D len;
>>> +=09skb->truesize +=3D len;
>>> +
>>> +=09refcount_add(len, &xs->sk.sk_wmem_alloc);
>>> +
>>> +=09return skb;
>>> +}
>>> +
>>> +static struct sk_buff *xsk_build_skb(struct xdp_sock *xs,
>>> +=09=09=09=09     struct xdp_desc *desc, int *err)
>>> +{
>>> +=09struct sk_buff *skb;
>>> +
>>> +=09if (xs->dev->features & NETIF_F_SKB_NO_LINEAR) {
>>> +=09=09skb =3D xsk_build_skb_zerocopy(xs, desc);
>>> +=09=09if (unlikely(!skb)) {
>>> +=09=09=09*err =3D -ENOMEM;
>>> +=09=09=09return NULL;
>>> +=09=09}
>>> +=09} else {
>>> +=09=09char *buffer;
>>> +=09=09u64 addr;
>>> +=09=09u32 len;
>>> +=09=09int err;
>>> +
>>> +=09=09len =3D desc->len;
>>> +=09=09skb =3D sock_alloc_send_skb(&xs->sk, len, 1, &err);
>>> +=09=09if (unlikely(!skb)) {
>>> +=09=09=09*err =3D -ENOMEM;
>>> +=09=09=09return NULL;
>>> +=09=09}
>>> +
>>> +=09=09skb_put(skb, len);
>>> +=09=09addr =3D desc->addr;
>>> +=09=09buffer =3D xsk_buff_raw_get_data(xs->pool, desc->addr);
>>> +=09=09err =3D skb_store_bits(skb, 0, buffer, len);
>>> +
>>> +=09=09if (unlikely(err)) {
>>> +=09=09=09kfree_skb(skb);
>>> +=09=09=09*err =3D -EINVAL;
>>> +=09=09=09return NULL;
>>> +=09=09}
>>> +=09}
>>> +
>>> +=09skb->dev =3D xs->dev;
>>> +=09skb->priority =3D xs->sk.sk_priority;
>>> +=09skb->mark =3D xs->sk.sk_mark;
>>> +=09skb_shinfo(skb)->destructor_arg =3D (void *)(long)desc->addr;
>>> +=09skb->destructor =3D xsk_destruct_skb;
>>> +
>>> +=09return skb;
>>> +}
>>> +
>>>  static int xsk_generic_xmit(struct sock *sk)
>>>  {
>>>  =09struct xdp_sock *xs =3D xdp_sk(sk);
>>> @@ -446,43 +535,28 @@ static int xsk_generic_xmit(struct sock *sk)
>>>  =09=09goto out;
>>> =20
>>>  =09while (xskq_cons_peek_desc(xs->tx, &desc, xs->pool)) {
>>> -=09=09char *buffer;
>>> -=09=09u64 addr;
>>> -=09=09u32 len;
>>> -
>>>  =09=09if (max_batch-- =3D=3D 0) {
>>>  =09=09=09err =3D -EAGAIN;
>>>  =09=09=09goto out;
>>>  =09=09}
>>> =20
>>> -=09=09len =3D desc.len;
>>> -=09=09skb =3D sock_alloc_send_skb(sk, len, 1, &err);
>>> +=09=09skb =3D xsk_build_skb(xs, &desc, &err);
>>>  =09=09if (unlikely(!skb))
>>>  =09=09=09goto out;
>>> =20
>>> -=09=09skb_put(skb, len);
>>> -=09=09addr =3D desc.addr;
>>> -=09=09buffer =3D xsk_buff_raw_get_data(xs->pool, addr);
>>> -=09=09err =3D skb_store_bits(skb, 0, buffer, len);
>>>  =09=09/* This is the backpressure mechanism for the Tx path.
>>>  =09=09 * Reserve space in the completion queue and only proceed
>>>  =09=09 * if there is space in it. This avoids having to implement
>>>  =09=09 * any buffering in the Tx path.
>>>  =09=09 */
>>>  =09=09spin_lock_irqsave(&xs->pool->cq_lock, flags);
>>> -=09=09if (unlikely(err) || xskq_prod_reserve(xs->pool->cq)) {
>>> +=09=09if (xskq_prod_reserve(xs->pool->cq)) {
>>>  =09=09=09spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
>>>  =09=09=09kfree_skb(skb);
>>>  =09=09=09goto out;
>>>  =09=09}
>>>  =09=09spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
>>> =20
>>> -=09=09skb->dev =3D xs->dev;
>>> -=09=09skb->priority =3D sk->sk_priority;
>>> -=09=09skb->mark =3D sk->sk_mark;
>>> -=09=09skb_shinfo(skb)->destructor_arg =3D (void *)(long)desc.addr;
>>> -=09=09skb->destructor =3D xsk_destruct_skb;
>>> -
>>>  =09=09err =3D __dev_direct_xmit(skb, xs->queue_id);
>>>  =09=09if  (err =3D=3D NETDEV_TX_BUSY) {
>>>  =09=09=09/* Tell user-space to retry the send */
>>>=20
>
> Al

Al

