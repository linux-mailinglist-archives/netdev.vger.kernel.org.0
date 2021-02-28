Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50920327453
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 21:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbhB1ULH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 15:11:07 -0500
Received: from mail-40134.protonmail.ch ([185.70.40.134]:28838 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbhB1ULE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 15:11:04 -0500
Date:   Sun, 28 Feb 2021 20:10:17 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1614543020; bh=Ag77GPZFhp9P3u0v34MlsM/fenE+0ssu4ljL1jeWfV8=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=BUnEBSilp4FX1RQvEYfFBmdKNrDguWvoz84xF6WVZwlEx1ZBrtMxl6ZkK+JCrlTKw
         aCbacKFVW7aEEBWYwQeaZ7MwBeW7ptmT1r9UExkErMYN4MfqBAnJwUqi1SSAc8GvdC
         LvuVrY2YadjGImQYj0kXorZDU/gZAJqQrXmf3OATQVWr8C3WYia/geUVeOk5ZdXBJ0
         adQ//5PdPNQRzUuMe2BeSuXE7rNuWyL7TctOstPOz/whjB2mafi2dHwjkC8baO8RhL
         CS79f8XRc4B7DgCvQqiPY+3caC4nDjdHQm0Xvw91W2Ebv2/bEZjtg+qbqyn7kiLS5+
         N6fwydkaixOaQ==
To:     Pavel Skripkin <paskripkin@gmail.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>, davem@davemloft.net,
        linmiaohe@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+80dccaee7c6630fa9dcf@syzkaller.appspotmail.com
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH v3] net/core/skbuff: fix passing wrong size to __alloc_skb
Message-ID: <20210228201000.13606-1-alobakin@pm.me>
In-Reply-To: <47681a0b629ac0efb2ce0d92c3181db08e5ea3c8.camel@gmail.com>
References: <20210227110306.13360-1-alobakin@pm.me> <20210227175114.28645-1-paskripkin@gmail.com> <20210228181440.1715-1-alobakin@pm.me> <47681a0b629ac0efb2ce0d92c3181db08e5ea3c8.camel@gmail.com>
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

From: Pavel Skripkin <paskripkin@gmail.com>
Date: Sun, 28 Feb 2021 22:28:13 +0300

> Hi, thanks for reply!
>
> > From: Pavel Skripkin <paskripkin@gmail.com>
> > Date: Sat, 27 Feb 2021 20:51:14 +0300
> >
> > Hi,
> >
> > > syzbot found WARNING in __alloc_pages_nodemask()[1] when order >=3D
> > > MAX_ORDER.
> > > It was caused by __netdev_alloc_skb(), which doesn't check len
> > > value after adding NET_SKB_PAD.
> > > Order will be >=3D MAX_ORDER and passed to __alloc_pages_nodemask()
> > > if size > KMALLOC_MAX_SIZE.
> > > Same happens in __napi_alloc_skb.
> > >
> > > static void *kmalloc_large_node(size_t size, gfp_t flags, int node)
> > > {
> > > =09struct page *page;
> > > =09void *ptr =3D NULL;
> > > =09unsigned int order =3D get_order(size);
> > > ...
> > > =09page =3D alloc_pages_node(node, flags, order);
> > > ...
> > >
> > > [1] WARNING in __alloc_pages_nodemask+0x5f8/0x730
> > > mm/page_alloc.c:5014
> > > Call Trace:
> > >  __alloc_pages include/linux/gfp.h:511 [inline]
> > >  __alloc_pages_node include/linux/gfp.h:524 [inline]
> > >  alloc_pages_node include/linux/gfp.h:538 [inline]
> > >  kmalloc_large_node+0x60/0x110 mm/slub.c:3999
> > >  __kmalloc_node_track_caller+0x319/0x3f0 mm/slub.c:4496
> > >  __kmalloc_reserve net/core/skbuff.c:150 [inline]
> > >  __alloc_skb+0x4e4/0x5a0 net/core/skbuff.c:210
> > >  __netdev_alloc_skb+0x70/0x400 net/core/skbuff.c:446
> > >  netdev_alloc_skb include/linux/skbuff.h:2832 [inline]
> > >  qrtr_endpoint_post+0x84/0x11b0 net/qrtr/qrtr.c:442
> > >  qrtr_tun_write_iter+0x11f/0x1a0 net/qrtr/tun.c:98
> > >  call_write_iter include/linux/fs.h:1901 [inline]
> > >  new_sync_write+0x426/0x650 fs/read_write.c:518
> > >  vfs_write+0x791/0xa30 fs/read_write.c:605
> > >  ksys_write+0x12d/0x250 fs/read_write.c:658
> > >  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
> > >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >
> > Ah, by the way. Have you tried to seek for the root cause, why
> > a request for such insanely large (at least 4 Mib) skb happens
> > in QRTR? I don't believe it's intended to be like this.
> > Now I feel that silencing this error with early return isn't
> > really correct approach for this.
>
> Yeah, i figured it out. Syzbot provides reproducer for thig bug:
>
> void loop(void)
> {
>   intptr_t res =3D 0;
>   memcpy((void*)0x20000000, "/dev/qrtr-tun\000", 14);
>   res =3D syscall(__NR_openat, 0xffffffffffffff9cul, 0x20000000ul, 1ul,
> 0);
>   if (res !=3D -1)
>     r[0] =3D res;
>   memcpy((void*)0x20000040, "\x02", 1);
>   syscall(__NR_write, r[0], 0x20000040ul, 0x400000ul);
> }
>
> So, simply it writes to /dev/qrtr-tun 0x400000 bytes.
> In qrtr_tun_write_iter there is a check, that the length is smaller
> than KMALLOC_MAX_VSIZE. Then the length is passed to
> __netdev_alloc_skb, where it becomes more than KMALLOC_MAX_VSIZE.

I've checked the logics in qrtr_tun_write_iter(). Seems like it's
only trying to prevent kzallocs of sizes larger than the maximum
and doesn't care about netdev_alloc_skb() at all, as it ignores
the fact that, besides NET_SKB_PAD and NET_IP_ALIGN, skbs always
have SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) on top of
the "usable" size.

On the other hand, skb memory overheads, kmalloc bounds etc. are
an internal thing and all related corner cases should be handled
inside the implementations, not the users. From this point, even
this check for (len < KMALLOC_MAX_SIZE) is a bit bogus.
I think in that particular case with the size coming from userspace
(i.e. untrusted source), the allocations (both kzalloc() and
__netdev_alloc_skb()) should be performed with __GFP_NOWARN, so
insane values won't provoke any splats.

So maybe use it as a fix for this particular warning (seems like
it's the sole place in the entire kernel that can potentially
request such skb allocations) and don't add any branches into
hot *alloc_skb() at all?
We might add a cap for max skb length later, as Jakub pointed.

> >
> > > Reported-by: syzbot+80dccaee7c6630fa9dcf@syzkaller.appspotmail.com
> > > Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> > >
> > > ---
> > > Changes from v3:
> > > * Removed Change-Id and extra tabs in net/core/skbuff.c
> > >
> > > Changes from v2:
> > > * Added length check to __napi_alloc_skb
> > > * Added unlikely() in checks
> > >
> > > Change from v1:
> > > * Added length check to __netdev_alloc_skb
> > > ---
> > >  net/core/skbuff.c | 6 ++++++
> > >  1 file changed, 6 insertions(+)
> > >
> > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > index 785daff48030..ec7ba8728b61 100644
> > > --- a/net/core/skbuff.c
> > > +++ b/net/core/skbuff.c
> > > @@ -443,6 +443,9 @@ struct sk_buff *__netdev_alloc_skb(struct
> > > net_device *dev, unsigned int len,
> > >  =09if (len <=3D SKB_WITH_OVERHEAD(1024) ||
> > >  =09    len > SKB_WITH_OVERHEAD(PAGE_SIZE) ||
> > >  =09    (gfp_mask & (__GFP_DIRECT_RECLAIM | GFP_DMA))) {
> > > +=09=09if (unlikely(len > KMALLOC_MAX_SIZE))
> > > +=09=09=09return NULL;
> > > +
> > >  =09=09skb =3D __alloc_skb(len, gfp_mask, SKB_ALLOC_RX,
> > > NUMA_NO_NODE);
> > >  =09=09if (!skb)
> > >  =09=09=09goto skb_fail;
> > > @@ -517,6 +520,9 @@ struct sk_buff *__napi_alloc_skb(struct
> > > napi_struct *napi, unsigned int len,
> > >  =09if (len <=3D SKB_WITH_OVERHEAD(1024) ||
> > >  =09    len > SKB_WITH_OVERHEAD(PAGE_SIZE) ||
> > >  =09    (gfp_mask & (__GFP_DIRECT_RECLAIM | GFP_DMA))) {
> > > +=09=09if (unlikely(len > KMALLOC_MAX_SIZE))
> > > +=09=09=09return NULL;
> > > +
> > >  =09=09skb =3D __alloc_skb(len, gfp_mask, SKB_ALLOC_RX,
> > > NUMA_NO_NODE);
> > >  =09=09if (!skb)
> > >  =09=09=09goto skb_fail;
> > > --
> > > 2.25.1
> >
> > Thanks,
> > Al
> >
>
> With regards,
> Pavel Skripkin

Thanks,
Al

