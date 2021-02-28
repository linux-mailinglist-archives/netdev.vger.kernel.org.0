Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF0AD32741B
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 20:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbhB1T3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 14:29:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbhB1T25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 14:28:57 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61679C06174A;
        Sun, 28 Feb 2021 11:28:16 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id b1so11180733lfb.7;
        Sun, 28 Feb 2021 11:28:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=Adl6CK8nrXne88qZjWHiIGNkiXx3KmatImtubYveON0=;
        b=NIy12U1DZ+HecQB+s0dKuaQ8MY0WIQtPfCvN0jhQQi644mA6BgPphKx64u28+KsmOO
         Jr0swsC+egUsB+g9iXjxCBhuyAXdfKJoytyMoKlFdfQh16lzayvzksSCkMMfsr5vb9SB
         4ipzML/jdATQ8Vmtp8RHYBvANiaXZGAvIMJ8gGWxZsTeXvVNVm3e/WN8OfnTY5OTbQiP
         3zuBO+tOq0hLIa87gaeQnfaoyEOKVtVmnPbUxKrvjGhC4jh54+58HCBHxw580eBu/8Ca
         Ta6LVkZTrRbTlY4/h+MeYT25AHtfAO5yxmddvbK/6cvlOFI7MeG2lJ8zehXDp9ljYzPH
         RSoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Adl6CK8nrXne88qZjWHiIGNkiXx3KmatImtubYveON0=;
        b=tkKiGqnJJhpfAzmm5GZr2XNpjn1XiyzdJZLFqYE0dAtAvJcsiq8WUdPoBK2u+9ee6r
         9++ec4jmEY1dC5UjJkvwWg/0/Y6y/0p6T6UAlXK03X3CFok0xmkRPBkQ6zFNGfYLIYwc
         AqMmhNZLrgdYI0IvP74zDLeO4LF9mt4/a5z0EBnIY27B61C2IQkDhl5B4x+SrPACAiMF
         gqpM+z22j9GwDLit7iSnsEFL2TCvXugI84lhA3QgJ25bI3VzxHEc75DUEbxsETv0Q4RU
         Ps3CBoEEBNj4BctAJpvxyGp0RGp/hFFrKqbwb8BLBqbC+2oM9XrrzmyNaiZYxxu508dx
         0rzg==
X-Gm-Message-State: AOAM532yqhXm8iFmFuVnoaGfz/S1bEcJ7+MSbILg4RJaMtec43J0e6Yc
        i8gEFqcHm1wQuGtIVWQraB3wA/21fnzKBVpDre0=
X-Google-Smtp-Source: ABdhPJyeJ+bAyav9aNrEq2G3W2/X3qYzwOYIAtNWne6+ZAZ4Z0kBFqRSQ/kbNdKSWIMdoG352d+Jqg==
X-Received: by 2002:a19:c14a:: with SMTP id r71mr7355718lff.358.1614540494867;
        Sun, 28 Feb 2021 11:28:14 -0800 (PST)
Received: from pskrgag-home ([94.103.235.167])
        by smtp.gmail.com with ESMTPSA id a9sm2215955ljn.129.2021.02.28.11.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 11:28:14 -0800 (PST)
Message-ID: <47681a0b629ac0efb2ce0d92c3181db08e5ea3c8.camel@gmail.com>
Subject: Re: [PATCH v3] net/core/skbuff: fix passing wrong size to
 __alloc_skb
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     davem@davemloft.net, linmiaohe@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+80dccaee7c6630fa9dcf@syzkaller.appspotmail.com
Date:   Sun, 28 Feb 2021 22:28:13 +0300
In-Reply-To: <20210228181440.1715-1-alobakin@pm.me>
References: <20210227110306.13360-1-alobakin@pm.me>
         <20210227175114.28645-1-paskripkin@gmail.com>
         <20210228181440.1715-1-alobakin@pm.me>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, thanks for reply!

> From: Pavel Skripkin <paskripkin@gmail.com>
> Date: Sat, 27 Feb 2021 20:51:14 +0300
> 
> Hi,
> 
> > syzbot found WARNING in __alloc_pages_nodemask()[1] when order >=
> > MAX_ORDER.
> > It was caused by __netdev_alloc_skb(), which doesn't check len
> > value after adding NET_SKB_PAD.
> > Order will be >= MAX_ORDER and passed to __alloc_pages_nodemask()
> > if size > KMALLOC_MAX_SIZE.
> > Same happens in __napi_alloc_skb.
> > 
> > static void *kmalloc_large_node(size_t size, gfp_t flags, int node)
> > {
> > 	struct page *page;
> > 	void *ptr = NULL;
> > 	unsigned int order = get_order(size);
> > ...
> > 	page = alloc_pages_node(node, flags, order);
> > ...
> > 
> > [1] WARNING in __alloc_pages_nodemask+0x5f8/0x730
> > mm/page_alloc.c:5014
> > Call Trace:
> >  __alloc_pages include/linux/gfp.h:511 [inline]
> >  __alloc_pages_node include/linux/gfp.h:524 [inline]
> >  alloc_pages_node include/linux/gfp.h:538 [inline]
> >  kmalloc_large_node+0x60/0x110 mm/slub.c:3999
> >  __kmalloc_node_track_caller+0x319/0x3f0 mm/slub.c:4496
> >  __kmalloc_reserve net/core/skbuff.c:150 [inline]
> >  __alloc_skb+0x4e4/0x5a0 net/core/skbuff.c:210
> >  __netdev_alloc_skb+0x70/0x400 net/core/skbuff.c:446
> >  netdev_alloc_skb include/linux/skbuff.h:2832 [inline]
> >  qrtr_endpoint_post+0x84/0x11b0 net/qrtr/qrtr.c:442
> >  qrtr_tun_write_iter+0x11f/0x1a0 net/qrtr/tun.c:98
> >  call_write_iter include/linux/fs.h:1901 [inline]
> >  new_sync_write+0x426/0x650 fs/read_write.c:518
> >  vfs_write+0x791/0xa30 fs/read_write.c:605
> >  ksys_write+0x12d/0x250 fs/read_write.c:658
> >  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
> >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Ah, by the way. Have you tried to seek for the root cause, why
> a request for such insanely large (at least 4 Mib) skb happens
> in QRTR? I don't believe it's intended to be like this.
> Now I feel that silencing this error with early return isn't
> really correct approach for this.

Yeah, i figured it out. Syzbot provides reproducer for thig bug:

void loop(void)
{
  intptr_t res = 0;
  memcpy((void*)0x20000000, "/dev/qrtr-tun\000", 14);
  res = syscall(__NR_openat, 0xffffffffffffff9cul, 0x20000000ul, 1ul,
0);
  if (res != -1)
    r[0] = res;
  memcpy((void*)0x20000040, "\x02", 1);
  syscall(__NR_write, r[0], 0x20000040ul, 0x400000ul);
}

So, simply it writes to /dev/qrtr-tun 0x400000 bytes.
In qrtr_tun_write_iter there is a check, that the length is smaller
than KMALLOC_MAX_VSIZE. Then the length is passed to
__netdev_alloc_skb, where it becomes more than KMALLOC_MAX_VSIZE.

> 
> > Reported-by: syzbot+80dccaee7c6630fa9dcf@syzkaller.appspotmail.com
> > Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> > 
> > ---
> > Changes from v3:
> > * Removed Change-Id and extra tabs in net/core/skbuff.c
> > 
> > Changes from v2:
> > * Added length check to __napi_alloc_skb
> > * Added unlikely() in checks
> > 
> > Change from v1:
> > * Added length check to __netdev_alloc_skb
> > ---
> >  net/core/skbuff.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 785daff48030..ec7ba8728b61 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -443,6 +443,9 @@ struct sk_buff *__netdev_alloc_skb(struct
> > net_device *dev, unsigned int len,
> >  	if (len <= SKB_WITH_OVERHEAD(1024) ||
> >  	    len > SKB_WITH_OVERHEAD(PAGE_SIZE) ||
> >  	    (gfp_mask & (__GFP_DIRECT_RECLAIM | GFP_DMA))) {
> > +		if (unlikely(len > KMALLOC_MAX_SIZE))
> > +			return NULL;
> > +
> >  		skb = __alloc_skb(len, gfp_mask, SKB_ALLOC_RX,
> > NUMA_NO_NODE);
> >  		if (!skb)
> >  			goto skb_fail;
> > @@ -517,6 +520,9 @@ struct sk_buff *__napi_alloc_skb(struct
> > napi_struct *napi, unsigned int len,
> >  	if (len <= SKB_WITH_OVERHEAD(1024) ||
> >  	    len > SKB_WITH_OVERHEAD(PAGE_SIZE) ||
> >  	    (gfp_mask & (__GFP_DIRECT_RECLAIM | GFP_DMA))) {
> > +		if (unlikely(len > KMALLOC_MAX_SIZE))
> > +			return NULL;
> > +
> >  		skb = __alloc_skb(len, gfp_mask, SKB_ALLOC_RX,
> > NUMA_NO_NODE);
> >  		if (!skb)
> >  			goto skb_fail;
> > --
> > 2.25.1
> 
> Thanks,
> Al
> 

With regards,
Pavel Skripkin


