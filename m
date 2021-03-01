Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF16327FBF
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 14:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235860AbhCANlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 08:41:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235676AbhCANlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 08:41:19 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A20C061756;
        Mon,  1 Mar 2021 05:40:39 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id a17so19438036ljq.2;
        Mon, 01 Mar 2021 05:40:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tfPkTHeTaVvR1yZ2FfXg8gmr0JM9q50LxKJc1Ac2dQE=;
        b=PecNtnGblG27Yybc7mVkavx3/j9Q0qAn4P0EovQlbGaaBLtahgShK3UmyLX5d6pb3U
         i4LAjuomGgAJZa/I3YCAHykgSjpt++iel9mKXb4QIq4hymK5is1/KrQ6PW292cvkztiF
         TjP8pjJ3H9s4+v95xIJJ1ovjeYE5eoRhKXnQvuFiTseSHeroJdzlgBbLl627YSSH3ZrU
         JZBpiCr5N9CEr0RqIOBSqKwU7dQ9GxmTWqEl6aAobflvu+FZNznQJgdDQeMd/rYVRbu3
         ovXylYo1pXc3D5aNuFHlq8Nd517BKIIN6V34ITpwZfWiFhklhykVBepeqUYFay+HnZhp
         NyYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tfPkTHeTaVvR1yZ2FfXg8gmr0JM9q50LxKJc1Ac2dQE=;
        b=mOMHXH8L/xdHMI0RO0RMpx63Xx+qthDtEHRGWuAUKjc2C9GVarf1aeaVZ9FpVhjFnZ
         xkA55aBvEmNEYsTazpcvy94HEpKbIR+iPuN3IOpjZG01fW0a7R7Apul9NvpkId6TE5jX
         1uTT/dGjwD+cqOH3Df/saCCrxSmkeNHvSlqLMjiPzpqfUKUF6WXKNWwACyK1xFF5kF/u
         jxwE5Uz4IyKyUiHHOlE+JwEAbZy9CDGjRQYREzNYmUc+HBaxNSlJiBdNe3USoXyQfbsp
         yNJfb3Ihf9GRZzLkVCJ8JsEBulvtVYTT/UhA4LLpm9xeRdb1y6dKrMY9c+uo22GTb2Ra
         2I6g==
X-Gm-Message-State: AOAM530hLonFJ7srzLzA1wGImRwgiJeg0MiqZXH/UCNBIoN4jL1yitPW
        VteuqJhywoU7Tv1kgOoPhf0=
X-Google-Smtp-Source: ABdhPJy9PYq6Qagabf94XBUyJH6TuCeXLiP0AfPwRl3XcnEjhFpX1XCsZsJoHj+PhU2zMM0PnldndA==
X-Received: by 2002:a2e:8151:: with SMTP id t17mr8927655ljg.163.1614606037897;
        Mon, 01 Mar 2021 05:40:37 -0800 (PST)
Received: from amakushkin-VirtualBox ([46.61.204.60])
        by smtp.googlemail.com with ESMTPSA id h10sm2363229ljb.101.2021.03.01.05.40.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 01 Mar 2021 05:40:37 -0800 (PST)
Message-ID: <4d22ecbe776ada30c8f4b553204e2776fc0d48ac.camel@gmail.com>
Subject: Re: [PATCH] net/core/skbuff.c: __netdev_alloc_skb fix when len is
 greater than KMALLOC_MAX_SIZE
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, linmiaohe@huawei.com,
        Sabyrzhan Tasbolatov <snovitoll@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+80dccaee7c6630fa9dcf@syzkaller.appspotmail.com
Date:   Mon, 01 Mar 2021 16:40:36 +0300
In-Reply-To: <24d966a7-ed2e-eb50-23e9-71ff2e43371f@gmail.com>
References: <20210226191106.554553-1-paskripkin@gmail.com>
         <24d966a7-ed2e-eb50-23e9-71ff2e43371f@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, thanks for your reply!

On Mon, 2021-03-01 at 14:09 +0100, Eric Dumazet wrote:
> 
> On 2/26/21 8:11 PM, Pavel Skripkin wrote:
> > syzbot found WARNING in __alloc_pages_nodemask()[1] when order >=
> > MAX_ORDER.
> > It was caused by __netdev_alloc_skb(), which doesn't check len
> > value after adding NET_SKB_PAD.
> > Order will be >= MAX_ORDER and passed to __alloc_pages_nodemask()
> > if size > KMALLOC_MAX_SIZE.
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
> > 
> > Reported-by: syzbot+80dccaee7c6630fa9dcf@syzkaller.appspotmail.com
> > Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> > Change-Id: I480a6d6f818a4c0a387db0cd3f230b68a7daeb16
> > ---
> >  net/core/skbuff.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 785daff48030..dc28c8f7bf5f 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -443,6 +443,9 @@ struct sk_buff *__netdev_alloc_skb(struct
> > net_device *dev, unsigned int len,
> >  	if (len <= SKB_WITH_OVERHEAD(1024) ||
> >  	    len > SKB_WITH_OVERHEAD(PAGE_SIZE) ||
> >  	    (gfp_mask & (__GFP_DIRECT_RECLAIM | GFP_DMA))) {
> > +		if (len > KMALLOC_MAX_SIZE)
> > +			return NULL;
> > +
> >  		skb = __alloc_skb(len, gfp_mask, SKB_ALLOC_RX,
> > NUMA_NO_NODE);
> >  		if (!skb)
> >  			goto skb_fail;
> > 
> 
> 
> No, please fix the offender instead.

Yesterday I already send newer patch version to Alexander Lobakin,
where I added __GFP_NOWARN in qrtr_endpoint_post(). I think, You can
check it in this thread. 

> 
> Offender tentative fix was in 
> 
> commit 2a80c15812372e554474b1dba0b1d8e467af295d
> Author: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
> Date:   Tue Feb 2 15:20:59 2021 +0600
> 
>     net/qrtr: restrict user-controlled length in
> qrtr_tun_write_iter()
> 

This patch fixes kzalloc() call, but the warning was caused by
__netdev_alloc_skb().  

> 
> qrtr maintainers have to tell us what is the maximum datagram length
> they need to support.
> 
> 
> 
With regards,
Pavel Skripkin


