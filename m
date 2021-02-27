Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBFE326CD9
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 12:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbhB0LEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Feb 2021 06:04:39 -0500
Received: from mail-40136.protonmail.ch ([185.70.40.136]:34256 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbhB0LET (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Feb 2021 06:04:19 -0500
Date:   Sat, 27 Feb 2021 11:03:22 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1614423811; bh=5hB+XutPE1XnNI9I1TLc/I4QbqoPv1i3U8XEVLrHtJc=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=fXUTQvH9RG6u0ndpoXPkLtOJS1V0jlHZwAjpMp2ribxS+zba4HrrwQfmfa3VVilqY
         t2KFo6IThyx5kDJrsmk4eeZHz0NUxEOrYASv3c2v2ie0AqyWZX/VdnsqesRXgIqrgE
         52mTkjwUGrKX93Biku+mPcBEnifr+4Zf8NDmR58NH4mBO3Zl/8Q8sEUPiAMlC17VF/
         KNZS3VBvcWUNuO+p1OLOyaDTiTuxjPCHUxBasIktVOEgmpPfBNI7kzO1c1g2UdGG1C
         xzFCiy1RqyVarvcefCf4dvt3i+DYU1w26HPp2HRUDGZZ20iD3WvqS/A54b6luDb6uw
         4cLTsCkyC83Cw==
To:     Pavel Skripkin <paskripkin@gmail.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>, davem@davemloft.net,
        kuba@kernel.org, linmiaohe@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+80dccaee7c6630fa9dcf@syzkaller.appspotmail.com
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH] net/core/skbuff.c: __netdev_alloc_skb fix when len is greater than KMALLOC_MAX_SIZE
Message-ID: <20210227110306.13360-1-alobakin@pm.me>
In-Reply-To: <20210226191106.554553-1-paskripkin@gmail.com>
References: <20210226191106.554553-1-paskripkin@gmail.com>
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
Date: Fri, 26 Feb 2021 22:11:06 +0300

Hi,

> syzbot found WARNING in __alloc_pages_nodemask()[1] when order >=3D MAX_O=
RDER.
> It was caused by __netdev_alloc_skb(), which doesn't check len value afte=
r adding NET_SKB_PAD.
> Order will be >=3D MAX_ORDER and passed to __alloc_pages_nodemask() if si=
ze > KMALLOC_MAX_SIZE.
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
>
> Reported-by: syzbot+80dccaee7c6630fa9dcf@syzkaller.appspotmail.com
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> Change-Id: I480a6d6f818a4c0a387db0cd3f230b68a7daeb16
> ---
>  net/core/skbuff.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 785daff48030..dc28c8f7bf5f 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -443,6 +443,9 @@ struct sk_buff *__netdev_alloc_skb(struct net_device =
*dev, unsigned int len,
>  =09if (len <=3D SKB_WITH_OVERHEAD(1024) ||
>  =09    len > SKB_WITH_OVERHEAD(PAGE_SIZE) ||
>  =09    (gfp_mask & (__GFP_DIRECT_RECLAIM | GFP_DMA))) {
> +=09=09if (len > KMALLOC_MAX_SIZE)
> +=09=09=09return NULL;

I'd use unlikely() for this as it's very very rare condition on the
very hot path.

Also, I'd add the same check below into __napi_alloc_skb() as it has
the same fallback.

>  =09=09skb =3D __alloc_skb(len, gfp_mask, SKB_ALLOC_RX, NUMA_NO_NODE);
>  =09=09if (!skb)
>  =09=09=09goto skb_fail;
> --
> 2.25.1

Thanks,
Al

