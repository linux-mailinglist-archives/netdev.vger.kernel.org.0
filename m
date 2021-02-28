Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 810F4327567
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 00:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbhB1Xxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 18:53:49 -0500
Received: from mail1.protonmail.ch ([185.70.40.18]:15481 "EHLO
        mail1.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbhB1Xxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 18:53:47 -0500
Date:   Sun, 28 Feb 2021 23:53:00 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1614556384; bh=TRcjtYNTHqIoRaiMvcr4BoQWcvivKK8cOyItux+4GXc=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=B0OXYtVkWlCsA9WkXXI0BXkHc9WYbCjPWZdaryZbVjaVJ6+NT+gA79oUs4JC1gXvv
         OsorXRv/1woDnGVBpCyGAinqulwoZfZE1S/zl8OoZa0tQBS129S0JjwYVpAF6J+cfR
         7aciILQ1VPGSwIWO03YgUe/ivmHyNgV+Tb/yL3eF4T4T6/S9BfsI0wIdwGFRW+c+T9
         K5l/TywCsn/oiuQ8mKdR3F0I+ZZtal2qs9rifxtMl/HXFN6MI8eQUwnZ2Dv2OzzSz7
         VQaNN552MdXeKF01qi/9loPjMEVem70NMDTPqiYfqyzQi2eWmHyBIblXS9YSkjVe9c
         Ba2M4q66oxVxA==
To:     Pavel Skripkin <paskripkin@gmail.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linmiaohe@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+80dccaee7c6630fa9dcf@syzkaller.appspotmail.com
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH v4] net/qrtr: fix __netdev_alloc_skb call
Message-ID: <20210228235235.121609-1-alobakin@pm.me>
In-Reply-To: <20210228232240.972205-1-paskripkin@gmail.com>
References: <20210228201000.13606-1-alobakin@pm.me> <20210228232240.972205-1-paskripkin@gmail.com>
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
Date: Mon, 1 Mar 2021 02:22:40 +0300

> syzbot found WARNING in __alloc_pages_nodemask()[1] when order >=3D MAX_O=
RDER.
> It was caused by a huge length value passed from userspace to qrtr_tun_wr=
ite_iter(),
> which tries to allocate skb. Since the value comes from the untrusted sou=
rce
> there is no need to raise a warning in __alloc_pages_nodemask().
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

Acked-by: Alexander Lobakin <alobakin@pm.me>

Thanks!

> ---
>  net/qrtr/qrtr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
> index b34358282f37..82d2eb8c21d1 100644
> --- a/net/qrtr/qrtr.c
> +++ b/net/qrtr/qrtr.c
> @@ -439,7 +439,7 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, cons=
t void *data, size_t len)
>  =09if (len =3D=3D 0 || len & 3)
>  =09=09return -EINVAL;
>
> -=09skb =3D netdev_alloc_skb(NULL, len);
> +=09skb =3D __netdev_alloc_skb(NULL, len, GFP_ATOMIC | __GFP_NOWARN);
>  =09if (!skb)
>  =09=09return -ENOMEM;
>
> --
> 2.25.1

Al

