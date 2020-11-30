Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCC022C7D95
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 05:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgK3Ekf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 23:40:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726188AbgK3Ekf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 23:40:35 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 066F9C0613CF
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 20:39:48 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id b6so9623236pfp.7
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 20:39:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GGfZ9OhByWYJexksVlxnbGN4bWqLwIl/DVeCK7Bkns0=;
        b=oovqn3eWT4UCpTkKFNJWAjRxG3LoAaTVqOKZnQWvFCpbTTWUU8wgrrAwXnkPfVgC4d
         DNp1ivZfDl84rZM5Ti57ZaT15+RANGSznxYJt47O28ZaxQlDdzpOvmmAmAbspaC4dQD3
         nu8+wWpOO69XC2HI6nG/V2TAJnmjSyrkrvPVvwNWrwIvrfmatWW31m2Zloxhrq5F4I04
         paUgn/4C0z0L1O0Nyf85FVqt8+yZXydgrU8+X/X2HfsVmmeoz0SXdiFDmETAzDDUQ58f
         IeGefEv9/S6CrJKN1Ugi3wcU5uxol+0vUoRzG+MsMU3ZxQHDI7wAWcG3QlUqjtSecYwM
         KmSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GGfZ9OhByWYJexksVlxnbGN4bWqLwIl/DVeCK7Bkns0=;
        b=aE3YEWX5likFxodwe8/tI6sBtzZObyg9okCqCXzH4RX8LsJGTJTpRxBXhKr+Esadwn
         URqSk5BDPxQBJXfp4ek5oc82yy7RGSM6uGlZB3vaefMBnp/2oOlaIMG1yzTp9PH1qIm9
         OWL7xmlUh6TsO/CSYBVUIdOCbPN44V+4erqFKz80IXdzltbQmtI6788COeib98lQEdUd
         fyrbd44FTzI19bW4zkzKRlPU+f3gsQssGOvMRA5hNZvMPXK8wr+LvoekxJTZt+v8zLkg
         bBP4KE+nCQGd+V4LgM8QAg4SOaErgP+Cf4nBn2Y1l3esybFnSeHAlx8YkhcfDxDP7Ca3
         vdxw==
X-Gm-Message-State: AOAM531iBXkLtOvaYa09F6VeN3gFywMSaRT1o6EU0LzFD4chD8zZSC3l
        zD3hj+fhmdniNZS5VQD7dy3eUg==
X-Google-Smtp-Source: ABdhPJy0BgbaRF599C6c3+ryCyqkdirNuKOUlmGgWebuZzO5FBNIjKc3jAmKvYndr2Mt+JbBMqoooQ==
X-Received: by 2002:a63:3e86:: with SMTP id l128mr16229713pga.114.1606711188433;
        Sun, 29 Nov 2020 20:39:48 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id g8sm14552500pgn.47.2020.11.29.20.39.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Nov 2020 20:39:48 -0800 (PST)
Date:   Sun, 29 Nov 2020 20:39:33 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <toshiaki.makita1@gmail.com>, <rkovhaev@gmail.com>
Subject: Re: [PATCH net] net: fix memory leak in register_netdevice() on
 error path
Message-ID: <20201129203933.623451fe@hermes.local>
In-Reply-To: <20201126132312.3593725-1-yangyingliang@huawei.com>
References: <20201126132312.3593725-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Nov 2020 21:23:12 +0800
Yang Yingliang <yangyingliang@huawei.com> wrote:

> I got a memleak report when doing fault-inject test:
> 
> unreferenced object 0xffff88810ace9000 (size 1024):
>   comm "ip", pid 4622, jiffies 4295457037 (age 43.378s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<00000000008abe41>] __kmalloc+0x10f/0x210
>     [<000000005d3533a6>] veth_dev_init+0x140/0x310
>     [<0000000088353c64>] register_netdevice+0x496/0x7a0
>     [<000000001324d322>] veth_newlink+0x40b/0x960
>     [<00000000d0799866>] __rtnl_newlink+0xd8c/0x1360
>     [<00000000d616040a>] rtnl_newlink+0x6b/0xa0
>     [<00000000e0a1600d>] rtnetlink_rcv_msg+0x3cc/0x9e0
>     [<000000009eeff98b>] netlink_rcv_skb+0x130/0x3a0
>     [<00000000500f8be1>] netlink_unicast+0x4da/0x700
>     [<00000000666c03b3>] netlink_sendmsg+0x7fe/0xcb0
>     [<0000000073b28103>] sock_sendmsg+0x143/0x180
>     [<00000000ad746a30>] ____sys_sendmsg+0x677/0x810
>     [<0000000087dd98e5>] ___sys_sendmsg+0x105/0x180
>     [<00000000028dd365>] __sys_sendmsg+0xf0/0x1c0
>     [<00000000a6bfbae6>] do_syscall_64+0x33/0x40
>     [<00000000e00521b4>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> It seems ifb and loopback may also hit the leak, so I try to fix this in
> register_netdevice().
> 
> In common case, priv_destructor() will be called in netdev_run_todo()
> after calling ndo_uninit() in rollback_registered(), on other error
> path in register_netdevice(), ndo_uninit() and priv_destructor() are
> called before register_netdevice() return, but in this case,
> priv_destructor() will never be called, then it causes memory leak,
> so we should call priv_destructor() here.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  net/core/dev.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 82dc6b48e45f..907204395b64 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -10000,6 +10000,17 @@ int register_netdevice(struct net_device *dev)
>  	ret = notifier_to_errno(ret);
>  	if (ret) {
>  		rollback_registered(dev);
> +		/*
> +		 * In common case, priv_destructor() will be
> +		 * called in netdev_run_todo() after calling
> +		 * ndo_uninit() in rollback_registered().
> +		 * But in this case, priv_destructor() will
> +		 * never be called, then it causes memory
> +		 * leak, so we should call priv_destructor()
> +		 * here.
> +		 */
> +		if (dev->priv_destructor)
> +			dev->priv_destructor(dev);

Are you sure this is safe?
Several devices have destructors that call free_netdev.
Up until now a common pattern for those devices was to call
free_netdev on error. After this change it would lead to double free.

