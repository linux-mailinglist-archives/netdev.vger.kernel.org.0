Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D49653273C4
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 19:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbhB1SPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 13:15:34 -0500
Received: from mail-40133.protonmail.ch ([185.70.40.133]:46065 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbhB1SPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 13:15:32 -0500
Date:   Sun, 28 Feb 2021 18:14:46 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1614536089; bh=4UsadbncUKDixN62+Q12wn/JiwITckpiWa+Bs5jepEU=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=OpWJX8lrh6tsF8iJ1BCVD1QHGur+6IMsA3Z53xF08S/dmSqSdeoLDZFhhvNsKWOBP
         sp6r2LkgwvOsa56Jh9d7cEBLBWumQyscsqWNcxECQXt5LnJN3ecL9VRUddXUXclHTC
         ya+/nrMxMgAoxuUNVJhKIQjic2X8Hp+ay0t42PDmtI4fJwykbIHFzSK8IQYRjQB+M3
         13p1cF/KWwonMRoQnpiGdDuYacLJflq5RM6F8fBxXtN6tWFx3THL6Wtkff7ZmMFi0Y
         mYJilkPOW4C2hVim4DvZQFTACaxQglmR50D8lHv6fO3HZ+U2Z5UqlXudYvTMYeCykh
         dXoZndpIwWyLg==
To:     Pavel Skripkin <paskripkin@gmail.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>, davem@davemloft.net,
        linmiaohe@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+80dccaee7c6630fa9dcf@syzkaller.appspotmail.com
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH v3] net/core/skbuff: fix passing wrong size to __alloc_skb
Message-ID: <20210228181440.1715-1-alobakin@pm.me>
In-Reply-To: <20210227175114.28645-1-paskripkin@gmail.com>
References: <20210227110306.13360-1-alobakin@pm.me> <20210227175114.28645-1-paskripkin@gmail.com>
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
Date: Sat, 27 Feb 2021 20:51:14 +0300

Hi,

> syzbot found WARNING in __alloc_pages_nodemask()[1] when order >=3D MAX_O=
RDER.
> It was caused by __netdev_alloc_skb(), which doesn't check len value afte=
r adding NET_SKB_PAD.
> Order will be >=3D MAX_ORDER and passed to __alloc_pages_nodemask() if si=
ze > KMALLOC_MAX_SIZE.
> Same happens in __napi_alloc_skb.
>
> static void *kmalloc_large_node(size_t size, gfp_t flags, int node)
> {
> =09struct page *page;
> =09void *ptr =3D NULL;
> =09unsigned int order =3D get_order(size);
> ...
> =09page =3D alloc_pages_node(node, flags, order);
> ...
>
> [1] WARNING in __alloc_pages_nodemask+0x5f8/0x730 mm/page_alloc.c:5014
> Call Trace:
>  __alloc_pages include/linux/gfp.h:511 [inline]
>  __alloc_pages_node include/linux/gfp.h:524 [inline]
>  alloc_pages_node include/linux/gfp.h:538 [inline]
>  kmalloc_large_node+0x60/0x110 mm/slub.c:3999
>  __kmalloc_node_track_caller+0x319/0x3f0 mm/slub.c:4496
>  __kmalloc_reserve net/core/skbuff.c:150 [inline]
>  __alloc_skb+0x4e4/0x5a0 net/core/skbuff.c:210
>  __netdev_alloc_skb+0x70/0x400 net/core/skbuff.c:446
>  netdev_alloc_skb include/linux/skbuff.h:2832 [inline]
>  qrtr_endpoint_post+0x84/0x11b0 net/qrtr/qrtr.c:442
>  qrtr_tun_write_iter+0x11f/0x1a0 net/qrtr/tun.c:98
>  call_write_iter include/linux/fs.h:1901 [inline]
>  new_sync_write+0x426/0x650 fs/read_write.c:518
>  vfs_write+0x791/0xa30 fs/read_write.c:605
>  ksys_write+0x12d/0x250 fs/read_write.c:658
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Ah, by the way. Have you tried to seek for the root cause, why
a request for such insanely large (at least 4 Mib) skb happens
in QRTR? I don't believe it's intended to be like this.
Now I feel that silencing this error with early return isn't
really correct approach for this.

> Reported-by: syzbot+80dccaee7c6630fa9dcf@syzkaller.appspotmail.com
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
>
> ---
> Changes from v3:
> * Removed Change-Id and extra tabs in net/core/skbuff.c
>
> Changes from v2:
> * Added length check to __napi_alloc_skb
> * Added unlikely() in checks
>
> Change from v1:
> * Added length check to __netdev_alloc_skb
> ---
>  net/core/skbuff.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 785daff48030..ec7ba8728b61 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -443,6 +443,9 @@ struct sk_buff *__netdev_alloc_skb(struct net_device =
*dev, unsigned int len,
>  =09if (len <=3D SKB_WITH_OVERHEAD(1024) ||
>  =09    len > SKB_WITH_OVERHEAD(PAGE_SIZE) ||
>  =09    (gfp_mask & (__GFP_DIRECT_RECLAIM | GFP_DMA))) {
> +=09=09if (unlikely(len > KMALLOC_MAX_SIZE))
> +=09=09=09return NULL;
> +
>  =09=09skb =3D __alloc_skb(len, gfp_mask, SKB_ALLOC_RX, NUMA_NO_NODE);
>  =09=09if (!skb)
>  =09=09=09goto skb_fail;
> @@ -517,6 +520,9 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *=
napi, unsigned int len,
>  =09if (len <=3D SKB_WITH_OVERHEAD(1024) ||
>  =09    len > SKB_WITH_OVERHEAD(PAGE_SIZE) ||
>  =09    (gfp_mask & (__GFP_DIRECT_RECLAIM | GFP_DMA))) {
> +=09=09if (unlikely(len > KMALLOC_MAX_SIZE))
> +=09=09=09return NULL;
> +
>  =09=09skb =3D __alloc_skb(len, gfp_mask, SKB_ALLOC_RX, NUMA_NO_NODE);
>  =09=09if (!skb)
>  =09=09=09goto skb_fail;
> --
> 2.25.1

Thanks,
Al

