Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAFD2327F12
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 14:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234958AbhCANKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 08:10:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235451AbhCANJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 08:09:47 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AEAEC06178B;
        Mon,  1 Mar 2021 05:09:06 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id e10so15849624wro.12;
        Mon, 01 Mar 2021 05:09:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eJc/Ox3dwGddddugy+b5PY/l1381V8CTFrszbDwmWyU=;
        b=NHOjTUKYxhiSXocYbNW26Sp0hznlCtyERG+dOXRRJVc6N/8XCOugMez9tVuSi7wM1r
         WHELzsVw8dwaeutrrdRsUvZ70YQXg1kRyI35M81T3XJSimYF7tgQzwhZOtMgnuqjZSFE
         Xs6In8q6Ufh4w0xIb8IWO8D6GmEWlw4kGhkV6g36vauuJCmYeh7B/c+ziQZ0wsprLrTv
         bffsKhihO3XRITHPpg1XYhxLwnKwIM7PM6+tpVoTKGMJcZx4qeN0/4hwD77bkRlryFKy
         XFFKyj1Obidb33vQGCs7y0Hd+bnx6JgKZWwjC/Izu1UH8J4QIhmWxMM2gAY+T03ffPEl
         1Otw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eJc/Ox3dwGddddugy+b5PY/l1381V8CTFrszbDwmWyU=;
        b=oCi3QDrW7BOY2bSJPKUj6OfwRzgCHkOcMjgtrgAZbrd+hrQElL0lWmHMZI6m8w8zis
         ETYlx25Yk1mFl8YOk4JND4NabdbulXHB5VAbD0brjpSv5T5egtoj65LZBsU6m7iY8Fhw
         cRjiFin11Xqxa1ee3QFJUEOhCCOJjukDN3jU2kXrtvDS/ps95M0ZcF828JW5l6Q2Au60
         9gV+Ql5vakHnj8Jdk9dIjrpdo8OBQpgVCcLNqChyYSJJm0RJJIEA+hqntWeN5tMZii5w
         pcFMuy0rQX2Z8I6P9V9vFaZ8dS+9N5lsM4QJMqIGQN6PfGPVRpNyZ29R7iaO7/k619le
         IIUg==
X-Gm-Message-State: AOAM531KC1oh3CMEuVY+inr6IgsR9ZJDYnpDp+sSmcngzFHkrTPXj7lL
        LAWcvz17j2ViEK7wQ0qWPwmFy5vvxcg=
X-Google-Smtp-Source: ABdhPJy/dQKVhMxgF6RNDwPqxztNN74G4JqIX6cPPQs1GBa1zqnk+O3KxZtCbwsPb5W2Lx3dsK7MxA==
X-Received: by 2002:a5d:6c66:: with SMTP id r6mr16651488wrz.407.1614604144925;
        Mon, 01 Mar 2021 05:09:04 -0800 (PST)
Received: from [192.168.1.101] ([37.167.146.167])
        by smtp.gmail.com with ESMTPSA id g11sm13133373wrw.89.2021.03.01.05.09.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Mar 2021 05:09:04 -0800 (PST)
Subject: Re: [PATCH] net/core/skbuff.c: __netdev_alloc_skb fix when len is
 greater than KMALLOC_MAX_SIZE
To:     Pavel Skripkin <paskripkin@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, linmiaohe@huawei.com,
        Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+80dccaee7c6630fa9dcf@syzkaller.appspotmail.com
References: <20210226191106.554553-1-paskripkin@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <24d966a7-ed2e-eb50-23e9-71ff2e43371f@gmail.com>
Date:   Mon, 1 Mar 2021 14:09:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210226191106.554553-1-paskripkin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/26/21 8:11 PM, Pavel Skripkin wrote:
> syzbot found WARNING in __alloc_pages_nodemask()[1] when order >= MAX_ORDER.
> It was caused by __netdev_alloc_skb(), which doesn't check len value after adding NET_SKB_PAD.
> Order will be >= MAX_ORDER and passed to __alloc_pages_nodemask() if size > KMALLOC_MAX_SIZE.
> 
> static void *kmalloc_large_node(size_t size, gfp_t flags, int node)
> {
> 	struct page *page;
> 	void *ptr = NULL;
> 	unsigned int order = get_order(size);
> ...
> 	page = alloc_pages_node(node, flags, order);
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
> @@ -443,6 +443,9 @@ struct sk_buff *__netdev_alloc_skb(struct net_device *dev, unsigned int len,
>  	if (len <= SKB_WITH_OVERHEAD(1024) ||
>  	    len > SKB_WITH_OVERHEAD(PAGE_SIZE) ||
>  	    (gfp_mask & (__GFP_DIRECT_RECLAIM | GFP_DMA))) {
> +		if (len > KMALLOC_MAX_SIZE)
> +			return NULL;
> +
>  		skb = __alloc_skb(len, gfp_mask, SKB_ALLOC_RX, NUMA_NO_NODE);
>  		if (!skb)
>  			goto skb_fail;
> 


No, please fix the offender instead.

Offender tentative fix was in 

commit 2a80c15812372e554474b1dba0b1d8e467af295d
Author: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Date:   Tue Feb 2 15:20:59 2021 +0600

    net/qrtr: restrict user-controlled length in qrtr_tun_write_iter()


qrtr maintainers have to tell us what is the maximum datagram length they need to support.



