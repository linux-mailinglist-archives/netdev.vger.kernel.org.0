Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04107327401
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 20:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbhB1TMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 14:12:50 -0500
Received: from mail2.protonmail.ch ([185.70.40.22]:21549 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbhB1TMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 14:12:49 -0500
Date:   Sun, 28 Feb 2021 19:11:59 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1614539526; bh=EJrinQ67qB/LlA99cwn6B7uEjbgLffctlyIaZybzzxc=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=k85JS7L2Gtu7m2ha48NGFELCzYqGbtrsZn5B46hyhwTFgz5DFyG+BqE7kFdS5EkLu
         0Q8k1ZDByd5EPE/Nd4/lEFsbtbEADBNyRveTsDK/lA0oOZsQlTEKlbTMiR8CouchAy
         IrckDnzU4JaVSvAD0zT2XHgtULKgVxN+8cejkk0ElokK375hAoZz7uORgpr1zJU1+m
         U0PqCQX0KIJ0Dc1PFOubMylSPoSo7+AEWRK+yzG+ucVC5eexMsVD9+iJhmQwCWxCoH
         0S2b1eE4ezAIkUD5v56qcE0W+8ipDFEAXoshnU2AI/Ucd3kWikfvzaSJl4NdvG9WSW
         /ksfxqFt/XzmQ==
To:     Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Pavel Skripkin <paskripkin@gmail.com>, davem@davemloft.net,
        linmiaohe@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+80dccaee7c6630fa9dcf@syzkaller.appspotmail.com
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH v3] net/core/skbuff: fix passing wrong size to __alloc_skb
Message-ID: <20210228191150.10421-1-alobakin@pm.me>
In-Reply-To: <20210228105552.4f810700@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210227110306.13360-1-alobakin@pm.me> <20210227175114.28645-1-paskripkin@gmail.com> <20210228181440.1715-1-alobakin@pm.me> <20210228105552.4f810700@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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

From: Jakub Kicinski <kuba@kernel.org>
Date: Sun, 28 Feb 2021 10:55:52 -0800

> On Sun, 28 Feb 2021 18:14:46 +0000 Alexander Lobakin wrote:
> > > [1] WARNING in __alloc_pages_nodemask+0x5f8/0x730 mm/page_alloc.c:501=
4
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
> Right, IIUC Eric suggested we limit the length of the allocation
> to 64KB because that's the max reasonable skb length, and QRTR tun write
> results in generating a single skb. That seems like a good approach.

+1 for explicit capping max skb length to 64K.

Al

